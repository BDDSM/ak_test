﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//+++АК sils 07.06.2018 ИП-00018876
	ОперацияАпдекс = APDEX_ОценкаПроизводительностиКлиентСервер.ПолучитьОперацию("Открытие документа Блокировка товаров для приемки");
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(ОперацияАпдекс);
	//---АК
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата=ТекущаяДата();
		Объект.Автор=ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПроизводительПриИзменении(Элемент)
	ПроизводительПриИзмененииСервер();
КонецПроцедуры

Процедура ПроизводительПриИзмененииСервер()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХарактеристикиНоменклатуры.Ссылка,
		|	ХарактеристикиНоменклатуры.Владелец
		|ИЗ
		|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО ХарактеристикиНоменклатуры.Ссылка = ЗначенияСвойствОбъектов.Объект
		|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
		|ГДЕ
		|	ХарактеристикиНоменклатуры.Владелец В(&Владелец)
		|	И ЗначенияСвойствОбъектов.Значение = &Значение";
	
	Запрос.УстановитьПараметр("Владелец", Объект.Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура"));
	Запрос.УстановитьПараметр("Значение",Объект.Производитель); 
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Для каждого Стр Из Объект.Товары Цикл
		Стр.Характеристика=Неопределено;
	КонецЦикла; 
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МасСтр=Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура",ВыборкаДетальныеЗаписи.Владелец));
		Для каждого Стр Из МасСтр Цикл
			Стр.Характеристика=ВыборкаДетальныеЗаписи.Ссылка;
		КонецЦикла; 
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	Элементы.Товары.ТекущиеДанные.Характеристика=ПолучитьХарактеристику(Элементы.Товары.ТекущиеДанные.Номенклатура);
КонецПроцедуры

Функция ПолучитьХарактеристику(Номенклатура)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХарактеристикиНоменклатуры.Ссылка,
		|	ХарактеристикиНоменклатуры.Владелец
		|ИЗ
		|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО ХарактеристикиНоменклатуры.Ссылка = ЗначенияСвойствОбъектов.Объект
		|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
		|ГДЕ
		|	ХарактеристикиНоменклатуры.Владелец =(&Владелец)
		|	И ЗначенияСвойствОбъектов.Значение = &Значение";
	
	Запрос.УстановитьПараметр("Владелец", Номенклатура);
	Запрос.УстановитьПараметр("Значение",Объект.Производитель); 
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	

КонецФункции // ()

//+++АК sils 07.06.2018 ИП-00018876
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(ОперацияАпдекс, ?(Параметры.Ключ.Пустая(), "Новый документ", "" + Объект.Ссылка));
КонецПроцедуры
 