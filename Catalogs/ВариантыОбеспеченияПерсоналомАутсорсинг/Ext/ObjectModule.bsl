﻿//АК БЕЛН 31.03.2017+
Перем Автоматически Экспорт;
Процедура ПередЗаписью(Отказ)
	Если Не Автоматически Тогда
		Если Не РольДоступна("ПолныеПрава") И (ПометкаУдаления ИЛИ ЭтоНовый()) Тогда
			Сообщить("Недостаточно прав");
			Отказ=Истина;
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры
Автоматически=Ложь;
//АК БЕЛН 31.03.2017-
