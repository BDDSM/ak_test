Перем СтрокаПодключенияТелеграм;


&НаСервере
Процедура ПолучитьНаСервере()
	
	Начало = Формат(НачалоДня(Период.ДатаНачала), "ДФ='yyyyMMdd HH:mm:ss'");
	Конец = Формат(КонецДня(Период.ДатаОкончания), "ДФ='yyyyMMdd HH:mm:ss'");
	
	Если ЗначениеЗаполнено(Период) Тогда
	
		ТекстЗапроса = 
			"SELECT user_id as id, received_date as date, message_text as message, isNULL(Email, 0) as number
			|FROM [Telegram].[dbo].[inbox_telegram] LEFT JOIN
			|	Loyalty.dbo.Customer ON Telegram.dbo.inbox_telegram.user_id = Loyalty.dbo.Customer.telegram_id
			|WHERE answer = 100 and received_date >= '" + Начало + "' and received_date <= '" + Конец + "'
			|ORDER BY received_date desc";
			
	Иначе
			
		ТекстЗапроса = 
			"SELECT user_id as id, received_date as date, message_text as message, isNULL(Email, 0) as number
			|FROM [Telegram].[dbo].[inbox_telegram] LEFT JOIN
			|	Loyalty.dbo.Customer ON Telegram.dbo.inbox_telegram.user_id = Loyalty.dbo.Customer.telegram_id
			|WHERE answer = 100
			|ORDER BY received_date desc";			
			
	КонецЕсли;
		
	Попытка
		Результат = База_ВыполнитьЗапрос(ТекстЗапроса,,СтрокаПодключенияТелеграм);	
		ТЗ = База_РезультатЗапросВТаблицуЗначений(Результат);
		Табл.Очистить();
		Для каждого Стр Из ТЗ Цикл	
			НоваяСтрока = Табл.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Стр);
		КонецЦикла;  
	Исключение
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

//
Функция База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения = "", CursorLocation=2) Экспорт
	
	СтрокаПодключения = ?(СтрокаПодключения = "", СтрокаПодключенияТелеграм, СтрокаПодключения);
	
	Попытка
		Command = Новый COMОбъект("ADODB.Command");
		Если ТипЗнч(допПараметры) = Тип("Структура") тогда
			ЗаполнитьЗначенияСвойств(Command, допПараметры);
		КонецЕсли;			
		CurrentConnection = База_Подключение(СтрокаПодключения);
		
		//
		CurrentConnection.CursorLocation = CursorLocation;
		//
		
		Command.ActiveConnection = CurrentConnection;
		Command.CommandTimeout = 0;
		Command.CommandText = ТекстЗапроса;
		RecordSet = Новый COMОбъект("ADODB.RecordSet");
		//
		//RecordSet.CursorLocation = CursorLocation;
		//RecordSet.CursorType = 2;
		//
		RecordSet = Command.Execute(); //Выполнение и получение набора данных
		Возврат RecordSet;
	Исключение	
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;	
	
КонецФункции

//
Функция База_Подключение(СтрокаПодключения) экспорт	
	
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

//
Функция База_РезультатЗапросВТаблицуЗначений(RecordSet) Экспорт
	
	тз = Новый ТаблицаЗначений;
	Если ТипЗнч(RecordSet) <> Тип("COMОбъект") тогда
		Возврат тз;
	КонецЕсли;
	
	// Инициализируем колонки
	Для НомерКолонки = 0 По RecordSet.Fields.Count-1 Цикл
		NameFiled = RecordSet.Fields.Item(НомерКолонки).Name;
		NameFiled = СтрЗаменить(NameFiled,"$","_");
		тз.Колонки.Добавить(NameFiled,,RecordSet.Fields.Item(НомерКолонки).Name, 15);
	КонецЦикла;
	
	// Перебор данных
	Если НЕ RecordSet.EOF() Тогда
		RecordSet.MoveFirst();   
		Пока RecordSet.EOF() = 0 Цикл
			СтрокаТаблицыЗначений = тз.Добавить();
			Для НомерКолонки = 0 По RecordSet.Fields.Count-1 Цикл
				СтрокаТаблицыЗначений[НомерКолонки] = RecordSet.Fields(RecordSet.Fields.Item(НомерКолонки).Name).Value;
			КонецЦикла;
			RecordSet.MoveNext();  
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТЗ;
КонецФункции

&НаКлиенте
Процедура Получить(Команда)
	ПолучитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ТаблВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Попытка	
		НомерКарты = Элемент.ТекущиеДанные.number;
		Если Не ЗначениеЗаполнено(НомерКарты) Тогда Возврат КонецЕсли;
	Исключение	
		Возврат;
	КонецПопытки;
	
	СтруктураПараметровФормы = Новый Структура;
	СтруктураПараметровФормы.Вставить("Email", НомерКарты);	
	ОткрытьФорму("Обработка.ОтчетыПоКартам.Форма.КарточкаКлиента", СтруктураПараметровФормы);		
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПолучитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Период = Новый СтандартныйПериод(ВариантСтандартногоПериода.Сегодня);
КонецПроцедуры

СтрокаПодключенияТелеграм = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql03", "Telegram");