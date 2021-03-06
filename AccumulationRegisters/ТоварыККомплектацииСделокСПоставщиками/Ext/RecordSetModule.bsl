﻿//+++АК POZM 2017.11.02 ИП-00017155 
Процедура ПриЗаписи(Отказ, Замещение)
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;	
	 
КонецПроцедуры
//---АК POZM 

//+++АК POZM 2017.11.02 ИП-00017155 
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;	
	БезКонтроля = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьУвеличениеПереплатТоварамККомплектации, Ложь);
	
	Если БезКонтроля = Истина Тогда
		Возврат;
	КонецЕсли;	
	
	Регистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
	
	ТекстЗапроса="ВЫБРАТЬ
	             |	Расчеты.Сделка,
	             |	Расчеты.КоличествоОстаток КАК КоличествоОстаток,
	             |	Расчеты.УИН_Этапа,
	             |	Расчеты.Номенклатура
	             |ИЗ
	             |	РегистрНакопления.ТоварыККомплектацииСделокСПоставщиками.Остатки(, ) КАК Расчеты
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	КоличествоОстаток
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	Расчеты.Сделка,
	             |	СУММА(ВЫБОР
	             |			КОГДА Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	             |				ТОГДА -Расчеты.Количество
	             |			ИНАЧЕ Расчеты.Количество
	             |		КОНЕЦ) КАК КоличествоОстаток,
	             |	Расчеты.УИН_Этапа,
	             |	Расчеты.Номенклатура
	             |ИЗ
	             |	РегистрНакопления.ТоварыККомплектацииСделокСПоставщиками КАК Расчеты
	             |ГДЕ
	             |	Расчеты.Регистратор = &Регистратор
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	Расчеты.Сделка,
	             |	Расчеты.УИН_Этапа,
	             |	Расчеты.Номенклатура
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	КоличествоОстаток";

				 
	
	Запрос=Новый Запрос(ТекстЗапроса);		
	
	Запрос.УстановитьПараметр("Регистратор",Регистратор);
	Результат = Запрос.ВыполнитьПакет();
	ТекущиеОстаткиПоТоварамДокумента = Результат[0].Выгрузить();
	МинусыТекущие = ТекущиеОстаткиПоТоварамДокумента.Скопировать();
	МинусыТекущие.Очистить();
	Для Каждого Стр Из ТекущиеОстаткиПоТоварамДокумента Цикл
		Если Стр.КоличествоОстаток>=0 Тогда
			Прервать;
		КонецЕсли;	
		НС = МинусыТекущие.Добавить();
		ЗаполнитьЗначенияСвойств(НС,Стр);
	КонецЦикла;	
	
	БылоМинусовНаСумму = МинусыТекущие.Итог("КоличествоОстаток");
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		НС = ТекущиеОстаткиПоТоварамДокумента.Добавить();
		ЗаполнитьЗначенияСвойств(НС,Запись);
		Если Запись.ВидДвижения = ВидДвиженияНакопления.Приход Тогда
			НС.КоличествоОстаток = Запись.Количество;
		Иначе
			НС.КоличествоОстаток = -Запись.Количество;
		КонецЕсли;	
	КонецЦикла;	
	
	СтарыеДвижения = Результат[1].Выбрать();
	Пока СтарыеДвижения.Следующий() Цикл
		НС = ТекущиеОстаткиПоТоварамДокумента.Добавить();
		ЗаполнитьЗначенияСвойств(НС,СтарыеДвижения);
	КонецЦикла;	
	
	ТекущиеОстаткиПоТоварамДокумента.Свернуть("Сделка,УИН_Этапа,Номенклатура","КоличествоОстаток");
	ТекущиеОстаткиПоТоварамДокумента.Сортировать("КоличествоОстаток");
	
	МинусыТекущие.Колонки.Добавить("ОстатокПосле");
	Для Каждого Стр Из ТекущиеОстаткиПоТоварамДокумента Цикл
		Если Стр.КоличествоОстаток>=0 Тогда
			Прервать;
		КонецЕсли;	
		НС = МинусыТекущие.Добавить();
		ЗаполнитьЗначенияСвойств(НС,Стр);
		НС.КоличествоОстаток = 0 ;
		НС.ОстатокПосле = Стр.КоличествоОстаток;
	КонецЦикла;	
	
	МинусыТекущие.Свернуть("Сделка,УИН_Этапа,Номенклатура","КоличествоОстаток,ОстатокПосле");
	
	СейчасМинусовНаСумму = МинусыТекущие.Итог("ОстатокПосле");
	
	Если (СейчасМинусовНаСумму) < БылоМинусовНаСумму Тогда 
		
		Если НЕ БезКонтроля = Истина Тогда
			Отказ = Истина;
		КонецЕсли;	
		
		Сообщить("Проведение документа увеличивает перерасход товаров к комплектации, в записи отказано");
		Для каждого Стр  Из МинусыТекущие Цикл
		
			Если Стр.КоличествоОстаток<>Стр.ОстатокПосле Тогда
			
				Сообщить("Укомплектовано больше чем есть в сделке по "+Стр.Номенклатура+"/"+Стр.Сделка+" на "+(-Стр.ОстатокПосле));
			
			КонецЕсли; 
		
		КонецЦикла; 
	КонецЕсли;	
КонецПроцедуры
//---АК POZM 