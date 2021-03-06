﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВариантыОбеспеченияПерсоналомАутсорсингОбеспечениеПерсоналом.Должность.Наименование КАК Должность,
		|	ВариантыОбеспеченияПерсоналомАутсорсингОбеспечениеПерсоналом.Ссылка КАК Вариант,
		|	ВариантыОбеспеченияПерсоналомАутсорсингОбеспечениеПерсоналом.Контрагент,
		|	СУММА(ВариантыОбеспеченияПерсоналомАутсорсингОбеспечениеПерсоналом.КоличествоЧеловек) КАК КоличествоЧеловек
		|ИЗ
		|	Справочник.ВариантыОбеспеченияПерсоналомАутсорсинг.ОбеспечениеПерсоналом КАК ВариантыОбеспеченияПерсоналомАутсорсингОбеспечениеПерсоналом
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДолжностиВнештатныхСотрудников КАК ДолжностиВнештатныхСотрудников
		|		ПО ВариантыОбеспеченияПерсоналомАутсорсингОбеспечениеПерсоналом.Должность = ДолжностиВнештатныхСотрудников.Ссылка
		|ГДЕ
		|	ВариантыОбеспеченияПерсоналомАутсорсингОбеспечениеПерсоналом.Ссылка.ПометкаУдаления = ЛОЖЬ
		|
		|СГРУППИРОВАТЬ ПО
		|	ВариантыОбеспеченияПерсоналомАутсорсингОбеспечениеПерсоналом.Ссылка,
		|	ВариантыОбеспеченияПерсоналомАутсорсингОбеспечениеПерсоналом.Контрагент,
		|	ВариантыОбеспеченияПерсоналомАутсорсингОбеспечениеПерсоналом.Должность.Наименование
		|ИТОГИ
		|	СУММА(КоличествоЧеловек)
		|ПО
		|	Вариант,
		|	Должность";

	Результат = Запрос.Выполнить();

	ВыборкаВариант = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
    ТЗВарианты=Новый ТаблицаЗначений;
	ТЗВарианты.Колонки.Добавить("Вариант",Новый ОписаниеТипов("СправочникСсылка.ВариантыОбеспеченияПерсоналомАутсорсинг"));
	ТЗВарианты.Колонки.Добавить("Контрагент",ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(500));
	ТЗВарианты.Колонки.Добавить("Должность",ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(100));
	ТЗВарианты.Колонки.Добавить("КоличествоЧеловек",ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(10));
	

	
	
	Пока ВыборкаВариант.Следующий() Цикл
		ВыборкаДолжность = ВыборкаВариант.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаДолжность.Следующий() Цикл
			НовСтр=ТЗВарианты.Добавить();
			НовСтр.Вариант=ВыборкаДолжность.Вариант;
			НовСтр.Должность=ВыборкаДолжность.Должность;
			НовСтр.КоличествоЧеловек=ВыборкаДолжность.КоличествоЧеловек;
			ВыборкаКонтр = ВыборкаДолжность.Выбрать();
			СтрКонтр="";
			Пока ВыборкаКонтр.Следующий() Цикл
				Если ЗначениеЗаполнено(ВыборкаКонтр.Контрагент) Тогда
					СтрКонтр=СтрКонтр+Строка(ВыборкаКонтр.Контрагент)+", ";
				КонецЕсли; 
			КонецЦикла;  
			НовСтр.Контрагент=Лев(СтрКонтр,СтрДлина(СтрКонтр)-2);
		КонецЦикла;  
		
	КонецЦикла;


	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДолжностиВнештатныхСотрудников.Наименование КАК Должность
		|ИЗ
		|	Справочник.ДолжностиВнештатныхСотрудников КАК ДолжностиВнештатныхСотрудников
		|ГДЕ
		|	ДолжностиВнештатныхСотрудников.ПометкаУдаления = ЛОЖЬ
		|	И ДолжностиВнештатныхСотрудников.Наименование <> """"
		|
		|СГРУППИРОВАТЬ ПО
		|	ДолжностиВнештатныхСотрудников.Наименование
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДолжностиВнештатныхСотрудников.Наименование";

	Результат = Запрос.Выполнить();

	ТЗДолж = Результат.Выгрузить();
	
	Мак=ПолучитьМакет("Макет");
	ОблШапкаНач=Мак.ПолучитьОбласть("Шапка|Начало");
	ОблШапкаДан=Мак.ПолучитьОбласть("Шапка|Данные");
	
	ОблСтрокаНач=Мак.ПолучитьОбласть("Строка|Начало");
	ОблСтрокаДан=Мак.ПолучитьОбласть("Строка|Данные");

	//ДокументРезультат=Новый ТабличныйДокумент;
	ДокументРезультат.Вывести(ОблШапкаНач);
	Для каждого СтрД Из ТЗДолж Цикл
		ОблШапкаДан.Параметры.Должность=СтрД.Должность;
		ДокументРезультат.Присоединить(ОблШапкаДан);
	КонецЦикла; 
	
	ТЗ=ТЗВарианты.Скопировать();
	ТЗ.Свернуть("Вариант");
	
	Для каждого Стр Из ТЗ Цикл
		ОблСтрокаНач.Параметры.Вариант=Стр.Вариант;
		ДокументРезультат.Вывести(ОблСтрокаНач);
		
		//МасСтрДол=ТЗВарианты.НайтиСтроки(Новый Структура("Вариант",Стр.Вариант));
		//ТЗТекВар=ТЗВарианты.СкопироватьКолонки();
		//Для каждого Эл Из МасСтрДол Цикл
		//	НовСтрТекВар=ТЗТекВар.Добавить();
		//	ЗаполнитьЗначенияСвойств(НовСтрТекВар,Эл);
		//КонецЦикла; 
		
		Для каждого СтрД Из ТЗДолж Цикл
			ОблСтрокаДан=Мак.ПолучитьОбласть("Строка|Данные");
			МасСтр=ТЗВарианты.НайтиСтроки(Новый Структура("Вариант,Должность",Стр.Вариант,СтрД.Должность));
			Если МасСтр.Количество()>0 Тогда
				ОблСтрокаДан.Параметры.КоличествоЧеловек=МасСтр[0].КоличествоЧеловек;
				ОблСтрокаДан.Параметры.Контрагент=МасСтр[0].Контрагент;
			КонецЕсли; 
			ДокументРезультат.Присоединить(ОблСтрокаДан);
		КонецЦикла; 
	КонецЦикла; 
	//ДокументРезультат.Показать();	
	
							
	ДокументРезультат.ФиксацияСверху=1;							
	СтандартнаяОбработка=Ложь;							
	//ДокументРезультат=ТабДок;
КонецПроцедуры
