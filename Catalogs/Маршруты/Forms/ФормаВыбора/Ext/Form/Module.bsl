﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если РольДоступна("ОператорСклада") ИЛИ РольДоступна("Кладовщик") Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	    ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ПометкаУдаления");   
	    ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	    ЭлементОтбора.Использование  = Истина;
	    ЭлементОтбора.ПравоеЗначение = Ложь;
	КонецЕсли; 
КонецПроцедуры
