﻿
//+++АК LATV 2018.08.30 ИП-00017990
Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПользователь	= глЗначениеПеременной("глТекущийПользователь");
	
	Для Каждого ТекЗапись Из ЭтотОбъект Цикл
		ТекЗапись.АвторИзменений	= ТекущийПользователь;
		ТекЗапись.ДатаИзменений		= ТекущаяДата();
	КонецЦикла;

КонецПроцедуры
