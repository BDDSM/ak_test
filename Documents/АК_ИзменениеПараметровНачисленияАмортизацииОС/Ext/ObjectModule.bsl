﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента,Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Организация");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - структура, содержащая реквизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиОС(Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ОсновноеСредство");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ОС", СтруктураОбязательныхПолей, Отказ, Заголовок);
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Состояние", СтруктураОбязательныхПолей, Отказ, Заголовок);	

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС, ТаблицаПоСостояниюОС);

	ДатаДок = СтруктураШапкиДокумента.Дата;

	ПараметрыАмортизацииБУ = Движения.ПринятыеКУчетуОС;

	Для Каждого СтрокаТЧ из ТаблицаПоОС Цикл

		СтрокаДвижений = ПараметрыАмортизацииБУ.Добавить();

		СтрокаДвижений.Период           = ?(ЗначениеЗаполнено(СтрокаТЧ.Период), СтрокаТЧ.Период, ДатаДок);
		СтрокаДвижений.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
		СтрокаДвижений.Организация      = СтруктураШапкиДокумента.Организация;

		СтрокаДвижений.ДатаВводаВЭксплуатацию                  = СтрокаТЧ.ДатаВводаВЭксплуатацию;
		
		СтрокаДвижений.НачальнаяСтоимость                  = СтрокаТЧ.НачальнаяСтоимость;
		СтрокаДвижений.НачислятьАмортизацию                  = СтрокаТЧ.НачислятьАмортизацию;
		СтрокаДвижений.СрокАмортизации                  = СтрокаТЧ.СрокАмортизации;
		СтрокаДвижений.СчетУчетаАмортизация                  = СтрокаТЧ.СчетУчетаАмортизация;
		СтрокаДвижений.СчетУчета                  = СтрокаТЧ.СчетУчета;
		СтрокаДвижений.АмортизационнаяГруппа                  = СтрокаТЧ.АмортизационнаяГруппа;
		СтрокаДвижений.ЭтоОприходование                  = СтрокаТЧ.ЭтоОприходование;
		СтрокаДвижений.СтатьяДР                  = СтрокаТЧ.СтатьяДР;		

	КонецЦикла;
	
	// состояние ОС
	ПараметрыАмортизацииБУ = Движения.СостояниеОС;

	Для Каждого СтрокаТЧ из ТаблицаПоСостояниюОС Цикл

		СтрокаДвижений = ПараметрыАмортизацииБУ.Добавить();

		СтрокаДвижений.Период           = ?(ЗначениеЗаполнено(СтрокаТЧ.Период), СтрокаТЧ.Период, ДатаДок);
		СтрокаДвижений.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
		СтрокаДвижений.Организация      = СтруктураШапкиДокумента.Организация;

		СтрокаДвижений.Местоположение                  = СтрокаТЧ.Местоположение;
		
		СтрокаДвижений.Эксплуатируется                  = СтрокаТЧ.Эксплуатируется;
		СтрокаДвижений.Списано                  = СтрокаТЧ.Списано;
		
	КонецЦикла;

КонецПроцедуры // ДвиженияПоРегистрам

Процедура ДополнитьСтруктуруПолейТабличнойЧастиОСРегл(СтруктураШапкиДокумента, СтруктураПолей)

	СтруктураПолей.Вставить("ДатаВводаВЭксплуатацию"                 , "ДатаВводаВЭксплуатацию");
	СтруктураПолей.Вставить("НачальнаяСтоимость"  , "НачальнаяСтоимость");
	СтруктураПолей.Вставить("НачислятьАмортизацию"                        , "НачислятьАмортизацию");
	СтруктураПолей.Вставить("СрокАмортизации", "СрокАмортизации");
	СтруктураПолей.Вставить("СчетУчетаАмортизация"           , "СчетУчетаАмортизация");
	СтруктураПолей.Вставить("СчетУчета"                     , "СчетУчета");
	СтруктураПолей.Вставить("АмортизационнаяГруппа"                       , "АмортизационнаяГруппа");
	СтруктураПолей.Вставить("ЭтоОприходование"                       , "ЭтоОприходование");
	СтруктураПолей.Вставить("СтатьяДР"                       , "СтатьяДР");
	СтруктураПолей.Вставить("Период"                       , "Период");
	
КонецПроцедуры

Процедура ДополнитьСтруктуруПолейТабличнойЧастиСостояниеОСРегл(СтруктураШапкиДокумента, СтруктураПолей)

	СтруктураПолей.Вставить("Местоположение"                 , "Местоположение");
	СтруктураПолей.Вставить("Эксплуатируется"  , "Эксплуатируется");
	СтруктураПолей.Вставить("Списано"                        , "Списано");
	СтруктураПолей.Вставить("Период"                       , "Период");
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ)

	Заголовок = "";

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
		
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	// Сформируем структуру табличной части
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("ОсновноеСредство" , "ОсновноеСредство");
	
	СтруктураПолейСостояние = Новый Структура;
	СтруктураПолейСостояние.Вставить("ОсновноеСредство" , "ОсновноеСредство");

	ДополнитьСтруктуруПолейТабличнойЧастиОСРегл(СтруктураШапкиДокумента,СтруктураПолей);
	ДополнитьСтруктуруПолейТабличнойЧастиСостояниеОСРегл(СтруктураШапкиДокумента,СтруктураПолейСостояние);

	РезультатЗапросаПоОС = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ОС", СтруктураПолей);
	ТаблицаПоОС          = РезультатЗапросаПоОС.Выгрузить();
	
	РезультатЗапросаПоСостояниюОС = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Состояние", СтруктураПолейСостояние);
	ТаблицаПоСостояниюОС          = РезультатЗапросаПоСостояниюОС.Выгрузить();	

	ПроверитьЗаполнениеТабличнойЧастиОС(Отказ, Заголовок);	

	// Проверим, нет ли повторяющихся основных средств в таблице по ОС.
	ПроверитьДублиОС(ТаблицаПоОС, Отказ, Заголовок);
	ПроверитьДублиОС(ТаблицаПоСостояниюОС, Отказ, Заголовок);
	
	Если НЕ Отказ Тогда
		
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС, ТаблицаПоСостояниюОС);
		
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьДублиОС(ТаблицаПоОС, Отказ, Заголовок) Экспорт
	
	ТаблицаДублей = ТаблицаПоОС.Скопировать();
	
	// Подсчитываем количество повторений.
	ТаблицаДублей.Колонки.Добавить("КоличествоПовторений");
	ТаблицаДублей.ЗаполнитьЗначения(1, "КоличествоПовторений");
	ТаблицаДублей.Свернуть("ОсновноеСредство", "КоличествоПовторений");
	
	// Если количество повторений > 1, выдаем сообщение об ошибке.
	Если ?(ТаблицаДублей.Количество() > 0, ТаблицаДублей.Итог("КоличествоПовторений") / ТаблицаДублей.Количество(), 0) > 1 Тогда
		
		ТекстСообщенияОбОшибке = "";
		
		ТаблицаПоОС.Индексы.Добавить("ОсновноеСредство");
		
		// Цикл по каждому найденному повторению.
		Для Каждого СтрокаТаблицыДублей Из ТаблицаДублей Цикл
			
			Если СтрокаТаблицыДублей.КоличествоПовторений = 1 Тогда
				Продолжить; // повторений нет.
			КонецЕсли;
			
			// Добавим перевод строки, если требуется.
			ТекстСообщенияОбОшибке = ТекстСообщенияОбОшибке 
			                       + ?(НЕ ЗначениеЗаполнено(ТекстСообщенияОбОшибке), "", "
			                                                                            |");
			
			ТекстСообщенияОбОшибке = ТекстСообщенияОбОшибке
			                       + "В строках №№ "; 
								   
			// Выводим номера строк.
			СписокНомеровСтрок = "";
			МассивСтрок = ТаблицаПоОС.НайтиСтроки(Новый Структура("ОсновноеСредство", СтрокаТаблицыДублей.ОсновноеСредство));
			
			Для Каждого Строка Из МассивСтрок Цикл
				СписокНомеровСтрок = СписокНомеровСтрок + ?(НЕ ЗначениеЗаполнено(СписокНомеровСтрок), "", ", ") + Строка.НомерСтроки;
			КонецЦикла;
			
			
			ТекстСообщенияОбОшибке = ТекстСообщенияОбОшибке
			                       + СписокНомеровСтрок
			                       + " табличной части ""Основные средства"" указано одно и то же основное средство.";
								   
		КонецЦикла;
														  
		ОбщегоНазначения.ОшибкаПриПроведении(ТекстСообщенияОбОшибке, Отказ, Заголовок);
		
	КонецЕсли;
	
КонецПроцедуры