
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;	
	КомпоновщикНастроек.ЗагрузитьНастройки(КомпоновщикНастроек.ПолучитьНастройки());
	ДатаС="";
	ДатаПо="";
	Для каждого Параметр из КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы Цикл
		Если СокрЛП(Параметр.Параметр)="ПериодОтчета" Тогда
			ДатаС = Параметр.Значение.ДатаНачала-5*24*60*60;
			ДатаПо = Параметр.Значение.ДатаОкончания+5*24*60*60;
			Прервать;
		КонецЕсли;
	КонецЦикла;	
	
	ТекстЗапросаКалендарь="ВЫБРАТЬ
	|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря КАК ДатаКалендаря,
	|	РегламентированныйПроизводственныйКалендарь.Год,
	|	РегламентированныйПроизводственныйКалендарь.ВидДня
	|ИЗ
	|	РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	|ГДЕ
	|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &ДатаС И &ДатаПо
	|	И (РегламентированныйПроизводственныйКалендарь.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
	|			ИЛИ РегламентированныйПроизводственныйКалендарь.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаКалендаря";
	ЗапросКалендарь=Новый Запрос(ТекстЗапросаКалендарь);
	ЗапросКалендарь.УстановитьПараметр("ДатаС",ДатаС);			 
	ЗапросКалендарь.УстановитьПараметр("ДатаПо",ДатаПо+15*24*60*60);// накинем 15 суток про запас
	Календарь=ЗапросКалендарь.Выполнить().Выгрузить();
	
	
	ВыборкаSQL = Новый ТаблицаЗначений;
	ВыборкаSQL.Колонки.Добавить("id_terminal");
	
	ВыборкаSQL.Колонки.Добавить("ДатаSQL");
	ВыборкаSQL.Колонки.Добавить("Дата");
	ВыборкаSQL.Колонки.Добавить("id_terminal_ch");
	ВыборкаSQL.Колонки.Добавить("СуммаВ_SQL");
	ВыборкаSQL.Колонки.Добавить("Сумма_ТранВ_SQL");
	ВыборкаSQL.Колонки.Добавить("id_org");
	ВыборкаSQL.Колонки.Добавить("schet");
	
	ВыборкаSQLПоЧекам = Новый ТаблицаЗначений;
	ВыборкаSQLПоЧекам.Колонки.Добавить("ДатаSQL");
	ВыборкаSQLПоЧекам.Колонки.Добавить("Дата");
	ВыборкаSQLПоЧекам.Колонки.Добавить("CashID");
	ВыборкаSQLПоЧекам.Колонки.Добавить("id_terminal");
	ВыборкаSQLПоЧекам.Колонки.Добавить("СуммаБезНалПоККМ");
	ВыборкаSQLПоЧекам.Колонки.Добавить("ВозвратБезНалПоККМ");
	
	
	
	ТекстЗапроса = "SELECT 
	|cast(SBER.date as datetime) as date,
	|SBER.id_org,
	|SBER.id_terminal,
	|SUM(SBER.summa) as summa,
	|SBER.schet,
	|SUM(SBER.Summa_tran) as Summa_tran
	|FROM [SMS_IZBENKA].[dbo].[terminal_prihod] as SBER (nolock) 
	|where SBER.date >= '"+Формат(ДатаС,"ДФ=yyyy-MM-dd")+"' and SBER.date < '"+Формат(КонецДня(ДатаПо)+1,"ДФ=yyyy-MM-dd")+"' 
	|GROUP BY cast(SBER.date as datetime), SBER.id_org, SBER.id_terminal, SBER.schet
	|
	|;
	//+++ АК pozm ИП-00016007
	|
	|SELECT Ch.ShopNo, Ch.CashID,
	|cast(cast(Ch.CloseDate as date)as datetime) as date,
	|			  SUM(CASE WHEN Ch.OperationType = 1 THEN Ch.BaseSum ELSE 0 END) as Summa,
	|			  SUM(CASE WHEN Ch.OperationType = 1 THEN Ch.SummBank ELSE 0 END) as Beznal,
	|			  SUM(CASE WHEN Ch.OperationType IN (3, 202, 203) THEN Ch.SummCash ELSE 0 END) as SummaVozvratNal,
	|			  SUM(CASE WHEN Ch.OperationType IN (3, 202, 203) THEN Ch.SummBank ELSE 0 END) as SummaVozvratBezNal,
	|			  SUM(CASE WHEN Ch.OperationType = 201 THEN Ch.SummCash WHEN Ch.OperationType = 211 THEN Ch.SummCash * -1 ELSE 0 END) as SummaVozvrat201Nal,
	|			  SUM(CASE WHEN Ch.OperationType = 201 THEN Ch.SummBank WHEN Ch.OperationType = 211 THEN Ch.SummBank * -1 ELSE 0 END) as SummaVozvrat201BezNal,
	|			  SUM(CASE WHEN Ch.OperationType IN (1, 3, 202, 203) THEN Ch.SummBonus ELSE 0 END) as SummaBallami,
	|              NULL as terminal_bank
	|			  
	|			FROM [SMS_IZBENKA].[dbo].[Checks] as Ch (nolock) 
	|			WHERE cast(Ch.CloseDate as date) >= '"+Формат(ДатаС,"ДФ=yyyy-MM-dd")+"' and cast(Ch.CloseDate as date) < '"+Формат(КонецДня(ДатаПо)+1,"ДФ=yyyy-MM-dd")+"'
	|			GROUP BY Ch.ShopNo, Ch.CashID, cast(Ch.CloseDate as date)
	| UNION ALL
	|
	|SELECT Ch.ShopNo, Ch.CashID,
	|cast(cast(Ch.CloseDate as date)as datetime) as date,
	|			  SUM(CASE WHEN Ch.OperationType = 1 THEN Ch.BaseSum ELSE 0 END) as Summa,
	|			  SUM(CASE WHEN Ch.OperationType = 1 THEN Ch.SummBank ELSE 0 END) as Beznal,
	|			  SUM(CASE WHEN Ch.OperationType IN (3, 202, 203) THEN Ch.SummCash ELSE 0 END) as SummaVozvratNal,
	|			  SUM(CASE WHEN Ch.OperationType IN (3, 202, 203) THEN Ch.SummBank ELSE 0 END) as SummaVozvratBezNal,
	|			  SUM(CASE WHEN Ch.OperationType = 201 THEN Ch.SummCash WHEN Ch.OperationType = 211 THEN Ch.SummCash * -1 ELSE 0 END) as SummaVozvrat201Nal,
	|			  SUM(CASE WHEN Ch.OperationType = 201 THEN Ch.SummBank WHEN Ch.OperationType = 211 THEN Ch.SummBank * -1 ELSE 0 END) as SummaVozvrat201BezNal,
	|			  SUM(CASE WHEN Ch.OperationType IN (1, 3, 202, 203) THEN Ch.SummBonus ELSE 0 END) as SummaBallami,
	|	        Ch.terminal_bank as terminal_bank
	|			  
	|			FROM [SMS_UNION].[dbo].[Checks] as Ch (nolock) 
	|			WHERE cast(Ch.CloseDate as date) >= '"+Формат(ДатаС,"ДФ=yyyy-MM-dd")+"' and cast(Ch.CloseDate as date) < '"+Формат(КонецДня(ДатаПо)+1,"ДФ=yyyy-MM-dd")+"'
	|			GROUP BY Ch.ShopNo, Ch.CashID, cast(Ch.CloseDate as date),Ch.terminal_bank";
	
	//--- АК pozm ИП-00016007

	
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
	попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			Стр = ВыборкаSQL.Добавить();
			Стр.ДатаSQL = Дата(rs.Fields("date").Value);
			Стр.id_terminal_ch = rs.Fields("id_terminal").Value;
			
			Стр.СуммаВ_SQL = Число(rs.Fields("summa").Value);
			Стр.Сумма_ТранВ_SQL = Число(rs.Fields("Summa_tran").Value);
			
			Стр.id_terminal = Формат(Стр.id_terminal_ch,"ЧГ=0");
			
			Стр.СуммаВ_SQL = Окр(Стр.СуммаВ_SQL,2);
			Стр.Сумма_ТранВ_SQL = Окр(Стр.Сумма_ТранВ_SQL,2);
			
			Стр.schet = rs.Fields("schet").Value;
			Стр.id_org = rs.Fields("id_org").Value;
			
			ТекДата = НачалоДня(Стр.ДатаSQL);
			День = Календарь.Найти(ТекДата);
			й = 0; // если вдруг календарь не заполнен
			Пока День = Неопределено И й < 30 Цикл
				й = й + 1 ;
				ТекДата = КонецДня(ТекДата) + 1;
				День = Календарь.Найти(ТекДата);
			КонецЦикла;	
			Стр.Дата = ТекДата;
			rs.MoveNext();
		КонецЦикла;
	Исключение
		
	КонецПопытки;	
	
	//+++ АК pozm ИП-00016007
	rs = rs.NextRecordSet();
	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			Стр = ВыборкаSQLПоЧекам.Добавить();
			Стр.ДатаSQL = Дата(rs.Fields("date").Value);
			ТекДата = КонецДня(Стр.ДатаSQL)+1;
			День = Календарь.Найти(ТекДата);
			й = 0; // если вдруг календарь не заполнен
			Пока День = Неопределено И й < 30 Цикл
				й = й + 1 ;
				ТекДата = КонецДня(ТекДата) + 1;
				День = Календарь.Найти(ТекДата);
			КонецЦикла;	
			Стр.Дата = ТекДата;
				
			Стр.CashID = rs.Fields("CashID").Value;
			Стр.id_terminal = rs.Fields("terminal_bank").Value;
			Стр.СуммаБезНалПоККМ = Число(rs.Fields("Beznal").Value);
			Стр.ВозвратБезНалПоККМ = -Число(rs.Fields("SummaVozvratBezNal").Value) - Число(rs.Fields("SummaVozvrat201BezNal").Value);
			
			rs.MoveNext();
		КонецЦикла;	
	Исключение
		
	КонецПопытки;	
		
	//--- АК pozm ИП-00016007
	
	
	ADOСоединение.Close();
		
	//	//Получаем схему из макета
	//СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	//Из схемы возьмем настройки по умолчанию
	Настройки = КомпоновщикНастроек.Настройки;
	
	//Помещаем в переменную данные о расшифровке данных
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
	Настройки, ДанныеРасшифровки);
	
	ВнешниеНаборыДанных=Новый Структура;
	
	ВнешниеНаборыДанных.Вставить("ВыборкаSQL",ВыборкаSQL);
	//+++ АК pozm ИП-00016007
	ВнешниеНаборыДанных.Вставить("ВыборкаSQLПоЧекам",ВыборкаSQLПоЧекам);
	//--- АК pozm ИП-00016007
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,ВнешниеНаборыДанных,
	ДанныеРасшифровки);
	
	//Очищаем поле табличного документа
	
	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	
	
КонецПроцедуры
