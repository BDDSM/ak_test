﻿&НаСервере
Перем ТабСебестоимость; //+++АК sils 19.07.2018 ИП-00018932

&НаКлиенте
Перем флИзменение; //+++АК sils 20.07.2018 ИП-00018932

&НаКлиенте
Перем СтароеЧисло; //+++АК sils 20.07.2018 ИП-00018932

&НаКлиенте
Перем флДобавление; //+++АК sils 20.07.2018 ИП-00018932

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = НЕ УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РезервНаСписаниеТовара, Ложь);
	Если Отказ Тогда
		Сообщить("Нет прав на использование документа");
	КонецЕсли;	
	

	Если не ЗначениеЗаполнено(Объект.Ссылка) тогда
		Объект.ДатаНачала = НачалоМесяца(ТекущаяДата());
		Объект.ДатаОкончания = КонецМесяца(ТекущаяДата());
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		Объект.ВидОперации = Перечисления.ВидыОперацийРезервыНаВозратТоваров.ТекущееНачислениеИСписаниеРезервов;
		
		//+++АК sils 19.07.2018 ИП-00018932
		Объект.Формирование_ВидОперации = Перечисления.ВидыОперацийВУчете.Резервы_Формирование;
		УстановитьНастройки_Формирование(Объект.Формирование_ВидОперации);
		
		Объект.Списание_ВидОперации = Перечисления.ВидыОперацийВУчете.Резервы_Списание;
		УстановитьНастройки_Списание(Объект.Списание_ВидОперации);
		//---АК
	КонецЕсли;	
	
	//+++АК sils 30.08.2018 ИП-00018932
	//ОбновитьДанныеЗаПериод();
	//---АК
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗаПериод(Команда)
	
	ЗаполнитьЗаПериодНаСервере();
	ОбновитьДанныеЗаПериод();
	
КонецПроцедуры


Процедура ЗаполнитьЗаПериодНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница,
		|	ЦФОСтруктурныхЕдиницСрезПоследних.Организация
		|ПОМЕСТИТЬ втОтборПоОрганизации
		|ИЗ
		|	РегистрСведений.ЦФОСтруктурныхЕдиниц.СрезПоследних(&ДатаОкончания, ) КАК ЦФОСтруктурныхЕдиницСрезПоследних
		|ГДЕ
		|	ЦФОСтруктурныхЕдиницСрезПоследних.Организация = &Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияТоваровПоЛистамУчетаОбороты.Регистратор,
		|	ДвиженияТоваровПоЛистамУчетаОбороты.СтруктурнаяЕдиница,
		|	ДвиженияТоваровПоЛистамУчетаОбороты.Номенклатура
		|ПОМЕСТИТЬ втВозвратыПоЛистамУчета
		|ИЗ
		|	РегистрНакопления.ДвиженияТоваровПоЛистамУчета.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			Регистратор,
		|			ВидДвиженияТовара = ЗНАЧЕНИЕ(Перечисление.ВидДвиженияТовараПоЛистуУчета.ВозвратОтПокупателя)
		|				И СтруктурнаяЕдиница В
		|					(ВЫБРАТЬ
		|						втОтборПоОрганизации.СтруктурнаяЕдиница
		|					ИЗ
		|						втОтборПоОрганизации)) КАК ДвиженияТоваровПоЛистамУчетаОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втВозвратыПоЛистамУчета.Регистратор КАК Документ,
		|	втВозвратыПоЛистамУчета.СтруктурнаяЕдиница КАК ТорговаяТочка,
		|	СУММА(ЛистУчетаТоварыПоВозвратам.Сумма) КАК Сумма
		|ИЗ
		|	Документ.ЛистУчета.ТоварыПоВозвратам КАК ЛистУчетаТоварыПоВозвратам
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втВозвратыПоЛистамУчета КАК втВозвратыПоЛистамУчета
		|		ПО ЛистУчетаТоварыПоВозвратам.Ссылка = втВозвратыПоЛистамУчета.Регистратор
		|			И ЛистУчетаТоварыПоВозвратам.Номенклатура = втВозвратыПоЛистамУчета.Номенклатура
		|
		|СГРУППИРОВАТЬ ПО
		|	втВозвратыПоЛистамУчета.Регистратор,
		|	втВозвратыПоЛистамУчета.СтруктурнаяЕдиница";

	Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(Объект.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(Объект.ДатаОкончания));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	

	Результат = Запрос.Выполнить().Выгрузить();

	Объект.Списания.Загрузить(Результат);
	
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
	
	//+++АК sils 30.08.2018 ИП-00018932
	//ОбновитьДанныеЗаПериод();
	//---АК
	
КонецПроцедуры

Процедура ОбновитьДанныеЗаПериод()
	
	//Элементы.ТекущийРезерв.Заголовок = "Текущий резерв: " + ПолучитьТекущийРезерв(Объект.ДатаНачала);	
	РезервНаНачало = ПолучитьТекущийРезерв(Объект.Организация,НачалоДня(Объект.ДатаНачала));	
	ВсегоВозвратов = Объект.Списания.Итог("Сумма");
	РезервКНачислению = ВсегоВозвратов - РезервНаНачало;
	Объект.СуммаРезерва = РезервКНачислению;
	
КонецПроцедуры

Функция ПолучитьТекущийРезерв(Организация,Дата)
	

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	-ЕСТЬNULL(СУММА(ФинансовыйОстатки.СуммаОстаток), 0) - ЕСТЬNULL(СУММА(ФинансовыйОстатки.СуммаМСФООстаток), 0) КАК СуммаОстаток
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Остатки(&Дата, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РезервыНаСписаниеВозвратовОтПокупателей), , Организация = &Организация) КАК ФинансовыйОстатки";

	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат Формат(ВыборкаДетальныеЗаписи.СуммаОстаток,"ЧДЦ=2; ЧН='Не установлен'")
	КонецЦикла;

	Возврат "Не установлен";

	
	
КонецФункции

&НаКлиенте
Процедура СписанияПриИзменении(Элемент)
	
	ОбновитьДанныеЗаПериод();
	
КонецПроцедуры

//+++АК sils 19.07.2018 ИП-00018932
&НаСервере
Процедура ЗаполнитьЗаПериод_Резервы_НаСервере()
	СЗСчетаИсключитьИзПроведения = Новый СписокЗначений;
	СЗСчетаИсключитьИзПроведения.Добавить(ПланыСчетов.Финансовый.ГСМ);
	СЗСчетаИсключитьИзПроведения.Добавить(ПланыСчетов.Финансовый.ПрочиеМатериалы);
	СЗСчетаИсключитьИзПроведения.Добавить(ПланыСчетов.Финансовый.Инвентарь);
	СЗСчетаИсключитьИзПроведения.Добавить(ПланыСчетов.Финансовый.Спецодежда);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ДатаНач", НачалоМесяца(Объект.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаКон", КонецМесяца(Объект.ДатаОкончания));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);	
	Запрос.УстановитьПараметр("СЗСчетаИсключитьИзПроведения", СЗСчетаИсключитьИзПроведения);	
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
	               |	И ДвиженияТоваровПоЛистамУчета.ВидДвиженияТовара = ЗНАЧЕНИЕ(Перечисление.ВидДвиженияТовараПоЛистуУчета.ВозвратОтПокупателя)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ДвиженияТоваровПоЛистамУчета.Номенклатура,
	               |	СУММА(ДвиженияТоваровПоЛистамУчета.Количество) КАК Возврат_Количество,
	               |	СУММА(ВЫРАЗИТЬ(ДвиженияТоваровПоЛистамУчета.Количество * ЕСТЬNULL(ВложенныйЗапрос.Себестоимость, 0) КАК ЧИСЛО(15, 2))) КАК Возврат_Сумма
	               |ПОМЕСТИТЬ ТЗ
	               |ИЗ
	               |	ВТ_ДвиженияТоваровПоЛистамУчета КАК ДвиженияТоваровПоЛистамУчета
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
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЛистУчета КАК ЛистУчета
	               |		ПО ДвиженияТоваровПоЛистамУчета.Регистратор = ЛистУчета.Ссылка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаУчетаНоменклатуры.СрезПоследних(&ДатаКон, ) КАК СчетаУчетаНоменклатурыСрезПоследних
	               |		ПО ДвиженияТоваровПоЛистамУчета.Номенклатура = СчетаУчетаНоменклатурыСрезПоследних.Номенклатура
	               |ГДЕ
	               |	ЕСТЬNULL(ЛистУчета.Организация, &Организация) = &Организация
	               |	И (НЕ СчетаУчетаНоменклатурыСрезПоследних.СчетУчета В (&СЗСчетаИсключитьИзПроведения)
	               |			ИЛИ СчетаУчетаНоменклатурыСрезПоследних.СчетУчета = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.ПустаяСсылка)
	               |			ИЛИ СчетаУчетаНоменклатурыСрезПоследних.СчетУчета ЕСТЬ NULL)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДвиженияТоваровПоЛистамУчета.Номенклатура
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ФинансовыйОстатки.Субконто1 КАК Номенклатура,
	               |	ФинансовыйОстатки.КоличествоОстаток КАК Количество,
	               |	ФинансовыйОстатки.СуммаМСФООстаток КАК Сумма
	               |ПОМЕСТИТЬ ВР_96В
	               |ИЗ
	               |	РегистрБухгалтерии.Финансовый.Остатки(&ДатаНач, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РезервыНаСписаниеВозвратовОтПокупателей), , Организация = &Организация) КАК ФинансовыйОстатки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВложенныйЗапрос.Номенклатура,
	               |	ВложенныйЗапрос.Возврат_Количество КАК Возврат_Количество,
	               |	ВложенныйЗапрос.Возврат_Сумма КАК Возврат_Сумма,
	               |	ВложенныйЗапрос.Количество96 КАК Количество96,
	               |	ВложенныйЗапрос.Сумма96 КАК Сумма96
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	               |		СУММА(ВложенныйЗапрос.Возврат_Количество) КАК Возврат_Количество,
	               |		СУММА(ВложенныйЗапрос.Возврат_Сумма) КАК Возврат_Сумма,
	               |		СУММА(ВложенныйЗапрос.Количество) КАК Количество96,
	               |		СУММА(ВложенныйЗапрос.Сумма) КАК Сумма96
	               |	ИЗ
	               |		(ВЫБРАТЬ
	               |			ТЗ.Номенклатура КАК Номенклатура,
	               |			ТЗ.Возврат_Количество КАК Возврат_Количество,
	               |			ТЗ.Возврат_Сумма КАК Возврат_Сумма,
	               |			0 КАК Количество,
	               |			0 КАК Сумма
	               |		ИЗ
	               |			ТЗ КАК ТЗ
	               |		
	               |		ОБЪЕДИНИТЬ ВСЕ
	               |		
	               |		ВЫБРАТЬ
	               |			ВР_96В.Номенклатура,
	               |			0,
	               |			0,
	               |			-ВР_96В.Количество,
	               |			-ВР_96В.Сумма
	               |		ИЗ
	               |			ВР_96В КАК ВР_96В) КАК ВложенныйЗапрос
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ВложенныйЗапрос.Номенклатура) КАК ВложенныйЗапрос
	               |ГДЕ
	               |	ВложенныйЗапрос.Возврат_Количество <> 0";
	ТЗ = Запрос.Выполнить().Выгрузить();
	ТЗ.Колонки.Добавить("РезервыСписание_Количество", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("РезервыСписание_Сумма", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("РезервыНачисление_Количество", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("РезервыНачисление_Сумма", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("РучнаяКорректировка", Новый ОписаниеТипов("Булево"));
	
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
	
	Для каждого стр из ТЗ Цикл
		Если стр.Возврат_Количество <= стр.Количество96 Тогда
			стр.РезервыСписание_Количество =  стр.Возврат_Количество;
			стр.РезервыСписание_Сумма = Окр(?(стр.Количество96 = 0, 0, стр.РезервыСписание_Количество * стр.Сумма96 / стр.Количество96), 2, 1);
		Иначе
			стр.РезервыСписание_Количество = стр.Количество96;
			стр.РезервыСписание_Сумма = стр.Сумма96;
			
			стр.РезервыНачисление_Количество = стр.Возврат_Количество;
			стр.РезервыНачисление_Сумма = Окр(?(стр.Возврат_Количество = 0, 0, стр.РезервыНачисление_Количество * стр.Возврат_Сумма / стр.Возврат_Количество), 2, 1);
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

//+++АК sils 19.07.2018 ИП-00018932
&НаСервере
Процедура ЗаполнитьОстаткамиРезерваНаСервере()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНач", НачалоМесяца(Объект.ДатаНачала));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ФинансовыйОстатки.Субконто1 КАК Номенклатура,
	               |	-ФинансовыйОстатки.КоличествоОстаток КАК РезервыСписание_Количество,
	               |	-ФинансовыйОстатки.СуммаМСФООстаток КАК РезервыСписание_Сумма
	               |ИЗ
	               |	РегистрБухгалтерии.Финансовый.Остатки(&ДатаНач, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РезервыНаСписаниеВозвратовОтПокупателей), , Организация = &Организация) КАК ФинансовыйОстатки";
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	ТЗ.Сортировать("Номенклатура");
	
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
	ТЗ.Колонки.Добавить("РучнаяКорректировка", Новый ОписаниеТипов("Булево"));
	
	Для каждого стр из ТЗ Цикл
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
	ТЗ.Сортировать("Номенклатура");
	
	Объект.Резервы.Очистить();
	Объект.Резервы.Загрузить(ТЗ);
КонецПроцедуры

//+++АК sils 19.07.2018 ИП-00018932
&НаСервере
Процедура Резервы_ЗаполнитьНаСервере()
	Если Объект.ВидОперации = Перечисления.ВидыОперацийРезервыНаВозратТоваров.ТекущееНачислениеИСписаниеРезервов Тогда
		ЗаполнитьЗаПериод_Резервы_НаСервере();
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийРезервыНаВозратТоваров.СписаниеОстатковРезервов Тогда
		ЗаполнитьОстаткамиРезерваНаСервере();
	КонецЕсли;
КонецПроцедуры

//+++АК sils 19.07.2018 ИП-00018932
&НаКлиенте
Процедура Резервы_Заполнить(Команда)
	Если Объект.Резервы.Количество() > 0 Тогда
		Ответ = Вопрос("Табличная часть будет очищена. Вы уверены?", РежимДиалогаВопрос.ДаНет, 0); 
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;

	Резервы_ЗаполнитьНаСервере();
КонецПроцедуры

//+++АК sils 19.07.2018 ИП-00018932
&НаКлиенте
Процедура УправлениеВидимостью()
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРезервыНаВозратТоваров.СписаниеОстатковРезервов") Тогда
		Элементы.РезервыГруппаНачисление.Видимость = Ложь;
		Элементы.РезервыГруппаВозврат.Видимость = Ложь;
	Иначе
		Элементы.РезервыГруппаНачисление.Видимость = Истина;
		Элементы.РезервыГруппаВозврат.Видимость = Истина;
	КонецЕсли;
КонецПроцедуры

//+++АК sils 19.07.2018 ИП-00018932
&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УправлениеВидимостью();
КонецПроцедуры

//+++АК sils 19.07.2018 ИП-00018932
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеВидимостью();
	флИзменение = Ложь;
	флДобавление = Ложь;
КонецПроцедуры

//+++АК sils 19.07.2018 ИП-00018932
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

//+++АК sils 25.07.2018 ИП-00018932
&НаКлиенте
Процедура РезервыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	флДобавление = Истина;
КонецПроцедуры

//+++АК sils 19.07.2018 ИП-00018932
&НаКлиенте
Процедура РезервыПередНачаломИзменения(Элемент, Отказ)
	флИзменение = Истина;
	ТекРеквизит = Сред(Элемент.ТекущийЭлемент.Имя, 8);
	СтароеЧисло = Элемент.ТекущиеДанные[ТекРеквизит];
КонецПроцедуры

//+++АК sils 25.07.2018 ИП-00018932
&НаСервере
Процедура УстановитьНастройки_Формирование(ТекВидОперации)
	ТекДата = ?(Объект.Дата = '00010101', ТекущаяДата(), Объект.Дата);
	СтруктураНастроек_Формирование = РегистрыСведений.НастройкаОтраженияОперацийВУчете.ПолучитьПоследнее(ТекДата, Новый Структура("ВидОперации", ТекВидОперации));
	Объект.Формирование_Счет = СтруктураНастроек_Формирование.Счет;
	Объект.Формирование_ЦФО = СтруктураНастроек_Формирование.ЦФО;
	Объект.Формирование_СтатьяРасходов = СтруктураНастроек_Формирование.СтатьяДоходовРасходов;
	Объект.Формирование_ТорговыеТочки = СтруктураНастроек_Формирование.СтруктурнаяЕдиница;
КонецПроцедуры

//+++АК sils 25.07.2018 ИП-00018932
&НаСервере
Процедура УстановитьНастройки_Списание(ТекВидОперации)
	ТекДата = ?(Объект.Дата = '00010101', ТекущаяДата(), Объект.Дата);
	СтруктураНастроек_Списание = РегистрыСведений.НастройкаОтраженияОперацийВУчете.ПолучитьПоследнее(ТекДата, Новый Структура("ВидОперации", ТекВидОперации));
	Объект.Списание_Счет = СтруктураНастроек_Списание.Счет;
	Объект.Списание_ЦФО = СтруктураНастроек_Списание.ЦФО;
	Объект.Списание_СтатьяРасходов = СтруктураНастроек_Списание.СтатьяДоходовРасходов;
	Объект.Списание_ТорговыеТочки = СтруктураНастроек_Списание.СтруктурнаяЕдиница;
КонецПроцедуры

//+++АК sils 25.07.2018 ИП-00018932
&НаКлиенте
Процедура Формирование_ВидОперацииПриИзменении(Элемент)
	УстановитьНастройки_Формирование(Объект.Формирование_ВидОперации);
КонецПроцедуры

//+++АК sils 25.07.2018 ИП-00018932
&НаКлиенте
Процедура Списание_ВидОперацииПриИзменении(Элемент)
	УстановитьНастройки_Списание(Объект.Списание_ВидОперации);
КонецПроцедуры

//+++АК sils 25.07.2018 ИП-00018932
&НаКлиенте
Процедура ВидОперацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Объект.Резервы.Количество() > 0 Тогда
		Если Вопрос("При изменении вида операции табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			Объект.Резервы.Очистить();
			Объект.ВидОперации = ВыбранноеЗначение;
		КонецЕсли;
	Иначе
		Объект.ВидОперации = ВыбранноеЗначение;
	КонецЕсли;
КонецПроцедуры
















