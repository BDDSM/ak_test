﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтаФорма.ДатаСоставленияЗаявкиСтр 	= 2;
	ЭтаФорма.ДатаСоставленияЗаявкиКол 	= 10;
	ЭтаФорма.ДатаКлиентПроситСтр		= 4;
	ЭтаФорма.ДатаКлиентПроситКол		= 3;
	ЭтаФорма.НомерЯвочнойКарточкиСтр 	= 8;
	ЭтаФорма.НомерЯвочнойКарточкиКол 	= 4;
	ЭтаФорма.Количество01Стр 	= 15;
	ЭтаФорма.Количество01Кол 	= 5;
	ЭтаФорма.Количество05Стр 	= 16;
	ЭтаФорма.Количество05Кол 	= 5;
	ЭтаФорма.Количество1Стр 	= 17;
	ЭтаФорма.Количество1Кол 	= 5;
	ЭтаФорма.Количество2Стр 	= 18;
	ЭтаФорма.Количество2Кол 	= 5;
	ЭтаФорма.Количество5Стр 	= 19;
	ЭтаФорма.Количество5Кол 	= 5;
	ЭтаФорма.Количество10Стр 	= 20;
	ЭтаФорма.Количество10Кол 	= 5;
	ЭтаФорма.Количество50Стр 	= 15;
	ЭтаФорма.Количество50Кол 	= 11;
	ЭтаФорма.Количество100Стр 	= 16;
	ЭтаФорма.Количество100Кол 	= 11;
	ЭтаФорма.Количество500Стр 	= 17;
	ЭтаФорма.Количество500Кол 	= 11;
	ЭтаФорма.Количество1000Стр 	= 18;
	ЭтаФорма.Количество1000Кол 	= 11;
	ЭтаФорма.СоставительЗаявкиСтр = 33;
	ЭтаФорма.СоставительЗаявкиКол = 9;
	ЭтаФорма.ДолжностьСоставителяЗаявкиСтр = 33;
	ЭтаФорма.ДолжностьСоставителяЗаявкиКол = 1;
	ЭтаФорма.ТелефонСтр = 35;
	ЭтаФорма.ТелефонКол = 10;
	
	ЭтаФорма.ДниНеделиСтр = 30;
	ЭтаФорма.ПнКол = 3;
	ЭтаФорма.ВтКол = 5;
	ЭтаФорма.СрКол = 6;
	ЭтаФорма.ЧтКол = 7;
	ЭтаФорма.ПтКол = 8;
	ЭтаФорма.СбКол = 9;
	ЭтаФорма.ВсКол = 11;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.СоставительЗаявки 		= ПараметрыСеанса.ТекущийПользователь;
	Объект.КаталогСФайлами			= "D:\Izbenka\Neal\Расчеты с поставщиками\Заявки на монеты\";
	Объект.ДатаСоставленияЗаявки 	= ТекущаяДата();
	Объект.ДатаКлиентПросит 		= ТекущаяДата();
	
КонецПроцедуры


&НаКлиенте
Процедура КаталогСФайламиПриИзменении(Элемент)

КонецПроцедуры

&НаКлиенте
Процедура КаталогСФайламиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогВыбораФайла =	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораФайла.Заголовок					= "Выберите каталог с файлами";
	ДиалогВыбораФайла.ПредварительныйПросмотр	= Ложь;
	ДиалогВыбораФайла.ИндексФильтра				= 0;
	Если НЕ Объект.КаталогСФайлами = "" Тогда
		ДиалогВыбораФайла.Каталог				= Объект.КаталогСФайлами;
	КонецЕсли;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		Объект.КаталогСФайлами = ДиалогВыбораФайла.Каталог;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьЛистЭксель(ЛистЭксель)
	
	мДеньНеделиПросит = ДеньНедели(Объект.ДатаКлиентПросит);
	Если мДеньНеделиПросит = 1 Тогда
		ИмяКолонкиДень = "Пн";
	ИначеЕсли мДеньНеделиПросит = 2 Тогда
		ИмяКолонкиДень = "Вт";
	ИначеЕсли мДеньНеделиПросит = 3 Тогда
		ИмяКолонкиДень = "Ср";
	ИначеЕсли мДеньНеделиПросит = 4 Тогда
		ИмяКолонкиДень = "Чт";
	ИначеЕсли мДеньНеделиПросит = 5 Тогда
		ИмяКолонкиДень = "Пт";
	ИначеЕсли мДеньНеделиПросит = 6 Тогда
		ИмяКолонкиДень = "Сб";
	Иначе
		ИмяКолонкиДень = "Вс";
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.ДатаСоставленияЗаявки) Тогда
		ЛистЭксель.Cells(ЭтаФорма.ДатаСоставленияЗаявкиСтр, ЭтаФорма.ДатаСоставленияЗаявкиКол).Value = Формат(Объект.ДатаСоставленияЗаявки, "ДФ=""дд ММММ гггг'г.'""");
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.ДатаКлиентПросит) Тогда
		ЛистЭксель.Cells(ЭтаФорма.ДатаКлиентПроситСтр, ЭтаФорма.ДатаКлиентПроситКол).Value = Формат(Объект.ДатаКлиентПросит, "ДФ=""дд ММММ гггг' г.'""");
		Попытка
			ЛистЭксель.Cells(ЭтаФорма.ДниНеделиСтр, ЭтаФорма[ИмяКолонкиДень + "Кол"]).Value = "XXX";
			Если НЕ мДеньНеделиПросит = 1 Тогда
				ЛистЭксель.Cells(ЭтаФорма.ДниНеделиСтр, ЭтаФорма.ПнКол).Value = "";
			КонецЕсли;
			Если НЕ мДеньНеделиПросит = 2 Тогда
				ЛистЭксель.Cells(ЭтаФорма.ДниНеделиСтр, ЭтаФорма.ВтКол).Value = "";
			КонецЕсли;
			Если НЕ мДеньНеделиПросит = 3 Тогда
				ЛистЭксель.Cells(ЭтаФорма.ДниНеделиСтр, ЭтаФорма.СрКол).Value = "";
			КонецЕсли;
			Если НЕ мДеньНеделиПросит = 4 Тогда
				ЛистЭксель.Cells(ЭтаФорма.ДниНеделиСтр, ЭтаФорма.ЧтКол).Value = "";
			КонецЕсли;
			Если НЕ мДеньНеделиПросит = 5 Тогда
				ЛистЭксель.Cells(ЭтаФорма.ДниНеделиСтр, ЭтаФорма.ПтКол).Value = "";
			КонецЕсли;
			Если НЕ мДеньНеделиПросит = 6 Тогда
				ЛистЭксель.Cells(ЭтаФорма.ДниНеделиСтр, ЭтаФорма.СбКол).Value = "";
			КонецЕсли;
			Если НЕ мДеньНеделиПросит = 7 Тогда
				ЛистЭксель.Cells(ЭтаФорма.ДниНеделиСтр, ЭтаФорма.ВсКол).Value = "";
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЕсли;
	//Если ЗначениеЗаполнено(Объект.НомерЯвочнойКарточки) Тогда
	//	ЛистЭксель.Cells(ЭтаФорма.НомерЯвочнойКарточкиСтр, ЭтаФорма.НомерЯвочнойКарточкиКол).Value = СокрЛП(Объект.НомерЯвочнойКарточки);
	//КонецЕсли;
	//ЛистЭксель.Cells(ЭтаФорма.Количество01Стр, ЭтаФорма.Количество01Кол).Value = Объект.Количество01;
	//ЛистЭксель.Cells(ЭтаФорма.Количество05Стр, ЭтаФорма.Количество05Кол).Value = Объект.Количество05;
	//ЛистЭксель.Cells(ЭтаФорма.Количество1Стр, ЭтаФорма.Количество1Кол).Value = Объект.Количество1;
	//ЛистЭксель.Cells(ЭтаФорма.Количество2Стр, ЭтаФорма.Количество2Кол).Value = Объект.Количество2;
	//ЛистЭксель.Cells(ЭтаФорма.Количество5Стр, ЭтаФорма.Количество5Кол).Value = Объект.Количество5;
	//ЛистЭксель.Cells(ЭтаФорма.Количество10Стр, ЭтаФорма.Количество10Кол).Value = Объект.Количество10;
	//ЛистЭксель.Cells(ЭтаФорма.Количество50Стр, ЭтаФорма.Количество50Кол).Value = Объект.Количество50;
	//ЛистЭксель.Cells(ЭтаФорма.Количество100Стр, ЭтаФорма.Количество100Кол).Value = Объект.Количество100;
	//ЛистЭксель.Cells(ЭтаФорма.Количество500Стр, ЭтаФорма.Количество500Кол).Value = Объект.Количество500;
	//ЛистЭксель.Cells(ЭтаФорма.Количество1000Стр, ЭтаФорма.Количество1000Кол).Value = Объект.Количество1000;
	//Если ЗначениеЗаполнено(Объект.СоставительЗаявки) Тогда
	//	ЛистЭксель.Cells(ЭтаФорма.СоставительЗаявкиСтр, ЭтаФорма.СоставительЗаявкиКол).Value = СокрЛП(Строка(Объект.СоставительЗаявки));
	//КонецЕсли;
	//Если ЗначениеЗаполнено(Объект.ДолжностьСоставителяЗаявки) Тогда
	//	ЛистЭксель.Cells(ЭтаФорма.ДолжностьСоставителяЗаявкиСтр, ЭтаФорма.ДолжностьСоставителяЗаявкиКол).Value = СокрЛП(Объект.ДолжностьСоставителяЗаявки);
	//КонецЕсли;
	//Если ЗначениеЗаполнено(Объект.Телефон) Тогда
	//	ЛистЭксель.Cells(ЭтаФорма.ТелефонСтр, ЭтаФорма.ТелефонКол).Value = СокрЛП(Объект.Телефон);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьФайлы(Команда)
	
	Если СокрЛП(Объект.КаталогСФайлами) = "" Тогда
		Сообщить("Не выбран каталог с файлами!");
		Возврат;
	КонецЕсли;
	
	ЭксельПриложение = Новый COMОбъект("Excel.Application");
	
	НайденныеФайлы = НайтиФайлы(Объект.КаталогСФайлами, "*.xls", Истина);
	Для мИндекс = 1 По НайденныеФайлы.Количество() Цикл
		
		ТекФайл = НайденныеФайлы[мИндекс - 1];
		Если ТекФайл.ЭтоКаталог() Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			Эксель_документ = ЭксельПриложение.WorkBooks.Open(ТекФайл.ПолноеИмя);
			ЛистЭксель = Эксель_документ.Sheets(1);
			
			ОбработатьЛистЭксель(ЛистЭксель);
			
			Эксель_документ.Save();
			Эксель_документ.Close();
			Сообщить("Обработан файл " + ТекФайл.Имя);
		Исключение			
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;
	
	ЭксельПриложение.Quit();
	
КонецПроцедуры
