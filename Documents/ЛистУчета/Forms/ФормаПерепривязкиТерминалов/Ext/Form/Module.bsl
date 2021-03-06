﻿&НаСервере
Процедура ВыполнитьАнализНаСервере()
	
	ТабДанные.Очистить();
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Дата", НачалоДня(ДатаПоступленияВБанк));
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ПериодАнализаЛистовУчета.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ПериодАнализаЛистовУчета.ДатаОкончания));
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПоступлениеВБанкЭквайрингРасшифровка.Терминал,
	               |	СУММА(ПоступлениеВБанкЭквайрингРасшифровка.СуммаДокумента + ПоступлениеВБанкЭквайрингРасшифровка.СуммаКомиссииБанка) КАК Сумма,
	               |	ПоступлениеВБанкЭквайрингРасшифровка.ТорговаяТочка
	               |ПОМЕСТИТЬ ВТ_Поступления
	               |ИЗ
	               |	Документ.ПоступлениеВБанк.ЭквайрингРасшифровка КАК ПоступлениеВБанкЭквайрингРасшифровка
	               |ГДЕ
	               |	НАЧАЛОПЕРИОДА(ПоступлениеВБанкЭквайрингРасшифровка.Ссылка.Дата, ДЕНЬ) = &Дата
	               |	И ПоступлениеВБанкЭквайрингРасшифровка.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ЭквайрингСводно)
	               |	И ПоступлениеВБанкЭквайрингРасшифровка.Ссылка.Проведен = ИСТИНА
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ПоступлениеВБанкЭквайрингРасшифровка.Терминал,
	               |	ПоступлениеВБанкЭквайрингРасшифровка.ТорговаяТочка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЛистУчетаОплатыПоБанковскимКартам.Терминал,
	               |	СУММА(ЛистУчетаОплатыПоБанковскимКартам.Сумма - ЛистУчетаОплатыПоБанковскимКартам.СуммаВозврата) КАК Сумма,
	               |	ЛистУчетаОплатыПоБанковскимКартам.Ссылка.ТорговаяТочка,
	               |	ЛистУчетаОплатыПоБанковскимКартам.РабочееМестоВСкл,
	               |	ВЗ_РабочиеМеста.Ссылка КАК РабочееМесто,
	               |	ЛОЖЬ КАК ЭтоИзбенка
	               |ПОМЕСТИТЬ ВТ_Листы
	               |ИЗ
	               |	Документ.ЛистУчета.ОплатыПоБанковскимКартам КАК ЛистУчетаОплатыПоБанковскимКартам
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			РабочиеМеста.CashName КАК CashName,
	               |			МАКСИМУМ(РабочиеМеста.Ссылка) КАК Ссылка
	               |		ИЗ
	               |			Справочник.РабочиеМеста КАК РабочиеМеста
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			РабочиеМеста.CashName) КАК ВЗ_РабочиеМеста
	               |		ПО ЛистУчетаОплатыПоБанковскимКартам.РабочееМестоВСкл = ВЗ_РабочиеМеста.CashName
	               |ГДЕ
	               |	ЛистУчетаОплатыПоБанковскимКартам.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
	               |	И ЛистУчетаОплатыПоБанковскимКартам.Ссылка.Проведен = ИСТИНА
	               |	И ЛистУчетаОплатыПоБанковскимКартам.Ссылка.ТорговаяТочка.ТипРозничнойТочки = ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.Магазин)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ЛистУчетаОплатыПоБанковскимКартам.Терминал,
	               |	ЛистУчетаОплатыПоБанковскимКартам.Ссылка.ТорговаяТочка,
	               |	ЛистУчетаОплатыПоБанковскимКартам.РабочееМестоВСкл,
	               |	ВЗ_РабочиеМеста.Ссылка
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ЛистУчетаОплатыПоБанковскимКартам.Терминал,
	               |	СУММА(ЛистУчетаОплатыПоБанковскимКартам.СуммаЭквайринг - ЛистУчетаОплатыПоБанковскимКартам.ВозвратПокупателюБезнал),
	               |	ЛистУчетаОплатыПоБанковскимКартам.ТорговаяТочка,
	               |	НЕОПРЕДЕЛЕНО,
	               |	НЕОПРЕДЕЛЕНО,
	               |	ИСТИНА
	               |ИЗ
	               |	Документ.ЛистУчета КАК ЛистУчетаОплатыПоБанковскимКартам
	               |ГДЕ
	               |	ЛистУчетаОплатыПоБанковскимКартам.Дата МЕЖДУ &ДатаНач И &ДатаКон
	               |	И ЛистУчетаОплатыПоБанковскимКартам.Проведен = ИСТИНА
	               |	И ЛистУчетаОплатыПоБанковскимКартам.ТорговаяТочка.ТипРозничнойТочки = ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.Избенка)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ЛистУчетаОплатыПоБанковскимКартам.Терминал,
	               |	ЛистУчетаОплатыПоБанковскимКартам.ТорговаяТочка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_Листы.РабочееМестоВСкл,
	               |	ВТ_Листы.ТорговаяТочка,
	               |	ВТ_Поступления.Терминал,
	               |	ВТ_Листы.РабочееМесто,
	               |	ВТ_Листы.Терминал КАК ТерминалВЛисте,
	               |	ВТ_Листы.ЭтоИзбенка,
	               |	ВТ_Листы.Сумма
	               |ИЗ
	               |	ВТ_Поступления КАК ВТ_Поступления
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Листы КАК ВТ_Листы
	               |		ПО ВТ_Поступления.ТорговаяТочка = ВТ_Листы.ТорговаяТочка
	               |			И ВТ_Поступления.Сумма = ВТ_Листы.Сумма
	               |ГДЕ
	               |	ВТ_Листы.Терминал <> ВТ_Поступления.Терминал";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаДоб = ТабДанные.Добавить();
		СтрокаДоб.Записывать = Истина;
		СтрокаДоб.ТерминалВЛисте = Выборка.ТерминалВЛисте;
		СтрокаДоб.ТерминалУстановить = Выборка.Терминал;
		СтрокаДоб.ТТ = Выборка.ТорговаяТочка;
		СтрокаДоб.РабочееМестоВСкл = Выборка.РабочееМестоВСкл;
		СтрокаДоб.РабочееМесто = Выборка.РабочееМесто;
		СтрокаДоб.ЭтоИзбенка = Выборка.ЭтоИзбенка;
		СтрокаДоб.Сумма = Выборка.Сумма; //+++АК LAGP 2018.03.30 ИП-00018072 Для дополнительного контроля, отображение суммы
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьАнализ(Команда)
	
	Если НЕ ЗначениеЗаполнено(ДатаПоступленияВБанк) Тогда
		Сообщить("Не заполнена дата поступления в банк");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПериодАнализаЛистовУчета.ДатаНачала) Тогда
		Сообщить("Не заполнен период анализа листов учета");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПериодАнализаЛистовУчета.ДатаОкончания) Тогда
		Сообщить("Не заполнен период анализа листов учета");
		Возврат;
	КонецЕсли;
	
	ВыполнитьАнализНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаб Из ТабДанные Цикл
		СтрокаТаб.Записывать = Истина;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого СтрокаТаб Из ТабДанные Цикл
		СтрокаТаб.Записывать = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеВЛистыСервер()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Таб", ТабДанные.Выгрузить());
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ПериодАнализаЛистовУчета.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ПериодАнализаЛистовУчета.ДатаОкончания));
	Запрос.Текст = "ВЫБРАТЬ
	               |	Таб.ТерминалУстановить,
	               |	Таб.ТТ,
	               |	Таб.РабочееМестоВСкл,
	               |	Таб.РабочееМесто
	               |ПОМЕСТИТЬ ВТ_Данные
	               |ИЗ
	               |	&Таб КАК Таб
	               |ГДЕ
	               |	Таб.Записывать = ИСТИНА
	               |	И Таб.ЭтоИзбенка = ЛОЖЬ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЛистУчетаОплатыПоБанковскимКартам.Ссылка КАК Ссылка,
	               |	ЛистУчетаОплатыПоБанковскимКартам.НомерСтроки КАК НомерСтроки,
	               |	ВТ_Данные.ТерминалУстановить
	               |ИЗ
	               |	Документ.ЛистУчета.ОплатыПоБанковскимКартам КАК ЛистУчетаОплатыПоБанковскимКартам
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Данные КАК ВТ_Данные
	               |		ПО ЛистУчетаОплатыПоБанковскимКартам.РабочееМестоВСкл = ВТ_Данные.РабочееМестоВСкл
	               |			И ЛистУчетаОплатыПоБанковскимКартам.Ссылка.ТорговаяТочка = ВТ_Данные.ТТ
	               |ГДЕ
	               |	ЛистУчетаОплатыПоБанковскимКартам.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
	               |	И ЛистУчетаОплатыПоБанковскимКартам.Ссылка.Проведен = ИСТИНА
	               |	И ЛистУчетаОплатыПоБанковскимКартам.Ссылка.ТорговаяТочка.ТипРозничнойТочки = ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.Магазин)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Ссылка,
	               |	НомерСтроки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПривязкиОборудованияКРабочимМестамСрезПоследних.РабочееМесто,
	               |	ПривязкиОборудованияКРабочимМестамСрезПоследних.Терминал,
	               |	ПривязкиОборудованияКРабочимМестамСрезПоследних.Касса,
	               |	ВТ_Данные.ТерминалУстановить
	               |ИЗ
	               |	РегистрСведений.ПривязкиОборудованияКРабочимМестам.СрезПоследних(&ДатаНач, ) КАК ПривязкиОборудованияКРабочимМестамСрезПоследних
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Данные КАК ВТ_Данные
	               |		ПО ПривязкиОборудованияКРабочимМестамСрезПоследних.РабочееМесто = ВТ_Данные.РабочееМесто";
				   
	Результаты = Запрос.ВыполнитьПакет();
	Выборка = Результаты[1].Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Пока Выборка.Следующий() Цикл
			ДокОбъект.ОплатыПоБанковскимКартам[Выборка.НомерСтроки - 1].Терминал = Выборка.ТерминалУстановить;
		КонецЦикла;	
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;
	
	Выборка = Результаты[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		Запись = РегистрыСведений.ПривязкиОборудованияКРабочимМестам.СоздатьМенеджерЗаписи();
		Запись.Период = ПериодАнализаЛистовУчета.ДатаНачала;
		Запись.РабочееМесто = Выборка.РабочееМесто;
		Запись.Терминал = Выборка.ТерминалУстановить;
		Запись.Касса = Выборка.Касса;
		Запись.Записать();
	КонецЦикла;	
	
	
	//теперь запишем данные по ТТ
	ЗапросКеш = Новый Запрос();
	ЗапросКеш.УстановитьПараметр("ДатаНач", НачалоДня(ПериодАнализаЛистовУчета.ДатаНачала));
	ЗапросКеш.УстановитьПараметр("ДатаКон", КонецДня(ПериодАнализаЛистовУчета.ДатаОкончания));
	ЗапросКеш.Текст = "ВЫБРАТЬ
	                  |	ЛистУчета.Ссылка,
	                  |	ЛистУчета.ТорговаяТочка,
	                  |	ЛистУчета.Терминал
	                  |ИЗ
	                  |	Документ.ЛистУчета КАК ЛистУчета
	                  |ГДЕ
	                  |	НАЧАЛОПЕРИОДА(ЛистУчета.Дата, ДЕНЬ) МЕЖДУ &ДатаНач И &ДатаКон";
					  
	ТабКеш = ЗапросКеш.Выполнить().Выгрузить();
					  
	Для Каждого СтрокаТаб Из ТабДанные Цикл
		Если СтрокаТаб.Записывать = Истина
			И СтрокаТаб.ЭтоИзбенка = Истина Тогда
			СтрокиКеш = ТабКеш.НайтиСтроки(Новый Структура("ТорговаяТочка, Терминал", СтрокаТаб.ТТ, СтрокаТаб.ТерминалВЛисте));
			Для Каждого СтрокаКеш Из СтрокиКеш Цикл
				ДокОбъект = СтрокаКеш.Ссылка.ПолучитьОбъект();
				ДокОбъект.Терминал = СтрокаТаб.ТерминалУстановить;
				ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
				СпрОб = ДокОбъект.Терминал.ПолучитьОбъект();
				Если СпрОб.Владелец <> ДокОбъект.ТорговаяТочка Тогда
					СпрОб.Владелец = ДокОбъект.ТорговаяТочка;
					СпрОб.Записать();
				КонецЕсли;	
				СпрОб = ДокОбъект.ТорговаяТочка.ПолучитьОбъект();
				Если СпрОб.Терминал <> ДокОбъект.Терминал Тогда
					СпрОб.Терминал = ДокОбъект.Терминал;
					СпрОб.Записать();
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;	
	КонецЦикла;	
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДанныеВЛисты(Команда)
	
	ЗаписатьДанныеВЛистыСервер();
	ВыполнитьАнализНаСервере();
	
КонецПроцедуры

//&НаКлиенте
//Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
//	
//	ДиалогОткрытия = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
//	ДиалогОткрытия.ПолноеИмяФайла = "";
//	ДиалогОткрытия.Фильтр = "Банковская выписка (*.txt)|*.txt";;
//	ДиалогОткрытия.Заголовок = "Выберите файл банковской выписки";
//	Если ДиалогОткрытия.Выбрать() Тогда
//		ИмяФайла = ДиалогОткрытия.ПолноеИмяФайлаВыбранныеФайлы;
//	КонецЕсли;
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ПрочитатьДанныеФайла(Команда)
//	
//	Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
//		Сообщить("Не указано имя файла для обработки");
//		Возврат;
//	КонецЕсли;
//	
//	ЧтениеТекста = Новый ЧтениеТекста();
//	ЧтениеТекста.Открыть(ИмяФайла);
//	Стр = ЧтениеТекста.ПрочитатьСтроку();
//	Пока Стр <> Неопределено Цикл
//		ТекстСтроки = СтрЗаменить(Стр, Символы.Таб, Символы.ПС);
//		НазваниеРабМеста = ВРег(СокрЛП(СтрПолучитьСтроку(ТекстСтроки, 5)));
//		Терминал = СокрЛП(СтрПолучитьСтроку(ТекстСтроки, 6));
//		ДатаОперации = СокрЛП(СтрПолучитьСтроку(ТекстСтроки, 7));
//		ДатаОперации = СтрЗаменить(ДатаОперации, " ", Символы.ПС);
//		СуммаОперации = СокрЛП(СтрПолучитьСтроку(ТекстСтроки, 9));
//		СуммаОперации = СтрЗаменить(СуммаОперации, ",", ".");
//		Стр = ЧтениеТекста.ПрочитатьСтроку();
//		Если ВРег(НазваниеРабМеста) <> "НАЗВАНИЕ" Тогда
//			НазваниеРабМеста = СтрЗаменить(НазваниеРабМеста, "VKUSVILL ", "");
//			НазваниеРабМеста = СтрЗаменить(НазваниеРабМеста, "LUG DA POLE ", "");
//			НазваниеРабМеста = СтрЗаменить(НазваниеРабМеста, "IZBENKA ", "");
//			НазваниеРабМеста = СтрЗаменить(НазваниеРабМеста, "_", Символы.ПС);
//			НазваниеРабМеста = СтрЗаменить(НазваниеРабМеста, " ", Символы.ПС);
//			НазваниеРабМеста = СтрЗаменить(НазваниеРабМеста, "-", Символы.ПС);
//			НазваниеРабМеста = СтрЗаменить(НазваниеРабМеста, " ", Символы.ПС);
//			
//			СтрокаДоб = ДанныеФайла.Добавить();
//			СтрокаДоб.НомерМагазина = Число(СтрПолучитьСтроку(НазваниеРабМеста, 1));
//			Если СтрЧислоСтрок(НазваниеРабМеста) > 1 Тогда
//				СтрокаДоб.НомерРабочегоМеста = Число(СтрПолучитьСтроку(НазваниеРабМеста, 2));
//			КонецЕсли;
//			СтрокаДоб.Терминал = Терминал;
//			СтрокаДоб.СуммаВФайле = Число(СуммаОперации);
//			
//			ДатаСтрока = СтрПолучитьСтроку(ДатаОперации, 1);
//			ДатаСтрока = СтрЗаменить(ДатаСтрока, ".", Символы.ПС);
//			СтрокаДоб.Дата = Дата(Число(СтрПолучитьСтроку(ДатаСтрока, 3)), Число(СтрПолучитьСтроку(ДатаСтрока, 2)), Число(СтрПолучитьСтроку(ДатаСтрока, 1)));
//		КонецЕсли;	
//	КонецЦикла;
//	ЧтениеТекста.Закрыть();
//	
//КонецПроцедуры
