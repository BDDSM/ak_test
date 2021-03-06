﻿Перем НЯКДозаписи;


//+++ AK suvv 2018.10.24 ИП-00020194
Функция ПолучитьГрафикИнкассацииМагазина()
	
	ГрафикИнкассацииМагазина = "";
	
	НЗ_ГрафикИнкассации = РегистрыСведений.ГрафикИнкассации.СоздатьНаборЗаписей();
	НЗ_ГрафикИнкассации.Отбор.ТорговаяТочка.Установить(Магазин);
	НЗ_ГрафикИнкассации.Прочитать();
	
	Для Каждого Стр из НЗ_ГрафикИнкассации Цикл
		
		Если Стр.ИнкассацияПн Тогда
			ГрафикИнкассацииМагазина = ГрафикИнкассацииМагазина + "Понедельник, ";
		КонецЕсли;
		Если Стр.ИнкассацияВт Тогда 
			ГрафикИнкассацииМагазина = ГрафикИнкассацииМагазина + "Вторник, ";
		КонецЕсли;
		Если Стр.ИнкассацияСр Тогда 
			ГрафикИнкассацииМагазина = ГрафикИнкассацииМагазина + "Среда, ";
		КонецЕсли;
		Если Стр.ИнкассацияЧт Тогда
			ГрафикИнкассацииМагазина = ГрафикИнкассацииМагазина + "Четверг, ";
		КонецЕсли;
		Если Стр.ИнкассацияПт Тогда
			ГрафикИнкассацииМагазина = ГрафикИнкассацииМагазина + "Пятница, ";
		КонецЕсли;
		Если Стр.ИнкассацияСб Тогда 
			ГрафикИнкассацииМагазина = ГрафикИнкассацииМагазина + "Суббота, ";
		КонецЕсли;
		Если Стр.ИнкассацияВс Тогда
			ГрафикИнкассацииМагазина = ГрафикИнкассацииМагазина + "Воскресенье, ";
		КонецЕсли;
		
	КонецЦикла;
	
	Если ГрафикИнкассацииМагазина <> "" Тогда 
		ГрафикИнкассацииМагазина = Лев(ГрафикИнкассацииМагазина, СтрДлина(ГрафикИнкассацииМагазина) - 2);
	КонецЕсли;
	
	Возврат ГрафикИнкассацииМагазина;
	
КонецФункции //--- AK suvv

Процедура ПриЗаписи(Отказ)
	
	Если СуммаЛимита <> 0 Тогда 
		АК_СуммаЛимитаРазмена = СуммаЛимита;
	Иначе
		АК_СуммаЛимитаРазмена = Константы.АК_СуммаЛимитаРазмена.Получить();
	КонецЕсли;
	ИтогСуммаРуб = Раскладка.Итог("СуммаРуб");
	Если ИтогСуммаРуб> АК_СуммаЛимитаРазмена Тогда 
		Сообщить("Внимание превышена сумма лимита. Сумма не должна превышать "+АК_СуммаЛимитаРазмена+" руб.");
		Отказ = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерЯвочнойТочки) и ЗначениеЗаполнено(Магазин) и СокрЛП(НомерЯвочнойТочки) <> СокрЛП(Магазин.НомерЯвочнойКартыДляИнкассации)  Тогда
		//+++АК BARA 2018.04.02 ИП-00018292  Добавлена проверка, если банк инкассатор с установленным флажком разные номера то не выполнять код.
		Если не (ЗначениеЗаполнено(Магазин.БанкВносительИнкассация) и Магазин.БанкВносительИнкассация.РазныеНомера) Тогда 
			УстановитьПривилегированныйРежим(Истина);
			МагазинОбъект = Магазин.ПолучитьОбъект();
			МагазинОбъект.НомерЯвочнойКартыДляИнкассации = СокрЛП(НомерЯвочнойТочки);
			МагазинОбъект.Записать();
			УстановитьПривилегированныйРежим(Ложь);	 
		КонецЕсли;
		//---АК BARA
	КонецЕсли;
	
	//+++АК BARA ИП-00017699   2018.02.06   
	Если НЯКДозаписи <> НомерЯвочнойТочки  Тогда
		//Рассылка письма
		
		//+++ AK suvv 2018.10.19 ИП-00020194	
		РеквизитыМагазина = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Магазин, "Самоинкассация, КонтрагентИнкассатор, ИнкассируемыйБанк, НомерЯвочнойКартыДляИнкассации, НомерПТК");
		
		ТекстПисьмаСозданияЗаявки = "Создана новая заявка на размен.
		|
		|Номер як: %НомерЯК%";
		Если РеквизитыМагазина.Самоинкассация Тогда 
			ТекстПисьмаСозданияЗаявки = ТекстПисьмаСозданияЗаявки + "
			|
			|Номер ПТК/ЯК АДМ: %НомерПТК%";
		КонецЕсли;
		ТекстПисьмаСозданияЗаявки = ТекстПисьмаСозданияЗаявки + "
		|
		|График инкассации: %ГрафикИнкассации%
		|
		|Контрагент - Инкассатор: %КонтрагентИнкассатор%
		|
		|График размена: %ГрафикРазмена%
		|
		|Контрагент - Размен: %КонтрагентРазмен%
		|";
		
		Если РеквизитыМагазина.Самоинкассация Тогда
			ТекстПисьмаСозданияЗаявки = СтрЗаменить(ТекстПисьмаСозданияЗаявки, "%НомерЯК%",              РеквизитыМагазина.НомерЯвочнойКартыДляИнкассации);
			ТекстПисьмаСозданияЗаявки = СтрЗаменить(ТекстПисьмаСозданияЗаявки, "%НомерПТК%",             РеквизитыМагазина.НомерПТК);
			ТекстПисьмаСозданияЗаявки = СтрЗаменить(ТекстПисьмаСозданияЗаявки, "%ГрафикИнкассации%",     "по мере заполнения ПТК/ЯК АДМ");
			ТекстПисьмаСозданияЗаявки = СтрЗаменить(ТекстПисьмаСозданияЗаявки, "%КонтрагентИнкассатор%", РеквизитыМагазина.КонтрагентИнкассатор);
			ТекстПисьмаСозданияЗаявки = СтрЗаменить(ТекстПисьмаСозданияЗаявки, "%ГрафикРазмена%",        ГрафикРазмена);
			ТекстПисьмаСозданияЗаявки = СтрЗаменить(ТекстПисьмаСозданияЗаявки, "%КонтрагентРазмен%",     РеквизитыМагазина.ИнкассируемыйБанк);	
		Иначе
			ТекстПисьмаСозданияЗаявки = СтрЗаменить(ТекстПисьмаСозданияЗаявки, "%НомерЯК%",              НомерЯвочнойТочки);
			ТекстПисьмаСозданияЗаявки = СтрЗаменить(ТекстПисьмаСозданияЗаявки, "%ГрафикИнкассации%",     ПолучитьГрафикИнкассацииМагазина());
			ТекстПисьмаСозданияЗаявки = СтрЗаменить(ТекстПисьмаСозданияЗаявки, "%КонтрагентИнкассатор%", РеквизитыМагазина.КонтрагентИнкассатор);
			ТекстПисьмаСозданияЗаявки = СтрЗаменить(ТекстПисьмаСозданияЗаявки, "%ГрафикРазмена%",        ГрафикРазмена);
			ТекстПисьмаСозданияЗаявки = СтрЗаменить(ТекстПисьмаСозданияЗаявки, "%КонтрагентРазмен%",     РеквизитыМагазина.ИнкассируемыйБанк);
		КонецЕсли;
		//--- AK suvv
		
		Кому = Новый Массив;
		Кому.Добавить(ЭтотОбъект.Магазин.АдресЭлектроннойПочты);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	АК_ГруппыРассылки.Группа,
		|	АК_ГруппыРассылки.ФизЛицо,
		|	АК_ГруппыРассылки.Емейл,
		|	АК_ГруппыРассылки.Телефон,
		|	КонтактнаяИнформация.Представление КАК Представление,
		|	КонтактнаяИнформация.Вид
		|ИЗ
		|	РегистрСведений.АК_ГруппыРассылки КАК АК_ГруппыРассылки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|		ПО АК_ГруппыРассылки.ФизЛицо = КонтактнаяИнформация.Объект
		|ГДЕ
		|	АК_ГруппыРассылки.Группа = &Группа
		|	И КонтактнаяИнформация.Тип = &Тип
		|	И КонтактнаяИнформация.Вид = &Вид";
		
		Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.EmailФизЛица);
		Запрос.УстановитьПараметр("Группа", Справочники.АК_ГруппыРассылки.СозданиеЗаявкиРазмена);
		Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Кому.Добавить(ВыборкаДетальныеЗаписи.Представление);
			//Кому.Добавить("bancom@yandex.ru");
		КонецЦикла;
	
			
		ОтправитьПисьмо("Создана новая заявка на размен",ТекстПисьмаСозданияЗаявки,Кому);

		////Рассылка в 1с уведомления
		////МеханизмОбменаСообщениями
		//МассМагазинов = Новый Массив;
		//МассМагазинов.Добавить(Магазин);
		//ПараметрыСообщения = Новый Структура;
		//ПараметрыСообщения.Вставить("ТипСообщения", Перечисления.ТипыСообщенийМОС.ИнформационноеСообщение);
		//ПараметрыСообщения.Вставить("ВидПолучателей", Перечисления.ВидыПолучателейМОС.СписокМагазинов);
		//ПараметрыСообщения.Вставить("ВсемСменам", Истина);
		//ПараметрыСообщения.Вставить("Тема", "Создана новая заявка на размен");
		//ПараметрыСообщения.Вставить("ТекстСообщения", ТекстПисьмаСозданияЗаявки);
		//ПараметрыСообщения.Вставить("СписокМагазинов", МассМагазинов); //СтруктурныеЕдиницы  Магазин
		//ПараметрыСообщения.Вставить("ОбъектИнициатор", Ссылка.Ссылка);
		//ПараметрыСообщения.Вставить("Отправитель", Справочники.РолиПользователей.Администратор);
		////ПараметрыСообщения.Вставить("ШаблонСообщений", Справочники.ШаблоныСообщенийМОС.УведомлениеЗаданиеТехнолога);
		//
		//СообщениеОбОшибке = "";
		//Попытка
		//	СообщениеОбОшибке = МеханизмОбменаСообщениями.СоздатьИОтправитьСообщение(ПараметрыСообщения, Истина);
		//	СообщениеОбОшибке = ?(ТипЗнч(СообщениеОбОшибке) = Тип("ДокументСсылка.СообщениеМОС"), "", СообщениеОбОшибке);
		//Исключение
		//	СообщениеОбОшибке = ОписаниеОшибки();
		//КонецПопытки; 	
	КонецЕсли;	
	//---АК BARA
КонецПроцедуры

//+++АК BARA ИП-00017699   2018.02.06  
Процедура ОтправитьПисьмо(Тема,Текст,Кому)
	
	АдресОтправки = "no-reply@vkusvill.ru";
	
	УчёткаДляНастройки =  МеханизмОбменаСообщениями.ПолучитьУчетнуюЗаписьПоАдресу( АдресОтправки);	
	Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчёткаДляНастройки);
	
	Почта = Новый ИнтернетПочта;
	Почта.Подключиться(Профиль, ПротоколИнтернетПочты.IMAP);
	
	Письмо = Новый ИнтернетПочтовоеСообщение;
	Письмо.Тема = Тема;
	Письмо.ИмяОтправителя  = ""+СокрЛП(УчёткаДляНастройки)+"";
	Письмо.Отправитель.Адрес = АдресОтправки;
	
	Для каждого Стр Из Кому Цикл
		
		Получатель = Письмо.Получатели.Добавить();
		Получатель.Адрес = Стр;
		
	КонецЦикла; 
	
	ТекстСообщения = Письмо.Тексты.Добавить(Текст);
	Попытка
		Почта.Послать(Письмо);
	Исключение
		Сообщить("Письмо не отправлено. " + ОписаниеОшибки());
	КонецПопытки;	
	Почта.Отключиться();	

КонецПроцедуры


