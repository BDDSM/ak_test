﻿Перем флОтправлятьРассылкуПоКраснымМаркерам; //+++АК SHEP 2018.06.25 ИП-00018753.04
Перем флСталоТребуетОбязательногоОтветаПроизводителя; //+++АК SHEP 2018.08.07 ИП-00018753.03
Перем ИсторияИзмененияРеквизитов; //+++АК SHEP 2018.12.19 ИП-00018753.05: сохраняем историю изменения реквизитов

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//+++АК SHEP 2018.06.25 ИП-00018753.04
	флЕстьКрасныеМаркеры = (СоставПоказателей.НайтиСтроки(Новый Структура("Маркер", ПредопределенноеЗначение("Перечисление.МаркерыДляАудита.Красный"))).Количество() > 0);
	
	флОтправлятьРассылкуПоКраснымМаркерам = (флЕстьКрасныеМаркеры И ЗначениеЗаполнено(Ответ) И НЕ ЗначениеЗаполнено(Ссылка.Ответ));
	//---АК SHEP 2018.06.25
	
	//+++АК SHEP 2018.07.26 ИП-00018753.03
	Если флЕстьКрасныеМаркеры И НЕ ТребуетОбязательногоОтветаПроизводителя И НЕ ЗначениеЗаполнено(Ответ) И Дата >= Дата(2018,6,1) Тогда
		Если ОбменДанными.Загрузка = Ложь Тогда
			ТребуетОбязательногоОтветаПроизводителя = Истина;
		КонецЕсли;
	КонецЕсли;
	
	флСталоТребуетОбязательногоОтветаПроизводителя = (ТребуетОбязательногоОтветаПроизводителя И ТребуетОбязательногоОтветаПроизводителя <> Ссылка.ТребуетОбязательногоОтветаПроизводителя);
	//---АК SHEP 2018.07.26 
	
	//+++АК SHEP 2018.12.19 ИП-00018753.05: сохраняем историю изменения реквизитов
	ИсторияИзмененияРеквизитов = РегистрыСведений.ИсторияИзмененияРеквизитовЛКПоставщика.ЗаполнитьДанныеДляИстории(ЭтотОбъект, "ТребуетОбязательногоОтветаПроизводителя");
	//---АК SHEP 2018.12.19
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если НЕ Отказ Тогда
		
		Если ЗначениеЗаполнено(ЭтотОбъект.ИмяФайла) Тогда
			
			Набор = РегистрыСведений.ПрикрепленныеФотоКОбъектам.СоздатьНаборЗаписей();
			Набор.Отбор.Объект.Установить(ЭтотОбъект.Ссылка);
			
			ФайлОбъект = Новый Файл(ЭтотОбъект.ИмяФайла);
			УинФайла = ФайлОбъект.ИмяБезРасширения;
			
			Запись = Набор.Добавить();
			Запись.Номенклатура 			= ЭтотОбъект.Номенклатура;
			Запись.Характеристика 			= ЭтотОбъект.ХарактеристикаНоменклатуры;
			Запись.ТипЗаписи 				= Перечисления.ТипыЗаписейПриложенныхКартинок.ПроверкаКачестваТоваров;
			Запись.ОтносительноеИмяФайла 	= УинФайла + ФайлОбъект.Расширение;
			Запись.Расширение 				= СтрЗаменить(ФайлОбъект.Расширение, ".", "");
			Запись.УинЗаписи 				= УинФайла;
			Запись.Объект 					= ЭтотОбъект.Ссылка;
			Запись.ДатаДобавления 			= ЭтотОбъект.Дата;
			Набор.Записать();
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ЭтотОбъект.ИмяФайлаОтвета) Тогда
			
			Набор = РегистрыСведений.ПрикрепленныеФотоКОбъектам.СоздатьНаборЗаписей();
			Набор.Отбор.Объект.Установить(ЭтотОбъект.Ссылка);
			
			ФайлОбъект = Новый Файл(ИмяФайлаОтвета);
			УинФайла = ФайлОбъект.ИмяБезРасширения;
			
			Запись = Набор.Добавить();
			Запись.Номенклатура 			= ЭтотОбъект.Номенклатура;
			Запись.Характеристика 			= ЭтотОбъект.ХарактеристикаНоменклатуры;
			Запись.ТипЗаписи 				= Перечисления.ТипыЗаписейПриложенныхКартинок.ПроверкаКачестваТоваров;
			Запись.ОтносительноеИмяФайла 	= УинФайла + ФайлОбъект.Расширение;
			Запись.Расширение 				= СтрЗаменить(ФайлОбъект.Расширение, ".", "");
			Запись.УинЗаписи 				= УинФайла;
			Запись.Объект 					= ЭтотОбъект.Ссылка;
			Запись.ДатаДобавления 			= ЭтотОбъект.Дата;
			Набор.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
	//+++АК SHEP 2018.06.25 ИП-00018753.04
	Если флОтправлятьРассылкуПоКраснымМаркерам Тогда
		
		МассивЭлАдресов = РегистрыСведений.АК_ГруппыРассылки.ПолучитьМассивЭлАдресовПоГруппеРассылки(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.ПолученОтветПроизводителяПоКрасномуПротоколу"));
			
		СтруктураПолей = Новый Структура("Ссылка,Номенклатура,Производитель,Нарушения,Ответ",
			"Документ", "Номенклатура", "Производитель", "Нарушения", "Ответ производителя");
		
		ТекстХТМЛ = СтроковыеФункцииКлиентСервер.ТекстХТМЛ_НачалоХТМЛ();
		ТекстХТМЛ = ТекстХТМЛ + СтроковыеФункцииКлиентСервер.ТекстХТМЛ_ТаблицаЗаголовок(СтруктураПолей, Истина);
		ЗаполнитьЗначенияСвойств(СтруктураПолей, ЭтотОбъект);
		ТекстХТМЛ = ТекстХТМЛ + СтроковыеФункцииКлиентСервер.ТекстХТМЛ_ТаблицаТело(СтруктураПолей,,, Истина);
		ТекстПисьмаОтветПроизводителя = ТекстХТМЛ + СтроковыеФункцииКлиентСервер.ТекстХТМЛ_КонецХТМЛ();
		
		Документы.ЗаданиеТехнологаМагазинам.ОтправитьСообщение("Получен ответ производителя по красному протоколу", ТекстПисьмаОтветПроизводителя, МассивЭлАдресов, "Ответ производителя");
		
	КонецЕсли;
	//---АК SHEP 2018.06.26
	
	//+++АК SHEP 2018.08.07 ИП-00018753.03
	Если флСталоТребуетОбязательногоОтветаПроизводителя Тогда
		ВнешОбработка = ПолныеПрава.ПолучитьИПодключитьВнешнююОбработку("Требует обязательного ответа производителя (рассылка)");
		Если ВнешОбработка <> Неопределено Тогда
			ВнешОбработка.ВыполнитьРассылку(Новый Структура("Ссылка", Ссылка));
		КонецЕсли;
	КонецЕсли;
	//---АК SHEP 2018.08.07
	
	//+++АК SHEP 2018.12.19 ИП-00018753.05: сохраняем историю изменения реквизитов
	Если ИсторияИзмененияРеквизитов.Количество() > 0 Тогда
		РегистрыСведений.ИсторияИзмененияРеквизитовЛКПоставщика.ЗаписатьИсторию(Ссылка, ИсторияИзмененияРеквизитов);
	КонецЕсли;
	//---АК SHEP 2018.12.19
	
КонецПроцедуры

//+++АК VERN 2016.08.10 ИП-00013306
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Попытка
		УстановитьПривилегированныйРежим(Истина);
	
		Если НЕ ЗначениеЗаполнено(Производитель) тогда
			Возврат;
		КонецЕсли;
		
		Движения.АК_РассылкиПоставщикамТехнологам.Записывать = Истина;
		Движения.АК_РассылкиПоставщикамТехнологам.Очистить();
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПроверкаКачестваТоваровСоставПоказателей.Нарушение
		|ИЗ
		|	Документ.ПроверкаКачестваТоваров.СоставПоказателей КАК ПроверкаКачестваТоваровСоставПоказателей
		|ГДЕ
		|	ПроверкаКачестваТоваровСоставПоказателей.Ссылка = &Ссылка
		|	И ПроверкаКачестваТоваровСоставПоказателей.Нарушение";

		Если НЕ Запрос.Выполнить().Пустой() Тогда

			Движение = Движения.АК_РассылкиПоставщикамТехнологам.Добавить();
			Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
			Движение.Период 		= ЭтотОбъект.Дата;
			//Движение.GUID_Загрузки = Запись.GUID_Загрузки;
			Движение.Производитель 	= ЭтотОбъект.Производитель;
			
			Если ЗначениеЗаполнено(ЭтотОбъект.Технолог) тогда
				Движение.Технолог	= ЭтотОбъект.Технолог;
			иначе
				Движение.Технолог 	= ЭтотОбъект.Номенклатура.Технолог;
			КонецЕсли;
			Движение.ЭтоПроверкаКачества				= Истина;
			Движение.УведомлятьПоставщикаПриРассылке 	= Истина;
			Движение.УведомлятьТехнологаПриРассылке 	= Истина;
			Движение.КоличествоОбращений 				= 1;
				
		КонецЕсли;
		Движения.Записать();
		УстановитьПривилегированныйРежим(Ложь);
	Исключение
	КонецПопытки;
	
	//+++АК LAGP 2018.03.09 ИП-00017097.03
	Если НЕ Отказ И ЗначениеЗаполнено(ДокументОснование) И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаданиеЛаборатории") Тогда
		Если НЕ ДокументОснование.Статус = Перечисления.СтатусыЗаданийЛаборатории.Выполнено И НЕ ДокументОснование.ПометкаУдаления Тогда
			ОбъектЗаданиеЛаборатории 		= ДокументОснование.ПолучитьОбъект();
			ОбъектЗаданиеЛаборатории.Статус = Перечисления.СтатусыЗаданийЛаборатории.Выполнено;
			ОбъектЗаданиеЛаборатории.Записать(РежимЗаписиДокумента.Проведение);
		КонецЕсли;
	КонецЕсли;	
	//---АК LAGP
	
КонецПроцедуры
//---АК VERN 2016.08.10 ИП-00013306

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	//+++АК LAGP 2018.03.09 ИП-00017097.03
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаданиеЛаборатории") Тогда
		ДокументОснование 			= ДанныеЗаполнения;
		Номенклатура 				= ДанныеЗаполнения.Номенклатура;
		Производитель 				= ДанныеЗаполнения.Поставщик;
		Статус 						= Перечисления.СтатусыЖурналаПроверкиКачестваТоваров.НеобходимаПроверка;
		
		//+++АК CISA 2018.11.08 ИП-00020059
		//ХарактеристикаНоменклатуры 	= ДопМодульСервер.ПолучитьХарактеристикуНоменклатуры(Производитель, Номенклатура);
		ХарактеристикаНоменклатуры 	= ДанныеЗаполнения.Характеристика;
		ТипыИсследований.Загрузить(ДанныеЗаполнения.ТипыИсследований.Выгрузить());
		//---АК CISA
		
		Лаборатория					= Справочники.Контрагенты.НайтиПоКоду("000000561"); //+++АК LAGP 2018.04.13 ИП-00018390 Решено отказаться от надписи и использовать контрагента "Вкусвилл" для документов внутренней лаборатории 
	//---АК LAGP	
	КонецЕсли;
	
КонецПроцедуры

//+++АК LAGP 2018.03.12 ИП-00017097.03
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если НЕ Отказ И ЗначениеЗаполнено(ДокументОснование) И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаданиеЛаборатории") Тогда
		Если ДокументОснование.Статус = Перечисления.СтатусыЗаданийЛаборатории.Выполнено И НЕ ДокументОснование.ПометкаУдаления Тогда
			ОбъектЗаданиеЛаборатории 		= ДокументОснование.ПолучитьОбъект();
			ОбъектЗаданиеЛаборатории.Статус = Перечисления.СтатусыЗаданийЛаборатории.ВРаботе;
			ОбъектЗаданиеЛаборатории.Записать(РежимЗаписиДокумента.Проведение);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры
