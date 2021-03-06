﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;	
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если ЗначениеЗаполнено(Запись.ПрикреплённыеФайлы) Тогда
			Таб = ЗначениеИзСтрокиВнутр(Запись.ПрикреплённыеФайлы);
			Запись.КоличествоПрикреплённыхФайлов = Таб.Количество();
		Иначе	
			Запись.КоличествоПрикреплённыхФайлов = 0;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

//+++АК SHEP 2018.08.07 ИП-00018753.03
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если НЕ Отказ И ЭтотОбъект.Количество() > 0 Тогда //И Замещение Тогда
		
		СтруктураДанныеОтбор = Новый Структура("id_OK,GUID_Загрузки,ДатаДок");
		СтруктураДанные = Новый Структура("ТипВключенияОписаниеПостороннегоПредмета,ПричинаПопаданияПостороннегоВключения,ОписаниеТехнологическогоПроцессаВключения,
			|ТекущиеМетодыКонтроляДанногоНарушения,РазработанныеПрограммыПредварительныхМероприятий,ПринятыеМерыМетодыКонтроляПослеНарушения,ПланируемыеКорректирующиеДействия,
			|НаПроизводствеУстановленаВидеоФиксация,ЕстьНаблюдениеЗаКонтрольнойТочкой,ПланируетсяВнедрениеВидеонаблюденияЗаКонтрольнойТочкой,Комментарий,Заполнил");
		СтруктураСинонимы = Новый Структура(Новый ФиксированнаяСтруктура(СтруктураДанные));
		ЗаполнитьСинонимыПолей(СтруктураСинонимы);
		
		МенеджерЗаписиОбращенияПокупателей = РегистрыСведений.ОбращенияПокупателей.СоздатьМенеджерЗаписи();
		
		Для Каждого Запись Из ЭтотОбъект Цикл
			
			ЗаполнитьЗначенияСвойств(СтруктураДанныеОтбор, Запись);
			ЗаполнитьЗначенияСвойств(МенеджерЗаписиОбращенияПокупателей, СтруктураДанныеОтбор);
			МенеджерЗаписиОбращенияПокупателей.Прочитать();
			
			Если НЕ МенеджерЗаписиОбращенияПокупателей.Выбран() Тогда Продолжить; КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(СтруктураДанные, Запись);
			
			МассивОтветыПроизводителя = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("ОтветПроизводителя", ",");
			Для Каждого ИмяРекъОтветПроизводителя Из МассивОтветыПроизводителя Цикл
				ОтветПроизводителя = МенеджерЗаписиОбращенияПокупателей[ИмяРекъОтветПроизводителя];
				
				Поз1 = Найти(ОтветПроизводителя, "Ответ_производителя_начало");
				Поз2 = Найти(ОтветПроизводителя, "Ответ_производителя_конец");
				
				Если Поз1 > 0 Тогда
					ОтветПроизводителя1 = Лев(ОтветПроизводителя, Поз1 - 1);
					ОтветПроизводителя2 = ?(Поз2 = 0, "", Сред(ОтветПроизводителя, Поз2 + СтрДлина("Ответ_производителя_конец")));
				Иначе
					ОтветПроизводителя1 = ОтветПроизводителя;
					ОтветПроизводителя2 = "";
				КонецЕсли;
				
				ОтветПроизводителяНаВключения = "Ответ_производителя_начало";
				
				Для Каждого КлючИЗначение Из СтруктураДанные Цикл
					ОтветПроизводителяНаВключения = ОтветПроизводителяНаВключения + "
					|" + СтруктураСинонимы[КлючИЗначение.Ключ] + ":
					|  - " + КлючИЗначение.Значение + Символы.ПС;
				КонецЦикла;
				
				ОтветПроизводителяНаВключения = ОтветПроизводителяНаВключения + "
				|Ответ_производителя_конец";
				
				ОтветПроизводителя = ОтветПроизводителя1 + ?(ПустаяСтрока(ОтветПроизводителя1), "", Символы.ПС) + ОтветПроизводителяНаВключения + ОтветПроизводителя2;
				
				МенеджерЗаписиОбращенияПокупателей[ИмяРекъОтветПроизводителя] = ОтветПроизводителя;
			КонецЦикла;
			
			МенеджерЗаписиОбращенияПокупателей.ПерепискаСПроизводителем = МенеджерЗаписиОбращенияПокупателей.ПерепискаСПроизводителем +
				?(ПустаяСтрока(МенеджерЗаписиОбращенияПокупателей.ПерепискаСПроизводителем), "", Символы.ПС + "|" + Символы.ПС)
				+ "<Получен ответ производителя [" + Формат(ТекущаяДата(), "ДЛФ=DT") + "]>";
			
			МенеджерЗаписиОбращенияПокупателей.ТребуетОбязательногоОтветаПроизводителя = Ложь;
			МенеджерЗаписиОбращенияПокупателей.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

//+++АК SHEP 2018.08.17 ИП-00018753.03
Процедура ЗаполнитьСинонимыПолей(СтруктураПолей)
Перем МетаданныеОбъекта;
	
	МетаданныеОбъекта = ЭтотОбъект.Метаданные();
	РеквизитыОбъектаМД = МетаданныеОбъекта.Реквизиты;
	
	Для Каждого КлючИЗначение Из СтруктураПолей Цикл
		ИмяРекъ = КлючИЗначение.Ключ;
		
		РеквизитОбъектаМД = РеквизитыОбъектаМД.Найти(ИмяРекъ);
		СтруктураПолей.Вставить(ИмяРекъ, ?(РеквизитОбъектаМД = Неопределено, ИмяРекъ, РеквизитОбъектаМД.Синоним));
	КонецЦикла;
	
КонецПроцедуры
 