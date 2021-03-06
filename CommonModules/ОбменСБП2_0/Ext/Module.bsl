﻿
//+++АК Susk (Суслин К.В.) 2018.04.18 оптимизация
Процедура ОбменСБП2_0ПередЗаписьюДокумента(Источник, Отказ) Экспорт
	УстановитьПривилегированныйРежим(Истина);	
	Узел = ОбщегоНазначенияПовтИсп.ПолучитьУзелОбменаПоКоду("БП"); 
	Узел2 = ОбщегоНазначенияПовтИсп.ПолучитьУзелОбменаПоКоду("БП2");
	
	//на случай тестовых баз.
	Если Узел.Пустая() ИЛИ Узел2.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Если НЕ ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда //заплатка для присваиваемых через ЭДО номеров счет-фактур для ПТУ.
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		
		Если Источник.Дата >= Дата(2014, 6, 1)
				И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Контрагент, "ИНН") <> "7777777777" Тогда
			Источник.ОбменДанными.Получатели.Добавить(Узел2);			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		
		Если Источник.ВыгружатьВ_БП
				И Источник.Дата >= Дата(2015, 3, 1) Тогда
			Источник.ОбменДанными.Получатели.Добавить(Узел);
		КонецЕсли;	
		
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.РасходИзКассы")
			И Источник.Организация <> Справочники.Организации.Избенка
			И Источник.Дата >= Дата(2015, 4, 1) Тогда
			
		Источник.ОбменДанными.Получатели.Добавить(Узел);
		
	ИначеЕсли (ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.ВозвратТоваровПоставщику")
				ИЛИ ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг"))
			И Источник.Дата >= Дата(2014, 7, 1) Тогда		
		
		Источник.ОбменДанными.Получатели.Добавить(?(ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг"), Узел2, Узел));		
		
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.ПоступлениеДопРасходов") Тогда
		
		Источник.ОбменДанными.Получатели.Добавить(Узел);		
			
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.КорректировкаПоступления") Тогда
		
		Если Источник.Дата >= Дата(2015, 7, 1)
				И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Контрагент, "ИНН") <> "7777777777"
				И НЕ Источник.НеВыгружатьВБУ Тогда
			Источник.ОбменДанными.Получатели.Добавить(Узел);
		КонецЕсли;
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.ВводВЭксплуатацию") Тогда
		Если Источник.Дата >= Дата(2017, 1, 1) Тогда 
			Источник.ОбменДанными.Получатели.Добавить(Узел);
		КонецЕсли;
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.СписаниеОС") Тогда
		
		Если Источник.Дата >= Дата(2017, 1, 1) Тогда 
			Источник.ОбменДанными.Получатели.Добавить(Узел);
		КонецЕсли;

	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.ОприходованиеОС") Тогда
		
		Если Источник.Дата >= Дата(2017, 1, 1) Тогда 
			Источник.ОбменДанными.Получатели.Добавить(Узел);
		КонецЕсли;

	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.ИнвентаризацияОС") Тогда
		
		Если Источник.Дата >= Дата(2017, 1, 1) Тогда 
			Источник.ОбменДанными.Получатели.Добавить(Узел);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.ТребованиеНакладная") Тогда
		
		Если Источник.Дата >= Дата(2017, 1, 1)
			И Источник.ВидСписания = Перечисления.ВидыСписанияТребованиеНакладная.СписаниеМатериалов Тогда 
			Источник.ОбменДанными.Получатели.Добавить(Узел);
		КонецЕсли;		
	
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.Операция") Тогда
		
		Если ЗначениеЗаполнено(Источник.ВидОперации) 
			ИЛИ Источник.НовыйМеханизм Тогда		
				Источник.ОбменДанными.Получатели.Добавить(Узел);
		КонецЕсли;
		
	//ИП-00016796.01
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.НачислениеПроцентовПоДоговорам") Тогда
		
		Если Источник.ТипДоговора = Перечисления.ТипыДоговоровФинансы.Депозит
			ИЛИ Источник.ТипДоговора = Перечисления.ТипыДоговоровФинансы.Займ Тогда			
				Источник.ОбменДанными.Получатели.Добавить(Узел);
		КонецЕсли;
			
	//ИП-00015971
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.РеализацияОС") Тогда
		
		Если НЕ Источник.РучнаяКорректировка Тогда
			Источник.ОбменДанными.Получатели.Добавить(Узел)
		КонецЕсли;
		
	//ИП-00017162.01 21.11.2017
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.ПеремещениеОС") Тогда
		
		Если НЕ Источник.НеВыгружатьВБУ Тогда
			Источник.ОбменДанными.Получатели.Добавить(Узел)
		КонецЕсли;
		
	//ИП-00016525 29.11.2017
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.КорректировкаВзаиморасчетов") Тогда
		
		Если Источник.Дата >= Дата(2017, 11, 1) И НЕ Источник.НеВыгружатьВБУ Тогда
			Источник.ОбменДанными.Получатели.Добавить(Узел)
		КонецЕсли;	
		
	//+++АК Susk (Суслин К.В.) 2018.02.08 ИП-00017676
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		
		Источник.ОбменДанными.Получатели.Добавить(Узел)
		
	//ИП-00017731 25.01.2018
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.НачислениеАренднойПлатыОтАрендодателей") Тогда
		
		лОтказ = Источник.ТипАренднойПлаты <> Перечисления.ТипыАренднойПлаты.ПеременнаяЧасть ИЛИ Источник.ВидАренднойПлаты <> Перечисления.ВидыАренднойПлаты.ПоСчету;
		
		Если НЕ лОтказ Тогда
			Источник.ОбменДанными.Получатели.Добавить(Узел)
		КонецЕсли;
		
	//+++АК Susk (Суслин К.В.) 2018.05.21 ИП-00018745
	ИначеЕсли ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
		
		Источник.ОбменДанными.Получатели.Добавить(Узел2)
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);	
	
КонецПроцедуры

//+++АК Susk (Суслин К.В.) 2018.01.10 б/н
Функция ИнициализироватьОбработкуОбмена(ИмяПравила = "", НазваниеМакетаПравил = "") Экспорт
	
	пОбработка = Обработки.ВыгрузкаПлатежныхДокументовВБухгалтерию.Создать();
	пОбработка.ИмяФайлаПравилОбмена 				= "Правила обмена загружены";
	пОбработка.НепосредственноеЧтениеВИБПриемнике 	= Истина;
	пОбработка.ТипИнформационнойБазыДляПодключения 	= Ложь;
	пОбработка.ВерсияПлатформыИнформационнойБазыДляПодключения 			= ПолныеПрава.ПолучитьВерсиюКомОбъекта_Бух();
	СтруктураПодключения = ПолныеПрава.ПолучитьСтрокуПодключенияСтруктурой_Бух();
	пОбработка.ИмяСервераИнформационнойБазыДляПодключения 				= СтруктураПодключения.ИмяСервера;
	пОбработка.ИмяИнформационнойБазыНаСервереДляПодключения 			= СтруктураПодключения.ИмяБазы;
	пОбработка.АутентификацияWindowsИнформационнойБазыДляПодключения 	= Ложь;
	пОбработка.ПользовательИнформационнойБазыДляПодключения 			= СтруктураПодключения.Пользователь;
	пОбработка.ПарольИнформационнойБазыДляПодключения 					= СтруктураПодключения.Пароль;
	пОбработка.ИспользоватьТранзакции 				= Истина;
	пОбработка.КоличествоОбъектовНаТранзакцию 		= 1000000;
	пОбработка.ФлагРежимОтладки 					= Истина;	
	пОбработка.РежимОбмена = "Выгрузка";
		
	пОбработка.ТипУдаленияРегистрацииИзмененийДляУзловОбменаПослеВыгрузки=0;
	
	пОбработка.ИмяМакета = ?(ЗначениеЗаполнено(НазваниеМакетаПравил), НазваниеМакетаПравил, "ПравилаОбменаДанными");
	
	Если ИмяПравила = "СчетФактураПолученный" Тогда 
		пОбработка.ПользовательИнформационнойБазыДляПодключения 			= "ОбменСчетФактур";
		пОбработка.ПарольИнформационнойБазыДляПодключения 					= "19283746";
	КонецЕсли;
	
	ЗагрузитьПравилаОБменаДаннымиРеглОбмен(пОбработка, ?(ЗначениеЗаполнено(НазваниеМакетаПравил), НазваниеМакетаПравил, "ПравилаОбменаДанными"));
	
	пОбработка.ИнициализироватьПервоначальныеЗначенияПараметров();
	
	Возврат пОбработка;
	 	
КонецФункции

//+++АК Susk (Суслин К.В.) 2018.01.10 оптимизация
Функция ВернутьИзмененияПланаОбменаБП(НазваниеТаблицыДокумента)
	
	Узел = ВернутьУзелОбменаБУ();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВводВЭксплуатациюИзменения.Ссылка
	               |ИЗ
	               |	Документ." + НазваниеТаблицыДокумента + ".Изменения КАК ВводВЭксплуатациюИзменения
	               |ГДЕ
	               |	ВводВЭксплуатациюИзменения.Узел = &Узел";
	Запрос.УстановитьПараметр("Узел", Узел);			   
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

//+++АК VERT 2018.03.02 ИП-00017712
Функция ВернутьПодключениеКБазеБУ(ПодключениеУстановлено) Экспорт
	
	СтрокаПодключения = ПолныеПрава.ПолучитьСтрокуПодключения_Бух();
	
	v82COMОбъект = Новый COMОбъект(ПолныеПрава.ПолучитьВерсиюКомОбъекта_Бух() + ".COMConnector");
	Попытка
		v82 = v82COMОбъект.Connect(СтрокаПодключения);
		ПодключениеУстановлено=Истина;
	Исключение
		ПодключениеУстановлено=Ложь;
		ОбщегоНазначения.СообщитьОбОшибке("Не удалось подключиться к базе бухгалтерии!");		
	КонецПопытки;
	
	Возврат v82;
	
КонецФункции

//+++АК Susk (Суслин К.В.) 2018.01.10 оптимизация
Функция ВернутьДатыЗапретаБУ(v82, ИмяПравила = "")
	
	///////////////////////////////
	ЗапросДатыЗапрета = v82.NewObject("Запрос");  
	
	ЗапросДатыЗапрета.Текст =
	"ВЫБРАТЬ
	|	ГраницыЗапретаИзмененияДанных.Организация.ИНН КАК ИНН,
	|	МАКСИМУМ(ГраницыЗапретаИзмененияДанных.ГраницаЗапретаИзменений) КАК ГраницаЗапретаИзменений
	|ИЗ
	|	РегистрСведений.ГраницыЗапретаИзмененияДанных КАК ГраницыЗапретаИзмененияДанных
	|ГДЕ
	|	ГраницыЗапретаИзмененияДанных.Пользователь В (&ОтложенныеДвижения, &ТекущийПользователь)
	|
	|СГРУППИРОВАТЬ ПО
	|	ГраницыЗапретаИзмененияДанных.Организация.ИНН";
	
	ЗапросДатыЗапрета.УстановитьПараметр("ОтложенныеДвижения", v82.Справочники.Пользователи.НайтиПоНаименованию("Отложенные движения"));
	
	Если ИмяПравила = "СчетФактураПолученный" Тогда
		ЗапросДатыЗапрета.УстановитьПараметр("ТекущийПользователь", v82.Справочники.Пользователи.НайтиПоНаименованию("ОбменСчетФактур"));
	Иначе
		ЗапросДатыЗапрета.УстановитьПараметр("ТекущийПользователь", v82.ПараметрыСеанса.ТекущийПользователь);
	КонецЕсли;
	
	Возврат ЗапросДатыЗапрета.Выполнить().Выгрузить();
	
КонецФункции

//+++АК Susk (Суслин К.В.) 2018.01.10 оптимизация
Функция ВернутьУзелОбменаБУ()
	
	Возврат ПланыОбмена.ОбменИзбенкаСБП.НайтиПоКоду("БП");
	
КонецФункции

//+++АК Susk (Суслин К.В.) 2017.01.10 б/н
Процедура ВыгрузитьДокументВБП(ИмяПравила, НазваниеТаблицыДокумента, Объект) Экспорт
	
	ПодключениеУстановлено = Ложь;
	v82 = ВернутьПодключениеКБазеБУ(ПодключениеУстановлено);
	Узел = ВернутьУзелОбменаБУ();
	
	Если НЕ ПодключениеУстановлено Тогда
		Возврат;
	КонецЕсли;

	Если ОбщегоНазначения.ЕстьРеквизитДокумента("Организация", Объект.Метаданные()) Тогда
		ДатыЗапрета = ВернутьДатыЗапретаБУ(v82, ИмяПравила);	
		ДатаЗапрета = Неопределено;
	
		Если ДатыЗапрета.Количество() > 0 Тогда
			НашлиДата = ДатыЗапрета.Найти(Объект.Организация.ИНН, "ИНН");
			Если НЕ НашлиДата = Неопределено Тогда
				ДатаЗапрета = НашлиДата.ГраницаЗапретаИзменений;
				Если НашлиДата.ГраницаЗапретаИзменений > Объект.Дата Тогда //Передумали, опять не грузим
					ОбщегоНазначения.СообщитьОбОшибке("В бухгалтерии закрыт период, документ не будет выгружен");
					Возврат;
				КонецЕсли;	
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;
	
	пОбработка = ИнициализироватьОбработкуОбмена(ИмяПравила);		
	
	НазваниеДляОтбора = "Документ_" + НазваниеТаблицыДокумента;
	ИмяСтрокиДерева = "Документы";
	ВыгрузитьОбъектВБухгалтериюПоОтбору(пОбработка, НазваниеДляОтбора, ИмяСтрокиДерева, ИмяПравила, Объект);
	
КонецПроцедуры

//+++АК Susk (Суслин К.В.) 2018.01.17 ИП-00017530 
Процедура ВыгрузитьОбъектВБухгалтериюПоОтбору(пОбработка, НазваниеДляОтбора, ИмяСтрокиДерева, ИмяПравила, Объект, ЭтоСписок = Ложь) Экспорт
	
	СтрокиДереваПравилВыгрузки = пОбработка.ТаблицаПравилВыгрузки.Строки;	
		
	Для Каждого СтрокаДерева из СтрокиДереваПравилВыгрузки Цикл
		Если СтрокаДерева.Имя = ИмяСтрокиДерева	Тогда
			СтрокаДерева.Включить = 1;
			ПравилаВсе = СтрокаДерева.Строки;
		Иначе
			СтрокаДерева.Включить = 0;
			
			Для Каждого Стр Из СтрокаДерева.Строки Цикл
				Стр.Включить = 0;
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
	Если ТипЗнч(Объект) = Тип("Массив") Тогда
		СписокВОтбор = Новый СписокЗначений;
		
		Для Каждого Эл Из Объект Цикл
			СписокВОтбор.Добавить(Эл);
		КонецЦикла;
	Иначе
		СписокВОтбор = Объект;
	КонецЕсли;
	
	Для каждого Правило из ПравилаВсе Цикл
		Если Правило.Имя = ИмяПравила Тогда
			Правило.Включить 			= 1;
			Правило.ИспользоватьОтбор = Истина;
						
			ТекущееПВД = Правило;
	
			Свойства	= пОбработка.Менеджеры[ТекущееПВД.ОбъектВыборки];
		
			ИтоговоеОграничениеПоДате = "";	
		
			пОбработка.ПостроительОтчета.Текст = "ВЫБРАТЬ Разрешенные _.* ИЗ " + ТекущееПВД.ИмяОбъектаДляЗапроса + " КАК _ 
				|
				|" + ИтоговоеОграничениеПоДате + "
				|
				|{ГДЕ _.Ссылка.* КАК " + СтрЗаменить(ТекущееПВД.ИмяОбъектаДляЗапроса, ".", "_") + "}";			
		
			пОбработка.ПостроительОтчета.Отбор.Сбросить();				
			
			пОбработка.ПостроительОтчета.ЗаполнитьНастройки();
			Отб = пОбработка.ПостроительОтчета.Отбор.Добавить(НазваниеДляОтбора, НазваниеДляОтбора);
			Отб.ВидСравнения = ?(ЭтоСписок, ВидСравнения.ВСписке, ВидСравнения.Равно);
			Отб.Значение = ?(ЭтоСписок, СписокВОтбор, Объект.Ссылка);
			Отб.Использование = Истина;
			
			Настройки = пОбработка.ПостроительОтчета.ПолучитьНастройки();
			
			Правило.НастройкиПостроителя = Настройки;		
		Иначе
			Правило.Включить = 0;
		КонецЕсли;		
	КонецЦикла;	
	
	пОбработка.ВыполнитьВыгрузку();
	
КонецПроцедуры

Процедура ВыгрузитьСписокДокументовВБП(ИмяПравила, НазваниеТаблицыДокумента, СписокДокументов) Экспорт	
	
	Если СписокДокументов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СписокОрганизаций = Новый Массив;
	
	Для Каждого Строка Из СписокДокументов Цикл
		Если СписокОрганизаций.Найти(Строка.Ссылка.Организация) = Неопределено Тогда
			СписокОрганизаций.Добавить(Строка.Ссылка.Организация);
		КонецЕсли;
	КонецЦикла;	
	
	ПодключениеУстановлено = Ложь;
	v82 = ВернутьПодключениеКБазеБУ(ПодключениеУстановлено);
	
	Если НЕ ПодключениеУстановлено Тогда
		Возврат;
	КонецЕсли;
	
	Узел = ВернутьУзелОбменаБУ();
	
	ДатыЗапрета = ВернутьДатыЗапретаБУ(v82);	
	ДатаЗапрета = Неопределено;
	
	Если ДатыЗапрета.Количество() > 0 Тогда
		Для Каждого Строка Из СписокОрганизаций Цикл 
			НашлиДата = ДатыЗапрета.Найти(Строка.ИНН, "ИНН");
			Если НЕ НашлиДата = Неопределено Тогда
				ДатаЗапрета = НашлиДата.ГраницаЗапретаИзменений;
				
				Индекс = 0;
				Пока Индекс < СписокДокументов.Количество() Цикл 
					Если СписокДокументов[Индекс].Ссылка.Организация = Строка И НашлиДата.ГраницаЗапретаИзменений > СписокДокументов[Индекс].Ссылка.Дата Тогда //Передумали, опять не грузим							
						ОбщегоНазначения.СообщитьОбОшибке("Документ: " + Строка(СписокДокументов[Индекс].Ссылка) + " попадает в границы запрета в базе Бухгалтерии. Выгружен не будет!");
						СписокДокументов.Удалить(Индекс);
					Иначе
						Индекс = Индекс + 1;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если СписокДокументов.Количество() <> 0 Тогда 
		
		пОбработка = ИнициализироватьОбработкуОбмена();
		
		НазваниеДляОтбора = "Документ_" + НазваниеТаблицыДокумента;
		ИмяСтрокиДерева = "Документы";
		ВыгрузитьОбъектВБухгалтериюПоОтбору(пОбработка, НазваниеДляОтбора, ИмяСтрокиДерева, ИмяПравила, СписокДокументов, Истина);
		
	КонецЕсли;	
	
КонецПроцедуры

//+++АК Susk (Суслин К.В.) 2017.12.15 ИП-00017497
Процедура ВыгрузкаСправочникаВБП(ИмяСтрокиДереваПравил, ИмяПравила, НазваниеДляОтбора, Элемент, ЭтоСписок = Ложь) Экспорт 
	
	пОбработка = ИнициализироватьОбработкуОбмена();
	
	ИмяСтрокиДерева = ИмяСтрокиДереваПравил;
	ВыгрузитьОбъектВБухгалтериюПоОтбору(пОбработка, НазваниеДляОтбора, ИмяСтрокиДерева, ИмяПравила, Элемент, ЭтоСписок);	
		
КонецПроцедуры

//+++АК Susk (Суслин К.В.) 2017.12.20 оптимизация
Процедура ЗагрузитьПравилаОБменаДаннымиРеглОбмен(пОбработка, ИмяМакетаПравил) 
	
	флВременныеПравила = Истина;
	ТекстПравил = "";
	
	Разрез = ?(ИмяМакетаПравил = "ПравилаОбменаДанными_Контрагенты", "Контрагенты", "");
	
	Попытка
		ТекстПравил = пОбработка.ПолучитьТекстВременныхПравилОбмена(Разрез);
	Исключение
		флВременныеПравила = Ложь;
	КонецПопытки;
	
	Если Не ЗначениеЗаполнено(ТекстПравил) Тогда
		флВременныеПравила = Ложь;
	КонецЕсли;
	
	Если флВременныеПравила Тогда
		пОбработка.ЗагрузитьПравилаОбмена(ТекстПравил, "Строка");
	Иначе	
		пМакет = пОбработка.ПолучитьМакет(ИмяМакетаПравил);
		пОбработка.ЗагрузитьПравилаОбмена(пМакет.ПолучитьТекст(), "Строка");
	КонецЕсли;
	
КонецПроцедуры

//+++АК Susk (Суслин К.В.) 2018.01.10 ИП-00017530
Функция ПроверкаПередВыгрузкой(НужноЗаписать, МодифицированностьФормы, ДатаМеньше = "", НеВыгружатьВБУ = Ложь) Экспорт
	
	Отказ = Ложь;
	
	Если НужноЗаписать Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Сначала нужно записать документ!", Отказ);		
	КонецЕсли;	
	
	Если МодифицированностьФормы Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Документ был изменен. Сначала нужно записать документ!", Отказ);		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаМеньше) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Дата документа меньше " + ДатаМеньше + ". Выгружен не будет!", Отказ);
	КонецЕсли;
	
	Если НеВыгружатьВБУ Тогда
		ОбщегоНазначения.СообщитьОбОшибке("У документа стоит флаг ""Не выгружать в БУ"", выгрузка документа невозможна!", Отказ);		
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

//+++АК Susk (Суслин К.В.) 2018.04.13 ИП-00018145.03
Процедура ОбменСБП_ПриЗаписиСправочникаПриЗаписи(Источник, Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);	
	
	Узел = ОбщегоНазначенияПовтИсп.ПолучитьУзелОбменаПоКоду("БП"); //ПланыОбмена.ОбменИзбенкаСБП.НайтиПоКоду("БП");
	
	Если Узел.Пустая() Тогда
		Возврат;
	КонецЕсли;
		
	Если ТипЗнч(Источник.Ссылка) = Тип("СправочникСсылка.Номенклатура") 
		ИЛИ ТипЗнч(Источник.Ссылка) = Тип("СправочникСсылка.РасходыБудущихПериодов") 
		ИЛИ ТипЗнч(Источник.Ссылка) = Тип("СправочникСсылка.РабочиеМеста") Тогда		
			Источник.ОбменДанными.Получатели.Добавить(Узел);		
	КонецЕсли;
	
КонецПроцедуры
 
//+++АК Susk (Суслин К.В.) 2018.05.07 ИП-00017910
Функция ПроверкаНеобходимостиРегистрацииЛУВУзелОбмена(Объект)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат Истина;
	КонецЕсли;
	
	СтруктураЗапроса = ОбщегоНазначенияПовтИсп.ПолучитьСтруктуруЗапросаПроверкиИзмененийЛУ();
	ТекстЗапроса = "";
	
	Если НЕ СтруктураЗапроса.Свойство("ТекстЗапроса", ТекстЗапроса) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТаблицаПроверкиИзменений = Новый ТаблицаЗначений;
	
	Если НЕ СтруктураЗапроса.Свойство("ТаблицаПроверкиИзменений", ТаблицаПроверкиИзменений) Тогда		
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Счетчик = -1;
	
	Для Каждого Стр Из ТаблицаПроверкиИзменений Цикл
		
		Счетчик = Счетчик + 1;
		
		ВыборкаЗапроса = Результат[Счетчик].Выгрузить();
		
		МассивРеквДляПроверки = Стр.МассивРеквизитов;
		
		Если Стр.Сущность <> "Шапка" И ВыборкаЗапроса.Количество() <> Объект[Стр.Сущность].Количество() Тогда
			Возврат Истина;
		КонецЕсли;
		
		Для Каждого Рекв Из МассивРеквДляПроверки Цикл
			
			Если Стр.Сущность = "Шапка" Тогда
				Если Объект[Рекв] <> ВыборкаЗапроса[0][Рекв] Тогда
					Возврат Истина;
				КонецЕсли;
			Иначе
				Для Каждого СтрТч Из Объект[Стр.Сущность] Цикл
					Если СтрТч[Рекв] <> ВыборкаЗапроса[СтрТч.НомерСтроки-1][Рекв] Тогда
						Возврат Истина;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

//+++АК Susk (Суслин К.В.) 2018.05.08 
Процедура ОбменсБП2_0ПередЗаписьюДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	//ИП-00017910 2018.05.07
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ЛистУчета") Тогда	
		
		Узел = ОбщегоНазначенияПовтИсп.ПолучитьУзелОбменаПоКоду("ЛУП");
		
		Если ЗначениеЗаполнено(Узел) Тогда
			НужноРегать = Истина;
			
			Попытка
				НужноРегать = ПроверкаНеобходимостиРегистрацииЛУВУзелОбмена(Источник);
			Исключение
			КонецПопытки;
			
			Если НужноРегать Тогда
				Источник.ОбменДанными.Получатели.Добавить(Узел);
			КонецЕсли;
		КонецЕсли;
		
	//ИП-00019621^01	
	ИначеЕсли ТипЗнч(Источник) = Тип("ДокументОбъект.ЗакрытиеМесяца") Тогда
		
		Узел = ОбщегоНазначенияПовтИсп.ПолучитьУзелОбменаПоКоду("БП");
		
		Если ЗначениеЗаполнено(Узел) Тогда
			
			Если Источник.ВидЗакрытия = 2 Тогда			
				Источник.ОбменДанными.Получатели.Добавить(Узел);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// СИНХРОНИЗАЦИЯ НОМЕРОВ СЧЕТ-ФАКТУР
//////////////////////////////////////////////////////////////////////////

//+++АК Susk (Суслин К.В.) 2018.10.11 ИП-00020387
Процедура ПроставитьНомераСчетФактур_Из_Базы_БП() Экспорт
	
	СписокДок = ПолучитьСписокДокДляСинхронизацииНомеровСчетФактур();
	
	Если СписокДок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПодключениеУстановлено = Ложь;	
	ПодключениеКБазеБП = ВернутьПодключениеКБазеБУ(ПодключениеУстановлено);
	
	Если НЕ ПодключениеУстановлено Тогда
		Возврат;
	КонецЕсли;	
	
	ПроставитьВДокументыНомераСчетФактур(СписокДок, ПодключениеКБазеБП); // в рту проставляю номера счет-фактур из бух	
	
КонецПроцедуры

//+++АК Susk (Суслин К.В.) 2018.10.11 ИП-00020387
Функция ПолучитьСписокДокДляСинхронизацииНомеровСчетФактур()
	
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ РАЗРЕШЕННЫЕ
	              |	ОбъектыДляВыполненияОтложенныхДействий.Объект
	              |ИЗ
	              |	РегистрСведений.ОбъектыДляВыполненияОтложенныхДействий КАК ОбъектыДляВыполненияОтложенныхДействий
	              |ГДЕ
	              |	ОбъектыДляВыполненияОтложенныхДействий.ВидДействия = ЗНАЧЕНИЕ(Перечисление.ВидыОтложенныхДействийСОбъектами.СинхронизацияНомеровСчетФактур)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Объект");
	
КонецФункции

//+++АК Susk (Суслин К.В.) 2018.10.11 ИП-00020387
Процедура ПроставитьВДокументыНомераСчетФактур(СписокДок, ПодключениеКБазеБП)
	
	МетаданныеРТУ = ПодключениеКБазеБП.XMLTypeOf(ПодключениеКБазеБП.Документы.РеализацияТоваровУслуг.ПустаяСсылка()); 
	МетаданныеВП = ПодключениеКБазеБП.XMLTypeOf(ПодключениеКБазеБП.Документы.ВозвратТоваровПоставщику.ПустаяСсылка()); 
	
	СоответствиеФинБух = Новый Соответствие;
	МассивДокВЗапросБух = ПодключениеКБазеБП.NewObject("Массив");
	
	СписокДокВозврат = Новый Массив;
	СписокДокРТУ = Новый Массив;
	
	Для Каждого Док Из СписокДок Цикл
		
		ГуидФинСтрокой = Строка(Док.УникальныйИдентификатор());
		
		Если ТипЗнч(Док) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			МассивДокВЗапросБух.Добавить(ПодключениеКБазеБП.XMLValue(ПодключениеКБазеБП.FromXMLType(МетаданныеРТУ), ГуидФинСтрокой)); //по гуиду РТУ получаю док в бух. Они всегда равны по гуидам
			СписокДокРТУ.Добавить(Док);
		Иначе
			МассивДокВЗапросБух.Добавить(ПодключениеКБазеБП.XMLValue(ПодключениеКБазеБП.FromXMLType(МетаданныеВП), ГуидФинСтрокой)); //по гуиду РТУ получаю док в бух. Они всегда равны по гуидам
			СписокДокВозврат.Добавить(Док);
		КонецЕсли;
		
		СоответствиеФинБух.Вставить(ГуидФинСтрокой, Док); //делаю соответствие гуид-документ в фине
		
	КонецЦикла;
	
	СоответствиеНомеровСчФ = ПолучитьИзБПСоответствиеНомеровСчФДляДокументов(СоответствиеФинБух, ПодключениеКБазеБП, МассивДокВЗапросБух); //получаю номера счет-фактур
	ЗначРеквФинВозврат = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(СписокДокВозврат, "НомерИсходящегоСчетаФактуры,ДатаИсходящегоСчетаФактуры,НомерИсходящегоДокумента,ДатаИсходящегоДокумента");
	ЗначРеквФинРТУ = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(СписокДокРТУ, "НомерИсходящегоСчетаФактуры,ДатаИсходящегоСчетаФактуры,НомерИсходящегоДокумента,ДатаИсходящегоДокумента");
	
	ТаблицаПроверки = Новый ТаблицаЗначений;
	ТаблицаПроверки.Колонки.Добавить("Док");
	ТаблицаПроверки.Колонки.Добавить("НомерСчФ");
	ТаблицаПроверки.Колонки.Добавить("ДатаСчФ");
	ТаблицаПроверки.Колонки.Добавить("НеНайденВБух");
	
	//прописываю номера в РТУ фина, если они не совпадают с теми, что в базе.
	Для Каждого Док Из СписокДок Цикл
		СтруктураНомерДата = СоответствиеНомеровСчФ.Получить(Док);
		НомерСчФБух = "";
		ДатаСчФБух = Дата("00010101");	
		
		НовСтрТЗПроверки = ТаблицаПроверки.Добавить();
		НовСтрТЗПроверки.Док = Док;
		НовСтрТЗПроверки.НеНайденВБух = Ложь;		
		
		Если СтруктураНомерДата = Неопределено Тогда		
			НовСтрТЗПроверки.НеНайденВБух = Истина;
			Продолжить;
		КонецЕсли;
		
		НомерСчФБух = СтруктураНомерДата["Номер"];
		ДатаСчФБух = НачалоДня(СтруктураНомерДата["Дата"]);
		
		Если ТипЗнч(Док) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			ЗначенияРеквизитовФин = ЗначРеквФинРТУ.Получить(Док);
		Иначе
			ЗначенияРеквизитовФин = ЗначРеквФинВозврат.Получить(Док);
		КонецЕсли;
		
		НовСтрТЗПроверки.НомерСчФ = НомерСчФБух;
		НовСтрТЗПроверки.ДатаСчФ = ДатаСчФБух;
		
		Если СокрЛП(ЗначенияРеквизитовФин["НомерИсходящегоСчетаФактуры"]) <> СокрЛП(НомерСчФБух)
			ИЛИ СокрЛП(ЗначенияРеквизитовФин["НомерИсходящегоДокумента"]) <> СокрЛП(НомерСчФБух) 
			ИЛИ ЗначенияРеквизитовФин["ДатаИсходящегоСчетаФактуры"] <> ДатаСчФБух 
			ИЛИ ЗначенияРеквизитовФин["ДатаИсходящегоДокумента"] <> ДатаСчФБух Тогда
			
			ДокОб = Док.ПолучитьОбъект();
			ДокОб.НомерИсходящегоСчетаФактуры = НомерСчФБух;
			ДОкОб.ДатаИсходящегоСчетаФактуры = ДатаСчФБух;
			ДокОб.НомерИсходящегоДокумента = НомерСчФБух;
			ДокОб.ДатаИсходящегоДокумента = ДатаСчФБух;
			ДокОб.ОбменДанными.Загрузка = Истина;
			
			Попытка
				ДокОб.Записать(РежимЗаписиДокумента.Запись);
			Исключение
			КонецПопытки;	
						
		КонецЕсли;
		
	КонецЦикла; 
	
	//проверим вписались ли номера в документ и если всё ок, то удалим с регистра синхронизации.
	ПроверитьСинхронизациюНомеровСчетФактур_ОчиститьРегистрСинхронизации(ТаблицаПроверки);
	
КонецПроцедуры

//+++АК Susk (Суслин К.В.) 2018.10.11 ИП-00020387
Функция ПолучитьИзБПСоответствиеНомеровСчФДляДокументов(СоответствиеФинБух, ПодключениеКБазеБП, МассивВЗапросДок)
	
	Запрос = ПодключениеКБазеБП.NewObject("Запрос");
	Запрос.Текст = "ВЫБРАТЬ
	|	СчетФактураВыданный.Номер КАК НомерСчФ,
	|	СчетФактураВыданный.Дата КАК ДатаСчФ,
	|	СчетФактураВыданный.ДокументОснование
	|ИЗ
	|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|ГДЕ
	|	НЕ СчетФактураВыданный.ПометкаУдаления
	|	И СчетФактураВыданный.ДокументОснование В (&МассивДок)";
	
	Запрос.УстановитьПараметр("МассивДок", МассивВЗапросДок);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СоответствиеНомеровСчФ = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		ДокФин = СоответствиеФинБух.Получить(ПодключениеКБазеБП.XMLСтрока(Выборка.ДокументОснование));		
		
		СтруктураНомерДата = Новый Структура;
		СтруктураНомерДата.Вставить("Номер", Выборка.НомерСчФ);
		СтруктураНомерДата.Вставить("Дата", Выборка.ДатаСчФ);
		
		СоответствиеНомеровСчФ.Вставить(ДокФин, СтруктураНомерДата);
	КонецЦикла;
	
	Возврат СоответствиеНомеровСчФ;	
	
КонецФункции

//+++АК Susk (Суслин К.В.) 2018.10.11 ИП-00020387
Процедура ПроверитьСинхронизациюНомеровСчетФактур_ОчиститьРегистрСинхронизации(ТаблицаПроверки)
	
	СписокДокВозврат = Новый Массив;
	СписокДокРТУ = Новый Массив;
	
	Для Каждого Стр Из ТаблицаПроверки Цикл
		Если ТипЗнч(Стр.Док) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			СписокДокРТУ.Добавить(Стр.Док);
		Иначе
			СписокДокВозврат.Добавить(Стр.Док);
		КонецЕсли;
	КонецЦикла;

	ЗначРеквФинРТУ = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(СписокДокРТУ, "НомерИсходящегоСчетаФактуры,ДатаИсходящегоСчетаФактуры,НомерИсходящегоДокумента,ДатаИсходящегоДокумента");
	ЗначРеквФинВозврат = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(СписокДокВозврат, "НомерИсходящегоСчетаФактуры,ДатаИсходящегоСчетаФактуры,НомерИсходящегоДокумента,ДатаИсходящегоДокумента");
	
	Для Каждого Стр Из ТаблицаПроверки Цикл
			
		Если ТипЗнч(Стр.Док) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			ЗначенияРеквизитовДокумента = ЗначРеквФинРТУ.Получить(Стр.Док);
		Иначе
			ЗначенияРеквизитовДокумента = ЗначРеквФинВозврат.Получить(Стр.Док);
		КонецЕсли;
		
		Набор = РегистрыСведений.ОбъектыДляВыполненияОтложенныхДействий.СоздатьНаборЗаписей();
		Набор.Отбор.Объект.Установить(Стр.Док);
		Набор.Отбор.ВидДействия.Установить(Перечисления.ВидыОтложенныхДействийСОбъектами.СинхронизацияНомеровСчетФактур);
		Набор.Прочитать();
		
		//отдельно не найденные в бух
		Если Стр.НеНайденВБух Тогда
			
			Для Каждого Запись Из Набор Цикл
				Запись.СчетчикДействий = Запись.СчетчикДействий + 1;
			КонецЦикла;
			
			Набор.Записать();

			Продолжить;
			
		КонецЕсли;
		
		Если Стр.НомерСчФ = ЗначенияРеквизитовДокумента.НомерИсходящегоСчетаФактуры
			И Стр.НомерСчФ = ЗначенияРеквизитовДокумента.НомерИсходящегоДокумента
			И Стр.ДатаСчФ = ЗначенияРеквизитовДокумента.ДатаИсходящегоСчетаФактуры
			И Стр.ДатаСчФ = ЗначенияРеквизитовДокумента.ДатаИсходящегоДокумента Тогда
				Набор.Очистить();
		Иначе
			
			Для Каждого Запись Из Набор Цикл
				Запись.СчетчикДействий = Запись.СчетчикДействий + 1;
			КонецЦикла;
				
		КонецЕсли;
		
		Набор.Записать();
			
	КонецЦикла;
	
КонецПроцедуры




