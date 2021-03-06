﻿//Перем ОтключитьФильтр;

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогФайла.МножественныйВыбор = Ложь;
	
	ДиалогФайла.Фильтр = "(*.jpg;*.jpeg;*.gif;*.tif;*.png)|*.jpg;*.jpeg;*.gif;*.tif;*.png";
	
	Если ОтключитьФильтр = Истина Тогда
		ДиалогФайла.Фильтр = "";
	КонецЕсли;
	
	ДиалогФайла.ПроверятьСуществованиеФайла = Истина;
	Если ДиалогФайла.Выбрать() Тогда
		//ХранилищеКартинки = Новый ХранилищеЗначения(ДиалогФайла.ПолноеИмяФайла);
		БылВыборФайла = Истина;
		ИмяФайла = ДиалогФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	
	Закрыть(Новый Структура("ИмяФайла, БылВыборФайла", ИмяФайла, БылВыборФайла));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("ОтключитьФильтр",ОтключитьФильтр);
КонецПроцедуры
