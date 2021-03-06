﻿
Функция ПолучитьКодПоТипуОперацииЧека()
	
	Если ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип101 Тогда
		Возврат 101;
	ИначеЕсли ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип102 Тогда
		Возврат 102;
	ИначеЕсли ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип103 Тогда
		Возврат 103;
	ИначеЕсли ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип104 Тогда
		Возврат 104;
	ИначеЕсли ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип111 Тогда
		Возврат 111;
	ИначеЕсли ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип112 Тогда
		Возврат 112;
	ИначеЕсли ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип113 Тогда
		Возврат 113;
	ИначеЕсли ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип114 Тогда
		Возврат 114;
	ИначеЕсли ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип201 Тогда
		Возврат 201;
	ИначеЕсли ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип211 Тогда
		Возврат 211;	
	КонецЕсли;	
	
КонецФункции	

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЭтоНовый() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Бланки более на загружать. Возвраты и списания по качеству автоматически напрямую загружаются в обращения покупателей",,,, Отказ);
	КонецЕсли;	
	
	//Если ЭтоНовый() Тогда
	//	
	//	Для каждого ТекСтр Из Товары Цикл
	//		
	//		ТекСтр.ТипЖалобы = Справочники.ТипыЖалоб.НайтиПоНаименованию("00 Пока не выяснили");
	//		ТекСтр.РезультатОбращения = Справочники.РезультатыРассмотренияОбращений.НайтиПоКоду("6");
	//		ТекСтр.ТипОбращения = Справочники.ТипыОбращенийПокупателей.НайтиПоКоду("23");
	//		//ТекСтр.ИсточникОбращения = Справочники.ИсточникиОбращений.НайтиПоКоду("00");
	//		ТекСтр.Продавец1 = Продавец1;
	//		ТекСтр.ДатаСобытия = Дата;
	//		
	//	КонецЦикла;	
	//	
	//КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ТекстИзмененияСкл", "");
	
	Если НЕ ЭтоНовый() Тогда
		
		Массив101 = Новый Массив();
		Массив101.Добавить(Перечисления.ТипыОперацийЧеков.Тип101);
		Массив101.Добавить(Перечисления.ТипыОперацийЧеков.Тип102);
		Массив101.Добавить(Перечисления.ТипыОперацийЧеков.Тип103);
		Массив101.Добавить(Перечисления.ТипыОперацийЧеков.Тип104);
		
		Массив111 = Новый Массив();
		Массив111.Добавить(Перечисления.ТипыОперацийЧеков.Тип111);
		Массив111.Добавить(Перечисления.ТипыОперацийЧеков.Тип112);
		Массив111.Добавить(Перечисления.ТипыОперацийЧеков.Тип113);
		Массив111.Добавить(Перечисления.ТипыОперацийЧеков.Тип114);
		
		Если (ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип201
			ИЛИ ТипОперацииЧека = Перечисления.ТипыОперацийЧеков.Тип211)
			И ТипОперацииЧека <> Ссылка.ТипОперацииЧека Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нельзя менять тип операции чека",,,, Отказ);
		КонецЕсли;
		
		Если Массив101.Найти(Ссылка.ТипОперацииЧека) <> Неопределено
			И Массив101.Найти(ТипОперацииЧека) = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нельзя менять тип операции чека на указанный",,,, Отказ);
		КонецЕсли;
		
		Если Массив111.Найти(Ссылка.ТипОперацииЧека) <> Неопределено
			И Массив111.Найти(ТипОперацииЧека) = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нельзя менять тип операции чека на указанный",,,, Отказ);
		КонецЕсли;
		
		ЭтоМагазин = (ТорговаяТочка.ТипРозничнойТочки = Перечисления.ТипыРозничныхТочек.Магазин);
		Если ТипОперацииЧека <> Ссылка.ТипОперацииЧека Тогда
			СтрокаУины = "";
			Для Каждого СтрокаТаб Из Товары Цикл
				Если ЗначениеЗаполнено(СтрокаТаб.УИНСтроки) Тогда
					СтрокаУины = СтрокаУины + ?(ПустаяСтрока(СтрокаУины), "", ", ") + ВнешниеДанные.ФорматПоля(СокрЛП(СтрокаТаб.УИНСтроки));
				КонецЕсли;	
			КонецЦикла;	
			Если ЭтоМагазин Тогда
				ДополнительныеСвойства.ТекстИзмененияСкл = ДополнительныеСвойства.ТекстИзмененияСкл + ?(ПустаяСтрока(ДополнительныеСвойства.ТекстИзмененияСкл), "", Символы.ПС)
					+ "UPDATE [Loyalty].[dbo].[PurchaseNotificationLine]
   						|SET [ChequeNum] = " + ВнешниеДанные.ФорматПоля(ПолучитьКодПоТипуОперацииЧека()) + "
						|WHERE [row_rep] IN (" + СтрокаУины + ")";
			Иначе
				ДополнительныеСвойства.ТекстИзмененияСкл = ДополнительныеСвойства.ТекстИзмененияСкл + ?(ПустаяСтрока(ДополнительныеСвойства.ТекстИзмененияСкл), "", Символы.ПС)
					+ "UPDATE [SMS_IZBENKA].[dbo].[CheckLine]
   						|SET [OperationType_cl] = " + ВнешниеДанные.ФорматПоля(ПолучитьКодПоТипуОперацииЧека()) + "
						|WHERE [CheckLineUID] IN (" + СтрокаУины + ")";		
			КонецЕсли;	
		КонецЕсли;
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Таб", Товары);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст = "ВЫБРАТЬ
		               |	БланкТовары.УИНСтроки,
		               |	БланкТовары.Характеристика,
		               |	БланкТовары.ТипСписанияВозврата
		               |ПОМЕСТИТЬ ВТ_ТекДанные
		               |ИЗ
		               |	&Таб КАК БланкТовары
		               |ГДЕ
		               |	БланкТовары.УИНСтроки <> """"
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ВТ_ТекДанные.УИНСтроки,
		               |	ВТ_ТекДанные.ТипСписанияВозврата,
		               |	ЕСТЬNULL(ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК Справочник.Контрагенты).ИД, 0) КАК ИДПроизводитель
		               |ИЗ
		               |	ВТ_ТекДанные КАК ВТ_ТекДанные
		               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		               |			БланкТовары.УИНСтроки КАК УИНСтроки,
		               |			БланкТовары.ТипСписанияВозврата КАК ТипСписанияВозврата,
		               |			БланкТовары.Характеристика КАК Характеристика
		               |		ИЗ
		               |			ВТ_ТекДанные КАК ВТ_ТекДанные
		               |				ЛЕВОЕ СОЕДИНЕНИЕ Документ.Бланк.Товары КАК БланкТовары
		               |				ПО ВТ_ТекДанные.УИНСтроки = БланкТовары.УИНСтроки
		               |		ГДЕ
		               |			БланкТовары.Ссылка = &Ссылка
		               |			И БланкТовары.УИНСтроки <> """") КАК ВЗ_Док
		               |		ПО ВТ_ТекДанные.УИНСтроки = ВЗ_Док.УИНСтроки
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		               |		ПО ВТ_ТекДанные.Характеристика = ЗначенияСвойствОбъектов.Объект
		               |			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
		               |ГДЕ
		               |	(ВТ_ТекДанные.ТипСписанияВозврата <> ВЗ_Док.ТипСписанияВозврата
		               |			ИЛИ ВТ_ТекДанные.Характеристика <> ВЗ_Док.Характеристика)
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |УНИЧТОЖИТЬ ВТ_ТекДанные";
					   
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СтрокаДока = Товары.Найти(Выборка.УИНСтроки, "УИНСтроки");
			Если СтрокаДока <> Неопределено Тогда
				СтрокаДока.СотрудникМенявшийТипСписанияВозврата = ПараметрыСеанса.ТекущийПользователь;
			КонецЕсли;	
			Если ЭтоМагазин Тогда
				ДополнительныеСвойства.ТекстИзмененияСкл = ДополнительныеСвойства.ТекстИзмененияСкл + ?(ПустаяСтрока(ДополнительныеСвойства.ТекстИзмененияСкл), "", ";" + Символы.ПС)
					+ "UPDATE [Loyalty].[dbo].[PurchaseNotificationLine]
   						|SET [id_reason] = " + ВнешниеДанные.ФорматПоля(Выборка.ТипСписанияВозврата.ИД) + ", [Summ] = " + ?(ЗначениеЗаполнено(Выборка.ИДПроизводитель), ВнешниеДанные.ФорматПоля(Выборка.ИДПроизводитель), "0") + "
						|WHERE [row_rep] IN (" + ВнешниеДанные.ФорматПоля(Выборка.УИНСтроки) + ")";
			Иначе
				ДополнительныеСвойства.ТекстИзмененияСкл = ДополнительныеСвойства.ТекстИзмененияСкл + ?(ПустаяСтрока(ДополнительныеСвойства.ТекстИзмененияСкл), "", ";" + Символы.ПС)
					+ "UPDATE [SMS_IZBENKA].[dbo].[CheckLine]
   						|SET [id_reason] = " + ВнешниеДанные.ФорматПоля(Выборка.ТипСписанияВозврата.ИД) + ", [ManufacturerID] = " + ?(ЗначениеЗаполнено(Выборка.ИДПроизводитель), ВнешниеДанные.ФорматПоля(Выборка.ИДПроизводитель), "0") + "
						|WHERE [CheckLineUID] IN (" + ВнешниеДанные.ФорматПоля(Выборка.УИНСтроки) + ")";
			КонецЕсли;
		КонецЦикла;	
		
		Если ОбщегоНазначения.ЭтоКопияБазы() Тогда
			ДополнительныеСвойства.ТекстИзмененияСкл = "";
		КонецЕсли;	
		
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ИД) Тогда
		ИД = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Не Отказ Тогда
		ЗагрузитьИзБланковНаСервере();
		Если ЗначениеЗаполнено(ДополнительныеСвойства.ТекстИзмененияСкл) Тогда
			ADOСоединение = Новый COMОбъект("ADODB.Connection");
			ADOСоединение.ConnectionTimeOut = 0;
			ADOСоединение.CommandTimeOut    = 0;
			
			СтрСоедиение = ОбменСAccess.ПолучитьСтрокуСоединения("sms_izbenka");
			
			ADOСоединение.ConnectionString  = СтрСоедиение;
			ADOСоединение.Open();
			
			ADOСоединение.Execute(ДополнительныеСвойства.ТекстИзмененияСкл);
			
			ADOСоединение.Close();
			
			ADOСоединение = Неопределено;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьИзБланковНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Бланк.Ссылка КАК GUID_Загрузки,
		|	Бланк.Номер КАК Номер_Бланка,
		|	Бланк.Дата КАК ДатаДок,
		|	Бланк.ИД,
		|	Бланк.ТипБланка КАК Тип_Бланка,
		|	Бланк.ТорговаяТочка КАК СтруктурнаяЕдиница,
		|	БланкТовары.Номенклатура,
		|	БланкТовары.Проблема,
		|	БланкТовары.ИсточникОбращения,
		|	БланкТовары.ТипОбращения,
		|	БланкТовары.ФИО_Покупателя,
		|	БланкТовары.Телефон,
		|	БланкТовары.email,
		|	БланкТовары.ДатаСобытия,
		|	БланкТовары.Продавец1,
		|	БланкТовары.Примечание,
		|	БланкТовары.ТипЖалобы,
		|	БланкТовары.Номер_Бланка КАК Номер_Бланка1,
		|	БланкТовары.Номер_Карты_ОК,
		|	0 КАК id_OK,
		|	ЗначенияСвойствОбъектов.Значение КАК Производитель
		|ИЗ
		|	Документ.Бланк.Товары КАК БланкТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Бланк КАК Бланк
		|		ПО БланкТовары.Ссылка = Бланк.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО (БланкТовары.Характеристика = ЗначенияСвойствОбъектов.Объект
		|				И ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
		|ГДЕ
		|	Бланк.Ссылка = &Ссылка
		|	И БланкТовары.Ссылка = &Ссылка";
    
	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	ТЗРезультат = Запрос.Выполнить().Выгрузить();
	ТЗСсылок = ТЗРезультат.Скопировать();
	ТЗСсылок.Свернуть("GUID_Загрузки","");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОбращенияПокупателей.id_OK КАК id_OK
		|ИЗ
		|	РегистрСведений.ОбращенияПокупателей КАК ОбращенияПокупателей
		|
		|УПОРЯДОЧИТЬ ПО
		|	id_OK УБЫВ";

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
    ТекПоследнийНомер = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ТекПоследнийНомер = ВыборкаДетальныеЗаписи.id_OK;
	КонецЦикла;
 
    Для каждого ТекСтр Из ТЗРезультат Цикл
		
		ТекПоследнийНомер = ТекПоследнийНомер+1;
		ТекСтр.id_OK = ТекПоследнийНомер;	
		
	КонецЦикла;
	
	Для каждого ТекСтрокаСсылок Из ТЗСсылок Цикл
 
 		набор = РегистрыСведений.ОбращенияПокупателей.СоздатьНаборЗаписей();
		набор.Отбор.GUID_Загрузки.Установить(ТекСтрокаСсылок.GUID_Загрузки);
		набор.Прочитать();
		набор.Очистить();
		
		ТекОтборТЗ = Новый Структура;
		ТекОтборТЗ.Вставить("GUID_Загрузки", ТекСтрокаСсылок.GUID_Загрузки);
		МассивНайденыхСтрок = ТЗРезультат.НайтиСтроки(ТекОтборТЗ);
		
		Для каждого ТекСтрМасс Из МассивНайденыхСтрок Цикл
  
  	    	НоваяСтрокаНабора = набор.Добавить();	
            ЗаполнитьЗначенияСвойств(НоваяСтрокаНабора, ТекСтрМасс); 
			
			Если НЕ ЗначениеЗаполнено(НоваяСтрокаНабора.ТипЖалобы) Тогда
					НоваяСтрокаНабора.ТипЖалобы = Справочники.ТипыЖалоб.НайтиПоНаименованию("00 Пока не выяснили");
			КонецЕсли;		
			
			Если НЕ ЗначениеЗаполнено(НоваяСтрокаНабора.РезультатОбращения) Тогда	
				НоваяСтрокаНабора.РезультатОбращения = Справочники.РезультатыРассмотренияОбращений.НайтиПоКоду("6");
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(НоваяСтрокаНабора.ТипОбращения) Тогда	
				НоваяСтрокаНабора.ТипОбращения = Справочники.ТипыОбращенийПокупателей.НайтиПоКоду("23");
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(НоваяСтрокаНабора.ИсточникОбращения) Тогда	
				НоваяСтрокаНабора.ИсточникОбращения = Справочники.ИсточникиОбращений.НайтиПоКоду("00");
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(НоваяСтрокаНабора.Продавец1) Тогда
				НоваяСтрокаНабора.Продавец1 = Продавец1;
			КонецЕсли;
			//Если НЕ ЗначениеЗаполнено(НоваяСтрокаНабора.ДатаСобытия) Тогда
			//	НоваяСтрокаНабора.ДатаСобытия = Дата;
			//КонецЕсли;	
			
			НоваяСтрокаНабора.ДатаДок = Дата;
			НоваяСтрокаНабора.Номер_Карты_ОК = Формат(ТекСтрМасс.Номер_Карты_ОК, "ЧЦ=7; ЧДЦ=0; ЧН=0000000; ЧВН=; ЧГ=");
			
		КонецЦикла;
		
		Попытка
			набор.Записать();		
			Сообщить("Загрузили данные по документу: "+ТекСтрокаСсылок.GUID_Загрузки);
		Исключение
			Сообщить("Не удалось загрузить данные по документу: "+ТекСтрокаСсылок.GUID_Загрузки, СтатусСообщения.ОченьВажное);
		КонецПопытки;	
		
	КонецЦикла;
	
КонецПроцедуры	

