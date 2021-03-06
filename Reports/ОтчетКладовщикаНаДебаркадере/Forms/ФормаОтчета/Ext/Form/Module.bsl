﻿
&НаКлиенте
Процедура Сформировать()
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Сообщить(НСтр("ru = 'Выберите организацию'"));
		Возврат;
	КонецЕсли; 
	Если Элементы.Маршруты.ТекущиеДанные=Неопределено Тогда
		СформироватьСервер();
	Иначе	
		СформироватьСерверСТекСтрокой();
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура СформироватьСерверСТекСтрокой()
  	ТЗ=Отчеты.ОтчетКладовщикаНаДебаркадере.СформироватьОтчет(Период.ДатаНачала,КонецДня(Период.ДатаОкончания),Склад,ОтборСтатус,Организация.Код);
	Если ЗначениеЗаполнено(ТекМаршрут) Тогда
		Сч=-1;
		Инд=-1;
		Для каждого Стр Из ТЗ Цикл
			Сч=Сч+1;
			Если Стр.Маршрут=ТекМаршрут Тогда
				Инд=Сч;
				Прервать;
			КонецЕсли; 
		КонецЦикла; 
		Если Инд>=0 Тогда
		    СтрокаВыгруженнойТаблицы = ТЗ.Получить(Инд);
			
		    ИндексСтрокиПослеСортировки = ТЗ.Индекс(СтрокаВыгруженнойТаблицы);
		    
		    Отчет.Маршруты.Загрузить(ТЗ);
		    
		    СтрокаКоллекции = Отчет.Маршруты.Получить(ИндексСтрокиПослеСортировки);
		    Элементы.Маршруты.ТекущаяСтрока = СтрокаКоллекции.ПолучитьИдентификатор();
		Иначе
			Отчет.Маршруты.Очистить();	
			Для каждого Стр Из ТЗ Цикл
				НовСтр=Отчет.Маршруты.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтр,Стр);
			КонецЦикла; 
		КонецЕсли; 
	Иначе
		Отчет.Маршруты.Очистить();	
		Для каждого Стр Из ТЗ Цикл
			НовСтр=Отчет.Маршруты.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр,Стр);
		КонецЦикла; 
	КонецЕсли; 
                                    
КонецПроцедуры    

&НаСервере
Процедура СформироватьСервер()
	//Результат.Очистить();
	ТД=Отчеты.ОтчетКладовщикаНаДебаркадере.СформироватьОтчет(Период.ДатаНачала,КонецДня(Период.ДатаОкончания),Склад,ОтборСтатус,Организация.Код);
	//Результат.Вывести(ТД);
	Отчет.Маршруты.Очистить();	
	Для каждого Стр Из ТД Цикл
		НовСтр=Отчет.Маршруты.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр,Стр);
	КонецЦикла; 
КонецПроцедуры



&НаКлиенте
Процедура МаршрутыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Если ЗначениеЗаполнено(Элементы.Маршруты.ТекущиеДанные.Магазин) Тогда
		Если Элементы.Маршруты.ТекущийЭлемент=Элементы.МаршрутыЗабыт Тогда
			Парам=Новый Структура("ДатаНачала,ДатаОкончания,СкладКод,Магазин,Расщифровка",Период.ДатаНачала,Период.ДатаОкончания,ЗначРекв(Склад,"Код"),Элементы.Маршруты.ТекущиеДанные.Магазин,Истина);
			ОткрытьФорму("Отчет.ОтчетПоЗабытымПаллетам.Форма.ФормаОтчета",Парам,ЭтаФорма,Новый УникальныйИдентификатор);
		Иначе	
			Парам=Новый Структура("ДатаНачала,ДатаОкончания,СкладКод,Магазин,Расщифровка",Период.ДатаНачала,Период.ДатаОкончания,ЗначРекв(Склад,"Код"),Элементы.Маршруты.ТекущиеДанные.Магазин,Истина);
			ОткрытьФорму("Отчет.ОтчетПоПаллетам.Форма.ФормаОтчета",Парам,ЭтаФорма,Новый УникальныйИдентификатор);
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗначРекв(Ссылка,Рекв)
	Возврат Ссылка[Рекв];
КонецФункции // ()

&НаСервереБезКонтекста
Функция СформироватьОтчетПоПаллетамПоМагазину(ДатаНачала,КонецПериода,СкладКод,Магазин)
	Отчет=Отчеты.ОтчетПоПаллетам.Создать();
   
    ДатаНач=Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода");
    ДатаНач.Значение=(ДатаНачала);
    ДатаНач.Использование=истина;
	
    ДатаКон=Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
    ДатаКон.Значение=(КонецДня(КонецПериода));
    ДатаКон.Использование=истина;
	
    ПарамСклад=Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Склад");
    ПарамСклад.Значение=(Справочники.СтруктурныеЕдиницы.НайтиПоКоду(СкладКод));
    ПарамСклад.Использование=истина;
	
    ПарамМаг=Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ТТ");
    ПарамМаг.Значение=(Справочники.СтруктурныеЕдиницы.НайтиПоНаименованию(Магазин));
    ПарамМаг.Использование=истина;	
	
	СхемаКомпоновкиДанных=Отчет.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
    //Из схемы возьмем настройки по умолчанию
   
    //А как здесь передать мои только что установленные настройки?
    Настройки=Отчет.КомпоновщикНастроек.ПолучитьНастройки();
   
    //Помещаем в переменную данные о расшифровке данных
    ДанныеРасшифровки=Новый ДанныеРасшифровкиКомпоновкиДанных;
    //Формируем макет, с помощью компоновщика макета
    КомпоновщикМакета=Новый КомпоновщикМакетаКомпоновкиДанных;
    //Передаем в макет компоновки схему, настройки и данные расшифровки
    МакетКомпоновки=КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
    //Выполним компоновку с помощью процессора компоновки
    ПроцессорКомпоновкиДанных=Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,,ДанныеРасшифровки);
                                                  
    Результат=Новый ТабличныйДокумент;
    ПроцессорВывода=Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
    ПроцессорВывода.УстановитьДокумент(Результат);
    ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);	
	Возврат Результат;	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Период.Вариант=ВариантСтандартногоПериода.Завтра;
	ПодключитьОбработчикОжидания("Сформировать",60);
	Автообновление=Истина;
КонецПроцедуры

&НаКлиенте
Процедура Отборы(Команда)
	Элементы.Группа2.Видимость=Не Элементы.Группа2.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура АвтообновлениеПриИзменении(Элемент)
	Если Автообновление Тогда
		ПодключитьОбработчикОжидания("Сформировать",60);
	Иначе	
		ОтключитьОбработчикОжидания("Сформировать");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура МаршрутыПриАктивизацииСтроки(Элемент)
	Если Элементы.Маршруты.ТекущиеДанные<>Неопределено Тогда
		НомСтр=Элементы.Маршруты.ТекущиеДанные.НомерСтроки-1;
		ТекМаршрут=Элементы.Маршруты.ТекущиеДанные.МаршрутДоп;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииСервер();

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	Отчет.Маршруты.Очистить();
	ТЗКат=Отчеты.ОтчетКладовщикаНаДебаркадере.ПолучитьТабКатегорий(Склад);
	Для каждого Эл Из Элементы.Маршруты.ПодчиненныеЭлементы Цикл
		Для каждого Стр Из ТЗКат Цикл
			Если Найти(Эл.Имя,Стр.Поиск)>0 И НЕ Найти(Эл.Имя,"Статус")>0 Тогда
				Эл.Видимость=Истина;
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла; 

	
	Если НЕ Организация=Справочники.Организации.НайтиПоКоду("000000009") Тогда
		ТЗКат1=Новый ТаблицаЗначений;
		ТЗКат1.Колонки.Добавить("Группа");
		ТЗКат1.Колонки.Добавить("Поиск");
		ТЗКат1.Колонки.Добавить("ПоискДоп");
		
		
		НовСтр=ТЗКат1.Добавить();
		НовСтр.Группа="Тилси";
		НовСтр.Поиск="Тилси";
		НовСтр.ПоискДоп="";
		Для каждого Эл Из Элементы.Маршруты.ПодчиненныеЭлементы Цикл
			ФлСклад=Ложь;
			Для каждого СтрКат Из ТЗКат Цикл
				Если Найти(Эл.Имя,СтрКат.Поиск)>0 И НЕ Найти(Эл.Имя,"Статус")>0  Тогда
					ФлСклад=Истина;
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
			
			Если ФлСклад Тогда
				Фл=Ложь;
				Для каждого СтрКат Из ТЗКат Цикл
					Если Найти(Эл.Имя,СтрКат.Поиск)>0 И (СтрКат.Склад=Склад ИЛИ Не ЗначениеЗаполнено(СтрКат.Склад)) Тогда
						Фл=Истина;
						Прервать;
					КонецЕсли; 
				КонецЦикла; 
				Если Не Фл Тогда
					Эл.Видимость=Ложь;
				КонецЕсли; 
			
				
			
			КонецЕсли; 
			
			Для каждого Стр Из ТЗКат1 Цикл
				Если Найти(Эл.Имя,Стр.Поиск)>0 Тогда
					Эл.Видимость=Ложь;
				Иначе
				КонецЕсли; 
			КонецЦикла; 
		КонецЦикла; 
	
	ИначеЕсли Организация=Справочники.Организации.НайтиПоКоду("000000009") Тогда
		ТЗКат.удалить(ТЗКат.Количество()-1);
		Для каждого Эл Из Элементы.Маршруты.ПодчиненныеЭлементы Цикл
			Для каждого Стр Из ТЗКат Цикл
				Если Найти(Эл.Имя,Стр.Поиск)>0 ИЛИ Найти(Эл.Имя,Стр.Группа)>0 Тогда
					Эл.Видимость=Ложь;
				КонецЕсли; 
			КонецЦикла; 
		КонецЦикла; 

		
	КонецЕсли; 
КонецПроцедуры


&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	ОрганизацияПриИзмененииСервер();
КонецПроцедуры


&НаКлиенте
Процедура ПоказатьВТабличномДокументе(Команда)
	ТабДокумент = ПоказатьВТабличномДокументеНаСервере();
	ТабДокумент.Показать();    
КонецПроцедуры

&НаСервере
Функция ПоказатьВТабличномДокументеНаСервере()
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	ТабДокумент.ОтображатьГруппировки = Ложь;
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	ТабДокумент.ОтображатьСетку = Ложь;
	
	Объект = РеквизитФормыВЗначение("Отчет");
	Макет = Объект.ПолучитьМакет("МакетВывода");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");

	ТабДокумент.Вывести(ОбластьШапка);
	
	Для каждого Стр Из Отчет.Маршруты Цикл
		Если Стр.Магазин = "" Тогда 
			ТабДокумент.Вывести(ОбластьПустаяСтрока);
			Продолжить;
		КонецЕсли;
		
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		
		ПокраситьОбласть(Стр, ОбластьСтрока, "ДолгосрокСтатус", "Долгосрок");
		ПокраситьОбласть(Стр, ОбластьСтрока, "ЗаморозкаСтатус", "Заморозка");
		ПокраситьОбласть(Стр, ОбластьСтрока, "ОвощиСтатус", "ОвощиФрукты");
		ПокраситьОбласть(Стр, ОбластьСтрока, "ОхлажденСтатус", "Охлажден");
		ПокраситьОбласть(Стр, ОбластьСтрока, "ХлебСтатус", "Хлеб");
		ПокраситьОбласть(Стр, ОбластьСтрока, "МолочкаСтатус", "Молочка");
		ПокраситьОбласть(Стр, ОбластьСтрока, "СухойСтатус", "Сухой");
		ПокраситьОбласть(Стр, ОбластьСтрока, "МелкоштСтатус", "Мелкошт");
		ПокраситьОбласть(Стр, ОбластьСтрока, "ШтучныйСтатус", "Штучный");
		ПокраситьОбласть(Стр, ОбластьСтрока, "ТилсиСтатус", "Тилси");
		ПокраситьОбласть(Стр, ОбластьСтрока, "КондитерСтатус", "Кондитер");
		ПокраситьОбласть(Стр, ОбластьСтрока, "ДневнойСтатус", "Дневной");
		Значение = Стр.МагазинСтатус;
		Если Значение = 1  Тогда
			ОбластьСтрока.Области.Найти("Магазин").ЦветФона = WebЦвета.Бирюзовый;
		КонецЕсли;
		
		ЗначениеМар = Стр.МаршрутСтатус;
		Если ЗначениеМар = 1  Тогда
			ОбластьСтрока.Области.Найти("Маршрут").ЦветФона = WebЦвета.Желтый;
		ИначеЕсли ЗначениеМар = 1  Тогда
			ОбластьСтрока.Области.Найти("Маршрут").ЦветФона = WebЦвета.Бирюзовый;
		КонецЕсли;

		
		ОбластьСтрока.Параметры.Номер = Стр.Номер;
		ОбластьСтрока.Параметры.Маршрут = Стр.Маршрут;
		ОбластьСтрока.Параметры.Магазин = Стр.Магазин;
		ОбластьСтрока.Параметры.Водитель = Стр.Водитель;
		ОбластьСтрока.Параметры.Долгосрок = Стр.Долгосрок;
		ОбластьСтрока.Параметры.Заморозка = Стр.Заморозка;
		ОбластьСтрока.Параметры.Овощи = Стр.Овощи;
		ОбластьСтрока.Параметры.Охлажден = Стр.Охлажден;
		ОбластьСтрока.Параметры.Хлеб = Стр.Хлеб;
		ОбластьСтрока.Параметры.Молочка = Стр.Молочка;
		ОбластьСтрока.Параметры.Штучный = Стр.Штучный;
		ОбластьСтрока.Параметры.Мелкошт = Стр.Мелкошт;
		ОбластьСтрока.Параметры.Сухой = Стр.Сухой;
		ОбластьСтрока.Параметры.Забыт = Стр.Забыт;
		ОбластьСтрока.Параметры.Кондитер = Стр.Кондитер;
		ОбластьСтрока.Параметры.Дневной = Стр.Дневной;
		ОбластьСтрока.Параметры.Тилси = Стр.Тилси;
		
		
		Если Стр.ВремяВыхода <> Дата(1,1,1) Тогда 
			ОбластьСтрока.Параметры.ВремяВыхода = Формат(Стр.ВремяВыхода,"ДФ=HH:mm" );
		КонецЕсли;
		Если Стр.ДатаПодачиМашины <> Дата(1,1,1) Тогда 
			ОбластьСтрока.Параметры.ДатаПодачиМашины = Стр.ДатаПодачиМашины;
		КонецЕсли;
		Если Стр.ФактВремя <> Дата(1,1,1) Тогда 
			ОбластьСтрока.Параметры.ФактВремя = Стр.ФактВремя;
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции 

&НаСервере
Процедура ПокраситьОбласть(Стр, ОбластьСтрока, Поле, Область)
	    Значение = Стр[Поле];
		Если Значение = 1  Тогда
			ОбластьСтрока.Области.Найти(Область).ЦветФона = WebЦвета.Желтый;
		ИначеЕсли Значение = 2  Тогда
			ОбластьСтрока.Области.Найти(Область).ЦветФона = WebЦвета.БледноЗеленый;
		ИначеЕсли Значение = 3  Тогда
			ОбластьСтрока.Области.Найти(Область).ЦветФона = WebЦвета.Розовый;
		ИначеЕсли Значение = 4  Тогда
			ОбластьСтрока.Области.Найти(Область).ЦветФона = WebЦвета.Бирюзовый;
		КонецЕсли;
КонецПроцедуры // ()


