﻿
&НаКлиенте
Процедура ЗагрузитьРаспределение(Команда)
	
	//+++АК KIRN 2018.04.09 ИП-00018330 
	//ОткрытьФорму("Обработка.ЗагрузитьРаспределение.Форма.Форма");
	//ОткрытьФорму("Обработка.ЗагрузитьРаспределение.Форма.Форма", Новый Структура("Организация",ОтборОрганизация));
	//ОткрытьФорму("Обработка.Удалить_ЗагрузитьРаспределение.Форма.Форма", Новый Структура("Организация",ОтборОрганизация));
	ОткрытьФорму("Обработка.ЗагрузитьРаспределение1.Форма.Форма", Новый Структура("Организация",ОтборОрганизация));
	//---АК KIRN 
	
КонецПроцедуры

Процедура ОбновитьТорговыеТочки()
	
	Перем Запрос;
	
	Если ЭтаФорма.ТорговыеТочки.Количество() > 0 Тогда
		ЭтаФорма.ТорговыеТочки.Очистить();
	КонецЕсли;
	
	Если Элементы.СписокМаршрутов.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивМаршрутныхЛистов", Элементы.СписокМаршрутов.ВыделенныеСтроки);
	//+++АК KIRN 2018.04.05 ИП-00018330
	Запрос.УстановитьПараметр("ОтборПоОрганизации", ЗначениеЗаполнено(ОтборОрганизация));
	Запрос.УстановитьПараметр("Организация", ОтборОрганизация);
	//---АК KIRN 
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ВЗ_Запрос.ТорговаяТочка,
	|	ВЗ_Запрос.Порядок
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТЧТорговыеТочки.СтруктурнаяЕдиница КАК ТорговаяТочка,
	|		1 КАК Порядок
	|	ИЗ
	|		Документ.МаршрутныйЛист.ТорговыеТочки КАК ТЧТорговыеТочки
	|	ГДЕ
	|		ТЧТорговыеТочки.Ссылка В(&МассивМаршрутныхЛистов)
	//+++АК KIRN 2018.04.05  ИП-00018330
	|		И Выбор когда &ОтборПоОрганизации Тогда ТЧТорговыеТочки.Ссылка.Организация = &Организация Иначе Истина Конец
	//---АК KIRN 
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка),
	|		0) КАК ВЗ_Запрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВЗ_Запрос.Порядок,
	|	ВЗ_Запрос.ТорговаяТочка.Наименование";
	
	//Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	//			   |	ВЗ_Запрос.ТорговаяТочка,
	//			   |	ВЗ_Запрос.Порядок КАК Порядок
	//			   |ИЗ
	//			   |	(ВЫБРАТЬ
	//			   |		МаршрутныйЛистРасходныеОрдера.Документ.Получатель КАК ТорговаяТочка,
	//			   |		1 КАК Порядок
	//			   |	ИЗ
	//			   |		Документ.МаршрутныйЛист.РасходныеОрдера КАК МаршрутныйЛистРасходныеОрдера
	//			   |	ГДЕ
	//			   |		МаршрутныйЛистРасходныеОрдера.Ссылка В(&МассивМаршЛисты)
	//			   |		И МаршрутныйЛистРасходныеОрдера.Документ.Получатель ССЫЛКА Справочник.СтруктурныеЕдиницы
	//			   |		И МаршрутныйЛистРасходныеОрдера.Документ.Получатель <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	//			   |	
	//			   |	ОБЪЕДИНИТЬ ВСЕ
	//			   |	
	//			   |	ВЫБРАТЬ
	//			   |		ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка),
	//			   |		0) КАК ВЗ_Запрос
	//			   |
	//			   |УПОРЯДОЧИТЬ ПО
	//			   |	Порядок,
	//			   |	ВЗ_Запрос.ТорговаяТочка.Наименование";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаТаб = ТорговыеТочки.Добавить();
		СтрокаТаб.ТорговаяТочка = Выборка.ТорговаяТочка;    
	КонецЦикла;	
	
