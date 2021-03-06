﻿
&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Задача.ПлановыйАссортимент.Наименование", СтрокаПоиска, ВидСравненияКомпоновкиДанных.Равно, ,
		ЗначениеЗаполнено(СтрокаПоиска), РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	Если ЗначениеЗаполнено(СтрокаПоиска) И Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Предупреждение("Данные не найдены!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрокаПоиска = "";
	СтрокаПоискаПриИзменении(Элемент);
	
КонецПроцедуры
