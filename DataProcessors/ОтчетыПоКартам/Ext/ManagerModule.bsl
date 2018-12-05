
Функция НачислитьБаллыНаКарту(НомерКарты, ПричинаНачисления = Неопределено, КолвоБаллов = 0, ЦельНачисления, НомерЧека = "", СуммаЧека = 0) Экспорт
	
	Если СтрДлина(НомерКарты) = 7 Тогда
		
		СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
		
		Если ПричинаНачисления = Перечисления.АК_ПричиныНачисленияБаллов.АнкетаНаСайте50руб Тогда			
			показат_ = 1;
			a_d_ = 50;			
		ИначеЕсли ПричинаНачисления = Перечисления.АК_ПричиныНачисленияБаллов.АкцияКупонНаКарту100руб Тогда 
			показат_ = 2;
			a_d_ = 100;
		ИначеЕсли ПричинаНачисления = Перечисления.АК_ПричиныНачисленияБаллов.НачислитьПоЧеку ИЛИ ПричинаНачисления = Перечисления.АК_ПричиныНачисленияБаллов.Доставка Тогда			
			Если СокрЛП(НомерЧека) = "" Тогда
				Возврат "Не указан номер чека. Начисление баллов не возможно!";
			КонецЕсли;	
			показат_ = НомерЧека;
			a_d_ = Формат(СуммаЧека, "ЧРД=.; ЧГ=");
		Иначе
			Если КолвоБаллов <> 0 Тогда
				показат_ = 1;
				a_d_ = КолвоБаллов;
			Иначе	
				показат_ = 0;
				a_d_ = 0;
			КонецЕсли;	
		КонецЕсли;
		
		лкТекДата = ТекущаяДата(); 
				
		// Бонус_add
		ТекстЗапроса = "INSERT INTO [dbo].[Card_new] ([card_nomer], [user_add], [time], [type_add], [amount], [descr]) VALUES (" + "'"+НомерКарты+"','"+ ПараметрыСеанса.ТекущийПользователь+"','"+ лкТекДата+"',"+показат_+","+ a_d_+",'"+СокрЛП(ЦельНачисления)+"') ;";
		
		База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, Неопределено, СтрокаПодключения);
		
		//ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение("10.0.0.40", "izbenka", "cjyzcjyz");
		//ADOСоединение.Execute(ТекстЗапроса);	
		//ADOСоединение.Close();
		
		
		ТекстЗапроса = "exec loyalty.dbo.add_Card_new_to_TH";
		//// Бонус_add_loyalty
		//ТекстЗапроса = "select
		//|NEWID() TransactionHistoryUID,
		//|2 TransactionType,
		//|Propert.[time]
		//|,0 ChequeAmount
		//|,Propert.DiscountCardUID
		//|,Propert.AccountUID
		//|,Ind.IndicatorUID
		//|,amount
		//|,0 FinalBalance
		//|,-1  IsCommited
		//|,-888 ShopNo
		//|,NEWID() ChequeUID
		//|,1 changed
		//|into #ch
		//|FROM ( Select DiscountCard.*, Card_new.amount, Card_new.[time] from (SELECT " + "'"+НомерКарты+"' [card_nomer], '"+ лкТекДата+"' [time], "+ a_d_+" [amount]) Card_new
		//|inner join DiscountCard
		//|on convert(int,DiscountCard.Number)=convert(int,Card_new.card_nomer)  ) Propert
		//|  INNER JOIN Account ON Propert.AccountUID = Account.AccountUID
		//|      INNER JOIN (Select * from Indicator where Indicatortype=0) Ind ON Account.AccountUID = Ind.AccountUID
		//|
		//|left join (
		//|  SELECT DiscountCardUID,1 as kk, [Time]  FROM TransactionHistory WHERE TransactionHistory.TransactionType=2) Начисл
		//|  on Propert.DiscountCardUID=Начисл.DiscountCardUID and Propert.[time]=Начисл.[time]
		//|where
		//| ISNULL(Начисл.kk,0)=0  
		//|
		//|insert into TransactionHistory (
		//|       [TransactionHistoryUID]
		//|      ,[TransactionType]
		//|      ,[Time]
		//|      ,[ChequeAmount]
		//|      ,[DiscountCardUID]
		//|      ,[AccountUID]
		//|      ,[IndicatorUID]
		//|      ,[BonusValue]
		//|      ,[FinalBalance]
		//|      ,[IsCommited]
		//|      ,shopno
		//|      ,[ChequeUID]
		//|      ,[changed] ) 
		//|select * from #ch
		//|      
		//|insert into [Loyalty].[dbo].[TransactionHistory]
		//|       ([TransactionHistoryUID] ,[TransactionType] ,[Time] ,[ChequeAmount] ,[DiscountCardUID]
		//|      ,[AccountUID] ,[IndicatorUID] ,[BonusValue] ,[FinalBalance] ,[PromotionProgramUID] ,[IsCommited]
		//|      ,[RegenerationUID] ,[ShopNo] ,[ChequeUID],[Changed])
		//| SELECT newid() ,1 ,th.[Time], th.[BonusValue] ,th.[DiscountCardUID]
		//|      ,th.[AccountUID] ,i.[IndicatorUID]  ,0 ,0 ,null ,th.[IsCommited],
		//|      th.[RegenerationUID]  ,th.[ShopNo] ,th.[ChequeUID],1
		//|  FROM  [Loyalty].[dbo].[TransactionHistory] (nolock) th
		//|  inner join [Loyalty].[dbo].Indicator i on i.AccountUID=th.AccountUID
		//|  inner join #ch on #ch.TransactionHistoryUID=th.TransactionHistoryUID
		//|  where i.IndicatorType=1
		//| drop table #ch;";

		База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, Неопределено, СтрокаПодключения);
		
		//ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение("10.0.0.40", "izbenka", "cjyzcjyz");
		//ADOСоединение.Execute(ТекстЗапроса);	
		//ADOСоединение.Close();
		
	Иначе
		Возврат "Номер карты должен содержать 7 цифр!";
	КонецЕсли;
	
	Возврат "Обработка завершена.";
	
КонецФункции

Функция НачислитьБонусыПоЧеку(CheckUID, ЦельНачисления, КолвоБаллов, СтрокаРезультат) Экспорт
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	ТекстЗапросаSQL =
		"DECLARE @return_value int,
		|@message varchar(1000)
		|
		|EXEC @return_value = [SMS_REPL].[dbo].[Charge_Bonus_By_Check]
		|@CheckUID = '" + CheckUID + "',
		|@BonusValue = " + ВнешниеДанные.ФорматПоля(КолвоБаллов) + ",
		|@descr = '" + СокрЛП(ЦельНачисления) + "',
		|@user = '" + СокрЛП(ПараметрыСеанса.ТекущийПользователь) + "',
		|@message = @message OUTPUT
		|
		|SELECT @message as N'@message'";
		//|
		//|SELECT 'Return Value' = @return_value";
	
	//База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапросаSQL, Неопределено, СтрокаПодключения);
	//
	//ТекстЗапросаSQL =
	//	"DECLARE @message varchar(1000)
	//	|
	//	|SELECT @message as N'@message'";
	//
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапросаSQL, Неопределено, СтрокаПодключения);
	
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet, Ложь);
	СтрокаРезультат = ТЗ[0].message;
	RecordSet.Close();
	
КонецФункции

Процедура База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения)  
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры, СтрокаПодключения);
	//тзРезультат = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	Попытка
		RecordSet.Close();
	Исключение
	КонецПопытки;
		
КонецПроцедуры

