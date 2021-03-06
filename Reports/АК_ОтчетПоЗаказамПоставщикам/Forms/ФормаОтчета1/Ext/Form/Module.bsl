﻿
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	//Если НЕ ЗначениеЗаполнено(НаименованиеТекущегоВарианта) Тогда
	//	Сообщить("Не выбран вариант отчёта. Формирование невозможно");
	//	Отказ = Истина;
	//	Возврат;
	//КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.ИмяСхемы) Тогда
		Сообщить("Не удалось найти подходяшую схему компоновки!");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	//Если НЕ ЗначениеЗаполнено(ИмяВариантаИзПараметра)
	//	ИЛИ ИмяВариантаИзПараметра <> "ПоПериодуПоступления" И ИмяВариантаИзПараметра <> "ПоПериодуОжиданияПоступлений" Тогда
	//	Сообщить("Данный вариант отчёта недоступен. Формирование невозможно");
	//	Отказ = Истина;
	//	Возврат;
	//КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.ДатаНач) ИЛИ НЕ ЗначениеЗаполнено(Отчет.ДатаКон) ИЛИ Отчет.ДатаНач > Отчет.ДатаКон Тогда
		Сообщить("Не заполнен или некорректно заполнен период!");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
		
	//Если ИмяВариантаИзПараметра = "ПоПериодуПоступлений" Тогда
	//	Пар1 = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаНач");
	//	Пар2 = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаКон");
	//ИначеЕсли ИмяВариантаИзПараметра = "ПоПериодуОжиданияПоступлений" Тогда
	//	Пар1 = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаОПНач");
	//	Пар2 = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаОПКон");
	//Иначе
	//	Возврат;
	//КонецЕсли;
	//
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСхему(Команда)
	
	СЗ1 = Новый СписокЗначений;
	СЗ1.Добавить("ПоПериодуПоступлений", "По периоду поступлений");
	СЗ1.Добавить("ПоПериодуОжиданияПоступлений", "По периоду ожидания поступлений");
	
	ЭлСЗ = СЗ1.ВыбратьЭлемент("Выберите вариант отчёта");
	Если ЭлСЗ = Неопределено Тогда
		Отчет.ИмяСхемы = "";
	Иначе
		Отчет.ИмяСхемы = ЭлСЗ.Значение;
	КонецЕсли;
	
	ИнициализироватьКомпоновщикНастроек();
	УстановитьНаименованиеТекВарианта();
	
КонецПроцедуры

//&НаКлиенте
Процедура УстановитьНаименованиеТекВарианта()

	Если Отчет.ИмяСхемы = "ПоПериодуПоступлений" Тогда
		НаименованиеТекущегоВарианта1 = "По периоду поступлений";
	ИначеЕсли Отчет.ИмяСхемы = "ПоПериодуОжиданияПоступлений" Тогда
		НаименованиеТекущегоВарианта1 = "По периоду ожидания поступлений";
	Иначе
		НаименованиеТекущегоВарианта1 = "";
	КонецЕсли;
		
КонецПроцедуры

Процедура ИнициализироватьКомпоновщикНастроек()

	Если НЕ ЗначениеЗаполнено(Отчет.ИмяСхемы) Тогда
	 	Отчет.ИмяСхемы = Метаданные.Отчеты.АК_ОтчетПоЗаказамПоставщикам.ОсновнаяСхемаКомпоновкиДанных.Имя;
	КонецЕсли;
	//СхемаКД = Отчеты.АК_ОтчетПоЗаказамПоставщикам.ПолучитьМакет(Отчет.ИмяСхемы);
	//Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКД));
	//Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКД.НастройкиПоУмолчанию);
	//Отчет.КомпоновщикНастроек.Настройки = СхемаКД.ВариантыНастроек[0];
	

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьКомпоновщикНастроек();
	УстановитьНаименованиеТекВарианта();
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьНаСервере();
	
	
КонецПроцедуры

Процедура СформироватьНаСервере()

	ПроверитьЗаполнение();
	
	СхемаКД = Отчеты.АК_ОтчетПоЗаказамПоставщикам.ПолучитьМакет(Отчет.ИмяСхемы);
	Настройки = СхемаКД.НастройкиПоУмолчанию;
	
	//Пар1 = Настройки.ПараметрыДанных.Элементы.Найти("ДатаНач");
	Пар1 = СхемаКД.Параметры.Найти("ДатаНач");
	Пар1.Значение = Отчет.ДатаНач;
	Пар1.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	
	Пар2 = СхемаКД.Параметры.Найти("ДатаКон");
	Пар2.Значение = КонецДня(Отчет.ДатаКон);
	Пар2.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;;
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКД, Настройки, ДанныеРасшифровки);
	
	ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКД.Инициализировать(МакетКомпоновки);
	
	ПроцессорВР = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВР.УстановитьДокумент(Результат);
	ПроцессорВР.Вывести(ПроцессорКД);

КонецПроцедуры
