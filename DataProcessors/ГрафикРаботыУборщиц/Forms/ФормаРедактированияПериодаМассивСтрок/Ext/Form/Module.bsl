﻿
&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	//+++АК mika 2018.07.17 ИП-00019185
	ЗаполнитьЦФОТорговыхТочек();
	//---АК mika

	СтруктураВозврата = Новый Структура;
	
	СтруктураВозврата.Вставить("Сотрудник"	, Сотрудник);
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("ТорговаяТочка"	 , Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ТЗ.Колонки.Добавить("КоличествоЧасов", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("ЦФО"	         , Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы")); //+++АК mika 2018.07.17 ИП-00019185
	
	Для Каждого Стр Из ТаблицаДанных Цикл
		ЗаполнитьЗначенияСвойств(ТЗ.Добавить(), Стр);
	КонецЦикла;
	
	СтруктураВозврата.Вставить("ТаблицаДанных", ТЗ);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Сотрудник")Тогда
		Сотрудник = Параметры.Сотрудник;
	КонецЕсли;
	
	Если Параметры.Свойство("ТаблицаДанных")Тогда
		ТаблицаДанных.Загрузить(Параметры.ТаблицаДанных);	
	КонецЕсли;
	
КонецПроцедуры

//+++АК mika 2018.07.17 ИП-00019185
&Насервере
Процедура ЗаполнитьЦФОТорговыхТочек();
	
	Запрос = Новый Запрос("Выбрать * ПОМЕСТИТЬ ВТ Из &ВременнаяТаблица Как ВременнаяТаблица");
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ВременнаяТаблица", ТаблицаДанных.Выгрузить());
	Запрос.Выполнить();
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница,
	|	МАКСИМУМ(ЦФОСтруктурныхЕдиницСрезПоследних.ЦФО) КАК ЦФО
	|ПОМЕСТИТЬ ВТ_ЦФО
	|ИЗ
	|	РегистрСведений.ЦФОСтруктурныхЕдиниц.СрезПоследних КАК ЦФОСтруктурныхЕдиницСрезПоследних
	|
	|СГРУППИРОВАТЬ ПО
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ.ТорговаяТочка,
	|	ВТ.КоличествоЧасов,
	|	ВТ_ЦФО.ЦФО
	|ИЗ
	|	ВТ КАК ВТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ЦФО КАК ВТ_ЦФО
	|		ПО ВТ.ТорговаяТочка = ВТ_ЦФО.СтруктурнаяЕдиница";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		ТаблицаДанных.Загрузить(Результат.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры
