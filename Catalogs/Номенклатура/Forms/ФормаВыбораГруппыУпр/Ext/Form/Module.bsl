﻿//+++АК BELN 2017.11.16 ИП-00017261 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ТолькоВерхниеГруппы") Тогда
		Элементы.Список.Отображение=ОтображениеТаблицы.Список;	
	КонецЕсли;
КонецПроцедуры
//---АК BELN 2017.11.16 
