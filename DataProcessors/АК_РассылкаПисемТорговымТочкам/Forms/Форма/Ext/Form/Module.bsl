﻿
Функция ПолучитьАдресаПоТТСервер(мТорговаяТочка)
	
	СтруктураАдресов = Новый Структура("EMailМагазина", мТорговаяТочка.АдресЭлектроннойПочты);
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Объект", мТорговаяТочка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Представление КАК EMail
	|ИЗ
	|	Справочник.РолиПользователей.ТипыРолей КАК РолиПользователей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних КАК СоответствиеОбъектРольСрезПоследних
	|		ПО (СоответствиеОбъектРольСрезПоследних.РольПользователя = РолиПользователей.Ссылка)
	|			И (СоответствиеОбъектРольСрезПоследних.Объект = &Объект)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|		ПО (РолиПользователейСоставРоли.Ссылка = РолиПользователей.Ссылка)
	|			И (РолиПользователейСоставРоли.НомерСтроки = 1)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|		ПО (КонтактнаяИнформация.Объект = РолиПользователейСоставРоли.Сотрудник)
	|			И (КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))
	|			И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица))
	|ГДЕ
	//+++ AK suvv 2018.06.08 ИП-00018376.01
	//|	РолиПользователей.ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего)
	|	(РолиПользователей.ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего)
	|   ИЛИ РолиПользователей.ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы))
	//--- AK suvv
	|	И НЕ РолиПользователей.Ссылка.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	мТекст = "";
	Пока Выборка.Следующий() Цикл
		мТекст = "; " + СокрЛП(Выборка.EMail);
	КонецЦикла;
	Если НЕ мТекст = "" Тогда
		мТекст = Сред(мТекст, 3);
	КонецЕсли;
	
	СтруктураАдресов.Вставить("EMailПомощника", мТекст);
	
	Возврат СтруктураАдресов;
	
КонецФункции


&НаКлиенте
Процедура ТорговыеТочкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока
		 	И НЕ Копирование Тогда
		 ТекДанные = Элементы.ТорговыеТочки.ТекущиеДанные;
		 ТекДанные.Обработать = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ТорговыеТочкиТорговаяТочкаПриИзменении(Элемент)
	
	ТекДанные = Элементы.ТорговыеТочки.ТекущиеДанные;
	
	СтруктураАдресов = ПолучитьАдресаПоТТСервер(ТекДанные.ТорговаяТочка);
	ТекДанные.EMailМагазина 	= СтруктураАдресов.EMailМагазина;
	ТекДанные.EMailПомощника 	= СтруктураАдресов.EMailПомощника;
	
КонецПроцедуры


Процедура ОтправитьПисьмаСервер()
	
	МассивПолучателей = Новый Массив;
	Для Каждого СтрокаТаблицы Из Объект.ТорговыеТочки Цикл
		Если НЕ СтрокаТаблицы.Обработать Тогда
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаТаблицы.EMailМагазина) Тогда
			МассивПолучателей.Добавить(СтрокаТаблицы.EMailМагазина);
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаТаблицы.EMailПомощника) Тогда
			ТекСтрока = СтрокаТаблицы.EMailПомощника;
			ПозЗапятой = Найти(ТекСтрока, ";");
			Пока ПозЗапятой > 0 Цикл // несколько помощников
				МассивПолучателей.Добавить(Лев(ТекСтрока, ПозЗапятой - 1));
				ТекСтрока = Сред(ТекСтрока, ПозЗапятой + 2);
				ПозЗапятой = Найти(ТекСтрока, ";");
			КонецЦикла;
			МассивПолучателей.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	Если МассивПолучателей.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Нет получателей письма!");
		Возврат;
	КонецЕсли;
	
	
	// отправка писем
	ИПП = Новый ИнтернетПочтовыйПрофиль;
	
	ИПП.АдресСервераSMTP 	= "10.0.0.30";
	ИПП.ПортSMTP 			= 25;
	ИПП.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
	ИПП.ПарольSMTP         = "";
	ИПП.ПользовательSMTP   = "";
	
	//
	Письмо = Новый ИнтернетПочтовоеСообщение;
	Письмо.Отправитель = "no-reply@vkusvill.ru";
	
	Для Каждого ТекПолучатель Из МассивПолучателей Цикл
		Письмо.Получатели.Добавить(ТекПолучатель);
	КонецЦикла;

	Письмо.Тема = Объект.ТемаПисем;
	Письмо.Тексты.Добавить(Объект.ТекстПисем);
	
	Почта = Новый ИнтернетПочта;

	Попытка
		Почта.Подключиться(ИПП);
		Почта.Послать(Письмо);
		Почта.Отключиться();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Письма отправлены успешно";
		Сообщение.Сообщить();		
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить();		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПисьма(Команда)
	
	ОтправитьПисьмаСервер();
	
КонецПроцедуры
