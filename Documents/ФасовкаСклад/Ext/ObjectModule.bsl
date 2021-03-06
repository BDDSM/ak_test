﻿
Перем ТекДата;
Перем ТабИзмененийВДвижениях;

Процедура ПриКопировании(ОбъектКопирования)
	
	ИзмененияДвижений.Очистить();
	
КонецПроцедуры

Функция ПолучитьТаблицуИзмененийВДвижениях()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("Регистратор"	, Ссылка);
	Запрос.УстановитьПараметр("Товары"		, Товары.Выгрузить());
	Запрос.УстановитьПараметр("Склад"		, Склад);
	Запрос.УстановитьПараметр("ВидОперации"		, ВидОперации);
	//+++АК SHEP 2018.05.06 ИП-00018453
	//Запрос.УстановитьПараметр("СторонняяПереработка", (Склад.Владелец = Справочники.СтруктурныеЕдиницы.СторонняяПереработка));
	Запрос.УстановитьПараметр("СторонняяПереработка", Склад.Владелец.СторонняяПереработка);
	//---АК SHEP 2018.05.06
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТоварыНаСкладах.Склад,
	|	ТоварыНаСкладах.Номенклатура,
	|	ТоварыНаСкладах.Характеристика,
	|	ТоварыНаСкладах.ДатаПроизводства,
	|	ТоварыНаСкладах.ЕдиницаИзмерения,
	|	СУММА(ТоварыНаСкладах.Количество * ВЫБОР
	|			КОГДА ТоварыНаСкладах.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА 1
	|			ИНАЧЕ -1
	|		КОНЕЦ) КАК Количество
	|ПОМЕСТИТЬ ВТ_Движения
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах КАК ТоварыНаСкладах
	|ГДЕ
	|	ТоварыНаСкладах.Регистратор = &Регистратор
	//+++АК SHEP 2018.05.06 ИП-00018453
	//|	И ТоварыНаСкладах.Склад.Владелец <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.СторонняяПереработка)
	|	И НЕ ТоварыНаСкладах.Склад.Владелец.СторонняяПереработка
	//---АК SHEP 2018.05.06
	|	И ТоварыНаСкладах.Активность = ИСТИНА
	|	И (ТоварыНаСкладах.КорректировкаПоИнвентаризации = НЕОПРЕДЕЛЕНО
	|			ИЛИ ТоварыНаСкладах.КорректировкаПоИнвентаризации = ЗНАЧЕНИЕ(Документ.ИнвентаризацияСклад.ПустаяСсылка))
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыНаСкладах.Склад,
	|	ТоварыНаСкладах.Номенклатура,
	|	ТоварыНаСкладах.Характеристика,
	|	ТоварыНаСкладах.ДатаПроизводства,
	|	ТоварыНаСкладах.ЕдиницаИзмерения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Склад КАК Склад,
	|	ФасовкаСкладТовары.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &СторонняяПереработка
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|		ИНАЧЕ ФасовкаСкладТовары.Характеристика
	|	КОНЕЦ КАК Характеристика,
	|	ФасовкаСкладТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВЫБОР
	|		КОГДА &СторонняяПереработка
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ ФасовкаСкладТовары.ДатаПроизводства
	|	КОНЕЦ КАК ДатаПроизводства,
	|	ФасовкаСкладТовары.Количество * -1 КАК Количество
	|ПОМЕСТИТЬ ВТ_Врем1
	|ИЗ
	|	&Товары КАК ФасовкаСкладТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Склад,
	|	ФасовкаСкладТовары.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &СторонняяПереработка
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|		ИНАЧЕ ФасовкаСкладТовары.ХарактеристикаПолучено
	|	КОНЕЦ КАК Характеристика,
	|	ФасовкаСкладТовары.ЕдиницаИзмерения,
	|	ВЫБОР
	|		КОГДА &СторонняяПереработка
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ ФасовкаСкладТовары.ДатаПроизводства
	|	КОНЕЦ КАК ДатаПроизводства,
	|	ФасовкаСкладТовары.Количество КАК Количество
	|ПОМЕСТИТЬ ВТ_Врем2
	|ИЗ
	|	&Товары КАК ФасовкаСкладТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЗ_Запрос.Склад,
	|	ВЗ_Запрос.Номенклатура,
	|	ВЗ_Запрос.Характеристика,
	|	ВЗ_Запрос.ЕдиницаИзмерения,
	|	ВЗ_Запрос.ДатаПроизводства,
	|	ВЗ_Запрос.Количество
	|ПОМЕСТИТЬ ВТ_ТабТовары
	|ИЗ
	|	(ВЫБРАТЬ
	|		ФасовкаСкладТовары.Склад КАК Склад,
	|		ФасовкаСкладТовары.Номенклатура КАК Номенклатура,
	|		ФасовкаСкладТовары.Характеристика КАК Характеристика,
	|		ФасовкаСкладТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ФасовкаСкладТовары.ДатаПроизводства КАК ДатаПроизводства,
	|		ФасовкаСкладТовары.Количество КАК Количество
	|	ИЗ
	|		ВТ_Врем1 КАК ФасовкаСкладТовары
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ФасовкаСкладТовары.Склад,
	|		ФасовкаСкладТовары.Номенклатура,
	|		ФасовкаСкладТовары.Характеристика,
	|		ФасовкаСкладТовары.ЕдиницаИзмерения,
	|		ФасовкаСкладТовары.ДатаПроизводства,
	|		ФасовкаСкладТовары.Количество
	|	ИЗ
	|		ВТ_Врем2 КАК ФасовкаСкладТовары) КАК ВЗ_Запрос
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВТ_Движения.Склад, ВЗ_Товары.Склад) КАК Склад,
	|	ЕСТЬNULL(ВТ_Движения.Номенклатура, ВЗ_Товары.Номенклатура) КАК Номенклатура,
	|	ЕСТЬNULL(ВТ_Движения.Характеристика, ВЗ_Товары.Характеристика) КАК Характеристика,
	|	ЕСТЬNULL(ВТ_Движения.ДатаПроизводства, ВЗ_Товары.ДатаПроизводства) КАК ДатаПроизводства,
	|	ЕСТЬNULL(ВТ_Движения.ЕдиницаИзмерения, ВЗ_Товары.ЕдиницаИзмерения) КАК ЕдиницаИзмерения,
	|	ЕСТЬNULL(ВЗ_Товары.Количество, 0) - ЕСТЬNULL(ВТ_Движения.Количество, 0) КАК Количество
	|ИЗ
	|	ВТ_Движения КАК ВТ_Движения
	|		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ВТ_ТабТовары.Склад КАК Склад,
	|			ВТ_ТабТовары.Номенклатура КАК Номенклатура,
	|			ВТ_ТабТовары.Характеристика КАК Характеристика,
	|			ВТ_ТабТовары.ДатаПроизводства КАК ДатаПроизводства,
	|			ВТ_ТабТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|			СУММА(ВТ_ТабТовары.Количество) КАК Количество
	|		ИЗ
	|			ВТ_ТабТовары КАК ВТ_ТабТовары
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВТ_ТабТовары.Склад,
	|			ВТ_ТабТовары.Номенклатура,
	|			ВТ_ТабТовары.Характеристика,
	|			ВТ_ТабТовары.ДатаПроизводства,
	|			ВТ_ТабТовары.ЕдиницаИзмерения) КАК ВЗ_Товары
	|		ПО ВТ_Движения.Склад = ВЗ_Товары.Склад
	|			И ВТ_Движения.Номенклатура = ВЗ_Товары.Номенклатура
	|			И ВТ_Движения.Характеристика = ВЗ_Товары.Характеристика
	|			И ВТ_Движения.ДатаПроизводства = ВЗ_Товары.ДатаПроизводства
	|			И ВТ_Движения.ЕдиницаИзмерения = ВЗ_Товары.ЕдиницаИзмерения
	|ГДЕ
	|	ЕСТЬNULL(ВЗ_Товары.Количество, 0) - ЕСТЬNULL(ВТ_Движения.Количество, 0) <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_Движения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_ТабТовары";
				   
	ТаблицаДвижений = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаДвижений;
	
