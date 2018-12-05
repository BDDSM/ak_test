
Функция ПолучитьДанныеДляФормирования(мДатаРаспределения, мРасчетчик, мСклад, ДнейПродажВГруппировке, ГлубинаАнализаПродаж,
										ВыводитьТТМиниТТПусто = Ложь, ВыводитьТолькоВВ = Ложь, ИспользоватьНормативныйКвантДляРасчетаПлановогоОстатка = Истина) Экспорт
	
	мТипЧисло = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(12, 3));
	
	ТекстДаты 			= "'4" + Сред(СтрЗаменить(Формат(мДатаРаспределения, "ДФ=""гггг ММ дд"""), " ", ""), 2) + "'";
	ТекстУИДРасчетчик 	= "'" + Строка(мРасчетчик.УникальныйИдентификатор()) 	+ "'";
	ТекстУИДСклад 		= "'" + Строка(мСклад.УникальныйИдентификатор()) 		+ "'";
	ТекстГлубинаПродаж 	= Формат(ГлубинаАнализаПродаж, "ЧГ=");
	КолПериодов = ?(ДнейПродажВГруппировке > 0, Окр(ГлубинаАнализаПродаж / ДнейПродажВГруппировке), 0);
	Если КолПериодов = 0 Тогда
		КолПериодов = 1;
	КонецЕсли;
	ТекстКолПериодов 	= Формат(КолПериодов, "ЧГ=");
	
	ТекстОтбораТТ = "";
	Если ВыводитьТТМиниТТПусто Тогда
		ТекстОтбораТТ = ТекстОтбораТТ + "
	|		And Not Spr_StrEd._Fld7064RRef = 0xBBA026EBE525FFB34FA7C41108394DF6";
	ИначеЕсли ВыводитьТолькоВВ Тогда
		ТекстОтбораТТ = ТекстОтбораТТ + "
	|		And Spr_StrEd._Fld7064RRef = 0xBBA026EBE525FFB34FA7C41108394DF6";
	КонецЕсли;
	
	ТаблицаДанные = Новый ТаблицаЗначений;
	ТаблицаДанные.Колонки.Добавить("Поставщик"				, Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ТаблицаДанные.Колонки.Добавить("ТорговаяТочка"			, Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ТаблицаДанные.Колонки.Добавить("Номенклатура"			, Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДанные.Колонки.Добавить("МинимальныйОстаток"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ФактическийОстаток"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("Распределено"			, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПланПродаж"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ_"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ2"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ2_"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ3"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ3_"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ4"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ4_"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ5"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ5_"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ6"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ6_"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокРасчетный"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокУРЗ"				, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокНаКонецДня"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокПередСледЗаказом", мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ФактПродаж"								, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ОстатокПослеРаспределения"				, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокПередСледНеразмЗаказом"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоТТСОграничением05"			, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокДняРазмещения"			, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ФактПродажДнейРазмещения"				, мТипЧисло);
	
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	ADOСоединение.ConnectionString  = ОбменСAccess.ПолучитьСтрокуСоединения("SMS_Izbenka");
	ADOСоединение.Open();
	
	ТекстЗапроса =
	"Declare @UID_Raschetchik nvarchar(36), @UID_Sklad nvarchar(36), @DateRaspr datetime, @DateNach datetime, @DateKon datetime, @DatePost datetime, @DateRasprPlus1 datetime, @DateRasprPlus2 datetime, @DateRasprPlus3 datetime, @DateRasprPlus4 datetime, @DateRasprPlus5 datetime, @DatePartRaspr int, @Binary_Sklad binary(16) 
	|
	|Set @UID_Raschetchik	= " + ТекстУИДРасчетчик + "			-- расчетчик
	|Set @UID_Sklad			= " + ТекстУИДСклад + "				-- структурная единица - склад расчетчика
	|Set @Binary_Sklad       = master.dbo.UID2Binary(@UID_Sklad)
	|Set @DateRaspr			= " + ТекстДаты + "
	|Set @DateNach			= DateAdd(Year, -2000, DateAdd(Day, -" + ТекстГлубинаПродаж + ", @DateRaspr))
	|Set @DateKon			= DateAdd(Year, -2000, @DateRaspr - 1) 											-- + 86399)
	|Set @DatePost			= DateAdd(Day, -1, @DateRaspr)
	|Set @DateRasprPlus1	= DateAdd(Day, 1, @DateRaspr)
	|Set @DateRasprPlus2	= DateAdd(Day, 2, @DateRaspr)
	|Set @DateRasprPlus3	= DateAdd(Day, 3, @DateRaspr)
	|Set @DateRasprPlus4	= DateAdd(Day, 4, @DateRaspr)
	|Set @DateRasprPlus5	= DateAdd(Day, 5, @DateRaspr)
	|Set @DatePartRaspr		= DatePart(DW, @DateRaspr)
	|
	|If OBJECT_ID('tempdb..#VTProizvoditeli') is not null			Drop Table #VTProizvoditeli
	|If OBJECT_ID('tempdb..#Dostupnaya_Nom') is not null			Drop Table #Dostupnaya_Nom
	|If OBJECT_ID('tempdb..#Polnye_Analogi') is not null			Drop Table #Polnye_Analogi
	|If OBJECT_ID('tempdb..#Nom_I_Analogi') is not null				Drop Table #Nom_I_Analogi
	|If OBJECT_ID('tempdb..#VT_tt') is not null						Drop Table #VT_tt
	|If OBJECT_ID('tempdb..#VT_Assortiment') is not null			Drop Table #VT_Assortiment
	|If OBJECT_ID('tempdb..#VT_PredZakazy') is not null				Drop Table #VT_PredZakazy
	|If OBJECT_ID('tempdb..#VTOstatkiNaSklade') is not null			Drop Table #VTOstatkiNaSklade
	|If OBJECT_ID('tempdb..#VT_Daty_Postavki') is not null			Drop Table #VT_Daty_Postavki
	|If OBJECT_ID('tempdb..#VT_Fact_Prodaj_Mejdu') is not null		Drop Table #VT_Fact_Prodaj_Mejdu
	|If OBJECT_ID('tempdb..#VT_Fact_Prodaj') is not null			Drop Table #VT_Fact_Prodaj
	|If OBJECT_ID('tempdb..#VT_Osnovnaya') is not null				Drop Table #VT_Osnovnaya
	|If OBJECT_ID('tempdb..#VTKolVUpakovke') is not null			Drop Table #VTKolVUpakovke
	//+++АК KIRN 2018.07.31 ИП-00012852.07
	|If OBJECT_ID('tempdb..#KvantUp') is not null					Drop Table #KvantUp
	|If OBJECT_ID('tempdb..#KvantUpMax') is not null				Drop Table #KvantUpMax
	//---АК KIRN 
	|If OBJECT_ID('tempdb..#VT_Predyduschiy_PredZakaz') is not null	Drop Table #VT_Predyduschiy_PredZakaz
	|
	|
	|-----------------------------------------------------------------------------------------------
	|Select
	|	RegZnach_Svoistv._Fld394_RRRef as Harakteristika,
	|	SprKontr._IDRRef as kontr,
	|	SprKontr._Fld1159 as id_kontr
	|Into #VTProizvoditeli
	|From IzbenkaFin.._InfoRg393 as RegZnach_Svoistv (nolock)
	| Left Outer Join IzbenkaFin.._Reference27 as SprKontr (nolock)			-- производитель
	| On SprKontr._IDRRef = RegZnach_Svoistv._Fld396_RRRef
	|Where
	|	RegZnach_Svoistv._Fld395RRef = 0x9B0FBEA8EE4FEDDB4CAF6656F51808B7   -- свойство <Производитель>
	|	And SprKontr._IDRRef is not null
	|
	|-------------------------------------------------------------------------------------
	|Select Distinct
	|	TovaryAnalogov._Reference6042_IDRRef as Analog,
	|	TovaryAnalogov._Fld6045RRef as Tovar
	|Into #Polnye_Analogi
	|From IzbenkaFin.._Reference6042_VT6043 as TovaryAnalogov (nolock)
	| Inner Join izbenkafin.._Reference6042 as Analogi (nolock)
	| On Analogi._IDRRef = TovaryAnalogov._Reference6042_IDRRef
	|	 And Analogi._Fld7463 = 1                                           -- полностью заменяемый товар
	|	 And Analogi._Marked = 0
	| Left Join IzbenkaFin.._Reference3030_VT3047 as Nom_Raschetchikov (nolock)
	| On Nom_Raschetchikov._Fld3049RRef = TovaryAnalogov._Fld6045RRef
	|	And CAST(master.dbo.Binary2UID(Nom_Raschetchikov._Reference3030_IDRRef) as nvarchar(36)) = @UID_Raschetchik
	|Where
	|	Nom_Raschetchikov._Fld3049RRef is not null
	|
	|-------------------------------------------------------------------------------------
	|Select
	|	SprNom._IDRRef as Tovar,
	|	SprNom._Fld760 as id_tov,
	|	SprNom._Fld5162RRef as GruppaURZ
	|Into #Dostupnaya_Nom
	|From IzbenkaFin.._Reference29 as SprNom (nolock)
	| Left Join IzbenkaFin.._Reference3030_VT3047 as Nom_Raschetchikov (nolock)
	| On Nom_Raschetchikov._Fld3049RRef = SprNom._IDRRef
	|	And CAST(master.dbo.Binary2UID(Nom_Raschetchikov._Reference3030_IDRRef) as nvarchar(36)) = @UID_Raschetchik
	|Where
	|	SprNom._Marked = 0
	|	And Nom_Raschetchikov._Fld3049RRef is not null
	|
	|-------------------------------------------------------------------------------------
	|Select
	|	Dostupnaya_Nom.Tovar as Tovar,
	|	Dostupnaya_Nom.id_tov as id_tov,
	|	Dostupnaya_Nom.GruppaURZ as GruppaURZ
	|Into #Nom_I_Analogi
	|From #Dostupnaya_Nom as Dostupnaya_Nom (nolock)
	|
	|Union
	|
	|Select
	|	SprNom._IDRRef,
	|	SprNom._Fld760,
	|	SprNom._Fld5162RRef
	|From IzbenkaFin.._Reference6042_VT6043 as TovaryAnalogov (nolock)
	| Inner Join #Polnye_Analogi as Polnye_Analogi (nolock)
	| On Polnye_Analogi.Analog = TovaryAnalogov._Reference6042_IDRRef
	| 	 And Not Polnye_Analogi.Tovar = TovaryAnalogov._Fld6045RRef
	| Inner Join IzbenkaFin.._Reference29 as SprNom (nolock)
	| On SprNom._IDRRef = TovaryAnalogov._Fld6045RRef
	|	 And SprNom._Marked = 0
	|
	|-------------------------------------------------------------------------------------
	|Select Distinct
	|	Poryadok_Obespecheniya._Fld2726RRef as TT
	|Into #VT_tt
	|From IzbenkaFin.dbo._InfoRg2725 as Poryadok_Obespecheniya (nolock)
	|	Left Outer Join IzbenkaFin.._Reference42 as Spr_StrEd (nolock)
	|	On Spr_StrEd._IDRRef = Poryadok_Obespecheniya._Fld2726RRef
	|		And Spr_StrEd._Fld2757 = 1" + ТекстОтбораТТ + "
	|	Left Outer Join #Dostupnaya_Nom as Dostupnaya_Nom
	|	On Dostupnaya_Nom.GruppaURZ = Poryadok_Obespecheniya._Fld5207RRef
	|	Left Outer Join (
	|		Select
	|			Poryadok_Obespecheniya._Fld2726RRef,
	|			Poryadok_Obespecheniya._Fld5207RRef,
	|			Max(Poryadok_Obespecheniya._Period) as _Period
	|		From IzbenkaFin.dbo._InfoRg2725 as Poryadok_Obespecheniya (nolock)
	|		Where
	|			Poryadok_Obespecheniya._Period < @DateRasprPlus1
	|		Group By
	|			Poryadok_Obespecheniya._Fld2726RRef,
	|			Poryadok_Obespecheniya._Fld5207RRef) as MaxPeriody
	|	On MaxPeriody._Fld2726RRef = Poryadok_Obespecheniya._Fld2726RRef
	|		And MaxPeriody._Fld5207RRef = Poryadok_Obespecheniya._Fld5207RRef
	|		And MaxPeriody._Period = Poryadok_Obespecheniya._Period
	|Where
	|	CAST(master.dbo.Binary2UID(Poryadok_Obespecheniya._Fld2728RRef) as nvarchar(36)) = @UID_Sklad
	|	And Dostupnaya_Nom.GruppaURZ is not null
	|	And Spr_StrEd._IDRRef is not null
	|	And MaxPeriody._Fld2726RRef is not null
	|
	|-------------------------------------------------------------------------------------
	|Select
	|	Tov_Assortiment._Fld3958RRef as TT,
	|	Tov_Assortiment._Fld3959RRef as Tovar,
	|	Tov_Assortiment._Fld3960RRef as Har
	|Into #VT_Assortiment
	|From IzbenkaFin.dbo._InfoRg3957 as Tov_Assortiment (nolock)
	| Inner Join (
	|		Select
	|			Tov_Assortiment._Fld3958RRef,
	|			Tov_Assortiment._Fld3959RRef,
	|			Max(Tov_Assortiment._Period) as _Period
	|		From IzbenkaFin.dbo._InfoRg3957 as Tov_Assortiment (nolock)
	|		 Left Outer Join #Dostupnaya_Nom as Dostupnaya_Nom
	|		 On Dostupnaya_Nom.Tovar = Tov_Assortiment._Fld3959RRef
	|		 Left Outer Join #VT_tt as VT_tt
	|		 On VT_tt.TT = Tov_Assortiment._Fld3958RRef
	|		Where
	|			Tov_Assortiment._Period < @DateRasprPlus1 
	|			And Dostupnaya_Nom.Tovar is not null
	|			And VT_tt.TT is not null
	|		Group By
	|			Tov_Assortiment._Fld3958RRef,
	|			Tov_Assortiment._Fld3959RRef) as MaxPeriody
	| On MaxPeriody._Fld3958RRef = Tov_Assortiment._Fld3958RRef
	|    And MaxPeriody._Fld3959RRef = Tov_Assortiment._Fld3959RRef
	|	 And MaxPeriody._Period = Tov_Assortiment._Period
	|Where
	|	Tov_Assortiment._Fld3961 = 0
	|
	|-------------------------------------------------------------------------------------
	|Select
	|	Predzakaz_Tovary._Fld3065RRef as TT,
	|	Predzakaz_Tovary._Fld3066RRef as Tovar,
	|	Predzakazy._Fld5314RRef as grafik,
	|	Predzakazy._Fld3058 as date_post,
	|	Predzakazy._Fld3060 as podgotovlen,
	|	Predzakazy._Posted as proveden,
	|	Predzakaz_Tovary._Fld3067 as kol,
	|	CASE
	|		WHEN Predzakazy._Fld3060 = 0
	|			THEN Predzakaz_Tovary._Fld3067
	|		ELSE 0
	|	END as Kol_
	|Into #VT_PredZakazy
	|From IzbenkaFin.._Document3032_VT3063 as Predzakaz_Tovary (nolock)
	| Inner Join IzbenkaFin.._Document3032 as Predzakazy (nolock)
	| On Predzakazy._IDRRef = Predzakaz_Tovary._Document3032_IDRRef
	|	And CAST(master.dbo.Binary2UID(Predzakazy._Fld3057RRef) as nvarchar(36)) = @UID_Sklad
	|	And Not Predzakazy._Fld3058 < @DateRaspr
	|	And Predzakazy._Marked = 0
	|
	|-----------------------------------------------------------------------------------------------
	|Select
	|	a.tovar as tovar,
	|	a.Har as Har,
	|	SUM(a.kol) as kol
	|Into #VTOstatkiNaSklade
	|From (
	|	Select
	|		ostatki._Fld3247RRef as tovar,
	|		ostatki._Fld3248RRef as Har,
	|		ostatki._Fld3250 as kol
	|	From IzbenkaFin.._AccumRgT3252 as ostatki (nolock)
	|	 Inner Join IzbenkaFin.._Reference1321 as Spr_Sklady (nolock)
	|	 On Spr_Sklady._IDRRef = ostatki._Fld3246RRef
	|		And CAST(master.dbo.Binary2UID(Spr_Sklady._OwnerIDRRef) as nvarchar(36)) = @UID_Sklad
	|		And Spr_Sklady._Fld3349RRef = 0x82E78E1B537199464DCC4500C55630FF			-- вид склада = Оптовый
	|	 Left Outer Join #Dostupnaya_Nom as Dostupnaya_Nom
	|	 On Dostupnaya_Nom.Tovar = ostatki._Fld3247RRef
	|	Where
	|		ostatki._Period = '59991101'
	|		And Dostupnaya_Nom.Tovar is not null
	|	Union all
	|	Select
	|		ostatki._Fld7256RRef,
	|		ostatki._Fld7257RRef,
	|		-ostatki._Fld7259
	|	From IzbenkaFin.._AccumRgT7261 as ostatki (nolock)         						-- отнимаются остатки по заданиям на перемещение
	|	 Inner Join IzbenkaFin.._Document7234 as Doc_Zadanie (nolock)				
	|	 On Doc_Zadanie._IDRRef = ostatki._Fld7255RRef
	|	 Inner Join IzbenkaFin.._Reference1321 as Spr_Sklady (nolock)
	|	 On Spr_Sklady._IDRRef = Doc_Zadanie._Fld7235RRef
	|		And CAST(master.dbo.Binary2UID(Spr_Sklady._OwnerIDRRef) as nvarchar(36)) = @UID_Sklad
	|	 Left Outer Join #Dostupnaya_Nom as Dostupnaya_Nom
	|	 On Dostupnaya_Nom.Tovar = ostatki._Fld7256RRef
	|	Where
	|		ostatki._Period = '59991101'
	|		And Dostupnaya_Nom.Tovar is not null
	|	Union all
	|	Select
	|		Reg_Tovary._Fld3247RRef,
	|		Reg_Tovary._Fld3248RRef,
	|		CASE WHEN Reg_Tovary._RecordKind = 0 THEN -Reg_Tovary._Fld3250 ELSE Reg_Tovary._Fld3250 END
	|	From IzbenkaFin.._AccumRg3245 as Reg_Tovary (nolock)
	|	 Inner Join IzbenkaFin.._Reference1321 as Spr_Sklady (nolock)
	|	 On Spr_Sklady._IDRRef = Reg_Tovary._Fld3246RRef
	|		And CAST(master.dbo.Binary2UID(Spr_Sklady._OwnerIDRRef) as nvarchar(36)) = @UID_Sklad
	|		And Spr_Sklady._Fld3349RRef = 0x82E78E1B537199464DCC4500C55630FF			-- вид склада = Оптовый
	|	 Left Outer Join #Dostupnaya_Nom as Dostupnaya_Nom
	|	 On Dostupnaya_Nom.Tovar = Reg_Tovary._Fld3247RRef
	|	Where
	|		Reg_Tovary._Period >= @DateRaspr
	|		And Dostupnaya_Nom.Tovar is not null
	|	Union all
	|	Select
	|		Reg_Zadaniya._Fld7256RRef,
	|		Reg_Zadaniya._Fld7257RRef,
	|		CASE WHEN Reg_Zadaniya._RecordKind = 0 THEN Reg_Zadaniya._Fld7259 ELSE -Reg_Zadaniya._Fld7259 END
	|	From IzbenkaFin.._AccumRg7254 as Reg_Zadaniya (nolock)
	|	 Inner Join IzbenkaFin.._Document7234 as Doc_Zadanie (nolock)				
	|	 On Doc_Zadanie._IDRRef = Reg_Zadaniya._Fld7255RRef
	|	 Inner Join IzbenkaFin.._Reference1321 as Spr_Sklady (nolock)
	|	 On Spr_Sklady._IDRRef = Doc_Zadanie._Fld7235RRef
	|		And CAST(master.dbo.Binary2UID(Spr_Sklady._OwnerIDRRef) as nvarchar(36)) = @UID_Sklad
	|	 Left Outer Join #Dostupnaya_Nom as Dostupnaya_Nom
	|	 On Dostupnaya_Nom.Tovar = Reg_Zadaniya._Fld7256RRef
	|	Where
	|		Reg_Zadaniya._Period >= @DateRaspr
	|		And Dostupnaya_Nom.Tovar is not null) as a
	|Group by
	|	a.tovar,
	|	a.Har
	|Having
	|	not SUM(a.kol) = 0
	|
	|-------------------------------------------------------------------------------------
	|Select
	|    a.Kontr as Kontr,
	|    Grafiki_Tovary._Fld3487RRef as Tovar,
	|    a.KolNedel as KolNedel,
	|    ISNULL(Daty_PredZakazy.date_post, a.date_post) as date_post,
	|    DatePart(DW, ISNULL(Daty_PredZakazy.date_post, a.date_post)) as day_of_date_post,
	|    Case
	|    	When DateAdd(Week, -(a.KolNedel + 1), @DateRaspr) > @DateNach
	|      	Then DateAdd(Week, -(a.KolNedel + 1), @DateRaspr)
	|      	Else @DateNach
	|    End as date_nach 
	|Into #VT_Daty_Postavki
	|From
	|	(Select
	|	    Spr_Grafiki._OwnerIDRRef as Kontr,
	|	    Grafiki_Grafik._Reference3482_IDRRef as Grafik,
	|	    MIN(Grafiki_Grafik._Fld6031) as KolNedel,
	|	    MIN(DateAdd(Week,
	|	    		Grafiki_Grafik._Fld6031,
	|	    		DateAdd(Day,
	|	    				CASE
	|	    					WHEN dni_nedeli_post._EnumOrder > dni_nedeli._EnumOrder
	|	    					THEN dni_nedeli_post._EnumOrder - dni_nedeli._EnumOrder
	|	    					ELSE 7 + dni_nedeli_post._EnumOrder - dni_nedeli._EnumOrder END,
	|	    				@DatePost))) as date_post                                     -- миним. даты поступления по графику
	|	From IzbenkaFin.dbo._Reference3482_VT3488 as Grafiki_Grafik (nolock)
	|	 Inner Join IzbenkaFin.dbo._Reference3482 as Spr_Grafiki (nolock)
	|	 On Spr_Grafiki._IDRRef = Grafiki_Grafik._Reference3482_IDRRef
	|		 And CAST(master.dbo.Binary2UID(Spr_Grafiki._Fld3483RRef) as nvarchar(36)) = @UID_Sklad
	|	 	 And Spr_Grafiki._Marked = 0
	|	 Left Outer Join IzbenkaFin.dbo._Enum2373 as dni_nedeli (nolock)
	|	 On dni_nedeli._EnumOrder + 1 = Cast(DatePart(weekday, @DatePost) as numeric(10,0))
	|	 	 And dni_nedeli._IDRRef = Grafiki_Grafik._Fld3490RRef
	|	 Left Outer Join IzbenkaFin.dbo._Enum2373 as dni_nedeli_post (nolock)
	|	 On dni_nedeli_post._IDRRef = Grafiki_Grafik._Fld3491RRef
	|	Where
	|		 dni_nedeli._IDRRef is not null
	|		 And dni_nedeli_post._IDRRef is not null
	|	Group by
	|	    Spr_Grafiki._OwnerIDRRef,
	|	    Grafiki_Grafik._Reference3482_IDRRef) as a
	| Left Outer Join IzbenkaFin.dbo._Reference3482_VT3485 as Grafiki_Tovary (nolock)
	| On Grafiki_Tovary._Reference3482_IDRRef = a.Grafik
	| Left Outer Join (                                     -- миним. даты поступления в неподготовленных предзаказах
	|	Select 
	|		VT_PredZakazy.grafik,
	|		VT_PredZakazy.Tovar,
	|		MIN(VT_PredZakazy.date_post) as date_post
	|	From #VT_PredZakazy as VT_PredZakazy
	|	Where
	|		VT_PredZakazy.podgotovlen = 0
	|	group by
	|		VT_PredZakazy.grafik,
	|		VT_PredZakazy.Tovar) as Daty_PredZakazy
	| On Daty_PredZakazy.Grafik = a.Grafik
	| 	 And Daty_PredZakazy.Tovar = Grafiki_Tovary._Fld3487RRef
	|Where
	|	 Grafiki_Tovary._Fld3487RRef is not null
	|
	|-------------------------------------------------------------------------------------
	|Select
	|	ISNULL(VTProizvoditeli.id_kontr, 0) as id_kontr,
	|	VTProizvoditeli.kontr as kontr,
	|	Osn_Tablica.Tovar as Tovar,
	|	ISNULL(VT_Assortiment.Har, 0x00000000000000000000000000000000) as Har,
	|	Osn_Tablica.TT as TT,
	|	SUM(Plan_Prodaj) as Plan_Prodaj,
	|	SUM(Fact_Ostatok) as Fact_Ostatok,
	|	SUM(Raspredeleno) as Raspredeleno,
	|	SUM(Kol_Zakaz) as Kol_Zakaz,
	|	SUM(Kol_Zakaz_) as Kol_Zakaz_,
	|	SUM(Kol_Zakaz2) as Kol_Zakaz2,
	|	SUM(Kol_Zakaz2_) as Kol_Zakaz2_,
	|	SUM(Kol_Zakaz3) as Kol_Zakaz3,
	|	SUM(Kol_Zakaz3_) as Kol_Zakaz3_,
	|	SUM(Kol_Zakaz4) as Kol_Zakaz4,
	|	SUM(Kol_Zakaz4_) as Kol_Zakaz4_,
	|	SUM(Kol_Zakaz5) as Kol_Zakaz5,
	|	SUM(Kol_Zakaz5_) as Kol_Zakaz5_,
	|	SUM(Kol_Zakaz6) as Kol_Zakaz6,
	|	SUM(Kol_Zakaz6_) as Kol_Zakaz6_,
	|	SUM(Fact_Ostatok) +	SUM(Raspredeleno) - SUM(Plan_Prodaj) as Plan_Konec_Dnya
	|Into #VT_Osnovnaya
	|From (
	|	Select
	|		VT_PredZakazy.TT as TT,
	|		VT_PredZakazy.Tovar as Tovar,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRaspr		THEN VT_PredZakazy.kol	ELSE 0 END as Kol_Zakaz,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRaspr		THEN VT_PredZakazy.kol_	ELSE 0 END as Kol_Zakaz_,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRasprPlus1 THEN VT_PredZakazy.kol  ELSE 0 END as Kol_Zakaz2,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRasprPlus1 THEN VT_PredZakazy.kol_ ELSE 0 END as Kol_Zakaz2_,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRasprPlus2 THEN VT_PredZakazy.kol  ELSE 0 END as Kol_Zakaz3,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRasprPlus2 THEN VT_PredZakazy.kol_ ELSE 0 END as Kol_Zakaz3_,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRasprPlus3 THEN VT_PredZakazy.kol  ELSE 0 END as Kol_Zakaz4,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRasprPlus3 THEN VT_PredZakazy.kol_ ELSE 0 END as Kol_Zakaz4_,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRasprPlus4 THEN VT_PredZakazy.kol  ELSE 0 END as Kol_Zakaz5,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRasprPlus4 THEN VT_PredZakazy.kol_ ELSE 0 END as Kol_Zakaz5_,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRasprPlus5 THEN VT_PredZakazy.kol  ELSE 0 END as Kol_Zakaz6,
	|		CASE WHEN VT_PredZakazy.date_post = @DateRasprPlus5 THEN VT_PredZakazy.kol_ ELSE 0 END as Kol_Zakaz6_,
	|		0 as Plan_Prodaj,
	|		0 as Fact_Ostatok,
	|		0 as Raspredeleno
	|	From #VT_PredZakazy as VT_PredZakazy
	|	Where
	|		(Not VT_PredZakazy.date_post > @DateRasprPlus5)
	|		And VT_PredZakazy.proveden = 1
	|
	|	Union All
	|
	|	Select
	|		PodZapros_.TT,
	|		PodZapros_.Tovar,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		PodZapros_.Plan_Prodaj,
	|		PodZapros_.Fact_Ostatok,
	|		PodZapros_.Raspredeleno
	|	From (
	|		Select
	|			Reg_Plan_Prodaj._Fld2883RRef as TT,
	|			Reg_Plan_Prodaj._Fld2884RRef as Tovar,
	|			Reg_Plan_Prodaj._Fld2885 as Plan_Prodaj,
	|			0 as Fact_Ostatok,
	|			0 as Raspredeleno
	|		From IzbenkaFin.._InfoRg2881 as Reg_Plan_Prodaj (nolock)
	|		Where
	|			Reg_Plan_Prodaj._Fld3269 = @DateRaspr
	|		
	|		Union All
	|		
	|		Select
	|			Reg_Fact_Ost._Fld3196RRef,
	|			Reg_Fact_Ost._Fld3197RRef,
	|			0,
	|			Reg_Fact_Ost._Fld3198,
	|			0
	|		From IzbenkaFin.._InfoRg3194 as Reg_Fact_Ost (nolock)
	|		Where
	|			Reg_Fact_Ost._Fld3195 = @DatePost
	|		
	|		Union All
	|		
	|		Select
	|			Reg_Ost_Raspr._Fld4023RRef,
	|			Reg_Ost_Raspr._Fld4022RRef,
	|			0,
	|			0,
	|			Reg_Ost_Raspr._Fld4024
	|		From IzbenkaFin.._InfoRg4020 as Reg_Ost_Raspr (nolock)
	|		Where
	|			Reg_Ost_Raspr._Fld4021 = @DateRaspr) as PodZapros_) as Osn_Tablica
	| Left Outer Join #Nom_I_Analogi as Nom_I_Analogi
	| On Nom_I_Analogi.Tovar = Osn_Tablica.Tovar
	| Left Outer Join #VT_tt as VT_tt
	| On VT_tt.TT = Osn_Tablica.TT
	| Left Outer Join #VT_Assortiment as VT_Assortiment
	| On VT_Assortiment.TT = Osn_Tablica.TT
	|	And VT_Assortiment.Tovar = Osn_Tablica.Tovar
	| Left Outer Join #VTProizvoditeli as VTProizvoditeli
	| On VTProizvoditeli.Harakteristika = VT_Assortiment.Har
	|Where
	|	Nom_I_Analogi.Tovar is not null
	|	And VT_tt.TT is not null
	//|	VT_Assortiment.Tovar is not null
	//|	And VTProizvoditeli.Harakteristika is not null
	|Group by
	|	ISNULL(VTProizvoditeli.id_kontr, 0),
	|	VTProizvoditeli.kontr,
	|	Osn_Tablica.Tovar,
	|	VT_Assortiment.Har,
	|	Osn_Tablica.TT
	|
	|-------------------------------------------------------------------------------------
	|Select
	|	RegZnach_Svoistv._Fld394_RRRef as Har,
	|	Spr_Har._OwnerIDRRef as Tovar,
	|	CASE
	|		WHEN SprTovary._Fld239 = 1
	|			THEN RegZnach_Svoistv._Fld396_N
	|		ELSE CAST(RegZnach_Svoistv._Fld396_N as Numeric(15,0))
	|	END as Kol
	|Into #VTKolVUpakovke
	|From IzbenkaFin.._InfoRg393 as RegZnach_Svoistv (nolock)
	| Inner Join IzbenkaFin.dbo._Reference2539 as Spr_Har (nolock)
	| On Spr_Har._IDRRef = RegZnach_Svoistv._Fld394_RRRef
	| Inner Join IzbenkaFin.._Reference29 as SprTovary (nolock)				
	| On SprTovary._IDRRef = Spr_Har._OwnerIDRRef
	|Where
	|	RegZnach_Svoistv._Fld395RRef = 0x8C82DC746C8468B545B618EC1DACAEE4  -- свойство <Количество в упаковке>
	|
	|-------------------------------------------------------------------------------------
	//+++АК KIRN 2018.07.31 ИП-00012852.07 
	|Select
	|  MAX(RegNormKvantUp._Period) as Period,
	|  RegNormKvantUp._Fld7274RRef as Har,
	|  RegNormKvantUp._Fld7273RRef as Sklad,
	|  --RegNormKvantUp._Fld7275 as Kvant,
	|  Spr_Har._OwnerIDRRef as Tovar,
	|  Spr_Har._Fld7868 as id_kontr
	|Into #KvantUpMax
	|From IzbenkaFin.._InfoRg7272 as RegNormKvantUp (nolock) -- РС нормативный квант упаковки
	| Inner Join IzbenkaFin.dbo._Reference2539 as Spr_Har (nolock)
	| 	On Spr_Har._IDRRef = RegNormKvantUp._Fld7274RRef
	|where RegNormKvantUp._Fld7273RRef = @Binary_Sklad
	|group by 
	|  RegNormKvantUp._Fld7274RRef,
	|  RegNormKvantUp._Fld7273RRef, 
	|  Spr_Har._OwnerIDRRef,
	|  Spr_Har._Fld7868
	|------------------------------------------------------------------------------------- 
	|Select
	|  RegNormKvantUp._Period as Period,
	|  RegNormKvantUp._Fld7274RRef as Har,
	|  RegNormKvantUp._Fld7275 as Kvant,
	|  KvantUpMax.Tovar as Tovar,
	|  KvantUpMax.id_kontr as id_kontr  
	|Into #KvantUp 
	|From IzbenkaFin.._InfoRg7272 as RegNormKvantUp (nolock) -- РС нормативный квант упаковки
	| Inner join #KvantUpMax as KvantUpMax
	|	on RegNormKvantUp._Fld7274RRef = KvantUpMax.Har
	|		and RegNormKvantUp._Fld7273RRef = KvantUpMax.Sklad
	|		and RegNormKvantUp._Period = KvantUpMax.Period
	//---АК KIRN 
	|-------------------------------------------------------------------------------------
	|
	|Select
	|	Predzakaz_Tovary._Fld5229RRef as Har,
	|	Predzakaz_Tovary._Fld3066RRef as Tovar,
	|	Predzakaz_Tovary._Fld3065RRef as TT,
	|	SUM(Predzakaz_Tovary._Fld3067) as Kol
	|Into #VT_Predyduschiy_PredZakaz
	|From IzbenkaFin.._Document3032_VT3063 as Predzakaz_Tovary (nolock)
	| Inner Join IzbenkaFin.._Document3032 as Predzakazy (nolock)
	| On Predzakazy._IDRRef = Predzakaz_Tovary._Document3032_IDRRef
	|	And CAST(master.dbo.Binary2UID(Predzakazy._Fld3057RRef) as nvarchar(36)) = @UID_Sklad
	|	And Predzakazy._Fld3058 = @DatePost
	|	And Predzakazy._Posted = 1
	| Left Outer Join #Dostupnaya_Nom as Dostupnaya_Nom
	| On Dostupnaya_Nom.Tovar = Predzakaz_Tovary._Fld3066RRef
	| Left Outer Join #VT_tt as VT_tt
	| On VT_tt.TT = Predzakaz_Tovary._Fld3065RRef
	|Where
	|	Dostupnaya_Nom.Tovar is not null
	|	And VT_tt.TT is not null
	|Group by
	|	Predzakaz_Tovary._Fld5229RRef,
	|	Predzakaz_Tovary._Fld3066RRef,
	|	Predzakaz_Tovary._Fld3065RRef
	|	
	|-------------------------------------------------------------------------------------
	|Select
	|	dtt.date_tt as date,
	|	dtt.id_tov,
	|	dtt.id_tt,
	|	dtt.quantity - dtt.discount50_qty - dtt.discount50_sms_qty as kol,
	|	0 as Kol_p
	|Into #VT_Fact_Prodaj
	|From Reports..dtt as dtt (nolock)
	|Where
	|	dtt.date_tt between @DateNach and @DateKon
	|
	|Union All
	|
	|Select
	|	LostSales.date_ls,
	|	LostSales.id_tov_ls,
	|	LostSales.id_tt_ls,
	|	0,
	|	LostSales.lost1
	|From M2..Lost_sales as LostSales (nolock)
	|Where
	|	LostSales.date_ls between @DateNach and @DateKon
	|	
	|-------------------------------------------------------------------------------------
	|Select
	|	VT_Fact_Prodaj.id_tov,
	|	VT_Fact_Prodaj.id_tt,
	|	VTProizvoditeli.id_kontr,
	|	SUM(VT_Fact_Prodaj.kol) as Kol
	|Into #VT_Fact_Prodaj_Mejdu
	|From #VT_Fact_Prodaj as VT_Fact_Prodaj
	| Inner Join #Dostupnaya_Nom as Dostupnaya_Nom
	| On Dostupnaya_Nom.id_tov = VT_Fact_Prodaj.id_tov
	| Inner Join IzbenkaFin.._Reference42 as Spr_StrEd (nolock)				
	| On Spr_StrEd._Fld758 = VT_Fact_Prodaj.id_tt
	| Inner Join #VT_Assortiment as VT_Assortiment
	| On VT_Assortiment.TT = Spr_StrEd._IDRRef
	|	And VT_Assortiment.Tovar = Dostupnaya_Nom.Tovar
	| Inner Join #VTProizvoditeli as VTProizvoditeli
	| On VTProizvoditeli.Harakteristika = VT_Assortiment.Har
	| Inner join #VT_Daty_Postavki as VT_Daty_Postavki
	| On VT_Daty_Postavki.Tovar = Dostupnaya_Nom.Tovar
	| 	 And VT_Daty_Postavki.kontr = VTProizvoditeli.kontr
	|Where
	|	((IsNull(VT_Daty_Postavki.KolNedel, 0) = 0
	|	  And
	|	 	((VT_Daty_Postavki.day_of_date_post > @DatePartRaspr
	|	 	  And DatePart(DW, VT_Fact_Prodaj.date) Between @DatePartRaspr And VT_Daty_Postavki.day_of_date_post - 1)
	|		 Or
	|		 (VT_Daty_Postavki.day_of_date_post = @DatePartRaspr)
	|		 Or
	|		 (VT_Daty_Postavki.day_of_date_post < @DatePartRaspr
	|	 	  And DatePart(DW, VT_Fact_Prodaj.date) Between VT_Daty_Postavki.day_of_date_post And @DatePartRaspr)))
	|	Or
	|	 (IsNull(VT_Daty_Postavki.KolNedel, 0) > 0
	|	  And (VT_Fact_Prodaj.date Between
	|	  						   VT_Daty_Postavki.date_nach
	|	  						   And (DateAdd(Week, -(IsNull(VT_Daty_Postavki.KolNedel, 0) + 1), VT_Daty_Postavki.date_post) - 1))))
	|Group by
	|	VT_Fact_Prodaj.id_tov,
	|	VT_Fact_Prodaj.id_tt,
	|	VTProizvoditeli.id_kontr	
	|	
	|-------------------------------------------------------------------------------------
	|Select
	|	VT_Osnovnaya.id_kontr as id_kontr,
	|	CAST(master.dbo.Binary2UID(VT_Osnovnaya.kontr) as nvarchar(36)) as kontr,
	|	SprTovary._Fld760 as id_tov,
	|	CAST(master.dbo.Binary2UID(SprTovary._IDRRef) as nvarchar(36)) as tov,
	|	Spr_StrEd._Fld2756 as Nomer_Tochki,
	|	CAST(master.dbo.Binary2UID(Spr_StrEd._IDRRef) as nvarchar(36)) as tt,
	|	ISNULL(Reg_Tov_Ogranicheniya._Fld2918, 0) as Min_Ostatok,
	|	VT_Osnovnaya.Plan_Prodaj as Plan_Prodaj,
	|	VT_Osnovnaya.Fact_Ostatok as Fact_Ostatok,
	|	VT_Osnovnaya.Raspredeleno as Raspredeleno,
	|	VT_Osnovnaya.Kol_Zakaz as Kol_Zakaz,
	|	VT_Osnovnaya.Kol_Zakaz_ as Kol_Zakaz_,
	|	VT_Osnovnaya.Kol_Zakaz2 as Kol_Zakaz2,
	|	VT_Osnovnaya.Kol_Zakaz2_ as Kol_Zakaz2_,
	|	VT_Osnovnaya.Kol_Zakaz3 as Kol_Zakaz3,
	|	VT_Osnovnaya.Kol_Zakaz3_ as Kol_Zakaz3_,
	|	VT_Osnovnaya.Kol_Zakaz4 as Kol_Zakaz4,
	|	VT_Osnovnaya.Kol_Zakaz4_ as Kol_Zakaz4_,
	|	VT_Osnovnaya.Kol_Zakaz5 as Kol_Zakaz5,
	|	VT_Osnovnaya.Kol_Zakaz5_ as Kol_Zakaz5_,
	|	VT_Osnovnaya.Kol_Zakaz6 as Kol_Zakaz6,
	|	VT_Osnovnaya.Kol_Zakaz6_ as Kol_Zakaz6_,
	|	VT_Osnovnaya.Plan_Konec_Dnya - ISNULL(VT_Predyduschiy_PredZakaz.Kol, 0) as Ost_Pered_Sled_Zakazom,
	//+++АК KIRN 2018.07.31 ИП-00012852.07 
	|"+?(ИспользоватьНормативныйКвантДляРасчетаПлановогоОстатка,"
	|	ISNULL(VT_Kol_TT.Kol, 0) * 0.5 * ISNULL(KvantUp.Kvant, 0) as Plan_Raschet,","
	|	ISNULL(VT_Kol_TT.Kol, 0) * 0.5 * ISNULL(VTKolVUpakovke.Kol, 0) as Plan_Raschet,")+"	
	//|	ISNULL(VT_Kol_TT.Kol, 0) * 0.5 * ISNULL(VTKolVUpakovke.Kol, 0) as Plan_Raschet,
	//---АК KIRN 
	|	ISNULL(Reg_Par_Nom_Zakaz._Fld7226, 0) as PlanOst_URZ,
	|	VT_Osnovnaya.Plan_Konec_Dnya as Plan_Konec_Dnya,
	|	CASE
	|		WHEN SprTovary._Fld239 = 1
	|			THEN ISNULL(VT_Fact_Prodaj.kol, 0) / " + ТекстКолПериодов + "
	|		ELSE CAST(ISNULL(VT_Fact_Prodaj.kol, 0) / " + ТекстКолПериодов + " as Numeric(15,0))
	|	END as Kol_Fact_Prodaj,
	|	ISNULL(VTOstatkiNaSklade.kol, 0) as Ost_Sklad,
	|	VT_Osnovnaya.Fact_Ostatok
	|		+ CASE
	|			WHEN SprTovary._Fld239 = 1
	|				THEN ISNULL(VT_Fact_Prodaj_Mejdu.kol, 0)
	|			ELSE CAST(ISNULL(VT_Fact_Prodaj_Mejdu.kol, 0) as Numeric(15,0))
	|		  END
	|		- VT_Osnovnaya.Raspredeleno
	|		- ISNULL(VT_PredZakazy.kol, 0)  as Plan_Ost_Do_Razm,
	|	ISNULL(VT_KolTTWithMaxOst.kol, 0) * 0.5 * ISNULL(VTKolVUpakovke.Kol, 0) as KolTTWith05,
	|	CASE
	|		WHEN SprTovary._Fld239 = 1
	|			THEN ISNULL(VT_Fact_Prodaj_Razm.kol, 0) / " + ТекстКолПериодов + "
	|		ELSE CAST(ISNULL(VT_Fact_Prodaj_Razm.kol, 0) / " + ТекстКолПериодов + " as Numeric(15,0))
	|	END as Plan_Ost_Razm,
	|	CASE
	|		WHEN SprTovary._Fld239 = 1
	|			THEN ISNULL(VT_Fact_Prodaj_Mejdu.kol, 0)
	|		ELSE CAST(ISNULL(VT_Fact_Prodaj_Mejdu.kol, 0) as Numeric(15,0))
	|	END as Fact_Razm
	|-------------------------------------------------------------------------------------
	|From #VT_Osnovnaya as VT_Osnovnaya
	|-------------------------------------------------------------------------------------
	| Inner Join IzbenkaFin.._Reference29 as SprTovary (nolock)				
	| On SprTovary._IDRRef = VT_Osnovnaya.Tovar
	| Inner Join IzbenkaFin.._Reference42 as Spr_StrEd (nolock)				
	| On Spr_StrEd._IDRRef = VT_Osnovnaya.TT
	|-------------------------------------------------------------------------------------
	| Left Outer Join IzbenkaFin.._InfoRg2915 as Reg_Tov_Ogranicheniya (nolock)
	| On Reg_Tov_Ogranicheniya._Fld2916RRef = VT_Osnovnaya.Tovar
	|	 And Reg_Tov_Ogranicheniya._Fld2917RRef = VT_Osnovnaya.TT
	|-------------------------------------------------------------------------------------
	| Left Outer Join
	|	(Select
	|		VT_Assortiment.Tovar,
	|		COUNT(Distinct VT_Assortiment.TT) as Kol
	|	From #VT_Assortiment as VT_Assortiment
	|	Group by
	|		VT_Assortiment.Tovar) as VT_Kol_TT
	| On VT_Kol_TT.Tovar = VT_Osnovnaya.Tovar
	|-------------------------------------------------------------------------------------
	| Left Outer Join #VTKolVUpakovke as VTKolVUpakovke
	| On VTKolVUpakovke.Tovar = VT_Osnovnaya.Tovar
	|	And VTKolVUpakovke.Har = VT_Osnovnaya.Har
	|-------------------------------------------------------------------------------------
	//+++АК KIRN 2018.08.01  ИП-00012852.07
	| Left Outer Join #KvantUp as KvantUp
	| On KvantUp.Tovar = VT_Osnovnaya.Tovar
	|	And KvantUp.Har = VT_Osnovnaya.Har
	//---АК KIRN 
	|-------------------------------------------------------------------------------------
	| Left Outer Join #VT_Predyduschiy_PredZakaz as VT_Predyduschiy_PredZakaz
	| On VT_Predyduschiy_PredZakaz.Tovar = VT_Osnovnaya.Tovar
	|	 And VT_Predyduschiy_PredZakaz.TT = VT_Osnovnaya.TT
	|	 And VT_Predyduschiy_PredZakaz.Har = VT_Osnovnaya.Har
	|-------------------------------------------------------------------------------------
	| Left Outer Join IzbenkaFin.._InfoRg2909 as Reg_Par_Nom_Zakaz (nolock)
	| On CAST(master.dbo.Binary2UID(Reg_Par_Nom_Zakaz._Fld2910RRef) as nvarchar(36)) = @UID_Sklad
	| 	 And Reg_Par_Nom_Zakaz._Fld2911RRef = VT_Osnovnaya.Tovar
	| 	 And Reg_Par_Nom_Zakaz._Fld7341RRef = VT_Osnovnaya.Har
	|-------------------------------------------------------------------------------------
	| Left Outer Join #VTOstatkiNaSklade as VTOstatkiNaSklade
	| On VTOstatkiNaSklade.Tovar = VT_Osnovnaya.Tovar
	| 	And VTOstatkiNaSklade.Har = VT_Osnovnaya.Har
	|-------------------------------------------------------------------------------------
	| Left Outer join
	|	(Select
	|		VT_Fact_Prodaj.id_tov,
	|		VT_Fact_Prodaj.id_tt,
	|		SUM(VT_Fact_Prodaj.kol) as kol
	|	From #VT_Fact_Prodaj as VT_Fact_Prodaj
	|	Where
	|		DatePart(DW, VT_Fact_Prodaj.date) = @DatePartRaspr
	|	Group by
	|		VT_Fact_Prodaj.id_tov,
	|		VT_Fact_Prodaj.id_tt) as VT_Fact_Prodaj 
	| On VT_Fact_Prodaj.id_tov = SprTovary._Fld760
	|	 And VT_Fact_Prodaj.id_tt = Spr_StrEd._Fld758
	|-------------------------------------------------------------------------------------
	| Left Outer Join
	|	(Select
	|		VT_Assortiment.Tovar,
	|		VT_Assortiment.TT,
	|		Case When ISNULL(VT_Tov_Ogranicheniya._Fld2919, 0) > 0 Then 1 Else 0 End As Kol
	//|		COUNT(Distinct VT_Assortiment.TT) as Kol
	|	From #VT_Assortiment as VT_Assortiment
	//|	 Inner Join IzbenkaFin.._InfoRg2915 as VT_Tov_Ogranicheniya (nolock)
	|	 Left Outer Join IzbenkaFin.._InfoRg2915 as VT_Tov_Ogranicheniya (nolock)
	|	 On VT_Tov_Ogranicheniya._Fld2916RRef = VT_Assortiment.Tovar
	|	 	And VT_Tov_Ogranicheniya._Fld2917RRef = VT_Assortiment.TT
	//|	 	And VT_Tov_Ogranicheniya._Fld2919 > 0
	//|	Group by
	//|		VT_Assortiment.Tovar) as VT_KolTTWithMaxOst
	|	) as VT_KolTTWithMaxOst
	| On VT_KolTTWithMaxOst.Tovar = VT_Osnovnaya.Tovar
	| 	And VT_KolTTWithMaxOst.TT = VT_Osnovnaya.Tovar
	|-------------------------------------------------------------------------------------
	| Inner join #VT_Daty_Postavki as VT_Daty_Postavki
	| On VT_Daty_Postavki.kontr = VT_Osnovnaya.kontr
	|	 And VT_Daty_Postavki.Tovar = VT_Osnovnaya.Tovar
	|-------------------------------------------------------------------------------------
	| Left Outer join
	|	(Select
	|		DatePart(DW, VT_Fact_Prodaj.date) as DayOfDate,
	|		VT_Fact_Prodaj.id_tov,
	|		VT_Fact_Prodaj.id_tt,
	|		SUM(VT_Fact_Prodaj.kol) as kol
	|	From #VT_Fact_Prodaj as VT_Fact_Prodaj
	|	Group by
	|		DatePart(DW, VT_Fact_Prodaj.date),
	|		VT_Fact_Prodaj.id_tov,
	|		VT_Fact_Prodaj.id_tt) as VT_Fact_Prodaj_Razm 
	| On VT_Fact_Prodaj_Razm.DayOfDate = VT_Daty_Postavki.day_of_date_post
	|	 And VT_Fact_Prodaj_Razm.id_tov = SprTovary._Fld760
	|	 And VT_Fact_Prodaj_Razm.id_tt = Spr_StrEd._Fld758
	|-------------------------------------------------------------------------------------
	| Left Outer join #VT_Fact_Prodaj_Mejdu as VT_Fact_Prodaj_Mejdu
	| On VT_Fact_Prodaj_Mejdu.id_tov = SprTovary._Fld760
	|	 And VT_Fact_Prodaj_Mejdu.id_tt = Spr_StrEd._Fld758
	|	 And VT_Fact_Prodaj_Mejdu.id_kontr = VT_Osnovnaya.id_kontr
	|-------------------------------------------------------------------------------------
	| Left Outer join ( 
	|	Select 
	|		VT_PredZakazy.TT,
	|		VT_PredZakazy.Tovar,
	|		SUM(VT_PredZakazy.kol) as kol
	|	From #VT_PredZakazy as VT_PredZakazy
	|	Where
	|		VT_PredZakazy.proveden = 1
	|	group by
	|		VT_PredZakazy.TT,
	|		VT_PredZakazy.Tovar) as VT_PredZakazy
	| On VT_PredZakazy.TT = VT_Osnovnaya.TT
	|	 And VT_PredZakazy.Tovar = VT_Osnovnaya.Tovar
	| 
	|-------------------------------------------------------------------------------------
	|Drop Table #VTProizvoditeli
	|Drop Table #Dostupnaya_Nom
	|Drop Table #Polnye_Analogi
	|Drop Table #Nom_I_Analogi
	|Drop Table #VT_tt
	|Drop Table #VT_Assortiment
	|Drop Table #VT_PredZakazy          
	|Drop Table #VTOstatkiNaSklade          
	|Drop Table #VT_Daty_Postavki
	|Drop Table #VT_Fact_Prodaj_Mejdu
	|Drop Table #VT_Fact_Prodaj
	|Drop Table #VT_Osnovnaya
	|Drop Table #VTKolVUpakovke
	//+++АК KIRN 2018.08.01 ИП-00012852.07 
	|Drop Table #KvantUp
	|Drop Table #KvantUpMax
	//---АК KIRN 
	|Drop Table #VT_Predyduschiy_PredZakaz";
	
	//
	Выборка = ADOСоединение.Execute(ТекстЗапроса);
	
	//
	СпрКонтрагенты 		= Справочники.Контрагенты;
	СпрНоменклатура 	= Справочники.Номенклатура;
	СпрТорговыеТочки 	= Справочники.СтруктурныеЕдиницы;
	Пока НЕ Выборка = Неопределено Цикл
		Если Выборка.Fields.Count > 0 Тогда
			Пока НЕ Выборка.EOF Цикл
				
				НоваяСтрока = ТаблицаДанные.Добавить();
				Попытка
					НоваяСтрока.Поставщик 	= СпрКонтрагенты.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.Fields("kontr").Value));
				Исключение
				КонецПопытки;
				НоваяСтрока.Номенклатура 	= СпрНоменклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.Fields("tov").Value));
				НоваяСтрока.ТорговаяТочка	= СпрТорговыеТочки.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.Fields("tt").Value));
				
				НоваяСтрока.МинимальныйОстаток		= Выборка.Fields("Min_Ostatok").Value;
				НоваяСтрока.ФактическийОстаток		= Выборка.Fields("Fact_Ostatok").Value;
				НоваяСтрока.Распределено			= Выборка.Fields("Raspredeleno").Value;
				НоваяСтрока.КоличествоПланПродаж	= Выборка.Fields("Plan_Prodaj").Value;
 				НоваяСтрока.КоличествоЗаказ			= Выборка.Fields("Kol_Zakaz").Value;
  				НоваяСтрока.КоличествоЗаказ_		= Выборка.Fields("Kol_Zakaz_").Value;
  				НоваяСтрока.КоличествоЗаказ2		= Выборка.Fields("Kol_Zakaz2").Value;
  				НоваяСтрока.КоличествоЗаказ2_		= Выборка.Fields("Kol_Zakaz2_").Value;
    			НоваяСтрока.КоличествоЗаказ3		= Выборка.Fields("Kol_Zakaz3").Value;
  				НоваяСтрока.КоличествоЗаказ3_		= Выборка.Fields("Kol_Zakaz3_").Value;
  				НоваяСтрока.КоличествоЗаказ4		= Выборка.Fields("Kol_Zakaz4").Value;
  				НоваяСтрока.КоличествоЗаказ4_		= Выборка.Fields("Kol_Zakaz4_").Value;
  				НоваяСтрока.КоличествоЗаказ5		= Выборка.Fields("Kol_Zakaz5").Value;
  				НоваяСтрока.КоличествоЗаказ5_		= Выборка.Fields("Kol_Zakaz5_").Value;
  				НоваяСтрока.КоличествоЗаказ6		= Выборка.Fields("Kol_Zakaz6").Value;
  				НоваяСтрока.КоличествоЗаказ6_		= Выборка.Fields("Kol_Zakaz6_").Value;
  				НоваяСтрока.ПлановыйОстатокРасчетный	= Выборка.Fields("Plan_Raschet").Value;
  				НоваяСтрока.ПлановыйОстатокУРЗ			= Выборка.Fields("PlanOst_URZ").Value;
  				НоваяСтрока.ПлановыйОстатокНаКонецДня	= Выборка.Fields("Plan_Konec_Dnya").Value;
 				НоваяСтрока.ПлановыйОстатокПередСледЗаказом	= Выборка.Fields("Ost_Pered_Sled_Zakazom").Value;
				НоваяСтрока.ФактПродаж						= Выборка.Fields("Kol_Fact_Prodaj").Value;
				НоваяСтрока.ОстатокПослеРаспределения		= Выборка.Fields("Ost_Sklad").Value;
				НоваяСтрока.ПлановыйОстатокПередСледНеразмЗаказом	= Выборка.Fields("Plan_Ost_Do_Razm").Value;
				НоваяСтрока.КоличествоТТСОграничением05		= Выборка.Fields("KolTTWith05").Value;
				НоваяСтрока.ПлановыйОстатокДняРазмещения	= Выборка.Fields("Plan_Ost_Razm").Value;
				НоваяСтрока.ФактПродажДнейРазмещения		= Выборка.Fields("Fact_Razm").Value;

				Если НЕ Выборка.EOF Тогда
					Выборка.MoveNext();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Выборка = Выборка.NextRecordSet();
	КонецЦикла;
	
	ADOСоединение.Close();		
				
	//
	Возврат ТаблицаДанные;
	
КонецФункции
