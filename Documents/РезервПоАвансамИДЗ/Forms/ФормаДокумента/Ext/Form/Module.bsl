﻿
&НаКлиенте
Процедура Заполнить(Команда)
	
	Если не Объект.Проведен Тогда
		ЗаполнитьРезервыНаСервере();
	Иначе 
		Сообщить("Нельзя перезаполнять проведенный документ");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРезервыНаСервере()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты) КАК Контрагент,
		|	ФинансовыйОбороты.Счет КАК Счет,
		|	СУММА(ФинансовыйОбороты.СуммаОстатокДт) КАК СуммаОстатокДт,
		|	ВЫБОР
		|		КОГДА ФинансовыйОбороты.Организация ЕСТЬ NULL
		|				ИЛИ ФинансовыйОбороты.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|			ТОГДА ФинансовыйОбороты.Субконто1
		|		ИНАЧЕ ФинансовыйОбороты.Организация
		|	КОНЕЦ КАК Организация
		|ПОМЕСТИТЬ ВТ_Остатки
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Остатки(
		|			&ДатаОкончания,
		|			Счет В (&СписокСчетов),
		|			,
		|			(Организация = &Организация
		|				ИЛИ Субконто1 = &Организация)
		|				И НЕ Субконто2 В (&ИсключаемКонтрагентов)) КАК ФинансовыйОбороты
		|ГДЕ
		|	ФинансовыйОбороты.СуммаОстатокДт <> 0
		|
		|СГРУППИРОВАТЬ ПО
		|	ФинансовыйОбороты.Счет,
		|	ВЫБОР
		|		КОГДА ФинансовыйОбороты.Организация ЕСТЬ NULL
		|				ИЛИ ФинансовыйОбороты.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|			ТОГДА ФинансовыйОбороты.Субконто1
		|		ИНАЧЕ ФинансовыйОбороты.Организация
		|	КОНЕЦ,
		|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент,
		|	Счет
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ФинансовыйОбороты.Период,
		|	ФинансовыйОбороты.Счет,
		|	ФинансовыйОбороты.Регистратор,
		|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты) КАК Контрагент,
		|	ФинансовыйОбороты.СуммаОборотДт,
		|	ВТ_Остатки.СуммаОстатокДт,
		|	ВТ_Остатки.Организация,
		|	ФинансовыйОбороты.КорСчет
		|ПОМЕСТИТЬ ВТ_РегистраторыБезОпераций
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Обороты(
		|			,
		|			ДОБАВИТЬКДАТЕ(&ДатаОкончания, СЕКУНДА, -1),
		|			Регистратор,
		|			Счет В
		|				(ВЫБРАТЬ
		|					Т.Счет
		|				ИЗ
		|					ВТ_Остатки КАК Т),
		|			,
		|			(Субконто1, Субконто2) В
		|				(ВЫБРАТЬ
		|					Т.Организация,
		|					Т.Контрагент
		|				ИЗ
		|					ВТ_Остатки КАК Т),
		|			КорСчет <> ЗНАЧЕНИЕ(ПланСчетов.Финансовый.Вспомогательный),
		|			) КАК ФинансовыйОбороты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
		|		ПО (ВТ_Остатки.Счет = ФинансовыйОбороты.Счет)
		|			И (ВТ_Остатки.Контрагент = ФинансовыйОбороты.Субконто2)
		|			И ФинансовыйОбороты.Субконто1 = ВТ_Остатки.Организация
		|ГДЕ
		|	ФинансовыйОбороты.СуммаОборотДт <> 0
		//+++АК sils 11.07.2018 ИП-00017746
		|" + ?(ЗначениеЗаполнено(Объект.Организация) и СокрЛП(Объект.Организация.ИНН) <> "7726660031", "
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ФинансовыйОбороты.Период,
		|	ФинансовыйОбороты.Счет,
		|	ФинансовыйОбороты.Регистратор,
		|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты),
		|	ФинансовыйОбороты.СуммаОборотДт,
		|	ВТ_Остатки.СуммаОстатокДт,
		|	&Организация,
		|	ФинансовыйОбороты.КорСчет
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Обороты(
		|			,
		|			ДОБАВИТЬКДАТЕ(&ДатаОкончания, СЕКУНДА, -1),
		|			Регистратор,
		|			Счет В
		|				(ВЫБРАТЬ
		|					Т.Счет
		|				ИЗ
		|					ВТ_Остатки КАК Т),
		|			,
		|			(Субконто1, Субконто2) В
		|				(ВЫБРАТЬ
		|					&ЛугДаПоле,
		|					ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты) КАК Контрагент
		|				ИЗ
		|					РегистрБухгалтерии.Финансовый.Обороты(, , Регистратор, Счет В (&СписокСчетов), , Организация = &ЛугДаПоле, , ) КАК ФинансовыйОбороты
		|				ГДЕ
		|					ФинансовыйОбороты.Регистратор ССЫЛКА Документ.Операция
		|					И ФинансовыйОбороты.Регистратор.Номер = ""LP000000041""
		|					И ГОД(ФинансовыйОбороты.Регистратор.Дата) = 2018),
		|			КорСчет <> ЗНАЧЕНИЕ(ПланСчетов.Финансовый.Вспомогательный),
		|			) КАК ФинансовыйОбороты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
		|		ПО (ВТ_Остатки.Счет = ФинансовыйОбороты.Счет)
		|			И (ВТ_Остатки.Контрагент = ФинансовыйОбороты.Субконто2)
		|			И (ФинансовыйОбороты.Субконто1 = &ЛугДаПоле)
		|ГДЕ
		|	ФинансовыйОбороты.СуммаОборотДт <> 0
		|", "") + "
		//---АК
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Регистраторы.Контрагент КАК Контрагент,
		|	ВТ_Регистраторы.Счет КАК Счет,
		|	ВТ_Регистраторы.Период КАК Период,
		|	ВТ_Регистраторы.Регистратор КАК Регистратор,
		|	ВТ_Регистраторы.СуммаОборотДт КАК СуммаДокумента,
		|	ВТ_Регистраторы.СуммаОстатокДт КАК СуммаОстатокДт,
		|	СУММА(ЕСТЬNULL(ВТ_Регистраторы_2.СуммаОборотДт, 0)) КАК СуммаОборотДт,
		|	ВТ_Регистраторы.Организация,
		|	ВТ_Регистраторы.КорСчет
		|ПОМЕСТИТЬ ВТ_СуммыОборотовНарастающим
		|ИЗ
		|	ВТ_РегистраторыБезОпераций КАК ВТ_Регистраторы
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_РегистраторыБезОпераций КАК ВТ_Регистраторы_2
		|		ПО (ВТ_Регистраторы_2.Контрагент = ВТ_Регистраторы.Контрагент)
		|			И (ВТ_Регистраторы_2.Счет = ВТ_Регистраторы.Счет)
		|			И (ВТ_Регистраторы_2.Период > ВТ_Регистраторы.Период
		|				ИЛИ ВТ_Регистраторы_2.Период = ВТ_Регистраторы.Период
		|					И ВТ_Регистраторы_2.Регистратор > ВТ_Регистраторы.Регистратор)
		|			И ВТ_Регистраторы.Организация = ВТ_Регистраторы_2.Организация
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_Регистраторы.Контрагент,
		|	ВТ_Регистраторы.Счет,
		|	ВТ_Регистраторы.Период,
		|	ВТ_Регистраторы.Регистратор,
		|	ВТ_Регистраторы.СуммаОборотДт,
		|	ВТ_Регистраторы.СуммаОстатокДт,
		|	ВТ_Регистраторы.Организация,
		|	ВТ_Регистраторы.КорСчет
		|
		|ИМЕЮЩИЕ
		|	СУММА(ЕСТЬNULL(ВТ_Регистраторы_2.СуммаОборотДт, 0)) < ВТ_Регистраторы.СуммаОстатокДт
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты) КАК Контрагент,
		|	ВЫБОР
		|		КОГДА ФинансовыйОбороты.Организация ЕСТЬ NULL
		|				ИЛИ ФинансовыйОбороты.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|			ТОГДА ФинансовыйОбороты.Субконто1
		|		ИНАЧЕ ФинансовыйОбороты.Организация
		|	КОНЕЦ КАК Организация,
		|	СУММА(ЕСТЬNULL(ФинансовыйОбороты.СуммаОборотКт, 0)) КАК Сумма
		|ПОМЕСТИТЬ втПоступленияОтКонтрагента
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			,
		|			Счет В (&СписокСчетов),
		|			,
		|			Организация = &Организация
		|				ИЛИ Субконто1 = &Организация,
		|			,
		|			) КАК ФинансовыйОбороты
		|ГДЕ
		|	ФинансовыйОбороты.СуммаОборотКт > 0
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА ФинансовыйОбороты.Организация ЕСТЬ NULL
		|				ИЛИ ФинансовыйОбороты.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|			ТОГДА ФинансовыйОбороты.Субконто1
		|		ИНАЧЕ ФинансовыйОбороты.Организация
		|	КОНЕЦ,
		|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаЗадолженности.Контрагент,
		|	ТаблицаЗадолженности.Счет КАК СчетУчета,
		|	ТаблицаЗадолженности.Регистратор КАК Документ,
		|	ТаблицаЗадолженности.СуммаДокумента КАК СуммаДокумента,
		|	ВЫБОР
		|		КОГДА ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт >= ТаблицаЗадолженности.СуммаДокумента
		|			ТОГДА ТаблицаЗадолженности.СуммаДокумента
		|		ИНАЧЕ ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт
		|	КОНЕЦ КАК Сумма,
		|	РАЗНОСТЬДАТ(ТаблицаЗадолженности.Период, &ДатаОкончания, ДЕНЬ) КАК ДнейПрошло,
		|	ЕСТЬNULL(втПоступленияОтКонтрагента.Сумма, 0) КАК ПоступленияЗаПериод
		|ПОМЕСТИТЬ втРезультат
		|ИЗ
		|	ВТ_СуммыОборотовНарастающим КАК ТаблицаЗадолженности
		|		ЛЕВОЕ СОЕДИНЕНИЕ втПоступленияОтКонтрагента КАК втПоступленияОтКонтрагента
		|		ПО ТаблицаЗадолженности.Контрагент = втПоступленияОтКонтрагента.Контрагент
		|			И ТаблицаЗадолженности.Организация = втПоступленияОтКонтрагента.Организация,
		|	РегистрСведений.СрокПереходаДЗВСомнительную.СрезПоследних(&ДатаОкончания, ) КАК СрокПереходаДЗВСомнительнуюСрезПоследних
		|ГДЕ
		|	РАЗНОСТЬДАТ(ТаблицаЗадолженности.Период, &ДатаОкончания, ДЕНЬ) > ЕСТЬNULL(СрокПереходаДЗВСомнительнуюСрезПоследних.Срок, 0)
		|	И НЕ ЕСТЬNULL(втПоступленияОтКонтрагента.Сумма, 0) > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втРезультат.Контрагент,
		|	втРезультат.СчетУчета,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ втРезультат.Документ) КАК Документов,
		|	СУММА(втРезультат.СуммаДокумента) КАК СуммаДокумента,
		|	СУММА(втРезультат.Сумма) КАК Сумма,
		|	МИНИМУМ(втРезультат.ДнейПрошло) КАК МинимумДней,
		|	МАКСИМУМ(втРезультат.ДнейПрошло) КАК МаксимумДней
		|ИЗ
		|	втРезультат КАК втРезультат
		|
		|СГРУППИРОВАТЬ ПО
		|	втРезультат.Контрагент,
		|	втРезультат.СчетУчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ФинансовыйОстатки.Субконто1 КАК Контрагент,
		|	ФинансовыйОстатки.СуммаОстатокКт + ФинансовыйОстатки.СуммаМСФООстатокКт КАК Текущий,
		|	0 КАК Требуется
		|ПОМЕСТИТЬ втРезерв
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Остатки(&ДатаОкончания, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РезервНаСписаниеБезнадежнойДЗ), , Организация = &Организация) КАК ФинансовыйОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	втРезультат.Контрагент,
		|	0,
		|	СУММА(втРезультат.Сумма)
		|ИЗ
		|	втРезультат КАК втРезультат
		|
		|СГРУППИРОВАТЬ ПО
		|	втРезультат.Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втРезерв.Контрагент,
		|	СУММА(ЕСТЬNULL(втРезерв.Текущий, 0)) КАК Текущий,
		|	СУММА(ЕСТЬNULL(втРезерв.Требуется, 0)) КАК Требуется
		|ПОМЕСТИТЬ втРезультатРезерв
		|ИЗ
		|	втРезерв КАК втРезерв
		|
		|СГРУППИРОВАТЬ ПО
		|	втРезерв.Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втРезультатРезерв.Контрагент,
		|	втРезультатРезерв.Текущий,
		|	втРезультатРезерв.Требуется,
		|	ВЫБОР
		|		КОГДА втРезультатРезерв.Текущий > втРезультатРезерв.Требуется
		|			ТОГДА втРезультатРезерв.Текущий - втРезультатРезерв.Требуется
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК КСписанию,
		|	ВЫБОР
		|		КОГДА втРезультатРезерв.Требуется > втРезультатРезерв.Текущий
		|			ТОГДА втРезультатРезерв.Требуется - втРезультатРезерв.Текущий
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК КНачислению
		|ИЗ
		|	втРезультатРезерв КАК втРезультатРезерв";
		
	СписокСчетов = Новый СписокЗначений;
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.РасчетыПоАренде);
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщиками);	
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщикамиОборудования);	
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщикамиУпаковки);	
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.ПрочаяЗадолженность);	
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.РасчетыСПрочимиПоставщикамиИПодрядчиками);	
	
	Запрос.УстановитьПараметр("ДатаОкончания",Объект.Дата);
	Запрос.УстановитьПараметр("ДатаНачала",НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("Организация",Объект.Организация);
	//ИП-00014746.01 koro Исключаем "бонус по Карте"
	СписокИсключаемыхКонтрагентов = Новый СписокЗначений;
	СписокИсключаемыхКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("000000970"));	
	Запрос.УстановитьПараметр("ИсключаемКонтрагентов",СписокИсключаемыхКонтрагентов);
	
	Запрос.УстановитьПараметр("СписокСчетов",СписокСчетов);	
	//+++АК sils 11.07.2018 ИП-00017746
	Запрос.УстановитьПараметр("ЛугДаПоле", Справочники.Организации.НайтиПоРеквизиту("ИНН", "7726660031"));
	//---АК
	
	Результат = Запрос.ВыполнитьПакет();
	
	ТаблицаТекущаяЗадолженность = Результат[5].Выгрузить();
    ТаблицаНачислениеСписаниеРезерва = Результат[8].Выгрузить();
	
	
	Объект.ТекущаяЗадолженность.Загрузить(ТаблицаТекущаяЗадолженность);
	Объект.НачислениеСписаниеРезерва.Загрузить(ТаблицаНачислениеСписаниеРезерва);
	
	
	
	ОбновитьСуммыИтого();
	
 КонецПроцедуры	
 
 Процедура ЗаполнитьРезервыНаСервереСтарая()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты) КАК Контрагент,
		|	ФинансовыйОбороты.Счет КАК Счет,
		|	СУММА(ФинансовыйОбороты.СуммаОстатокДт) КАК СуммаОстатокДт,
		|	ВЫБОР
		|		КОГДА ФинансовыйОбороты.Организация ЕСТЬ NULL 
		|				ИЛИ ФинансовыйОбороты.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|			ТОГДА ФинансовыйОбороты.Субконто1
		|		ИНАЧЕ ФинансовыйОбороты.Организация
		|	КОНЕЦ КАК Организация
		|ПОМЕСТИТЬ ВТ_Остатки
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Остатки(
		|			&ДатаОкончания,
		|			Счет В (&СписокСчетов),
		|			,
		|			(Организация = &Организация
		|				ИЛИ Субконто1 = &Организация)
		|				И НЕ Субконто2 В (&ИсключаемКонтрагентов)) КАК ФинансовыйОбороты
		|ГДЕ
		|	ФинансовыйОбороты.СуммаОстатокДт <> 0
		|
		|СГРУППИРОВАТЬ ПО
		|	ФинансовыйОбороты.Счет,
		|	ВЫБОР
		|		КОГДА ФинансовыйОбороты.Организация ЕСТЬ NULL 
		|				ИЛИ ФинансовыйОбороты.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|			ТОГДА ФинансовыйОбороты.Субконто1
		|		ИНАЧЕ ФинансовыйОбороты.Организация
		|	КОНЕЦ,
		|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент,
		|	Счет
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ФинансовыйОбороты.Период,
		|	ФинансовыйОбороты.Счет,
		|	ФинансовыйОбороты.Регистратор,
		|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты) КАК Контрагент,
		|	ФинансовыйОбороты.СуммаОборотДт,
		|	ВТ_Остатки.СуммаОстатокДт,
		|	ВТ_Остатки.Организация,
		|	ФинансовыйОбороты.КорСчет
		|ПОМЕСТИТЬ ВТ_Регистраторы
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Обороты(
		|			,
		|			ДОБАВИТЬКДАТЕ(&ДатаОкончания, СЕКУНДА, -1),
		|			Регистратор,
		|			Счет В
		|				(ВЫБРАТЬ
		|					Т.Счет
		|				ИЗ
		|					ВТ_Остатки КАК Т),
		|			,
		|			(Субконто1, Субконто2) В
		|				(ВЫБРАТЬ
		|					Т.Организация,
		|					Т.Контрагент
		|				ИЗ
		|					ВТ_Остатки КАК Т),
		|			,
		|			) КАК ФинансовыйОбороты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
		|		ПО (ВТ_Остатки.Счет = ФинансовыйОбороты.Счет)
		|			И (ВТ_Остатки.Контрагент = ФинансовыйОбороты.Субконто2)
		|			И ФинансовыйОбороты.Субконто1 = ВТ_Остатки.Организация
		|ГДЕ
		|	ФинансовыйОбороты.СуммаОборотДт <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Регистраторы.Контрагент КАК Контрагент,
		|	ВТ_Регистраторы.Счет КАК Счет,
		|	ВТ_Регистраторы.Период КАК Период,
		|	ВТ_Регистраторы.Регистратор КАК Регистратор,
		|	ВТ_Регистраторы.СуммаОборотДт КАК СуммаДокумента,
		|	ВТ_Регистраторы.СуммаОстатокДт КАК СуммаОстатокДт,
		|	СУММА(ЕСТЬNULL(ВТ_Регистраторы_2.СуммаОборотДт, 0)) КАК СуммаОборотДт,
		|	ВТ_Регистраторы.Организация,
		|	ВТ_Регистраторы.КорСчет
		|ПОМЕСТИТЬ ВТ_СуммыОборотовНарастающим
		|ИЗ
		|	ВТ_Регистраторы КАК ВТ_Регистраторы
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Регистраторы КАК ВТ_Регистраторы_2
		|		ПО (ВТ_Регистраторы_2.Контрагент = ВТ_Регистраторы.Контрагент)
		|			И (ВТ_Регистраторы_2.Счет = ВТ_Регистраторы.Счет)
		|			И (ВТ_Регистраторы_2.Период > ВТ_Регистраторы.Период
		|				ИЛИ ВТ_Регистраторы_2.Период = ВТ_Регистраторы.Период
		|					И ВТ_Регистраторы_2.Регистратор > ВТ_Регистраторы.Регистратор)
		|			И ВТ_Регистраторы.Организация = ВТ_Регистраторы_2.Организация
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_Регистраторы.Контрагент,
		|	ВТ_Регистраторы.Счет,
		|	ВТ_Регистраторы.Период,
		|	ВТ_Регистраторы.Регистратор,
		|	ВТ_Регистраторы.СуммаОборотДт,
		|	ВТ_Регистраторы.СуммаОстатокДт,
		|	ВТ_Регистраторы.Организация,
		|	ВТ_Регистраторы.КорСчет
		|
		|ИМЕЮЩИЕ
		|	СУММА(ЕСТЬNULL(ВТ_Регистраторы_2.СуммаОборотДт, 0)) < ВТ_Регистраторы.СуммаОстатокДт
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты) КАК Контрагент,
		|	ВЫБОР
		|		КОГДА ФинансовыйОбороты.Организация ЕСТЬ NULL 
		|				ИЛИ ФинансовыйОбороты.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|			ТОГДА ФинансовыйОбороты.Субконто1
		|		ИНАЧЕ ФинансовыйОбороты.Организация
		|	КОНЕЦ КАК Организация,
		|	СУММА(ЕСТЬNULL(ФинансовыйОбороты.СуммаОборотКт, 0)) КАК Сумма
		|ПОМЕСТИТЬ втПоступленияОтКонтрагента
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			,
		|			Счет В (&СписокСчетов),
		|			,
		|			Организация = &Организация
		|				ИЛИ Субконто1 = &Организация,
		|			,
		|			) КАК ФинансовыйОбороты
		|ГДЕ
		|	ФинансовыйОбороты.СуммаОборотКт > 0
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА ФинансовыйОбороты.Организация ЕСТЬ NULL 
		|				ИЛИ ФинансовыйОбороты.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|			ТОГДА ФинансовыйОбороты.Субконто1
		|		ИНАЧЕ ФинансовыйОбороты.Организация
		|	КОНЕЦ,
		|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаЗадолженности.Контрагент,
		|	ТаблицаЗадолженности.Счет КАК СчетУчета,
		|	ТаблицаЗадолженности.Период КАК Дата,
		|	ТаблицаЗадолженности.Регистратор КАК Документ,
		|	ТаблицаЗадолженности.СуммаДокумента КАК СуммаДокумента,
		|	ВЫБОР
		|		КОГДА ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт >= ТаблицаЗадолженности.СуммаДокумента
		|			ТОГДА ТаблицаЗадолженности.СуммаДокумента
		|		ИНАЧЕ ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт
		|	КОНЕЦ КАК Сумма,
		|	РАЗНОСТЬДАТ(ТаблицаЗадолженности.Период, &ДатаОкончания, ДЕНЬ) КАК ДнейПрошло,
		|	ЕСТЬNULL(втПоступленияОтКонтрагента.Сумма, 0) КАК ПоступленияЗаПериод
		|ПОМЕСТИТЬ втРезультат
		|ИЗ
		|	ВТ_СуммыОборотовНарастающим КАК ТаблицаЗадолженности
		|		ЛЕВОЕ СОЕДИНЕНИЕ втПоступленияОтКонтрагента КАК втПоступленияОтКонтрагента
		|		ПО ТаблицаЗадолженности.Контрагент = втПоступленияОтКонтрагента.Контрагент
		|			И ТаблицаЗадолженности.Организация = втПоступленияОтКонтрагента.Организация,
		|	РегистрСведений.СрокПереходаДЗВСомнительную.СрезПоследних(&ДатаОкончания, ) КАК СрокПереходаДЗВСомнительнуюСрезПоследних
		|ГДЕ
		|	РАЗНОСТЬДАТ(ТаблицаЗадолженности.Период, &ДатаОкончания, ДЕНЬ) > ЕСТЬNULL(СрокПереходаДЗВСомнительнуюСрезПоследних.Срок, 0)
		|	И НЕ ЕСТЬNULL(втПоступленияОтКонтрагента.Сумма, 0) > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втРезультат.Контрагент,
		|	втРезультат.СчетУчета,
		|	втРезультат.Дата,
		|	втРезультат.Документ,
		|	втРезультат.СуммаДокумента,
		|	втРезультат.Сумма,
		|	втРезультат.ДнейПрошло
		|ИЗ
		|	втРезультат КАК втРезультат
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ФинансовыйОстатки.Субконто1 КАК Контрагент,
		|	ФинансовыйОстатки.СуммаОстатокКт КАК Текущий,
		|	0 КАК Требуется
		|ПОМЕСТИТЬ втРезерв
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Остатки(&ДатаОкончания, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РезервНаСписаниеБезнадежнойДЗ), , ) КАК ФинансовыйОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	втРезультат.Контрагент,
		|	0,
		|	СУММА(втРезультат.Сумма)
		|ИЗ
		|	втРезультат КАК втРезультат
		|
		|СГРУППИРОВАТЬ ПО
		|	втРезультат.Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втРезерв.Контрагент,
		|	СУММА(ЕСТЬNULL(втРезерв.Текущий, 0)) КАК Текущий,
		|	СУММА(ЕСТЬNULL(втРезерв.Требуется, 0)) КАК Требуется
		|ПОМЕСТИТЬ втРезультатРезерв
		|ИЗ
		|	втРезерв КАК втРезерв
		|
		|СГРУППИРОВАТЬ ПО
		|	втРезерв.Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втРезультатРезерв.Контрагент,
		|	втРезультатРезерв.Текущий,
		|	втРезультатРезерв.Требуется,
		|	ВЫБОР
		|		КОГДА втРезультатРезерв.Текущий > втРезультатРезерв.Требуется
		|			ТОГДА втРезультатРезерв.Текущий - втРезультатРезерв.Требуется
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК КСписанию,
		|	ВЫБОР
		|		КОГДА втРезультатРезерв.Требуется > втРезультатРезерв.Текущий
		|			ТОГДА втРезультатРезерв.Требуется - втРезультатРезерв.Текущий
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК КНачислению
		|ИЗ
		|	втРезультатРезерв КАК втРезультатРезерв";
		
	СписокСчетов = Новый СписокЗначений;
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.РасчетыПоАренде);
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщиками);	
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщикамиОборудования);	
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщикамиУпаковки);	
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.ПрочаяЗадолженность);	
	СписокСчетов.Добавить(ПланыСчетов.Финансовый.РасчетыСПрочимиПоставщикамиИПодрядчиками);	
	
	Запрос.УстановитьПараметр("ДатаОкончания",Объект.Дата);
	Запрос.УстановитьПараметр("ДатаНачала",НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("Организация",Объект.Организация);
	//ИП-00014746.01 koro Исключаем "бонус по Карте"
	СписокИсключаемыхКонтрагентов = Новый СписокЗначений;
	СписокИсключаемыхКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("000000970"));	
	Запрос.УстановитьПараметр("ИсключаемКонтрагентов",СписокИсключаемыхКонтрагентов);
	
	Запрос.УстановитьПараметр("СписокСчетов",СписокСчетов);	
	
	Результат = Запрос.ВыполнитьПакет();
	
	ТаблицаТекущаяЗадолженность = Результат[5].Выгрузить();
    ТаблицаНачислениеСписаниеРезерва = Результат[8].Выгрузить();
	
	
	Объект.ТекущаяЗадолженность.Загрузить(ТаблицаТекущаяЗадолженность);
	Объект.НачислениеСписаниеРезерва.Загрузить(ТаблицаНачислениеСписаниеРезерва);
	
	
	
	ОбновитьСуммыИтого();
	
 КонецПроцедуры	

 
 
