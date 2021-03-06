﻿
&НаКлиенте
Процедура ОбновитьСтатусы(Команда)
	ОбновитьСтатусыНаСервере() 
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусыНаСервере()
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект"); 
	//ОбработкаОбъект.ПроанализироватьТекущееСостояниеИПредпринятьДействия(ТекущаяДата());
	ТекСтатусы = ОбработкаОбъект.ПолучитьСтатусы(ТекущаяДата());
	Если ТекСтатусы <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ТекСтатусы);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПереодическоеЗадание = Справочники.ПериодическиеЗадания.НайтиПоНаименованию("Распределение для ИМ");
	Если ЗначениеЗаполнено(ПереодическоеЗадание) Тогда
		Авто = НЕ ПереодическоеЗадание.НеВыполнять;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетПоПланированию(Команда)
	ОткрытьФорму("Отчет.АнализПланированияПоИМ.Форма",,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьСтатусыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетИсполнениеЗаказовИМ(Команда)
	ОткрытьФорму("Отчет.ИсполнениеЗаказовИМ.Форма",,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройки(Команда)
	ОткрытьФорму("Обработка.РаспределениеИМ.Форма.ФормаНастроек",,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчет(Команда)
	ОткрытьФорму("Отчет.ОтчетИМ.Форма",,ЭтаФорма);
КонецПроцедуры
