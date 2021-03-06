﻿
&НаСервере
Процедура База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения = "")  
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры, СтрокаПодключения);
	Попытка
		RecordSet.Close();
	Исключение
	КонецПопытки;	
		
КонецПроцедуры


&НаСервере
Функция База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения = "")  
	
	Попытка
		Command = Новый COMОбъект("ADODB.Command");
		
		Если ТипЗнч(допПараметры) = Тип("Структура") Тогда
			ЗаполнитьЗначенияСвойств(Command, допПараметры);
		КонецЕсли;
		
		CurrentConnection = База_Подключение(СтрокаПодключения);
		Command.ActiveConnection 	= CurrentConnection;
		Command.CommandTimeout 		= 0;
		Command.CommandText 		= ТекстЗапроса;
		
		RecordSet = Новый COMОбъект("ADODB.RecordSet");
		RecordSet = Command.Execute(); //Выполнение и получение набора данных
		
		Возврат RecordSet;
		
	Исключение	
		
		ВызватьИсключение ОписаниеОшибки();
		
	КонецПопытки;
	
КонецФункции

&НаСервере
Функция База_Подключение(СтрокаПодключения) Экспорт	
	
	Попытка
		
		CurrentConnection = Новый COMОбъект("ADODB.Connection");
		Catalog = Новый COMОбъект("ADOX.Catalog");			
		
		Catalog.ActiveConnection = СтрокаПодключения;
		CurrentConnection.Open(СтрокаПодключения);
		
		Возврат CurrentConnection;	
		
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();		
		#Если НаКлиенте тогда
		Сообщить(ОписаниеОшибки);			
		#КонецЕсли		
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

// На основе результата запроса (База_ВыполнитьЗапрос) создаем таблицу значений!!
&НаСервере
Функция База_РезульататЗапросВТаблицуЗначений(RecordSet) 
	
	тз = Новый ТаблицаЗначений;
	Если ТипЗнч(RecordSet) <> Тип("COMОбъект") Тогда
		Возврат тз;
	КонецЕсли;
	
	// Инициализируем колонки
	Для НомерКолонки = 0 По RecordSet.Fields.Count - 1 Цикл
		NameFiled = RecordSet.Fields.Item(НомерКолонки).Name;
		NameFiled = СтрЗаменить(NameFiled, "$", "_");
		тз.Колонки.Добавить(NameFiled,, RecordSet.Fields.Item(НомерКолонки).Name, 15);
	КонецЦикла;
	
	// Перебор данных
	Если НЕ RecordSet.EOF() Тогда
		RecordSet.MoveFirst();                 
		Пока RecordSet.EOF() = 0 Цикл
			СтрокаТаблицыЗначений = тз.Добавить();
			Для НомерКолонки = 0 По RecordSet.Fields.Count - 1 Цикл
				СтрокаТаблицыЗначений[НомерКолонки] = RecordSet.Fields(RecordSet.Fields.Item(НомерКолонки).Name).Value;
			КонецЦикла;
			RecordSet.MoveNext();  
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТЗ;
	
КонецФункции

// Закрываем датасет возвращаемй База_ВыполнитьЗапрос();
//
&НаСервере
Процедура База_ЗакрытьЗапрос(RecordSet) 
	
	Если ТипЗнч(RecordSet) = Тип("COMОбъект") Тогда
		RecordSet.Close();
	КонецЕсли;
	
КонецПроцедуры


//////////////////////////////////////////////////////////////////
&НаКлиенте
Процедура КнОтправить(Команда)
	
	Предупреждение(КнОтправитьНаСервере());	
	 
КонецПроцедуры

&НаСервере
Функция КнОтправитьНаСервере()
	
	СтрокаВозврата = "";
	
	Если СтрДлина(Формат(Телефон, "ЧГ=0")) <> 10
			ИЛИ СокрЛП(СообщениеSMS) = "" Тогда
		СтрокаВозврата = "Проверьте ещё раз формат номера телефона!";	
	Иначе	
		ТекстЗапроса =
		"Insert into SMSGate..Incoming
		|      (Date,
		|      nomer,
		|      text,
		|      Time,
		|      source)
		|select convert(datetime, CONVERT(date, getdate())) , 
		|/**BPar1**/'~~~~~'/**FPar**/ ,
		|/**BPar2**/'^^^^^'/**FPar**/ ,
		|CONVERT(time(7), getdate())  , 10 ;";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~", Формат(Телефон, "ЧГ=0"));
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "^^^^^", СообщениеSMS);
		
		СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "SMSGate");
		База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса,, СтрокаПодключения);
		СтрокаВозврата = "Сообщение отправлено.";
	КонецЕсли;

	Возврат СтрокаВозврата;
	
КонецФункции

