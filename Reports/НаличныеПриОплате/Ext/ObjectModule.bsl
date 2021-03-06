﻿Перем СохраненнаяНастройка Экспорт;        // Текущий вариант отчета

Перем ТаблицаВариантовОтчета Экспорт;      // Таблица вариантов доступных текущему пользователю

Перем СоответствиеНаборовДанныхИЗапросов;

Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	Если ДанныеРасшифровки = Неопределено тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КонецЕсли;
	
	НастрокаПоУмолчанию        = КомпоновщикНастроек.ПолучитьНастройки();
	ИнфокомТиповыеОтчеты.ПолучитьПримененуюНастройку(ЭтотОбъект);
	
	
	ПараметрНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ТаблицаДанныхПоПоступлению = Неопределено;
	Если ПараметрНачалоПериода = Неопределено Или ПараметрКонецПериода = Неопределено тогда
		Возврат Неопределено;
	Иначе
		
		НачалоПериода = ?(ПараметрНачалоПериода.Значение <> Неопределено, Дата(ПараметрНачалоПериода.Значение), '00010101');
		КонецПериода  = ?(ПараметрКонецПериода.Значение <> Неопределено, Дата(ПараметрКонецПериода.Значение), '00010101');
		
		ТаблицаДанныхПоПоступлению = ВнешниеДанные.ПолучитьДвиженияТоваровПолная(НачалоПериода, КонецПериода);
	КонецЕсли;
	
	ВнешниеНаборыДанных=Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаДанныхПоПоступлению", ТаблицаДанныхПоПоступлению);
	
	ИнфокомТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных);
	КомпоновщикНастроек.ЗагрузитьНастройки(НастрокаПоУмолчанию);
	УправлениеОтчетамиИнфоком.УстановитьЗапросыСКДПоСоответсвию(СхемаКомпоновкиДанных.НаборыДанных, СоответствиеНаборовДанныхИЗапросов);
	
	Возврат Результат;
	
КонецФункции

Процедура УдалитьЛишниеПредставленияВШапке(Результат)
	
	Ячейка = Результат.НайтиТекст("Удалить", , , , истина, Истина, ложь);
	Пока Ячейка <> Неопределено Цикл
		УдаляемаяОбласть = Результат.Область("R"+Ячейка.Верх);
		Результат.УдалитьОбласть(УдаляемаяОбласть, ТипСмещенияТабличногоДокумента.ПоВертикали);
		Ячейка = Результат.НайтиТекст("Удалить", , , , истина, Истина, ложь);
	КонецЦикла;
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт
	
	СтруктураНастроек = ИнфокомТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

Процедура ПрименитьНастройку() Экспорт
	
	Схема = ИнфокомТиповыеОтчеты.ПолучитьСхемуКомпоновкиОбъекта(ЭтотОбъект);
	
	// Считываение структуры настроек отчета
	Если Не СохраненнаяНастройка.Пустая() Тогда
		
		СтруктураНастроек = СохраненнаяНастройка.ХранилищеНастроек.Получить();
		Если Не СтруктураНастроек = Неопределено Тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(СтруктураНастроек.НастройкиКомпоновщика);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
		Иначе
			КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КонецЕсли;
		
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	КонецЕсли;
	
КонецПроцедуры


// Настройка отчета при отработки расшифровки
Процедура Настроить(Отбор) Экспорт
	
	// Настройка отбора
	Для каждого ЭлементОтбора Из Отбор Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
		Иначе
			ПолеОтбора = Новый ПолеКомпоновкиДанных(ЭлементОтбора.Поле);
		КонецЕсли;
		
		Если КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора, ЭлементОтбора);
		Иначе
			НовыйЭлементОтбора.Использование  = Истина;
			НовыйЭлементОтбора.ЛевоеЗначение  = ПолеОтбора;
			Если ЭлементОтбора.Иерархия Тогда
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
				КонецЕсли;
			Иначе
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				КонецЕсли;
			КонецЕсли;
			
			НовыйЭлементОтбора.ПравоеЗначение = ЭлементОтбора.Значение;
			
		КонецЕсли;                                    
		
	КонецЦикла;
	
	ИнфокомТиповыеОтчеты.УдалитьДублиОтбора(КомпоновщикНастроек);
	
