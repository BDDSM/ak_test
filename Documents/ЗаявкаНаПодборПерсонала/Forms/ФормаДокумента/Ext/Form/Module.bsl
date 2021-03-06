﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьОсновныеПараметрыФормы();
	
	ОбновитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьОтборыОбеспечения();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьДоступностьЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаЦФОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Обработка.ГрафикРаботыГрузчиков.Форма.ФормаВыбораСтруктурнойЕдиницы", Новый Структура("НаименованиеГруппы", "Управление розницей."),,
				Элементы.ГруппаЦФО, ВариантОткрытияОкна.ОтдельноеОкно,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПотребности

&НаКлиенте
Процедура ПотребностиДолжностьАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ПолучитьДолжностьПоЧастиТекста(Текст);

КонецПроцедуры

&НаКлиенте
Процедура ПотребностиДолжностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущаяДолжность = ВыбранноеЗначение; 
	ОбновитьОтборыОбеспечения(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПотребностиПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьОтборыОбеспеченияОбработчик", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПотребностиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьОтборыОбеспечения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбеспечение
&НаКлиенте
Процедура ОбеспечениеСотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьВыбор", ЭтаФорма);
		
	ОткрытьФорму("Документ.ЗаявкаНаПодборПерсонала.Форма.ФормаВыбораФизЛица", Новый Структура("Отбор, ЗакрыватьПриВыборе", Новый Структура("Должность", ТекущаяДолжность), Истина),
		  ЭтаФорма.УникальныйИдентификатор,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		  
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыбор(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат <> Неопределено Тогда
		ТекущиеДанные = Элементы.Обеспечение.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда 
			ТекущиеДанные.Сотрудник = Результат.Ссылка;
			ТекущиеДанные.Должность = ТекущаяДолжность;
			Элементы.Обеспечение.ЗакончитьРедактированиеСтроки(Ложь); 
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбеспечениеСотрудникАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ПолучитьФизЛицоПоЧастиТекста(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбеспечениеСотрудникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Обеспечение.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.Сотрудник = ВыбранноеЗначение;
		ТекущиеДанные.Должность = ТекущаяДолжность;
		Элементы.Обеспечение.ЗакончитьРедактированиеСтроки(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбеспечениеПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	ОбновитьКоличествоОбеспеченияПодвал();

КонецПроцедуры

&НаКлиенте
Процедура ОбеспечениеПослеУдаления(Элемент)
	
	ОбновитьКоличествоОбеспеченияПодвал();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбеспечениеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Объект.Потребности.Количество() = 0 Тогда
		ПоказатьПредупреждение(, "Заполните таблицу потребностей!");
		Отказ = Истина;
		Возврат;
	ИначеЕсли НЕ ЗначениеЗаполнено(ТекущаяДолжность) Тогда
		ПоказатьПредупреждение(, "Активируйте строку с должностью!");
		Отказ = Истина;		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущаяДолжность) И НЕ ЗначениеЗаполнено(КоличествоПотребность) Тогда
		ПоказатьПредупреждение(,СтрЗаменить("Укажите количество сотрудников в таблице потребностей по должности ТекущаяДолжность!", "ТекущаяДолжность", ТекущаяДолжность));
		Отказ = Истина;	
	ИначеЕсли  КоличествоПотребность <= КоличествоОбеспечение Тогда
		ПоказатьПредупреждение(,СтрЗаменить("Потребность в сотрудниках с должностью ТекущаяДолжность уже обеспечена!", "ТекущаяДолжность", ТекущаяДолжность));
		Отказ = Истина;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОсновныеПараметрыФормы()

	//Заполнение нового документа
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		Если ЗначениеЗаполнено(Объект.Ответственный) Тогда
			Объект.ГруппаЦФО = РегистрыСведений.ПользователиПоЦФО.ПолучитьСтрукрутуПодчиненияТекущегоСотрудника(Объект.Ответственный, Ложь, Истина);
		КонецЕсли;
		Объект.Статус = Перечисления.СтатусыЗаявокНаПодборПерсонала.Новая;
	КонецЕсли;
	
	//Заполнение прочих параметров
	ОбновитьСписокВыбораДолжностей();
	
КонецПроцедуры // ЗаполнитьОсновныеПараметрыФормы()

&НаСервере
Процедура ОбновитьСписокВыбораДолжностей()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФизическиеЛица.Должность КАК Значение,
	|	ФизическиеЛица.Должность КАК Представление
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ПО СотрудникиОрганизаций.Физлицо = ФизическиеЛица.Ссылка
	|ГДЕ
	|	СотрудникиОрганизаций.ДатаУвольнения = &ПустаяДата
	|	И НЕ СотрудникиОрганизаций.ПометкаУдаления
	|	И ФизическиеЛица.Активный
	|
	|СГРУППИРОВАТЬ ПО
	|	ФизическиеЛица.Должность
	|
	|УПОРЯДОЧИТЬ ПО
	|	Должность";
	
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1,1,1));
	
	Результат = Запрос.Выполнить();
	
	СписокВыбораДолжностей = Новый СписокЗначений();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Элементы.Потребности.ПодчиненныеЭлементы.ПотребностиДолжность.СписокВыбора.Добавить(Выборка.Значение, СокрЛП(Выборка.Представление));
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДолжностьПоЧастиТекста(Текст)
	
    Возврат ПолучитьДанныеВыбора(Тип("СправочникСсылка.ДолжностиОрганизаций"), 
				Новый Структура("ДополнительныеПараметры, ТекстПоиска", "ПодборПоДолжности", Текст));
	
КонецФункции
			
&НаКлиенте
Функция ПолучитьФизЛицоПоЧастиТекста(Текст)
	
    Возврат ПолучитьДанныеВыбора(Тип("СправочникСсылка.ФизическиеЛица"), Новый Структура("ВыборГруппИЭлементов, ВариантПодбора, ТекстПоиска, Должность", 
			ИспользованиеГруппИЭлементов.Элементы, "ПодборПоДолжности", Текст, ТекущаяДолжность));
	
КонецФункции

&НаКлиенте
Процедура ОбновитьОтборыОбеспеченияОбработчик()Экспорт
	
	ОбновитьОтборыОбеспечения();	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтборыОбеспечения(ОбновитьДолжность = Истина)Экспорт
	
	ТекущиеДанные = Элементы.Потребности.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.Должность) Тогда 
		Если ОбновитьДолжность Тогда
			ТекущаяДолжность = ТекущиеДанные.Должность;
		КонецЕсли;
		КоличествоПотребность = ТекущиеДанные.Количество;
		Элементы.Обеспечение.ОтборСтрок = Новый ФиксированнаяСтруктура("Должность", ТекущаяДолжность);
	Иначе
		ТекущаяДолжность = "";
		КоличествоПотребность = 0;
		Элементы.Обеспечение.ОтборСтрок = Новый ФиксированнаяСтруктура("Должность", "Не установлен отбор");
	КонецЕсли;
	
	ОбновитьКоличествоОбеспеченияПодвал();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоличествоОбеспеченияПодвал()
	
	КоличествоОбеспечение = Объект.Обеспечение.НайтиСтроки(Новый Структура("Должность", ТекущаяДолжность)).Количество();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьЭлементовФормы()
	
	Если РольДоступна("ПолныеПрава") Тогда
		ТолькоПросмотр = Ложь;
	Иначе
		ТолькоПросмотр = Объект.Статус = Перечисления.СтатусыЗаявокНаПодборПерсонала.Обеспечена 
				ИЛИ Объект.ПометкаУдаления; 
	КонецЕсли;
	
	Элементы.Статус.ТолькоПросмотр = ТолькоПросмотр; 
	Элементы.Потребности.ИзменятьСоставСтрок = НЕ ТолькоПросмотр;
	Элементы.Потребности.ИзменятьПорядокСтрок = НЕ ТолькоПросмотр;
	
	Для каждого Колонка Из Элементы.Потребности.ПодчиненныеЭлементы Цикл
		Колонка.ТолькоПросмотр = ТолькоПросмотр;
	КонецЦикла;
	
	Для каждого Колонка Из Элементы.Обеспечение.ПодчиненныеЭлементы Цикл
		Колонка.ТолькоПросмотр = ТолькоПросмотр;
	КонецЦикла;
	
КонецПроцедуры // ОбновитьДоступностьЭлементовФормы()

&НаКлиенте
Процедура ПотребностиПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	ТекущиеДанные = Элементы.Потребности.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		Если ТекущиеДанные.Количество < КоличествоОбеспечение Тогда
			ПоказатьПредупреждение(, СтрЗаменить("Обеспечение не может превышать потребность (проверьте обеспечение по должность ТекущаяДолжность)!", "ТекущаяДолжность", ТекущаяДолжность));
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;                                                                                                  
	
КонецПроцедуры

#КонецОбласти
