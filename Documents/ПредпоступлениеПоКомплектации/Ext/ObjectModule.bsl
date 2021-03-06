﻿
Процедура РассчитатьСуммуДокумента() Экспорт
	
	СуммаДокумента = 0;
	
	Для Каждого СтрокаТабличнойЧастиТовары Из ЭтотОбъект.Товары Цикл
		Если ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.НДСвТомЧисле Тогда
			СуммаДокумента = СуммаДокумента + СтрокаТабличнойЧастиТовары.Сумма;
		Иначе
			СуммаДокумента = СуммаДокумента + СтрокаТабличнойЧастиТовары.Сумма + СтрокаТабличнойЧастиТовары.СуммаНДС;
		КонецЕсли;
	КонецЦикла;
	
Конецпроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ТекстЗапроса="ВЫБРАТЬ
	             |	РасчетыПоСделкамСПоставщикамиОстатки.Сделка,
	             |	РасчетыПоСделкамСПоставщикамиОстатки.УИН_Этапа,
	             |	РасчетыПоСделкамСПоставщикамиОстатки.Комплектация,
	             |	РасчетыПоСделкамСПоставщикамиОстатки.УИН_СтрокиКомплектации,
	             |	РасчетыПоСделкамСПоставщикамиОстатки.ДатаПлатежа,
	             |	РасчетыПоСделкамСПоставщикамиОстатки.СуммаОстаток,
	             |	СделкаСПоставщикомГрафикОплат.УИН_ПервойСтроки,
	             |	СделкаСПоставщикомГрафикОплат.НомерСтрокиГрафика КАК НомерСтрокиГрафика
	             |ПОМЕСТИТЬ Преварительно
	             |ИЗ
	             |	РегистрНакопления.РасчетыПоСделкамСПоставщиками.Остатки(
	             |			,
	             |			Сделка В (&СделкиДокумента)
	             |				И (Комплектация = ЗНАЧЕНИЕ(Документ.КомплектацияМагазинаПоСделкамСПоставщиком.ПустаяСсылка)
	             |					ИЛИ Комплектация = ЗНАЧЕНИЕ(Документ.ПредпоступлениеПоКомплектации.ПустаяСсылка)
	             |					ИЛИ Комплектация = НЕОПРЕДЕЛЕНО)) КАК РасчетыПоСделкамСПоставщикамиОстатки
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СделкаСПоставщиком.ГрафикОплат КАК СделкаСПоставщикомГрафикОплат
	             |		ПО РасчетыПоСделкамСПоставщикамиОстатки.Сделка = СделкаСПоставщикомГрафикОплат.Ссылка
	             |			И РасчетыПоСделкамСПоставщикамиОстатки.УИН_Этапа = СделкаСПоставщикомГрафикОплат.УИН_Строки
	             |
	             |ОБЪЕДИНИТЬ ВСЕ
	             |
	             |ВЫБРАТЬ
	             |	РасчетыПоСделкамСПоставщиками.Сделка,
	             |	РасчетыПоСделкамСПоставщиками.УИН_Этапа,
	             |	РасчетыПоСделкамСПоставщиками.Комплектация,
	             |	РасчетыПоСделкамСПоставщиками.УИН_СтрокиКомплектации,
	             |	РасчетыПоСделкамСПоставщиками.ДатаПлатежа,
	             |	ВЫБОР
	             |		КОГДА РасчетыПоСделкамСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	             |			ТОГДА -РасчетыПоСделкамСПоставщиками.Сумма
	             |		ИНАЧЕ РасчетыПоСделкамСПоставщиками.Сумма
	             |	КОНЕЦ,
	             |	СделкаСПоставщикомГрафикОплат.УИН_ПервойСтроки,
	             |	СделкаСПоставщикомГрафикОплат.НомерСтрокиГрафика
	             |ИЗ
	             |	РегистрНакопления.РасчетыПоСделкамСПоставщиками КАК РасчетыПоСделкамСПоставщиками
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СделкаСПоставщиком.ГрафикОплат КАК СделкаСПоставщикомГрафикОплат
	             |		ПО РасчетыПоСделкамСПоставщиками.УИН_Этапа = СделкаСПоставщикомГрафикОплат.УИН_Строки
	             |			И РасчетыПоСделкамСПоставщиками.Сделка = СделкаСПоставщикомГрафикОплат.Ссылка
	             |ГДЕ
	             |	РасчетыПоСделкамСПоставщиками.Регистратор = &Регистратор
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	Преварительно.Сделка,
	             |	Преварительно.УИН_Этапа,
	             |	Преварительно.Комплектация,
	             |	Преварительно.УИН_СтрокиКомплектации,
	             |	Преварительно.ДатаПлатежа,
	             |	СУММА(Преварительно.СуммаОстаток) КАК СуммаОстаток,
	             |	Преварительно.УИН_ПервойСтроки,
	             |	Преварительно.НомерСтрокиГрафика КАК НомерСтрокиГрафика
	             |ИЗ
	             |	Преварительно КАК Преварительно
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	Преварительно.Сделка,
	             |	Преварительно.УИН_Этапа,
	             |	Преварительно.Комплектация,
	             |	Преварительно.УИН_СтрокиКомплектации,
	             |	Преварительно.ДатаПлатежа,
	             |	Преварительно.УИН_ПервойСтроки,
	             |	Преварительно.НомерСтрокиГрафика
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	НомерСтрокиГрафика
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	СделкаСПоставщикомЭтапыСделки.ВариантОплаты,
	             |	СделкаСПоставщикомЭтапыСделки.ПроцентОплаты КАК ВариантПроцентОплаты,
	             |	СделкаСПоставщикомЭтапыСделки.КоличествоДней КАК ВариантКоличествоДней,
	             |	СделкаСПоставщикомЭтапыСделки.ДатаОплаты КАК ВариантДатаОплаты,
	             |	СделкаСПоставщикомГрафикОплат.УИН_Строки КАК УИН_СтрокиСделки,
	             |	СделкаСПоставщикомГрафикОплат.Ссылка КАК Сделка,
	             |	СделкаСПоставщикомГрафикОплат.ДатаПлатежа КАК ДатаПлатежаВСделке,
	             |	СделкаСПоставщикомГрафикОплат.Цена КАК ЦенаВСделке,
	             |	СделкаСПоставщикомГрафикОплат.НомерСтрокиГрафика КАК НомерСтрокиГрафика,
	             |	СделкаСПоставщикомГрафикОплат.УИН_ПервойСтроки КАК УИН_ПервойСтроки
	             |ИЗ
	             |	Документ.СделкаСПоставщиком.ГрафикОплат КАК СделкаСПоставщикомГрафикОплат
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СделкаСПоставщиком.ЭтапыСделки КАК СделкаСПоставщикомЭтапыСделки
	             |		ПО СделкаСПоставщикомГрафикОплат.Ссылка = СделкаСПоставщикомЭтапыСделки.Ссылка
	             |			И СделкаСПоставщикомГрафикОплат.НомерСтрокиГрафика = СделкаСПоставщикомЭтапыСделки.НомерСтроки
	             |ГДЕ
	             |	СделкаСПоставщикомГрафикОплат.УИН_ПервойСтроки В(&УиныСтрокСделок)
	             |	И СделкаСПоставщикомГрафикОплат.Ссылка В(&СделкиДокумента)
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	Сделка,
	             |	УИН_ПервойСтроки,
	             |	НомерСтрокиГрафика
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ТоварыККомплектацииСделокСПоставщикамиОстатки.Сделка,
	             |	ТоварыККомплектацииСделокСПоставщикамиОстатки.Номенклатура,
	             |	ТоварыККомплектацииСделокСПоставщикамиОстатки.УИН_Этапа,
	             |	ТоварыККомплектацииСделокСПоставщикамиОстатки.КоличествоОстаток
	             |ИЗ
	             |	РегистрНакопления.ТоварыККомплектацииСделокСПоставщиками.Остатки(, ) КАК ТоварыККомплектацииСделокСПоставщикамиОстатки
	             |
	             |ОБЪЕДИНИТЬ ВСЕ
	             |
	             |ВЫБРАТЬ
	             |	ТоварыККомплектацииСделокСПоставщиками.Сделка,
	             |	ТоварыККомплектацииСделокСПоставщиками.Номенклатура,
	             |	ТоварыККомплектацииСделокСПоставщиками.УИН_Этапа,
	             |	ТоварыККомплектацииСделокСПоставщиками.Количество
	             |ИЗ
	             |	РегистрНакопления.ТоварыККомплектацииСделокСПоставщиками КАК ТоварыККомплектацииСделокСПоставщиками
	             |ГДЕ
	             |	ТоварыККомплектацииСделокСПоставщиками.Регистратор = &Регистратор
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ПредпоступлениеПоКомплектацииТовары.НомерСтроки КАК НомСтр,
	             |	ПредпоступлениеПоКомплектацииТовары.Номенклатура
	             |ИЗ
	             |	Документ.ПредпоступлениеПоКомплектации.Товары КАК ПредпоступлениеПоКомплектацииТовары
	             |ГДЕ
	             |	ПредпоступлениеПоКомплектацииТовары.Ссылка = &Регистратор
	             |	И ПредпоступлениеПоКомплектацииТовары.Номенклатура.ТипХолодильника = ЗНАЧЕНИЕ(Справочник.ТипыХолодильников.ПустаяСсылка)
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ЕСТЬNULL(ЛимитыРасходовНаСтруктурныеЕдиницыСрезПоследнихПоТочкам.СтруктурнаяЕдиница, ЕСТЬNULL(РасходыНаСтруктурныеЕдиницыОбороты.СтруктурнаяЕдиница, ЛимитыРасходовНаСтруктурныеЕдиницыСрезПоследних.СтруктурнаяЕдиница)) КАК Точка,
	             |	ЕСТЬNULL(ЛимитыРасходовНаСтруктурныеЕдиницыСрезПоследнихПоТочкам.ЛимитНаХолодильноеОборудование, ЕСТЬNULL(ЛимитыРасходовНаСтруктурныеЕдиницыСрезПоследних.ЛимитНаХолодильноеОборудование, 0)) - СУММА(ЕСТЬNULL(РасходыНаСтруктурныеЕдиницыОбороты.СуммаНаХолодильноеОборудованиеОборот, 0)) + СУММА(ЕСТЬNULL(РасходыНаСтруктурныеЕдиницы.СуммаНаХолодильноеОборудование, 0)) КАК Остаток
	             |ИЗ
	             |	РегистрСведений.ЛимитыРасходовНаСтруктурныеЕдиницы.СрезПоследних(, СтруктурнаяЕдиница = &ТТ) КАК ЛимитыРасходовНаСтруктурныеЕдиницыСрезПоследнихПоТочкам
	             |		ПОЛНОЕ СОЕДИНЕНИЕ РегистрНакопления.РасходыНаСтруктурныеЕдиницы.Обороты(, , , СтруктурнаяЕдиница = &ТТ) КАК РасходыНаСтруктурныеЕдиницыОбороты
	             |			ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.ЛимитыРасходовНаСтруктурныеЕдиницы.СрезПоследних(, СтруктурнаяЕдиница = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.Пустаяссылка)) КАК ЛимитыРасходовНаСтруктурныеЕдиницыСрезПоследних
	             |			ПО (ИСТИНА)
	             |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасходыНаСтруктурныеЕдиницы КАК РасходыНаСтруктурныеЕдиницы
	             |			ПО РасходыНаСтруктурныеЕдиницыОбороты.СтруктурнаяЕдиница = РасходыНаСтруктурныеЕдиницы.СтруктурнаяЕдиница
	             |				И (РасходыНаСтруктурныеЕдиницы.Регистратор = &Регистратор)
	             |		ПО ЛимитыРасходовНаСтруктурныеЕдиницыСрезПоследнихПоТочкам.СтруктурнаяЕдиница = РасходыНаСтруктурныеЕдиницыОбороты.СтруктурнаяЕдиница
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ЛимитыРасходовНаСтруктурныеЕдиницыСрезПоследнихПоТочкам.ЛимитНаХолодильноеОборудование,
	             |	ЛимитыРасходовНаСтруктурныеЕдиницыСрезПоследних.ЛимитНаХолодильноеОборудование,
	             |	ЕСТЬNULL(ЛимитыРасходовНаСтруктурныеЕдиницыСрезПоследнихПоТочкам.СтруктурнаяЕдиница, ЕСТЬNULL(РасходыНаСтруктурныеЕдиницыОбороты.СтруктурнаяЕдиница, ЛимитыРасходовНаСтруктурныеЕдиницыСрезПоследних.СтруктурнаяЕдиница))";
	Запрос=Новый Запрос(ТекстЗапроса);			 
	//Запрос.УстановитьПараметр("НаДату",Дата-1);
	Запрос.УстановитьПараметр("СделкиДокумента",Товары.ВыгрузитьКолонку("Сделка"));
	Запрос.УстановитьПараметр("УиныСтрокСделок",Товары.ВыгрузитьКолонку("УИН_СтрокиСделки"));
	Запрос.УстановитьПараметр("Регистратор",ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("ТТ",ЭтотОбъект.Магазин);
	//Запрос.УстановитьПараметр("НаДату",Дата-1);   
	Результат=Запрос.ВыполнитьПакет();
	ТабОстатковПоРасчетам=Результат[1].Выгрузить();
	ТабУсловийПоСделкам=Результат[2].Выгрузить();
	
	ТабОстатковККомплектации=Результат[3].Выгрузить();
	
	Если ЭтотОбъект.Дата>=Дата(2018,2,27) Тогда
		ТабСтрокБезТипаХолодильника = Результат[4].Выгрузить();
		Если ТабСтрокБезТипаХолодильника.Количество()>0 Тогда
			Отказ = Истина;
			Для каждого Стр Из ТабСтрокБезТипаХолодильника Цикл
			
				Сообщить("В строке "+Стр.НомСтр+" для номенклатуры "+Стр.Номенклатура+" не указан тип холодильника. Проведение невозможно.");
			
			КонецЦикла; 
			Возврат;
		КонецЕсли;	
	КонецЕсли;		
	
	//+++АК POZM 2018.09.11 ИП-00018684.01 
	//+++АК POZM 2018.10.09 ИП-00018684.02    
	ЗаписьРегистраПревышений = РегистрыСведений.ДокументыПревысившиеЛимитыТочек.СоздатьМенеджерЗаписи();
	ЗаписьРегистраПревышений.СсылкаНаДокумент = ЭтотОбъект.Ссылка;
	ЗаписьРегистраПревышений.Прочитать();	
	//---АК POZM 
					
	Если ОбщиеПроцедуры.ПолучитьЦФОПоСтруктурнойЕдинице(ЭтотОбъект.Магазин, ЭтотОбъект.Дата) = Справочники.СтруктурныеЕдиницы.НайтиПоКоду("ЦФО_12") Тогда
		ОстаткиЛимитов = Результат[5].Выгрузить();
		Если ОстаткиЛимитов.Количество() > 0 Тогда
			Если ОстаткиЛимитов[0].Остаток < ЭтотОбъект.СуммаДокумента Тогда
				
				Сообщение = Новый СообщениеПользователю();
			    Сообщение.Текст ="Превышена сумма лимита расходов по " + ЭтотОбъект.Магазин + " на " + (-ОстаткиЛимитов[0].Остаток + ЭтотОбъект.СуммаДокумента) + "(" + ЭтотОбъект.Ссылка + ")";
				Сообщение.УстановитьДанные(ЭтотОбъект.Ссылка);
			    Сообщение.Сообщить();
				
				ПравоПревышенияЛимитаПоТТ = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.ПревышениеЛимитовПоТТ, Ложь);
				Если Не ПравоПревышенияЛимитаПоТТ Тогда
					
					//+++АК POZM 2018.10.09 ИП-00018684.02    
					Если НЕ ЗаписьРегистраПревышений.Выбран() Тогда
						ЗаписьРегистраПревышений.СсылкаНаДокумент = ЭтотОбъект.Ссылка;
						ЗаписьРегистраПревышений.Записать(Ложь);
					КонецЕсли;
			        					
					//---АК POZM 
					Отказ = Истина;
				КонецЕсли;	
			КонецЕсли;	
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;	
		
		Движения.РасходыНаСтруктурныеЕдиницы.Записывать = Истина;
		Движения.РасходыНаСтруктурныеЕдиницы.Очистить();
		НД = Движения.РасходыНаСтруктурныеЕдиницы.Добавить();
		НД.Период = ЭтотОбъект.Дата;
		НД.СтруктурнаяЕдиница = ЭтотОбъект.Магазин;
		НД.СуммаНаХолодильноеОборудование = ЭтотОбъект.СуммаДокумента;
	КонецЕсли;
	//+++АК POZM 2018.10.09 ИП-00018684.02    
	Если ЗаписьРегистраПревышений.Выбран() Тогда
		ЗаписьРегистраПревышений.Удалить();
	КонецЕсли;
	//---АК POZM 
	//---АК POZM 
	
	Движения.ТоварыККомплектацииСделокСПоставщиками.Записывать = Истина;
	Движения.ТоварыККомплектацииСделокСПоставщиками.Очистить();
	
	Движения.РасчетыПоСделкамСПоставщиками.Записывать=Истина;
	Движения.РасчетыПоСделкамСПоставщиками.Очистить();
	
	Движения.ТМЦКПоступлению.Записывать = Истина;
	Движения.ТМЦКПоступлению.Очистить();
	
	БезКонтроля = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.КорректировкаОплаченныхПредпоступлений, Ложь);
	
	Для Каждого ТекСтрокаКомплектация Из Товары Цикл
		
		Движение = Движения.ТоварыККомплектацииСделокСПоставщиками.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Сделка = ТекСтрокаКомплектация.Сделка;
		Движение.УИН_Этапа = ТекСтрокаКомплектация.УИН_СтрокиСделки;
		Движение.Номенклатура = ТекСтрокаКомплектация.Номенклатура;
		Движение.Количество = ТекСтрокаКомплектация.Количество;
		
		СтрокиОстатков = ТабОстатковККомплектации.НайтиСтроки(Новый Структура("Сделка,Номенклатура,УИН_Этапа",ТекСтрокаКомплектация.Сделка,ТекСтрокаКомплектация.Номенклатура,ТекСтрокаКомплектация.УИН_СтрокиСделки));
		Если СтрокиОстатков.Количество()>0 Тогда
			СтрокиОстатков[0].КоличествоОстаток = СтрокиОстатков[0].КоличествоОстаток - ТекСтрокаКомплектация.Количество;
			Если СтрокиОстатков[0].КоличествоОстаток < 0 Тогда
				Отказ = Истина;
			КонецЕсли;	
		Иначе	
			Отказ = Истина;
		КонецЕсли;	
		Если Отказ Тогда
			Сообщить("Недостаточно свободных остатков по "+ТекСтрокаКомплектация.Номенклатура);
		КонецЕсли;
		Если БезКонтроля Тогда
			Отказ = Ложь;
		КонецЕсли;	
		Если Дата >= Дата(2017,05,10)  Тогда
			Движение = Движения.ТМЦКПоступлению.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.Количество = ТекСтрокаКомплектация.Количество;
			Движение.Номенклатура = ТекСтрокаКомплектация.Номенклатура;
			Движение.Предпоступление = ЭтотОбъект.Ссылка;
			Движение.Сделка = ТекСтрокаКомплектация.Сделка;
		КонецЕсли; 
		
		////////////
		//Движение = Движения.ТоварыККомплектацииСделокСПоставщиками.Добавить();
		//Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		//Движение.Период = Дата;
		//Движение.Сделка = ТекСтрокаКомплектация.Сделка;
		//Движение.УИН_Этапа = ТекСтрокаКомплектация.УИН_СтрокиСделки;
		//Движение.Номенклатура = ТекСтрокаКомплектация.Номенклатура;
		//Движение.Количество = ТекСтрокаКомплектация.Количество;
		
		/////////////////////////
		
		СтруктураПоискаСтрокСделки=Новый Структура;
		СтруктураПоискаСтрокСделки.Вставить("УИН_ПервойСтроки",ТекСтрокаКомплектация.УИН_СтрокиСделки);
		СтруктураПоискаСтрокСделки.Вставить("Сделка",ТекСтрокаКомплектация.Сделка);
		
		СтрокиСделки=ТабУсловийПоСделкам.НайтиСтроки(СтруктураПоискаСтрокСделки);
		
		//ДанныеПредЭтапа=Новый Структура;
		//ДанныеПредЭтапа.Вставить("Оплачен");
		//ДанныеПредЭтапа.Вставить("ВариантОплаты");
		//ДанныеПредЭтапа.Вставить("ВариантПроцентОплаты");
		//ДанныеПредЭтапа.Вставить("ВариантКоличествоДней");
		//ДанныеПредЭтапа.Вставить("ВариантДатаОплаты");
		//ДанныеПредЭтапа.Вставить("ДатаПлатежаВСделке");
		//ДанныеПредЭтапа.Вставить("ЦенаВСделке");
		ДатаПлатежаПредЭтапа=Дата(1,1,1);
		
		Для Каждого СтрокаСделки Из СтрокиСделки Цикл
					
			СтруктураПоискаОстатков=Новый Структура;
			СтруктураПоискаОстатков.Вставить("УИН_Этапа",СтрокаСделки.УИН_СтрокиСделки);
			СтруктураПоискаОстатков.Вставить("Сделка",СтрокаСделки.Сделка);
			
			ОстаткиПоСтроке=ТабОстатковПоРасчетам.НайтиСтроки(СтруктураПоискаОстатков);
			
			Если СтрокаСделки.ВариантОплаты=Перечисления.ВариантыОплаты.ВТеченииДней Тогда
				Если ДатаПлатежаПредЭтапа<>Дата(1,1,1) Тогда
					ДатаПлатежа=ДатаПлатежаПредЭтапа+СтрокаСделки.ВариантКоличествоДней*60*60*24;
				Иначе
					ДатаПлатежа=Дата(1,1,1);
				КонецЕсли;
			ИначеЕсли СтрокаСделки.ВариантОплаты=Перечисления.ВариантыОплаты.ВУказаннуюДату Тогда
				ДатаПлатежа=СтрокаСделки.ДатаПлатежаВСделке;
			ИначеЕсли СтрокаСделки.ВариантОплаты=Перечисления.ВариантыОплаты.ПриПодписанииАкта Тогда
				Если ЭтотОбъект.ДатаАкта=Дата(1,1,1) Тогда
					ДатаПлатежа=Дата(1,1,1);
				Иначе	
					ДатаПлатежа=ЭтотОбъект.ДатаАкта+СтрокаСделки.ВариантКоличествоДней*60*60*24;
				КонецЕсли;	
				СуммаПлатежа=СтрокаСделки.ЦенаВСделке*ТекСтрокаКомплектация.Количество;
			ИначеЕсли СтрокаСделки.ВариантОплаты=Перечисления.ВариантыОплаты.ПоГотовности Тогда
				Если ТекСтрокаКомплектация.ДатаГотовности=Дата(1,1,1) Тогда
					ДатаПлатежа=Дата(1,1,1);
				Иначе	
					ДатаПлатежа=ТекСтрокаКомплектация.ДатаГотовности+СтрокаСделки.ВариантКоличествоДней*60*60*24;
				КонецЕсли;	
				СуммаПлатежа=СтрокаСделки.ЦенаВСделке*ТекСтрокаКомплектация.Количество;		
				
			КонецЕсли;	
			СуммаПлатежа=СтрокаСделки.ЦенаВСделке*ТекСтрокаКомплектация.Количество*СтрокаСделки.ВариантПроцентОплаты/100;
			ДатаПлатежаПредЭтапа=ДатаПлатежа;
			
			Если ОстаткиПоСтроке.Количество()=0 ИЛИ СтрокаСделки.ВариантОплаты=Перечисления.ВариантыОплаты.ВУказаннуюДату Тогда//Этап оплачен, но от него могут зависеть следующие этапы, просто запомним его данные
				Продолжить;
			КонецЕсли;
			
			
			Движение=Движения.РасчетыПоСделкамСПоставщиками.Добавить();
			Движение.ВидДвижения=ВидДвиженияНакопления.Расход;
			Движение.ДатаПлатежа=ОстаткиПоСтроке[0].ДатаПлатежа;
			Движение.Сделка=ТекСтрокаКомплектация.Сделка;
			Движение.УИН_Этапа=ОстаткиПоСтроке[0].УИН_Этапа;
			Движение.Сумма=СуммаПлатежа;
			Движение.Период=ЭтотОбъект.Дата;
			
			Движение=Движения.РасчетыПоСделкамСПоставщиками.Добавить();
			Движение.ВидДвижения=ВидДвиженияНакопления.Приход;
			
			Движение.ДатаПлатежа=ДатаПлатежа;
			Движение.Сумма=СуммаПлатежа;
			
			Движение.Сделка=ТекСтрокаКомплектация.Сделка;
			Движение.УИН_Этапа=ОстаткиПоСтроке[0].УИН_Этапа;
			Движение.Комплектация=ЭтотОбъект.Ссылка;
			Движение.УИН_СтрокиКомплектации=ТекСтрокаКомплектация.УИН_Строки;
			Движение.Период=ЭтотОбъект.Дата;
			
		КонецЦикла;	
	КонецЦикла;
	//+++АК POZM 2018.05.08 ИП-00018375 
	ОтразитьПлановуюКомплектацию();
	//---АК POZM 
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Если СокрЛП(ТекСтрокаТовары.УИН_Строки)="" Тогда
			ТекСтрокаТовары.УИН_Строки=Новый УникальныйИдентификатор();
		КонецЕсли;	
	КонецЦикла;

	
	Если ЭтоНовый() Тогда
		ТекстЗапроса="ВЫБРАТЬ
		             |	ПредпоступлениеПоКомплектации.Ссылка
		             |ИЗ
		             |	Документ.ПредпоступлениеПоКомплектации КАК ПредпоступлениеПоКомплектации
		             |ГДЕ
		             |	ПредпоступлениеПоКомплектации.ДатаАкта = &ДатаАкта
		             |	И ПредпоступлениеПоКомплектации.НомерАкта = &НомерАкта
		             |	И ПредпоступлениеПоКомплектации.Контрагент = &Контрагент";
		Запрос=Новый Запрос(ТекстЗапроса);			 
		Запрос.УстановитьПараметр("ДатаАкта",ЭтотОбъект.ДатаАкта);
		Запрос.УстановитьПараметр("НомерАкта",ЭтотОбъект.НомерАкта);
		Запрос.УстановитьПараметр("Контрагент",ЭтотОбъект.Контрагент);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			//Отказ = Истина;
			Сообщить("Уже есть Предпоступление по контрагенту "+ЭтотОбъект.Контрагент +" с таким номером и датой акта");
		КонецЕсли;	
	КонецЕсли;	
	
	РассчитатьСуммуДокумента();
	
	//+++АК POZM 2017.11.04 ИП-00017048
	ЗаполнитьИсториюСтрок();
	//---АК POZM 
КонецПроцедуры

//+++АК POZM 2017.11.04 ИП-00017048 
Процедура ЗаполнитьИсториюСтрок()

	Для каждого Стр Из ЭтотОбъект.Товары Цикл
	
		НС = ЭтотОбъект.ТоварыИстория.Добавить();
		ЗаполнитьЗначенияСвойств(НС,Стр);
		НС.Дата = ТекущаяДата();
	    НС.Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЦикла; 

КонецПроцедуры
 
//---АК POZM 

//+++АК POZM 2018.05.08 ИП-00018375 
Процедура ОтразитьПлановуюКомплектацию()
	ЗначенияТиповХолодильника = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ЭтотОбъект.Товары.ВыгрузитьКолонку("Номенклатура"),"ТипХолодильника");
	
	Движения.ПлановаяКомплектацияТорговыхТочек.Записывать = Истина;
	Движения.ПлановаяКомплектацияТорговыхТочек.Очистить();
	Для каждого Стр Из ЭтотОбъект.Товары Цикл
		Если Не ЗначениеЗаполнено(ЗначенияТиповХолодильника[Стр.Номенклатура].ТипХолодильника) Тогда
			Продолжить;
		КонецЕсли;	
		НД = Движения.ПлановаяКомплектацияТорговыхТочек.ДобавитьРасход();
		НД.Количество = 1;
		НД.Магазин = ЭтотОбъект.Магазин;
		//НД.Оборудование = Стр.Номенклатура;
		НД.Период = ЭтотОбъект.Дата;
		НД.ТипОборудования =ЗначенияТиповХолодильника[Стр.Номенклатура].ТипХолодильника;
	
	КонецЦикла; 
КонецПроцедуры
//---АК POZM 
