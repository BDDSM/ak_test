﻿Функция СформироватьТабличныйДокумент_Магазины(МасМаг)Экспорт
	
	ВнешняяКомпонента = Справочники.Номенклатура.ПодключитьВнешнююКомпонентуПечатиШтрихкода();
	
	ТабДок = Новый ТабличныйДокумент;
	Макет = Обработки.ФормированийЗаданийНаРазборку.ПолучитьМакет("Этикетка");
	ТабДок.ИмяПараметровПечати="ПечатьШКМаг";	
	ТабДок.ОриентацияСтраницы=ОриентацияСтраницы.Ландшафт;
	ТабДок.АвтоМасштаб=Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтруктурныеЕдиницы.Ссылка,
		|	СтруктурныеЕдиницы.id_TT,
		|	СтруктурныеЕдиницы.НомерТочки КАК НомерТочки
		|ИЗ
		|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|ГДЕ
		|	СтруктурныеЕдиницы.Ссылка В(&Ссылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерТочки";
	
	Запрос.УстановитьПараметр("Ссылка", МасМаг);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗМаг = РезультатЗапроса.Выгрузить();
	
	Для Каждого СтрокаМассива Из ТЗМаг Цикл
		
		
		ШтрихКод = "820" + Прав("000000000000" + Формат(СтрокаМассива.id_TT, "ЧГ=0"), 12);
		Область = Макет.ПолучитьОбласть("Этикетка");
		Область.Параметры.Склад = Строка(СтрокаМассива.Ссылка);
		
		Рисунок = Область.Рисунки["ШтрихКод"];
		
		//+++АК sole 2018.09.18 ИП-00019639^01
		//ПараметрыШК = Новый Структура;
		//ПараметрыШК.Вставить("Ширина"			, Рисунок.Ширина);
		//ПараметрыШК.Вставить("Высота"			, Рисунок.Высота);
		//ПараметрыШК.Вставить("ТипКода"			, 4);
		//ПараметрыШК.Вставить("ОтображатьТекст"	, Ложь);
		//ПараметрыШК.Вставить("РазмерШрифта"		, 10);
		//ПараметрыШК.Вставить("Штрихкод"			, Штрихкод);
		//Рисунок.Картинка = ОбщегоНазначенияКлиентСервер.ПолучитьКартинкуШтрихкода(ВнешняяКомпонента, ПараметрыШК);
		ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(Штрихкод, 0, 600);
		Рисунок.Картинка = Новый Картинка(ДанныеQRКода);
		//---АК sole 2018.09.18 ИП-00019639^01
		
		Область.Параметры.ШК = ШтрихКод;
		
		Если Не ТабДок.ПроверитьВывод(Область) Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ТабДок.Вывести(Область);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции
