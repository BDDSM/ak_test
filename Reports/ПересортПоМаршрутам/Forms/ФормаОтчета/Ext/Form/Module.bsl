﻿
&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	//ТЗИтог=Неопределено;
	//СтрукРасшиф=Неопределено;
	СтандартнаяОбработка = Ложь;
	//Возврат;
	СтрукРасшиф=РасшифроватьОтчет(Расшифровка);
	Если Не СтрукРасшиф=Неопределено Тогда
		//ТабДок.ОтображатьЗаголовки = Ложь;
		//ТабДок.ОтображатьСетку = Ложь;
		//ТабДок.ФиксацияСверху = 3;
		//ТабДок.Показать();
		Если Элементы.Результат.ТекущаяОбласть.Верх>3+Отчет.НастройкаГруппировки.Количество()
			И Элементы.Результат.ТекущаяОбласть.Верх< Результат.ВысотаТаблицы-(3+Отчет.НастройкаГруппировки.Количество()) Тогда
			Режим=2;
		ИначеЕсли Элементы.Результат.ТекущаяОбласть.Верх<3+Отчет.НастройкаГруппировки.Количество() Тогда
			Режим=1;
		Иначе
			Режим=3;
		КонецЕсли; 
		
		Парам=Новый Структура("Режим",Режим);
		ОткрытьФорму(ПолучитьПолноеИмяФормы("ФормаРасшифровки"),Парам);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте 
Функция ПолучитьПолноеИмяФормы(ИмяФормы)

    СимволТочка = ".";
    ПозицияТочки = СтрДлина(ЭтаФорма.ИмяФормы);
    Пока Сред(ЭтаФорма.ИмяФормы, ПозицияТочки, 1) <> СимволТочка Цикл ПозицияТочки = ПозицияТочки - 1; КонецЦикла; //
    Возврат Лев(ЭтаФорма.ИмяФормы, ПозицияТочки) + ИмяФормы;

КонецФункции

&НаСервере
Функция РасшифроватьОтчет(Расшифровка)
	ТЗИтог=Неопределено;
	СтрукРасшиф=Неопределено;
	Данные = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	
	//ДатаОтчета = Данные.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаОтчета")).Значение.Дата;
	ДатаОтчета = ТекущаяДата();

	Поля = ИнфокомТиповыеОтчеты.ПолучитьМассивПолейРасшифровки(Расшифровка, Данные);
	Если Поля.Количество()=0 Тогда
	     Возврат Неопределено;
	КонецЕсли; 
	НоменклатураОтбор = Неопределено;
	СкладОтбор = Неопределено;
	ХарактеристикаОтбор = Неопределено;
	ОтбГрупп = Неопределено;
	Для Каждого ПолеРасшифровки Из Поля Цикл
		Если ТипЗнч(ПолеРасшифровки) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") Тогда
			Если ПолеРасшифровки.Поле = "Номенклатура" Тогда
				НоменклатураОтбор = ПолеРасшифровки.Значение;
			КонецЕсли;
			Если ПолеРасшифровки.Поле = "Склад" Тогда
				СкладОтбор = ПолеРасшифровки.Значение;
			КонецЕсли;
			Если ПолеРасшифровки.Поле = "Характеристика" Тогда
				ХарактеристикаОтбор = ПолеРасшифровки.Значение;
			КонецЕсли;
			Если ПолеРасшифровки.Поле = "Дата" Тогда
				ДатаОтчета = ПолеРасшифровки.Значение;
			КонецЕсли;
			Если ПолеРасшифровки.Поле = "Представление" Тогда
				ОтбГрупп = ПолеРасшифровки.Значение;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	Если Не ЗначениеЗаполнено(ОтбГрупп) Тогда
	     Возврат Неопределено;
	КонецЕсли; 
	Если Отчет.Адрес="" Тогда
	    Возврат Неопределено;
	КонецЕсли; 
	Хран=ПолучитьИзВременногоХранилища(Отчет.Адрес);
	//ТабДанные=ХранилищеОбщихНастроек.Загрузить("АК_ТабДанныеИзб");
	Если Хран=Неопределено Тогда
	    Возврат Неопределено;
	КонецЕсли;                         
	ТабДанные=Хран.Получить();
	Если ТабДанные=Неопределено Тогда
	    Возврат Неопределено;
	КонецЕсли;   	
	//ОтбГрупп=Отчет.НастройкаГруппировки[НомСтр-1].Представление;	
	
	МасБезПересчетаСКонтрПересчетом=Новый Массив;
	Для каждого Стр Из ТабДанные Цикл
		Если Стр.ПриемкаТовараБезПересчета=Истина И
		 (Стр.ПриемкаВМагазинеБезПересчета=2 ИЛИ Стр.ПриемкаВМагазинеБезПересчета=-2) Тогда
			Если МасБезПересчетаСКонтрПересчетом.Найти(Стр.ТорговаяТочка)=Неопределено Тогда
				МасБезПересчетаСКонтрПересчетом.Добавить(Стр.ТорговаяТочка);
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла; 
	
	МасБезПересчета=Новый Массив;
	ТабДанные1=ТабДанные.Скопировать();
	Кол=ТабДанные1.Количество();
	Для Сч=0 По Кол-1 Цикл
		Если ТабДанные1[Кол-1-Сч].ПриемкаТовараБезПересчета=Истина  Тогда
			Если (МасБезПересчетаСКонтрПересчетом.Найти(ТабДанные1[Кол-1-Сч].ТорговаяТочка)=Неопределено) Тогда
				Если МасБезПересчета.Найти(ТабДанные1[Кол-1-Сч].ТорговаяТочка)=Неопределено Тогда
					МасБезПересчета.Добавить(ТабДанные1[Кол-1-Сч].ТорговаяТочка);
				КонецЕсли; 
				//ТабДанные1.Удалить(Кол-1-Сч);
			КонецЕсли;
		Иначе
		КонецЕсли; 
	КонецЦикла; 
	//ТабДанные=ТабДанные1;
	
	
	ТабДанныеСРасходником=ТабДанные.Скопировать();
	ТабДанные.Свернуть("Дата, ТорговаяТочка", "НехваткаКоробок");
	ТабДанныеСРасходником.Свернуть("Дата, ТорговаяТочка, Расходник,Склад,ПриемкаВМагазинеБезПересчета,ПриемкаТовараБезПересчета", "НехваткаКоробок");
	Группы=Отчет.НастройкаГруппировки.Выгрузить();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Группы.Представление,
		|	Группы.НижняяГраница,
		|	Группы.ВерхняяГраница
		|ПОМЕСТИТЬ втГруппы
		|ИЗ
		|	&Группы КАК Группы
		|ГДЕ
		|	Группы.Представление = &Представление
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабДанные.Дата,
		|	ТабДанные.ТорговаяТочка,
		|	ТабДанные.НехваткаКоробок
		|ПОМЕСТИТЬ втТабДанные
		|ИЗ
		|	&ТабДанные КАК ТабДанные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабДанныеСРасходником.Дата,
		|	ТабДанныеСРасходником.ТорговаяТочка,
		|	ТабДанныеСРасходником.Расходник,
		|	ТабДанныеСРасходником.Склад,
		|	ТабДанныеСРасходником.НехваткаКоробок,ТабДанныеСРасходником.ПриемкаВМагазинеБезПересчета,ТабДанныеСРасходником.ПриемкаТовараБезПересчета
		|ПОМЕСТИТЬ ТабДанныеСРасходником
		|ИЗ
		|	&ТабДанныеСРасходником КАК ТабДанныеСРасходником
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втГруппы.Представление,
		|	втТабДанные.НехваткаКоробок КАК НехваткаКоробок,
		|	втТабДанные.Дата КАК Дата,
		|	втТабДанные.ТорговаяТочка КАК ТорговаяТочка
		|ПОМЕСТИТЬ втИтогТТ
		|ИЗ
		|	втГруппы КАК втГруппы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втТабДанные КАК втТабДанные
		|		ПО (ВЫБОР
		|				КОГДА втГруппы.НижняяГраница = 0
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ втТабДанные.НехваткаКоробок >= втГруппы.НижняяГраница
		|			КОНЕЦ)
		|			И (ВЫБОР
		|				КОГДА втГруппы.ВерхняяГраница = 0
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ втТабДанные.НехваткаКоробок < втГруппы.ВерхняяГраница
		|			КОНЕЦ)
		|
		|СГРУППИРОВАТЬ ПО
		|	втГруппы.Представление,
		|	втТабДанные.Дата,
		|	втТабДанные.ТорговаяТочка,
		|	втТабДанные.НехваткаКоробок
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втИтогТТ.Представление,
		|	ТабДанныеСРасходником.Дата КАК Дата,
		|	ТабДанныеСРасходником.ТорговаяТочка КАК ТорговаяТочка,
		|	ТабДанныеСРасходником.Расходник,
		|	ТабДанныеСРасходником.Расходник.Склад как Склад,
		|	ТабДанныеСРасходником.Расходник.Сборщик как Сборщик,
		|	ТабДанныеСРасходником.НехваткаКоробок,ТабДанныеСРасходником.ПриемкаВМагазинеБезПересчета,ТабДанныеСРасходником.ПриемкаТовараБезПересчета
		|ИЗ
		|	втИтогТТ КАК втИтогТТ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втГруппы КАК втГруппы
		|		ПО втИтогТТ.Представление = втГруппы.Представление
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТабДанныеСРасходником КАК ТабДанныеСРасходником
		|		ПО втИтогТТ.Дата = ТабДанныеСРасходником.Дата
		|			И втИтогТТ.ТорговаяТочка = ТабДанныеСРасходником.ТорговаяТочка
		|			И (ВЫБОР
		|				КОГДА НЕ втГруппы.НижняяГраница = 0
		|					ТОГДА ТабДанныеСРасходником.НехваткаКоробок <> 0 Иначе Истина
		|			КОНЕЦ)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	ТорговаяТочка";
    Запрос.УстановитьПараметр("ТабДанные",ТабДанные);
    Запрос.УстановитьПараметр("Группы",Группы);
    Запрос.УстановитьПараметр("Представление",ОтбГрупп);
    Запрос.УстановитьПараметр("ТабДанныеСРасходником",ТабДанныеСРасходником);
	ВыбРезультат = Запрос.Выполнить();

	ТЗИтог = ВыбРезультат.Выгрузить();
    СтрукРасшиф=Новый Структура("ТЗИтог",ТЗИтог);
    ХранилищеОбщихНастроек.Сохранить("АК_ТЗИтогИзб",,ТЗИтог);
    ХранилищеОбщихНастроек.Сохранить("МасБезПересчета",,МасБезПересчета);
	Возврат Истина;

	
КонецФункции

&НаСервере
Функция РасшифроватьОтчет1(НомСтр)
	//ТЗИтог=Неопределено;
	//СтрукРасшиф=Неопределено;
	//Данные = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	//
	////ДатаОтчета = Данные.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаОтчета")).Значение.Дата;
	//ДатаОтчета = ТекущаяДата();

	//Поля = ИнфокомТиповыеОтчеты.ПолучитьМассивПолейРасшифровки(Расшифровка, Данные);
	//Если Поля.Количество()=0 Тогда
	//	 Возврат Неопределено;
	//КонецЕсли; 
	//НоменклатураОтбор = Неопределено;
	//СкладОтбор = Неопределено;
	//ХарактеристикаОтбор = Неопределено;
	//ОтбГрупп = Неопределено;
	////ОбОтч=РеквизитФормыВЗначение("Отчет");
	//ОбОтч=Отчеты.АК_ПересортицаПоДнОтгрузкам.Создать();
	//Для Каждого ПолеРасшифровки Из Поля Цикл
	//	Если ТипЗнч(ПолеРасшифровки) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") Тогда
	//		Если ПолеРасшифровки.Поле = "Номенклатура" Тогда
	//			НоменклатураОтбор = ПолеРасшифровки.Значение;
	//		КонецЕсли;
	//		Если ПолеРасшифровки.Поле = "Склад" Тогда
	//			СкладОтбор = ПолеРасшифровки.Значение;
	//		КонецЕсли;
	//		Если ПолеРасшифровки.Поле = "Характеристика" Тогда
	//			ХарактеристикаОтбор = ПолеРасшифровки.Значение;
	//		КонецЕсли;
	//		Если ПолеРасшифровки.Поле = "Дата" Тогда
	//			ДатаОтчета = ПолеРасшифровки.Значение;
	//		КонецЕсли;
	//		Если ПолеРасшифровки.Поле = "Представление" Тогда
	//			ОтбГрупп = ПолеРасшифровки.Значение;
	//		КонецЕсли;
	//	КонецЕсли;	
	//КонецЦикла;
	//Если Не ЗначениеЗаполнено(ОтбГрупп) Тогда
	//	 Возврат Неопределено;
	//КонецЕсли; 
	////ТаблицаДанных = ПолучитьДанныеДляОтчета(ДатаОтчета, НоменклатураОтбор, СкладОтбор);
	//ДатаНачала = '00010101';
	//ДатаКонца = '00010101';
	//НоменклатураОтбор = Неопределено;
	//СкладОтбор = Неопределено;
	//Для Каждого ПользПоле Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
	//	Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
	//		И Строка(ПользПоле.Параметр) = "Период" Тогда
	//		ДатаНачала = ПользПоле.Значение.ДатаНачала;
	//		ДатаКонца = ПользПоле.Значение.ДатаОкончания;
	//	КонецЕсли;
	//	Если ТипЗнч(ПользПоле) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
	//		Если ТипЗнч(ПользПоле.ПравоеЗначение) = Тип("СправочникСсылка.Номенклатура")
	//			И ПользПоле.Использование = Истина
	//			И ПользПоле.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
	//			И ЗначениеЗаполнено(ПользПоле.ПравоеЗначение)
	//			И НЕ ПользПоле.ПравоеЗначение.ЭтоГруппа Тогда
	//			НоменклатураОтбор = ПользПоле.ПравоеЗначение;
	//		КонецЕсли;	
	//		Если ТипЗнч(ПользПоле.ПравоеЗначение) = Тип("СправочникСсылка.Склады")
	//			И ПользПоле.Использование = Истина
	//			И ПользПоле.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
	//			И ЗначениеЗаполнено(ПользПоле.ПравоеЗначение) Тогда
	//			СкладОтбор = ПользПоле.ПравоеЗначение;
	//		КонецЕсли;	
	//	КонецЕсли;	
	//КонецЦикла;
	//
	//ПервыйПроход = Истина;
	//Пока ДатаКонца >= ДатаНачала Цикл
	//	Если ПервыйПроход Тогда
	//		ТабДанные = ОбОтч.ПолучитьДанныеДляОтчета(ДатаНачала, НоменклатураОтбор, СкладОтбор, Истина);
	//	Иначе
	//		ТабВрем = ОбОтч.ПолучитьДанныеДляОтчета(ДатаНачала, НоменклатураОтбор, СкладОтбор, Истина);
	//		Для Каждого СтрокаТаб Из ТабВрем Цикл
	//			ЗаполнитьЗначенияСвойств(ТабДанные.Добавить(), СтрокаТаб);
	//		КонецЦикла;	
	//	КонецЕсли;	
	//	ПервыйПроход = Ложь;
	//	ДатаНачала = ДатаНачала + 86400;
	//КонецЦикла;
	//ТабДанные.Свернуть("Дата, ТорговаяТочка,Склад,Расходник", "НехваткаКоробок, ПолучилаТТКоробок");
	//Для каждого Стр Из ТабДанные Цикл
	//	КолПересортВодитель=?(Стр.Расходник.КоличествоКоробокПоДаннымВодителя-Стр.ПолучилаТТКоробок>0,Стр.Расходник.КоличествоКоробокПоДаннымВодителя-Стр.ПолучилаТТКоробок,-Стр.Расходник.КоличествоКоробокПоДаннымВодителя+Стр.ПолучилаТТКоробок);
	//	Стр.НехваткаКоробок=?(ЗначениеЗаполнено(Стр.Расходник.КоличествоКоробокПоДаннымВодителя),Макс(Стр.Расходник.КоличествоКоробокПоДаннымВодителя,КолПересортВодитель),Стр.НехваткаКоробок);
	//КонецЦикла;
	Если Отчет.Адрес="" Тогда
	    Возврат Неопределено;
	КонецЕсли; 
	Хран=ПолучитьИзВременногоХранилища(Отчет.Адрес);
	//ТабДанные=ХранилищеОбщихНастроек.Загрузить("АК_ТабДанныеИзб");
	Если Хран=Неопределено Тогда
	    Возврат Неопределено;
	КонецЕсли;                         
	ТабДанные=Хран.Получить();
	Если ТабДанные=Неопределено Тогда
	    Возврат Неопределено;
	КонецЕсли;   	
	ОтбГрупп=Отчет.НастройкаГруппировки[НомСтр-1].Представление;	
	ТабДанныеСРасходником=ТабДанные.Скопировать();
	ТабДанные.Свернуть("Дата, ТорговаяТочка", "НехваткаКоробок");
	ТабДанныеСРасходником.Свернуть("Дата, ТорговаяТочка, Расходник,Склад", "НехваткаКоробок");
	Группы=Отчет.НастройкаГруппировки.Выгрузить();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Группы.Представление,
		|	Группы.НижняяГраница,
		|	Группы.ВерхняяГраница
		|ПОМЕСТИТЬ втГруппы
		|ИЗ
		|	&Группы КАК Группы
		|ГДЕ
		|	Группы.Представление = &Представление
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабДанные.Дата,
		|	ТабДанные.ТорговаяТочка,
		|	ТабДанные.НехваткаКоробок
		|ПОМЕСТИТЬ втТабДанные
		|ИЗ
		|	&ТабДанные КАК ТабДанные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТабДанныеСРасходником.Дата,
		|	ТабДанныеСРасходником.ТорговаяТочка,
		|	ТабДанныеСРасходником.Расходник,
		|	ТабДанныеСРасходником.Склад,
		|	ТабДанныеСРасходником.НехваткаКоробок
		|ПОМЕСТИТЬ ТабДанныеСРасходником
		|ИЗ
		|	&ТабДанныеСРасходником КАК ТабДанныеСРасходником
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втГруппы.Представление,
		|	втТабДанные.НехваткаКоробок КАК НехваткаКоробок,
		|	втТабДанные.Дата КАК Дата,
		|	втТабДанные.ТорговаяТочка КАК ТорговаяТочка
		|ПОМЕСТИТЬ втИтогТТ
		|ИЗ
		|	втГруппы КАК втГруппы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втТабДанные КАК втТабДанные
		|		ПО (ВЫБОР
		|				КОГДА втГруппы.НижняяГраница = 0
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ втТабДанные.НехваткаКоробок >= втГруппы.НижняяГраница
		|			КОНЕЦ)
		|			И (ВЫБОР
		|				КОГДА втГруппы.ВерхняяГраница = 0
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ втТабДанные.НехваткаКоробок < втГруппы.ВерхняяГраница
		|			КОНЕЦ)
		|
		|СГРУППИРОВАТЬ ПО
		|	втГруппы.Представление,
		|	втТабДанные.Дата,
		|	втТабДанные.ТорговаяТочка,
		|	втТабДанные.НехваткаКоробок
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втИтогТТ.Представление,
		|	ТабДанныеСРасходником.Дата КАК Дата,
		|	ТабДанныеСРасходником.ТорговаяТочка КАК ТорговаяТочка,
		|	ТабДанныеСРасходником.Расходник,
		|	ТабДанныеСРасходником.Расходник.Склад как Склад,
		|	ТабДанныеСРасходником.Расходник.Сборщик как Сборщик,
		|	ТабДанныеСРасходником.НехваткаКоробок
		|ИЗ
		|	втИтогТТ КАК втИтогТТ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втГруппы КАК втГруппы
		|		ПО втИтогТТ.Представление = втГруппы.Представление
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТабДанныеСРасходником КАК ТабДанныеСРасходником
		|		ПО втИтогТТ.Дата = ТабДанныеСРасходником.Дата
		|			И втИтогТТ.ТорговаяТочка = ТабДанныеСРасходником.ТорговаяТочка
		|			И (ВЫБОР
		|				КОГДА НЕ втГруппы.НижняяГраница = 0
		|					ТОГДА ТабДанныеСРасходником.НехваткаКоробок <> 0 Иначе Истина
		|			КОНЕЦ)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	ТорговаяТочка";
    Запрос.УстановитьПараметр("ТабДанные",ТабДанные);
    Запрос.УстановитьПараметр("Группы",Группы);
    Запрос.УстановитьПараметр("Представление",ОтбГрупп);
    Запрос.УстановитьПараметр("ТабДанныеСРасходником",ТабДанныеСРасходником);
	ВыбРезультат = Запрос.Выполнить();

	ТЗИтог = ВыбРезультат.Выгрузить();
    СтрукРасшиф=Новый Структура("ТЗИтог",ТЗИтог);
    ХранилищеОбщихНастроек.Сохранить("АК_ТЗИтогИзб",,ТЗИтог);
	
	Возврат Истина;
	
	//
	//Макет = ОбОтч.ПолучитьМакет("Расшифровка");
	//ТабДок = Новый ТабличныйДокумент();
	//
	//Область = Макет.ПолучитьОбласть("Шапка");
	//ТабДок.Вывести(Область);
	//Для каждого СтрокаДанных Из ТЗИтог Цикл
	//	Область = Макет.ПолучитьОбласть("Строка");
	//	Область.Параметры.Заполнить(СтрокаДанных);
	//	ТабДок.Вывести(Область);
	//КонецЦикла; 
	
	//Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
	//	Если ЗначениеЗаполнено(СкладОтбор)
	//		И СтрокаДанных.Склад <> СкладОтбор Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(НоменклатураОтбор)
	//		И СтрокаДанных.Номенклатура <> НоменклатураОтбор Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(ХарактеристикаОтбор)
	//		И СтрокаДанных.Характеристика <> ХарактеристикаОтбор Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	Область = Макет.ПолучитьОбласть("Строка");
	//	Область.Параметры.Заполнить(СтрокаДанных);
	//	ТабДок.Вывести(Область);
	//КонецЦикла;	
	
	//Возврат ТабДок;
	
КонецФункции


&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	СохранитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()
	ТЗНастройки=Отчет.НастройкаГруппировки.Выгрузить();
    ХранилищеОбщихНастроек.Сохранить("НастройкиОтчетаПересортПоОтгрузкам",,ТЗНастройки);
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТЗНастройки=ХранилищеОбщихНастроек.Загрузить("НастройкиОтчетаПересортПоОтгрузкам");
	Если Не ТЗНастройки=Неопределено Тогда
	    Отчет.НастройкаГруппировки.Загрузить(ТЗНастройки);
	КонецЕсли;
	Если Отчет.НастройкаГруппировки.Количество()=0 Тогда
	     СтрНов=Отчет.НастройкаГруппировки.Добавить();
		 СтрНов.Представление="0";
	     СтрНов.НижняяГраница=0;
	     СтрНов.ВерхняяГраница=1;
	     СтрНов=Отчет.НастройкаГруппировки.Добавить();
		 СтрНов.Представление="1";
	     СтрНов.НижняяГраница=1;
	     СтрНов.ВерхняяГраница=2;
	     СтрНов=Отчет.НастройкаГруппировки.Добавить();
		 СтрНов.Представление="2-3";
	     СтрНов.НижняяГраница=2;
	     СтрНов.ВерхняяГраница=4;
	     СтрНов=Отчет.НастройкаГруппировки.Добавить();
		 СтрНов.Представление="4-10";
	     СтрНов.НижняяГраница=4;
	     СтрНов.ВерхняяГраница=11;
	     СтрНов=Отчет.НастройкаГруппировки.Добавить();
		 СтрНов.Представление=">10";
	     СтрНов.НижняяГраница=11;
	     СтрНов.ВерхняяГраница=0;
		 
		 
	КонецЕсли; 
КонецПроцедуры


&НаКлиенте
Процедура РезультатВыбор(Элемент, Область, СтандартнаяОбработка)
	//СтандартнаяОбработка = Ложь;
	//Высота=Результат.ВысотаТаблицы-1;
	//Кол=Отчет.НастройкаГруппировки.Количество();
	//Отсчет=Высота-Кол;
	//НомСтр=Элементы.Результат.ТекущаяОбласть.Верх-Отсчет;
	//Если НомСтр<1 Тогда
	//   Возврат;
	//   КонецЕсли;
	//Если НомСтр>Кол Тогда
	//   Возврат;
	//   КонецЕсли;
	//СтрукРасшиф=РасшифроватьОтчет1(НомСтр);
	//Если Не СтрукРасшиф=Неопределено Тогда
	//	ОткрытьФорму(ПолучитьПолноеИмяФормы("ФормаРасшифровки"));
	//КонецЕсли; 
	
КонецПроцедуры
 
