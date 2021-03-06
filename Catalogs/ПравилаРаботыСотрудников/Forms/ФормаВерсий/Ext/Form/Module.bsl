﻿
&НаКлиенте
Процедура ОткатитьсяДоК(Команда)
	
	ОткатитьсяДо();
	Предупреждение(НСтр("ru = 'Версия " + ТекущаяДатаВерсии + " загружена.'"));
	
	//+++ АК Pans 20160110
	Если ВерсияИзменена Тогда
		// запрос на формирование сообщений
		Ответ1 = Вопрос("Изменена версия! Сформировать сообщения магазинам?", РежимДиалогаВопрос.ДаНет);
		Если Ответ1 = КодВозвратаДиалога.Да Тогда
			СформироватьСообщенияМагазинам();
		КонецЕсли;
	КонецЕсли;
	ВерсияИзменена = Ложь;
	//--- АК Pans 20160110
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры	// ОткатитьсяДоК(Команда)

//+++ АК Pans 20160110
Процедура СформироватьСообщенияМагазинам()
	
	Справочники.ПравилаРаботыСотрудников.СформироватьСообщенияМагазинамОбИзмененииВерсии(Параметры.Ключ);

КонецПроцедуры
//--- АК Pans 20160110

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокВерсийР.Очистить();
	Для Каждого ТекСтрока Из Параметры.Ключ.ТЧТекст Цикл
		
		НовСтрока = СписокВерсийР.Добавить();
		НовСтрока.ДатаВерсии = ТекСтрока.Версия;
		НовСтрока.НомерВерсии = ТекСтрока.НомерСтроки;
		
	КонецЦикла;
	
	СписокВерсийР.Сортировать("НомерВерсии Убыв");
	
	//mika Дата: 2017.10.30 ИП-00017045
	ИспользоватьHTML = Параметры.Ключ.ИспользоватьHTML;
	Если ИспользоватьHTML Тогда
		ОбновитьВидимостьЭлементов();
	КонецЕсли;
	//mika
	
КонецПроцедуры	// ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

&НаКлиенте
Процедура СписокВерсийЭПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("СписокВерсийЭПриАктивизацииСтрокиОжидание", 0.1, Истина);

КонецПроцедуры	// СписокВерсийЭПриАктивизацииСтроки(Элемент)

&НаКлиенте
Процедура СписокВерсийЭПриАктивизацииСтрокиОжидание()
	
	//Подключен обработчик ожидания (Рефакторинг кода не проводился)
	Элемент = Элементы.СписокВерсийЭ;
	
	ПолеHTML = "";
	КэшВременныйКаталог = "";

	//Если ЗначениеЗаполнено(КэшВременныйКаталог) Тогда
	//	ПолеHTML = "";
	//	УдалитьВременныеФайлыHTMLКлиент(КэшВременныйКаталог);
	//	КэшВременныйКаталог = "";
	//КонецЕсли;

	Если ИспользоватьHTML Тогда
		
		ТекущийHTML = "";
		ИспользоватьТекстHTML(Параметры.Ключ, СтрЗаменить(Элемент.ТекущиеДанные.ДатаВерсии,":","-"), ТекущийHTML, КэшВременныйКаталог, "_" + ЭтаФорма.УникальныйИдентификатор);
		
		ПолеHTML = ТекущийHTML;
		
	Иначе	
		ЭлементФД(Элемент.ТекущиеДанные.ДатаВерсии);
	КонецЕсли;
	
КонецПроцедуры	// СписокВерсийЭПриАктивизацииСтроки(Элемент)

