﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Запись.Представление = Формат(Запись.ВРабочиеДни, "ЧДЦ=0; ЧН=") + "," + Формат(Запись.ВВыходныеДни, "ЧДЦ=0; ЧН=");
		Запись.Автор = ПараметрыСеанса.ТекущийПользователь;
		Запись.ДатаПоследнегоИзменения = ТекущаяДата();
	КонецЦикла;	
	
КонецПроцедуры
