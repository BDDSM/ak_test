﻿Функция ПечатьПутевогоЛиста(Ссылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПутевойЛистПоказания.Ссылка,
		|	ПутевойЛистПоказания.НомерСтроки,
		|	ПутевойЛистПоказания.Дата,
		|	ПутевойЛистПоказания.Начало,
		|	ПутевойЛистПоказания.Конец,
		|	ПутевойЛистПоказания.МаршрутОткуда,
		|	ПутевойЛистПоказания.МаршрутКуда,
		|	ПутевойЛистПоказания.КилометражМаршрута,
		|	ПутевойЛистПоказания.Ссылка.Номер КАК НомерДокумента,
		|	ПутевойЛистПоказания.Ссылка.ТранспортноеСредство.МаркаАвтомобиля КАК МаркаАвтомобиля,
		|	ФИОФизЛицСрезПоследних.Фамилия + "" "" + ФИОФизЛицСрезПоследних.Имя + "" "" + ФИОФизЛицСрезПоследних.Отчество КАК Водитель,
		|	ПутевойЛистПоказания.Ссылка.ТранспортноеСредство.ГосударственныйРегистрационныйНомер КАК ГосНомер,
		|	ПутевойЛистПоказания.Ссылка.НормаРасходаТоплива КАК НормаСписания,
		|	ПутевойЛистПоказания.Ссылка.ПоказаниеСпидометра
		|ИЗ
		|	Документ.ПутевойЛист.Показания КАК ПутевойЛистПоказания
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(&ДатаКон, ) КАК ФИОФизЛицСрезПоследних
		|		ПО ПутевойЛистПоказания.Ссылка.ФизЛицо = ФИОФизЛицСрезПоследних.ФизЛицо
		|ГДЕ
		|	ПутевойЛистПоказания.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка",  Ссылка);
    Запрос.УстановитьПараметр("ДатаКон", Ссылка.Дата);
	
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",  Ссылка);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МИНИМУМ(ПутевойЛистПоказания.Дата) КАК ДатаНачало,
		|	МАКСИМУМ(ПутевойЛистПоказания.Дата) КАК ДатаКонец
		|ИЗ
		|	Документ.ПутевойЛист.Показания КАК ПутевойЛистПоказания
		|ГДЕ
		|	ПутевойЛистПоказания.Ссылка = &Ссылка";

	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписиДаты = Результат.Выбрать();
	ВыборкаДетальныеЗаписиДаты.Следующий(); 

	
	
	ТабДокумент = Новый ТабличныйДокумент;

	ТабДокумент.ПолеСверху              = 0;
	ТабДокумент.ПолеСлева               = 5;
	ТабДокумент.ПолеСнизу               = 0;
	ТабДокумент.ПолеСправа              = 5;
	ТабДокумент.РазмерКолонтитулаСверху = 0;
	ТабДокумент.РазмерКолонтитулаСнизу  = 0;
	ТабДокумент.АвтоМасштаб             = Истина;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;
	
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПутевойЛист";
	
	Макет = Документы.ПутевойЛист.ПолучитьМакет("ПутевойЛист");
	
	ВыборкаДетальныеЗаписи.Следующий(); 
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");   
    ОбластьМакета.Параметры.Заполнить(ВыборкаДетальныеЗаписи); 
	ОбластьМакета.Параметры.Заполнить(ВыборкаДетальныеЗаписиДаты); 
	
	СведенияООрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(ВыборкаДетальныеЗаписи.Ссылка.Организация, ВыборкаДетальныеЗаписи.Ссылка.Дата); 
	ОбластьМакета.Параметры.Организация = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияООрганизации, "ПолноеНаименование, ФактическийАдрес, Телефоны"); 
	
	ТабДокумент.Вывести(ОбластьМакета);
		
	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");	
	ТабДокумент.Вывести(ОбластьМакетаШапка);
	
	ВыборкаДетальныеЗаписи.Сбросить(); 
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 	
		ОбластьМакетаСтрока = Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаСтрока.Параметры.Заполнить(ВыборкаДетальныеЗаписи); 
		ТабДокумент.Вывести(ОбластьМакетаСтрока);
	КонецЦикла;
	
	ВыборкаДетальныеЗаписи.Сбросить();
	ВыборкаДетальныеЗаписи.Следующий();
	
	ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаДетальныеЗаписи); 
	ОбластьМакетаПодвал.Параметры.ИтогоПройдено = ВыборкаДетальныеЗаписи.Ссылка.Показания.Итог("КилометражМаршрута");
	ТабДокумент.Вывести(ОбластьМакетаПодвал);
	
	Возврат ТабДокумент;
	
КонецФункции




Функция ПечатьОтчетПоЧекам(Ссылка) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;

	ТабДокумент.ПолеСверху              = 0;
	ТабДокумент.ПолеСлева               = 5;
	ТабДокумент.ПолеСнизу               = 0;
	ТабДокумент.ПолеСправа              = 5;
	ТабДокумент.РазмерКолонтитулаСверху = 0;
	ТабДокумент.РазмерКолонтитулаСнизу  = 0;
	ТабДокумент.АвтоМасштаб             = Истина;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;
	
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПутевойЛист";
	
	Макет = Документы.ПутевойЛист.ПолучитьМакет("ОтчетПоЧекам");
	
	Если Ссылка.ПредоставленныеЧеки.Количество() Тогда
		
		ОбластьМакетаШапкаПредоставленныеЧеки = Макет.ПолучитьОбласть("ШапкаПредоставленныеЧеки");
		ТабДокумент.Вывести(ОбластьМакетаШапкаПредоставленныеЧеки);
		
		Для каждого ТекСтрока Из Ссылка.ПредоставленныеЧеки Цикл
			
			ОбластьМакетаШапкаСтрокаПредоставленныеЧеки = Макет.ПолучитьОбласть("СтрокаПредоставленныеЧеки");
			ОбластьМакетаШапкаСтрокаПредоставленныеЧеки.Параметры.Заполнить(ТекСтрока); 
			ТабДокумент.Вывести(ОбластьМакетаШапкаСтрокаПредоставленныеЧеки);
			
		КонецЦикла;
		
		СтруктураИтог = Новый Структура;
		
		СтруктураИтог.Вставить("КоличествоГСМ", Ссылка.ПредоставленныеЧеки.Итог("КоличествоГСМ"));
		СтруктураИтог.Вставить("СуммаЧекаПоГСМ", Ссылка.ПредоставленныеЧеки.Итог("СуммаЧекаПоГСМ"));
		
		ОбластьМакетаИтогоПредоставленныеЧеки = Макет.ПолучитьОбласть("ИтогоПредоставленныеЧеки");
		ОбластьМакетаИтогоПредоставленныеЧеки.Параметры.Заполнить(СтруктураИтог); 
		ТабДокумент.Вывести(ОбластьМакетаИтогоПредоставленныеЧеки);
	
	КонецЕсли;
	
	ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал");
	//ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаДетальныеЗаписи); 
	ОбластьМакетаПодвал.Параметры.НормаСписания		    = Ссылка.НормаРасходаТоплива;
	ОбластьМакетаПодвал.Параметры.СуммаСписанияПоГСМВАО = Ссылка.СуммаСписанияПоГСМВАО;

	ТабДокумент.Вывести(ОбластьМакетаПодвал);
	
	Возврат ТабДокумент;
	
КонецФункции