КонецПроцедуры	

Процедура ОбновитьРасходныеОрдера(ТекИдентификатор)
	
	ЭтаФорма.РасходныеОрдера.Очистить();
	
	Если ТекИдентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ТекДанные = ЭтаФорма.ТорговыеТочки.НайтиПоИдентификатору(ТекИдентификатор);
	
	Если ТекДанные = Неопределено
			ИЛИ НЕ ЗначениеЗаполнено(Элементы.СписокМаршрутов.ТекущаяСтрока) Тогда
		Возврат;
	КонецЕсли;
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивМаршрутныхЛистов"	, Элементы.СписокМаршрутов.ВыделенныеСтроки);
	Запрос.УстановитьПараметр("ТорговаяТочка"			, ТекДанные.ТорговаяТочка);
	Запрос.УстановитьПараметр("Склад"					, ЭтаФорма.ОтборСклад);
				   
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТЧРасходныеОрдера.Документ КАК РасходныйОрдер,
	|	ДокументРО.Статус КАК Статус,
	|	ДокументРО.Склад КАК Склад
	|ИЗ
	|	Документ.МаршрутныйЛист.РасходныеОрдера КАК ТЧРасходныеОрдера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйОрдерСклад КАК ДокументРО
	|		ПО (ДокументРО.Ссылка = ТЧРасходныеОрдера.Документ)
	|			И (ДокументРО.Получатель = &ТорговаяТочка
	|				ИЛИ &ТорговаяТочка = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))
	|			И (ДокументРО.Склад = &Склад
	|				ИЛИ &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|			И (НЕ ДокументРО.ПометкаУдаления)
	|			И (НЕ ТЧРасходныеОрдера.Ссылка.ПометкаУдаления)
	|ГДЕ
	|	ТЧРасходныеОрдера.Ссылка В(&МассивМаршрутныхЛистов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТЧРасходныеОрдера.Ссылка,
	|	ТЧРасходныеОрдера.НомерСтроки";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаТаб = ЭтаФорма.РасходныеОрдера.Добавить();
		СтрокаТаб.РасходныйОрдер 	= Выборка.РасходныйОрдер;    
		СтрокаТаб.Статус 			= Выборка.Статус;
		СтрокаТаб.СКлад 			= Выборка.Склад;
	КонецЦикла;	
	
КонецПроцедуры	

Функция ПолучитьМассивКПечати(ИзПакетнойПечати = Ложь)
	
	МассивДокументов = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.РасходныеОрдера.ВыделенныеСтроки Цикл
		СтрокаТаб = РасходныеОрдера.НайтиПоИдентификатору(ВыделеннаяСтрока);
		//+++АК KIRN 2018.04.11 ИП-00018330      
		ЕСли СтрокаТаб.РасходныйОрдер.Организация = ОтборОрганизация Тогда
			МассивДокументов.Добавить(СтрокаТаб.РасходныйОрдер);
		КонецЕсли;
		//---АК KIRN 
	КонецЦикла;	
	
	Возврат МассивДокументов;
	
КонецФункции

Функция ПолучитьМассивКУстановкеСтатуса(СтатусСтрока)
	
	МассивДокументов = Новый Массив;
	Для Каждого СтрокаТабИдентификатор Из Элементы.РасходныеОрдера.ВыделенныеСтроки Цикл
		СтрокаТаб = РасходныеОрдера.НайтиПоИдентификатору(СтрокаТабИдентификатор);
		МассивДокументов.Добавить(СтрокаТаб.РасходныйОрдер);
	КонецЦикла;
	
	Возврат МассивДокументов;
	
КонецФункции

Процедура СортировкаРОПоМаршрутамИТТ(МассивДокументов)
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МаршрутныйЛистРасходныеОрдера.Документ
	|ИЗ
	|	Документ.МаршрутныйЛист.РасходныеОрдера КАК МаршрутныйЛистРасходныеОрдера
	|ГДЕ
	|	МаршрутныйЛистРасходныеОрдера.Документ В(&МассивДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.ПорядокСортировки,
	|	МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.Наименование,
	|	МаршрутныйЛистРасходныеОрдера.Документ.Получатель.Код";
	
	МассивДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Документ");
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//+++АК KIRN 2018.04.09 ИП-00018330
	ЭтаФорма.ОтборОрганизация = Справочники.Организации.НайтиПоРеквизиту("ИНН", "7734675810");
	//---АК KIRN 
	
	Если ЭтаФорма.ОтборСтруктурнаяЕдиница.Пустая() Тогда
		ЭтаФорма.ОтборСтруктурнаяЕдиница = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОсновноеСтруктурноеПодразделение");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭтаФорма.СписокМаршрутов.Отбор, "СтруктурноеПодразделение", ЭтаФорма.ОтборСтруктурнаяЕдиница,,,
															ЗначениеЗаполнено(ЭтаФорма.ОтборСтруктурнаяЕдиница));
															
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписанМаршрутныйЛист" Тогда
		
		Элементы.СписокМаршрутов.Обновить();
		
		ОбновитьТорговыеТочки();
		//ОбновитьРасходныеОрдера();
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Процедура СписокМаршрутовПриАктивизацииСтроки(Элемент)
	
	ОбновитьТорговыеТочки();
	//ОбновитьРасходныеОрдера();
	
КонецПроцедуры

&НаКлиенте
Процедура ТорговыеТочкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ТорговыеТочки.НайтиПоИдентификатору(ВыбраннаяСтрока).ТорговаяТочка) Тогда
		ОткрытьЗначение(ТорговыеТочки.НайтиПоИдентификатору(ВыбраннаяСтрока).ТорговаяТочка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТорговыеТочкиПриАктивизацииСтроки(Элемент)
	
	ОбновитьРасходныеОрдера(Элементы.ТорговыеТочки.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходныеОрдераВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(РасходныеОрдера.НайтиПоИдентификатору(ВыбраннаяСтрока).РасходныйОрдер);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьРасходныхОрдеров(Команда)
	      
	Если НЕ ЗначениеЗаполнено(ОтборОрганизация) ТОгда
		Сообщить("Не заполнена организация");
		Возврат;		
	КонецЕСли;
	
	МассивДокументов = ПолучитьМассивКПечати();
	Если МассивДокументов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	Ответ = Вопрос("После печати документам будет установлен статус ""В сборке"". Продолжить?", РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;	
	
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("Маршрутные листы. Печать расходных ордеров");
	ТабДок = ЗначениеИзСтрокиВнутрСервер(МассивДокументов);
	ТабДок.ОтображатьСетку 		= Ложь;
	ТабДок.ОтображатьЗаголовки 	= Ложь;
	ТабДок.ТолькоПросмотр 		= Истина;
	ТабДок.Показать("Расходные ордера");
	APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени("Маршрутные листы. Печать расходных ордеров", Строка(ОтборСклад));
	
	ОбновитьРасходныеОрдера(Элементы.ТорговыеТочки.ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Функция ЗначениеИзСтрокиВнутрСервер(МассивДокументов)
	
	СортировкаРОПоМаршрутамИТТ(МассивДокументов);
	
	Возврат ЗначениеИзСтрокиВнутр(ПечатьРасходныхОрдеровСервер(МассивДокументов).Получить());
	
КонецФункции

&НаСервере
Функция ПечатьРасходныхОрдеровСервер(МассивДокументов)
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Для Каждого ЭлементМассива Из МассивДокументов Цикл
		Если ТабДокумент.ВысотаТаблицы > 0 Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;	
		ТабДок = Документы.РасходныйОрдерСклад.ПечатьРасходныйОрдер_Товары(ЭлементМассива);
		ТабДокумент.Вывести(ТабДок);
	КонецЦикла;	
	
	Возврат Новый ХранилищеЗначения(ЗначениеВСтрокуВнутр(ТабДокумент), Новый СжатиеДанных(9));
	
КонецФункции

&НаСервере
Процедура УстановитьСтатусСервер(МассивДокументов, СтатусСтрока)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ЭлементДокумент Из МассивДокументов Цикл
		ДокОбъект = ЭлементДокумент.ПолучитьОбъект();
		Если СтатусСтрока = "НеОбработан" Тогда
			ДокОбъект.Статус = Перечисления.СтатусыРасходныхОрдеров.НеОбработан;
		ИначеЕсли СтатусСтрока = "ВСборке" Тогда
			//+++АК SHEP 20160609: статус ВСборке присваиваем при печати РО
			Если НЕ ТипЗнч(ДокОбъект) = Тип("ДокументОбъект.РасходныйОрдерСклад") Тогда
				Продолжить;
			КонецЕсли;
			//---АК SHEP 20160609
			ДокОбъект.Статус = Перечисления.СтатусыРасходныхОрдеров.ВСборке;	
		КонецЕсли;	
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;	
	
КонецПроцедуры	

//+++АК Vert 2018.12.20 без задания
&НаКлиенте
Процедура УстановитьСтатусНеОбработан(Команда)
	
	МассивДокументов = ПолучитьМассивКУстановкеСтатуса("НеОбработан");
	Если МассивДокументов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	Ответ = Вопрос("Документам в выделенных строках будет установлен статус ""Не обработан"". Продолжить?", РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	//
	УстановитьСтатусСервер(МассивДокументов, "НеОбработан");
	
	ОбновитьРасходныеОрдера(Элементы.ТорговыеТочки.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусВСборке(Команда)
	
	МассивДокументов = ПолучитьМассивКУстановкеСтатуса("ВСборке");
	Если МассивДокументов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	Ответ = Вопрос("Документам в выделенных строках будет установлен статус ""В сборке"". Продолжить?", РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;	
	
	УстановитьСтатусСервер(МассивДокументов, "ВСборке");
	
	ОбновитьРасходныеОрдера(Элементы.ТорговыеТочки.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтруктурнаяЕдиницаПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокМаршрутов.Отбор, "СтруктурноеПодразделение", ОтборСтруктурнаяЕдиница,,, ЗначениеЗаполнено(ОтборСтруктурнаяЕдиница));
	
КонецПроцедуры

//+++АК Vert 2018.12.20 без задания
&НаКлиенте
Процедура ПакетнаяПечать(Команда)
	
	МассивДокументов = ПолучитьМассивКУстановкеСтатуса("");
	Если МассивДокументов.Количество() = 0 Тогда
		Сообщить("Нет данных для печати");
		Возврат;
	КонецЕсли;	
	
	Ответ = Неопределено;
	
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ПакетнаяПечатьЗавершение", ЭтаФорма, Новый Структура("МассивДокументов", МассивДокументов)), "Документам в выделенных строках будет установлен статус ""В сборке"". Продолжить?", РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);	
	
КонецПроцедуры

//+++АК Vert 2018.12.20 без задания
&НаКлиенте
Процедура ПакетнаяПечатьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	МассивДокументов = ДополнительныеПараметры.МассивДокументов;	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	СортировкаРОПоМаршрутамИТТ(МассивДокументов);	
	
	// Формирование параметров для вызова фонового задания.
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения	= Истина;
	ПараметрыОжидания.ТекстСообщения				= "Перевод документов в статус в Сборке по складу " + Строка(ОтборСклад);
	ПараметрыОжидания.ОповещениеПользователя.Показать	= Истина;
	ПараметрыОжидания.ОповещениеПользователя.Пояснение	= "Завершена загрузка распределения по складу "+ Строка(ОтборСклад);	
	ДлительнаяОперация = УстановитьСтатусВСборкеДляРОСервер(МассивДокументов);	
	
	СтруктураОткрытия = Новый Структура("РасходныеОрдера", МассивДокументов);
	ОткрытьФормуМодально("Обработка.МаршрутныеЛисты.Форма.ФормаВыбораВидаПечатныхФорм", СтруктураОткрытия, ЭтаФорма);
	
	// Ожидание фонового задания
	Описание = Новый ОписаниеОповещения("УстановкаСтатусовЗавершение",ЭтаФорма);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Описание, ПараметрыОжидания);

КонецПроцедуры

//+++АК Vert 2018.12.20 без задания
&НаСервере
Функция УстановитьСтатусВСборкеДляРОСервер(МассивДокументов)

	ИмяМетода = "Обработки.МаршрутныеЛисты.УстановитьСтатусСервер";
	НаименованиеЗадания = "Установка статуса собран по складу "+ Строка(ОтборСклад);
	
	ПараметрыЗадания = Новый Структура("МассивДокументов, Статус", МассивДокументов, Перечисления.СтатусыРасходныхОрдеров.ВСборке);	
	
	// Запуск фонового задания
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыЗадания, ПараметрыВыполнения);

КонецФункции

//+++АК Vert 2018.12.20 без задания
&НаКлиенте
Процедура УстановкаСтатусовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Оповестить("Установлен признак в сборке");
	
	Если Результат.Статус = "Выполнено" Тогда
		Если Результат.Сообщения <> Неопределено Тогда
			Для Каждого Сообщение Из Результат.Сообщения Цикл
				Сообщение.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
		Если РезультатВыполнения.Количество() > 0 Тогда 
			Для Каждого НеПроведенныйДокумент Из РезультатВыполнения Цикл 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ не переведен в сборку: " + Строка(НеПроведенныйДокумент));
			КонецЦикла;;
		КонецЕсли;
		
		ОбновитьРасходныеОрдера(Элементы.ТорговыеТочки.ТекущаяСтрока);
		
	КонецЕсли;

КонецПРоцедуры

&НаСервере
Процедура ЗадатьФорматСтрок(ТабДок)

	лкКоличествоСтрок 	= ТабДок.ВысотаТаблицы;
	лкКоличествоКолонок = ТабДок.ШиринаТаблицы;
	лкШирина1 = "";
	лкШирина2 = "";
	лкСтрока1 = 0;
	лкСтрока2 = 0;
	Для лкСтр=1 По лкКоличествоСтрок Цикл
		
		лкШирина2 = "";
		Для лкКол=1 По лкКоличествоКолонок Цикл
			лкШирина2 = лкШирина2 + "," + ТабДок.Область(лкСтр,лкКол).ШиринаКолонки;
		КонецЦикла; 
		Если лкШирина1 = лкШирина2 Тогда
			лкСтрока2 = лкСтрока2 + 1;
		Иначе
			Если лкСтрока1 <> 0 Тогда
				ТабДок.Область(лкСтрока1,,лкСтрока2).СоздатьФорматСтрок();
			КонецЕсли;
			лкШирина1 = лкШирина2;
			лкСтрока1 = лкСтр;
			лкСтрока2 = лкСтр;
		КонецЕсли;
		
	КонецЦикла; 
	
	Если лкСтрока1 <> 0 Тогда
		ТабДок.Область(лкСтрока1,,лкСтрока2).СоздатьФорматСтрок();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладПриИзменении(Элемент)
	
	ОбновитьРасходныеОрдера(Элементы.ТорговыеТочки.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьШКПаллет(Команда)
	
	МассивДокументов = Новый Массив;
	//Для Каждого СтрокаТаб Из РасходныеОрдера Цикл
	//	МассивДокументов.Добавить(СтрокаТаб.РасходныйОрдер);
	//КонецЦикла;
	Для Каждого ВыделеннаяСтрока Из Элементы.РасходныеОрдера.ВыделенныеСтроки Цикл
		СтрокаТаб = РасходныеОрдера.НайтиПоИдентификатору(ВыделеннаяСтрока);
		МассивДокументов.Добавить(СтрокаТаб.РасходныйОрдер);
	КонецЦикла;
	
	ОткрытьФорму("Обработка.ФормированиеШтрихКодаПаллеты.Форма.Форма", Новый Структура("МассивРасходники", МассивДокументов));
	
КонецПроцедуры

Функция ПолучитьТабличныйДокументМаршрутных()
	
	ТабДок = Новый ТабличныйДокумент;
	
	МассивДоки = Новый Массив;
	
	//АК БЕЛН 20.03.17+
	Если ПоПеревозчику Тогда

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Дата1"		, ЭтаФорма.ДатаМарш);
		Запрос.УстановитьПараметр("Дата2"		, КонецДня(ЭтаФорма.ДатаМарш));
		Запрос.УстановитьПараметр("Перевозчик"	, ЭтаФорма.Перевозчик);
		Запрос.УстановитьПараметр("СтруктурноеПодразделение"	, ЭтаФорма.ОтборСтруктурнаяЕдиница);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	МаршрутныйЛист.Ссылка
		|ИЗ
		|	Документ.МаршрутныйЛист КАК МаршрутныйЛист
		|ГДЕ
		|	МаршрутныйЛист.Дата МЕЖДУ &Дата1 И &Дата2
		|	И МаршрутныйЛист.Перевозчик = &Перевозчик
		|	И МаршрутныйЛист.Проведен
		|	И (МаршрутныйЛист.СтруктурноеПодразделение = &СтруктурноеПодразделение ИЛИ &СтруктурноеПодразделение=Значение(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))";
		Выборка = Запрос.Выполнить().Выбрать();

		Пока Выборка.Следующий() Цикл
			Если ТабДок.ВысотаТаблицы > 0 Тогда
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;	
			ТабДокМаршрут = Документы.МаршрутныйЛист.СформироватьМаршрутныйЛист(Выборка.Ссылка);
			ТабДок.Вывести(ТабДокМаршрут);
		КонецЦикла;
		
	Иначе
	//АК БЕЛН 20.03.17-
		Для Каждого СтрокаВыделенная Из Элементы.СписокМаршрутов.ВыделенныеСтроки Цикл
			Если ТабДок.ВысотаТаблицы > 0 Тогда
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;	
			ТабДокМаршрут = Документы.МаршрутныйЛист.СформироватьМаршрутныйЛист(СтрокаВыделенная);
			ТабДок.Вывести(ТабДокМаршрут);
		КонецЦикла;	
	//АК БЕЛН 20.03.17+
	КонецЕсли; 
	//АК БЕЛН 20.03.17-
	
	ТабДок.ОтображатьСетку			= Ложь;
	ТабДок.Защита					= Ложь;
	ТабДок.ТолькоПросмотр			= Истина;
	ТабДок.ОтображатьЗаголовки		= Ложь;
	ТабДок.ОриентацияСтраницы		= ОриентацияСтраницы.Портрет;
	ТабДок.РазмерКолонтитулаСнизу	= 0;
	ТабДок.РазмерКолонтитулаСверху 	= 0;
	ТабДок.ПолеСверху 				= 5;
	ТабДок.ПолеСнизу 				= 5;
	ТабДок.ПолеСлева 				= 5;
	ТабДок.ПолеСправа 				= 5;
	ТабДок.АвтоМасштаб				= Истина;
	
	Возврат ТабДок;
	
КонецФункции	

&НаКлиенте
Процедура ПечатьМаршрутныеЛисты(Команда)
	
	ТабДок = ПолучитьТабличныйДокументМаршрутных();
	ТабДок.Показать();
	
КонецПроцедуры

&НаКлиенте
Процедура СмотретьРазвозНаКарте(Команда)
	
	ОткрытьФорму("Обработка.РазвозНаТорговыеТочки.Форма.Форма");
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьПриложений(Команда)
	
	МассивДокументов = ПолучитьМассивКПечати();
	Если МассивДокументов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	Ответ = Вопрос("После печати документам будет установлен статус ""В сборке"". Продолжить?", РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	//
	//ТабДок = ЗначениеИзСтрокиВнутр(ПечатьРасходныхОрдеровСервер(МассивДокументов).Получить());
	ТабДок = ЗначениеИзСтрокиВнутрСерверПрил(МассивДокументов);
	ТабДок.ОтображатьСетку 		= Ложь;
	ТабДок.ОтображатьЗаголовки 	= Ложь;
	ТабДок.ТолькоПросмотр 		= Истина;
	ТабДок.Показать("Расходные ордера");
	
	ОбновитьРасходныеОрдера(Элементы.ТорговыеТочки.ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Функция ЗначениеИзСтрокиВнутрСерверПрил(МассивДокументов)
	
	СортировкаРОПоМаршрутамИТТ(МассивДокументов);
	
	Возврат ЗначениеИзСтрокиВнутр(ПечатьРасходныхОрдеровСерверПрил(МассивДокументов).Получить());
	
КонецФункции


&НаСервере
Функция ПечатьРасходныхОрдеровСерверПрил(МассивДокументов)
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Для Каждого ЭлементМассива Из МассивДокументов Цикл
		
		Если ТабДокумент.ВысотаТаблицы > 0 Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;	
		
		ТабДок = Документы.РасходныйОрдерСклад.ПечатьРасходныйОрдер_ТоварыССертификатами(ЭлементМассива);
		ТабДокумент.Вывести(ТабДок);
		
	КонецЦикла;	
	
	Возврат Новый ХранилищеЗначения(ЗначениеВСтрокуВнутр(ТабДокумент), Новый СжатиеДанных(9));
	
КонецФункции

&НаКлиенте
Процедура ПеревозчикПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокМаршрутов.Отбор, "Перевозчик", Перевозчик,,, ЗначениеЗаполнено(Перевозчик));
КонецПроцедуры


//+++АК KIRN 2018.04.09 ИП-00018209  
&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокМаршрутов.Отбор, "Организация", ОтборОрганизация,,, ЗначениеЗаполнено(ОтборОрганизация));
	ОбновитьТорговыеТочки();
	//ОбновитьРасходныеОрдера(Элементы.ТорговыеТочки.ТекущаяСтрока);
КонецПроцедуры
//---АК KIRN 

//+++АК KIRN 2018.04.09 ИП-00018209  
&НаКлиенте
Процедура ОтборСкладНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ФормаВыбора = ПолучитьФорму("Справочник.Склады.Форма.ФормаВыбораУправляемая",Новый Структура("Организация",ОтборОрганизация),ЭтаФорма);
	ФормаВыбора.Открыть();	
КонецПроцедуры
//---АК KIRN 


//+++АК KIRN 2018.04.09 ИП-00018330 
&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "Справочник.Склады.Форма.ФормаВыбораУправляемая" Тогда
		ОтборСклад = ВыбранноеЗначение;
		ОбновитьРасходныеОрдера(Элементы.ТорговыеТочки.ТекущаяСтрока);		
	КонецЕСлИ;
КонецПроцедуры


&НаКлиенте
Процедура ЗагрузитьРаспределениеТест(Команда)
	ОткрытьФорму("Обработка.ЗагрузитьРаспределение1.Форма.Форма", Новый Структура("Организация",ОтборОрганизация));
КонецПроцедуры


&НаКлиенте
Процедура СформироватьРОТест(Команда)
	ОткрытьФорму("Обработка.ЗаполнитьРасходникиПоЗаданиямНаРазборку.Форма.Форма");
КонецПроцедуры


&НаКлиенте
Процедура СформироватьРОНаОсновеЗаданийНаРазборку(Команда)
	//УстановитьПривилегированныйРежим(Истина);  //+++АК LAGP 2018.06.08 Дежурство. Выдаёт ошибку, на клиенте нет установки привилегированного режима.
	ОткрытьФорму("Обработка.ЗаполнитьРасходникиПоЗаданиямНаРазборку.Форма.Форма1");
КонецПроцедуры
//---АК KIRN 