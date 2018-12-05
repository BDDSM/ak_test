
Процедура ОбновитьСписок()
	
	ТаблицаПеремещений.Очистить();
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	ТекстЗапросаSQL = "SELECT DISTINCT
	|td.closedate,
	|case when operation_type_orig in (410) then td.Corr_id_tt else td.ShopNo_rep end ShopNo_Rep, --Магазин отправитель
	|case when operation_type_orig in (410) then td.ShopNo_rep else td.Corr_id_tt end Corr_id_tt, --Магазин получатель
	|td.Id_doc,
	|tpo.name_operation
    |
	|from SMS_REPL..TD_move as td with(nolock)
	|inner join SMS_REPL..Types_Operation as tpo with(nolock)
	|on abs(td.operation_type_orig)=tpo.code_operation and table_operation ='td_move' and field_operation='operation_type_orig'
	|where abs(operation_type_orig) in (410,411) and ABS(operation_type) in (410,411)
	|and Confirm_type in (0,-1) and Confirm_reason in (0,15,21) and CONVERT(date,closedate)=convert(date,GETDATE()) and Corr_id_tt not in (10,11)
	|UNION ALL
	|select distinct ch.closedate,
	|case when abs(cl.operationtype_cl) in (410) then ch.ShopNo else convert(int,pr.Quantity) end ShopNo
	|, case when abs(cl.operationtype_cl) in (410) then convert(int,pr.Quantity) else ch.ShopNo end
	|, ch.CheckUID, tpo.name_operation
	|from SMS_IZBENKA..CheckLine as cl with(nolock) inner join SMS_IZBENKA..Checks as ch with(nolock) on cl.CheckUID=ch.CheckUID
	|inner join (select CheckUID, Quantity from SMS_IZBENKA..CheckLine as chl with(nolock)
	|where id_tov_cl=1562 and date_ch=convert(date,GETDATE()) and Quantity not in (10,11,0,1) and chl.Quantity>1) pr
	|on Cl.CheckUID=pr.CheckUID
	|inner join SMS_REPL..Types_Operation as tpo with(nolock)
	|on ABS(cl.operationtype_cl)=tpo.code_operation and table_operation ='sms_izbenka..Checkline'
	|and field_operation='operation_type_orig'
    |
	|where OperationType_cl in (-410,-411) and Confirm_reason in (0,15,21) and date_ch=convert(date,GETDATE()) and id_tov_cl<>1562
	|ORDER BY ShopNo_Rep,Corr_id_tt,closedate, name_operation desc";
					
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	Попытка
		rs.MoveFirst();
		Пока НЕ rs.Eof() Цикл
			//Сообщить(Выборка.Confirm_type);
			НовСтр = ТаблицаПеремещений.Добавить();
			НовСтр.ДатаДокумента = rs.Fields("closedate").Value;
			НовСтр.МагазинОтправитель = rs.Fields("ShopNo_rep").Value;
			НовСтр.МагазинПолучатель = rs.Fields("Corr_id_tt").Value;
			НовСтр.Ссылка = rs.Fields("Id_doc").Value;
			rs.MoveNext();
		КонецЦикла;
		
	Исключение
	КонецПопытки;
	
	ADOСоединение.Close();
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьСписок();
	
КонецПроцедуры

Процедура СоздатьДокументНаСервере(ТекИдентификатор)
	
	ТекДанные = ТаблицаПеремещений.НайтиПоИдентификатору(ТекИдентификатор);
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	ТекстЗапросаSQL = "DECLARE @RC int
						|DECLARE @Doc_UID uniqueidentifier = " + ВнешниеДанные.ФорматПоля(ТекДанные.Ссылка) + "
						|DECLARE @User varchar(200) = " + ВнешниеДанные.ФорматПоля(Строка(ПараметрыСеанса.ТекущийПользователь)) + "
						|DECLARE @res varchar(500) = ''
                        |
						|EXECUTE @RC = [SMS_REPL].[dbo].[CreatePerem_ForClosedTT] 
						|   @Doc_UID
						|  ,@User
						|  ,@res OUTPUT
						|
						|SELECT @res as res";
					
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	
	Пока НЕ rs = Неопределено Цикл
		Если rs.Fields.Count > 0 Тогда
			Прервать;
		КонецЕсли;
		rs = rs.NextRecordSet();
	КонецЦикла;
	
	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			Сообщить(Rs.Fields("res").Value);
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	ADOСоединение.Close();
	
КонецПроцедуры	

&НаКлиенте
Процедура СоздатьДокументПоВыделеннойСтроке(Команда)
	
	Если Элементы.ТаблицаПеремещений.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	СоздатьДокументНаСервере(Элементы.ТаблицаПеремещений.ТекущаяСтрока);
	ОбновитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок1(Команда)
	
	ОбновитьСписок();
	
КонецПроцедуры
