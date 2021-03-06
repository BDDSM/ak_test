﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Сформировать_М11(ПараметрКоманды);

	ТабДок.ОтображатьСетку		= Ложь;
	ТабДок.Защита				= Истина;
	ТабДок.ТолькоПросмотр		= Истина;
	ТабДок.ОтображатьЗаголовки	= Ложь;
	ТабДок.Показать();
	
КонецПроцедуры

&НаСервере
Функция Сформировать_М11(ПараметрКоманды)
	
	ТабДок = Новый ТабличныйДокумент;
	Макет = Документы.ТребованиеНакладная.ПолучитьМакет("М11");
	
	//Шапка
	Область	= Макет.ПолучитьОбласть("Шапка");
	Область.Параметры.Заголовок			= "ТРЕБОВАНИЕ-НАКЛАДНАЯ № " + Строка(ПараметрКоманды.Номер);
	Область.Параметры.КодОКПО			= ПараметрКоманды.Организация.КодПоОКПО;
	Область.Параметры.Организация		= ?(ЗначениеЗаполнено(ПараметрКоманды.Организация.НаименованиеПолное), ПараметрКоманды.Организация.НаименованиеПолное, ПараметрКоманды.Организация.Наименование);
	Область.Параметры.ДатаСоставления	= Формат(ПараметрКоманды.Дата, "ДФ=dd.MM.yy");
	Область.Параметры.Склад				= ПараметрКоманды.Склад;
	
	Область.Параметры.КоррСчет			= "41.1";	//счет дебета зашит жестко в проводках
	ТабДок.Вывести(Область);

	//Товары
	Запрос = Новый Запрос("ВЫБРАТЬ
							|	Товары.НомерСтроки,
							|	Товары.Номенклатура,
							|	Товары.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
							|	Товары.Номенклатура.ЕдиницаХраненияОстатков.Код КАК ЕдиницаИзмеренияКод,
							|	Товары.Количество,
							|	Товары.Цена,
							|	Товары.Сумма,
							|	Товары.СтавкаНДС,
							|	Товары.СуммаНДС,
							|	Товары.СчетЗатрат
							|ИЗ
							|	Документ.ТребованиеНакладная.Товары КАК Товары
							|ГДЕ
							|	Товары.Ссылка = &Ссылка
							|	");
							
	Запрос.Параметры.Вставить("Ссылка", ПараметрКоманды);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл

		Область = Макет.ПолучитьОбласть("Строка");
		Область.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Область);

	КонецЦикла;
	
	//Подвал
	Область = Макет.ПолучитьОбласть("Подвал");
	ТабДок.Вывести(Область);
	
	Возврат ТабДок;
	
КонецФункции
