
Процедура ЗаполнитьТаблицыОстатков()
	
	//2016-04-28 Минеев - в связи с переделкой логики работы таблицы AccArticle переделана следующая процедура, весь старый код в комменте
	
	ЗапросКеш = Новый Запрос;
	ЗапросКеш.УстановитьПараметр("ТекДата", ТекущаяДата());
	ЗапросКеш.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура,
	|	ЦеныНоменклатурыСрезПоследних.Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ТекДата, ТорговаяТочка = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)) КАК ЦеныНоменклатурыСрезПоследних";
					  
	ТабКешЦены = ЗапросКеш.Выполнить().Выгрузить();
	
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	ADOСоединение.ConnectionString  = ОбменСAccess.ПолучитьСтрокуСоединения("SMS_UNION");
	ADOСоединение.Open();
	
	ТекстЗапроса =
	"exec M2..ostatki_tt_tov_kontr_currdate null,'" + Формат(ЭтаФорма.ТорговаяТочка.id_TT, "ЧГ=0") + "',0";
	
	Выборка = ADOСоединение.Execute(ТекстЗапроса);
	
	//
	СпрНоменклатура = Справочники.Номенклатура;
	
	Пока НЕ Выборка = Неопределено Цикл
		Если Выборка.Fields.Count > 0 Тогда
			Пока НЕ Выборка.EOF Цикл
			
				ТекОстаток = Макс(Выборка.Fields("kol").Value, 0);
				
				НоваяСтрока = ЭтаФорма.ТаблицаОстатков.Добавить();
				НоваяСтрока.Дата 		= ТекущаяДата();
				Если НЕ Выборка.Fields("TovarUID").Value = NULL Тогда
					НоваяСтрока.Номенклатура 	= СпрНоменклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.Fields("TovarUID").Value));
				КонецЕсли;
				НоваяСтрока.Количество 	= ТекОстаток;
				СтрокаКешЦена = ТабКешЦены.Найти(НоваяСтрока.Номенклатура, "Номенклатура");
				Если СтрокаКешЦена = Неопределено Тогда
					НоваяСтрока.Цена 		= 0;
					НоваяСтрока.Сумма 		= 0;
				Иначе
					НоваяСтрока.Цена 		= СтрокаКешЦена.Цена;
					НоваяСтрока.Сумма 		= СтрокаКешЦена.Цена * НоваяСтрока.Количество;
				КонецЕсли;	
			
				Если НЕ Выборка.EOF Тогда
					Выборка.MoveNext();
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		Выборка = Выборка.NextRecordSet();
	КонецЦикла;
	
	//// ищем последний день, в котором были записи по торговой точке
	//Если ЭтаФорма.ТаблицаОстатков.Количество() = 0 Тогда
	//	
	//	ТекстЗапроса =
	//	"IF OBJECT_ID('tempdb..#tabuidynom') IS NOT NULL
	//	|DROP TABLE #tabuidynom
	//	|;
	//	|IF OBJECT_ID('tempdb..#tabmaxdata') IS NOT NULL
	//	|DROP TABLE #tabmaxdata
	//	|;
	//	|SELECT
	//	|	[id_tov] as ID,
	//	|	[UID] as UID
	//	|INTO
	//	|	#tabuidynom
	//	|FROM [IzbenkaFin].[dbo].[ArticleBin2UID] (nolock)
	//	|;
	//	|SELECT
	//	|	MAX(RealOstatki.Period) as Period
	//	|INTO
	//	|	#tabmaxdata
	//	|FROM [SMS_UNION].[dbo].[AccArticle] as RealOstatki (nolock)
	//	|WHERE
	//	|	RealOstatki.ID_TT IN (" + Формат(ЭтаФорма.ТорговаяТочка.id_TT, "ЧГ=0") + ")
	//	|;
	//	|SELECT
	//	|	tabuidynom.UID as TovarUID,
	//	|	CONVERT(REAL, [Amount]) as Amount,
	//	|	CONVERT(REAL, [Price]) as Price,
	//	|	RealOstatki.Period
	//	|FROM [SMS_UNION].[dbo].[AccArticle] as RealOstatki (nolock)
	//	| 	INNER JOIN
	//	| 		#tabmaxdata as tabmaxdata (nolock)
	//	| 	ON CONVERT(DATE, RealOstatki.Period) = CONVERT(DATE, tabmaxdata.Period)
	//	| 	LEFT OUTER JOIN
	//	| 		#tabuidynom as tabuidynom (nolock)
	//	| 	ON RealOstatki.ID_tov = tabuidynom.ID
	//	|WHERE
	//	|	RealOstatki.ID_TT IN (" + Формат(ЭтаФорма.ТорговаяТочка.id_TT, "ЧГ=0") + ")
	//	|ORDER BY
	//	|	RealOstatki.Period DESC
	//	|;
	//	|DROP TABLE
	//	|	#tabuidynom
	//	|;
	//	|DROP TABLE
	//	|	#tabmaxdata";
	//	Выборка = ADOСоединение.Execute(ТекстЗапроса);
	//	
	//	Пока НЕ Выборка = Неопределено Цикл
	//		Если Выборка.Fields.Count > 0 Тогда
	//			Пока НЕ Выборка.EOF Цикл
	//			
	//				ТекОстаток = Макс(Выборка.Fields("Amount").Value, 0);
	//				
	//				НоваяСтрока = ЭтаФорма.ТаблицаОстатков.Добавить();
	//				НоваяСтрока.Дата 		= Выборка.Fields("Period").Value;
	//				Если НЕ Выборка.Fields("TovarUID").Value = NULL Тогда
	//					НоваяСтрока.Номенклатура 	= СпрНоменклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Сред(Выборка.Fields("TovarUID").Value, 2, 36)));
	//				КонецЕсли;
	//				НоваяСтрока.Количество 	= ТекОстаток;
	//				НоваяСтрока.Цена 		= Выборка.Fields("Price").Value;
	//				НоваяСтрока.Сумма 		= ТекОстаток * НоваяСтрока.Цена;
	//			
	//				Если НЕ Выборка.EOF Тогда
	//					Выборка.MoveNext();
	//				КонецЕсли;
	//				
	//			КонецЦикла;
	//		КонецЕсли;
	//		Выборка = Выборка.NextRecordSet();
	//	КонецЦикла;
	//	
	//КонецЕсли;
	ADOСоединение.Close();
	
	//
	ВремТаблица = ЭтаФорма.ТаблицаОстатков.Выгрузить(, "Дата, Сумма");
	ВремТаблица.Свернуть("Дата", "Сумма");
	
	ЭтаФорма.ТаблицаСумм.Загрузить(ВремТаблица);
	
	
	//СТАРЫЙ КОД
	
	//мДатаНачала = НачалоДня(ТекущаяДата()) - 86400;
	//
	//ADOСоединение = Новый COMОбъект("ADODB.Connection");
	//ADOСоединение.ConnectionTimeOut = 0;
	//ADOСоединение.CommandTimeOut    = 0;
	//ADOСоединение.ConnectionString  = ОбменСAccess.ПолучитьСтрокуСоединения("SMS_UNION");
	//ADOСоединение.Open();
	//
	//ТекстЗапроса =
	//"IF OBJECT_ID('tempdb..#tabuidynom') IS NOT NULL
	//|DROP TABLE #tabuidynom
	//|;
	//|SELECT
	//|	[id_tov] as ID,
	//|	[UID] as UID
	//|INTO
	//|	#tabuidynom
	//|FROM [IzbenkaFin].[dbo].[ArticleBin2UID] (nolock)
	//|;
	//|SELECT
	//|	tabuidynom.UID as TovarUID,
	//|	CONVERT(REAL, [Amount]) as Amount,
	//|	CONVERT(REAL, [Price]) as Price,
	//|	RealOstatki.Period
	//|FROM [SMS_UNION].[dbo].[AccArticle] as RealOstatki (nolock)
	//| 	LEFT OUTER JOIN
	//| 		#tabuidynom as tabuidynom (nolock)
	//| 	ON RealOstatki.ID_tov = tabuidynom.ID
	//|WHERE
	//|	RealOstatki.Period >= '" + Формат(мДатаНачала, "ДФ='yyyy-MM-ddTHH:mm:ss'") + "'
	//|	AND RealOstatki.ID_TT IN (" + Формат(ЭтаФорма.ТорговаяТочка.id_TT, "ЧГ=0") + ")
	//|ORDER BY
	//|	RealOstatki.Period DESC
	//|;
	//|DROP TABLE
	//|	#tabuidynom";
	//
	//Выборка = ADOСоединение.Execute(ТекстЗапроса);
	//
	////
	//СпрНоменклатура = Справочники.Номенклатура;
	//
	//Пока НЕ Выборка = Неопределено Цикл
	//	Если Выборка.Fields.Count > 0 Тогда
	//		Пока НЕ Выборка.EOF Цикл
	//		
	//			ТекОстаток = Макс(Выборка.Fields("Amount").Value, 0);
	//			
	//			НоваяСтрока = ЭтаФорма.ТаблицаОстатков.Добавить();
	//			НоваяСтрока.Дата 		= Выборка.Fields("Period").Value;
	//			Если НЕ Выборка.Fields("TovarUID").Value = NULL Тогда
	//				НоваяСтрока.Номенклатура 	= СпрНоменклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Сред(Выборка.Fields("TovarUID").Value, 2, 36)));
	//			КонецЕсли;
	//			НоваяСтрока.Количество 	= ТекОстаток;
	//			НоваяСтрока.Цена 		= Выборка.Fields("Price").Value;
	//			НоваяСтрока.Сумма 		= ТекОстаток * НоваяСтрока.Цена;
	//		
	//			Если НЕ Выборка.EOF Тогда
	//				Выборка.MoveNext();
	//			КонецЕсли;
	//			
	//		КонецЦикла;
	//	КонецЕсли;
	//	Выборка = Выборка.NextRecordSet();
	//КонецЦикла;
	//
	//// ищем последний день, в котором были записи по торговой точке
	//Если ЭтаФорма.ТаблицаОстатков.Количество() = 0 Тогда
	//	
	//	ТекстЗапроса =
	//	"IF OBJECT_ID('tempdb..#tabuidynom') IS NOT NULL
	//	|DROP TABLE #tabuidynom
	//	|;
	//	|IF OBJECT_ID('tempdb..#tabmaxdata') IS NOT NULL
	//	|DROP TABLE #tabmaxdata
	//	|;
	//	|SELECT
	//	|	[id_tov] as ID,
	//	|	[UID] as UID
	//	|INTO
	//	|	#tabuidynom
	//	|FROM [IzbenkaFin].[dbo].[ArticleBin2UID] (nolock)
	//	|;
	//	|SELECT
	//	|	MAX(RealOstatki.Period) as Period
	//	|INTO
	//	|	#tabmaxdata
	//	|FROM [SMS_UNION].[dbo].[AccArticle] as RealOstatki (nolock)
	//	|WHERE
	//	|	RealOstatki.ID_TT IN (" + Формат(ЭтаФорма.ТорговаяТочка.id_TT, "ЧГ=0") + ")
	//	|;
	//	|SELECT
	//	|	tabuidynom.UID as TovarUID,
	//	|	CONVERT(REAL, [Amount]) as Amount,
	//	|	CONVERT(REAL, [Price]) as Price,
	//	|	RealOstatki.Period
	//	|FROM [SMS_UNION].[dbo].[AccArticle] as RealOstatki (nolock)
	//	| 	INNER JOIN
	//	| 		#tabmaxdata as tabmaxdata (nolock)
	//	| 	ON CONVERT(DATE, RealOstatki.Period) = CONVERT(DATE, tabmaxdata.Period)
	//	| 	LEFT OUTER JOIN
	//	| 		#tabuidynom as tabuidynom (nolock)
	//	| 	ON RealOstatki.ID_tov = tabuidynom.ID
	//	|WHERE
	//	|	RealOstatki.ID_TT IN (" + Формат(ЭтаФорма.ТорговаяТочка.id_TT, "ЧГ=0") + ")
	//	|ORDER BY
	//	|	RealOstatki.Period DESC
	//	|;
	//	|DROP TABLE
	//	|	#tabuidynom
	//	|;
	//	|DROP TABLE
	//	|	#tabmaxdata";
	//	Выборка = ADOСоединение.Execute(ТекстЗапроса);
	//	
	//	Пока НЕ Выборка = Неопределено Цикл
	//		Если Выборка.Fields.Count > 0 Тогда
	//			Пока НЕ Выборка.EOF Цикл
	//			
	//				ТекОстаток = Макс(Выборка.Fields("Amount").Value, 0);
	//				
	//				НоваяСтрока = ЭтаФорма.ТаблицаОстатков.Добавить();
	//				НоваяСтрока.Дата 		= Выборка.Fields("Period").Value;
	//				Если НЕ Выборка.Fields("TovarUID").Value = NULL Тогда
	//					НоваяСтрока.Номенклатура 	= СпрНоменклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Сред(Выборка.Fields("TovarUID").Value, 2, 36)));
	//				КонецЕсли;
	//				НоваяСтрока.Количество 	= ТекОстаток;
	//				НоваяСтрока.Цена 		= Выборка.Fields("Price").Value;
	//				НоваяСтрока.Сумма 		= ТекОстаток * НоваяСтрока.Цена;
	//			
	//				Если НЕ Выборка.EOF Тогда
	//					Выборка.MoveNext();
	//				КонецЕсли;
	//				
	//			КонецЦикла;
	//		КонецЕсли;
	//		Выборка = Выборка.NextRecordSet();
	//	КонецЦикла;
	//	
	//КонецЕсли;
	//ADOСоединение.Close();
	//
	////
	//ВремТаблица = ЭтаФорма.ТаблицаОстатков.Выгрузить(, "Дата, Сумма");
	//ВремТаблица.Свернуть("Дата", "Сумма");
	//
	//ЭтаФорма.ТаблицаСумм.Загрузить(ВремТаблица);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОстатковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Дата", Элемент.ТекущиеДанные.Дата);
	СтрокиТаблицыОстатков = ЭтаФорма.ТаблицаОстатков.НайтиСтроки(СтруктураОтбора);
	
	МассивСтрок = Новый Массив;
	Для Каждого СтрокаТаблицы Из СтрокиТаблицыОстатков Цикл
		
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Дата"			, ТекущаяДата());
		СтруктураСтроки.Вставить("ТорговаяТочка", ЭтаФорма.ТорговаяТочка);
		СтруктураСтроки.Вставить("Номенклатура"	, СтрокаТаблицы.Номенклатура);
		СтруктураСтроки.Вставить("Количество"	, СтрокаТаблицы.Количество);
		
		МассивСтрок.Добавить(СтруктураСтроки);
		
	КонецЦикла;
	
	
	ЭтаФорма.Закрыть(МассивСтрок);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.ТорговаяТочка = ЭтаФорма.Параметры.ТорговаяТочка;
	
	ЗаполнитьТаблицыОстатков();
	
КонецПроцедуры
