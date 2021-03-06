﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ПодборВПоступление", ПодборВПоступление); 
	
	//---АК ZHAS 29-08-17 -- ИП-00016175.01
	Параметры.Свойство("ПодборВДопРасходы", ПодборВДопРасходы);
	Параметры.Свойство("ДокДопРасходов", ДокДопРасходов);
	//---АК ZHAS 29-08-17 -- ИП-00016175.01
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ПодборВПоступление И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Поступление) Тогда
		СтандартнаяОбработка = Ложь;
		Сообщить("По данному документу уже введено <" + Элемент.ТекущиеДанные.Поступление +  ">!", СтатусСообщения.Важное);
	КонецЕсли; 
	
	//---АК ZHAS 29-08-17 -- ИП-00016175.01
	
	Если ПодборВДопРасходы Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеДопРасходовНоменклатураДопОборудование.Предпоступление,
		|	ПоступлениеДопРасходовНоменклатураДопОборудование.Ссылка КАК ПоступлениеДопРасходов
		|ИЗ
		|	Документ.ПоступлениеДопРасходов.НоменклатураДопОборудование КАК ПоступлениеДопРасходовНоменклатураДопОборудование
		|ГДЕ
		|	ПоступлениеДопРасходовНоменклатураДопОборудование.Ссылка <> &ТекДокДопРасходов
		|	И ПоступлениеДопРасходовНоменклатураДопОборудование.Ссылка.Проведен
		//---АК ZHAS 01-09-17 -- ИП-00016175.01
		|	И ПоступлениеДопРасходовНоменклатураДопОборудование.Предпоступление = &ВыбранноеПредпоступление
		//---АК ZHAS 01-09-17 -- ИП-00016175.01
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоступлениеДопРасходовНоменклатураДопОборудование.Предпоступление,
		|	ПоступлениеДопРасходовНоменклатураДопОборудование.Ссылка";
		
		Запрос.УстановитьПараметр("ТекДокДопРасходов", ДокДопРасходов);
		
		//---АК ZHAS 01-09-17 -- ИП-00016175.01
		Запрос.УстановитьПараметр("ВыбранноеПредпоступление", ВыбраннаяСтрока);
		//---АК ZHAS 01-09-17 -- ИП-00016175.01
		
		РезЗапроса = Запрос.Выполнить();
		
		ЕстьОшибка = НЕ РезЗапроса.Пустой();
		
		РезЗапросаВыборка = РезЗапроса.Выбрать();
		
		Если ЕстьОшибка Тогда
			СтандартнаяОбработка = Ложь;
			Пока РезЗапросаВыборка.Следующий() Цикл
				Сообщить("По документу уже введено <" + РезЗапросаВыборка.ПоступлениеДопРасходов +  ">!", СтатусСообщения.Важное);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли; 

	//---АК ZHAS 29-08-17 -- ИП-00016175.01
	
КонецПроцедуры
