﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТТПоАйпи = ПараметрыСеанса.ТорговаяТочкаПоАйпи;
	
	МассивРолейТекПользователя = МеханизмОбменаСообщениямиПовтИсп.ПолучитьРолиПользователяИлиФизЛица(ПараметрыСеанса.ТекущийПользователь);
	
	РолиТекПользователя = Новый СписокЗначений;
	
	ЭтоАдминистратор = Ложь;
	Если МассивРолейТекПользователя <> Неопределено Тогда
		РолиТекПользователя.ЗагрузитьЗначения(МассивРолейТекПользователя);
		Если МассивРолейТекПользователя.Найти(Справочники.РолиПользователей.Администратор) <> Неопределено Тогда
			ЭтоАдминистратор = Истина;
		КонецЕсли;
	КонецЕсли;
	
	//ОснРежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	ОснРежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = Ложь;
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Если ЭтоАдминистратор Тогда
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	Иначе
		ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
	КонецЕсли;

	ГруппаИЛИ1 = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИЛИ1.Использование = Истина;
	ГруппаИЛИ1.РежимОтображения = ОснРежимОтображения;
	ГруппаИЛИ1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ЭлементОтбора = ГруппаИЛИ1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Отправитель");
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = РолиТекПользователя;
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
	
	ГруппаИ1 = ГруппаИЛИ1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИ1.Использование = Истина;
	ГруппаИ1.РежимОтображения = ОснРежимОтображения;
	ГруппаИ1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		
	ЭлементОтбора = ГруппаИ1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Проведен");
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = Истина;
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
		
	ЭлементОтбора = ГруппаИ1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РольПолучателя");
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = РолиТекПользователя;
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
		
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ТТПоАйпи) Тогда
		Отказ = Истина;
		//Форма1 = ПолучитьФорму("Документ.СообщениеМОС.Форма.ФормаСпискаМагазина");
		//Форма1.Открыть();
	КонецЕсли;
	
КонецПроцедуры

