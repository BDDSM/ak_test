﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.НеИспользоватьАвтоакцепт.Доступность = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.УправлениеАвтоакцептомУслугКомплектации, Ложь);
КонецПроцедуры
