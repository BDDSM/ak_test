﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТабДок.Вывести(Параметры.ТабДок);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРасшифровкуЧеков(ТекАйди)
	
	Возврат Обработки.ОтчетыПоКартам.ФинОперациВыборНаСервере(ТекАйди);
	
КонецФункции

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТабДокРасш = ПолучитьРасшифровкуЧеков(Расшифровка);
	ТабДокРасш.ОтображатьСетку = Ложь;
	ТабДокРасш.ОтображатьЗаголовки = Ложь;
	ТабДокРасш.Показать();
	
КонецПроцедуры
