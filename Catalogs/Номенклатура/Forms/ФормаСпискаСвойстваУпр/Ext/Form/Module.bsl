﻿
Процедура ДобавитьРеквизитыСвойствНаФорму()
	
	Перем Запрос, РезультатЗапроса, МассивРеквизитовФормы;
	
	// получение списка свойств для справочника номенклатуры
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СвойстваОбъектов.Ссылка КАК Ссылка,
	|	СвойстваОбъектов.ТипЗначения,
	|	СвойстваОбъектов.Код КАК Код,
	|	СвойстваОбъектов.Наименование КАК Наименование
	|ИЗ
	|	ПланВидовХарактеристик.СвойстваОбъектов КАК СвойстваОбъектов
	|ГДЕ
	|	СвойстваОбъектов.НазначениеСвойства = ЗНАЧЕНИЕ(ПланВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура)
	|	И НЕ СвойстваОбъектов.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	МассивРеквизитовФормы = Новый Массив;
	ПутьКРеквизиту = "ДеревоНоменклатуры";
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекИмяРеквизита = "СвойстваПоле" + СокрЛП(Выборка.Код);
		МассивРеквизитовФормы.Добавить(Новый РеквизитФормы(ТекИмяРеквизита,	Выборка.ТипЗначения, ПутьКРеквизиту, Выборка.Наименование));
		
		ЭтаФорма.Параметры.СписокСвойств.Добавить(Выборка.Код);
	КонецЦикла;
	
	
	// добавление новых реквизиты для формы
	ЭтаФорма.ИзменитьРеквизиты(МассивРеквизитовФормы);
	
	
	// вывод элементов формы на форму
	ЭлементФормыРодитель = Элементы.ДеревоНоменклатуры;
	
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		
		ТекИмяРеквизита = ПутьКРеквизиту + "СвойстваПоле" + СокрЛП(Выборка.Код);
		
		Элемент = Элементы.Вставить(ТекИмяРеквизита, Тип("ПолеФормы"), ЭлементФормыРодитель);
		
		//ТекТипЗначения = ТипЗнч(ЭтаФорма[ТекИмяРеквизита]);
		Если Выборка.ТипЗначения = Новый ОписаниеТипов("Булево") Тогда
			Элемент.Вид 				= ВидПоляФормы.ПолеФлажка;
			//Элемент.ПоложениеЗаголовка 	= ПоложениеЗаголовкаЭлементаФормы.Право;
		Иначе
			Элемент.Вид 				= ВидПоляФормы.ПолеВвода;
			Элемент.КнопкаВыбора 		= Истина;
		КонецЕсли;
		Элемент.ПутьКДанным 		= ПутьКРеквизиту + "." + "СвойстваПоле" + СокрЛП(Выборка.Код);
		
		Элемент.УстановитьДействие("ПриИзменении", "Подключаемая_СвойствоПриИзменении");
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьДерево()
	
	Перем Запрос, РезультатЗапроса;
	
	СтрокаВыборки 		= "";
	СтрокаСоединений 	= "";
	
	Запрос = Новый Запрос;
	
	мСписокСвойств = ЭтаФорма.Параметры.СписокСвойств;
	Для Каждого ЭлементСписка Из мСписокСвойств Цикл
		
		ТекКодСвойства = СокрЛП(ЭлементСписка.Значение);
		СтрокаВыборки 		= СтрокаВыборки + ",
	|	ВТСвойства" + ТекКодСвойства + ".Значение КАК СвойстваПоле" + ТекКодСвойства;
		СтрокаСоединений 	= СтрокаСоединений + "
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТСвойства КАК ВТСвойства" + ТекКодСвойства + "
	|	ПО ВТСвойства" + ТекКодСвойства + ".Объект = СпрНоменклатура.Ссылка
	|	И ВТСвойства" + ТекКодСвойства + ".КодСвойства = """ + ТекКодСвойства + """";
	КонецЦикла;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗначенияСвойствОбъектов.Свойство.Код КАК КодСвойства,
	|	ЗначенияСвойствОбъектов.Объект,
	|	ЗначенияСвойствОбъектов.Значение
	|ПОМЕСТИТЬ ВТСвойства
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|ГДЕ
	|	ЗначенияСвойствОбъектов.Свойство.НазначениеСвойства = ЗНАЧЕНИЕ(ПланВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Номенклатура,
	|	СпрНоменклатура.ПометкаУдаления" + СтрокаВыборки + "
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура" + СтрокаСоединений + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	СпрНоменклатура.Наименование ИЕРАРХИЯ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДеревоЗапроса = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ЗначениеВДанныеФормы(ДеревоЗапроса, ЭтаФорма.ДеревоНоменклатуры);
	
КонецПроцедуры

Процедура ОбновитьЗначенияСвойствНоменклатурыНаФорме(мНоменклатура)
	
	Перем Запрос, РезультатЗапроса, Выборка, ТекИмяРеквизита;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Объект", мНоменклатура);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗначенияСвойствОбъектов.Свойство,
	|	ЗначенияСвойствОбъектов.Значение
	|ПОМЕСТИТЬ ВТЗначения
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|ГДЕ
	|	ЗначенияСвойствОбъектов.Объект = &Объект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СвойстваОбъектов.Код КАК Код,
	|	ЕСТЬNULL(ВТЗначения.Значение, """") КАК Значение
	|ИЗ
	|	ПланВидовХарактеристик.СвойстваОбъектов КАК СвойстваОбъектов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗначения КАК ВТЗначения
	|		ПО (ВТЗначения.Свойство = СвойстваОбъектов.Ссылка)
	|ГДЕ
	|	СвойстваОбъектов.НазначениеСвойства = ЗНАЧЕНИЕ(ПланВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура)
	|	И НЕ СвойстваОбъектов.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	СвойстваОбъектов.Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекИмяРеквизита = "СвойстваПоле" + СокрЛП(Выборка.Код);
		Попытка
			ЭтаФорма[ТекИмяРеквизита] = ?(НЕ Выборка.Значение = "", Выборка.Значение,
											ОбщегоНазначения.ПустоеЗначениеТипа(ТипЗнч(ЭтаФорма[ТекИмяРеквизита])));
		Исключение			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДобавитьРеквизитыСвойствНаФорму();
	
	ЗаполнитьДерево();
		
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ЗаписатьЗначениеСвойствПоКоду(мКод, мНоменклатура, мЗначение)
	
	Перем мСвойствоНоменклатуры, МенеджерЗаписи;
	
	мСвойствоНоменклатуры = ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду(мКод);
	Если НЕ ЗначениеЗаполнено(мСвойствоНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
		
	МенеджерЗаписи = РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Объект 	= мНоменклатура;
	МенеджерЗаписи.Свойство = мСвойствоНоменклатуры;
	МенеджерЗаписи.Значение = мЗначение;
	
	Попытка
		МенеджерЗаписи.Записать();
	Исключение
		Сообщить("Не удалось установить значение свойства для текущей номенклатуры" + Символы.ПС + ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемая_СвойствоПриИзменении(Элемент)
	
	Перем ТекИмяЭлементаФормы, ТекДанныеНоменклатуры;
	
	ПутьКРеквизиту = "ДеревоНоменклатуры";
	
	ТекИмяЭлементаФормы = Элемент.Имя;
	Если НЕ Лев(ТекИмяЭлементаФормы, 30) = "ДеревоНоменклатурыСвойстваПоле" Тогда
		Возврат;
	КонецЕсли;
	
	ТекДанныеНоменклатуры = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	Если ТекДанныеНоменклатуры = Неопределено
			ИЛИ ТекДанныеНоменклатуры.Номенклатура.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьЗначениеСвойствПоКоду(СокрЛП(Сред(ТекИмяЭлементаФормы, 31)), ТекДанныеНоменклатуры.Номенклатура,
			ТекДанныеНоменклатуры[СокрЛП(Сред(ТекИмяЭлементаФормы, 19))]);//ЭтаФорма[ТекИмяЭлементаФормы]);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНоменклатурыПриАктивизацииСтрокиНаКлиенте()
	
	Перем ТекДанные;
	
	ТекДанные = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекДанные.Номенклатура.ЭтоГруппа Тогда
		//Элементы
	КонецЕсли;
	
	//ОбновитьЗначенияСвойствНоменклатурыНаФорме(ТекДанные.Номенклатура);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элемент.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ДеревоНоменклатурыПриАктивизацииСтрокиНаКлиенте", 0.1, Истина);
	
КонецПроцедуры


&НаКлиенте
Процедура НоменклатураСоздатьЭлементСписка(Команда)
	
	Перем ТекРодитель, ТекДанные;
	
	ТекРодитель = "";
	
	ТекДанные = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	Если НЕ ТекДанные = Неопределено Тогда
		ТекНоменклатура = ТекДанные.Номенклатура;
		ТекРодитель 	= ТекНоменклатура.Родитель;
	КонецЕсли;
	
	//+++АК MOSD 2018.11.21 ИП-00019907
	//мФорма = ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлементаУпр");
	мФорма = ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта");
	//---АК MOSD 
	
	Если НЕ ТекРодитель = "" Тогда
		мФорма.Объект.Родитель = ТекРодитель;
	КонецЕсли;
	
	ЗаполнитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураСоздатьГруппу(Команда)
	
	Перем ТекРодитель, ТекДанные;
	
	ТекРодитель = "";
	
	ТекДанные = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	Если НЕ ТекДанные = Неопределено Тогда
		ТекНоменклатура = ТекДанные.Номенклатура;
		ТекРодитель 	= ТекНоменклатура.Родитель;
	КонецЕсли;
	
	мФорма = ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаГруппыУпр");
	
	Если НЕ ТекРодитель = "" Тогда
		мФорма.Объект.Родитель = ТекРодитель;
	КонецЕсли;
	
	ЗаполнитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураСкопироватьЭлементСписка(Команда)
	
	Перем ТекДанные, ТекНоменклатура;
	
	ТекДанные = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекНоменклатура = ТекДанные.Номенклатура;

	//+++АК MOSD 2018.11.21 ИП-00019907
	//мФорма = ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлементаУпр");
	мФорма = ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта");
	//---АК MOSD 
	
	ЗаполнитьЗначенияСвойств(мФорма.Объект, ТекНоменклатура,, "Код");
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураИзменитьТекущийЭлемент(Команда)
	
	Перем ТекДанные;
	
	ТекДанные = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("Ключ", ТекДанные.Номенклатура);
	
	//+++АК MOSD 2018.11.21 ИП-00019907
	//мФорма = ПолучитьФорму("Справочник.Номенклатура.Форма.ФормаЭлементаУпр", СтруктураПараметров);
	мФорма = ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", СтруктураПараметров);
	//---АК MOSD 
	
	мФорма.Открыть();
	 
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПометитьНаУдаление(Команда)
	
	Перем ТекДанные;
	
	ТекДанные = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектНоменклатуры = ТекДанные.Номенклатура.ПолучитьОбъект();
	
	Попытка
		ОбъектНоменклатуры.УстановитьПометкуУдаления(НЕ ОбъектНоменклатуры.ПометкаУдаления);
	Исключение
		
	КонецПопытки;
	
	ЗаполнитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураОбновить(Команда)
	
	ЗаполнитьДерево();
	
КонецПроцедуры
