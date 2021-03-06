﻿
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	СотрудникПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Запись.Сотрудник) Тогда
		
		Запись.ЭлектронныйАдрес = "";
		 
		Запрос = Новый Запрос;
		Запрос.Текст = 
		
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КонтактнаяИнформация.Объект,
		|	КонтактнаяИнформация.Тип,
		|	КонтактнаяИнформация.Вид,
		|	КонтактнаяИнформация.Представление КАК EmailАдрес,
		|	Пользователи.Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|		ПО (КонтактнаяИнформация.Объект = Пользователи.ФизЛицо)
		|ГДЕ
		|	КонтактнаяИнформация.Тип = &Тип
		|	И КонтактнаяИнформация.Вид = &Вид
		|	И Пользователи.Ссылка = &Сотрудник
		|	И Пользователи.ФизЛицо <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)";
		
		Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.EmailФизЛица);
		Запрос.УстановитьПараметр("Сотрудник", Запись.Сотрудник);
		Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Запись.ЭлектронныйАдрес = СокрЛП(ВыборкаДетальныеЗаписи.EmailАдрес);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


