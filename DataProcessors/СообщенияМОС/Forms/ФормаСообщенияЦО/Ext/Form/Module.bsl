﻿&НаКлиенте
Процедура ПрочитаноПриИзменении(Элемент)
	
	Если Прочитано Тогда
		ВыводФормыОтвета = Ложь;
		
		Если ЗначениеЗаполнено(Элемент.Заголовок) Тогда
			ИмяФлажка = Элемент.Заголовок;
		Иначе
			ИмяФлажка = "Прочитано";
		КонецЕсли;
		
		Ответ1 = Вопрос("Вы действительно хотите установить признак """ + ИмяФлажка + """?", РежимДиалогаВопрос.ДаНет);
		Если Ответ1 = КодВозвратаДиалога.Нет Тогда
			Прочитано = Ложь;
			Возврат;
		КонецЕсли; 
		Если ТипСообщения = ПредопределенноеЗначение("Перечисление.ТипыСообщенийМОС.ИнформационноеСообщение") Тогда
			Ответ1 = Вопрос("Вызвать окно нового сообщения для ответа/комментария?", РежимДиалогаВопрос.ДаНет);
			Если Ответ1 = КодВозвратаДиалога.Да Тогда
				ВыводФормыОтвета = Истина;
			КонецЕсли;
		КонецЕсли;
		
		КодСотрудника = Формат(Объект.КодСотрудника, "ЧГ=0");
		Если ЗначениеЗаполнено(КодСотрудника) Тогда
			УстановитьПризнакПрочтения(ИД, КодСотрудника);
			ЭтаФорма.ВладелецФормы.ОбновитьДанные(Неопределено);
		КонецЕсли;
		
		Если ВыводФормыОтвета Тогда
			
			Если ЗначениеЗаполнено(ИДРод) Тогда
				ИДВФормуНС = ИДРод;
			Иначе
				ИДВФормуНС = ИД;
			КонецЕсли;
			
			
			
			ПФ1 = Новый Структура("РеквизитОбъект, ИДРод, РольОтправителя, РольПолучателя, КодНаправления, ТемаРод", Объект, ИДВФормуНС, РольОтправителя, РольПолучателя, КодНаправления, Тема);
			
			Если КодНаправления = 2 Тогда
				ПФ1.Вставить("КодМагазинаОтправителя", КодПодразделения);
			КонецЕсли;
			Форма1 = ПолучитьФорму("Обработка.СообщенияМОС.Форма.ФормаНовогоСообщенияЦО", ПФ1, ЭтаФорма);
			Форма1.Открыть();
		
		КонецЕсли;
		
	КонецЕсли;
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьЭлементыФормы()

	Если Прочитано Тогда
		Элементы.Прочитано.Доступность = Ложь;
	КонецЕсли;
	
	Элементы.Переадресовать.Видимость = Ложь;
	
	Если ТипСообщения = ПредопределенноеЗначение("Перечисление.ТипыСообщенийМОС.Инцидент") Тогда
		Элементы.ТекущийСтатус.Видимость = Истина;
		Элементы.ИзменениеСтатуса.Видимость = Истина;
		Элементы.Прочитано.Видимость = Ложь;
		Если СтатусИнцидента = 1 Тогда
			ТекущийСтатус = "Направлен";
			Элементы.ИзменениеСтатуса.Заголовок = "Принят к исполнению";
			Элементы.ОжидаемаяДатаВыполнения.Видимость = Истина;
			Элементы.Переадресовать.Видимость = Истина;
		ИначеЕсли СтатусИнцидента = 2 Тогда
			ТекущийСтатус = "Принят к исполнению";
			Элементы.ИзменениеСтатуса.Заголовок = "Выполнен";
		ИначеЕсли СтатусИнцидента = 3 Тогда
			ТекущийСтатус = "Выполнен";
			Элементы.ИзменениеСтатуса.Заголовок = "Выполнен";
			Элементы.ИзменениеСтатуса.ТолькоПросмотр = Истина;
			// посмотрим, если роль отправителя содержится в ролях тек. пользователя,
			// то сделаем флажок "Проверено"
			Эл1 = Объект.ВсеРолиПользователя.НайтиПоЗначению(РольОтправителя);
			Если Эл1 <> Неопределено Тогда
				Элементы.ИзменениеСтатуса.Заголовок = "Проверено";
				Элементы.ИзменениеСтатуса.ТолькоПросмотр = Ложь;
			КонецЕсли;
		ИначеЕсли СтатусИнцидента = 4 Тогда
			ТекущийСтатус = "Выполнен и проверен";
			Элементы.ИзменениеСтатуса.Видимость = Ложь;
		ИначеЕсли СтатусИнцидента = 5 Тогда
			ТекущийСтатус = "Переадресован";
			Элементы.ИзменениеСтатуса.Видимость = Ложь;
		Иначе
			ТекущийСтатус = "*";
			Элементы.ИзменениеСтатуса.Заголовок = "*";
			Элементы.ИзменениеСтатуса.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьПризнакПрочтения(ИД, КодСотрудника) Экспорт
	
	СоединениеСБДSQL = МеханизмОбменаСообщениямиПовтИсп.ПолучитьСоединениеСБДSQL("SMS_REPL");
	ТекстКомандыSQL = "UPDATE SMS_REPL.dbo.info_exch_messages SET Reader = " + КодСотрудника + ", ReadDateTime = '" + Строка(Обработки.СообщенияМОС.ПолучитьРабочуюДатуМОС()) + "' WHERE id = CAST('" + ИД + "' AS uniqueidentifier)"; 
	СоединениеСБДSQL.Execute(ТекстКомандыSQL);

КонецПроцедуры

Функция ЗаписатьНовыйСтатусИнцидента(НовыйСтатус) Экспорт
	
	СоединениеСБДSQL = МеханизмОбменаСообщениямиПовтИсп.ПолучитьСоединениеСБДSQL("SMS_REPL");
	КодСотрудника = Формат(Объект.КодСотрудника, "ЧГ=0");
	ТекстКомандыSQL = "UPDATE SMS_REPL.dbo.info_exch_messages SET ";
	Если НовыйСтатус = 2 Тогда
		ТекстКомандыSQL = ТекстКомандыSQL + " Status = 2, Acceptor = " + КодСотрудника + ", PlanDateTime = '" + Строка(ОжидаемаяДатаВыполнения) + "'";
	ИначеЕсли НовыйСтатус = 3 Тогда
		ТекстКомандыSQL = ТекстКомандыSQL + " Status = 3, Executor = " + КодСотрудника + ", EndDateTime = '" + Строка(Обработки.СообщенияМОС.ПолучитьРабочуюДатуМОС()) + "'";
	ИначеЕсли НовыйСтатус = 4 Тогда
		ТекстКомандыSQL = ТекстКомандыSQL + " Status = 4";
	КонецЕсли;
	ТекстКомандыSQL = ТекстКомандыSQL + " WHERE id = CAST('" + ИД + "' AS uniqueidentifier)";
	
	Попытка
		СоединениеСБДSQL.Execute(ТекстКомандыSQL);
		Возврат Истина;
	Исключение
		Возврат Ложь
	КонецПопытки;
	

КонецФункции


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КопироватьДанныеФормы(Параметры.РеквизитОбъект, Объект);
	
	//СО1 = Новый Структура;
	//СО1.Вставить("Идентификатор", Параметры.ИД);
	//МСС = Объект.Сообщения.НайтиСтроки(СО1);
	//Если МСС.Количество() = 0 Тогда
	//	Сообщить("Не найдена строка сообщения");
	//	Отказ = Истина;
	//	Возврат;
	//Иначе
	//	ТекДанные = МСС[0];
	//КонецЕсли;
	
	ТекДанные = ПолучитьСтрокуСообщения(Параметры.ИД);
	Если ТекДанные = Неопределено Тогда
		Сообщить("Не найдена строка сообщения");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ТекДанные);
	ИДРод = ТекДанные.ИдентификаторРодителя;
	ИД = ТекДанные.Идентификатор;
	
	Прочитано = ЗначениеЗаполнено(ТекДанные.ДатаИВремяПрочтения);
	
	Если ТипСообщения = Перечисления.ТипыСообщенийМОС.Инцидент Тогда
		Элементы.Прочитано.Заголовок = "Выполнено";
		Элементы.ТекстСообщения.Заголовок = "Действие";
	КонецЕсли;
	
	Если КодНаправления = 1 Тогда
		Элементы.Прочитано.Видимость = Ложь;
		// заполним получателей
		
		Для каждого СтрокаТЧПол Из Параметры.Получатели Цикл
			Если СтрокаТЧПол.ИДСообщения <> ИД Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаТЧ1 = Получатели.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧ1, СтрокаТЧПол);
			
			КодПодразделения = СтрокаТЧПол.КодПодразделенияПолучателя;
			СтрокаТЧ1.Магазин = Обработки.СообщенияМОС.ПолучитьНазваниеПодразделенияПоКоду(КодПодразделения);
		КонецЦикла;
		
		
	ИначеЕсли КодНаправления = 2 Тогда
		Элементы.Получатели.Видимость = Ложь;
	ИначеЕсли КодНаправления = 3 Тогда
		Элементы.Группа1.Видимость = Ложь;
	КонецЕсли;
	
	Заголовок = Заголовок + Обработки.СообщенияМОС.ПолучитьДобавкуКЗаголовкуОкна();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеСтатусаПриИзменении(Элемент)
	
	НовыйСтатус = 0;
	Если ИзменениеСтатуса Тогда
		Если СтатусИнцидента = 1 Тогда
			// проверим на заполненность дату и выведе
			Если НЕ ЗначениеЗаполнено(ОжидаемаяДатаВыполнения) Тогда
				Если НЕ ВвестиДату(ОжидаемаяДатаВыполнения, "Введите ожидаемую дату выполнения", ЧастиДаты.Дата) Тогда
					ИзменениеСтатуса = Ложь;
					Возврат;
				КонецЕсли;
			КонецЕсли;
			НовыйСтатус = 2;
		ИначеЕсли СтатусИнцидента = 2 Тогда
			НовыйСтатус = 3;
		ИначеЕсли СтатусИнцидента = 3 Тогда
			НовыйСтатус = 4;
		КонецЕсли; 
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НовыйСтатус) Тогда
		// запишем новый статус
		Если ЗаписатьНовыйСтатусИнцидента(НовыйСтатус) Тогда
			СтатусИнцидента = НовыйСтатус;
		КонецЕсли;
	КонецЕсли;
	
	Закрыть();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПереадресоватьИнцидент(Команда)
	
	Если ЗначениеЗаполнено(ИДРод) Тогда
		ИДВФормуПИ = ИДРод;
	Иначе
		ИДВФормуПИ = ИД;
	КонецЕсли;
	
	ПФ1 = Новый Структура("РеквизитОбъект, ИДРод, РольОтправителя, ТекстСообщения, ИД", Объект, ИДВФормуПИ, РольОтправителя, ТекстСообщения, ИД);
	Форма1 = ПолучитьФорму("Обработка.СообщенияМОС.Форма.ФормаПереадресации", ПФ1, ЭтаФорма);
	Форма1.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	//ТекДок1 = ПолучитьПечатнуюФорму();
	//Если ТекДок1 <> Неопределено Тогда
	//	ТекДок1.Показать();
	//КонецЕсли;
	
	ТабДок1 = ПолучитьПечатнуюФорму();
	Если ТабДок1 <> Неопределено Тогда
		//ТабДок1.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
		ТабДок1.Показать();
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПечатнуюФорму()

	ТекДанные = ПолучитьСтрокуСообщения(ИД);
	Если ТекДанные = Неопределено Тогда
		Сообщить("Не найдена строка сообщения");
		Возврат Неопределено;
	КонецЕсли;
	
	//СтрокаРез = "Дата и время создания сообщения: " + Строка(ТекДанные.ДатаИВремяСоздания)
	//		+ ". Автор: " + ТекДанные.Автор + Символы.ПС + "Тема: " + ТекДанные.Тема;
	//		
	//СтрокаРез = СтрокаРез + Символы.ПС + Символы.ПС + "Текст сообщения: " + Символы.ПС + ТекДанные.ТекстСообщения;
	//
	//ТекДок1 = Новый ТекстовыйДокумент;
	//ТекДок1.ДобавитьСтроку(СтрокаРез);
	//Возврат ТекДок1;
	
	Макет1 = Обработки.СообщенияМОС.ПолучитьМакет("ПечатнаяФорма1");
	Обл1 = Макет1.ПолучитьОбласть("Область1");
	Обл1.Параметры.Заполнить(ТекДанные);
	ТабДок = Новый ТабличныйДокумент();
	ТабДок.Вывести(Обл1);
	Возврат ТабДок;
		
КонецФункции // ()

Функция ПолучитьСтрокуСообщения(ИД)

	СО1 = Новый Структура;
	СО1.Вставить("Идентификатор", ИД);
	МСС = Объект.Сообщения.НайтиСтроки(СО1);
	Если МСС.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат МСС[0];
	КонецЕсли;

КонецФункции // ()