Функция База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения = "")  
	Попытка
		Command = Новый COMОбъект("ADODB.Command");
		
		Если ТипЗнч(допПараметры) = Тип("Структура") тогда
			ЗаполнитьЗначенияСвойств(Command, допПараметры);
		КонецЕсли;			
		CurrentConnection = База_Подключение(СтрокаПодключения);
		Command.ActiveConnection = CurrentConnection;
		Command.CommandTimeout = 0;
		Command.CommandText = ТекстЗапроса;
		RecordSet = Новый COMОбъект("ADODB.RecordSet");
		RecordSet = Command.Execute(); //Выполнение и получение набора данных
		Возврат RecordSet;
	Исключение	
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;	
КонецФункции

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

Функция База_РезульататЗапросВТаблицуЗначений(RecordSet, ДелатьMoveFirst = Истина) 
	
	//Возврат ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(RecordSet);
	
	тз = Новый ТаблицаЗначений;
	Если ТипЗнч(RecordSet) <> Тип("COMОбъект") тогда
		Возврат тз;
	КонецЕсли;
	
	// Инициализируем колонки
	Для НомерКолонки = 0 По RecordSet.Fields.Count-1 Цикл
		NameFiled = RecordSet.Fields.Item(НомерКолонки).Name;
		NameFiled = СтрЗаменить(NameFiled,"$","_");
		NameFiled = СтрЗаменить(NameFiled, "@", "");
		тз.Колонки.Добавить(NameFiled,,RecordSet.Fields.Item(НомерКолонки).Name, 15);
	КонецЦикла;
	
	// Перебор данных
	Если НЕ RecordSet.EOF() Тогда
		Если ДелатьMoveFirst Тогда RecordSet.MoveFirst(); КонецЕсли;
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

Функция ФинОперациВыборНаСервере(ТекID) Экспорт
	
	//Минеев запрос заменил по просьбе Ольги Диговцовой
	//изм. tuga #14779
	//ТекстЗапроса = 
	//"if OBJECT_ID('tempdb..#Checks')is not null drop table #Checks
	//|if OBJECT_ID('tempdb..#ChecksI')is not null drop table #ChecksI
	//|if OBJECT_ID('tempdb..#Chl_vv')is not null drop table #Chl_vv
	//|if OBJECT_ID('tempdb..#Chl_iz')is not null drop table #Chl_iz
	//|if OBJECT_ID('tempdb..#ls')is not null drop table #ls
	//|
	//|
	//|declare @checkuid as varchar(36)='~~~~~'
	//|select * into #Checks from Sms_Union..Checks (nolock) where CheckUID='~~~~~'
	//|select * into #ChecksI from SMS_IZBENKA..Checks (nolock) where CheckUID='~~~~~'
	//|
	//|select * into #chl_iz from SMS_IZBENKA..Checkline (nolock) where CheckUID='~~~~~'
	//|select * into #chl_vv from SMS_UNION..Checkline (nolock) where CheckUID='~~~~~'
	//|
	//|declare @s as nvarchar(4000), @temp_table as varchar(36)
	//|
	//|if OBJECT_ID('tempdb..#ls')is not null drop table #ls
	//|create table #ls (id_tov_cl int, date_ch date,id_tt_cl int, id_kontr_ls int , id_kontr_fp int)
	//|
	//|-----------------------vv03------------------------------
	//|select @temp_table= replace(convert(char(36),NEWID()) , '-' , '_')
	//|
	//|SET @s =
	//|'select id_tov_cl, date_ch,id_tt_cl 
	//|into Temp_tables..[' + @temp_table + '] ' +
	//|'from #chl_iz 
	//|where isnull(ManufacturerID,0)=0
	//|union all
	//|select id_tov_cl, date_ch,id_tt_cl
	//|from #chl_vv 
	//|where isnull(id_kontr,0)=0
	//|'
	//|EXEC sp_executeSQL @s
	//|
	//|SET @s = '
	//|EXEC( ''select * into Temp_tables.dbo.[' + @temp_table + '] from [SRV-SQL01].Temp_tables.dbo.[' + @temp_table + '] '') at [SRV-SQL03]'
	//|
	//|EXEC sp_executeSQL @s
	//|
	//|
	//|SET @s = '
	//|EXEC('' 
	//|select a.id_tov_cl, a.date_ch,a.id_tt_cl , ls.id_kontr_ls, ls.id_kontr_fp
	//|from Temp_tables.dbo.[' + @temp_table + '] as a 
	//|left join vv03..lost_sales as ls with(nolock) 
	//|on ls.date_ls =a.date_ch and a.id_tov_cl=ls.id_tov_ls and a.id_tt_cl=ls.id_tt_ls 
	//|
	//|
	//|'') at [SRV-SQL03]
	//|' 
	//|insert into #ls (id_tov_cl, date_ch,id_tt_cl , id_kontr_ls, id_kontr_fp)
	//|exec sp_executeSQL @s
	//|
	//|
	//|
	//|SET @s =
	//|'drop table Temp_tables..[' + @temp_table + ']
	//|EXEC( ''drop table Temp_tables.dbo.[' + @temp_table + ']'') at [SRV-SQL03] '
	//|
	//|EXEC sp_executeSQL @s
	//|
	//|----------------------------vv03--------------------------
	//|
	//|Select N_строки,Товар,Производитель
	//|,IsNull(kontr.nova_kontr+case a.fp when 0 then ' (сканиров.)' else ' (посл.поставка)'end,'')[ПредполагаемыйПоставщик]
	//|, Колво, Цена, Сумма , РознЦена
	//|, ТипСкидки, СкидкаВЧеке
	//|, СкидкаБонусами, ЦенаПокупателя
	//|, ТипВводаТовара, КолвоНаВесахПриПробитии
	//|, КолвоВШтрихКоде
	//|, case when ISNULL(pn.ManualInput,0)=1 then '+' else '' end РучнойВводКарты
	//|from
	//|(
	//|select chl.CashCheckLineNo N_строки, t.Name_tov Товар
	//|, kontr.nova_kontr Производитель, chl.Quantity Колво
	//|, round(chl.BaseSum / chl.Quantity,2) Цена, chl.BaseSum Сумма 
	//|, chl.BasePrice РознЦена,'' ТипСкидки, 0 СкидкаВЧеке
	//|, 0 СкидкаБонусами, 0 ЦенаПокупателя, '' ТипВводаТовара
	//|, 0 КолвоНаВесахПриПробитии, 0 КолвоВШтрихКоде
	//|, ch.CashID, ch.CashCheckNo, ch.BONUSCARD, ch.CloseDate
	//|, case isnull(ls.id_kontr_ls,0) when 0 then ls.id_kontr_fp else ls.id_kontr_fp end kontr_ls
	//|, case when isnull(ls.id_kontr_ls,0)=0 then 1 else 0 end fp
	//|from #chl_iz as chl with(nolock) 
	//|inner join #ChecksI ch (nolock) on chl.CheckUID=ch.CheckUID
	//|inner join M2..Tovari t on t.id_tov = chl.id_tov_cl
	//|left join #ls as ls on chl.id_tov_cl=ls.id_tov_cl and chl.id_tt_cl=ls.id_tt_cl 
	//|left outer join [M2].[dbo].[kontr] kontr on (chl.ManufacturerID = kontr.id_kontr)
	//|where chl.Quantity <> 0
	//|union all
	//|
	//|select chl.CashCheckLineNo , t.Name_tov , kontr.nova_kontr
	//|, chl.Quantity , chl.BasePrice , chl.BaseSum , chl.Price_retail
	//|, d.name_discount ТипСкидки
	//|, convert(int,CASE WHEN chl.BasePrice <> chl.Price_retail THEN ( chl.Price_retail - chl.BasePrice) * chl.Quantity END) СкидкаЧек
	//|, convert(int,CASE WHEN abs( chl.BasePrice - chl.set_price) > 0.01 THEN ( chl.BasePrice - chl.set_price) * chl.Quantity end) СкидкаБонусами
	//|, chl.set_price ЦенаПок
	//|, ISNULL(Chl.type_scanned, '') as ТипВводаТовара, ISNULL(Chl.q_vesi, 0) as КолвоНаВесахПриПробитии
	//|, ISNULL(Chl.q_shtrihcode, 0) as КолвоВШтрихКоде
	//|, ch.CashID, ch.CashCheckNo, ch.BONUSCARD, ch.CloseDate
	//|, case isnull(ls.id_kontr_ls,0) when 0 then ls.id_kontr_fp else ls.id_kontr_fp end kontr_ls
	//|, case when isnull(ls.id_kontr_ls,0)=0 then 1 else 0 end fp
	//|from #chl_vv chl
	//|inner join #Checks ch (nolock) on chl.CheckUID=ch.CheckUID
	//|inner join M2..Tovari t on t.id_tov = chl.id_tov_cl
	//|left outer join [M2].[dbo].[kontr] kontr on chl.id_kontr = kontr.id_kontr
	//|left join SMS_REPL..discount_type d (nolock) on d.id_discount = chl.id_discount_chl
	//|and chl.BonusCard_cl IS NOT NULL AND chl.OperationType_cl = 1 AND 
	//|(BasePrice <> Price_retail OR
	//|(BasePrice <> set_price AND set_price <> 0) OR
	//|id_discount_chl IS NOT NULL OR
	//|id_coupons_type2_card_tov IS NOT NULL OR
	//|id_lovepr_card_tov IS NOT NULL)
	//|left join #ls ls on chl.id_tov_cl=ls.id_tov_cl and chl.id_tt_cl=ls.id_tt_cl 
	//|where chl.Quantity <> 0) a
	//|left join Loyalty..PurchaseNotification as pn with(nolock)
	//|on a.CloseDate=pn.DateTime and a.CashID=pn.CashID and a.CashCheckNo=pn.DocNum 
	//|left outer join [M2].[dbo].[kontr] kontr on isnull(a.kontr_ls,0)>0 and a.kontr_ls = kontr.id_kontr
	//|order by a.N_строки
	//|
	//|if OBJECT_ID('tempdb..#Checks')is not null drop table #Checks
	//|if OBJECT_ID('tempdb..#ChecksI')is not null drop table #ChecksI
	//|if OBJECT_ID('tempdb..#Chl_vv')is not null drop table #Chl_vv
	//|if OBJECT_ID('tempdb..#Chl_iz')is not null drop table #Chl_iz
	//|if OBJECT_ID('tempdb..#ls')is not null drop table #ls";

	
	ВсегоДл = СтрДлина(ТекID);	
	ТекID = Лев(ТекID, ВсегоДл -1);
	ВсегоДл = СтрДлина(ТекID);
	ТекID = Прав(ТекID, ВсегоДл -1);
	
	//ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~", ТекID);
	
	//+++АК MIND 2017.12.15 все вынесено в процедуру скл
	ТекстЗапроса = "EXEC	[SMS_REPL].[dbo].[Get_CheckInfo_for1C]
					|@checkuid = " + ВнешниеДанные.ФорматПоля(ТекID);
	
	//СтрокаПодключения = "Provider=SQLOLEDB.1;Persist Security Info=True;Initial Catalog=Loyalty;Data Source=srv-sql01;Password=cjyzcjyz;User ID=izbenka";
	//RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, Неопределено, СтрокаПодключения);
	//Пока RecordSet <> Неопределено И RecordSet.Fields.Count <= 0 Цикл
	//	RecordSet=RecordSet.NextRecordSet();
	//КонецЦикла;
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	RecordSet = ADOСоединение.Execute(ТекстЗапроса);
	Пока RecordSet <> Неопределено И RecordSet.Fields.Count <= 0 Цикл
		RecordSet=RecordSet.NextRecordSet();
	КонецЦикла;
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet, Ложь);
	Если ТЗ.НайтиСтроки(Новый Структура("ПредполагаемыйПоставщик","")).Количество()=ТЗ.Количество() Тогда
		ТЗ.Колонки.Удалить("ПредполагаемыйПоставщик")
	КонецЕсли;
	RecordSet.Close();
	
	ТЗ.Колонки.Удалить("N_строки");
	Табл = Новый ТабличныйДокумент;
	Макет = ПолучитьОбщийМакет(Метаданные.ОбщиеМакеты.АК_ПечатьТаблицЗначений);
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапкаОсновной=Макет.ПолучитьОбласть("Шапка|Основной");
	ОбластьСтрокаОсновной=Макет.ПолучитьОбласть("Строка|Основной");
	ОбластьИтогОсновной=Макет.ПолучитьОбласть("Итог|Основной");
	ОбластьШапкаДОП=Макет.ПолучитьОбласть("Шапка|Показатели");
	ОбластьСтрокаДОП=Макет.ПолучитьОбласть("Строка|Показатели");
	ОбластьИтогДОП=Макет.ПолучитьОбласть("Итог|Показатели");
	
	
	ОбластьЗаголовок.Параметры.Заголовок = "Чек_unf ";
	Табл.Вывести(ОбластьЗаголовок);
	
	Табл.Вывести(ОбластьШапкаОсновной);
	
	Для Каждого Колонка из Тз.Колонки ЦИКЛ
		ОбластьШапкаДОП.Параметры.ИмяПоказателя=Колонка.Имя;
		Если Колонка.Имя <> "Товар"
			И Колонка.Имя <> "ТипСкидки" Тогда
			ОбластьШапкаДОП.Область(1, 1, 1, 1).ШиринаКолонки = 11;
			ОбластьШапкаДОП.Область(1, 1, 1, 1).РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
		КонецЕсли;
		Табл.Присоединить(ОбластьШапкаДОП);
	КонецЦикла;
	
	счетчик=0;
	Для каждого стр из Тз Цикл
		счетчик=счетчик+1;
		ОбластьСтрокаОсновной.Параметры.счетчик=счетчик; 
		Табл.Вывести(ОбластьСтрокаОсновной);
		Для Каждого Колонка из Тз.Колонки ЦИКЛ
			ОбластьСтрокаДОП.Параметры.ЗначениеКолонки=СокрЛП(Формат(стр[Колонка.Имя],"ЧДЦ=2; ЧН=0,00; ЧГ=0"));
			ОбластьСтрокаДОП.Область(1, 1, 1, 1).ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
			ОбластьСтрокаДОП.Область(1, 1, 1, 1).РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
			Если Колонка.Имя <> "Товар"
				И Колонка.Имя <> "ТипСкидки" Тогда
				ОбластьСтрокаДОП.Область(1, 1, 1, 1).ШиринаКолонки = 11;
			КонецЕсли;	
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
	Возврат Табл;
		
