﻿
&НаКлиенте
Процедура ОсновноеСредствоПриИзменении(Элемент)
	
	ОбновитьСписок();
 	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОсновноеСредство = Параметры.ОсновноеСредство;
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("ОсновноеСредство",ОсновноеСредство);

КонецПроцедуры

Процедура ОбновитьСписок()
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("ОсновноеСредство",ОсновноеСредство);
    ЭтаФорма.Элементы.СписокДокументов.Обновить();
	
КонецПроцедуры	

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.СписокДокументов.ТекущиеДанные;
	ОткрытьЗначение(ТекущаяСтрока.Документ);
	
КонецПроцедуры
