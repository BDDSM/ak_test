﻿
&НаКлиенте
Процедура СформироватьТаблицы(Команда)
	
	СформироватьТаблицыСервер();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьТаблицыСервер()
	
	Объект.Выгрузка.Очистить();
	ТаблицаПериоды.Очистить();
	
	НачПериодаВыручки = ВычислитьНачалоПериодаВыручки();
	
	Если НачПериодаВыручки = Неопределено Тогда
		ОбщегоНазначения.СообщитьОбОшибке("НЕ удалось подобрать начальную рабочую дату для анализа. Возможно не заполнен производственный календарь в периоде обработки. Продолжение операции невозможно!");
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ФинансовыйОбороты.Период,
	               |	ФинансовыйОбороты.Счет,
	               |	ФинансовыйОбороты.Субконто1 КАК Организация,
	               |	ФинансовыйОбороты.Субконто2 КАК Магазин,
	               |	ФинансовыйОбороты.Субконто3 КАК Терминал,
	               |	ФинансовыйОбороты.СуммаОборот
	               |ИЗ
	               |	РегистрБухгалтерии.Финансовый.Обороты(
	               |			&НачПериода,
	               |			&КонПериода,
	               |			День,
	               |			Счет = &Счет572,
	               |			,
	               |			Субконто1 = &Организация
	               |				И Субконто2 = &Магазин
	               |				И Субконто3 = &Терминал,
	               |			КорСчет = &Счет904,
	               |			) КАК ФинансовыйОбороты";
				   
	Запрос.УстановитьПараметр("Счет572", ПланыСчетов.Финансовый.ДенежныеСредстваВПутиЭквайринг);
	Запрос.УстановитьПараметр("Счет904", ПланыСчетов.Финансовый.ВыручкаТорговыхТочек);
	//Запрос.УстановитьПараметр("НачПериода", НачПериодаВыручки);
	//Запрос.УстановитьПараметр("КонПериода", КонецДня(Объект.КонецПериода)-86400);
	
	ЗапросЭквайринг = Новый Запрос;
	ЗапросЭквайринг.Текст = "ВЫБРАТЬ
	                        |	ФинансовыйОбороты.Период,
	                        |	ФинансовыйОбороты.КорСубконто3,
	                        |	ФинансовыйОбороты.СуммаОборот,
	                        |	ФинансовыйОбороты.СуммаОборотДт,
	                        |	ФинансовыйОбороты.СуммаОборотКт,
	                        |	ФинансовыйОбороты.КорСубконто1,
	                        |	ФинансовыйОбороты.КорСубконто2
	                        |ПОМЕСТИТЬ Сводная
	                        |ИЗ
	                        |	РегистрБухгалтерии.Финансовый.Обороты(&НачПериода, &КонПериода, День, Счет = &Счет511, , , КорСчет = &Счет572, ) КАК ФинансовыйОбороты
	                        |ГДЕ
	                        |	ФинансовыйОбороты.СуммаОборот <> 0
	                        |
	                        |ОБЪЕДИНИТЬ ВСЕ
	                        |
	                        |ВЫБРАТЬ
	                        |	НАЧАЛОПЕРИОДА(ФинансовыйОбороты.Период, ДЕНЬ),
	                        |	ФинансовыйОбороты.КорСубконто3,
	                        |	ФинансовыйОбороты.СуммаОборот,
	                        |	ФинансовыйОбороты.СуммаОборотДт,
	                        |	ФинансовыйОбороты.СуммаОборотКт,
	                        |	ФинансовыйОбороты.КорСубконто1,
	                        |	ФинансовыйОбороты.КорСубконто2
	                        |ИЗ
	                        |	РегистрБухгалтерии.Финансовый.Обороты(&НачПериода, &КонПериода, Регистратор, Счет = &Счет443, , , КорСчет = &Счет572, ) КАК ФинансовыйОбороты
	                        |ГДЕ
	                        |	ФинансовыйОбороты.СуммаОборот <> 0
	                        |	И НЕ ФинансовыйОбороты.Регистратор ССЫЛКА Документ.Операция
	                        |;
	                        |
	                        |////////////////////////////////////////////////////////////////////////////////
	                        |ВЫБРАТЬ
	                        |	Сводная.Период КАК Период,
	                        |	Сводная.КорСубконто1 КАК Организация,
	                        |	Сводная.КорСубконто2 КАК Магазин,
	                        |	Сводная.КорСубконто3 КАК Терминал,
	                        |	СУММА(Сводная.СуммаОборот) КАК СуммаОборот,
	                        |	СУММА(Сводная.СуммаОборотДт) КАК СуммаОборотДт,
	                        |	СУММА(Сводная.СуммаОборотКт) КАК СуммаОборотКт
	                        |ИЗ
	                        |	Сводная КАК Сводная
	                        |
	                        |СГРУППИРОВАТЬ ПО
	                        |	Сводная.Период,
	                        |	Сводная.КорСубконто3,
	                        |	Сводная.КорСубконто1,
	                        |	Сводная.КорСубконто2
	                        |
	                        |УПОРЯДОЧИТЬ ПО
	                        |	Терминал,
	                        |	Период
	                        |ИТОГИ ПО
	                        |	Терминал
	                        |АВТОУПОРЯДОЧИВАНИЕ";
							
	ЗапросЭквайринг.УстановитьПараметр("НачПериода", Объект.НачалоПериода);
	ЗапросЭквайринг.УстановитьПараметр("КонПериода", КонецДня(Объект.КонецПериода));
	ЗапросЭквайринг.УстановитьПараметр("Счет511", ПланыСчетов.Финансовый.РасчетныйСчет);
	ЗапросЭквайринг.УстановитьПараметр("Счет572", ПланыСчетов.Финансовый.ДенежныеСредстваВПутиЭквайринг);
	ЗапросЭквайринг.УстановитьПараметр("Счет443", ПланыСчетов.Финансовый.ЗатратыТочекДляРаспределения);
	
	ВыборкаЭквайрингТерминалы = ЗапросЭквайринг.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ОбщСумма = 0;
	МассивСтрокДляУд = Новый Массив;
	
	ТзОплаты = Новый ТаблицаЗначений;
	ТзОплаты.Колонки.Добавить("Период");
	ТзОплаты.Колонки.Добавить("СуммаОборот");
	
	ДопустимаяПогрешность = (Объект.НачалоПериода - НачПериодаВыручки) / 86400;
	ПрДатаОплаты = НачПериодаВыручки;
	
	Пока ВыборкаЭквайрингТерминалы.Следующий() Цикл
		
		ВыборкаТерминал = ВыборкаЭквайрингТерминалы.Выбрать();
		
		ПрДатаОплаты = НачПериодаВыручки;
		
		Пока ВыборкаТерминал.Следующий() Цикл
			
			Запрос.УстановитьПараметр("НачПериода", ПрДатаОплаты);
			Запрос.УстановитьПараметр("КонПериода", КонецДня(ВыборкаТерминал.Период - 86400));
			Запрос.УстановитьПараметр("Организация", ВыборкаТерминал.Организация);
			Запрос.УстановитьПараметр("Магазин", ВыборкаТерминал.Магазин);
			Запрос.УстановитьПараметр("Терминал", ВыборкаТерминал.Терминал);
						
			ВыборкаОплаты = Запрос.Выполнить().Выбрать();
			
			Пока ВыборкаОплаты.Следующий() Цикл
				НовСтр = ТзОплаты.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтр, ВыборкаОплаты);				
			КонецЦикла;
			
			Для Каждого СтрОпл Из ТзОплаты Цикл
				
 				Если ВыборкаТерминал.Период = СтрОпл.Период + 86400 Тогда
					
					ОбщСумма = ОбщСумма + СтрОпл.СуммаОборот;
					МассивСтрокДляУд.Добавить(СтрОпл);
					Прервать;
					
				КонецЕсли;
				
				ОбщСумма = ОбщСумма + СтрОпл.СуммаОборот;
				
				МассивСтрокДляУд.Добавить(СтрОпл);
				
			КонецЦикла;
			
			НовСтр = Объект.Выгрузка.Добавить();
			НовСтр.Период = ВыборкаТерминал.Период;
			НовСтр.Организация = ВыборкаТерминал.Организация;
			НовСтр.Магазин = ВыборкаТерминал.Магазин;
			НовСтр.Терминал = ВыборкаТерминал.Терминал;
			НовСтр.СуммаПоЭквайрингу = ВыборкаТерминал.СуммаОборот;
			НовСтр.СуммаПоОплате = ОбщСумма;
			НовСтр.ДопустимаяПогрешность = ДопустимаяПогрешность;
			НовСтр.РазницаДляСписывания = НовСтр.СуммаПоЭквайрингу - НовСтр.СуммаПоОплате;
			
			НовСтр = ТаблицаПериоды.Добавить();
			НовСтр.Период = ВыборкаТерминал.Период;
			
			Для Каждого СтрУд Из МассивСтрокДляУд Цикл
				ТзОплаты.Удалить(СтрУд);
			КонецЦикла;
			
			МассивСтрокДляУд.Очистить();
			ОбщСумма = 0;			
			ПрДатаОплаты = ВыборкаТерминал.Период;
			
		КонецЦИкла;
		
		ТзОплаты.Очистить();		
		
	КонецЦикла;
	
	ТзВрем = ТаблицаПериоды.Выгрузить();
	ТзВрем.Свернуть("Период");
	
	ТаблицаПериоды.Загрузить(ТзВрем);

КонецПроцедуры

&НаСервере
Функция ВычислитьНачалоПериодаВыручки()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря КАК ДатаКалендаря,
	               |	РегламентированныйПроизводственныйКалендарь.Год,
	               |	РегламентированныйПроизводственныйКалендарь.Пятидневка,
	               |	РегламентированныйПроизводственныйКалендарь.Шестидневка,
	               |	РегламентированныйПроизводственныйКалендарь.КалендарныеДни,
	               |	РегламентированныйПроизводственныйКалендарь.ВидДня
	               |ИЗ
	               |	РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	               |ГДЕ
	               |	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &НачПериода И &КонПериода
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДатаКалендаря УБЫВ
	               |АВТОУПОРЯДОЧИВАНИЕ";
				   
	Запрос.УстановитьПараметр("НачПериода", ДобавитьМесяц(Объект.НачалоПериода, -1));
	Запрос.УстановитьПараметр("КонПериода", Объект.НачалоПериода - 86400);
	
	ТзПериоды = Запрос.Выполнить().Выгрузить();
	
	ПРошлаяДата = Дата("00010101");
	
	Для Каждого Стр Из ТзПериоды Цикл
		
		Если Стр.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий Тогда
			
			Если ПрошлаяДата = Дата("00010101") Тогда
				Возврат Стр.ДатаКалендаря;
			Иначе
			     Возврат ПрошлаяДата;
			КонецЕсли;
						
		КонецЕсли;
		
		Если Стр.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий Тогда
			ПрошлаяДата = Стр.ДатаКалендаря;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ТаблицаПериодыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ТаблицаПериоды.ТекущиеДанные <> Неопределено Тогда	
		Элементы.Выгрузка.ОтборСтрок = Новый ФиксированнаяСтруктура("Период", Элементы.ТаблицаПериоды.ТекущиеДанные.Период);	
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОперации(Команда)
	
	СоздатьДокументыСервер();
	
КонецПроцедуры

&НаСервере
Процедура СоздатьДокументыСервер()
	
	СвойствоСозданДок = ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию("Автоматически создан обработкой кор.57 счета");
	
	Если СвойствоСозданДок.Пустая() Тогда
		НовОб = ПланыВидовХарактеристик.СвойстваОбъектов.СоздатьЭлемент();
		НовОб.Наименование = "Автоматически создан обработкой кор.57 счета";
		НовОб.ТипЗначения = Новый ОписаниеТипов("Булево");
		
		Попытка
			НовОБ.Записать();
		Исключение
			ОбщегоНазначения.СообщитьОбОшибке("Не удалось записать свойство: Автоматически создан обработкой корректировки");
			Возврат;
		КонецПопытки;
		
		СвойствоСозданДок = НовОб.Ссылка;
		
	КонецЕсли;
	
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                |	ЗначенияСвойствОбъектов.Объект КАК ДокОперация,
	                |	НАЧАЛОПЕРИОДА(ЗначенияСвойствОбъектов.Объект.Дата, ДЕНЬ) КАК Период
	                |ИЗ
	                |	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	                |ГДЕ
	                |	ЗначенияСвойствОбъектов.Свойство = &Свойство
	                |	И ЗначенияСвойствОбъектов.Значение = ИСТИНА
	                |	И ЗначенияСвойствОбъектов.Объект.Дата МЕЖДУ &НачПериода И &КонПериода";
					
	Запрос.УстановитьПараметр("Свойство", СвойствоСозданДок);
	Запрос.УстановитьПараметр("НачПериода", Объект.НачалоПериода);
	Запрос.УстановитьПараметр("КонПериода", КонецДня(Объект.КонецПериода));
	
	ТзОперации = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрПериод Из ТаблицаПериоды Цикл
		
		НайдСтроки = Объект.Выгрузка.НайтиСтроки(Новый Структура("Период", СтрПериод.Период));
		
		СтрДокОперация = ТзОперации.Найти(СтрПериод.Период, "Период");
		
		Если СтрДокОперация = Неопределено Тогда
			
			СоздаемДок = Ложь;
			
			Для Каждого СтрокаТерминал Из НайдСтроки Цикл
				
				Если СтрокаТерминал.РазницаДляСписывания <> 0 
					И ?(СтрокаТерминал.РазницаДляСписывания < 0, -СтрокаТерминал.РазницаДляСписывания, СтрокаТерминал.РазницаДляСписывания) < СтрокаТерминал.ДопустимаяПогрешность Тогда
					
					СоздаемДок = Истина;
					Прервать;
					
				Иначе
					
					Продолжить;
					
				КонецЕсли;
				
			КонецЦикла;
				
			Если НЕ СоздаемДок Тогда
				Продолжить;
			КонецЕсли;
				
			ДокОперацияОб = Документы.Операция.СоздатьДокумент();
			ДокОперацияОб.Ответственный = ПараметрыСеанса.ТекущийПользователь;
			ДокОперацияОб.Комментарий = "Автоматически создан обработкой корректировки 57 счета";
			ДокОперацияОб.Содержание = "Корректировка оплат эквайринга по терминалам";
			ДокОперацияОб.Дата = КонецДня(СтрПериод.Период );
			ДокОперацияОб.Организация = Справочники.Организации.Избенка;
			
			Попытка
 				ДокОперацияОб.Записать();
			Исключение
				ОбщегоНазначения.СообщитьОбОшибке("Не удалось создать документ ""Операция"" для периода: " + Формат(СтрПериод.Период, "ДФ=dd.MM.yyyy") + ОписаниеОшибки());
				Продолжить;
			КонецПопытки;
			
			ДокОперация = ДокОперацияОб.Ссылка;
						
			НаборРег = РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьНаборЗаписей();
			НаборРег.Отбор.Объект.Установить(ДокОперация);
			НаборРег.Отбор.Свойство.Установить(СвойствоСозданДок);
			
			НаборРег.Прочитать();
			НаборРег.Очистить();
			
			НовЗапись = НаборРег.Добавить();
			НовЗапись.Объект = ДокОперация;
			НовЗапись.Свойство = СвойствоСозданДок;
			НовЗапись.Значение = Истина;
			
			НаборРег.Записать(Истина);		
			
		Иначе
			
			ДокОперация = СтрДокОперация.ДокОперация;
			
		КонецЕсли;			
		
		//ДокОб = Документы.Операция.СоздатьДокумент();
		
		ДокОб = ДокОперация.ПолучитьОбъект();
		ДокОб.Организация = Справочники.Организации.Избенка;
		
		Движения = ДокОБ.Движения.Финансовый;
		
		Движения.Очистить();
		
		СуммОбщ = 0;
		
		Для Каждого СтрокаТерминал Из НайдСтроки Цикл
			
			Если СтрокаТерминал.РазницаДляСписывания <> 0 
				И ?(СтрокаТерминал.РазницаДляСписывания < 0, -СтрокаТерминал.РазницаДляСписывания, СтрокаТерминал.РазницаДляСписывания) < СтрокаТерминал.ДопустимаяПогрешность Тогда
				
				Дт57 = СтрокаТерминал.РазницаДляСписывания > 0;
				
			Иначе
				
				Продолжить;
				
			КонецЕсли;			
			
			Если ОбщиеПроцедуры.ПолучитьЦФОПоСтруктурнойЕдинице(СтрокаТерминал.Магазин, СтрПериод.Период).Пустая() Тогда
				Сообщить("Ожидается пустая проводка по магазину " + Строка(СтрокаТерминал.Магазин) + " из-за отсутствия ЦФО. Данная запись будет пропущена");
				Продолжить;
			КонецЕсли;

			ВыборкаСубконто244 = ПолучитьСубконто244Счета(СтрПериод.Период, СтрокаТерминал.Магазин);
				
			Проводка = Движения.Добавить();
			Проводка.Период = КонецДня(СтрПериод.Период);
			
			Если Дт57 Тогда
				Проводка.СчетДт = ПланыСчетов.Финансовый.ДенежныеСредстваВПутиЭквайринг;
				Проводка.СчетКт = ПланыСчетов.Финансовый.ЗатратыТочекДляРаспределения;
				
				Проводка.СубконтоДт.Организации = СтрокаТерминал.Организация;
				Проводка.СубконтоДт.ИсточникиДенежныхСредств = СтрокаТерминал.Магазин;
				Проводка.СубконтоДт.Терминалы = СтрокаТерминал.Терминал;
				
				Проводка.СубконтоКт.ТорговыеТочки = СтрокаТерминал.Магазин;
				Проводка.СубконтоКт.СтатьиДоходовРасходов = ВыборкаСубконто244;
				Проводка.СубконтоКт.ЦФО = ОбщиеПроцедуры.ПолучитьЦФОПоСтруктурнойЕдинице(СтрокаТерминал.Магазин, СтрПериод.Период);				
				
			Иначе
				Проводка.СчетКт = ПланыСчетов.Финансовый.ДенежныеСредстваВПутиЭквайринг;
				Проводка.СчетДт = ПланыСчетов.Финансовый.ЗатратыТочекДляРаспределения;
				
				Проводка.СубконтоКт.Организации = СтрокаТерминал.Организация;
				Проводка.СубконтоКт.ИсточникиДенежныхСредств = СтрокаТерминал.Магазин;
				Проводка.СубконтоКт.Терминалы = СтрокаТерминал.Терминал;
				
				Проводка.СубконтоДт.ТорговыеТочки = СтрокаТерминал.Магазин;
				Проводка.СубконтоДт.СтатьиДоходовРасходов = ВыборкаСубконто244;
				Проводка.СубконтоДт.ЦФО = ОбщиеПроцедуры.ПолучитьЦФОПоСтруктурнойЕдинице(СтрокаТерминал.Магазин, СтрПериод.Период);				
								
			КонецЕсли;
			
			Проводка.Содержание				= "Корректировка эквайринга по 57 счету";
			//Проводка.Организация 			= СтрокаТерминал.Организация;
			Проводка.Сумма 					= ?(СтрокаТерминал.РазницаДляСписывания < 0, -СтрокаТерминал.РазницаДляСписывания, СтрокаТерминал.РазницаДляСписывания);
			
			СуммОбщ = СуммОбщ + Проводка.Сумма;
			
		КонецЦикла;
		
		ДокОБ.СуммаОперации = СуммОбщ;
		СуммОБщ = 0;
		
		ДокОБ.Записать();
		
		Движения.Записать(Истина);
		
	КонецЦикла;
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСубконто244Счета(Период, ТТ)
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//			   |	НастройкаОтраженияОперацийВУчетеСрезПоследних.Счет,
	//			   |	НастройкаОтраженияОперацийВУчетеСрезПоследних.СтатьяДоходовРасходов КАК Субконто2
	//			   |ИЗ
	//			   |	РегистрСведений.НастройкаОтраженияОперацийВУчете.СрезПоследних(&Период, ВидОперации = &ВидОперации) КАК НастройкаОтраженияОперацийВУчетеСрезПоследних
	//			   |ГДЕ
	//			   |	НастройкаОтраженияОперацийВУчетеСрезПоследних.Счет = &Счет";
	//			   
	//Запрос.УстановитьПараметр("Период", Период);
	//Запрос.УстановитьПараметр("ВидОперации", Перечисления.ВидыОперацийВУчете.КорректировкаСчета57ПоЭквайрингу);
	//Запрос.УстановитьПараметр("Счет", ПланыСчетов.Финансовый.ЗатратыТочекДляРаспределения);
	//Запрос.УстановитьПараметр("СтруктурнаяЕдиница", ТТ);
	//
	//Выборка = Запрос.Выполнить().Выбрать();
	//
	//Если Выборка.Следующий() Тогда
	//	Возврат Выборка.Субконто2;
	//КонецЕсли;
	//
	//Набор = РегистрыСведений.НастройкаОтраженияОперацийВУчете.СоздатьНаборЗаписей();
	//Набор.Отбор.Период.Установить(НачалоГода(Период));
	//Набор.Отбор.ВидОперации.Установить(Перечисления.ВидыОперацийВУчете.КорректировкаСчета57ПоЭквайрингу);
	//
	//Набор.Прочитать();
	//
	//Набор.Очистить();
	//
	//НовЗапись = Набор.Добавить();
	//НовЗапись.Период = НачалоГода(Период); 
	//НовЗапись.ВидОперации = Перечисления.ВидыОперацийВУчете.КорректировкаСчета57ПоЭквайрингу;
	//НовЗапись.СтатьяДоходовРасходов = Справочники.СтатьиДоходовРасходов.НайтиПоКоду("39313");
	//
	//Набор.Записать(Истина);
	
	Возврат Справочники.СтатьиДоходовРасходов.НайтиПоКоду("39313");
	
КонецФункции