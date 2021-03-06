﻿
//Определяет применяется ли упрощенная система налогообложения
//
Функция ПрименениеУСН(Организация, Знач Дата) Экспорт //~
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДата();
	КонецЕсли;

	УчетнаяПолитика = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиРегл(Дата, Организация, Ложь);
		
	Возврат ?(НЕ ЗначениеЗаполнено(УчетнаяПолитика), Ложь, (УчетнаяПолитика.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная));

КонецФункции
