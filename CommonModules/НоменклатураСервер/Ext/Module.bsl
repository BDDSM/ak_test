﻿// Заполняет служебные реквизиты по номенклатуре в коллекции
//
// Параметры:
// 		КоллекцияДанных - ДанныеФормыКоллекция, ТаблицаЗначний - Таблица, в которой необходимо заполнить реквизиты
// 		Реквизиты - Строка - Строка с перечислением через запятую имен реквизитов для заполнения
//
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(КоллекцияДанных, СтруктураДействий) Экспорт
	
	СтруктураДопДанных = ПолучитьСтруктуруДополнительнойИнформации(СтруктураДействий);
	
	Запрос = Новый Запрос(ПолучитьТекстЗапросаПоСлужебнымРеквизитамТЧ(СтруктураДействий, СтруктураДопДанных));
	Запрос.УстановитьПараметр("КоллекцияДанных", КоллекцияДанных.Выгрузить( ,"НомерСтроки" + СтруктураДопДанных.РеквизитыВыгрузки));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Для Н=0 По КоллекцияДанных.Количество()-1 Цикл
		Выборка.Следующий(); // Количество строк в выборке по запросу всегда равно количеству строк в коллекции
		ЗаполнитьЗначенияСвойств(КоллекцияДанных[Н], Выборка, СтруктураДопДанных.РеквизитыЗаполнения);
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьСлужебныеРеквизитыВКоллекции()

// Возвращает структуру дополнительной информации получения служебных реквизитов
//
// Параметры:
// 		СтруктураДействий - Структура - Структура с действиями по получения служебных реквизитов
//
// Возвращаемое значение:
// 		Структура
//
Функция ПолучитьСтруктуруДополнительнойИнформации(СтруктураДействий) Экспорт
	
	СтруктураИсточников = Новый Структура;
	СтрокаРеквизитовЗаполнения = "";
	СтрокаРеквизитовВыгрузки = "";
	
	Для Каждого Действие Из СтруктураДействий Цикл
		Для Каждого Поле Из Действие.Значение Цикл
			Если Не СтруктураИсточников.Свойство(Поле.Ключ) Тогда
				СтруктураИсточников.Вставить(Поле.Ключ);
				СтрокаРеквизитовВыгрузки = СтрокаРеквизитовВыгрузки + ", " + Поле.Ключ;
			КонецЕсли;
			СтрокаРеквизитовЗаполнения = СтрокаРеквизитовЗаполнения + ", " + Поле.Значение;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Новый Структура(
		"СтруктураИсточников, РеквизитыЗаполнения, РеквизитыВыгрузки",
		СтруктураИсточников,
		Сред(СтрокаРеквизитовЗаполнения, 2), // Отрезать первый символ строки, т.к. это запятая
		СтрокаРеквизитовВыгрузки);
	
КонецФункции // ПолучитьСтруктуруДополнительнойИнформации()
	
// Возвращает текст запроса выборки по служебным реквизитам номенклатуры
//
// Парметры:
// 		СтруктураРеквизитов - Структура - Структура с именами служебыных реквизитов в качестве полей
// 		СтруктураДопДанных - Структура - Структура с дополнительными данными
//
// Возвращаемое значение:
// 		Строка - Строка с текстом запроса
//
Функция ПолучитьТекстЗапросаПоСлужебнымРеквизитамТЧ(СтруктураДействий, СтруктураДопДанных) Экспорт
	
	ШаблонЗапроса = "";
	
	// Формирование шаблона запроса временной таблицы по номенклатуре
	ШаблонЗапроса = "
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Таблица.НомерСтроки КАК ЧИСЛО) КАК НомерСтроки%ТекстВЫБРАТЬ%
	|ПОМЕСТИТЬ втТаблицаНоменклатуры
	|ИЗ
	|	&КоллекцияДанных КАК Таблица;";
	
	ШаблонВЫБРАТЬ = ",
	|	ВЫРАЗИТЬ(Таблица.%ИмяПоля% КАК Справочник.Номенклатура) КАК %ИмяПоля%";
	
	ТекстВЫБРАТЬ = "";
	Для Каждого Поле Из СтруктураДопДанных.СтруктураИсточников Цикл
		ТекстВЫБРАТЬ = ТекстВЫБРАТЬ + СтрЗаменить(ШаблонВЫБРАТЬ, "%ИмяПоля%", Поле.Ключ);
	КонецЦикла;
	ШаблонЗапроса = СтрЗаменить(ШаблонЗапроса, "%ТекстВЫБРАТЬ%", ТекстВЫБРАТЬ);
	
	// Шаблон запроса основной выборки
	ШаблонЗапроса = ШаблонЗапроса + "
	|///////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втТаблицаНоменклатуры.НомерСтроки КАК НомерСтроки%ТекстВЫБРАТЬ%
	|ИЗ
	|	втТаблицаНоменклатуры КАК втТаблицаНоменклатуры
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	
	// Формирование полей запроса основной выборки
	ТекстВЫБРАТЬ = "";
	Для Каждого Действие Из СтруктураДействий Цикл
		ШаблонВЫБРАТЬ = ПолучитьШаблонПоляВыборкиПоКлючуДействия(Действие.Ключ);
		Если ШаблонВЫБРАТЬ <> Неопределено Тогда
			Для Каждого Поле Из Действие.Значение Цикл
				ТекстВыбрать = ТекстВЫБРАТЬ + СтрЗаменить(СтрЗаменить(ШаблонВЫБРАТЬ, "%Значение%", Поле.Значение), "%Ключ%", Поле.Ключ);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрЗаменить(ШаблонЗапроса, "%ТекстВЫБРАТЬ%", ТекстВЫБРАТЬ);
	
