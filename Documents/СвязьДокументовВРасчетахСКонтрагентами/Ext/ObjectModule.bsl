﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Если ЭтотОбъект.СоставДокументов.Количество() < 2 Тогда
		Отказ = Истина;
		Сообщить("Для связи в расчетах с контрагентами, нужно выбрать хотя бы 2 документа");
	КонецЕсли;	
	
	ДвиженияПоРасчетам = Движения.РасчетыСКонтрагентами;
	ДвиженияПоРасчетам.Записывать = Истина;
	ДвиженияПоРасчетам.Очистить();
	
	ТекстЗапроса="ВЫБРАТЬ
	             |	РасчетыСКонтрагентами.Организация,
	             |	РасчетыСКонтрагентами.Контрагент,
	             |	РасчетыСКонтрагентами.СчетУчета,
	             |	РасчетыСКонтрагентами.Сделка,
	             |	РасчетыСКонтрагентами.Сумма,
	             |	РасчетыСКонтрагентами.АвансПоСделке,
	             |	РасчетыСКонтрагентами.ДокументДт,
	             |	РасчетыСКонтрагентами.ВидДвижения
	             |ИЗ
	             |	Документ.СвязьДокументовВРасчетахСКонтрагентами.СоставДокументов КАК СвязьДокументовВРасчетахСКонтрагентамиСоставДокументов
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКонтрагентами КАК РасчетыСКонтрагентами
	             |		ПО СвязьДокументовВРасчетахСКонтрагентамиСоставДокументов.СвязуемыйДокумент = РасчетыСКонтрагентами.Регистратор
	             |ГДЕ
	             |	СвязьДокументовВРасчетахСКонтрагентамиСоставДокументов.Ссылка = &Ссылка";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка",ЭтотОбъект.Ссылка);
	ТабДвижений = Запрос.Выполнить().Выгрузить();
	ДокументСвязи = ЭтотОбъект.Ссылка;
	Для Каждого СтрокаДвижения ИЗ ТабДвижений Цикл
		Если ЗначениеЗаполнено(СтрокаДвижения.Сделка) Тогда
			ДокументСвязи = СтрокаДвижения.Сделка;
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
	
	Для Каждого СтрокаДвижения ИЗ ТабДвижений Цикл
		НД = ДвиженияПоРасчетам.Добавить();
		ЗаполнитьЗначенияСвойств(НД,СтрокаДвижения);
		НД.Сумма = -НД.Сумма;
		НД.АвансПоСделке = -НД.АвансПоСделке;
		НД.Период = ЭтотОбъект.Дата;
		НД = ДвиженияПоРасчетам.Добавить();
		ЗаполнитьЗначенияСвойств(НД,СтрокаДвижения);
		НД.Сделка = ДокументСвязи;
		НД.Период = ЭтотОбъект.Дата;
	КонецЦикла;	
КонецПроцедуры
