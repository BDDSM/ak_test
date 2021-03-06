﻿
Процедура СформироватьНаСервере(Объект) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МП_ЗадачаМагазина.Магазин,
		|	МП_ЗадачаМагазина.БаллыПоЗаданию КАК БаллыПоЗаданию,
		|	МП_ЗадачаМагазина.Ссылка
		|ПОМЕСТИТЬ вт
		|ИЗ
		|	Документ.МП_ЗадачаМагазина КАК МП_ЗадачаМагазина
		|ГДЕ
		|	МП_ЗадачаМагазина.Дата МЕЖДУ &Дата1 И &Дата2
		|	И МП_ЗадачаМагазина.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	вт.Магазин,
		|	СУММА(вт.БаллыПоЗаданию) КАК БаллыПоЗаданию,
		|	вт.Ссылка
		|ИЗ
		|	вт КАК вт
		|ГДЕ
		|	вт.БаллыПоЗаданию <> 0
		|
		|СГРУППИРОВАТЬ ПО
		|	вт.Магазин,
		|	вт.Ссылка";
		
	Запрос.УстановитьПараметр("Дата1",НачалоДня(Объект.ДатаВыполнения));
	Запрос.УстановитьПараметр("Дата2",КонецДня(Объект.ДатаВыполнения));
	
	ТЗРезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	
	Для Каждого Элемент Из Объект.СписокМагазинов Цикл
		Если Элемент.Пометка Тогда
			СформироватьЗапись(Объект, Элемент.Значение, ТЗРезультатЗапроса);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // СформироватьНаСервере()

Процедура СформироватьЗапись(Объект, Магазин,ТЗРезультатЗапроса)
	Если ТЗРезультатЗапроса.Количество()=0 Тогда
	   Возврат;
	КонецЕсли; 	
	Строки=ТЗРезультатЗапроса.НайтиСтроки(Новый Структура("Магазин",Магазин));
	Если Строки.Количество()=0 Тогда
	   Возврат;
	КонецЕсли; 	
	
	//
	НЗ = РегистрыСведений.ПроцентыТайногоПокупателя.СоздатьНаборЗаписей();
	НЗ.Отбор.Период.Установить(НачалоДня(Объект.ДатаВыполнения));
	НЗ.Отбор.СтруктурнаяЕдиница.Установить(Магазин);
	НЗ.Отбор.ДатаПроверки.Установить(НачалоДня(Объект.ДатаВыполнения));
	НЗ.Отбор.ТипАнкет.Установить("Выкладка");
	//ТЗПродавец=ПолучитьПродавцовНаСервере(Магазин, Объект.ДатаВыполнения);
	НЗ.Прочитать();
	НЗ.Очистить();
	НЗ.Записать();
	
	//
	НЗ = РегистрыСведений.ПроцентыТайногоПокупателя.СоздатьНаборЗаписей();
	НЗ.Отбор.Период.Установить(НачалоДня(Объект.ДатаВыполнения));
	НЗ.Отбор.СтруктурнаяЕдиница.Установить(Магазин);
	НЗ.Отбор.ДатаПроверки.Установить(НачалоДня(Объект.ДатаВыполнения));
	НЗ.Отбор.ТипАнкет.Установить("Фотоотчет");
	ТЗПродавец=ПолучитьПродавцовНаСервере(Магазин, Объект.ДатаВыполнения);
	НЗ.Прочитать();
	НЗ.Очистить();
	НЗ.Записать();
	
	//
	Для каждого стр Из ТЗПродавец Цикл
		Запись				=НЗ.Добавить();
		Запись.Процент		=Строки[0].БаллыПоЗаданию;
		Запись.ДатаПроверки	=НачалоДня(Объект.ДатаВыполнения);
		Запись.Продавец		=стр.Продавец;
		Запись.СтруктурнаяЕдиница = Магазин;
		Запись.ТипАнкет 	= "Фотоотчет";
		Запись.Период		= НачалоДня(Объект.ДатаВыполнения);
		Запись.Задача       = Строки[0].Ссылка;
		Запись.Ответственный= Строки[0].Ссылка.Проверяющий;
	КонецЦикла; 
	НЗ.Записать();

	
	//Сообщить("Создана задача " + Задача);
	
КонецПроцедуры // СформироватьЗадачу()

