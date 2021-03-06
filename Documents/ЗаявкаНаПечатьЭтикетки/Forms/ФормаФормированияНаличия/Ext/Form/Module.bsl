﻿
&НаКлиенте
Процедура ЭтикеткиПеренестиПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Этикетки.ТекущиеДанные;
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Этикетка", ТекущиеДанные.Этикетка);
	СтруктураОтбора.Вставить("Товар", ТекущиеДанные.Товар);
	СтруктураОтбора.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	МассивСтрок = Этикетки.НайтиСтроки(СтруктураОтбора);
	ЗначениеФлажка = ТекущиеДанные.Перенести; 
	Для Каждого СтрокаМассива Из МассивСтрок Цикл
		СтрокаМассива.Перенести = ЗначениеФлажка;	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Перенести(Команда)
	Для Каждого СтрокаТЧ Из Этикетки Цикл
		Если СтрокаТЧ.Перенести Тогда
			СтруктураОтбора = Новый Структура;
			СтруктураОтбора.Вставить("ИндексСортировки", СтрокаТЧ.ИндексСортировки);
			МассивСтрок = ВладелецФормы.Объект.Этикетки.НайтиСтроки(СтруктураОтбора);
			Если МассивСтрок.Количество() Тогда
				МассивСтрок[0].КоличествоЗаказано = СтрокаТЧ.КоличествоЗаказано;
				МассивСтрок[0].ИзНаличия = Истина;
			Иначе
				НоваяСтрока = ВладелецФормы.Объект.Этикетки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ВладелецФормы.Объект.Этикетки.Сортировать("ИндексСортировки Возр");
	Закрыть();
КонецПроцедуры
