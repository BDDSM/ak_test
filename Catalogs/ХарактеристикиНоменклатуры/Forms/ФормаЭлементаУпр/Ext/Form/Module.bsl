﻿
#Область ОбработчикиСобытийФормы

//+++АК LATV 2018.10.29 ИП-00020157
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если РольДоступнаСервер() Тогда
		Элементы.Статус.КнопкаСпискаВыбора		= Истина;
		Элементы.Статус.РежимВыбораИзСписка		= Истина;
		элементы.Статус.РедактированиеТекста	= Ложь;
		Элементы.Статус.КнопкаВыбора			= Ложь;
		Элементы.Статус.КнопкаВыпадающегоСписка	= Истина;
	КонецЕсли;
	
	ЭтаФорма.ДатаВыводаБыло = Объект.ДатаВывода;
	
	ЭтаФорма.ЕстьПравоРедактированияДопСвойств						= ОбщегоНазначенияПовтИсп.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.ПолныеПраваНаРедактированиеТовары, Ложь);
	ЭтаФорма.ЕстьПравоРедактированияДопСвойстваКоличествоВУпаковке	= ОбщегоНазначенияПовтИсп.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.МожетРедактироватьДопСвойствоХарактеристикКоличествоВУпаковке, Ложь);
	
	УстановитьОтборЗначенияСвойств();

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Не Отказ Тогда
		Если ТекущийОбъект.СтатусУРЗ<>ТекущийОбъект.Ссылка.СтатусУРЗ ИЛИ                       
				ТекущийОбъект.Комментарий<>ТекущийОбъект.Ссылка.Комментарий ИЛИ
				ТекущийОбъект.ДатаОжидаемойПоставки<>ТекущийОбъект.Ссылка.ДатаОжидаемойПоставки 
				Тогда
			    ТекущийОбъект.ДатаПоследнегоИзмененияУРЗ=ТекущаяДата();
				//+++AK GREK 17.10.2017 ИП-00017059
				ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
				СтрЗапрос = "INSERT INTO Reports.dbo.Changes_status_URZ([Товар],[Характеристика],[СтатусУРЗ],[ДатаПоследнегоИзмененияУРЗ],[Комментарий]) VALUES('&Товар','&Характеристика','&СтатусУРЗ','&ДатаПоследнегоИзмененияУРЗ','&Комментарий');";
				СтрЗапрос = СтрЗаменить(СтрЗапрос, "&Товар", Объект.Владелец.Наименование); 
				СтрЗапрос = СтрЗаменить(СтрЗапрос, "&Характеристика", Объект.Наименование); 
				СтрЗапрос = СтрЗаменить(СтрЗапрос, "&СтатусУРЗ", Строка(Объект.СтатусУРЗ));
				СтрЗапрос = СтрЗаменить(СтрЗапрос, "&ДатаПоследнегоИзмененияУРЗ", Формат(ВнешниеДанные.ВернутьТекущуюДатуSQL(),"ДФ=yyyyMMdd hh:mm:ss"));
				СтрЗапрос = СтрЗаменить(СтрЗапрос, "&Комментарий", Объект.Комментарий);
				rs = ADOСоединение.Execute(СтрЗапрос);
				//---AK
		КонецЕсли;
	КонецЕсли; 	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьОтборЗначенияСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	//+++АК CISA 2018.09.27 ИП-00019945
	Если НЕ Отказ Тогда
		Если (Объект.Высота > 0 ИЛИ Объект.Ширина > 0 ИЛИ Объект.Глубина > 0) И Объект.Высота * Объект.Ширина * Объект.Глубина = 0 Тогда
			Сообщить("Необходимо либо заполнить все три значения габаритов (ширина, высота, глубина), либо вообще ничего не заполнять!");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	//---АК CISA
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

//+++АК SHEP 2017.12.08 ИП-00017349
&НаКлиенте
Процедура ДатаВыводаПриИзменении(Элемент)
	
	Если Объект.ДатаВывода <> ДатаВыводаБыло И ЗначениеЗаполнено(Объект.ДатаВывода) И Объект.ДатаВывода < НачалоДня(ТекущаяДата()) Тогда
		Объект.ДатаВывода = ДатаВыводаБыло;
		Сообщить("Дата вывода должна быть не меньше текущей!");
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

//+++AK ziga ИП-00017211 20171110
&НаКлиенте
Процедура СтатусНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
		Если РольДоступнаСервер() Тогда		
		СписокСтатусов=Новый Массив;
		СписокСтатусов.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыХарактеристик.НаВывод"));
		СписокСтатусов.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыХарактеристик.Приостановлена"));
		Элемент.СписокВыбора.ЗагрузитьЗначения(СписокСтатусов);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ЗначенияСвойств

//+++АК LATV 2018.10.29 ИП-00020157
&НаКлиенте
Процедура ЗначенияСвойствПередНачаломИзменения(Элемент, Отказ)

	Отказ = Истина;
	
	Если МожноРедактироватьТекущуюСтрокуДополнительныхСвойств() Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", Элементы.ЗначенияСвойств.ТекущаяСтрока);
		ОткрытьФорму("РегистрСведений.ЗначенияСвойствОбъектов.Форма.ФормаРедактированияЗначения", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//+++АК LATV 2018.10.29 ИП-00020157
&НаСервере
Процедура УстановитьОтборЗначенияСвойств()

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ЗначенияСвойств
		, "Объект", Объект.Ссылка);

КонецПроцедуры

//AK ziga...
&НаСервере
Функция РольДоступнаСервер()
	//+++AK ziga ИП-00016835.01 20171118
	Если РольДоступна("ПолныеПрава") Тогда
		Возврат Ложь;
		Иначе
	//НаименованиеДопПрава="Возможность выбирать статус рабочая";	
	МассивПраваАренда=УправлениеДопПравамиПользователей.ПрочитатьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.ВыборСтатусовПоХарактеристике,Ложь,ПараметрыСеанса.ТекущийПользователь);	
	ПравоАренда=МассивПраваАренда[0];	
	Возврат ПравоАренда;
	
	КонецЕсли;
	//---AK ziga ИП-00016835.01 20171118 
КонецФункции

//+++АК LATV 2018.10.29 ИП-00020157
&НаКлиенте
Функция МожноРедактироватьТекущуюСтрокуДополнительныхСвойств()

	Результат = Ложь;
	
	Если ЕстьПравоРедактированияДопСвойств Тогда
		Результат = Истина;
		
	Иначе
		ТекДанные = Элементы.ЗначенияСвойств.ТекущиеДанные;
		
		Если ЕстьПравоРедактированияДопСвойстваКоличествоВУпаковке
		   И ТекДанные.Свойство = ПредопределенноеЗначение("ПланВидовХарактеристик.СвойстваОбъектов.КоличествоВУпаковке") Тогда
			Результат = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

#КонецОбласти
