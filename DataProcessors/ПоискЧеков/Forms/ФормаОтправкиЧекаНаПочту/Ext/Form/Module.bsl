
&НаСервере
Процедура ПолучательПриИзмененииНаСервере()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Объект", Получатель);
	Запрос.Текст = "ВЫБРАТЬ
	               |	КонтактнаяИнформация.Представление
	               |ИЗ
	               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	               |ГДЕ
	               |	КонтактнаяИнформация.Объект = &Объект
	               |	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	               |	И КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		EMail = СокрЛП(Выборка.Представление);
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	ПолучательПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтправитьНаПочтуНаСервере()
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	СтрокаГуидов = "";
	Для Каждого ЭлементГуид Из МассивЧеков Цикл
		СтрокаГуидов = СтрокаГуидов + ?(ЗначениеЗаполнено(СтрокаГуидов), ",", "") + "(" + ВнешниеДанные.ФорматПоля(ЭлементГуид.Значение) + ")";
	КонецЦикла;	
	
	ТекстЗапроса = "create table #ChGuids(CheckUID uniqueidentifier)
					|insert into #ChGuids(CheckUID) VALUES " + СтрокаГуидов + "
					|
					|CREATE INDEX index_CheckUID
					|ON #ChGuids(CheckUID)
					|
					|declare @rowuid as uniqueidentifier=newid(), @s as nvarchar(4000)
					|set @s='
					|select ch.CheckUID, 2 tt_format
					|into temp_tables..['+ CONVERT(varchar(36),@rowuid)+']
					|from SMS_UNION..Checks as ch with(nolock)
					|Left outer join #ChGuids as ChGuids ON Ch.CheckUID = ChGuids.CheckUID
					|where not ChGuids.CheckUID is null
					|order by CloseDate desc
					|'
					|
					|exec sp_executesql @s
					|
					|
					|set @s='
					|insert into temp_tables..['+ CONVERT(varchar(36),@rowuid)+'] (checkUID, tt_format)
					|select ch.CheckUID, 1 tt_format
					|from SMS_izbenka..Checks as ch with(nolock)
					|Left outer join #ChGuids as ChGuids ON Ch.CheckUID = ChGuids.CheckUID
					|where not ChGuids.CheckUID is null
					|order by CloseDate desc
					|'
					|
					|exec sp_executesql @s
					|
					|INSERT INTO [Reports].[dbo].[BOT_Send_Customer_Check_email]
					|([CheckUID]
					|,[email]
					|,[row_uid])
					|VALUES
					|(@rowuid
					|," + ВнешниеДанные.ФорматПоля(EMail) + "
					|,@rowuid)
					|
					|insert into jobs.dbo.Jobs (job_name, prefix_job, number_1)
					|select 'reports..BOT_send_email_check',@rowuid, 0";

	
	//ТекстЗапроса = "declare @checkUID as uniqueidentifier=" + ВнешниеДанные.ФорматПоля(УинЧека) + " --идентификатор чека
	//				| ,@email as varchar(500)=" + ВнешниеДанные.ФорматПоля(EMail) + " -- адрес электронной почты 
	//				| ,@row_uid as varchar(36)=replace(newid(),'-','_') 
	//				| ,@tt_format as int =2 --1Избенка, 2 --Вкусвилл
	//				| INSERT INTO [Reports].[dbo].[BOT_Send_Customer_Check_email]
	//				|([CheckUID] ,[email],[row_uid])
	//				|select @CheckUID, @email, @Row_uid 
	//				|--добавим задание на отправку почты
	//				|insert into jobs.dbo.Jobs (job_name, prefix_job, number_1)
	//				|select 'reports..BOT_send_email_check',@Row_uid, @tt_format";
	
	ADOСоединение.Execute(ТекстЗапроса);
	
	ADOСоединение.Close();
	ADOСоединение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНаПочту(Команда)
	ОтправитьНаПочтуНаСервере();
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивЧеков.ЗагрузитьЗначения(Параметры.МассивЧеков);
	
КонецПроцедуры
