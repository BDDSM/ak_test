﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Параметры =  ЭтотОбъект.КомпоновщикНастроек.Настройки.ПараметрыДанных;
	Параметры.УстановитьЗначениеПараметра("СписаниеЗапасовПоСрокуДолгосрочный", Справочники.СтатьиДоходовРасходов.НайтиПоКоду("21307"));
	Параметры.УстановитьЗначениеПараметра("СписаниеЗапасовПоСрокуКраткосрочный", Справочники.СтатьиДоходовРасходов.НайтиПоКоду("21308"));
	
	ДокументРезультат.ФиксацияСлева = 1;
КонецПроцедуры
