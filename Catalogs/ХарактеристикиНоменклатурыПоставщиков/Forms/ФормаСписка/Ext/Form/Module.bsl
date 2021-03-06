﻿
&НаСервереБезКонтекста
Функция ПолучитьМассивКонтрагентовДляТехнолога()
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивКонтрагентов = Новый Массив;
	
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	Если НЕ ЗначениеЗаполнено(ТекПользователь) Тогда Возврат МассивКонтрагентов; КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗначенияСвойствОбъектов.Значение КАК Контрагент
		|ИЗ
		|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|			,
		|			ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
		|				И Объект ССЫЛКА Справочник.ХарактеристикиНоменклатуры) КАК СоответствиеОбъектРольСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО (ЗначенияСвойствОбъектов.Объект = СоответствиеОбъектРольСрезПоследних.Объект)
		|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|			ПО РолиПользователейСоставРоли.Сотрудник = Пользователи.ФизЛицо
		|		ПО СоответствиеОбъектРольСрезПоследних.РольПользователя = РолиПользователейСоставРоли.Ссылка
		|ГДЕ
		|	НЕ СоответствиеОбъектРольСрезПоследних.РольПользователя = ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка)
		|	И Пользователи.Ссылка = &ТекПользователь
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоответствиеОбъектРольСрезПоследних.Объект
		|ИЗ
		|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|			,
		|			ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
		|				И Объект ССЫЛКА Справочник.Контрагенты) КАК СоответствиеОбъектРольСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|			ПО РолиПользователейСоставРоли.Сотрудник = Пользователи.ФизЛицо
		|		ПО СоответствиеОбъектРольСрезПоследних.РольПользователя = РолиПользователейСоставРоли.Ссылка
		|ГДЕ
		|	НЕ СоответствиеОбъектРольСрезПоследних.РольПользователя = ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка)
		|	И Пользователи.Ссылка = &ТекПользователь");
	Запрос.УстановитьПараметр("ТекПользователь", ТекПользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		МассивКонтрагентов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Контрагент");
	КонецЕсли;
	
	Возврат МассивКонтрагентов;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаполнитьСтруктурныеЕдиницыСклады()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Склады.Владелец КАК СтруктурнаяЕдиница,
		|	Склады.Ссылка КАК Склад
		|ИЗ
		|	Справочник.Склады КАК Склады
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|		ПО Склады.Владелец = СтруктурныеЕдиницы.Ссылка
		|ГДЕ
		|	НЕ Склады.ПометкаУдаления
		|	И Склады.ВидСклада = ЗНАЧЕНИЕ(Перечисление.ВидыСкладов.Оптовый)
		|	И НЕ СтруктурныеЕдиницы.ПометкаУдаления
		|	И НЕ Склады.ЭтоСкладРеклМатериалов
		|	И СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Склад)");
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьНаИсправление(ТекущийПоставщик)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ХарактеристикиНоменклатурыПоставщиков.Ссылка
		|ИЗ
		|	Справочник.ХарактеристикиНоменклатурыПоставщиков КАК ХарактеристикиНоменклатурыПоставщиков
		|ГДЕ
		|	ХарактеристикиНоменклатурыПоставщиков.Поставщик = &Поставщик
		|	И ХарактеристикиНоменклатурыПоставщиков.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыКарточекТовараПоставщиков.НаИсправление)");
	Запрос.УстановитьПараметр("Поставщик", ТекущийПоставщик);
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	ТекущийПоставщик = ПараметрыСеанса.ТекущийКонтрагент;
	ЭтоПоставщик = ЗначениеЗаполнено(ТекущийПоставщик);
	
	Элементы.Поставщик.Видимость = НЕ ЭтоПоставщик;
	
	Если ЭтоПоставщик Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьНедоступныйЭлементОтбора(Список.Отбор, "Поставщик", ТекущийПоставщик);
		
		// если есть элементы в статусе "На исправление", отображаем картинку с восклицательным знаком
		Элементы.ГруппаНаИсправление.Картинка = ?(ЕстьНаИсправление(ТекущийПоставщик), Новый Картинка, БиблиотекаКартинок.Важно);
	Иначе
		
		ЭтоПолныеПрава = РольДоступна("ПолныеПрава");
		Если НЕ ЭтоПолныеПрава Тогда
			
			ЭтоАналитик = Справочники.ХарактеристикиНоменклатурыПоставщиков.ЭтоАналитик();
			Если НЕ ЭтоАналитик Тогда
				
				ЭтоУЕК = Справочники.ХарактеристикиНоменклатурыПоставщиков.ЭтоУЕК();
				Если НЕ ЭтоУЕК Тогда
					
					ЭтоТехнолог = Справочники.ХарактеристикиНоменклатурыПоставщиков.ЭтоТехнолог();
					Если ЭтоТехнолог Тогда
						ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
						ТекФизЛицо = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекПользователь, "ФизЛицо");
						ОбщегоНазначенияКлиентСервер.УстановитьНедоступныйЭлементОтбора(Список.Отбор, "Технолог", ТекФизЛицо);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоАналитик ИЛИ ЭтоПолныеПрава Тогда
		ТЗнСтруктурныеЕдиницыСклады = ЗаполнитьСтруктурныеЕдиницыСклады();
		ЗначениеВРеквизитФормы(ТЗнСтруктурныеЕдиницыСклады, "СтруктурныеЕдиницыСклады");
		ТЗнСтруктурныеЕдиницыСклады.Свернуть("СтруктурнаяЕдиница");
		СтруктурныеЕдиницы.ЗагрузитьЗначения(ТЗнСтруктурныеЕдиницыСклады.ВыгрузитьКолонку("СтруктурнаяЕдиница"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ГруппаСтраницыПриСменеСтраницы(Элементы.ГруппаСтраницы, Элементы.ГруппаВРаботе);
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ТекСтатусСтр = СтрЗаменить(ТекущаяСтраница.Имя, "Группа", "");
	
	// при смене страницы устанавливаем отбор по статусу карточки товара поставщика
	ОбщегоНазначенияКлиентСервер.УстановитьНедоступныйЭлементОтбора(Список.Отбор, "Статус", ПредопределенноеЗначение("Перечисление.СтатусыКарточекТовараПоставщиков." + ТекСтатусСтр));
	
	НуженРежимВыбора = ((ЭтоАналитик ИЛИ ЭтоПолныеПрава) И ТекСтатусСтр = "ПрошлаПроверку");
	Элементы.КнопкаСоздатьНоменклатуруХарактеристики.Видимость = НуженРежимВыбора;
	Элементы.НадписьРежимаВыбора.Видимость = НуженРежимВыбора;
	Элементы.ГруппаМестаХранения.Видимость = НуженРежимВыбора;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьХарактеристикиНоменклатурыНаСервере()
	
	ТЗнМестаХранения = РеквизитФормыВЗначение("МестаХранения");
	
	МассивСсылок = Элементы.Список.ВыделенныеСтроки;
	МассивСсылокДляСнятияПометки = Новый Массив;
	
	Для Каждого ТекСсылка Из МассивСсылок Цикл
		
		//Попытка
			
			МассивСтрокДляОтбора = ТЗнМестаХранения.НайтиСтроки(Новый Структура("Ссылка", ТекСсылка));
			Если МассивСтрокДляОтбора.Количество() = 0 Тогда
				Сообщить("'" + ТекСсылка + "': не выбраны места хранения, пропускаем");
				Продолжить;
			КонецЕсли;
			
			Справочники.ХарактеристикиНоменклатурыПоставщиков.СоздатьТоварХарактеристикуНоменклатуры(ТекСсылка, МассивСтрокДляОтбора);
			
			// удаляем все ссылки на места хранения
			Для Каждого СтрокаТЧ Из МассивСтрокДляОтбора Цикл
				ТЗнМестаХранения.Удалить(СтрокаТЧ);
			КонецЦикла;
			МассивСсылокДляСнятияПометки.Добавить(ТекСсылка);
			
		//Исключение
		//	Сообщить("'" + ТекСсылка + "': " + ОписаниеОшибки());
		//КонецПопытки;
		
	КонецЦикла;
	
	Для Каждого ТекСсылка Из МассивСсылокДляСнятияПометки Цикл
		МассивСсылок.Удалить(МассивСсылок.Найти(ТекСсылка));
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТЗнМестаХранения, "МестаХранения");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНоменклатуруХарактеристики(Команда)
	СоздатьХарактеристикиНоменклатурыНаСервере();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура СтруктурныеЕдиницыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	ТекСсылка = ТекущиеДанные.Ссылка;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	// заполняем складами по тек. структ. единице
	Склады.Очистить();
	
	СтруктураОтбора = Новый Структура("СтруктурнаяЕдиница", ТекущиеДанные.Значение);
	МассивСтрокДляОтбора = СтруктурныеЕдиницыСклады.НайтиСтроки(СтруктураОтбора);
	СтруктураОтбора.Вставить("Ссылка", ТекСсылка);
	
	Для Каждого СтрокаОтбора Из МассивСтрокДляОтбора Цикл
		НоваяСтрокаСписка = Склады.Добавить();
		НоваяСтрокаСписка.Значение = СтрокаОтбора.Склад;
		СтруктураОтбора.Вставить("Склад", СтрокаОтбора.Склад);
		НоваяСтрокаСписка.Пометка = (МестаХранения.НайтиСтроки(СтруктураОтбора).Количество() > 0);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элементы.ГруппаМестаХранения.Видимость Тогда Возврат; КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	// устанавливаем пометки по выбранным структ. единицам
	Склады.ЗаполнитьПометки(Ложь);
	СтруктурныеЕдиницы.ЗаполнитьПометки(Ложь);
	
	ТекСсылка = ТекущиеДанные.Ссылка;
	МассивСтрокДляОтбора = МестаХранения.НайтиСтроки(Новый Структура("Ссылка", ТекСсылка));
	Для Каждого СтрокаОтбора Из МассивСтрокДляОтбора Цикл
		ТекСкладЭлементСписка = Склады.НайтиПоЗначению(СтрокаОтбора.Склад);
		Если ТекСкладЭлементСписка <> Неопределено Тогда ТекСкладЭлементСписка.Пометка = Истина; КонецЕсли;
		СтруктурныеЕдиницы.НайтиПоЗначению(СтрокаОтбора.СтруктурнаяЕдиница).Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СкладыПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	ТекСсылка = ТекущиеДанные.Ссылка;
	
	// добавляем или удаляем строку в ТЗн МестаХранения
	ТекущиеДанные = Элементы.Склады.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	ТекущиеДанныеСтруктурныеЕдиницы = Элементы.СтруктурныеЕдиницы.ТекущиеДанные;
	Если ТекущиеДанныеСтруктурныеЕдиницы = Неопределено Тогда Возврат; КонецЕсли;
	
	СтруктураДанных = Новый Структура("Ссылка,Склад,СтруктурнаяЕдиница", ТекСсылка, ТекущиеДанные.Значение, ТекущиеДанныеСтруктурныеЕдиницы.Значение);
	Если ТекущиеДанные.Пометка Тогда
		
		НоваяСтрокаТЧ = МестаХранения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧ, СтруктураДанных);
		//ТекущиеДанныеСтруктурныеЕдиницы.Пометка = Истина;
		СтруктурныеЕдиницы.НайтиПоЗначению(СтруктураДанных.СтруктурнаяЕдиница).Пометка = Истина;
		
	Иначе
		
		МассивСтрокДляУдаления = МестаХранения.НайтиСтроки(СтруктураДанных);
		Для Каждого СтрокаТЧ Из МассивСтрокДляУдаления Цикл
			МестаХранения.Удалить(СтрокаТЧ);
		КонецЦикла;
		
		// если пометок на других складах нет, снимаем пометку со структ. единицы
		СтруктураДанных.Удалить("Склад");
		СтруктурныеЕдиницы.НайтиПоЗначению(СтруктураДанных.СтруктурнаяЕдиница).Пометка = (МестаХранения.НайтиСтроки(СтруктураДанных).Количество() > 0);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	// если есть элементы в статусе "На исправление", отображаем картинку с восклицательным знаком
	Элементы.ГруппаНаИсправление.Картинка = ?(ЕстьНаИсправление(ТекущийПоставщик), Новый Картинка, БиблиотекаКартинок.Важно);
КонецПроцедуры
