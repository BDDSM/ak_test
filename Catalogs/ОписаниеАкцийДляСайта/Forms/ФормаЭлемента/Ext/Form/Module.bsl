﻿//+++АК KIRN 2018.02.26 ИП-00017855
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ОбновитьКолонкиТоваров();
КонецПроцедуры
//---АК KIRN

//+++АК KIRN 2018.02.26 ИП-00017855
&НаСервере
Процедура ОбновитьКолонкиТоваров(СтруктураПараметров = Неопределено)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЕСли ЗначениеЗаполнено(СтруктураПараметров) Тогда
		Запрос.Текст = "Выбрать
		|	&Номенклатура КАК Номенклатура,
		|	&НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ вт_АкцияТовары
		|;";
		Запрос.УстановитьПараметр("Номенклатура", СтруктураПараметров.Номенклатура);
		Запрос.УстановитьПараметр("НомерСтроки", СтруктураПараметров.НомерСтроки);
	Иначе
		Запрос.Текст = "ВЫБРАТЬ
		|	ОписаниеАкцийДляСайтаТовары.Номенклатура,
		|	ОписаниеАкцийДляСайтаТовары.НомерСтроки
		|ПОМЕСТИТЬ вт_АкцияТовары
		|ИЗ
		|	Справочник.ОписаниеАкцийДляСайта.Товары КАК ОписаниеАкцийДляСайтаТовары
		|ГДЕ
		|	ОписаниеАкцийДляСайтаТовары.Ссылка = &СсылкаОписаниеАкциии				   
		|;";
	КонецЕСли;
	Запрос.Текст = Запрос.Текст+"
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт_АкцияТовары.НомерСтроки КАК НомерСтрокиТЧ,
	|	НоменклатураАкции.НомерСтроки КАК НомерСтроки,
	|	НоменклатураАкции.Ссылка КАК Номенклатура,
	|	НоменклатураАкции.ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ вт_НоменклатураАкции
	|ИЗ
	|	Справочник.Номенклатура.Акции КАК НоменклатураАкции
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ вт_АкцияТовары КАК вт_АкцияТовары
	|		ПО НоменклатураАкции.Ссылка = вт_АкцияТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(вт_НоменклатураАкции.НомерСтроки) КАК НомерСтроки,
	|	вт_НоменклатураАкции.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ вт_НоменклатураАкцииМакс
	|ИЗ
	|	вт_НоменклатураАкции КАК вт_НоменклатураАкции
	|
	|СГРУППИРОВАТЬ ПО
	|	вт_НоменклатураАкции.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт_НоменклатураАкции.НомерСтрокиТЧ КАК НомерСтроки,
	|	вт_НоменклатураАкции.Номенклатура,
	|	вт_НоменклатураАкции.Номенклатура.ВыгружатьНаСайт КАК ВыгружатьНаСайт,
	//|	вт_НоменклатураАкции.НомерСтроки КАК НомерСтроки,
	|	вт_НоменклатураАкции.ДатаОкончания КАК ДатаОкончания
	|ИЗ
	|	вт_НоменклатураАкции КАК вт_НоменклатураАкции
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ вт_НоменклатураАкцииМакс КАК вт_НоменклатураАкцииМакс
	|		ПО вт_НоменклатураАкции.Номенклатура = вт_НоменклатураАкцииМакс.Номенклатура
	|			И вт_НоменклатураАкции.НомерСтроки = вт_НоменклатураАкцииМакс.НомерСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	Запрос.УстановитьПараметр("СсылкаОписаниеАкциии",Объект.Ссылка);
	тз = Запрос.Выполнить().Выгрузить();
	
	для Каждого СтрТЗ из тз Цикл
		мсСтроки = Объект.Товары.НайтиСтроки(Новый структура("НомерСТроки",СтрТЗ.НомерСтроки));
		Если мсСтроки.Количество()>0 Тогда
			ЗаполнитьЗначенияСвойств(мсСтроки[0],стрТЗ);
		КонецЕСли;
	КонецЦИкла;
	
КонецПРоцедуры
//---АК KIRN 

&НаКлиенте
Процедура УстановитьКартинку()
	
	Если ЗначениеЗаполнено(ИмяФайлаИсточник) Тогда
		Картинка = Новый Картинка(ИмяФайлаИсточник);
		СтрокаКартинка = ПоместитьВоВременноеХранилище(Картинка);
	Иначе
		УстановитьКартинкуИзФайла()
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция УстановитьКартинкуИзФайла()
	
	Если ЗначениеЗаполнено(Объект.РасширениеФайла) Тогда
		КаталогКЗаписи = Константы.КаталогХраненияФайловКартинок.Получить();
		Если Прав(КаталогКЗаписи, 1) <> "\" Тогда
			КаталогКЗаписи = КаталогКЗаписи + "\";
		КонецЕсли;	
		КаталогКЗаписи = КаталогКЗаписи + "АкцииДляСайта\";
		ИмяФайла = КаталогКЗаписи + Строка(Объект.Ссылка.УникальныйИдентификатор()) + Объект.РасширениеФайла;
		
		СтрокаКартинка = ПоместитьВоВременноеХранилище(Новый Картинка(ИмяФайла));
	КонецЕсли;	
	
КонецФункции

&НаКлиенте
Процедура ОписаниеHtmlДокументСформирован(Элемент)
	
	Элемент.Документ.Body.ContentEditable = "true";
	Элемент.Документ.body.scroll = "yes";
	Если СтрДлина(Объект.Описание) > 0 Тогда		
		Элементы.ОписаниеHtml.Документ.Body.innerHTML = Объект.Описание;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРежимыКнопокОписание()
	
	Для каждого Кнопка Из Элементы.ГруппаКоманднаяПанельОписание.ПодчиненныеЭлементы Цикл
		//Для каждого Кнопка Из Группа.ПодчиненныеЭлементы Цикл
	        Если ТипЗнч(Кнопка) = тип("КнопкаФормы") Тогда
				Команда = Сред(Кнопка.Имя, 8);
				Если Элементы.ОписаниеHtml.Документ.queryCommandSupported(Команда) Тогда
					Попытка
						Кнопка.Пометка = Элементы.ОписаниеHtml.Документ.queryCommandState(Команда);
					Исключение
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
		//КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКоманду(Кнопка)
	
	Команда = Сред(Кнопка.Имя, 8);
	Если Элементы.ОписаниеHtml.Документ.queryCommandSupported(Команда) Тогда
		Элементы.ОписаниеHtml.Документ.execCommand(Команда, Ложь);
		ПоказатьРежимыКнопокОписание();
		
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеHtmlПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ПоказатьРежимыКнопокОписание();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если СтрДлина(Элементы.ОписаниеHtml.Документ.Body.innerHTML) > 0 Тогда
		Объект.Описание = Элементы.ОписаниеHtml.Документ.Body.innerHTML;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяФайлаИсточник) Тогда
		Файл = Новый Файл(ИмяФайлаИсточник);
		Объект.РасширениеФайла = Файл.Расширение;
		УстановитьКартинку();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаКартинкаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураВозврат = ОткрытьФормуМодально("Справочник.Номенклатура.Форма.ФормаВыбораФайлаКартинки", Новый Структура("Фильтр", "(*.png)|*.png"));
	Если СтруктураВозврат <> Неопределено
			И СтруктураВозврат.БылВыборФайла Тогда
		ИмяФайлаИсточник = СтруктураВозврат.ИмяФайла;
		УстановитьКартинку();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьКартинку();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ИмяФайлаИсточник) Тогда
		КаталогКЗаписи = Константы.КаталогХраненияФайловКартинок.Получить();
		Если Прав(КаталогКЗаписи, 1) <> "\" Тогда
			КаталогКЗаписи = КаталогКЗаписи + "\";
		КонецЕсли;	
		КаталогКЗаписи = КаталогКЗаписи + "АкцииДляСайта\";
		Картинка = ПолучитьИзВременногоХранилища(СтрокаКартинка);
		Картинка.Записать(КаталогКЗаписи + Строка(Объект.Ссылка.УникальныйИдентификатор()) + Объект.РасширениеФайла);
	КонецЕсли;
	
	//+++АК KIRN 2018.02.26 ИП-00017855
	ОбновитьКолонкиТоваров();
	//---АК KIRN 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПромо(Команда)
	ОткрытьФорму("Обработка.РаботаСПромоАкциями.Форма.УправляемаяФорма", Новый Структура("РежимВыбораПромо", Истина), Элементы.Товары);
КонецПроцедуры

Процедура ЗаполнитьТоварыПоПромо(ИдПромо)
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	ТекстЗапроса = "SELECT UINTov._Fld4946 as TovarUID
					|	
					|FROM Promo.dbo.Promo_tovar (nolock) as PT 
					|INNER JOIN IzbenkaFin.dbo._InfoRg4943 UINTov (nolock) ON PT.id_tov = UINTov._Fld4953 and UINTov._Fld4944_TYPE = 0x08 and UINTov._Fld4944_RTRef = 0x0000001D
                    |WHERE PT.id_promo = " + ВнешниеДанные.ФорматПоля(ИдПромо) + " and PT.nabor IN (SELECT PT.Nabor FROM Promo.dbo.Promo_nabor (nolock) as PT WHERE PT.id_promo = " + ВнешниеДанные.ФорматПоля(ИдПромо) + ")
					|";
	
	rs = ADOСоединение.Execute(ТекстЗапроса);
	Пока rs <> Неопределено И rs.Fields.Count <= 0 Цикл
		rs=rs.NextRecordSet();
	КонецЦикла;
	
	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Rs.Fields("TovarUID").Value));
			Если ЗначениеЗаполнено(Номенклатура)
				И Найти(Номенклатура, "<Объект не найден") = 0 Тогда
				СтрокаДоб = Объект.Товары.Добавить();
				СтрокаДоб.Номенклатура = Номенклатура;
			КонецЕсли;	
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
	ADOСоединение.Close();
	ADOСоединение = Неопределено;
	
КонецПроцедуры	

&НаКлиенте
Процедура ТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		Если ВыбранноеЗначение.Свойство("Режим")
			И ВыбранноеЗначение.Режим = "ВыборПромо" Тогда
			ЗаполнитьТоварыПоПромо(ВыбранноеЗначение.ИдПромо);
			//+++АК KIRN 2018.02.26 ИП-00017855 
			ОбновитьКолонкиТоваров();
			//---АК KIRN 
		ИначеЕсли ВыбранноеЗначение.Свойство("Режим")
			И ВыбранноеЗначение.Режим = "ИзСписка" Тогда
			Для Каждого ЭлементТовар Из ВыбранноеЗначение.Товары Цикл
				СтрокаТаб = Объект.Товары.Добавить();
				СтрокаТаб.Номенклатура = ЭлементТовар;
			КонецЦикла;	
			//+++АК KIRN 2018.02.26  ИП-00017855
			ОбновитьКолонкиТоваров();
			//---АК KIRN 
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

Процедура ЗаполнитьДействующимиСпецЦенамиНаСервере()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ДатаНачала", Объект.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Объект.ДатаОкончания);
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	НоменклатураАкции.Ссылка
	               |ИЗ
	               |	Справочник.Номенклатура.Акции КАК НоменклатураАкции
	               |ГДЕ
	               |	(НоменклатураАкции.ДатаНачала МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |			ИЛИ НоменклатураАкции.ДатаОкончания МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |			ИЛИ &ДатаНачала МЕЖДУ НоменклатураАкции.ДатаНачала И НоменклатураАкции.ДатаОкончания
	               |			ИЛИ &ДатаОкончания МЕЖДУ НоменклатураАкции.ДатаНачала И НоменклатураАкции.ДатаОкончания)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НоменклатураАкции.Ссылка.Наименование";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТаб = Объект.Товары.Добавить();
		СтрокаТаб.Номенклатура = Выборка.Ссылка;
	КонецЦикла;
	
	//+++АК KIRN 2018.02.26 ИП-00017855
	ОбновитьКолонкиТоваров();
	//---АК KIRN 
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьДействующимиСпецЦенами(Команда)
	
	ЗаполнитьДействующимиСпецЦенамиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписком(Команда)
	
	ОткрытьФорму("Справочник.ОписаниеАкцийДляСайта.Форма.ФормаЗаполненияПоСписку", , Элементы.Товары);
	
КонецПроцедуры


//+++АК KIRN 2018.02.26  ИП-00017855
&НаКлиенте
Процедура Товары1НоменклатураПриИзменении(Элемент)
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	ОбновитьКолонкиТоваров(Новый Структура("Номенклатура, НомерСтроки", ТекДанные.Номенклатура, ТекДанные.НомерСтроки));
КонецПроцедуры
//---АК KIRN 