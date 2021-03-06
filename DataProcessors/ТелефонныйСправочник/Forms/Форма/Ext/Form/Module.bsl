﻿
&НаКлиенте
Процедура ДобавитьНомер(Команда)
	
	ФормаНомера = ПолучитьФорму("Справочник.СлужебныеSIMКарты.ФормаОбъекта");
	ФормаНомера.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТелефоновВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	                                
	Если Элемент.ТекущиеДанные.Вид = "Служебный" Тогда
		СтруктураПараметров = Новый Структура("Ключ", Элемент.ТекущиеДанные.НомерЭлемент);
		ФормаСимКарты = ПолучитьФорму("Справочник.СлужебныеSIMКарты.ФормаОбъекта", СтруктураПараметров); 
		Если ФормаСимКарты.Открыта() Тогда
			ФормаСимКарты.Активизировать();
		Иначе
			ФормаСимКарты.Открыть();
		КонецЕсли;
	Иначе 
		СтруктураПараметров = Новый Структура("Ключ", Элемент.ТекущиеДанные.Объект);
		ФормаФизлица = ПолучитьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", СтруктураПараметров);		
		Если ФормаФизлица.Открыта() Тогда
			ФормаФизлица.Активизировать();
		Иначе
			ФормаФизлица.Открыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СделатьОсновнымНаСервере(Данные)
	
	ТелефоннаяКнига.СделатьОсновным(Данные.НомерЭлемент, Данные.Назначение, Данные.Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьОсновным(Команда)
	
	ТекущиеДанные = Элементы.СписокТелефонов.ТекущиеДанные;
	Если ТекущиеДанные.Основной Тогда
		Сообщить("Это основной номер!");
		Возврат;
	КонецЕсли;

	//
	СделатьОсновнымНаСервере(ТекущиеДанные);

	Элементы.СписокТелефонов.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПривязатьКарту(Команда)
	
	ТекущиеДанные = Элементы.СписокТелефонов.ТекущиеДанные;
	Если ТекущиеДанные.Вид = "Личный" Тогда
		Сообщить("Это личный номер!");
		Возврат;
	КонецЕсли;
	
	//
	ФормаЗаписи = ПолучитьФорму("РегистрСведений.ПривязкаТелефонов.ФормаЗаписи");
	ФормаЗаписи.Запись.Номер 		= ТекущиеДанные.НомерЭлемент;
	ФормаЗаписи.Запись.Назначение 	= ТекущиеДанные.Назначение;
	ФормаЗаписи.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Позвонить(Команда)
	
	ТекДанные = Элементы.СписокТелефонов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	//
	АК_ТелефонияКлиент.Звонить(ТекДанные.НомерТелефона);
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокТелефонов.ТекстЗапроса = Обработки.ТелефонныйСправочник.ПолучитьЗапросПоТелефонам();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭлементыОтбора = СписокТелефонов.Отбор.Элементы;
	Для каждого Элем из ЭлементыОтбора Цикл
		Если Элем.Представление = "Только основные телефоны" Тогда
			Этаформа.ТолькоОсновные 	= Элем.Использование;
		ИначеЕсли Элем.Представление = "Только голосовая связь" Тогда
			Этаформа.ТолькоГолосовая 	= Элем.Использование;
		ИначеЕсли Элем.Представление = "Абонент содержит" Тогда
			Этаформа.Абонент 			= Элем.ПравоеЗначение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Изменена привязка номера" Тогда  
		Элементы.СписокТелефонов.Обновить();		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ТолькоОсновныеПриИзменении(Элемент)
	
	ЭлементыОтбора = СписокТелефонов.Отбор.Элементы;
	Для каждого Элем из ЭлементыОтбора Цикл
		Если Элем.Представление = "Только основные телефоны" Тогда
			Элем.Использование = Этаформа.ТолькоОсновные;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоГолосоваяПриИзменении(Элемент)
	
	ЭлементыОтбора = СписокТелефонов.Отбор.Элементы;
	Для каждого Элем из ЭлементыОтбора Цикл
		Если Элем.Представление = "Только голосовая связь" Тогда
			Элем.Использование = Этаформа.ТолькоГолосовая;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура АбонентПриИзменении(Элемент)
	
	ЭлементыОтбора = СписокТелефонов.Отбор.Элементы;
	Для каждого Элем из ЭлементыОтбора Цикл
		Если Элем.Представление = "Абонент содержит" Тогда
			Элем.ПравоеЗначение = Этаформа.Абонент;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ЭлементыОтбора = СписокТелефонов.Отбор.Элементы;
	Для каждого Элем из ЭлементыОтбора Цикл
		Если Элем.Представление = "Подразделение" Тогда
			Если ЗначениеЗаполнено(ЭтаФорма.Подразделение) Тогда
				Элем.ПравоеЗначение	= ЭтаФорма.Подразделение;
				Элем.Использование	= Истина;
			Иначе
				Элем.Использование	= Ложь;
			КонецЕсли;			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПривязкиПриИзменении(Элемент)
	
	ЭлементыОтбора = СписокТелефонов.Отбор.Элементы;
	Если ЭтаФорма.ВидПривязки = 1 Тогда
		Для каждого Элем из ЭлементыОтбора Цикл
			Если Элем.Представление = "Вид абонента" Тогда
				Элем.Использование	= Ложь;		
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для каждого Элем из ЭлементыОтбора Цикл
			Если Элем.Представление = "Вид абонента" Тогда
				Элем.Использование	= Истина;		
				Элем.ПравоеЗначение = ?(ЭтаФорма.ВидПривязки = 2, "Физлицо", "Подразделение");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;		

КонецПроцедуры


//+++AK BARA #16739
&НаКлиенте
Процедура ОтвязатьТелефон(Команда)
	
	ТекущиеДанные = Элементы.СписокТелефонов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено  Тогда 
		Номер 		= ТекущиеДанные.НомерЭлемент;		
		УдалитьПривязкиТелефона(Номер,ТекущиеДанные.НомерТелефона);	
		Элементы.СписокТелефонов.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьПривязкиТелефона(Номер,НомерТелефона)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОсновныеТелефоны.Привязка КАК Привязка,
	|	ОсновныеТелефоны.Назначение КАК Назначение,
	|	ОсновныеТелефоны.Телефон
	|ИЗ
	|	РегистрСведений.ОсновныеТелефоны КАК ОсновныеТелефоны
	|ГДЕ
	|	ОсновныеТелефоны.Телефон = &Телефон";
	
	Запрос.УстановитьПараметр("Телефон", Номер);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		мзОсновныеТелефоны = РегистрыСведений.ОсновныеТелефоны.СоздатьМенеджерЗаписи();
		мзОсновныеТелефоны.Привязка = Выборка.Привязка  ;
		мзОсновныеТелефоны.Назначение = Выборка.Назначение  ;	
		мзОсновныеТелефоны.Прочитать();
		мзОсновныеТелефоны.Удалить();
	КонецЦикла;
	
	мзПЗ = РегистрыСведений.ПривязкаТелефонов.СоздатьМенеджерЗаписи();
	мзПЗ.Номер = Номер;
	мзПЗ.Период = ТекущаяДата();
	мзПЗ.Записать();
	
	Если ЗначениеЗаполнено(НомерТелефона) Тогда 
		ДлинаНомера = СтрДлина(НомерТелефона); 
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтактнаяИнформация.Объект,
		|	КонтактнаяИнформация.Тип,
		|	КонтактнаяИнформация.Вид
		|ИЗ
		|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	(ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(11))) = &Представление
		|	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)";
		
		Запрос.УстановитьПараметр("Представление", НомерТелефона);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			мзКИ = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
			мзКИ.Объект = Выборка.Объект;
			мзКИ.Тип = Выборка.Тип;
			мзКИ.Вид = Выборка.Вид;
			мзКИ.Прочитать();
			мзКИ.Удалить();
		КонецЦикла;
		
		
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	СтруктурныеЕдиницы.Ссылка
			|ИЗ
			|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
			|ГДЕ
			|	СтруктурныеЕдиницы.ТелефонныйНомер1 = &ТелефонныйНомер1";
			
			Запрос.УстановитьПараметр("ТелефонныйНомер1", Прав(СокрЛП(НомерТелефона), 10));
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				СпрОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
				СпрОбъект.ОбменДанными.Загрузка = Истина;
				СпрОбъект.ТелефонныйНомер1 = "";
				СпрОбъект.Записать();
			КонецЦикла;
	КонецЕсли;

