﻿
Перем мДатаУказанавТЧ;

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ДатаПогашения = '00010101000000';
	
	Если ВидКомментария = Справочники.АК_ВидыКомментариев.Долг и НЕ ЗначениеЗаполнено(ДатаЗакрытияПДЗ) тогда
		ТЧ = ГрафикПогашенияПДЗ.Выгрузить();
		Для Каждого Строка из ТЧ цикл
			мДатаУказанавТЧ = ?(ЗначениеЗаполнено(Строка.ДатаПогашения),Истина,Неопределено);
			ДатаПогашения = ?(ДатаПогашения < Строка.ДатаПогашения, Строка.ДатаПогашения,ДатаПогашения); 
		КонецЦикла;	
		Если мДатаУказанавТЧ = Неопределено тогда
			Отказ = Истина;
			Предупреждение("Заполните дату закрытия ПДЗ или график закрытия ПДЗ.");
			возврат;
		Иначе
			ДатаЗакрытияПДЗ = ДатаПогашения;
		КонецЕсли;	
	КонецЕсли;	
	
	
	Движения.АК_КомментарииКДебЗадолженности.Записывать = Истина;
	Движения.АК_КомментарииКДебЗадолженности.Очистить();
	Движение = Движения.АК_КомментарииКДебЗадолженности.Добавить();
	Движение.Период = Дата;
	Движение.Пользователь = Пользователь;
	Движение.Комментарий = Комментарий;
	Движение.ВидКомментария = ВидКомментария;
	Движение.ДатаЗакрытияПДЗ = ДатаЗакрытияПДЗ;
	Движение.Сумма = Сумма;
	Движение.ДокументЗадолженности = ДокументЗадолженности;
	Движение.ПОдтвержденБухгалтером = Перечисления.АК_ВидыПодтверждения.НеПодтвержден;
	Если ВидКомментария = Справочники.АК_ВидыКомментариев.Сверка тогда
		Предупреждение("Статус комментария изменен на ""Не подтвержден""." + Символы.ПС +"Для отображения нового комментария в отчете необходимо переформировать отчет.");
	Иначе
		Движение.ПОдтвержденБухгалтером = Неопределено;
		Предупреждение("Для отображения нового комментария в отчете необходимо переформировать отчет.");
	КонецЕсли;
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	//+++АК sils 19.07.2017 ИП-00015657.07
	//Если ЭтоНовый() тогда
	//	Дата = НачалоДня(ТекущаяДата());
	//КонецЕсли;	
	//---АК
	
	Если РежимЗаписи = РежимЗаписиДокумента.Запись тогда	
		Если Ссылка.ПометкаУдаления = ПометкаУдаления тогда
			Отказ = НЕ ЭтотОбъект.ПроверитьЗаполнение();
			РежимЗаписи = РежимЗаписиДокумента.Проведение;
		КонецЕсли;
	//ИначеЕсли НЕ РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения и НЕ РежимЗаписи = РежимЗаписиДокумента.Проведение тогда 
	//	Отказ = истина;
	КонецЕсли;	
КонецПроцедуры

//Процедура ПроверкаЗаполнения()

//	Если НЕ ЗначениеЗаполнено(ВидКомментария) тогда
//		Сообщить("Значение"
//	КонецЕсли;	

//КонецПроцедуры

