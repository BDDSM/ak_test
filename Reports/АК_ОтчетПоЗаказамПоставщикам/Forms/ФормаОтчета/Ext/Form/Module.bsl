﻿
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(НаименованиеТекущегоВарианта) Тогда
		Сообщить("Не выбран вариант отчёта. Формирование невозможно");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИмяВариантаИзПараметра = "";
	ЗначПарКД = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ИмяВарианта");
	Если ЗначПарКД <> Неопределено Тогда
		ИмяВариантаИзПараметра = ЗначПарКД.Значение;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИмяВариантаИзПараметра)
			ИЛИ ИмяВариантаИзПараметра <> "ПоПериодуПоступлений"
				И ИмяВариантаИзПараметра <> "ПоПериодуОжиданияПоступлений" Тогда
		Сообщить("Данный вариант отчёта недоступен. Формирование невозможно");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.ДатаНач)
			ИЛИ НЕ ЗначениеЗаполнено(Отчет.ДатаКон)
			ИЛИ Отчет.ДатаНач > Отчет.ДатаКон Тогда
		Сообщить("Не заполнен или некорректно заполнен период!");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	//
	ОтборКД = Отчет.КомпоновщикНастроек.ФиксированныеНастройки.Отбор;
	ЛевоеПолеОтбораКД = Неопределено;
	Если ИмяВариантаИзПараметра = "ПоПериодуПоступлений" Тогда
		ЛевоеПолеОтбораКД = Новый ПолеКомпоновкиДанных("ФактическаяДатаПоступления");
	ИначеЕсли ИмяВариантаИзПараметра = "ПоПериодуОжиданияПоступлений" Тогда
		ЛевоеПолеОтбораКД = Новый ПолеКомпоновкиДанных("ОжидаемаяДатаПоступления");
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЛевоеПолеОтбораКД <> Неопределено Тогда
		
		// сделать с поиском по левому полю и виду сравнения
		ЭлОтбораКД1 = Неопределено;
		Для каждого Эл1 Из ОтборКД.Элементы Цикл
			Если Эл1.ЛевоеЗначение = ЛевоеПолеОтбораКД
					И Эл1.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно Тогда
				ЭлОтбораКД1 = Эл1;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЭлОтбораКД1 = Неопределено Тогда
			ЭлОтбораКД1 = ОтборКД.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлОтбораКД1.ЛевоеЗначение 	= ЛевоеПолеОтбораКД;
			ЭлОтбораКД1.ВидСравнения 	= ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		КонецЕсли;
		ЭлОтбораКД1.ПравоеЗначение 	= НачалоДня(Отчет.ДатаНач);
		ЭлОтбораКД1.Использование 	= Истина;
		
		
		ЭлОтбораКД2 = Неопределено;
		Для каждого Эл2 Из ОтборКД.Элементы Цикл
			Если Эл2.ЛевоеЗначение = ЛевоеПолеОтбораКД
					И Эл2.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно Тогда
				ЭлОтбораКД2 = Эл2;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЭлОтбораКД2 = Неопределено Тогда
			ЭлОтбораКД2 = ОтборКД.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлОтбораКД2.ЛевоеЗначение 	= ЛевоеПолеОтбораКД;
			ЭлОтбораКД2.ВидСравнения 	= ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
		КонецЕсли;
		
		ЭлОтбораКД2.ПравоеЗначение 	= КонецДня(Отчет.ДатаКон);
		ЭлОтбораКД2.Использование 	= Истина;
		
	КонецЕсли;
	
	Если НЕ ЭтаФорма.Склад.Пустая() Тогда
		ЛевоеПолеОтбора = Новый ПолеКомпоновкиДанных("СтруктурнаяЕдиница");
		мЭлементОтбора = Неопределено;
		Для каждого ТекЭлемент Из ОтборКД.Элементы Цикл
			Если ТекЭлемент.ЛевоеЗначение = ЛевоеПолеОтбора Тогда
				мЭлементОтбора = ТекЭлемент;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если мЭлементОтбора = Неопределено Тогда
			мЭлементОтбора = ОтборКД.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			мЭлементОтбора.ЛевоеЗначение 	= ЛевоеПолеОтбора;
			мЭлементОтбора.ВидСравнения 	= ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
		мЭлементОтбора.ПравоеЗначение 	= ЭтаФорма.Склад;
		мЭлементОтбора.Использование 	= Истина;
	КонецЕсли;
	
	Если НЕ ЭтаФорма.СкладХранения.Пустая() Тогда
		ЛевоеПолеОтбора = Новый ПолеКомпоновкиДанных("СкладХранения");
		мЭлементОтбора = Неопределено;
		Для каждого ТекЭлемент Из ОтборКД.Элементы Цикл
			Если ТекЭлемент.ЛевоеЗначение = ЛевоеПолеОтбора Тогда
				мЭлементОтбора = ТекЭлемент;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если мЭлементОтбора = Неопределено Тогда
			мЭлементОтбора = ОтборКД.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			мЭлементОтбора.ЛевоеЗначение 	= ЛевоеПолеОтбора;
			мЭлементОтбора.ВидСравнения 	= ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
		мЭлементОтбора.ПравоеЗначение 	= ЭтаФорма.СкладХранения;
		мЭлементОтбора.Использование 	= Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойВариантаНаСервере(Настройки)
	
	КолВо1 = Отчет.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Количество();
	Для Сч = 1 По КолВо1 Цикл
		ЭлОКД1 = Отчет.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы[КолВо1 - Сч];
		Отчет.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Удалить(ЭлОКД1);
	КонецЦикла; 
	
КонецПроцедуры
