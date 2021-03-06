﻿
Процедура ПередЗаписью(Отказ, Замещение)
	Для Каждого Запись Из ЭтотОбъект Цикл
		Отказ = НЕ РегистрыСведений.ШтриховыеКоды.ПроверкаШтрихКода(Запись.ШтрихКод, Запись.Номенклатура, Запись.Характеристика);
	КонецЦикла;
	//ОмПроцедурыСетевогоОбмена.ЗарегистрироватьОбъектДляОбработки(ЭтотОбъект, ОбменДанными.Загрузка, , Замещение);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	//+++shar
	// Регистрация изменений в плане обмена
	Попытка
		
		УстановитьПривилегированныйРежим(Истина);
		
		//+++АК SHEP 20160810: исключаем ненужные узлы
		ПрофилиИспользования = Новый Массив;
		ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.Строитель"));
		ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.ПлановыйАссортимент"));
		ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.НовыеТоварыТехнолог"));
		ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.НовыеТоварПостановщикЗадач"));
		//---АК SHEP 20160810
		
		МассивУзлов = Новый Массив;
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	МобильноеПриложение.Ссылка
		|ИЗ
		|	ПланОбмена.МобильноеПриложение КАК МобильноеПриложение
		|ГДЕ
		|	МобильноеПриложение.Ссылка <> &ЭтотУзел
		|	И НЕ МобильноеПриложение.Профиль В (&ПрофилиИспользования)";
		Запрос.УстановитьПараметр("ПрофилиИспользования", ПрофилиИспользования);
		Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.МобильноеПриложение.ЭтотУзел());
		МассивУзлов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		МассивНоменклатуры = Новый Массив;
		
		Для Каждого Запись Из ЭтотОбъект Цикл
			Если МассивНоменклатуры.Найти(Запись.Номенклатура) = Неопределено И ЗначениеЗаполнено(Запись.Номенклатура) Тогда
				МассивНоменклатуры.Добавить(Запись.Номенклатура);
			КонецЕсли;
			Если МассивНоменклатуры.Найти(Запись.ЕдиницаИзмерения) = Неопределено И ЗначениеЗаполнено(Запись.ЕдиницаИзмерения) Тогда
				МассивНоменклатуры.Добавить(Запись.ЕдиницаИзмерения);
			КонецЕсли;
			Если МассивНоменклатуры.Найти(Запись.Характеристика) = Неопределено И ЗначениеЗаполнено(Запись.Характеристика) Тогда
				МассивНоменклатуры.Добавить(Запись.Характеристика);
			КонецЕсли;

		КонецЦикла;
		
		Для Каждого ТекНоменклатура Из МассивНоменклатуры Цикл
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, ТекНоменклатура);
		КонецЦикла;
		
	Исключение
		ЗаписьЖурналаРегистрации(ОписаниеОшибки(), УровеньЖурналаРегистрации.Ошибка);
	КонецПопытки;
	УстановитьПривилегированныйРежим(Ложь);
	
	//---shar

	
КонецПроцедуры
