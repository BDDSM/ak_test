﻿
Функция ПолучитьПрикрепленныеСервер()
	
	Возврат ПрикрепленныеФайлы.Выгрузить();
	
КонецФункции	

Функция ПолучитьРеквизитыСохраненияКартинки(ФайлСсылка)
	
	Картинка = Новый Картинка(Справочники.Файлы.ПолучитьИмяФайлаДляОбъекта(ФайлСсылка));
	
	Возврат Новый Структура("АдресКартинки, Расширение", ПоместитьВоВременноеХранилище(Картинка), ФайлСсылка.Расширение);
	
КонецФункции

Функция СоздатьФайлХранения(СтрокаТаблицы, РасширениеРезультата)
	
	СпрОбъект = Справочники.Файлы.СоздатьЭлемент();
	//СпрОбъект.УстановитьНовыйКод("0");
	СпрОбъект.Наименование 	= СтрокаТаблицы.Представление;
	СпрОбъект.Расширение 	= РасширениеРезультата;
	СпрОбъект.ДополнительныеСвойства.Вставить("Хранилище", Новый ХранилищеЗначения(Новый Картинка(СтрокаТаблицы.ДанныеКартинки)));
	СпрОбъект.Записать();
	
	Возврат СпрОбъект.Ссылка;
	
КонецФункции	


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УИН_СтрокиОплат = Параметры.УИН_СтрокиОплат;
	
	ПрикрепленныеФайлы.Загрузить(Параметры.СоставФайлов);
	
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьФайл(Команда)
	
	//
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла 		= "";
	ДиалогОткрытияФайла.МножественныйВыбор 	= Истина;
	ДиалогОткрытияФайла.Заголовок 			= "Выберите файлы";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
	    МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
	    Для Каждого ИмяФайла Из МассивФайлов Цикл
	        ВыбФайл = Новый Файл(ИмяФайла);
			Если НЕ ВыбФайл.Существует() Тогда				
				Сообщить("Не существует файл. "+ИмяФайла);
				Продолжить;
			КонецЕсли;
			СсылкаНаФайл = СоздатьФайлХранения(Новый Структура("Представление, ДанныеКартинки", ВыбФайл.Имя, Новый ДвоичныеДанные(ИмяФайла)), ВыбФайл.Расширение);
			
			//
			НоваяСтрока = ПрикрепленныеФайлы.Добавить();
			НоваяСтрока.Файл = СсылкаНаФайл;
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(ПолучитьПрикрепленныеСервер());
	
КонецПроцедуры

&НаКлиенте
Процедура Просмотреть(Команда)
	
	Если Элементы.ПрикрепленныеФайлы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элементы.ПрикрепленныеФайлы.ДанныеСтроки(Элементы.ПрикрепленныеФайлы.ТекущаяСтрока);
	
	СтруктураКартинки = ПолучитьРеквизитыСохраненияКартинки(ДанныеСтроки.Файл);
	ИмяФайла = ПолучитьИмяВременногоФайла(СтруктураКартинки.Расширение);
	Если ПолучитьФайл(СтруктураКартинки.АдресКартинки, ИмяФайла, Ложь) = Истина Тогда
		ЗапуститьПриложение(ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Элементы.ПрикрепленныеФайлы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элементы.ПрикрепленныеФайлы.ДанныеСтроки(Элементы.ПрикрепленныеФайлы.ТекущаяСтрока);
	
	СтруктураКартинки = ПолучитьРеквизитыСохраненияКартинки(ДанныеСтроки.Файл);
	
	ИмяФайла = ПолучитьИмяВременногоФайла(СтруктураКартинки.Расширение);
	ПолучитьФайл(СтруктураКартинки.АдресКартинки, ИмяФайла, Истина);
	
КонецПроцедуры
