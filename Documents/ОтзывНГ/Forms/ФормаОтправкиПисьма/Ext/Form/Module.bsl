﻿
&НаСервере
Процедура ОтправитьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
	
	Почта = Новый ИнтернетПочта;
	Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	Письмо = Новый ИнтернетПочтовоеСообщение;
	Почта.Подключиться(Профиль);
	
	Письмо.Тема = ТемаПисьма;
	
	Письмо.ИмяОтправителя 	= "" + УчетнаяЗапись + "";
	Письмо.ИмяОтправителя  	= "" + СокрЛП(УчетнаяЗапись) + "";
	Письмо.Отправитель     	= "" + СокрЛП(УчетнаяЗапись) + "";
	Для Каждого СтрокаПолучатель Из Получатели Цикл
		Если ЗначениеЗаполнено(СтрокаПолучатель.Адрес) Тогда
			Получатель = Письмо.Получатели.Добавить();
			Получатель.Адрес           = СтрокаПолучатель.Адрес;
			Получатель.ОтображаемоеИмя = СокрЛП(СтрокаПолучатель.Имя);
		КонецЕсли;	
	КонецЦикла;
	
	ТекстСообщения = Письмо.Тексты.Добавить();
	
	ТекстСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.HTML;
	
	Текст     = "<p>"+СтрЗаменить(ТекстПисьма, Символы.ПС,"<br>")+"</p>";
	
	ТекстСообщения.Текст=Текст;
		
	Для Каждого СтрокаФайл Из Объект.Картинки Цикл
		Если ЗначениеЗаполнено(СтрокаФайл.Файл) Тогда
			Письмо.Вложения.Добавить(Справочники.Файлы.ПолучитьИмяФайлаДляОбъекта(СтрокаФайл.Файл));
		КонецЕсли;		
	КонецЦикла;	
	
	Почта.Послать(Письмо); 
	Почта.Отключиться();	
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	ОтправитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Производитель = ПолучитьПроизводителя();
	Если ЗначениеЗаполнено(Производитель) Тогда
		ЗаполнитьПолучателей();
	КонецЕсли;
	ЗаполнитьТемуИТекст();
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПроизводителя()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Владелец КАК Товар,
	|	ЗначенияСвойствОбъектов.Значение КАК Производитель
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|		ПО ХарактеристикиНоменклатуры.Ссылка = ЗначенияСвойствОбъектов.Объект
	|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Владелец = &Товар
	|	И НЕ ХарактеристикиНоменклатуры.ПометкаУдаления
	|	И НЕ ХарактеристикиНоменклатуры.Неактивная");
	Запрос.УстановитьПараметр("Товар", Объект.ТоварНГ);
	ТЗ = Запрос.Выполнить().Выгрузить();
	Если ТЗ.Количество()=1 И ЗначениеЗаполнено(ТЗ[0].Производитель) Тогда
		Возврат ТЗ[0].Производитель;
	КонецЕсли;
	
	ТекстЗапроса =
	"EXEC [Loyalty].[dbo].[FOR1C_NG_Kontr] '" + Объект.НомерКарты + "', '" + Формат(Объект.ДатаОтзыва, "ДФ=dd.MM.yyyy") + "', " + Формат(Объект.ТоварНГ.id_tov, "ЧН=0; ЧГ=");
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");	
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса, СтрокаПодключения);
	ТЗ = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);
	
	Если ТипЗнч(ТЗ) = Тип("ТаблицаЗначений") И ТЗ.Количество() > 0 И ЗначениеЗаполнено(ТЗ[0].id_kontr) Тогда
		Возврат Справочники.Контрагенты.НайтиПоРеквизиту("ИД", ТЗ[0].id_kontr);
	КонецЕсли;	
		
	Возврат Справочники.Контрагенты.ПустаяСсылка();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПолучателей()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Получатели.Очистить();
	
	Продакты = РегистрыСведений.ОбращенияПокупателей.ПолучитьПродактМенеджера(Объект.ТоварНГ, Производитель);
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Объект.Наименование КАК Имя,
	|	КонтактнаяИнформация.Представление КАК Адрес,
	|	КонтактнаяИнформация.Объект КАК Физлицо
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Объект В(&Продакты)
	|	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|	И КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица)");
	Запрос.УстановитьПараметр("Продакты", Продакты);

	РЗ = Запрос.Выполнить().Выбрать();
	Пока РЗ.Следующий() Цикл
		НоваяСтрока = Получатели.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, РЗ);
	КонецЦикла; 
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьТемуИТекст()
	
	ТемаПисьма = "Отзыв НГ на товар " + Объект.ТоварНГ.Наименование;
	
	ТекстПисьма =
	"Дата отзыва: " + Формат(Объект.ДатаОтзыва, "ДФ=dd.MM.yyyy") + "
	|Номер карты: " + Объект.НомерКарты + "
	|Товар: " + Объект.ТоварНГ.Наименование + "
	|Производитель: " + Строка(Производитель) + "
	|Текст отзыва:
	|" + Объект.ТекстОтзыва;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьИЗакрыть(Команда)
	ОтправитьНаСервере();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиФизлицоПриИзменении(Элемент)
	
	Если НЕ Элементы.Получатели.ТекущиеДанные = Неопределено ТОгда
		ЗаполнитьЗначенияСвойств(Элементы.Получатели.ТекущиеДанные, ПолучитьДанныеФизлица(Элементы.Получатели.ТекущиеДанные.Физлицо));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеФизлица(Физлицо)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ЗначениеЗаполнено(Физлицо) ТОгда
		Возврат Новый Структура("Имя, Адрес", "", "");
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Объект.Наименование КАК Имя,
	|	КонтактнаяИнформация.Представление КАК Адрес
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Объект = &Физлицо
	|	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|	И КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица)");
	Запрос.УстановитьПараметр("Физлицо", Физлицо);

	РЗ = Запрос.Выполнить().Выбрать();
	Если РЗ.Следующий() Тогда
		Возврат Новый Структура("Имя, Адрес", РЗ.Имя, РЗ.Адрес);
	КонецЕсли;
	
	Возврат Новый Структура("Имя, Адрес", Физлицо.Наименование, "");
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции