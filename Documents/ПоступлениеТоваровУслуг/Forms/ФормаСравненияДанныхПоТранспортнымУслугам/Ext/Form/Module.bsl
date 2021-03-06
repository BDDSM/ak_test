﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("СсылкаНаДокумент",ДокументПТУ) Или Не ЗначениеЗаполнено(ДокументПТУ) Тогда		
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не выбран документ Поступление товаров и услуг";		
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуДокументов();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуДокументов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслугТранспортныеДокументы.Документ,
		|	МАКСИМУМ(ПоступлениеТоваровУслугТранспортныеДокументы.СуммаДокумента) КАК СуммаДокумента,
		|	МАКСИМУМ(ПоступлениеТоваровУслугТранспортныеДокументы.СуммаДопТарифа) КАК СуммаДопТарифа,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Получатель КАК ТорговаяТочка,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.Дата,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.ПричинаПеревозки
		|ПОМЕСТИТЬ ВТ_СписокМаршрутов
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.ТранспортныеДокументы КАК ПоступлениеТоваровУслугТранспортныеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛист.РасходныеОрдера КАК МаршрутныйЛистРасходныеОрдера
		|		ПО ПоступлениеТоваровУслугТранспортныеДокументы.Документ = МаршрутныйЛистРасходныеОрдера.Ссылка
		|ГДЕ
		|	ПоступлениеТоваровУслугТранспортныеДокументы.Ссылка = &ДокументПТУ
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоступлениеТоваровУслугТранспортныеДокументы.Документ,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Получатель,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.ПричинаПеревозки,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.Дата,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_СписокМаршрутов.Дата,
		|	ВТ_СписокМаршрутов.ТорговаяТочка,
		|	ВТ_СписокМаршрутов.Документ,
		|	ВТ_СписокМаршрутов.Маршрут,
		|	ВТ_СписокМаршрутов.ПричинаПеревозки,
		|	ЕСТЬNULL(СтоимостьУслугПоДоставкеТовараНаТТ.Ставка, 0) КАК Ставка,
		|	ЕСТЬNULL(СтоимостьУслугПоДоставкеТовараНаТТ.НаличиеДопТарифа, ЛОЖЬ) КАК НаличиеДопТарифа,
		|	ЕСТЬNULL(СтоимостьУслугПоДоставкеТовараНаТТ.СтавкаДопТарифа, 0) КАК СтавкаДопТарифа,
		|	ЕСТЬNULL(СтоимостьУслугПоДоставкеТовараНаТТ.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК Период,
		|	ВТ_СписокМаршрутов.СуммаДокумента,
		|	ВТ_СписокМаршрутов.СуммаДопТарифа
		|ПОМЕСТИТЬ ВТ_СтоимостьУслугДоставки
		|ИЗ
		|	ВТ_СписокМаршрутов КАК ВТ_СписокМаршрутов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтоимостьУслугПоДоставкеТовараНаТТ КАК СтоимостьУслугПоДоставкеТовараНаТТ
		|		ПО (ВТ_СписокМаршрутов.ПричинаПеревозки В (ЗНАЧЕНИЕ(Перечисление.ПричиныПеревозки.ПустаяСсылка), ЗНАЧЕНИЕ(Перечисление.ПричиныПеревозки.ОсновнаяПоставка)))
		|			И ВТ_СписокМаршрутов.ТорговаяТочка = СтоимостьУслугПоДоставкеТовараНаТТ.ТТ
		|			И ВТ_СписокМаршрутов.Маршрут = СтоимостьУслугПоДоставкеТовараНаТТ.Маршрут
		|			И ВТ_СписокМаршрутов.Дата > СтоимостьУслугПоДоставкеТовараНаТТ.Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_СтоимостьУслугДоставки.ТорговаяТочка,
		|	ВТ_СтоимостьУслугДоставки.Документ,
		|	ВТ_СтоимостьУслугДоставки.СтавкаДопТарифа КАК СуммаДопТарифаПоОтчету,
		|	ВЫБОР
		|		КОГДА ВТ_СтоимостьУслугДоставки.ПричинаПеревозки В (ЗНАЧЕНИЕ(Перечисление.ПричиныПеревозки.ПустаяСсылка), ЗНАЧЕНИЕ(Перечисление.ПричиныПеревозки.ОсновнаяПоставка))
		|			ТОГДА ВТ_СтоимостьУслугДоставки.Ставка
		|		ИНАЧЕ ЕСТЬNULL(ЦенаДопоставкиНаТТ.Сумма, 0)
		|	КОНЕЦ КАК СуммаПоОтчету,
		|	ВТ_СтоимостьУслугДоставки.СуммаДокумента,
		|	ВТ_СтоимостьУслугДоставки.СуммаДопТарифа,
		|	ВТ_СтоимостьУслугДоставки.Дата
		|ПОМЕСТИТЬ ВТ_Итоги
		|ИЗ
		|	ВТ_СтоимостьУслугДоставки КАК ВТ_СтоимостьУслугДоставки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦенаДопоставкиНаТТ КАК ЦенаДопоставкиНаТТ
		|		ПО (ЦенаДопоставкиНаТТ.Дата = НАЧАЛОПЕРИОДА(ВТ_СтоимостьУслугДоставки.Дата, ДЕНЬ))
		|			И (ЦенаДопоставкиНаТТ.Маршрут = ВТ_СтоимостьУслугДоставки.Маршрут)
		|			И (ЦенаДопоставкиНаТТ.ПричинаПеревозки = ВТ_СтоимостьУслугДоставки.ПричинаПеревозки)
		|			И (ЦенаДопоставкиНаТТ.ТорговаяТочка = ВТ_СтоимостьУслугДоставки.ТорговаяТочка)
		|ГДЕ
		|	(ВТ_СтоимостьУслугДоставки.ТорговаяТочка, ВТ_СтоимостьУслугДоставки.Маршрут, ВТ_СтоимостьУслугДоставки.Период) В
		|			(ВЫБРАТЬ
		|				ВТ_СтоимостьУслугДоставки.ТорговаяТочка,
		|				ВТ_СтоимостьУслугДоставки.Маршрут,
		|				МАКСИМУМ(ВТ_СтоимостьУслугДоставки.Период) КАК Период
		|			ИЗ
		|				ВТ_СтоимостьУслугДоставки КАК ВТ_СтоимостьУслугДоставки
		|			СГРУППИРОВАТЬ ПО
		|				ВТ_СтоимостьУслугДоставки.ТорговаяТочка,
		|				ВТ_СтоимостьУслугДоставки.Маршрут)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТ_СтоимостьУслугДоставки.ТорговаяТочка,
		|	ВТ_СтоимостьУслугДоставки.Документ,
		|	ВТ_СтоимостьУслугДоставки.СтавкаДопТарифа,
		|	ВЫБОР
		|		КОГДА ВТ_СтоимостьУслугДоставки.ПричинаПеревозки В (ЗНАЧЕНИЕ(Перечисление.ПричиныПеревозки.ПустаяСсылка), ЗНАЧЕНИЕ(Перечисление.ПричиныПеревозки.ОсновнаяПоставка))
		|			ТОГДА 0
		|		ИНАЧЕ ЕСТЬNULL(ЦенаДопоставкиНаТТ.Сумма, 0)
		|	КОНЕЦ,
		|	ВТ_СтоимостьУслугДоставки.СуммаДокумента,
		|	ВТ_СтоимостьУслугДоставки.СуммаДопТарифа,
		|	ВТ_СтоимостьУслугДоставки.Дата
		|ИЗ
		|	ВТ_СтоимостьУслугДоставки КАК ВТ_СтоимостьУслугДоставки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦенаДопоставкиНаТТ КАК ЦенаДопоставкиНаТТ
		|		ПО (ЦенаДопоставкиНаТТ.Дата = НАЧАЛОПЕРИОДА(ВТ_СтоимостьУслугДоставки.Дата, ДЕНЬ))
		|			И (ЦенаДопоставкиНаТТ.Маршрут = ВТ_СтоимостьУслугДоставки.Маршрут)
		|			И (ЦенаДопоставкиНаТТ.ПричинаПеревозки = ВТ_СтоимостьУслугДоставки.ПричинаПеревозки)
		|			И (ЦенаДопоставкиНаТТ.ТорговаяТочка = ВТ_СтоимостьУслугДоставки.ТорговаяТочка)
		|ГДЕ
		|	ВТ_СтоимостьУслугДоставки.Маршрут ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Итоги.Документ КАК Документ,
		|	МАКСИМУМ(ВТ_Итоги.СуммаДокумента) КАК СуммаДокумента,
		|	МАКСИМУМ(ВТ_Итоги.СуммаДопТарифа) КАК СуммаДопТарифа,
		|	СУММА(ВТ_Итоги.СуммаПоОтчету) КАК СуммаПоОтчету,
		|	СУММА(ВТ_Итоги.СуммаДопТарифаПоОтчету) КАК СуммаДопТарифаПоОтчету,
		|	ВТ_Итоги.Дата
		|ИЗ
		|	ВТ_Итоги КАК ВТ_Итоги
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_Итоги.Документ,
		|	ВТ_Итоги.Дата";
		
	
	Если ТолькоРазличающиеся Тогда
		Запрос.Текст = Запрос.Текст + "
		|
		|ИМЕЮЩИЕ
		|	МАКСИМУМ(ВТ_Итоги.СуммаДокумента) <> СУММА(ВТ_Итоги.СуммаПоОтчету)
		|		ИЛИ МАКСИМУМ(ВТ_Итоги.СуммаДопТарифа) <> СУММА(ВТ_Итоги.СуммаДопТарифаПоОтчету)";
	КонецЕсли;	
	
	Запрос.Текст = Запрос.Текст + "
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВТ_Итоги.Дата";
	
	Запрос.УстановитьПараметр("ДокументПТУ", ДокументПТУ);
	
	ТаблицаСравнения.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоРазличающиесяПриИзменении(Элемент)
	ЗаполнитьТаблицуДокументов();
КонецПроцедуры


