﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьСостояниеКонтактногоЛицаСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ДобавитьВИсториюКЛКонтрагента();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты) //+++АК mika 2018.07.31 ИП-00019374
	
	Если Справочники.КонтактныеЛицаКонтрагентов.КонтрагентПредоставляетТранспортныеУслуги(Объект.Владелец) Тогда
		//ПроверяемыеРеквизиты.Добавить("ВодительскоеНомер"); //Не отрабатывает
		Если НЕ ЗначениеЗаполнено(Объект.ВодительскоеНомер) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Необходимо заполнить номер удостоверения!";
			Сообщение.Поле  = "Объект.ВодительскоеНомер";
			Сообщение.УстановитьДанные(Объект);
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтактноеЛицоПриИзменении(Элемент)
	
	Объект.Наименование = СокрЛП(Строка(Объект.КонтактноеЛицо));
	
КонецПроцедуры

&НаКлиенте
Процедура ВодительскоеСсылкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка) //+++АК mika 2018.07.31 ИП-00019374
	
	СтандартнаяОбработка = Ложь;
	
	ПрикрепитьФайлУдостоверенияКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВодительскоеСсылкаОткрытие(Элемент, СтандартнаяОбработка) //+++АК mika 2018.07.31 ИП-00019374
	
	Если ЗначениеЗаполнено(Объект.ВодительскоеСсылка) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		СтруктураФайла = ПолучитьСтруктуруФайлаДляОткрытияСервер(Объект.ВодительскоеСсылка);
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла(СтруктураФайла.Расширение);
		
		Если ПолучитьФайл(СтруктураФайла.Файл, ИмяВременногоФайла, Ложь) = Истина Тогда
			ЗапуститьПриложение(ИмяВременногоФайла);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПечатьБейджа(Команда) //+++АК mika 2018.08.01 ИП-00019374
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		МассивКонтЛиц = Новый Массив();
		МассивКонтЛиц.Добавить(Объект.Ссылка);
		ТабличныйДокумент = ПечатьБейджейСервер(МассивКонтЛиц);
		ТабличныйДокумент.Показать("Бэйджи");
	Иначе
		ПоказатьПредупреждение(,"Текущий элемент не записан (печать невозможна)!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеНажатие(Элемент, СтандартнаяОбработка) //+++АК mika 2018.08.01 ИП-00019374
	
	СтандартнаяОбработка = Ложь;

	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ОткрытьФорму("РегистрСведений.ИсторияКонтактныхЛицКонтрагентов.Форма.ФормаСписка", Новый Структура("Отбор", Новый Структура("КонтактноеЛицоКонтрагента", Объект.Ссылка)), 
					ЭтаФорма,,ВариантОткрытияОкна.ОтдельноеОкно,,Новый ОписаниеОповещения("ОбновитьСостояниеИсторииЗакрытие", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	Иначе
		ПоказатьПредупреждение(,"Перед просомтрм истории необходимо записать элемент!");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещений

&НаКлиенте
Процедура ОбработатьВыборФайлаЗакрытие(Результат, ДополнительныеПараметры)Экспорт //+++АК mika 2018.07.31 ИП-00019374 
	
	Если Результат <> Неопределено Тогда
		Для Каждого ИмяФайла Из Результат Цикл
			ОбработатьВыбранныйФайлКлиент(ИмяФайла);
		КонецЦикла;
	Иначе
		ПоказатьПредупреждение(,НСтр("ru = 'Файл не выбран!'; en = 'File not selected!'"))
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеИсторииЗакрытие(Результат, ДополнительныеПараметры) Экспорт //+++АК mika 2018.08.01 ИП-00019374
	
	ОбновитьСостояниеКонтактногоЛицаСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьВИсториюКЛКонтрагента()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ИсторияКонтактныхЛицКонтрагентов.КонтактноеЛицоКонтрагента
	|ИЗ
	|	РегистрСведений.ИсторияКонтактныхЛицКонтрагентов КАК ИсторияКонтактныхЛицКонтрагентов
	|ГДЕ
	|	ИсторияКонтактныхЛицКонтрагентов.КонтактноеЛицоКонтрагента = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если НЕ Выборка.Следующий() Тогда
		
		НаборЗаписей = РегистрыСведений.ИсторияКонтактныхЛицКонтрагентов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.КонтактноеЛицоКонтрагента.Использование 	= Истина;
		НаборЗаписей.Отбор.КонтактноеЛицоКонтрагента.Значение 		= Объект.Ссылка;
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Период = ТекущаяДата();
		НоваяЗапись.КонтактноеЛицоКонтрагента 	= Объект.Ссылка;
		НоваяЗапись.КонтактноеЛицо 				= Объект.КонтактноеЛицо;
		НоваяЗапись.Контрагент 					= Объект.Владелец;
		
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепитьФайлУдостоверенияКлиент() //+++АК mika 2018.07.31 ИП-00019374
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'Файл'; en = 'File'") + "(*.jpg, *.pdf)|*.jpg;*.pdf";
	
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	
	НачатьПомещениеФайлов(Новый ОписаниеОповещения("ОбработатьВыборФайлаЗакрытие", ЭтаФорма), , ДиалогОткрытияФайла, Истина, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыбранныйФайлКлиент(Адрес) //+++АК mika 2018.07.31 ИП-00019374
	
	//Определение имени файла
	ИмяФайла = Адрес.Имя;
	
	ЭтоКаталог = Найти(ИмяФайла,"\");
	Пока ЭтоКаталог > 0 Цикл
		ИмяФайла = Сред(ИмяФайла, ЭтоКаталог+1, СтрДлина(ИмяФайла));
		ЭтоКаталог = Найти(ИмяФайла,"\");
	КонецЦикла;
	
	//Заполнение реквизитов объекта на сервере
	
	ОбработатьВыбранныйФайлСервер(ИмяФайла, Адрес.Хранение);
	
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьВыбранныйФайлСервер(ИмяФайла, Хранение) //+++АК mika 2018.07.31 ИП-00019374
	
	Если ЗначениеЗаполнено(Объект.ВодительскоеСсылка) Тогда
		ФайлОбъект = Объект.ВодительскоеСсылка.ПолучитьОбъект();
	Иначе
		ФайлОбъект = Справочники.Файлы.СоздатьЭлемент();
	КонецЕсли;
	
	ФайлОбъект.Наименование   = ИмяФайла; 
	ФайлОбъект.ИмяФайла       = ИмяФайла;
	ФайлОбъект.ИмяПодкаталога = "Водительские удостоверения";
	ФайлОбъект.Расширение     = Прав(ИмяФайла, 3);
	
	ФайлОбъект.ДополнительныеСвойства.Вставить("Хранилище", 
			Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Хранение)));
	
	ФайлОбъект.Записать();
	
	Объект.ВодительскоеСсылка = ФайлОбъект.Ссылка;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруФайлаДляОткрытияСервер(ВодительскоеСсылка) //+++АК mika 2018.07.31 ИП-00019374
	
	Возврат Новый Структура("Файл, Расширение", ПоместитьВоВременноеХранилище(Новый Картинка(Справочники.Файлы.ПолучитьИмяФайлаДляОбъекта(ВодительскоеСсылка))), 
					ОбщегоНазначения.ПолучитьЗначениеРеквизита(ВодительскоеСсылка, "Расширение"));
	
КонецФункции

&НаСервере
Функция ПечатьБейджейСервер(МассивКонтЛиц) //+++АК mika 2018.08.01 ИП-00019374
	
	Возврат Справочники.КонтактныеЛицаКонтрагентов.ПечатьБейджейКонтактныеЛицаКонтрагентов(МассивКонтЛиц);
	
КонецФункции

&НаСервере
Процедура ОбновитьСостояниеКонтактногоЛицаСервер() //+++АК mika 2018.08.01 ИП-00019374
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ИсторияКонтактныхЛицКонтрагентовСрезПоследних.ДатаУвольнения) КАК ДатаУвольнения
	|ИЗ
	|	РегистрСведений.ИсторияКонтактныхЛицКонтрагентов.СрезПоследних КАК ИсторияКонтактныхЛицКонтрагентовСрезПоследних
	|ГДЕ
	|	ИсторияКонтактныхЛицКонтрагентовСрезПоследних.КонтактноеЛицоКонтрагента = &КонтактноеЛицоКонтрагента";
	
	Запрос.УстановитьПараметр("КонтактноеЛицоКонтрагента", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если  Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Выборка.Следующий();
		
		ДатаУвольнения = СтрЗаменить("ДатаУвольнения", "ДатаУвольнения", ?(ЗначениеЗаполнено(Выборка.ДатаУвольнения), Формат(Выборка.ДатаУвольнения,"ДФ=dd.MM.yyyy"),""));

		Состояние = СокрЛП(СтрЗаменить(СтрЗаменить("Состояние ДатаУвольнения", "Состояние", 
						?(ЗначениеЗаполнено(ДатаУвольнения), "Уволен", "Работает")), "ДатаУвольнения", ДатаУвольнения));
		
	Иначе 
		Состояние = "Работает";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти









