﻿
&НаКлиенте
Процедура Ок(Команда)	
	Закрыть(СписокТоваров);	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СписокТоваров.Очистить();
	Для каждого стр из Параметры.Товары Цикл
		СписокТоваров.добавить(Стр.Значение);	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОК(Команда)
	НомерЛистаExcel = 1;
	xlLastCell      = 11;
	ВыбФайл = Новый Файл(ИмяФайла);
	Если НЕ ВыбФайл.Существует() Тогда
		Сообщить("Файл не существует!");
		Возврат ;
	КонецЕсли;	
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.WorkBooks.Open(ИмяФайла);
		ExcelЛист = Excel.Sheets(НомерЛистаExcel);
	Исключение
		Сообщить("Ошибка. Возможно неверно указан номер листа книги Excel.");
		Возврат ;		
	КонецПопытки;
	ActiveCell = Excel.ActiveCell.SpecialCells(xlLastCell);
	RowCount    = ActiveCell.Row;
	ColumnCount = ActiveCell.Column; 		
	Предел=100000;	 
	Для Row = 1 По Предел Цикл 
		Если  СокрЛП(ExcelЛист.Cells(Row, 1).Text)="" Тогда
			Прервать;	
		КонецЕсли;
		Номенклатура=НайтиНаСервере(СокрЛП(ExcelЛист.Cells(Row, 1).Text));	
		Если Не Номенклатура.Пустая() и не Номенклатура=Неопределено Тогда
			НовСтрока = СписокТоваров.Добавить(Номенклатура);
		Иначе
			Сообщить("Номенклатура "+СокрЛП(ExcelЛист.Cells(Row, 1).Text)+" не найдена в базе");
		КонецЕсли;		
	КонецЦикла;
	Excel.WorkBooks.Close();
	Excel = 0;
	
КонецПроцедуры

&НаСервере
Функция НайтиНасервере(НАименование)
	Возврат Справочники.Номенклатура.НайтиПоНаименованию(Наименование,Истина);
КонецФункции

&НаКлиенте
Процедура ПутьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.Фильтр="Лист Excel (*.xls)|*.xls| Лист Excel 2007 (*.xlsx)|*.xlsx|";
	Если ДиалогВыбора.Выбрать() Тогда
		ИмяФайла = ДиалогВыбора.ПолноеИмяФайла;
	КонецЕсли;	
КонецПроцедуры
