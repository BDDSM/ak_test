﻿&НаСервере
Перем ТабСебестоимость;

&НаКлиенте
Перем флИзменение;

&НаКлиенте
Перем СтароеЧисло;

&НаКлиенте
Перем флДобавление;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = НЕ УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РезервПодОбесценениеЗапасовПоСроку, Ложь);
	Если Отказ Тогда
		Сообщить("Нет прав на использование документа");
	КонецЕсли;	

	Если не ЗначениеЗаполнено(Объект.Ссылка) тогда
		Объект.Дата = КонецМесяца(ТекущаяДата());
		Объект.ДатаНачала = НачалоМесяца(ТекущаяДата());
		Объект.ДатаОкончания = КонецМесяца(ТекущаяДата());
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		Объект.ГруппаНонФуд = Справочники.Номенклатура.НайтиПоКоду("000619741");
		
		УстановитьНастройкиОпераций();
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиОпераций(флагВидаРезерва = 0)
	ТекДата = ?(Объект.Дата = '00010101', ТекущаяДата(), Объект.Дата);
	
	Если флагВидаРезерва = 0 Тогда
		Объект.Долгосрочный_ВидОперации = Перечисления.ВидыОперацийВУчете.РезервыОбесцЗапасовПоСроку_Долгосрочный;
	КонецЕсли;
	Если флагВидаРезерва = 0 или флагВидаРезерва = 1 Тогда
		СтруктураНастроек_Формирование = РегистрыСведений.НастройкаОтраженияОперацийВУчете.ПолучитьПоследнее(ТекДата, Новый Структура("ВидОперации", Объект.Долгосрочный_ВидОперации));
		Объект.Долгосрочный_Счет = СтруктураНастроек_Формирование.Счет;
		Объект.Долгосрочный_ЦФО = СтруктураНастроек_Формирование.ЦФО;
		Объект.Долгосрочный_СтатьяРасходов = СтруктураНастроек_Формирование.СтатьяДоходовРасходов;
		Объект.Долгосрочный_СтатьяСписания = СтруктураНастроек_Формирование.ДопРеквизит;
		Объект.Долгосрочный_ТорговыеТочки = СтруктураНастроек_Формирование.СтруктурнаяЕдиница;
	КонецЕсли;
	
	Если флагВидаРезерва = 0 Тогда
		Объект.Краткосрочный_ВидОперации = Перечисления.ВидыОперацийВУчете.РезервыОбесцЗапасовПоСроку_Краткосрочный;
	КонецЕсли;
	Если флагВидаРезерва = 0 или флагВидаРезерва = 2 Тогда
		СтруктураНастроек_Формирование = РегистрыСведений.НастройкаОтраженияОперацийВУчете.ПолучитьПоследнее(ТекДата, Новый Структура("ВидОперации", Объект.Краткосрочный_ВидОперации));
		Объект.Краткосрочный_Счет = СтруктураНастроек_Формирование.Счет;
		Объект.Краткосрочный_ЦФО = СтруктураНастроек_Формирование.ЦФО;
		Объект.Краткосрочный_СтатьяРасходов = СтруктураНастроек_Формирование.СтатьяДоходовРасходов;
		Объект.Краткосрочный_СтатьяСписания = СтруктураНастроек_Формирование.ДопРеквизит;
		Объект.Краткосрочный_ТорговыеТочки = СтруктураНастроек_Формирование.СтруктурнаяЕдиница;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериод(Команда)
	
	Диалог = новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период.ДатаНачала = Объект.ДатаНачала;
	Диалог.Период.ДатаОкончания = Объект.ДатаОкончания;	
	
	Если Диалог.Редактировать() Тогда 
    	Объект.ДатаНачала = Диалог.Период.ДатаНачала;
		Объект.ДатаОкончания = Диалог.Период.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Объект.ДатаНачала    = НачалоМесяца(Объект.Дата);
	Объект.ДатаОкончания = КонецМесяца(Объект.Дата);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗаПериод_Резервы_НаСервере()
	Если не ЗначениеЗаполнено(Объект.ГруппаНонФуд) Тогда
		Объект.ГруппаНонФуд = Справочники.Номенклатура.НайтиПоКоду("000619741");
	КонецЕсли;
	
	СЗСчетаИсключитьИзПроведения = Новый СписокЗначений;
	СЗСчетаИсключитьИзПроведения.Добавить(ПланыСчетов.Финансовый.ГСМ);
	СЗСчетаИсключитьИзПроведения.Добавить(ПланыСчетов.Финансовый.ПрочиеМатериалы);
	СЗСчетаИсключитьИзПроведения.Добавить(ПланыСчетов.Финансовый.Инвентарь);
	СЗСчетаИсключитьИзПроведения.Добавить(ПланыСчетов.Финансовый.Спецодежда);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ДатаНач", НачалоМесяца(Объект.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаКон", КонецМесяца(Объект.ДатаОкончания));
	Запрос.УстановитьПараметр("СЗСчетаИсключитьИзПроведения", СЗСчетаИсключитьИзПроведения);	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДвиженияТоваровПоЛистамУчета.СтруктурнаяЕдиница,
	               |	ЕСТЬNULL(СоставКомплектаСрезПоследних.ТоварКомплекта, ДвиженияТоваровПоЛистамУчета.Номенклатура) КАК Номенклатура,
	               |	ДвиженияТоваровПоЛистамУчета.ВидДвиженияТовара,
	               |	ДвиженияТоваровПоЛистамУчета.Регистратор,
	               |	ЕСТЬNULL(СоставКомплектаСрезПоследних.Количество * ДвиженияТоваровПоЛистамУчета.Количество, ДвиженияТоваровПоЛистамУчета.Количество) КАК Количество
	               |ПОМЕСТИТЬ ВТ_ДвиженияТоваровПоЛистамУчета
	               |ИЗ
	               |	РегистрНакопления.ДвиженияТоваровПоЛистамУчета КАК ДвиженияТоваровПоЛистамУчета
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставКомплекта.СрезПоследних(&ДатаКон, ) КАК СоставКомплектаСрезПоследних
	               |		ПО ДвиженияТоваровПоЛистамУчета.Номенклатура = СоставКомплектаСрезПоследних.Комплект
	               |			И (СоставКомплектаСрезПоследних.Количество > 0)
	               |			И (ДвиженияТоваровПоЛистамУчета.Номенклатура.ЭтоКомплект)
	               |ГДЕ
	               |	ДвиженияТоваровПоЛистамУчета.Период МЕЖДУ &ДатаНач И &ДатаКон
	               |	И ДвиженияТоваровПоЛистамУчета.Активность = ИСТИНА
	               |	И ДвиженияТоваровПоЛистамУчета.Номенклатура.НеУчитыватьВЗакрытииМесяца = ЛОЖЬ
	               |	И ДвиженияТоваровПоЛистамУчета.ВидДвиженияТовара = ЗНАЧЕНИЕ(Перечисление.ВидДвиженияТовараПоЛистуУчета.Списание)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ДвиженияТоваровПоЛистамУчета.Номенклатура,
	               |	СУММА(-ДвиженияТоваровПоЛистамУчета.Количество) КАК Списание_Количество,
	               |	ЕСТЬNULL(ВложенныйЗапрос.Себестоимость, 0) КАК Себестоимость
	               |ПОМЕСТИТЬ ВТ_ДанныеССебестоимостью
	               |ИЗ
	               |	ВТ_ДвиженияТоваровПоЛистамУчета КАК ДвиженияТоваровПоЛистамУчета
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаУчетаНоменклатуры.СрезПоследних(&ДатаКон, ) КАК СчетаУчетаНоменклатурыСрезПоследних
	               |		ПО ДвиженияТоваровПоЛистамУчета.Номенклатура = СчетаУчетаНоменклатурыСрезПоследних.Номенклатура
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЛистУчета КАК ЛистУчета
	               |		ПО ДвиженияТоваровПоЛистамУчета.Регистратор = ЛистУчета.Ссылка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			СебестоимостьТоваровСрезПоследних.Номенклатура КАК Номенклатура,
	               |			ВЫБОР
	               |				КОГДА КОНЕЦПЕРИОДА(СебестоимостьТоваровСрезПоследних.Период, МЕСЯЦ) <> &ДатаКон
	               |					ТОГДА 0
	               |				ИНАЧЕ 1
	               |			КОНЕЦ * СебестоимостьТоваровСрезПоследних.Себестоимость КАК Себестоимость
	               |		ИЗ
	               |			РегистрСведений.СебестоимостьТоваров.СрезПоследних(&ДатаКон, ) КАК СебестоимостьТоваровСрезПоследних) КАК ВложенныйЗапрос
	               |		ПО ДвиженияТоваровПоЛистамУчета.Номенклатура = ВложенныйЗапрос.Номенклатура
	               |ГДЕ
	               |	(НЕ СчетаУчетаНоменклатурыСрезПоследних.СчетУчета В (&СЗСчетаИсключитьИзПроведения)
	               |			ИЛИ СчетаУчетаНоменклатурыСрезПоследних.СчетУчета = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.ПустаяСсылка)
	               |			ИЛИ СчетаУчетаНоменклатурыСрезПоследних.СчетУчета ЕСТЬ NULL)
	               |	И ЕСТЬNULL(ЛистУчета.Организация, &Организация) = &Организация
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДвиженияТоваровПоЛистамУчета.Номенклатура,
	               |	ЕСТЬNULL(ВложенныйЗапрос.Себестоимость, 0)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ДанныеССебестоимостью.Номенклатура,
	               |	ВТ_ДанныеССебестоимостью.Списание_Количество,
	               |	ВТ_ДанныеССебестоимостью.Себестоимость,
	               |	ВЫРАЗИТЬ(ВТ_ДанныеССебестоимостью.Списание_Количество * ВТ_ДанныеССебестоимостью.Себестоимость КАК ЧИСЛО(15, 2)) КАК Списание_Сумма
	               |ПОМЕСТИТЬ ВТ_ДанныеССуммой
	               |ИЗ
	               |	ВТ_ДанныеССебестоимостью КАК ВТ_ДанныеССебестоимостью
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ФинансовыйОстатки.Субконто1 КАК Номенклатура,
	               |	-ФинансовыйОстатки.КоличествоОстаток КАК КоличествоД,
	               |	-ФинансовыйОстатки.СуммаМСФООстаток КАК СуммаД,
	               |	0 КАК КоличествоК,
	               |	0 КАК СуммаК
	               |ПОМЕСТИТЬ ВР_96СК
	               |ИЗ
	               |	РегистрБухгалтерии.Финансовый.Остатки(&ДатаНач, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуДолгосрочные), , Организация = &Организация) КАК ФинансовыйОстатки
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ФинансовыйОстатки.Субконто1,
	               |	0,
	               |	0,
	               |	-ФинансовыйОстатки.КоличествоОстаток,
	               |	-ФинансовыйОстатки.СуммаМСФООстаток
	               |ИЗ
	               |	РегистрБухгалтерии.Финансовый.Остатки(&ДатаНач, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуКраткосрочные), , Организация = &Организация) КАК ФинансовыйОстатки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВложенныйЗапрос.Номенклатура,
	               |	ВложенныйЗапрос.Списание_Количество,
	               |	ВложенныйЗапрос.Списание_Сумма,
	               |	ВложенныйЗапрос.КоличествоД,
	               |	ВложенныйЗапрос.СуммаД,
	               |	ВложенныйЗапрос.КоличествоК,
	               |	ВложенныйЗапрос.СуммаК
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	               |		СУММА(ВложенныйЗапрос.Списание_Количество) КАК Списание_Количество,
	               |		СУММА(ВложенныйЗапрос.Списание_Сумма) КАК Списание_Сумма,
	               |		СУММА(ВложенныйЗапрос.КоличествоД) КАК КоличествоД,
	               |		СУММА(ВложенныйЗапрос.СуммаД) КАК СуммаД,
	               |		СУММА(ВложенныйЗапрос.КоличествоК) КАК КоличествоК,
	               |		СУММА(ВложенныйЗапрос.СуммаК) КАК СуммаК
	               |	ИЗ
	               |		(ВЫБРАТЬ
	               |			ВТ_ДанныеССуммой.Номенклатура КАК Номенклатура,
	               |			ВТ_ДанныеССуммой.Списание_Количество КАК Списание_Количество,
	               |			ВТ_ДанныеССуммой.Списание_Сумма КАК Списание_Сумма,
	               |			0 КАК КоличествоД,
	               |			0 КАК СуммаД,
	               |			0 КАК КоличествоК,
	               |			0 КАК СуммаК
	               |		ИЗ
	               |			ВТ_ДанныеССуммой КАК ВТ_ДанныеССуммой
	               |		
	               |		ОБЪЕДИНИТЬ ВСЕ
	               |		
	               |		ВЫБРАТЬ
	               |			ВР_96СК.Номенклатура,
	               |			0,
	               |			0,
	               |			ВР_96СК.КоличествоД,
	               |			ВР_96СК.СуммаД,
	               |			ВР_96СК.КоличествоК,
	               |			ВР_96СК.СуммаК
	               |		ИЗ
	               |			ВР_96СК КАК ВР_96СК) КАК ВложенныйЗапрос
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ВложенныйЗапрос.Номенклатура) КАК ВложенныйЗапрос
	               |ГДЕ
	               |	ВложенныйЗапрос.Списание_Количество <> 0
	               |	И НЕ ВложенныйЗапрос.Номенклатура ЕСТЬ NULL";
	ТЗ = Запрос.Выполнить().Выгрузить();
	ТЗ.Колонки.Добавить("РезервыСписание_Количество", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("РезервыСписание_Сумма", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("РезервыНачисление_Количество", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("РезервыНачисление_Сумма", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("РучнаяКорректировка", Новый ОписаниеТипов("Булево"));
	
	// Учет ручной корректировки
	ТЗ_Резервы = Объект.Резервы.Выгрузить();
	ТекКол = ТЗ_Резервы.Количество();
	Пока ТекКол <> 0 Цикл
		стр = ТЗ_Резервы[ТекКол - 1];
		Если не стр.РучнаяКорректировка Тогда
			ТЗ_Резервы.Удалить(стр);
		КонецЕсли;
		ТекКол = ТекКол - 1;
	КонецЦикла;
	ТЗ_Резервы.Колонки.Добавить("Добавлена", Новый ОписаниеТипов("Булево"));
	
	// Расчет количества
	Для каждого стр из ТЗ Цикл
		Если стр.Номенклатура.ПринадлежитЭлементу(Объект.ГруппаНонФуд) Тогда
			Если стр.Списание_Количество <= стр.КоличествоД Тогда
				стр.РезервыСписание_Количество =  стр.Списание_Количество;
				стр.РезервыСписание_Сумма = Окр(?(стр.КоличествоД = 0, 0, стр.РезервыСписание_Количество * стр.СуммаД / стр.КоличествоД), 2, 1);
			Иначе
				стр.РезервыСписание_Количество = стр.КоличествоД;
				стр.РезервыСписание_Сумма = стр.СуммаД;
				
				стр.РезервыНачисление_Количество = стр.Списание_Количество;
				стр.РезервыНачисление_Сумма = Окр(?(стр.Списание_Количество = 0, 0, стр.РезервыНачисление_Количество * стр.Списание_Сумма / стр.Списание_Количество), 2, 1);
			КонецЕсли;
		Иначе
			Если стр.Списание_Количество <= стр.КоличествоК Тогда
				стр.РезервыСписание_Количество =  стр.Списание_Количество;
				стр.РезервыСписание_Сумма = Окр(?(стр.КоличествоК = 0, 0, стр.РезервыСписание_Количество * стр.СуммаК / стр.КоличествоК), 2, 1);
			Иначе
				стр.РезервыСписание_Количество = стр.КоличествоК;
				стр.РезервыСписание_Сумма = стр.СуммаК;
				
				стр.РезервыНачисление_Количество = стр.Списание_Количество;
				стр.РезервыНачисление_Сумма = Окр(?(стр.Списание_Количество = 0, 0, стр.РезервыНачисление_Количество * стр.Списание_Сумма / стр.Списание_Количество), 2, 1);
			КонецЕсли;
		КонецЕсли;
		
		Отбор = Новый Структура;
		Отбор.Вставить("Номенклатура", стр.Номенклатура);
		НайденныеСтр = ТЗ_Резервы.НайтиСтроки(Отбор);
		Если НайденныеСтр.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(стр, НайденныеСтр[0]);
			НайденныеСтр[0].Добавлена = Истина;
		КонецЕсли;
	КонецЦикла;
	Отбор = Новый Структура;
	Отбор.Вставить("Добавлена", Ложь);
	НайденныеСтр = ТЗ_Резервы.НайтиСтроки(Отбор);
	Для каждого стр из НайденныеСтр Цикл
		ЗаполнитьЗначенияСвойств(ТЗ.Добавить(), стр);
	КонецЦикла;
	
	//*****************************************************************************************
	
	ТЗ.Сортировать("Номенклатура");
	
	Объект.Резервы.Очистить();
	Объект.Резервы.Загрузить(ТЗ);
КонецПроцедуры

&НаКлиенте
Процедура Резервы_Заполнить(Команда)
	Если Объект.Резервы.Количество() > 0 Тогда
		Ответ = Вопрос("Табличная часть будет очищена. Вы уверены?", РежимДиалогаВопрос.ДаНет, 0); 
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ЗаполнитьЗаПериод_Резервы_НаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	флИзменение = Ложь;
	флДобавление = Ложь;
	ОбновитьКолонки();
КонецПроцедуры

&НаСервере
Процедура ОбновитьКолонки()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГруппаНонФуд", Объект.ГруппаНонФуд);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.Ссылка В ИЕРАРХИИ(&ГруппаНонФуд)";
	ТЗ =Запрос.Выполнить().Выгрузить();
	СЗ = Новый СписокЗначений;
	СЗ.ЗагрузитьЗначения(ТЗ.ВыгрузитьКолонку("Ссылка"));
	
	Для каждого стр из Объект.Резервы Цикл
		Если СЗ.НайтиПоЗначению(стр.Номенклатура) <> Неопределено Тогда
			стр.СчетУчета = ПланыСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуДолгосрочные;
		Иначе
			стр.СчетУчета = ПланыСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуКраткосрочные;
		КонецЕсли;
		стр.Группа = стр.Номенклатура.Родитель;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура РезервыПриИзменении(Элемент)
	Если флИзменение Тогда
		ТекСтр = Элементы.Резервы.ТекущиеДанные;
		ТекРеквизит = Сред(Элемент.ТекущийЭлемент.Имя, 8);
		ТекЗначение = ТекСтр[ТекРеквизит];
		
		Если СтароеЧисло <> ТекЗначение Тогда
			ТекСтр.РучнаяКорректировка = Истина;
		КонецЕсли;
		флИзменение = Ложь;
	КонецЕсли;
	Если флДобавление Тогда
		ТекСтр = Элементы.Резервы.ТекущиеДанные;
		ТекСтр.РучнаяКорректировка = Истина;
		флДобавление = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РезервыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	флДобавление = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РезервыПередНачаломИзменения(Элемент, Отказ)
	флИзменение = Истина;
	ТекРеквизит = Сред(Элемент.ТекущийЭлемент.Имя, 8);
	СтароеЧисло = Элемент.ТекущиеДанные[ТекРеквизит];
КонецПроцедуры

&НаКлиенте
Процедура Долгосрочный_ВидОперацииПриИзменении(Элемент)
	УстановитьНастройкиОпераций(1);
КонецПроцедуры

&НаКлиенте
Процедура Краткосрочный_ВидОперацииПриИзменении(Элемент)
	УстановитьНастройкиОпераций(2);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ОбновитьКолонки();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьКолонки();
КонецПроцедуры

&НаСервере
Функция РезервыНоменклатураПриИзмененииНаСервере(ТекНоменклатура)
	Если ТекНоменклатура.ПринадлежитЭлементу(Объект.ГруппаНонФуд) Тогда
		Возврат ПланыСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуДолгосрочные;
	Иначе
		Возврат ПланыСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуКраткосрочные;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура РезервыНоменклатураПриИзменении(Элемент)
	ТекДанные = Элементы.Резервы.ТекущиеДанные;
	ТекДанные.Группа = ТекДанные.Номенклатура.Родитель;
	ТекДанные.СчетУчета = РезервыНоменклатураПриИзмененииНаСервере(ТекДанные.Номенклатура);
КонецПроцедуры
















