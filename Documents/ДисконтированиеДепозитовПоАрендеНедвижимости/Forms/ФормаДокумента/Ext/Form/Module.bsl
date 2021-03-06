﻿&НаКлиенте
Перем КэшСтрокиНачисление;

&НаКлиенте
Перем КэшСтрокиСписание;

&НаКлиенте
Процедура ЗаполнитьДисконт(Команда)
	
	Если Объект.Проведен Тогда
		Сообщить("Заполнение разрешено только для непроведенных документов!", СтатусСообщения.Важное);
		Возврат;
	КонецЕсли; 
	
	ЗаполнитьДисконтСервер();		
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДисконтСервер()
	
	КопияТЧ = 	Объект.НачислениеДисконта.Выгрузить();
	СтрокиТЧ = КопияТЧ.НайтиСтроки(Новый Структура("РедактировалосьВручную", Истина));
    Объект.НачислениеДисконта.Загрузить(КопияТЧ.Скопировать(СтрокиТЧ));
	
	КопияТЧ = 	Объект.СписаниеДисконта.Выгрузить();
	СтрокиТЧ = КопияТЧ.НайтиСтроки(Новый Структура("РедактировалосьВручную", Истина));
    Объект.СписаниеДисконта.Загрузить(КопияТЧ.Скопировать(СтрокиТЧ));
	
	ОтредактированныеДокументы = Объект.НачислениеДисконта.Выгрузить().ВыгрузитьКолонку("Документ");
	
	Для Каждого Документ Из Объект.НачислениеДисконта.Выгрузить().ВыгрузитьКолонку("Документ") Цикл
		ОтредактированныеДокументы.Добавить(Документ);
	КонецЦикла;  
	
	//
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	СтавкиДисконтированияДепозитовСрезПоследних.ЗначениеСтавки
	|ИЗ
	|	РегистрСведений.СтавкиДисконтированияДепозитов.СрезПоследних(КОНЕЦПЕРИОДА(&Период, МЕСЯЦ), ВидСтавки = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокДисконтированияДепозитов.Стандартная)) КАК СтавкиДисконтированияДепозитовСрезПоследних");
	
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТекущаяСтавкаДисконта = Выборка.ЗначениеСтавки;
	Иначе
		Сообщить("Заполнение не произведено! Не задана дисконтная ставка! ");
	КонецЕсли; 
	
	//
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	ДополнительноеСоглашениеСрезПоследних.Ссылка,
	                      |	ДополнительноеСоглашениеСрезПоследних.ДокументОснование,
	                      |	ДополнительноеСоглашениеСрезПоследних.ДатаОкончанияДоговора
	                      |ПОМЕСТИТЬ ВТ_ДополнительныеСоглашенияСрезПоследних
	                      |ИЗ
	                      |	Документ.ДополнительноеСоглашение КАК ДополнительноеСоглашениеСрезПоследних
	                      |ГДЕ
	                      |	ДополнительноеСоглашениеСрезПоследних.Ссылка В
	                      |			(ВЫБРАТЬ ПЕРВЫЕ 1
	                      |				ДополнительноеСоглашение.Ссылка КАК Ссылка
	                      |			ИЗ
	                      |				Документ.ДополнительноеСоглашение КАК ДополнительноеСоглашение
	                      |			ГДЕ
	                      |				ДополнительноеСоглашение.ДокументОснование = ДополнительноеСоглашениеСрезПоследних.ДокументОснование
	                      |				И ДополнительноеСоглашение.Дата <= КОНЕЦПЕРИОДА(&Период, МЕСЯЦ)
	                      |				И ДополнительноеСоглашение.Проведен
	                      |			УПОРЯДОЧИТЬ ПО
	                      |				ДополнительноеСоглашение.МоментВремени УБЫВ)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	ЗаключениеДоговораАренды.Ссылка КАК Документ,
	                      |	ЗаключениеДоговораАренды.ОбъектАренды.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	                      |	ЗаключениеДоговораАренды.Контрагент КАК Контрагент,
	                      |	ЕСТЬNULL(ВТ_ДополнительныеСоглашенияСрезПоследних.ДатаОкончанияДоговора, ЗаключениеДоговораАренды.ДатаОкончанияДоговора) КАК ДатаОкончанияДоговора
	                      |ПОМЕСТИТЬ ВТ_ТорговыеТочкиПредварительно
	                      |ИЗ
	                      |	Документ.ЗаключениеДоговораАренды КАК ЗаключениеДоговораАренды
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасторжениеДоговораАренды КАК РасторжениеДоговораАренды
	                      |		ПО (РасторжениеДоговораАренды.ДокументОснование = ЗаключениеДоговораАренды.Ссылка)
	                      |			И (РасторжениеДоговораАренды.Дата < НАЧАЛОПЕРИОДА(&Период, МЕСЯЦ))
	                      |			И (РасторжениеДоговораАренды.Проведен)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДополнительныеСоглашенияСрезПоследних КАК ВТ_ДополнительныеСоглашенияСрезПоследних
	                      |		ПО (ВТ_ДополнительныеСоглашенияСрезПоследних.ДокументОснование = ЗаключениеДоговораАренды.Ссылка)
	                      |ГДЕ
	                      |	ЗаключениеДоговораАренды.Проведен
	                      |	И ЗаключениеДоговораАренды.Организация = &Организация
	                      |	И РАЗНОСТЬДАТ(ВЫБОР
	                      |				КОГДА ЗаключениеДоговораАренды.ДатаЗаключенияДоговора = ДАТАВРЕМЯ(1, 1, 1)
	                      |					ТОГДА ЗаключениеДоговораАренды.ДатаАкта
	                      |				ИНАЧЕ ЗаключениеДоговораАренды.ДатаЗаключенияДоговора
	                      |			КОНЕЦ, ЕСТЬNULL(ВТ_ДополнительныеСоглашенияСрезПоследних.ДатаОкончанияДоговора, ЗаключениеДоговораАренды.ДатаОкончанияДоговора), ДЕНЬ) > 365
	                      |	И РасторжениеДоговораАренды.Ссылка ЕСТЬ NULL
	                      |	И ЗаключениеДоговораАренды.ДоговорКонтрагента В
	                      |			(ВЫБРАТЬ
	                      |				РегистрСведений.ДепозитыПоДоговорамАренды.ДоговорКонтрагента
	                      |			ИЗ
	                      |				РегистрСведений.ДепозитыПоДоговорамАренды)
	                      |	И ВЫБОР
	                      |			КОГДА ЗаключениеДоговораАренды.ДатаЗаключенияДоговора = ДАТАВРЕМЯ(1, 1, 1)
	                      |				ТОГДА ЗаключениеДоговораАренды.ДатаАкта
	                      |			ИНАЧЕ ЗаключениеДоговораАренды.ДатаЗаключенияДоговора
	                      |		КОНЕЦ <= КОНЕЦПЕРИОДА(&Период, МЕСЯЦ)
	                      |	И НЕ ЗаключениеДоговораАренды.Ссылка В (&ОтредактированныеДокументы)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ_ТорговыеТочкиПредварительноСрезПоследних.Документ,
	                      |	ВТ_ТорговыеТочкиПредварительноСрезПоследних.СтруктурнаяЕдиница,
	                      |	ВТ_ТорговыеТочкиПредварительноСрезПоследних.Контрагент,
	                      |	ВТ_ТорговыеТочкиПредварительноСрезПоследних.ДатаОкончанияДоговора
	                      |ПОМЕСТИТЬ ВТ_ТорговыеТочки
	                      |ИЗ
	                      |	ВТ_ТорговыеТочкиПредварительно КАК ВТ_ТорговыеТочкиПредварительноСрезПоследних
	                      |ГДЕ
	                      |	ВТ_ТорговыеТочкиПредварительноСрезПоследних.Документ В
	                      |			(ВЫБРАТЬ ПЕРВЫЕ 1
	                      |				ВТ_ТорговыеТочкиПредварительно.Документ
	                      |			ИЗ
	                      |				ВТ_ТорговыеТочкиПредварительно КАК ВТ_ТорговыеТочкиПредварительно
	                      |			ГДЕ
	                      |				ВТ_ТорговыеТочкиПредварительно.СтруктурнаяЕдиница = ВТ_ТорговыеТочкиПредварительноСрезПоследних.СтруктурнаяЕдиница
	                      |				И ВТ_ТорговыеТочкиПредварительно.Контрагент = ВТ_ТорговыеТочкиПредварительноСрезПоследних.Контрагент
	                      |			УПОРЯДОЧИТЬ ПО
	                      |				ВТ_ТорговыеТочкиПредварительно.Документ.МоментВремени УБЫВ)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ_ТорговыеТочки.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	                      |	ВТ_ТорговыеТочки.Контрагент КАК Контрагент,
	                      |	ВТ_ТорговыеТочки.Документ,
	                      |	ВТ_ТорговыеТочки.ДатаОкончанияДоговора,
	                      |	ФинансовыйОстаткиИОбороты.СуммаНачальныйОстатокДт КАК СуммаНачальныйОстаток,
	                      |	ФинансовыйОстаткиИОбороты.СуммаКонечныйОстатокДт КАК СуммаКонечныйОстаток,
	                      |	ФинансовыйОстаткиИОбороты.СуммаМСФОКонечныйОстатокКт КАК СуммаМСФОКонечныйОстаток
	                      |ПОМЕСТИТЬ ВТ_ОстаткиНаСчете
	                      |ИЗ
	                      |	ВТ_ТорговыеТочки КАК ВТ_ТорговыеТочки
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Финансовый.ОстаткиИОбороты(НАЧАЛОПЕРИОДА(&Период, МЕСЯЦ), КОНЕЦПЕРИОДА(&Период, МЕСЯЦ), Период, , Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.ОбеспечительныйВзнос), , Организация = &Организация) КАК ФинансовыйОстаткиИОбороты
	                      |		ПО (ФинансовыйОстаткиИОбороты.Субконто2 = ВТ_ТорговыеТочки.Контрагент)
	                      |			И (ФинансовыйОстаткиИОбороты.Субконто3 = ВТ_ТорговыеТочки.СтруктурнаяЕдиница)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ЕСТЬNULL(ВТ_ОстаткиНаСчете.Контрагент, ДисконтПоДепозитамАрендыНедвижимостиОстатки.Контрагент) КАК Контрагент,
	                      |	ЕСТЬNULL(ВТ_ОстаткиНаСчете.Документ.ДоговорКонтрагента, ДисконтПоДепозитамАрендыНедвижимостиОстатки.ДоговорКонтрагента) КАК ДоговорКонтрагента,
	                      |	ЕСТЬNULL(ВТ_ОстаткиНаСчете.Документ, ДисконтПоДепозитамАрендыНедвижимостиОстатки.Документ) КАК Документ,
	                      |	ЕСТЬNULL(ВТ_ОстаткиНаСчете.СтруктурнаяЕдиница, ДисконтПоДепозитамАрендыНедвижимостиОстатки.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиница,
	                      |	ВТ_ОстаткиНаСчете.ДатаОкончанияДоговора КАК ДатаОкончанияДоговораДляНачисления,
	                      |	ВТ_ОстаткиНаСчете.СуммаНачальныйОстаток КАК СуммаНачальныйОстаток,
	                      |	ВТ_ОстаткиНаСчете.СуммаКонечныйОстаток КАК СуммаКонечныйОстаток,
	                      |	ВТ_ОстаткиНаСчете.СуммаМСФОКонечныйОстаток КАК СуммаМСФОКонечныйОстаток,
	                      |	ДисконтПоДепозитамАрендыНедвижимостиОстатки.СтавкаДисконта,
	                      |	ДисконтПоДепозитамАрендыНедвижимостиОстатки.ДатаОкончанияДоговора КАК ДатаОкончанияДоговора,
	                      |	ДисконтПоДепозитамАрендыНедвижимостиОстатки.СуммаДисконтаОстаток КАК СуммаДисконтаПоРегистру,
	                      |	ДисконтПоДепозитамАрендыНедвижимостиОстатки.СуммаДепозитаОстаток КАК СуммаДепозитаПоРегистру
	                      |ИЗ
	                      |	ВТ_ОстаткиНаСчете КАК ВТ_ОстаткиНаСчете
	                      |		ПОЛНОЕ СОЕДИНЕНИЕ РегистрНакопления.ДисконтПоДепозитамАрендыНедвижимости.Остатки(НАЧАЛОПЕРИОДА(&Период, МЕСЯЦ), Организация = &Организация) КАК ДисконтПоДепозитамАрендыНедвижимостиОстатки
	                      |		ПО ВТ_ОстаткиНаСчете.Документ = ДисконтПоДепозитамАрендыНедвижимостиОстатки.Документ
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Контрагент,
	                      |	СтруктурнаяЕдиница
	                      |ИТОГИ
	                      |	МАКСИМУМ(Контрагент),
	                      |	МАКСИМУМ(ДоговорКонтрагента),
	                      |	МАКСИМУМ(СтруктурнаяЕдиница),
	                      |	МАКСИМУМ(ДатаОкончанияДоговораДляНачисления),
	                      |	ЕСТЬNULL(МАКСИМУМ(СуммаНачальныйОстаток), 0) КАК СуммаНачальныйОстаток,
	                      |	ЕСТЬNULL(МАКСИМУМ(СуммаКонечныйОстаток), 0) КАК СуммаКонечныйОстаток,
	                      |	ЕСТЬNULL(МАКСИМУМ(СуммаМСФОКонечныйОстаток), 0) КАК СуммаМСФОКонечныйОстаток,
	                      |	ЕСТЬNULL(СУММА(СуммаДисконтаПоРегистру), 0) КАК СуммаДисконтаПоРегистру,
	                      |	ЕСТЬNULL(СУММА(СуммаДепозитаПоРегистру), 0) КАК СуммаДепозитаПоРегистру
	                      |ПО
	                      |	Документ
	                      |АВТОУПОРЯДОЧИВАНИЕ
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ_ТорговыеТочки.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	                      |	ВТ_ТорговыеТочки.Контрагент КАК Контрагент,
	                      |	ФинансовыйОстаткиИОбороты.Период,
	                      |	ФинансовыйОстаткиИОбороты.СуммаОборотДт,
	                      |	ФинансовыйОстаткиИОбороты.СуммаОборотКт
	                      |ИЗ
	                      |	РегистрБухгалтерии.Финансовый.ОстаткиИОбороты(НАЧАЛОПЕРИОДА(&Период, МЕСЯЦ), КОНЕЦПЕРИОДА(&Период, МЕСЯЦ), День, Движения, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.ОбеспечительныйВзнос), , Организация = &Организация) КАК ФинансовыйОстаткиИОбороты
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ТорговыеТочки КАК ВТ_ТорговыеТочки
	                      |		ПО ФинансовыйОстаткиИОбороты.Субконто2 = ВТ_ТорговыеТочки.Контрагент
	                      |			И ФинансовыйОстаткиИОбороты.Субконто3 = ВТ_ТорговыеТочки.СтруктурнаяЕдиница
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	СтруктурнаяЕдиница,
	                      |	Контрагент,
	                      |	ФинансовыйОстаткиИОбороты.Период");
	
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);	
	Запрос.УстановитьПараметр("ОтредактированныеДокументы", ОтредактированныеДокументы);	
	                                                                       
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ТаблицаДвижений = РезультатыЗапроса[РезультатыЗапроса.ВГраница()].Выгрузить();
	
	ДеревоРезультат = РезультатыЗапроса[РезультатыЗапроса.ВГраница()-1].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Для Каждого СтрокаДокумент Из ДеревоРезультат.Строки Цикл
		
		// Проверяем синхронность данных по разным видам учета
		Если СтрокаДокумент.СуммаНачальныйОстаток = 0 И СтрокаДокумент.СуммаКонечныйОстаток = 0  Тогда	
			Если СтрокаДокумент.СуммаМСФОКонечныйОстаток > 0 Тогда
				Сообщить("ТТ: " + СтрокаДокумент.СтруктурнаяЕдиница + ". Контрагент: " + СтрокаДокумент.Контрагент + ". " + СтрокаДокумент.Документ + ". Сальдо по счету 60.1 (УУ) отсутствует. Незакрытое сальдо по счету 60.1 (Корректировки МСФО): " + Формат(СтрокаДокумент.СуммаМСФОКонечныйОстаток,"ЧДЦ=2; ЧН=") + ".", СтатусСообщения.Важное);			
			КонецЕсли;					
			
			Если СтрокаДокумент.СуммаДисконтаПоРегистру <> 0 Тогда
				Сообщить("ТТ: " + СтрокаДокумент.СтруктурнаяЕдиница + ". Контрагент: " + СтрокаДокумент.Контрагент + ". " + СтрокаДокумент.Документ + ". Сальдо по счету 60.1 (УУ) отсутствует. Незакрытый остаток дисконта по регистру ""Дисконт по депозитам"": " + Формат(СтрокаДокумент.СуммаДисконтаПоРегистру,"ЧДЦ=2; ЧН=") + ".", СтатусСообщения.Важное);			
			КонецЕсли;	
			
			Если СтрокаДокумент.СуммаДепозитаПоРегистру <> 0 Тогда
				Сообщить("ТТ: " + СтрокаДокумент.СтруктурнаяЕдиница + ". Контрагент: " + СтрокаДокумент.Контрагент + ". " + СтрокаДокумент.Документ + ". Сальдо по счету 60.1 (УУ) отсутствует. Незакрытый остаток депозита по регистру ""Дисконт по депозитам"": " + Формат(СтрокаДокумент.СуммаДепозитаПоРегистру,"ЧДЦ=2; ЧН=") + ".", СтатусСообщения.Важное);			
			КонецЕсли;	
			
			Продолжить;
			
		ИначеЕсли СтрокаДокумент.СуммаМСФОКонечныйОстаток <> СтрокаДокумент.СуммаДисконтаПоРегистру Тогда
			Сообщить("ТТ: " + СтрокаДокумент.СтруктурнаяЕдиница + ". Контрагент: " + СтрокаДокумент.Контрагент + ". " + СтрокаДокумент.Документ + ". Не совпадают остаток дисконта по регистру ""Дисконт по депозитам"": " + Формат(СтрокаДокумент.СуммаДисконтаПоРегистру,"ЧДЦ=2; ЧН=") + " и сальдо по счету 60.1 (Корректировки МСФО): " + Формат(СтрокаДокумент.СуммаМСФОКонечныйОстаток,"ЧДЦ=2; ЧН=") + ".", СтатусСообщения.Важное);
			Продолжить;
			
		ИначеЕсли СтрокаДокумент.СуммаНачальныйОстаток <> СтрокаДокумент.СуммаДепозитаПоРегистру Тогда
			Сообщить("ТТ: " + СтрокаДокумент.СтруктурнаяЕдиница + ". Контрагент: " + СтрокаДокумент.Контрагент + ". " + СтрокаДокумент.Документ + ". Не совпадают сумма  депозита по регистру ""Дисконт по депозитам"": " + Формат(СтрокаДокумент.СуммаДепозитаПоРегистру,"ЧДЦ=2; ЧН=") + " и сальдо на начало месяца по счету 60.1 (УУ): " + Формат(СтрокаДокумент.СуммаНачальныйОстаток,"ЧДЦ=2; ЧН=") + ".", СтатусСообщения.Важное);
			Продолжить;
			
		КонецЕсли;
		
		// Если списания депозита не было - анализируем изменение сроков депозитов сразу (иначе - сначала спишем депозит, и потом проанализируем остаток)
		Если СтрокаДокумент.СуммаНачальныйОстаток <= СтрокаДокумент.СуммаКонечныйОстаток  Тогда
			
			Для Каждого Строка Из СтрокаДокумент.Строки Цикл
				Если ЗначениеЗаполнено(Строка.ДатаОкончанияДоговора) И ЗначениеЗаполнено(СтрокаДокумент.ДатаОкончанияДоговораДляНачисления) И Строка.ДатаОкончанияДоговора <> СтрокаДокумент.ДатаОкончанияДоговораДляНачисления Тогда
					
					// Если изменился срок действия договора, то сторнируем остаток дисконта по старой дате и начсляем новый дисконт и проценты за текущий месяц
					НоваяСтрокаСторно = Объект.НачислениеДисконта.Добавить();
					
					ЗаполнитьЗначенияСвойств(НоваяСтрокаСторно, Строка);	
					НоваяСтрокаСторно.СуммаДисконта = - Строка.СуммаДисконтаПоРегистру;
					НоваяСтрокаСторно.СуммаДепозита = - Строка.СуммаДепозитаПоРегистру;
					
					НачислитьДисконтИПроцентыЗаПервыйМесяц(СтрокаДокумент, Строка.СуммаДепозитаПоРегистру, НачалоМесяца(Объект.Дата), СтрокаДокумент.ДатаОкончанияДоговораДляНачисления);
					
					// Обнуляем сумму дисконта, чтобы повторно не начислить проценты
					Строка.СуммаДисконтаПоРегистру = 0;
				КонецЕсли; 
			КонецЦикла;  
			
		КонецЕсли; 
		
		// Анализируем изменение сальдо по депозиту в финансовом учете
		Если СтрокаДокумент.СуммаНачальныйОстаток = СтрокаДокумент.СуммаКонечныйОстаток Тогда
			
			НачислитьПроцентыПланово(СтрокаДокумент);				
			
		ИначеЕсли СтрокаДокумент.СуммаНачальныйОстаток < СтрокаДокумент.СуммаКонечныйОстаток Тогда	
			
			Если СтрокаДокумент.СуммаНачальныйОстаток>0 Тогда
				НачислитьПроцентыПланово(СтрокаДокумент);
			КонецЕсли; 
			
			// Если были движения по кредиту - то датируем всю сумму первой дебетовой датой, иначе на каждую дату - своя запись
			ДвиженияПоТТ = ТаблицаДвижений.Скопировать(ТаблицаДвижений.НайтиСтроки(Новый Структура("СтруктурнаяЕдиница, Контрагент", СтрокаДокумент.СтруктурнаяЕдиница, СтрокаДокумент.Контрагент)));
			ИспользуемПервуюДату = ДвиженияПоТТ.Итог("СуммаОборотКт") <> 0;
			
			Для Каждого Строка ИЗ ДвиженияПоТТ Цикл
				Если ИспользуемПервуюДату И Строка.СуммаОборотДт>0 Тогда
					НачислитьДисконтИПроцентыЗаПервыйМесяц(СтрокаДокумент, СтрокаДокумент.СуммаКонечныйОстаток - СтрокаДокумент.СуммаНачальныйОстаток, Строка.Период, СтрокаДокумент.ДатаОкончанияДоговораДляНачисления);						
					Прервать;
				Иначе
					НачислитьДисконтИПроцентыЗаПервыйМесяц(СтрокаДокумент, Строка.СуммаОборотДт, Строка.Период, СтрокаДокумент.ДатаОкончанияДоговораДляНачисления);
				КонецЕсли; 
			КонецЦикла;  
				
		ИначеЕсли СтрокаДокумент.СуммаНачальныйОстаток > СтрокаДокумент.СуммаКонечныйОстаток Тогда	
			
			// Дисконт списываем пропорционально списанию депозита
			ТаблицаСписания = Объект.СписаниеДисконта.Выгрузить().СкопироватьКолонки();
			ТаблицаСписания.Колонки.Добавить("СуммаДепозитаПоРегистру", ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15,2));
			ТаблицаСписания.Колонки.Добавить("СуммаДисконтаПоРегистру", ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15,2));
			
			Для Каждого Строка Из СтрокаДокумент.Строки Цикл
				Если  Строка.СуммаДепозитаПоРегистру = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				НоваяСтрока = ТаблицаСписания.Добавить();
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);	
			КонецЦикла;  
			
			НовыеСуммыДепозита = ОбщегоНазначения.РаспределитьПропорционально(СтрокаДокумент.СуммаКонечныйОстаток, ТаблицаСписания.ВыгрузитьКолонку("СуммаДепозитаПоРегистру"), , Ложь);
			
			Для Каждого Строка ИЗ ТаблицаСписания Цикл
				
				НоваяСуммаДепозита = НовыеСуммыДепозита[ТаблицаСписания.Индекс(Строка)];
				
				НоваяСтрока = Объект.СписаниеДисконта.Добавить();
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);	
				НоваяСтрока.СуммаДисконта = Строка.СуммаДисконтаПоРегистру * (СтрокаДокумент.СуммаНачальныйОстаток - СтрокаДокумент.СуммаКонечныйОстаток) / СтрокаДокумент.СуммаНачальныйОстаток; 				
				НоваяСтрока.СуммаДепозита = Строка.СуммаДепозитаПоРегистру - НоваяСуммаДепозита;				
				Если НачалоМесяца(Строка.ДатаОкончанияДоговора) <= КонецМесяца(Объект.Дата)+1 Тогда
					НоваяСтрока.ТипСписания = Перечисления.ТипыСписанияДисконта.Плановое;			
				Иначе
					НоваяСтрока.ТипСписания = Перечисления.ТипыСписанияДисконта.Досрочное;			
				КонецЕсли; 

				// Если это не полное списание, то проанализируем не изменился ли срок и начислим проценты на оставшуюся часть депозита
				Если НоваяСуммаДепозита > 0 Тогда
					
					НовыйОстатокДисконта = Строка.СуммаДисконтаПоРегистру - НоваяСтрока.СуммаДисконта;
					
					// Анализируем - не изменился ли срок действия договора
					Если ЗначениеЗаполнено(Строка.ДатаОкончанияДоговора) И ЗначениеЗаполнено(СтрокаДокумент.ДатаОкончанияДоговораДляНачисления) И Строка.ДатаОкончанияДоговора <> СтрокаДокумент.ДатаОкончанияДоговораДляНачисления Тогда
						НоваяСтрокаСторно = Объект.НачислениеДисконта.Добавить();
						
						ЗаполнитьЗначенияСвойств(НоваяСтрокаСторно, Строка);	
						НоваяСтрокаСторно.СуммаДисконта = - НовыйОстатокДисконта;
						НоваяСтрокаСторно.СуммаДепозита = - НоваяСуммаДепозита;
						
						НачислитьДисконтИПроцентыЗаПервыйМесяц(СтрокаДокумент, НоваяСуммаДепозита, НачалоМесяца(Объект.Дата), СтрокаДокумент.ДатаОкончанияДоговораДляНачисления);
						
					// Если срок не изменлися - просто начисляем проценты на новый остаток
					ИначеЕсли  НовыйОстатокДисконта>0 Тогда

						Если Строка.ДатаОкончанияДоговора <= КонецМесяца(Объект.Дата) Тогда							
							СуммаПроцентов = НовыйОстатокДисконта;
						Иначе
							СтавкаМесяца = Строка.СтавкаДисконта / 12;						
							СуммаПроцентов = (НоваяСуммаДепозита - НовыйОстатокДисконта)* СтавкаМесяца / 100;												
						КонецЕсли; 						
						
						НоваяСтрока = Объект.СписаниеДисконта.Добавить();
						
						ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);	
						НоваяСтрока.СуммаДисконта = СуммаПроцентов;
						НоваяСтрока.СуммаДепозита = 0;
						НоваяСтрока.ТипСписания = Перечисления.ТипыСписанияДисконта.Плановое;
					КонецЕсли; 				
					
				КонецЕсли; 				
				
			КонецЦикла;	
			
		КонецЕсли; 
		
	КонецЦикла;   
	
КонецПроцедуры

&НаСервере
Процедура НачислитьПроцентыПланово(СтрокаДокумент)
	
	Для Каждого Строка Из СтрокаДокумент.Строки Цикл
		
		Если Строка.СуммаДисконтаПоРегистру = 0 Тогда
			Продолжить;
		ИначеЕсли Строка.ДатаОкончанияДоговора <= КонецМесяца(Объект.Дата) Тогда		
			СуммаПроцентов = Строка.СуммаДисконтаПоРегистру;
		Иначе
			СтавкаМесяца = Строка.СтавкаДисконта / 12;
			СуммаПроцентов = Мин((Строка.СуммаДепозитаПоРегистру - Строка.СуммаДисконтаПоРегистру)* СтавкаМесяца / 100, Строка.СуммаДисконтаПоРегистру);	
		КонецЕсли;
		
		НоваяСтрока = Объект.СписаниеДисконта.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);	
		НоваяСтрока.СуммаДисконта = СуммаПроцентов;
		НоваяСтрока.ТипСписания = Перечисления.ТипыСписанияДисконта.Плановое;			
		
	КонецЦикла;  

КонецПроцедуры 

&НаСервере
Процедура НачислитьДисконтИПроцентыЗаПервыйМесяц(СтрокаДокумент, Сумма, ДатаНачалаДоговора, ДатаОкончанияДоговора = Неопределено, СтавкаДисконта = Неопределено, ТолькоПроценты = Ложь)
	
	Если ДатаОкончанияДоговора = Неопределено Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
		                      |	ДополнительноеСоглашениеСрезПоследних.ДатаОкончанияДоговора
		                      |ИЗ
		                      |	Документ.ДополнительноеСоглашение КАК ДополнительноеСоглашениеСрезПоследних
		                      |ГДЕ
		                      |	ДополнительноеСоглашениеСрезПоследних.Ссылка В
		                      |			(ВЫБРАТЬ ПЕРВЫЕ 1
		                      |				ДополнительноеСоглашение.Ссылка КАК Ссылка
		                      |			ИЗ
		                      |				Документ.ДополнительноеСоглашение КАК ДополнительноеСоглашение
		                      |			ГДЕ
		                      |				ДополнительноеСоглашение.ДокументОснование = &ДокументОснование
		                      |				И ДополнительноеСоглашение.Проведен
		                      |			УПОРЯДОЧИТЬ ПО
		                      |				ДополнительноеСоглашение.МоментВремени УБЫВ)");
		
		Запрос.УстановитьПараметр("ДокументОснование", СтрокаДокумент.Документ);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ДатаОкончанияДоговора = Выборка.ДатаОкончанияДоговора;
		Иначе
			ДатаОкончанияДоговора  = СтрокаДокумент.ДатаОкончанияДоговора;
		КонецЕсли; 
	КонецЕсли; 
	
	Если КонецМесяца(ДатаОкончанияДоговора) <= КонецМесяца(ДатаНачалаДоговора) Тогда
		Возврат;
	КонецЕсли; 
	
	Если СтавкаДисконта = Неопределено Тогда
		СтавкаДисконта = ТекущаяСтавкаДисконта;
	КонецЕсли; 
	
	СтавкаПервогоМесяца = СтавкаДисконта/12  * (День(КонецМесяца(ДатаНачалаДоговора)) - День(ДатаНачалаДоговора) + 1) / День(КонецМесяца(ДатаНачалаДоговора));
	СтавкаПоследнегоМесяца = СтавкаДисконта/12 * (День(ДатаОкончанияДоговора) - День(НачалоМесяца(ДатаОкончанияДоговора)) + 1) / День(КонецМесяца(ДатаОкончанияДоговора));
	СтавкаПолногоМесяца = СтавкаДисконта/12;
	
	КоличествоПромежуточныхМесяцев = Год(ДатаОкончанияДоговора)*12 + Месяц(ДатаОкончанияДоговора) - Год(ДатаНачалаДоговора)*12 - Месяц(ДатаНачалаДоговора) - 1;
	
	КоэффициентДисконта = (1+СтавкаПервогоМесяца/100) * Pow(1+СтавкаПолногоМесяца/100, КоличествоПромежуточныхМесяцев) *  (1+СтавкаПоследнегоМесяца/100) ;
	
	СуммаДисконта = Окр(Сумма - Сумма/КоэффициентДисконта, 2);
	
	//
	Если НЕ ТолькоПроценты Тогда
		НоваяСтрока = Объект.НачислениеДисконта.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДокумент);	
		НоваяСтрока.ДатаОкончанияДоговора = ДатаОкончанияДоговора;
		НоваяСтрока.СтавкаДисконта = СтавкаДисконта;
		НоваяСтрока.СуммаДисконта = СуммаДисконта;
		НоваяСтрока.СуммаДепозита = Сумма;
	КонецЕсли; 
	
	//
	НоваяСтрока = Объект.СписаниеДисконта.Добавить();
	
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДокумент);	
	НоваяСтрока.ДатаОкончанияДоговора = ДатаОкончанияДоговора;	
	НоваяСтрока.СтавкаДисконта = СтавкаДисконта;
	НоваяСтрока.СуммаДисконта = (Сумма - СуммаДисконта) * СтавкаПервогоМесяца/100;
	НоваяСтрока.СуммаДепозита = 0;	
	НоваяСтрока.ТипСписания = Перечисления.ТипыСписанияДисконта.Плановое;
	
