﻿
&НаКлиенте
Процедура Сохранить(Команда)
	
	РежимСохранения = Истина;
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если РежимСохранения Тогда
		ЭтаФорма.ВладелецФормы.ДобавлениеТекстаЕЛУ = ТекстЕЛУ;
	КонецЕсли;
	
КонецПроцедуры
