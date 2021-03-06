﻿
Функция ПолучитьИмяПоляПоТипу(мЗначение)
	
	Если ТипЗнч(мЗначение) = Тип("СправочникСсылка.Организации") Тогда
		Возврат "Организация";
	ИначеЕсли ТипЗнч(мЗначение) = Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат "Контрагент";
	ИначеЕсли ТипЗнч(мЗначение) = Тип("СписокЗначений") Тогда
		Если мЗначение.Количество() > 0 Тогда
			Если ТипЗнч(мЗначение[0].Значение) = Тип("СправочникСсылка.Организации") Тогда
				Возврат "Организация";
			ИначеЕсли ТипЗнч(мЗначение[0].Значение) = Тип("СправочникСсылка.Контрагенты") Тогда
				Возврат "Контрагент";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ПолучитьПредставлениеВидаСравнения(мВидСравнения)
	
	Если мВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
		Возврат "Равно";
	ИначеЕсли мВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
		Возврат "Не равно";
	ИначеЕсли мВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии Тогда
		Возврат "В группе";
	ИначеЕсли мВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии Тогда
		Возврат "Не в группе";
	ИначеЕсли мВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
		Возврат "В списке";
	ИначеЕсли мВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке Тогда
		Возврат "Не в списке";
	ИначеЕсли мВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии Тогда
		Возврат "В списке по иерархии";
	ИначеЕсли мВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии Тогда
		Возврат "Не в списке по иерархии";
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	////////////////////////////////
	//// Получение данных и вывод //
	////////////////////////////////
	
	ТипСправочникОрганизации = Тип("СправочникСсылка.Организации");
	ТипСправочникКонтрагенты = Тип("СправочникСсылка.Контрагенты");
	МассивОрганизацийВкл	= Новый Массив;
	МассивОрганизацийИскл 	= Новый Массив;
	МассивКонтрагентовВкл	= Новый Массив;
	МассивКонтрагентовИскл 	= Новый Массив;
	
	мТекстОтбора = "";
	мЭлементыНастроек = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	Для Каждого ПользПоле Из мЭлементыНастроек Цикл
		Если ТипЗнч(ПользПоле) = Тип("ЭлементОтбораКомпоновкиДанных")
				И ПользПоле.Использование = Истина Тогда
			мТекстОтбора = мТекстОтбора + ?(НЕ мТекстОтбора = "", Символы.ПС, "") +
							ПолучитьИмяПоляПоТипу(ПользПоле.ПравоеЗначение) + " " +
							ПолучитьПредставлениеВидаСравнения(ПользПоле.ВидСравнения) + " """;
			Если ПользПоле.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
				Если ТипЗнч(ПользПоле.ПравоеЗначение) = ТипСправочникОрганизации Тогда
					МассивОрганизацийВкл.Добавить(ПользПоле.ПравоеЗначение);
				ИначеЕсли ТипЗнч(ПользПоле.ПравоеЗначение) = ТипСправочникКонтрагенты Тогда
					МассивКонтрагентовВкл.Добавить(ПользПоле.ПравоеЗначение);
				КонецЕсли;
				мТекстОтбора = мТекстОтбора + ПользПоле.ПравоеЗначение + """;";
			ИначеЕсли ПользПоле.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
				Если ТипЗнч(ПользПоле.ПравоеЗначение) = ТипСправочникОрганизации Тогда
					МассивОрганизацийИскл.Добавить(ПользПоле.ПравоеЗначение);
				ИначеЕсли ТипЗнч(ПользПоле.ПравоеЗначение) = ТипСправочникКонтрагенты Тогда
					МассивКонтрагентовИскл.Добавить(ПользПоле.ПравоеЗначение);
				КонецЕсли;
				мТекстОтбора = мТекстОтбора + ПользПоле.ПравоеЗначение + """;";
			ИначеЕсли ПользПоле.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии
					ИЛИ ПользПоле.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии Тогда
				мТекстОтбора = мТекстОтбора + ПользПоле.ПравоеЗначение + """;";
			ИначеЕсли ПользПоле.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
				ТекстСписка = "";
				Для Каждого ЭлементСписка Из ПользПоле.ПравоеЗначение Цикл
					Если ТипЗнч(ЭлементСписка.Значение) = ТипСправочникОрганизации Тогда
						МассивОрганизацийВкл.Добавить(ЭлементСписка.Значение);
					ИначеЕсли ТипЗнч(ЭлементСписка.Значение) = ТипСправочникКонтрагенты Тогда
						МассивКонтрагентовВкл.Добавить(ЭлементСписка.Значение);
					КонецЕсли;
					ТекстСписка = ТекстСписка + "," + ЭлементСписка.Значение;
				КонецЦикла;
				ТекстСписка = Сред(ТекстСписка, 2);
				мТекстОтбора = мТекстОтбора + ТекстСписка + """;";
			ИначеЕсли ПользПоле.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке Тогда
				ТекстСписка = "";
				Для Каждого ЭлементСписка Из ПользПоле.ПравоеЗначение Цикл
					Если ТипЗнч(ЭлементСписка.Значение) = ТипСправочникОрганизации Тогда
						МассивОрганизацийИскл.Добавить(ЭлементСписка.Значение);
					ИначеЕсли ТипЗнч(ЭлементСписка.Значение) = ТипСправочникКонтрагенты Тогда
						МассивКонтрагентовИскл.Добавить(ЭлементСписка.Значение);
					КонецЕсли;
					ТекстСписка = ТекстСписка + "," + ЭлементСписка.Значение;
				КонецЦикла;
				ТекстСписка = Сред(ТекстСписка, 2);
				мТекстОтбора = мТекстОтбора + ТекстСписка + """;";
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	ЭтотОбъект.ТекстОтбора = мТекстОтбора;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДатаНачала"	, ЭтотОбъект.ДатаНачала);
	СтруктураПараметров.Вставить("ДатаОкончания", КонецДня(ЭтотОбъект.ДатаОкончания));
	СтруктураПараметров.Вставить("Счет"			, ЭтотОбъект.Счет);
	ТаблицаДанных = Отчеты.ОтчетПоНаличиюСогласованногоАктаСверкиЗаПериод_.ПолучитьТаблицу(СтруктураПараметров,
														МассивОрганизацийВкл, МассивКонтрагентовВкл, МассивОрганизацийИскл, МассивКонтрагентовИскл);

	ЭтотОбъект.ДанныеОтчета.Загрузить(ТаблицаДанных);
	
	
	//
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ДанныеДляФормирования", ТаблицаДанных);
	
	//Макет компоновки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	//Компоновка данных
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	//Вывод результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры
