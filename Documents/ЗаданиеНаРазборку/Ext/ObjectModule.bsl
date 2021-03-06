﻿
//+++АК KIRN 2018.06.28 ИП-00019109.000.00000002  
Процедура ЗаполнитьШапкуРО(РасхОрдерОбъект,Выборка)
	РасхОрдерОбъект.НеМенятьДатуПриПроведении = Истина;
	РасхОрдерОбъект.Дата			= Дата;
	РасхОрдерОбъект.Автор 			= ПараметрыСеанса.ТекущийПользователь;
	РасхОрдерОбъект.ВидОперации		= Перечисления.ВидыОперацийРасходСкладскойУчет.ОтгрузкаВТорговуюТочку;;
	РасхОрдерОбъект.Получатель 		= Выборка.СтруктурнаяЕдиница;
	РасхОрдерОбъект.Организация		= Выборка.СкладОрганизация;
	РасхОрдерОбъект.Склад 			= Выборка.Склад;
	РасхОрдерОбъект.АвтозагрузкаУРЗ = Истина;
	РасхОрдерОбъект.Статус 			= Перечисления.СтатусыРасходныхОрдеров.ВСборке;
	РасхОрдерОбъект.ДатаРаспределения 	= Дата;
КонецПроцедуры

//+++АК KIRN 2018.06.28 ИП-00019109.000.00000002  
Процедура ЗаполнитьСтрокуРО(СтрокаТовар, Выборка)
	СтрокаТовар.Номенклатура 		= Выборка.Номенклатура;
	СтрокаТовар.ЗаданиеНаРазборку	= Выборка.ЗаданиеНаРазборку;
	СтрокаТовар.Характеристика 		= Выборка.Характеристика;
	СтрокаТовар.ДатаПроизводства 	= Выборка.ДатаПроизводства;
	СтрокаТовар.НомерРаспределения	= Выборка.НомерРаспределения;
	СтрокаТовар.ЕдиницаИзмерения 	= Выборка.ЕдИзм;
	СтрокаТовар.КоличествоУРЗ 		= Выборка.Количество;
	СтрокаТовар.Количество 			= Выборка.Количество;
КонецПРоцедуры


