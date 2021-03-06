﻿
&НаКлиенте
Процедура МаршрутыВремяВыездаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Парам=Новый Структура("Маршрут,ВременнойИнтервал",Элементы.Маршруты.ТекущиеДанные.Маршрут,Элементы.Маршруты.ТекущиеДанные.ВременнойИнтервал);                   
	ОткрытьФорму("Справочник.ВремяВыездаПоМаршруту.ФормаВыбора",Парам,Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Для каждого Стр Из ВладелецФормы.Объект.Маршруты Цикл
		Для каждого СтрТек Из Объект.Маршруты Цикл
			Если Стр.Маршрут=СтрТек.Маршрут И ЗначениеЗаполнено(СтрТек.ВремяВыезда) Тогда
				Стр.ВремяВыезда=СтрТек.ВремяВыезда;
				Стр.ВременнойИнтервал=СтрТек.ВременнойИнтервал;
				
				Стр.ТекущееВремяВыезда=СтрТек.ВремяВыезда;
				Стр.ТекущийВременнойИнтервал=СтрТек.ВременнойИнтервал;
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла; 
	Закрыть(Истина);
КонецПроцедуры


&НаКлиенте
Процедура МаршрутыПередУдалением(Элемент, Отказ)
	Отказ=Истина;
КонецПроцедуры

&НаКлиенте
Процедура МаршрутыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ=Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Для каждого Стр Из ВладелецФормы.Объект.Маршруты Цикл
		Если Стр.Перевозчик=Перевозчик И Стр.ТекущийВременнойИнтервал=ВременнойИнтервал Тогда
			ЗаполнитьЗначенияСвойств(Объект.Маршруты.Добавить(),Стр,,"ВременнойИнтервал,ВремяВыезда");
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перевозчик=Параметры.Перевозчик;
	ВременнойИнтервал=Параметры.ВременнойИнтервал;
КонецПроцедуры

&НаКлиенте
Процедура МаршрутыВременнойИнтервалНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Отбор=Новый Структура("Склад",ВладелецФормы.Объект.Склад);
	Парам=Новый Структура("Отбор",Отбор);                   
	ОткрытьФорму("Справочник.ВременныеИнтервалы.Форма.ФормаВыбора",Парам,Элемент);
КонецПроцедуры

&НаКлиенте
Процедура МаршрутыВремяВыездаПриИзменении(Элемент)
	Для каждого Стр Из Объект.Маршруты Цикл
		Если Стр.Маршрут=Элементы.Маршруты.ТекущиеДанные.Маршрут Тогда
			Стр.ВремяВыезда=Элементы.Маршруты.ТекущиеДанные.ВремяВыезда;
			Стр.ВременнойИнтервал=Элементы.Маршруты.ТекущиеДанные.ВременнойИнтервал;
		КонецЕсли; 	
	КонецЦикла; 
КонецПроцедуры
