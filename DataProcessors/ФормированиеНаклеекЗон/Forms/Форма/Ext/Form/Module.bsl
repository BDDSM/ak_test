﻿
Процедура НоменклатураПриИзменении(ТекИдентификатор)
	
	ТекДанные = Объект.Товары.НайтиПоИдентификатору(ТекИдентификатор);
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Владелец", ТекДанные.Номенклатура);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХарактеристикиНоменклатуры.Ссылка
	               |ИЗ
	               |	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	               |ГДЕ
	               |	ХарактеристикиНоменклатуры.Владелец = &Владелец
	               |	И ХарактеристикиНоменклатуры.Неактивная = ЛОЖЬ";
				   
	ТабХарактеристики = Запрос.Выполнить().Выгрузить();
	
	Если ТабХарактеристики.Количество() = 1 Тогда
		ТекДанные.Характеристика = ТабХарактеристики[0].Ссылка;
	Иначе
		ТекДанные.Характеристика = Неопределено;
	КонецЕсли;
	
	ХарактеристикаПриИзменении(ТекИдентификатор);
	
КонецПроцедуры

Процедура ХарактеристикаПриИзменении(ТекИдентификатор)
	
	ТекДанные = Объект.Товары.НайтиПоИдентификатору(ТекИдентификатор);
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Объект", ТекДанные.Характеристика);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗначенияСвойствОбъектов.Значение
	               |ИЗ
	               |	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	               |ГДЕ
	               |	ЗначенияСвойствОбъектов.Объект = &Объект
	               |	И ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.КоличествоВУпаковке)";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТекДанные.КоличествоВУпаковке = Выборка.Значение;
	Иначе
		ТекДанные.КоличествоВУпаковке = 0;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзменении(Элементы.Товары.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ХарактеристикаПриИзменении(Элементы.Товары.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.Товары.ТекущиеДанные.КоличествоКопий = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЭтикеткиНаСервере()
	
	Этикетки.Очистить();
	ТабДок = Новый ТабличныйДокумент();
	ВнешняяКомпонента = Справочники.Номенклатура.ПодключитьВнешнююКомпонентуПечатиШтрихкода();
	Макет = Обработки.ФормированиеНаклеекЗон.ПолучитьМакет("Этикетка");
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
				   |	Номенклатура.Ссылка,
				   |	Номенклатура.БазоваяЕдиницаИзмерения.Наименование КАК ЕдИзм,
				   |	Номенклатура.НаименованиеПолное
				   |ИЗ
				   |	Справочник.Номенклатура КАК Номенклатура";
				   
	ТабКеш = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТовар Из Объект.Товары Цикл
		
		Если ТабДок.ВысотаТаблицы > 0 Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;	
		
		СтрокаКеш = КартинкиШтрихКодовКСкладам.НайтиСтроки(Новый Структура("Склад_Зона", СтрокаТовар.Склад_Зона))[0];
		
		СтрокаКешТовар = ТабКеш.Найти(СтрокаТовар.Номенклатура, "Ссылка");
		
		Область = Макет.ПолучитьОбласть("Этикетка");
		НаимТовар = Лев(СокрЛП(СтрокаКешТовар.НаименованиеПолное), 60);
		Если СтрДлина(НаимТовар) > 40 Тогда
			НаимТовар = Сред(НаимТовар, 1, 20) + Символы.ПС + Сред(НаимТовар, 21, 20) + Символы.ПС + Сред(НаимТовар, 41);
		ИначеЕсли СтрДлина(НаимТовар) > 20 Тогда
			НаимТовар = Сред(НаимТовар, 1, 20) + Символы.ПС + Сред(НаимТовар, 21);	
		КонецЕсли;	
		Область.Параметры.Товар = НаимТовар;
		Область.Параметры.Характеристика = Лев(СокрЛП(СтрокаТовар.Характеристика), 30);
		Если НРег(СтрокаКешТовар.ЕдИзм) = "кг" Тогда
			Область.Параметры.КолвоВУпаковке = "кг";
		Иначе
			Область.Параметры.КолвоВУпаковке = "Кол-во в кор. " + Формат(СтрокаТовар.КоличествоВУпаковке, "ЧДЦ=2; ЧГ=0");
		КонецЕсли;	
		Область.Параметры.КодЯчейки = СокрЛП(СтрокаТовар.КодЯчейки);
		
		Рисунок 					= Область.Рисунки["ШтрихКод"];
	
		Рисунок.Картинка = СтрокаКеш.КартинкаШК;
		Для н = 1 По СтрокаТовар.КоличествоКопий Цикл
			ТабДок.Вывести(Область);
		КонецЦикла;	
	КонецЦикла;	
	
	Этикетки.Вывести(ТабДок);
	Этикетки.КлючПараметровПечати = "ПараметрыПечати_ЭтикеткиЗон";
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	Этикетки.ПолеСверху = 0;
	Этикетки.ПолеСнизу = 0;
	Этикетки.ПолеСлева = 0;
	Этикетки.ПолеСправа = 0;
	Этикетки.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьШКСкладов()
	
	КартинкиШтрихКодовКСкладам.Очистить();
	ВнешняяКомпонента = Справочники.Номенклатура.ПодключитьВнешнююКомпонентуПечатиШтрихкода();
	Макет = Обработки.ФормированиеНаклеекЗон.ПолучитьМакет("Этикетка");
	
	ТабСклады = Объект.Товары.Выгрузить();
	ТабСклады.Свернуть("Склад_Зона");
	Область = Макет.ПолучитьОбласть("Этикетка");
	Рисунок = Область.Рисунки["ШтрихКод"];
	Для Каждого СтрокаСклад Из ТабСклады Цикл
		СтрокаДоб = КартинкиШтрихКодовКСкладам.Добавить();
		СтрокаДоб.Склад_Зона = СтрокаСклад.Склад_Зона;
		ШтрихКод = "810" + Прав("000000000000" + Формат(СтрокаСклад.Склад_Зона.ИД, "ЧГ=0"), 12);
		ПараметрыШК = Новый Структура();
		ПараметрыШК.Вставить("Ширина", Рисунок.Высота);
		ПараметрыШК.Вставить("Высота", Рисунок.Ширина);
		ПараметрыШК.Вставить("ТипКода", 4);
		ПараметрыШК.Вставить("ОтображатьТекст", Ложь);
		ПараметрыШК.Вставить("Штрихкод", Штрихкод);
		Картинка = ОбщегоНазначенияКлиентСервер.ПолучитьКартинкуШтрихкода(ВнешняяКомпонента, ПараметрыШК);
		//Картинка = Картинка.Преобразовать(ФорматКартинки.JPEG);
		//ИмяВремФайла = ПолучитьИмяВременногоФайла("jpg");
		//Картинка.Записать(ИмяВремФайла);
		//КомпонентаДопГрафика.ПовернутьИзображениеВФайле(ИмяВремФайла, 1);
		//Картинка = Новый Картинка(ИмяВремФайла);
		СтрокаДоб.КартинкаШК = Картинка;
		//УдалитьФайлы(ИмяВремФайла);
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Процедура СформироватьЭтикетки(Команда)
	
	ПодготовитьШКСкладов();
	Для Каждого СтрокаСклад Из КартинкиШтрихКодовКСкладам Цикл
		ИмяВремФайла = ПолучитьИмяВременногоФайла("jpg");
		СтрокаСклад.КартинкаШК.Записать(ИмяВремФайла);
		КомпонентаДопГрафика.ПовернутьИзображениеВФайле(ИмяВремФайла, 1);
		Картинка = Новый Картинка(ИмяВремФайла);
		СтрокаСклад.КартинкаШК = Картинка;
		УдалитьФайлы(ИмяВремФайла);
	КонецЦикла;
	
	СформироватьЭтикеткиНаСервере();
	
	Элементы.Группа1.ТекущаяСтраница = Элементы.СтраницаЭтикетки;
	
КонецПроцедуры