КонецПроцедуры
//---AK BARA #16739

&НаКлиенте
Процедура РедактироватьЕмейл(Команда)
	Если Элементы.СписокТелефонов.ТекущиеДанные<>Неопределено Тогда
		Если ТипЗнч(Элементы.СписокТелефонов.ТекущиеДанные.Объект)=Тип("СправочникСсылка.ФизическиеЛица") Тогда
			Вид=ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailФизЛица");
		ИначеЕсли ТипЗнч(Элементы.СписокТелефонов.ТекущиеДанные.Объект)=Тип("СправочникСсылка.КонтактныеЛицаКонтрагентов") Тогда
			Вид=ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыКонтактногоЛицаКонтрагента");
		ИначеЕсли ТипЗнч(Элементы.СписокТелефонов.ТекущиеДанные.Объект)=Тип("СправочникСсылка.Контрагенты") Тогда
			Вид=ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыКонтрагентаДляОбменаДокументами");
		ИначеЕсли ТипЗнч(Элементы.СписокТелефонов.ТекущиеДанные.Объект)=Тип("СправочникСсылка.Организации") Тогда
			Вид=ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailОрганизации");
		Иначе
			Возврат;
		КонецЕсли; 
		
		СтруктураЗаполнения=Новый Структура("Объект, Тип,Вид",Элементы.СписокТелефонов.ТекущиеДанные.Объект,
		ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты"),
		Вид);		
		ОткрытьФормуЗаписи(СтруктураЗаполнения);
		// ОБНОВИМ динамический список файлы
		Элементы.СписокТелефонов.Обновить();

		// для обновления Реквизитов
		//ЭтаФорма.Прочитать();

		// Обновление данных
		ЭтаФорма.ОбновитьОтображениеДанных();
	КонецЕсли; 
