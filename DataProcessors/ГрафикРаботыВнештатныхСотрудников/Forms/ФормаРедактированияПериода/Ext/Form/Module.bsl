﻿
&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	СтруктураВозврата = Новый Структура;
	
	СтруктураВозврата.Вставить("Сотрудник"	, Сотрудник);
	СтруктураВозврата.Вставить("Период"		, Период);
	//+++AK ziga  
	ТЗ=Новый Массив;
	//ТЗ = Новый ТаблицаЗначений;
	//ТЗ.Колонки.Добавить("ТорговаяТочка"	 , Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	//ТЗ.Колонки.Добавить("КоличествоЧасов", Новый ОписаниеТипов("Число"));
	//---AK ziga 
	Для Каждого Стр Из ТаблицаДанных Цикл
	//+++AK ziga	
		ТЗ.Добавить(Новый Структура("ТорговаяТочка,КоличествоЧасов",Стр.ТорговаяТочка,Стр.КоличествоЧасов));
		//ЗаполнитьЗначенияСвойств(ТЗ.Добавить(), Стр);
	//---AK ziga 
	КонецЦикла;
	//+++AK ziga 
	//СтруктураВозврата.Вставить("ТаблицаДанных", ТЗ);
	СтруктураВозврата.Вставить("ТаблицаДанных", ТЗ);

	//---AK ziga 
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Сотрудник")Тогда
		Сотрудник = Параметры.Сотрудник;
	КонецЕсли;
	
	Если Параметры.Свойство("Период")Тогда
		Период = Параметры.Период;
	КонецЕсли;
	
	Если Параметры.Свойство("ТаблицаДанных")Тогда
			//+++AK ziga 
		Для Каждого стр из Параметры.ТаблицаДанных Цикл
		СтрокаТ=ТаблицаДанных.Добавить();
		СтрокаТ.ТорговаяТочка=Стр.ТорговаяТочка;
		СтрокаТ.КоличествоЧасов=Стр.КоличествоЧасов;
		//ТаблицаДанных.Загрузить(Параметры.ТаблицаДанных);
		//---AK ziga 
		КонецЦикла; 
	КонецЕсли;
	 
КонецПроцедуры
