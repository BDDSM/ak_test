Функция ПолучитьФормуРасшифровки() Экспорт 
	
	Возврат ЭтотОбъект.ПолучитьФорму("ФормаРасшифровки");	
		
КонецФункции

&НаСервере
Функция СведенияОВнешнейОбработке() Экспорт
    ПараметрыРегистрации = Новый Структура;
    //МассивНазначений = Новый Массив;
    //МассивНазначений.Добавить("Документ.РеализацияТоваровУслуг");
    
    ПараметрыРегистрации.Вставить("Вид", "ДополнительнаяОбработка");
    //ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
    ПараметрыРегистрации.Вставить("Наименование", "Загрузка эквайринг");
    ПараметрыРегистрации.Вставить("Версия", "1.0");
    ПараметрыРегистрации.Вставить("БезопасныйРежим", ложь);
    ПараметрыРегистрации.Вставить("Информация", "Загрузка эквайринг");
    Возврат ПараметрыРегистрации;

КонецФункции

Функция ПолучитьТаблицуЧековSQL(ДатаЧек) Экспорт
	
		
	ТекстЗапроса = "SELECT   Ch.CashID, Ch.ShopNo,  Ch.CashID, Ch.CashCheckNo, Ch.CloseDate,
	|			Ch.BaseSum, Ch.Discount, Ch.BONUSCARD, Ch.SummCash, Ch.SummBank, Ch.SummBonus, Ch.OperationType, 
	|			NULL as terminal_bank
	|			  
	|			FROM [SMS_IZBENKA].[dbo].[Checks] as Ch (nolock) 
	|			WHERE cast(Ch.CloseDate as date) >= '"+Формат(ДатаЧек,"ДФ=yyyy-MM-dd")+"' and cast(Ch.CloseDate as date) <= '"+Формат(ДатаЧек,"ДФ=yyyy-MM-dd")+"'	
	|	
	| UNION ALL
	|
	|				SELECT  Ch.CashID, Ch.ShopNo, Ch.CashID, Ch.CashCheckNo, Ch.CloseDate,
	|			Ch.BaseSum, Ch.Discount, Ch.BONUSCARD, Ch.SummCash, Ch.SummBank, Ch.SummBonus, Ch.OperationType,
	|			 Ch.terminal_bank
	|			  
	|			FROM [SMS_UNION].[dbo].[Checks] as Ch (nolock) 
	|			WHERE cast(Ch.CloseDate as date) >= '"+Формат(ДатаЧек,"ДФ=yyyy-MM-dd")+"' and cast(Ch.CloseDate as date) <= '"+Формат(ДатаЧек,"ДФ=yyyy-MM-dd")+"'";
	

	//Ch.LoadDateTime, Ch.HistoryLineNo, Ch.OperationTypeOrig	
	
	СтрСоединенияДанныеТовародвижение = ОбменСAccess.ПолучитьСтрокуСоединения("sms_izbenka");
	
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	ADOСоединение.ConnectionString  = СтрСоединенияДанныеТовародвижение;
	ADOСоединение.Open();
	
	
	rs = ADOСоединение.Execute(ТекстЗапроса);
	Пока rs <> Неопределено И rs.Fields.Count <= 0 Цикл
		rs = rs.NextRecordSet();
	КонецЦикла;
	
	
	ВыборкаSQLПоЧекам = Новый ТаблицаЗначений;
	ВыборкаSQLПоЧекам.Колонки.Добавить("CashID");
	ВыборкаSQLПоЧекам.Колонки.Добавить("ShopNo");
	ВыборкаSQLПоЧекам.Колонки.Добавить("CloseDate");	
	ВыборкаSQLПоЧекам.Колонки.Добавить("BaseSum");
	ВыборкаSQLПоЧекам.Колонки.Добавить("CashCheckNo");
	ВыборкаSQLПоЧекам.Колонки.Добавить("SummBank");
	ВыборкаSQLПоЧекам.Колонки.Добавить("terminal_bank");
			
	попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			Стр = ВыборкаSQLПоЧекам.Добавить();
			Стр.CashID = rs.Fields("CashID").Value;
			Стр.ShopNo = rs.Fields("ShopNo").Value;
			Стр.CloseDate = Дата(rs.Fields("CloseDate").Value);			
			Стр.CashCheckNo = rs.Fields("CashCheckNo").Value;
			Стр.BaseSum = rs.Fields("BaseSum").Value;
			Стр.terminal_bank = rs.Fields("terminal_bank").Value;
			Стр.SummBank   =  rs.Fields("SummBank").Value;
			Если Стр.CashID > 100000 Тогда
				Стр.ТерминалID = Стр.ShopNo*10+1;
			Иначе 	
				Стр.ТерминалID = Стр.CashID;
			КонецЕсли;	
			rs.MoveNext();
		КонецЦикла;
	Исключение
		Возврат	 ВыборкаSQLПоЧекам;
	КонецПопытки;	
	
	Возврат ВыборкаSQLПоЧекам;
	
КонецФункции