КонецФункции	

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ТекДата = ТекущаяДата(); //можно брать эту, т.к. код выполняется на сервере и дата будет серверная
		//временное разрешение для финансистов вносить документы с дивжениями датой документов
		ТабИзмененийВДвижениях = ПолучитьТаблицуИзмененийВДвижениях();
		Если ТабИзмененийВДвижениях.Количество() > 0 Тогда
			СтрокаТаб = ИзмененияДвижений.Добавить();
			СтрокаТаб.ДатаИзменения = ТекДата;
			СтрокаТаб.Пользователь = ПараметрыСеанса.ТекущийПользователь;
		КонецЕсли;
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		//Общий запрет
		ЕстьПравоОтменять = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьОтменуСкладскихДокументов, Ложь);
		
		Если НЕ ЕстьПравоОтменять Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("У вас нет права отменять складские документы с видом операции """ + Строка(ВидОперации) + """");
			Возврат;
		КонецЕсли;	
		ИзмененияДвижений.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ++ АК Зайцева А. 14582
	Если ЗначениеЗаполнено(ЭтотОбъект.Склад) И ЭтотОбъект.Склад.ЗаблокироватьДвижениеПоСкладу И ЭтотОбъект.Склад.ДатаБлокировкиДвижений <= НачалоДня(ТекущаяДата()) Тогда
		Сообщить("Движения по складу " + ЭтотОбъект.Склад.Наименование + " заблокированы! Проведение невозможно.");
		Отказ = Истина;
	КонецЕсли;
	//--
	
	Если ТабИзмененийВДвижениях.Количество() > 0 Тогда
		Движения.ТоварыНаСкладах.Записывать = Истина;
		Движения.ТоварыНаСкладах.Прочитать();
	КонецЕсли;	
	
	Для Каждого СтрокаДвижение Из ТабИзмененийВДвижениях Цикл
		
		//пХарактеристика = ?(СтрокаДвижение.Склад.Владелец = Справочники.СтруктурныеЕдиницы.СторонняяПереработка, Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка(), СтрокаДвижение.Характеристика);
		
		Движение = Движения.ТоварыНаСкладах.ДобавитьПриход();
		Движение.Период 			= ТекДата;
		Движение.Склад 				= СтрокаДвижение.Склад;
		Движение.Номенклатура 		= СтрокаДвижение.Номенклатура;
		Движение.Характеристика 	= СтрокаДвижение.Характеристика;
		Движение.ДатаПроизводства 	= СтрокаДвижение.ДатаПроизводства;
		Движение.ЕдиницаИзмерения	= СтрокаДвижение.ЕдиницаИзмерения;
		Движение.Количество 		= СтрокаДвижение.Количество;
		Движение.АвторИзменений		= ПараметрыСеанса.ТекущийПользователь;
		
	КонецЦикла;
	
КонецПроцедуры


