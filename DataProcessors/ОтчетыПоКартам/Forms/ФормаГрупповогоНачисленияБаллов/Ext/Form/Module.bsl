﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТабДокБаллов.Область(1, 1, 1, 1).ШиринаКолонки = 40;
	ТабДокБаллов.Область(1, 1, 1, 1).Шрифт = Новый Шрифт(,, 10);
	ТабДокБаллов.Область(1, 1, 1, 1).Текст = "Номер карты";
	ТабДокБаллов.Область(1, 1, 1, 1).Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)
						, Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)
						, Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)
						, Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1));
						
	ТабДокБаллов.Область(1, 2, 1, 2).ШиринаКолонки = 40;
	ТабДокБаллов.Область(1, 2, 1, 2).Шрифт = Новый Шрифт(,, 10);
	ТабДокБаллов.Область(1, 2, 1, 2).Текст = "Колво баллов";
	ТабДокБаллов.Область(1, 2, 1, 2).Обвести(Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)
						, Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)
						, Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1)
						, Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1));					
	
КонецПроцедуры

&НаСервере
Процедура НачислитьНаСервере()
	
	лкТекДата = ТекущаяДата();
	Для н = 2 По ТабДокБаллов.ВысотаТаблицы Цикл
		Карта = СокрЛП(ТабДокБаллов.Область(н, 1, н, 1).Текст);
		Баллы = СокрЛП(ТабДокБаллов.Область(н, 2, н, 2).Текст);
		Баллы = СтрЗаменить(Баллы, Символы.НПП, "");
		Баллы = СтрЗаменить(Баллы, " ", "");
		Баллы = СтрЗаменить(Баллы, ".", ",");
		Если ЗначениеЗаполнено(Карта) Тогда
			Если СтрДлина(Карта) = 7 Тогда
				Попытка
					Баллы = Число(Баллы);
				Исключение
					Сообщить("Для карты " + Карта + " не удалось преобразовать количество баллов к числу");
					Продолжить;
				КонецПопытки;
				
				Обработки.ОтчетыПоКартам.НачислитьБаллыНаКарту(Карта, , Баллы, "Групповое начисление. " + ЦельНачисления);
								
			Иначе
				Сообщить("Карта " + Карта + " не удовлетворяет условию длины 7 символов");
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура Начислить(Команда)
	
	НачислитьНаСервере();
	Предупреждение("Обработка завершена");
	
КонецПроцедуры
