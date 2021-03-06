﻿
&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если (НЕ ЭтаФорма.Имя = ЭтаФорма.ИмяПриОткрытии)
			ИЛИ (НЕ ЭтаФорма.Фамилия = ЭтаФорма.ФамилияПриОткрытии)
			ИЛИ (НЕ ЭтаФорма.Отчество = ЭтаФорма.ОтчествоПриОткрытии)
			ИЛИ (НЕ ЭтаФорма.Период = ЭтаФорма.ПериодПриОткрытии) Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Имя"		, ЭтаФорма.Имя);
		СтруктураПараметров.Вставить("Фамилия"	, ЭтаФорма.Фамилия);
		СтруктураПараметров.Вставить("Отчество"	, ЭтаФорма.Отчество);
		СтруктураПараметров.Вставить("Период"	, ЭтаФорма.Период);
		
		ЭтаФорма.Закрыть(СтруктураПараметров);
	Иначе
		ЭтаФорма.Закрыть(Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.Физлицо 	= ЭтаФорма.Параметры.Физлицо;
	
	ЭтаФорма.Имя 		= ЭтаФорма.Параметры.Имя;
	ЭтаФорма.Фамилия 	= ЭтаФорма.Параметры.Фамилия;
	ЭтаФорма.Отчество 	= ЭтаФорма.Параметры.Отчество;
	ЭтаФорма.Период 	= ЭтаФорма.Параметры.Период;
	ЭтаФорма.ИмяПриОткрытии 		= ЭтаФорма.Параметры.Имя;
	ЭтаФорма.ФамилияПриОткрытии 	= ЭтаФорма.Параметры.Фамилия;
	ЭтаФорма.ОтчествоПриОткрытии 	= ЭтаФорма.Параметры.Отчество;
	ЭтаФорма.ПериодПриОткрытии 		= ЭтаФорма.Параметры.Период;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьИсторию(Команда)
	
	ФормаВыбора = ПолучитьФорму("РегистрСведений.ФИОФизЛиц.Форма.ФормаСписка",, ЭтаФорма);
	
	мОтбор = ФормаВыбора.Отбор.ФизЛицо;
    мОтбор.ВидСравнения 	= ВидСравнения.Равно;
    мОтбор.Использование 	= Истина;
    мОтбор.Значение 		= ЭтаФорма.Физлицо;
	
	ЭФСписок = ФормаВыбора.ЭлементыФормы.РегистрСведенийСписок;
	ЭФСписок.НачальноеОтображениеСписка = НачальноеОтображениеСписка.Конец;
	ЭФСписок.НастройкаОтбора.ФизЛицо.Доступность = Ложь;
	
	ФормаВыбора.Открыть();
	
КонецПроцедуры
