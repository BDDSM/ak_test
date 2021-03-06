﻿//+++АК KOPA 2018.05.14  ИП-00018638

//Необходимо создать оповещалку, по сверке:
//Сверка того, что мы отправили, с тем что принял магазин Пордерс(что отправили)/ Рекадв (что приняли) и что пришло по http.
//Если одна из трех цифр расходится, необходимо оповещать об этом ответственных лиц.
//Сверку производить каждый день в 17:00 за текущий день.
 
Функция СформироватьОтчет(Параметры)Экспорт 	
	Параметры.Вставить("Контрагент", Справочники.Контрагенты.НайтиПоКоду("000001121"));
	//+++АК KIRN 2018.09.24  
	Параметры.Вставить("ОрганизацияТилси", ОбщегоНазначенияПовтИсп.Тилси());
	//---АК KIRN 
	Параметры.Вставить("Партнер", Справочники.КонтурEDI_ДополнительныеСправочники.НайтиПоКоду("000000006"));
	
	Выборка = ПолучитьВыборкуСверки(Параметры);
	
	Если Выборка = Неопределено Тогда
		Возврат ТегН("Ошибка получения данных. Сообщите об этом разработчикам!", 3);	
	КонецЕсли;
	
	Выборка.Следующий();
	Выборка_Магазины = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если Выборка.Количество() = 0 Тогда	
	    Результат = Новый Структура("ХТМЛ", ТегН("Данных нет!", 3));
		Результат.Вставить("Заголовок", "Данных нет!");
	ИначеЕсли Параметры.ТолькоРасхождения и Не Выборка.ЕстьРасхождения Тогда
		Результат = Новый Структура("ХТМЛ", ТегН("Расхождений нет!", 3, ЦветЗеленый()));
		Результат.Вставить("Заголовок", "Расхождений нет!");
	Иначе 
		Результат = СформироватьТаблицуХТМЛ_ТабДок(Выборка_Магазины, Параметры);
		Результат.Вставить("ХТМЛ", ТегН("Есть расхождения!", 3, ЦветКрасный()) + Результат.ХТМЛ);
		
		Если Выборка.ЕстьРасхождения Тогда
			Результат.Вставить("Заголовок", "Есть расхождения!");
		Иначе 	
		    Результат.Вставить("Заголовок", "Расхождений нет!");
		КонецЕсли;
	КонецЕсли;
		
	Возврат Результат;
КонецФункции 

Функция ПолучитьВыборкуСверки(Параметры)
	ТаблицаОбменХ5 = ПолучитьТаблицуОбменХ5(Параметры.СтрокаПодключения, Параметры.НачПериода, Параметры.КонПериода);
	
	Если ТаблицаОбменХ5 = Неопределено Тогда
		Возврат Неопределено;	
	КонецЕсли;
	
	Запрос = Новый Запрос;	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	тз.Werk_id КАК Werk_id,
		|	тз.PLU КАК PLU,
		|	тз.QTY КАК QTY
		|ПОМЕСТИТЬ втХ5
		|ИЗ
		|	&тз КАК тз
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Werk_id,
		|	PLU,
		|	QTY
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КонтурEDI_СоответствияТоваров.Номенклатура,
		|	КонтурEDI_СоответствияТоваров.ХарактеристикаНоменклатуры,
		|	втХ5.Werk_id,
		|	втХ5.PLU,
		|	СУММА(втХ5.QTY) КАК QTY,
		|	СтруктурныеЕдиницы.Ссылка КАК Магазин
		|ПОМЕСТИТЬ втСоответствиеХ5
		|ИЗ
		|	РегистрСведений.КонтурEDI_СоответствияТоваров КАК КонтурEDI_СоответствияТоваров
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втХ5 КАК втХ5
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|			ПО (СтруктурныеЕдиницы.НомерСтороннейТочки = втХ5.Werk_id)
		|				И (НЕ СтруктурныеЕдиницы.ПометкаУдаления)
		|		ПО КонтурEDI_СоответствияТоваров.КодТовараПартнера = втХ5.PLU
		|			И (КонтурEDI_СоответствияТоваров.Партнер = &Партнер)
		//+++АК KIRN 2018.09.24 ИП-00019915
		|	И КонтурEDI_СоответствияТоваров.ОсновноеСоответствие = Истина
		//---АК KIRN 
		|
		|СГРУППИРОВАТЬ ПО
		|	КонтурEDI_СоответствияТоваров.Номенклатура,
		|	КонтурEDI_СоответствияТоваров.ХарактеристикаНоменклатуры,
		|	втХ5.Werk_id,
		|	СтруктурныеЕдиницы.Ссылка,
		|	втХ5.PLU
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РеализацияТоваровУслуг.Ссылка,
		|	РеализацияТоваровУслуг.EDI_ТочкаДоставки
		|ПОМЕСТИТЬ втРТУ
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|ГДЕ
		|	РеализацияТоваровУслуг.Дата МЕЖДУ &ДатаНач И &ДатаКон
		|	И РеализацияТоваровУслуг.Проведен
		|	И РеализацияТоваровУслуг.Организация = &ОрганизацияТилси
		//|	И РеализацияТоваровУслуг.Контрагент = &Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РеализацияТоваровУслугEDI_Товары.Номенклатура,
		|	РеализацияТоваровУслугEDI_Товары.Характеристика КАК Характеристика,
		|	РеализацияТоваровУслугEDI_Товары.КоличествоОтгружено КАК КоличествоОтгружено,
		|	втРТУ.EDI_ТочкаДоставки,
		|	РеализацияТоваровУслугEDI_Товары.НомерСтроки,
		|	втРТУ.Ссылка
		|ПОМЕСТИТЬ втОтправили
		|ИЗ
		|	втРТУ КАК втРТУ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.EDI_Товары КАК РеализацияТоваровУслугEDI_Товары
		|		ПО втРТУ.Ссылка = РеализацияТоваровУслугEDI_Товары.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КонтурEDI_Статистика.Номенклатура,
		|	КонтурEDI_Статистика.Характеристика КАК Характеристика,
		|	втОтправили.EDI_ТочкаДоставки КАК ТочкаДоставки,
		|	КонтурEDI_Статистика.Количество
		|ПОМЕСТИТЬ втКонтурEDI_Статистика
		|ИЗ
		|	РегистрСведений.КонтурEDI_Статистика КАК КонтурEDI_Статистика
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втОтправили КАК втОтправили
		|		ПО КонтурEDI_Статистика.Документ1С = втОтправили.Ссылка
		|			И КонтурEDI_Статистика.НомерСтрокиТоваров = втОтправили.НомерСтроки
		|			И (КонтурEDI_Статистика.ТипСообщения = ""RECADV"")
		|ГДЕ
		|	КонтурEDI_Статистика.ДатаЗаказа МЕЖДУ &ДатаНач И &ДатаКон
		|	И КонтурEDI_Статистика.Партнер = &Партнер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втОтправили.Номенклатура,
		|	втОтправили.Характеристика,
		|	втОтправили.EDI_ТочкаДоставки КАК Магазин,
		|	втОтправили.КоличествоОтгружено КАК КоличествоОтгружено,
		|	0 КАК КоличествоОбменХ5,
		|	0 КАК КоличествоЗаказано,
		|	""КоличествоОтгружено"" КАК ТипПоказателя
		|ПОМЕСТИТЬ втИтог
		|ИЗ
		|	втОтправили КАК втОтправили
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	втСоответствиеХ5.Номенклатура,
		|	втСоответствиеХ5.ХарактеристикаНоменклатуры,
		|	втСоответствиеХ5.Магазин,
		|	0,
		|	втСоответствиеХ5.QTY,
		|	0,
		|	""ОбменХ5""
		|ИЗ
		|	втСоответствиеХ5 КАК втСоответствиеХ5
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	втКонтурEDI_Статистика.Номенклатура,
		|	втКонтурEDI_Статистика.Характеристика,
		|	втКонтурEDI_Статистика.ТочкаДоставки,
		|	0,
		|	0,
		|	втКонтурEDI_Статистика.Количество,
		|	""Заказ""
		|ИЗ
		|	втКонтурEDI_Статистика КАК втКонтурEDI_Статистика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втИтог.Номенклатура КАК Номенклатура,
		|	втИтог.Характеристика КАК Характеристика,
		|	втИтог.Магазин КАК Магазин,
		|	ЕСТЬNULL(КонтурEDI_СоответствияТоваров.КодТовараПартнера, ""Нет"") КАК PLU,
		|	СУММА(втИтог.КоличествоОтгружено) КАК КоличествоОтгружено,
		|	СУММА(втИтог.КоличествоОбменХ5) КАК КоличествоОбменХ5,
		|	СУММА(втИтог.КоличествоЗаказано) КАК КоличествоЗаказано
		|ПОМЕСТИТЬ втСгруппировано
		|ИЗ
		|	втИтог КАК втИтог
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтурEDI_СоответствияТоваров КАК КонтурEDI_СоответствияТоваров
		|		ПО втИтог.Номенклатура = КонтурEDI_СоответствияТоваров.Номенклатура
		|			И втИтог.Характеристика = КонтурEDI_СоответствияТоваров.ХарактеристикаНоменклатуры
		|			И (КонтурEDI_СоответствияТоваров.Партнер = &Партнер)
		//+++АК KIRN 2018.09.24  ИП-00019915
		|			И (КонтурEDI_СоответствияТоваров.ОсновноеСоответствие = Истина)
		//---АК KIRN 
		|
		|СГРУППИРОВАТЬ ПО
		|	втИтог.Номенклатура,
		|	втИтог.Характеристика,
		|	втИтог.Магазин,
		|	ЕСТЬNULL(КонтурEDI_СоответствияТоваров.КодТовараПартнера, ""Нет"")
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втСгруппировано.PLU,
		|	втСгруппировано.КоличествоОтгружено,
		|	втСгруппировано.КоличествоОбменХ5,
		|	ВЫБОР
		|		КОГДА тНоменклатура.Весовой
		|			ТОГДА втСгруппировано.КоличествоОтгружено - 1.1 * втСгруппировано.КоличествоОбменХ5 > 0
		//|					ИЛИ втСгруппировано.КоличествоОтгружено - 1.1 * втСгруппировано.КоличествоЗаказано > 0
		|					ИЛИ втСгруппировано.КоличествоОбменХ5 - 1.1 * втСгруппировано.КоличествоОтгружено > 0
		//|					ИЛИ втСгруппировано.КоличествоОбменХ5 - 1.1 * втСгруппировано.КоличествоЗаказано > 0
		//|					ИЛИ втСгруппировано.КоличествоЗаказано - 1.1 * втСгруппировано.КоличествоОтгружено > 0
		//|					ИЛИ втСгруппировано.КоличествоЗаказано - 1.1 * втСгруппировано.КоличествоОбменХ5 > 0
		|		ИНАЧЕ втСгруппировано.КоличествоОтгружено - втСгруппировано.КоличествоОбменХ5 <> 0
		//|				ИЛИ втСгруппировано.КоличествоОтгружено - втСгруппировано.КоличествоЗаказано <> 0
		//|				ИЛИ втСгруппировано.КоличествоОбменХ5 - втСгруппировано.КоличествоЗаказано <> 0
		|	КОНЕЦ КАК ЕстьРасхождения,
		|	тНоменклатура.Наименование КАК Номенклатура,
		|	ЕСТЬNULL(СтруктурныеЕдиницы.Наименование, ""Нет"") КАК Магазин,
		|	ХарактеристикиНоменклатуры.Наименование КАК Характеристика,
		|	ЕСТЬNULL(СтруктурныеЕдиницы.НомерСтороннейТочки, 0) КАК Werk_id,
		//|	втСгруппировано.КоличествоЗаказано,
		|	втСгруппировано.КоличествоОтгружено - втСгруппировано.КоличествоОбменХ5 КАК ОтношениеФактКПрисланому
		//|,втСгруппировано.КоличествоОтгружено - втСгруппировано.КоличествоЗаказано КАК ОтношениеФактКЗаказаному
		|ИЗ
		|	втСгруппировано КАК втСгруппировано
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|		ПО втСгруппировано.Магазин = СтруктурныеЕдиницы.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК тНоменклатура
		|		ПО втСгруппировано.Номенклатура = тНоменклатура.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|		ПО втСгруппировано.Характеристика = ХарактеристикиНоменклатуры.Ссылка
		|ИТОГИ
		|	МАКСИМУМ(ЕстьРасхождения),
		|	МАКСИМУМ(Магазин)
		|ПО
		|	ОБЩИЕ,
		|	Werk_id";
	
	Запрос.УстановитьПараметр("ДатаКон", Параметры.КонПериода);
	Запрос.УстановитьПараметр("ДатаНач", Параметры.НачПериода);
	//Запрос.УстановитьПараметр("Контрагент", Параметры.Контрагент);
	Запрос.УстановитьПараметр("ОрганизацияТилси", Параметры.ОрганизацияТилси);
	Запрос.УстановитьПараметр("Партнер", Параметры.Партнер);
	Запрос.УстановитьПараметр("тз", ТаблицаОбменХ5);
	
	Если ЗначениеЗаполнено(ОтборТочкаДоставки) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПО втСгруппировано.Характеристика = ХарактеристикиНоменклатуры.Ссылка", 
			"		ПО втСгруппировано.Характеристика = ХарактеристикиНоменклатуры.Ссылка
			|ГДЕ
			|	втСгруппировано.Магазин = &Магазин");
		Запрос.УстановитьПараметр("Магазин", ОтборТочкаДоставки);		
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
КонецФункции