КонецПроцедуры

Функция ЕстьДетальныеПоля(ВыбранныеПоля)
	ЕстьРесурсы = ложь;
	Для каждого ВыбраноеПоле из ВыбранныеПоля Цикл
		ДоступноеПоле = ИнфокомТиповыеОтчеты.ПолучитьДоступноеПолеПоПолюКомпоновкиДанных(ВыбраноеПоле.Поле, КомпоновщикНастроек);
		Если ДоступноеПоле <> Неопределено тогда
			Если ДоступноеПоле.Ресурс тогда
				ЕстьРесурсы = истина;
			Иначе
				ЕстьРесурсы = ложь;
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Не ЕстьРесурсы;
КонецФункции

Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
	ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ТекущаяДата",   ТекущаяДата());
	
	//ЕстьКодДохода                = ПрисутствуетПоле("КодДохода");
	//ЕстьВидРасчета               = ПрисутствуетПоле("ВидРасчета");
	//ЕстьРегистратор              = ПрисутствуетПоле("Регистратор"); 
	//ЕстьСтавкаНалогообложения    = ПрисутствуетПоле("НДФЛ.СтавкаНалогообложенияНДФЛ"); 
	//ЕстьФизЛицо                  = ПрисутствуетПоле("Сотрудник");
	//ЕстьКПП                      = ПрисутствуетПоле("КПП");
	//							   
	//ЕстьНалоговыйРежим                    = ПрисутствуетПоле("НалоговыйРежим");
	//ЕстьВидПособия                        = ПрисутствуетПоле("Пособия.ВидПособия");
	//ЕстьИнвалид                           = ПрисутствуетПоле("Взносы.Инвалид");
	//ЕстьРебенок                           = ПрисутствуетПоле("Пособия.Ребенок");
	//ЕстьВидЗанятости                      = ПрисутствуетПоле("Пособия.ВидЗанятости");
	//ЕстьСреднийЗаработок                  = ПрисутствуетПоле("Пособия.РазмерСреднегоЗаработка");
	//ЕстьВидСтрахования                    = ПрисутствуетПоле("Пособия.ВидСтрахования");
	//ЕстьКодПоОКАТО                        = ПрисутствуетПоле("НДФЛ.КодПоОКАТО"); 
	//ЕстьВычет                             = ПрисутствуетПоле("НДФЛ.КодВычетНДФЛ"); 
	//
	//ЕстьВидДохода                         = ПрисутствуетПоле("ВидДохода");
	//ЕстьВидТарифаСтраховыхВзносов         = ПрисутствуетПоле("ВидТарифаСтраховыхВзносов");
	//ЕстьРодилсяДо1967                     = ПрисутствуетПоле("РодилсяДо1967");
	//ЕстьОблагаетсяПоДополнительномуТарифу = ПрисутствуетПоле("ОблагаетсяПоДополнительномуТарифу");
	//ЕстьВыплатаЗаСчетФедеральногоБюджета = ПрисутствуетПоле("Пособия.ВыплатаЗаСчетФедеральногоБюджета");
	//
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КПП",   ЕстьКПП);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Инвалид",   ЕстьИнвалид);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КодДохода",   ЕстьКодДохода);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидРасчета",  ЕстьВидРасчета);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Регистратор", ЕстьРегистратор);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "СтавкаНалогообложенияРезидента", ЕстьСтавкаНалогообложения);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ФизЛицо",     ЕстьФизЛицо);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НалоговыйРежим",     ЕстьНалоговыйРежим);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидПособия",              ЕстьВидПособия);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Ребенок",                 ЕстьРебенок);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидЗанятости",            ЕстьВидЗанятости);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "РазмерСреднегоЗаработка", ЕстьСреднийЗаработок);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидСтрахования",          ЕстьВидСтрахования);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КодПоОКАТО",              ЕстьКодПоОКАТО);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Вычет",                   ЕстьВычет);
	//
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидДохода",                 ЕстьВидДохода);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидТарифаСтраховыхВзносов", ЕстьВидТарифаСтраховыхВзносов);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "РодилсяДо1967",             ЕстьРодилсяДо1967);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ОблагаетсяПоДополнительномуТарифу", ЕстьОблагаетсяПоДополнительномуТарифу);
	//ИнфокомТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВыплатаЗаСчетФедеральногоБюджета", ЕстьВыплатаЗаСчетФедеральногоБюджета);
	//
	//
	//Если ЕстьВычет тогда 
	//	Если ЕстьКодДохода тогда 
	//		Сообщить("Поле Вычет не возможно использовать с группировкой или отбором по полю ""Код дохода"".");
	//	КонецЕсли;
	//КонецЕсли;
	//
	//ВыбранныеПоля = ИнфокомТиповыеОтчеты.ПолучитьВыбранныеПоля(КомпоновщикНастроек);
	//
	//СписокПолей = Новый СписокЗначений;
	//
	//Для каждого ВыбранноеПоле из ВыбранныеПоля Цикл
	//	ДоступноеПоле = ИнфокомТиповыеОтчеты.ПолучитьДоступноеПолеПоПолюКомпоновкиДанных(ВыбранноеПоле.Поле, КомпоновщикНастроек);
	//	Если ДоступноеПоле <> Неопределено И ДоступноеПоле.Родитель <> Неопределено тогда
	//		Если ЕстьКодДохода тогда
	//			Если Найти(ДоступноеПоле.Поле, "Пособия.") <> 0 тогда
	//				Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ не возможно вывести одновременно с группировкой или отбором по полю ""Код по ОКАТО"".");
	//				ДобавитьПустоеОформдениеПоля(ВыбранноеПоле.Поле);
	//				СписокПолей.Добавить(ДоступноеПоле.Поле);
	//			КонецЕсли;
	//			Если Найти(ДоступноеПоле.Поле, "ЕСН.") = 0 и Найти(ДоступноеПоле.Поле, "База") = 0 и Строка(ДоступноеПоле.Поле) <> "ЕСН.Начислено" и Строка(ДоступноеПоле.Поле) <> "ЕСН.НачисленоСкидка" тогда
	//				Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ не возможно вывести одновременно с группировкой или отбором по полю ""Вид расчета"".");
	//				ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
	//				СписокПолей.Добавить(ДоступноеПоле.Поле);
	//			КонецЕсли;
	//		КонецЕсли;
	//		Если ЕстьВидРасчета тогда
	//			Если Найти(ДоступноеПоле.Поле, "База") = 0 и Строка(ДоступноеПоле.Поле) <> "Взносы.Начислено" и Строка(ДоступноеПоле.Поле) <> "Взносы.НеОблагаетсяЦеликом" тогда
	//				Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ не возможно вывести одновременно с группировкой или отбором по полю ""Вид расчета"".");
	//				ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
	//				СписокПолей.Добавить(ДоступноеПоле.Поле);
	//			КонецЕсли;
	//		КонецЕсли;
	//		Если ЕстьРегистратор тогда
	//			Если Найти(ДоступноеПоле.Поле, "ФССНС.") <> 0 тогда
	//				Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ не возможно вывести одновременно с группировкой или отбором по полю ""Регистратор"".");
	//				ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
	//				СписокПолей.Добавить(ДоступноеПоле.Поле);
	//			КонецЕсли;
	//		КонецЕсли;
	//		Если ЕстьСтавкаНалогообложения	тогда
	//			Если Найти(ДоступноеПоле.Поле, "НДФЛ.") = 0 тогда
	//				Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ не возможно вывести одновременно с группировкой или отбором по полю ""Ставка налогообложения"".");
	//				ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
	//				СписокПолей.Добавить(ДоступноеПоле.Поле);
	//			КонецЕсли;
	//		КонецЕсли;
	//		Если ЕстьФизЛицо тогда
	//			Если Найти(ДоступноеПоле.Поле, "ФССНС.") <> 0 тогда
	//				Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ не возможно вывести одновременно с группировкой или отбором по полю ""Сотрудник"".");
	//				ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
	//				СписокПолей.Добавить(ДоступноеПоле.Поле);
	//			КонецЕсли;
	//		КонецЕсли;
	//		Если ЕстьВидПособия или ЕстьРебенок или ЕстьВидЗанятости или ЕстьСреднийЗаработок или ЕстьВидСтрахования тогда
	//			Если Найти(ДоступноеПоле.Поле, "Пособия.") = 0 тогда
	//				Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ не возможно вывести одновременно с группировкой или отбором по полю ""Вид пособия"".");
	//				ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
	//				СписокПолей.Добавить(ДоступноеПоле.Поле);
	//			КонецЕсли;
	//		КонецЕсли;
	//		Если ЕстьНалоговыйРежим тогда
	//			Если Найти(ДоступноеПоле.Поле, "ЕСН.") = 0 и Найти(ДоступноеПоле.Поле, "ПФР.") = 0 тогда
	//				Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ не возможно вывести одновременно с группировкой или отбором по полю ""Налоговый режим"".");
	//				ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
	//				СписокПолей.Добавить(ДоступноеПоле.Поле);
	//			КонецЕсли;
	//		КонецЕсли;
	//		Если ЕстьВычет тогда
	//			Если Найти(ДоступноеПоле.Поле, "НалогНДФЛ") <> 0 или Найти(ДоступноеПоле.Поле, "НалогНДФЛУдержаный") <> 0 
	//				или Найти(ДоступноеПоле.Поле, "БазаНДФЛ") <> 0 или Найти(ДоступноеПоле.Поле, "СуммаДоходаНеОблагаемая") <> 0 тогда
	//				Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ не возможно вывести одновременно с группировкой или отбором по полю ""Вычет НДФЛ"".");
	//				ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
	//				СписокПолей.Добавить(ДоступноеПоле.Поле);
	//			КонецЕсли;
	//		КонецЕсли;
	//		Если ЕстьВидДохода тогда
	//			Если Найти(ДоступноеПоле.Поле, "Взносы.ФССНесчастныеСлучаи") <> 0 или Найти(ДоступноеПоле.Поле, "Взносы.ТФОМС") <> 0 
	//				или Найти(ДоступноеПоле.Поле, "Взносы.ФФОМС") <> 0 или Найти(ДоступноеПоле.Поле, "Взносы.ТФОМС") <> 0
	//				или Найти(ДоступноеПоле.Поле, "Взносы.ФСС") <> 0 или Найти(ДоступноеПоле.Поле, "Взносы.ПФРПоДополнительномуТарифу") <> 0
	//				или Найти(ДоступноеПоле.Поле, "Взносы.ПФРНакопительная") <> 0 или Найти(ДоступноеПоле.Поле, "Взносы.ПФРСтраховая") <> 0 тогда
	//				
	//				Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ не возможно вывести одновременно с группировкой или отбором по полю ""Вид дохода"".");
	//				ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
	//				СписокПолей.Добавить(ДоступноеПоле.Поле);
	//			КонецЕсли;
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЦикла;
	
	//Если ЕстьДетальныеПоля(ВыбранныеПоля) тогда
	//	Возврат;
	//КонецЕсли;
	//
	//ДобавитьОтборИлиПоВсемПоказателям(КомпоновщикНастроек.Настройки, ВыбранныеПоля, СписокПолей);
	
	ПараметрНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ПараметрНачалоПериода = Неопределено или ПараметрКонецПериода = Неопределено тогда
		Возврат;
	Иначе
		НачалоПериода = ?(ПараметрНачалоПериода.Значение <> Неопределено, Дата(ПараметрНачалоПериода.Значение), '00010101');
		КонецПериода  = ?(ПараметрКонецПериода.Значение <> Неопределено, Дата(ПараметрКонецПериода.Значение), '00010101');
		Если НачалоПериода = '00010101'  тогда
			НачалоПериода = НачалоМесяца(ТекущаяДата());
		КонецЕсли;
		Если КонецПериода = '00010101' тогда
			КонецПериода = КонецМесяца(ТекущаяДата());
		КонецЕсли;
		ПараметрКонецПериода.Использование = Истина;
		ПараметрНачалоПериода.Использование = Истина;
		
		ПараметрКонецПериода.Значение  = КонецПериода;
		ПараметрНачалоПериода.Значение = НачалоПериода;
	КонецЕсли;
	
	Если НачалоПериода <> Неопределено и КонецПериода <> Неопределено тогда
		УправлениеОтчетамиИнфоком.ЗаменитьВСКДТекстЗапросКалендаря(СхемаКомпоновкиДанных, НачалоПериода, КонецПериода, СоответствиеНаборовДанныхИЗапросов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПустоеОформдениеПоля(Поле)
	
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	ЗначениеТекст = УсловноеОформление.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Text"));
	ЗначениеТекст.Значение = "-";
	ЗначениеТекст.Использование = Истина;
	
	ПолеОформления = УсловноеОформление.Поля.Элементы.Добавить();
	ПолеОформления.Использование = Истина;
	ПолеОформления.Поле = Поле;
	
КонецПроцедуры


Процедура ДобавитьОтборИлиПоВсемПоказателям(СтруктураОтчета, ВыбранныеПоля, СписокПолей)
	// создадим отбор или 
	ГруппаИли = СтруктураОтчета.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Для каждого ВыбранноеПоле из ВыбранныеПоля Цикл
		Если Найти(Строка(ВыбранноеПоле.Поле), "UserField") > 0 или СписокПолей.НайтиПоЗначению(ВыбранноеПоле.Поле) <> Неопределено тогда
			Продолжить;
		КонецЕсли;
		ИнфокомТиповыеОтчеты.ДобавитьОтбор(ГруппаИли, Строка(ВыбранноеПоле.Поле), 0, ВидСравненияКомпоновкиДанных.НеРавно);
	КонецЦикла;
	Если ГруппаИли.Элементы.Количество() = 0 тогда
		ГруппаИли.Использование = истина;
	КонецЕсли;
	Если ГруппаИли.Элементы.Количество() = 0 тогда
		СтруктураОтчета.Отбор.Элементы.Удалить(ГруппаИли);
	КонецЕсли;
КонецПроцедуры


Функция ПрисутствуетПоле(Поле)
	
	ЕстьГруппировка = ложь;
	
	ЕстьГруппировка = НайтиПоле(КомпоновщикНастроек.Настройки.Структура, Поле);
	
	
	//Для каждого ЭлементСтруктуры из КомпоновщикНастроек.Настройки.Структура Цикл
	//	
	//	Если Тип(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") тогда
	//		
	//		ЕстьГруппировка = НайтиПоле(ЭлементСтруктуры.Строки, Поле) или НайтиПоле(ЭлементСтруктуры.Колонки, Поле);
	//		
	//	ИначеЕсли Тип(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") тогда
	//		
	//		ЕстьГруппировка = НайтиПоле(ЭлементСтруктуры.Структура, Поле);
	//		
	//	ИначеЕсли Тип(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") тогда
	//		
	//		Если ЭлементСтруктуры.Точки.Количество() <> 0 тогда
	//			
	//			ЕстьГруппировка = НайтиПоле(ЭлементСтруктуры.Точки, Поле) ИЛИ НайтиПоле(ЭлементСтруктуры.Серии, Поле);
	//			
	//		КонецЕсли;
	//		
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
	Если ЕстьГруппировка тогда
		Возврат ЕстьГруппировка;
	КонецЕсли;
	
	// найти поле группировки в отборе
	Для каждого ОтборПоле из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		
		ПолеПериодРегистрации = Новый ПолеКомпоновкиДанных(Поле);
		
		Если ТипЗнч(ОтборПоле) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") тогда
			ЕстьГруппировка = ИспользуетсяОтбор(ОтборПоле.Элементы, ПолеПериодРегистрации);
		Иначе
			Если ОтборПоле.Использование и (ОтборПоле.ЛевоеЗначение = ПолеПериодРегистрации или ОтборПоле.ПравоеЗначение = ПолеПериодРегистрации) тогда
				
				ЕстьГруппировка = истина;
				
				Прервать;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ВыбранныеПоля = ИнфокомТиповыеОтчеты.ПолучитьВыбранныеПоля(КомпоновщикНастроек);
	
	Для каждого ПолеВыбора из ВыбранныеПоля Цикл
		
		ПолеПериодРегистрации = Новый ПолеКомпоновкиДанных(Поле);
		
		Если ТипЗНЧ(ПолеВыбора) = Тип("ВыбранноеПолеКомпоновкиДанных") И ПолеВыбора.Использование И ПолеВыбора.Поле = ПолеПериодРегистрации тогда
			
			ЕстьГруппировка = истина;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	
	Возврат ЕстьГруппировка;
	
КонецФункции 

Функция ИспользуетсяОтбор(Элементы, ПолеПериодРегистрации)
	
	ЕстьГруппировка = ложь;
	
	Для каждого ОтборПоле из Элементы Цикл
		
		Если ТипЗнч(ОтборПоле) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") тогда
			ЕстьГруппировка = ИспользуетсяОтбор(ОтборПоле.Элементы, ПолеПериодРегистрации);
		Иначе
			Если ОтборПоле.Использование и (ОтборПоле.ЛевоеЗначение = ПолеПериодРегистрации или ОтборПоле.ПравоеЗначение = ПолеПериодРегистрации) тогда
				
				ЕстьГруппировка = истина;
				
				Прервать;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЕстьГруппировка;
	
КонецФункции

// Функция возвращает значение истина, если в группировках элементов структуры присутствует поле "Период регистрации"
//
Функция НайтиПоле(Структура, Поле)
	
	ЕстьПоле = ложь;
	
	Если ТипЗнч(Структура) <> Тип("КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных") 
		и ТипЗнч(Структура) <> Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") 
		и ТипЗнч(Структура) <> Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных") 
		тогда
		
		Возврат ЕстьПоле;
		
	КонецЕсли;
	
	ПолеПериодРегистрации = Новый ПолеКомпоновкиДанных(Поле);
	
	Для каждого ЭлементСтруктуры из Структура Цикл
		
		Если Тип(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") 
			или  Тип(ЭлементСтруктуры) = Тип("ГруппировкаТаблицыКомпоновкиДанных") 
			или  Тип(ЭлементСтруктуры) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") тогда
			Для каждого ПолеГруппировки из ЭлементСтруктуры.ПоляГруппировки.Элементы Цикл
				Если ТипЗнч(ПолеГруппировки) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") тогда
					Продолжить;
				КонецЕсли;
				Если ПолеГруппировки.Использование И ПолеГруппировки.Поле = ПолеПериодРегистрации тогда
					ЕстьПоле = истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ЕстьПоле тогда
			Прервать;
		КонецЕсли;
		Если Тип(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") тогда
			ЕстьПоле = НайтиПоле(ЭлементСтруктуры.Строки, Поле) или НайтиПоле(ЭлементСтруктуры.Колонки, Поле);
		ИначеЕсли Тип(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") 
			или  Тип(ЭлементСтруктуры) = Тип("ГруппировкаТаблицыКомпоновкиДанных") 
			или  Тип(ЭлементСтруктуры) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") тогда
			ЕстьПоле = НайтиПоле(ЭлементСтруктуры.Структура, Поле);
		ИначеЕсли Тип(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") тогда
			Если ЭлементСтруктуры.Точки.Количество() <> 0 тогда
				ЕстьПоле = НайтиПоле(ЭлементСтруктуры.Точки, Поле) ИЛИ НайтиПоле(ЭлементСтруктуры.Серии, Поле);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЕстьПоле;
	
КонецФункции //НайтиПоле()

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	СписокПолейПодстановкиОтборовПоУмолчанию = Новый Соответствие;
	
	Возврат Новый Структура("ДополнительныеНастройкиОтчета, ИспользоватьСобытияПриФормированииОтчета,
	|ПриВыводеЗаголовкаОтчета,
	|ПослеВыводаПанелиПользователя,
	|ПослеВыводаПериода,
	|ПослеВыводаПараметра,
	|ПослеВыводаГруппировки,
	|ПослеВыводаОтбора,
	|ДействияПанелиИзменениеФлажкаДопНастроек,
	|ПриПолучениеНастроекПользователя, 
	|ЗаполнитьОтборыПоУмолчанию, 
	|СписокПолейПодстановкиОтборовПоУмолчанию", 
	Истина, ложь, ложь, ложь, ложь, ложь, ложь, ложь, ложь, ложь, истина, СписокПолейПодстановкиОтборовПоУмолчанию);
КонецФункции


Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	
	// Подготовим и выведем отчет.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	НастройкиКомпоновкиДанных = КомпоновщикНастроек.ПолучитьНастройки();
	
	Если ДанныеРасшифровки = Неопределено тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КонецЕсли;
	
	ПараметрПериода = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период")).ИдентификаторПользовательскойНастройки);
	Если ПараметрПериода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НачалоПериода = ПараметрПериода.Значение.ДатаНачала;
	КонецПериода  = ПараметрПериода.Значение.ДатаОкончания;
	Если НЕ ЗначениеЗаполнено(НачалоПериода) ИЛИ НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		Возврат;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РолиПользователейСоставРоли.Сотрудник КАК Ссылка,
	|	РолиПользователейСоставРоли.Сотрудник.Код КАК Код
	|ИЗ
	|	Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|		ПО РолиПользователейТипыРолей.Ссылка = РолиПользователейСоставРоли.Ссылка
	|ГДЕ
	|	РолиПользователейТипыРолей.ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗСотр = РезультатЗапроса.Выгрузить();
	
	ТЗВыручка=Новый ТаблицаЗначений;
	ТЗВыручка.Колонки.Добавить("ТТ",Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ТЗВыручка.Колонки.Добавить("Помощник",Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТЗВыручка.Колонки.Добавить("Касса",ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(10));
	ТЗВыручка.Колонки.Добавить("НомерЧека",ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(10));
	ТЗВыручка.Колонки.Добавить("ДатаЗакрытия",Новый ОписаниеТипов("Дата"));
	ТЗВыручка.Колонки.Добавить("СуммаДенегОтПокупателя",ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15,2));
	ТЗВыручка.Колонки.Добавить("СуммаСдачи",ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15,2));
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	//ТекстЗапросаSQL = "declare @datanach datetime = "+ВнешниеДанные.ФорматПоля(НачалоДня(НачалоПериода))+"
	//|declare @datakon datetime = "+ВнешниеДанные.ФорматПоля(КонецДня(КонецПериода))+"
	//|SELECT  tt.id_tt Магазин,Pomoschniki._SotrCode Помощник,UINTT._Fld4946 as TTUID
	//|, cp.[CashId] Касса
	//|,[CashCheckNo] НомерЧека 
	//|,[CloseDate] ДатаЗакрытия
	//|,[PaySum] [Сумма денег от покупателя]
	//|,[Exchange] [Сумма сдачи]
	//
	//|FROM [SMS_REPL].[dbo].[ClientPayments] as cp with(nolock)
	//|left join SMS_REPL..CashIP with(nolock)
	//|on cp.CashId=CashIP.CashID 
	//|left join M2..tt tt with(nolock)
	//|	inner join Reports..Pomoschniki  as Pomoschniki with(nolock) on Pomoschniki.id_tt=tt.id_tt
	//|LEFT OUTER JOIN IzbenkaFin.dbo._InfoRg4943 UINTT (nolock) ON TT.id_tt = UINTT._Fld4953 and UINTT._Fld4944_TYPE = 0x08 and UINTT._Fld4944_RTRef = 0x0000002A and UINTT._Fld4947 = 1
	//|on tt.N=CashIP.ShopNo
	//|where cp.CloseDate between @datanach and @datakon
	//|order by CloseDate desc
	//|";
	ТекстЗапросаSQL = "exec SMS_REPL..FOR1C_GetCashWhenPay 
	|@datanach = "+ВнешниеДанные.ФорматПоля(НачалоДня(НачалоПериода))+"
	|,@datakon = "+ВнешниеДанные.ФорматПоля(КонецДня(КонецПериода));
	
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	Пока rs <> Неопределено И rs.Fields.Count <= 0 Цикл
		rs=rs.NextRecordSet();
	КонецЦикла;
	Попытка
		rs.MoveFirst();
		Пока НЕ rs.Eof()  Цикл
			ИскСтр=ТЗСотр.Найти(rs.Fields("Помощник").Value);
			Если ИскСтр=Неопределено Тогда
				rs.Movenext();
				Продолжить;
			КонецЕсли;
			ФЛ=ИскСтр.Ссылка;
			
			НовСтр=ТЗВыручка.Добавить();
			
			НовСтр.ТТ = Справочники.СтруктурныеЕдиницы.ПолучитьСсылку(Новый УникальныйИдентификатор(Rs.Fields("TTUID").Value));
			НовСтр.Помощник=ФЛ;
			НовСтр.Касса=rs.Fields("Касса").Value;
			НовСтр.НомерЧека=rs.Fields("НомерЧека").Value;
			НовСтр.ДатаЗакрытия=rs.Fields("ДатаЗакрытия").Value;
			НовСтр.СуммаДенегОтПокупателя=rs.Fields("Сумма денег от покупателя").Value;
			НовСтр.СуммаСдачи=rs.Fields("Сумма сдачи").Value;
			
			rs.Movenext();
		КонецЦикла;  
		
	Исключение
	КонецПопытки;
	ADOСоединение.Close();
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТЗВыручка", ТЗВыручка);
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
	СхемаКомпоновкиДанных, 
	НастройкиКомпоновкиДанных,
	ДанныеРасшифровки
	);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(
	МакетКомпоновки,
	ВнешниеНаборыДанных,
	ДанныеРасшифровки
	);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
КонецПроцедуры

Если СохраненнаяНастройка = Неопределено Тогда
	СохраненнаяНастройка =  Справочники.СохраненныеНастройки.ПустаяСсылка();
КонецЕсли;

Если КомпоновщикНастроек = Неопределено Тогда
	КомпоновщикНастроек =  Новый КомпоновщикНастроекКомпоновкиДанных;
КонецЕсли;

УправлениеОтчетамиИнфоком.ЗаменитьНазваниеПолейСхемыКомпоновкиДанных(СхемаКомпоновкиДанных);
