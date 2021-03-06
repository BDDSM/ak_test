﻿
&НаСервере
Процедура ПеречитатьДанныеСервер()
	
	Отказ = Ложь;
	Если ДатаКонца < ДатаНачала Тогда
		ДатаКонца = ДатаНачала;
	КонецЕсли;	
	Если (ДатаКонца - ДатаНачала) / 86400 + 1 > 31 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нельзя формировать график более, чем за 31 день",,,, Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для н = 1 По 31 Цикл
		Элементы["ТаблицаПоМаршрутамДата" + н].Видимость = Ложь;
	КонецЦикла;	
	
	ТаблицаПоМаршрутам.Очистить();
	ДатаНачалаСформированное = ДатаНачала;
	
	ТекстЗапросаДат = "";
	ДатаОбработки = ДатаНачала;
	Для н = 1 По 31 Цикл
		Если ДатаОбработки > ДатаКонца Тогда
			Прервать;
		КонецЕсли;	
		ТекстЗапросаДат = ТекстЗапросаДат + ?(ПустаяСтрока(ТекстЗапросаДат), "ВЫБРАТЬ ", Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ") + "
		|	ДАТАВРЕМЯ(" + Формат(Год(ДатаОбработки), "ЧГ=0") + ", " + Формат(Месяц(ДатаОбработки), "ЧГ=0") + ", " + Формат(День(ДатаОбработки), "ЧГ=0") + ") КАК ДатаОбработки";
		Элементы["ТаблицаПоМаршрутамДата" + н].Видимость = Истина;
		Элементы["ТаблицаПоМаршрутамДата" + н].Заголовок = Формат(ДатаОбработки, "ДФ=dd.MM.yyyy");
		ДатаОбработки = ДатаОбработки + 86400;
	КонецЦикла;	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("СтруктурноеПодразделение", СтруктурноеПодразделение);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Маршруты.Ссылка КАК Маршрут,
	               |	Маршруты.ПорядокСортировки,
				   |	ВЗ_Даты.ДатаОбработки КАК Дата
				   |ПОМЕСТИТЬ ВТ_Данные
	               |ИЗ
	               |	Справочник.Маршруты КАК Маршруты
				   |	ВНУТРЕННЕЕ СОЕДИНЕНИЕ (" + ТекстЗапросаДат + ") КАК ВЗ_Даты
				   |		ПО (ИСТИНА)
				   |ГДЕ Маршруты.СтруктурноеПодразделение = &СтруктурноеПодразделение ИЛИ &СтруктурноеПодразделение = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
				   |;
				   |ВЫБРАТЬ
				   |	ВТ_Данные.Дата КАК Дата,
				   |	ВТ_Данные.Маршрут КАК Маршрут,
				   |	ЕСТЬNULL(ВремяВыездаПоМаршруту.ВремяВыезда, ДАТАВРЕМЯ(1, 1, 1)) КАК ВремяВыезда
				   |ИЗ
				   |	ВТ_Данные КАК ВТ_Данные
				   |	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВремяВыездаПоМаршруту КАК ВремяВыездаПоМаршруту
				   |		ПО ВТ_Данные.Дата = ВремяВыездаПоМаршруту.Дата
				   |			И ВТ_Данные.Маршрут = ВремяВыездаПоМаршруту.Маршрут
				   |
				   |УПОРЯДОЧИТЬ ПО
				   |	ВТ_Данные.ПорядокСортировки,
				   |	Маршрут,
				   |	Дата";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Маршрут") Цикл
		СтрокаТаб = ТаблицаПоМаршрутам.Добавить();
		СтрокаТаб.Маршрут = Выборка.Маршрут;
		Счетчик = 1;
		Пока Выборка.СледующийПоЗначениюПоля("Дата") Цикл
			СтрокаТаб["Дата" + Счетчик] = Выборка.ВремяВыезда;
			Счетчик = Счетчик + 1;
		КонецЦикла;	
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПеречитатьДанные(Команда)
	
	ПеречитатьДанныеСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ДатаНачала) Тогда
		ДатаНачала = НачалоМесяца(ТекущаяДата());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаКонца) Тогда
		ДатаКонца = КонецМесяца(ТекущаяДата());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделение) Тогда
		СтруктурноеПодразделение = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОсновноеСтруктурноеПодразделение");
	КонецЕсли;
	
	ПеречитатьДанныеСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаИзмененияВремени(НомерЯчейки)
	
	ТекДанные = ТаблицаПоМаршрутам.НайтиПоИдентификатору(Элементы.ТаблицаПоМаршрутам.ТекущаяСтрока);
	Запись = РегистрыСведений.ВремяВыездаПоМаршруту.СоздатьМенеджерЗаписи();
	Запись.Дата = ДатаНачалаСформированное + (НомерЯчейки - 1) * 86400;
	Запись.Маршрут = ТекДанные.Маршрут;
	Запись.ВремяВыезда = ТекДанные["Дата" + НомерЯчейки];
	Запись.Записать();
	
КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата1ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(1);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата2ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(2);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата3ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(3);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата4ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(4);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата5ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(5);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата6ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(6);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата7ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(7);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата8ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(8);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата9ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(9);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата10ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(10);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата11ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(11);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата12ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(12);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата13ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(13);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата14ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(14);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата15ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(15);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата16ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(16);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата17ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(17);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата18ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(18);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата19ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(19);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата20ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(20);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата21ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(21);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата22ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(22);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата23ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(23);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата24ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(24);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата25ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(25);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата26ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(26);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата27ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(27);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата28ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(28);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата29ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(29);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата30ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(30);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПоМаршрутамДата31ПриИзменении(Элемент)
	ОбработкаИзмененияВремени(31);
КонецПроцедуры

Функция СформироватьПечать()
	
	ТаблицаДанных = Новый ТаблицаЗначений();
	ТаблицаДанных.Колонки.Добавить("Маршрут", Новый ОписаниеТипов("СправочникСсылка.Маршруты"));
	ТаблицаДанных.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата",,, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ТаблицаДанных.Колонки.Добавить("СтруктурноеПодразделение", Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ТаблицаДанных.Колонки.Добавить("ПлановоеВремя", Новый ОписаниеТипов("Дата",,, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ТаблицаДанных.Колонки.Добавить("ВремяВыезда", Новый ОписаниеТипов("Дата",,, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	
	КолвоДней = 1;
	Для н = 1 По 31 Цикл
		Если НЕ Элементы["ТаблицаПоМаршрутамДата" + н].Видимость Тогда
			Прервать;
		КонецЕсли;
		КолвоДней = н;
	КонецЦикла;	
	Для Каждого СтрокаТаб Из ТаблицаПоМаршрутам Цикл
		СтрЕдиница = СтрокаТаб.Маршрут.СтруктурноеПодразделение;
		ПланВремя = СтрокаТаб.Маршрут.ПланируемоеВремяВыездаПоМаршруту;
		Для н = 1 По КолвоДней Цикл
			СтрокаДоб = ТаблицаДанных.Добавить();
			СтрокаДоб.Маршрут = СтрокаТаб.Маршрут;
			СтрокаДоб.Дата = ДатаНачалаСформированное + (н - 1) * 86400;
			СтрокаДоб.СтруктурноеПодразделение = СтрЕдиница;
			СтрокаДоб.ПлановоеВремя = ПланВремя;
			СтрокаДоб.ВремяВыезда = СтрокаТаб["Дата" + н];
		КонецЦикла;	
	КонецЦикла;	
	
	ДокументРезультат = Новый ТабличныйДокумент();
	СхемаКомпоновки = Обработки.ВремяВыездаПоМаршрутам.ПолучитьМакет("Макет");
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ДанныеДляФормирования", ТаблицаДанных);
	
	//Макет компоновки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновки, СхемаКомпоновки.НастройкиПоУмолчанию);
	
	//Компоновка данных
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных);
	
	//Вывод результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат ДокументРезультат;
	
КонецФункции

&НаКлиенте
Процедура Печать(Команда)
	
	ТабРезультат = СформироватьПечать();
	ТабРезультат.ОтображатьСетку = Ложь;
	ТабРезультат.ОтображатьЗаголовки = Ложь;
	ТабРезультат.ТолькоПросмотр = Истина;
	ТабРезультат.Показать();
	
КонецПроцедуры
