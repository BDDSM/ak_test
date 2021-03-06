﻿
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда //+++АК mika 2018.07.09 ИП-00019213
		Возврат;
	КонецЕсли;
	
	//+++АК mika 2018.02.07 ИП-00017859
	ПроверитьНаличиеСотрудника(ЭтотОбъект, Отказ);	
	//---АК mika ИП-00017859
	
	//+++АК mika 2018.07.09 ИП-00019213
	Если ЗначениеЗаполнено(ЭтотОбъект.ИД) Тогда
		ПроверитьВозможностьРедактированияНаименования(ЭтотОбъект, Отказ);
	КонецЕсли;
	//---АК mika 
	
	Если Отказ
			ИЛИ ЭтотОбъект.ПометкаУдаления Тогда
		Возврат
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.ИД) Тогда
		ЭтотОбъект.ИД = ОбщегоНазначенияСервер.ПолучитьНовыйУникальныйИдентификатор("СотрудникиАутсорсинг", "ИД");
	КонецЕсли;	
	
	//+++АК mika 2018.02.07 ИП-00017859
	//Дополнительное формирование кода, для связки "Внештатных сотрудников" и "ПерсоналККМ" в запросах
	Если НЕ ЗначениеЗаполнено(КодПерсоналККМ) Тогда	
		
		ТекущийИД = Формат(ЭтотОбъект.ИД, "ЧГ=");
		Для н = 1 по 10 - СтрДлина(ТекущийИД) Цикл
			ТекущийИД = "0" + ТекущийИД;
		КонецЦикла;
		
		КодПерсоналККМ = ТекущийИД;
		
	КонецЕсли;
	//---АК mika ИП-00017859
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда //+++АК mika 2018.07.09 ИП-00019213
		Возврат;
	КонецЕсли;

	Если Отказ
			ИЛИ ЭтотОбъект.ПометкаУдаления Тогда
		Возврат
	КонецЕсли;
	
	//+++АК mika 2018.02.07 ИП-00017859
	//Дополнительное формирование кода, для связки "Внештатных сотрудников" и "ПерсоналККМ" выполнялось ранее (перед записью)
	//ТекИД = Формат(ЭтотОбъект.ИД, "ЧГ=");
	//Для н = 1 по 10 - СтрДлина(ТекИД) Цикл
	//	ТекИД = "0" + ТекИД;
	//КонецЦикла;
	//ТекПерсоналККМ = Справочники.ПерсоналККМ.НайтиПоКоду(ТекИД);
	ТекПерсоналККМ = Справочники.ПерсоналККМ.НайтиПоКоду(КодПерсоналККМ);
	//---АК mika ИП-00017859

	Если ТекПерсоналККМ.Пустая() Тогда
		// создание нового элемента справочника "Персонал ККМ" с паролем, равным Ш-Коду, и кодом, равным ИД текущего сотрудника аутсорсинга
		Справочники.ПерсоналККМ.СинхронизироватьДанныеПерсонала(); 
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЭтотОбъект.ИД = 0;
	ЭтотОбъект.КодПерсоналККМ = 0; //+++АК mika 2018.04.17 ИП-00018378
	
КонецПроцедуры

// Проверяет наличие сотрутрудника по группе, наименованию, должности и дате рождения
//
// Параметры:
//   ТекущийСотрудник Тип.СправочникСсылка.СотрудникиАутсорсинг" - Сотрудник
//   Отказ Тип.Булево  
//
Процедура ПроверитьНаличиеСотрудника(ТекущийСотрудник, Отказ) Экспорт //+++АК mika 2018.02.07 ИП-00017859

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	СотрудникиАутсорсинг.Ссылка
	|ИЗ
	|	Справочник.СотрудникиАутсорсинг КАК СотрудникиАутсорсинг
	|ГДЕ
	|	СотрудникиАутсорсинг.Наименование = &Наименование
	|	И СотрудникиАутсорсинг.ГруппаСотрудников = &ГруппаСотрудников
	|	И СотрудникиАутсорсинг.Должность = &Должность
	|	И СотрудникиАутсорсинг.ДатаРождения = &ДатаРождения
	|	И СотрудникиАутсорсинг.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("ГруппаСотрудников", ТекущийСотрудник.ГруппаСотрудников);
	Запрос.УстановитьПараметр("ДатаРождения", ТекущийСотрудник.ДатаРождения);
	Запрос.УстановитьПараметр("Должность", ТекущийСотрудник.Должность);
	Запрос.УстановитьПараметр("Наименование", ТекущийСотрудник.Наименование);
	Запрос.УстановитьПараметр("Ссылка", ТекущийСотрудник.Ссылка);
	
	Если Не Запрос.Выполнить().Пустой() Тогда
				
		СтрокаСообщения = НСтр("ru = 'Группа: ГруппаСотрудников 
									  |Сотрудник: Наименование
									  |Дата рождения: ДатаРождения
									  |Должность: ДолжностьСотрудника 
									  |уже есть в базе!';");
		
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "Наименование", ТекущийСотрудник.Наименование);
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "ДатаРождения", Формат(ТекущийСотрудник.ДатаРождения, "ДФ=dd.MM.yyyy"));
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "ГруппаСотрудников", ТекущийСотрудник.ГруппаСотрудников);
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "ДолжностьСотрудника", ТекущийСотрудник.Должность);
		
		#Если НЕ ВнешнееСоединение Тогда
			Сообщить(СтрокаСообщения);
		#КонецЕсли
		
		Отказ = Истина;
		
	КонецЕсли;

КонецПроцедуры // ПроверитьНаличиеСотрудника()

// Проверяет возможность редактирования наименования(перименование)сотрудника //+++АК mika 2018.07.09 ИП-00019213 
//
// Параметры:
//   ТекущийСотрудник Тип.СправочникСсылка.СотрудникиАутсорсинг" - Сотрудник
//   Отказ Тип.Булево  
//
Процедура ПроверитьВозможностьРедактированияНаименования(ЭтотОбъект, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	СотрудникиАутсорсинг.Ссылка,
	|	СотрудникиАутсорсинг.Наименование,
	|	СотрудникиАутсорсинг.ГруппаСотрудников,
	|	СотрудникиАутсорсинг.Должность,
	|	СотрудникиАутсорсинг.ИД
	|ИЗ
	|	Справочник.СотрудникиАутсорсинг КАК СотрудникиАутсорсинг
	|ГДЕ
	|	СотрудникиАутсорсинг.Наименование <> &Наименование
	|	И СотрудникиАутсорсинг.Ссылка <> &Ссылка
	|	И СотрудникиАутсорсинг.ИД = &ИД";
	
	Запрос.УстановитьПараметр("ГруппаСотрудников", ГруппаСотрудников);
	Запрос.УстановитьПараметр("Наименование", ЭтотОбъект.Наименование);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ИД", ЭтотОбъект.ИД);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		СтрокаСообщения = НСтр("ru = 'Группа: ГруппаСотрудников 
									  |Сотрудник: Наименование
									  |Дата рождения: ДатаРождения
									  |Должность: ДолжностьСотрудника
									  |Ответственный: ТекущийПользователь';");
		
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "Наименование", ЭтотОбъект.Наименование);
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "ДатаРождения", Формат(ЭтотОбъект.ДатаРождения, "ДФ=dd.MM.yyyy"));
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "ГруппаСотрудников", ЭтотОбъект.ГруппаСотрудников);
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "ДолжностьСотрудника", ЭтотОбъект.Должность);
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "ТекущийПользователь", ПараметрыСеанса.ТекущийПользователь);
		
		#Если НЕ ВнешнееСоединение Тогда
			Сообщить(СтрЗаменить("Запрещено изменять ФИО, поскольку в базе присутствуют другие сотрудники с ID ИД! Обратитесть к администратору!", "ИД", ЭтотОбъект.ИД)+ Символы.ПС + Символы.ПС + СтрокаСообщения);
		#КонецЕсли
		
		Отказ = Истина;
		
	КонецЕсли;

КонецПроцедуры // ПроверитьВозможностьРедактированияНаименования()

