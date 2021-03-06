﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.ЗагрузитьЗначения(ПолныеПрава.ПолучитьМассивМагазинов());
	//Результ = ОткрытьФормуМодально("Справочник.СтруктурныеЕдиницы.ФормаВыбора", Новый Структура("РежимВыбора, ЗакрыватьПриВыборе", Истина, Истина));
	Результ = СписокВыбора.ВыбратьЭлемент("Выберите магазин");
	Если Результ <> Неопределено Тогда
		ПолныеПрава.УстановитьТекущийМагазин(Результ.Значение);
		Магазины_Клиент.УправлениеОкнамиМагазинов("Товародвижения");
		Магазины_Клиент.УправлениеОкнамиМагазинов("КассовыеОперации");
		УстановитьЗаголовокПриложения("Текущий магазин: " + Результ.Значение);
	Иначе
		УстановитьЗаголовокПриложения("Текущий магазин: <Не установлен>");
		ПолныеПрава.УстановитьТекущийМагазин(ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы.ПустаяСсылка"));
	КонецЕсли;
	
КонецПроцедуры
