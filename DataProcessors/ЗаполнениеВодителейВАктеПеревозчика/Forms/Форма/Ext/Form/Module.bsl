﻿
&НаСервереБезКонтекста
Функция ПолучитьПеревозчикаАкта(мАкт)
	
	Возврат мАкт.Перевозчик;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДатуНачалаАкта(мАкт)
	
	Возврат мАкт.ДатаНачала;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьКолДнейПериодаАкта(мАкт)
	
	Возврат (мАкт.ДатаОкончания - мАкт.ДатаНачала) / 86400 + 1;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтаФорма.ВысотаШапки 					= 1;
	ЭтаФорма.НомерКолонкиВодитель 			= 1;
	ЭтаФорма.НомерКолонкиАвтомобиль 		= 2;
	ЭтаФорма.НомерКолонкиПервыйДеньПериода 	= 3;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.АктПеревозчика = ЭтаФорма.Параметры.АктПеревозчика;
	
КонецПроцедуры


&НаКлиенте
Процедура ФайлЭксельНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогВыбораФайла =	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);

	//ДиалогВыбораФайла.Фильтр					= "Документ Microsoft Excel (*.xls)|*.xls";
	//ДиалогВыбораФайла.Расширение				= "xls";
	ДиалогВыбораФайла.Заголовок					= "Выберите файл Excel";
	ДиалогВыбораФайла.ПредварительныйПросмотр	= Ложь;
	//ДиалогВыбораФайла.ИндексФильтра				= 0;
	ДиалогВыбораФайла.ПолноеИмяФайла			= ЭтаФорма.ФайлЭксель;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ЭтаФорма.ФайлЭксель = ДиалогВыбораФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлЭксельОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение("explorer " + ЭтаФорма.ФайлЭксель);
	
КонецПроцедуры


&НаСервереБезКонтекста
Процедура ЗаполнитьВодителейСервер(СтруктураПараметров)
	
	//
	ТаблицаВодителей = Новый ТаблицаЗначений;
	ТаблицаВодителей.Колонки.Добавить("Дата"		, Новый ОписаниеТипов("Дата"));
	ТаблицаВодителей.Колонки.Добавить("Водитель"	, Новый ОписаниеТипов("СправочникСсылка.КонтактныеЛицаКонтрагентов"));
	ТаблицаВодителей.Колонки.Добавить("Автомобиль"	, Новый ОписаниеТипов("СправочникСсылка.Автомобили"));
	
	Для Каждого ТекСтруктура Из СтруктураПараметров.МассивСтруктур Цикл
		НоваяСтрока = ТаблицаВодителей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтруктура);
	КонецЦикла;

	Если ТаблицаВодителей.Количество() = 0 Тогда
		Сообщить("Нет данных для заполнения");
		Возврат;
	КонецЕсли;
	
	//
	ОбъектДокумента = СтруктураПараметров.АктПеревозчика.ПолучитьОбъект();
	
	СтруктураПоиска = Новый Структура("Дата, Автомобиль");
	
	Для Каждого СтрокаТЧ Из ОбъектДокумента.ПриходныеОрдера Цикл
		СтруктураПоиска.Дата 		= НачалоДня(СтрокаТЧ.ПриходныйОрдер.ДатаВремяЗаездаМашины);
		СтруктураПоиска.Автомобиль 	= СтрокаТЧ.ПриходныйОрдер.Автомобиль;
		СтрокиТаблицы = ТаблицаВодителей.НайтиСтроки(СтруктураПоиска);
		Если СтрокиТаблицы.Количество() > 0 Тогда
			СтрокаТЧ.Водитель = СтрокиТаблицы[0].Водитель;
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		ОбъектДокумента.Записать();
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКЛСервер(ФИОВодителя)
	
	СпрКонтЛица = Справочники.КонтактныеЛица;
	ТекКЛ = СпрКонтЛица.НайтиПоНаименованию(ФИОВодителя, Истина);
	Если ТекКЛ.Пустая() Тогда
		НовоеКЛ = СпрКонтЛица.СоздатьЭлемент();
		НовоеКЛ.Наименование = ФИОВодителя;
		
		ТекФИО = ФИОВодителя;
		ПозПробел = Найти(ТекФИО, " ");
		Если ПозПробел > 0 Тогда
			НовоеКЛ.Фамилия 		= Лев(ТекФИО, ПозПробел - 1);
			ТекФИО = СокрЛ(Сред(ТекФИО, ПозПробел + 1));
			ПозПробел = Найти(ТекФИО, " ");
			Если ПозПробел > 0 Тогда
				НовоеКЛ.Имя 		= Лев(ТекФИО, ПозПробел - 1);
				НовоеКЛ.Отчество 	= СокрЛ(Сред(ТекФИО, ПозПробел + 1))
			КонецЕсли;
		КонецЕсли;
		
		Попытка
			НовоеКЛ.Записать();
			ТекКЛ = НовоеКЛ.Ссылка;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Возврат ТекКЛ;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВодителяСервер(ФИОВодителя, ТекКЛ, ТекПеревозчик, НомСтроки)
	
	СпрКонтЛицаКонтр = Справочники.КонтактныеЛицаКонтрагентов;
	ТекВодитель = СпрКонтЛицаКонтр.НайтиПоНаименованию(ФИОВодителя, Истина,, ТекПеревозчик);
	Если ТекВодитель.Пустая() Тогда
		НовыйВодитель = СпрКонтЛицаКонтр.СоздатьЭлемент();
		НовыйВодитель.Владелец 			= ТекПеревозчик;
		НовыйВодитель.Наименование 		= ФИОВодителя;
		НовыйВодитель.КонтактноеЛицо 	= ТекКЛ;
		НовыйВодитель.Должность			= "Водитель";
		Попытка
			НовыйВодитель.Записать();
			Сообщить("Строка № " + Формат(НомСтроки, "ЧГ=") + ": создан водитель """ + НовыйВодитель + """");
			ТекВодитель = НовыйВодитель.Ссылка;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Возврат ТекВодитель;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьАвтомобильСервер(СтрокаАвтомобиль)
	
	Возврат Справочники.Автомобили.НайтиПоНаименованию(СтрокаАвтомобиль);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьВодителей(Команда)
	
	Если ЭтаФорма.ФайлЭксель = "" Тогда
		Возврат;
	КонецЕсли;
	
	ТекПеревозчик = ПолучитьПеревозчикаАкта(ЭтаФорма.АктПеревозчика);
	ТекДатаНачала = ПолучитьДатуНачалаАкта(ЭтаФорма.АктПеревозчика);
	КолДнейПериода = ПолучитьКолДнейПериодаАкта(ЭтаФорма.АктПеревозчика);
	
	МассивСтруктур = Новый Массив;
	
	Эксель = Новый COMОбъект("Excel.Application");
	
	Эксель_документ = Эксель.Workbooks.Open(ЭтаФорма.ФайлЭксель);
	ЛистЭксель = Эксель_документ.Sheets(1);
	
	
	НомСтроки = ЭтаФорма.ВысотаШапки + 1;
	СтрокаВодитель = ЛистЭксель.Cells(НомСтроки, ЭтаФорма.НомерКолонкиВодитель).Value;
	
	Пока ЗначениеЗаполнено(СтрокаВодитель) Цикл
		
		ФИОВодителя = СокрЛП(СтрокаВодитель);
		
		ТекКЛ = ПолучитьКЛСервер(ФИОВодителя);
		Если ТекКЛ.Пустая() Тогда
			Сообщить("Строка № " + Формат(НомСтроки, "ЧГ=") + ": не создано контактное лицо!");
			НомСтроки = НомСтроки + 1;
			СтрокаВодитель = ЛистЭксель.Cells(НомСтроки, ЭтаФорма.НомерКолонкиВодитель).Value;
			Продолжить;
		КонецЕсли;
		
		ТекВодитель = ПолучитьВодителяСервер(ФИОВодителя, ТекКЛ, ТекПеревозчик, НомСтроки);
		Если ТекВодитель.Пустая() Тогда
			Сообщить("Строка № " + Формат(НомСтроки, "ЧГ=") + ": не создан водитель!");
			НомСтроки = НомСтроки + 1;
			СтрокаВодитель = ЛистЭксель.Cells(НомСтроки, ЭтаФорма.НомерКолонкиВодитель).Value;
			Продолжить;
		КонецЕсли;
		
		СтрокаАвтомобиль = СокрЛП(ВРег(ЛистЭксель.Cells(НомСтроки, ЭтаФорма.НомерКолонкиАвтомобиль).Value));
		ТекАвтомобиль = ПолучитьАвтомобильСервер(СтрокаАвтомобиль);
 		Если ТекАвтомобиль.Пустая() Тогда
			Сообщить("Строка № " + Формат(НомСтроки, "ЧГ=") + ": не найден автомобиль!");
			НомСтроки = НомСтроки + 1;
			СтрокаВодитель = ЛистЭксель.Cells(НомСтроки, ЭтаФорма.НомерКолонкиВодитель).Value;
			Продолжить;
 		КонецЕсли;
		
		
		Для н = 1 По КолДнейПериода Цикл
			ЯчейкаЭксель = ЛистЭксель.Cells(НомСтроки, ЭтаФорма.НомерКолонкиПервыйДеньПериода + н - 1);
			Если ЯчейкаЭксель.Interior.ColorIndex > 0 Тогда
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("Дата"			, ТекДатаНачала + (н - 1) * 86400);
				СтруктураПараметров.Вставить("Водитель"		, ТекВодитель);
				СтруктураПараметров.Вставить("Автомобиль"	, ТекАвтомобиль);
				МассивСтруктур.Добавить(СтруктураПараметров);
			КонецЕсли;
		КонецЦикла;
		
		
		НомСтроки = НомСтроки + 1;
		СтрокаВодитель = ЛистЭксель.Cells(НомСтроки, ЭтаФорма.НомерКолонкиВодитель).Value;
		
	КонецЦикла;
	
	Эксель.Quit();
	
	
	//
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("АктПеревозчика", ЭтаФорма.АктПеревозчика);
	СтруктураПараметров.Вставить("МассивСтруктур", МассивСтруктур);
	
	ЗаполнитьВодителейСервер(СтруктураПараметров);
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры


