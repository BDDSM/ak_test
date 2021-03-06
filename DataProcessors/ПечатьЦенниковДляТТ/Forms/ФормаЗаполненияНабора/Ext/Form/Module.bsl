﻿
Функция ПолучитьМассивКВозврату_()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
	Запрос.УстановитьПараметр("ТТ", ТабТТ.Выгрузить().ВыгрузитьКолонку("СтруктурнаяЕдиница"));
	Запрос.УстановитьПараметр("Номенклатура", ТабТовары.Выгрузить().ВыгрузитьКолонку("Номенклатура"));
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТоварныйАссортиментТочекСрезПоследних.ТорговаяТочка,
	               |	ТоварныйАссортиментТочекСрезПоследних.Номенклатура,
	               |	ТоварныйАссортиментТочекСрезПоследних.Характеристика
	               |ИЗ
	               |	РегистрСведений.ТоварныйАссортиментТочек.СрезПоследних(&ТекДата, ) КАК ТоварныйАссортиментТочекСрезПоследних
	               |ГДЕ
	               |	ТоварныйАссортиментТочекСрезПоследних.ТорговаяТочка В (&ТТ)
	               |	И ТоварныйАссортиментТочекСрезПоследних.Номенклатура В (&Номенклатура)
	               |	И ТоварныйАссортиментТочекСрезПоследних.Выведена = ЛОЖЬ
	               |	И ТоварныйАссортиментТочекСрезПоследних.Запрещена = ЛОЖЬ";
				   
	ТабКеш = Запрос.Выполнить().Выгрузить();

	МассивВозврат = Новый Массив();
	Для Каждого СтрокаТТ Из ТабТТ Цикл
		Для Каждого СтрокаТовар Из ТабТовары Цикл
			СтрокиКеш = ТабКеш.НайтиСтроки(Новый Структура("ТорговаяТочка, Номенклатура", СтрокаТТ.СтруктурнаяЕдиница, СтрокаТовар.Номенклатура));
			СтруктураВозврат = Новый Структура("ТТ, Номенклатура, Характеристика", СтрокаТТ.СтруктурнаяЕдиница, СтрокаТовар.Номенклатура, Неопределено);
			Если СтрокиКеш.Количество() > 0 Тогда
				СтруктураВозврат.Характеристика = СтрокиКеш[0].Характеристика;
			КонецЕсли;	
			МассивВозврат.Добавить(СтруктураВозврат);
		КонецЦикла;	
	КонецЦикла;
	
	Возврат МассивВозврат;
	
КонецФункции	

Функция ПолучитьМассивКВозврату()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Товары", ТабТовары.Выгрузить().ВыгрузитьКолонку("Номенклатура"));
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка КАК Товар,
	               |	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика,
	               |	ВЫБОР
	               |		КОГДА ХарактеристикиНоменклатуры.СтатусАктивностиХарактеристики = ЗНАЧЕНИЕ(Перечисление.СтатусыАктивностиХарактеристик.Активна)
	               |			ТОГДА 0
	               |		КОГДА ХарактеристикиНоменклатуры.СтатусАктивностиХарактеристики = ЗНАЧЕНИЕ(Перечисление.СтатусыАктивностиХарактеристик.Выведена)
	               |			ТОГДА 1
	               |		КОГДА ХарактеристикиНоменклатуры.СтатусАктивностиХарактеристики = ЗНАЧЕНИЕ(Перечисление.СтатусыАктивностиХарактеристик.Новая)
	               |			ТОГДА 2
	               |	КОНЕЦ КАК Сортировка
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	               |		ПО Номенклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец
	               |			И (ХарактеристикиНоменклатуры.ПометкаУдаления = ЛОЖЬ
	               |				И ХарактеристикиНоменклатуры.Неактивная = ЛОЖЬ)
	               |ГДЕ
	               |	Номенклатура.Ссылка В(&Товары)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Товар,
	               |	Сортировка";
				   
	Выборка = Запрос.Выполнить().Выбрать();

	МассивВозврат = Новый Массив();
	Пока Выборка.СледующийПоЗначениюПоля("Товар") Цикл
		Пока Выборка.Следующий() Цикл
			СтруктураВозврат = Новый Структура("Номенклатура, Характеристика", Выборка.Товар, Выборка.Характеристика);
			МассивВозврат.Добавить(СтруктураВозврат);
			Прервать;
		КонецЦикла;	
	КонецЦикла;	
	
	Возврат МассивВозврат;
	
КонецФункции	

&НаКлиенте
Процедура Заполнить(Команда)
	
	ОповеститьОВыборе(ПолучитьМассивКВозврату());
	
КонецПроцедуры
