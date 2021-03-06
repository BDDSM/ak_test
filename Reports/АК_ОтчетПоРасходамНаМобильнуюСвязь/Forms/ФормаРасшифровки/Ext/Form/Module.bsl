﻿Процедура СформироватьТабличныйДокумент(ПараметрыЗапроса)
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходыНаМобильнуюСвязьОбороты.СимКарта КАК СимКарта,
		|	РасходыНаМобильнуюСвязьОбороты.Оператор,
		|	РасходыНаМобильнуюСвязьОбороты.ПериодМесяц КАК ПериодМесяц,
		|	ВЫБОР
		|		КОГДА ПривязкаТелефоновСрезПоследних.Номер ЕСТЬ NULL
		|			ТОГДА ""Неопределено""
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ПривязкаТелефоновСрезПоследних.Привязка ЕСТЬ NULL
		|					ТОГДА ""Привязка не установлена""
		|				ИНАЧЕ ПривязкаТелефоновСрезПоследних.Привязка
		|			КОНЕЦ
		|	КОНЕЦ КАК Привязка,
		|	ВЫБОР
		|		КОГДА ПривязкаТелефоновСрезПоследних.Номер ЕСТЬ NULL
		|			ТОГДА ""Сим-карта не зарегистрирована""
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ПривязкаТелефоновСрезПоследних.Назначение ЕСТЬ NULL
		|					ТОГДА ""Назначение не указано""
		|				ИНАЧЕ ПривязкаТелефоновСрезПоследних.Назначение
		|			КОНЕЦ
		|	КОНЕЦ КАК Назначение,
		|	РасходыНаМобильнуюСвязьОбороты.АбонентскаяПлатаОборот КАК АбонентскаяПлата,
		|	РасходыНаМобильнуюСвязьОбороты.МобильнаяСвязьОборот КАК МобильнаяСвязь,
		|	РасходыНаМобильнуюСвязьОбороты.SMSMMSОборот КАК SMSMMS,
		|	РасходыНаМобильнуюСвязьОбороты.ИнтернетОборот КАК Интернет,
		|	РасходыНаМобильнуюСвязьОбороты.РоумингОборот КАК Роуминг,
		|	РасходыНаМобильнуюСвязьОбороты.ДополнительныеУслугиОборот КАК ДополнительныеУслуги,
		|	РасходыНаМобильнуюСвязьОбороты.СкидкаОборот КАК Скидка,
		|	РасходыНаМобильнуюСвязьОбороты.АбонентскаяПлатаОборот + РасходыНаМобильнуюСвязьОбороты.МобильнаяСвязьОборот + РасходыНаМобильнуюСвязьОбороты.SMSMMSОборот + РасходыНаМобильнуюСвязьОбороты.ИнтернетОборот + РасходыНаМобильнуюСвязьОбороты.РоумингОборот + РасходыНаМобильнуюСвязьОбороты.ДополнительныеУслугиОборот - РасходыНаМобильнуюСвязьОбороты.СкидкаОборот КАК Итого,
		|	ЛОЖЬ КАК СопоставленаПриФормировании,
		|	ИСТИНА КАК Сопоставлена
		|ПОМЕСТИТЬ втРезультат
		|ИЗ
		|	РегистрНакопления.РасходыНаМобильнуюСвязь.Обороты(&ДатаНачала, &ДатаОкончания, Авто, СимКарта ССЫЛКА Справочник.СлужебныеSIMКарты) КАК РасходыНаМобильнуюСвязьОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПривязкаТелефонов.СрезПоследних(&ДатаОкончания, ) КАК ПривязкаТелефоновСрезПоследних
		|		ПО РасходыНаМобильнуюСвязьОбороты.СимКарта = ПривязкаТелефоновСрезПоследних.Номер
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ПривязкаПоКоду.Ссылка, РасходыНаМобильнуюСвязьОбороты.СимКарта),
		|	РасходыНаМобильнуюСвязьОбороты.Оператор,
		|	РасходыНаМобильнуюСвязьОбороты.ПериодМесяц,
		|	ВЫБОР
		|		КОГДА ПривязкаПоКоду.Ссылка ЕСТЬ NULL
		|			ТОГДА ""Неопределено""
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ПривязкаПоКоду.Привязка ЕСТЬ NULL
		|					ТОГДА ""Привязка не установлена""
		|				ИНАЧЕ ПривязкаПоКоду.Привязка
		|			КОНЕЦ
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ПривязкаПоКоду.Ссылка ЕСТЬ NULL
		|			ТОГДА ""Сим-карта не зарегистрирована""
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ПривязкаПоКоду.Назначение ЕСТЬ NULL
		|					ТОГДА ""Назначение не указано""
		|				ИНАЧЕ ПривязкаПоКоду.Назначение
		|			КОНЕЦ
		|	КОНЕЦ,
		|	РасходыНаМобильнуюСвязьОбороты.АбонентскаяПлатаОборот,
		|	РасходыНаМобильнуюСвязьОбороты.МобильнаяСвязьОборот,
		|	РасходыНаМобильнуюСвязьОбороты.SMSMMSОборот,
		|	РасходыНаМобильнуюСвязьОбороты.ИнтернетОборот,
		|	РасходыНаМобильнуюСвязьОбороты.РоумингОборот,
		|	РасходыНаМобильнуюСвязьОбороты.ДополнительныеУслугиОборот,
		|	РасходыНаМобильнуюСвязьОбороты.СкидкаОборот,
		|	РасходыНаМобильнуюСвязьОбороты.АбонентскаяПлатаОборот + РасходыНаМобильнуюСвязьОбороты.МобильнаяСвязьОборот + РасходыНаМобильнуюСвязьОбороты.SMSMMSОборот + РасходыНаМобильнуюСвязьОбороты.ИнтернетОборот + РасходыНаМобильнуюСвязьОбороты.РоумингОборот + РасходыНаМобильнуюСвязьОбороты.ДополнительныеУслугиОборот - РасходыНаМобильнуюСвязьОбороты.СкидкаОборот,
		|	ВЫБОР
		|		КОГДА ПривязкаПоКоду.Ссылка ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ,
		|	ЛОЖЬ
		|ИЗ
		|	РегистрНакопления.РасходыНаМобильнуюСвязь.Обороты(&ДатаНачала, &ДатаОкончания, Авто, НЕ СимКарта ССЫЛКА Справочник.СлужебныеSIMКарты) КАК РасходыНаМобильнуюСвязьОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			СлужебныеSIMКарты.Ссылка КАК Ссылка,
		|			СлужебныеSIMКарты.Код КАК Код11,
		|			ПОДСТРОКА(СлужебныеSIMКарты.Код, 2, 10) КАК Код10,
		|			ПривязкаТелефоновСрезПоследних.Привязка КАК Привязка,
		|			ПривязкаТелефоновСрезПоследних.Назначение КАК Назначение
		|		ИЗ
		|			Справочник.СлужебныеSIMКарты КАК СлужебныеSIMКарты
		|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПривязкаТелефонов.СрезПоследних(&ДатаОкончания, ) КАК ПривязкаТелефоновСрезПоследних
		|				ПО СлужебныеSIMКарты.Ссылка = ПривязкаТелефоновСрезПоследних.Номер) КАК ПривязкаПоКоду
		|		ПО (РасходыНаМобильнуюСвязьОбороты.СимКарта = ПривязкаПоКоду.Код11
		|				ИЛИ РасходыНаМобильнуюСвязьОбороты.СимКарта = ПривязкаПоКоду.Код10)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втРезультат.СимКарта,
		|	втРезультат.Оператор,
		|	втРезультат.ПериодМесяц,
		|	втРезультат.Привязка,
		|	втРезультат.Назначение,
		|	втРезультат.АбонентскаяПлата,
		|	втРезультат.МобильнаяСвязь,
		|	втРезультат.SMSMMS,
		|	втРезультат.Интернет,
		|	втРезультат.Роуминг,
		|	втРезультат.ДополнительныеУслуги,
		|	втРезультат.Скидка,
		|	втРезультат.Итого,
		|	втРезультат.СопоставленаПриФормировании,
		|	втРезультат.Сопоставлена,
		|	ВЫБОР
		|		КОГДА втРезультат.Привязка ССЫЛКА Справочник.ФизическиеЛица
		|			ТОГДА втРезультат.Привязка
		|		ИНАЧЕ СоставСотрудники.Сотрудник
		|	КОНЕЦ КАК Ответственный
		|ПОМЕСТИТЬ втРезультатСОтветсвенным
		|ИЗ
		|	втРезультат КАК втРезультат
		//+++ AK suvv 2018.06.08 ИП-00018376.01
		//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(&ДатаОкончания, ТипРоли.Код = ""PomoshnikTerrUpravlyushego"") КАК СоответствиеОбъектРольСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(&ДатаОкончания, (ТипРоли.Код = ""PomoshnikTerrUpravlyushego"" или ТипРоли.Код = ""PomoshnikStorRozn"")) КАК СоответствиеОбъектРольСрезПоследних
		//--- AK suvv
		|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|				МАКСИМУМ(РолиПользователейСоставРоли.Сотрудник) КАК Сотрудник,
		|				РолиПользователей.Ссылка КАК Ссылка
		|			ИЗ
		|				Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|					ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей КАК РолиПользователей
		|					ПО РолиПользователейСоставРоли.Ссылка = РолиПользователей.Ссылка
		|			
		|			СГРУППИРОВАТЬ ПО
		|				РолиПользователей.Ссылка) КАК СоставСотрудники
		|			ПО СоответствиеОбъектРольСрезПоследних.РольПользователя = СоставСотрудники.Ссылка
		|		ПО втРезультат.Привязка = СоответствиеОбъектРольСрезПоследних.Объект
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втРезультатСОтветсвенным.СимКарта,
		|	втРезультатСОтветсвенным.Оператор,
		|	втРезультатСОтветсвенным.ПериодМесяц,
		|	втРезультатСОтветсвенным.Привязка,
		|	втРезультатСОтветсвенным.Назначение,
		|	втРезультатСОтветсвенным.АбонентскаяПлата,
		|	втРезультатСОтветсвенным.МобильнаяСвязь,
		|	втРезультатСОтветсвенным.SMSMMS,
		|	втРезультатСОтветсвенным.Интернет,
		|	втРезультатСОтветсвенным.Роуминг,
		|	втРезультатСОтветсвенным.ДополнительныеУслуги,
		|	втРезультатСОтветсвенным.Скидка,
		|	втРезультатСОтветсвенным.Итого,
		|	втРезультатСОтветсвенным.СопоставленаПриФормировании,
		|	втРезультатСОтветсвенным.Сопоставлена,
		|	втРезультатСОтветсвенным.Ответственный
		|ИЗ
		|	втРезультатСОтветсвенным КАК втРезультатСОтветсвенным
		|ГДЕ
		|	втРезультатСОтветсвенным.СимКарта В(&СимКарты)";
	
	Запрос.УстановитьПараметр("ДатаНачала", ПараметрыЗапроса.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПараметрыЗапроса.ДатаОкончания);
	Если ЗначениеЗаполнено(ПараметрыЗапроса.Ответственный) Тогда
		Запрос.Текст = Запрос.Текст +  " И втРезультатСОтветсвенным.Ответственный = &Ответственный";
		Запрос.УстановитьПараметр("Ответственный", ПараметрыЗапроса.Ответственный);
	КонецЕсли;	
	Запрос.УстановитьПараметр("СимКарты", ПараметрыЗапроса.СимКарты);
	
	 
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Расшифровка.Загрузить(РезультатЗапроса);
	Итого = РезультатЗапроса.Итог("Итого");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПараметрыЗапроса = Новый Структура("ДатаНачала,ДатаОкончания,Ответственный,СимКарты");
	ЗаполнитьЗначенияСвойств(ПараметрыЗапроса,Параметры);
	СформироватьТабличныйДокумент(ПараметрыЗапроса);	
КонецПроцедуры
