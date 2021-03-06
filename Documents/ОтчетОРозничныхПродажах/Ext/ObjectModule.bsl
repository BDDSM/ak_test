﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", НачалоДня(Дата));
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОтчетОРозничныхПродажах.Ссылка
	               |ИЗ
	               |	Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	               |ГДЕ
	               |	ОтчетОРозничныхПродажах.Ссылка <> &Ссылка
	               |	И ОтчетОРозничныхПродажах.Организация = &Организация
	               |	И НАЧАЛОПЕРИОДА(ОтчетОРозничныхПродажах.Дата, ДЕНЬ) = &Дата
	               |	И ОтчетОРозничныхПродажах.ПометкаУдаления = ЛОЖЬ";
				   
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Уже есть документ на данную дату по указанной организации",,,, Отказ);
	КонецЕсли;
	
	СуммаДокумента = Товары.Итог("Сумма");
	
КонецПроцедуры
