﻿
Процедура УправлениеОкнамиМагазинов(Открываемое) Экспорт
	
	//////////////////////////////////////////////////
	//// старый код (до 13.07.2015) 
	//ОткрытыеОкна = ПолучитьОкна();
	//Если Открываемое = "КассовыеОперации" Тогда
	//	Для Каждого Окно Из ОткрытыеОкна Цикл
	//		Если Окно.Основное Тогда
	//			Продолжить;
	//		КонецЕсли;
	//		ОкноСодержимое = Окно.ПолучитьСодержимое();
	//		Если ЛЕВ(ОкноСодержимое.КлючУникальности, 3) = "ТД_" Тогда
	//			ОкноСодержимое.Закрыть();
	//		КонецЕсли;	
	//	КонецЦикла;
	//ИначеЕсли Открываемое = "Товародвижения" Тогда
	//	Для Каждого Окно Из ОткрытыеОкна Цикл
	//		Если Окно.Основное Тогда
	//			Продолжить;
	//		КонецЕсли;
	//		ОкноСодержимое = Окно.ПолучитьСодержимое();
	//		Если ЛЕВ(ОкноСодержимое.КлючУникальности, 3) = "КО_" Тогда
	//			ОкноСодержимое.Закрыть();
	//		КонецЕсли;	
	//	КонецЦикла;	
	//КонецЕсли;
	//
	//// старый код (до 13.07.2015) 
	//////////////////////////////////////////////////
		
	
	ОткрытыеОкна = ПолучитьОкна();
	Если Открываемое = "КассовыеОперации" Тогда
		Для Каждого Окно Из ОткрытыеОкна Цикл
			Если Окно.Основное Тогда
				Продолжить;
			КонецЕсли;
			ОкноСодержимое = Окно.ПолучитьСодержимое();
			Если Лев(ОкноСодержимое.КлючУникальности, 3) = "ТД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ВК_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЩ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЕ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ПК_" 
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ЖД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ФО_" Тогда
				ОкноСодержимое.Закрыть();
			КонецЕсли;	
		КонецЦикла;
	ИначеЕсли Открываемое = "Товародвижения" Тогда
		Для Каждого Окно Из ОткрытыеОкна Цикл
			Если Окно.Основное Тогда
				Продолжить;
			КонецЕсли;
			ОкноСодержимое = Окно.ПолучитьСодержимое();
			Если Лев(ОкноСодержимое.КлючУникальности, 3) = "КО_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ВК_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЩ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЕ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ПК_" 
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ЖД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ФО_" Тогда
				ОкноСодержимое.Закрыть();
			КонецЕсли;	
		КонецЦикла;	
	ИначеЕсли Открываемое = "Сообщения" Тогда
		Для Каждого Окно Из ОткрытыеОкна Цикл
			Если Окно.Основное Тогда
				Продолжить;
			КонецЕсли;
			ОкноСодержимое = Окно.ПолучитьСодержимое();
			Если Лев(ОкноСодержимое.КлючУникальности, 3) = "КО_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ВК_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ТД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЕ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ПК_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ЖД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ФО_" Тогда
				ОкноСодержимое.Закрыть();
			КонецЕсли;	
		КонецЦикла;	
	ИначеЕсли Открываемое = "ЖурналРеглРаботВМагазинах" Тогда
		Для Каждого Окно Из ОткрытыеОкна Цикл
			Если Окно.Основное Тогда
				Продолжить;
			КонецЕсли;
			ОкноСодержимое = Окно.ПолучитьСодержимое();
			Если Лев(ОкноСодержимое.КлючУникальности, 3) = "КО_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ВК_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ТД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЩ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ПК_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ЖД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ФО_" Тогда
				ОкноСодержимое.Закрыть();
			КонецЕсли;	
		КонецЦикла;
	ИначеЕсли Открываемое = "ПротоколыПроверокКачества" Тогда
		Для Каждого Окно Из ОткрытыеОкна Цикл
			Если Окно.Основное Тогда
				Продолжить;
			КонецЕсли;
			ОкноСодержимое = Окно.ПолучитьСодержимое();
			Если Лев(ОкноСодержимое.КлючУникальности, 3) = "КО_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ВК_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ТД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЩ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЕ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ЖД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ФО_" Тогда
				ОкноСодержимое.Закрыть();
			КонецЕсли;	
		КонецЦикла;	
	ИначеЕсли Открываемое = "ПросмотрУправлениеВидеоКамерами" Тогда
		Для Каждого Окно Из ОткрытыеОкна Цикл
			Если Окно.Основное Тогда
				Продолжить;
			КонецЕсли;
			ОкноСодержимое = Окно.ПолучитьСодержимое();
			Если Лев(ОкноСодержимое.КлючУникальности, 3) = "КО_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ПК_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ТД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЩ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЕ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ЖД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ФО_" Тогда
				ОкноСодержимое.Закрыть();
			КонецЕсли;	
		КонецЦикла;	
//Раков П.С. ++		
	ИначеЕсли Открываемое = "Основная" Тогда
		Для Каждого Окно Из ОткрытыеОкна Цикл
			Если Окно.Основное Тогда
				Продолжить;
			КонецЕсли;
			ОкноСодержимое = Окно.ПолучитьСодержимое();
			Если Лев(ОкноСодержимое.КлючУникальности, 3) = "ФО_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ВК_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЩ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЕ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ПК_" 
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ТД_" 
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ЖД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "КО_" Тогда
				ОкноСодержимое.Закрыть();
			КонецЕсли;	
		КонецЦикла;	
	ИначеЕсли Открываемое = "ЖурналыИДокументы" Тогда
		Для Каждого Окно Из ОткрытыеОкна Цикл
			Если Окно.Основное Тогда
				Продолжить;
			КонецЕсли;
			ОкноСодержимое = Окно.ПолучитьСодержимое();
			Если Лев(ОкноСодержимое.КлючУникальности, 3) = "ФО_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ВК_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЩ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ЖД_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "СЕ_"
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ПК_" 
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "ТД_" 
					ИЛИ Лев(ОкноСодержимое.КлючУникальности, 3) = "КО_" Тогда
				ОкноСодержимое.Закрыть();
			КонецЕсли;	
		КонецЦикла;	
//Раков П.С. --		
	КонецЕсли;
	
КонецПроцедуры	
