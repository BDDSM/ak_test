﻿
&НаКлиенте
Процедура Справочник(Команда)
	ТекИмя = Команда.Имя;
	ИмяСправочника = стрЗаменить(ТекИмя,"Справочник_","");
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("НастройкаСайта",НастройкаСайта);
	СтруктураПараметров.Вставить("СистемаУправленияСайтом",СистемаУправленияСайтом);
	
	Ф = ПолучитьФорму("Справочник."+ИмяСправочника+".ФормаСписка",СтруктураПараметров);
	НазваниеЛевогоЗначения = ПолучитьНазваниеЛевогоЗначения("Справочники",ИмяСправочника);
	
	Если НазваниеЛевогоЗначения <> Неопределено И ЗначениеЗаполнено(СистемаУправленияСайтом) Тогда
		Нашли = Ложь;
		ТекПоле = Новый ПолеКомпоновкиДанных(НазваниеЛевогоЗначения+".СистемаУправленияСайтом");
		Для Каждого СтрТз из ф.Список.отбор.Элементы Цикл
			Если СтрТз.ЛевоеЗначение = ТекПоле Тогда
				ДобСтр = СтрТз;
				Нашли = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ Нашли Тогда		
			ДобСтр = Ф.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Конецесли;
		
		ДобСтр.ЛевоеЗначение = ТекПоле;
		ДобСтр.ПравоеЗначение = СистемаУправленияСайтом;
		ДобСтр.ИСпользование = Истина;
	КонецЕсли;
	
	Если НазваниеЛевогоЗначения <> Неопределено И ЗначениеЗаполнено(НастройкаСайта) Тогда
		Нашли = Ложь;
		ТекПоле = Новый ПолеКомпоновкиДанных(НазваниеЛевогоЗначения);
		
		Для Каждого СтрТз из ф.Список.отбор.Элементы Цикл
			Если СтрТз.ЛевоеЗначение = ТекПоле Тогда
				ДобСтр = СтрТз;
				Нашли = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ Нашли Тогда
			ДобСтр = Ф.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		КонецЕсли;
		
		ДобСтр.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(НазваниеЛевогоЗначения);
		ДобСтр.ПравоеЗначение = НастройкаСайта;
		ДобСтр.ИСпользование = Истина;
	КонецЕсли;
	
	Ф.Открыть();
КонецПроцедуры

Функция ПолучитьНазваниеЛевогоЗначения(ИмяМенеджераМетаданных,ИмяОбъектаМетаданных)
	ТекМетаданные = Метаданные[ИмяМенеджераМетаданных][ИмяОбъектаМетаданных];
	
	Если ИмяОбъектаМетаданных = "CMS1C_НастройкиСайтов" Тогда
		Возврат "Ссылка";
	КонецЕсли;
	
	Если ИмяМенеджераМетаданных = "РегистрыСведений" Тогда
		Если ТекМетаданные.Реквизиты.Найти("НастройкаСайта")<> Неопределено Тогда
			ИмяРеквизитаНастройкаСайта = "НастройкаСайта";
		ИначеЕсли ТекМетаданные.Измерения.Найти("НастройкаСайта")<> Неопределено Тогда
			ИмяРеквизитаНастройкаСайта = "НастройкаСайта";
		ИначеЕсли ТекМетаданные.Ресурсы.Найти("НастройкаСайта")<> Неопределено Тогда
			ИмяРеквизитаНастройкаСайта = "НастройкаСайта";
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Если ТекМетаданные.Реквизиты.Найти("НастройкаСайта")<> Неопределено Тогда
			ИмяРеквизитаНастройкаСайта = "НастройкаСайта";
		ИначеЕсли ТекМетаданные.Владельцы.Количество() = 0 Тогда
			Возврат Неопределено;
		Иначе
			ИмяРеквизитаНастройкаСайта = "Владелец";
		КонецЕсли;
	КонецЕсли;
	Возврат ИмяРеквизитаНастройкаСайта;
КонецФункции

