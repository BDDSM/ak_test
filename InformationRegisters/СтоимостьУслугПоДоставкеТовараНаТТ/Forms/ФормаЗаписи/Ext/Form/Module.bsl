﻿
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(ЭтаФорма.Параметры.Ключ) Тогда
		Если Не НоменклатураСервер.ПроверитьГруппуДоставкиНоменклатуры(Запись.Период,Запись.ТТ,Запись.ГруппаДоставкиНоменклатуры) Тогда
			Отказ=Истина;
			Сообщить("Уже есть запись с текущей ТТ в заданном периоде по этой группе доставки");
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры
