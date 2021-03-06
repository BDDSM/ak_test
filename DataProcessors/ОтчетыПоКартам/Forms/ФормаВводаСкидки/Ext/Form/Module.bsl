﻿
&НаКлиенте
Процедура Принять(Команда)
	
	Закрыть(Новый Структура("МесяцНачисления, Процент, Комментарий", МесяцНачисления, ПроцентСкидки, Комментарий));
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокой()
	
	МесяцНачисленияСтрокой = Формат(МесяцНачисления, "ДФ='MMMM yyyy'");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//+++АК SHEP 2018.05.20 ИП-00018557.01
	Элементы.МесяцНачисления.РежимВыбораИзСписка = Истина;
	СписокМесяцыАкций = Обработки.ОтчетыПоКартам.СписокАкцийРазнообразноеПитание(Истина);
	
	СписокВыбораМесяцыАкций = Элементы.МесяцНачисления.СписокВыбора;
	Для Каждого ЭлементСпискаАкций Из СписокМесяцыАкций Цикл
		СписокВыбораМесяцыАкций.Добавить(Дата("" + ЭлементСпискаАкций.Значение + "01"), ЭлементСпискаАкций.Представление); //т.к. в формате ГГГГММ
	КонецЦикла;
	//---АК SHEP 2018.05.20
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//+++АК SHEP 2018.05.20 ИП-00018557.01
	//МесяцНачисления = НачалоМесяца(ТекущаяДата());
	//МесяцСтрокой();
	
	СписокВыбораМесяцыАкций = Элементы.МесяцНачисления.СписокВыбора;
	КвоАкций = СписокВыбораМесяцыАкций.Количество();
	Если КвоАкций > 0 Тогда
		ЭлементСпискаАкций = СписокВыбораМесяцыАкций.Получить(КвоАкций - 1);
		ИзмЭлементСпискаАкций(ЭлементСпискаАкций);
	КонецЕсли;
	//---АК SHEP 2018.05.20
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//+++АК SHEP 2018.05.20 ИП-00018557.01
	СписокВыбораМесяцыАкций = Элементы.МесяцНачисления.СписокВыбора;
	КвоАкций = СписокВыбораМесяцыАкций.Количество();
	Если КвоАкций > 0 Тогда
		ЭлементСпискаАкций = СписокВыбораМесяцыАкций.НайтиПоЗначению(МесяцНачисления);
		Если ЭлементСпискаАкций <> Неопределено Тогда
			ИндексТекАкции = СписокВыбораМесяцыАкций.Индекс(ЭлементСпискаАкций);
			Если Направление = 1 Тогда
				Если ИндексТекАкции + 1 = КвоАкций Тогда Возврат; КонецЕсли; // мы в самом верху списка
			ИначеЕсли Направление = -1 Тогда
				Если ИндексТекАкции = 0 Тогда Возврат; КонецЕсли; // мы в самом низу списка
			КонецЕсли;
			ЭлементСпискаАкций = СписокВыбораМесяцыАкций.Получить(ИндексТекАкции + Направление);
			ИзмЭлементСпискаАкций(ЭлементСпискаАкций);
		КонецЕсли;
	КонецЕсли;
	Возврат;
	//---АК SHEP 2018.05.20
	
	МесяцНачисления = ДобавитьМесяц(МесяцНачисления, Направление);
	МесяцСтрокой();
	
КонецПроцедуры

//+++АК SHEP 2018.05.20 ИП-00018557.01
&НаКлиенте
Процедура ИзмЭлементСпискаАкций(ЭлементСпискаАкций)
	МесяцНачисления = ЭлементСпискаАкций.Значение;
КонецПроцедуры
