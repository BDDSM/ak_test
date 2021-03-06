﻿
Процедура ПриИзмененииВидаРасходов()
	
	Если (НЕ Объект.ВидТранспортныхРасходов = Перечисления.ВидыОбщихТранспортныхРасходов.Прочие)
			И Объект.СписыватьРасходыНа44Счет Тогда
		Объект.СписыватьРасходыНа44Счет = Ложь;
	ИначеЕсли Объект.ВидТранспортныхРасходов = Перечисления.ВидыОбщихТранспортныхРасходов.Прочие
			И НЕ Объект.СписыватьРасходыНа44Счет Тогда
		Объект.СписыватьРасходыНа44Счет = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьДоступностьПоВидуРасходов()
	
	Элементы.СтраницаПоставщики.Видимость =	(Объект.ВидТранспортныхРасходов = Перечисления.ВидыОбщихТранспортныхРасходов.ДоставкаНаСклад);
	
	ЭтоДопУслуги = (Объект.ВидТранспортныхРасходов = Перечисления.ВидыОбщихТранспортныхРасходов.ДополнительныеУслуги);
	Элементы.СтатьяДоходовРасходов.Видимость = ЭтоДопУслуги;
	Элементы.СтраницаТорговыеТочки.Видимость = ЭтоДопУслуги;
	
КонецПроцедуры

Процедура РассчитатьСуммуНДС()
	
	Перем мСуммаВключаетНДС;
	
	мСуммаВключаетНДС = (Объект.ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.НДСвТомЧисле);
	Если Объект.ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.БезНДС Тогда
		Объект.СтавкаНДС 	= Перечисления.СтавкиНДС.БезНДС;
		Объект.СуммаНДС		= 0;
		Возврат;
	КонецЕсли;
	
	Объект.СуммаНДС = УчетНДС.РассчитатьСуммуНДС(Объект.Сумма,
													   Истина, мСуммаВключаетНДС,
													   УчетНДС.ПолучитьСтавкуНДС(Объект.СтавкаНДС));
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//+++АК sils 08.06.2018 ИП-00018876
	ОперацияАпдекс = APDEX_ОценкаПроизводительностиКлиентСервер.ПолучитьОперацию("Открытие документа Общие транспортные расходы");
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(ОперацияАпдекс);
	//---АК
	
	// значения "по умолчанию"
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Объект.Автор 		= ПараметрыСеанса.ТекущийПользователь;
		Объект.Дата 		= ТекущаяДата();
		Объект.Организация 	= УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
		
		Объект.ВидТранспортныхРасходов = Перечисления.ВидыОбщихТранспортныхРасходов.ДоставкаНаСклад;
		
		Объект.ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.НДСвТомЧисле;
		
	Иначе
		
		НастройкаПравДоступа.ОпределитьДоступностьВозможностьИзмененияДокументаПоДатеЗапрета(Объект.Ссылка.ПолучитьОбъект(), ЭтаФорма);
		
		 // переход со старой структуры хранения данных
		Если Объект.ВидТранспортныхРасходов.Пустая() Тогда
			Если Объект.СписыватьРасходыНа44Счет Тогда
				Объект.ВидТранспортныхРасходов = Перечисления.ВидыОбщихТранспортныхРасходов.Прочие;
			Иначе
				Объект.ВидТранспортныхРасходов = Перечисления.ВидыОбщихТранспортныхРасходов.ДоставкаНаСклад;
			КонецЕсли;
			Элементы.СписыватьРасходыНа44Счет.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьДоступностьПоВидуРасходов();
	
	//+++АК SHEP 2018.01.26 ИП-00017365.02
	Если ЗначениеЗаполнено(Объект.Ссылка) И НЕ ТолькоПросмотр Тогда
		ТолькоПросмотр = Документы.ОбщиеТранспортныеРасходы.ДокументИспользуетсяВТранспортныхДокументах(Объект.Ссылка, Истина);
	КонецЕсли;
	//---АК SHEP 2018.01.26
	
КонецПроцедуры

