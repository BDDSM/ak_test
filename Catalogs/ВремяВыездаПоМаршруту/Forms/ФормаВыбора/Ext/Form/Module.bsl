﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Маршрут") Тогда
		Выб=Справочники.ВремяВыездаПоМаршруту.Выбрать();

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	КвотаПеревозчикаСрезПоследних.ВременнойИнтервал,
			|	КвотаПеревозчикаСрезПоследних.ВременнойИнтервал.ВремяНачала КАК ВремяНачала,
			|	КвотаПеревозчикаСрезПоследних.ВременнойИнтервал.ВремяОкончания КАК ВремяОкончания
			|ИЗ
			|	РегистрСведений.КвотаПеревозчика.СрезПоследних(, Подрядчик = &Подрядчик) КАК КвотаПеревозчикаСрезПоследних";

		Запрос.УстановитьПараметр("Подрядчик", Параметры.Маршрут.Перевозчик);

		Результат = Запрос.Выполнить();

		ТЗВремя = Результат.Выгрузить();
        Сп=Новый СписокЗначений;
		Пока Выб.Следующий() Цикл
			Для каждого Стр Из ТЗВремя Цикл
				Если Выб.ВремяВыезда>=Стр.ВремяНачала и Выб.ВремяВыезда<=Стр.ВремяОкончания Тогда
					Сп.Добавить(Выб.Ссылка);
				КонецЕсли; 	
			КонецЦикла; 
		КонецЦикла;
		Элемент = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		Элемент.ПравоеЗначение = Сп;
		Элемент.Использование=Истина;
		                                                                                                
	КонецЕсли; 
	Если Параметры.Свойство("ВременнойИнтервал") Тогда
		Элемент = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВремяВыезда");
		Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;              
		Элемент.ПравоеЗначение = Параметры.ВременнойИнтервал.ВремяНачала;
		Элемент.Использование=Истина;
		
		Элемент = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВремяВыезда");
		Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;              
		Элемент.ПравоеЗначение = Параметры.ВременнойИнтервал.ВремяОкончания;
		Элемент.Использование=Истина;                                                          
		
	КонецЕсли; 
		
		
	Допустимые=Истина;
	Элементы.Допустимые.Доступность=Не РольДоступна("Перевозчик");
КонецПроцедуры

&НаКлиенте
Процедура ДопустимыеПриИзменении(Элемент)
	Для каждого Эл Из Список.Отбор.Элементы Цикл
		Эл.Использование=Допустимые;	
	КонецЦикла; 
КонецПроцедуры