КонецПроцедуры
&НаКлиенте
Процедура ОткрытьФормуЗаписи(СтруктураЗаполнения)
	
	Если Не ЕстьЗапись(СтруктураЗаполнения) Тогда
		СтруктураДанных=Новый Структура("ЗначенияЗаполнения,ОграничитьДоступность",СтруктураЗаполнения,Истина)		
	Иначе
		ЭтотМассив=Новый Массив;
		ЭтотМассив.Добавить(СтруктураЗаполнения);
		КлючЗаписи       =    Новый("РегистрСведенийКлючЗаписи.КонтактнаяИнформация", ЭтотМассив);
		СтруктураДанных=Новый Структура("Ключ,ОграничитьДоступность",КлючЗаписи,Истина)		
	КонецЕсли;
	
	ОткрытьФормуМодально("РегистрСведений.КонтактнаяИнформация.Форма.ФормаЗаписи",СтруктураДанных,ЭтаФорма);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьЗапись(СтруктураЗаполнения)
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	КонтактнаяИнформация.Представление
	               |ИЗ
	               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	               |ГДЕ
	               |	КонтактнаяИнформация.Объект = &Объект
	               |	И КонтактнаяИнформация.Тип = &Тип
	               |	И КонтактнаяИнформация.Вид = &Вид";
	
	Запрос.УстановитьПараметр("Тип", СтруктураЗаполнения.Тип);
	Запрос.УстановитьПараметр("Вид", СтруктураЗаполнения.Вид);
	Запрос.УстановитьПараметр("Объект", СтруктураЗаполнения.Объект);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		//СтруктураЗаполнения.Период=Выборка.Период;
		//СтруктураЗаполнения.Объект=Выборка.Объект;
		Возврат Истина;
	КонецЦикла;
	
	Возврат  Ложь;
КонецФункции

//+++АК PISH 2018.10.15 ИП-00019949^01
&НаКлиенте
Процедура ДобавитьЛичныйНомер(Команда)
	
	ТекущиеДанные = Элементы.СписокТелефонов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено  Тогда 
		
		ФизЛицо = ТекущиеДанные.Объект;
		
		Телефон = "";
		Если ТекущиеДанные.Вид <> "Служебный" Тогда 
			ВремТелефон  = ТекущиеДанные.НомерТелефона;
			Если Лев(ВремТелефон,1) = "8" Тогда 
				Телефон = "+7"+Сред(ВремТелефон,2);
			Иначе 
				Телефон = ВремТелефон;
			КонецЕсли;			
		КонецЕсли;
		
		СтруктураПараметров = Новый Структура("ФизЛицо,Номер",ФизЛицо,Телефон);
		
		ОткрытьФорму("Обработка.ТелефонныйСправочник.Форма.ФормаВводаЛичногоНомера",СтруктураПараметров,ЭтаФорма);
		
	КонецЕсли;

	
КонецПроцедуры
//---АК PISH

//+++АК PISH 2018.10.15 ИП-00019949^01
&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ВыбранноеЗначение = "ЗафиксироватьЛичныйНомер" Тогда 
		Элементы.СписокТелефонов.Обновить();			
	КонецЕсли;
	
КонецПроцедуры
//---АК PISH
