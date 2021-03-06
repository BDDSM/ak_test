﻿Процедура ОтобразитьСостояние(ТекстСообщения) Экспорт
		
	#Если Клиент Тогда
	Состояние(ТекстСообщения);
	#КонецЕсли

КонецПроцедуры

Процедура ПроверитьПрерывание() Экспорт
	#Если Клиент Тогда
	ОбработкаПрерыванияПользователя();
	#КонецЕсли
КонецПроцедуры	

Функция ОткрытьФормуХодаОбработки() Экспорт
	
	#Если Клиент Тогда
		возврат ПолучитьОбщуюФорму("ХодВыполненияОбработкиДанных");
	#Иначе			
		возврат Новый Структура("НаименованиеОбработкиДанных,КомментарийОбработкиДанных,КомментарийЗначения,МаксимальноеЗначение,Значение");			
	#КонецЕсли
	
КонецФункции

Функция ПолучитьФормуЗагрузкиЗаказов() Экспорт
	
	возврат ПолучитьФорму("ФормаЗагрузкиЗаказов");
	
КонецФункции

Процедура ОбновитьДанныеРегламентногоЗадания(Отказ, РасписаниеРегламентногоЗадания, ТекущийОбъект) Экспорт
	Возврат;
	// получаем регламентное задание по идентификатору, если объект не находим, то создаем новый
	РегламентноеЗаданиеОбъект = СоздатьРегламентноеЗаданиеПриНеобходимости(Отказ, ТекущийОбъект);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// обновляем свойства РЗ
	УстановитьПараметрыРегламентногоЗадания(РегламентноеЗаданиеОбъект, РасписаниеРегламентногоЗадания, ТекущийОбъект);
	
	// записываем измененное задание
	ЗаписатьРегламентноеЗадание(Отказ, РегламентноеЗаданиеОбъект);
	
	//запоминаем GUID регл. задания в реквизите объекта
	ТекущийОбъект.РегламентноеЗадание = Строка(РегламентноеЗаданиеОбъект.УникальныйИдентификатор);
	
КонецПроцедуры

Процедура ОбновитьДанныеРегламентногоЗаданияЗагрузкиЗаказов(Отказ, РасписаниеРегламентногоЗадания, ТекущийОбъект) Экспорт
	Возврат;
	// получаем регламентное задание по идентификатору, если объект не находим, то создаем новый
	РегламентноеЗаданиеОбъект = СоздатьРегламентноеЗаданиеЗагрузкиЗаказовПриНеобходимости(Отказ, ТекущийОбъект);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// обновляем свойства РЗ
	УстановитьПараметрыРегламентногоЗаданияЗагрузкиЗаказов(РегламентноеЗаданиеОбъект, РасписаниеРегламентногоЗадания, ТекущийОбъект);
	
	// записываем измененное задание
	ЗаписатьРегламентноеЗадание(Отказ, РегламентноеЗаданиеОбъект);
	
	//запоминаем GUID регл. задания в реквизите объекта
	ТекущийОбъект.РегламентноеЗаданиеЗагрузкиЗаказов = Строка(РегламентноеЗаданиеОбъект.УникальныйИдентификатор);
	
КонецПроцедуры

Процедура ЗаписатьРегламентноеЗадание(Отказ, РегламентноеЗаданиеОбъект) Экспорт
	Возврат;
	Попытка
		
		// записываем задание
		РегламентноеЗаданиеОбъект.Записать();
		
	Исключение
		
		НСтрока = НСтр("ru = ''");
		//
		СтрокаСообщения = "Произошла ошибка при сохранении расписания выполнения обменов. Возможно данные расписания были изменены.
		                     |Подробное описание ошибки: "+ОписаниеОшибки();
		
		Сообщить(СтрокаСообщения, Отказ);
		
	КонецПопытки;
	
КонецПроцедуры

Функция СоздатьРегламентноеЗаданиеПриНеобходимости(Отказ, ТекущийОбъект)
	Возврат Неопределено;
	РегламентноеЗаданиеОбъект = НайтиРегламентноеЗаданиеПоПараметру(ТекущийОбъект.РегламентноеЗадание);
	
	// при необходимости создаем регл. задание
	Если РегламентноеЗаданиеОбъект = Неопределено Тогда
		
		//РегламентноеЗаданиеОбъект = РегламентныеЗадания.СоздатьРегламентноеЗадание("CMS1C_ЗаданиеОбменССайтом");
		
	КонецЕсли;
	
	Возврат РегламентноеЗаданиеОбъект;
	
КонецФункции

Процедура УстановитьПараметрыРегламентногоЗадания(РегламентноеЗаданиеОбъект, РасписаниеРегламентногоЗадания, ТекущийОбъект)
	Возврат;
	ПараметрыРегламентногоЗадания = Новый Массив;
	ПараметрыРегламентногоЗадания.Добавить(ТекущийОбъект.Ссылка);
	
	НСтрока = НСтр("ru = 'Выполнение обмена по настройке: %1'");
	НаименованиеРегламентногоЗадания = "Выполнение обмена по настройке: "+СокрЛП(ТекущийОбъект.Наименование);
	
	РегламентноеЗаданиеОбъект.Наименование  = Лев(НаименованиеРегламентногоЗадания, 120);
	РегламентноеЗаданиеОбъект.Использование = ТекущийОбъект.ИспользоватьРегламентныеЗадания;
	РегламентноеЗаданиеОбъект.Параметры     = ПараметрыРегламентногоЗадания;
	
	// обновляем расписание, если оно было изменено
	Если РасписаниеРегламентногоЗадания <> Неопределено Тогда
		РегламентноеЗаданиеОбъект.Расписание = РасписаниеРегламентногоЗадания;
	КонецЕсли;
		
КонецПроцедуры

Функция СоздатьРегламентноеЗаданиеЗагрузкиЗаказовПриНеобходимости(Отказ, ТекущийОбъект)
	Возврат Неопределено;
	РегламентноеЗаданиеОбъект = НайтиРегламентноеЗаданиеПоПараметру(ТекущийОбъект.РегламентноеЗаданиеЗагрузкиЗаказов);
	
	// при необходимости создаем регл. задание
	Если РегламентноеЗаданиеОбъект = Неопределено или ТекущийОбъект.РегламентноеЗаданиеЗагрузкиЗаказов = ТекущийОбъект.РегламентноеЗадание Тогда
		
		РегламентноеЗаданиеОбъект = РегламентныеЗадания.СоздатьРегламентноеЗадание("CMS1C_ЗаданиеОбменССайтомЗаказы");
		
	КонецЕсли;
	
	Возврат РегламентноеЗаданиеОбъект;
	
КонецФункции

Процедура УстановитьПараметрыРегламентногоЗаданияЗагрузкиЗаказов(РегламентноеЗаданиеОбъект, РасписаниеРегламентногоЗадания, ТекущийОбъект)
	
	ПараметрыРегламентногоЗадания = Новый Массив;
	ПараметрыРегламентногоЗадания.Добавить(ТекущийОбъект.Ссылка);
	
	НСтрока = НСтр("ru = 'Выполнение обмена по настройке: %1'");
	НаименованиеРегламентногоЗадания = "Выполнение обмена по настройке: "+СокрЛП(ТекущийОбъект.Наименование);
	
	РегламентноеЗаданиеОбъект.Наименование  = Лев(НаименованиеРегламентногоЗадания, 120);
	РегламентноеЗаданиеОбъект.Использование = ТекущийОбъект.ИспользоватьРегламентныеЗаданияЗагрузкиЗаказов;
	РегламентноеЗаданиеОбъект.Параметры     = ПараметрыРегламентногоЗадания;
	
	// обновляем расписание, если оно было изменено
	Если РасписаниеРегламентногоЗадания <> Неопределено Тогда
		РегламентноеЗаданиеОбъект.Расписание = РасписаниеРегламентногоЗадания;
	КонецЕсли;
КонецПроцедуры

Функция НайтиРегламентноеЗаданиеПоПараметру(УникальныйНомерЗадания) Экспорт
	
	Попытка
		
		Если НЕ ПустаяСтрока(УникальныйНомерЗадания) Тогда
			
			УникальныйИдентификаторЗадания = Новый УникальныйИдентификатор(УникальныйНомерЗадания);
			ТекущееРегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(УникальныйИдентификаторЗадания);
			
		Иначе
			
			ТекущееРегламентноеЗадание = Неопределено;
			
		КонецЕсли;
		
	Исключение
		
		ТекущееРегламентноеЗадание = Неопределено;
		
	КонецПопытки;
	
	Возврат ТекущееРегламентноеЗадание;
	
КонецФункции

// Получает расписание регл. задания. Если регл. задание не задано, то возвращает "Неопределено"
Функция ПолучитьРасписаниеВыполненияОбменаДанными(НастройкаВыполненияОбмена) Экспорт
	
	// возвращаемое значение функции
	РасписаниеРегламентногоЗадания = Неопределено;
	
	РегламентноеЗаданиеОбъект = НайтиРегламентноеЗаданиеПоПараметру(НастройкаВыполненияОбмена.РегламентноеЗадание);
	
	Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = РегламентноеЗаданиеОбъект.Расписание;
		
	КонецЕсли;
	
	Возврат РасписаниеРегламентногоЗадания;
	
КонецФункции

Функция ПолучитьРасписаниеВыполненияЗагрузкиЗаказов(НастройкаВыполненияОбмена) Экспорт
	
	// возвращаемое значение функции
	РасписаниеРегламентногоЗадания = Неопределено;
	
	РегламентноеЗаданиеОбъект = НайтиРегламентноеЗаданиеПоПараметру(НастройкаВыполненияОбмена.РегламентноеЗаданиеЗагрузкиЗаказов);
	
	Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = РегламентноеЗаданиеОбъект.Расписание;
		
	КонецЕсли;
	
	Возврат РасписаниеРегламентногоЗадания;
	
КонецФункции