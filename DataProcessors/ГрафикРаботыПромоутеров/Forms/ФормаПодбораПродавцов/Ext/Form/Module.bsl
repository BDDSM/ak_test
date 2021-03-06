﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивФизЛиц = ПолучитьИзВременногоХранилища(Параметры.Адрес);
	
	СписокЗначений.ЗагрузитьЗначения(МассивФизЛиц);
	СписокЗначений.ЗаполнитьПометки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	МассивПродавцов = Новый Массив;
	
	Для Каждого Строка Из СписокЗначений Цикл
		Если Строка.Пометка Тогда
			МассивПродавцов.Добавить(Строка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивПродавцов.Количество()>0 Тогда
		Закрыть(МассивПродавцов);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры
