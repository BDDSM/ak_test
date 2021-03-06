﻿
Функция ПечатьСписокЗабораПродукции(МассивОбъектов, ОбъектыПечати)
Перем ТабДокумент, Запрос, Выборка;
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаданиеТехнологаМагазинам_СписокЗабораПродукции";
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаданиеТехнологаМагазинам.Ссылка КАК Ссылка,
		|	ВложенныйЗапрос.Магазин,
		|	СтруктурныеЕдиницы.Адрес,
		|	СтруктурныеЕдиницы.КоординатыШирота КАК Широта,
		|	СтруктурныеЕдиницы.КоординатыДолгота КАК Долгота,
		|	МаршрутыТорговыеТочки.Ссылка.Перевозчик КАК Перевозчик,
		|	МаршрутыТорговыеТочки.Ссылка КАК Маршрут,
		|	СтруктурныеЕдиницы.НомерТочки КАК НомерТочки
		|ИЗ
		|	Документ.ЗаданиеТехнологаМагазинам КАК ЗаданиеТехнологаМагазинам
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.ДокументОснование КАК ДокументОснование,
		|			МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.Магазин КАК Магазин,
		|			СУММА(МП_ЗадачаТехнологаПараметрыЗадачи.Количество) КАК Количество
		|		ИЗ
		|			Документ.МП_ЗадачаТехнолога.ПараметрыЗадачи КАК МП_ЗадачаТехнологаПараметрыЗадачи
		|		ГДЕ
		|			МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.Проведен
		|			И МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.ТипЗадания = ЗНАЧЕНИЕ(Перечисление.ТипыЗаданийТехнологаМагазинам.ВозвратНаСклад)
		|		
		|		СГРУППИРОВАТЬ ПО
		|			МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.ДокументОснование,
		|			МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.Магазин
		|		
		|		ИМЕЮЩИЕ
		|			СУММА(МП_ЗадачаТехнологаПараметрыЗадачи.Количество) > 0) КАК ВложенныйЗапрос
		|		ПО (ВложенныйЗапрос.ДокументОснование = ЗаданиеТехнологаМагазинам.Ссылка)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|		ПО (ВложенныйЗапрос.Магазин = СтруктурныеЕдиницы.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Маршруты.ТорговыеТочки КАК МаршрутыТорговыеТочки
		|		ПО (ВложенныйЗапрос.Магазин = МаршрутыТорговыеТочки.СтруктурнаяЕдиница)
		|ГДЕ
		|	ЗаданиеТехнологаМагазинам.Ссылка В(&МассивОбъектов)
		|	И НЕ МаршрутыТорговыеТочки.Ссылка.НеУчаствуетВТранспортнойСистеме
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерТочки
		|ИТОГИ ПО
		|	Ссылка,
		|	Перевозчик");
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Макет = Документы.ЗаданиеТехнологаМагазинам.ПолучитьМакет("СписокЗабораПродукции");
	
	ПервыйДокумент = Истина;
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		// Вывод шапки
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		//ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Выборка, "Список забора продукции");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.Номер = СокрЛП(Выборка.Ссылка.Номер);
		ОбластьМакета.Параметры.Дата = Формат(Выборка.Ссылка.Дата, "ДФ=dd.MM.yyyy");
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывод табличной части
		ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");		
		ТабДокумент.Вывести(ОбластьШапкаТаблицы);
		
		ОбластьПеревозчик = Макет.ПолучитьОбласть("Перевозчик");
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		
		ВыборкаПеревозчик = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПеревозчик.Следующий() Цикл
			
			ОбластьПеревозчик.Параметры.Заполнить(ВыборкаПеревозчик);
			ТабДокумент.Вывести(ОбластьПеревозчик);
			
			Ном 	= 0;
			ВыборкаСтрокТовары = ВыборкаПеревозчик.Выбрать();
			Пока ВыборкаСтрокТовары.Следующий() Цикл

				Ном = Ном + 1;
							
				ОбластьСтрока.Параметры.Заполнить(ВыборкаСтрокТовары);
				ОбластьСтрока.Параметры.НомерСтроки = Ном;
				ТабДокумент.Вывести(ОбластьСтрока);

			КонецЦикла;
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	ТабДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьСписокЗабораПродукцииСамовывоз(МассивОбъектов, ОбъектыПечати)
Перем ТабДокумент, Запрос, Выборка;
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаданиеТехнологаМагазинам_СписокЗабораПродукцииСамовывоз";
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаданиеТехнологаМагазинам.Ссылка КАК Ссылка,
		|	ВложенныйЗапрос.Магазин,
		|	СтруктурныеЕдиницы.Адрес,
		//|	СтруктурныеЕдиницы.КоординатыШирота КАК Широта,
		//|	СтруктурныеЕдиницы.КоординатыДолгота КАК Долгота,
		|	СтруктурныеЕдиницы.НомерТочки КАК НомерТочки,
		|	СтруктурныеЕдиницы.ТелефонныйНомер1,
		|	СтруктурныеЕдиницы.ТелефонныйНомер2
		|ИЗ
		|	Документ.ЗаданиеТехнологаМагазинам КАК ЗаданиеТехнологаМагазинам
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.ДокументОснование КАК ДокументОснование,
		|			МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.Магазин КАК Магазин,
		|			СУММА(МП_ЗадачаТехнологаПараметрыЗадачи.Количество) КАК Количество
		|		ИЗ
		|			Документ.МП_ЗадачаТехнолога.ПараметрыЗадачи КАК МП_ЗадачаТехнологаПараметрыЗадачи
		|		ГДЕ
		|			МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.Проведен
		|			И МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.ТипЗадания = ЗНАЧЕНИЕ(Перечисление.ТипыЗаданийТехнологаМагазинам.СамовывозСМагазинов)
		|		
		|		СГРУППИРОВАТЬ ПО
		|			МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.ДокументОснование,
		|			МП_ЗадачаТехнологаПараметрыЗадачи.Ссылка.Магазин
		|		
		|		ИМЕЮЩИЕ
		|			СУММА(МП_ЗадачаТехнологаПараметрыЗадачи.Количество) > 0) КАК ВложенныйЗапрос
		|		ПО (ВложенныйЗапрос.ДокументОснование = ЗаданиеТехнологаМагазинам.Ссылка)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|		ПО (ВложенныйЗапрос.Магазин = СтруктурныеЕдиницы.Ссылка)
		|ГДЕ
		|	ЗаданиеТехнологаМагазинам.Ссылка В(&МассивОбъектов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерТочки
		|ИТОГИ ПО
		|	Ссылка");
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Макет = Документы.ЗаданиеТехнологаМагазинам.ПолучитьМакет("СписокЗабораПродукцииСамовывоз");
	
	ПервыйДокумент = Истина;
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		// Вывод шапки
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		//ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Выборка, "Список забора продукции");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.Номер = СокрЛП(Выборка.Ссылка.Номер);
		ОбластьМакета.Параметры.Дата = Формат(Выборка.Ссылка.Дата, "ДФ=dd.MM.yyyy");
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывод табличной части
		ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");		
		ТабДокумент.Вывести(ОбластьШапкаТаблицы);
		
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		
		Ном 	= 0;
		ВыборкаМагазины = Выборка.Выбрать();
		Пока ВыборкаМагазины.Следующий() Цикл

			Ном = Ном + 1;
						
			ОбластьСтрока.Параметры.Заполнить(ВыборкаМагазины);
			ОбластьСтрока.Параметры.НомерСтроки = Ном;
			ТелефонныйНомер2 = СокрЛП(ВыборкаМагазины.ТелефонныйНомер2);
			ОбластьСтрока.Параметры.Телефон = СокрЛП(ВыборкаМагазины.ТелефонныйНомер1) + ?(ПустаяСтрока(ТелефонныйНомер2), "", ", " + ТелефонныйНомер2);
			ТабДокумент.Вывести(ОбластьСтрока);

		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	ТабДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабДокумент;
	
КонецФункции

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СписокЗабораПродукцииСамовывоз") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СписокЗабораПродукцииСамовывоз", "Список забора продукции (самовывоз)",
																ПечатьСписокЗабораПродукцииСамовывоз(МассивОбъектов, ОбъектыПечати));
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СписокЗабораПродукции") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СписокЗабораПродукции", "Список забора продукции",
																ПечатьСписокЗабораПродукции(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ПредставлениеНоменклатуры(СтруктураДанных) Экспорт
Перем ДатаПроизводстваНач, ДатаПроизводстваКон, ДатыПроизводстваСтр, БезДатПроизводства;
	
	ДатаПроизводстваНач = СтруктураДанных.ДатаПроизводстваНач;
	ДатаПроизводстваКон = СтруктураДанных.ДатаПроизводстваКон;
	
	ДатыПроизводстваДоп = "";
	БезДатПроизводства = СтруктураДанных.БезДатПроизводства;
	Если БезДатПроизводства Тогда
		ДатыПроизводстваДоп = "без дат производства";
	ИначеЕсли ТекущаяДата() > Дата(2017,2,1,10,0,0) И СтруктураДанных.ВсеПартии Тогда
		ДатыПроизводстваДоп = "все партии";
	ИначеЕсли ДатаПроизводстваНач = Дата(1,1,1) И ДатаПроизводстваКон = Дата(1,1,1) Тогда
		ДатыПроизводстваСтр = "все";
	ИначеЕсли ДатаПроизводстваНач = Дата(1,1,1) Тогда
		ДатыПроизводстваСтр = "все, по " + Формат(ДатаПроизводстваКон, "ДФ=dd.MM.yyyy");
	ИначеЕсли ДатаПроизводстваКон = Дата(1,1,1) Тогда
		ДатыПроизводстваСтр = "все, с " + Формат(ДатаПроизводстваНач, "ДФ=dd.MM.yyyy");
	ИначеЕсли ДатаПроизводстваНач = ДатаПроизводстваКон Тогда
		ДатыПроизводстваСтр = Формат(ДатаПроизводстваНач, "ДФ=dd.MM.yyyy");
	Иначе
		ДатыПроизводстваСтр = Формат(ДатаПроизводстваНач, "ДФ=dd.MM.yyyy") + "-" + Формат(ДатаПроизводстваКон, "ДФ=dd.MM.yyyy");
	КонецЕсли;
	
	Возврат Строка(СтруктураДанных.Номенклатура) + " (" + Строка(СтруктураДанных.Характеристика) + "), " +
		?(ЗначениеЗаполнено(ДатыПроизводстваДоп), ДатыПроизводстваДоп, "даты пр-ва: " + ДатыПроизводстваСтр);
	
КонецФункции

Функция ПолучитьКаталогХраненияФайлов(СсылкаИлиДата) Экспорт
Перем ДатаДок;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДатаДок = ?(ТипЗнч(СсылкаИлиДата) = Тип("Дата"), СсылкаИлиДата, СсылкаИлиДата.Дата);
	КаталогХраненияФайлов = СокрЛП(Константы.КаталогХраненияФайлов.Получить());
	КаталогХраненияФайлов = КаталогХраненияФайлов + ?(Прав(КаталогХраненияФайлов, 1) = "\", "", "\") + "Документ.ЗаданиеТехнологаМагазинам\" + Формат(ДатаДок, "ДФ=yyyyMM") + "\";
	
	ФайлКаталогХраненияФайлов = Новый Файл(КаталогХраненияФайлов);
	Если НЕ ФайлКаталогХраненияФайлов.Существует() Тогда
		СоздатьКаталог(КаталогХраненияФайлов);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат КаталогХраненияФайлов;
	
КонецФункции // ПолучитьКаталогХраненияФайлов()

Функция ВернутьТЗнОтветственных(ЗаданиеТехнологаМагазинамСсылка, Магазин = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	//+++АК SHEP 2018.08.28 ИП-00019388: добавил АдресЭлПочты
	//+++АК SHEP 2018.12.07 ИП-00020580: добавил признак "Помощник"
	//+++АК SHEP 2018.12.16 ИП-00020580: добавил определение помощника ТУ для магазина
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РолиПользователейСоставРоли.Сотрудник,
		|	""Управляющий управления качества"" КАК ТипРолиСтр,
		|	ЛОЖЬ КАК Помощник,
		|	ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(40)) КАК НомерТелефона,
		|	ВЫРАЗИТЬ(КонтактнаяИнформацияЭлПочта.Представление КАК СТРОКА(999)) КАК АдресЭлПочты,
		|	ЕСТЬNULL(РолиПользователейСоставРоли.Ссылка, ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка)) КАК РольПользователя
		|ИЗ
		|	Документ.ЗаданиеТехнологаМагазинам КАК ЗаданиеТехнологаМагазинам
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаданиеТехнологаМагазинам.Товары КАК ЗаданиеТехнологаМагазинамТовары
		|		ПО (ЗаданиеТехнологаМагазинамТовары.Ссылка = ЗаданиеТехнологаМагазинам.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|				,
		|				ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
		|					И Объект ССЫЛКА Справочник.ХарактеристикиНоменклатуры) КАК СоответствиеОбъектРольСрезПоследнихХ
		|		ПО (СоответствиеОбъектРольСрезПоследнихХ.Объект = ЗаданиеТехнологаМагазинамТовары.Характеристика)
		|			И (СоответствиеОбъектРольСрезПоследнихХ.РольПользователя <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО (ЗначенияСвойствОбъектов.Объект = ЗаданиеТехнологаМагазинамТовары.Характеристика)
		|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|				,
		|				ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
		|					И Объект ССЫЛКА Справочник.Контрагенты) КАК СоответствиеОбъектРольСрезПоследнихК
		|		ПО (СоответствиеОбъектРольСрезПоследнихХ.Объект ЕСТЬ NULL)
		|			И (ЗначенияСвойствОбъектов.Значение = СоответствиеОбъектРольСрезПоследнихК.Объект)
		|			И (СоответствиеОбъектРольСрезПоследнихК.РольПользователя <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|		ПО (ЕСТЬNULL(СоответствиеОбъектРольСрезПоследнихХ.РольПользователя, СоответствиеОбъектРольСрезПоследнихК.РольПользователя) <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|			И (РолиПользователейСоставРоли.Ссылка = ЕСТЬNULL(СоответствиеОбъектРольСрезПоследнихХ.РольПользователя.Родитель, СоответствиеОбъектРольСрезПоследнихК.РольПользователя.Родитель))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|		ПО (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСлужебный))
		|			И (РолиПользователейСоставРоли.Сотрудник = КонтактнаяИнформация.Объект)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформацияЭлПочта
		|		ПО (РолиПользователейСоставРоли.Сотрудник = КонтактнаяИнформацияЭлПочта.Объект)
		|			И (КонтактнаяИнформацияЭлПочта.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица))
		|ГДЕ
		|	ЗаданиеТехнологаМагазинам.Ссылка = &ЗаданиеТехнологаМагазинамСсылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РолиПользователейСоставРоли.Сотрудник,
		|	""Технолог по качеству"",
		|	ВЫБОР
		|		КОГДА РолиПользователейСоставРоли.Ссылка.Родитель = ЕСТЬNULL(СоответствиеОбъектРольСрезПоследнихХ.РольПользователя, СоответствиеОбъектРольСрезПоследнихК.РольПользователя)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ,
		|	ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(40)),
		|	ВЫРАЗИТЬ(КонтактнаяИнформацияЭлПочта.Представление КАК СТРОКА(999)),
		|	ЕСТЬNULL(РолиПользователейСоставРоли.Ссылка, ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|ИЗ
		|	Документ.ЗаданиеТехнологаМагазинам КАК ЗаданиеТехнологаМагазинам
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаданиеТехнологаМагазинам.Товары КАК ЗаданиеТехнологаМагазинамТовары
		|		ПО (ЗаданиеТехнологаМагазинамТовары.Ссылка = ЗаданиеТехнологаМагазинам.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|				,
		|				ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
		|					И Объект ССЫЛКА Справочник.ХарактеристикиНоменклатуры) КАК СоответствиеОбъектРольСрезПоследнихХ
		|		ПО (СоответствиеОбъектРольСрезПоследнихХ.Объект = ЗаданиеТехнологаМагазинамТовары.Характеристика)
		|			И (СоответствиеОбъектРольСрезПоследнихХ.РольПользователя <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО (ЗначенияСвойствОбъектов.Объект = ЗаданиеТехнологаМагазинамТовары.Характеристика)
		|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|				,
		|				ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
		|					И Объект ССЫЛКА Справочник.Контрагенты) КАК СоответствиеОбъектРольСрезПоследнихК
		|		ПО (СоответствиеОбъектРольСрезПоследнихХ.Объект ЕСТЬ NULL)
		|			И (ЗначенияСвойствОбъектов.Значение = СоответствиеОбъектРольСрезПоследнихК.Объект)
		|			И (СоответствиеОбъектРольСрезПоследнихК.РольПользователя <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|		ПО (ЕСТЬNULL(СоответствиеОбъектРольСрезПоследнихХ.РольПользователя, СоответствиеОбъектРольСрезПоследнихК.РольПользователя) <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|			И (РолиПользователейСоставРоли.Ссылка = ЕСТЬNULL(СоответствиеОбъектРольСрезПоследнихХ.РольПользователя, СоответствиеОбъектРольСрезПоследнихК.РольПользователя)
		|				ИЛИ РолиПользователейСоставРоли.Ссылка.Родитель = ЕСТЬNULL(СоответствиеОбъектРольСрезПоследнихХ.РольПользователя, СоответствиеОбъектРольСрезПоследнихК.РольПользователя))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|		ПО (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСлужебный))
		|			И (РолиПользователейСоставРоли.Сотрудник = КонтактнаяИнформация.Объект)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформацияЭлПочта
		|		ПО (РолиПользователейСоставРоли.Сотрудник = КонтактнаяИнформацияЭлПочта.Объект)
		|			И (КонтактнаяИнформацияЭлПочта.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица))
		|ГДЕ
		|	ЗаданиеТехнологаМагазинам.Ссылка = &ЗаданиеТехнологаМагазинамСсылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РолиПользователейСоставРоли.Сотрудник,
		|	""Товаровед"",
		|	ЛОЖЬ,
		|	ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(40)),
		|	ВЫРАЗИТЬ(КонтактнаяИнформацияЭлПочта.Представление КАК СТРОКА(999)),
		|	ЕСТЬNULL(РолиПользователейСоставРоли.Ссылка, ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|ИЗ
		|	Документ.ЗаданиеТехнологаМагазинам КАК ЗаданиеТехнологаМагазинам
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаданиеТехнологаМагазинам.Товары КАК ЗаданиеТехнологаМагазинамТовары
		|		ПО (ЗаданиеТехнологаМагазинамТовары.Ссылка = ЗаданиеТехнологаМагазинам.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|				,
		|				ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
		|					И Объект ССЫЛКА Справочник.ХарактеристикиНоменклатуры) КАК СоответствиеОбъектРольСрезПоследнихХ
		|		ПО (СоответствиеОбъектРольСрезПоследнихХ.Объект = ЗаданиеТехнологаМагазинамТовары.Характеристика)
		|			И (СоответствиеОбъектРольСрезПоследнихХ.РольПользователя <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО (ЗначенияСвойствОбъектов.Объект = ЗаданиеТехнологаМагазинамТовары.Характеристика)
		|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|				,
		|				ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
		|					И Объект ССЫЛКА Справочник.Контрагенты) КАК СоответствиеОбъектРольСрезПоследнихК
		|		ПО (СоответствиеОбъектРольСрезПоследнихХ.Объект ЕСТЬ NULL)
		|			И (ЗначенияСвойствОбъектов.Значение = СоответствиеОбъектРольСрезПоследнихК.Объект)
		|			И (СоответствиеОбъектРольСрезПоследнихК.РольПользователя <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|				,
		|				ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.БрендМенеджер)
		|					И Объект ССЫЛКА Справочник.РолиПользователей) КАК СоответствиеОбъектРольСрезПоследнихБМ
		|		ПО (ЕСТЬNULL(СоответствиеОбъектРольСрезПоследнихХ.РольПользователя, СоответствиеОбъектРольСрезПоследнихК.РольПользователя) <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|			И (СоответствиеОбъектРольСрезПоследнихБМ.Объект = ЕСТЬNULL(СоответствиеОбъектРольСрезПоследнихХ.РольПользователя, СоответствиеОбъектРольСрезПоследнихК.РольПользователя))
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|		ПО (РолиПользователейСоставРоли.Ссылка = СоответствиеОбъектРольСрезПоследнихБМ.РольПользователя)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|		ПО (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСлужебный))
		|			И (РолиПользователейСоставРоли.Сотрудник = КонтактнаяИнформация.Объект)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформацияЭлПочта
		|		ПО (РолиПользователейСоставРоли.Сотрудник = КонтактнаяИнформацияЭлПочта.Объект)
		|			И (КонтактнаяИнформацияЭлПочта.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица))
		|ГДЕ
		|	ЗаданиеТехнологаМагазинам.Ссылка = &ЗаданиеТехнологаМагазинамСсылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РолиПользователейСоставРоли.Сотрудник,
		|	""Помощник по рознице"",
		|	ЛОЖЬ,
		|	ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(40)),
		|	ВЫРАЗИТЬ(КонтактнаяИнформацияЭлПочта.Представление КАК СТРОКА(999)),
		|	ЕСТЬNULL(РолиПользователейСоставРоли.Ссылка, ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|ИЗ
		|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|			,
		|			ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего)
		|				И Объект ССЫЛКА Справочник.СтруктурныеЕдиницы
		|				И Объект = &Магазин) КАК СоответствиеОбъектРольСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|		ПО (РолиПользователейСоставРоли.Ссылка = СоответствиеОбъектРольСрезПоследних.РольПользователя)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|		ПО (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСлужебный))
		|			И (РолиПользователейСоставРоли.Сотрудник = КонтактнаяИнформация.Объект)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформацияЭлПочта
		|		ПО (РолиПользователейСоставРоли.Сотрудник = КонтактнаяИнформацияЭлПочта.Объект)
		|			И (КонтактнаяИнформацияЭлПочта.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица))
		|ГДЕ
		|	НЕ &Магазин = НЕОПРЕДЕЛЕНО
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаданиеТехнологаМагазинам.Автор.ФизЛицо,
		|	""Автор"",
		|	ЛОЖЬ,
		|	ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(40)),
		|	ВЫРАЗИТЬ(КонтактнаяИнформацияЭлПочта.Представление КАК СТРОКА(999)),
		|	ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка)
		|ИЗ
		|	Документ.ЗаданиеТехнологаМагазинам КАК ЗаданиеТехнологаМагазинам
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаданиеТехнологаМагазинам.Товары КАК ЗаданиеТехнологаМагазинамТовары
		|		ПО (ЗаданиеТехнологаМагазинамТовары.Ссылка = ЗаданиеТехнологаМагазинам.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|		ПО (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСлужебный))
		|			И ЗаданиеТехнологаМагазинам.Автор.ФизЛицо = КонтактнаяИнформация.Объект
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформацияЭлПочта
		|		ПО ЗаданиеТехнологаМагазинам.Автор.ФизЛицо = КонтактнаяИнформацияЭлПочта.Объект
		|			И (КонтактнаяИнформацияЭлПочта.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица))
		|ГДЕ
		|	ЗаданиеТехнологаМагазинам.Ссылка = &ЗаданиеТехнологаМагазинамСсылка");
	Запрос.УстановитьПараметр("ЗаданиеТехнологаМагазинамСсылка", ЗаданиеТехнологаМагазинамСсылка);
	Запрос.УстановитьПараметр("Магазин", Магазин);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ЗакрытьДокументыЗадачаТехнолога(Ссылка, ЗакрыватьЗадачи = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗадачаТехнолога.Ссылка,
		|	ЗадачаТехнолога.Закрыта КАК ЗадачаЗакрыта,
		|	ВЫБОР
		//+++АК ILIK 2018.08.08 ИП-00019413
		//|		КОГДА ЗадачаТехнолога.Магазин.СтатусТорговойТочки = ЗНАЧЕНИЕ(Перечисление.СтатусыТорговыхТочек.Закрыт)
		|		КОГДА ЗадачаТехнолога.Магазин.СтатусТорговойТочки В (ЗНАЧЕНИЕ(Перечисление.СтатусыТорговыхТочек.Закрыт), ЗНАЧЕНИЕ(Перечисление.СтатусыТорговыхТочек.Приостановлен))
		//---АК ILIK
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК МагазинЗакрыт
		|ИЗ
		|	Документ.МП_ЗадачаТехнолога КАК ЗадачаТехнолога
		|ГДЕ
		|	ЗадачаТехнолога.ДокументОснование = &Ссылка
		|	И НЕ ЗадачаТехнолога.Закрыта = &ЗакрыватьЗадачи
		|
		|ДЛЯ ИЗМЕНЕНИЯ");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ЗакрыватьЗадачи", ЗакрыватьЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда Возврат; КонецЕсли;
	
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл
		
		ЗадачаТехнологаОбъект = ВыборкаЗапроса.Ссылка.ПолучитьОбъект();
		
		Если ВыборкаЗапроса.МагазинЗакрыт Тогда
			Если НЕ ВыборкаЗапроса.ЗадачаЗакрыта Тогда 
				ЗадачаТехнологаОбъект.Закрыта = Истина;
				ЗадачаТехнологаОбъект.ФактическаяДатаВыполнения = ТекущаяДата();
			КонецЕсли;
		Иначе
			ЗадачаТехнологаОбъект.Закрыта = ЗакрыватьЗадачи;
		КонецЕсли;
		
		ЗадачаТехнологаОбъект.Записать();
		Сообщить("Закрыт документ " + ЗадачаТехнологаОбъект.Ссылка);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция ВозможноОткрытьЗадание(ДокументОснование) Экспорт
Перем ДокументОбъект;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВозвратТоваровПоставщику.Ссылка КАК ДокументСсылка
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
		|ГДЕ
		|	ВозвратТоваровПоставщику.ДокументОснование = &ДокументОснование
		|	И НЕ ВозвратТоваровПоставщику.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РасходныйОрдерСклад.Ссылка
		|ИЗ
		|	Документ.РасходныйОрдерСклад КАК РасходныйОрдерСклад
		|ГДЕ
		|	РасходныйОрдерСклад.Основание = &ДокументОснование
		|	И НЕ РасходныйОрдерСклад.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	РасходныйОрдерСклад.Ссылка");
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	УстановитьПривилегированныйРежим(Ложь);
	Если РезультатЗапроса.Пустой() Тогда Возврат Истина; КонецЕсли;
	
	Попытка

		НачатьТранзакцию();
		
		ВыборкаЗапроса = РезультатЗапроса.Выбрать();
		Пока ВыборкаЗапроса.Следующий() Цикл
			ДокументОбъект = ВыборкаЗапроса.ДокументСсылка.ПолучитьОбъект();
			ДокументОбъект.ПометкаУдаления = Истина;
			ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
	    ОтменитьТранзакцию();
		Возврат Ложь;
	КонецПопытки; 
	
	Возврат Истина;
	
КонецФункции

// АдресаЭП -- массив адресов эл. почты или строка с разделителем ";"
Процедура ОтправитьСообщение(Тема, ТекстСообщения, АдресаЭП, ИмяОтправителя = "", АдресЭПОтправителя = "no-reply@vkusvill.ru", ОтКого = "") Экспорт
	
	УчётнаяЗаписьЭП = МеханизмОбменаСообщениями.ПолучитьУчетнуюЗаписьПоАдресу(АдресЭПОтправителя);
	Если НЕ ЗначениеЗаполнено(УчётнаяЗаписьЭП) Тогда
		Возврат;
	ИначеЕсли НЕ ЗначениеЗаполнено(АдресаЭП) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(АдресаЭП) = Тип("Массив") Тогда
		МассивАдресовЭП = Новый Массив;
		// на случай, если эл. адрес составной
		Для Каждого СоставнойАдресЭП Из АдресаЭП Цикл
			МассАдресовЭП = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СоставнойАдресЭП, ";", Истина, Истина);
			Для Каждого АдресЭП Из МассАдресовЭП Цикл
				Если ЗначениеЗаполнено(АдресЭП) Тогда
					МассивАдресовЭП.Добавить(АдресЭП);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Иначе
		МассивАдресовЭП = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(АдресаЭП, ";", Истина, Истина);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьПовторяющиесяЭлементы(МассивАдресовЭП);
	
	КвоАдресов = МассивАдресовЭП.Количество();
	Если МассивАдресовЭП.Количество() = 0 Тогда Возврат; КонецЕсли;
	
	ТипТекстаСообщения = ?(Найти(ТекстСообщения, "<HTML>") > 0, ТипТекстаПочтовогоСообщения.HTML, ТипТекстаПочтовогоСообщения.ПростойТекст);
	
	КвоИтераций = Цел(КвоАдресов / 33) + 1;
	
	Почта = Новый ИнтернетПочта;
	Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчётнаяЗаписьЭП);
	Почта.Подключиться(Профиль);
	
	Для Ит = 1 По КвоИтераций Цикл
		
		Письмо = Новый ИнтернетПочтовоеСообщение;
		Письмо.Тема = Тема;
		Письмо.ИмяОтправителя = ИмяОтправителя;
		Письмо.Отправитель.Адрес = АдресЭПОтправителя;
		
		Если ЗначениеЗаполнено(ОтКого) Тогда
			ОбратныйАдрес = Письмо.ОбратныйАдрес.Добавить(СокрЛП(ОтКого));
			ОбратныйАдрес.ОтображаемоеИмя = ИмяОтправителя;
			ОбратныйАдрес.Кодировка = "UTF-8";
		КонецЕсли;
		
		СчМин = (Ит - 1) * 32 + 1;
		СчМакс = Мин(КвоАдресов, Ит * 32);
		Для Сч = СчМин По СчМакс Цикл
			Получатель = Письмо.Получатели.Добавить();
			Получатель.Адрес = МассивАдресовЭП[Сч - 1];
		КонецЦикла;
		
		ТекстПисьма = Письмо.Тексты.Добавить();
		ТекстПисьма.ТипТекста = ТипТекстаСообщения;
		ТекстПисьма.Текст = ТекстСообщения;
		
		Попытка
			Почта.Послать(Письмо);
		Исключение
			ТекстОшибки = "Ошибка при отправке почты: " + ОписаниеОшибки();
			ЗаписьЖурналаРегистрации("Документы.ЗаданиеТехнологаМагазинам.ОтправитьСообщение." + ИмяОтправителя, УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
			Сообщить(ТекстОшибки);
		КонецПопытки;
		
	КонецЦикла;
	
	Почта.Отключиться();
	
КонецПроцедуры
