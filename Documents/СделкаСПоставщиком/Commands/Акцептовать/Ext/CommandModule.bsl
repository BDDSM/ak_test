﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ПараметрыВыполненияКоманды.Источник.АкцептированиеДоступно Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Текст = ?(ПараметрКоманды.Количество()>1,"ru = ""Акцептовать выделенные документы?"";","ru = ""Акцептовать документ?"";");
		Ответ = Вопрос(НСтр(Текст), Режим, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
		    Возврат;
		КонецЕсли; 
		Если ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Документ.СделкаСПоставщиком.Форма.ФормаДокумента" Тогда
			ПараметрыВыполненияКоманды.Источник.Объект.Акцептовано = Истина;
			ПараметрыВыполненияКоманды.Источник.Объект.Акцептант = ПараметрыСеанса.ТекущийПользователь;
			ПараметрыВыполненияКоманды.Источник.Записать(Новый Структура("РежимЗаписи",?(ПараметрыВыполненияКоманды.Источник.Объект.Проведен,РежимЗаписиДокумента.Проведение,РежимЗаписиДокумента.Запись)));
			ПараметрыВыполненияКоманды.Источник.Модифицированность = Истина;
		Иначе
			
        	АкцептоватьДокументы(ПараметрКоманды);
			
		КонецЕсли;	
		
	Иначе
		Сообщить("У вас нет прав акцепта заявок и сделок");
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура АкцептоватьДокументы(МассивДокументов)
	Для Каждого Док Из МассивДокументов Цикл
		АкцептоватьДокументНаСервере(Док);
		Сообщение = Новый СообщениеПользователю();
	    Сообщение.Текст = "Акцептован "+Док;
	    Сообщение.Сообщить();

	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Процедура АкцептоватьДокументНаСервере(Док)
	ДокОбъект = Док.ПолучитьОбъект();
	ДокОбъект.Акцептовано = Истина;
	ДокОбъект.Акцептант = ПараметрыСеанса.ТекущийПользователь;
	ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
КонецПроцедуры	
