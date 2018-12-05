
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДатаНачала = Дата(3999, 1, 1);
	ДатаКонца = Дата(3999, 1, 1);
	Для Каждого ПользПоле Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
				И Строка(ПользПоле.Параметр) = "Период" Тогда
			ДатаНачала = ПользПоле.Значение.ДатаНачала;
			ДатаКонца = ПользПоле.Значение.ДатаОкончания;
			Прервать;
		КонецЕсли;	
	КонецЦикла;
	
	ТаблицаДанных = Новый ТаблицаЗначений();
	ТаблицаДанных.Колонки.Добавить("Дата");
	ТаблицаДанных.Колонки.Добавить("НомерМагазина");
	ТаблицаДанных.Колонки.Добавить("РабочееМесто");
	ТаблицаДанных.Колонки.Добавить("НомерZОтчета");
	ТаблицаДанных.Колонки.Добавить("СуммаПоЧекам");
	ТаблицаДанных.Колонки.Добавить("СуммаПоZОтчету");
	ТаблицаДанных.Колонки.Добавить("Разница");
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	ЗапросСкуль = "SELECT Cast(Ch.date as datetime) as date, Ch.ShopNo, Ch.CashID, Ch.ShiftID, Ch.Summ SummCh, ISNULL(Sh.summ, 0) SummSh, ABS(Ch.Summ - Sh.summ) Dif
					|FROM (SELECT Ch.ShiftID, Ch.ShopNo,
					|	  Cast(Ch.CloseDate as date) date
					|	  ,SUM(Ch.SummCash * CASE WHEN Ch.OperationType = 3 THEN -1 ELSE 1 END + Ch.SummBank)  as Summ
					|	  ,Ch.CashID
					|	  
					|	  
					|FROM [SMS_UNION].[dbo].[Checks] Ch (nolock)
                    |
					|  Where Ch.CloseDate >= " + ВнешниеДанные.ФорматПоля(ДатаНачала) + " and Ch.CloseDate <= " + ВнешниеДанные.ФорматПоля(КонецДня(ДатаКонца)) + " and Ch.OperationType > 0
					|  GROUP BY 
					|  Ch.ShiftID, Cast(Ch.CloseDate as date), Ch.CashID, Ch.ShopNo) as Ch
					|  INNER JOIN (SELECT [cashid] cashid
					|	  ,[shift_no] shiftid
					|	  ,Cast(shift_closedate as date) date
					|	  ,SUM([summ_shift]) as summ
					|	  
					|  FROM [SMS_REPL].[dbo].[Shifts] Sh (nolock)
					|  Where Sh.shift_closedate >= " + ВнешниеДанные.ФорматПоля(ДатаНачала) + " and Sh.shift_closedate <= " + ВнешниеДанные.ФорматПоля(КонецДня(ДатаКонца)) + "
					|  GROUP BY [cashid]
					|	  ,[shift_no]
					|	  , Cast(shift_closedate as date)) as Sh ON Ch.date = Sh.date and Ch.CashID = Sh.cashid and Ch.ShiftID = Sh.shiftid
					|  Where Ch.Summ <> Sh.summ";
								
	Попытка			
		Выборка = ADOСоединение.Execute(ЗапросСкуль);
		
		Если НЕ Выборка.EOF() Тогда
			Выборка.MoveFirst();
			Пока НЕ Выборка.EOF() Цикл
				СтрокаДоб = ТаблицаДанных.Добавить();
				СтрокаДоб.Дата = Выборка.Fields("date").Value;
				СтрокаДоб.НомерМагазина = Выборка.Fields("ShopNo").Value;
				СтрокаДоб.РабочееМесто = Выборка.Fields("CashID").Value;
				СтрокаДоб.НомерZОтчета = Выборка.Fields("ShiftID").Value;
				СтрокаДоб.СуммаПоЧекам = Выборка.Fields("SummCh").Value;
				СтрокаДоб.СуммаПоZОтчету = Выборка.Fields("SummSh").Value;
				СтрокаДоб.Разница = Выборка.Fields("Dif").Value;
				Выборка.MoveNext();
			КонецЦикла;	
		КонецЕсли;	
	Исключение
	КонецПопытки;
	
	ADOСоединение.Close();	
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТабДанные", ТаблицаДанных);
	
	//
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();

	// Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

	// Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);

	// Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);

	// Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры


//SELECT Ch.date, Ch.ShopNo, Ch.CashID, Ch.ShiftID, Ch.Summ SummCh, ISNULL(Sh.summ, 0) SummSh, ABS(Ch.Summ - Sh.summ) Dif
//FROM (SELECT Ch.ShiftID, Ch.ShopNo,
//	  Cast(Ch.CloseDate as date) date
//	  ,SUM(Ch.SummCash * CASE WHEN Ch.OperationType = 3 THEN -1 ELSE 1 END + Ch.SummBank)  as Summ
//	  ,Ch.CashID
//	  
//	  
//FROM [SMS_UNION].[dbo].[Checks] Ch (nolock)

//  Where Ch.CloseDate >= '2015-09-01T00:00:00' and Ch.CloseDate <= '2015-09-20T23:59:59' and Ch.OperationType > 0
//  GROUP BY 
//  Ch.ShiftID, Cast(Ch.CloseDate as date), Ch.CashID, Ch.ShopNo) as Ch
//  INNER JOIN (SELECT [cashid] cashid
//	  ,[shift_no] shiftid
//	  ,Cast(shift_closedate as date) date
//	  ,SUM([summ_shift]) as summ
//	  
//  FROM [SMS_REPL].[dbo].[Shifts] Sh (nolock)
//  Where Sh.shift_closedate >= '2015-09-01T00:00:00' and Sh.shift_closedate <= '2015-09-20T23:59:59'
//  GROUP BY [cashid]
//	  ,[shift_no]
//	  , Cast(shift_closedate as date)) as Sh ON Ch.date = Sh.date and Ch.CashID = Sh.cashid and Ch.ShiftID = Sh.shiftid
//  Where Ch.Summ <> Sh.summ
//  
//  order by ABS(Ch.Summ - Sh.summ)    