Процедура ОбновитьСуммыИтого()
	
	ОбновитьИтогоТекущаяЗадолженность();
	ОбновитьИтогоНачислениеСписаниеРезерва();
	ОбновитьВсегоСписание();
	
КонецПроцедуры	

Процедура ОбновитьИтогоТекущаяЗадолженность()
	
	ВсегоЗадолженность = Объект.ТекущаяЗадолженность.Итог("Сумма");		
	
КонецПроцедуры	
 
Процедура ОбновитьИтогоНачислениеСписаниеРезерва()
	
	ВсегоКНачислению   = Объект.НачислениеСписаниеРезерва.Итог("КНачислению");
	ВсегоКСписанию     = Объект.НачислениеСписаниеРезерва.Итог("КСписанию");
	ВсегоТекущий       = Объект.НачислениеСписаниеРезерва.Итог("Текущий");
	ВсегоТребуется     = Объект.НачислениеСписаниеРезерва.Итог("Требуется");			
	
КонецПроцедуры	

&НаКлиенте
Процедура ТекущаяЗадолженностьПриИзменении(Элемент)
	
	ОбновитьИтогоТекущаяЗадолженность();	
	
КонецПроцедуры

&НаКлиенте
Процедура НачислениеСписаниеРезерваПриИзменении(Элемент)
	
	ОбновитьИтогоНачислениеСписаниеРезерва();	
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПереходаДебеторскойЗадолженностиВСомнительнуюНажатие(Элемент)
	
	ОткрытьФорму("РегистрСведений.СрокПереходаДЗВСомнительную.ФормаСписка");
	
КонецПроцедуры
 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//+++АК sils 08.06.2018 ИП-00018876
	ОперацияАпдекс = APDEX_ОценкаПроизводительностиКлиентСервер.ПолучитьОперацию("Открытие документа Резерв по авансам и ДЗ");
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(ОперацияАпдекс);
	//---АК
	
	Отказ = НЕ УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РезервПоАвансамИДЗ, Ложь);
	Если Отказ Тогда
		Сообщить("Нет прав на использование документа");
	КонецЕсли;	
	
	Если не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	ОбновитьСрокПереходаВСомнительную();
	ОбновитьСуммыИтого();	
	
КонецПроцедуры

Процедура ОбновитьСрокПереходаВСомнительную()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕстьNULL(СрокПереходаДЗВСомнительнуюСрезПоследних.Срок,0) КАК Срок
		|ИЗ
		|	РегистрСведений.СрокПереходаДЗВСомнительную.СрезПоследних(&ДатаДокумента, ) КАК СрокПереходаДЗВСомнительнуюСрезПоследних";

		
	ДатаДокумента = ?(ЗначениеЗаполнено(Объект.Дата),Объект.Дата,ТекущаяДата());	
		
	Запрос.УстановитьПараметр("ДатаДокумента", ДатаДокумента);
	
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Надпись = "Срок перехода ДЗ в сомнительную не установлен";
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Надпись = "Срок перехода ДЗ в сомнительную: " +  ВыборкаДетальныеЗаписи.Срок + " дней";
	КонецЦикла;

	Элементы.СрокПереходаДебеторскойЗадолженностиВСомнительную.Заголовок = Надпись; 
	
