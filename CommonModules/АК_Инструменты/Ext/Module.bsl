﻿//+++АК sole 2018.06.04 ИП-00018850
Функция ЭтоКлиент() Экспорт

	#Если Клиент Тогда
		Возврат Истина;	
	#КонецЕсли

	#Если Сервер Тогда
		Возврат Ложь;	
	#КонецЕсли
КонецФункции

//+++АК sole 2018.06.04 ИП-00018850
Функция ЭтоСервер() Экспорт

	#Если Клиент Тогда
		Возврат Ложь;	
	#КонецЕсли

	#Если Сервер Тогда
		Возврат Истина;	
	#КонецЕсли
КонецФункции

//+++АК sole 2018.06.04 ИП-00018850
Функция ПолучитьРасширениеФайла(ИмяФайла) Экспорт
	
	Перем FSO;
	
	FSO = Новый COMОбъект("Scripting.FileSystemObject");
	Возврат FSO.GetExtensionName(ИмяФайла);  
	
КонецФункции

//+++АК sole 2018.06.09 ИП-00018850
Функция ПолучитьИмяФайла(ИмяФайла) Экспорт
	
	Перем FSO;
	
	FSO = Новый COMОбъект("Scripting.FileSystemObject");
	Возврат FSO.GetFileName(ИмяФайла);	
	
КонецФункции

//+++АК sole 2018.06.09 ИП-00018850
Функция ФайлСуществует(ИмяФайла) Экспорт
	
	Перем FSO;
	
	FSO = Новый COMОбъект("Scripting.FileSystemObject");
	Возврат FSO.FileExists(ИмяФайла);	
	
КонецФункции

//+++АК sole 2018.06.04 ИП-00018850
&НаКлиенте
Функция ЗагрузитьФайлНаСервер(ИмяФайла) Экспорт
	
	Перем СтрокаBase64, РасширениеФайла, ИмяФайлаНаСервере;
	
	СтрокаBase64 = Base64Строка(Новый ДвоичныеДанные(ИмяФайла));
	РасширениеФайла = ПолучитьРасширениеФайла(ИмяФайла); 
	
	ИмяФайлаНаСервере = АК_ИнструментыСервер.СоздатьВременныйФайлНаСервере(СтрокаBase64, РасширениеФайла);
	
	Возврат ИмяФайлаНаСервере;
	
КонецФункции

//+++АК sole 2018.06.07 ИП-00018850
Процедура ВыполнитьПроцедуруНаСервере(ИмяПроцедуры, мПараметры) Экспорт
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(Неопределено);
	ПоместитьВоВременноеХранилище(мПараметры, АдресВХранилище);
	
	АК_ИнструментыСервер.ВыполнитьПроцедуруНаСервере_Сервер(ИмяПроцедуры, АдресВХранилище); 
	
КонецПроцедуры

//+++АК sole 2018.06.09 ИП-00018850
&НаКлиенте
Функция ОбновитьФайлВложение(ИмяФайла, СправочникФайлыСсылка) Экспорт
	
	Перем ИмяФайлаНаСервере;
	
	Если НЕ ФайлСуществует(ИмяФайла) Тогда
		Сообщить("Файл """ + ИмяФайла + """ не существует или недоступен!");
		Возврат Ложь;
	КонецЕсли;
	
	ИмяФайлаНаСервере =	ЗагрузитьФайлНаСервер(ИмяФайла);
	СправочникФайлыСсылка = АК_ИнструментыСервер.ОбновитьФайлВложение_Сервер(ИмяФайла, ИмяФайлаНаСервере, СправочникФайлыСсылка); 
	
	Возврат Истина;
	
КонецФункции

//+++АК sole 2018.06.09 ИП-00018850
Функция ПолучитьДанныеИзХранилищаФайлов(СправочникФайлыСсылка) Экспорт
	
	Перем Данные, СтрокаBase64, ИмяФайла;
	
	Если АК_Инструменты.ЭтоКлиент() Тогда
		СтрокаBase64 = АК_ИнструментыСервер.ПолучитьДанныеИзХранилищаФайлов_Сервер(СправочникФайлыСсылка);
		Данные = Base64Значение(СтрокаBase64);
	Иначе
		ИмяФайла = Справочники.Файлы.ПолучитьИмяФайлаДляОбъекта(СправочникФайлыСсылка);
		Данные = Новый ДвоичныеДанные(ИмяФайла)
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

//+++АК sole 2018.06.21 ИП-00018725
Функция ПолучитьРезультатСкалярногоЗароса(Запрос, ЗначениеПоУмолчанию) Экспорт
	
	Перем Результат;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Результат = Выборка[0];
	Иначе
		Результат = ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//+++АК sole 2018.09.27 ИП-00019785.02
Функция ПолучитьПарсерТекста(Текст, Разделитель = Неопределено) Экспорт
	
	Если Разделитель = Неопределено Тогда
		Разделитель = Символы.ПС;
	КонецЕсли;
	
	ПарсерТекста = Новый Структура
		(
			"Текст, Подстрока, Разделитель, РазделительДлина, КонецТекста",
		    Текст,
			Текст,
			Разделитель,
			СтрДлина(Разделитель),
			Ложь
		);
		
	Если 	
			Текст = Неопределено 
		Или Текст = "" 
		Или Разделитель = ""
	Тогда
		ПарсерТекста.КонецТекста = Истина;
	КонецЕсли;	
	
	Возврат ПарсерТекста;
	
КонецФункции

//+++АК sole 2018.09.27 ИП-00019785.02
Функция ПолучитьСледующийБлокТекста(ПарсерТекста) Экспорт
		
	Перем Поз, Результат;
	
	Поз = Найти(ПарсерТекста.Подстрока, ПарсерТекста.Разделитель);
	Если Поз > 0 Тогда
		Результат = Лев(ПарсерТекста.Подстрока, Поз - 1);	
		ПарсерТекста.Подстрока = Сред(ПарсерТекста.Подстрока, Поз + ПарсерТекста.РазделительДлина, СтрДлина(ПарсерТекста.Подстрока));	
	Иначе
		Результат = ПарсерТекста.Подстрока;
		ПарсерТекста.КонецТекста = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//+++АК sole 2018.09.27 ИП-00019785.02
Функция СброситьПарсерТекста(ПарсерТекста) Экспорт
	
	ПарсерТекста.Подстрока = ПарсерТекста.Текст;
	ПарсерТекста.КонецТекста = Ложь;
	
КонецФункции

//