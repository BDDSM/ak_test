﻿Функция ЕстьНепроведенныеДокументыВМагазине() Экспорт
	
	ТекДата = ТекущаяДатаСеанса();
	ТорговаяТочка = ПараметрыСеанса.ТорговаяТочкаПоАйпи;
	СтаршийСмены = МеханизмОбменаСообщениями.ПолучитьСтаршегоТекущейСмены(ТорговаяТочка, ТекДата);
		
	Запрос1 = Новый Запрос;
	Запрос1.Текст = 
	"ВЫБРАТЬ
	|	СообщениеМОССтруктурныеЕдиницы.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.СообщениеМОС.СтруктурныеЕдиницы КАК СообщениеМОССтруктурныеЕдиницы
	|ГДЕ
	|	СообщениеМОССтруктурныеЕдиницы.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|	И СообщениеМОССтруктурныеЕдиницы.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И СообщениеМОССтруктурныеЕдиницы.СтаршийСмены = &СтаршийСмены
	|	И СообщениеМОССтруктурныеЕдиницы.Ссылка.ДатаАктуальности >= &ТекДата
	|	И СообщениеМОССтруктурныеЕдиницы.Ссылка.Проведен = ЛОЖЬ";
	
	Запрос1.УстановитьПараметр("ТекДата", ТекДата);
	Запрос1.УстановитьПараметр("СтаршийСмены", СтаршийСмены);
	Запрос1.УстановитьПараметр("СтруктурнаяЕдиница", ТорговаяТочка);
	
	Рез1 = Запрос1.Выполнить();
	ТЗРез = Рез1.Выгрузить();
	Если ТЗРез.Количество() > 10 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции // ()

Функция ФДЗаполнен(ФД) Экспорт

	ТекстHTML = "";
	Вложения = Новый Структура;
	ФД.ПолучитьHTML(ТекстHTML, Вложения);
	
	Текст1 = ФД.ПолучитьТекст();
	Если НЕ ЗначениеЗаполнено(Текст1) И Вложения.Количество() = 0 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции // ()
