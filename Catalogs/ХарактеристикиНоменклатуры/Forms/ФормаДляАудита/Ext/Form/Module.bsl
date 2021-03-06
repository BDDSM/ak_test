﻿&НаСервере
Функция ЦелМаксимальное(Сумма) Экспорт
	
	Возврат ?(Цел(Сумма) = Сумма, Сумма, Цел(Сумма) + 1);
	
КонецФункции 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	//
	Производитель = Неопределено;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЗначенияСвойствОбъектов.Значение
	                      |ИЗ
	                      |	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	                      |ГДЕ
	                      |	ЗначенияСвойствОбъектов.Объект = &Объект
	                      |	И ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель)");
	
	Запрос.УстановитьПараметр("Объект", Объект.Ссылка);


	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Производитель = Выборка.Значение;
	КонецЕсли;   

	ЭлементОтбора = Жалобы.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Номенклатура");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.ПравоеЗначение   = Объект.Владелец;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбора = Жалобы.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Производитель");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.ПравоеЗначение   = Производитель;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбора = Жалобы.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Примечание");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;

	//
	ЭлементОтбора = Анализы.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Номенклатура");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.ПравоеЗначение   = Объект.Владелец;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбора = Анализы.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ХарактеристикаНоменклатуры");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.ПравоеЗначение   = Объект.Ссылка;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	//
	ЭлементОтбора = ЦеныПоставщиков.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Номенклатура");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.ПравоеЗначение   = Объект.Владелец;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбора = ЦеныПоставщиков.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Характеристика");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.ПравоеЗначение   = Объект.Ссылка;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	// 
	//ОбъемыПродаж.Параметры.УстановитьЗначениеПараметра("Номенклатура", Объект.Владелец);
	//ОбъемыПродаж.Параметры.УстановитьЗначениеПараметра("ВидДвиженияТовара", Перечисления.ВидДвиженияТовараПоЛистуУчета.Продажа);

	//
	ОбновитьHTML();
				
	// 
	УстановитьВидимость();

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()

	
	Если ЗначениеЗаполнено(Параметры.ТипЗадания)  Тогда

		Если Параметры.ТипЗадания <> Перечисления.ТипыЗаданийАудитору.ПоискНовыхПроизводителей Тогда
			Элементы.СтраницаЦеныОбъемы.Видимость = Ложь;
		КонецЕсли; 
		
		Если Параметры.ТипЗадания = Перечисления.ТипыЗаданийАудитору.ПроверитьЭтикетку ИЛИ Параметры.ТипЗадания = Перечисления.ТипыЗаданийАудитору.СоздатьЭтикетку Тогда
			Элементы.СтраницаЖалобы.Видимость = Ложь;
			Элементы.СтраницаСообщения.Видимость = Ложь;
			Элементы.СтраницаАнализы.Видимость = Ложь;
		КонецЕсли; 

		Если Параметры.ТипЗадания <> Перечисления.ТипыЗаданийАудитору.СоздатьЭтикетку Тогда
			Элементы.КоманднаяПанельМакеты.Видимость = Ложь;
		КонецЕсли; 
	
	КонецЕсли; 

КонецПроцедуры 

&НаСервере
Процедура ОбновитьHTML()
	
	ТаблицаКартинокИзБазы.Очистить();

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	НоменклатураЭтикетки.ИмяФайла,
	                      |	НоменклатураЭтикетки.Комментарий
	                      |ИЗ
	                      |	Справочник.Номенклатура.Этикетки КАК НоменклатураЭтикетки
	                      |ГДЕ
	                      |	НоменклатураЭтикетки.Характеристика = &Характеристика
	                      |	И НоменклатураЭтикетки.Ссылка = &Номенклатура
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	НоменклатураЭтикетки.НомерСтроки");
	
	Запрос.УстановитьПараметр("Характеристика", Объект.Ссылка); 

	Запрос.УстановитьПараметр("Номенклатура", Объект.Владелец); 

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		Файл = Новый Файл(Выборка.ИмяФайла);
		
		Если НЕ Файл.Существует() Тогда
			Продолжить;
		Иначе
			НоваяСтрока = ТаблицаКартинокИзБазы.Добавить();
			НоваяСтрока.ИмяФайла = Выборка.ИмяФайла;
			НоваяСтрока.Комментарий = Выборка.Комментарий;
		КонецЕсли;	
	КонецЦикла;

	// 
	ТаблицаКартинокИзМагазина.Очистить();
	
	КаталогФотографий = СокрЛП(Константы.МП_КаталогХраненияФайловЗадачМП.Получить());

	Если Прав(КаталогФотографий, 1) <> "\" Тогда
		КаталогФотографий = КаталогФотографий + "\";
	КонецЕсли;

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ИнвентаризацияУпаковки.ОтносительноеИмяФайла КАК ИмяФайла,
	                      |	ИнвентаризацияУпаковки.Дата,
	                      |	ИнвентаризацияУпаковки.Магазин
	                      |ИЗ
	                      |	Документ.ИнвентаризацияУпаковки КАК ИнвентаризацияУпаковки
	                      |ГДЕ
	                      |	НЕ ИнвентаризацияУпаковки.ПометкаУдаления
	                      |	И ИнвентаризацияУпаковки.ХарактеристикаНоменклатуры = &Характеристика
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ИнвентаризацияУпаковки.Дата");
	
	Запрос.УстановитьПараметр("Характеристика", Объект.Ссылка); 

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		Файл = Новый Файл(КаталогФотографий+Выборка.ИмяФайла);
		
		Если ПустаяСтрока(Выборка.ИмяФайла) Тогда
			Продолжить;
		КонецЕсли;

		Попытка 
			Если  НЕ Файл.Существует() Тогда
				Продолжить;
			КонецЕсли;

		Исключение
						
		КонецПопытки; 

		Если НЕ Файл.Существует() Тогда 
		Иначе
			НоваяСтрока = ТаблицаКартинокИзМагазина.Добавить();
			НоваяСтрока.ИмяФайла = КаталогФотографий+Выборка.ИмяФайла;
			НоваяСтрока.Комментарий = Формат(Выборка.Дата, "ДФ=dd.MM.yyyy") + ". " + Выборка.Магазин;
		КонецЕсли;	
	КонецЦикла;

	////
	ТаблицаСертификатов.Очистить();

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СертификатыНаПродукцию.Характеристика,
	                      |	МАКСИМУМ(СертификатыНаПродукцию.Период) КАК Период
	                      |ПОМЕСТИТЬ ВТ_ПоследниеПериоды
	                      |ИЗ
	                      |	РегистрСведений.СертификатыНаПродукцию.СрезПоследних КАК СертификатыНаПродукцию
	                      |ГДЕ
	                      |	СертификатыНаПродукцию.Характеристика = &Характеристика
	                      |	И СертификатыНаПродукцию.Удален = ЛОЖЬ
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	СертификатыНаПродукцию.Характеристика
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СертификатыНаПродукцию.ХранилищеИменФайловСертификата,
	                      |	СертификатыНаПродукцию.РегистрационныйНомер,
	                      |	СертификатыНаПродукцию.ДействуетДо
	                      |ИЗ
	                      |	РегистрСведений.СертификатыНаПродукцию КАК СертификатыНаПродукцию
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПоследниеПериоды КАК ВТ_ПоследниеПериоды
	                      |		ПО СертификатыНаПродукцию.Характеристика = ВТ_ПоследниеПериоды.Характеристика
	                      |			И СертификатыНаПродукцию.Период = ВТ_ПоследниеПериоды.Период");
	
	Запрос.УстановитьПараметр("Характеристика", Объект.Ссылка); 

	//ИмяФайлаСертификата = "";
	//Сертификат = Неопределено;
	//Элементы.Сертификат.ТекстНевыбраннойКартинки = "";

	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ИменаФайлов = Выборка.ХранилищеИменФайловСертификата.Получить();;

		Если ИменаФайлов<>Неопределено Тогда
			ТаблицаСертификатов.Загрузить(ИменаФайлов.Скопировать(, "ИмяФайла"));
		КонецЕсли; 
		
		Для Каждого Строка Из ТаблицаСертификатов Цикл
			Строка.Комментарий = "Рег. номер: " + Выборка.РегистрационныйНомер + ". Действует до: " + Формат(Выборка.ДействуетДо, "ДФ=dd.MM.yyyy");
		КонецЦикла;  
	КонецЕсли; 
	
	//
	ТаблицаКартинокСообщений.Очистить();
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СообщениеМОСКартинки.Ссылка,
	                      |	СообщениеМОСКартинки.КлючСтроки,
	                      |	СообщениеМОСКартинки.Расширение,
	                      |	СообщениеМОСКартинки.Ссылка.ТекстСообщения КАК Комментарий,
	                      |	СообщениеМОСКартинки.Ссылка.Дата
	                      |ИЗ
	                      |	Документ.СообщениеМОС.Картинки КАК СообщениеМОСКартинки
	                      |ГДЕ
	                      |	СообщениеМОСКартинки.Ссылка.Товар = &Товар
	                      |	И СообщениеМОСКартинки.Ссылка.Производитель = &Производитель
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	СообщениеМОСКартинки.Ссылка.Дата,
	                      |	СообщениеМОСКартинки.НомерСтроки");
	
	Запрос.УстановитьПараметр("Товар", Объект.Владелец);
	Запрос.УстановитьПараметр("Производитель", Производитель);
	
	КаталогКЗаписи = Константы.КаталогХраненияФайловКартинок.Получить();	
	
	Если Прав(КаталогКЗаписи, 1) <> "\" Тогда
		КаталогКЗаписи = КаталогКЗаписи + "\";
	КонецЕсли;	

	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТаблицаКартинокСообщений.Добавить();
		НоваяСтрока.ИмяФайла = КаталогКЗаписи + Строка(Выборка.Ссылка.УникальныйИдентификатор()) + "_" + Строка(Выборка.КлючСтроки) + ?(Лев(Выборка.Расширение, 1) = ".", "", ".") + Выборка.Расширение;
		НоваяСтрока.Комментарий = Формат(Выборка.Дата, "ДФ=dd.MM.yyyy") + ". " + Выборка.Комментарий;
	КонецЦикла;   
	
	//
	ЭтикеткиИзБазыHTML = ПолучитьHTMLПоТаблицеКартинок(ТаблицаКартинокИзБазы);
	ЭтикеткиИзМагазинаHTML = ПолучитьHTMLПоТаблицеКартинок(ТаблицаКартинокИзМагазина);
	СертификатыHTML = ПолучитьHTMLПоТаблицеКартинок(ТаблицаСертификатов);
	СообщенияHTML = ПолучитьHTMLПоТаблицеКартинок(ТаблицаКартинокСообщений);

КонецПроцедуры

&НаСервере
Функция ПолучитьHTMLПоТаблицеКартинок(ТаблицаКартинок)

	КартинокВСтроке = 8;

	ПолныйТекстHTML = "
		|<html><body>
		|<table name = ""PictView"">";

	Для НомерСтроки = 1 По ЦелМаксимальное(ТаблицаКартинок.Количество()/КартинокВСтроке) Цикл
		ПолныйТекстHTML = ПолныйТекстHTML + "
			|<tr>";
		Для НомерКолонки = 1 По КартинокВСтроке Цикл
			ИндексСтрокиКартики = (НомерСтроки-1) * КартинокВСтроке + НомерКолонки - 1;
			Если ИндексСтрокиКартики = ТаблицаКартинок.Количество() Тогда
				Прервать;
			КонецЕсли; 
			ИмяФайла = ТаблицаКартинок[ИндексСтрокиКартики].ИмяФайла;
			ПолныйТекстHTML = ПолныйТекстHTML+ "
			|<td><table id=""" + ИндексСтрокиКартики + "_T" + """ border=""2"" cellpadding=""0"" bordercolor=#ffffff cellspacing=""0""><tr><td><img name=""picture"" width = 125 height=125 style = ""cursor: pointer"" id = """  + ИндексСтрокиКартики  + """ src = ""file:///" + СтрЗаменить(ИмяФайла, "\", "/") + """></td></tr></table></td>";
		КонецЦикла;	
		ПолныйТекстHTML = ПолныйТекстHTML + "
			|</tr>";
	КонецЦикла;	

	ПолныйТекстHTML = ПолныйТекстHTML + "</body></html>";

	Возврат ПолныйТекстHTML;

КонецФункции