&НаСервере
Процедура ЭлементФД(ДатаВерсии)
	
	Каталог = Константы.КаталогХраненияФайловКартинок.Получить();
	Если Прав(Каталог,1) <> "\" Тогда
		Каталог = Каталог + "\";
	КонецЕсли;
	
	ТекущаяДатаВерсии = ДатаВерсии;
	
	ТекстHTML = "";
	Для Каждого ТекСтрока Из Параметры.Ключ.ТЧТекст Цикл
		Если ДатаВерсии = ТекСтрока.Версия Тогда
			ТекстHTML = ТекСтрока.ФДХранилище.Получить();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Картинки = Новый Структура;
	Для Каждого ТекСтрока Из Параметры.Ключ.ТЧКартинки  Цикл
		Если ДатаВерсии = ТекСтрока.Версия Тогда
			ИмяФайла = ТекСтрока.ИмяФайла;
			ПолноеИмяФайла = "" + Каталог + ИмяФайла;
			Файл = Новый Файл(ПолноеИмяФайла);
			Если Файл.Существует() Тогда
				Картинка = Новый Картинка(ПолноеИмяФайла);
				Картинки.Вставить(ТекСтрока.Ключ, Картинка);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ПолеФДР.УстановитьHTML(ТекстHTML, Картинки);
	
КонецПроцедуры	// ЭлементФД(ДатаВерсии)

&НаСервере
Процедура ОткатитьсяДо()
	
	Объект = Параметры.Ключ.ПолучитьОбъект();
	
	Нашли = Ложь;
	Для Каждого ТекСтрока Из Объект.ТЧТекст Цикл
		Если ТекущаяДатаВерсии = ТекСтрока.Версия Тогда
			ТекстHTML = ТекСтрока.ФДХранилище.Получить();
			Нашли = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Нашли Тогда
		Объект.ТекущаяВерсия = ТекущаяДатаВерсии;
		Объект.ТекущийТекст = ТекстHTML;
		ВерсияИзменена = Истина;
		Объект.Записать();
	КонецЕсли;
	
КонецПроцедуры	// ОткатитьсяДо()

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(КэшВременныйКаталог) Тогда
		Попытка
			УдалитьВременныеФайлыHTMLКлиент(КэшВременныйКаталог, Истина);
		Исключение
			Предупреждение("Ошибка очистки кэша! Повторите закрытине окна через несколько секунд!");
			Отказ = Истина;
		КонецПопытки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ПараметрыФормы = Новый Структура("Ключ", ЭтаФорма.Параметры.Ключ, ЭтаФорма.УникальныйИдентификатор);
	ОткрытьФорму("Справочник.ПравилаРаботыСотрудников.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры

//mika Дата: 2017.10.30 ИП-00017045
&НаСервере
Процедура ОбновитьВидимостьЭлементов() 
	
	Элементы.ПолеHTML.Видимость = ИспользоватьHTML;
	Элементы.ПолеФДЭ.Видимость  = НЕ ИспользоватьHTML;
	Элементы.ОткатитьсяДоЭ.Видимость = НЕ ИспользоватьHTML;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИспользоватьТекстHTML(СправочникСсылка,ТекущаяВерсия, ТекущийHTML, КэшВременныйКаталог, УникальныйИдентификатор)
	
	СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
	Справочники.ПравилаРаботыСотрудников.ВосстановитьКартинкиHTMLТекущейВерсии(СправочникОбъект, ТекущаяВерсия, ТекущийHTML, КэшВременныйКаталог, УникальныйИдентификатор); 
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВременныеФайлыHTMLКлиент(ВременныйКаталог, ОчиститьВсеВерсии = Ложь)
	
	Если ОчиститьВсеВерсии Тогда
		УдалитьФайлы(Лев(ВременныйКаталог, Найти(ВременныйКаталог,"ver")-1));
	Иначе
		УдалитьФайлы(ВременныйКаталог);
	КонецЕсли;
	
КонецПроцедуры // УдалитьВременныеФайлыHTMLКлиент()

&НаСервере
Процедура ВызовСервера()
	
	ПолеHTML = ТекущийHTML;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьHTML(Команда)
	ВызовСервера();
КонецПроцедуры


//mika
