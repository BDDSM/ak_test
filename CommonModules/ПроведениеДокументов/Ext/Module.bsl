﻿// Возвращает перечень регистров, которые требуется очистить
//
Функция МассивРегистровНужноОчистить(ДокументОбъект) Экспорт
	
	МассивРегистров = Новый Массив();
	
	Для Каждого Движение ИЗ ДокументОбъект.Метаданные().Движения Цикл
		МассивРегистров.Добавить(Движение.ПолноеИмя());
	КонецЦикла; 
	
	Возврат МассивРегистров;
	
КонецФункции

Процедура ПроверкаНедействующихДоговоровОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	возврат;
	Если  (ТипЗнч(Источник)=Тип("ДокументОбъект.РасходИзБанка") или ТипЗнч(Источник)=Тип("ДокументОбъект.ЗаявкаНаРасходованиеСредств")
		или ТипЗнч(Источник)=Тип("ДокументОбъект.ПоступлениеТоваровУслуг") ) и ЗначениеЗаполнено(Источник.ДоговорКонтрагента) Тогда
		Срок=Источник.ДоговорКонтрагента.ПолучитьОбъект().СрокДействияДоговора();
		
		Если Срок<>Дата(1,1,1) и  Срок < Источник.Дата Тогда
			Сообщить("Срок действия договора "+Источник.ДоговорКонтрагента+" закончился у контрагента: "+Источник.Контрагент);
		КонецЕсли;	
	ИначеЕсли ТипЗнч(Источник)=Тип("ДокументОбъект.НачислениеАренднойПлатыОтАрендодателей") Тогда
		Для каждого стр из Источник.НачислениеАренды Цикл
			Если не значениеЗаполнено(Стр.Договор) Тогда
				продолжить;
			КонецЕсли;	
			Срок=Стр.Договор.ПолучитьОбъект().СрокДействияДоговора();
			Если Срок<>Дата(1,1,1) и  Срок<Источник.Дата Тогда
				Сообщить("Срок действия договора "+Стр.Договор+" закончился у контрагента: "+Стр.Контрагент);
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;
КонецПроцедуры

Процедура СоздатьЗадачуПоДокументу(пДокумент, пВидЗадачи, пИсполнитель, пНаименование="")
	обЗадача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
	обЗадача.ВидЗадачи = пВидЗадачи;
	обЗадача.Дата = ТекущаяДата();
	обЗадача.ОбъектЗадачи = пДокумент.ЗаявкаНаРасходованиеСредств;
	обЗадача.Ответственный = пДокумент.Ответственный;	
	обЗадача.Исполнитель = пИсполнитель;	
	//обЗадача.Организация = пДокумент.Организация;
	обЗадача.Оповещение = Истина;
	обЗадача.СрокИсполнения = КонецДня(ТекущаяДата());
	обЗадача.СрокОповещения = ТекущаяДата()+10;
	обЗадача.Контрагент = пДокумент.Контрагент;
	обЗадача.Наименование = пНаименование;
	Попытка
		обЗадача.Записать();
	Исключение
		Сообщить(ОписаниеОшибки())
	КонецПопытки
	
	//Задача = обЗадача.Ссылка;
	//Записать(РежимЗаписиДокумента.Запись);
КонецПроцедуры

Процедура РасходИзБанкаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	//Если РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения Тогда
	//	ОшибкаЛимиты = НЕ Источник.ПроверитьЛимиты();
	//	Отказ = Отказ Или ОшибкаЛимиты;
	//	Если ОшибкаЛимиты Тогда
	//		ТекстОшибки = "Не записан платеж на основании "+Строка(Источник.ЗаявкаНаРасходованиеСредств)+" на сумму "+Строка(Источник.СуммаДокумента);
	//		Источник.СоздатьЗадачуПоДокументу(Источник, Справочники.ВидыЗадачПользователей.НеЗаписанПлатеж, Источник.Ответственный,ТекстОшибки);	
	//		Сообщить("Для документа "+Строка(Источник.НомерВходящегоДокумента)+" от "+Строка(Источник.Дата)+" превышены лимиты деб.задолженности");
	//	КонецЕсли;
	//КонецЕсли;
КонецПроцедуры


Процедура ДокументыОбработкаПроведенияОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	
	Если Источник.Движения.Найти("РасчетыСКонтрагентами") <> Неопределено И НЕ Отказ Тогда
		
		Если ТипЗнч(Источник) = Тип("ДокументОбъект.ПоступлениеТоваровУслуг") ИЛИ 
			//+++АК POZM 2017.10.22 ИП-00017015 
			ТипЗнч(Источник) = Тип("ДокументОбъект.ПоступлениеДопРасходов") ИЛИ 
			//---АК POZM  
			ТипЗнч(Источник) = Тип("ДокументОбъект.РасходИзБанка") Тогда
			
			Источник.ВыполнитьДвиженияПоРасчетамСКонтрагентами();
			//+++ AK pozm 30.08.2017 ИП-00016568
		ИначеЕсли ТипЗнч(Источник) = Тип("ДокументОбъект.СвязьДокументовВРасчетахСКонтрагентами")
			  //+++АК ILIK 2018.09.19 ИП-00019521.04
			  //Тогда
			  Или ТипЗнч(Источник) = Тип("ДокументОбъект.ЛистУчета") Тогда
			  //---АК ILIK
			//--- AK pozm 30.08.2017 ИП-00016568	
		Иначе
			
			БухгалтерскийУчетРасчетовСКонтрагентами.СформироватьДвиженияПоРасчетамСКонтрагентами(Источник);		
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	//+++ AK pozm 13.08.2017 ИП-00016298
	СформироватьДвиженияПоРасчетамПоСделкам(Источник);
	//--- AK pozm 13.08.2017 ИП-00016298
	
	//+++ AK pozm 11.09.2017 ИП-00016323
	СторнироватьРасчетыСКонтрагентамиПоВозвратуВБанк(Источник);
	//--- AK pozm 11.09.2017 ИП-00016323
	
	//+++ AK pozm 17.08.2017 ИП-00016294
	Попытка  // на период тестов
		КонтрольРасхожденияРегистров(Источник,Отказ);
	Исключение
		ЗаписьЖурналаРегистрации("Контроль регистров",
		УровеньЖурналаРегистрации.Ошибка, 
		,Источник.Ссылка, 
		ОписаниеОшибки()); 
		
	КонецПопытки	
	//--- AK pozm 17.08.2017 ИП-00016294
КонецПроцедуры

Процедура ДокументыПередЗаписьюПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.Движения.Найти("РасчетыСКонтрагентами") <> Неопределено Тогда
		
		Если  РежимЗаписи = РежимЗаписиДокумента.Проведение И НЕ Отказ И Источник.Метаданные().УдалениеДвижений = Метаданные.СвойстваОбъектов.УдалениеДвижений.УдалятьАвтоматически Тогда
			Источник.Движения.РасчетыСКонтрагентами.ДополнительныеСвойства.Вставить("ЭтоУдалениеДвижений", Истина);
		Иначе
			Источник.Движения.РасчетыСКонтрагентами.ДополнительныеСвойства.Очистить();
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если ТипЗнч(Источник)=Тип("ДокументОбъект.ПоступлениеТоваровУслуг") ИЛИ ТипЗнч(Источник)=Тип("ДокументОбъект.ДоставкаНаТТ") ИЛИ ТипЗнч(Источник)=Тип("ДокументОбъект.МаршрутныйЛист") ИЛИ ТипЗнч(Источник)=Тип("ДокументОбъект.ОбщиеТранспортныеРасходы") Тогда
		Если ЗначениеЗаполнено(Источник.ДокументОснование) И ТипЗнч(Источник.ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаУслугиМатериалы") И Источник.Заявка <> Источник.ДокументОснование Тогда
			Источник.Заявка = Источник.ДокументОснование;
		КонецЕсли;	
	КонецЕсли;
	
	//+++ak ziga ИП-00015987 2017111201
	
	Если Не Источник.ОбменДанными.Загрузка И (ТипЗнч(Источник)=Тип("ДокументОбъект.РасторжениеДоговораАренды") Или ТипЗнч(Источник)=Тип("ДокументОбъект.ЗаключениеДоговораАренды") Или ТипЗнч(Источник)=Тип("ДокументОбъект.ДополнительноеСоглашение") )Тогда
		
			
	Если Не Источник.ДоговорКонтрагента=Справочники.ДоговорыКонтрагентов.ПустаяСсылка() Тогда
		Аренда=?(Источник.ДоговорКонтрагента.ТипДоговора=Перечисления.ТипыДоговоровСПоставщиком.Аренда,Истина,Ложь);	
		//НаименованиеДопПрава="Доступ к документам аренды";	
		МассивПраваАренда=УправлениеДопПравамиПользователей.ПрочитатьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.ДоступКДокументамАренды,Ложь,ПараметрыСеанса.ТекущийПользователь);	
		ПравоАренда=МассивПраваАренда[0];
		//НаименованиеДопПрава="Может редактировать договора в документах аренды";	
		//МассивПраваНаИзменениеДоговора=УправлениеДопПравамиПользователей.ПрочитатьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.НайтиПоНаименованию(НаименованиеДопПрава),Ложь,ПараметрыСеанса.ТекущийПользователь);	
		//ПравоИзменениеДоговора=МассивПраваНаИзменениеДоговора[0];
		
		Если не РольДоступна("ПолныеПрава") Тогда
			Если Аренда и Не ПравоАренда Тогда
				Сообщить("Нет прав на изменение документов Аренда");
				Отказ=Истина;
				
				//ЭтаФорма.ТолькоПросмотр=Не ПравоАренда;
				//ЭлементыФормы.ДоговорАренды.Доступность=ПравоИзменениеДоговора;
			КонецЕсли;		
		КонецЕсли;
	КонецЕсли;
	КонецЕсли;
	//---ak ziga ИП-00015987 2017111201

КонецПроцедуры