КонецФункции // ПолучитьТекстЗапросаПоСлужебнымРеквизитамТЧ

// Возвращает шаблон поля выборки соответствуюий для указанного ключа действия
//
// Параметры:
// 		КлючДействия - Строка - Строка имени ключа действия
//
// Возвращаемое значение:
// 		Строка - Строка шаблоно поля запроса
//
Функция ПолучитьШаблонПоляВыборкиПоКлючуДействия(КлючДействия)
	
	Если КлючДействия = "ЗаполнитьПризнакТипНоменклатуры" Тогда
		Возврат ",
		|	втТаблицаНоменклатуры.%Ключ%.ТипНоменклатуры КАК %Значение%";
	КонецЕсли;
	
	Если КлючДействия = "ЗаполнитьПризнакАртикул" Тогда
		Возврат ",
		|	втТаблицаНоменклатуры.%Ключ%.Артикул КАК %Значение%";
	КонецЕсли;
	
	Если КлючДействия = "ЗаполнитьПризнакВариантОформленияПродажи" Тогда
		Возврат ",
		|	втТаблицаНоменклатуры.%Ключ%.ВариантОформленияПродажи КАК %Значение%";
	КонецЕсли;
	
	Если КлючДействия = "ЗаполнитьПризнакХарактеристикиИспользуются" Тогда
		Возврат ",
		|	НЕ втТаблицаНоменклатуры.%Ключ%.НеВедетсяУчетПоХарактеристикам КАК %Значение%";
	КонецЕсли;
	
	Если КлючДействия = "ЗаполнитьПризнакСкладируемый" Тогда
		Возврат ",
		|	втТаблицаНоменклатуры.%Ключ%.Складируемая КАК %Значение%";
	КонецЕсли;
	
	Если КлючДействия = "ЗаполнитьПризнакВедетсяУчетПоГТД" Тогда
		Возврат ",
		|	втТаблицаНоменклатуры.%Ключ%.ВестиУчетПоГТД КАК %Значение%";
	КонецЕсли;
	
	Если КлючДействия = "ЗаполнитьПризнакЭтоУслуга" Тогда
		Возврат ",
		|	ВЫБОР КОГДА втТаблицаНоменклатуры.%Ключ%.ТипНоменклатуры НЕ В
		|		(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
		|		ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК %Значение%";
	КонецЕсли;
	
	Если КлючДействия = "ЗаполнитьПризнакПодакцизныйТовар" Тогда
		Возврат ",
		|	втТаблицаНоменклатуры.%Ключ%.ПодакцизныйТовар КАК %Значение%";
	КонецЕсли;
	
	Если ТипЗнч(КлючДействия) = Тип("Строка") Тогда
		ТекстЗапроса =
			",
			|	втТаблицаНоменклатуры.%Ключ%.%ИмяПоля% КАК %Значение%";
		Возврат СтрЗаменить(ТекстЗапроса, "%ИмяПоля%", КлючДействия);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПроверитьГруппуДоставкиНоменклатуры(Период,ТТ,ГруппаДоставкиНоменклатуры) Экспорт
 	НЗ=РегистрыСведений.СтоимостьУслугПоДоставкеТовараНаТТ.СоздатьНаборЗаписей();
	НЗ.Отбор.Период.Установить(Период);
	НЗ.Отбор.ТТ.Установить(ТТ);
	НЗ.Отбор.ГруппаДоставкиНоменклатуры.Установить(ГруппаДоставкиНоменклатуры);
	НЗ.Прочитать();
	Возврат НЗ.Количество()=0;

КонецФункции // ()

Процедура  УбратьСтарыеЗаписиСтоимостьУслугПоДоставкеТовараНаТТ(Период,ТТ,ГруппаДоставкиНоменклатуры) Экспорт
 	НЗ=РегистрыСведений.СтоимостьУслугПоДоставкеТовараНаТТ.СоздатьНаборЗаписей();
	НЗ.Отбор.Период.Установить(Период);
	НЗ.Отбор.ТТ.Установить(ТТ);
	НЗ.Отбор.ГруппаДоставкиНоменклатуры.Установить(ГруппаДоставкиНоменклатуры);
	НЗ.Прочитать();
	НЗ.Очистить();
	НЗ.Записать(Истина);

КонецПроцедуры// ()
 