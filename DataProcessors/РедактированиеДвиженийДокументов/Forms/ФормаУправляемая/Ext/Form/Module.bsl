﻿&НаКлиенте
Перем ПредТип;

&НаКлиенте
Процедура ДокументПриИзменении(Элемент)
	Если ПредТип = ТипЗнч(Объект.Документ) Тогда
		ОбновитьДв();
		ОбновитьПос();
		Возврат
	КонецЕсли;
	Элементы.Регистр.СписокВыбора.Очистить();
	Если Не Объект.Документ = Неопределено Тогда
		ПолучитьСписокДвижений();
	КонецЕсли;	
	
	ПредТип = ТипЗнч(Объект.Документ);
	ОбновитьДв();
	ОбновитьПос();
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокДвижений()
	Для Каждого Дв ИЗ Объект.Документ.Метаданные().Движения Цикл
		Элементы.Регистр.СписокВыбора.Добавить(""+Дв.Имя);
	КонецЦикла;
	Элементы.Регистр.СписокВыбора.СортироватьПоЗначению();
	
	Для Каждого Дв ИЗ Метаданные.Последовательности Цикл
		Если Дв.Документы.Содержит(Объект.Документ.Метаданные()) Тогда
			Элементы.Последовательность.СписокВыбора.Добавить(""+Дв.Имя);
		КонецЕсли;
	КонецЦикла;
	Элементы.Последовательность.СписокВыбора.СортироватьПоЗначению();
КонецПроцедуры


&НаСервере
Процедура СоздатьСтруктуруТаблиц(ТаблицаЭлемент,ТекДв,ДобавленныеЭлементы,ДобавленныеРеквизиты)
	Для Каждого ДобавленныйЭлемент Из ДобавленныеЭлементы Цикл
		Элементы.Удалить(Элементы[ДобавленныйЭлемент.Значение]);
	КонецЦикла;
	ДобавленныеЭлементы.Очистить();
	
	//добавляем реквизиты
	МассивРеквизитов = Новый Массив;
	Для Каждого Колонка Из ТекДв.Колонки Цикл
		
		ТипКолонки = Строка(Колонка.ТипЗначения);
		Если Колонка.Имя = "МоментВремени" ИЛИ Колонка.Имя = "Представление" ИЛИ Найти(ТипКолонки, "Хранилище значения") > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		РеквизитФормы = Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, ТаблицаЭлемент.Имя);
		МассивРеквизитов.Добавить(РеквизитФормы);
	КонецЦикла;
	ИзменитьРеквизиты(МассивРеквизитов, ДобавленныеРеквизиты.ВыгрузитьЗначения());
	ДобавленныеРеквизиты.Очистить();
	//добавляем элементы управления
	Для Каждого Реквизит Из МассивРеквизитов Цикл
		ДобавленныеРеквизиты.Добавить(Реквизит.Путь + "." + Реквизит.Имя);
		
		Элемент = Элементы.Добавить(ТаблицаЭлемент.Имя + Реквизит.Имя, Тип("ПолеФормы"), ТаблицаЭлемент);
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = ТаблицаЭлемент.Имя + "." + Реквизит.Имя;
		
		ДобавленныеЭлементы.Добавить(Элемент.Имя);
	КонецЦикла;
	
	РедТЗ = РеквизитФормыВЗначение(ТаблицаЭлемент.Имя);
	РедТЗ.Очистить();
	Для Каждого Стр ИЗ ТекДв Цикл
		НовСтр = РедТЗ.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Стр);
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(РедТЗ, ТаблицаЭлемент.Имя);
КонецПроцедуры
	
&НаСервере
Процедура ОбновитьДв()
	Если ЗначениеЗаполнено(Объект.Документ) Тогда
		Если ЗначениеЗаполнено(Объект.Регистр) тогда 
			
			ТаблицаЭлемент = Элементы.Движения;
			ТекДвижения = Объект.Документ.ПолучитьОбъект().Движения[Объект.Регистр];
			ТекДвижения.Прочитать();
			ТекДв = ТекДвижения.Выгрузить();
			СоздатьСтруктуруТаблиц(ТаблицаЭлемент,ТекДв,ДобавленныеЭлементыРег,ДобавленныеРеквизитыРег);
		КонецЕсли;	
	Иначе
		ТаблицаЭлемент = Элементы.Движения;
		РедТЗ = РеквизитФормыВЗначение(ТаблицаЭлемент.Имя);
		РедТЗ.Очистить();
		ЗначениеВРеквизитФормы(РедТЗ, ТаблицаЭлемент.Имя);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьПос()
	Если ЗначениеЗаполнено(Объект.Документ) Тогда
		Если ЗначениеЗаполнено(Объект.Регистр) тогда 
			
			ТаблицаЭлемент = Элементы.НЗПоследовательности;
			НЗПосл = Последовательности[Объект.Последовательность].СоздатьНаборЗаписей();
			НЗПосл.Отбор.Регистратор.Установить(Объект.Документ);
			НЗПосл.Прочитать();
			ТекДв = НЗПосл.Выгрузить();
			СоздатьСтруктуруТаблиц(ТаблицаЭлемент,ТекДв,ДобавленныеЭлементыПос,ДобавленныеРеквизитыПос);
		КонецЕсли;	
	Иначе
		ТаблицаЭлемент = Элементы.НЗПоследовательности;
		РедТЗ = РеквизитФормыВЗначение(ТаблицаЭлемент.Имя);
		РедТЗ.Очистить();
		ЗначениеВРеквизитФормы(РедТЗ, ТаблицаЭлемент.Имя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РегистрПриИзменении(Элемент)
	ОбновитьДв();
КонецПроцедуры

&НаКлиенте
Процедура ПоследовательностьПриИзменении(Элемент)
	ОбновитьПос();
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	Если ЗначениеЗаполнено(Объект.Документ) Тогда
		Попытка 
			Если Элементы.Страницы.ТекущаяСтраница = 
				Элементы.Регистры Тогда
				ТекДв = Объект.Документ.ПолучитьОбъект().Движения[Объект.Регистр];
				ТекДв.Загрузить(РеквизитФормыВЗначение("Движения"));
				ТекДв.Записать();
			ИначеЕсли Элементы.Страницы.ТекущаяСтраница = 
				Элементы.Последовательности Тогда
				НЗПосл = Последовательности[Объект.Последовательность].СоздатьНаборЗаписей();
				НЗПосл.Отбор.Регистратор.Установить(Объект.Документ);
				НЗПосл.Загрузить(РеквизитФормыВЗначение("НЗПоследовательности"));
				НЗПосл.Записать();
			КонецЕсли;
		Исключение
				
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

