﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	СуммаДокумента = Товары.Итог("Сумма");
	
	//mind всегда будем записывать требовнаие накладную концом дня, чтобы в бухгалтерию тоже концом дня переносилось
	Дата = КонецДня(Дата);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	//+++susk
	//ИП-00016544
	Если НовоеПроведение Тогда
		ОБработкаПРоведения_Нов(Отказ, РежимПроведения);
		Возврат;
	Иначе
	//---susk
		
		Если ВидСписания = Перечисления.ВидыСписанияТребованиеНакладная.СписаниеМатериалов Тогда
			//предварительно очистим движения, чтобы запрос взял правильные данные для отработки
			Движения.Финансовый.Очистить();
			Движения.Финансовый.Записать();
			ВыполнитьСписаниеМатериалов(Отказ);
			
		Иначе 	
			//Контроль заполнения
			Если НЕ (РеквизитыЗаполнены() И ЕстьОстатки()) Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
			//СтруктураНастроек = ОбщегоНазначенияСервер.ПолучитьНастройкиОтраженияОперацийВУчете(Перечисления.ВидыОперацийВУчете.СписаниеОтходовОтПереработки, Дата);
			
			Движения.Финансовый.Записывать = Истина;
			Движения.Финансовый.Очистить();
			
			//Если ВидСписания = Перечисления.ВидыСписанияТребованиеНакладная.НаУказанныйСчет Тогда
			//	ВыполнитьДвижения_НаСчет(СтруктураНастроек);
			//Иначе
			
			
			
			
			ВыполнитьДвижения_НаТовар(Отказ);
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеМатериалов(отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(Дата));
	Запрос.УстановитьПараметр("Орг", Организация);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТребованиеНакладнаяТовары.Ссылка,
		|	ТребованиеНакладнаяТовары.Номенклатура,
		|	ТребованиеНакладнаяТовары.Количество КАК КоличествоКт,
		|	ВЫБОР
		|		КОГДА ТребованиеНакладнаяТовары.Количество = ЕСТЬNULL(ВЗ_Себестоимость.КоличествоОстаток, 0)
		|			ТОГДА ВЗ_Себестоимость.СуммаОстаток
		|		ИНАЧЕ ТребованиеНакладнаяТовары.Количество * ЕСТЬNULL(ВЗ_Себестоимость.Себестоимость, 0)
		|	КОНЕЦ КАК Сумма,
		|	ТребованиеНакладнаяТовары.СчетЗатрат КАК СчетДт,
		|	ТребованиеНакладнаяТовары.Субконто1 КАК СубконтоДт1,
		|	ТребованиеНакладнаяТовары.Субконто2 КАК СубконтоДт2,
		|	ТребованиеНакладнаяТовары.Субконто3 КАК СубконтоДт3,
		|	ТребованиеНакладнаяТовары.СчетУчета КАК СчетКт,
		|	ТребованиеНакладнаяТовары.Номенклатура КАК СубконтоКт1,
		|	ТребованиеНакладнаяТовары.СубконтоУчет2 КАК СубконтоКт2,
		|	ТребованиеНакладнаяТовары.СубконтоУчет3 КАК СубконтоКт3,
		|	ТребованиеНакладнаяТовары.Ссылка.Организация,
		|	ТребованиеНакладнаяТовары.Ссылка.Дата КАК Период
		|ИЗ
		|	Документ.ТребованиеНакладная.Товары КАК ТребованиеНакладнаяТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ФинансовыйОстатки.Счет КАК Счет,
		|			ФинансовыйОстатки.Субконто1 КАК Субконто1,
		|			ВЫБОР
		|				КОГДА ФинансовыйОстатки.КоличествоОстаток = 0
		|					ТОГДА 0
		|				ИНАЧЕ ВЫБОР
		|						КОГДА ФинансовыйОстатки.СуммаОстаток / ФинансовыйОстатки.КоличествоОстаток < 0
		|							ТОГДА 0
		|						ИНАЧЕ ФинансовыйОстатки.СуммаОстаток / ФинансовыйОстатки.КоличествоОстаток
		|					КОНЕЦ
		|			КОНЕЦ КАК Себестоимость,
		|			ФинансовыйОстатки.КоличествоОстаток КАК КоличествоОстаток,
		|			ФинансовыйОстатки.СуммаОстаток КАК СуммаОстаток
		|		ИЗ
		|			РегистрБухгалтерии.Финансовый.Остатки(
		|					&ДатаКон,
		|					Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Финансовый.Материалы)),
		|					,
		|					Организация = &Орг
		|						И Субконто1 В
		|							(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|								ТребованиеНакладнаяТовары.Номенклатура
		|							ИЗ
		|								Документ.ТребованиеНакладная.Товары КАК ТребованиеНакладнаяТовары
		|							ГДЕ
		|								ТребованиеНакладнаяТовары.Ссылка = &Ссылка)) КАК ФинансовыйОстатки) КАК ВЗ_Себестоимость
		|		ПО ТребованиеНакладнаяТовары.Номенклатура = ВЗ_Себестоимость.Субконто1
		|			И ТребованиеНакладнаяТовары.СчетУчета = ВЗ_Себестоимость.Счет
		|ГДЕ
		|	ТребованиеНакладнаяТовары.Ссылка = &Ссылка";

	ТаблицаДвиженияФинансовый = Запрос.Выполнить().Выгрузить();
	
	ЭтотОбъект.Движения.Финансовый.Записывать = Истина;
    ЭтотОбъект.Движения.Финансовый.Очистить();
	
	Для каждого СтрокаДвижение из ТаблицаДвиженияФинансовый Цикл
		
		НоваяПроводка = ЭтотОбъект.Движения.Финансовый.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяПроводка,СтрокаДвижение);
		
		БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, 1, СтрокаДвижение.СубконтоДт1);
		БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, 2, СтрокаДвижение.СубконтоДт2);
		БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, 3, СтрокаДвижение.СубконтоДт3);

		БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, 1, СтрокаДвижение.СубконтоКт1);
		БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, 2, СтрокаДвижение.СубконтоКт2);
		БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, 3, СтрокаДвижение.СубконтоКт3);
		НоваяПроводка.СторонаПроводкиДляПересчетаПоСебестоимости = "Кт";
		
	КонецЦикла;
	
	
КонецПроцедуры

Функция РеквизитыЗаполнены()
	
	Результат = Истина;
	
	Если Не ЗначениеЗаполнено(ВидСписания) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Поле ""Вид списания"" не заполнено");
		Результат = Ложь;
	КонецЕсли;
	
	Если ВидСписания = Перечисления.ВидыСписанияТребованиеНакладная.РаспределениеНаПоступившийТовар Тогда
		Если Не ЗначениеЗаполнено(Контрагент) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Поле ""Контрагент"" не заполнено");
			Результат = Ложь;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Поле ""Дата начала"" не заполнено");
			Результат = Ложь;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ДатаОкончания) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Поле ""Дата окончания"" не заполнено");
			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;
		
	Если Товары.Количество()=0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнена таблица ""Товары""");
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЕстьОстатки()
	
	Результат = Истина;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
							|	ТоварыНаСкладахОстатки.Номенклатура,
							|	ТоварыНаСкладахОстатки.КоличествоОстаток
							|ИЗ
							|	РегистрНакопления.ТоварыНаСкладах.Остатки(&Дата, Склад = &Склад И Номенклатура В (&Список)) КАК ТоварыНаСкладахОстатки
							|	");
							
	Запрос.Параметры.Вставить("Дата",	Дата);
	Запрос.Параметры.Вставить("Склад",	Склад);
	Запрос.Параметры.Вставить("Список",	Товары.ВыгрузитьКолонку("Номенклатура"));
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТЧ Из Товары Цикл
		
		СтрокаОстатка = Таблица.Найти(СтрокаТЧ.Номенклатура);
		ВНаличии = ?(СтрокаОстатка <> Неопределено, СтрокаОстатка.КоличествоОстаток, 0);
		
		Если СтрокаТЧ.Количество <= ВНаличии Тогда
			Продолжить;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Строка " + Строка(СтрокаТЧ.НомерСтроки) +  ". " + Строка(СтрокаТЧ.Номенклатура) + ". Требуется " + Строка(СтрокаТЧ.Количество) + ", в наличии " + Строка(ВНаличии));
			Результат = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ВыполнитьДвижения_НаСчет(СтруктураНастроек)
	
	//!!! - возможно, убрать эту процедуру, когда заказчика всё устроит
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		
		//Дт<СчетЗатрат> - Кт41.1 (41.2)
		Проводка = Движения.Финансовый.Добавить();
		Проводка.Период	= Дата;
		Проводка.Сумма	= СтрокаТЧ.Сумма;
		
		Проводка.СчетДт								= СтрокаТЧ.СчетЗатрат;
		Проводка.СубконтоДт.ТорговыеТочки			= СтрокаТЧ.Субконто1;
		Проводка.СубконтоДт.СтатьиДоходовРасходов	= СтрокаТЧ.Субконто2;
		Проводка.СубконтоДт.ЦФО						= СтрокаТЧ.Субконто3;
		
		Проводка.СчетКт								= ?(СтрокаТЧ.Номенклатура.ВидНоменклатуры=Перечисления.ВидыНоменклатуры.Товар,
														ПланыСчетов.Финансовый.НайтиПоКоду("41.1"),
														ПланыСчетов.Финансовый.НайтиПоКоду("41.2"));
		Проводка.СубконтоКт.МестаХранения			= Склад;
		Проводка.СубконтоКт.Товары					= СтрокаТЧ.Номенклатура;
		Проводка.СубконтоКт.СтатьиТовароДвижения	= СтруктураНастроек.СтатьяДвиженияТоваров;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьДвижения_НаТовар(Отказ)
	
	мСуммаВсего = Товары.Итог("Сумма");
	
	СтруктураНастроек = ОбщегоНазначенияСервер.ПолучитьНастройкиОтраженияОперацийВУчете(Перечисления.ВидыОперацийВУчете.СписаниеПрочихРасходов, Дата);
	Если НЕ ЗначениеЗаполнено(СтруктураНастроек.СтатьяДвиженияТоваров) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не настроен вид отражения операций в учете ""Списание прочих расходов""! Проведение невозможно.");
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;				
	КонецЕсли;

	ТаблицаПоступлений = ПолучитьРаспределениеСуммы(мСуммаВсего);
	
	Если ТаблицаПоступлений.Количество() = 0 Тогда
		Сообщить("Нет базы к распределению! Проведение невозможно.");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	//Округление - обязательно
	ТаблицаПоступлений.Колонки.Добавить("СуммаОкр");
	Для Каждого Строка Из ТаблицаПоступлений Цикл
		Строка.СуммаОкр = Окр(Строка.Сумма, 2);
	КонецЦикла;
	
	//Вспомогательная таблица
	ТаблицаУпаковки = Товары.Выгрузить();
	
	мСуммаРаспределить = мСуммаВсего;
	Сч1	= 0;
	Сч2	= 0;
	Пока мСуммаРаспределить > 0 Цикл
		
		//Что распределяем
		СтрокаУпаковки = ТаблицаУпаковки[Сч1];
		
		//На что распределяем
		СтрокаПоступления = ТаблицаПоступлений[Сч2];
		
		//Распределение
		Если СтрокаПоступления.СуммаОкр < СтрокаУпаковки.Сумма Тогда
			
			СуммаВПроводку				= СтрокаПоступления.СуммаОкр;
			СтрокаУпаковки.Сумма		= СтрокаУпаковки.Сумма - СуммаВПроводку;		//хвост упаковки нужно будет дораспределить
			Сч2							= Сч2 + 1;										//следующий поступивший товар
			
			
		ИначеЕсли СтрокаУпаковки.Сумма < СтрокаПоступления.СуммаОкр  Тогда
			
			СуммаВПроводку				= СтрокаУпаковки.Сумма;
			СтрокаПоступления.СуммаОкр	= СтрокаПоступления.СуммаОкр - СуммаВПроводку;	//хвост поступления нужно будет дораспределить
			Сч1							= Сч1 + 1;										//следующая упаковка
			
		ИначеЕсли СтрокаУпаковки.Сумма = СтрокаПоступления.СуммаОкр  Тогда
			
			СуммаВПроводку				= СтрокаУпаковки.Сумма;
			Сч1							= Сч1 + 1;										//следующая упаковка
			Сч2							= Сч2 + 1;										//следующий поступивший товар
			
		КонецЕсли;
			
		
		Проводка = ДобавитьПроводку(СтрокаУпаковки, СтрокаПоступления, СуммаВПроводку, СтруктураНастроек.СтатьяДвиженияТоваров);
		мСуммаРаспределить = мСуммаРаспределить - СуммаВПроводку;
		
		//Иногда остается 1 копейка, нужен доп. контроль выхода за границы массива
		Если Сч1 = ТаблицаУпаковки.Количество() Или Сч2 = ТаблицаПоступлений.Количество() Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	//Разницу округления считать надо именно по итогам
	Таблица = Движения.Финансовый.Выгрузить(, "Сумма");
	РазницаОкругления = мСуммаВсего - Таблица.Итог("Сумма");
	
	//Её - в последнюю проводку
	Если РазницаОкругления <> 0 Тогда 
		Проводка.Сумма = Проводка.Сумма + РазницаОкругления;
	КонецЕсли;
		
КонецПроцедуры

Функция ДобавитьПроводку(СтрокаЧтоРаспределять, СтрокаНаЧтоРаспределять, СуммаВПроводку, СтатьяТД)
	
	//Сделано в виде функции, т.к. наверху нужна будет последняя проводка
	
	// Дт41.1 - Кт41.1 (41.2)
	Проводка = Движения.Финансовый.Добавить();
	Проводка.Период 							= Дата;
	//Проводка.Организация 						= Организация;
	Проводка.Сумма 								= СуммаВПроводку;
	
	//Дт
	Проводка.СчетДт 							= ПланыСчетов.Финансовый.НайтиПоКоду("41.1");
	Проводка.СубконтоДт.МестаХранения 			= СтрокаНаЧтоРаспределять.СтруктурнаяЕдиница;
	Проводка.СубконтоДт.Товары 					= СтрокаНаЧтоРаспределять.Номенклатура;
	Проводка.СубконтоДт.СтатьиТовародвижения 	= СтатьяТД;
	
	//Кт
	ТабСчетаУчета = ОбщегоНазначенияКлиентСервер.ПолучитьТаблицуСчетовУчетаНоменклатур(СтрокаЧтоРаспределять.Номенклатура, Дата);
	Если ТабСчетаУчета.Количество() > 0
		И ЗначениеЗаполнено(ТабСчетаУчета[0].СчетУчета) Тогда
		Проводка.СчетКт 						= ТабСчетаУчета[0].СчетУчета;
		Если Проводка.СчетКт = ПланыСчетов.Финансовый.НайтиПоКоду("41.1") Тогда
			Проводка.СубконтоКт.МестаХранения 		= Склад.Владелец;
			Проводка.СубконтоКт.Товары 				= СтрокаНаЧтоРаспределять.Номенклатура;
		ИначеЕсли Проводка.СчетКт = ПланыСчетов.Финансовый.НайтиПоКоду("41.2") Тогда
			Проводка.СубконтоКт.Материалы			= СтрокаЧтоРаспределять.Номенклатура;
			Проводка.СубконтоКт.Склады 				= Склад;
		Иначе
			Проводка.СубконтоКт.Материалы			= СтрокаЧтоРаспределять.Номенклатура;
		КонецЕсли;	
	Иначе	
		Если СтрокаЧтоРаспределять.Номенклатура.ТипТовара=Перечисления.ТипыТоваров.Упаковка Тогда
			Проводка.СчетКт 						= ПланыСчетов.Финансовый.НайтиПоКоду("41.2");
			Проводка.СубконтоКт.Материалы			= СтрокаЧтоРаспределять.Номенклатура;
			Проводка.СубконтоКт.Склады 				= Склад;
		Иначе
			Проводка.СчетКт							= ПланыСчетов.Финансовый.НайтиПоКоду("41.1");
			Проводка.СубконтоКт.МестаХранения 		= Склад.Владелец;
			Проводка.СубконтоКт.Товары 				= СтрокаНаЧтоРаспределять.Номенклатура;
		КонецЕсли;
	КонецЕсли;	
	Проводка.СубконтоКт.СтатьиТовародвижения 	= СтатьяТД;
		
	Возврат Проводка;
	
КонецФункции
	
Функция ПолучитьРаспределениеСуммы(мСуммаВсего)
	
	Перем Запрос, СуммаВсего;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачала",		НачалоДня(ЭтотОбъект.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания",	КонецДня(ЭтотОбъект.ДатаОкончания));
	Запрос.УстановитьПараметр("Контрагент",		ЭтотОбъект.Контрагент);
	Запрос.УстановитьПараметр("Сумма",			мСуммаВсего);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТЧТовары.Ссылка.Склад										КАК Склад,
	|	ТЧТовары.Ссылка.Склад.Владелец								КАК СтруктурнаяЕдиница,
	|	ТЧТовары.Номенклатура										КАК Номенклатура,
	|	ТЧТовары.Номенклатура.ТипТовара								КАК ТипТовара,
	|	СУММА(ТЧТовары.Количество * ТЧТовары.ЕдиницаИзмерения.Вес) 	КАК Вес
	|ПОМЕСТИТЬ ВТВеса
	|ИЗ
	|	Документ.ПриходныйОрдерСклад.Товары КАК ТЧТовары
	|ГДЕ
	|	ТЧТовары.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПриходСкладскойУчет.ОтПоставщика)
	|	И ТЧТовары.Ссылка.Проведен
	|	И ВЫБОР
	|			КОГДА НЕ ТЧТовары.Ссылка.ДатаДокументаПоставщика = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ТЧТовары.Ссылка.ДатаДокументаПоставщика
	|			ИНАЧЕ ТЧТовары.Ссылка.Дата
	|		КОНЕЦ МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ТЧТовары.Ссылка.Поставщик = &Контрагент
	|
	|СГРУППИРОВАТЬ ПО
	|	ТЧТовары.Ссылка.Склад,
	|	ТЧТовары.Ссылка.Склад.Владелец,
	|	ТЧТовары.Номенклатура,
	|	ТЧТовары.Номенклатура.ТипТовара
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВТВеса.Вес) КАК Вес
	|ПОМЕСТИТЬ ВТОбщийВес
	|ИЗ
	|	ВТВеса КАК ВТВеса
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВеса.Склад,
	|	ВТВеса.СтруктурнаяЕдиница,
	|	ВТВеса.Номенклатура,
	|	ВТВеса.ТипТовара,
	|	&Сумма * ВТВеса.Вес / ВЫБОР
	|		КОГДА ВТОбщийВес.Вес = 0
	|			ТОГДА 1
	|		ИНАЧЕ ЕСТЬNULL(ВТОбщийВес.Вес, 1)
	|	КОНЕЦ КАК Сумма
	|ПОМЕСТИТЬ ВТОсновная
	|ИЗ
	|	ВТВеса КАК ВТВеса
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбщийВес КАК ВТОбщийВес
	|		ПО (ИСТИНА)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТОсновная.СтруктурнаяЕдиница,
	|	ВТОсновная.Номенклатура	КАК Номенклатура,
	|	СУММА(ВТОсновная.Сумма) КАК Сумма
	|ИЗ
	|	ВТОсновная КАК ВТОсновная
	|ГДЕ
	|	ВТОсновная.ТипТовара <> ЗНАЧЕНИЕ(Перечисление.ТипыТоваров.Упаковка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТОсновная.СтруктурнаяЕдиница,
	|	ВТОсновная.Номенклатура

	|;////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТВеса
	|
	|;////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТОбщийВес
	|
	|;////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТОсновная";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//+++shae 2018.08.07 ИП-00019236  
	СкладыСервер.ПроверитьНаСоответствиеОрганизацииЗакупки(ЭтотОбъект.Организация, ЭтотОбъект.Товары.Выгрузить(), Отказ);		
	//---shae 2018.08.07 ИП-00019236  
	
	если ВидСписания = Перечисления.ВидыСписанияТребованиеНакладная.СписаниеМатериалов Тогда
		реквизит = ПроверяемыеРеквизиты.найти("Склад");
		ПроверяемыеРеквизиты.Удалить(реквизит);
		реквизит = ПроверяемыеРеквизиты.найти("Товары.Цена");
		ПроверяемыеРеквизиты.Удалить(реквизит)

	КонецЕсли;	
	
КонецПроцедуры

//+++АК Susk (Суслин К.В.) ИП-00016544 
Процедура ОбработкаПроведения_Нов(Отказ, РежимПроведения)
	
	ОбработкаПроверки(Отказ);
	
	Движения.Финансовый.Очистить();
	Движения.Финансовый.Записать();

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТребованиеНакладнаяТовары.Ссылка.Дата КАК Период,
	               |	ТребованиеНакладнаяТовары.Ссылка.Организация,
	               |	ТребованиеНакладнаяТовары.СчетЗатрат КАК СчетДт,
	               |	ТребованиеНакладнаяТовары.Субконто1 КАК СубконтоДт1,
	               |	ТребованиеНакладнаяТовары.Субконто2 КАК СубконтоДт2,
	               |	ТребованиеНакладнаяТовары.Субконто3 КАК СубконтоДт3,
	               |	ТребованиеНакладнаяТовары.СчетУчета КАК СчетКт,
	               |	ТребованиеНакладнаяТовары.Номенклатура КАК СубконтоКт1,
	               |	СУММА(ВЫБОР
	               |			КОГДА ТребованиеНакладнаяТовары.Документ ССЫЛКА Документ.ПоступлениеДопРасходов
	               |				ТОГДА 0
	               |			КОГДА ТребованиеНакладнаяТовары.Документ ССЫЛКА Документ.КорректировкаПоступления
	               |					И НЕ ТребованиеНакладнаяТовары.УчитыватьКоличество
	               |				ТОГДА 0
	               |			ИНАЧЕ ТребованиеНакладнаяТовары.Количество
	               |		КОНЕЦ) КАК КоличествоКт,
	               |	СУММА(ТребованиеНакладнаяТовары.Сумма) КАК Сумма
	               |ИЗ
	               |	Документ.ТребованиеНакладная.Товары КАК ТребованиеНакладнаяТовары
	               |ГДЕ
	               |	ТребованиеНакладнаяТовары.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТребованиеНакладнаяТовары.Ссылка.Организация,
	               |	ТребованиеНакладнаяТовары.СчетЗатрат,
	               |	ТребованиеНакладнаяТовары.Субконто1,
	               |	ТребованиеНакладнаяТовары.Субконто2,
	               |	ТребованиеНакладнаяТовары.Субконто3,
	               |	ТребованиеНакладнаяТовары.СчетУчета,
	               |	ТребованиеНакладнаяТовары.Номенклатура,
	               |	ТребованиеНакладнаяТовары.Ссылка.Дата
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	СубконтоКт1
	               |АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Движения.Финансовый.Записывать = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		НоваяПроводка = ЭтотОбъект.Движения.Финансовый.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяПроводка,Выборка);
		
		БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, 1, Выборка.СубконтоДт1);
		БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, 2, Выборка.СубконтоДт2);
		БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, 3, Выборка.СубконтоДт3);

		БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, 1, Выборка.СубконтоКт1);
		НоваяПроводка.СторонаПроводкиДляПересчетаПоСебестоимости = "Кт";
		
	КонецЦикла;
	
КонецПроцедуры

//+++АК Susk (Суслин К.В.) ИП-00016544 
Процедура ОбработкаПроверки(Отказ)
	
	//резерв на будущее
	
КонецПроцедуры
