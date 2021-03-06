﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦФОСтруктурныхЕдиницСрезПоследних.ЦФО
		|ИЗ
		|	РегистрСведений.ЦФОСтруктурныхЕдиниц.СрезПоследних КАК ЦФОСтруктурныхЕдиницСрезПоследних
		|
		|СГРУППИРОВАТЬ ПО
		|	ЦФОСтруктурныхЕдиницСрезПоследних.ЦФО
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Сп=Новый СписокЗначений;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сп.Добавить(ВыборкаДетальныеЗаписи.ЦФО);
	КонецЦикла;

	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Ссылка");   
    ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
    ЭлементОтбора.Использование  = Истина;
    ЭлементОтбора.ПравоеЗначение = Сп;
КонецПроцедуры