//+++АК KIRN 2018.06.27 ИП-00019109.000.00000002 
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ПометкаУдаления Тогда
		Документы.ЗаданиеНаРазборку.УдалитьЗаданиеИзРО(Ссылка);
		Закрыто = Ложь;
		ЗакрытоИОбновлено = Ложь;
		Возврат;
	КонецЕСли;
	
	//+++АК KIRN 2018.09.10  	
	Если Товары.Найти(ДОкументы.РасходныйОрдерСклад.ПустаяСсылка()) <> Неопределено Тогда
		Закрыто=Ложь;
		ЗакрытоИОбновлено = Ложь;
	КонецЕсли;
	//---АК KIRN 
	
	//Если ДополнительныеСвойства.Свойство("ЗаполнениеРасходниковВЗаданиях") Тогда
	//	Возврат;
	//КонецЕСли;
	//
	//Если НЕ Подготовлен Тогда
	//	ЗакрытоИОбновлено = Ложь;
	//	Возврат;
	//КонецЕСли;
	//
	//Если ЭтоНовый() Тогда
	//	УстановитьСсылкуНового(Документы.ЗаданиеНаРазборку.ПолучитьСсылку());
	//КонецЕСли;
	//
	//УстановитьПривилегированныйРежим(Истина);
	//Запрос = Новый Запрос;
	//Запрос.УстановитьПараметр("Ссылка",Ссылка);
	//Запрос.УстановитьПараметр("тз",Товары.Выгрузить());
	//Запрос.УстановитьПараметр("ДатаДок", НачалоДня(Дата));
	//Запрос.УстановитьПараметр("Склад",Склад);
	//Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	//Запрос.УстановитьПараметр("Характеристика", Характеристика);
	//Запрос.УстановитьПараметр("Напечатан",Напечатан);
	//Запрос.УстановитьПараметр("Сборщик", Сборщик);
	//
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	ВЫРАЗИТЬ(&Ссылка КАК Документ.ЗаданиеНаРазборку) КАК Ссылка,
	//|	ВЫРАЗИТЬ(&ДатаДок КАК Дата) КАК Дата,
	//|	тз.СтруктурнаяЕдиница,
	//|	тз.Количество,
	//|	тз.РасходныйОрдер,
	//|	тз.ДатаПроизводства,
	//|	тз.ДатаПроизводстваПред,
	//|	тз.Собран,
	//|	тз.НомерРаспределения,
	//|	ВЫРАЗИТЬ(&Склад КАК Справочник.Склады) КАК Склад,
	//|	ВЫРАЗИТЬ(&Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	//|	ВЫРАЗИТЬ(&Характеристика КАК Справочник.ХарактеристикиНоменклатуры) КАК Характеристика,
	//|	ВЫРАЗИТЬ(&Напечатан КАК БУЛЕВО) КАК Напечатан,
	//|	ВЫРАЗИТЬ(&Сборщик КАК Справочник.ФизическиеЛица) КАК Сборщик
	//|ПОМЕСТИТЬ втЗадания
	//|ИЗ
	//|	&тз КАК тз
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	РасходныйОрдерСкладТовары.Номенклатура,
	//|	ВЫРАЗИТЬ(РасходныйОрдерСкладТовары.Ссылка.Получатель КАК Справочник.СтруктурныеЕдиницы) КАК СтруктурнаяЕдиница,
	//|	РасходныйОрдерСкладТовары.Ссылка.Склад КАК Склад,
	//|	РасходныйОрдерСкладТовары.Характеристика,
	//|	РасходныйОрдерСкладТовары.КоличествоУРЗ КАК Количество,
	//|	РасходныйОрдерСкладТовары.Ссылка КАК Ссылка,
	//|	РасходныйОрдерСкладТовары.ДатаПроизводства,
	//|	РасходныйОрдерСкладТовары.ЗаданиеНаРазборку,
	//|	РасходныйОрдерСкладТовары.ЗаданиеНаРазборку.Закрыто КАК Закрыто,
	//|	НАЧАЛОПЕРИОДА(РасходныйОрдерСкладТовары.Ссылка.Дата, ДЕНЬ) КАК Дата
	//|ПОМЕСТИТЬ втРасходники
	//|ИЗ
	//|	Документ.РасходныйОрдерСклад.Товары КАК РасходныйОрдерСкладТовары
	//|ГДЕ
	//|	НАЧАЛОПЕРИОДА(РасходныйОрдерСкладТовары.Ссылка.Дата, ДЕНЬ) = &ДатаДок
	//|	И РасходныйОрдерСкладТовары.Ссылка.Проведен = ИСТИНА
	//|	И РасходныйОрдерСкладТовары.Ссылка.Получатель В
	//|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	//|				втЗадания.СтруктурнаяЕдиница
	//|			ИЗ
	//|				втЗадания)
	//|	И НЕ РасходныйОрдерСкладТовары.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРасходныхОрдеров.Отменен)
	//|	И РасходныйОрдерСкладТовары.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходСкладскойУчет.ОтгрузкаВТорговуюТочку)
	//|	И РасходныйОрдерСкладТовары.ЗаданиеНаРазборку <> ЗНАЧЕНИЕ(Документ.ЗаданиеНаРазборку.ПустаяСсылка)
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	втРасходники.Номенклатура,
	//|	втРасходники.СтруктурнаяЕдиница,
	//|	втРасходники.Склад,
	//|	втРасходники.Характеристика,
	//|	втРасходники.Количество,
	//|	втРасходники.Ссылка,
	//|	втРасходники.ДатаПроизводства,
	//|	втРасходники.ЗаданиеНаРазборку,
	//|	втРасходники.Закрыто,
	//|	втРасходники.Дата
	//|ИЗ
	//|	втРасходники КАК втРасходники
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	втЗадания.Ссылка КАК ЗаданиеНаРазборку,
	//|	втЗадания.Дата,
	//|	втЗадания.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	//|	втЗадания.Количество,
	//|	втЗадания.РасходныйОрдер КАК РасходныйОрдер,
	//|	втЗадания.ДатаПроизводства,
	//|	втЗадания.ДатаПроизводстваПред,
	//|	втЗадания.Собран,
	//|	втЗадания.НомерРаспределения,
	//|	втЗадания.Склад КАК Склад,
	//|	втЗадания.Номенклатура,
	//|	втЗадания.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдИзм,
	//|	втЗадания.Характеристика,
	//|	втЗадания.Напечатан,
	//|	втЗадания.Сборщик,
	//|	втРасходники.Ссылка КАК РасходныйОрдерРО,
	//|	втРасходники.ЗаданиеНаРазборку КАК ЗаданиеНаРазборкуРО,
	//|	втРасходники.Количество КАК КоличествоРО,
	//|	ВЫБОР
	//|		КОГДА втЗадания.Количество - ЕСТЬNULL(втРасходники.Количество, 0) = 0
	//|			ТОГДА ЛОЖЬ
	//|		ИНАЧЕ ИСТИНА
	//|	КОНЕЦ КАК ЕстьИзменения
	//|ПОМЕСТИТЬ втИзменения
	//|ИЗ
	//|	втЗадания КАК втЗадания
	//|		ЛЕВОЕ СОЕДИНЕНИЕ втРасходники КАК втРасходники
	//|		ПО втЗадания.Дата = втРасходники.Дата
	//|			И втЗадания.Склад = втРасходники.Склад
	//|			И втЗадания.СтруктурнаяЕдиница = втРасходники.СтруктурнаяЕдиница
	//|			И втЗадания.Номенклатура = втРасходники.Номенклатура
	//|			И втЗадания.Характеристика = втРасходники.Характеристика
	//|			И втЗадания.ДатаПроизводстваПред = втРасходники.ДатаПроизводства
	//|ГДЕ
	//|	(втЗадания.Количество - ЕСТЬNULL(втРасходники.Количество, 0) <> 0
	//|			ИЛИ втЗадания.ДатаПроизводства <> втЗадания.ДатаПроизводстваПред)
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ РАЗЛИЧНЫЕ
	//|	втИзменения.ЗаданиеНаРазборку,
	//|	втИзменения.Дата,
	//|	втИзменения.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	//|	втИзменения.Количество,
	//|	втИзменения.РасходныйОрдер КАК РасходныйОрдер,
	//|	втИзменения.ДатаПроизводства,
	//|	втИзменения.ДатаПроизводстваПред,
	//|	втИзменения.Собран,
	//|	втИзменения.НомерРаспределения,
	//|	втИзменения.Склад КАК Склад,
	//|	втИзменения.Номенклатура,
	//|	втИзменения.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдИзм,
	//|	втИзменения.Характеристика,
	//|	втИзменения.Напечатан,
	//|	втИзменения.Сборщик,
	//|	втИзменения.РасходныйОрдерРО КАК РасходныйОрдерРО,
	//|	втИзменения.ЗаданиеНаРазборку КАК ЗаданиеНаРазборкуРО,
	//|	втИзменения.Количество КАК КоличествоРО,
	//|	втИзменения.ЕстьИзменения,
	//|	ВЗ_МаршрутыРейсы.Маршрут КАК Маршрут,
	//|	ВЗ_МаршрутыРейсы.ТорговаяТочка КАК ТорговаяТочка,
	//|	ВЗ_МаршрутыРейсы.Номенклатура КАК Номенклатура1,
	//|	ВЗ_МаршрутыРейсы.Автомобиль,
	//|	ВЗ_МаршрутыРейсы.МаршрутныйЛист,
	//|	втИзменения.Склад.Организация
	//|ИЗ
	//|	втИзменения КАК втИзменения
	//|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	//|			ВЗ_НоменклатураМаршрутов.Номенклатура КАК Номенклатура,
	//|			ВЗ_НоменклатураМаршрутов.Маршрут КАК Маршрут,
	//|			ВЗ_НоменклатураМаршрутов.ТорговаяТочка КАК ТорговаяТочка,
	//|			ВЗ_НоменклатураМаршрутов.Организация КАК Организация,
	//|			ВодителиПоМаршрутуСрезПоследних.Автомобиль КАК Автомобиль,
	//|			ВЗ_Рейсы.Рейс КАК МаршрутныйЛист
	//|		ИЗ
	//|			(ВЫБРАТЬ
	//|				ВЗ_Номенклатура.Номенклатура КАК Номенклатура,
	//|				ВЗ_Маршруты.Маршрут КАК Маршрут,
	//|				ВЗ_Маршруты.ТорговаяТочка КАК ТорговаяТочка,
	//|				ВЗ_Маршруты.Организация КАК Организация
	//|			ИЗ
	//|				(ВЫБРАТЬ
	//|					Маршруты.Ссылка КАК Маршрут,
	//|					ЕСТЬNULL(МаршрутыСклады.Склад, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)) КАК Склад,
	//|					ЕСТЬNULL(МаршрутыТорговыеТочки.СтруктурнаяЕдиница, ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)) КАК ТорговаяТочка,
	//|					Маршруты.Организация КАК Организация
	//|				ИЗ
	//|					Справочник.Маршруты КАК Маршруты
	//|						ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Маршруты.Склады КАК МаршрутыСклады
	//|						ПО Маршруты.Ссылка = МаршрутыСклады.Ссылка
	//|						ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Маршруты.ТорговыеТочки КАК МаршрутыТорговыеТочки
	//|						ПО Маршруты.Ссылка = МаршрутыТорговыеТочки.Ссылка
	//|				ГДЕ
	//|					Маршруты.ПометкаУдаления = ЛОЖЬ) КАК ВЗ_Маршруты
	//|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	//|						ДоступностьТоваровНаСкладах.Номенклатура КАК Номенклатура,
	//|						ДоступностьТоваровНаСкладах.Склад КАК Склад
	//|					ИЗ
	//|						РегистрСведений.ДоступностьТоваровНаСкладах КАК ДоступностьТоваровНаСкладах) КАК ВЗ_Номенклатура
	//|					ПО (ВЗ_Маршруты.Склад = ВЗ_Номенклатура.Склад
	//|							ИЛИ ВЗ_Маршруты.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))) КАК ВЗ_НоменклатураМаршрутов
	//|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВодителиПоМаршруту.СрезПоследних(&ДатаДок, ) КАК ВодителиПоМаршрутуСрезПоследних
	//|				ПО ВЗ_НоменклатураМаршрутов.Маршрут = ВодителиПоМаршрутуСрезПоследних.Маршрут
	//|				ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	////+++АК KIRN 2018.08.24  
	//|					МАКСИМУМ(ДокМаршЛист.Ссылка) КАК Рейс,
	//|					ДокМаршЛист.Маршрут КАК Маршрут,
	//|					ДокМаршЛист.Организация КАК Организация,
	//|					ДокМаршЛист.СтруктурноеПодразделение КАК СтруктурноеПодразделение
	//|				ИЗ
	//|					Документ.МаршрутныйЛист КАК ДокМаршЛист
	//|				ГДЕ
	//|					ДокМаршЛист.ПометкаУдаления = ЛОЖЬ
	//|					И ДокМаршЛист.Отгружено = ЛОЖЬ
	//|					И НАЧАЛОПЕРИОДА(ДокМаршЛист.Дата, ДЕНЬ) = &ДатаДок
	//|				СГРУППИРОВАТЬ ПО
	//|					ДокМаршЛист.Маршрут,
	//|					ДокМаршЛист.Организация,
	//|					ДокМаршЛист.СтруктурноеПодразделение
	//|				) КАК ВЗ_Рейсы
	//|				ПО ВЗ_НоменклатураМаршрутов.Маршрут = ВЗ_Рейсы.Маршрут) КАК ВЗ_МаршрутыРейсы
	//|		ПО втИзменения.Номенклатура = ВЗ_МаршрутыРейсы.Номенклатура
	//|			И втИзменения.СтруктурнаяЕдиница = ВЗ_МаршрутыРейсы.ТорговаяТочка
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	ВЗ_МаршрутыРейсы.Маршрут,
	//|	ВЗ_МаршрутыРейсы.МаршрутныйЛист,
	//|	втИзменения.Склад,
	//|	втИзменения.СтруктурнаяЕдиница,
	//|	втИзменения.РасходныйОрдер";
	////|	втИзменения.ЗаданиеНаРазборку
	//
	//РезультатЗапроса = Запрос.ВыполнитьПакет();
	//ВсеРасходники = РезультатЗапроса[2].Выгрузить();
	//
	//тзВыборка = РезультатЗапроса[РезультатЗапроса.Количество()-1].Выгрузить();
	//Выборка = РезультатЗапроса[РезультатЗапроса.Количество()-1].Выбрать();
	//
	//ВидПеревозкиНаТТ = Справочники.АК_ВидыПеревозки.ДоставкаНаТТ;
	//
	////+++АК sole 2018.06.19 ИП-00018944
	//тзТарифы = РегистрыСведений.СтоимостьУслугПоДоставкеТовараНаТТ.ПолучитьТЗТарифы(Дата); 
	//СтруктураОтбора = Новый Структура();
	////---АК sole 2018.06.19 ИП-00018944
	//
	//ТаблицаБезМаршрутов = Новый ТаблицаЗначений();
	//ТаблицаБезМаршрутов.Колонки.Добавить("Склад"			, Новый ОписаниеТипов("СправочникСсылка.Склады"));
	//ТаблицаБезМаршрутов.Колонки.Добавить("ТорговаяТочка"	, Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	//ТаблицаБезМаршрутов.Колонки.Добавить("Номенклатура"	, Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	//ТаблицаБезМаршрутов.Колонки.Добавить("Характеристика"	, Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	//ТаблицаБезМаршрутов.Колонки.Добавить("Количество"		, Новый ОписаниеТипов("Число"));
	//ТаблицаБезМаршрутов.Колонки.Добавить("РасходныйОрдер"	, Новый ОписаниеТипов("ДокументСсылка.РасходныйОрдерСклад"));
	//ТаблицаБезМаршрутов.Колонки.Добавить("ЗаданиеНаРазборку", Новый ОписаниеТипов("ДокументСсылка.ЗаданиеНаРазборку"));
	//
	//Пока Выборка.СледующийПоЗначениюПоля("Маршрут") Цикл
	//	Пока Выборка.СледующийПоЗначениюПоля("МаршрутныйЛист") Цикл
	//		ЕстьМаршрут = Истина;
	//		Если НЕ ЗначениеЗаполнено(Выборка.МаршрутныйЛист) Тогда
	//			Если ЗначениеЗаполнено(Выборка.Маршрут) ТОгда
	//				МаршЛистОбъект = Документы.МаршрутныйЛист.СоздатьДокумент();
	//				МаршЛистОбъект.Дата 					= Дата;
	//				МаршЛистОбъект.Организация				= Выборка.СкладОрганизация;
	//				МаршЛистОбъект.СтруктурноеПодразделение = Выборка.ТорговаяТочка;
	//				МаршЛистОбъект.Автомобиль 				= Выборка.Автомобиль;
	//				ТекМаршрут = Выборка.Маршрут;
	//				МаршЛистОбъект.Маршрут 					= ТекМаршрут;
	//				МаршЛистОбъект.ВидПеревозки				= ВидПеревозкиНаТТ;
	//				
	//				//+++АК sole 2018.06.19 ИП-00018944
	//				СтруктураОтбора.Очистить();
	//				СтруктураОтбора.Вставить("Маршрут", ТекМаршрут);
	//				мТариф = тзТарифы.НайтиСтроки(СтруктураОтбора);
	//				
	//				Если мТариф.Количество() <> 0 Тогда
	//					СтрТариф = мТариф[0];
	//					МаршЛистОбъект.ВариантРасчетаНДС = СтрТариф["ВариантРасчетаНДС"];
	//					МаршЛистОбъект.СтавкаНДС = СтрТариф["СтавкаНДС"]; 
	//				КонецЕсли;
	//				
	//				ЗаполнитьЗначенияСвойств(МаршЛистОбъект, ТекМаршрут,
	//				"СтруктурноеПодразделение, Перевозчик");
	//				//---АК sole 2018.06.19 ИП-00018944

	//				МаршЛистОбъект.ТорговыеТочки.Загрузить(ТекМаршрут.ТорговыеТочки.Выгрузить());
	//			Иначе
	//				 ЕстьМаршрут = Ложь;
	//			КонецЕСли;
	//		Иначе
	//			МаршЛистОбъект = Выборка.МаршрутныйЛист.ПолучитьОбъект();
	//		КонецЕсли;

	//		
	//		Пока Выборка.СледующийПоЗначениюПоля("Склад") Цикл
	//			Пока Выборка.СледующийПоЗначениюПоля("СтруктурнаяЕдиница") Цикл
	//				Пока Выборка.СледующийПоЗначениюПоля("РасходныйОрдер") Цикл
	//					Если НЕ ЗначениеЗаполнено(Выборка.РасходныйОрдер) Тогда
	//						мсСтрокиРО = ВсеРасходники.НайтиСтроки(Новый Структура("Склад, СтруктурнаяЕдиница", Выборка.Склад, Выборка.СтруктурнаяЕдиница));
	//						Если мсСтрокиРО.Количество()>0 ТОгда
	//							РасхОрдерОбъект = мсСтрокиРО[0].Ссылка.ПолучитьОбъект();
	//						Иначе
	//							РасхОрдерОбъект = Документы.РасходныйОрдерСклад.СоздатьДокумент();
	//							ЗаполнитьШапкуРО(РасхОрдерОбъект,Выборка);
	//						КонецЕСли;
	//					Иначе
	//						РасхОрдерОбъект = Выборка.РасходныйОрдер.ПолучитьОбъект();
	//					КонецЕсли;
	//					
	//					Пока Выборка.Следующий() Цикл
	//						
	//						СтрокиТовар = РасхОрдерОбъект.Товары.НайтиСтроки(Новый Структура("Номенклатура, Характеристика, ДатаПроизводства", Выборка.Номенклатура, Выборка.Характеристика, Выборка.ДатаПроизводстваПред));
	//						
	//						Если СтрокиТовар.Количество() > 0 Тогда
	//							СтрокаТовар = СтрокиТовар[0];
	//						Иначе
	//							СтрокаТовар = РасхОрдерОбъект.Товары.Добавить();
	//						КонецЕсли;	
	//						ЗаполнитьСтрокуРО(СтрокаТОвар, Выборка);
	//					КонецЦикла;
	//					
	//					
	//					Если НЕ РасхОрдерОбъект.ЭтоНовый()
	//						ИЛИ (РасхОрдерОбъект.Товары.Количество() > 0 И РасхОрдерОбъект.Модифицированность()) Тогда
	//						РасхОрдерОбъект.Товары.Сортировать("Номенклатура");
	//						РасхОрдерОбъект.Записать(?(РасхОрдерОбъект.ПометкаУдаления, РежимЗаписиДокумента.Запись, РежимЗаписиДокумента.Проведение));
	//						
	//						Если ЕстьМаршрут ТОгда
	//							СтрокаРасхОрдер = МаршЛистОбъект.РасходныеОрдера.Найти(РасхОрдерОбъект.Ссылка, "Документ");
	//							Если СтрокаРасхОрдер = Неопределено Тогда
	//								СтрокаРасхОрдер = МаршЛистОбъект.РасходныеОрдера.Добавить();
	//								СтрокаРасхОрдер.Документ = РасхОрдерОбъект.Ссылка;
	//							КонецЕсли;
	//						КонецЕсли;
	//					КонецЕсли;
	//					
	//					тзТоварыРО = РасхОрдерОбъект.Товары.НайтиСтроки(Новый Структура("ЗаданиеНаРазборку",Ссылка));
	//					
	//					Для Каждого СтрТЗТоварыРО из тзТоварыРО Цикл
	//						СтрокиЗадание = Товары.НайтиСтроки(Новый Структура("СтруктурнаяЕдиница, ДатаПроизводства", Выборка.СтруктурнаяЕдиница, СтрТЗТоварыРО.ДатаПроизводства));
	//						Если СтрокиЗадание.Количество()>0 ТОгда
	//							СтрокиЗадание[0].РасходныйОрдер = РасхОрдерОбъект.Ссылка;
	//							СтрокиЗадание[0].ДатаПроизводстваПред = СтрокиЗадание[0].ДатаПроизводства;
	//							
	//							Если НЕ ЕстьМаршрут Тогда
	//								СтрокаБезМаршрута = ТаблицаБезМаршрутов.Добавить();
	//								СтрокаБезМаршрута.Склад = РасхОрдерОбъект.Склад;
	//								СтрокаБезМаршрута.ТорговаяТочка = РасхОрдерОбъект.Получатель;
	//								СтрокаБезМаршрута.Номенклатура = СтрТЗТоварыРО.Номенклатура;
	//								СтрокаБезМаршрута.Характеристика = СтрТЗТоварыРО.Характеристика;
	//								СтрокаБезМаршрута.Количество = СтрТЗТоварыРО.Количество;
	//								СтрокаБезМаршрута.РасходныйОрдер = РасхОрдерОбъект.Ссылка;
	//								СтрокаБезМаршрута.ЗаданиеНаРазборку = Ссылка;
	//							КонецЕСли;
	//						КонецЕСли;
	//					КонецЦикла;
	//					Если Товары.Найти(ДОкументы.РасходныйОрдерСклад.ПустаяСсылка()) = Неопределено Тогда
	//						Закрыто=Истина;
	//					КонецЕсли;
	//				КонецЦикла;
	//			КонецЦикла;
	//		КонецЦикла;
	//		
	//		Если ЕстьМаршрут Тогда
	//			Если НЕ МаршЛистОбъект.ЭтоНовый()
	//				ИЛИ (МаршЛистОбъект.РасходныеОрдера.Количество() > 0 И МаршЛистОбъект.Модифицированность()) Тогда
	//				МаршЛистОбъект.Записать(?(МаршЛистОбъект.ПометкаУдаления, РежимЗаписиДокумента.Запись, РежимЗаписиДокумента.Проведение));
	//			КонецЕсли;	
	//		КонецЕСли;
	//	КонецЦикла;
	//КонецЦикла;	
	//
	//ДЛя Каждого Стр из ТаблицаБезМаршрутов Цикл
	//	Сообщить("Нет маршрута для "+Стр.Склад+" "+Стр.ТорговаяТочка + " "+Стр.Номенклатура + " "+Стр.Характеристика +" "+Стр.Количество +" "+Стр.РасходныйОрдер +" "+Стр.ЗаданиеНаРазборку);
	//КонецЦикла;

	//Если Не отказ Тогда
	//	ЗакрытоИОбновлено = Истина;
	//КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	// записать данные в archive_rasp
	Если ЭтотОбъект.Подготовлен И НЕ ОбщегоНазначенияПовтИсп.ЭтоКопияБазы() Тогда 
		Попытка
			ВнешниеИсточникиДанных.m2.dbo_set_pickup_itog_1c(ЭтотОбъект.Номер);
		Исключение
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры



