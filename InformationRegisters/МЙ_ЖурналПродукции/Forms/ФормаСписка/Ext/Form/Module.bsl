﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ЭтоКопияБазы() Тогда
		Элементы.Список.ИзменятьСоставСтрок = Истина;
	КонецЕсли; 
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если Параметры.Свойство("GUID") Тогда
		Элементы.Список.ТекущаяСтрока = РегистрыСведений.МЙ_ЖурналПродукции.СоздатьКлючЗаписи(Новый Структура("GUID", Параметры.GUID));		
	КонецЕсли; 
	
	Если Параметры.Свойство("ПараметрыОтбора") Тогда
		Для Каждого КлючЗначение Из Параметры.ПараметрыОтбора Цикл
			ИзменилсяФильтр(КлючЗначение.Ключ, КлючЗначение.Значение);			
		КонецЦикла;  
	КонецЕсли; 
	
	Если Параметры.Свойство("ТолькоСОстатками") Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		ЭлементОтбора.Использование = Истина;	
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("volume");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
		ЭлементОтбора.ПравоеЗначение = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменилсяФильтр(ИмяПоля, Значение)
	
	ЭлементОтбора = Неопределено;
	
	ПолеОтбора = Новый ПолеКомпоновкиДанных(ИмяПоля);
	
	Для Каждого ТекущийЭлементОтбора Из Список.Отбор.Элементы Цикл
		Если ТекущийЭлементОтбора.ЛевоеЗначение = ПолеОтбора Тогда
			Если НЕ ЗначениеЗаполнено(Значение) ИЛИ ЭлементОтбора <> Неопределено Тогда
				ТекущийЭлементОтбора.Использование = Ложь;
			Иначе
				ЭлементОтбора = ТекущийЭлементОтбора;	
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;  
	
	Если ЗначениеЗаполнено(Значение) Тогда 
		Если ЭлементОтбора = Неопределено  Тогда
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = ПолеОтбора;
		КонецЕсли; 
		
		ЭлементОтбора.Использование = Истина;	
		
		Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;			
		Иначе
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;			
		КонецЕсли; 

		ЭлементОтбора.ПравоеЗначение = Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьОтбора(Команда)
	
	Элементы.ФормаИзменитьВидимостьОтбора.Пометка = НЕ Элементы.ФормаИзменитьВидимостьОтбора.Пометка;
	Элементы.Отбор.Видимость = НЕ Элементы.Отбор.Видимость;	
	
КонецПроцедуры
