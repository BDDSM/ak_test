﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	//+++АК ZICD 10.01.2017 ИП-00014363
	НачалоУчётаМСФО = АК_УчетМСФОПривилегированный.ПолучитьДатуНачалаУчетаМСФО();
	ОрганизацияДляУчётаПоМСФО = АК_УчетМСФО.ПолучитьОрганизациюИзСсылки(Ссылка, Дата, НачалоУчётаМСФО);
	//---АК
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЛистУчета.ТорговаяТочка,
	               |	ЛистУчета.ЦФО,
	               |	СУММА(1) КАК КоличествоДней
	               |ИЗ
	               |	Документ.ЛистУчета КАК ЛистУчета
	               |ГДЕ
	               |	ЛистУчета.Проведен = ИСТИНА
	               |	И НАЧАЛОПЕРИОДА(ЛистУчета.Дата, МЕСЯЦ) = &Дата
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ЛистУчета.ТорговаяТочка,
	               |	ЛистУчета.ЦФО
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница КАК ТорговаяТочка,
	               |	ЦФОСтруктурныхЕдиницСрезПоследних.ЦФО,
	               |	1 КАК КоличествоДней
	               |ИЗ
	               |	РегистрСведений.ЦФОСтруктурныхЕдиниц.СрезПоследних(&Дата, ) КАК ЦФОСтруктурныхЕдиницСрезПоследних";
				   
	Запрос.УстановитьПараметр("Дата", НачалоМесяца(Дата));
	Результаты = Запрос.ВыполнитьПакет();
	ТабЦФОПоТТ = Результаты[0].Выгрузить();
	ТабЦФОПоРегистру = Результаты[1].Выгрузить();
	
	Движения.Финансовый.Записывать = Истина;
	Движения.Финансовый.Очистить();
	Для Каждого ТекСтрокаТорговыеТочки Из ТорговыеТочки Цикл
		
		Если ТекСтрокаТорговыеТочки.Сумма = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокиЦФО = ТабЦФОПоТТ.НайтиСтроки(Новый Структура("ТорговаяТочка", ТекСтрокаТорговыеТочки.ТорговаяТочка));
		Если СтрокиЦФО.Количество() = 0 Тогда
			СтрокиЦФО = ТабЦФОПоРегистру.НайтиСтроки(Новый Структура("ТорговаяТочка", ТекСтрокаТорговыеТочки.ТорговаяТочка));
			Если СтрокиЦФО.Количество() = 0 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("По листам учета не определен ЦФО для точки: " + ТекСтрокаТорговыеТочки.ТорговаяТочка);
			КонецЕсли;	
		КонецЕсли;	
		
		Если СтрокиЦФО.Количество() = 0 Тогда
			Движение 								  = Движения.Финансовый.Добавить();
			Движение.Период 						  = Дата;
			Движение.СчетДт 						  = СчетСписанияЗатрат;
			Движение.СубконтоДт.ТорговыеТочки 		  = ТекСтрокаТорговыеТочки.ТорговаяТочка;
			Движение.СубконтоДт.СтатьиДоходовРасходов = СтатьяДоходовРасходов;
			
			//ОтборЦФО = Новый Структура;
			//ОтборЦФО.Вставить("СтруктурнаяЕдиница",ТекСтрокаТорговыеТочки.ТорговаяТочка);
			//СтруктураРезультата 					  = РегистрыСведений.ЦФОСтруктурныхЕдиниц.ПолучитьПоследнее(Дата,ОтборЦФО);
			//Движение.СубконтоДт.ЦФО 				  = СтрокаЦФО.ЦФО;
			
			Движение.СчетКт 						  = СчетЗатрат;
			БухгалтерскийУчет.УстановитьСубконто(Движение.СчетКт,Движение.СубконтоКт,1,СубконтоКт1);
			БухгалтерскийУчет.УстановитьСубконто(Движение.СчетКт,Движение.СубконтоКт,2,СубконтоКт2);
			БухгалтерскийУчет.УстановитьСубконто(Движение.СчетКт,Движение.СубконтоКт,3,СубконтоКт3);
			
			Движение.Сумма 							  = ТекСтрокаТорговыеТочки.Сумма;
			Движение.НомерЖурнала					  = "ТТ";
			Движение.Содержание						  = "Списаны затраты ТТ. "+ Комментарий;
			//+++АК ZICD 10.01.2017 ИП-00014363
			Движение.Организация = ОрганизацияДляУчётаПоМСФО;
			//---АК
		Иначе	
			ОбщееКоличествоДней = 0;
			Для Каждого СтрокаЦФО Из СтрокиЦФО Цикл
				ОбщееКоличествоДней = ОбщееКоличествоДней + СтрокаЦФО.КоличествоДней;
			КонецЦикла;	
			
			СуммаРаспределено = 0;
			Для Каждого СтрокаЦФО Из СтрокиЦФО Цикл
				Движение 								  = Движения.Финансовый.Добавить();
				Движение.Период 						  = Дата;
				Движение.СчетДт 						  = СчетСписанияЗатрат;
				Движение.СубконтоДт.ТорговыеТочки 		  = ТекСтрокаТорговыеТочки.ТорговаяТочка;
				Движение.СубконтоДт.СтатьиДоходовРасходов = СтатьяДоходовРасходов;
				
				//ОтборЦФО = Новый Структура;
				//ОтборЦФО.Вставить("СтруктурнаяЕдиница",ТекСтрокаТорговыеТочки.ТорговаяТочка);
				//СтруктураРезультата 					  = РегистрыСведений.ЦФОСтруктурныхЕдиниц.ПолучитьПоследнее(Дата,ОтборЦФО);
				Движение.СубконтоДт.ЦФО 				  = СтрокаЦФО.ЦФО;
				
				Движение.СчетКт 						  = СчетЗатрат;
				БухгалтерскийУчет.УстановитьСубконто(Движение.СчетКт,Движение.СубконтоКт,1,СубконтоКт1);
				БухгалтерскийУчет.УстановитьСубконто(Движение.СчетКт,Движение.СубконтоКт,2,СубконтоКт2);
				БухгалтерскийУчет.УстановитьСубконто(Движение.СчетКт,Движение.СубконтоКт,3,СубконтоКт3);
				
				Движение.Сумма 							  = ТекСтрокаТорговыеТочки.Сумма * СтрокаЦФО.КоличествоДней / ОбщееКоличествоДней;
				Движение.НомерЖурнала					  = "ТТ";
				Движение.Содержание						  = "Списаны затраты ТТ. "+ Комментарий;
				СуммаРаспределено = СуммаРаспределено + Движение.Сумма;
				//+++АК ZICD 10.01.2017 ИП-00014363
				Движение.Организация = ОрганизацияДляУчётаПоМСФО;
				//---АК
			КонецЦикла;
			Если ТекСтрокаТорговыеТочки.Сумма - СуммаРаспределено <> 0 Тогда
				Движение.Сумма = Движение.Сумма + (ТекСтрокаТорговыеТочки.Сумма - СуммаРаспределено);
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;