КонецПроцедуры 

&НаКлиенте
Процедура РасчитатьПроцентыПоРучнымНачислениям(Команда)
	РасчитатьПроцентыПоРучнымНачислениямНаСервере();
КонецПроцедуры

&НаСервере
Процедура РасчитатьПроцентыПоРучнымНачислениямНаСервере()
	
	СтрокиРучныхНачислений = Объект.НачислениеДисконта.НайтиСтроки(Новый Структура("РедактировалосьВручную", Истина));
	
	Для Каждого Строка Из СтрокиРучныхНачислений Цикл
		СтрокиКУдалению = 	Объект.СписаниеДисконта.НайтиСтроки(Новый Структура("Документ", Строка.Документ));
		
		Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
			Объект.СписаниеДисконта.Удалить(СтрокаКУдалению);
		КонецЦикла;  
		
		НачислитьДисконтИПроцентыЗаПервыйМесяц(Строка, Строка.СуммаДепозита, Макс(Строка.Документ.ДатаЗаключенияДоговора,НачалоМесяца(Объект.Дата)), , Строка.СтавкаДисконта, Истина)
	КонецЦикла;  
	
КонецПроцедуры



&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Объект.Дата = КонецМесяца(Объект.Дата );
	
КонецПроцедуры

&НаКлиенте
Процедура НачислениеДисконтаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ЗаполнитьЗначенияСвойств(КэшСтрокиНачисление, Элемент.ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура СписаниеДисконтаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ЗаполнитьЗначенияСвойств(КэшСтрокиСписание, Элемент.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура НачислениеДисконтаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТабличнаяЧастьПриОкончанииРедактирования(Элемент, НоваяСтрока, КэшСтрокиНачисление);
	
КонецПроцедуры

&НаКлиенте
Процедура СписаниеДисконтаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТабличнаяЧастьПриОкончанииРедактирования(Элемент, НоваяСтрока, КэшСтрокиСписание);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьПриОкончанииРедактирования(Элемент, НоваяСтрока, КэшСтроки)
	
	Если НоваяСтрока Тогда
		РучноеРедактирование = Истина;;
	Иначе
		НовыеДанные = ОбщегоНазначения.СкопироватьУниверсальнуюКоллекцию(КэшСтроки);		
		ЗаполнитьЗначенияСвойств(НовыеДанные, Элемент.ТекущиеДанные);
		
		РучноеРедактирование = НЕ ОбщегоНазначения.ДанныеСовпадают(НовыеДанные, КэшСтроки);
	КонецЕсли; 
	
	Если РучноеРедактирование Тогда
		СтрокиТЧ = Объект.НачислениеДисконта.НайтиСтроки(Новый Структура("Документ", Элемент.ТекущиеДанные.Документ));
		
		Для Каждого Строка ИЗ СтрокиТЧ Цикл
			Строка.РедактировалосьВручную = Истина;
		КонецЦикла;  
		
		СтрокиТЧ = Объект.СписаниеДисконта.НайтиСтроки(Новый Структура("Документ", Элемент.ТекущиеДанные.Документ));
		
		Для Каждого Строка ИЗ СтрокиТЧ Цикл
			Строка.РедактировалосьВручную = Истина;
		КонецЦикла;  
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере 
Функция ПолучитьДатуОкончанияДоговора(Документ)
	
	Если Документ = Неопределено Тогда
		Возврат Дата(1,1,1);
	КонецЕсли; 
	
	Возврат Документ.ДатаОкончанияДоговора;
	
КонецФункции

&НаКлиенте
Процедура НачислениеДисконтаДокументПриИзменении(Элемент)
	
	Элементы.НачислениеДисконта.ТекущиеДанные.ДатаОкончанияДоговора = ПолучитьДатуОкончанияДоговора(Элементы.НачислениеДисконта.ТекущиеДанные.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура СписаниеДисконтаДокументПриИзменении(Элемент)

	Элементы.СписаниеДисконта.ТекущиеДанные.ДатаОкончанияДоговора = ПолучитьДатуОкончанияДоговора(Элементы.СписаниеДисконта.ТекущиеДанные.Документ);	
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = НЕ УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.ДисконтированиеДепозитовПоАрендеНедвижимости, Ложь);
	
	Если Отказ Тогда
		Сообщить("Нет прав на использование документа!");
	КонецЕсли;	
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		Объект.Дата = КонецМесяца(ТекущаяДата());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КэшСтрокиНачисление = ПолучитьКэшСтроки("НачислениеДисконта");
	КэшСтрокиСписание = ПолучитьКэшСтроки("СписаниеДисконта");

КонецПроцедуры

&НаСервере
Функция ПолучитьКэшСтроки(ИмяТЧ)
	
	КэшСтроки = Новый Структура();
	
	Для Каждого Поле Из Элементы[ИмяТЧ].ПодчиненныеЭлементы Цикл
		КэшСтроки.Вставить(СтрЗаменить(Поле.ПутьКДанным, "Объект." + ИмяТЧ + ".", ""));
	КонецЦикла;  
	
	Возврат КэшСтроки;
	
КонецФункции 







