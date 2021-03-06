﻿
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЕдиницаПоКлассификатору"	, СтруктураДанные.Номенклатура.БазоваяЕдиницаИзмерения);
	Запрос.УстановитьПараметр("Номенклатура"			, СтруктураДанные.Номенклатура);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Владелец = &Номенклатура
	|	И НЕ ХарактеристикиНоменклатуры.Неактивная
	|	И НЕ ХарактеристикиНоменклатуры.ПометкаУдаления";
	ТабРезультат = Запрос.Выполнить().Выгрузить();
	Если ТабРезультат.Количество() = 1 Тогда
		СтруктураДанные.Характеристика = ТабРезультат[0].Характеристика;
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕдиницыИзмерения.Ссылка КАК ЕдиницаИзмерения
	|ИЗ
	|	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
	|ГДЕ
	|	ЕдиницыИзмерения.Владелец = &Номенклатура
	|	И ЕдиницыИзмерения.ЕдиницаПоКлассификатору = &ЕдиницаПоКлассификатору
	|	И НЕ ЕдиницыИзмерения.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтруктураДанные.Вставить("ЕдиницаИзмерения", Выборка.ЕдиницаИзмерения);
	КонецЕсли;
	
	Возврат СтруктураДанные;
	
КонецФункции

&НаСервере
Функция ПолучитьСЕ(мСклад)
	
	Возврат мСклад.Владелец;
	
КонецФункции	


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Автор 	= ПараметрыСеанса.ТекущийПользователь;
		Объект.Дата 	= ТекущаяДата();
		Если НЕ ЗначениеЗаполнено(Объект.СкладОтправитель) Тогда
			Объект.СкладОтправитель = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОсновнойСклад");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СкладОтправительПриИзменении(Элемент)
	
	Объект.СтруктурнаяЕдиница = ПолучитьСЕ(Объект.СкладОтправитель);
	Если ЗначениеЗаполнено(Объект.СкладПолучатель) Тогда
		Если НЕ ПолучитьСЕ(Объект.СкладПолучатель) = Объект.СтруктурнаяЕдиница Тогда
			Объект.СкладПолучатель = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Номенклатура"		, СтрокаТабличнойЧасти.Номенклатура);
	СтруктураДанные.Вставить("Характеристика"	, СтрокаТабличнойЧасти.Характеристика);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	СтрокаТабличнойЧасти.Характеристика		= СтруктураДанные.Характеристика;
	СтрокаТабличнойЧасти.ЕдиницаИзмерения 	= СтруктураДанные.ЕдиницаИзмерения;
	СтрокаТабличнойЧасти.Количество 		= 1;
	
КонецПроцедуры
