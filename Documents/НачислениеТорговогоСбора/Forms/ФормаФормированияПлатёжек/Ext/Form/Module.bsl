﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаПлатёжныхДокументов=ТекущаяДата();
	Организация=Параметры.Документ.Организация;
	Для каждого Стр из Параметры.Документ.ТорговыеТочки Цикл
		Если СокрЛП(Стр.ТорговаяТочка.ОКТМО)="" Тогда
			Сообщить("Для "+Стр.ТорговаяТочка+" не задан ОКТМО, платёжка сформирована не будет");
			Продолжить;
		КонецЕсли;	
		НС=ТаблицаПлатежей.Добавить();
		НС.ОКТМО=Стр.ТорговаяТочка.ОКТМО;
		НС.ТорговаяТочка=Стр.ТорговаяТочка;
		НС.Сумма=Стр.Сумма;
	КонецЦикла;	
	ТЗ=ТаблицаПлатежей.Выгрузить();
	ТЗ.Свернуть("ТорговаяТочка,ОКТМО","Сумма");
	ТаблицаПлатежей.Загрузить(ТЗ);
	ИтогПоТЗ=ТаблицаПлатежей.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПлатёжныеДокументы(Команда)
	СформироватьПлатёжкиСервер();
КонецПроцедуры

&НаСервере
Процедура СформироватьПлатёжкиСервер()
	ТекстЗапроса="ВЫБРАТЬ
	             |	РасходИзБанка.Ссылка
	             |ИЗ
	             |	Документ.РасходИзБанка КАК РасходИзБанка
	             |ГДЕ
	             |	РасходИзБанка.Комментарий ПОДОБНО &Комментарий
	             |	И РасходИзБанка.Организация = &Организация
	             |	И РасходИзБанка.ТорговаяТочка = &ТорговаяТочка";
	Запрос=Новый Запрос(ТекстЗапроса);			 
	Для каждого Стр Из ТаблицаПлатежей Цикл
		Комментарий="Сформирован автоматически на основании начисления торгового сбора "+Параметры.Документ.Номер+" от "+Год(ДатаПлатёжныхДокументов)+" ОКТМО "+Стр.ОКТМО+"/"+Стр.ТорговаяТочка;
		Запрос.УстановитьПараметр("Организация",Организация);
		Запрос.УстановитьПараметр("Комментарий",Комментарий);
		Запрос.УстановитьПараметр("ТорговаяТочка",Стр.ТорговаяТочка);
		выборкаД=запрос.Выполнить().Выбрать();
		Если выборкаД.Следующий() Тогда
			ДокПП=выборкаД.ссылка.ПолучитьОбъект();
		Иначе	
			ДокПП=Документы.РасходИзБанка.СоздатьДокумент();
		КонецЕсли;	
		ДокПП.Дата=ДатаПлатёжныхДокументов;
		ДокПП.ВалютаДокумента=Справочники.Валюты.НайтиПоКоду("643");
		ДокПП.ВидОперации=Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога;
		ДокПП.ВидПеречисленияВБюджет=Перечисления.ВидыПеречисленийВБюджет.НалоговыйПлатеж;
		ДокПП.ПеречислениеВБюджет=истина;
		ДокПП.ТорговаяТочка=Стр.ТорговаяТочка;
			
		ДокПП.ВидПлатежа="Электронно";
		ДокПП.СтатьяДвиженияДенежныхСредств=Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("120742");
			
		ДокПП.ОчередностьПлатежа=5;
		ДокПП.СтатусСоставителя="01";
		ДокПП.КодБК="18210505010021000110";
		ДокПП.ВидПлатежаВГосБюджет=Перечисления.ВидыПлатежейВГосБюджет.Налог;
			
		ДокПП.Организация=Организация;
		ДокПП.СчетОрганизации=Организация.ОсновнойБанковскийСчет;
		ДокПП.КодОКТМО=Стр.ОКТМО;
		КПП=Организация.КПП;
		ДокПП.Контрагент=НайтиИФНС_По_КПП(КПП);
		ДокПП.ИННПлательщика=ДокПП.Организация.ИНН;
		ДокПП.КПППлательщика = КПП;
		ДокПП.ИННПолучателя = ДокПП.Контрагент.ИНН;
		ДокПП.КПППолучателя = ДокПП.Контрагент.КПП;
						
		ДокПП.ТекстПлательщика=ДокПП.Организация.НаименованиеПлательщикаПриПеречисленииНалогов;
		ДокПП.ТекстПолучателя=ДокПП.Контрагент.НаименованиеПолное;
			
		ДокПП.СчетКонтрагента=ДокПП.Контрагент.ОсновнойБанковскийСчет;
		ДокПП.ДатаОплаты=ДокПП.Дата;
		ДокПП.Оплачено=ложь;
		ДокПП.СуммаДокумента=Стр.Сумма;
		ДокПП.ПоказательПериода="КВ."+Формат(Параметры.Документ.Дата,"ДФ=кк.yyyy");
		ДокПП.СчетУчетаРасчетовСКонтрагентом=ПланыСчетов.Финансовый.НайтиПоКоду("68.2");
		ДокПП.СубконтоДт1=ДокПП.Организация;
		ДокПП.СубконтоДт2=Справочники.ВидыНалогов.НайтиПоКоду("000000017");
		ДокПП.СчетБанк=ПланыСчетов.Хозрасчетный.НайтиПоКоду("51");
		ДокПП.СчетУчетаРасчетовСКонтрагентомБУ=ПланыСчетов.Хозрасчетный.НайтиПоКоду("68.13");
		ДокПП.СчетУчетаРасчетовПоАвансамБУ=ПланыСчетов.Хозрасчетный.НайтиПоКоду("68.13");
		ДокПП.ПоказательТипа = "НС";
		ДокПП.НазначениеПлатежа="Торговый сбор, за "+Формат(Параметры.Документ.Дата,"ДФ='к ""квартал"" yyyy'")+"г. Сумма "+Формат(Стр.Сумма,"ЧДЦ=2; ЧРД=-; ЧГ=0");
		ДокПП.Комментарий=Комментарий;
		ДокПП.СтатьяДвиженияДенежныхСредствБУ=ОбщегоНазначенияСервер.ПолучитьСтатьюДДС_БУ(ДокПП.СтатьяДвиженияДенежныхСредств,ДокПП.ВидОперации);
		ДокПП.Записать(режимЗаписиДокумента.Запись);
		ДокПП.Записать(режимЗаписиДокумента.ОтменаПроведения);
		Попытка 
			ДокПП.Записать(режимЗаписиДокумента.Проведение);
			Сообщить("Сформирован "+ДокПП);
		Исключение
			Сообщить("Не смог провести "+ДокПП);
		КонецПопытки;	
		
		
	КонецЦикла;	
	Сообщить("Обработка завершена!");

КонецПроцедуры	

Функция НайтиИФНС_По_КПП(КПП)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Родитель"	, Справочники.Контрагенты.НайтиПоКоду("000000523"));
	Запрос.УстановитьПараметр("ИНН_Поиск"	, Лев(КПП, 4));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Родитель = &Родитель
	|	И ПОДСТРОКА(Контрагенты.ИНН, 1, 4) = &ИНН_Поиск";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ссылка;
	КонецЕсли;
	
	Возврат Справочники.Контрагенты.ПустаяСсылка();
	
КонецФункции	

&НаКлиенте
Процедура ТаблицаПлатежейПриИзменении(Элемент)
	ТаблицаПлатежейПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Процедура ТаблицаПлатежейПриИзмененииСервер()
	ИтогПоТЗ=ТаблицаПлатежей.Итог("Сумма");
КонецПроцедуры	