&НаКлиенте
Процедура ВидТранспортныхРасходовПриИзменении(Элемент)
	
	ПриИзмененииВидаРасходов();
	
	УстановитьДоступностьПоВидуРасходов();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	РассчитатьСуммуНДС();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРасчетаНДСПриИзменении(Элемент)
	
	РассчитатьСуммуНДС();
	
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	
	РассчитатьСуммуНДС();
	
КонецПроцедуры

 &НаСервере
Функция СоздатьФайлХранения(СтрокаТаблицы, РасширениеРезультата)
	
	СпрОбъект = Справочники.Файлы.СоздатьЭлемент();
	СпрОбъект.Наименование 	= СтрокаТаблицы.Представление;
	СпрОбъект.Расширение 	= РасширениеРезультата;
	СпрОбъект.ДополнительныеСвойства.Вставить("Хранилище", Новый ХранилищеЗначения(Новый Картинка(СтрокаТаблицы.ДанныеКартинки)));
	СпрОбъект.Записать();
	
	Возврат СпрОбъект.Ссылка;
	
КонецФункции
&НаСервере
Функция ПолучитьРеквизитыСохраненияКартинки(ФайлСсылка)
	
	Картинка = Новый Картинка(Справочники.Файлы.ПолучитьИмяФайлаДляОбъекта(ФайлСсылка));
	Возврат Новый Структура("АдресКартинки, Расширение", ПоместитьВоВременноеХранилище(Картинка), ФайлСсылка.Расширение);
	
КонецФункции


&НаКлиенте
Процедура АктНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла 		= "";
	ДиалогОткрытияФайла.МножественныйВыбор 	= Ложь;
	ДиалогОткрытияФайла.Заголовок 			= "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
	    МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
	    Для Каждого ИмяФайла Из МассивФайлов Цикл
	        ВыбФайл = Новый Файл(ИмяФайла);
			Если НЕ ВыбФайл.Существует() Тогда				
				Сообщить("Не существует файл. "+ИмяФайла);
				Продолжить;
			КонецЕсли;
			Объект.Акт = СоздатьФайлХранения(Новый Структура("Представление, ДанныеКартинки", ВыбФайл.Имя, Новый ДвоичныеДанные(ИмяФайла)), ВыбФайл.Расширение);
			ЭтаФорма.Модифицированность = Истина;
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура АктОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СтруктураКартинки = ПолучитьРеквизитыСохраненияКартинки(Объект.Акт);
	ИмяФайла = ПолучитьИмяВременногоФайла(СтруктураКартинки.Расширение);
	Если ПолучитьФайл(СтруктураКартинки.АдресКартинки, ИмяФайла, Ложь) = Истина Тогда
		ЗапуститьПриложение(ИмяФайла);
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура СчетФактураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла 		= "";
	ДиалогОткрытияФайла.МножественныйВыбор 	= Ложь;
	ДиалогОткрытияФайла.Заголовок 			= "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
	    МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
	    Для Каждого ИмяФайла Из МассивФайлов Цикл
	        ВыбФайл = Новый Файл(ИмяФайла);
			Если НЕ ВыбФайл.Существует() Тогда				
				Сообщить("Не существует файл. "+ИмяФайла);
				Продолжить;
			КонецЕсли;
			Объект.СчетФактура = СоздатьФайлХранения(Новый Структура("Представление, ДанныеКартинки", ВыбФайл.Имя, Новый ДвоичныеДанные(ИмяФайла)), ВыбФайл.Расширение);
			ЭтаФорма.Модифицированность = Истина;
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура СчетФактураОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СтруктураКартинки = ПолучитьРеквизитыСохраненияКартинки(Объект.СчетФактура);
	ИмяФайла = ПолучитьИмяВременногоФайла(СтруктураКартинки.Расширение);
	Если ПолучитьФайл(СтруктураКартинки.АдресКартинки, ИмяФайла, Ложь) = Истина Тогда
		ЗапуститьПриложение(ИмяФайла);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПриложениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла 		= "";
	ДиалогОткрытияФайла.МножественныйВыбор 	= Ложь;
	ДиалогОткрытияФайла.Заголовок 			= "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
	    МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
	    Для Каждого ИмяФайла Из МассивФайлов Цикл
	        ВыбФайл = Новый Файл(ИмяФайла);
			Если НЕ ВыбФайл.Существует() Тогда				
				Сообщить("Не существует файл. "+ИмяФайла);
				Продолжить;
			КонецЕсли;
			Объект.Приложение = СоздатьФайлХранения(Новый Структура("Представление, ДанныеКартинки", ВыбФайл.Имя, Новый ДвоичныеДанные(ИмяФайла)), ВыбФайл.Расширение);
			ЭтаФорма.Модифицированность = Истина;
			
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура ПриложениеОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СтруктураКартинки = ПолучитьРеквизитыСохраненияКартинки(Объект.Приложение);
	ИмяФайла = ПолучитьИмяВременногоФайла(СтруктураКартинки.Расширение);
	Если ПолучитьФайл(СтруктураКартинки.АдресКартинки, ИмяФайла, Ложь) = Истина Тогда
		ЗапуститьПриложение(ИмяФайла);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Если Не Объект.ДокументыПолучены Тогда
			//Отказ = Истина;
			//Сообщить("Внимание! Проведение без ""Документы получены"" запрещено.",СтатусСообщения.ОченьВажное);
		КонецЕсли;	
		Если Объект.ДокументыПолучены И НЕ Объект.СтатусПолученныхДокументов = Перечисления.СтатусыПолученныхДокументов.ПринятыПоЭДО Тогда
			Если Не ЗначениеЗаполнено(Объект.УПД) Тогда
				Если НЕ ЗначениеЗаполнено(Объект.Акт) Тогда
					//Отказ = Истина;
					//Сообщить("Внимание! Проведение без скана акта/накладной или УПД запрещено.",СтатусСообщения.ОченьВажное);
				КонецЕсли;	
				Если НЕ ЗначениеЗаполнено(Объект.СчетФактура) И Объект.ВариантРасчетаНДС<>Перечисления.ВариантыРасчетаНДС.БезНДС Тогда
					//Отказ = Истина;
					//Сообщить("Внимание! Проведение без скана фактуры или УПД запрещено.",СтатусСообщения.ОченьВажное);
				КонецЕсли;	
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтатусПолученныхДокументовПриИзменении(Элемент)
	
	Объект.ДокументыПолучены = ЗначениеЗаполнено(Объект.СтатусПолученныхДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура УПДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла 		= "";
	ДиалогОткрытияФайла.МножественныйВыбор 	= Ложь;
	ДиалогОткрытияФайла.Заголовок 			= "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
	    МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
	    Для Каждого ИмяФайла Из МассивФайлов Цикл
	        ВыбФайл = Новый Файл(ИмяФайла);
			Если НЕ ВыбФайл.Существует() Тогда				
				Сообщить("Не существует файл. "+ИмяФайла);
				Продолжить;
			КонецЕсли;
			Объект.УПД = СоздатьФайлХранения(Новый Структура("Представление, ДанныеКартинки", ВыбФайл.Имя, Новый ДвоичныеДанные(ИмяФайла)), ВыбФайл.Расширение);
			ЭтаФорма.Модифицированность = Истина;
			
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура УПДОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СтруктураКартинки = ПолучитьРеквизитыСохраненияКартинки(Объект.УПД);
	ИмяФайла = ПолучитьИмяВременногоФайла(СтруктураКартинки.Расширение);
	Если ПолучитьФайл(СтруктураКартинки.АдресКартинки, ИмяФайла, Ложь) = Истина Тогда
		ЗапуститьПриложение(ИмяФайла);
	КонецЕсли;
КонецПроцедуры

//+++АК sils 08.06.2018 ИП-00018876
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(ОперацияАпдекс, ?(Параметры.Ключ.Пустая(), "Новый документ", "" + Объект.Ссылка));
КонецПроцедуры
