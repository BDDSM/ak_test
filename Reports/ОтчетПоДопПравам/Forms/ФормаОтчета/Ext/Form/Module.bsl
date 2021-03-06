﻿
&НаКлиенте
Процедура Сформировать(Команда)
	//Если Не ЗначениеЗаполнено(Право) Тогда
	//	Сообщить("Выберите право");
	//	Возврат;
	//КонецЕсли; 
	СформироватьСервер()	
КонецПроцедуры

Процедура СформироватьСервер()
	ТабДок.Очистить();
    УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗначенияДополнительныхПравПользователя.Пользователь КАК Пользователь,
		|	ЗначенияДополнительныхПравПользователя.Пользователь.Наименование КАК ПользовательНаименование,
		|	ЗначенияДополнительныхПравПользователя.Право,
		|	ЗначенияДополнительныхПравПользователя.Значение
		|ИЗ
		|	РегистрСведений.ЗначенияДополнительныхПравПользователя КАК ЗначенияДополнительныхПравПользователя
		//|ГДЕ
		//|	(ЗначенияДополнительныхПравПользователя.Право = &Право
		//|			ИЛИ &Право = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ПраваПользователей.ПустаяСсылка))
		//|	И (ЗначенияДополнительныхПравПользователя.Пользователь = &Пользователь
		//|			ИЛИ &Право = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПользовательНаименование
		|ИТОГИ ПО
		|	Пользователь";

	Запрос.УстановитьПараметр("Право", Право);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
    Мак=Отчеты.ОтчетПоДопПравам.ПолучитьМакет("Макет");
	Обл=Мак.ПолучитьОбласть("Шапка|Начало");
	Табдок.Вывести(Обл);
	Мас=Новый Массив;
	Если Не ЗначениеЗаполнено(Право) ИЛИ Право=ПланыВидовХарактеристик.ПраваПользователей.МожетРедактироватьАкцииНаТовары Тогда
		Мас.Добавить(ПланыВидовХарактеристик.ПраваПользователей.МожетРедактироватьАкцииНаТовары);
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(Право) ИЛИ Право=ПланыВидовХарактеристик.ПраваПользователей.РедактированиеРегистраЦеныПоставщиков Тогда
		Мас.Добавить(ПланыВидовХарактеристик.ПраваПользователей.РедактированиеРегистраЦеныПоставщиков);
	КонецЕсли; 	
	Если Не ЗначениеЗаполнено(Право) ИЛИ Право=ПланыВидовХарактеристик.ПраваПользователей.РедактированиеРегистраЦеныРеализации Тогда
		Мас.Добавить(ПланыВидовХарактеристик.ПраваПользователей.РедактированиеРегистраЦеныРеализации);
	КонецЕсли; 	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Выб=ВыборкаДетальныеЗаписи.Выбрать();
		Пока Выб.Следующий() Цикл
			Если Мас.Найти(Выб.Право)=Неопределено Тогда
				Если ЗначениеЗаполнено(Право) Тогда
					Если Право<>Выб.Право Тогда
						Продолжить;
					КонецЕсли; 
				КонецЕсли; 
				Мас.Добавить(Выб.Право);
			КонецЕсли; 	
		КонецЦикла; 
	КонецЦикла;
	Для каждого Эл Из Мас Цикл
		Обл=Мак.ПолучитьОбласть("Шапка|Конец");
		Обл.Параметры.Право=Эл;
		Табдок.Присоединить(Обл);
	КонецЦикла; 
	ВыборкаДетальныеЗаписи.Сбросить();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ЗначениеЗаполнено(Пользователь) Тогда
			Если Пользователь<>ВыборкаДетальныеЗаписи.Пользователь Тогда
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
	    Мак=Отчеты.ОтчетПоДопПравам.ПолучитьМакет("Макет");
		Обл=Мак.ПолучитьОбласть("Строка|Начало");
		Обл.Параметры.Пользователь=ВыборкаДетальныеЗаписи.Пользователь;
		Табдок.Вывести(Обл);
		Выб=ВыборкаДетальныеЗаписи.Выбрать();
		Для каждого Эл  Из Мас Цикл
			Обл=Мак.ПолучитьОбласть("Строка|Конец");
			Если Выб.НайтиСледующий(Новый Структура("Право",Эл)) Тогда
				Обл.Параметры.ЗначениеПрава=Выб.Значение;
			КонецЕсли; 
			Табдок.Присоединить(Обл);
		КонецЦикла;
	КонецЦикла;
	Табдок.ФиксацияСверху=1;
	Табдок.ФиксацияСлева=1;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Элементы.Право.СписокВыбора.Добавить(ПланыВидовХарактеристик.ПраваПользователей.МожетРедактироватьАкцииНаТовары);
	//Элементы.Право.СписокВыбора.Добавить(ПланыВидовХарактеристик.ПраваПользователей.РедактированиеРегистраЦеныПоставщиков);
	//Элементы.Право.СписокВыбора.Добавить(ПланыВидовХарактеристик.ПраваПользователей.РедактированиеРегистраЦеныРеализации);
КонецПроцедуры
