﻿
// Возвращает вид договора с контрагентом по виду операции
//
Функция ОпределитьВидДоговораСКонтрагентом(ВидОперации = Неопределено) Экспорт

	СПоставщиком = Новый СписокЗначений;
	СПоставщиком.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
	СПоставщиком.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомитентом);
	СПоставщиком.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером);

	СПокупателем = Новый СписокЗначений;
	СПокупателем.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	СПокупателем.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером);
	СПокупателем.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомитентом);

	Прочее = Новый СписокЗначений;
	Прочее.Добавить(Перечисления.ВидыДоговоровКонтрагентов.Прочее);

	Финансовый = Новый СписокЗначений;
	Финансовый.Добавить(Перечисления.ВидыДоговоровКонтрагентов.Финансовый);
	
	Если ЗначениеЗаполнено(ВидОперации) тогда

		//Определение вида операции

		ВидДоговораПоВидуОпераций = Новый Соответствие();

		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.ОплатаПостояннойЧастиАрендыАрендодателю,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.ОплатаПеременнойЧастиАрендыАрендодателю,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.ОплатаДепозитаАрендодателю,СПоставщиком);
		//ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.РасчетыПоКредитамИЗаймам,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.ВозвратПостояннойЧастиАрендыАрендатору,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.ВозвратПеременнойЧастиАрендыАрендатору,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийРКО.ВозвратДепозитаАрендатору,СПокупателем);

		//ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПКО.ОплатаПокупателя,СПокупателем);
		//ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПКО.РасчетыПоКредитамИЗаймам,Прочее);
		//ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПКО.ВозвратОтПоставщика,СПоставщиком);

		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ОплатаПоставщику,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ОплатаПостояннойЧастиАрендыАрендодателю,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ОплатаПеременнойЧастиАрендыАрендодателю,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ОплатаДепозитаАрендодателю,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ОплатаУслугБанка,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.РасчетыПоКредитамИЗаймам,Прочее);
		
		//+++АК POZM 2017.10.27 ИП-00017017
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.РасчетыПоКредитамИЗаймам,Финансовый);
		//---АК POZM 
		
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ВозвратПокупателю,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ВозвратПостояннойЧастиАрендыАрендатору,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ВозвратПеременнойЧастиАрендыАрендатору,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ВозвратДепозитаАрендатору,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ПрочиеРасчетыСКонтрагентами,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ОтменаЭквайринга,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.ОтменаЭквайрингаСводно,Прочее);

		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПокупателя,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПостояннойЧастиАрендыОтАрендатора,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПеременнойЧастиАрендыОтАрендатора,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаДепозитаОтАрендатора,СПокупателем);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДепозитаОтАрендодателя,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратОтПоставщика,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратПостояннойЧастиАрендыОтАрендодателя,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратПеременнойЧастиАрендыОтАрендодателя,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДепозитаОтАрендодателя,СПоставщиком);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.РасчетыПоКредитамИЗаймам,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПриобретениеИностраннойВалюты,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПоступленияОтПродажиИностраннойВалюты,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.Эквайринг,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ЭквайрингСводно,Прочее);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочиеРасчетыСКонтрагентами,Прочее);
		
		//+++АК LAGP 2018.05.31 ИП-00018822 Загрузка инкассации Сбербанк в документ "Поступление в банк", находит договор, но вида операции документа "инкассация" нет в списке разрешенных.
		//ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.Инкассация,Прочее);
		//---АК LAGP
		
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийППИсходящее.РазмещениеДепозита,Финансовый);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДепозита,Финансовый);
		ВидДоговораПоВидуОпераций.Вставить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПоступлениеПроцентовПоДепозиту,Финансовый);
		
		ВидДоговора = ВидДоговораПоВидуОпераций[ВидОперации];

		Если НЕ ВидДоговора = Неопределено Тогда
			Возврат ВидДоговора;
		Иначе
			Возврат Новый СписокЗначений;

		КонецЕсли;

	Иначе

		Возврат Новый СписокЗначений;

	Конецесли;

КонецФункции // ОпределитьВидДоговораСКонтрагентом()

//+++АК LAGP 2018.09.14 ИП-00019778 Определение основного договора контрагента по дополнительным параметрам
//Копия функции ДопМодульСервер.ПолучитьОсновнойДоговорКонтрагента с добавлением ДополнительныхПараметров
Функция ПолучитьОсновнойДоговорКонтрагента(мОрганизация, мКонтрагент, мДата = Неопределено, СписокВидовДоговоров = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если мДата = Неопределено Тогда
		мДата = ТекущаяДата();
	КонецЕсли;
	
	ЕстьОтборПоВидамДоговоров = (НЕ СписокВидовДоговоров = Неопределено);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация"	, мОрганизация);
	Запрос.УстановитьПараметр("Контрагент"	, мКонтрагент);
	Запрос.УстановитьПараметр("Дата"		, мДата);
	Если ЕстьОтборПоВидамДоговоров Тогда
		Запрос.УстановитьПараметр("ВидыДоговоров", СписокВидовДоговоров);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОсновныеДоговораКонтрагентовСрезПоследних.ДоговорКонтрагента
	|ИЗ
	|	РегистрСведений.ОсновныеДоговораКонтрагентов.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И Контрагент = &Контрагент
	|				И &УсловиеПоВидамДоговоров) КАК ОсновныеДоговораКонтрагентовСрезПоследних";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "
	|				И &УсловиеПоВидамДоговоров",
		?(ЕстьОтборПоВидамДоговоров,
			?(ТипЗнч(СписокВидовДоговоров) = Тип("СписокЗначений") ИЛИ ТипЗнч(СписокВидовДоговоров) = Тип("Массив"), "
	|				И ДоговорКонтрагента.ВидДоговора В(&ВидыДоговоров)", "
	|				И ДоговорКонтрагента.ВидДоговора = &ВидыДоговоров"), ""));
			
	//+++АК LAGP 2018.09.14 ИП-00019778 Определение основного договора контрагента по дополнительным параметрам
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") И ДополнительныеПараметры.Свойство("ТипДоговора") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ") КАК ОсновныеДоговораКонтрагентовСрезПоследних", Символы.ПС + " И ДоговорКонтрагента.ТипДоговора = &ТипДоговора) КАК ОсновныеДоговораКонтрагентовСрезПоследних");	
		Запрос.УстановитьПараметр("ТипДоговора", ДополнительныеПараметры.ТипДоговора);
	КонецЕсли;
	//---АК LAGP
			
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ДоговорКонтрагента;
	Иначе
		Возврат Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции	

#Если Клиент Тогда
	
Процедура ЗаполнитьРасшифровкуПлатежей(СтруктураПараметров) Экспорт
	
	Если СтруктураПараметров.Организация.Пустая() Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана организация.");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтруктураПараметров.Контрагент) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан контрагент.");
		Возврат;
	КонецЕсли;
	
	ОбработкаОбъект = Обработки.ПодборПараметровРасшифровкиПлатежаДляАренды.Создать();
	ОбработкаОбъект.КурсДокумента				=СтруктураПараметров.КурсДокумента;
	ОбработкаОбъект.КратностьДокумента			=СтруктураПараметров.КратностьДокумента;
	ОбработкаОбъект.Контрагент					=СтруктураПараметров.Контрагент;
	ОбработкаОбъект.Организация					=СтруктураПараметров.Организация;
	ОбработкаОбъект.ВалютаДокумента				=СтруктураПараметров.ВалютаДокумента;
	ОбработкаОбъект.ДатаДок						=СтруктураПараметров.ДатаДок;
	ОбработкаОбъект.ВидОперацииДок				=СтруктураПараметров.ВидОперацииДок;
	ОбработкаОбъект.РасшифровкаПлатежаДок		=СтруктураПараметров.РасшифровкаПлатежа;
	ОбработкаОбъект.СуммаДляПодбора				=СтруктураПараметров.СуммаДокумента;
	СтруктураПараметров.Свойство("СсылкаНаДокумент", ОбработкаОбъект.ДокументСсылка);
	СтруктураПараметров.Свойство("ОтражатьВБухгалтерскомУчете", ОбработкаОбъект.ОтражатьВБухгалтерскомУчете);
	СтруктураПараметров.Свойство("ОтбиратьНачисленияАрендаторам", ОбработкаОбъект.ОтбиратьНачисленияАрендаторам);
	СтруктураПараметров.Свойство("ОтбиратьНачисленияАрендодателям", ОбработкаОбъект.ОтбиратьНачисленияАрендодателям);
	ОбработкаОбъект.ЕстьПодбор					=Ложь;
	
	Если СтруктураПараметров.Интерактивно Тогда
		
		ТекстВидОперации=СтруктураПараметров.ВидОперацииДок.Метаданные().Имя;
		ФормаНастройки=ОбработкаОбъект.ПолучитьФорму("ПараметрыЗаполнения");
		ФормаНастройки.ОткрытьМодально();
		
	Иначе
		
		СтруктураПараметровАвто=СтруктураПараметров.СтруктураПараметровАвто;
		
		ОбработкаОбъект.ПодбиратьСумму=СтруктураПараметровАвто.ПодбиратьСумму;
		ОбработкаОбъект.СпособЗаполнения=СтруктураПараметровАвто.СпособЗаполнения;
		ОбработкаОбъект.СуммаДляПодбора=СтруктураПараметровАвто.СуммаДляПодбора;
		
		Если СтруктураПараметровАвто.Свойство("ОтборПоДоговорам") Тогда
			ОбработкаОбъект.ПостроительОтбораДоговоров.УстановитьНастройки(СтруктураПараметровАвто.ОтборПоДоговорам, Истина, Ложь, Ложь, Ложь, Ложь)
		КонецЕсли;
		
		ОбработкаОбъект.ЗаполнитьРасшифровкуПоДолгам(СтруктураПараметровАвто.ПодборПоСуммеПлатежа,Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРасшифровкуПлатежейПоСчетам(СтруктураПараметров) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СтруктураПараметров.Контрагент) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан контрагент.");
		Возврат;
	КонецЕсли;
	
	// Открываем форму подбора.
	
	ОбработкаОбъект=Обработки.ПодборПараметровРасшифровкиПлатежаДляАренды.Создать();
	ОбработкаОбъект.ДокументСсылка					=СтруктураПараметров.ДокументСсылка;
	ОбработкаОбъект.КурсДокумента					=СтруктураПараметров.КурсДокумента;
	ОбработкаОбъект.КратностьДокумента				=СтруктураПараметров.КратностьДокумента;
	ОбработкаОбъект.Контрагент						=СтруктураПараметров.Контрагент;
	ОбработкаОбъект.Организация						=СтруктураПараметров.Организация;
	ОбработкаОбъект.ВалютаДокумента					=СтруктураПараметров.ВалютаДокумента;
	ОбработкаОбъект.ДатаДок							=СтруктураПараметров.ДатаДок;
	ОбработкаОбъект.ВидОперацииДок					=СтруктураПараметров.ВидОперацииДок;
	ОбработкаОбъект.СуммаДляПодбора					=СтруктураПараметров.СуммаДокумента;
	ОбработкаОбъект.РасшифровкаПлатежаДок			=СтруктураПараметров.РасшифровкаПлатежаДок;
	ОбработкаОбъект.ОтражатьВБухгалтерскомУчете		=СтруктураПараметров.ОтражатьВБухгалтерскомУчете;
	ОбработкаОбъект.ЕстьПодбор						= НЕ СтруктураПараметров.ЗакрыватьПриВыборе;
	ОбработкаОбъект.НазначениеПлатежа		        =СтруктураПараметров.НазначениеПлатежа;
	СтруктураПараметров.Свойство("ОтбиратьНачисленияАрендаторам", ОбработкаОбъект.ОтбиратьНачисленияАрендаторам);
	СтруктураПараметров.Свойство("ОтбиратьНачисленияАрендодателям", ОбработкаОбъект.ОтбиратьНачисленияАрендодателям);
	
	ФормаПодбора = ОбработкаОбъект.ПолучитьФорму("ФормаПодбораПоСчетам", СтруктураПараметров.ФормаДокумента, "ФормаПодбораПоСчетам");
	
	ФормаПодбора.РежимВыбора=Истина;
	ФормаПодбора.ЗакрыватьПриВыборе=СтруктураПараметров.ЗакрыватьПриВыборе;
	
	ФормаПодбора.ОткрытьМодально();
	СтруктураПараметров.НазначениеПлатежа = ОбработкаОбъект.НазначениеПлатежа;
	
КонецПроцедуры
// Получает договор контрагента по умолчанию с учетом условий отбора. Возвращается основной договор или единственный или пустая ссылка
//
// Параметры
//  ВладелецДоговора	–	<СправочникСсылка.Контрагенты> 
//							Контрагент, договор которого нужно получить
//  ОрганизацияДоговора	–	<СправочникСсылка.Организации> 
//							Организация, договор которой нужно получить
//  СписокВидовДоговора	–	<Массив> или <СписокЗначений>, состоящий из значений типа <ПеречислениеСсылка.ВидыДоговоровКонтрагентов> 
//							Нужные виды договора
//  СтруктураПараметров	–	<Структура>
//							Структура дополнительных параметров отбора договоров по реквизитам.
//							Элементы структуры СтруктураПараметров:
//							Ключ - имя реквизита договора, Значение - еще одна структура
//							
//							Элементы структуры, которая находится в Значение:
//							Ключ - "ЗначениеОтбора", Значение - значение реквизита договора для отбора. Обязательный элемент.
//							Ключ - "ВидСравненияОтбора", Значение - <ВидСравнения>. Необязательный элемент, по умолчанию ВидСравнения.Равно
//
// Возвращаемое значение:
//   <СправочникСсылка.ДоговорыКонтрагентов> – найденный счет или пустая ссылка
//
Функция УстановитьДоговорКонтрагента(ДоговорКонтрагента,ВладелецДоговора, ОрганизацияДоговора, СписокВидовДоговора=неопределено, СтруктураПараметров = Неопределено) Экспорт

	НовыйДоговор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();

	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоговорыКонтрагентов.Ссылка,
	|	ВЫБОР
	|		КОГДА СправочникВладелец.Ссылка ЕСТЬ НЕ NULL 
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК Приоритет
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК СправочникВладелец
	|		ПО ДоговорыКонтрагентов.Владелец = СправочникВладелец.Ссылка
	|			И ДоговорыКонтрагентов.Ссылка = СправочникВладелец.ОсновнойДоговорКонтрагента
	|ГДЕ
	|	&ТекстФильтра
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет,
	|	ДоговорыКонтрагентов.Код УБЫВ";
	
	Запрос.УстановитьПараметр("ВладелецДоговора", ВладелецДоговора);
	ГоловнаяОрганизацияДоговора = ОрганизацияДоговора;
	Запрос.УстановитьПараметр("ОрганизацияДоговора", ГоловнаяОрганизацияДоговора);
	Запрос.УстановитьПараметр("СписокВидовДоговора", СписокВидовДоговора);
	
	ТекстФильтра = "
	|	ДоговорыКонтрагентов.Владелец = &ВладелецДоговора
	|	И ДоговорыКонтрагентов.Организация = &ОрганизацияДоговора
	|	И ДоговорыКонтрагентов.ПометкаУдаления = ЛОЖЬ"
	+?(СписокВидовДоговора<>неопределено,"
	|	И ДоговорыКонтрагентов.ВидДоговора В (&СписокВидовДоговора)","");
	
	Если ТипЗнч(СтруктураПараметров) = Тип("Структура") Тогда
		Для каждого Параметр Из СтруктураПараметров Цикл
			ИмяРеквизита = Параметр.Ключ;
			СтруктураОтбора = Параметр.Значение;
			ВидСравненияЗапроса = ПолучитьВидСравненияДляЗапроса(СтруктураОтбора);
			ТекстФильтра = ТекстФильтра + "
			|	И ДоговорыКонтрагентов." + ИмяРеквизита + " " + ВидСравненияЗапроса + " (&" + ИмяРеквизита + ")";
			Запрос.УстановитьПараметр(ИмяРеквизита, СтруктураОтбора.ЗначениеОтбора);
		КонецЦикла;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстФильтра", ТекстФильтра);
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
	
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		НайденОсновнойДоговор = Выборка.Приоритет = 1;
		НайденОдинДоговор     = Выборка.Количество() = 1;
		
		Если НайденОсновнойДоговор ИЛИ НайденОдинДоговор Тогда
			НовыйДоговор = Выборка.Ссылка;
		Иначе
			пСтрока = Запрос.Выполнить().Выгрузить().Найти(ДоговорКонтрагента, "Ссылка");
			Если пСтрока <> Неопределено Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НовыйДоговор) Тогда	
		ДоговорКонтрагента = НовыйДоговор;
		Возврат Истина;
	Иначе
		ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции // ПолучитьДоговорКонтрагента()

// Преобразует значение системного перечисления ВидСравнения в текст для запроса
//
// Параметры
//  СтруктураОтбора		–	<Структура>
//							Структура параметров отбора. Если есть элемент структуры с ключом "ВидСравненияОтбора",
//							значение этого элемента преобразуется в текст для запроса.
//							Необязательный элемент, по умолчанию ВидСравнения.Равно
//
// Возвращаемое значение:
//   <Строка> – текст сравнения для запроса
//
Функция ПолучитьВидСравненияДляЗапроса(СтруктураОтбора)

	Если НЕ СтруктураОтбора.Свойство("ВидСравненияОтбора") Тогда
		Возврат "=";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.Равно Тогда
		Возврат "=";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеРавно Тогда
		Возврат "<>";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.ВСписке Тогда
		Возврат "В";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеВСписке Тогда
		Возврат "НЕ В";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.ВИерархии Тогда
		Возврат "В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.ВСпискеПоИерархии Тогда
		Возврат "В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеВСпискеПоИерархии Тогда
		Возврат "НЕ В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеВИерархии Тогда
		Возврат "НЕ В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.Больше Тогда
		Возврат ">";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.БольшеИлиРавно Тогда
		Возврат ">=";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.Меньше Тогда
		Возврат "<";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.МеньшеИлиРавно Тогда
		Возврат "<=";
	Иначе // другие варианты 
		Возврат "=";
	КонецЕсли;

КонецФункции // ПолучитьВидСравненияДляЗапроса()

#КонецЕсли