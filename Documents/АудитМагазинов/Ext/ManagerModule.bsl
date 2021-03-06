﻿Функция ПечатьОтчетов(МассивСсылок) Экспорт
	ТекущийДокумент = 0;
	ТабличныйДокуемнт = Новый ТабличныйДокумент;
	Макет = Документы.АудитМагазинов.ПолучитьМакет("АудитМагазинов");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрокаТЧ = Макет.ПолучитьОбласть("СтрокаТЧ");
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = "ВЫБРАТЬ
	               |	АудитМагазиновРезультаты.Ссылка КАК ДокументСсылка,
	               |	АудитМагазиновРезультаты.НомерСтроки КАК НомерСтроки,
	               |	АудитМагазиновРезультаты.СтатьяАудита.Наименование КАК СтатьяАудита,
	               |	АудитМагазиновРезультаты.Результат,
	               |	АудитМагазиновРезультаты.Комментарии,
	               |	АудитМагазиновРезультаты.Ссылка.Статус КАК Статус,
	               |	АудитМагазиновРезультаты.Ссылка.Результат КАК ОбщийРезультат,
	               |	АудитМагазиновРезультаты.СтатьяАудита.Родитель КАК Группа,
	               |	АудитМагазиновРезультаты.Ссылка.Магазин.Адрес КАК АдресМагазина,
	               |	АудитМагазиновРезультаты.Ссылка.Проверяющий КАК Проверяющий,
	               |	АудитМагазиновРезультаты.Ссылка.Дата КАК Дата
	               |ИЗ
	               |	Документ.АудитМагазинов.Результаты КАК АудитМагазиновРезультаты
	               |ГДЕ
	               |	АудитМагазиновРезультаты.Ссылка В(&МассивСсылок)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	АудитМагазиновРезультаты.Ссылка.Дата,
	               |	НомерСтроки
	               |ИТОГИ
	               |	МАКСИМУМ(Статус),
	               |	МАКСИМУМ(ОбщийРезультат),
	               |	МАКСИМУМ(АдресМагазина),
	               |	МАКСИМУМ(Проверяющий),
	               |	МАКСИМУМ(Дата)
	               |ПО
	               |	ДокументСсылка";
	ВыборкаДокументов = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДокументов.Следующий() Цикл
		ТекущийДокумент = ТекущийДокумент + 1;
		ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры,ВыборкаДокументов);
		ОбластьШапка.Параметры.Дата = Формат(ВыборкаДокументов.Дата,"ДЛФ=DD");
		ТабличныйДокуемнт.Вывести(ОбластьШапка);
		Выборка = ВыборкаДокументов.Выбрать();
		нс=0;
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(ОбластьСтрокаТЧ.Параметры,Выборка);
			ТабличныйДокуемнт.Вывести(ОбластьСтрокаТЧ);
		КонецЦикла;
		Если ТекущийДокумент < 	МассивСсылок.Количество() Тогда
			ТабличныйДокуемнт.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТабличныйДокуемнт;
КонецФункции


Функция ПечатьТТН(Ссылка, СПодписью = Ложь) Экспорт 
	
	ТабДокумент	= Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПараметрыПечати_АктПеревозчика_ТТН";
	
	ЭтоОтгрузкаВТТ = (Ссылка.ВидОперации = Перечисления.ВидыОперацийАктПеревозчика.ОтгрузкаВТорговуюТочку);
	
	// 
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Если ЭтоОтгрузкаВТТ Тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	РасходныеОрдера.Водитель КАК Водитель,
		|	РасходныйОрдерСкладТовары.Номенклатура.Родитель.Наименование КАК ГруппаТоваров
		|ИЗ
		|	Документ.АктПеревозчика.РасходныеОрдера КАК РасходныеОрдера
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйОрдерСклад.Товары КАК РасходныйОрдерСкладТовары
		|		ПО (РасходныйОрдерСкладТовары.Ссылка = РасходныеОрдера.РасходныйОрдер)
		|ГДЕ
		|	РасходныеОрдера.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	РасходныеОрдера.Водитель,
		|	РасходныйОрдерСкладТовары.Номенклатура.Родитель.Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(РасходныеОрдера.РасходныйОрдер.Дата, ДЕНЬ) КАК Дата,
		|	РасходныеОрдера.НомерТТН КАК НомерТТН,
		|	РасходныеОрдера.Водитель КАК Водитель,
		|	РасходныеОрдера.Автомобиль КАК Автомобиль,
		|	РасходныеОрдера.РасходныйОрдер КАК РасходныйОрдер
		|ИЗ
		|	Документ.АктПеревозчика.РасходныеОрдера КАК РасходныеОрдера
		|ГДЕ
		|	РасходныеОрдера.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	РасходныеОрдера.НомерТТН
		|ИТОГИ ПО
		|	Дата,
		|	НомерТТН,
		|	Водитель";
	Иначе //Если Ссылка.ВидОперации = Перечисления.ВидыОперацийАктПеревозчика.ДоставкаНаСклад Тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПриходныеОрдера.Водитель КАК Водитель,
		|	ПриходныйОрдерСкладТовары.Номенклатура.Родитель.Наименование КАК ГруппаТоваров
		|ИЗ
		|	Документ.АктПеревозчика.ПриходныеОрдера КАК ПриходныеОрдера
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриходныйОрдерСклад.Товары КАК ПриходныйОрдерСкладТовары
		|		ПО (ПриходныйОрдерСкладТовары.Ссылка = ПриходныеОрдера.ПриходныйОрдер)
		|ГДЕ
		|	ПриходныеОрдера.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПриходныеОрдера.Водитель,
		|	ПриходныйОрдерСкладТовары.Номенклатура.Родитель.Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ПриходныеОрдера.ПриходныйОрдер.ДатаВремяЗаездаМашины, ДЕНЬ) КАК Дата,
		|	ПриходныеОрдера.НомерТТН КАК НомерТТН,
		|	ПриходныеОрдера.Водитель КАК Водитель,
		|	ПриходныеОрдера.Автомобиль КАК Автомобиль,
		|	ПриходныеОрдера.ПриходныйОрдер КАК РасходныйОрдер,
		|	ПриходныеОрдера.ПриходныйОрдер.Поставщик КАК Поставщик
		|ИЗ
		|	Документ.АктПеревозчика.ПриходныеОрдера КАК ПриходныеОрдера
		|ГДЕ
		|	ПриходныеОрдера.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПриходныеОрдера.НомерТТН
		|ИТОГИ ПО
		|	Дата,
		|	НомерТТН,
		|	Водитель";
	КонецЕсли;
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	ТаблицаГруппТоваров = РезультатыЗапроса[0].Выгрузить();
	
	//
	Макет = Документы.АктПеревозчика.ПолучитьМакет("ТТН");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	
	СтруктураОтбора = Новый Структура("Водитель");
	
	ЭтоЛугДаПоле 		= Ложь;
	ЭтоВкусВилл 		= Ложь;
	ПодписьДиректора 	= Неопределено;
	Если СПодписью Тогда
		ЭтоЛугДаПоле 	= (Ссылка.Организация = Справочники.Организации.НайтиПоРеквизиту("ИНН", "7726660031"));
		Если ЭтоЛугДаПоле Тогда
			ПодписьДиректора = Справочники.ФизическиеЛица.НайтиПоНаименованию("Кривенко Андрей Александрович").Подпись.Получить();
		КонецЕсли;
		ЭтоВкусВилл 	= (Ссылка.Организация = Справочники.Организации.НайтиПоРеквизиту("ИНН", "7734675810"));
		Если ЭтоВкусВилл Тогда
			ПодписьДиректора = Справочники.ФизическиеЛица.НайтиПоНаименованию("Фарафонов Алексей Владимирович").Подпись.Получить();
		КонецЕсли;
	КонецЕсли;
	
	ВыборкаПоДатам = РезультатыЗапроса[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Дата");
	Пока ВыборкаПоДатам.Следующий() Цикл
		
		мДатаТТН 		= ВыборкаПоДатам.Дата;
		
		Если ЭтоОтгрузкаВТТ Тогда
			СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Ссылка.Организация, мДатаТТН);
			мТекстГрузоотправителя = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(
														СведенияОбОрганизации, "НаименованиеСокращенное,ЮридическийАдрес,Телефоны");
		КонецЕсли;
		СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Ссылка.ОрганизацияПолучатель, мДатаТТН);
		мТекстГрузополучателя = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(
																		СведенияОбОрганизации, "НаименованиеСокращенное,ЮридическийАдрес,Телефоны");
		
		ДатаНаПечать 	= Формат(мДатаТТН, "ДФ=""дд.ММ.гг""");
		ВыборкаПоНомерамТТН = ВыборкаПоДатам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "НомерТТН");
		Пока ВыборкаПоНомерамТТН.Следующий() Цикл
			ТекНомерТТН = ВыборкаПоНомерамТТН.НомерТТН;
			ВыборкаПоВодителям = ВыборкаПоНомерамТТН.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Водитель");
			Пока ВыборкаПоВодителям.Следующий() Цикл
				ТекВодитель = ВыборкаПоВодителям.Водитель;
				
				// Страница 1
				ОбластьМакета.Параметры.ДатаТТН 	= ДатаНаПечать;
				ОбластьМакета.Параметры.НомерТТН 	= Формат(ТекНомерТТН, "ЧГ=");
				
				Если НЕ ЭтоОтгрузкаВТТ Тогда
					СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(ВыборкаПоВодителям.Поставщик, мДатаТТН);
					мТекстГрузоотправителя = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(
																		СведенияОбОрганизации, "НаименованиеСокращенное,ЮридическийАдрес,Телефоны");
				КонецЕсли;
				ОбластьМакета.Параметры.Грузополучатель 	= мТекстГрузополучателя;
				
				СтруктураОтбора.Водитель = ТекВодитель;
				СтрокиТаблицыГрупп = ТаблицаГруппТоваров.НайтиСтроки(СтруктураОтбора);
				СтрокаГрупп = "";
				Для Каждого СтрокаТаблицы Из СтрокиТаблицыГрупп Цикл
					СтрокаГрупп = СтрокаГрупп + "; " + СокрЛП(СтрокаТаблицы.ГруппаТоваров);
				КонецЦикла;
				Если НЕ СтрокаГрупп = "" Тогда
					СтрокаГрупп = Сред(СтрокаГрупп, 3);
				КонецЕсли;
				ОбластьМакета.Параметры.НаименованиеГруза = СтрокаГрупп;
				
				ТекстОрдеров 	= "";
				ТекАвтомобиль 	= "";
				ТекПоставщик 	= "";
				Выборка = ВыборкаПоВодителям.Выбрать();
				Пока Выборка.Следующий() Цикл
					ТекАвтомобиль 	= Выборка.Автомобиль; 	// предположение, что 1 водитель ездит на одной машине в течение дня
					Если НЕ ЭтоОтгрузкаВТТ Тогда
						ТекПоставщик = Выборка.Поставщик; 	// предположение, что 1 водитель ездит на одной машине к одному поставщику
					КонецЕсли;
					ТекстОрдеров = ТекстОрдеров + "; " + ОбщегоНазначения.ПолучитьНомерНаПечать(Выборка.РасходныйОрдер) + " от " + ДатаНаПечать;
				КонецЦикла;
				Если НЕ ТекстОрдеров = "" Тогда
					ТекстОрдеров = Сред(ТекстОрдеров, 3);
				КонецЕсли;
				ОбластьМакета.Параметры.ПереченьДокументов = ?(ЭтоОтгрузкаВТТ, "Расходные ордера: ", "Приходные ордера: ") + ТекстОрдеров + ".";
				
				Если НЕ ТекПоставщик = "" Тогда // доставка на склад: поставщик = Грузоотправитель
					СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(ТекПоставщик, мДатаТТН);
					мТекстГрузоотправителя = ?(ЗначениеЗаполнено(СведенияОбОрганизации.НаименованиеДляПечатныхФорм),
												СведенияОбОрганизации.НаименованиеДляПечатныхФорм + ", ", "") +
											ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОбОрганизации, "ЮридическийАдрес,Телефоны");
					//мТекстГрузоотправителя = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(
					//													СведенияОбОрганизации, "НаименованиеСокращенное,ЮридическийАдрес,Телефоны");
				КонецЕсли;
				ОбластьМакета.Параметры.Грузоотправитель	= мТекстГрузоотправителя;
				
				// Страница 2
				ИмяВодителя = СокрЛП(ТекВодитель.Наименование);
				ОбластьМакета.Параметры.Перевозчик 	= СокрЛП(Ссылка.Перевозчик.Наименование);
				ОбластьМакета.Параметры.Водитель 		= ИмяВодителя;
				ОбластьМакета.Параметры.Автомобиль 		= ТекАвтомобиль;
				ОбластьМакета.Параметры.ГосНомерАвтомобиля = СокрЛП(ТекАвтомобиль.Наименование);
				Если ЭтоОтгрузкаВТТ Тогда
					ОбластьМакета.Параметры.Руководитель = ОбщегоНазначения.ФамилияИнициалыФизЛица(СокрЛП(Ссылка.Организация.ГенеральныйДиректор));
				КонецЕсли;
				ОбластьМакета.Параметры.ФИОВодителя 	= ОбщегоНазначения.ФамилияИнициалыФизЛица(ИмяВодителя);
				ОбластьМакета.Параметры.ДатаТТН 		= ДатаНаПечать;
				
				Если СПодписью
						И (ЭтоЛугДаПоле
							ИЛИ ЭтоВкусВилл)
						И ТипЗнч(ПодписьДиректора) = Тип("Картинка") Тогда
					РисунокПодписи = ОбластьМакета.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
			    	РисунокПодписи.Расположить(ОбластьМакета.Область(105, 11, 107, 12));
					РисунокПодписи.Узор 		= ТипУзораТабличногоДокумента.БезУзора;
			    	РисунокПодписи.ЦветФона 	= Новый Цвет; // автоцвет (прозрачный чтоб полоску подчеркивания видно было)
			    	РисунокПодписи.Линия 		= Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии, 0);
			    	РисунокПодписи.Картинка 	= ПодписьДиректора;
				КонецЕсли;
				
				ТабДокумент.Вывести(ОбластьМакета);
				
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	ТабДокумент.ПолеСнизу 			= 5;
	ТабДокумент.ПолеСверху 			= 5;	
	ТабДокумент.АвтоМасштаб 		= Истина;
	ТабДокумент.ОтображатьСетку 	= Ложь;
	ТабДокумент.Защита 				= Ложь;
	ТабДокумент.ТолькоПросмотр 		= Ложь;
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	
	Возврат ТабДокумент;
	
КонецФункции