Процедура ПередЗаписью(Отказ)
	НЯКДозаписи = ЭтотОбъект.Ссылка.НомерЯвочнойТочки;
	Ответственный = ПараметрыСеанса.ТекущийПользователь;
	Попытка
		Если ЗначениеЗаполнено(ПараметрыСеанса.ТекущийПродавец) Тогда 
			Ответственный = ПараметрыСеанса.ТекущийПродавец;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Размен.Ссылка
	|ИЗ
	|	Справочник.АК_Размен КАК Размен
	|ГДЕ
	|	Размен.Магазин = &Магазин
	|	И Размен.Ссылка <> &Ссылка
	|	И Размен.ДопДеньРазмена = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Магазин", Магазин);
	Запрос.УстановитьПараметр("Ссылка", ?(ЗначениеЗаполнено(Ссылка),Ссылка,Справочники.АК_Размен.ПустаяСсылка()));
	
	Если Запрос.Выполнить().Пустой()= Ложь и ДопДеньРазмена = Ложь Тогда
		 Отказ = Истина;
		 Сообщить("На один магазин можно создать только одну карту размена.");				
	 КонецЕсли;	
	 
	 //Проверка, что размены по доп дня в разные дни, не пропускать два размена одного магазина на одни день. 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Размен.ГрафикРазмена,
		|	1 КАК КоличествоСтрок
		|ПОМЕСТИТЬ ВТ
		|ИЗ
		|	Справочник.АК_Размен КАК Размен
		|ГДЕ
		|	Размен.Магазин = &Магазин
		|   И Размен.Ссылка <> &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ГрафикРазмена,
		|	1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ.ГрафикРазмена,
		|	КОЛИЧЕСТВО(ВТ.КоличествоСтрок) КАК КоличествоСтрок
		|ПОМЕСТИТЬ ВТ2
		|ИЗ
		|	ВТ КАК ВТ
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ.ГрафикРазмена
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ВТ2.КоличествоСтрок) КАК КоличествоСтрок
		|ИЗ
		|	ВТ2 КАК ВТ2";
	
	Запрос.УстановитьПараметр("ГрафикРазмена", ЭтотОбъект.ГрафикРазмена);
	Запрос.УстановитьПараметр("Магазин", ЭтотОбъект.Магазин);
	Запрос.УстановитьПараметр("Ссылка", ?(ЗначениеЗаполнено(Ссылка),Ссылка,Справочники.АК_Размен.ПустаяСсылка()));

	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		Если ВыборкаДетальныеЗаписи.КоличествоСтрок>1 Тогда
		  Сообщить("По магазину имеется несколько карт размена в один день." );
		КонецЕсли;
	КонецЕсли;	


	 
	 
	 Для каждого Стр Из Раскладка Цикл
		 Если Стр.ДостоинствоВалюты.Кратно <> 0 и Цел(Стр.КоличествоМешков/Стр.ДостоинствоВалюты.Кратно)<> Стр.КоличествоМешков/Стр.ДостоинствоВалюты.Кратно Тогда
			 Сообщить("В строке "+Стр.НомерСтроки+" количество должно быть кратно "+Стр.ДостоинствоВалюты.Кратно+".");
			 Отказ = Истина;				 
		 КонецЕсли;
	 КонецЦикла;
КонецПроцедуры

Процедура Печать() Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ_ЭЛЕМЕНТ(Печать)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	ТабДок = Новый ТабличныйДокумент;
	Макет = Справочники.АК_Размен.ПолучитьМакет("Печать");
	// Заголовок
	Область = Макет.ПолучитьОбласть("Заголовок");
	ТабДок.Вывести(Область);
	// Шапка
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Шапка.Параметры.Заполнить(ЭтотОбъект);
	ТабДок.Вывести(Шапка);
	// Раскладка
	Область = Макет.ПолучитьОбласть("РаскладкаШапка");
	ТабДок.Вывести(Область);
	ОбластьРаскладка = Макет.ПолучитьОбласть("Раскладка");
	Для Каждого ТекСтрокаРаскладка Из Раскладка Цикл
		ОбластьРаскладка.Параметры.Заполнить(ТекСтрокаРаскладка);
		ТабДок.Вывести(ОбластьРаскладка);
	КонецЦикла;
	// Подвал
	Подвал = Макет.ПолучитьОбласть("Подвал");
	Подвал.Параметры.Заполнить(ЭтотОбъект);
	ТабДок.Вывести(Подвал);

	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	//}}_КОНСТРУКТОР_ПЕЧАТИ_ЭЛЕМЕНТ
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	//ОбъектКопирования.Раскладка.Очистить();
	//ОбъектКопирования.СтатусТорговойТочкиЗакрыто = Ложь;
	//ОбъектКопирования.НомерЯвочнойТочки = "";
	//ОбъектКопирования.Магазин = Справочники.СтруктурныеЕдиницы.ПустаяСсылка();
	//ОбъектКопирования.Наименование = "";
КонецПроцедуры