Функция ПолучитьТаблицуОбменХ5(СтрокаПодключения, НачПериода, КонПериода)
	Попытка
		Соединитель = Новый COMObject("V83.COMConnector");
		Соединитель = Соединитель.Connect(СтрокаПодключения);
			
		Запрос = Соединитель.NewObject("Запрос");
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЭлементыПакета_Остатки.WerkId КАК Werk_id,
		|	ЭлементыПакета_Остатки.PLU КАК PLU,
		|	СУММА(ЭлементыПакета_Остатки.QTY) КАК QTY
		|ИЗ
		|	РегистрСведений.ЭлементыПакета_Остатки КАК ЭлементыПакета_Остатки
		|ГДЕ
		|	ЭлементыПакета_Остатки.DocCreateDate МЕЖДУ &ДатаНач И &ДатаКон
		|	И ЭлементыПакета_Остатки.DocType = 1502
		|
		|СГРУППИРОВАТЬ ПО
		|	ЭлементыПакета_Остатки.WerkId,
		|	ЭлементыПакета_Остатки.PLU";
		
		Запрос.УстановитьПараметр("ДатаНач", НачПериода);
		Запрос.УстановитьПараметр("ДатаКон", КонПериода);
		
		Результат = Запрос.Выполнить();
		
		Таблица = Результат.Выгрузить();
		
		оп = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(0, 0, ДопустимыйЗнак.Любой));
			 
		ТаблицаРезультат = Новый ТаблицаЗначений;
		//+++АК KIRN 2018.09.20 ИП-00019915.000.00000002 
		//ТаблицаРезультат.Колонки.Добавить("Werk_id", оп);
		ТаблицаРезультат.Колонки.Добавить("Werk_id", Новый ОписаниеТипов("Строка", ,
												 Новый КвалификаторыСтроки(5, ДопустимаяДлина.Переменная)));
		//---АК KIRN 
		ТаблицаРезультат.Колонки.Добавить("QTY", оп);											 
		ТаблицаРезультат.Колонки.Добавить("PLU", Новый ОписаниеТипов("Строка", ,
												 Новый КвалификаторыСтроки(16, ДопустимаяДлина.Переменная)));
													 
		Для каждого Строка Из Таблица Цикл
			НоваяСтрока = ТаблицаРезультат.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			//+++АК KIRN 2018.09.20  ИП-00019915.000.00000002
			НоваяСтрока.Werk_id = Формат(Строка.Werk_id, "ЧГ=");
			//---АК KIRN 
			НоваяСтрока.PLU = Формат(Строка.PLU, "ЧГ=");
		КонецЦикла;
		
		Соединитель = Неопределено;
		
		Возврат ТаблицаРезультат;
	Исключение
		Соединитель = Неопределено;
		
		Сообщить("Не удалось подключиться: " + ОписаниеОшибки());	
		
		Возврат Неопределено;
	КонецПопытки;
