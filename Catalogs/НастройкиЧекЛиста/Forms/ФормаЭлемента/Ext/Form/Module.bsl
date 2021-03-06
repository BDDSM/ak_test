﻿
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РазвернутьВсеДерево(КоллекцияЭлементов) 
    
    Для Каждого ЭлементКоллекции Из КоллекцияЭлементов Цикл
        Элементы.ОперацииЧекЛистаДерево.Развернуть(ЭлементКоллекции.ПолучитьИдентификатор());
        
        ВложенныеЭлементыКоллекции = ЭлементКоллекции.ПолучитьЭлементы();
        Если (ВложенныеЭлементыКоллекции.Количество() > 0) Тогда
            РазвернутьВсеДерево(ВложенныеЭлементыКоллекции);
        КонецЕсли;
    КонецЦикла;
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОперацииЧекЛиста(ИсходноеДерево)
	
	Для Каждого Стр из ИсходноеДерево.Строки Цикл
		
		Если Стр.Строки.Количество()> 0 и Стр.ОперацияЧекЛиста = Стр.Строки[0].ОперацияЧекЛиста Тогда
			Стр.Строки.Очистить();
		Иначе
			ЗаполнитьОперацииЧекЛиста(Стр);
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьОперацииЧекЛистаДеревоПоУмолчанию()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиЧекЛистаОперацииЧекЛиста.ОперацияЧекЛиста КАК ОперацияЧекЛиста,
	|	НастройкиЧекЛистаОперацииЧекЛиста.Использовать КАК Использовать
	|ПОМЕСТИТЬ ВТ_ТекущаяНастройка
	|ИЗ
	|	Справочник.НастройкиЧекЛиста.ОперацииЧекЛиста КАК НастройкиЧекЛистаОперацииЧекЛиста
	|ГДЕ
	|	НастройкиЧекЛистаОперацииЧекЛиста.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОперацииЧекЛиста.Ссылка КАК ОперацияЧекЛиста,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Ответственный
	|ПОМЕСТИТЬ ВТ_ВсеОперации
	|ИЗ
	|	Справочник.ОперацииЧекЛиста КАК ОперацииЧекЛиста
	|ГДЕ
	|	НЕ ОперацииЧекЛиста.ЭтоГруппа
	|	И НЕ ОперацииЧекЛиста.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВТ_ВсеОперации.ОперацияЧекЛиста, ВТ_ТекущаяНастройка.ОперацияЧекЛиста) КАК ОперацияЧекЛиста,
	|	ЕСТЬNULL(ВТ_ТекущаяНастройка.Использовать, ЛОЖЬ) КАК Использовать
	|ПОМЕСТИТЬ ВТ_Объединение
	|ИЗ
	|	ВТ_ВсеОперации КАК ВТ_ВсеОперации
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_ТекущаяНастройка КАК ВТ_ТекущаяНастройка
	|		ПО ВТ_ВсеОперации.ОперацияЧекЛиста = ВТ_ТекущаяНастройка.ОперацияЧекЛиста
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Объединение.ОперацияЧекЛиста КАК ОперацияЧекЛиста,
	|	ВТ_Объединение.Использовать КАК Использовать
	|ИЗ
	|	ВТ_Объединение КАК ВТ_Объединение
	|ИТОГИ
	|	МИНИМУМ(Использовать)
	|ПО
	|	ОперацияЧекЛиста ИЕРАРХИЯ
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);	

	ДеревоОпераций = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗаполнитьОперацииЧекЛиста(ДеревоОпераций);
		
	ДеревоОперацийЧекЛиста = РеквизитФормыВЗначение("ОперацииЧекЛистаДерево");
	ДеревоОперацийЧекЛиста.Строки.Очистить();
	ЗначениеВРеквизитФормы(ДеревоОпераций, "ОперацииЧекЛистаДерево");
	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьОперацииЧекЛистаДеревоСохраненные() 
		
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиЧекЛистаОперацииЧекЛиста.ОперацияЧекЛиста КАК ОперацияЧекЛиста,
	|	НастройкиЧекЛистаОперацииЧекЛиста.Использовать КАК Использовать
	|ПОМЕСТИТЬ ВТ_ОперацииИОтветственные
	|ИЗ
	|	Справочник.НастройкиЧекЛиста.ОперацииЧекЛиста КАК НастройкиЧекЛистаОперацииЧекЛиста
	|ГДЕ
	|	НастройкиЧекЛистаОперацииЧекЛиста.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ОперацииИОтветственные.ОперацияЧекЛиста КАК ОперацияЧекЛиста,
	|	ВТ_ОперацииИОтветственные.Использовать КАК Использовать
	|ИЗ
	|	ВТ_ОперацииИОтветственные КАК ВТ_ОперацииИОтветственные
	|ИТОГИ
	|	МИНИМУМ(Использовать)
	|ПО
	|	ОперацияЧекЛиста ИЕРАРХИЯ
	|АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);	
	
	ДеревоОпераций = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗаполнитьОперацииЧекЛиста(ДеревоОпераций);

	ДеревоОперацийЧекЛиста = РеквизитФормыВЗначение("ОперацииЧекЛистаДерево");
	ДеревоОперацийЧекЛиста.Строки.Очистить();
	ЗначениеВРеквизитФормы(ДеревоОпераций, "ОперацииЧекЛистаДерево");
	
КонецПроцедуры 

&НаСервере
Процедура ПолучитьПодчиненныеЭлементы(УровеньРодитель)
	
	Для Каждого Уровень из УровеньРодитель.Строки Цикл 
		
		Если Уровень.Строки.Количество() = 0 и ЗначениеЗаполнено(Уровень.ОперацияЧекЛиста) Тогда
			
			ЗаполнитьЗначенияСвойств(Объект.ОперацииЧекЛиста.Добавить(), Уровень);
		Иначе
			ПолучитьПодчиненныеЭлементы(Уровень);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДеревоВТЧСправочника()
	
	Объект.ОперацииЧекЛиста.Очистить();
	
	ДеревоОперацииЧекЛиста = РеквизитФормыВЗначение("ОперацииЧекЛистаДерево");
	
	Для каждого Уровень из ДеревоОперацииЧекЛиста.Строки Цикл	
		
		Если Уровень.Строки.Количество() = 0 и ЗначениеЗаполнено(Уровень.ОперацияЧекЛиста) Тогда
			
			ЗаполнитьЗначенияСвойств(Объект.ОперацииЧекЛиста.Добавить(), Уровень);
			
		Иначе
			ПолучитьПодчиненныеЭлементы(Уровень);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеРодителяВДереве(НазваниеРеквизитаДерева)
	
	ЭлементКоллекции = Элементы.ОперацииЧекЛистаДерево.ТекущиеДанные;
	
	УстановкаФлажков(ЭлементКоллекции, ЭлементКоллекции[НазваниеРеквизитаДерева], НазваниеРеквизитаДерева);
	
	Родитель = ЭлементКоллекции.ПолучитьРодителя();
	Пока Родитель <> Неопределено Цикл
		Родитель[НазваниеРеквизитаДерева] = ?(УстановленноДляВсех(ЭлементКоллекции, НазваниеРеквизитаДерева),
		ЭлементКоллекции[НазваниеРеквизитаДерева], ?(НазваниеРеквизитаДерева = "Использовать", Ложь, ""));
		ЭлементКоллекции = Родитель;
		Родитель = ЭлементКоллекции.ПолучитьРодителя();
	КонецЦикла;
			
КонецПроцедуры

&НаКлиенте
Процедура УстановкаФлажков(ЭлементКоллекции, ЗначениеПометки, НазваниеРеквизитаДерева)
	
	ПодчинЭлементы = ЭлементКоллекции.ПолучитьЭлементы();
	Для Каждого ТекЭлемент Из ПодчинЭлементы Цикл
		ТекЭлемент[НазваниеРеквизитаДерева] = ЗначениеПометки;
		УстановкаФлажков(ТекЭлемент, ТекЭлемент[НазваниеРеквизитаДерева], НазваниеРеквизитаДерева);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция УстановленноДляВсех(ЭлементКоллекции, НазваниеРеквизитаДерева)
	
	СоседниеЭлементы = ЭлементКоллекции.ПолучитьРодителя().ПолучитьЭлементы();
	Для Каждого ТекЭлемент Из СоседниеЭлементы Цикл
		Если ТекЭлемент[НазваниеРеквизитаДерева] <> ЭлементКоллекции[НазваниеРеквизитаДерева] Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
	
КонецФункции  

&НаСервере
Процедура ДобавитьНовуюОперацию(ВыбранноеЗначение)
	
	НовСтрока = Объект.ОперацииЧекЛиста.Добавить();
	НовСтрока.ОперацияЧекЛиста = ВыбранноеЗначение;
	ЗаполнитьОперацииЧекЛистаДеревоПоУмолчанию();
		
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьОперацииЧекЛистаДеревоПоУмолчанию();
	Иначе    
		ЗаполнитьОперацииЧекЛистаДеревоСохраненные();		
	КонецЕсли;
			
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если не УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РазрешеныЛюбыеОперацииСЧекЛистом, Ложь) Тогда 
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
		
	РазвернутьВсеДерево(ОперацииЧекЛистаДерево.ПолучитьЭлементы());
	
	Если Объект.Ссылка.Пустая() Тогда
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры  

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
		
	ЗаписатьДеревоВТЧСправочника();
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВыбранноеЗначение.ПометкаУдаления = Истина Тогда 
		Сообщить("Удаленные операции нельзя вносить в список настроек.");
		Возврат;
	КонецЕсли;
	
	ОтборПоОперации = Новый Структура;
	ОтборПоОперации.Вставить("ОперацияЧекЛиста", ВыбранноеЗначение); 
	СтрокиПоВыбраннойОперации = Объект.ОперацииЧекЛиста.НайтиСтроки(ОтборПоОперации);
	Если СтрокиПоВыбраннойОперации.Количество() > 0 Тогда 
		Сообщить("Выбранные операция уже есть в списке");
		Возврат;
	КонецЕсли;
	
	ДобавитьНовуюОперацию(ВыбранноеЗначение);
	
	РазвернутьВсеДерево(ОперацииЧекЛистаДерево.ПолучитьЭлементы());
	
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТЧФормы

&НаКлиенте
Процедура ОперацииЧекЛистаДеревоИспользоватьПриИзменении(Элемент)
	
	ИзменениеРодителяВДереве("Использовать");
	
КонецПроцедуры 

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	
	Ответ = Вопрос("Вы действительно хотите заменить текущую настройку настройкой по умолчанию?", РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
		
	ЗаполнитьОперацииЧекЛистаДеревоПоУмолчанию();
	
	РазвернутьВсеДерево(ОперацииЧекЛистаДерево.ПолучитьЭлементы());
	
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры 

&НаКлиенте
Процедура ДатаНачалаДействияНастройкиПриИзменении(Элемент)
	
	Объект.ДатаНачалаДействияНастройки = НачалоМесяца(Объект.ДатаНачалаДействияНастройки);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОперацииЧекЛистаДеревоПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОперацииЧекЛистаДеревоПослеУдаления(Элемент)
	
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры 

&НаКлиенте
Процедура ДобавитьОперацию(Команда)
	
	ОткрытьФорму("Справочник.ОперацииЧекЛиста.Форма.ФормаВыбора",,ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
