﻿
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ВладелецФормы<>Неопределено Тогда
		Попытка
			МасСтр=ВладелецФормы.ОсновнаяТаблица.НайтиСтроки(Новый Структура("Сотрудник",Запись.Продавец));	
			Для каждого Эл Из МасСтр Цикл
				Эл.ПЧ=Запись.ПЧ;
				Эл.Статус=Запись.Статус;
			КонецЦикла; 
		Исключение
		КонецПопытки;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		Запись.Автор=ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли; 
	
	//+++АК mika 2018.10.04 ИП-00019755 Отображение Типа вахты
	Элементы.ПродавецТипВахтыВГрафике.Видимость = ЗначениеЗаполнено(Запись.Продавец) И 
			ЗначениеЗаполнено(ОбщегоНазначения.ПолучитьЗначениеРеквизита(Запись.Продавец, "ТипВахтыВГрафике"));	
	ЭтаФорма.Прочитать(); //При простом включении/отключении видимости не всегда меняется размер формы (иногда появляется полоса прокрутки).  		
	//---АК mika 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Модифицированность Тогда
		ТекущийОбъект.Автор=ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли; 
	Если ЗначениеЗаполнено(Запись.Статус)И НЕ ЗначениеЗаполнено(Запись.БлижайшийМагазин) Тогда
		Сообщить(НСтр("ru = 'Необходимо указать магазин!'"));
		Отказ=Истина;
	КонецЕсли; 
КонецПроцедуры
