﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ФормаСвязанныеДокументы = КритерииОтбора.СвязанныеДокументы.ПолучитьФорму();
	ФормаСвязанныеДокументы.ПараметрОтборПоЗначению = ПараметрКоманды;
	ФормаСвязанныеДокументы.Открыть();
КонецПроцедуры
