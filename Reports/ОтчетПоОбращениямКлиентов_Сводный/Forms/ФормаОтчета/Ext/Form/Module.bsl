﻿
&НаКлиенте
Процедура СохранитьТабДокумент(Команда)
	
	ТекСтраница = Элементы.Группа1.ТекущаяСтраница;
	
	Если ТекСтраница = Элементы.Группа2 Тогда
		ТекТабДокумент = Отчет.ТабДокумент_Общий;
	//+++АК SHEP 2018.08.16 ИП-00019446
	#Область Страницы_БезЦикла
	//ИначеЕсли ТекСтраница = Элементы.Группа3 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_01;
	//ИначеЕсли ТекСтраница = Элементы.Группа4 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_02;
	//ИначеЕсли ТекСтраница = Элементы.Группа5 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_03;
	//ИначеЕсли ТекСтраница = Элементы.Группа6 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_04;
	//ИначеЕсли ТекСтраница = Элементы.Группа7 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_05;
	//ИначеЕсли ТекСтраница = Элементы.Группа8 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_06;
	//ИначеЕсли ТекСтраница = Элементы.Группа9 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_07;
	//ИначеЕсли ТекСтраница = Элементы.Группа10 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_08;
	//ИначеЕсли ТекСтраница = Элементы.Группа11 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_09;
	//ИначеЕсли ТекСтраница = Элементы.Группа12 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_10;
	//ИначеЕсли ТекСтраница = Элементы.Группа13 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_11;
	//ИначеЕсли ТекСтраница = Элементы.Группа14 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_12;
	//ИначеЕсли ТекСтраница = Элементы.Группа15 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_13;
	//ИначеЕсли ТекСтраница = Элементы.Группа16 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_14;
	//ИначеЕсли ТекСтраница = Элементы.Группа17 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_15;
	//ИначеЕсли ТекСтраница = Элементы.Группа18 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_16;
	//ИначеЕсли ТекСтраница = Элементы.Группа19 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_17;
	////+++АК mika 2018.06.26 ИП-00018998
	//ИначеЕсли ТекСтраница = Элементы.Группа20 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_18;
	//ИначеЕсли ТекСтраница = Элементы.Группа21 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_19;
	//ИначеЕсли ТекСтраница = Элементы.Группа22 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_20;
	//ИначеЕсли ТекСтраница = Элементы.Группа23 Тогда
	//	ТекТабДокумент = Отчет.ТабДокумент_21;
	//	//---АК mika 
	#КонецОбласти
	Иначе
		ТекТабДокумент = Отчет["ТабДокумент_" + СтрЗаменить(ТекСтраница.Имя, "Страница", "")];
	//---АК SHEP 2018.08.16
	КонецЕсли;
	
	//
	ДиалогВыбораФайла =	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);

	ДиалогВыбораФайла.Фильтр					= "Документ Microsoft Excel (*.xls)|*.xls";
	ДиалогВыбораФайла.Расширение				= "xls";
	ДиалогВыбораФайла.Заголовок					= "Выберите файл";
	ДиалогВыбораФайла.ПредварительныйПросмотр	= Ложь;
	ДиалогВыбораФайла.МножественныйВыбор		= Ложь;
	ДиалогВыбораФайла.ИндексФильтра				= 0;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ТекТабДокумент.Записать(ДиалогВыбораФайла.ПолноеИмяФайла, ТипФайлаТабличногоДокумента.XLS);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьМакетКомпоновкиПоНаименованиюСхемы(ИмяМакета, ДатаНачала, ДатаОкончания)
КонецФункции

Процедура СохранитьВсеСервер()
	
	ЭтаФорма.Результат_Общий.Очистить();
	
	//
	ДатаНачала 		= Дата(1, 1, 1);
	ДатаОкончания 	= Дата(1, 1, 1);
	
	мЭлементыНастроек = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;
	Для Каждого ПользПоле Из мЭлементыНастроек Цикл
		Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если Строка(ПользПоле.Параметр) = "Период" Тогда
				ДатаНачала 		= ПользПоле.Значение.ДатаНачала;
				ДатаОкончания 	= КонецДня(ПользПоле.Значение.ДатаОкончания);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	//
	РезультатыЗапроса = Отчеты.ОтчетПоОбращениямКлиентов_Сводный.ПолучитьРезультатыЗапроса(ДатаНачала, ДатаОкончания);
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ДанныеОбщие"	, РезультатыЗапроса[1].Выгрузить());
	
	//+++АК SHEP 2018.08.15 ИП-00019446
	#Область ВнешниеНаборыДанных_БезЦикла
	//ВнешниеНаборыДанных.Вставить("Итоги_01"		, РезультатыЗапроса[2].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_01"	, РезультатыЗапроса[3].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_02"		, РезультатыЗапроса[4].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_02"	, РезультатыЗапроса[5].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_03"		, РезультатыЗапроса[6].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_03"	, РезультатыЗапроса[7].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_04"		, РезультатыЗапроса[8].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_04"	, РезультатыЗапроса[9].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_05"		, РезультатыЗапроса[10].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_05"	, РезультатыЗапроса[11].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_06"		, РезультатыЗапроса[12].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_06"	, РезультатыЗапроса[13].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_07"		, РезультатыЗапроса[14].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_07"	, РезультатыЗапроса[15].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_08"		, РезультатыЗапроса[16].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_08"	, РезультатыЗапроса[17].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_09"		, РезультатыЗапроса[18].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_09"	, РезультатыЗапроса[19].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_10"		, РезультатыЗапроса[20].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_10"	, РезультатыЗапроса[21].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_11"		, РезультатыЗапроса[22].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_11"	, РезультатыЗапроса[23].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_12"		, РезультатыЗапроса[24].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_12"	, РезультатыЗапроса[25].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_13"		, РезультатыЗапроса[26].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_13"	, РезультатыЗапроса[27].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_14"		, РезультатыЗапроса[28].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_14"	, РезультатыЗапроса[29].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_15"		, РезультатыЗапроса[30].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_15"	, РезультатыЗапроса[31].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_16"		, РезультатыЗапроса[32].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_16"	, РезультатыЗапроса[33].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_17"		, РезультатыЗапроса[34].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Данные_17"	, РезультатыЗапроса[35].Выгрузить());
	//
	////+++АК mika 2018.06.26 ИП-00018998
	//ВнешниеНаборыДанных.Вставить("Итоги_18"	    , РезультатыЗапроса[36].Выгрузить());  //18 Диетология
	//ВнешниеНаборыДанных.Вставить("Данные_18"    , РезультатыЗапроса[37].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_19"	    , РезультатыЗапроса[38].Выгрузить());  //19_Оценки в боте
	//ВнешниеНаборыДанных.Вставить("Данные_19"    , РезультатыЗапроса[39].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_20"	    , РезультатыЗапроса[40].Выгрузить());  //20_Доставка
	//ВнешниеНаборыДанных.Вставить("Данные_20"    , РезультатыЗапроса[41].Выгрузить());
	//ВнешниеНаборыДанных.Вставить("Итоги_21"	    , РезультатыЗапроса[42].Выгрузить());  //21 Экология
	//ВнешниеНаборыДанных.Вставить("Данные_21"    , РезультатыЗапроса[43].Выгрузить());
	////---АК mika
	
	#КонецОбласти
	
	НомерРезультатаЗапроса = 2;
	Для Сч = 1 По 24 Цикл
		СчСтр = Формат(Сч, "ЧЦ=2; ЧВН=");
		ВнешниеНаборыДанных.Вставить("Итоги_" + СчСтр, РезультатыЗапроса[НомерРезультатаЗапроса].Выгрузить());
		НомерРезультатаЗапроса = НомерРезультатаЗапроса + 1; 
		ВнешниеНаборыДанных.Вставить("Данные_" + СчСтр, РезультатыЗапроса[НомерРезультатаЗапроса].Выгрузить());
		НомерРезультатаЗапроса = НомерРезультатаЗапроса + 1; 
	КонецЦикла;
	//---АК SHEP 2018.08.15
	
	//Макет компоновки 
	ОбъектОтчета = РеквизитФормыВЗначение("Отчет");
	ТекСхема = ОбъектОтчета.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных_Старая");
	ТекНастройки = ТекСхема.НастройкиПоУмолчанию;
	
	ТекЭлементыПараметровДанных = ТекНастройки.ПараметрыДанных.Элементы;
	Для Каждого ЭлементНастроек Из ТекЭлементыПараметровДанных Цикл
		Если НЕ ТипЗнч(ЭлементНастроек) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		Если ЭлементНастроек.Параметр = Новый ПараметрКомпоновкиДанных("ДатаНачала") Тогда
			ЭлементНастроек.Значение = ДатаНачала;
		ИначеЕсли ЭлементНастроек.Параметр = Новый ПараметрКомпоновкиДанных("ДатаОкончания") Тогда
			ЭлементНастроек.Значение = ДатаОкончания;
		ИначеЕсли ЭлементНастроек.Параметр = Новый ПараметрКомпоновкиДанных("Период") Тогда
			ЭлементНастроек.Значение.ДатаНачала 	= ДатаНачала;
			ЭлементНастроек.Значение.ДатаОкончания 	= ДатаОкончания;
		КонецЕсли;
	КонецЦикла;
	
	ТекКомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = ТекКомпоновщикМакета.Выполнить(ТекСхема, ТекНастройки);
	
	//Компоновка данных
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных);
	
	//Вывод результата
	ТекТабДокумент = ЭтаФорма.Результат_Общий;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТекТабДокумент);
	ПроцессорВывода.НачатьВывод();

	ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	Пока НЕ ЭлементРезультата = Неопределено Цикл
		Если ЭлементРезультата.ЗначенияПараметров.Количество() = 1 Тогда
			Если ЭлементРезультата.ЗначенияПараметров[0].Значение = "РазорватьСтраницу" Тогда
				ТекТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
		КонецЕсли;
	    ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
	    ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	КонецЦикла;
	ПроцессорВывода.ЗакончитьВывод();	
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВсе(Команда)
	
	СохранитьВсеСервер();
	
	//
	ДиалогВыбораФайла =	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);

	ДиалогВыбораФайла.Фильтр					= "Документ Microsoft Excel (*.xls)|*.xls";
	ДиалогВыбораФайла.Расширение				= "xls";
	ДиалогВыбораФайла.Заголовок					= "Выберите файл";
	ДиалогВыбораФайла.ПредварительныйПросмотр	= Ложь;
	ДиалогВыбораФайла.МножественныйВыбор		= Ложь;
	ДиалогВыбораФайла.ИндексФильтра				= 0;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ЭтаФорма.Результат_Общий.Записать(ДиалогВыбораФайла.ПолноеИмяФайла, ТипФайлаТабличногоДокумента.XLS);
	КонецЕсли;
	
КонецПроцедуры
 