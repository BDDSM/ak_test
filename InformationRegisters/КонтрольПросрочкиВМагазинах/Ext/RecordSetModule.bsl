﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если НЕ ЗначениеЗаполнено(Запись.АвторИзменения) Тогда
			Попытка
				Запись.АвторИзменения = ПараметрыСеанса.ТекущийПродавец;
			Исключение
			КонецПопытки;
			Если НЕ ЗначениеЗаполнено(Запись.АвторИзменения) Тогда
				Запись.АвторИзменения = ПараметрыСеанса.ТекущийПользователь;
			КонецЕсли;	
			Запись.ДатаПоследнегоИзменения = ТекущаяДата();
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры
