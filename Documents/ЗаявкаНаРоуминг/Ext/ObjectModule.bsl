﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	//+++АК LAGP 2018.06.05 ИП-00018863 Отказ от акцепта в заявках на роуминг.
	//Если ЭтотОбъект.ВыгруженаЗаявкаОператоруСвязи ИЛИ ЭтотОбъект.Статус = Перечисления.СтатусыЗаявокНаРоуминг.Подтвержден Тогда
	//	Отказ = ДопПраваПроведенияПроверить();	
	//КонецЕсли;
	//---АК LAGP
	
	Если НЕ (ЗначениеЗаполнено(ЭтотОбъект.СлужебнаяSIMКарта.ОператорСвязи) ИЛИ РольДоступна("ПолныеПрава")) Тогда
		Сообщить("В номере сотрудника не указан оператор связи!");
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

Функция ДопПраваПроведенияПроверить()
	
	МассивПраваУпрЗаявкамиНаРоуминг	 = УправлениеДопПравамиПользователей.ПрочитатьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.УправлениеЗаявкамиНаРоуминг,Ложь,ПараметрыСеанса.ТекущийПользователь);	
	ПравоУправлениеЗаявкамиНаРоуминг = МассивПраваУпрЗаявкамиНаРоуминг[0];
	
	Если НЕ (ПравоУправлениеЗаявкамиНаРоуминг ИЛИ РольДоступна("ПолныеПрава") ИЛИ ПараметрыСеанса.ТекущийПользователь.ФизЛицо = ЭтотОбъект.РуководительСотрудника) Тогда
		Сообщить("Права на проведение заявки в данном статусе есть только у руководителя и управляющего заявками на роуминг.");
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции	

Функция ОбновитьЛимит()
	
	ТЗЛимит = РегистрыСведений.ЗаявкиНаРоумингЛимиты.СрезПоследних(ЭтотОбъект.Дата,);
	Лимит				= "";
	
	//Перебирает срез регистра от свежих к старым, пока не найдет лимит
	Если ТЗЛимит.Количество() > 0 Тогда
		ТЗЛимит.Сортировать("Период Убыв", Новый СравнениеЗначений);	
		
		Для каждого СтрокаТЗРегистра Из ТЗЛимит Цикл
			Если ЗначениеЗаполнено(Лимит)Тогда
				Прервать;	
			КонецЕсли;	
			
			Если НЕ ЗначениеЗаполнено(Лимит) И ЗначениеЗаполнено(СтрокаТЗРегистра.Лимит) Тогда
				Возврат СтрокаТЗРегистра.Лимит;
			КонецЕсли;					
		КонецЦикла;		
	КонецЕсли;	
	
	Возврат 0;	
	
КонецФункции	

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если НЕ Отказ И НЕ ЭтотОбъект.Ссылка.Пустая() Тогда
		ЭтотОбъект.ЛимитЗаявки = ОбновитьЛимит();
	КонецЕсли;		
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Перечисления.СтатусыЗаявокНаРоуминг.ПустаяСсылка();	
	//+++ AK suvv 24.04.2018 ИП-00018442
	//РуководительСотрудника = Справочники.ФизическиеЛица.ПустаяСсылка(); //+++АК LAGP 2018.06.05 ИП-00018863 Система акцепта упразднена. Руководитель больше не нужен.
	//--- AK suvv
	
КонецПроцедуры