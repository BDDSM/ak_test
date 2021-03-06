﻿
&НаСервере
Процедура ЗаполнитьЛУ(ДатаОбработки)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТабельРаботыПродавцов.Сотрудник КАК Сотрудник,
	               |	ТабельРаботыПродавцов.ТорговаяТочка КАК ТорговаяТочка,
	               |	ТабельРаботыПродавцов.СвойствоПродавца КАК Пч
	               |ПОМЕСТИТЬ ВТ_Табель
	               |ИЗ
	               |	РегистрСведений.ТабельРаботыПродавцов КАК ТабельРаботыПродавцов
	               |ГДЕ
	               |	НАЧАЛОПЕРИОДА(ТабельРаботыПродавцов.Период, ДЕНЬ) = &ДатаОбработки
	               |	И ТабельРаботыПродавцов.Отсутствие = ЗНАЧЕНИЕ(Перечисление.ВидыОтсутствия.ПустаяСсылка)
	               |	И ТабельРаботыПродавцов.Сотрудник В(&МассивПродавцов)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЛистУчетаПродавцы.Продавец,
	               |	ЛистУчетаПродавцы.Пч,
	               |	ЛистУчетаПродавцы.Ссылка.ТорговаяТочка
	               |ПОМЕСТИТЬ ВТ_Листы
	               |ИЗ
	               |	Документ.ЛистУчета.Продавцы КАК ЛистУчетаПродавцы
	               |ГДЕ
	               |	НАЧАЛОПЕРИОДА(ЛистУчетаПродавцы.Ссылка.Дата, ДЕНЬ) = &ДатаОбработки
	               |	И ЛистУчетаПродавцы.Ссылка.Проведен = ИСТИНА
	               |	И ЛистУчетаПродавцы.Продавец В(&МассивПродавцов)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЛистУчетаПродавцы.Ссылка,
	               |	ЛистУчетаПродавцы.ТорговаяТочка
	               |ИЗ
	               |	Документ.ЛистУчета КАК ЛистУчетаПродавцы
	               |ГДЕ
	               |	НАЧАЛОПЕРИОДА(ЛистУчетаПродавцы.Ссылка.Дата, ДЕНЬ) = &ДатаОбработки
	               |	И ЛистУчетаПродавцы.Ссылка.Проведен = ИСТИНА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_Табель.Сотрудник,
	               |	ВТ_Табель.ТорговаяТочка,
	               |	ВТ_Табель.Пч
	               |ИЗ
	               |	ВТ_Табель КАК ВТ_Табель
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ЕСТЬNULL(ВТ_Листы.ТорговаяТочка, ВТ_Табель.ТорговаяТочка) КАК ТорговаяТочка
	               |ИЗ
	               |	ВТ_Табель КАК ВТ_Табель
	               |		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Листы КАК ВТ_Листы
	               |		ПО ВТ_Табель.Сотрудник = ВТ_Листы.Продавец
	               |			И ВТ_Табель.ТорговаяТочка = ВТ_Листы.ТорговаяТочка
	               |			И ВТ_Табель.Пч = ВТ_Листы.Пч
	               |ГДЕ
	               |	(ВТ_Табель.Сотрудник ЕСТЬ NULL 
	               |			ИЛИ ВТ_Листы.Продавец ЕСТЬ NULL 
	               |			ИЛИ (ВТ_Табель.ТорговаяТочка ЕСТЬ NULL 
	               |				ИЛИ ВТ_Листы.ТорговаяТочка ЕСТЬ NULL )
	               |			ИЛИ (ВТ_Табель.Пч ЕСТЬ NULL 
	               |				ИЛИ ВТ_Листы.Пч ЕСТЬ NULL ))
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_Листы
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_Табель";
				   
	Запрос.УстановитьПараметр("ДатаОбработки", НачалоДня(ДатаОбработки));
	Запрос.УстановитьПараметр("МассивПродавцов", СписокПродавцов);
	
	Результаты = Запрос.ВыполнитьПакет();
	ВыборкаТабель = Результаты[4].Выбрать();
	ТабГрафик = Результаты[3].Выгрузить();
	ТабЛУ = Результаты[2].Выгрузить();
	
	//Для Каждого СтрокаЛУ Из ТабЛУОчистить Цикл
	//	ДокЛУ = СтрокаЛУ.Ссылка.ПолучитьОбъект();
	//	КолвоСтрок = ДокЛУ.Продавцы.Количество();
	//	Для н = 1 По КолвоСтрок Цикл
	//		Если СписокПродавцов.НайтиПоЗначению(ДокЛУ.Продавцы[КолвоСтрок - н]. Продавец) <> Неопределено Тогда
	//			ДокЛУ.Продавцы.Удалить(КолвоСтрок - н);
	//		КонецЕсли;	
	//	КонецЦикла;
	//	ДокЛУ.Записать(РежимЗаписиДокумента.Запись);
	//КонецЦикла;	
	
	Пока ВыборкаТабель.Следующий() Цикл
		СтрокаЛист = ТабЛУ.Найти(ВыборкаТабель.ТорговаяТочка, "ТорговаяТочка");
		Если СтрокаЛист = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ДокОбъект = СтрокаЛист.Ссылка.ПолучитьОбъект();
		КолвоСтрок = ДокОбъект.Продавцы.Количество();
		Для н = 1 По КолвоСтрок Цикл
			Если СписокПродавцов.НайтиПоЗначению(ДокОбъект.Продавцы[КолвоСтрок - н]. Продавец) <> Неопределено Тогда
				ДокОбъект.Продавцы.Удалить(КолвоСтрок - н);
			КонецЕсли;	
		КонецЦикла;
		СтрокиТабель = ТабГрафик.НайтиСтроки(Новый Структура("ТорговаяТочка", ВыборкаТабель.ТорговаяТочка));
		Для Каждого СтрокаТабель Из СтрокиТабель Цикл
			СтрокаДоб = ДокОбъект.Продавцы.Добавить();
			СтрокаДоб.Продавец = СтрокаТабель.Сотрудник;
			СтрокаДоб.Пч = СтрокаТабель.Пч;
		КонецЦикла;	
		ДокОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура Заполнить(Команда)
	
	ДатаОбработки = ДатаНачала;
	Пока ДатаОбработки <= ДатаОкончания Цикл
		Состояние("Обработка за " + Формат(ДатаОбработки, "ДФ=dd.MM.yyyy"));
		ЗаполнитьЛУ(ДатаОбработки);
		ДатаОбработки = ДатаОбработки + 86400;
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаНачала = Параметры.ДатаНачала;
	ДатаОкончания = Параметры.ДатаОкончания;
	СписокПродавцов.ЗагрузитьЗначения(Параметры.МассивПродавцов);
	
	Если НЕ ЗначениеЗаполнено(ДатаНачала) Тогда
		ДатаНачала = НачалоМесяца(ДобавитьМесяц(ТекущаяДата(), -1));
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаОкончания) Тогда
		ДатаОкончания = НачалоМесяца(ДобавитьМесяц(ТекущаяДата(), -1));
	КонецЕсли;
	
КонецПроцедуры
