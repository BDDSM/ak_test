﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаИмпортироватьУстныйОпрос(Команда)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'Документ'; en = 'Document'") + "(*.xls, *.xlsx)|*.xls;*.xlsx";
	
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	
	НачатьПомещениеФайлов(Новый ОписаниеОповещения("ОбработатьВыборФайлаЗакрытие", ЭтаФорма), , ДиалогОткрытияФайла, Истина, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОпевещений

&НаКлиенте
Процедура ОбработатьВыборФайлаЗакрытие(Результат, ДополнительныеПараметры)Экспорт 
	
	Если Результат <> Неопределено Тогда
		Для Каждого ИмяФайла Из Результат Цикл
			ОбработатьВыбранныйФайлКлиент(ИмяФайла);
		КонецЦикла;
	Иначе
		ПоказатьПредупреждение(,НСтр("ru = 'Файл не выбран!'; en = 'File not selected!'"))
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВыбранныйФайлКлиент(Адрес, НомерЛистаExcel = 1)
	
    xlLastCell = 11;
		
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
	Исключение
		Сообщить("Не удалось создать объект Excel");
		Возврат;
	КонецПопытки;
	
	Попытка
		Excel.WorkBooks.Open(Адрес.Имя);
		ExcelЛист = Excel.Sheets(НомерЛистаExcel);
	Исключение
		Сообщить("Не удалось открыть файл.");
		Возврат;
	КонецПопытки;
	
	ActiveCell = Excel.ActiveCell.SpecialCells(xlLastCell);
	RowCount    = ActiveCell.Row;
	ColumnCount = ActiveCell.Column;
	
	ПеридСтрока = СокрЛП(ExcelЛист.Cells(2,2).Value);
	
	Если НЕ ЗначениеЗаполнено(ПеридСтрока) Тогда
		ПоказатьПредупреждение(,"В документе не указан период (ячейка B2)!");
		Возврат;
	КонецЕсли;
	
	Попытка
		Запись.Период = Прав(ПеридСтрока,4) + Сред(ПеридСтрока,4,2)  + Лев(ПеридСтрока,2);
	Исключение
		Запись.Период = Дата(1,1,1);
	КонецПопытки;
	
	Запись.Организация    = ПолучитьОрганизациюСервер(ExcelЛист.Cells(1,1).Value);
	Запись.КвоОпрошенных  = Число(СокрЛП(СтрЗаменить(ExcelЛист.Cells(3,2).Value,"чел","")));
	Запись.КвоОтветов     = Число(СокрЛП(СтрЗаменить(ExcelЛист.Cells(4,2).Value,"чел","")));
	Запись.КвоНеПробовали = Число(СокрЛП(СтрЗаменить(ExcelЛист.Cells(5,2).Value,"чел","")));
	Запись.СреднийБалл    = Число(СокрЛП(ExcelЛист.Cells(8,2).Value));
	
	Запись.Оценка1 = Число(СокрЛП(ExcelЛист.Cells(12,1).Value));
	Запись.Оценка2 = Число(СокрЛП(ExcelЛист.Cells(12,2).Value));
	Запись.Оценка3 = Число(СокрЛП(ExcelЛист.Cells(12,3).Value));
	Запись.Оценка4 = Число(СокрЛП(ExcelЛист.Cells(12,4).Value));
	Запись.Оценка5 = Число(СокрЛП(ExcelЛист.Cells(12,5).Value));
	
	Запись.ПоложительныеОтзывы = СокрЛП(ExcelЛист.Cells(16,1).Value);
	Запись.ОтрицательныеОтзывы = СокрЛП(ExcelЛист.Cells(26,1).Value);
	
	Запись.Автор = ТекущийПользователь;
	
	Excel.WorkBooks.Close();
	Excel = Неопределено;

	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОрганизациюСервер(Организация)
	
	Если Организация = "ВкусВилл" Тогда
		Возврат Справочники.Организации.НайтиПоРеквизиту("ИНН", "7734675810");
	Иначе
		Возврат Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти
