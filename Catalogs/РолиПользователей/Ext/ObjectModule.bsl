﻿
//
//
Процедура ПередЗаписью(Отказ)
	
	СоставСтрокой = "";
	Для Каждого СтрокаСотрудник Из СоставРоли Цикл
		СоставСтрокой = СоставСтрокой + ?(ЗначениеЗаполнено(СоставСтрокой), Символы.ПС, "") + СтрокаСотрудник.Сотрудник;
	КонецЦикла;	
	
	//+++АК CISA 2018.10.15 ИП-00019741
	НомерСтроки = ВернутьНомерСтрокиОтказа();
	Если НомерСтроки > 0 Тогда
		Сообщить("Для роли """ + ТипыРолей[НомерСтроки-1].ТипРоли + """ нельзя добавить более одного сотрудника.");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	//---АК CISA	
	
	//???ZEZA
	Возврат;
	//---ZEZA
		
	ТипРолиСтр = ОбщегоНазначения.ПолучитьИмяЗначенияПеречисленияПоСсылке(ТипРоли);
	
	// дублирующие проверки, а также для невозможности записать некорректные данные программным путём
	Если НЕ ЗначениеЗаполнено(ТипРоли) Тогда
		Сообщить("Не заполнено поле ""Тип роли");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если ТипРоли = Перечисления.ТипыРолейПользователейМОС.Расчетчик Тогда
		Если ЗначениеЗаполнено(Расчетчик_СтруктурнаяЕдиница) Тогда
			Если ТипЗнч(Расчетчик_СтруктурнаяЕдиница) <> Тип("СправочникСсылка.Расчетчики") Тогда
				Сообщить("Некорректно заполнено поле ""Расчетчик""");
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;		
	ИначеЕсли ТипРоли = Перечисления.ТипыРолейПользователейМОС.Магазин ИЛИ ТипРоли = Перечисления.ТипыРолейПользователейМОС.Склад Тогда
		Если ЗначениеЗаполнено(Расчетчик_СтруктурнаяЕдиница) Тогда
			Если ТипЗнч(Расчетчик_СтруктурнаяЕдиница) <> Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
				Сообщить("Некорректно заполнено поле ""Структ. единица""");
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
			Если ТипРоли = Перечисления.ТипыРолейПользователейМОС.Магазин И Расчетчик_СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы <> Перечисления.ТипыСтруктурныхЕдиниц.Розница 
				ИЛИ ТипРоли = Перечисления.ТипыРолейПользователейМОС.Склад   И Расчетчик_СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы <> Перечисления.ТипыСтруктурныхЕдиниц.Склад  Тогда
				Сообщить("Некорректно заполнено поле ""Структ. единица"" (неверный тип)");
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Родитель) Тогда
		Если ТипРоли <> Родитель.ТипРоли Тогда
			ТипРоли = Родитель.ТипРоли;
			Расчетчик_СтруктурнаяЕдиница = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//
//
Процедура ПриЗаписи(Отказ)
	
	//
	ТЗ = "ВЫБРАТЬ
	     |	&ТекущаяДата КАК Период,
	     |	СоответствиеОбъектРольДляТипаРолиТранспортРазвозСрезПоследних.Откуда,
	     |	СоответствиеОбъектРольДляТипаРолиТранспортРазвозСрезПоследних.Куда
	     |ИЗ
	     |	РегистрСведений.СоответствиеОбъектРольДляТипаРолиТранспортРазвоз.СрезПоследних КАК СоответствиеОбъектРольДляТипаРолиТранспортРазвозСрезПоследних
	     |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставТранспортРазвоз КАК РолиПользователейСоставТранспортРазвоз
	     |		ПО СоответствиеОбъектРольДляТипаРолиТранспортРазвозСрезПоследних.РольПользователя = РолиПользователейСоставТранспортРазвоз.Ссылка
	     |			И (РолиПользователейСоставТранспортРазвоз.Откуда = СоответствиеОбъектРольДляТипаРолиТранспортРазвозСрезПоследних.Откуда)
	     |			И (РолиПользователейСоставТранспортРазвоз.Куда = СоответствиеОбъектРольДляТипаРолиТранспортРазвозСрезПоследних.Куда)
	     |ГДЕ
	     |	СоответствиеОбъектРольДляТипаРолиТранспортРазвозСрезПоследних.РольПользователя = &Ссылка
	     |	И РолиПользователейСоставТранспортРазвоз.Ссылка ЕСТЬ NULL ";
		 
	//
	ПЗ = Новый ПостроительЗапроса;
	ПЗ.Текст = ТЗ;
	
	//
	ПЗ.Параметры.Вставить("ТекущаяДата", ТекущаяДата());
	ПЗ.Параметры.Вставить("Ссылка", Ссылка);
	
	//
	ПЗ.Выполнить();
	
	//
	Выборка = ПЗ.Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
	
		//
		МЗ = РегистрыСведений.СоответствиеОбъектРольДляТипаРолиТранспортРазвоз.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МЗ, Выборка);
		
		//
		МЗ.РольПользователя = Неопределено;
		
		//
		МЗ.Записать();
	
	КонецЦикла; 
	
	//
	Для каждого СтрокаТЧТипыРолей Из ТипыРолей Цикл
	
		//
		Если СтрокаТЧТипыРолей.ТипРоли <> ПланыВидовХарактеристик.ТипыРолейПользователя.ТранспортРазвоз Тогда
			Продолжить;
		КонецЕсли; 
		
		//
		Для каждого СтрокаТЧ Из СоставТранспортРазвоз Цикл
			
			//
			Отбор = Новый Структура("Откуда, Куда");
			ЗаполнитьЗначенияСвойств(Отбор, СтрокаТЧ);
			
			//
			СрезПоследних = РегистрыСведений.СоответствиеОбъектРольДляТипаРолиТранспортРазвоз.СрезПоследних(, Отбор);
			Если СрезПоследних.Количество() = 0 Тогда
				
				//
				МЗ = РегистрыСведений.СоответствиеОбъектРольДляТипаРолиТранспортРазвоз.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(МЗ, СтрокаТЧ);
				
				//
				МЗ.Период = ТекущаяДата();
				
				//
				МЗ.РольПользователя = Ссылка;
				
				//
				МЗ.Записать();
		
				
			Иначе					
				
				//
				_Срез = СрезПоследних[0];
				Если _Срез.РольПользователя <> Ссылка Тогда
				
					//
					МЗ = РегистрыСведений.СоответствиеОбъектРольДляТипаРолиТранспортРазвоз.СоздатьМенеджерЗаписи();
					ЗаполнитьЗначенияСвойств(МЗ, СтрокаТЧ);
					
					//
					МЗ.Период = ТекущаяДата();
					
					//
					МЗ.РольПользователя = Ссылка;
					
					//
					МЗ.Записать();
		
				КонецЕсли; 
			
			КонецЕсли;
		
		КонецЦикла; 
	
	КонецЦикла; 
	
	
	//+++АК SHEP 20160530: регистрируем в обмене с моб. приложением
	Если Отказ Тогда Возврат; КонецЕсли;
	
	ПрофилиИспользования = Новый Массив;
	ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.ПлановыйАссортимент"));
	ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.НовыеТоварыТехнолог"));
	ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.НовыеТоварПостановщикЗадач"));
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	МобильноеПриложение.Ссылка
		|ИЗ
		|	ПланОбмена.МобильноеПриложение КАК МобильноеПриложение
		|ГДЕ
		|	МобильноеПриложение.Профиль В (&ПрофилиИспользования)");
	Запрос.УстановитьПараметр("ПрофилиИспользования", ПрофилиИспользования);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбменДанными.Получатели.Добавить(Выборка.Ссылка);
	КонецЦикла;
	//---АК SHEP 20160530
	
КонецПроцедуры

//+++АК CISA 2018.10.15 ИП-00019741 Контроль указания только одного сотрудника.
Функция ВернутьНомерСтрокиОтказа()
	Для каждого СтрокаТипРоли Из ТипыРолей Цикл
		Если СтрокаТипРоли.ТипРоли = ПредопределенноеЗначение("ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы")
			ИЛИ СтрокаТипРоли.ТипРоли = ПредопределенноеЗначение("ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего") Тогда
			 //СтрСоставРоли = Новый Структура("НомерСтроки, КоличествоСотрудников", СтрокаТипРоли.НомерСтроки, СоставРоли.Количество()); 
			 //Возврат СтрСоставРоли;
			Если СоставРоли.Количество() > 1 Тогда
				Возврат СтрокаТипРоли.НомерСтроки;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат 0;
КонецФункции