КонецПроцедуры	

&НаКлиенте
Процедура СписаниеДолговКонтрагентПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписаниеДолгов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекущиеДанные.ТекущийРезерв = СуммаРезерва(ТекущиеДанные.Контрагент);
	
	
КонецПроцедуры

Функция СуммаРезерва(Контрагент)

	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		Возврат 0;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФинансовыйОстатки.Субконто1 КАК Контрагент,
		|	ФинансовыйОстатки.СуммаОстатокКт + ФинансовыйОстатки.СуммаМСФООстатокКт КАК СуммаРезерва
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Остатки(, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РезервНаСписаниеБезнадежнойДЗ), ,Организация = &Организация И  Субконто1 = &Контрагент) КАК ФинансовыйОстатки";

	//Запрос.УстановитьПараметр("Дата", КонецДня(Объект.Дата));
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.СуммаРезерва; 
	КонецЦикла;
	
	Возврат 0;
	
КонецФункции	


&НаКлиенте
Процедура СписаниеДолговСчетУчетаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	 
	ТекущиеДанные = Элементы.СписаниеДолгов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	МассивСчетов = ПолучитьМассивСчетов(ТекущиеДанные.Контрагент);
	Элемент.СписокВыбора.ЗагрузитьЗначения(МассивСчетов);	
	
