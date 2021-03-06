﻿Перем Хранилище Экспорт;

//+++АК sole 2018.06.09 ИП-00018850
Процедура Конструктор()
	
	Если ЗначениеЗаполнено(ЭтотОбъект.Ссылка) Тогда
		Если ЗначениеЗаполнено(ЭтотОбъект.Ссылка.Файл) Тогда
			Хранилище = Новый ХранилищеЗначения
				(
					АК_Инструменты.ПолучитьДанныеИзХранилищаФайлов(ЭтотОбъект.Ссылка.Файл)
				);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	//+++АК sole 2018.06.09 ИП-00018850	
	Если ЗначениеЗаполнено(Хранилище) Тогда
		
		Данные = Хранилище.Получить();
		РасширениеФайла = АК_Инструменты.ПолучитьРасширениеФайла(ЭтотОбъект.ИмяФайла);
		ИмяВремФайла = ПолучитьИмяВременногоФайла(РасширениеФайла);
		Данные.Записать(ИмяВремФайла);
		
		Если АК_Инструменты.ЭтоКлиент() Тогда
			ИмяФайлаНаСервере =	АК_Инструменты.ЗагрузитьФайлНаСервер(ИмяВремФайла);
		Иначе
			ИмяФайлаНаСервере = ИмяВремФайла;
		КонецЕсли;	
		
		ЭтотОбъект.Файл = АК_ИнструментыСервер.ОбновитьФайлВложение_Сервер(ЭтотОбъект.ИмяФайла, ИмяФайлаНаСервере, ЭтотОбъект.Файл);	
		
		Если АК_Инструменты.ФайлСуществует(ИмяВремФайла) Тогда
			УдалитьФайлы(ИмяВремФайла);	
		КонецЕсли; 
		
	КонецЕсли;
	//---АК sole 2018.06.09 ИП-00018850
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(Объект) = Тип("ДокументСсылка.ЭлектронноеПисьмо")
	   И ТипЗнч(Объект.ПредметКонтакта) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Предмет = Объект.ПредметКонтакта;
	Иначе
		Предмет = Справочники.ФизическиеЛица.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры


Конструктор();