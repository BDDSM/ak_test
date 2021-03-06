﻿
#Область ОбработчикиСобытий

//+++АК LATV 2018.10.18 ИП-00020202
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	// Определение параметров
	мДатаРаспределения	= Дата(1, 1, 1);
	мНоменклатура		= Справочники.Номенклатура.ПустаяСсылка();
	мТекстId_tov		= "";
	мТекстNumber_r		= "";
	Для Каждого ПользПоле Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ПользПоле.Использование Тогда
			Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
				Если Строка(ПользПоле.Параметр) = "ДатаРаспределения" Тогда
					Если ТипЗнч(ПользПоле.Значение) = Тип("СтандартнаяДатаНачала") Тогда
						мДатаРаспределения = ПользПоле.Значение.Дата;
					Иначе
						мДатаРаспределения = ПользПоле.Значение;
					КонецЕсли;
				ИначеЕсли Строка(ПользПоле.Параметр) = "Номенклатура" Тогда
					мНоменклатура = ПользПоле.Значение;
					Если ЗначениеЗаполнено(мНоменклатура) Тогда
						мТекстId_tov = " and tm2.id_tov in (";
						Если ТипЗнч(мНоменклатура) = Тип("СписокЗначений") Тогда
							ЭТоПервый = Истина;
							Для Каждого СтрНом Из мНоменклатура Цикл
								мТекстId_tov = мТекстId_tov + ?(ЭтоПервый,"",", ")+Формат(СтрНом.Значение.id_tov, "ЧН=0; ЧГ=");
								ЭТоПервый = Ложь;
							КонецЦикла;
							мТекстId_tov = мТекстId_tov + ")";
							
						ИначеЕсли ТипЗнч(мНоменклатура) = Тип("Массив") Тогда
							ЭТоПервый = Истина;
							Для Каждого СтрНом Из мНоменклатура Цикл
								мТекстId_tov = мТекстId_tov + ?(ЭтоПервый,"",", ")+Формат(СтрНом.id_tov, "ЧН=0; ЧГ=");	
								ЭТоПервый = Ложь;
							КонецЦикла;
							мТекстId_tov = мТекстId_tov + ")";
						Иначе
							мТекстId_tov = мТекстId_tov + Формат(мНоменклатура.id_tov, "ЧН=0; ЧГ=")+")";
						КонецЕСли;
					КонецЕСли;
				ИначеЕсли Строка(ПользПоле.Параметр) = "НомерРаспределения" Тогда
					мТекстNumber_r = " and tm2.number_r = "+Формат(ПользПоле.Значение, "ЧН=0; ЧГ=");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(мДатаРаспределения) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо указать дату распределения'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если мТекстId_tov = "" и мТекстNumber_r = "" Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо указать или номенклатуру или номер распределения'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕСли;
	
	// Формирование отчета
	ТаблицаДанных = ПолучитьДанныеДляФормирования(мДатаРаспределения, мТекстId_tov, мТекстNumber_r);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ДанныеДляФормирования", ТаблицаДанных);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//+++АК LATV 2018.10.18 ИП-00020202
Функция ПолучитьДанныеДляФормирования(мДатаРаспределения, мТекстId_tov, мТекстNumber_r)

	мТипЧисло = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(12, 3));
	мТипДата = Новый ОписаниеТипов("Дата");
	
	ТекстДаты = "'"+Формат(мДатаРаспределения, "ДФ=yyyyMMdd")+"'";
	
	ТаблицаДанные = Новый ТаблицаЗначений;
	ТаблицаДанные.Колонки.Добавить("Характеристика"			, Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаДанные.Колонки.Добавить("ТорговаяТочка"			, Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ТаблицаДанные.Колонки.Добавить("Номенклатура"			, Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДанные.Колонки.Добавить("НомерРаспределения"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ДатаРаспределения"		, мТипДата);
	ТаблицаДанные.Колонки.Добавить("id_tov"					, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("id_kontr"				, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("id_tt"					, мТипЧисло);
	
	ТаблицаДанные.Колонки.Добавить("КолОст"			, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ФактКолОст"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("РасчКолОст"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("МинОст"			, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("МаксОст"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КолПоПлану"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КолВКор"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("РаспрНеЦелымиКор"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("Распределено"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ОжидаемыйПриход"	, мТипЧисло);
	
	ТаблицаДанные.Колонки.Добавить("РасходныйОрдер"		, Новый ОписаниеТипов("ДокументСсылка.РасходныйОрдерСклад"));
	ТаблицаДанные.Колонки.Добавить("ЗаданиеНаРазборку"	, Новый ОписаниеТипов("ДокументСсылка.ЗаданиеНаРазборку"));
	ТаблицаДанные.Колонки.Добавить("МаршрутныйЛист"		, Новый ОписаниеТипов("ДокументСсылка.МаршрутныйЛист"));
	
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut	= 0;
	ADOСоединение.CommandTimeOut	= 0;
	ADOСоединение.ConnectionString	= ОбменСAccess.ПолучитьСтрокуСоединения("SMS_Izbenka");
	ADOСоединение.Open();
	
	ТекстЗапроса =
	"Declare @id_tov int, @DateRaspr datetime, @number_r int
	|Set @DateRaspr			= " + ТекстДаты + "
	|	
	|	SELECT tm2.number_r as number_r
	|      ,tm2.date_add
	|      ,tm2.id_tt
	|      ,tm2.id_tov
	|      ,tm2.id_kontr
	|      ,SprNom._Description as tovar
	|      ,CAST(master.dbo.Binary2UID(SprNom._IDRRef) as nvarchar(36)) as tovar_ref
	|      ,SprNom._Fld760 as id_tov_1C
	|      ,SprCh._Description as ch
	|      ,CAST(master.dbo.Binary2UID(SprCh._IDRRef) as nvarchar(36)) as ch_ref
	|	   ,SprCh._Fld7868 as ch_id_1C
	|	   ,SprTT._Description as tt
	|	   ,SprTT._Fld758 as id_tt_1C
	|	   ,CAST(master.dbo.Binary2UID(SprTT._IDRRef) as nvarchar(36)) as tt_ref
	|	   ,isNULL(tk_init.q_ost_sklad,0) as q_ost_sklad
	|	   ,isNULL(tk_init.q_wait_sklad,0) as q_wait_sklad
	|	   ,isNULL(tm2.q_fo_fact,0) as q_fo_fact
	|	   ,isNULL(tm2.q_FO,0) as q_FO
	|      ,isNULL(tm2.q_min_ost,0) as q_min_ost
	|      ,isNULL(tm2.q_max_ost,0) as q_max_ost
	|      ,tm2.q_plan_pr
	|      ,isNULL(tk_init.Kolvo_korob,0) as Kolvo_korob
	|      ,isNULL(t_init.pick_item,0) as pick_item
	|      ,tm2.q_raspr
	|      ,CAST(master.dbo.Binary2UID(docRO._Document3034_IDRRef) as nvarchar(36)) as RO_IDRRef
	|	   ,CAST(master.dbo.Binary2UID(docRO._Fld13846RRef) as nvarchar(36)) as Zad_IDRRef
	|	   ,CAST(master.dbo.Binary2UID(docML._Document3036_IDRRef) as nvarchar(36)) as ML_IDRRef
	|  FROM [M2].[dbo].[archive_rasp] tm2 (nolock)
	|	inner JOIN IzbenkaFin.dbo._Reference29 SprNom (nolock) ON tm2.id_tov = SprNom._Fld760
	|	inner JOIN IzbenkaFin.dbo._Reference2539 SprCh (nolock) ON tm2.id_kontr = SprCh._Fld7868 and SprNom._IDRRef = SprCh._OwnerIDRRef 
	|	inner JOIN IzbenkaFin.dbo._Reference42 SprTT (nolock) ON tm2.id_tt = SprTT._Fld758
	|	left outer JOIN IzbenkaFin.dbo._Document3034_VT3100 docRO (nolock)
	|			inner JOIN IzbenkaFin.dbo._Document3034 docRO_h (nolock)
	|			ON docRO._Document3034_IDRRef = docRO_h._IDRRef
	|		ON tm2.number_r = docRO._Fld5085 and SprNom._IDRRef = docRO._Fld3102RRef and SprCh._IDRRef = docRO._Fld3103RRef and SprTT._IDRRef = docRO_h._Fld3090_RRRef
	|	left outer join IzbenkaFin.dbo._Document3036_VT3132 docML (nolock) ON docML._Fld3134RRef = docRO._Document3034_IDRRef
	|	left outer join [M2].[dbo].[tov_kontr_init] tk_init (nolock) on tm2.number_r = tk_init.Number_r and tm2.id_tov = tk_init.id_tov and tm2.id_kontr = tk_init.id_kontr
	|	left outer join [M2].[dbo].[tov_init] t_init (nolock) on tm2.number_r = t_init.Number_r and tm2.id_tov = t_init.id_tov 
	|where convert(date,tm2.date_add,102) = @DateRaspr "+мТекстId_tov+мТекстNumber_r+"
	|";
	
	СпрХарактеристика	= Справочники.ХарактеристикиНоменклатуры;
	СпрНоменклатура 	= Справочники.Номенклатура;
	СпрТорговыеТочки 	= Справочники.СтруктурныеЕдиницы;
	ДокРО				= Документы.РасходныйОрдерСклад;
	ДокРейс				= Документы.МаршрутныйЛист;
	ДокЗадание			= Документы.ЗаданиеНаРазборку;
	
	rs = ADOСоединение.Execute(ТекстЗапроса);
	Пока НЕ rs = Неопределено Цикл
		Если rs.Fields.Count > 0 Тогда
			Пока НЕ rs.EOF Цикл
				
				НоваяСтрока = ТаблицаДанные.Добавить();
				
				НоваяСтрока.id_tt					= rs.Fields("id_tt").Value;
				НоваяСтрока.id_tov					= rs.Fields("id_tov").Value;
				НоваяСтрока.id_kontr				= rs.Fields("id_kontr").Value;

				НоваяСтрока.НомерРаспределения		= rs.Fields("number_r").Value;
				НоваяСтрока.ДатаРаспределения		= rs.Fields("date_add").Value;
				НоваяСтрока.КолОст					= rs.Fields("q_ost_sklad").Value;
				НоваяСтрока.ФактКолОст				= rs.Fields("q_fo_fact").Value;
				НоваяСтрока.РасчКолОст				= rs.Fields("q_FO").Value;
				НоваяСтрока.МинОст					= rs.Fields("q_min_ost").Value;
				НоваяСтрока.МаксОст					= rs.Fields("q_max_ost").Value;
				НоваяСтрока.КолПоПлану				= rs.Fields("q_plan_pr").Value;
				НоваяСтрока.КолВКор					= rs.Fields("Kolvo_korob").Value;
				НоваяСтрока.РаспрНеЦелымиКор		= rs.Fields("pick_item").Value;
				НоваяСтрока.Распределено			= rs.Fields("q_raspr").Value;
				НоваяСтрока.ОжидаемыйПриход			= rs.Fields("q_wait_sklad").Value;
				
				Попытка
					НоваяСтрока.Характеристика		= СпрХарактеристика.ПолучитьСсылку(Новый УникальныйИдентификатор(rs.Fields("ch_ref").Value));
				Исключение
				КонецПопытки;
				Попытка
					НоваяСтрока.Номенклатура		= СпрНоменклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(rs.Fields("tovar_ref").Value));
				Исключение
				КонецПопытки;
				Попытка
					НоваяСтрока.ТорговаяТочка		= СпрТорговыеТочки.ПолучитьСсылку(Новый УникальныйИдентификатор(rs.Fields("tt_ref").Value));
				Исключение
				КонецПопытки;
				Попытка
					НоваяСтрока.РасходныйОрдер		= ДокРО.ПолучитьСсылку(Новый УникальныйИдентификатор(rs.Fields("RO_IDRRef").Value));
				Исключение
				КонецПопытки;
				Попытка
					НоваяСтрока.ЗаданиеНаРазборку	= ДокЗадание.ПолучитьСсылку(Новый УникальныйИдентификатор(rs.Fields("Zad_IDRRef").Value));
				Исключение
				КонецПопытки;
				Попытка
					НоваяСтрока.МаршрутныйЛист		= ДокРейс.ПолучитьСсылку(Новый УникальныйИдентификатор(rs.Fields("ML_IDRRef").Value));
				Исключение
				КонецПопытки;
				
				Если НЕ rs.EOF Тогда
					rs.MoveNext();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		rs = rs.NextRecordSet();
	КонецЦикла;
	
	ADOСоединение.Close();
	
	Возврат ТаблицаДанные;

КонецФункции

#КонецОбласти