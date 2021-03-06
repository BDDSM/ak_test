﻿//+++АК KOPA 2018.01.09 ИП-00017264

Функция ПолучитьДанныеДляВозвратаПоПриходномуОрдеру(СтруктураПараметры) Экспорт 
	УстановитьПривилегированныйРежим(Истина);
	ШтрихКодДокумента = СтруктураПараметры.ШтрихКод;
	Ссылка = ВнешниеДанные.ПолучитьДокументПоШтрихКоду(ШтрихКодДокумента);

	СтруктураВозврат = Новый Структура("ОписаниеОшибок", "");
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Или НЕ ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПриходныйОрдерСклад") Тогда
		СтруктураВозврат.ОписаниеОшибок = "По штрихкоду не найден приходный ордер";
		
		Возврат Новый ХранилищеЗначения(СтруктураВозврат);
	КонецЕсли;
	
//Остатки товаров
	ТаблицаТовары = Новый ТаблицаЗначений;
	
	ТаблицаТовары.Колонки.Добавить("Характеристика", ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(36));
	ТаблицаТовары.Колонки.Добавить("Номенклатура", ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(36));
	//ТаблицаТовары.Колонки.Добавить("ЕдиницаИзмерения", ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(36));
	ТаблицаТовары.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	ТаблицаТовары.Колонки.Добавить("КоличествоКоробок", Новый ОписаниеТипов("Число"));
	ТаблицаТовары.Колонки.Добавить("ДатаПроизводства", Новый ОписаниеТипов("Дата", , ,Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ПриходныйОрдерСкладТовары.Номенклатура,
	                      |	ПриходныйОрдерСкладТовары.Характеристика,
	                      |	СУММА(ПриходныйОрдерСкладТовары.Количество) КАК Количество,
	                      |	ПриходныйОрдерСкладТовары.ДатаПроизводства,
	                      |	СУММА(ПриходныйОрдерСкладТовары.КоличествоКоробок) КАК КоличествоКоробок,
	                      |	ПриходныйОрдерСкладТовары.ЕдиницаИзмерения
	                      |ИЗ
	                      |	Документ.ПриходныйОрдерСклад.Товары КАК ПриходныйОрдерСкладТовары
	                      |ГДЕ
	                      |	ПриходныйОрдерСкладТовары.Ссылка = &Ссылка
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ПриходныйОрдерСкладТовары.Номенклатура,
	                      |	ПриходныйОрдерСкладТовары.Характеристика,
	                      |	ПриходныйОрдерСкладТовары.ДатаПроизводства,
	                      |	ПриходныйОрдерСкладТовары.ЕдиницаИзмерения
	                      |
	                      |ИМЕЮЩИЕ
	                      |	СУММА(ПриходныйОрдерСкладТовары.Количество) > 0");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);                                                                                 
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТаблицаТовары.Добавить();
		
		НоваяСтрока.Номенклатура  = Строка(Выборка.Номенклатура.УникальныйИдентификатор());
		НоваяСтрока.Характеристика = Строка(Выборка.Характеристика.УникальныйИдентификатор());
		//НоваяСтрока.ЕдиницаИзмерения = Строка(Выборка.ЕдиницаИзмерения.УникальныйИдентификатор());
		НоваяСтрока.Количество = Выборка.Количество;
		НоваяСтрока.КоличествоКоробок = Выборка.КоличествоКоробок;
		НоваяСтрока.ДатаПроизводства = Выборка.ДатаПроизводства;
	КонецЦикла;
//
	СтруктураВозврат.Вставить("ТаблицаТовары", ТаблицаТовары);
	СтруктураВозврат.Вставить("Дата", Ссылка.Дата);
	//СтруктураВозврат.Вставить("ТаблицаЗаблокированные",);
	СтруктураВозврат.Вставить("Сборщик", СтруктураПараметры.Сборщик);
	СтруктураВозврат.Вставить("ГУИД", "" + Ссылка.УникальныйИдентификатор());
	СтруктураВозврат.Вставить("Описание", ПолучитьОписаниеПриходногоОрдера(Ссылка, ШтрихКодДокумента, СтруктураВозврат.ГУИД));
	СтруктураВозврат.Вставить("ОрдерПредставление", "" + Ссылка.Номер + " от " + Ссылка.Дата);
	СтруктураВозврат.Вставить("СкладПредставление", "" + Ссылка.Склад);
	
	Если ЗначениеЗаполнено(Ссылка.Склад) Тогда
		СтруктураВозврат.Вставить("СкладГУИД", "" + Ссылка.Склад.УникальныйИдентификатор());	
	Иначе
		СтруктураВозврат.Вставить("СкладГУИД", "");
	КонецЕсли;
	
	СтруктураВозврат.Вставить("СкладПредставление", "" + Ссылка.Склад);
	
	Возврат Новый ХранилищеЗначения(СтруктураВозврат, Новый СжатиеДанных(9));
КонецФункции

Функция ПолучитьОписаниеПриходногоОрдера(Ссылка, Штрихкод, ГУИД)
	мас = Новый Массив;
	
	мас.Добавить("Штрихкод: " + Штрихкод);
	мас.Добавить("Номер: " + Ссылка.Номер);
	мас.Добавить("Дата: " + Ссылка.Дата);
	мас.Добавить("Поставщик: " + Ссылка.Поставщик);
	мас.Добавить("Кладовщик: " + Ссылка.Автор);
	мас.Добавить("Склад: " + Ссылка.Склад);
	мас.Добавить("ГУИД: " + ГУИД);
	
	Результат = "";
	
	Для каждого элем Из мас Цикл	
		Результат = Результат + ?(ЗначениеЗаполнено(Результат), Символы.ПС, "") + элем;	
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

//
Функция ОбработатьВозвратТоваров_ПеремещениеСклад(СтруктураПараметры) Экспорт 
	НачатьТранзакцию();
	
	СтруктураВозврат = Новый Структура("ОписаниеОшибок", "");
	
	Попытка	
		СделатьВозвратТоваров_ПеремещениеСклад(СтруктураПараметры);
		
		ЗафиксироватьТранзакцию();
	Исключение
	    Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		
		Ошибка = ОписаниеОшибки();
		СтруктураВозврат.ОписаниеОшибок = Ошибка;
	КонецПопытки;
	
	Возврат Новый ХранилищеЗначения(СтруктураВозврат);
КонецФункции

Процедура СделатьВозвратТоваров_ПеремещениеСклад(СтруктураПараметры)
	ВозвратПоОрдеру = СтруктураПараметры.ВозвратПоОрдеру;
	ПричинаВозврата = СтруктураПараметры.ПричинаВозврата;
	
	Если ВозвратПоОрдеру Тогда
		ГУИД = СтруктураПараметры.ГУИД;
		ГУИД = Новый УникальныйИдентификатор(ГУИД);
		ПриходныйОрдер = ПолучитьСсылкуПоГУИД(ГУИД, Документы, "ПриходныйОрдерСклад");
		
		//ПеремещениеСклад = НайтиПеремещениеСклад(ПриходныйОрдер);
		//
		//Если ПеремещениеСклад = Неопределено Тогда
			обк = Документы.ПеремещениеСклад.СоздатьДокумент();
			обк.Основание = ПриходныйОрдер;
			обк.Комментарий = "Создано программно." + ПричинаВозврата;
		//Иначе 	
		//	обк = ПеремещениеСклад.ПолучитьОбъект();			
		//КонецЕсли;
		
		УстановитьАвтораТехнолога(обк, СтруктураПараметры.ГУИДФизЛица);
		
		обк.СкладОтправитель = ПриходныйОрдер.Склад;
		обк.СкладПолучатель = ОпределитьСкладПолучательПоСтруктурнойЕдинице(ПриходныйОрдер.Склад);
		
		обк.ПометкаУдаления = Ложь;
		обк.Дата = ТекущаяДата();
		
		обк.Товары.Очистить();
		ДанныеСопоставления = Новый Структура("Номенклатура,Характеристика", "Номенклатура", "ХарактеристикиНоменклатуры");
		ЗаполнитьТаблицуТовары_ПеремещениеСклад(обк.Товары, СтруктураПараметры.Товары, ДанныеСопоставления);
		
		обк.Записать();
		//обк.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		
		ВыборкаПоставщик = СформироватьВыборкуПоТаблицеТоваров(СтруктураПараметры.Товары);	
		
		ГУИД = Новый УникальныйИдентификатор(СтруктураПараметры.ГУИДСклада);
		Склад = ПолучитьСсылкуПоГУИД(ГУИД, Справочники, "Склады");
			
		Пока ВыборкаПоставщик.Следующий() Цикл
			обк = Документы.ПеремещениеСклад.СоздатьДокумент();
			обк.Дата = ТекущаяДата();
			обк.Комментарий = "Создано программно." + ПричинаВозврата;
			УстановитьАвтораТехнолога(обк, СтруктураПараметры.ГУИДФизЛица);
			
			обк.СкладОтправитель = Склад;
			обк.СкладПолучатель = ОпределитьСкладПолучательПоСтруктурнойЕдинице(обк.СкладОтправитель);
		
			ВыборкаДетальныеЗаписи = ВыборкаПоставщик.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Строка = обк.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(Строка, ВыборкаДетальныеЗаписи);
				
				Строка.КоличествоОтправитель = ВыборкаДетальныеЗаписи.Количество;
				Строка.КоличествоПолучатель = ВыборкаДетальныеЗаписи.Количество;
				Строка.ДатаПроизводства = ВыборкаДетальныеЗаписи.ДатаПроизводства;
			КонецЦикла;
			
			обк.Записать();
			//обк.Записать(РежимЗаписиДокумента.Проведение);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьСсылкуПоГУИД(ГУИД, Менеджер, ИмяОбъекта)
	ГУИД = Новый УникальныйИдентификатор(ГУИД);
	Ссылка = Менеджер[ИмяОбъекта].ПолучитьСсылку(ГУИД);	
		
	Возврат Ссылка;
КонецФункции

Функция ОпределитьСкладПолучательПоСтруктурнойЕдинице(Склад) Экспорт 
	Если Не ЗначениеЗаполнено(Склад) Тогда
		Возврат Неопределено;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Склады.Владелец КАК СтруктурноеПодразделение
		|ПОМЕСТИТЬ тСтруктурноеПодразделение
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	Склады.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Склады.Ссылка КАК СкладВозврата
		|ИЗ
		|	Справочник.Склады КАК Склады
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ тСтруктурноеПодразделение КАК тСтруктурноеПодразделение
		|		ПО (Склады.Владелец = тСтруктурноеПодразделение.СтруктурноеПодразделение
		|				И НЕ Склады.ПометкаУдаления
		|				И Склады.ЭтоВозвратПоставщику)";
	
	Запрос.УстановитьПараметр("Ссылка", Склад);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.СкладВозврата;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

Функция СформироватьВыборкуПоТаблицеТоваров(Товары)

	ТаблицаТовары = Новый ТаблицаЗначений;
	
	ТаблицаТовары.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТовары.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));	
	//ТаблицаТовары.Колонки.Добавить("ЕдиницаИзмерения", Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмерения"));
	ТаблицаТовары.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	ТаблицаТовары.Колонки.Добавить("КоличествоКоробок", Новый ОписаниеТипов("Число"));
	ТаблицаТовары.Колонки.Добавить("ДатаПроизводства", Новый ОписаниеТипов("Дата", , ,Новый КвалификаторыДаты(ЧастиДаты.Дата)));	
	
	ДанныеСопоставления = Новый Структура("Номенклатура,Характеристика", "Номенклатура", "ХарактеристикиНоменклатуры");
	
	ЗаполнитьТаблицуТовары_ПеремещениеСклад(ТаблицаТовары, Товары, ДанныеСопоставления, Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	тз.Номенклатура,
		|	тз.Характеристика,
		|	тз.ДатаПроизводства,
		|	тз.Количество,
		|	тз.КоличествоКоробок
		|ПОМЕСТИТЬ тз
		|ИЗ
		|	&тз КАК тз
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	тз.Номенклатура,
		|	тз.Характеристика,
		|	тз.ДатаПроизводства,
		|	тз.Количество,
		|	тз.КоличествоКоробок,
		|	ЕСТЬNULL(ЗначенияСвойствОбъектов.Значение, ЗНАЧЕНИЕ(справочник.Контрагенты.пустаяссылка)) КАК Поставщик,
		|	ЕСТЬNULL(ЕдиницыИзмерения.Ссылка, ЗНАЧЕНИЕ(справочник.ЕдиницыИзмерения.пустаяссылка)) КАК ЕдиницаИзмерения
		|ИЗ
		|	тз КАК тз
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО тз.Характеристика = ЗначенияСвойствОбъектов.Объект
		|			И (ЗначенияСвойствОбъектов.Свойство = &СвойствоПроизводитель)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
		|		ПО тз.Номенклатура = ЕдиницыИзмерения.Владелец
		|ИТОГИ ПО
		|	Поставщик";
	
	Запрос.УстановитьПараметр("тз", ТаблицаТовары);
	Запрос.УстановитьПараметр("СвойствоПроизводитель", ПланыВидовХарактеристик.СвойстваОбъектов.Производитель);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаПоставщик = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Возврат ВыборкаПоставщик;
КонецФункции

Процедура ЗаполнитьСтрокуТаблицыСсылками(Строка, СтрокаГуид, ДанныеСопоставления)
	Для каждого КлючЗначения Из ДанныеСопоставления Цикл
		Если Не  ЗначениеЗаполнено(СтрокаГуид[КлючЗначения.Ключ]) Тогда
			Продолжить;	
		КонецЕсли;
		
		Идентификатор = Новый УникальныйИдентификатор(СтрокаГуид[КлючЗначения.Ключ]);
		Ссылка  = Справочники[КлючЗначения.Значение].ПолучитьСсылку(Идентификатор);
		
	    Строка[КлючЗначения.Ключ] = Ссылка;
	КонецЦикла;
КонецПроцедуры

Процедура УстановитьАвтораТехнолога(Объект, ГУИДФизЛица)
	Если Не ЗначениеЗаполнено(ГУИДФизЛица) Тогда
		//Объект.Комментарий = "Автор не установлен";
		
		Возврат;
	КонецЕсли;
	
	Попытка	
		Идентификатор = Новый УникальныйИдентификатор(ГУИДФизЛица);
		ФизЛицо  = Справочники.ФизическиеЛица.ПолучитьСсылку(Идентификатор);			
	Исключение
		//Объект.Комментарий = "Автор не установлен";
		
		Возврат;
	КонецПопытки;
	
	Объект.Технолог = ФизЛицо;
	
	Пользователь = ПолучитьПользователяПоФизЛицу(ФизЛицо);
	
	Если Не Пользователь = Неопределено Тогда
		Объект.Автор = Пользователь;
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьПользователяПоФизЛицу(ФизЛицо)	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.Ссылка,
		|	Пользователи.ФизЛицо
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.ФизЛицо = &ФизЛицо";
	
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, Неопределено);
КонецФункции

Функция ПолучитьЕдиницуИзмеренияПоНоменклатуре(Номенклатура)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЕдиницыИзмерения.Ссылка
		|ИЗ
		|	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
		|ГДЕ
		|	ЕдиницыИзмерения.Владелец = &Номенклатура
		|	И НЕ ЕдиницыИзмерения.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, Неопределено);
КонецФункции

Процедура ЗаполнитьТаблицуТовары_ПеремещениеСклад(ТаблицаТоварыПриемник, ТаблицаТовары, ДанныеСопоставления, ВДокумент = Истина)
	Для каждого Строка Из ТаблицаТовары Цикл		
		НоваяСтрока = ТаблицаТоварыПриемник.Добавить();
		
		ЗаполнитьСтрокуТаблицыСсылками(НоваяСтрока, Строка, ДанныеСопоставления);
		НоваяСтрока.ДатаПроизводства = Строка.ДатаПроизводства;
		
		Если ВДокумент Тогда		
			НоваяСтрока.КоличествоОтправитель = Строка.Количество;
			НоваяСтрока.КоличествоПолучатель = Строка.Количество;						
			НоваяСтрока.ЕдиницаИзмерения = ПолучитьЕдиницуИзмеренияПоНоменклатуре(НоваяСтрока.Номенклатура);
		Иначе		
			НоваяСтрока.Количество = Строка.Количество;
			НоваяСтрока.КоличествоКоробок = Строка.КоличествоКоробок;			
		КонецЕсли;				
	КонецЦикла;
КонецПроцедуры

Функция НайтиПеремещениеСклад(ПриходныйОрдер)
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПеремещениеСклад.Ссылка
		|ИЗ
		|	Документ.ПеремещениеСклад КАК ПеремещениеСклад
		|ГДЕ
		|	ПеремещениеСклад.Основание = &Основание";
	
	Запрос.УстановитьПараметр("Основание", ПриходныйОрдер);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Результат = Неопределено;
	
	Пока Выборка.Следующий() Цикл
		Результат = Выборка.Ссылка;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ПолучитьДанныеДляПриходника(ДанныеМобильногоПриложения) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	СтруктураПараметры = ДанныеМобильногоПриложения.Получить();

	Если СтруктураПараметры.Свойство("Возврат") Тогда	
		Если СтруктураПараметры.Свойство("ПолучитьДанные") Тогда		
			Возврат ПолучитьДанныеДляВозвратаПоПриходномуОрдеру(СтруктураПараметры);			
		ИначеЕсли СтруктураПараметры.Свойство("СделатьВозврат") Тогда 
			Возврат ОбработатьВозвратТоваров_ПеремещениеСклад(СтруктураПараметры);	
		КонецЕсли;
		
		СтруктураВозврат = Новый Структура("ОписаниеОшибок", "Невыполнено!");
		
		Возврат Новый ХранилищеЗначения(СтруктураВозврат);
	КонецЕсли;
КонецФункции

Функция ВыполнитьДействие(СтруктураПараметры) Экспорт 
	Если СтруктураПараметры.Свойство("ПолучитьДанные") Тогда		
		Возврат ПолучитьДанныеДляВозвратаПоПриходномуОрдеру(СтруктураПараметры);			
	ИначеЕсли СтруктураПараметры.Свойство("СделатьВозврат") Тогда 
		Возврат ОбработатьВозвратТоваров_ПеремещениеСклад(СтруктураПараметры);
	Иначе 
		ВызватьИсключение "Не установлено действие для выполнения!";
	КонецЕсли;	
КонецФункции
