﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//+++АК sils 08.06.2018 ИП-00018876
	ОперацияАпдекс = APDEX_ОценкаПроизводительностиКлиентСервер.ПолучитьОперацию("Открытие документа Планируемые маршруты перевозчика");
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(ОперацияАпдекс);
	//---АК
	
	Если  Не ЗначениеЗаполнено(Объект.Подрядчик) И  Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Контрагент=ПараметрыСеанса.ТекущийПользователь.ФизЛицо.Контрагент;
		Объект.Подрядчик=Контрагент;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ДатаПланирования=ТекущаяДата()+24*60*60;
	КонецЕсли; 
	
	
	//Если РольДоступна("Перевозчик") Тогда
	//	Элементы.ДатаПланирования.ТолькоПросмотр=Истина;	
	//КонецЕсли; 
	Если ЗначениеЗаполнено(Объект.Ссылка) и РольДоступна("Перевозчик") и ЗначениеЗаполнено(Объект.ДатаПланирования) И Объект.ДатаПланирования<ТекущаяДата() Тогда
		ЭтаФорма.ТолькоПросмотр=Истина;	
	КонецЕсли; 
	Элементы.Подрядчик.ТолькоПросмотр=РольДоступна("Перевозчик");
	Для каждого Стр Из Объект.Маршруты Цикл
		Если Не ЗначениеЗаполнено(Стр.УИН_Строки) Тогда
			Стр.УИН_Строки=Новый УникальныйИдентификатор;
		КонецЕсли;
		МасСтр=Объект.Магазины.НайтиСтроки(Новый Структура("УИН_Строки",Стр.УИН_Строки));
		Для каждого Эл Из МасСтр Цикл
			Если Не ЗначениеЗаполнено(Эл.Маршрут) И ЗначениеЗаполнено(Стр.Маршрут) Тогда
				Эл.Маршрут=Стр.Маршрут;
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла; 
    Кол=Объект.Магазины.Количество();
	Для Сч=0 По Кол-1 Цикл
		МасСтр=Объект.Маршруты.НайтиСтроки(Новый Структура("УИН_Строки",Объект.Магазины[Кол-1-Сч].УИН_Строки)) ;
		Если МасСтр.Количество()=0 Тогда
			Объект.Магазины.Удалить(Кол-1-Сч);
			Продолжить;
		
		КонецЕсли; 
		
		Если Не ЗначениеЗаполнено(МасСтр[0].Маршрут) Тогда
			Объект.Магазины.Удалить(Кол-1-Сч);
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура МаршрутыВремяВыездаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Парам=Новый Структура("Маршрут,ВременнойИнтервал",Элементы.Маршруты.ТекущиеДанные.Маршрут,Элементы.Маршруты.ТекущиеДанные.ВременнойИнтервал);                   
	ОткрытьФорму("Справочник.ВремяВыездаПоМаршруту.ФормаВыбора",Парам,Элемент);
КонецПроцедуры

&НаКлиенте
Процедура МаршрутыМаршрутПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Элементы.Маршруты.ТекущиеДанные.Маршрут) Тогда
		//Мас=Объект.Маршруты.НайтиСтроки(Новый Структура("Маршрут",Элементы.Маршруты.ТекущиеДанные.Маршрут));
		//Если Мас.Количество()>1 Тогда
		//	Элементы.Маршруты.ТекущиеДанные.Маршрут=Неопределено;
		//	Сообщить("Маршрут уже выбран в таблице");                                  
		//КонецЕсли;
		Элементы.Маршруты.ТекущиеДанные.ВремяВыезда=ПолучитьВремяВыезда(Элементы.Маршруты.ТекущиеДанные.Маршрут);
		Кол=Объект.Магазины.Количество()-1;
		Для Сч=0 По Кол Цикл
			Если Объект.Магазины[Кол-Сч].УИН_Строки=Элементы.Маршруты.ТекущиеДанные.УИН_Строки Тогда
				ТекСтрока = Объект.Магазины[Кол-Сч];
				Объект.Магазины.Удалить(Кол-Сч);
			КонецЕсли; 
		КонецЦикла; 
		
		ПолучитьМагазиныМаршрута(Элементы.Маршруты.ТекущиеДанные.Маршрут,Элементы.Маршруты.ТекущиеДанные.УИН_Строки);
	Иначе
		Кол=Объект.Магазины.Количество()-1;
		Для Сч=0 По Кол Цикл
			Если Объект.Магазины[Кол-Сч].УИН_Строки=Элементы.Маршруты.ТекущиеДанные.УИН_Строки Тогда
				ТекСтрока = Объект.Магазины[Кол-Сч];
				Объект.Магазины.Удалить(Кол-Сч);
			КонецЕсли;                                 
		КонецЦикла; 
		Элементы.Маршруты.ТекущиеДанные.ВремяВыезда=Неопределено;
	КонецЕсли; 
