﻿
Процедура СформироватьСервер()
	
	СкомпоноватьРезультат();
	
КонецПроцедуры	


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//+++АК LAGP 2018.02.07 ИП-00017867 Доступен роли "пользователь", ограничение по доп.праву.
	МассивДопПрав = УправлениеДопПравамиПользователей.ПрочитатьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.ДоступКОтчётуПоВыведенымТоварам,Ложь,ПараметрыСеанса.ТекущийПользователь);	
	ПравоНаИспользование = МассивДопПрав[0];
	Если НЕ ПравоНаИспользование И НЕ РольДоступна("ПолныеПрава") Тогда
		Сообщить("Нет прав на использование отчёта!");
		Отказ = Истина;
	КонецЕсли;
	//---АК LAGP
	
	мЭлементыПараметровДанных = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы;
	
	Параметр = мЭлементыПараметровДанных.Найти("ДатаНачала");	
	ПользовательскийПараметр = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Параметр.ИдентификаторПользовательскойНастройки);
	ПользовательскийПараметр.Использование 	= Истина;
	ПользовательскийПараметр.Значение 		= НачалоДня(ТекущаяДата() - 8 * 86400);
	
	Параметр = мЭлементыПараметровДанных.Найти("ДатаОкончания");	
	ПользовательскийПараметр = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Параметр.ИдентификаторПользовательскойНастройки);
	ПользовательскийПараметр.Использование 	= Истина;
	ПользовательскийПараметр.Значение 		= НачалоДня(ТекущаяДата() - 86400);
	
	//
	СформироватьСервер();
	
КонецПроцедуры