&НаСервере
Функция ТолькоЦифры(лкСтр) Экспорт 
	
	лкСтрПроверки = "1234567890";
	ДлинаСтр = СтрДлина(лкСтр);
	
	НеТлькоЦифры = Истина;
	
	Для i = 1 По ДлинаСтр Цикл
		
		ТекСимвол = Сред(лкСтр, i, i);
		Если НЕ Найти(лкСтрПроверки, ТекСимвол) Тогда
			НеТлькоЦифры = Ложь;
			Прервать;
		КонецЕсли;	
		i = i + 1;
	КонецЦикла;	
	
	Возврат НеТлькоЦифры;
	
КонецФункции	

&НаКлиенте
Процедура ПосмотретьСписокЗагрузки(Команда)
	
	 ПосмотретьСписокЗагрузкиНаСервере();
	
КонецПроцедуры


&НаСервере
Процедура ПосмотретьСписокЗагрузкиНаСервере()
	
	ТекстЗапроса =
	"SELECT [card_number]
	|  ,[anketa_id]
	|  ,[familia]
	|  ,[user_ca]
	|  ,[time_ca]
	|  ,[type_import]
	|FROM [Loyalty].[dbo].[Card_anketa]
	|ORDER BY [time_ca] DESC;";
 
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса,, СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();	
		
	Табл = Новый ТабличныйДокумент;
	Макет = ПолучитьОбщийМакет(Метаданные.ОбщиеМакеты.АК_ПечатьТаблицЗначений);
	
	ОбластьЗаголовок 		= Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапкаОсновной	= Макет.ПолучитьОбласть("Шапка|Основной");
	ОбластьСтрокаОсновной	= Макет.ПолучитьОбласть("Строка|Основной");
	ОбластьИтогОсновной		= Макет.ПолучитьОбласть("Итог|Основной");
	ОбластьШапкаДОП			= Макет.ПолучитьОбласть("Шапка|Показатели");
	ОбластьСтрокаДОП		= Макет.ПолучитьОбласть("Строка|Показатели");
	ОбластьИтогДОП			= Макет.ПолучитьОбласть("Итог|Показатели");
	
	
	ОбластьЗаголовок.Параметры.Заголовок = "Список загрузки";
	Табл.Вывести(ОбластьЗаголовок);
	
	Табл.Вывести(ОбластьШапкаОсновной);
	
	Для Каждого Колонка из Тз.Колонки ЦИКЛ
		ОбластьШапкаДОП.Параметры.ИмяПоказателя = Колонка.Имя;
		Табл.Присоединить(ОбластьШапкаДОП);
	КонецЦикла;
	
	счетчик = 0;
	Для каждого стр Из Тз Цикл
		счетчик = счетчик + 1;
		ОбластьСтрокаОсновной.Параметры.счетчик = счетчик; 
		Табл.Вывести(ОбластьСтрокаОсновной);
		Для Каждого Колонка из Тз.Колонки ЦИКЛ
			ОбластьСтрокаДОП.Параметры.ЗначениеКолонки = Формат(стр[Колонка.Имя], "ЧДЦ=2; ЧН=0,00; ЧГ=0");
			Табл.Присоединить(ОбластьСтрокаДОП);
		КонецЦикла;
	КонецЦикла;
	
	//Табл.Вывести(ОбластьИтогОсновной);
	
	//Для Каждого Колонка из Тз.Колонки ЦИКЛ
	//	ОбластьИтогДОП.Параметры.Итог=Формат(Тз.Итог(Колонка.Имя),"ЧДЦ=2; ЧН=0,00; ЧГ=0");
	//	Табл.Присоединить(ОбластьИтогДОП);
	//КонецЦикла;
	
	
	//Табл.Защита = Истина;
	//Табл.ОтображатьЗаголовки = Ложь;
	Табл.ОтображатьСетку = Ложь;
		
	Табл.Показать("Список загрузки");
	
КонецПроцедуры

&НаКлиенте
Процедура НеРаспознанныеСМС(Команда)
	
	Форма = ПолучитьФорму("Обработка.АК_НеобработанныеСМС.Форма.ФормаСписка");
	Форма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатыОбработкиЗапросаНаПривязкуЧека(Команда)
	
	Форма = ПолучитьФорму("Обработка.РезультатыОбработкиЗапросовНаПривязкуЧека.Форма.ФормаСписка");
	Форма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СМС_БезПоложительногоОтвета(Команда)
	
	Форма = ПолучитьФорму("Обработка.СМС_БезПоложительногоОтвета.Форма.ФормаСписка");
	Форма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныСМСДляОтветаПокупателю(Команда)
	
	Форма = ПолучитьФорму("Обработка.ШаблоныСМС_ДляОтветаПокупателю.Форма.Форма");
	Форма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Статистика(Команда)
	
	Форма = ПолучитьФорму("Отчет.Статистика.Форма.ФормаОтчета");
	Форма.Открыть();
	
КонецПроцедуры

Процедура ТТПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.ТТ) Тогда
		
		Телефон = Объект.ТТ.ТелефонныйНомер1;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТТПриИзменении(Элемент)
	
	ТТПриИзмененииНаСервере();
	
КонецПроцедуры
