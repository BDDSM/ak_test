﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//+++АК sils 07.06.2018 ИП-00018876
	ОперацияАпдекс = APDEX_ОценкаПроизводительностиКлиентСервер.ПолучитьОперацию("Открытие документа Задача товароведа на дегустацию новинки");
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(ОперацияАпдекс);
	//---АК
	ЗаданиеНаДегустациюНовинки = Объект.ЗаданиеНаДегустациюНовинки;
	ДатаДок = ЗаданиеНаДегустациюНовинки.Дата;
	НомерДок = ЗаданиеНаДегустациюНовинки.Номер;
	Комментарий = ЗаданиеНаДегустациюНовинки.Комментарий;
	ЕдиницаИзмерения = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Номенклатура, "ЕдиницаХраненияОстатков");
	СканироватьШтрихкод = ЗаданиеНаДегустациюНовинки.СканироватьШтрихкод;
	Элементы.ДеревоПоказателейВвестиШтрихКод.Видимость = СканироватьШтрихкод;
	ЭтоШтучныйТовар = НЕ ОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Номенклатура, "Весовой");
	ТолькоПросмотр = Объект.Закрыта ИЛИ Объект.Проведен ИЛИ (ЗаданиеНаДегустациюНовинки.Проведен ИЛИ ЗаданиеНаДегустациюНовинки.ПометкаУдаления);
	
	ЗадачаНаРазработке = (РегистрыСведений.ПараметрыРаботыССоцСетями.ПолучитьЗначениеПараметра(, "ЗадачаНаДегустациюНовинкиНаРазработке") = Истина);
	Если ЗадачаНаРазработке Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если НЕ ТолькоПросмотр И Объект.РозничнаяЦена = 0 Тогда
		Объект.РозничнаяЦена = Документы.МП_ЗадачаТехнолога.РозничнаяЦена(Объект.Номенклатура);
	КонецЕсли;
	
	ОтветственныеЛица.Загрузить(Документы.ЗаданиеНаДегустациюНовинки.ВернутьТЗнОтветственных(Объект.ЗаданиеНаДегустациюНовинки));
	
	//+++АК SHEP 2018.07.09 ИП-00018818
	Если ЗначениеЗаполнено(Объект.ХарактеристикаНоменклатуры) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Объект.ХарактеристикаНоменклатуры, "ФишкаРазвёрнуто");
	КонецЕсли;
	//---АК SHEP 2018.07.09
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДеревоПоказателей()
	
	СтрокиДерева = ДеревоПоказателей.ПолучитьЭлементы();
	
	Для Каждого СтрокаТЧ Из Объект.ОценкаПоказателей Цикл
		
		НоваяСтрокаДерева = СтрокиДерева.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаДерева, СтрокаТЧ);
		
		МассивКомментариевПоСтроке = Объект.КомментарииПоказателей.НайтиСтроки(Новый Структура("УИДСтрокиПоказателя", СтрокаТЧ.УИДСтрокиПоказателя));
		Для Каждого СтрокаКомментария Из МассивКомментариевПоСтроке Цикл
			НоваяСтрокаДереваКомментарий = НоваяСтрокаДерева.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДереваКомментарий, СтрокаКомментария);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьДеревоПоказателей();
	НетТовараДанногоПроизводителя = ?(СканироватьШтрихкод, Неопределено, Ложь);
	
	Если ЗадачаНаРазработке Тогда
		Предупреждение("По данному функционалу проводятся сервисные работы,
			|попробуйте работать с данным документом чуть позже!");
	КонецЕсли;
	
	//+++АК sils 07.06.2018 ИП-00018876
	APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(ОперацияАпдекс, ?(Параметры.Ключ.Пустая(), "Новый документ", "" + Объект.Ссылка));
	//---АК
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПоказателейПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	ИмяТекЭлемента = СтрЗаменить(Элемент.ТекущийЭлемент.Имя, "ДеревоПоказателей", "");
	
	Если ИмяТекЭлемента = "Оценка" И НЕ ЗначениеЗаполнено(ТекущиеДанные.Показатель) Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли ИмяТекЭлемента = "Комментарий" И ЗначениеЗаполнено(ТекущиеДанные.Показатель) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если СканироватьШтрихкод И НЕ ШтрихКодОтсканирован Тогда
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, "Да, у меня есть такой товар от этого производителя и я его просканирую");
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, "Нет данного товара/характеристики");
		//СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, "Отмена");
		
		Если Вопрос("Чтобы изменить значения по этому товару, отсканируй его", СписокКнопок, , КодВозвратаДиалога.Да, "Задача товароведа на дегустацию новинки", ) = КодВозвратаДиалога.Нет Тогда
			НетТовараДанногоПроизводителя = Истина;
		Иначе
			ВвестиШтрихКод("");
		КонецЕсли;
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПоказателейОценкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоПоказателей.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	МассивСтрокДляОтбора = Объект.ОценкаПоказателей.НайтиСтроки(Новый Структура("УИДСтрокиПоказателя", ТекущиеДанные.УИДСтрокиПоказателя));
	Для Каждого СтрокаТЧ Из МассивСтрокДляОтбора Цикл
		СтрокаТЧ.Оценка = ТекущиеДанные.Оценка;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПоказателейКомментарийПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоПоказателей.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	МассивСтрокДляОтбора = Объект.КомментарииПоказателей.НайтиСтроки(Новый Структура("УИДСтрокиПоказателя,ТипКомментария", ТекущиеДанные.УИДСтрокиПоказателя, ТекущиеДанные.ТипКомментария));
	Для Каждого СтрокаТЧ Из МассивСтрокДляОтбора Цикл
		СтрокаТЧ.Комментарий = ТекущиеДанные.Комментарий;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// если нет данного товара, проверки не выполняем
	Если НетТовараДанногоПроизводителя = Истина Тогда
		Если Объект.Количество <> 0 Тогда
			Если Вопрос("Если нет данного товара, количество для списания не нужно указывать!
	  		  |Очистить количество?", РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Нет, "Задача товароведа на дегустацию новинки") = КодВозвратаДиалога.Да Тогда
				Объект.Количество = 0;
		  	Иначе
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// запрещаем ввод дробного количества для штучного товара
	Если ЭтоШтучныйТовар И Объект.Количество <> Цел(Объект.Количество) Тогда
		Предупреждение("Для штучного товара нужно указывать целое количество (штук)!");
		Отказ = Истина;
		Возврат;
	ИначеЕсли Объект.Количество = 0 И Вопрос("Не заполнено количество для списания!
	  |Провести без количества?", РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Нет, "Задача товароведа на дегустацию новинки") <> КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	//Для Каждого СтрокаОценки Из Объект.ОценкаПоказателей Цикл
	//	Если СтрокаОценки.Оценка = 0 Тогда
	//		Сообщение = Новый СообщениеПользователю;
	//		Сообщение.Текст = "По показателю """ + СтрокаОценки.Показатель + """ не заполнена оценка!";
	//		Сообщение.Поле = "Объект.ОценкаПоказателей[" + (СтрокаОценки.НомерСтроки - 1) + "]";
	//		Сообщение.УстановитьДанные(Объект);
	//		Сообщение.Сообщить();
	//		Отказ = Истина;
	//		Возврат;
	//	КонецЕсли;
	//	
	//	МассивСтрокДляОтбора = Объект.КомментарииПоказателей.НайтиСтроки(Новый Структура("УИДСтрокиПоказателя,Обязательный,Комментарий", СтрокаОценки.УИДСтрокиПоказателя, Истина, ""));
	//	Для Каждого СтрокаКомментарии Из МассивСтрокДляОтбора Цикл
	//		Сообщение = Новый СообщениеПользователю;
	//		Сообщение.Текст = "Не заполнен обязательный комментарий " + СтрокаОценки.Показатель + ": " + СтрокаКомментарии.ТипКомментария + "!";
	//		Сообщение.Поле = "Объект.ОценкаПоказателей[" + (СтрокаОценки.НомерСтроки - 1) + "]";
	//		Сообщение.УстановитьДанные(Объект);
	//		Сообщение.Сообщить();
	//		Отказ = Истина;
	//		Возврат;
	//	КонецЦикла;
	//КонецЦикла;
	
	Для Каждого СтрокаОценки Из Объект.ОценкаПоказателей Цикл
		
		Если СтрокаОценки.Оценка = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("По показателю """ + СтрокаОценки.Показатель + """ не заполнена оценка!", Объект,
				"Объект.ОценкаПоказателей[" + (СтрокаОценки.НомерСтроки - 1) + "].Оценка",, Отказ);
			Возврат;
		ИначеЕсли ПустаяСтрока(СтрокаОценки.Комментарий) И СтрокаОценки.Оценка <> 5 Тогда
			//ОбщегоНазначенияКлиентСервер.СообщитьПользователю("По показателю """ + СтрокаОценки.Показатель + """ не заполнен комментарий!", Объект,
			//	"Объект.ОценкаПоказателей[" + (СтрокаОценки.НомерСтроки - 1) + "].Комментарий",, Отказ);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нам очень важен комментарий к вашей оценке, напишите, пожалуйста!", Объект,
				"Объект.ОценкаПоказателей[" + (СтрокаОценки.НомерСтроки - 1) + "].Комментарий",, Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
Перем ПерваяСтрока;
	
	Если Источник = "KeyboardHook" И Данные = "00122" И НЕ ШтрихКодОбработанФормой Тогда
		
		ШтрихКодОбработанФормой = Истина;
		Если НЕ СканироватьШтрихкод Тогда Возврат; КонецЕсли;
		
		ШтрихКод = ОткрытьФормуМодально("ОбщаяФорма.ФормаВводаШтрихкода");
		ШтрихКодОбработанФормой = Истина;
		Если НЕ ЗначениеЗаполнено(ШтрихКод) Тогда Возврат; КонецЕсли;
		
		СтруктураДанных = ВнешниеДанные.СчитатьДанныеПоШтрихКоду(ШтрихКод);
		Если Объект.Номенклатура <> СтруктураДанных.Номенклатура Тогда
			ОшибкаСтрокой = "Данный товар по этой задаче технолога не надо оценивать!";
		ИначеЕсли Объект.ХарактеристикаНоменклатуры <> СтруктураДанных.Характеристика Тогда
			ОшибкаСтрокой = "Данного производителя по этой задаче технолога не надо оценивать!";
		Иначе
			ШтрихКодОтсканирован = Истина;
		КонецЕсли;
		
		Если ПустаяСтрока(ОшибкаСтрокой) Тогда
			// разрешаем редактирование
			НетТовараДанногоПроизводителя = Ложь;
			//ТекущийЭлемент = Элементы.ДеревоПоказателей;
			//Если ТекущийЭлемент.ТекущийЭлемент.Имя <> "ДеревоПоказателейКомментарий" Тогда ТекущийЭлемент.ТекущийЭлемент = Элементы.ДеревоПоказателейОценка; КонецЕсли;
			ТекущийЭлемент = Элементы.ОценкаПоказателей;
			Если ТекущийЭлемент.ТекущийЭлемент.Имя <> "ОценкаПоказателейКомментарий" Тогда ТекущийЭлемент.ТекущийЭлемент = Элементы.ОценкаПоказателейОценка; КонецЕсли;
			ТекущийЭлемент.ИзменитьСтроку();
		Иначе
			Предупреждение(ОшибкаСтрокой);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихКод(Команда)
	ШтрихКодОбработанФормой = Ложь;
	ВнешнееСобытие("KeyboardHook", "KeyboardHook", "00122");
КонецПроцедуры

&НаКлиенте
Процедура ОценкаПоказателейПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	ИмяТекЭлемента = СтрЗаменить(Элемент.ТекущийЭлемент.Имя, "ОценкаПоказателей", "");
	
	Если ИмяТекЭлемента = "Показатель" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если СканироватьШтрихкод И НЕ ШтрихКодОтсканирован Тогда
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, "Да, у меня есть такой товар от этого производителя и я его просканирую");
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, "Нет данного товара/характеристики");
		//СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, "Отмена");
		
		Если Вопрос("Чтобы изменить значения по этому товару, отсканируй его", СписокКнопок, , КодВозвратаДиалога.Да, "Задача товароведа на дегустацию новинки", ) = КодВозвратаДиалога.Нет Тогда
			НетТовараДанногоПроизводителя = Истина;
		Иначе
			ВвестиШтрихКод("");
		КонецЕсли;
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры
