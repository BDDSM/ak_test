﻿
&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	//+++АК POZM 2018.07.25 ИП-00018310.01
	Если Источник = "KeyboardHook" И (Данные = "16606" ИЛИ Данные = "00122" ИЛИ Данные = " "  ИЛИ Данные = "32" ИЛИ Данные = "00032" ИЛИ Данные = "0032") Тогда //Сканер должен был посылать префикс F11, но настроить сканер смогли только на пробел
		
		
		ШтрихКодОбработанФормой = Истина;
		
		ШтрихКод = Неопределено;
		
		
		ОткрытьФорму("ОбщаяФорма.ФормаВводаШтрихкода",,,,,, Новый ОписаниеОповещения("ВнешнееСобытиеЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);		
	КонецЕсли;
	//---АК POZM 
КонецПроцедуры

//+++АК POZM 2018.07.25 ИП-00018310.01
&НаКлиенте
Процедура ВнешнееСобытиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ШтрихКод = Результат;
	
	Если НЕ ЗначениеЗаполнено(ШтрихКод) Тогда 
		Возврат; 
	КонецЕсли;
	
	ОбработатьШтрихкод(ШтрихКод);
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихКод(Команда)
	ШтрихКод = Неопределено;
	
	ОткрытьФорму("ОбщаяФорма.ФормаВводаШтрихкода",,,,,, Новый ОписаниеОповещения("ВвестиШтрихКодЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихКодЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ШтрихКод = Результат;
	Если ЗначениеЗаполнено(ШтрихКод) Тогда
		ОбработатьШтрихкод(ШтрихКод);	
	КонецЕсли;
	
КонецПроцедуры
//---АК POZM 
&НаСервере
Процедура ОбработатьШтрихкод(Штрихкод)
	//ШК = Штрихкод;
	Штрихкод = СокрЛП(Штрихкод);
	Пока ЗначениеЗаполнено(Штрихкод) И Найти("1234567890",Лев(Штрихкод,1)) = 0 Цикл
	
		Штрихкод = Сред(Штрихкод,2);
	
	КонецЦикла; 
	Если Лев(Штрихкод,2) = "19" Тогда
		Штрихкод = СокрЛП(Штрихкод);
		//"19"+Формат(Магазин.НомерТочки,"ЧЦ=4; ЧВН=; ЧГ=0")+Формат(Дата,"ДФ=ddMM")+Стр.КодПФ;
		
		НомерТочки = Сред(Штрихкод,3,4);
		
		Результат = Новый Структура("Магазин,Дата,ВидВложения",);
		Попытка
			СтрокиТочек = КэшТочек.НайтиСтроки(Новый Структура("НомерТочки",Число(НомерТочки)));
			Если СтрокиТочек.Количество()>0 Тогда
				Результат.Магазин = СтрокиТочек[0].Ссылка;
			Иначе
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = "Не найдена точка с номером "+НомерТочки;
				Сообщение.Сообщить();
			КонецЕсли;	
		Исключение
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Не удалось расшифровать номер точки "+НомерТочки;
			Сообщение.Сообщить();
		КонецПопытки;
		
		День = Сред(Штрихкод,7,2);
		Месяц = Сред(Штрихкод,9,2);
		ТекДата = ТекущаяДата();
		Попытка
			Результат.Дата = Дата(Год(ТекДата),Число(Месяц),Число(День));
		Исключение
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Не удалось найти дату в строке "+Штрихкод;
			Сообщение.Сообщить();
		КонецПопытки;
		
		
		КодПФ = Сред(Штрихкод,11);
		
		Попытка
			СтрокиВложений = КэшВложений.НайтиСтроки(Новый Структура("Код",КодПФ));
			Если СтрокиВложений.Количество()>0 Тогда
				Результат.ВидВложения = СтрокиВложений[0].Ссылка;
			Иначе
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = "Не найдено вида вложения с кодом "+КодПФ;
				Сообщение.Сообщить();
			КонецЕсли;	
		Исключение
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Не удалось расшифровать номер точки "+НомерТочки;
			Сообщение.Сообщить();
		КонецПопытки;
		
		НеДобавлять = Ложь;
		УжеЕсть = Объект.Вложения.НайтиСтроки(Результат);
		Если УжеЕсть.Количество()>0 Тогда
			НеДобавлять = Истина;
			Для Каждого СтрокаУжеЕсть ИЗ УжеЕсть Цикл
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = "Уже есть вложение с такими параметрами в этом документе ";
				
				//Сообщение.Поле = "Номенклатура[10].Количество";
				
				Сообщение.УстановитьДанные(СтрокаУжеЕсть);
				
				Сообщение.Сообщить();
			КонецЦикла;	
		КонецЕсли;	
		
		УжеЕсть = КэшПришедшихУжеПисем.НайтиСтроки(Результат);
		Если УжеЕсть.Количество()>0 Тогда
			НеДобавлять = Истина;
			Для Каждого СтрокаУжеЕсть ИЗ УжеЕсть Цикл
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = "Уже есть вложение с такими параметрами в документе "+СтрокаУжеЕсть.Ссылка+" в строке "+СтрокаУжеЕсть.НомерСтроки;
				
				//Сообщение.Поле = "Номенклатура[10].Количество";
				
				Сообщение.УстановитьДанные(СтрокаУжеЕсть.Ссылка);
				
				Сообщение.Сообщить();
			КонецЦикла;	
		КонецЕсли;
		Если Не НеДобавлять Тогда
			НС = Объект.Вложения.Добавить();
			ЗаполнитьЗначенияСвойств(НС,результат);
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//+++АК sils 08.06.2018 ИП-00018876
	ОперацияАпдекс = APDEX_ОценкаПроизводительностиКлиентСервер.ПолучитьОперацию("Открытие документа Реестр полученных конвертов");
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(ОперацияАпдекс);
	//---АК
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;	
	ТекстЗапроса="ВЫБРАТЬ
	|	ВидыВложенийВКонверты.Ссылка,
	|	ВидыВложенийВКонверты.Код,
	|	ВидыВложенийВКонверты.Наименование
	|ИЗ
	|	Справочник.ВидыВложенийВКонверты КАК ВидыВложенийВКонверты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.Ссылка,
	|	СтруктурныеЕдиницы.НомерТочки
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеестрПолученныхКонвертовВложения.Ссылка,
	|	РеестрПолученныхКонвертовВложения.НомерСтроки,
	|	РеестрПолученныхКонвертовВложения.ВидВложения,
	|	РеестрПолученныхКонвертовВложения.Дата,
	|	РеестрПолученныхКонвертовВложения.Магазин
	|ИЗ
	|	Документ.РеестрПолученныхКонвертов.Вложения КАК РеестрПолученныхКонвертовВложения
	|ГДЕ
	|	РеестрПолученныхКонвертовВложения.Ссылка <> &Ссылка
	|	И РеестрПолученныхКонвертовВложения.Ссылка.Дата >= &ДатаНачала";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка",Объект.Ссылка);
	Запрос.УстановитьПараметр("ДатаНачала",Объект.Дата - 7*60*60*24);
	Результат = Запрос.ВыполнитьПакет();
	ЗначениеВРеквизитФормы(Результат[0].Выгрузить(),"КэшВложений");
	ЗначениеВРеквизитФормы(Результат[1].Выгрузить(),"КэшТочек");
	ЗначениеВРеквизитФормы(Результат[2].Выгрузить(),"КэшПришедшихУжеПисем");
КонецПроцедуры

//+++АК POZM 2018.08.07 ИП-00018310.01
&НаКлиенте
Процедура ОбработкаШтрихкода()
	Если ШК = "" Тогда
		Возврат;
	Иначе
		ОбработатьШтрихкод(ШК);
		ШК = "";
		ЭтаФорма.ТекущийЭлемент = Элементы.ШК;
	КонецЕсли;	
КонецПроцедуры	
//---АК POZM 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("АвтосохранениеДокумента",10,Ложь);
	//+++АК POZM 2018.08.07 ИП-00018310.01
	ПодключитьОбработчикОжидания("ОбработкаШтрихкода",1,Ложь);
	//---АК POZM 
	//+++АК sils 08.06.2018 ИП-00018876
	APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(ОперацияАпдекс, ?(Параметры.Ключ.Пустая(), "Новый документ", "" + Объект.Ссылка));
	//---АК
КонецПроцедуры

&НаКлиенте
Процедура АвтосохранениеДокумента()
	Записать();
КонецПроцедуры	

//+++АК POZM 2018.07.25 ИП-00018310.01
&НаКлиенте
Процедура ОбработатьШК(Команда)
	ОбработатьШтрихкод(ШК);
КонецПроцедуры

//---АК POZM 