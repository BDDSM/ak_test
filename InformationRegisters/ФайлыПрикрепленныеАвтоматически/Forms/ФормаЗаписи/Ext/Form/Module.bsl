﻿
&НаКлиенте
Процедура ОбновитьПолеПредпросмотра(ИмяФайла)
	
	//
	HTMLПредпросмотр = "<HTML><HEAD>
					|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
					|<META name=GENERATOR content=""MSHTML 8.00.7601.18870""></HEAD>
					|<BODY>";
					
					
	//
	стрИзображение = "<DIV><IMG style=""width:99%;"" src=""#REF""></DIV>"; 
	
	//
	Файл = Новый Файл(ИмяФайла);
	Если Файл.Существует() И НЕ Файл.ЭтоКаталог() Тогда
		
		//
		Если Файл.Расширение = ".pdf" Тогда
			
			//
			стрИзображение = "<DIV><EMBED style=""width:99%;height:100%;"" src=""#REF""></DIV>";
			
		Иначе
			
			//
			стрИзображение = "<DIV><IMG style=""width:99%;"" src=""#REF""></DIV>";
			
		КонецЕсли;							
		
		//
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
		ИзображениеСкан = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		
		//
		HTMLПредпросмотр = HTMLПредпросмотр + СтрЗаменить(стрИзображение, "#REF", ИмяФайла);
		
	Иначе
		
		//
		HTMLПредпросмотр = HTMLПредпросмотр + СтрЗаменить(стрИзображение, "#REF", "");
		
	КонецЕсли;						
	
	//
	HTMLПредпросмотр = HTMLПредпросмотр + "</BODY></HTML>";

КонецПроцедуры



&НаСервере
Функция ПолучитьЗначениеРеквизита(Ссылка, ИмяРеквизита)
	
	//
	Возврат Ссылка[ИмяРеквизита];
	
КонецФункции	


&НаСервере
Функция ПолучитьАдресДанныхКартинки()
	
	//
	Попытка
		Картинка = Новый Картинка(Справочники.Файлы.ПолучитьИмяФайлаДляОбъекта(Запись.Файл));
	Исключение
		Картинка = Новый Картинка;
	КонецПопытки;	
	
	//
	Возврат ПоместитьВоВременноеХранилище(Картинка);
	
КонецФункции


&НаКлиенте
Процедура ФайлОткрытие(Элемент, СтандартнаяОбработка)
	
	//
	СтандартнаяОбработка = Ложь;
	
	//
	ИмяФайла = ПолучитьИмяВременногоФайла(ПолучитьЗначениеРеквизита(Запись.Файл, "Расширение"));
	Если ПолучитьФайл(ПолучитьАдресДанныхКартинки(), ИмяФайла, Ложь) = Истина Тогда
		ЗапуститьПриложение(ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура НайтиДокумент()
	
	//
	ТекстЗапроса = "ВЫБРАТЬ
	               |	Таблица.Ссылка,
	               |	Таблица.НомерВходящегоДокумента КАК Номер,
	               |	Таблица.ДатаВходящегоДокумента КАК Дата
	               |ПОМЕСТИТЬ ТЗ
	               |ИЗ
	               |	Документ.ПоступлениеТоваровУслуг КАК Таблица
	               |ГДЕ
	               |	Таблица.Контрагент = &Контрагент
	               |	И Таблица.Организация = &Организация
	               |	И Таблица.НомерВходящегоДокумента = &Номер
	               |	И Таблица.ДатаВходящегоДокумента = &Дата
	               |	И Таблица.НомерВходящегоДокумента <> """"
	               |	И &ПризнакЭтоАктНакладная
	               |
	               |ОБЪЕДИНИТЬ
	               |
	               |ВЫБРАТЬ
	               |	Таблица.Ссылка,
	               |	Таблица.НомерВходящегоСчетаФактуры,
	               |	Таблица.ДатаВходящегоСчетаФактуры
	               |ИЗ
	               |	Документ.ПоступлениеТоваровУслуг КАК Таблица
	               |ГДЕ
	               |	Таблица.Контрагент = &Контрагент
	               |	И Таблица.Организация = &Организация
	               |	И Таблица.НомерВходящегоСчетаФактуры = &Номер
	               |	И Таблица.ДатаВходящегоСчетаФактуры = &Дата
	               |	И Таблица.НомерВходящегоСчетаФактуры <> """"
	               |	И (&ПризнакЭтоСФ
	               |			ИЛИ &ПризнакЭтоУПД)
	               |
	               |ОБЪЕДИНИТЬ
	               |
	               |ВЫБРАТЬ
	               |	Таблица.Ссылка,
	               |	Таблица.НомерСчетФактуры,
	               |	Таблица.ДатаВходящегоСчетаФактуры
	               |ИЗ
	               |	Документ.ПоступлениеТоваровУслуг КАК Таблица
	               |ГДЕ
	               |	Таблица.Контрагент = &Контрагент
	               |	И Таблица.Организация = &Организация
	               |	И Таблица.НомерСчетФактуры = &Номер
	               |	И Таблица.ДатаВходящегоСчетаФактуры = &Дата
	               |	И (&ПризнакЭтоСФ
	               |			ИЛИ &ПризнакЭтоУПД)
	               |	И Таблица.НомерСчетФактуры <> """"
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТЗ.Ссылка,
	               |	ВЫБОР
	               |		КОГДА ТЗ.Ссылка.Проведен
	               |			ТОГДА 0
	               |		КОГДА НЕ ТЗ.Ссылка.ПометкаУдаления
	               |			ТОГДА 1
	               |	КОНЕЦ КАК Порядок
	               |ИЗ
	               |	ТЗ КАК ТЗ
	               |ГДЕ
	               |	НЕ ТЗ.Ссылка.ПометкаУдаления";
	
	//
	ПЗ = Новый ПостроительЗапроса;
	ПЗ.Текст = ТекстЗапроса;
	
	//
	ПЗ.Параметры.Вставить("Контрагент", Запись.Контрагент);
	ПЗ.Параметры.Вставить("Организация", Запись.Организация);
	ПЗ.Параметры.Вставить("Номер", Запись.Номер);
	ПЗ.Параметры.Вставить("Дата", Запись.Дата);
	
	ПЗ.Параметры.Вставить("ПризнакЭтоАктНакладная", Запись.ПризнакЭтоАктНакладная);
	ПЗ.Параметры.Вставить("ПризнакЭтоСФ", Запись.ПризнакЭтоСФ);
	ПЗ.Параметры.Вставить("ПризнакЭтоУПД", Запись.ПризнакЭтоУПД);
	
	//
	ПЗ.Выполнить();
	
	//
	Выборка = ПЗ.Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Запись.Объект = Выборка.Ссылка;
	КонецЕсли;	
	
КонецПроцедуры	


&НаКлиенте
Процедура КомандаНайти(Команда)
	НайтиДокумент();
КонецПроцедуры

/////////////////////////////////////////////////////////////////

&НаСервере
Функция ПолучитьПолныйПутьКФайлу(Файл)
	
	//
	Возврат Справочники.Файлы.ПолучитьИмяФайлаДляОбъекта(Файл);
	
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//
	ИмяФайла = ПолучитьПолныйПутьКФайлу(Запись.Файл);
	ОбновитьПолеПредпросмотра(ИмяФайла);
	
КонецПроцедуры