КонецФункции 

#Область HTML


Функция СформироватьТаблицуХТМЛ_ТабДок(Выборка_Магазины, Параметры)
	ОписаниеКолонок = Новый Структура;
	ОписаниеКолонок.Вставить("Номенклатура", "Номенклатура");
	ОписаниеКолонок.Вставить("Характеристика", "Характеристика");
	ОписаниеКолонок.Вставить("PLU", "PLU");
	ОписаниеКолонок.Вставить("КоличествоОтгружено", "Отгружено");
	ОписаниеКолонок.Вставить("КоличествоОбменХ5", "Присланное(http)");
	//ОписаниеКолонок.Вставить("КоличествоЗаказано", "Заказ(EDI)");
	ОписаниеКолонок.Вставить("ОтношениеФактКПрисланому", "Отклонение факт/присланное");
	//ОписаниеКолонок.Вставить("ОтношениеФактКЗаказаному","Отклонение факт/подписанное");
	
	ЗаголовокКолонок = Новый Массив;
	
	Для каждого КлючЗначение Из ОписаниеКолонок Цикл
		Цвет = Неопределено;
		Ячейка = ТегЯчейкаЗаголокаТаблицы(КлючЗначение.Значение);			
		ЗаголовокКолонок.Добавить(Ячейка);		
	КонецЦикла;
	
	ЗаголовокКолонок = ТелеграмТехБот.МассивВСтроку(ЗаголовокКолонок, Символы.ПС);
	
	МассивHTML = Новый Массив;
	
	Пока Выборка_Магазины.Следующий() Цикл
		Если Параметры.ТолькоРасхождения и Не Выборка_Магазины.ЕстьРасхождения Тогда
			Продолжить;	
		КонецЕсли;
		
		ЗаголовокТаблицы = ТегН(Выборка_Магазины.Магазин + ": " + Формат(Выборка_Магазины.Werk_id, "ЧГ="), 3);
		
		Выборка_Номенклатура = Выборка_Магазины.Выбрать();
		
		МассивСтрок = Новый Массив;
		
		МассивСтрок.Добавить(ЗаголовокКолонок);
		
		Пока Выборка_Номенклатура.Следующий() Цикл
			Если Параметры.ТолькоРасхождения и Не Выборка_Номенклатура.ЕстьРасхождения Тогда
				Продолжить;	
			КонецЕсли;
		
			МассивЯчеек = Новый Массив;
						
			Для каждого КлючЗначение Из ОписаниеКолонок Цикл
				Цвет = Неопределено;
				Ячейка = ТегЯчейкаТаблицы(Выборка_Номенклатура[КлючЗначение.Ключ], Цвет);			
				МассивЯчеек.Добавить(Ячейка);		
			КонецЦикла;			
			
			
			Если Выборка_Номенклатура.ЕстьРасхождения Тогда
				Цвет = ЦветРозовый();		
			КонецЕсли;
			
			МассивСтрок.Добавить(ТегСтрокаТаблицы(ТелеграмТехБот.МассивВСтроку(МассивЯчеек, ""), Цвет));		
		КонецЦикла;
		
		МассивHTML.Добавить(ЗаголовокТаблицы);
		МассивHTML.Добавить(ТегТаблица(ТелеграмТехБот.МассивВСтроку(МассивСтрок, Символы.ПС)));		
	КонецЦикла;
	
	ХТМЛ = ТелеграмТехБот.МассивВСтроку(МассивHTML, Символы.ПС);
	
	Результат = Новый Структура;
	Результат.Вставить("ХТМЛ", ХТМЛ);
	
	Возврат Результат;
КонецФункции

Функция ТегТаблица(Текст)
	Возврат "<table border=""1"">" + Текст + "</table>";
КонецФункции

Функция ТегСтрокаТаблицы(Текст, Цвет = Неопределено)
	Возврат "<tr" + ?(Цвет = Неопределено, "", " bgcolor=""" + Цвет + """") + ">" + Текст + "</tr>";
КонецФункции

Функция ТегЯчейкаТаблицы(Текст, Цвет = Неопределено)
	Возврат "<td" + ?(Цвет = Неопределено, "", " bgcolor=""" + Цвет + """") + ">" + ?(ЗначениеЗаполнено(Текст), Текст, "-") + "</td>";
КонецФункции

Функция ТегЯчейкаЗаголокаТаблицы(Текст, Цвет = Неопределено)
	Возврат "<th" + ?(Цвет = Неопределено, "", " bgcolor=""" + Цвет + """") + ">" + ?(ЗначениеЗаполнено(Текст), Текст, "-") + "</th>";
КонецФункции

Функция ТегН(Текст, Размер, Цвет = Неопределено)
	Возврат "<H" + Размер + ?(Цвет = Неопределено, "", " style=""color:" + Цвет + ";""") + ">" + Текст + "</H" + Размер + ">";
КонецФункции

Функция ТегBody(Текст)
	Возврат "<Body>" + Текст + "</Body>";
КонецФункции

Функция ЦветЗаголовкаОтчета()
	Возврат "#F4ECC5";	
КонецФункции

Функция ЦветЗеленый()
	Возврат "#008000";	
КонецФункции

Функция ЦветКрасный()
	Возврат "#FF0000";	
КонецФункции

Функция ЦветРозовый()
	Возврат "#FFC0CB";	
КонецФункции


#КонецОбласти