&НаКлиенте
Процедура ЭтикеткиHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Если Элемент.Имя = "ЭтикеткиИзБазыHTML" Тогда
		ТаблицаКартинок = ТаблицаКартинокИзБазы;
	ИначеЕсли Элемент.Имя = "ЭтикеткиИзМагазинаHTML" Тогда
		ТаблицаКартинок = ТаблицаКартинокИзМагазина;
	ИначеЕсли Элемент.Имя = "СертификатыHTML" Тогда
		ТаблицаКартинок = ТаблицаСертификатов;
	ИначеЕсли Элемент.Имя = "СообщенияHTML" Тогда
		ТаблицаКартинок = ТаблицаКартинокСообщений;
	КонецЕсли; 

	Попытка 
		
		Если ДанныеСобытия.Element.name = "picture" Тогда
			ИндексСтроки = Число(ДанныеСобытия.Element.id);

			Картинка = Новый Картинка(ТаблицаКартинок[ИндексСтроки].ИмяФайла);
			Комментарий = ТаблицаКартинок[ИндексСтроки].Комментарий;
			АдресКартинки = ПоместитьВоВременноеХранилище(Картинка, УникальныйИдентификатор);
			ПараметрыФормы = Новый Структура("КартинкаСсылка, Комментарий", АдресКартинки, Комментарий); 
			
			ОткрытьФорму("ОбщаяФорма.Фото", ПараметрыФормы);
		КонецЕсли;

	Исключение
	КонецПопытки; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьМакет(Команда)
	
	//ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);

	//Если ДиалогВыбора.Выбрать() Тогда
	//	Элементы.Этикетки.ТекущиеДанные.ИмяФайла = ДиалогВыбора.ПолноеИмяФайла;
	//КонецЕсли;	

	АдресВременногоХранилища = "";
	ВыбранноеИмяФайла = "";

	Если  ПоместитьФайл(АдресВременногоХранилища, , ВыбранноеИмяФайла) Тогда
		Комментарий = "";
		ВвестиСтроку(Комментарий, "Введите комментарий");
		Файл = Новый Файл(ВыбранноеИмяФайла);
		ДобавитьМакетНаСервере(АдресВременногоХранилища, Файл.ИмяБезРасширения, Файл.Расширение, Комментарий);
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура 	ДобавитьМакетНаСервере(АдресВременногоХранилища, ИмяБезРасширения, Расширение, Комментарий)

	ИмяБезРасширенияНаСервере = "\\10.0.0.40\YandexDisk\YandexDisk\Новая папка\" + ИмяБезРасширения;

	ИмяФайлаНаСервере = ИмяБезРасширенияНаСервере + Расширение;
	Файл = Новый Файл(ИмяФайлаНаСервере);
	
 	Сч = 1;
	Пока Файл.Существует() Цикл
		ИмяФайлаНаСервере = ИмяБезРасширенияНаСервере + "_" + Сч  + Расширение;
		Файл = Новый Файл(ИмяФайлаНаСервере);
		Сч = Сч+1;
	КонецЦикла;  	

	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);	

	Попытка 
		ДвоичныеДанные.Записать(ИмяФайлаНаСервере);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки; 

	НоменклатураОбъект = Объект.Владелец.ПолучитьОбъект();

	НоваяСтрока = НоменклатураОбъект.Этикетки.Добавить();
	
	НоваяСтрока.Характеристика = Объект.Ссылка;
	НоваяСтрока.ИмяФайла = ИмяФайлаНаСервере;
	НоваяСтрока.Комментарий = Комментарий;
	Попытка 
		НоменклатураОбъект.Записать();
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки; 

	ОбновитьHTML();

КонецПроцедуры 

&НаКлиенте
Процедура ПрочитатьПродажи(Команда)
	
	ПрочитатьПродажиСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПродажиСервер()
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	//ДатаНачала = Дата(2000,1,1);
	//ДатаОкончания = ТекущаяДата();
	id_tov = Объект.Владелец.id_tov;
	id_kontr = Производитель.ИД;
	
	//ТекстЗапроса = "declare @date1 as date = " + ВнешниеДанные.ФорматПоля(ДатаНачала, Истина) + ", @date2 as date = " + ВнешниеДанные.ФорматПоля(ДатаОкончания, Истина) + ", @id_tov as int = " + id_tov +", @id_kontr as int = " + id_kontr; 
	
	ТекстЗапроса = "declare @id_tov as int = " + Формат(id_tov, "ЧГ=") +", @id_kontr as int = " + Формат(id_kontr, "ЧГ="); 
	
	ТекстЗапроса = ТекстЗапроса + Символы.ПС + Справочники.ХарактеристикиНоменклатуры.ПолучитьМакет("ТекстЗапросаПродажи").ПолучитьТекст();
		
	rs = ADOСоединение.Execute(ТекстЗапроса);
	
	Пока rs <> Неопределено И rs.Fields.Count <= 0 Цикл
		rs=rs.NextRecordSet();
	КонецЦикла;

	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			НоваяСтрока = ОбъемыПродаж.Добавить();
			
			НоваяСтрока.ПериодС = Rs.Fields("ned").Value;
			НоваяСтрока.ПериодПо = КонецНедели(НоваяСтрока.ПериодС);
			НоваяСтрока.Количество = Rs.Fields("Qty").Value;

			rs.MoveNext();
		КонецЦикла;
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;

	
КонецПроцедуры 



