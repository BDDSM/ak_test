﻿//+++АК BELN 2018.12.04 ИП-00020614
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Фл=Ложь;
	Для каждого Эл Из ЭтотОбъект Цикл
		Если Эл.Заблокировано Тогда
			Фл=Истина;
		КонецЕсли; 
	КонецЦикла;
	Если НЕ Фл Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Причина"));
	КонецЕсли; 
КонецПроцедуры
//---АК BELN 2018.12.04 
//+++АК BELN 2018.12.04 ИП-00020614
Процедура ПередЗаписью(Отказ, Замещение)
	Если НЕ ПроверитьЗаполнение() Тогда
		Отказ=Истина;	
	КонецЕсли; 	
КонецПроцедуры
//---АК BELN 2018.12.04 
