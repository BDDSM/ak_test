﻿
Процедура ПриЗаписи(Отказ)
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		Наименование = ?(ЗначениеЗаполнено(Родитель.Наименование), Родитель.Наименование + " - " + Код, Код);
		ЭтотОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЭтоГруппа Тогда
		Если НЕ ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Перед записью необходимо определить единицу измерения площади!", Отказ);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры
