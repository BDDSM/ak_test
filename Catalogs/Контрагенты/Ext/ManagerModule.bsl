﻿

Процедура ОтправитьРЛПоПочте(СтруктураНовогоПисьма)  Экспорт
	УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
	СпАдресов=Новый СписокЗначений;
	Для каждого ЭлСп Из СтруктураНовогоПисьма.Кому Цикл
		МассивАдресов=РазложитьСтрокуВМассивПодстрок(ЭлСп.Значение,";");	
		Для каждого Эл Из МассивАдресов Цикл
			СпАдресов.Добавить(Сокрлп(Эл));
		КонецЦикла; 
	КонецЦикла;
	Почта = Новый ИнтернетПочта;
	Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	Письмо = Новый ИнтернетПочтовоеСообщение;
	
	Почта.Подключиться(Профиль);
	Письмо.Тема = СтруктураНовогоПисьма.Тема;
	Письмо.ИмяОтправителя = ""+УчетнаяЗапись+"";
	Письмо.ИмяОтправителя  = ""+СокрЛП(УчетнаяЗапись)+"";
	Письмо.Отправитель     = ""+СокрЛП(УчетнаяЗапись)+"";
	
	ТекстСообщения = Письмо.Тексты.Добавить();
	ТекстСообщения.Текст     = СтруктураНовогоПисьма.Тело;
	ТекстСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	
	Для каждого Эл1 Из СтруктураНовогоПисьма.СписокФайловВложений Цикл
		Письмо.Вложения.Добавить(Эл1.Значение.ИмяФайла);
	КонецЦикла;
	
	Для каждого Адрес Из СпАдресов Цикл
		Получатель = Письмо.Получатели.Добавить();
		Получатель.Адрес           = Адрес.Значение;
	КонецЦикла; 
	Почта.Послать(Письмо);
	Почта.Отключиться();
КонецПроцедуры

Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ",") Экспорт 
	
	МассивСтрок = Новый Массив(); 
	Если Разделитель = " " Тогда 
		Стр = СокрЛП(Стр); 
		Пока Истина Цикл 
			Поз = Найти(Стр,Разделитель); 
			Если Поз=0 Тогда 
				МассивСтрок.Добавить(Стр); 
				Возврат МассивСтрок; 
			КонецЕсли; 
			МассивСтрок.Добавить(Лев(Стр,Поз-1)); 
			Стр = СокрЛ(Сред(Стр,Поз)); 
		КонецЦикла; 
	Иначе 
		ДлинаРазделителя = СтрДлина(Разделитель); 
		Пока Истина Цикл 
			Поз = Найти(Стр,Разделитель); 
			Если Поз=0 Тогда 
				МассивСтрок.Добавить(Стр); 
				Возврат МассивСтрок; 
			КонецЕсли; 
			МассивСтрок.Добавить(Лев(Стр,Поз-1)); 
			Стр = Сред(Стр,Поз+ДлинаРазделителя); 
		КонецЦикла; 
	КонецЕсли; 
КонецФункции // глРазложить

Функция ПолучитьДвоичныеДанные(ИмяФайла) Экспорт 
	УстановитьПривилегированныйРежим(Истина);
	Файл = Новый Файл(ИмяФайла);
	
	Если Файл.Существует() Тогда
		Данные = Новый ДвоичныеДанные(ИмяФайла);
		//Попытка
		//	УдалитьФайлы(ИмяФайла);
		//Исключение
		//КонецПопытки;
		Возврат Данные;
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
	

КонецФункции


Функция ВнешнийОтчет(ИмяПечФ) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВнешниеОбработкиПринадлежность.Ссылка КАК Ссылка,
	|	ВнешниеОбработкиПринадлежность.Наименование КАК Наименование,
	|	ВнешниеОбработкиПринадлежность.ХранилищеВнешнейОбработки КАК ХранилищеВнешнейОбработки
	|ИЗ
	|	Справочник.ВнешниеОбработки КАК ВнешниеОбработкиПринадлежность
	|ГДЕ
	|	НЕ ВнешниеОбработкиПринадлежность.Ссылка.ПометкаУдаления
	|	И ВнешниеОбработкиПринадлежность.Ссылка.ВидОбработки = &ВидОбработки
	|	И ВнешниеОбработкиПринадлежность.Ссылка.Наименование подобно &Наименование
	|ИТОГИ ПО
	|	Ссылка";
	
	ИмяТаблицыОбъекта = "";
	Запрос.УстановитьПараметр("ВидОбработки", Перечисления.ВидыДополнительныхВнешнихОбработок.Обработка);
	Запрос.УстановитьПараметр("Наименование", ИмяПечФ+"%");
	
	НоваяОбработка = Неопределено;
	//БылРазделитель = СтрокиДерева.Количество() = 0 ;
	ВыборкаСсылок = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаСсылок.Следующий() Цикл
		ПорядковыйНомер = 0;
		Выборка = ВыборкаСсылок.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НоваяОбработка = Неопределено;
			ОбработкаСтроки = Выборка.ХранилищеВнешнейОбработки.Получить();
			Если ТипЗнч(ОбработкаСтроки) = Тип("ДвоичныеДанные") Тогда
				НоваяОбработка = ОбработкаСтроки;
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;	
	Возврат НоваяОбработка;
КонецФункции

Процедура ПоместитьКонтрагентаВАрхив(Контрагент) Экспорт
	
	//+++АК MIND 2017.12.04 по просьбе Сазановой убираем вычистку отвественных лиц
	//СписокРеквизитыКОчистке = Новый Структура("Родитель, ОсновноеКонтактноеЛицо, ОсновнойБанковскийСчет, ОсновнойБухгалтерПокупателя, ОсновнойДоговорКонтрагента, ОсновнойМенеджерПокупателя, ОсновнойБухгалтерПоУпаковке");
	СписокРеквизитыКОчистке = Новый Структура("Родитель, ОсновноеКонтактноеЛицо, ОсновнойБанковскийСчет, ОсновнойДоговорКонтрагента");
	//---АК MIND 
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Объект", Контрагент);
	ТекстЗапрос = "ВЫБРАТЬ
	               |	КонтактнаяИнформация.Тип,
	               |	КонтактнаяИнформация.Вид,
	               |	КонтактнаяИнформация.Представление,
	               |	КонтактнаяИнформация.Поле1,
	               |	КонтактнаяИнформация.Поле2,
	               |	КонтактнаяИнформация.Поле3,
	               |	КонтактнаяИнформация.Поле4,
	               |	КонтактнаяИнформация.Поле5,
	               |	КонтактнаяИнформация.Поле6,
	               |	КонтактнаяИнформация.Поле7,
	               |	КонтактнаяИнформация.Поле8,
	               |	КонтактнаяИнформация.Поле9,
	               |	КонтактнаяИнформация.Поле10,
	               |	КонтактнаяИнформация.Комментарий,
	               |	КонтактнаяИнформация.ЗначениеПоУмолчанию
	               |ИЗ
	               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	               |ГДЕ
	               |	КонтактнаяИнформация.Объект = &Объект
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Контрагенты.Ссылка
	               |ИЗ
	               |	Справочник.Контрагенты КАК Контрагенты
	               |ГДЕ
	               |	Контрагенты.ЭтоГруппа = ИСТИНА
	               |	И Контрагенты.ЭтоКаталогПриостановленых = ИСТИНА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Контрагенты.Ссылка,
	               |	&ПоляЗамены КАК Замена
	               |ИЗ
	               |	Справочник.Контрагенты КАК Контрагенты
	               |ГДЕ
	               |	Контрагенты.Ссылка = &Объект";
	
	ТекстРеквизиты = "";
	Для Каждого ЭлементСписка Из СписокРеквизитыКОчистке Цикл
		ТекстРеквизиты = ТекстРеквизиты + ?(ПустаяСтрока(ТекстРеквизиты), "", ", ") + ЭлементСписка.Ключ + " КАК " + ЭлементСписка.Ключ;
	КонецЦикла;
	
	ТекстЗапрос = СтрЗаменить(ТекстЗапрос, "&ПоляЗамены КАК Замена", ТекстРеквизиты);
	Запрос.Текст = ТекстЗапрос;
	
	Результаты = Запрос.ВыполнитьПакет();
	ВыборкаКонтИнфо = Результаты[0].Выбрать();			   
				   
	СпрОбъект = Контрагент.ПолучитьОбъект();
	СпрОбъект.ВАрхиве = Истина;
	СпрОбъект.ОбменДанными.Загрузка = Истина;
	СпрОбъект.ПометкаУдаления = Истина;
	СпрОбъект.КонтактныеДанныеВАрхиве.Очистить();
	Пока ВыборкаКонтИнфо.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СпрОбъект.КонтактныеДанныеВАрхиве.Добавить(), ВыборкаКонтИнфо);
	КонецЦикла;
	
	ВыборкаГруппа = Результаты[1].Выбрать();
	Если ВыборкаГруппа.Следующий() Тогда
		СпрОбъект.Родитель = ВыборкаГруппа.Ссылка;
	КонецЕсли;	
	
	ВыборкаРеквизиты = Результаты[2].Выбрать();
	Если ВыборкаРеквизиты.Следующий() Тогда
		Для Каждого ЭлементСписка Из СписокРеквизитыКОчистке Цикл
			СписокРеквизитыКОчистке.Вставить(ЭлементСписка.Ключ, ВыборкаРеквизиты[ЭлементСписка.Ключ]);
			СтрокаДоб = СпрОбъект.РеквизитыДоПомещенияВАрхив.Добавить();
			СтрокаДоб.Имя = ЭлементСписка.Ключ;
			СтрокаДоб.Значение = ВыборкаРеквизиты[ЭлементСписка.Ключ];
		КонецЦикла;	
	КонецЕсли;	
	
	Для Каждого ЭлементСписка Из СписокРеквизитыКОчистке Цикл
		Если ЭлементСписка.Ключ = "Родитель" Тогда
			Продолжить;
		КонецЕсли;	
		СпрОбъект[ЭлементСписка.Ключ] = Неопределено;
	КонецЦикла;
				   
	СпрОбъект.Записать();
	
	ВыборкаКонтИнфо.Сбросить();
	Пока ВыборкаКонтИнфо.Следующий() Цикл
		Набор = РегистрыСведений.КонтактнаяИнформация.СоздатьНаборЗаписей();
		Набор.Отбор.Объект.Установить(Контрагент);
		Набор.Отбор.Тип.Установить(ВыборкаКонтИнфо.Тип);
		Набор.Отбор.Вид.Установить(ВыборкаКонтИнфо.Вид);
		Набор.Записать();
	КонецЦикла;	
	
КонецПроцедуры

Процедура ВосстановитьИзАрхива(Контрагент) Экспорт
	
	Попытка
		НачатьТранзакцию();
		СпрОбъект = Контрагент.ПолучитьОбъект();
		Для Каждого СтрокаТаб Из СпрОбъект.КонтактныеДанныеВАрхиве Цикл
			Если ЗначениеЗаполнено(СтрокаТаб.Представление) Тогда
				Запись = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(Запись, СтрокаТаб);
				Запись.Объект = Контрагент;
				Запись.Записать();
			КонецЕсли;	
		КонецЦикла;	
		
		СпрОбъект.ВАрхиве = Ложь;
		СпрОбъект.ОбменДанными.Загрузка = Истина;
		СпрОбъект.ПометкаУдаления = Ложь;
		СпрОбъект.КонтактныеДанныеВАрхиве.Очистить();
		
		Для Каждого СтрокаТаб Из СпрОбъект.РеквизитыДоПомещенияВАрхив Цикл
			Попытка
				СпрОбъект[СтрокаТаб.Имя] = СтрокаТаб.Значение;
			Исключение
			КонецПопытки;	
		КонецЦикла;	
		СпрОбъект.РеквизитыДоПомещенияВАрхив.Очистить();
		
		Если НЕ ЗначениеЗаполнено(СпрОбъект.Родитель) Тогда
			Запрос = Новый Запрос();
			Запрос.Текст = "ВЫБРАТЬ
			              |	Контрагенты.Ссылка
			              |ИЗ
			              |	Справочник.Контрагенты КАК Контрагенты
			              |ГДЕ
			              |	Контрагенты.ЭтоГруппа = ИСТИНА
			              |	И Контрагенты.ЭтоКаталогАктивных = ИСТИНА";
			ВыборкаГруппа = Запрос.Выполнить().Выбрать();
			Если ВыборкаГруппа.Следующий() Тогда
				СпрОбъект.Родитель = ВыборкаГруппа.Ссылка;
			КонецЕсли;	
		КонецЕсли;	
		
		СпрОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение	
		Сообщить(ОписаниеОшибки());
		ОтменитьТранзакцию();
	КонецПопытки;	
	
КонецПроцедуры

//+++АК LATV 2018.09.19 ИП-00019768
Функция ФорматСохраненияТабличногоДокументаКонтрагента(Контрагент) Экспорт

	ФорматПоУиолчанию = "XLS";
	
	ПоддерживаемыеФорматы = Новый Массив();
	ПоддерживаемыеФорматы.Добавить("XLS");
	ПоддерживаемыеФорматы.Добавить("PDF");
	ПоддерживаемыеФорматы.Добавить("XLSX");
	
	ФорматСохранения = РегистрыСведений.ЗначенияСвойствОбъектов.ЗначениеСвойстваОбъекта(Контрагент
		, ПланыВидовХарактеристик.СвойстваОбъектов.ФорматСохраненияТабличногоДокумента, ФорматПоУиолчанию);
	
	ФорматСохранения = ВРег(СокрЛП(ФорматСохранения));
	Если ПоддерживаемыеФорматы.Найти(ФорматСохранения) = Неопределено Тогда
		ФорматСохранения = ФорматПоУиолчанию;
	КонецЕсли;
	
	Возврат ФорматСохранения;

КонецФункции

//+++АК LAGP 2018.10.02 ИП-00018521.01 Проверка физ.лица контрагента ЮрФизЛицо = ФизЛицо
Функция ОпределитьФизЛицоКонтрагента(Контрагент) Экспорт
	
	Если Контрагент = Справочники.Контрагенты.ПустаяСсылка() Тогда
		Возврат "Физ.лица не найдено!";	
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФизическиеЛица.Ссылка КАК ФизЛицо
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.Контрагент = &Контрагент";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() > 1 Тогда
		Возврат "Найдено несколько физ.лиц!";
	ИначеЕсли ВыборкаДетальныеЗаписи.Количество() = 0 Тогда 	
		Возврат "Физ.лица не найдено!";
	Иначе
		ВыборкаДетальныеЗаписи.Следующий();
		Возврат ВыборкаДетальныеЗаписи.ФизЛицо;
	КонецЕсли;
		
КонецФункции	

//+++АК LAGP 2018.10.31 ИП-00019645 Выдача займа Контрагенту-поставщику по условию/возврат в срок, уведомление о возарвте займа
Процедура УведомитьОтветственныхОВозвратеЗайма(СтруктураДополнительныхПараметров) Экспорт
			
	СтруктураНовогоПисьма = Новый Структура;
	Кому = Новый СписокЗначений;
	МассивФизЛицОтветственных = Новый Массив;	
	Контрагент = СтруктураДополнительныхПараметров.Контрагент;
	ПользовательКривенко = Справочники.Пользователи.НайтиПоКоду("Кривенко Андрей");
	
	Тема = СтруктураДополнительныхПараметров.Тема;
	Тело = СтруктураДополнительныхПараметров.Тело;
	Если СтруктураДополнительныхПараметров.Событие = "ПроведениеИзКлиентБанка" ИЛИ СтруктураДополнительныхПараметров.Событие = "ПериодическоеЗаданиеПросрок" Тогда
		Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
			Тема = Тема + Символы.ПС + "СБОЙ ОПРЕДЕЛЕНИЯ КОНТРАГЕНТА! Спр.Контрагенты.МодульМенеджера(Процедура ""УведомитьОтветственныхОВозвратеЗайма"")";
			Кому.Добавить("lagp@automacon.ru");
		КонецЕсли;	
		//Менеджер   = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ОсновнойМенеджерПокупателя"); //+++АК LAGP 2018.11.06 ИП-00019645 Попросили отключить
		Бухгалтер  = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ОсновнойБухгалтерПокупателя");
		Если ЗначениеЗаполнено(Бухгалтер) И НЕ Бухгалтер = ПользовательКривенко Тогда
			//МассивФизЛицОтветственных.Добавить(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Менеджер, "ФизЛицо"));
			МассивФизЛицОтветственных.Добавить(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Бухгалтер, "ФизЛицо"));
		КонецЕсли;
	КонецЕсли;	
	
	СтруктураАдресовОтветственных = УправлениеЭлектроннойПочтой.ЭлектронныеАдресаФизическихЛиц(МассивФизЛицОтветственных);
	Для каждого ЭлементМассиваАдресовОтветсвенных Из СтруктураАдресовОтветственных Цикл
		Кому.Добавить(ЭлементМассиваАдресовОтветсвенных.Адрес);
	КонецЦикла;
	
	Если СтруктураАдресовОтветственных.Количество() = 0 И (СтруктураДополнительныхПараметров.Событие = "ПроведениеИзКлиентБанка" ИЛИ СтруктураДополнительныхПараметров.Событие = "ПериодическоеЗаданиеПросрок") Тогда
		Тема = Тема + Символы.ПС + "СБОЙ ОПРЕДЕЛЕНИЯ АДРЕСОВ ФИЗ.ЛИЦ ОТВЕТСВЕННЫХ! Спр.Контрагенты.МодульМенеджера(Процедура ""УведомитьОтветственныхОВозвратеЗайма"")";
		Кому.Очистить();
		Кому.Добавить("lagp@automacon.ru");
	ИначеЕсли СтруктураДополнительныхПараметров.Событие = "ПроведениеИзКлиентБанка" ИЛИ СтруктураДополнительныхПараметров.Событие = "ПериодическоеЗаданиеПриближениеПросрока" Тогда
		Кому.Добавить("finmanager@izbenka.msk.ru"); // помимо менеджера и бухгалтера, необходимо отправлять письмо "фин.менеджеру"
		Кому.Добавить("buh45@vkusvill.ru");
	ИначеЕсли СтруктураДополнительныхПараметров.Событие = "ПериодическоеЗаданиеПросрок" Тогда
		СтруктураАдресаКонтрагента = ОбщегоНазначения.ПолучитьКонтактнуюИнформациюПоВиду(Контрагент, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыКонтрагентаДляОбменаДокументами"));
		Если ЗначениеЗаполнено(СтруктураАдресаКонтрагента) Тогда
			//Кому.Добавить(СтруктураАдресаКонтрагента.Представление);
			Тело = Тело + Символы.ПС + "Адрес контрагента:" + СтруктураАдресаКонтрагента.Представление;
		КонецЕсли;	
	КонецЕсли;
			 	
	СтруктураНовогоПисьма.Вставить("Кому", Кому);	
	СтруктураНовогоПисьма.Вставить("Тема", Тема);
	СтруктураНовогоПисьма.Вставить("Тело", Тело);
	СтруктураНовогоПисьма.Вставить("СписокФайловВложений", Новый Массив);
	
	ОтправитьРЛПоПочте(СтруктураНовогоПисьма);		
	
КонецПроцедуры	
