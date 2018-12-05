﻿
Процедура ПриЗаписи(Отказ)
	Если ЭтотОбъект.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;	
	
	Если ЭтотОбъект.ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;	
		
	Если ЭтоНовый() ИЛИ Устарел  Тогда
		Возврат;
	КонецЕсли;	
	ТекстЗапроса="ВЫБРАТЬ ПЕРВЫЕ 1
	             |	ЭкзаменыПродавцовВопросы.Ссылка
	             |ИЗ
	             |	Документ.ЭкзаменыПродавцов.Вопросы КАК ЭкзаменыПродавцовВопросы
	             |ГДЕ
	             |	ЭкзаменыПродавцовВопросы.Вопрос = &Вопрос";
	Запрос=Новый Запрос(ТекстЗапроса);			 
	Запрос.УстановитьПараметр("Вопрос",Ссылка);
	Выборка=Запрос.Выполнить().Выбрать();
	Если Выборка.Количество()>0 Тогда
		Отказ=Истина;
		Сообщить("Вопрос участвует в экзаменах продавцов, его нельзя изменить");
	КонецЕсли;	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	//Если ЭтоНовый() Тогда
	//	ТекстЗапроса="ВЫБРАТЬ
	//	             |	ОпросникДляЭкзаменацииПродавца.Ссылка
	//	             |ИЗ
	//	             |	Справочник.ОпросникДляЭкзаменацииПродавца КАК ОпросникДляЭкзаменацииПродавца
	//	             |ГДЕ
	//	             |	ОпросникДляЭкзаменацииПродавца.ТекстВопроса ПОДОБНО &ТекстВопроса
	//	             |	И НЕ ОпросникДляЭкзаменацииПродавца.Устарел";
	//	Запрос = Новый Запрос(ТекстЗапроса);
	//	Запрос.УстановитьПараметр("ТекстВопроса",ЭтотОбъект.ТекстВопроса);
	//	Результат = Запрос.Выполнить();
	//	Если Не Результат.Пустой() Тогда
	//		Отказ = Истина;
	//		Сообщить("Уже есть вопрос с таким текстом: "+ЭтотОбъект.ТекстВопроса);
	//	КонецЕсли;	
	//КонецЕсли;	
КонецПроцедуры