КонецПроцедуры                                                                 

&НаСервере
Функция ПолучитьВремяВыезда(Маршрут)
	ВремяВыезда=Маршрут.ПланируемоеВремяВыездаПоМаршруту;
	Если ТипЗнч(ВремяВыезда)=Тип("Дата") Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВремяВыездаПоМаршруту.Ссылка
			|ИЗ
			|	Справочник.ВремяВыездаПоМаршруту КАК ВремяВыездаПоМаршруту
			|ГДЕ
			|	ВремяВыездаПоМаршруту.ВремяВыезда = &ВремяВыезда";

		Запрос.УстановитьПараметр("ВремяВыезда", ВремяВыезда);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();

        Если ВыборкаДетальныеЗаписи.Следующий()  Тогда
			ВремяВыезда=ВыборкаДетальныеЗаписи.Ссылка;
		Иначе	
		    ВремяВыезда=Неопределено;
			Сообщить("Необходимо создать элемент справочника Время выезда с временем выезда этого маршрута");
		КонецЕсли; 
	
	КонецЕсли; 
    Возврат ВремяВыезда;
КонецФункции // ()


&НаКлиенте
Процедура Заполнить(Команда)
	Если Не ЗначениеЗаполнено(Объект.ДатаПланирования) Тогда
		Сообщить("Выберите дату планирования");	
		Возврат;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(Объект.Склад) Тогда
		Сообщить("Выберите склад");	
		Возврат;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		Сообщить("Выберите организацию");	
		Возврат;
	КонецЕсли; 
	Объект.Маршруты.Очистить();
	Объект.Магазины.Очистить();
	ЗаполнитьСервер();
КонецПроцедуры
 
&НаСервере
Процедура ЗаполнитьСервер()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КвотаПеревозчикаСрезПоследних.ВременнойИнтервал,
		|	КвотаПеревозчикаСрезПоследних.КоличествоМаршрутов
		|ПОМЕСТИТЬ втКвота
		|ИЗ
		|	РегистрСведений.КвотаПеревозчика.СрезПоследних(
		|			&ДатаПланирования,
		|			Подрядчик = &Подрядчик
		|				И Склад = &Склад
		|				И Организация
		|				 = &Организация) КАК КвотаПеревозчикаСрезПоследних
		|ГДЕ
		|	КвотаПеревозчикаСрезПоследних.КоличествоМаршрутов > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПланируемыеМаршрутыПеревозчикаСрезПоследних.Подрядчик,
		|	МАКСИМУМ(ПланируемыеМаршрутыПеревозчикаСрезПоследних.ДатаПланирования) КАК ДатаПланирования,
		|	ПланируемыеМаршрутыПеревозчикаСрезПоследних.Маршрут
		|ПОМЕСТИТЬ втМаксДаты
		|ИЗ
		|	РегистрСведений.ПланируемыеМаршрутыПеревозчика.СрезПоследних(
		|			,
		|			ДатаПланирования <= &ДатаПланирования
		|				И Подрядчик = &Подрядчик
		|				И Маршрут.СтруктурноеПодразделение = &Склад
		|				И ВЫБОР
		|					КОГДА Маршрут.Организация = ЗНАЧЕНИЕ(Справочник.организации.ПустаяСсылка)
		|						ТОГДА &Вкусвилл
		|					ИНАЧЕ Маршрут.Организация
		|				КОНЕЦ = &Организация) КАК ПланируемыеМаршрутыПеревозчикаСрезПоследних
		|ГДЕ
		|	ПланируемыеМаршрутыПеревозчикаСрезПоследних.Отменен = ЛОЖЬ
		|
		|СГРУППИРОВАТЬ ПО
		|	ПланируемыеМаршрутыПеревозчикаСрезПоследних.Подрядчик,
		|	ПланируемыеМаршрутыПеревозчикаСрезПоследних.Маршрут
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПланируемыеМаршрутыПеревозчикаСрезПоследних.ДатаПланирования,
		|	ПланируемыеМаршрутыПеревозчикаСрезПоследних.Маршрут,
		|	ПланируемыеМаршрутыПеревозчикаСрезПоследних.ВременнойИнтервал,
		|	ПланируемыеМаршрутыПеревозчикаСрезПоследних.ВремяВыезда
		|ПОМЕСТИТЬ втМаршруты
		|ИЗ
		|	РегистрСведений.ПланируемыеМаршрутыПеревозчика.СрезПоследних(
		|			,
		|			Подрядчик = &Подрядчик
		|				И Маршрут.СтруктурноеПодразделение = &Склад
		|				И ВЫБОР
		|					КОГДА Маршрут.Организация = ЗНАЧЕНИЕ(Справочник.организации.ПустаяСсылка)
		|						ТОГДА &Вкусвилл
		|					ИНАЧЕ Маршрут.Организация
		|				КОНЕЦ = &Организация) КАК ПланируемыеМаршрутыПеревозчикаСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втМаксДаты КАК втМаксДаты
		|		ПО ПланируемыеМаршрутыПеревозчикаСрезПоследних.ДатаПланирования = втМаксДаты.ДатаПланирования
		|			И ПланируемыеМаршрутыПеревозчикаСрезПоследних.Маршрут = втМаксДаты.Маршрут
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втКвота.ВременнойИнтервал КАК ВременнойИнтервал,
		|	втМаршруты.Маршрут,
		|	втКвота.КоличествоМаршрутов,
		|	втКвота.ВременнойИнтервал.ВремяНачала КАК ВременнойИнтервалВремяНачала,
		|	втМаршруты.ВремяВыезда,
		|	втМаршруты.ВремяВыезда.ВремяВыезда КАК ВремяВыездаВремяВыезда
		|ИЗ
		|	втКвота КАК втКвота
		|		ЛЕВОЕ СОЕДИНЕНИЕ втМаршруты КАК втМаршруты
		|		ПО втКвота.ВременнойИнтервал = втМаршруты.ВременнойИнтервал
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВременнойИнтервалВремяНачала,
		|	ВремяВыездаВремяВыезда
		|ИТОГИ ПО
		|	ВременнойИнтервал";

	Запрос.УстановитьПараметр("ДатаПланирования", Объект.ДатаПланирования);
	Запрос.УстановитьПараметр("Подрядчик", Объект.Подрядчик);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Объект.Организация),Объект.Организация,Справочники.Организации.НайтиПоКоду("000000006")));
	Запрос.УстановитьПараметр("Вкусвилл", Справочники.Организации.НайтиПоКоду("000000006"));
	
	
	Результат = Запрос.Выполнить();

	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
    МасМарш=Новый Массив;
	Пока Выборка.Следующий() Цикл
		ВыбДетали=Выборка.Выбрать();
		Пока ВыбДетали.Следующий() Цикл
			МасМарш.Добавить(ВыбДетали.Маршрут);
		КонецЦикла;
	КонецЦикла;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МаршрутыТорговыеТочки.Ссылка,
		|	МаршрутыТорговыеТочки.СтруктурнаяЕдиница,
		|	МаршрутыТорговыеТочки.Стоимость,
		|	МаршрутыТорговыеТочки.ПорядокДоставки,
		|	МаршрутыТорговыеТочки.ПоставкаВСетках
		|ИЗ
		|	Справочник.Маршруты.ТорговыеТочки КАК МаршрутыТорговыеТочки
		|ГДЕ
		|	МаршрутыТорговыеТочки.Ссылка В(&Ссылка)";

	Запрос.УстановитьПараметр("Ссылка", МасМарш);

	Результат = Запрос.Выполнить();

	ТЗМарш = Результат.Выгрузить();



	
	
	
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		ВыбДетали=Выборка.Выбрать();
		Сч=0;
		Пока ВыбДетали.Следующий() Цикл
			Если Сч=0 Тогда
				Кол=ВыбДетали.КоличествоМаршрутов;
			КонецЕсли;
			
			НоваяСтрока = Объект.Маршруты.Добавить();
			НоваяСтрока.ВременнойИнтервал = ВыбДетали.ВременнойИнтервал;
			НоваяСтрока.Маршрут = ВыбДетали.Маршрут;
			НоваяСтрока.ВремяВыезда = ВыбДетали.ВремяВыезда;
			НоваяСтрока.УИН_Строки = Новый УникальныйИдентификатор;
			МасСтр=ТЗМарш.НайтиСтроки(Новый Структура("Ссылка",ВыбДетали.Маршрут));
			Для каждого Эл Из МасСтр Цикл
				НовСтрМаг=Объект.Магазины.Добавить();
				НовСтрМаг.Маршрут=ВыбДетали.Маршрут;
				НовСтрМаг.УИН_Строки=НоваяСтрока.УИН_Строки;
				НовСтрМаг.Магазин=Эл.СтруктурнаяЕдиница;
				НовСтрМаг.Стоимость=Эл.Стоимость;
				НовСтрМаг.ПорядокДоставки=Эл.ПорядокДоставки;
				НовСтрМаг.ПоставкаВСетках=Эл.ПоставкаВСетках;
				
			КонецЦикла; 
			Сч=Сч+1;
			
			Кол=Кол-1;
		КонецЦикла; 
		
		Для Сч=1 По Кол Цикл
			НоваяСтрока = Объект.Маршруты.Добавить();
			НоваяСтрока.ВременнойИнтервал = Выборка.ВременнойИнтервал;
			НоваяСтрока.УИН_Строки = Новый УникальныйИдентификатор;
		КонецЦикла; 
		
	КонецЦикла;

	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если ЗначениеЗаполнено(Элементы.Маршруты.ТекущиеДанные.Маршрут) Тогда
		
		Мас=Объект.Маршруты.НайтиСтроки(Новый Структура("Маршрут",Элементы.Маршруты.ТекущиеДанные.Маршрут));
		Если Мас.Количество()>1 Тогда
			Элементы.Маршруты.ТекущиеДанные.Маршрут=Неопределено;
		    Сообщить("Маршрут уже выбран в таблице");
			Кол=Объект.Магазины.Количество()-1;
			Для Сч=0 По Кол Цикл
				Если Объект.Магазины[Кол-Сч].УИН_Строки=Элементы.Маршруты.ТекущиеДанные.УИН_Строки Тогда
					ТекСтрока = Объект.Магазины[Кол-Сч];
					Если Не Отказ Тогда
						Объект.Магазины.Удалить(Кол-Сч);
					КонецЕсли; 
				КонецЕсли; 
			КонецЦикла; 
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьМагазиныМаршрута(Маршрут,УИН_Строки)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МаршрутыТорговыеТочки.СтруктурнаяЕдиница КАК Магазин,
		|	МаршрутыТорговыеТочки.Стоимость,
		|	МаршрутыТорговыеТочки.ПорядокДоставки,
		|	МаршрутыТорговыеТочки.ПоставкаВСетках,
		|	МаршрутыТорговыеТочки.Ссылка КАК Маршрут
		|ИЗ
		|	Справочник.Маршруты.ТорговыеТочки КАК МаршрутыТорговыеТочки
		|ГДЕ
		|	МаршрутыТорговыеТочки.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Маршрут);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
    Мас=Новый массив;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Стр=Объект.Магазины.Добавить();
		ЗаполнитьЗначенияСвойств(Стр,ВыборкаДетальныеЗаписи);
		Стр.УИН_Строки=УИН_Строки;
	КонецЦикла;
    Возврат Истина;
	

КонецФункции // ()
 

&НаКлиенте
Процедура МаршрутыПриАктивизацииСтроки(Элемент)
	Если НЕ Элемент.ТекущиеДанные = Неопределено И НеАктивизировать=Ложь Тогда
		НеАктивизировать=Истина;
		Если ЗначениеЗаполнено(ТекУИН) И Объект.Маршруты.НайтиСтроки(Новый Структура("УИН_Строки",ТекУИН)).Количество()>0  Тогда
			//Отказ=Ложь;
			//ТекУИН=Элемент.ТекущиеДанные.УИН_Строки;
			//РасчитатьКонфликтыСДругимиМаршрутами();
			РасчитатьКонфликтыСДругимиМаршрутами1(Истина);
			ТекУИН1=ТекУИН;
			//Если ЭтаФорма.ТаблицаКонфликтов.Количество() > 0
			//		Тогда
			//	СтатусОтказа = ОткрытьФормуМодально("Документ.ПланируемыеМаршрутыПеревозчика.Форма.ФормаКонфликтов", Новый Структура("ТаблицаКонфликтов", ЭтаФорма.ТаблицаКонфликтов));
			//	//Если ТипЗнч(СтатусОтказа) <> Тип("Булево")
			//	//		ИЛИ СтатусОтказа = Истина Тогда
			//	//	//Отказ = Истина;
			//	//КонецЕсли;	
			//	//Если НЕ Отказ Тогда
			//	//	РасчитатьКонфликтыСДругимиМаршрутами();
			//	//КонецЕсли;
			//	Сообщить("Обнаружен конфликт с другими маршрутами справочника Маршруты по составу магазинов - для маршрута "+Строка(Объект.Маршруты.НайтиСтроки(Новый Структура("УИН_Строки",ТекУИН1))[0].Маршрут));
			//КонецЕсли;	
			ТекУИН1=ТекУИН;
			Если ЭтаФорма.ТаблицаКонфликтов1.Количество() > 0
					Тогда
				СтатусОтказа = ОткрытьФормуМодально("Документ.ПланируемыеМаршрутыПеревозчика.Форма.ФормаКонфликтов", Новый Структура("ТаблицаКонфликтов", ЭтаФорма.ТаблицаКонфликтов1));
				//Если ТипЗнч(СтатусОтказа) <> Тип("Булево")
				//		ИЛИ СтатусОтказа = Истина Тогда
				//	//Отказ = Истина;
				//КонецЕсли;	
				//Если НЕ Отказ Тогда
				//	РасчитатьКонфликтыСДругимиМаршрутами();
				//КонецЕсли;
				Сообщить("Обнаружен конфликт с другими маршрутами в этом документе или других документах с этой датой планирования по составу магазинов - для маршрута "+Строка(Объект.Маршруты.НайтиСтроки(Новый Структура("УИН_Строки",ТекУИН1))[0].Маршрут));
			КонецЕсли;	
			
		КонецЕсли; 
		ТекУИН=Элемент.ТекущиеДанные.УИН_Строки;
		ОтборСтрок = Новый Структура;
		ОтборСтрок.Вставить("УИН_Строки", Элемент.ТекущиеДанные.УИН_Строки);
		Элементы.Магазины.ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтрок);
	КонецЕсли;
	НеАктивизировать=Ложь;
КонецПроцедуры


&НаСервере
Процедура РасчитатьКонфликтыСДругимиМаршрутами1(ВЭтомДокументе=Ложь)
	
	
	Перем Запрос;
	
	Если ЭтаФорма.ТаблицаКонфликтов1.Количество() > 0 Тогда
		ЭтаФорма.ТаблицаКонфликтов1.Очистить();
	КонецЕсли;
	ПослСтрока=Объект.Маршруты.НайтиСтроки(Новый Структура("УИН_Строки",ТекУИН))[0];
	
	
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка"				, ПослСтрока.Маршрут);
	Запрос.УстановитьПараметр("Подразделение"		, ПослСтрока.Маршрут.СтруктурноеПодразделение);
	
	МасМаг=Объект.Магазины.НайтиСтроки(Новый Структура("УИН_Строки",ТекУИН));
	Мас=Новый Массив;
	Для каждого Эл Из МасМаг Цикл
		Мас.Добавить(Эл.Магазин);
	КонецЦикла; 
	
	Запрос.УстановитьПараметр("СтруктурныеЕдиницы"	, Мас);
	Запрос.УстановитьПараметр("Склады"	,
		?(ПослСтрока.Маршрут.Склады.Количество() = 0, Справочники.Склады.ПустаяСсылка(), ПослСтрока.Маршрут.Склады.Выгрузить().ВыгрузитьКолонку("Склад")));
	Запрос.УстановитьПараметр("ТЗ"	,  Объект.Магазины.Выгрузить());
	Запрос.УстановитьПараметр("Док"	, Объект.Ссылка);
	Запрос.УстановитьПараметр("ДатаПланирования"	, Объект.ДатаПланирования);
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Объект.Организация),Объект.Организация,Справочники.Организации.НайтиПоКоду("000000006")));
	Запрос.УстановитьПараметр("Вкусвилл", Справочники.Организации.НайтиПоКоду("000000006"));
	
	Запрос.Текст =
	//?(Не ВЭтомДокументе,
	//"ВЫБРАТЬ
	//|	МаршрутыТорговыеТочки.Ссылка,
	//|	МаршрутыТорговыеТочки.СтруктурнаяЕдиница
	//|ПОМЕСТИТЬ ВТ_Маршруты
	//|ИЗ
	//|	Справочник.Маршруты.ТорговыеТочки КАК МаршрутыТорговыеТочки
	//|ГДЕ
	//|	МаршрутыТорговыеТочки.Ссылка <> &Ссылка
	//|	И МаршрутыТорговыеТочки.Ссылка.СтруктурноеПодразделение = &Подразделение
	//|	И МаршрутыТорговыеТочки.СтруктурнаяЕдиница В(&СтруктурныеЕдиницы)
	//|;",
	"ВЫБРАТЬ
	|	МаршрутыТорговыеТочки.Маршрут КАК Ссылка,
	|	МаршрутыТорговыеТочки.Магазин КАК СтруктурнаяЕдиница
	|ПОМЕСТИТЬ ВТ_Маршруты1
	|ИЗ
	|	&ТЗ КАК МаршрутыТорговыеТочки
	|ГДЕ
	|	МаршрутыТорговыеТочки.Маршрут <> &Ссылка
	|	И МаршрутыТорговыеТочки.Магазин В(&СтруктурныеЕдиницы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланируемыеМаршрутыПеревозчикаМагазины.Маршрут КАК Ссылка,
	|	ПланируемыеМаршрутыПеревозчикаМагазины.Магазин КАК СтруктурнаяЕдиница
	|ПОМЕСТИТЬ ВТ_Маршруты
	|ИЗ
	|	Документ.ПланируемыеМаршрутыПеревозчика.Магазины КАК ПланируемыеМаршрутыПеревозчикаМагазины
	|ГДЕ
	|	ПланируемыеМаршрутыПеревозчикаМагазины.Ссылка.Проведен
	|	И ПланируемыеМаршрутыПеревозчикаМагазины.Ссылка <> &Док
	|	И ПланируемыеМаршрутыПеревозчикаМагазины.Ссылка.ДатаПланирования = &ДатаПланирования
	|	И ПланируемыеМаршрутыПеревозчикаМагазины.Ссылка.Склад = &Подразделение
	|	И ПланируемыеМаршрутыПеревозчикаМагазины.Магазин В(&СтруктурныеЕдиницы)
	|	И ВЫБОР
	|			КОГДА ПланируемыеМаршрутыПеревозчикаМагазины.Ссылка.Организация = ЗНАЧЕНИЕ(Справочник.организации.ПустаяСсылка)
	|				ТОГДА &Вкусвилл
	|			ИНАЧЕ ПланируемыеМаршрутыПеревозчикаМагазины.Ссылка.Организация
	|		КОНЕЦ = &Организация
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	МаршрутыТорговыеТочки.Ссылка,
	|	МаршрутыТорговыеТочки.СтруктурнаяЕдиница
	|ИЗ
	|	ВТ_Маршруты1 КАК МаршрутыТорговыеТочки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВложенныйЗапрос.Ссылка КАК Маршрут,
	|	ВложенныйЗапрос.СтруктурнаяЕдиница,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.Ссылка) КАК МаршрутПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиницаПредставление
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЗ_Склады.Ссылка КАК Ссылка,
	|		ВЗ_Склады.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		Склады.Ссылка КАК Склад
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ВТ_Маршруты.Ссылка КАК Ссылка,
	|			ВТ_Маршруты.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|			ЕСТЬNULL(ВЗ_Группы.Склад, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)) КАК Склад
	|		ИЗ
	|			ВТ_Маршруты КАК ВТ_Маршруты
	|				ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|					МаршрутыСклады.Ссылка КАК Ссылка,
	|					МаршрутыСклады.Склад КАК Склад
	|				ИЗ
	|					Справочник.Маршруты.Склады КАК МаршрутыСклады
	|				ГДЕ
	|					МаршрутыСклады.Ссылка В
	|							(ВЫБРАТЬ
	|								ВТ_Маршруты.Ссылка
	|							ИЗ
	|								ВТ_Маршруты КАК ВТ_Маршруты)) КАК ВЗ_Группы
	|				ПО ВТ_Маршруты.Ссылка = ВЗ_Группы.Ссылка
	|		ГДЕ
	|			ВТ_Маршруты.Ссылка.СтруктурноеПодразделение = &Подразделение) КАК ВЗ_Склады
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|			ПО (ВЗ_Склады.Склад = Склады.Ссылка
	|					ИЛИ ВЗ_Склады.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))) КАК ВложенныйЗапрос
	|ГДЕ
	|	ВложенныйЗапрос.Склад В ИЕРАРХИИ(&Склады)
	|	И ВложенныйЗапрос.Ссылка.ПометкаУдаления = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Маршрут,
	|	ВложенныйЗапрос.СтруктурнаяЕдиница.Наименование";
	
	
	
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	Запрос.Текст ="Выбрать * из ВТ_Маршруты";
	ТЗ=Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из ТаблицаЗапроса Цикл
		НоваяСтрока = ЭтаФорма.ТаблицаКонфликтов1.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
	КонецЦикла;
	Кол=ТаблицаКонфликтов.Количество();
	Для Сч=0 По Кол-1 Цикл
		Если Объект.Маршруты.НайтиСтроки(Новый Структура("Маршрут",ТаблицаКонфликтов[Кол-1-Сч].Маршрут)).Количество()>0 Тогда
			ТаблицаКонфликтов.Удалить(Кол-1-Сч);
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры



&НаКлиенте
Процедура МаршрутыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Стр = Объект.Маршруты.Добавить();
	Стр.УИН_Строки = Новый УникальныйИдентификатор;
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура МаршрутыПередУдалением(Элемент, Отказ)
	//Режим = РежимДиалогаВопрос.ДаНет;
	//Текст = "ru = ""Удалить строку?""";
	//Ответ = Вопрос(НСтр(Текст), Режим, 0);
	//Если Не Ответ = КодВозвратаДиалога.Да Тогда
	//	Отказ=Истина;	
	//КонецЕсли; 
	
	Если Не Отказ Тогда
		Кол=Объект.Магазины.Количество()-1;
		Для Сч=0 По Кол Цикл
			Если Объект.Магазины[Кол-Сч].УИН_Строки=Элементы.Маршруты.ТекущиеДанные.УИН_Строки Тогда
				ТекСтрока = Объект.Магазины[Кол-Сч];
				Если Не Отказ Тогда
					Объект.Магазины.Удалить(Кол-Сч);
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла; 	
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура МагазиныПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Элементы.Маршруты.ТекущиеДанные<>Неопределено Тогда
		Стр=Объект.Магазины.Добавить();
		Стр.УИН_Строки=Элементы.Маршруты.ТекущиеДанные.УИН_Строки;
		Стр.Маршрут=Элементы.Маршруты.ТекущиеДанные.Маршрут;
		Элементы.Маршруты.ТекущиеДанные.ОчиститьМагазины=Ложь;
	КонецЕсли;                                       
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМагазины(Команда)
	Если ЗначениеЗаполнено(Элементы.Маршруты.ТекущиеДанные.Маршрут) Тогда
		//Мас=Объект.Маршруты.НайтиСтроки(Новый Структура("Маршрут",Элементы.Маршруты.ТекущиеДанные.Маршрут));
		//Если Мас.Количество()>1 Тогда
		//	Элементы.Маршруты.ТекущиеДанные.Маршрут=Неопределено;
		//	Сообщить("Маршрут уже выбран в таблице");                                  
		//КонецЕсли;
		Кол=Объект.Магазины.Количество()-1;
		Для Сч=0 По Кол Цикл
			Если Объект.Магазины[Кол-Сч].УИН_Строки=Элементы.Маршруты.ТекущиеДанные.УИН_Строки Тогда
				ТекСтрока = Объект.Магазины[Кол-Сч];
				Объект.Магазины.Удалить(Кол-Сч);
			КонецЕсли; 
		КонецЦикла; 
		
		ПолучитьМагазиныМаршрута(Элементы.Маршруты.ТекущиеДанные.Маршрут,Элементы.Маршруты.ТекущиеДанные.УИН_Строки);

	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура МагазиныПередУдалением(Элемент, Отказ)
	Если Элементы.Маршруты.ТекущиеДанные<>Неопределено Тогда
		Элементы.Маршруты.ТекущиеДанные.ОчиститьМагазины=Истина;
	КонецЕсли;                                       
КонецПроцедуры

&НаКлиенте
Процедура ДатаПланированияПриИзменении(Элемент)
	ДатаПланированияПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Процедура ДатаПланированияПриИзмененииСервер()
	Если РольДоступна("Перевозчик") И Объект.ДатаПланирования<=ТекущаяДата() Тогда
		Объект.ДатаПланирования=ТекущаяДата()+24*60*60;
		Сообщить("Дата планирования должна быть позже текущей");	
	КонецЕсли; 
КонецПроцедуры


&НаКлиенте
Процедура МагазиныМагазинПриИзменении(Элемент)
	
	Если НЕ Элементы.Маршруты.ТекущиеДанные = Неопределено И НеАктивизировать=Ложь Тогда
		НеАктивизировать=Истина;
		Если ЗначениеЗаполнено(ТекУИН) И Объект.Маршруты.НайтиСтроки(Новый Структура("УИН_Строки",ТекУИН)).Количество()>0  Тогда
			//Отказ=Ложь;
			//ТекУИН=Элемент.ТекущиеДанные.УИН_Строки;
			//РасчитатьКонфликтыСДругимиМаршрутами();
			ТекУИН1=ТекУИН;
			РасчитатьКонфликтыСДругимиМаршрутами1(Истина);
			//ТекУИН1=ТекУИН;
			//Если ЭтаФорма.ТаблицаКонфликтов.Количество() > 0
			//		Тогда
			//	СтатусОтказа = ОткрытьФормуМодально("Документ.ПланируемыеМаршрутыПеревозчика.Форма.ФормаКонфликтов", Новый Структура("ТаблицаКонфликтов", ЭтаФорма.ТаблицаКонфликтов));
			//	//Если ТипЗнч(СтатусОтказа) <> Тип("Булево")
			//	//		ИЛИ СтатусОтказа = Истина Тогда
			//	//	//Отказ = Истина;
			//	//КонецЕсли;	
			//	//Если НЕ Отказ Тогда
			//	//	РасчитатьКонфликтыСДругимиМаршрутами();
			//	//КонецЕсли;
			//	Сообщить("Обнаружен конфликт с другими маршрутами справочника Маршруты по составу магазинов - для маршрута "+Строка(Объект.Маршруты.НайтиСтроки(Новый Структура("УИН_Строки",ТекУИН1))[0].Маршрут));
			//	Элементы.Магазины.ТекущиеДанные.Магазин=Неопределено;
			//КонецЕсли;	
			Если ЭтаФорма.ТаблицаКонфликтов1.Количество() > 0
					Тогда
				СтатусОтказа = ОткрытьФормуМодально("Документ.ПланируемыеМаршрутыПеревозчика.Форма.ФормаКонфликтов", Новый Структура("ТаблицаКонфликтов", ЭтаФорма.ТаблицаКонфликтов1));
				//Если ТипЗнч(СтатусОтказа) <> Тип("Булево")
				//		ИЛИ СтатусОтказа = Истина Тогда
				//	//Отказ = Истина;
				//КонецЕсли;	
				//Если НЕ Отказ Тогда
				//	РасчитатьКонфликтыСДругимиМаршрутами();
				//КонецЕсли;
				Сообщить("Обнаружен конфликт с другими маршрутами в этом документе или других документах с этой датой планирования по составу магазинов - для маршрута "+Строка(Объект.Маршруты.НайтиСтроки(Новый Структура("УИН_Строки",ТекУИН1))[0].Маршрут));
				Элементы.Магазины.ТекущиеДанные.Магазин=Неопределено;
			КонецЕсли;	
			
		КонецЕсли; 
		//ТекУИН=Элементы.Маршруты.ТекущиеДанные.УИН_Строки;
		//ОтборСтрок = Новый Структура;
		//ОтборСтрок.Вставить("УИН_Строки", Элемент.ТекущиеДанные.УИН_Строки);
		//Элементы.Магазины.ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтрок);
	КонецЕсли;
	НеАктивизировать=Ложь;
КонецПроцедуры


&НаКлиенте
Процедура СоздатьМаршрут(Команда)
	ОткрытьФорму("Справочник.Маршруты.Форма.ФормаЭлемента");
КонецПроцедуры

 
 &НаКлиенте 
Процедура СкопироватьМаршрут(Команда) 
	Если Элементы.Маршруты.ТекущиеДанные<>Неопределено И ЗначениеЗаполнено(Элементы.Маршруты.ТекущиеДанные.Маршрут) Тогда
		ОткрытьФорму("Справочник.Маршруты.ФормаОбъекта",Новый Структура("ЗначениеКопирования", Элементы.Маршруты.ТекущиеДанные.Маршрут), ЭтаФорма);
	КонецЕсли; 
КонецПроцедуры 


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		Сообщить(НСтр("ru = 'Выберите организацию'"));
		Отказ=Истина;
	КонецЕсли; 
КонецПроцедуры

//+++АК sils 08.06.2018 ИП-00018876
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(ОперацияАпдекс, ?(Параметры.Ключ.Пустая(), "Новый документ", "" + Объект.Ссылка));
КонецПроцедуры
 