КонецПроцедуры

 Функция ПолучитьМассивСчетов(Контрагент)
	
	Результат = новый Массив;
	
    Если НЕ ЗначениеЗаполнено(Контрагент) Тогда

		Результат.Добавить(ПланыСчетов.Финансовый.РасчетыПоАренде);
		Результат.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщиками);	
		Результат.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщикамиОборудования);	
		Результат.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщикамиУпаковки);	
		Результат.Добавить(ПланыСчетов.Финансовый.ПрочаяЗадолженность);	
		Результат.Добавить(ПланыСчетов.Финансовый.РасчетыСПрочимиПоставщикамиИПодрядчиками);	
		
	Иначе	
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Контрагент",Контрагент);
		
		СчетаУчета = объект.ТекущаяЗадолженность.Выгрузить(,"Контрагент,СчетУчета");
		СчетаУчета.Свернуть("Контрагент,СчетУчета");
		
		ПоискСтрок = СчетаУчета.НайтиСтроки(СтруктураПоиска);
		
		Если ПоискСтрок.Количество() > 0 тогда
			Для каждого Строка из ПоискСтрок Цикл
				
				Результат.Добавить(Строка.СчетУчета);	
					
			КонецЦикла;
		Иначе 
			Результат.Добавить(ПланыСчетов.Финансовый.РасчетыПоАренде);
			Результат.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщиками);	
			Результат.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщикамиОборудования);	
			Результат.Добавить(ПланыСчетов.Финансовый.РасчетыСПоставщикамиУпаковки);	
			Результат.Добавить(ПланыСчетов.Финансовый.ПрочаяЗадолженность);	
			Результат.Добавить(ПланыСчетов.Финансовый.РасчетыСПрочимиПоставщикамиИПодрядчиками);	
		КонецЕсли;	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции	

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Для каждого Строка из Объект.СписаниеДолгов Цикл
			
			Если Строка.ТекущийРезерв < Строка.Сумма тогда	
			
				Сообщить("Для контрагента: " + Строка.Контрагент + " сумма списания превышает сумму резерва!");
				Отказ = Истина;
				
			КонецЕсли;	
				
		КонецЦикла;	
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписаниеДолговСчетУчетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СписаниеДолгов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	МассивСчетов = ПолучитьМассивСчетов(ТекущиеДанные.Контрагент);
	Элемент.СписокВыбора.ЗагрузитьЗначения(МассивСчетов);	

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущийРезерв(Команда)
	
	ОбновитьТекущийРезервНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущийРезервНаКлиенте()

	//Если не Объект.Проведен Тогда
		ОбновитьТекущийРезервНаСервере();
	//Иначе 	
	//	Сообщить("Необходимо отменить проведение документа для перезаполнения резерва");	
	//КонецЕсли;
	
	
