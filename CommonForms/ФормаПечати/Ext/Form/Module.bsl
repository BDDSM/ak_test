﻿
&НаКлиенте
Процедура Печать(Команда)
	ТабДок.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ТабДок") Тогда
		ТабДок=Параметры.ТабДок;
	КонецЕсли; 
КонецПроцедуры