КонецФункции

&НаСервере
Функция  ОтчетПоРучнымНачислениямБалловНаСервере(НомерКарты) Экспорт
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	ТекстЗапроса = "SELECT [dbo].[Card_new].[user_add], [dbo].[Card_new].[time], [dbo].[Card_new].[amount], [dbo].[Card_new].[card_nomer], [dbo].[Customer].[Фамилия], [dbo].[Customer].[FullName],[dbo].[Card_new].descr 
	|FROM ([dbo].[Card_new] LEFT JOIN [dbo].[DiscountCard] ON [dbo].[Card_new].[card_nomer] = [dbo].[DiscountCard].[Number]) LEFT JOIN [dbo].[Customer] ON [dbo].[DiscountCard].[CustomerUID] = [dbo].[Customer].[CustomerUID]
	//+++АК SHEP 2018.05.08 ИП-00018563
	//|" + ?(ЗначениеЗаполнено(НомерКарты), "WHERE [dbo].[Customer].[Email] = " + ВнешниеДанные.ФорматПоля(НомерКарты), "") + "
	|" + ?(ЗначениеЗаполнено(НомерКарты), "WHERE [dbo].[Customer].[bc_number] = " + ВнешниеДанные.ФорматПоля(НомерКарты), "") + "
	//---АК SHEP 2018.05.08
	|ORDER BY [dbo].[Card_new].[time] DESC;";
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();	
		
	Табл=Новый ТабличныйДокумент;
	Макет = ПолучитьОбщийМакет(Метаданные.ОбщиеМакеты.АК_ПечатьТаблицЗначений);
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапкаОсновной=Макет.ПолучитьОбласть("Шапка|Основной");
	ОбластьСтрокаОсновной=Макет.ПолучитьОбласть("Строка|Основной");
	ОбластьИтогОсновной=Макет.ПолучитьОбласть("Итог|Основной");
	ОбластьШапкаДОП=Макет.ПолучитьОбласть("Шапка|Показатели");
	ОбластьСтрокаДОП=Макет.ПолучитьОбласть("Строка|Показатели");
	ОбластьИтогДОП=Макет.ПолучитьОбласть("Итог|Показатели");
	
	
	ОбластьЗаголовок.Параметры.Заголовок = "История ручных начислений";
	Табл.Вывести(ОбластьЗаголовок);
	
	Табл.Вывести(ОбластьШапкаОсновной);
	
	Для Каждого Колонка из Тз.Колонки ЦИКЛ
		ОбластьШапкаДОП.Параметры.ИмяПоказателя=Колонка.Имя;
		Табл.Присоединить(ОбластьШапкаДОП);
	КонецЦикла;
	
	счетчик=0;
	Для каждого стр из Тз Цикл
		счетчик=счетчик+1;
		ОбластьСтрокаОсновной.Параметры.счетчик=счетчик; 
		Табл.Вывести(ОбластьСтрокаОсновной);
		Для Каждого Колонка из Тз.Колонки ЦИКЛ
			ОбластьСтрокаДОП.Параметры.ЗначениеКолонки=Формат(стр[Колонка.Имя],"ЧДЦ=2; ЧН=0,00; ЧГ=0");
			Табл.Присоединить(ОбластьСтрокаДОП);
		КонецЦикла;
	КонецЦикла;
	
	Табл.ОтображатьСетку = Ложь;
	Возврат Табл
	
	
КонецФункции

//+++АК SHEP 2018.05.20 ИП-00018557.01
// 
Функция СписокАкцийРазнообразноеПитание(ТолькоПрошедшие = Неопределено) Экспорт
	
	СписокАкций = Новый СписокЗначений;
	
	Попытка
		ADOСоединение = Новый COMОбъект("ADODB.Connection");
		СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql03", "Telegram");
		ADOСоединение.Open(СтрокаПодключения);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат СписокАкций;
	КонецПопытки;
	
	ТекстЗапросаSQL = "
		|set language russian
		|
		|SELECT year_month,
		|       (case when getdate() >= date_start
		|              and getdate() < dateadd(day, 1, date_finish) then 1 else 0 end) as is_active,
		|       cast(year_month as char(6)) + ' - скидка на ' + lower(datename(month, cast(cast(year_month as char(6)) + '01' as datetime))) as action_name
		|FROM Telegram.dbo.BOT_Action as ba with(nolock)
		|";
	
	Если ТолькоПрошедшие <> Неопределено Тогда
		ТекстЗапросаSQL = ТекстЗапросаSQL + "
		|WHERE (case when getdate() >= date_start
		|              and getdate() < dateadd(day, 1, date_finish) then 1 else 0 end) = " + ?(ТолькоПрошедшие, "0", "1");
	КонецЕсли;
	
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	Пока rs <> Неопределено И rs.Fields.Count <= 0 Цикл
		rs = rs.NextRecordSet();
	КонецЦикла;
	
	//Попытка
		rs.MoveFirst();
		Пока НЕ rs.EOF() Цикл
			СписокАкций.Добавить(Формат(Rs.Fields("year_month").Value, "ЧГ="), Rs.Fields("action_name").Value, Rs.Fields("is_active").Value);
			rs.MoveNext();
		КонецЦикла;
	//Исключение
	//КонецПопытки;
	
	ADOСоединение.Close();
	ADOСоединение = Неопределено;
	
	Возврат СписокАкций;
	
КонецФункции