КонецПроцедуры

Процедура ОбновитьТекущийРезервНаСервере()
	
	Запрос = Новый  Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	СписаниеДолгов.Контрагент,
	|	СписаниеДолгов.СчетУчета,
	|	СписаниеДолгов.Сумма
	|ПОМЕСТИТЬ втСписаниеДолгов
	|ИЗ
	|	&СписаниеДолгов КАК СписаниеДолгов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втСписаниеДолгов.Контрагент,
	|	втСписаниеДолгов.СчетУчета,
	|	СУММА(втСписаниеДолгов.Сумма) КАК Сумма
	|ПОМЕСТИТЬ втСписаниеГруппировка
	|ИЗ
	|	втСписаниеДолгов КАК втСписаниеДолгов
	|
	|СГРУППИРОВАТЬ ПО
	|	втСписаниеДолгов.Контрагент,
	|	втСписаниеДолгов.СчетУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФинансовыйОстатки.Субконто1 КАК Контрагент,
	|	-(ФинансовыйОстатки.СуммаОстаток + ФинансовыйОстатки.СуммаМСФООстаток) КАК СуммаРезерва
	|ПОМЕСТИТЬ втРезервы
	|ИЗ
	|	РегистрБухгалтерии.Финансовый.Остатки(
	|			,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РезервНаСписаниеБезнадежнойДЗ),
	|			,
	|			Организация = &Организация
	|				И Субконто1 В
	|					(ВЫБРАТЬ
	|						втСписаниеГруппировка.Контрагент
	|					ИЗ
	|						втСписаниеГруппировка)) КАК ФинансовыйОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втСписаниеГруппировка.Контрагент,
	|	втСписаниеГруппировка.СчетУчета,
	|	втСписаниеГруппировка.Сумма,
	|	втРезервы.СуммаРезерва КАК ТекущийРезерв
	|ИЗ
	|	втСписаниеГруппировка КАК втСписаниеГруппировка
	|		ЛЕВОЕ СОЕДИНЕНИЕ втРезервы КАК втРезервы
	|		ПО втСписаниеГруппировка.Контрагент = втРезервы.Контрагент";	
	
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(Объект.Дата));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("СписаниеДолгов", Объект.СписаниеДолгов.Выгрузить());
	
	Результат = Запрос.Выполнить().Выгрузить();

	Объект.СписаниеДолгов.Загрузить(Результат);	

	
	
КонецПроцедуры	


&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбновитьТекущийРезервНаКлиенте();
КонецПроцедуры


&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	Объект.Дата = КонецМесяца(Объект.Дата);
	ОбновитьТекущийРезервНаКлиенте();
КонецПроцедуры


&НаКлиенте
Процедура СписаниеДолговПриИзменении(Элемент)
	
	ОбновитьВсегоСписание();
	
КонецПроцедуры

Процедура ОбновитьВсегоСписание()
	
	ВсегоСписание = Объект.СписаниеДолгов.Итог("Сумма");
	
КонецПроцедуры	

//+++АК sils 08.06.2018 ИП-00018876
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(ОперацияАпдекс, ?(Параметры.Ключ.Пустая(), "Новый документ", "" + Объект.Ссылка));
КонецПроцедуры

	