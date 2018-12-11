
//+++АК LATV 2018.10.11 ИП-00020131
Функция ПолучитьТаблицуДанных(ТекстДатаНачала, ТекстДатаОкончания, Текстid_TT, Текстid_tov) Экспорт

	// получение таблицы из SQL
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	ADOСоединение.ConnectionString  = ОбменСAccess.ПолучитьСтрокуСоединения("SMS_Izbenka");
	ADOСоединение.Open();
	
	ТекстЗапроса =
	"If OBJECT_ID('tempdb..#VT_Raspred') is not null		Drop table #VT_Raspred
	|If OBJECT_ID('tempdb..#VT_Raspred_Ob') is not null		Drop table #VT_Raspred_Ob
	|If OBJECT_ID('tempdb..#VT_Raspred_Ob2') is not null	Drop table #VT_Raspred_Ob2
	//+++shae 2018.11.25 ИП-00020348.01  
	|If OBJECT_ID('tempdb..#VT_RaspredSum') is not null		Drop table #VT_RaspredSum
	//+++shae 2018.11.25 ИП-00020348.01    	
	|
	|-----------------------------------------------------------------------------------------------
	|Select
	|	Raspred.Number_r as Number_r,
	|	Raspred.Date_r as Date_r,
	|	Raspred.id_tov as id_tov,
	|	Raspred.id_kontr as id_kontr,
	|	Raspred.id_sklad as id_sklad,
	|	Raspred.Товар as Товар,
	|	Raspred.Произв as Производитель,
	|	Raspred.kolvo_korob as ВКоробке,
	//|	ISNULL(Raspred.ФО_ТТ, 0) as ОстатокНаУтро,
	|	Raspred.время as ВремяПоследнегоРаспределения,	
	|	ISNULL(Raspred.ПланПродаж1С, 0) as ПланПродаж,
	|	ISNULL(Raspred.МинОст, 0) as МинимальныйОстаток,
	//+++АК SHEP 2018.11.02 ИП-00020078.01
	//|  Raspred.ПлПр2Большее as МожетПродать,
	//|  ISNULL(Raspred.МаксОст, 0) as МаксимальныйОстаток,
	//|  Raspred.Нужно as Нужно,
	//|  Raspred.Распределено as Распределили,
	//|  SprNom._Fld239 as Весовой
	|  ISNULL(Raspred.ПлПр2Большее, 0) as МожетПродать,
	|  ISNULL(Raspred.МаксОст, 0) as МаксимальныйОстаток,
	|  ISNULL(Raspred.Нужно, 0) as Нужно,
	|  ISNULL(Raspred.Распределено, 0) as Распределили,
	//+++АК mika 2018.11.13 ИП-00020348
	//|  ISNULL(Raspred.ФО_ТТ_init, 0) as Собрано,
	//---АК mika 
	//|  SprNom._Fld239 as Весовой   
	//---АК SHEP 2018.11.02
	//+++shae 2018.11.25 ИП-00020348.01  
	|  ISNULL(Raspred.ФО_ТТ_init, 0) as ОстатокНаУтро,	
	|  ISNULL(Raspred.Собрано, 0) as Собрано,	
	|  Case when ISNULL(SprNom._Fld239, 0) = 1 then 1 else 0 end as Весовой
	//+++shae 2018.11.25 ИП-00020348.01  	
	|Into #VT_Raspred
	|From M2..Raspred_tov_tt_date_f(" + ТекстДатаНачала + ", " + ТекстДатаОкончания + ", " + ?(Текстid_tov = "", "NUll", Текстid_tov) + ", " + Текстid_TT + ") as Raspred
	| Left Join IzbenkaFin.._Reference29 as SprNom (nolock)
	| On SprNom._Fld760 = Raspred.id_tov
	//+++shae 2018.11.25 ИП-00020348.01  
	|WHERE ISNULL(Raspred.Собрано, 0) > 0
	//+++shae 2018.11.25 ИП-00020348.01    	
	|
	|-----------------------------------------------------------------------------------------------	
	|Select
	|	Raspred.Number_r as Number_r,
	|	Raspred.Date_r as Date_r,
	|	Raspred.id_tov as id_tov,
	|	Raspred.id_kontr as id_kontr,
	|	Raspred.id_sklad as id_sklad,
	|	ISNULL(Raspred.НужновсемТТ, 0) as Потребность,
	|	ISNULL(Raspred.ОстСклад, 0) as Наличие,
	//+++shae 2018.12.06 ИП-00020348.01  
	|	ISNULL(Raspred.Избыт, 0) as Излишек,
	|	ISNULL(Raspred.НехваткаКор, 0) as НедостачаКоробок,
	//---shae 2018.12.06 ИП-00020348.01 	
	|	ISNULL(Raspred.Склад, 0) as Склад
	|Into #VT_Raspred_Ob
	|From M2..Raspred_tov_date_itog_f(" + ТекстДатаНачала + ", " + ТекстДатаОкончания + ", " + ?(Текстid_tov = "", "NUll", Текстid_tov) + ") as Raspred
	|
	|-----------------------------------------------------------------------------------------------	
	|Select
	|	VT_Raspred_Ob.Date_r as Date_r,
	|	VT_Raspred_Ob.id_tov as id_tov,
	|	VT_Raspred_Ob.id_kontr as id_kontr,
	|	VT_Raspred_Ob.id_sklad as id_sklad,
	|	VT_Raspred_Ob.Потребность as Потребность,
	|	VT_Raspred_Ob.Наличие as Наличие,
	//+++shae 2018.12.06 ИП-00020348.01  
	|	VT_Raspred_Ob.Излишек as Излишек,
	|	VT_Raspred_Ob.НедостачаКоробок as НедостачаКоробок,
	//---shae 2018.12.06 ИП-00020348.01 	
	|	VT_Raspred_Ob.Склад
	|Into #VT_Raspred_Ob2
	|From #VT_Raspred_Ob as VT_Raspred_Ob
	| Inner Join
	|	(Select
	|		VT_Raspred.Date_r as Date_r,
	|		VT_Raspred.id_tov as id_tov,
	|		VT_Raspred.id_kontr as id_kontr,
	|		VT_Raspred.id_sklad as id_sklad,
	|		MAX(VT_Raspred.Number_r) as Number_r
	|	From #VT_Raspred_Ob as VT_Raspred
	|	Group by
	|		VT_Raspred.Date_r,
	|		VT_Raspred.id_tov,
	|		VT_Raspred.id_kontr,
	|		VT_Raspred.id_sklad) as MaxNumbers
	| On MaxNumbers.Date_r = VT_Raspred_Ob.Date_r
	|	And MaxNumbers.id_tov = VT_Raspred_Ob.id_tov	
	|	And MaxNumbers.id_kontr = VT_Raspred_Ob.id_kontr	
	|	And MaxNumbers.id_sklad = VT_Raspred_Ob.id_sklad	
	|	And MaxNumbers.Number_r = VT_Raspred_Ob.Number_r	
	|
	//+++АК SHEP 2018.10.29 ИП-00020078
	//-----------------------------------------------------------------------------------------------	
	//SELECT
	//	DATEADD(YEAR, -2000, CAST(TovaryNaSkladah._Period AS DATE)) as date,
	//	Rashodniki._IDRRef,
	//	TovaryNaSkladah._Fld3246RRef AS Sklad,
	//	--TovaryNaSkladah._Fld3247RRef
	//	VT_Raspred.id_tov AS id_tov,
	//	TovaryNaSkladah._Fld3250 AS Kvo
	//FROM IzbenkaFin.._AccumRg3245 AS TovaryNaSkladah (NOLOCK)
	//	INNER JOIN IzbenkaFin.._Document3034 AS Rashodniki (NOLOCK)
	//		ON TovaryNaSkladah._RecorderRRef = Rashodniki._IDRRef
	//	INNER JOIN IzbenkaFin.._Reference42 AS SprStrEd (NOLOCK)
	//		ON Rashodniki._Fld3090_RRRef = SprStrEd._IDRRef

	//WHERE
	//	TovaryNaSkladah._Period between '40181023' AND '40181029'
	//	AND TovaryNaSkladah._Active = 1
	//	AND SprStrEd._Fld758 = 

	//Помещаем во временную таблицу, потом делаем UNION ALL
	//---АК SHEP 2018.10.29
	//+++shae 2018.11.25 ИП-00020348.01  
	|-----------------------------------------------------------------------------------------------	
	|Select
	|	Raspred.id_tov,
	|	Raspred.Date_r,
	|	Min(Raspred.ОстатокНаУтро) as ОстатокНаУтро,
	|	Sum(Raspred.Нужно) as Нужно,
	|	Sum(Raspred.Собрано) as Собрано,
	|	Sum(Raspred.Распределили) as Распределили
	|Into #VT_RaspredSum
	|From #VT_Raspred as Raspred (nolock)
	| Group by
	|		Raspred.Date_r,
	|		Raspred.id_tov	
	| 
	//---shae 2018.11.25 ИП-00020348.01  	
	|-----------------------------------------------------------------------------------------------	
	|Select
	|	Raspred.Товар as Товар,
	|	Convert(Date, Raspred.Date_r) as Дата,
	|	Raspred.Производитель as Производитель,
	|	Raspred.ВКоробке as ВКоробке,
	//|	Raspred.ОстатокНаУтро as ОстатокНаУтро,
	|	Raspred.ПланПродаж as ПланПродаж,
	|	Raspred.МинимальныйОстаток as МинимальныйОстаток,
	|	Raspred.МожетПродать as МожетПродать,
	|	Raspred.МаксимальныйОстаток as МаксимальныйОстаток,
	//|	Raspred.Нужно as Нужно,
	//|	Raspred.Распределили as Распределили,
	//+++shae 2018.11.25 ИП-00020348.01  
	|	Raspred.ВремяПоследнегоРаспределения as ВремяПоследнегоРаспределения,
	|	RaspredSum.ОстатокНаУтро as ОстатокНаУтро,
	|	RaspredSum.Нужно as Нужно,
	|	RaspredSum.Распределили as Распределили,
	|  	RaspredSum.Собрано as ОтгрузилиСоСклада,
	//---shae 2018.11.25 ИП-00020348.01	
	//+++АК mika 2018.11.13 ИП-00020348   //+++shae 2018.11.25 ИП-00020348.01  убрать поле Собрано
	//|  	Raspred.Собрано as Собрано,
	//---АК mika 
	|	Raspred.Весовой as Весовой,
	|	Convert(real, IsNull(Raspred_Ob.Потребность, 0)) as ПотребностьСклад,
	|	Convert(real, IsNull(Raspred_Ob.Наличие, 0)) as НаличиеСклад,
	//+++shae 2018.12.06 ИП-00020348.01  
	|	Convert(real, IsNull(Raspred_Ob.НедостачаКоробок, 0)) as НедостачаКоробокСклад,
	|	Convert(real, IsNull(Raspred_Ob.Излишек, 0)) as ИзлишекСклад,	
	//---shae 2018.12.06 ИП-00020348.01 	
	|	IsNull(Raspred_Ob.Склад, '') as Склад
	|From #VT_Raspred as Raspred (nolock)
	| Inner Join
	|	(Select
	|		VT_Raspred.Date_r as Date_r,
	|		VT_Raspred.id_tov as id_tov,
	|		MAX(VT_Raspred.Number_r) as Number_r
	|	From #VT_Raspred as VT_Raspred
	|	Group by
	|		VT_Raspred.Date_r,
	|		VT_Raspred.id_tov) as MaxNumbers
	| On MaxNumbers.Date_r = Raspred.Date_r
	|	And MaxNumbers.id_tov = Raspred.id_tov	
	|	And MaxNumbers.Number_r = Raspred.Number_r
	//+++shae 2018.11.25 ИП-00020348.01  
	| Inner Join #VT_RaspredSum as RaspredSum
	| On RaspredSum.Date_r = Raspred.Date_r
	|	And RaspredSum.id_tov = Raspred.id_tov	
	//---shae 2018.11.25 ИП-00020348.01 	
	| Left Join #VT_Raspred_Ob2 as Raspred_Ob
	| On Raspred_Ob.Date_r = Raspred.Date_r
	|	And Raspred_Ob.id_tov = Raspred.id_tov	
	|	And Raspred_Ob.id_kontr = Raspred.id_kontr	
	|	And Raspred_Ob.id_sklad = Raspred.id_sklad	
	| 
	|-----------------------------------------------------------------------------------------------
	|Drop table #VT_Raspred
	//+++shae 2018.11.25 ИП-00020348.01  
	|Drop table #VT_RaspredSum
	//---shae 2018.11.25 ИП-00020348.01 		
	|Drop table #VT_Raspred_Ob
	|Drop table #VT_Raspred_Ob2";
	
	Выборка = ADOСоединение.Execute(ТекстЗапроса);
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("Товар"				, Новый ОписаниеТипов("Строка"));
	ТаблицаДанных.Колонки.Добавить("Дата"				, Новый ОписаниеТипов("Дата"));
	ТаблицаДанных.Колонки.Добавить("Производитель"		, Новый ОписаниеТипов("Строка"));
	ТаблицаДанных.Колонки.Добавить("ВКоробке"			, Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("ОстатокНаУтро"		, Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("ПланПродаж"			, Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("МинимальныйОстаток"	, Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("МожетПродать"		, Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("МаксимальныйОстаток", Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("Нужно"				, Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("Распределили"		, Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("Склад"				, Новый ОписаниеТипов("Строка"));
	ТаблицаДанных.Колонки.Добавить("ПотребностьСклад"	, Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("НаличиеСклад"		, Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("ОтгрузилиСоСклада"	, Новый ОписаниеТипов("Число")); //+++АК SHEP 2018.10.29 ИП-00020078
	//ТаблицаДанных.Колонки.Добавить("Собрано"     		, Новый ОписаниеТипов("Число")); //+++АК mika 2018.11.13 ИП-00020348      //+++shae 2018.11.25 ИП-00020348.01 убрать поле
	//+++shae 2018.12.06 ИП-00020348.01  
	ТаблицаДанных.Колонки.Добавить("ИзлишекСклад"					, Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("НедостачаКоробокСклад"			, Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("ВремяПоследнегоРаспределения"	, Новый ОписаниеТипов("Дата",,,,,Новый КвалификаторыДаты(ЧастиДаты.Время)));
	//---shae 2018.12.06 ИП-00020348.01 
	
	Пока НЕ Выборка = Неопределено Цикл
		Если Выборка.Fields.Count > 0 Тогда
			Пока НЕ Выборка.EOF Цикл
				
				ПорядокОкругления = ?(Выборка.Fields("Весовой").Value = 1, 3, 0);
				
				НоваяСтрока = ТаблицаДанных.Добавить();
				ТекДата = Выборка.Fields("Дата").Value;
				НоваяСтрока.Дата 				= Дата(Лев(ТекДата, 4), Сред(ТекДата, 6, 2), Прав(ТекДата, 2));
				НоваяСтрока.Товар 				= СокрЛП(Выборка.Fields("Товар").Value);
				НоваяСтрока.Производитель 		= СокрЛП(Выборка.Fields("Производитель").Value);
				НоваяСтрока.ВКоробке 			= Окр(Выборка.Fields("ВКоробке").Value				, ПорядокОкругления);
				НоваяСтрока.ОстатокНаУтро 		= Окр(Выборка.Fields("ОстатокНаУтро").Value			, ПорядокОкругления);
				НоваяСтрока.ПланПродаж 			= Окр(Выборка.Fields("ПланПродаж").Value			, ПорядокОкругления);
				НоваяСтрока.МинимальныйОстаток 	= Окр(Выборка.Fields("МинимальныйОстаток").Value	, ПорядокОкругления);
				НоваяСтрока.МожетПродать 		= Окр(Выборка.Fields("МожетПродать").Value			, ПорядокОкругления);
				НоваяСтрока.МаксимальныйОстаток = Окр(Выборка.Fields("МаксимальныйОстаток").Value	, ПорядокОкругления);
				НоваяСтрока.Нужно 				= Окр(Выборка.Fields("Нужно").Value					, ПорядокОкругления);
				НоваяСтрока.Распределили 		= Окр(Выборка.Fields("Распределили").Value			, ПорядокОкругления);
				НоваяСтрока.Склад			 	= Выборка.Fields("Склад").Value;
				НоваяСтрока.ПотребностьСклад 	= Окр(Выборка.Fields("ПотребностьСклад").Value		, ПорядокОкругления);
				НоваяСтрока.НаличиеСклад 		= Окр(Выборка.Fields("НаличиеСклад").Value			, ПорядокОкругления);
				НоваяСтрока.ОтгрузилиСоСклада	= Окр(Выборка.Fields("ОтгрузилиСоСклада").Value		, ПорядокОкругления); //+++АК SHEP 2018.10.29 ИП-00020078           //+++shae 2018.11.25 ИП-00020348.01 вернуть поле
				//НоваяСтрока.Собрано		 		= Окр(Выборка.Fields("Собрано").Value				, ПорядокОкругления); //+++АК mika 2018.11.13 ИП-00020348      //+++shae 2018.11.25 ИП-00020348.01 убрать поле
				//+++shae 2018.12.06 ИП-00020348.01  
				НоваяСтрока.ИзлишекСклад 			= Окр(Выборка.Fields("ИзлишекСклад").Value			, ПорядокОкругления);
				НоваяСтрока.НедостачаКоробокСклад 	= Окр(Выборка.Fields("НедостачаКоробокСклад").Value	, ПорядокОкругления);	
				ВремяПоследнегоРаспределения 		= Лев(Выборка.Fields("ВремяПоследнегоРаспределения").Value,8);
				Если НЕ ПустаяСтрока(ВремяПоследнегоРаспределения) Тогда 
					НоваяСтрока.ВремяПоследнегоРаспределения = Дата("00010101" + Лев(ВремяПоследнегоРаспределения, 2)+ Сред(ВремяПоследнегоРаспределения, 4, 2)+ Прав(ВремяПоследнегоРаспределения, 2));
				КонецЕсли;
				//---shae 2018.12.06 ИП-00020348.01 
				
				Если НЕ Выборка.EOF Тогда
					Выборка.MoveNext();
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		Выборка = Выборка.NextRecordSet();
	КонецЦикла;
	
	ADOСоединение.Close();
	
	Возврат ТаблицаДанных;

КонецФункции
