﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ФорматСтраницы = "A3";
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	СтруктурныеЕдиницы.Ссылка
	               |ИЗ
	               |	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	               |ГДЕ
	               |	СтруктурныеЕдиницы.ДатаЗакрытия = ДАТАВРЕМЯ(1, 1, 1)
	               |	И СтруктурныеЕдиницы.ДатаЗапускаНовойСистемыУчета <> ДАТАВРЕМЯ(1, 1, 1)
	               |	И СтруктурныеЕдиницы.ТипРозничнойТочки = ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.Магазин)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	СтруктурныеЕдиницы.НомерТочки";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаДоб = Объект.Магазины.Добавить();
		СтрокаДоб.Магазин = Выборка.Ссылка;
	КонецЦикла;	
	
КонецПроцедуры

Функция СформироватьЦенникиПоМагазину(Магазин)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВыкладкаПланограммы.Номенклатура,
	               |	ТоварныйАссортиментТочекСрезПоследних.Характеристика,
	               |	ВЗ_Цены.Цена
	               |ИЗ
	               |	РегистрСведений.ВыкладкаПланограммы КАК ВыкладкаПланограммы
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТоварныйАссортиментТочек.СрезПоследних(
	               |				&ДатаТек,
	               |				ТорговаяТочка = &ТорговаяТочка
	               |					И Выведена = ЛОЖЬ) КАК ТоварныйАссортиментТочекСрезПоследних
	               |		ПО ВыкладкаПланограммы.Номенклатура = ТоварныйАссортиментТочекСрезПоследних.Номенклатура
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	               |			ЦеныНоменклатурыСрезПоследних.Цена КАК Цена
	               |		ИЗ
	               |			РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	               |					&ДатаТек,
	               |					ТорговаяТочка = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	               |						И ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.ОсновнойТипЦенПродаж)) КАК ЦеныНоменклатурыСрезПоследних) КАК ВЗ_Цены
	               |		ПО ВыкладкаПланограммы.Номенклатура = ВЗ_Цены.Номенклатура
	               |ГДЕ
	               |	(ВыкладкаПланограммы.Планограмма = &Планограмма
	               |			ИЛИ &Планограмма = ЗНАЧЕНИЕ(Справочник.Планограммы.ПустаяСсылка))
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ВыкладкаПланограммы.Номенклатура.Наименование";
				   
	Запрос.УстановитьПараметр("Планограмма", Магазин.Планограмма);
	Запрос.УстановитьПараметр("ТорговаяТочка", Магазин);
	Запрос.УстановитьПараметр("ДатаТек", ТекущаяДата());
	
	ТабДок = Новый ТабличныйДокумент();
	ТабДок.РазмерСтраницы = ФорматСтраницы;
	Если ФорматСтраницы = "A3" Тогда
		//ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	КонецЕсли;	
	Счетчик = 0;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Область = Справочники.Номенклатура.ПолучитьЦенник_80_60(Выборка.Номенклатура, Выборка.Характеристика);
		Если Счетчик%?(ФорматСтраницы = "A4", 2, 3) = 0 Тогда
			Если НЕ ТабДок.ПроверитьВывод(Область) Тогда
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;	
			ТабДок.Вывести(Область);
		Иначе
			ТабДок.Присоединить(Область);
		КонецЕсли;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции	

&НаКлиенте
Процедура КаталогДляСохраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Если ДиалогВыбора.Выбрать() Тогда
		КаталогДляСохранения = ДиалогВыбора.Каталог;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	Если СохранятьВФайл
		И Не ЗначениеЗаполнено(КаталогДляСохранения) Тогда
		Предупреждение("Не указан каталог для сохранения файлов");
	ИначеЕсли СохранятьВФайл Тогда
		Если Прав(КаталогДляСохранения, 1) <> "\" Тогда
			КаталогДляСохранения = КаталогДляСохранения + "\";
		КонецЕсли;	
	КонецЕсли;	
	
	
	Для Каждого СтрокаМагазин Из Объект.Магазины Цикл
		ТабДок = СформироватьЦенникиПоМагазину(СтрокаМагазин.Магазин);
		Если СохранятьВФайл Тогда
			ТабДок.Записать(КаталогДляСохранения + СтрокаМагазин.Магазин + ".pdf", ТипФайлаТабличногоДокумента.PDF);
		Иначе
			ТабДок.Показать(СтрокаМагазин.Магазин);
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматСтраницыОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры
