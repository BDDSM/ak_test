﻿
Процедура УстановитьВидимостьСпискаТТ()
	
	Элементы.ТорговаяТочка.Доступность 	= НЕ ЭтаФорма.ПоСпискуТТ;
	Элементы.ГруппаСписокТТ.Видимость 	= ЭтаФорма.ПоСпискуТТ;
	
	Если ЭтаФорма.ПоСпискуТТ Тогда
		Объект.ТорговаяТочка = Справочники.СтруктурныеЕдиницы.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьОтборУсловийРегламентныхРабот(ИмяКолонки, мЗначение, ТекстВидаСравнения = "Равно")
	
	ОтборНаФорме = ЭтаФорма.УсловияРегламентныхРаботВТТ.Отбор;
	
	ДоступноеПолеОтбора = ОтборНаФорме.ДоступныеПоляОтбора.Элементы.Найти(ИмяКолонки);
	Если ДоступноеПолеОтбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мПолеКомпоновки = ДоступноеПолеОтбора.Поле;
	
	ЕстьОтбор = Ложь;
	Для Каждого ЭлементОтбора Из ОтборНаФорме.Элементы Цикл
		Если ЭлементОтбора.ЛевоеЗначение = мПолеКомпоновки Тогда
			ЭлементОтбора.ПравоеЗначение	= мЗначение;
			ЭлементОтбора.Использование 	= ЗначениеЗаполнено(мЗначение);
			ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных[ТекстВидаСравнения];
			ЕстьОтбор = Истина;
		КонецЕсли;
	КонецЦикла;
	Если НЕ ЕстьОтбор Тогда
		ЭлементОтбора = ОтборНаФорме.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение 	= мПолеКомпоновки;
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных[ТекстВидаСравнения];
		ЭлементОтбора.Использование 	= ЗначениеЗаполнено(мЗначение);
		ЭлементОтбора.ПравоеЗначение 	= мЗначение;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьПараметрыВыбораТорговыхТочек()
	
	МассивПараметров = Новый Массив;
	мПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	Элементы.ТорговаяТочка.ПараметрыВыбора = мПараметрыВыбора;
	
	мПараметрВыбора = Новый ПараметрВыбора("Отбор.ПометкаУдаления"		, Ложь);
	МассивПараметров.Добавить(мПараметрВыбора);
	мПараметрВыбора = Новый ПараметрВыбора("Отбор.ТипСтруктурнойЕдиницы", ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.Розница"));
	МассивПараметров.Добавить(мПараметрВыбора);
	мПараметрВыбора = Новый ПараметрВыбора("Отбор.ТипРозничнойТочки"	, ПредопределенноеЗначение("Перечисление.ТипыРозничныхТочек.Магазин"));
	МассивПараметров.Добавить(мПараметрВыбора);
	Если НЕ ЭтаФорма.НеАктивныеТТ Тогда
		мПараметрВыбора = Новый ПараметрВыбора("Отбор.Активное"			, Истина);
	КонецЕсли;
	МассивПараметров.Добавить(мПараметрВыбора);
	
	мПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	Элементы.ТорговаяТочка.ПараметрыВыбора = мПараметрыВыбора;
	
КонецПроцедуры



&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПараметрыВыбораТорговыхТочек();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьВидимостьСпискаТТ();
	
	Объект.ДатаНачала 		= НачалоМесяца(ТекущаяДата());
	Объект.ДатаОкончания 	= КонецМесяца(ТекущаяДата());
	УстановитьОтборУсловийРегламентныхРабот("ДатаНачала"	, Объект.ДатаОкончания	, "МеньшеИлиРавно");
	УстановитьОтборУсловийРегламентныхРабот("ДатаОкончания"	, Объект.ДатаНачала		, "БольшеИлиРавно");
	
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();	
	
КонецПроцедуры


&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	УстановитьОтборУсловийРегламентныхРабот("ДатаНачала"	, Объект.ДатаОкончания	, "МеньшеИлиРавно");
	УстановитьОтборУсловийРегламентныхРабот("ДатаОкончания"	, Объект.ДатаНачала		, "БольшеИлиРавно");
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	УстановитьОтборУсловийРегламентныхРабот("ДатаНачала"	, Объект.ДатаОкончания	, "МеньшеИлиРавно");
	УстановитьОтборУсловийРегламентныхРабот("ДатаОкончания"	, Объект.ДатаНачала		, "БольшеИлиРавно");
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	УстановитьОтборУсловийРегламентныхРабот("Контрагент", Объект.Контрагент);
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	СтандартнаяОбработка = Ложь;
	
	ФормаВыбора = ПолучитьФорму("Справочник.Контрагенты.ФормаВыбора",, Элемент);
	ФормаВыбора.НачальноеЗначениеВыбора = Объект.Контрагент;
	
	ФормаВыбора.Отбор.ОказываетРегламентныеУслуги.Установить(Истина);
	
	ФормаВыбора.Открыть();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УслугаПриИзменении(Элемент)
	
	УстановитьОтборУсловийРегламентныхРабот("Услуга", Объект.Услуга);
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УслугаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	СтандартнаяОбработка = Ложь;
	
	ФормаВыбора = ПолучитьФорму("Справочник.Номенклатура.ФормаВыбора",, Элемент);
	ФормаВыбора.НачальноеЗначениеВыбора = Объект.Услуга;
	
	ФормаВыбора.Отбор.ВидНоменклатуры.Установить(Перечисления.ВидыНоменклатуры.Услуга);
	ФормаВыбора.ЭлементыФормы.СправочникСписок.НастройкаОтбора.ВидНоменклатуры.Доступность = Ложь;
	
	ФормаВыбора.Открыть();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ТорговаяТочкаПриИзменении(Элемент)
	
	УстановитьОтборУсловийРегламентныхРабот("ТорговаяТочка", Объект.ТорговаяТочка);
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ТорговаяТочкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	СтандартнаяОбработка = Ложь;
	
	ФормаВыбора = ПолучитьФорму("Справочник.СтруктурныеЕдиницы.ФормаВыбора",, Элемент);
	ФормаВыбора.НачальноеЗначениеВыбора = Объект.ТорговаяТочка;
	
	Если НЕ ЭтаФорма.НеАктивныеТТ Тогда
		ФормаВыбора.Отбор.Активное.Установить(Истина);
	КонецЕсли;
	
	ФормаВыбора.Отбор.ТипСтруктурнойЕдиницы.Установить(Перечисления.ТипыСтруктурныхЕдиниц.Розница);
	ФормаВыбора.ЭлементыФормы.СправочникСписок.НастройкаОтбора.ТипСтруктурнойЕдиницы.Доступность = Ложь;
	
	ФормаВыбора.Отбор.ТипРозничнойТочки.Установить(Перечисления.ТипыРозничныхТочек.Магазин);
	ФормаВыбора.ЭлементыФормы.СправочникСписок.НастройкаОтбора.ТипРозничнойТочки.Доступность = Ложь;
	
	ФормаВыбора.Открыть();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьРаботПриИзменении(Элемент)
	
	УстановитьОтборУсловийРегламентныхРабот("Периодичность", Объект.ПериодичностьРабот);
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();
	
КонецПроцедуры

Функция ПолучитьМассивТТ()
	
	Возврат ЭтаФорма.СписокТТ.Выгрузить(Новый Структура("Устанавливать", Истина)).ВыгрузитьКолонку("ТорговаяТочка");
	
КонецФункции

&НаКлиенте
Процедура ПоСпискуТТПриИзменении(Элемент)

	УстановитьВидимостьСпискаТТ();
	ЗаполнитьТТПоУмолчаниюСервер();
	
	мСписокТТ = Новый СписокЗначений;
	мСписокТТ.ЗагрузитьЗначения(ПолучитьМассивТТ());
	УстановитьОтборУсловийРегламентныхРабот("ТорговаяТочка", мСписокТТ, "ВСписке");
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура НеАктивныеТТПриИзменении(Элемент)
	
	УстановитьПараметрыВыбораТорговыхТочек();
	
КонецПроцедуры


&НаКлиенте
Процедура СписокТТУстановитьФлажки(Команда)

	Для Каждого СтрокаТаблицы Из ЭтаФорма.СписокТТ Цикл
		СтрокаТаблицы.Устанавливать = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТТСнятьФлажки(Команда)

	Для Каждого СтрокаТаблицы Из ЭтаФорма.СписокТТ Цикл
		СтрокаТаблицы.Устанавливать = Ложь;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьТТПоУмолчаниюСервер()
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Устанавливать,
	|	СпрСтруктурныеЕдиницы.Ссылка КАК ТорговаяТочка
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СпрСтруктурныеЕдиницы
	|ГДЕ
	|	СпрСтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
	|	И СпрСтруктурныеЕдиницы.ТипРозничнойТочки = ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.Магазин)
	|	И &УсловиеАктивное
	|	И НЕ СпрСтруктурныеЕдиницы.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	СпрСтруктурныеЕдиницы.id_TT";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеАктивное", ?(НЕ ЭтаФорма.НеАктивныеТТ, "И СпрСтруктурныеЕдиницы.Активное", ""));
	
	Запрос.Текст = ТекстЗапроса;
	
	ЭтаФорма.СписокТТ.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокТТ(Команда)

	Если ЭтаФорма.СписокТТ.Количество() > 0
			И Вопрос("Список торговых точек не пуст и будет заполнен. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТТПоУмолчаниюСервер();
	
	мСписокТТ = Новый СписокЗначений;
	мСписокТТ.ЗагрузитьЗначения(ПолучитьМассивТТ());
	УстановитьОтборУсловийРегламентныхРабот("ТорговаяТочка", мСписокТТ, "ВСписке");
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();
	
КонецПроцедуры


Процедура УстановитьУсловияДляСпискаТТСервер()
	
	мУсловия = РегистрыСведений.УсловияРегламентныхРаботВТТ;
	Для Каждого СтрокаТаблицы Из ЭтаФорма.СписокТТ Цикл
		Если НЕ СтрокаТаблицы.Устанавливать Тогда
			Продолжить;
		КонецЕсли;
		//МассивТТ.Добавить(СтрокаТаблицы.ТорговаяТочка);
		МенеджерЗаписи = мУсловия.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Контрагент		= Объект.Контрагент;
		МенеджерЗаписи.Услуга 			= Объект.Услуга;
		МенеджерЗаписи.ТорговаяТочка 	= СтрокаТаблицы.ТорговаяТочка;
		МенеджерЗаписи.ДатаНачала 		= Объект.НачислятьС;
		МенеджерЗаписи.ДатаОкончания	= Объект.НачислятьПо;
		МенеджерЗаписи.Периодичность	= Объект.ПериодичностьРабот;
		Попытка
			МенеджерЗаписи.Записать();
			Сообщить("Обработана " + СтрокаТаблицы.ТорговаяТочка);
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьУсловияДляСпискаТТ(Команда)
	
	УстановитьУсловияДляСпискаТТСервер();
	
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТТПриИзменении(Элемент)
	
	мСписокТТ = Новый СписокЗначений;
	мСписокТТ.ЗагрузитьЗначения(ПолучитьМассивТТ());
	УстановитьОтборУсловийРегламентныхРабот("ТорговаяТочка", мСписокТТ, "ВСписке");
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();
	
КонецПроцедуры


&НаКлиенте
Процедура УсловияРегламентныхРаботВТТПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ФормаНового = ПолучитьФорму("РегистрСведений.УсловияРегламентныхРаботВТТ.Форма.ФормаЗаписи",, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	ФормаНового.Запись.Контрагент		= Объект.Контрагент;
	ФормаНового.Запись.Услуга 			= Объект.Услуга;
	ФормаНового.Запись.ТорговаяТочка 	= Объект.ТорговаяТочка;
	ФормаНового.Запись.ДатаНачала 		= Объект.НачислятьС;
	ФормаНового.Запись.ДатаОкончания	= Объект.НачислятьПо;
	ФормаНового.Запись.Периодичность	= Объект.ПериодичностьРабот;
	
	ФормаНового.ОткрытьМодально();
	
	Элементы.УсловияРегламентныхРаботВТТ.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПланРеглРабот(Команда)
	
	РегламентныеЗаданияСервер.СформироватьПланРеглРаботВМагазинах();
	
КонецПроцедуры
