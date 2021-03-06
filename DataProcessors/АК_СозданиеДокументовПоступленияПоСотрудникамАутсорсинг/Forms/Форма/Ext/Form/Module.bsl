﻿//+++АК SUVV 2018.02.28 ИП-00017941
//Функция ПолучитьСтатьюДРПоСтатьеДДС(мСтатьяДДС, мСчет)
//	
//	//
//	Результат = Неопределено;
//	
//	//
//	ТЗ = "ВЫБРАТЬ
//	     |	СоответствияСтатейСчетов.СтатьяДР,
//	     |	СоответствияСтатейСчетов.СтатьяДДС,
//	     |	СоответствияСтатейСчетов.Счет
//	     |ПОМЕСТИТЬ ТЗ
//	     |ИЗ
//	     |	РегистрСведений.СоответствияСтатейСчетов КАК СоответствияСтатейСчетов
//	     |ГДЕ
//	     |	СоответствияСтатейСчетов.СтатьяДДС = &СтатьяДДС
//	     |	И СоответствияСтатейСчетов.Счет = &Счет
//	     |	И НЕ СоответствияСтатейСчетов.Счет.Ссылка ЕСТЬ NULL 
//	     |
//	     |ОБЪЕДИНИТЬ ВСЕ
//	     |
//	     |ВЫБРАТЬ
//	     |	СоответствияСтатейСчетов.СтатьяДР,
//	     |	СоответствияСтатейСчетов.СтатьяДДС,
//	     |	СоответствияСтатейСчетов.Счет
//	     |ИЗ
//	     |	РегистрСведений.СоответствияСтатейСчетов КАК СоответствияСтатейСчетов
//	     |ГДЕ
//	     |	СоответствияСтатейСчетов.СтатьяДДС = &СтатьяДДС
//	     |	И СоответствияСтатейСчетов.Счет.Ссылка ЕСТЬ NULL 
//	     |	И ЛОЖЬ
//	     |;
//	     |
//	     |////////////////////////////////////////////////////////////////////////////////
//	     |ВЫБРАТЬ ПЕРВЫЕ 1
//	     |	ТЗ.СтатьяДР
//	     |ИЗ
//	     |	ТЗ КАК ТЗ";
//		 
//	//
//	ПЗ = Новый ПостроительЗапроса;
//	ПЗ.Текст = ТЗ;
//	
//	//
//	ПЗ.Параметры.Вставить("СтатьяДДС"	, мСтатьяДДС);
//	ПЗ.Параметры.Вставить("Счет"		, мСчет);
//	
//	//
//	ПЗ.Выполнить();
//	
//	//
//	Выборка = ПЗ.Результат.Выбрать();
//	Если Выборка.Следующий() Тогда
//		Результат = Выборка.СтатьяДР;
//	КонецЕсли; 
//	
//	//
//	Если НЕ ЗначениеЗаполнено(Результат) Тогда
//		Результат = мСтатьяДДС.ОсновнаяСтатьяДоходовРасходов;
//	КонецЕсли; 
//	
//	//
//	Возврат Результат;
//	
//КонецФункции
Функция ПолучитьСтатьюДРПоСтатьеДДС(ВыбДата, мСтатьяДДС, мСчет)
	
	Результат = Неопределено;
	
	ТЗ = "ВЫБРАТЬ
	     |	СоответствияСтатейСчетов.СтатьяДР,
	     |	СоответствияСтатейСчетов.СтатьяДДС,
	     |	СоответствияСтатейСчетов.Счет
	     |ПОМЕСТИТЬ ТЗ
	     |ИЗ
	     |	(ВЫБРАТЬ
	     |		СоответствияСтатейСчетовСрезПоследних.СтатьяДДС КАК СтатьяДДС,
	     |		СоответствияСтатейСчетовСрезПоследних.Счет КАК Счет,
	     |		МАКСИМУМ(СоответствияСтатейСчетовСрезПоследних.Период) КАК МаксПериод
	     |	ИЗ
	     |		РегистрСведений.СоответствияСтатейСчетов.СрезПоследних(
	     |				&ВыбДата,
	     |				СтатьяДДС = &СтатьяДДС
	     |					И Счет = &Счет) КАК СоответствияСтатейСчетовСрезПоследних
	     |	
	     |	СГРУППИРОВАТЬ ПО
	     |		СоответствияСтатейСчетовСрезПоследних.СтатьяДДС,
	     |		СоответствияСтатейСчетовСрезПоследних.Счет) КАК СчетаИСтатьиМаксПериод
	     |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствияСтатейСчетов КАК СоответствияСтатейСчетов
	     |		ПО СчетаИСтатьиМаксПериод.СтатьяДДС = СоответствияСтатейСчетов.СтатьяДДС
	     |			И СчетаИСтатьиМаксПериод.Счет = СоответствияСтатейСчетов.Счет
	     |			И СчетаИСтатьиМаксПериод.МаксПериод = СоответствияСтатейСчетов.Период
	     |
	     |ОБЪЕДИНИТЬ ВСЕ
	     |
	     |ВЫБРАТЬ
	     |	СоответствияСтатейСчетовСрезПоследних.СтатьяДР,
	     |	СоответствияСтатейСчетовСрезПоследних.СтатьяДДС,
	     |	СоответствияСтатейСчетовСрезПоследних.Счет
	     |ИЗ
	     |	РегистрСведений.СоответствияСтатейСчетов.СрезПоследних(
	     |			&ВыбДата,
	     |			СтатьяДДС = &СтатьяДДС
	     |				И Счет.Ссылка = NULL) КАК СоответствияСтатейСчетовСрезПоследних
	     |ГДЕ
	     |	ЛОЖЬ
	     |;
	     |
	     |////////////////////////////////////////////////////////////////////////////////
	     |ВЫБРАТЬ ПЕРВЫЕ 1
	     |	ТЗ.СтатьяДР
	     |ИЗ
	     |	ТЗ КАК ТЗ";
	
	ПЗ = Новый ПостроительЗапроса;
	ПЗ.Текст = ТЗ;
	
	ПЗ.Параметры.Вставить("СтатьяДДС"	, мСтатьяДДС);
	ПЗ.Параметры.Вставить("Счет"		, мСчет);
	ПЗ.Параметры.Вставить("ВыбДата"     , ВыбДата);
	
	ПЗ.Выполнить();
	
	Выборка = ПЗ.Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.СтатьяДР;
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Результат = мСтатьяДДС.ОсновнаяСтатьяДоходовРасходов;
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции	
//---АК SUVV

Функция ПолучитьЦФОТорговойТочки(мДата, мТорговаяТочка)

	//
	Результат = Новый Структура("ЦФО, Организация");
	
	//
	ТЗ = "ВЫБРАТЬ
	     |	ЦФОСтруктурныхЕдиницСрезПоследних.Период,
	     |	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница,
	     |	ЦФОСтруктурныхЕдиницСрезПоследних.ЦФО,
	     |	ЦФОСтруктурныхЕдиницСрезПоследних.Организация
	     |ИЗ
	     |	РегистрСведений.ЦФОСтруктурныхЕдиниц.СрезПоследних(&Дата, СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ЦФОСтруктурныхЕдиницСрезПоследних";
	
	//
	ПЗ = Новый ПостроительЗапроса;
	ПЗ.Текст = ТЗ;
	
	//
	ПЗ.Параметры.Вставить("Дата"				, мДата);
	ПЗ.Параметры.Вставить("СтруктурнаяЕдиница"	, мТорговаяТочка);
	
	//
	ПЗ.Выполнить();
	
	//
	Выборка = ПЗ.Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли; 
	
	//
	Возврат Результат;

КонецФункции

Функция ПолучитьСтатьюЗатратБухПоСтатьеДР(мСтатья, мСчет)
	
	//+++АК Susk (Суслин К.В.) 2018.01.22 ИП-00016321.01	   
	Возврат ОбщиеПроцедуры.ПолучитьСтатьюЗатратБухПоСтатьеДР("СтатьиЗатратБУ", мСтатья, мСчет);
 	
	//
	//Результат = Неопределено;
	//
	////
	//ТЗ = "ВЫБРАТЬ
	//     |	СоответствиеСтатейДРСтатьямБУ.СтатьяБУ
	//     |ИЗ
	//     |	РегистрСведений.СоответствиеСтатейДРСтатьямБУ КАК СоответствиеСтатейДРСтатьямБУ
	//     |ГДЕ
	//     |	СоответствиеСтатейДРСтатьямБУ.Статья = &Статья
	//     |	И СоответствиеСтатейДРСтатьямБУ.Счет = &Счет
	//     |	И СоответствиеСтатейДРСтатьямБУ.СтатьяБУ ССЫЛКА Справочник.СтатьиЗатратБУ";
	//	 
	////
	//ПЗ = Новый ПостроительЗапроса;
	//ПЗ.Текст = ТЗ;
	//
	////
	//ПЗ.Параметры.Вставить("Статья"	, мСтатья);
	//ПЗ.Параметры.Вставить("Счет"	, мСчет);
	//
	////
	//ПЗ.Выполнить();
	//
	////
	//Выборка = ПЗ.Результат.Выбрать();
	//Если Выборка.Следующий() Тогда
	//	Результат = Выборка.СтатьяБУ;
	//КонецЕсли; 
	//
	////
	//Возврат Результат;
	
	//---АК Susk (Суслин К.В.) 
	
КонецФункции	

Процедура УстановитьВидимостьТарифов()
	
	Элементы.Тарифы.Видимость = ЭтаФорма.ПоказыватьТарифы;
	
	Элементы.ТарифыКонтрагент.Видимость = Объект.Контрагент.Пустая();
	
КонецПроцедуры

Процедура УстановитьВидимостьОтчетПоФактРаботе()
	
	Элементы.ТабДокументОтчетПоФактРаботе.Видимость = ЭтаФорма.ПоказыватьОтчетПоФактическойРаботе;
	
КонецПроцедуры

Процедура УстановитьОтборТарифы()
	
	ПараметрыЗапроса = ЭтаФорма.Тарифы.Параметры;
	ПараметрыЗапроса.УстановитьЗначениеПараметра("ДатаНачала"				, Объект.ДатаНачала);
	ПараметрыЗапроса.УстановитьЗначениеПараметра("ЕстьОтборПоКонтрагенту"	, ?(Объект.Контрагент.Пустая(), 0, 1));
	ПараметрыЗапроса.УстановитьЗначениеПараметра("Контрагент"				, Объект.Контрагент);
	
КонецПроцедуры

Процедура ВывестиОтчетПоФактРаботе()
	
	ЭтаФорма.ТабДокументОтчетПоФактРаботе.Очистить();
	
	мСхемаКомпоновкиДанных = Отчеты.ОтчетПоФактическойРаботеСотрудниковАутсорсинг_Новый.ПолучитьМакет("ОтчетПоСтоимости");
	
	мНастройкиОтчета = мСхемаКомпоновкиДанных.ВариантыНастроек.Получить(0).Настройки;
	
	мПараметрыОтчета = мНастройкиОтчета.ПараметрыДанных;
	
	ПараметрКомпоновкиДатаНачала 	= Новый ПараметрКомпоновкиДанных("ДатаНачала");
	ПараметрКомпоновкиДатаОкончания = Новый ПараметрКомпоновкиДанных("ДатаОкончания");
	Для Каждого ЭлементПараметров Из мПараметрыОтчета.Элементы Цикл
		Если ЭлементПараметров.Параметр = ПараметрКомпоновкиДатаНачала Тогда
			ЭлементПараметров.Использование = Истина;
			ЭлементПараметров.Значение		= Объект.ДатаНачала;
		ИначеЕсли ЭлементПараметров.Параметр = ПараметрКомпоновкиДатаОкончания Тогда
			ЭлементПараметров.Использование = Истина;
			ЭлементПараметров.Значение		= Объект.ДатаОкончания;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ Объект.Контрагент.Пустая() Тогда
		мОтборОтчета = мНастройкиОтчета.Отбор;
		ПолеКомпоновкиКонтрагент 	= Новый ПолеКомпоновкиДанных("Контрагент");
		Для Каждого ЭлементПараметров Из мОтборОтчета.Элементы Цикл
			Если ЭлементПараметров.ЛевоеЗначение = ПолеКомпоновкиКонтрагент Тогда
				ЭлементПараметров.Использование 	= Истина;
				ЭлементПараметров.ПравоеЗначение	= Объект.Контрагент;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Макет компоновки
	мКомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	мМакетКомпоновки = мКомпоновщикМакета.Выполнить(мСхемаКомпоновкиДанных, мНастройкиОтчета);	
	
	// Компоновка данных
	мПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	мПроцессорКомпоновки.Инициализировать(мМакетКомпоновки);	
	
	// Вывод на форму
	мПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	мПроцессорВывода.УстановитьДокумент(ЭтаФорма.ТабДокументОтчетПоФактРаботе);
	мПроцессорВывода.Вывести(мПроцессорКомпоновки, Истина);
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.ДатаНачала 		= НачалоМесяца(ТекущаяДата());
	Объект.ДатаОкончания 	= КонецМесяца(ТекущаяДата());
	Объект.Организация		= Справочники.Организации.НайтиПоКоду("000000006"); // Вкусвилл
	
	УстановитьВидимостьТарифов();
	УстановитьВидимостьОтчетПоФактРаботе();
	
	УстановитьОтборТарифы();
	
КонецПроцедуры


&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	Если ЭтаФорма.ПоказыватьТарифы Тогда
		УстановитьОтборТарифы();
	КонецЕсли; 
	
	Если ЭтаФорма.ПоказыватьОтчетПоФактическойРаботе Тогда
		ВывестиОтчетПоФактРаботе();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	Если ЭтаФорма.ПоказыватьОтчетПоФактическойРаботе Тогда
		ВывестиОтчетПоФактРаботе();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если ЭтаФорма.ПоказыватьТарифы Тогда
		Элементы.ТарифыКонтрагент.Видимость = Объект.Контрагент.Пустая();
		УстановитьОтборТарифы();
	КонецЕсли; 
	
	Если ЭтаФорма.ПоказыватьОтчетПоФактическойРаботе Тогда
		ВывестиОтчетПоФактРаботе();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьТарифыПриИзменении(Элемент)
	
	Если ЭтаФорма.ПоказыватьТарифы Тогда
		Элементы.ТарифыКонтрагент.Видимость = Объект.Контрагент.Пустая();
		УстановитьОтборТарифы();
	КонецЕсли; 
	
	УстановитьВидимостьТарифов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьОтчетПоФактическойРаботеПриИзменении(Элемент)
	
	УстановитьВидимостьОтчетПоФактРаботе();
	
	Если ЭтаФорма.ПоказыватьОтчетПоФактическойРаботе Тогда
		ВывестиОтчетПоФактРаботе();
	КонецЕсли;
	
КонецПроцедуры


Функция ПолучитьУслугуПоДолжности(мДолжность)
	
	Если мДолжность = Справочники.ДолжностиВнештатныхСотрудников.НайтиПоНаименованию("Грузчик", Истина) Тогда
		Возврат Справочники.Номенклатура.НайтиПоНаименованию("Работы в торговом зале по обслуживанию покупателей");
	ИначеЕсли мДолжность = Справочники.ДолжностиВнештатныхСотрудников.НайтиПоНаименованию("Кассир", Истина) Тогда
		Возврат Справочники.Номенклатура.НайтиПоНаименованию("Работы в кассовой зоне магазина");
	Иначе
		Возврат Справочники.Номенклатура.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Процедура СоздатьДокументыСервер()
	
	Если Объект.ДокументыПоступления.Количество() > 0 Тогда
		Объект.ДокументыПоступления.Очистить();
	КонецЕсли;
	
	
	ЕстьКонтрагент = НЕ Объект.Контрагент.Пустая();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачала"		, Объект.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания"	, КонецДня(Объект.ДатаОкончания));
	Если ЕстьКонтрагент ТОгда
		Запрос.УстановитьПараметр("Контрагент"	, Объект.Контрагент);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТабСгруппированная.Контрагент КАК Контрагент,
	|	ТабСгруппированная.Должность КАК Должность,
	|	ТабСгруппированная.ТорговаяТочка КАК ТорговаяТочка,
	|	ЕСТЬNULL(ТарифыСотрудниковАутсорсинг.Тариф, 0) КАК Цена,
	|	СУММА((ВЫРАЗИТЬ(ТабСгруппированная.РазницаМинут / 60 КАК ЧИСЛО(2, 0))) + ВЫБОР
	|			КОГДА ТабСгруппированная.РазницаМинут + 10 < ((ВЫРАЗИТЬ(ТабСгруппированная.РазницаМинут / 60 КАК ЧИСЛО(2, 0))) + 1) * 60
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ) КАК Количество,
	|	СУММА(((ВЫРАЗИТЬ(ТабСгруппированная.РазницаМинут / 60 КАК ЧИСЛО(2, 0))) + ВЫБОР
	|			КОГДА ТабСгруппированная.РазницаМинут + 10 < ((ВЫРАЗИТЬ(ТабСгруппированная.РазницаМинут / 60 КАК ЧИСЛО(2, 0))) + 1) * 60
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ) * ЕСТЬNULL(ТарифыСотрудниковАутсорсинг.Тариф, 0)) КАК Сумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЖурналУчета.Контрагент КАК Контрагент,
	|		ЖурналУчета.ТорговаяТочка КАК ТорговаяТочка,
	|		ЖурналУчета.Сотрудник КАК Сотрудник,
	|		ЖурналУчета.Должность КАК Должность,
	|		НАЧАЛОПЕРИОДА(ЖурналУчета.ДатаОтметки, ДЕНЬ) КАК ДатаФакт,
	|		МИНИМУМ(ЖурналУчета.ДатаОтметки) КАК ВремяПришел,
	|		МАКСИМУМ(ЖурналУчета.ДатаОтметки) КАК ВремяУшел,
	|		ЧАС(МАКСИМУМ(ЖурналУчета.ДатаОтметки)) * 60 + МИНУТА(МАКСИМУМ(ЖурналУчета.ДатаОтметки)) - ЧАС(МИНИМУМ(ЖурналУчета.ДатаОтметки)) * 60 - МИНУТА(МИНИМУМ(ЖурналУчета.ДатаОтметки)) КАК РазницаМинут
	|	ИЗ
	|		РегистрСведений.ЖурналУчетаСотрудниковАутсорсинг КАК ЖурналУчета
	|	ГДЕ
	|		ЖурналУчета.ДатаОтметки МЕЖДУ &ДатаНачала И &ДатаОкончания
	|		И &УсловиеПоКонтрагенту
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ЖурналУчета.Контрагент,
	|		ЖурналУчета.ТорговаяТочка,
	|		ЖурналУчета.Сотрудник,
	|		ЖурналУчета.Должность,
	|		НАЧАЛОПЕРИОДА(ЖурналУчета.ДатаОтметки, ДЕНЬ)
	|	
	|	ИМЕЮЩИЕ
	|		НЕ МАКСИМУМ(ЖурналУчета.ДатаОтметки) < МИНИМУМ(ЖурналУчета.ДатаОтметки)) КАК ТабСгруппированная
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТарифыСотрудниковАутсорсинг.СрезПоследних(&ДатаНачала, &УсловиеПоКонтрагенту) КАК ТарифыСотрудниковАутсорсинг
	|		ПО (ТарифыСотрудниковАутсорсинг.Контрагент = ТабСгруппированная.Контрагент)
	|			И (ТарифыСотрудниковАутсорсинг.Должность = ТабСгруппированная.Должность)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТабСгруппированная.Контрагент,
	|	ТабСгруппированная.Должность,
	|	ТабСгруппированная.ТорговаяТочка,
	|	ЕСТЬNULL(ТарифыСотрудниковАутсорсинг.Тариф, 0)
	|
	|ИМЕЮЩИЕ
	|	НЕ СУММА(((ВЫРАЗИТЬ(ТабСгруппированная.РазницаМинут / 60 КАК ЧИСЛО(2, 0))) + ВЫБОР
	|				КОГДА ТабСгруппированная.РазницаМинут + 10 < ((ВЫРАЗИТЬ(ТабСгруппированная.РазницаМинут / 60 КАК ЧИСЛО(2, 0))) + 1) * 60
	|					ТОГДА 0
	|				ИНАЧЕ 1
	|			КОНЕЦ) * ЕСТЬNULL(ТарифыСотрудниковАутсорсинг.Тариф, 0)) = 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТабСгруппированная.Контрагент.Наименование,
	|	ТабСгруппированная.Должность.Наименование,
	|	ТабСгруппированная.ТорговаяТочка.НомерТочки
	|ИТОГИ ПО
	|	Контрагент,
	|	Должность";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеПоКонтрагенту", ?(ЕстьКонтрагент, "Контрагент = &Контрагент", "ИСТИНА"));
	
	Запрос.Текст = ТекстЗапроса;
	
	//
	ДокиПоступление = Документы.ПоступлениеТоваровУслуг;
	мВидОперацииПокупка 			= Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Покупка;
	мСтатусПринятыНаПроверку		= Перечисления.СтатусыПолученныхДокументов.ПринятыНаПроверку;
	мВидДоговораСПоставщиком		= Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком;
	СтатьяДДСОплатаУслугАутсорсинг 	= Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("120525");
	мСчетЗатрат 					= ПланыСчетов.Финансовый.ЗатратыТочекДляРаспределения; // 44.3
	Счет4401 						= ПланыСчетов.Хозрасчетный.НайтиПоКоду("44.01");
	СтрокаПериод = Формат(Объект.ДатаНачала, "ДЛФ=Д") + "-" + Формат(Объект.ДатаОкончания, "ДЛФ=Д");
	
	мДатаДокументов = КонецДня(Объект.ДатаОкончания);
	ВыборкаПоКонтрагентам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоКонтрагентам.Следующий() Цикл
		
		ТекКонтрагент 	= ВыборкаПоКонтрагентам.Контрагент;
		ТекДоговор 		= ДопМодульСервер.ПолучитьОсновнойДоговорКонтрагента(Объект.Организация, ТекКонтрагент,	мДатаДокументов, мВидДоговораСПоставщиком);
		
		ВыборкаПоДолжностям = ВыборкаПоКонтрагентам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоДолжностям.Следующий() Цикл
			
			//
			ДокПоступления = ДокиПоступление.СоздатьДокумент();
			ДокПоступления.Дата 		= мДатаДокументов;
			ДокПоступления.ВидОперации	= мВидОперацииПокупка;
			ДокПоступления.Организация 	= Объект.Организация;
			
			ДокПоступления.Контрагент 						= ТекКонтрагент;
			ДокПоступления.ДоговорКонтрагента 				= ТекДоговор;
			ДокПоступления.СтруктурнаяЕдиница				= ТекДоговор.СтруктурнаяЕдиница;
			ДокПоступления.СчетУчетаРасчетовСКонтрагентом 	= ТекДоговор.СчетУчетаРасчетовСКонтрагентом;
			ДокПоступления.ПроизвестиУплатуНДФЛ 			= ТекДоговор.УплачиватьНДФЛЗаКонтрагента;
			ДокПоступления.СтатьяДДС 						= ТекКонтрагент.СтатьяДвиженияДенежныхСредств;
			Если ДокПоступления.СтатьяДДС.Пустая() Тогда
				Если ТипЗнч(ТекДоговор.Субконто2) = Тип("СправочникСсылка.СтатьиДоходовРасходов")Тогда
					ДокПоступления.СтатьяДДС = ТекДоговор.Субконто2.ОсновнаяСтатьяДвиженияДенежныхСредств;
				КонецЕсли;
			КонецЕсли;
			
			Если ДокПоступления.СтатьяДДС.Пустая() Тогда
				ДокПоступления.СтатьяДДС = СтатьяДДСОплатаУслугАутсорсинг;
			КонецЕсли;
			Если ДокПоступления.СчетУчетаРасчетовСКонтрагентом.Пустая() Тогда
				//+++АК SUVV 2018.02.28 ИП-00017941
				//МассивСчетов = УправлениеДенежнымиСредствами.ПолучитьСчетРасчетовСКонтрагентом(ДокПоступления.СтатьяДДС);
				МассивСчетов = УправлениеДенежнымиСредствами.ПолучитьСчетРасчетовСКонтрагентом(ДокПоступления.Дата, ДокПоступления.СтатьяДДС);
				//---АК SUVV
				Если МассивСчетов.Количество() = 1 Тогда
					ДокПоступления.СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Финансовый.НайтиПоКоду(МассивСчетов[0]).Ссылка;
				Иначе
					ДокПоступления.СчетУчетаРасчетовСКонтрагентом = Планысчетов.Финансовый.РасчетыСПоставщиками;
				КонецЕсли;
			КонецЕсли;
			
			ДокПоступления.НеВыгружатьВБУ 				= Истина;
			ДокПоступления.СтатусПолученныхДокументов 	= мСтатусПринятыНаПроверку;
			ДокПоступления.НомерВходящегоДокумента 		= "аутсорсинг";
			ДокПоступления.ДатаВходящегоДокумента 		= мДатаДокументов;
			
			ТекСтавкаНДС = ТекКонтрагент.СтавкаНДС;
			ДокПоступления.ВариантРасчетаНДС 	= ?(ТекСтавкаНДС = Перечисления.СтавкиНДС.БезНДС, Перечисления.ВариантыРасчетаНДС.БезНДС, Перечисления.ВариантыРасчетаНДС.НДСвТомЧисле);
			ДокПоступления.Ответственный		= ПараметрыСеанса.ТекущийПользователь;
			
			ДокПоступления.Комментарий	= "Создан обработкой формирования начисления услуг по аутсорсингу " + СтрокаПериод;
			
			//
			//+++АК SUVV 2018.02.28 ИП-00017941
			//мСтатьяДР 	= ПолучитьСтатьюДРПоСтатьеДДС(ДокПоступления.СтатьяДДС, мСчетЗатрат);
			мСтатьяДР 	= ПолучитьСтатьюДРПоСтатьеДДС(ДокПоступления.Дата, ДокПоступления.СтатьяДДС, мСчетЗатрат);
			//---АК SUVV
			мСтатьяДРБУ = ПолучитьСтатьюЗатратБухПоСтатьеДР(мСтатьяДР, мСчетЗатрат);
			
			ТекНоменклатура = ПолучитьУслугуПоДолжности(ВыборкаПоДолжностям.Должность);
			
			ТЧУслуги = ДокПоступления.Услуги;
			Выборка = ВыборкаПоДолжностям.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				НоваяСтрока = ТЧУслуги.Добавить();
				НоваяСтрока.Номенклатура 	= ТекНоменклатура;
				НоваяСтрока.Количество 		= Выборка.Количество;
				НоваяСтрока.Цена 			= Выборка.Цена;
				НоваяСтрока.СтавкаНДС 		= ТекСтавкаНДС;
				ДокПоступления.ПосчитатьСуммуСтрокиТЧ(НоваяСтрока);
				НоваяСтрока.СчетЗатрат 		= мСчетЗатрат;
				НоваяСтрока.Субконто1		= Выборка.ТорговаяТочка;
				НоваяСтрока.Субконто2		= мСтатьяДР;
				НоваяСтрока.Субконто3		= ПолучитьЦФОТорговойТочки(мДатаДокументов, Выборка.ТорговаяТочка).ЦФО;
				НоваяСтрока.СчетЗатратБУ 	= Счет4401;
				НоваяСтрока.СубконтоБУ1		= мСтатьяДРБУ;
				НоваяСтрока.СчетЗатратНУ 	= НоваяСтрока.СчетЗатратБУ;
				НоваяСтрока.СубконтоНУ1		= мСтатьяДРБУ;
				НоваяСтрока.ТорговаяТочка 	= Выборка.ТорговаяТочка;
				НоваяСтрока.Содержание 		= СокрЛП(НоваяСтрока.Номенклатура.Наименование) + " за " + СтрокаПериод + " по " + Строка(Выборка.ТорговаяТочка);
				
			КонецЦикла;
			
			Попытка
				ДокПоступления.Записать();
				Сообщить("Создан документ " + ДокПоступления);
				НоваяСтрока = Объект.ДокументыПоступления.Добавить();
				НоваяСтрока.ДокументПоступления = ДокПоступления.Ссылка;
			Исключение
				Сообщить(ОписаниеОшибки());
			КонецПопытки;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументы(Команда)
	
	СоздатьДокументыСервер();
	
КонецПроцедуры
