﻿
Процедура ПередЗаписью(Отказ)
	Если ОчисткаТаблиц.Количество() = 0 Тогда
		ТекТаблица1С = Неопределено;
		ТекТаблицаСайта = Неопределено;
		
		Если ЗначениеЗаполнено(Сопоставление.ПредставлениеТаблицы1С) тогда
			ТекТаблица1С = Сопоставление.ПредставлениеТаблицы1С;
			ДобСтр = ОчисткаТаблиц.Добавить();
			ДобСтр.Таблица = Сопоставление.ПредставлениеТаблицы1С;
			ДобСтр.Выгрузка = Истина;
			ДобСтр.Загрузка = Истина;
			ДобСтр.ПредварительнаяЗагрузка = Истина;
			ДобСтр.ОчиститьПослеПредварительнойЗагрузки = Истина;
		Конецесли;
		
		Если ЗначениеЗаполнено(Сопоставление.ПредставлениеТаблицыСайта) Тогда
			ТекТаблицаСайта = Сопоставление.ПредставлениеТаблицыСайта;
			ДобСтр = ОчисткаТаблиц.Добавить();
			ДобСтр.Таблица = Сопоставление.ПредставлениеТаблицыСайта;
			ДобСтр.Выгрузка = Истина;
			ДобСтр.Загрузка = Истина;
			ДобСтр.ПредварительнаяЗагрузка = ИСТИНА;
			ДобСтр.ОчиститьПослеПредварительнойЗагрузки = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекТаблица1С)И ЗначениеЗаполнено(ТекТаблицаСайта)  Тогда
			ДобСтр = ОчисткаТаблиц.Добавить();
			ДобСтр.Таблица = "ТРС_"+ТекТаблица1С+"_"+ТекТаблицаСайта;
			ДобСтр.Выгрузка = Истина;
			ДобСтр.Загрузка = Истина;
			ДобСтр.ПредварительнаяЗагрузка = Истина;
			ДобСтр.ОчиститьПослеПредварительнойЗагрузки = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры