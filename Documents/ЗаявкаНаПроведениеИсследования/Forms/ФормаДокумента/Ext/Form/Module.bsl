﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Ответственный=Параметрысеанса.ТекущийПользователь;
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьФайл(Команда)
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.МножественныйВыбор = Истина;
	ДиалогОткрытияФайла.Заголовок = "Выберите файлы";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
		Для Каждого ИмяФайла Из МассивФайлов Цикл
			ВыбФайл = Новый Файл(ИмяФайла);
			Если НЕ ВыбФайл.Существует() Тогда				
				Сообщить("Не существует файл. "+ИмяФайла);
				Продолжить;
			КонецЕсли;
			СсылкаНаФайл = СоздатьФайлХранения(Новый Структура("Представление, ДанныеКартинки",ВыбФайл.Имя, Новый ДвоичныеДанные(ИмяФайла)), ВыбФайл.Расширение);
			НС=Объект.ПрикрепленныеФайлы.Добавить();
			НС.Файл=СсылкаНаФайл;
			НС.ДатаПрикрепления=ТекущаяДата();
		КонецЦикла;	
	КонецЕсли;	
	
	
	
	
КонецПроцедуры

&НаСервере
Функция СоздатьФайлХранения(СтрокаТаблицы, РасширениеРезультата)
	
	СпрОбъект = Справочники.Файлы.СоздатьЭлемент();
	СпрОбъект.УстановитьНовыйКод("0");
	СпрОбъект.Наименование = СтрокаТаблицы.Представление;
	СпрОбъект.Расширение = РасширениеРезультата;
	СпрОбъект.ДополнительныеСвойства.Вставить("Хранилище", Новый ХранилищеЗначения(Новый Картинка(СтрокаТаблицы.ДанныеКартинки)));
	СпрОбъект.Записать();
	Возврат СпрОбъект.Ссылка;
	
КонецФункции	