КонецПроцедуры

Функция ПолучитьПервыйЦФОВПериоде(ТорговаяТочка,ДатаПериода)
	Если ДатаПериода < Дата("20130501000000") Тогда
		Возврат Неопределено;
	Иначе
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТорговаяТочка",ТорговаяТочка);
		Запрос.УстановитьПараметр("НачалоПериода",НачалоМесяца(ДатаПериода));
		Запрос.УстановитьПараметр("КонецПериода",КонецМесяца(ДатаПериода));
		
		Запрос.Текст ="ВЫБРАТЬ ПЕРВЫЕ 1
		              |	ЛистУчета.ЦФО,
		              |	ЛистУчета.Дата КАК Дата
		              |ИЗ
		              |	Документ.ЛистУчета КАК ЛистУчета
		              |ГДЕ
		              |	ЛистУчета.Проведен
		              |	И ЛистУчета.ТорговаяТочка = &ТорговаяТочка
		              |	И ЛистУчета.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		              |
		              |УПОРЯДОЧИТЬ ПО
		              |	Дата";
		Резульат = Запрос.Выполнить();
		Если Резульат.Пустой() Тогда
			Возврат Неопределено;
		Иначе
			Выборка = Резульат.Выбрать();
			Если Выборка.Следующий() Тогда
				Возврат Выборка.ЦФО;
			КонецЕсли
		КонецЕсли;
	КонецЕсли;
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	СуммаДокумента = ТорговыеТочки.Итог("Сумма");
	
КонецПроцедуры
