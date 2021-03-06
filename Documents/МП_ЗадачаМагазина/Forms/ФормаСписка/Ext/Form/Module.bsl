﻿
&НаКлиенте
Процедура ВыводитьТолькоГотовыеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "СтатусЗадачи", ПредопределенноеЗначение("Перечисление.СтатусыЗадач.ГОТОВО"),,, ВыводитьТолькоГотовые);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьТолькоСНеобработаннымиФотоПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ЕстьНеОбработанныеФото", Истина,,, ВыводитьТолькоСНеобработаннымиФото);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьФото(Команда)
	
	ОткрытьФорму("Документ.МП_ЗадачаМагазина.Форма.ФормаВыгрузкиФото");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРакурсовОтборПриИзменении(Элемент)
	
	Для Каждого ЭлементОтбор Из Список.Отбор.Элементы Цикл
		Если ЭлементОтбор.Представление = "ГруппаОтборовПоРакурсам" Тогда
			Список.Отбор.Элементы.Удалить(ЭлементОтбор);
		КонецЕсли;	
	КонецЦикла;
	
	Если СписокРакурсовОтбор.Количество() > 0 Тогда
		ЭлементОтборГруппа = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ЭлементОтборГруппа.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		ЭлементОтборГруппа.Представление = "ГруппаОтборовПоРакурсам";
		Для Каждого СтрокаРакурс Из СписокРакурсовОтбор Цикл
			ЭлементОтбор = ЭлементОтборГруппа.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РакурсыЗаданияСтрокой");
			ЭлементОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит;
			ЭлементОтбор.ПравоеЗначение = СокрЛП(СтрокаРакурс) + ";";
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ГрупповойОтчет(Команда)
	
	ОткрытьФорму("Документ.МП_ЗадачаМагазина.Форма.ПросмотрГрупповой");
	
КонецПроцедуры
