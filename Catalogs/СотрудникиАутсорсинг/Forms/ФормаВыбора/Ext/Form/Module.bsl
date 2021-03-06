﻿//+++AK ziga 091117
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//+++АК mika 2018.01.15 ИП-00017263.02
	//Комментирование оригинального текста
	//ТекГруппаСотрудников = ДопМодульСервер.ПолучитьТекущуюГруппуСотрудниковАутсорсинг();   
	
	//Не сохранять отборы пользователей с полными правами	
	Список.Отбор.Элементы.Очистить(); 
	
	Если Параметры.Свойство("Должность") И ЗначениеЗаполнено(Параметры.Должность) Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Должность");
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ВидСравнения 	 = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Справочники.ДолжностиВнештатныхСотрудников.НайтиПоНаименованию(Параметры.Должность);
		
		Если Не РольДоступна("ПолныеПрава") Тогда
			ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;

	КонецЕсли;
	
	Если Параметры.Свойство("ОтветственныйМенеджер") И ЗначениеЗаполнено(Параметры.ОтветственныйМенеджер) Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ОтветственныйМенеджер");
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ВидСравнения 	 = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Параметры.ОтветственныйМенеджер;
		
		Если Не РольДоступна("ПолныеПрава") Тогда
			ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;

	КонецЕсли;
	
	Если Параметры.Свойство("ТекущийКонтрагент") Тогда
		ГруппаСотрудников = Справочники.СотрудникиАутсорсинг.ПолучитьГруппуСотрудниковПоКонтрагенту(Параметры.ТекущийКонтрагент);
	ИначеЕсли Параметры.Свойство("ГруппаСотрудников") Тогда
		ГруппаСотрудников = Параметры.ГруппаСотрудников;
	Иначе
		ГруппаСотрудников = ДопМодульСервер.ПолучитьТекущуюГруппуСотрудниковАутсорсинг();
	КонецЕсли;
	
	Если НЕ ГруппаСотрудников = Неопределено Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ГруппаСотрудников");
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ВидСравнения 	 = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = ГруппаСотрудников;
		
		Если Не РольДоступна("ПолныеПрава") Тогда
			ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат;

	//---АК mika ИП-00017263.02
	
	Если НЕ ГруппаСотрудников = Неопределено Тогда
		
		ОтборНаФорме = ЭтаФорма.Список.Отбор;
		ПолеКомпоновкиГруппаСотрудников = Новый ПолеКомпоновкиДанных("ГруппаСотрудников");
			
		Если ОтборНаФорме.Элементы.Количество() = 0 Тогда
			
			ЭлементОтбора = ОтборНаФорме.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение 	= ПолеКомпоновкиГруппаСотрудников;
			ЭлементОтбора.Использование 	= Истина;
			ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбора.ПравоеЗначение 	= ГруппаСотрудников;
			//+++Ak ziga  20171119 Ип-00017049
			Если Не РольДоступна("ПолныеПрава") Тогда
			ЭлементОтбора.РежимОтображения=РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			КонецЕсли;
			//---Ak ziga  20171119 Ип-0001704
		Иначе
			
			Для Каждого ЭлементОтбора Из ОтборНаФорме.Элементы Цикл
				
				Если ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновкиГруппаСотрудников Тогда
					
					ЭлементОтбора.ПравоеЗначение = ГруппаСотрудников;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
	//ЭлементОтбора = ЭтаФорма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ПолеКомпоновкиМенеджер = Новый ПолеКомпоновкиДанных("Должность");
	//ЭлементОтбора.ЛевоеЗначение 	= ПолеКомпоновкиМенеджер;
	//ЭлементОтбора.Использование 	= Истина;
	//ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	//ЭлементОтбора.ПравоеЗначение 	= Справочники.ДолжностиВнештатныхСотрудников.НайтиПоНаименованию("Менеджер");


КонецПроцедуры
//---ak ziga