Функция ПолучитьПродавцовНаСервере(СтруктурнаяЕдиница, ДатаПроверки)
	ТЗ_Результат=Новый ТаблицаЗначений;
	Если ЗначениеЗаполнено(СтруктурнаяЕдиница) И ЗначениеЗаполнено(ДатаПроверки) Тогда
		
		//+++ АК gusd (ИП-00014167)
		// Ночных продавцов необходимо брать из ЛУ предыдущего дня.
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛистУчетаПродавцы.Продавец
		|ИЗ
		|	Документ.ЛистУчета.Продавцы КАК ЛистУчетаПродавцы
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(ЛистУчетаПродавцы.Ссылка.Дата, ДЕНЬ) = &Дата
		|	И ЛистУчетаПродавцы.Ссылка.ТорговаяТочка = &ТорговаяТочка
		|	И НЕ ЛистУчетаПродавцы.Пч В (5, 6)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЛистУчетаПродавцы.Продавец
		|ИЗ
		|	Документ.ЛистУчета.Продавцы КАК ЛистУчетаПродавцы
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(ЛистУчетаПродавцы.Ссылка.Дата, ДЕНЬ) = ДОБАВИТЬКДАТЕ(&Дата, ДЕНЬ, -1)
		|	И ЛистУчетаПродавцы.Ссылка.ТорговаяТочка = &ТорговаяТочка
		|	И ЛистУчетаПродавцы.Пч В (5, 6)";
		
		Запрос.УстановитьПараметр("Дата", НачалоДня(ДатаПроверки));
		Запрос.УстановитьПараметр("ТорговаяТочка", СтруктурнаяЕдиница);
		
		ТЗ_Результат = Запрос.Выполнить().Выгрузить();
		
		Если ТЗ_Результат.Количество() = 0 Тогда
			ЗапросПоТабелю = Новый Запрос;
			ЗапросПоТабелю.Текст = 
				"ВЫБРАТЬ
				|	ТабельРаботыПродавцов.Сотрудник КАК Продавец
				|ИЗ
				|	РегистрСведений.ТабельРаботыПродавцов КАК ТабельРаботыПродавцов
				|ГДЕ
				|	ТабельРаботыПродавцов.ТорговаяТочка = &ТорговаяТочка
				|	И НАЧАЛОПЕРИОДА(ТабельРаботыПродавцов.Период, ДЕНЬ) = &Дата
				|	И НЕ ТабельРаботыПродавцов.СвойствоПродавца В (5, 6)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ
				|	ТабельРаботыПродавцов.Сотрудник
				|ИЗ
				|	РегистрСведений.ТабельРаботыПродавцов КАК ТабельРаботыПродавцов
				|ГДЕ
				|	ТабельРаботыПродавцов.ТорговаяТочка = &ТорговаяТочка
				|	И НАЧАЛОПЕРИОДА(ТабельРаботыПродавцов.Период, ДЕНЬ) = ДОБАВИТЬКДАТЕ(&Дата, ДЕНЬ, -1)
				|	И ТабельРаботыПродавцов.СвойствоПродавца В (5, 6)";
		
			ЗапросПоТабелю.УстановитьПараметр("Дата", НачалоДня(ДатаПроверки));
			ЗапросПоТабелю.УстановитьПараметр("ТорговаяТочка", СтруктурнаяЕдиница);

	        ТЗ_Результат = ЗапросПоТабелю.Выполнить().Выгрузить();
		КонецЕсли; 
	КонецЕсли;	
	Возврат ТЗ_Результат
КонецФункции	

Процедура ЗаполнитьСписокМагазинов(Объект) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МобильноеПриложение.Магазин КАК Магазин
	|ИЗ
	|	ПланОбмена.МобильноеПриложение КАК МобильноеПриложение
	|ГДЕ
	|	МобильноеПриложение.Магазин <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Магазин
	|АВТОУПОРЯДОЧИВАНИЕ";
	Выборка = Запрос.Выполнить().Выбрать();
	Объект.СписокМагазинов.Очистить();
	Пока Выборка.Следующий() Цикл
		
		Элемент = Объект.СписокМагазинов.Добавить();
		Элемент.Значение = Выборка.Магазин;
		Элемент.Пометка = Истина;
		
	КонецЦикла;

КонецПроцедуры // ЗаполнитьСписокМагазинов()




