﻿&НаКлиенте
Процедура ЗаполнитьСписок()
	Объект.НастройкиПолейФормы.Очистить();
	//+++АК SUVV 2018.03.05 ИП-00017818
	//Форма = Справочники.СтруктурныеЕдиницы.ПолучитьФорму("НовыйМагазин");
	Форма = ПолучитьФорму("Справочник.СтруктурныеЕдиницы.Форма.НовыйМагазин");
	//---АК SUVV
	Для каждого Элемент из Форма.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПолеФормы") Тогда
			НоваяСтрока = Объект.НастройкиПолейФормы.Добавить();
			НоваяСтрока.Поле = Элемент.Имя;
		КонецЕсли;
	КонецЦикла;

	//Отбор = Новый Структура;
	//Отбор.Вставить("КлючОбъекта","Справочник.СтруктурныеЕдиницы.Форма.НовыйМагазин");
	//ВыборкаНастроек = ХранилищеСистемныхНастроек.Выбрать(Отбор);
	//Если ВидНастройки = "КонтрольЗаполнения" Тогда
	//	СтрКлючНастроек = "_КонтрольЗаполнения";	
	//ИначеЕсли ВидНастройки = "ЗапретРедактирования" Тогда
	//	СтрКлючНастроек = "_ЗапретРедактирования";
	//КонецЕсли;
	//Пока ВыборкаНастроек.Следующий() Цикл
	//	Если Найти(ВыборкаНастроек.КлючНастроек, СтрКлючНастроек) <> 0 Тогда
	//		ПараметрыОтбора = Новый Структура;
	//		ПараметрыОтбора.Вставить("Поле", СтрЗаменить(ВыборкаНастроек.КлючНастроек, СтрКлючНастроек,""));
	//		НайденныеСтроки = Объект.НастройкиПолейФормы.НайтиСтроки(ПараметрыОтбора);
	//		Для каждого Стр из НайденныеСтроки Цикл
	//			Стр.Значение = ВыборкаНастроек.Настройки;
	//			Если ЗначениеЗаполнено(Стр.Пользователи) Тогда
	//				Стр.Пользователи = Стр.Пользователи + ", " + ВыборкаНастроек.Пользователь;
	//			Иначе
	//				Стр.Пользователи = ВыборкаНастроек.Пользователь;
	//			КонецЕсли;
	//		КонецЦикла;
	//	КонецЕсли;
	//КонецЦикла;
	//Объект.НастройкиПолейФормы.Сортировать("Поле");
	//+++АК SUVV 2018.03.05 ИП-00017818
	УстановитьПользователей();
	//Запрос = новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	НастройкиОткрытияМагазинов.НастраеваемыйОбъект КАК Поле,
	//               |	НастройкиОткрытияМагазинов.Значение КАК Пользователи
	//               |ИЗ
	//               |	РегистрСведений.НастройкиОткрытияМагазинов КАК НастройкиОткрытияМагазинов
	//               |ГДЕ
	//               |	НастройкиОткрытияМагазинов.ВидНастройки = &ВидНастройки";
	//Запрос.УстановитьПараметр("ВидНастройки", ПредопределенноеЗначение("Перечисление.ВидыНастроекОткрытияМагазина." + ВидНастройки));
	//ВыборкаНастроек = Запрос.Выполнить().Выбрать();
	//Пока ВыборкаНастроек.Следующий() Цикл
	//	ПараметрыОтбора = Новый Структура;
	//	ПараметрыОтбора.Вставить("Поле", ВыборкаНастроек.Поле);
	//	НайденныеСтроки = Объект.НастройкиПолейФормы.НайтиСтроки(ПараметрыОтбора);
	//		Для каждого Стр из НайденныеСтроки Цикл
	//			Стр.Пользователи = ВыборкаНастроек.Пользователи;
	//		КонецЦикла;
	//КонецЦикла;
	//Запрос.УстановитьПараметр("ВидНастройки", ПредопределенноеЗначение("Перечисление.ВидыНастроекОткрытияМагазина." + ВидНастройки + "ДляВсехЗаИсключением"));
	//ВыборкаНастроек = Запрос.Выполнить().Выбрать();
	//Пока ВыборкаНастроек.Следующий() Цикл
	//	ПараметрыОтбора = Новый Структура;
	//	ПараметрыОтбора.Вставить("Поле", ВыборкаНастроек.Поле);
	//	НайденныеСтроки = Объект.НастройкиПолейФормы.НайтиСтроки(ПараметрыОтбора);
	//		Для каждого Стр из НайденныеСтроки Цикл
	//			Стр.Пользователи = ВыборкаНастроек.Пользователи;
	//			Стр.Значение = Истина;
	//		КонецЦикла;
	//КонецЦикла;
	//---АК SUVV
	Объект.НастройкиПолейФормы.Сортировать("Поле");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВидНастройки = "КонтрольЗаполнения";
	ЗаполнитьСписок();	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)	
	СохранитьНастройкиНаСервере();		
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиНаСервере()
	НачатьТранзакцию();
	//Удалим текущие настройки
	//Отбор = Новый Структура;
	//Отбор.Вставить("КлючОбъекта","Справочник.СтруктурныеЕдиницы.Форма.НовыйМагазин");
	//ВыборкаНастроек = ХранилищеСистемныхНастроек.Выбрать(Отбор);
	//Пока ВыборкаНастроек.Следующий() Цикл
	//	Если Найти(ВыборкаНастроек.КлючНастроек, "_КонтрольЗаполнения") <> 0 Тогда
	//		ХранилищеСистемныхНастроек.Удалить("Справочник.СтруктурныеЕдиницы.Форма.НовыйМагазин",ВыборкаНастроек.КлючНастроек,ВыборкаНастроек.Пользователь);	
	//	КонецЕсли;	
	//КонецЦикла;
	////Запишем новые
	//Если ВидНастройки = "КонтрольЗаполнения" Тогда
	//	СтрКлючНастроек = "_КонтрольЗаполнения";	
	//ИначеЕсли ВидНастройки = "ЗапретРедактирования" Тогда
	//	СтрКлючНастроек = "_ЗапретРедактирования";
	//КонецЕсли;
	//Для каждого Стр из Объект.НастройкиПолейФормы цикл	
	//	Если ЗначениеЗаполнено(Стр.Пользователи) Тогда
	//		Если Найти(Стр.Пользователи,", ") <> 0 Тогда
	//			ТекстПользователи = СтрЗаменить(Стр.Пользователи,", ",Символы.ПС);
	//			Для НомСтр = 1 По СтрЧислоСтрок(ТекстПользователи) Цикл
	//				ХранилищеСистемныхНастроек.Сохранить("Справочник.СтруктурныеЕдиницы.Форма.НовыйМагазин","" + СТр.Поле + СтрКлючНастроек, Стр.Значение,,СокрЛП(СтрПолучитьСТроку(ТекстПользователи, НомСтр)));
	//			КонецЦикла;
	//		Иначе
	//			ХранилищеСистемныхНастроек.Сохранить("Справочник.СтруктурныеЕдиницы.Форма.НовыйМагазин","" + СТр.Поле + СтрКлючНастроек, Стр.Значение,,Стр.Пользователи);
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЦикла;	
	//Удалим текущие настройки
	НаборЗаписей = РегистрыСведений.НастройкиОткрытияМагазинов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ВидНастройки.Установить(ПредопределенноеЗначение("Перечисление.ВидыНастроекОткрытияМагазина." + ВидНастройки));
	НаборЗаписей.Записать();
	
	//Запишем новые  
	ТЗ = новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("ВидНастройки");
	ТЗ.Колонки.Добавить("НастраеваемыйОбъект");
	ТЗ.Колонки.Добавить("Значение");
	Для каждого Стр из Объект.НастройкиПолейФормы цикл	
		Если ЗначениеЗаполнено(Стр.Пользователи) И НЕ Стр.Значение Тогда
			НовСтрока = ТЗ.Добавить();
			НовСтрока.ВидНастройки = ПредопределенноеЗначение("Перечисление.ВидыНастроекОткрытияМагазина." + ВидНастройки);
			НовСтрока.НастраеваемыйОбъект = Стр.Поле;
			НовСтрока.Значение = Стр.Пользователи;
		КонецЕсли;
	КонецЦикла;
	НаборЗаписей.Загрузить(ТЗ);
	НаборЗаписей.Записать();
	
	//Удалим текущие настройки
	НаборЗаписей = РегистрыСведений.НастройкиОткрытияМагазинов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ВидНастройки.Установить(ПредопределенноеЗначение("Перечисление.ВидыНастроекОткрытияМагазина." + ВидНастройки + "ДляВсехЗаИсключением"));
	НаборЗаписей.Записать();
	
	//Запишем новые  
	ТЗ = новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("ВидНастройки");
	ТЗ.Колонки.Добавить("НастраеваемыйОбъект");
	ТЗ.Колонки.Добавить("Значение");
	Для каждого Стр из Объект.НастройкиПолейФормы цикл	
		Если ЗначениеЗаполнено(Стр.Пользователи) И Стр.Значение Тогда
			НовСтрока = ТЗ.Добавить();
			НовСтрока.ВидНастройки = ПредопределенноеЗначение("Перечисление.ВидыНастроекОткрытияМагазина." + ВидНастройки + "ДляВсехЗаИсключением");
			НовСтрока.НастраеваемыйОбъект = Стр.Поле;
			НовСтрока.Значение = Стр.Пользователи;
		КонецЕсли;
	КонецЦикла;
	НаборЗаписей.Загрузить(ТЗ);
	НаборЗаписей.Записать();

	ЗафиксироватьТранзакцию();
КонецПроцедуры	

&НаКлиенте
Процедура НастройкиПолейФормыПользователиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.НастройкиПолейФормы.ТекущиеДанные;	
	СтандартнаяОбработка = Ложь;
	П = Новый Структура;
	П.Вставить("Пользователи", Элемент.ТекстРедактирования);
	ТекущиеДанные.Пользователи = ОткрытьФормуМодально("Обработка.ОткрытиеМагазинов.Форма.ФормаВыбораПользователей",П, Элемент);	
КонецПроцедуры


&НаКлиенте
Процедура ВидНастройкиПриИзменении(Элемент)
	ЗаполнитьСписок();
КонецПроцедуры
//+++АК SUVV 2018.03.05 ИП-00017818
&НаСервере
Процедура УстановитьПользователей()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НастройкиОткрытияМагазинов.НастраеваемыйОбъект КАК Поле,
	|	НастройкиОткрытияМагазинов.Значение КАК Пользователи
	|ИЗ
	|	РегистрСведений.НастройкиОткрытияМагазинов КАК НастройкиОткрытияМагазинов
	|ГДЕ
	|	НастройкиОткрытияМагазинов.ВидНастройки = &ВидНастройки";
	Запрос.УстановитьПараметр("ВидНастройки", ПредопределенноеЗначение("Перечисление.ВидыНастроекОткрытияМагазина." + ВидНастройки));
	ВыборкаНастроек = Запрос.Выполнить().Выбрать();
	Пока ВыборкаНастроек.Следующий() Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Поле", ВыборкаНастроек.Поле);
		НайденныеСтроки = Объект.НастройкиПолейФормы.НайтиСтроки(ПараметрыОтбора);
		Для каждого Стр из НайденныеСтроки Цикл
			Стр.Пользователи = ВыборкаНастроек.Пользователи;
		КонецЦикла;
	КонецЦикла;
	Запрос.УстановитьПараметр("ВидНастройки", ПредопределенноеЗначение("Перечисление.ВидыНастроекОткрытияМагазина." + ВидНастройки + "ДляВсехЗаИсключением"));
	ВыборкаНастроек = Запрос.Выполнить().Выбрать();
	Пока ВыборкаНастроек.Следующий() Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Поле", ВыборкаНастроек.Поле);
		НайденныеСтроки = Объект.НастройкиПолейФормы.НайтиСтроки(ПараметрыОтбора);
		Для каждого Стр из НайденныеСтроки Цикл
			Стр.Пользователи = ВыборкаНастроек.Пользователи;
			Стр.Значение = Истина;
		КонецЦикла;
	КонецЦикла;	
	
КонецПроцедуры  //---АК SUVV

