﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Номенклатура", ПараметрКоманды));
	ОткрытьФорму("РегистрСведений.СпецификацииПоставщиков.Форма.ФормаСпискаУпр", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