&НаКлиенте
Процедура РегистрСведений(Команда)
	ТекИмя = Команда.Имя;
	ИмяСправочника = стрЗаменить(ТекИмя,"РегистрСведений_","");
	Ф = ПолучитьФорму("РегистрСведений."+ИмяСправочника+".ФормаСписка");
	
	НазваниеЛевогоЗначения = ПолучитьНазваниеЛевогоЗначения("РегистрыСведений",ИмяСправочника);
	
	Если НазваниеЛевогоЗначения <> Неопределено И ЗначениеЗаполнено(СистемаУправленияСайтом) Тогда
		Нашли = Ложь;
		ТекПоле = Новый ПолеКомпоновкиДанных(НазваниеЛевогоЗначения+".СистемаУправленияСайтом");
		Для Каждого СтрТз из ф.Список.отбор.Элементы Цикл
			Если СтрТз.ЛевоеЗначение = ТекПоле Тогда
				ДобСтр = СтрТз;
				Нашли = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ Нашли Тогда		
			ДобСтр = Ф.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Конецесли;
		
		ДобСтр.ЛевоеЗначение = ТекПоле;
		ДобСтр.ПравоеЗначение = СистемаУправленияСайтом;
		ДобСтр.ИСпользование = Истина;
	КонецЕсли;
	
	Если НазваниеЛевогоЗначения <> Неопределено И ЗначениеЗаполнено(НастройкаСайта) Тогда
		Нашли = Ложь;
		ТекПоле = Новый ПолеКомпоновкиДанных(НазваниеЛевогоЗначения);
		
		Для Каждого СтрТз из ф.Список.отбор.Элементы Цикл
			Если СтрТз.ЛевоеЗначение = ТекПоле Тогда
				ДобСтр = СтрТз;
				Нашли = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ Нашли Тогда
			ДобСтр = Ф.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		КонецЕсли;
		
		ДобСтр.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(НазваниеЛевогоЗначения);
		ДобСтр.ПравоеЗначение = НастройкаСайта;
		ДобСтр.ИСпользование = Истина;
	КонецЕсли;
	
	Ф.Открыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьСистемыУправленияСайтом();
	ЗаполнитьКнопкиИнтерфейса();
	
КонецПроцедуры

Процедура ЗаполнитьСистемыУправленияСайтом()
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	CMS1C_НастройкиСайтов.СистемаУправленияСайтом КАК СистемаУправленияСайтом
	|ИЗ
	|	Справочник.CMS1C_НастройкиСайтов КАК CMS1C_НастройкиСайтов
	|ГДЕ
	|	НЕ CMS1C_НастройкиСайтов.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	СистемаУправленияСайтом
	|АВТОУПОРЯДОЧИВАНИЕ";
	Выб = Запрос.Выполнить().Выбрать();
	Пока ВЫб.Следующий() Цикл
		Элементы.СистемаУправленияСайтом.СписокВыбора.Добавить(Выб.СистемаУправленияСайтом);
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(СистемаУправленияСайтом) И Элементы.СистемаУправленияСайтом.СписокВыбора.Количество()>0 Тогда
		СистемаУправленияСайтом = Элементы.СистемаУправленияСайтом.СписокВыбора[0].Значение;
	КонецЕсли;
КонецПроцедуры

Процедура ОбновитьВидимостьКнопокИнтерфейса()
	МетаданныеОсновнойПодсистемы = Метаданные.Подсистемы.CMS1C_ОбменССайтами;
	Если ЗначениеЗаполнено(СистемаУправленияСайтом) Тогда
		МетаданныеТекущейПодсистемы = МетаданныеОсновнойПодсистемы.Подсистемы["CMS1C_"+СокрЛП(СистемаУправленияСайтом)];
	ИНаче
		МетаданныеТекущейПодсистемы = МетаданныеОсновнойПодсистемы;
	КонецЕсли;
	МетаданныеДополнительныеОбъекты = Метаданные.Подсистемы.CMS1C_ОбменССайтами.Подсистемы.CMS1C_ДополнительныеОбъекты;
	
	//1) Справочники + ПВХ
	Для Каждого ТекСправочник из Метаданные.Справочники Цикл
		Если МетаданныеОсновнойПодсистемы.Состав.Содержит(ТекСправочник)  = Ложь Тогда
			Продолжить;
		КонецЕсли;
		
		Если МетаданныеДополнительныеОбъекты.Состав.Содержит(ТекСправочник) = Истина Тогда
			Продолжить;
		КонецЕсли;
		
		Кнопка = Элементы["Справочник_"+ТекСправочник.Имя];
		Кнопка.Видимость = МетаданныеТекущейПодсистемы.Состав.Содержит(ТекСправочник);
	КонецЦикла;
	
	Кнопка = Элементы["ПланВидовХарактеристик_"+"CMS1C_СвойстваОбъектов"];
	Кнопка.Видимость = МетаданныеТекущейПодсистемы.Состав.Содержит(Метаданные.ПланыВидовХарактеристик.CMS1C_СвойстваОбъектов);
	
	
	
	Кнопка = Элементы["ПланВидовХарактеристик_"+"CMS1C_АттрибутыОбъектов"];
	Кнопка.Видимость = МетаданныеТекущейПодсистемы.Состав.Содержит(Метаданные.ПланыВидовХарактеристик.CMS1C_АттрибутыОбъектов);
	
	//2) Соответствия (регистры сведений)
	Для Каждого ТекРегистрСведений из Метаданные.РегистрыСведений Цикл
		Если МетаданныеОсновнойПодсистемы.Состав.Содержит(ТекРегистрСведений)  = Ложь Тогда
			Продолжить;
		КонецЕсли;
		//Если МетаданныеДополнительныеОбъекты.Состав.Содержит(ТекСправочник) = Истина Тогда
		//	Продолжить;
		//КонецЕсли;
		
		Если Найти(ТекРегистрСведений.Имя,"Соответствия")=0
			И Найти(ТекРегистрСведений.Имя,"Принадлежность")=0 Тогда
			Продолжить;
		КонецЕсли;
		
		
		Кнопка = Элементы["РегистрСведений_"+ТекРегистрСведений.Имя];
		Кнопка.Видимость = МетаданныеТекущейПодсистемы.Состав.Содержит(ТекРегистрСведений);
	КонецЦикла;
	
	//3) Служебные обработки
	Для Каждого ТекОбработка из Метаданные.Обработки Цикл
		Если МетаданныеОсновнойПодсистемы.Состав.Содержит(ТекОбработка)  = Ложь Тогда
			Продолжить;
		КонецЕсли;
		
		Если МетаданныеДополнительныеОбъекты.Состав.Содержит(ТекОбработка) = Истина Тогда
			Продолжить;
		КонецЕсли;
		
		Кнопка = Элементы["Обработка"+ТекОбработка.Имя];
		Кнопка.Видимость = МетаданныеТекущейПодсистемы.Состав.Содержит(ТекОбработка);
	КонецЦикла;
	
	
	
КонецПроцедуры

Процедура ЗаполнитьКнопкиИнтерфейса()
	МетаданныеОсновнойПодсистемы = Метаданные.Подсистемы.CMS1C_ОбменССайтами;
	МетаданныеТекущейПодсистемы = МетаданныеОсновнойПодсистемы.Подсистемы["CMS1C_"+СокрЛП(СистемаУправленияСайтом)];
	
	МетаданныеДополнительныеОбъекты = Метаданные.Подсистемы.CMS1C_ОбменССайтами.Подсистемы.CMS1C_ДополнительныеОбъекты;
	
	//1) Справочники + ПВХ
	Для Каждого ТекСправочник из Метаданные.Справочники Цикл
		Если МетаданныеОсновнойПодсистемы.Состав.Содержит(ТекСправочник)  = Ложь Тогда
			Продолжить;
		КонецЕсли;
		
		Если МетаданныеДополнительныеОбъекты.Состав.Содержит(ТекСправочник) = Истина Тогда
			Продолжить;
		КонецЕсли;
		
		Кнопка = Элементы.Добавить("Справочник_"+ТекСправочник.Имя,ТИп("КнопкаФормы"),Элементы.СтраницаСправочники);
		Кнопка.Заголовок = СтрЗаменить(ТекСправочник.Синоним,"(cms1c.ru) ","");
		
		
		НоваяКоманда = ЭтаФОрма.Команды.Добавить("Справочник_"+ТекСправочник.Имя);
		НоваяКоманда.Действие = "Справочник";
		Кнопка.ИмяКоманды = НоваяКоманда.Имя;
	КонецЦикла;
	
	Кнопка = Элементы.Добавить("ПланВидовХарактеристик_"+"CMS1C_СвойстваОбъектов",ТИп("КнопкаФормы"),Элементы.СтраницаСправочники);
	Кнопка.Заголовок = "Свойства объектов";
	НоваяКоманда = ЭтаФОрма.Команды.Добавить("ПланВидовХарактеристик_"+"CMS1C_СвойстваОбъектов");
	НоваяКоманда.Действие = "ПланВидовХарактеристик";
	Кнопка.ИмяКоманды = НоваяКоманда.Имя;
	
	Кнопка = Элементы.Добавить("ПланВидовХарактеристик_"+"CMS1C_АттрибутыОбъектов",ТИп("КнопкаФормы"),Элементы.СтраницаСправочники);
	Кнопка.Заголовок = "Аттрибуты объектов";
	НоваяКоманда = ЭтаФОрма.Команды.Добавить("ПланВидовХарактеристик_"+"CMS1C_АттрибутыОбъектов");
	НоваяКоманда.Действие = "ПланВидовХарактеристик";
	Кнопка.ИмяКоманды = НоваяКоманда.Имя;
	
	//2) Соответствия (регистры сведений)
	Для Каждого ТекРегистрСведений из Метаданные.РегистрыСведений Цикл
		Если МетаданныеОсновнойПодсистемы.Состав.Содержит(ТекРегистрСведений)  = Ложь Тогда
			Продолжить;
		КонецЕсли;
		//Если МетаданныеДополнительныеОбъекты.Состав.Содержит(ТекСправочник) = Истина Тогда
		//	Продолжить;
		//КонецЕсли;
		
		Если Найти(ТекРегистрСведений.Имя,"Соответствия")=0
			И Найти(ТекРегистрСведений.Имя,"Принадлежность")=0 Тогда
			Продолжить;
		КонецЕсли;
		
		
		Кнопка = Элементы.Добавить("РегистрСведений_"+ТекРегистрСведений.Имя,ТИп("КнопкаФормы"),Элементы.СтраницаСоответствия);
		Кнопка.Заголовок = СтрЗаменить(ТекРегистрСведений.Синоним,"(cms1c.ru) ","");
		
		
		НоваяКоманда = ЭтаФОрма.Команды.Добавить("РегистрСведений_"+ТекРегистрСведений.Имя);
		НоваяКоманда.Действие = "РегистрСведений";
		Кнопка.ИмяКоманды = НоваяКоманда.Имя;
	КонецЦикла;
	//3) Служебные обработки
	Для Каждого ТекОбработка из Метаданные.Обработки Цикл
		Если МетаданныеОсновнойПодсистемы.Состав.Содержит(ТекОбработка)  = Ложь Тогда
			Продолжить;
		КонецЕсли;
		
		Если МетаданныеДополнительныеОбъекты.Состав.Содержит(ТекОбработка) = Истина Тогда
			Продолжить;
		КонецЕсли;
		
		Кнопка = Элементы.Добавить("Обработка"+ТекОбработка.Имя,ТИп("КнопкаФормы"),Элементы.СтраницаСлужебныеОбработки);
		Кнопка.Заголовок = СтрЗаменить(ТекОбработка.Синоним,"(cms1c.ru) ","");
		
		
		НоваяКоманда = ЭтаФОрма.Команды.Добавить("Обработка_"+ТекОбработка.Имя);
		НоваяКоманда.Действие = "Обработка";
		Кнопка.ИмяКоманды = НоваяКоманда.Имя;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПланВидовХарактеристик(Команда)
	ТекИмя = Команда.Имя;
	ИмяСправочника = стрЗаменить(ТекИмя,"ПланВидовХарактеристик_","");
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("НастройкаСайта",НастройкаСайта);
	СтруктураПараметров.Вставить("СистемаУправленияСайтом",СистемаУправленияСайтом);
	
	Ф =ПолучитьФорму("ПланВидовХарактеристик."+ИмяСправочника+".ФормаСписка",СтруктураПараметров);
	
	НазваниеЛевогоЗначения = ПолучитьНазваниеЛевогоЗначения("ПланыВидовХарактеристик",ИмяСправочника);
	
	Если НазваниеЛевогоЗначения <> Неопределено И ЗначениеЗаполнено(СистемаУправленияСайтом) Тогда
		Нашли = Ложь;
		ТекПоле = Новый ПолеКомпоновкиДанных(НазваниеЛевогоЗначения+".СистемаУправленияСайтом");
		Для Каждого СтрТз из ф.Список.отбор.Элементы Цикл
			Если СтрТз.ЛевоеЗначение = ТекПоле Тогда
				ДобСтр = СтрТз;
				Нашли = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ Нашли Тогда		
			ДобСтр = Ф.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Конецесли;
		
		ДобСтр.ЛевоеЗначение = ТекПоле;
		ДобСтр.ПравоеЗначение = СистемаУправленияСайтом;
		ДобСтр.ИСпользование = Истина;
	КонецЕсли;
	
	Если НазваниеЛевогоЗначения <> Неопределено И ЗначениеЗаполнено(НастройкаСайта) Тогда
		Нашли = Ложь;
		ТекПоле = Новый ПолеКомпоновкиДанных(НазваниеЛевогоЗначения);
		
		Для Каждого СтрТз из ф.Список.отбор.Элементы Цикл
			Если СтрТз.ЛевоеЗначение = ТекПоле Тогда
				ДобСтр = СтрТз;
				Нашли = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ Нашли Тогда
			ДобСтр = Ф.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		КонецЕсли;
		
		ДобСтр.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(НазваниеЛевогоЗначения);
		ДобСтр.ПравоеЗначение = НастройкаСайта;
		ДобСтр.ИСпользование = Истина;
	КонецЕсли;
	
	Ф.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура Обработка(Команда)
	ТекИмя = Команда.Имя;
	ИмяСправочника = стрЗаменить(ТекИмя,"Обработка_","");
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("НастройкаСайта",НастройкаСайта);
	ОткрытьФорму("Обработка."+ИмяСправочника+".Форма",СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура СистемаУправленияСайтомПриИзменении(Элемент)
	ОбновитьВидимостьКнопокИнтерфейса();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьВидимостьКнопокИнтерфейса();
КонецПроцедуры
