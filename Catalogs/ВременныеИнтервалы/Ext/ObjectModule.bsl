﻿
Процедура ПередЗаписью(Отказ)
	Если ВремяНачала>=ВремяОкончания Тогда
		Сообщить("Некорректный временной интервал");
		Отказ=Истина;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВременныеИнтервалы.Ссылка
		|ИЗ
		|	Справочник.ВременныеИнтервалы КАК ВременныеИнтервалы
		|ГДЕ
		|	ВременныеИнтервалы.ПометкаУдаления = ЛОЖЬ
		|	И (ВременныеИнтервалы.ВремяОкончания > &ВремяНачала
		|				И ВременныеИнтервалы.ВремяОкончания <= &ВремяОкончания
		|			ИЛИ ВременныеИнтервалы.ВремяНачала >= &ВремяНачала
		|				И ВременныеИнтервалы.ВремяНачала < &ВремяОкончания)
		|	И ВременныеИнтервалы.Ссылка <> &Ссылка
		|	И ВременныеИнтервалы.Склад = &Склад";

	Запрос.УстановитьПараметр("ВремяНачала", ВремяНачала);
	Запрос.УстановитьПараметр("ВремяОкончания", ВремяОкончания);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Склад", Склад);
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сообщить("Есть пересекающиеся интервалы времени");
		Отказ=Истина;
	КонецЦикла;


КонецПроцедуры
