﻿
&НаСервере
Перем ОбработкаОбъект;

&НаКлиенте
Перем МодульОбменКлиент;

//служебные ---------------------------------------------------------------------------------------

&НаСервере
Функция МодульОбъекта()

	Если ОбработкаОбъект = Неопределено Тогда
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		ОбработкаОбъект.ИнициализироватьПодключаемыеМодули();
	КонецЕсли;	
	
	Возврат ОбработкаОбъект;
	
КонецФункции

&НаСервере
Функция БазаДанныхФайловая()
	
	СтрокаСоединенияИБ = СтрокаСоединенияИнформационнойБазы();
	
	Возврат Найти( Врег(СтрокаСоединенияИБ),"FILE=" ) = 1;
		
КонецФункции

//обработчики -------------------------------------------------------------------------------------

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ОбъектПараметрыКлиентСервер", Объект.ПараметрыКлиентСервер);
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда 
		ВыборДляОрганизации=Параметры.Организация;
		ЭтаФорма.Заголовок = "Выберите сертификат для организации """ + ВыборДляОрганизации+"""";
	КонецЕсли;
	
	Если Параметры.ПоказыватьФлагЗапомнитьВыбор = Истина Тогда
		Элементы.ЗапомнитьВыбор.Видимость = Истина;
	КонецЕсли;
	
	Если Не БазаДанныхФайловая() Тогда
		ЗаполнитьСписокСертификатовСервер();
	КонецЕсли;
	
КонецПроцедуры

//заполнение данных о серверных сертификатах ------------------------------------------------------

&НаСервере
Процедура ЗаполнитьСписокСертификатовСервер()
	
	//Заготовка на будущее Пока что только клиентские серты
	
	//МассивСертификатовСервер = МодульОбъекта().МассивСертификатов();
	//Для Каждого Элемент Из МассивСертификатовСервер Цикл
	//	НоваяСтрока = СписокСертификатов.Добавить();
	//	ЗаполнитьЗначенияСвойств(НоваяСтрока,Элемент);
	//	НоваяСтрока.РасположениеПользовательское = ?(Элемент.Расположение = "клиент", "локально", "на сервере");
	//КонецЦикла;
	
КонецПроцедуры

//-------------------------------------------------------------------------------------------------

//обработчики

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Состояние("Получение списка клиентских сертификатов...",50);	
	
	ЗаполнитьСписокСертификатовКлиент();
	
	Состояние("");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСертификатовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	РезультатВыбора = Новый Структура;
	РеквизитыСертификата = Новый Структура;
	
	ТекущиеДанные = Элементы.СписокСертификатов.ТекущиеДанные;
	
	Для Каждого ПолеСписка Из Элементы.СписокСертификатов.ПодчиненныеЭлементы Цикл
		Идентификатор = ПолеСписка.Имя;
		Значение = ТекущиеДанные[Идентификатор];
		РеквизитыСертификата.Вставить(Идентификатор,Значение);	
	КонецЦикла;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("Действие",   				"ВыборСертификата");
	РезультатВыбора.Вставить("Организация",   			ВыборДляОрганизации);
	РезультатВыбора.Вставить("СертификатДействуетПо",   РеквизитыСертификата.ОкончаниеПериодаДействия);
	РезультатВыбора.Вставить("РеквизитыСертификата",	РеквизитыСертификата);
	РезультатВыбора.Вставить("Отпечаток",   			ТекущиеДанные.Отпечаток);
	РезультатВыбора.Вставить("ЗапомнитьВыбор",			ЗапомнитьВыбор);
	
	Этаформа.Закрыть(РезультатВыбора);

КонецПроцедуры

//заполнение данных о клиентских сертификатах ------------------------------------------------------

&НаКлиенте
Процедура ЗаполнитьСписокСертификатовКлиент()
			
	МассивСертификатовКлиент = МодульОбменКлиент().МассивСертификатов();
	Для Каждого Элемент Из МассивСертификатовКлиент Цикл
		НоваяСтрока = СписокСертификатов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Элемент);
		НоваяСтрока.РасположениеПользовательское = ?(Элемент.Расположение = "клиент", "локально", "на сервере");
	КонецЦикла;	
	
КонецПроцедуры

//служебные ---------------------------------------------------------------------------------------

&НаКлиенте
Функция МодульОбменКлиент()
	
	Если ТипЗнч(МодульОбменКлиент) = Тип("УправляемаяФорма") Тогда
		Возврат МодульОбменКлиент;
	КонецЕсли;
	
	ОсновнаяФорма = ОсновнаяФорма();
	Если ТипЗнч(ОсновнаяФорма) = Тип("УправляемаяФорма") Тогда
		МодульОбменКлиент = ОсновнаяФорма.МодульОбменКлиент();
		Возврат МодульОбменКлиент;
	Иначе
		Сообщить("Ошибка! Не удалось получить контекст основной формы.");
	КонецЕсли;
	          	
КонецФункции

&НаКлиенте
Функция ОсновнаяФорма() Экспорт
	
	Если ЭтаФорма.ВладелецФормы = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат ЭтаФорма.ВладелецФормы.ОсновнаяФорма();
	КонецЕсли;
    	
КонецФункции

&НаКлиенте
Процедура Выбрать(Команда)
	
	СписокСертификатовВыбор("", "", "", "");

КонецПроцедуры

