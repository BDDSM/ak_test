﻿Функция ПостроитьСписокАдресатовНаСервере(ВидРассылки) Экспорт
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиРассылкиРеестраОтправок.ВидРассылки,
	|	НастройкиРассылкиРеестраОтправок.ТорговыеТочки,
	|	НастройкиРассылкиРеестраОтправок.ТерриториальныеУправляющие,
	|	НастройкиРассылкиРеестраОтправок.ПомошникиТерриториальныхУправляющих,
	|	НастройкиРассылкиРеестраОтправок.УЕК,
	|	НастройкиРассылкиРеестраОтправок.Избенка,
	|	НастройкиРассылкиРеестраОтправок.Магазины
	|ИЗ
	|	РегистрСведений.НастройкиРассылкиРеестраОтправок КАК НастройкиРассылкиРеестраОтправок
	|ГДЕ
	|	НастройкиРассылкиРеестраОтправок.ВидРассылки = &ВидРассылки";
	
	Запрос.УстановитьПараметр("ВидРассылки", ВидРассылки);
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда
		Объект=ВыборкаДетальныеЗаписи;
	Иначе
		Возврат Неопределено;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиРассылкиРеестраОтправокЦФО.ВидРассылки,
	|	НастройкиРассылкиРеестраОтправокЦФО.ЦФО
	|ИЗ
	|	РегистрСведений.НастройкиРассылкиРеестраОтправокЦФО КАК НастройкиРассылкиРеестраОтправокЦФО
	|ГДЕ
	|	НастройкиРассылкиРеестраОтправокЦФО.ВидРассылки = &ВидРассылки";
	
	Запрос.УстановитьПараметр("ВидРассылки", ВидРассылки);
	
	Результат = Запрос.Выполнить();
	
	ТЗЦФО = Результат.Выгрузить();
	
	
	
	
	
	
	
	
	СписокАдресатов = Новый ТаблицаЗначений;
	СписокАдресатов.Колонки.Добавить("СтруктурнаяЕдиница");
	СписокАдресатов.Колонки.Добавить("Адрес");
	
	СписокТелефонов = Новый СписокЗначений;
	
	ТЗ_ЦФО = ТЗЦФО;
	массЦФО = ТЗ_ЦФО.ВыгрузитьКолонку("ЦФО");
	СписокЦФО = Новый СписокЗначений; 
	СписокЦФО.ЗагрузитьЗначения(массЦФО);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.АдресЭлектроннойПочты КАК ТекАдрес,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.ТелефонныйНомер1 КАК ТелефонныйНомер1,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.ТипРозничнойТочки КАК ТипРозничнойТочки
	|ИЗ
	|	РегистрСведений.ЦФОСтруктурныхЕдиниц.СрезПоследних(
	|			&текДата,
	|			ЦФО В (&СписокЦФО)
	|				И СтруктурнаяЕдиница.Активное = ИСТИНА) КАК ЦФОСтруктурныхЕдиницСрезПоследних
	|
	|СГРУППИРОВАТЬ ПО
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.АдресЭлектроннойПочты,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.ТелефонныйНомер1,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.ТипРозничнойТочки";
	
	Запрос.УстановитьПараметр("СписокЦФО", СписокЦФО);
	Запрос.УстановитьПараметр("текДата", ТекущаяДата());
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Если Объект.ТорговыеТочки Тогда
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Если ВыборкаДетальныеЗаписи.ТипРозничнойТочки = ПредопределенноеЗначение("Перечисление.ТипыРозничныхТочек.Магазин") Тогда
				
				Если НЕ Объект.Магазины Тогда
					Продолжить;
				КонецЕсли;	
				
			ИначеЕсли ВыборкаДетальныеЗаписи.ТипРозничнойТочки = ПредопределенноеЗначение("Перечисление.ТипыРозничныхТочек.Избенка") Тогда
				
				Если НЕ Объект.Избенка Тогда
					Продолжить;
				КонецЕсли;
				
			Иначе 	
				
				Если Объект.Избенка ИЛИ Объект.Магазины Тогда
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
			
			
			ТекАдрес = ВыборкаДетальныеЗаписи.ТекАдрес; 
			Если СокрЛП(ТекАдрес) <> "" И СписокАдресатов.Найти(ТекАдрес) = Неопределено Тогда
				НовСтр=СписокАдресатов.Добавить();
				НовСтр.СтруктурнаяЕдиница=ВыборкаДетальныеЗаписи.СтруктурнаяЕдиница;
				НовСтр.Адрес=СокрЛП(ТекАдрес);
				//СписокАдресатов.Добавить(СокрЛП(ТекАдрес));					
			КонецЕсли;
			
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Объект.ПомошникиТерриториальныхУправляющих Тогда
		
		ВыборкаДетальныеЗаписи.Сбросить();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Если ВыборкаДетальныеЗаписи.ТипРозничнойТочки = ПредопределенноеЗначение("Перечисление.ТипыРозничныхТочек.Магазин") Тогда
				
				Если НЕ Объект.Магазины Тогда
					Продолжить;
				КонецЕсли;	
				
			ИначеЕсли ВыборкаДетальныеЗаписи.ТипРозничнойТочки = ПредопределенноеЗначение("Перечисление.ТипыРозничныхТочек.Избенка") Тогда
				
				Если НЕ Объект.Избенка Тогда
					Продолжить;
				КонецЕсли;
				
			Иначе 	
				
				Если Объект.Избенка ИЛИ Объект.Магазины Тогда
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
			
			
			ТекТТ = ВыборкаДетальныеЗаписи.СтруктурнаяЕдиница;			
			
			ЗапросПомошники = Новый Запрос;
			ЗапросПомошники.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ЖурналИзмененийПомощниковУправляющих.ФизическоеЛицо,
			|	ЖурналИзмененийПомощниковУправляющих.Дата
			|ПОМЕСТИТЬ ВремТЗ
			|ИЗ
			|	РегистрСведений.ЖурналИзмененийПомощниковУправляющих КАК ЖурналИзмененийПомощниковУправляющих
			|ГДЕ
			|	ЖурналИзмененийПомощниковУправляющих.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
			|
			|СГРУППИРОВАТЬ ПО
			|	ЖурналИзмененийПомощниковУправляющих.ФизическоеЛицо,
			|	ЖурналИзмененийПомощниковУправляющих.Дата
			|
			|УПОРЯДОЧИТЬ ПО
			|	ЖурналИзмененийПомощниковУправляющих.Дата УБЫВ
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	КонтактнаяИнформация.Представление КАК ТекАдрес
			|ИЗ
			|	ВремТЗ КАК ВремТЗ
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
			|		ПО ВремТЗ.ФизическоеЛицо = КонтактнаяИнформация.Объект
			|ГДЕ
			|	КонтактнаяИнформация.Тип = &Тип
			|	И КонтактнаяИнформация.Вид = &Вид";
			
			ЗапросПомошники.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
			ЗапросПомошники.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.EmailФизЛица);
			ЗапросПомошники.УстановитьПараметр("СтруктурнаяЕдиница", ТекТТ);
			
			РезультатПомошники = ЗапросПомошники.Выполнить();
			
			ВыборкаДетальныеЗаписиПомошники = РезультатПомошники.Выбрать();
			
			ТекАдрес = "";
			Пока ВыборкаДетальныеЗаписиПомошники.Следующий() Цикл
				ТекАдрес = СокрЛП(ВыборкаДетальныеЗаписиПомошники.ТекАдрес);
			КонецЦикла; 
			
			Если СокрЛП(ТекАдрес) <> "" И СписокАдресатов.Найти(ТекАдрес) = Неопределено Тогда
				НовСтр=СписокАдресатов.Добавить();
				НовСтр.СтруктурнаяЕдиница=ТекТТ;
				НовСтр.Адрес=СокрЛП(ТекАдрес);
				//СписокАдресатов.Добавить(СокрЛП(ТекАдрес));
				
			КонецЕсли;
			
			ЗапросПомошникиТел = Новый Запрос;
			ЗапросПомошникиТел.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ЖурналИзмененийПомощниковУправляющих.ФизическоеЛицо,
			|	ЖурналИзмененийПомощниковУправляющих.Дата
			|ПОМЕСТИТЬ ВремТЗ
			|ИЗ
			|	РегистрСведений.ЖурналИзмененийПомощниковУправляющих КАК ЖурналИзмененийПомощниковУправляющих
			|ГДЕ
			|	ЖурналИзмененийПомощниковУправляющих.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
			|
			|СГРУППИРОВАТЬ ПО
			|	ЖурналИзмененийПомощниковУправляющих.ФизическоеЛицо,
			|	ЖурналИзмененийПомощниковУправляющих.Дата
			|
			|УПОРЯДОЧИТЬ ПО
			|	ЖурналИзмененийПомощниковУправляющих.Дата УБЫВ
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	КонтактнаяИнформация.Представление КАК ТекТел
			|ИЗ
			|	ВремТЗ КАК ВремТЗ
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
			|		ПО ВремТЗ.ФизическоеЛицо = КонтактнаяИнформация.Объект
			|ГДЕ
			|	КонтактнаяИнформация.Тип = &Тип
			|	И КонтактнаяИнформация.Вид = &Вид";
			
			ЗапросПомошникиТел.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.Телефон);
			ЗапросПомошникиТел.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.ТелефонСлужебный);
			ЗапросПомошникиТел.УстановитьПараметр("СтруктурнаяЕдиница", ТекТТ);
			
			РезультатПомошникиТел = ЗапросПомошникиТел.Выполнить();
			
			ВыборкаДетальныеЗаписиПомошникиТел = РезультатПомошникиТел.Выбрать();
			
			ТекТел = "";
			Пока ВыборкаДетальныеЗаписиПомошникиТел.Следующий() Цикл
				ТекТел = СокрЛП(ВыборкаДетальныеЗаписиПомошникиТел.ТекТел);
			КонецЦикла;
			
			ТекТел = СтрЗаменить(ТекТел, " ", "");
			ТекТел = СтрЗаменить(ТекТел, "-", "");
			ТекТел = СтрЗаменить(ТекТел, "(", "");
			ТекТел = СтрЗаменить(ТекТел, ")", "");
			
			Если СтрДлина(ТекТел) = 11 И СокрЛП(ТекТел) <> "" И СписокТелефонов.НайтиПоЗначению(ТекТел) = Неопределено Тогда
				
				СписокТелефонов.Добавить(Прав(СокрЛП(ТекТел), 10));
				
			КонецЕсли;
			
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Объект.ТерриториальныеУправляющие Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		
	"ВЫБРАТЬ
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.АдресЭлектроннойПочты КАК ТекАдрес,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.ТелефонныйНомер1 КАК ТелефонныйНомер1,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.ТипРозничнойТочки КАК ТипРозничнойТочки,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.ЦФО
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	РегистрСведений.ЦФОСтруктурныхЕдиниц.СрезПоследних(
	|			&текДата,
	|			ЦФО В (&СписокЦФО)
	|				И СтруктурнаяЕдиница.Активное = ИСТИНА) КАК ЦФОСтруктурныхЕдиницСрезПоследних
	|
	|СГРУППИРОВАТЬ ПО
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.АдресЭлектроннойПочты,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.ТелефонныйНомер1,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.ТипРозничнойТочки,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.ЦФО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПользователиПоЦФОСрезПоследних.Сотрудник.ФизЛицо КАК Сотрудник,
	|	ВТ.СтруктурнаяЕдиница
	|ПОМЕСТИТЬ ВремТЗ
	|ИЗ
	|	РегистрСведений.ПользователиПоЦФО.СрезПоследних(
	|			&текДата,
	|			РуководительОтдела = ИСТИНА
	|				И ЦФО В (&СписокЦФО)) КАК ПользователиПоЦФОСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ КАК ВТ
	|		ПО ПользователиПоЦФОСрезПоследних.ЦФО = ВТ.ЦФО
	|
	|СГРУППИРОВАТЬ ПО
	|	ПользователиПоЦФОСрезПоследних.Сотрудник.ФизЛицо,
	|	ВТ.СтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтактнаяИнформация.Представление КАК ТекАдрес,
	|	ВремТЗ.СтруктурнаяЕдиница
	|ИЗ
	|	ВремТЗ КАК ВремТЗ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|		ПО ВремТЗ.Сотрудник = КонтактнаяИнформация.Объект
	|ГДЕ
	|	КонтактнаяИнформация.Тип = &Тип
	|	И КонтактнаяИнформация.Вид = &Вид";
		
		Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.EmailФизЛица);
		Запрос.УстановитьПараметр("СписокЦФО", СписокЦФО);
		Запрос.УстановитьПараметр("текДата", ТекущаяДата());
		Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ТекАдрес = "";
			
			ТекАдрес = СокрЛП(ВыборкаДетальныеЗаписи.ТекАдрес);
			
			Если СокрЛП(ТекАдрес) <> "" И СписокАдресатов.Найти(ТекАдрес) = Неопределено Тогда
				НовСтр=СписокАдресатов.Добавить();
				НовСтр.СтруктурнаяЕдиница=ВыборкаДетальныеЗаписи.СтруктурнаяЕдиница;
				НовСтр.Адрес=СокрЛП(ТекАдрес);
				
				//СписокАдресатов.Добавить(СокрЛП(ТекАдрес));
			КонецЕсли;
			
		КонецЦикла;			
		
	КонецЕсли;		
	
	Если Объект.УЕК Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	АК_ГруппыРассылки.Емейл КАК ТекАдрес
		|ИЗ
		|	РегистрСведений.АК_ГруппыРассылки КАК АК_ГруппыРассылки
		|ГДЕ
		|	АК_ГруппыРассылки.Группа = &Группа
		|	И АК_ГруппыРассылки.Емейл <> """"
		|
		|СГРУППИРОВАТЬ ПО
		|	АК_ГруппыРассылки.Емейл";
		
		Запрос.УстановитьПараметр("Группа", Справочники.АК_ГруппыРассылки.УЕК);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ТекАдрес = "";
			
			ТекАдрес = СокрЛП(ВыборкаДетальныеЗаписи.ТекАдрес);
			
			Если СокрЛП(ТекАдрес) <> "" И СписокАдресатов.Найти(ТекАдрес) = Неопределено Тогда
				НовСтр=СписокАдресатов.Добавить();
				//НовСтр.СтруктурнаяЕдиница=ВыборкаДетальныеЗаписи.СтруктурнаяЕдиница;
				НовСтр.Адрес=СокрЛП(ТекАдрес);
				//СписокАдресатов.Добавить(СокрЛП(ТекАдрес));
			КонецЕсли;
			
		КонецЦикла;			
		
		
	КонецЕсли;		
	
	//Для каждого ТекСтр Из Объект.ДопАдресаты Цикл
	//	
	//	СписокАдресатов.Добавить(СокрЛП(ТекСтр.Адрес));
	//				
	//КонецЦикла;
	
	//  	Для каждого ТекСтрСп Из СписокАдресатов Цикл
	//		  
	//			новСтр = Объект.СписокПолучателей.Добавить();
	//  		новСтр.АдресТелефон = ТекСтрСп.Значение;
	//
	//  	КонецЦикла;
	//  	
	
	//КонецЕсли;
	Возврат СписокАдресатов;
КонецФункции

Функция ПостроитьСписокАдресатовНаСервере_1С(ВидРассылки) Экспорт
	ТекДата=ТекущаяДата();	
	
	// Формируем список ТТ для отбора
	СписоТТДляОтбора = Новый СписокЗначений;
	
	
	лкСписокПроизв = Новый СписокЗначений;
	
	//
	СписокТТ = Новый СписокЗначений;
	//СписокРолей = Новый СписокЗначений;
	
	СписокАдресатов = Новый ТаблицаЗначений;
	СписокАдресатов.Колонки.Добавить("СтруктурнаяЕдиница");
	СписокАдресатов.Колонки.Добавить("Роль");
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиРассылкиРеестраОтправок.ВидРассылки,
	|	НастройкиРассылкиРеестраОтправок.ТорговыеТочки,
	|	НастройкиРассылкиРеестраОтправок.ТерриториальныеУправляющие,
	|	НастройкиРассылкиРеестраОтправок.ПомошникиТерриториальныхУправляющих,
	|	НастройкиРассылкиРеестраОтправок.УЕК,
	|	НастройкиРассылкиРеестраОтправок.Избенка,
	|	НастройкиРассылкиРеестраОтправок.Магазины
	|ИЗ
	|	РегистрСведений.НастройкиРассылкиРеестраОтправок КАК НастройкиРассылкиРеестраОтправок
	|ГДЕ
	|	НастройкиРассылкиРеестраОтправок.ВидРассылки = &ВидРассылки";
	
	Запрос.УстановитьПараметр("ВидРассылки", ВидРассылки);
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда
		Объект=ВыборкаДетальныеЗаписи;
	Иначе
		Возврат Неопределено;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиРассылкиРеестраОтправокЦФО.ВидРассылки,
	|	НастройкиРассылкиРеестраОтправокЦФО.ЦФО
	|ИЗ
	|	РегистрСведений.НастройкиРассылкиРеестраОтправокЦФО КАК НастройкиРассылкиРеестраОтправокЦФО
	|ГДЕ
	|	НастройкиРассылкиРеестраОтправокЦФО.ВидРассылки = &ВидРассылки";
	
	Запрос.УстановитьПараметр("ВидРассылки", ВидРассылки);
	
	Результат = Запрос.Выполнить();
	
	ТЗЦФО = Результат.Выгрузить();
	
	
	
	
	ТЗ_ЦФО = ТЗЦФО;
	массЦФО = ТЗ_ЦФО.ВыгрузитьКолонку("ЦФО");
	СписокЦФО = Новый СписокЗначений; 
	СписокЦФО.ЗагрузитьЗначения(массЦФО);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.ТипРозничнойТочки КАК ТипРозничнойТочки
	|ИЗ
	|	РегистрСведений.ЦФОСтруктурныхЕдиниц.СрезПоследних(
	|			&текДата,
	|			ЦФО В (&СписокЦФО)
	|				И СтруктурнаяЕдиница.Активное = ИСТИНА) КАК ЦФОСтруктурныхЕдиницСрезПоследних
	|
	|СГРУППИРОВАТЬ ПО
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница,
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница.ТипРозничнойТочки";
	
	Запрос.УстановитьПараметр("СписокЦФО", СписокЦФО);
	Запрос.УстановитьПараметр("текДата", ТекДата);
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если НЕ ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ТипРозничнойТочки) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВыборкаДетальныеЗаписи.ТипРозничнойТочки = ПредопределенноеЗначение("Перечисление.ТипыРозничныхТочек.Магазин") Тогда
			
			Если НЕ Объект.Магазины Тогда
				Продолжить;
			КонецЕсли;	
			
		ИначеЕсли ВыборкаДетальныеЗаписи.ТипРозничнойТочки = ПредопределенноеЗначение("Перечисление.ТипыРозничныхТочек.Избенка") Тогда
			
			Если НЕ Объект.Избенка Тогда
				Продолжить;
			КонецЕсли;
			
		Иначе 	
			
			Если Объект.Избенка ИЛИ Объект.Магазины Тогда
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		//Если СписоТТДляОтбора.Количество() > 0 И СписоТТДляОтбора.НайтиПоЗначению(ВыборкаДетальныеЗаписи.СтруктурнаяЕдиница) = Неопределено Тогда
		//	Продолжить;
		//КонецЕсли;
		
		ТекТТ = ВыборкаДетальныеЗаписи.СтруктурнаяЕдиница; 
		Если ЗначениеЗаполнено(ТекТТ) и СписокТТ.НайтиПоЗначению(ТекТТ)=Неопределено Тогда
			СписокТТ.Добавить(ТекТТ);					
			//НоваяСтр.ТорговаяТочка = ТекТТ
		КонецЕсли;
		
	КонецЦикла;
	//
	//ВремТЗ = СписокТТ.Выгрузить();
	//ВремТЗ.Свернуть("ТорговаяТочка");
	//Объект.СписокТТ.Очистить();
	//Объект.СписокТТ.Загрузить(ВремТЗ);				
	
	Если Объект.ПомошникиТерриториальныхУправляющих ИЛИ Объект.ТерриториальныеУправляющие Тогда
		
		лкСписокТТ = Новый СписокЗначений;
		Для каждого ТекСтрТТ Из СписокТТ Цикл
			
			лкСписокТТ.Добавить(ТекСтрТТ.Значение);
			
		КонецЦикла;			
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоответствиеОбъектРольСрезПоследних.РольПользователя,
		|	СоответствиеОбъектРольСрезПоследних.Объект КАК СтруктурнаяЕдиница
		|ИЗ
		|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|			&ТекДата,
		|			Объект В (&СписокТТ)
		//+++ AK suvv 2018.06.08 ИП-00018376.01
		//|				И ТипРоли = &ТипРоли) КАК СоответствиеОбъектРольСрезПоследних
		|				И (ТипРоли = &ТипРоли ИЛИ ТипРоли = &ТипРолиСторонняяРозница)) КАК СоответствиеОбъектРольСрезПоследних
		//--- AK suvv
		|
		|СГРУППИРОВАТЬ ПО
		|	СоответствиеОбъектРольСрезПоследних.РольПользователя,
		|	СоответствиеОбъектРольСрезПоследних.Объект";
		
		Запрос.УстановитьПараметр("СписокТТ", лкСписокТТ);
		Запрос.УстановитьПараметр("ТекДата", ТекДата);
		Запрос.УстановитьПараметр("ТипРоли", ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего);
		//+++ AK suvv 2018.06.08 ИП-00018376.01
		Запрос.УстановитьПараметр("ТипРолиСторонняяРозница", ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы);
		//--- AK suvv
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			//Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.РольПользователя) и СписокРолей.НайтиПоЗначению(ВыборкаДетальныеЗаписи.РольПользователя)=Неопределено Тогда
			//	СписокРолей.Добавить(ВыборкаДетальныеЗаписи.РольПользователя);
			//КонецЕсли;				
			НовСтр=СписокАдресатов.Добавить();
			НовСтр.СтруктурнаяЕдиница = ВыборкаДетальныеЗаписи.СтруктурнаяЕдиница;
			НовСтр.Роль = ВыборкаДетальныеЗаписи.РольПользователя;
		КонецЦикла;
		
		СписокАдресатов.Свернуть("Роль, СтруктурнаяЕдиница");
		
	КонецЕсли;
	
	Если Объект.ТерриториальныеУправляющие Тогда
		
		лкСписокРолейУправляющих = Новый СписокЗначений;
		лкСписокАдресатов = Новый ТаблицаЗначений;
		лкСписокАдресатов.Колонки.Добавить("СтруктурнаяЕдиница");
		лкСписокАдресатов.Колонки.Добавить("Роль");
		
		//Для каждого ТекСтрРолей Из СписокРолей Цикл
		//	
		//	Если ЗначениеЗаполнено(ТекСтрРолей.Значение.Родитель) Тогда
		//		лкСписокРолейУправляющих.Добавить(ТекСтрРолей.Значение.Родитель);
		//	КонецЕсли;	
		//	
		//КонецЦикла;
		
		Для каждого ТекСтрРолей Из СписокАдресатов Цикл
			
			Если ЗначениеЗаполнено(ТекСтрРолей.Роль.Родитель) Тогда
				НовСтр=лкСписокАдресатов.Добавить();
				НовСтр.СтруктурнаяЕдиница = ТекСтрРолей.СтруктурнаяЕдиница;
				НовСтр.Роль = ТекСтрРолей.Роль.Родитель;
			КонецЕсли;	
			
		КонецЦикла;
		
		Если НЕ Объект.ПомошникиТерриториальныхУправляющих Тогда
			//СписокРолей.Очистить();
			СписокАдресатов.Очистить();
		КонецЕсли;	
		
		//Для каждого ТекРоль Из лкСписокРолейУправляющих Цикл
		//	Если СписокРолей.НайтиПоЗначению(ТекРоль.Значение)=Неопределено Тогда
		//		СписокРолей.Добавить(ТекРоль.Значение);	
		//	КонецЕсли; 
		//	//НовСтр.Роль = ТекРоль.Значение;
		//КонецЦикла;
		
		Для каждого ТекРоль Из лкСписокАдресатов Цикл
			НовСтр=СписокАдресатов.Добавить();
			НовСтр.СтруктурнаяЕдиница = ТекРоль.СтруктурнаяЕдиница;
			НовСтр.Роль = ТекРоль.Роль;

		КонецЦикла;
		
		//ВремТЗ = Объект.СписокРолей.Выгрузить();
		//ВремТЗ.Свернуть("Роль");
		//Объект.СписокРолей.Очистить();
		//Объект.СписокРолей.Загрузить(ВремТЗ);
		СписокАдресатов.Свернуть("Роль, СтруктурнаяЕдиница");
	КонецЕсли;		
	//
	//Если НЕ Объект.ТорговыеТочки Тогда
	//	СписокТТ.Очистить();
	//КонецЕсли;	
	//
	 Возврат СписокАдресатов;
КонецФункции