Процедура ДокументыПриЗаписиПриЗаписи(Источник, Отказ) Экспорт
	
	Попытка 
		
		УстановитьПривилегированныйРежим(Истина);
		
		ЗаявкаСБИС = Ложь;
		
		Если ТипЗнч(Источник) = Тип("ДокументОбъект.ПоступлениеТоваровУслуг") Тогда
			ЗаявкаСБИС = Источник.ДокументОснование
		ИначеЕсли ТипЗнч(Источник) = Тип("ДокументОбъект.ПоступлениеДопРасходов") Тогда
			ЗаявкаСБИС = Источник.ЗаявкаНаРсходованиеСредств
		КонецЕсли;
		
		Если ЗаявкаСБИС <> Ложь Тогда
			
			Запрос = Новый Запрос("ВЫБРАТЬ
			|	ЗначенияСвойствОбъектов.Значение
			|ИЗ
			|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
			|ГДЕ
			|	ЗначенияСвойствОбъектов.Объект = &Объект
			|	И ЗначенияСвойствОбъектов.Свойство.Наименование = ""ДокументСБИС_Ид""
			|	И ЗначенияСвойствОбъектов.Значение <> """"");
			
			Запрос.УстановитьПараметр("Объект", Источник.Ссылка);
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Если Выборка.Следующий() Тогда
				МЗ = РегистрыСведений.СБИС_Заявки.СоздатьМенеджерЗаписи();
				
				МЗ.ИД = Выборка.Значение;
				МЗ.Прочитать();
				
				Если МЗ.Выбран() И МЗ.Заявка <> ЗаявкаСБИС Тогда				
					МЗ.Заявка = ЗаявкаСБИС;
					МЗ.Записать();
				КонецЕсли; 
			КонецЕсли;   
			
			
		КонецЕсли; 
		
	Исключение
	КонецПопытки;
	
КонецПроцедуры

//+++ AK pozm 13.08.2017 ИП-00016298
Процедура СформироватьДвиженияПоРасчетамПоСделкам(ДокОбъект)
	Если ТипЗнч(ДокОбъект) = Тип("ДокументОбъект.КорректировкаВзаиморасчетов") Тогда
		
		ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками.Записывать = Истина;
		ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками.Очистить();
		
		ТЗДвиженийПоСделкам=Новый ТаблицаЗначений;
		ТЗДвиженийПоСделкам.Колонки.Добавить("Сделка");
		ТЗДвиженийПоСделкам.Колонки.Добавить("Сумма");
		Для Каждого ДвижениеВРасчеты Из ДокОбъект.Движения.РасчетыСКонтрагентами Цикл
			Если ЗначениеЗаполнено(ДвижениеВРасчеты.Сделка) И ТипЗнч(ДвижениеВРасчеты.Сделка) = Тип("ДокументСсылка.СделкаСПоставщиком") Тогда
				НС = ТЗДвиженийПоСделкам.Добавить();
				НС.Сделка = ДвижениеВРасчеты.Сделка;
				Если ДвижениеВРасчеты.ВидДвижения = ВидДвиженияНакопления.Приход Тогда
					НС.Сумма = -ДвижениеВРасчеты.Сумма;
				Иначе
					НС.Сумма = ДвижениеВРасчеты.Сумма;
				КонецЕсли;	
			КонецЕсли;	
		КонецЦикла;	
		ТЗДвиженийПоСделкам.Свернуть("Сделка","Сумма");
		Если ТЗДвиженийПоСделкам.Количество()=0 Тогда
			Возврат;
		КонецЕсли;	
		ТекстЗапроса="ВЫБРАТЬ
		|	РасчетыПоСделкамСПоставщикамиОстатки.Сделка,
		|	РасчетыПоСделкамСПоставщикамиОстатки.УИН_Этапа,
		|	РасчетыПоСделкамСПоставщикамиОстатки.Комплектация,
		|	РасчетыПоСделкамСПоставщикамиОстатки.УИН_СтрокиКомплектации,
		|	РасчетыПоСделкамСПоставщикамиОстатки.ДатаПлатежа КАК ДатаПлатежа,
		|	РасчетыПоСделкамСПоставщикамиОстатки.СуммаОстаток КАК Сумма
		|ИЗ
		|	РегистрНакопления.РасчетыПоСделкамСПоставщиками.Остатки(
		|			&НаДату,
		|			Сделка В (&Сделки)
		|				И ДатаПлатежа <> ДАТАВРЕМЯ(1, 1, 1)) КАК РасчетыПоСделкамСПоставщикамиОстатки
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаПлатежа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РасчетыПоСделкамСПоставщиками.Сделка,
		|	РасчетыПоСделкамСПоставщиками.УИН_Этапа,
		|	РасчетыПоСделкамСПоставщиками.Комплектация,
		|	РасчетыПоСделкамСПоставщиками.УИН_СтрокиКомплектации,
		|	РасчетыПоСделкамСПоставщиками.ДатаПлатежа,
		|	РасчетыПоСделкамСПоставщиками.Сумма
		|ИЗ
		|	РегистрНакопления.РасчетыПоСделкамСПоставщиками КАК РасчетыПоСделкамСПоставщиками
		|ГДЕ
		|	РасчетыПоСделкамСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|	И РасчетыПоСделкамСПоставщиками.Сделка В(&Сделки)
		|	И РасчетыПоСделкамСПоставщиками.ДатаПлатежа <> ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	РасчетыПоСделкамСПоставщиками.ДатаПлатежа УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РасчетыПоСделкамСПоставщиками.Сделка,
		|	РасчетыПоСделкамСПоставщиками.УИН_Этапа,
		|	РасчетыПоСделкамСПоставщиками.Комплектация,
		|	РасчетыПоСделкамСПоставщиками.УИН_СтрокиКомплектации,
		|	РасчетыПоСделкамСПоставщиками.ДатаПлатежа,
		|	РасчетыПоСделкамСПоставщиками.Сумма
		|ИЗ
		|	РегистрНакопления.РасчетыПоСделкамСПоставщиками КАК РасчетыПоСделкамСПоставщиками
		|ГДЕ
		|	РасчетыПоСделкамСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|	И РасчетыПоСделкамСПоставщиками.Сделка В(&Сделки)
		|	И РасчетыПоСделкамСПоставщиками.ДатаПлатежа <> ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	РасчетыПоСделкамСПоставщиками.ДатаПлатежа УБЫВ";
		Запрос = Новый Запрос(ТекстЗапроса);			 
		Запрос.УстановитьПараметр("Сделки",ТЗДвиженийПоСделкам.ВыгрузитьКолонку("Сделка"));
		Запрос.УстановитьПараметр("НаДату",ДокОбъект.Дата);
		Результаты = Запрос.ВыполнитьПакет();
		ТабОстатков = Результаты[0].Выгрузить();
		ТабПриходов = Результаты[1].Выгрузить();
		ТабРасходов = Результаты[2].Выгрузить();
		Для Каждого СтрокаСделки ИЗ ТЗДвиженийПоСделкам Цикл
			Если СтрокаСделки.Сумма = 0 Тогда
				Продолжить;
			КонецЕсли;	
			Если СтрокаСделки.Сумма > 0 Тогда
				Осталось = СтрокаСделки.Сумма;
				Если Осталось>0 Тогда
					СтрокиКСписанию = ТабРасходов.НайтиСтроки(Новый Структура("Сделка",СтрокаСделки.Сделка));
					Для каждого СтрокаКСписанию Из СтрокиКСписанию Цикл
						Если Осталось = 0 Тогда
							Прервать;
						КонецЕсли;
						
						НД = ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками.ДобавитьПриход();
						ЗаполнитьЗначенияСвойств(НД,СтрокаКСписанию);
						НД.Период = ДокОбъект.Дата;
						Осталось = Осталось-НД.Сумма;
						Если Осталось<0 Тогда
							НД.Сумма = НД.Сумма+Осталось;
							Осталось=0;
						КонецЕсли;	
						
					КонецЦикла;	
				КонецЕсли;	
				
				Если Осталось>0 Тогда
					СтрокиКСписанию = ТабПриходов.НайтиСтроки(Новый Структура("Сделка",СтрокаСделки.Сделка));
					Для каждого СтрокаКСписанию Из СтрокиКСписанию Цикл
						Если Осталось = 0 Тогда
							Прервать;
						КонецЕсли;
						
						НД = ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками.ДобавитьПриход();
						ЗаполнитьЗначенияСвойств(НД,СтрокаКСписанию);
						НД.Период = ДокОбъект.Дата;
						Осталось = Осталось-НД.Сумма;
						Если Осталось<0 Тогда
							НД.Сумма = НД.Сумма+Осталось;
							Осталось=0;
						КонецЕсли;	
						
					КонецЦикла;	
				КонецЕсли;	
			Иначе
				Осталось = -СтрокаСделки.Сумма;
				СтрокиКСписанию = ТабОстатков.НайтиСтроки(Новый Структура("Сделка",СтрокаСделки.Сделка));
				Для каждого СтрокаКСписанию Из СтрокиКСписанию Цикл
					Если Осталось = 0 Тогда
						Прервать;
					КонецЕсли;
					
					НД = ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками.ДобавитьРасход();
					ЗаполнитьЗначенияСвойств(НД,СтрокаКСписанию);
					НД.Период = ДокОбъект.Дата;
					Осталось = Осталось-НД.Сумма;
					Если Осталось<0 Тогда
						НД.Сумма = НД.Сумма+Осталось;
						Осталось=0;
					КонецЕсли;	
					
				КонецЦикла;	
				Если Осталось>0 Тогда
					СтрокиКСписанию = ТабПриходов.НайтиСтроки(Новый Структура("Сделка",СтрокаСделки.Сделка));
					Для каждого СтрокаКСписанию Из СтрокиКСписанию Цикл
						Если Осталось = 0 Тогда
							Прервать;
						КонецЕсли;
						
						НД = ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками.ДобавитьРасход();
						ЗаполнитьЗначенияСвойств(НД,СтрокаКСписанию);
						НД.Период = ДокОбъект.Дата;
						Осталось = Осталось-НД.Сумма;
						Если Осталось<0 Тогда
							НД.Сумма = НД.Сумма+Осталось;
							Осталось=0;
						КонецЕсли;	
						
					КонецЦикла;	
				КонецЕсли;	
				
				Если Осталось>0 Тогда
					СтрокиКСписанию = ТабРасходов.НайтиСтроки(Новый Структура("Сделка",СтрокаСделки.Сделка));
					Для каждого СтрокаКСписанию Из СтрокиКСписанию Цикл
						Если Осталось = 0 Тогда
							Прервать;
						КонецЕсли;
						
						НД = ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками.ДобавитьРасход();
						ЗаполнитьЗначенияСвойств(НД,СтрокаКСписанию);
						НД.Период = ДокОбъект.Дата;
						Осталось = Осталось-НД.Сумма;
						Если Осталось<0 Тогда
							НД.Сумма = НД.Сумма+Осталось;
							Осталось=0;
						КонецЕсли;	
						
					КонецЦикла;	
				КонецЕсли;	
				
			КонецЕсли;
			Если Осталось<>0 Тогда
				Сообщить("Не удалось синхронизировать движения по сделке "+СтрокаСделки.Сделка);
			КонецЕсли;	
		КонецЦикла;	
		//+++ AK pozm 11.09.2017 ИП-00016323
	ИначеЕсли ТипЗнч(ДокОбъект) = Тип("ДокументОбъект.ПоступлениеВБанк") Тогда
		
		ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками.Записывать = Истина;
		ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками.Очистить();
		
		ТекстЗапроса="ВЫБРАТЬ
		             |	РасчетыПоСделкамСПоставщиками.ВидДвижения,
		             |	РасчетыПоСделкамСПоставщиками.Сделка,
		             |	РасчетыПоСделкамСПоставщиками.УИН_Этапа,
		             |	РасчетыПоСделкамСПоставщиками.Комплектация,
		             |	РасчетыПоСделкамСПоставщиками.УИН_СтрокиКомплектации,
		             |	РасчетыПоСделкамСПоставщиками.ДатаПлатежа,
		             |	РасчетыПоСделкамСПоставщиками.Сумма,
		             |	РасчетыПоСделкамСПоставщиками.Регистратор
		             |ИЗ
		             |	РегистрНакопления.РасчетыПоСделкамСПоставщиками КАК РасчетыПоСделкамСПоставщиками
		             |ГДЕ
		             |	РасчетыПоСделкамСПоставщиками.Регистратор В(&МассивРасходников)";
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("МассивРасходников",ДокОбъект.РасходБанка.ВыгрузитьКолонку("ДокументРасходИзБанка"));
		ТЗДвиженийРасходников = Запрос.Выполнить().Выгрузить();
		Для Каждого СтрокаРасходника ИЗ ДокОбъект.РасходБанка Цикл
			Расходник = СтрокаРасходника.ДокументРасходИзБанка;
			СуммаВозврата = СтрокаРасходника.Сумма;
			СтруктураПоиска = Новый Структура("Регистратор,Сумма",Расходник,СуммаВозврата);
			НайденныеСтроки = ТЗДвиженийРасходников.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество()>0 Тогда
				НД = ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками.Добавить();
				ЗаполнитьЗначенияСвойств(НД,НайденныеСтроки[0],,"Регистратор");
				НД.Сумма = -НД.Сумма;
				НД.Период = ДокОбъект.Дата;
			Иначе
				ОсталосьВернуть = СуммаВозврата;
				СтруктураПоиска = Новый Структура("Регистратор",Расходник);
				НайденныеСтроки = ТЗДвиженийРасходников.НайтиСтроки(СтруктураПоиска);
				Если НайденныеСтроки.Количество()>0 Тогда
					Для Каждого Стр Из НайденныеСтроки Цикл
						НД = ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками.Добавить();
						ЗаполнитьЗначенияСвойств(НД,НайденныеСтроки[0],,"Регистратор");
						СуммаДв=Мин(ОсталосьВернуть,НД.Сумма);
						ОсталосьВернуть = ОсталосьВернуть - СуммаДв;
						НД.Сумма = -СуммаДв;
						НД.Период = ДокОбъект.Дата;
						Если ОсталосьВернуть = 0 Тогда
							Прервать;
						КонецЕсли;	
					КонецЦикла;	
					Если ОсталосьВернуть<>0 Тогда
						Сообщить("Не все движения расходника банка по сделкам удалось сторнировать - "+Расходник);
					КонецЕсли;	
				КонецЕсли;	
			КонецЕсли;	
		КонецЦикла;	
		//--- AK pozm 11.09.2017 ИП-00016323
	КонецЕсли;	
КонецПроцедуры	
//--- AK pozm 13.08.2017 ИП-00016298

//+++ AK pozm 11.09.2017 ИП-00016323
Процедура СторнироватьРасчетыСКонтрагентамиПоВозвратуВБанк(ДокОбъект)
	Если ТипЗнч(ДокОбъект) = Тип("ДокументОбъект.ПоступлениеВБанк") Тогда
		Если ДокОбъект.РасходБанка.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;	
		ДокОбъект.Движения.РасчетыСКонтрагентами.Записывать = Истина;
		ДокОбъект.Движения.РасчетыСКонтрагентами.Очистить();
		
		ТекстЗапроса="ВЫБРАТЬ
		             |	РасчетыСКонтрагентами.ВидДвижения,
		             |	РасчетыСКонтрагентами.Организация,
		             |	РасчетыСКонтрагентами.Контрагент,
		             |	РасчетыСКонтрагентами.СчетУчета,
		             |	РасчетыСКонтрагентами.Сделка,
		             |	РасчетыСКонтрагентами.Сумма,
		             |	РасчетыСКонтрагентами.АвансПоСделке,
		             |	РасчетыСКонтрагентами.ДокументДт,
		             |	РасчетыСКонтрагентами.Регистратор
		             |ИЗ
		             |	РегистрНакопления.РасчетыСКонтрагентами КАК РасчетыСКонтрагентами
		             |ГДЕ
		             |	РасчетыСКонтрагентами.Регистратор В(&МассивРасходников)";
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("МассивРасходников",ДокОбъект.РасходБанка.ВыгрузитьКолонку("ДокументРасходИзБанка"));
		ТЗДвиженийРасходников = Запрос.Выполнить().Выгрузить();
		Для Каждого СтрокаРасходника ИЗ ДокОбъект.РасходБанка Цикл
			Расходник = СтрокаРасходника.ДокументРасходИзБанка;
			СуммаВозврата = СтрокаРасходника.Сумма;
			СтруктураПоиска = Новый Структура("Регистратор,Сумма",Расходник,СуммаВозврата);
			//+++АК SHEP 2018.01.12 ИП-00017636
			СтруктураПоиска.Вставить("СчетУчета", ДокОбъект.СчетУчетаРасчетовСКонтрагентом);
			//---АК SHEP 2018.01.12
			НайденныеСтроки = ТЗДвиженийРасходников.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество()>0 Тогда
				НД = ДокОбъект.Движения.РасчетыСКонтрагентами.Добавить();
				ЗаполнитьЗначенияСвойств(НД,НайденныеСтроки[0],,"Регистратор");
				НД.Сумма = -НД.Сумма;
				НД.Период = ДокОбъект.Дата;
			Иначе
				ОсталосьВернуть = СуммаВозврата;
				СтруктураПоиска = Новый Структура("Регистратор",Расходник);
				НайденныеСтроки = ТЗДвиженийРасходников.НайтиСтроки(СтруктураПоиска);
				Если НайденныеСтроки.Количество()>0 Тогда
					//+++АК SHEP 2018.01.12 ИП-00017636
					СтруктураПоиска.Вставить("СчетУчета", ДокОбъект.СчетУчетаРасчетовСКонтрагентом);
					НайденныеСтроки = ТЗДвиженийРасходников.НайтиСтроки(СтруктураПоиска);
					//---АК SHEP 2018.01.12
					Для Каждого Стр Из НайденныеСтроки Цикл
						НД = ДокОбъект.Движения.РасчетыСКонтрагентами.Добавить();
						ЗаполнитьЗначенияСвойств(НД,НайденныеСтроки[0],,"Регистратор");
						СуммаДв=Мин(ОсталосьВернуть,НД.Сумма);
						ОсталосьВернуть = ОсталосьВернуть - СуммаДв;
						НД.Сумма = -СуммаДв;
						НД.Период = ДокОбъект.Дата;
						Если ОсталосьВернуть = 0 Тогда
							Прервать;
						КонецЕсли;	
					КонецЦикла;	
					Если ОсталосьВернуть<>0 Тогда
						//+++АК SHEP 2018.01.12 ИП-00017636
						//Сообщить("Не все движения расходника банка по расчетам удалось сторнировать - "+Расходник);
						Сообщить("Не все движения расходника банка по расчётам удалось сторнировать, проверьте в обеих выписках счета учёта - " + Расходник);
						//---АК SHEP 2018.01.12
					КонецЕсли;	
				КонецЕсли;	
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры	
//--- AK pozm 11.09.2017 ИП-00016323

//+++ AK pozm 17.08.2017 ИП-00016294
Процедура КонтрольРасхожденияРегистров(ДокОбъект,Отказ)
	Если ТипЗнч(ДокОбъект)=Тип("ДокументОбъект.СделкаСПоставщиком") ИЛИ ТипЗнч(ДокОбъект)=Тип("ДокументОбъект.ПредпоступлениеПоКомплектации") ИЛИ ТипЗнч(ДокОбъект)=Тип("ДокументОбъект.ЛистУчета") ИЛИ ТипЗнч(ДокОбъект)=Тип("ДокументОбъект.СвязьДокументовВРасчетахСКонтрагентами")  ИЛИ ТипЗнч(ДокОбъект)=Тип("ДокументОбъект.НачислениеБонусовПокупателям")  ИЛИ ТипЗнч(ДокОбъект)=Тип("ДокументОбъект.ВзаимозачетПоСделкамСПоставщиками") Тогда
		Возврат;
	КонецЕсли;	
	
	ЕстьРасчетыСКонтрагентами	 = ДокОбъект.Движения.Найти("РасчетыСКонтрагентами") <> Неопределено;
	ЕстьРасчетыПоСделкам		 = ДокОбъект.Движения.Найти("РасчетыПоСделкамСПоставщиками") <> Неопределено;
	ЕстьПроводки			    = ДокОбъект.Движения.Найти("Финансовый") <> Неопределено;
	Если НЕ ЕстьРасчетыСКонтрагентами И НЕ ЕстьРасчетыПоСделкам И НЕ ЕстьПроводки Тогда
		Возврат;
	ИначеЕсли НЕ (ЕстьРасчетыСКонтрагентами И ЕстьРасчетыПоСделкам И ЕстьПроводки) Тогда	
		//Сообщить("Документ является регистратором только части регистров "+ДокОбъект);
	КонецЕсли;
	
	СчетаДляУчетаНаРегистреРасчетовСКонтрагентами = БухгалтерскийУчетРасчетовСКонтрагентами.ПолучитьСчетаДляУчетаНаРегистреРасчетовСКонтрагентами();
	
	Сч60_1 = СчетаДляУчетаНаРегистреРасчетовСКонтрагентами.Найти(ПланыСчетов.Финансовый.ОбеспечительныйВзнос);
	Если Сч60_1 <> Неопределено Тогда
		СчетаДляУчетаНаРегистреРасчетовСКонтрагентами.Удалить(Сч60_1);
	КонецЕсли;	
	Сч60_2 = СчетаДляУчетаНаРегистреРасчетовСКонтрагентами.Найти(ПланыСчетов.Финансовый.РасчетыПоАренде);
	Если Сч60_2 <> Неопределено Тогда
		СчетаДляУчетаНаРегистреРасчетовСКонтрагентами.Удалить(Сч60_2);
	КонецЕсли;	
	
	
	//Проверим обороты
	//ДокОбъект=Документы.КорректировкаВзаиморасчетов.СоздатьДокумент();
	ТЗДвижений = Новый ТаблицаЗначений;
	ТЗДвижений.Колонки.Добавить("Счет");
	ТЗДвижений.Колонки.Добавить("Сделка");
	ТЗДвижений.Колонки.Добавить("СуммаФин");
	ТЗДвижений.Колонки.Добавить("СуммаРасч");
	ТЗДвижений.Колонки.Добавить("СуммаРасчАванс");
	ТЗДвижений.Колонки.Добавить("СуммаСдел");
	Если ЕстьПроводки Тогда
		Для Каждого ДВ Из ДокОбъект.Движения.Финансовый Цикл
			Если СчетаДляУчетаНаРегистреРасчетовСКонтрагентами.Найти(Дв.СчетДт)<>Неопределено Тогда
				НС = ТЗДвижений.Добавить();
				НС.Счет = Дв.СчетДт;
				НС.СуммаФин = Дв.Сумма;
			КонецЕсли;	
			
			Если СчетаДляУчетаНаРегистреРасчетовСКонтрагентами.Найти(Дв.СчетКт)<>Неопределено Тогда
				НС = ТЗДвижений.Добавить();
				НС.Счет = Дв.СчетКт;
				НС.СуммаФин = -Дв.Сумма;
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;	
	
	Если ЕстьРасчетыСКонтрагентами Тогда
		Для Каждого ДВ Из ДокОбъект.Движения.РасчетыСКонтрагентами Цикл
			Если СчетаДляУчетаНаРегистреРасчетовСКонтрагентами.Найти(Дв.СчетУчета)<>Неопределено Тогда
				НС = ТЗДвижений.Добавить();
				НС.Счет = Дв.СчетУчета;
				НС.СуммаРасч = ?(Дв.ВидДвижения = ВидДвиженияНакопления.Приход,Дв.Сумма,-Дв.Сумма);
				НС.СуммаРасчАванс = ?(Дв.ВидДвижения = ВидДвиженияНакопления.Приход,Дв.АвансПоСделке,-Дв.АвансПоСделке);
				Если ЗначениеЗаполнено(Дв.Сделка) И  ТипЗнч(Дв.Сделка) = Тип("ДокументСсылка.СделкаСПоставщиком") Тогда
					НС.Сделка = Дв.Сделка
				КонецЕсли;	
			КонецЕсли;	
			
		КонецЦикла;	
	КонецЕсли;	
	
	//+++АК POZM 2017.10.22 ИП-00017015 
	//ЭтоПоступлениеОборудования =  ТипЗнч(ДокОбъект) = Тип("ДокументОбъект.ПоступлениеТоваровУслуг") 
	ЭтоПоступление =  ТипЗнч(ДокОбъект) = Тип("ДокументОбъект.ПоступлениеТоваровУслуг") ИЛИ ТипЗнч(ДокОбъект) = Тип("ДокументОбъект.ПоступлениеДопрасходов");
	//---АК POZM 
	ЭтоОплата =  ТипЗнч(ДокОбъект) = Тип("ДокументОбъект.РасходИзБанка");
	
	Если ЕстьРасчетыПоСделкам Тогда
		Для Каждого ДВ Из ДокОбъект.Движения.РасчетыПоСделкамСПоставщиками Цикл
			//+++АК POZM 2017.10.22 ИП-00017015 
			//Если ЗначениеЗаполнено(Дв.ДатаПлатежа) И (ТипЗнч(Дв.Комплектация)=Тип("ДокументСсылка.ПоступлениеТоваровУслуг") ИЛИ НЕ ЭтоПоступлениеОборудования) Тогда // поступления не так давно начали писать движения в расчеты по сделкам
			Если ЗначениеЗаполнено(Дв.ДатаПлатежа) И (ТипЗнч(Дв.Комплектация)=Тип("ДокументСсылка.ПоступлениеТоваровУслуг") ИЛИ ТипЗнч(Дв.Комплектация)=Тип("ДокументСсылка.ПоступлениеДопРасходов") ИЛИ НЕ ЭтоПоступление) Тогда // поступления не так давно начали писать движения в расчеты по сделкам
			//---АК POZM  
				НС = ТЗДвижений.Добавить();
				НС.Сделка = Дв.Сделка;
				НС.СуммаСдел = ?(Дв.ВидДвижения = ВидДвиженияНакопления.Приход,-Дв.Сумма,Дв.Сумма);
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;	
	
	ВсегоФин = ТЗДвижений.Итог("СуммаФин");
	ВсегоСдел = ТЗДвижений.Итог("СуммаСдел");
	ВсегоРасч = ТЗДвижений.Итог("СуммаРасч");
	ЕстьОшибки = Ложь;
	
	//+++АК LAGP 2018.06.26 ИП-00018465.04 Для данного документа нужны только движения по регистру накопления.
	Если ТипЗнч(ДокОбъект) = Тип("ДокументОбъект.РаспределениеПлатежей") Тогда
		ВсегоФин = ВсегоРасч;	
	КонецЕсли;	
	//---АК LAGP
	
	Если ВсегоФин <> ВсегоРасч 	Тогда
		Сообщить("Расходится сумма движений по регистру расчетов с контрагентами и проводкам");
		ЕстьОшибки = Истина;
	КонецЕсли;	
	
	ТЗДвижений.Свернуть("Сделка","СуммаСдел,СуммаРасч,СуммаРасчАванс");
	
	Если ДокОбъект.Дата>=Дата(2017,8,14) Тогда // по старым предпоступлениям поступление не двигало
		Если ТипЗнч(ДокОбъект) = Тип("ДокументОбъект.ПоступлениеТоваровУслуг") Тогда
			Для Каждого Стр ИЗ ДокОбъект.Оборудование Цикл
				Если ЗначениеЗаполнено(Стр.Предпоступление) И Стр.Предпоступление.Дата < Дата(2017,8,14) Тогда
					Возврат;
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;
		Для Каждого Стр ИЗ ТЗДвижений Цикл
			Если ЗначениеЗаполнено(Стр.Сделка) И Стр.Сделка.Дата>=Дата(2017,1,1) Тогда
				//+++АК POZM 2017.10.22 ИП-00017015
				//Если ЭтоПоступлениеОборудования Тогда
				Если ЭтоПоступление Тогда
				//---АК POZM 	
					Отклонение = Стр.СуммаСдел-Стр.СуммаРасч+Стр.СуммаРасчАванс;
					Если Отклонение<0 Тогда 
						Отклонение = -Отклонение;
					КонецЕсли;	
					Если Отклонение > 1 Тогда // рубль допускаем из-за округлений
						Сообщить("Расходится сумма движений по регистрам по сделке: "+Стр.Сделка);
						ЕстьОшибки = Истина;
					КонецЕсли;	
				ИначеЕсли НЕ ЭтоОплата ИЛИ(ЭтоОплата И ДокОбъект.Оплачено = Истина) Тогда
					Отклонение = Стр.СуммаСдел-Стр.СуммаРасч;
					
					Если Отклонение <> 0 Тогда // рубль допускаем из-за округлений
						Сообщить("Расходится сумма движений по регистрам по сделке: "+Стр.Сделка);
						ЕстьОшибки = Истина;
					КонецЕсли;
				КонецЕсли;	
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;
	
	Если ЕстьОшибки Тогда
		БезКонтроля = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьРасхожденияРегистровПоСделкам, Ложь);
		Если Не БезКонтроля Тогда
		
			Отказ = Истина;
		
		КонецЕсли; 
		
		//СписокКому = Новый СписокЗначений;
		//		
		//СписокКому.Добавить("pozm@automacon.ru");
		//СписокКому.Добавить("abdr@automacon.ru");
		//
		//
		//УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
		//
		//Почта = Новый ИнтернетПочта;
		//Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
		//Письмо = Новый ИнтернетПочтовоеСообщение;
		//
		//Почта.Подключиться(Профиль);
		//Письмо.Тема = "Разъезжаются регистры у документа "+ДокОбъект;
		//Письмо.ИмяОтправителя 	= "" + УчетнаяЗапись + "";
		//Письмо.ИмяОтправителя  	= "" + СокрЛП(УчетнаяЗапись) + "";
		//Письмо.Отправитель     	= "" + СокрЛП(УчетнаяЗапись) + "";
		//Для Каждого ПолучательЭлемент Из СписокКому Цикл
		//	Получатель = Письмо.Получатели.Добавить();
		//	Получатель.Адрес = ПолучательЭлемент.Значение;
		//КонецЦикла;	
		//
		//ТекстСообщения = Письмо.Тексты.Добавить();
		//ТекстСообщения.Текст     = "";
		//ТекстСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
		//		
		//Если НЕ ОбщегоНазначения.ЭтоКопияБазы() Тогда
		//	Почта.Послать(Письмо);
		//КонецЕсли;	
		//Почта.Отключиться();
	КонецЕсли;	
КонецПроцедуры	
//--- AK pozm 17.08.2017 ИП-00016294
