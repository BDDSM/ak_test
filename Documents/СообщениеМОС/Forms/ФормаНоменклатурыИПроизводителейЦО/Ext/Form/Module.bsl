﻿
&НаКлиенте
Процедура ЗавершитьВвод(Команда)
	
	СтрРез = Новый Структура;
	СтрРез.Вставить("Номенклатура", Номенклатура);
	СтрРез.Вставить("Производители", Производители);
	
	Закрыть(СтрРез);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Номенклатура  = Параметры.Номенклатура;
	Производители = Параметры.Производители;
	
КонецПроцедуры