&НаКлиенте
Процедура Просмотреть(Команда)
	
	Если Элементы.ПрикрепленныеФайлы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элементы.ПрикрепленныеФайлы.ДанныеСтроки(Элементы.ПрикрепленныеФайлы.ТекущаяСтрока);
	
	СтруктураКартинки = ПолучитьРеквизитыСохраненияКартинки(ДанныеСтроки.Файл);
	ИмяФайла = ПолучитьИмяВременногоФайла(СтруктураКартинки.Расширение);
	Если ПолучитьФайл(СтруктураКартинки.АдресКартинки, ИмяФайла, Ложь) = Истина Тогда
		ЗапуститьПриложение(ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьРеквизитыСохраненияКартинки(ФайлСсылка)
	
	Картинка = Новый Картинка(Справочники.Файлы.ПолучитьИмяФайлаДляОбъекта(ФайлСсылка));
	Возврат Новый Структура("АдресКартинки, Расширение", ПоместитьВоВременноеХранилище(Картинка), ФайлСсылка.Расширение);
	
КонецФункции


&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Элементы.ПрикрепленныеФайлы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элементы.ПрикрепленныеФайлы.ДанныеСтроки(Элементы.ПрикрепленныеФайлы.ТекущаяСтрока);
	
	СтруктураКартинки = ПолучитьРеквизитыСохраненияКартинки(ДанныеСтроки.Файл);
	ИмяФайла = ПолучитьИмяВременногоФайла(СтруктураКартинки.Расширение);
	ПолучитьФайл(СтруктураКартинки.АдресКартинки, ИмяФайла, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	//++ak lobv без типа исследований не сможем организовать рассылку
	Если Не ЗначениеЗаполнено(Объект.ТипИсследования) тогда
		Предупреждение("Заполните тип исследования!");
		Отказ=Истина;
	КонецЕсли;
	//--ак
КонецПроцедуры

&НаКлиенте
Процедура ВыполненоПриИзменении(Элемент)
	Если Объект.Выполнено Тогда 
		Если Не ЗначениеЗаполнено(Объект.ДатаВыполнения) Тогда
			Объект.ДатаВыполнения=ТекущаяДата();
		КонецЕсли;	
	Иначе
		Объект.ДатаВыполнения = Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПисьмоИсполнителю(Команда)
	Если ЭтаФорма.Модифицированность Тогда
		Сообщить("Сначала запишите документ");
		Возврат;
	КонецЕсли;	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "ru = ""Отправить письмо исполнителю?"";";
	Ответ = Вопрос(НСтр(Текст), Режим, 0);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ТабДок = Неопределено;
	
	ОтправитьПисьмоИсполнителюСервер(ТабДок);
	
	Если Табдок<>Неопределено Тогда
		ТабДок.Показать("Отправлено письмо следующего содержания");
		Сообщить("Письмо отправлено!");
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьПисьмоИсполнителюСервер(ТабДок)
	ТабДок = Новый ТабличныйДокумент;
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	СКД=Документы.ЗаявкаНаПроведениеИсследования.ПолучитьМакет("УведомлениеИсполнителяОЗаявке");
	СКД.Параметры.Ссылка.Значение = Объект.Ссылка;
	НастройкиСКД = СКД.НастройкиПоУмолчанию;
	//НастройкиСКД.ПараметрыДанных.УстановитьЗначениеПараметра("Заявка", Объект.Ссылка);
	
	//ТекстЗапроса="ВЫБРАТЬ
	//			 |	НоменклатураОбеспеченияТочекИсполнители.Исполнитель,
	//			 |	МАКСИМУМ(ВЫРАЗИТЬ(НоменклатураОбеспеченияТочекИсполнители.ПочтаИсполнителя КАК СТРОКА(150))) КАК Почта
	//			 |ИЗ
	//			 |	Документ.ЗаявкаНаОбеспечениеТочек.Перечень КАК ЗаявкаНаОбеспечениеТочекПеречень
	//			 |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НоменклатураОбеспеченияТочек.Исполнители КАК НоменклатураОбеспеченияТочекИсполнители
	//			 |		ПО ЗаявкаНаОбеспечениеТочекПеречень.Номенклатура.Родитель = НоменклатураОбеспеченияТочекИсполнители.Ссылка
	//			 |ГДЕ
	//			 |	ЗаявкаНаОбеспечениеТочекПеречень.Ссылка = &Заявка
	//			 |
	//			 |СГРУППИРОВАТЬ ПО
	//			 |	НоменклатураОбеспеченияТочекИсполнители.Исполнитель";
	//Запрос = Новый Запрос(ТекстЗапроса);			 
	//Запрос.УстановитьПараметр("Заявка",Объект.Ссылка);
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	СКД.Параметры.Исполнитель.Значение = Выборка.Исполнитель;
	//	НастройкиСКД = СКД.НастройкиПоУмолчанию;
	//НастройкиСКД.ПараметрыДанных.УстановитьЗначениеПараметра("Исполнитель", Выборка.Исполнитель);
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, НастройкиСКД, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ,ДанныеРасшифровки);
	
	//ТабДок=Новый ТабличныйДокумент;
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабДок);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ИмяФайла=Новый УникальныйИдентификатор;
	ИмяФайла=КаталогВременныхФайлов()+ИмяФайла+".pdf";
	
	ТабДок.Записать(ИмяФайла,ТипФайлаТабличногоДокумента.PDF);
	//Отправка письма
	Адрес = ПолучитьАдресИзКИСервер(Объект.Исполнитель);
	//Адрес = Выборка.Почта;
	СписокКому = Новый СписокЗначений;
	Если Адрес<>"" Тогда
		СпАдресов=Новый СписокЗначений;
		МассивАдресов=Справочники.Контрагенты.РазложитьСтрокуВМассивПодстрок(Адрес,";");	
		Для каждого Эл Из МассивАдресов Цикл
			Если ЗначениеЗаполнено(Эл) Тогда
				СписокКому.Добавить(СокрЛП(Эл));
			КонецЕсли; 
		КонецЦикла; 
		
	Иначе
		Сообщить("Не заполнен адрес электронной почты "+Объект.Исполнитель);
		//Возврат;
	КонецЕсли;
	
	
	//СписокКому.Добавить(ВыборкаДетальныеЗаписи.Представление);
	СписокКому.Добавить("research@izbenka.msk.ru");
	СписокКому.Добавить("research@vkusvill.ru");
	СписокКому.Добавить("pozm@automacon.ru");
	//СписокКому.Добавить("buh9@izbenka.msk.ru");
	
	
	УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
	
	Почта = Новый ИнтернетПочта;
	Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	Письмо = Новый ИнтернетПочтовоеСообщение;
	
	Почта.Подключиться(Профиль);
	Письмо.Тема = ""+Объект.Ссылка;
	Письмо.ИмяОтправителя 	= "" + УчетнаяЗапись + "";
	Письмо.ИмяОтправителя  	= "" + СокрЛП(УчетнаяЗапись) + "";
	Письмо.Отправитель     	= "" + СокрЛП(УчетнаяЗапись) + "";
	Для Каждого ПолучательЭлемент Из СписокКому Цикл
		Получатель = Письмо.Получатели.Добавить();
		Получатель.Адрес = ПолучательЭлемент.Значение;
	КонецЦикла;	
	
	ТекстСообщения = Письмо.Тексты.Добавить();
	ТекстСообщения.Текст     = "Во вложении находится информация о данных заявки";
	ТекстСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	
	Письмо.Вложения.Добавить(ИмяФайла);
	
	//	Если НЕ ОбщегоНазначения.ЭтоКопияБазы() Тогда
	Почта.Послать(Письмо);
	//	КонецЕсли;	
	Почта.Отключиться();
	//КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Функция ПолучитьАдресИзКИСервер(Исполнитель)
	Запрос = Новый Запрос;
	Запрос.Текст =                                                                                   
	"ВЫБРАТЬ                                                   
	|	КонтактнаяИнформация.Представление
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Объект = &Объект
	|	И КонтактнаяИнформация.Тип = &Тип
	|	И КонтактнаяИнформация.Вид = Значение(Справочник.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыКонтрагентаДляОбменаДокументами)";
	
	Запрос.УстановитьПараметр("Объект", Исполнитель);
	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Представление;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции	

&НаКлиенте
Процедура ОтправитьПисьмоЗаказчику(Команда)
	Если ЭтаФорма.Модифицированность Тогда
		Сообщить("Сначала запишите документ");
		Возврат;
	КонецЕсли;	
	Если НЕ Объект.Выполнено Тогда
		Сообщить("Задача не отмечена выполненной! Отправить письмо можно только по выполненной задаче");
		Возврат;
		
	КонецЕсли;	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "ru = ""Отправить письмо заказчику?"";";
	Ответ = Вопрос(НСтр(Текст), Режим, 0);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ТабДок = Неопределено;
	
	ОтправитьПисьмоЗаказчикуСервер(ТабДок);
	
	Если Табдок<>Неопределено Тогда
		ТабДок.Показать("Отправлено письмо следующего содержания");
		Сообщить("Письмо отправлено!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтправитьПисьмоЗаказчикуСервер(ТабДок)
	ТабДок = Новый ТабличныйДокумент;
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	СКД=Документы.ЗаявкаНаПроведениеИсследования.ПолучитьМакет("УведомлениеЗаказчикаОВыполнении");
	СКД.Параметры.Ссылка.Значение = Объект.Ссылка;
	НастройкиСКД = СКД.НастройкиПоУмолчанию;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, НастройкиСКД, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ,ДанныеРасшифровки);
	
	//ТабДок=Новый ТабличныйДокумент;
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабДок);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ИмяФайла=Новый УникальныйИдентификатор;
	ИмяФайла=КаталогВременныхФайлов()+ИмяФайла+".pdf";
	
	ТабДок.Записать(ИмяФайла,ТипФайлаТабличногоДокумента.PDF);
	//Отправка письма
	Адрес = ПолучитьАдресИзКИСервер(Объект.Заказчик);
	//Адрес = Выборка.Почта;
	СписокКому = Новый СписокЗначений;
	Если Адрес<>"" Тогда
		СпАдресов=Новый СписокЗначений;
		МассивАдресов=Справочники.Контрагенты.РазложитьСтрокуВМассивПодстрок(Адрес,";");	
		Для каждого Эл Из МассивАдресов Цикл
			Если ЗначениеЗаполнено(Эл) Тогда
				СписокКому.Добавить(СокрЛП(Эл));
			КонецЕсли; 
		КонецЦикла; 
		
	Иначе
		Сообщить("Не заполнен адрес электронной почты "+Объект.Заказчик);
		//Возврат;
	КонецЕсли;
	
	
	//СписокКому.Добавить(ВыборкаДетальныеЗаписи.Представление);
	СписокКому.Добавить("research@izbenka.msk.ru");
	СписокКому.Добавить("research@vkusvill.ru");
	СписокКому.Добавить("pozm@automacon.ru");
	//СписокКому.Добавить("buh9@izbenka.msk.ru");
	
	
	УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
	
	Почта = Новый ИнтернетПочта;
	Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	Письмо = Новый ИнтернетПочтовоеСообщение;
	
	Почта.Подключиться(Профиль);
	Письмо.Тема = ""+Объект.Ссылка;
	Письмо.ИмяОтправителя 	= "" + УчетнаяЗапись + "";
	Письмо.ИмяОтправителя  	= "" + СокрЛП(УчетнаяЗапись) + "";
	Письмо.Отправитель     	= "" + СокрЛП(УчетнаяЗапись) + "";
	Для Каждого ПолучательЭлемент Из СписокКому Цикл
		Получатель = Письмо.Получатели.Добавить();
		Получатель.Адрес = ПолучательЭлемент.Значение;
	КонецЦикла;	
	
	ТекстСообщения = Письмо.Тексты.Добавить();
	ТекстСообщения.Текст     = "Во вложении находится информация о данных заявки";
	ТекстСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	
	Письмо.Вложения.Добавить(ИмяФайла);
	
	//	Если НЕ ОбщегоНазначения.ЭтоКопияБазы() Тогда
	Почта.Послать(Письмо);
	//	КонецЕсли;	
	Почта.Отключиться();
	//КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "ru = ""Отправить письма заказчику и исполнителю?"";";
	Ответ = Вопрос(НСтр(Текст), Режим, 0);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ТабДок = Неопределено;
	Если ЗначениеЗаполнено(Объект.Заказчик) Тогда
		ОтправитьПисьмоЗаказчикуСервер(ТабДок);
	    Сообщить("Письмо заказчику отправлено!");
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Объект.Исполнитель) Тогда
		ОтправитьПисьмоИсполнителюСервер(ТабДок);
	    Сообщить("Письмо исполнителю отправлено!");
	КонецЕсли;	
	
КонецПроцедуры
