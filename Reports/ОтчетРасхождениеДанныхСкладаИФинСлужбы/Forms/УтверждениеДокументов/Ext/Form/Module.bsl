﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("МассивДокументы") Тогда
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("МассивДокументы", Параметры.МассивДокументы);
		Запрос.УстановитьПараметр("ВидОперации", Параметры.МассивДокументы);
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	РасходныйОрдерСклад.Ссылка
		               |ИЗ
		               |	Документ.РасходныйОрдерСклад КАК РасходныйОрдерСклад
		               |ГДЕ
		               |	РасходныйОрдерСклад.Ссылка В(&МассивДокументы)
		               |	И РасходныйОрдерСклад.ВидОперации В (ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходСкладскойУчет.ОтгрузкаТехнологу), ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходСкладскойУчет.СписаниеВСебестоимость), ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходСкладскойУчет.СписаниеНаНуждыСклада), ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходСкладскойУчет.СписаниеОтходовОтПереработки), ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходСкладскойУчет.Утилизация), ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходСкладскойУчет.УтилизацияБой))
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	РасходныйОрдерСклад.Дата";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СтрокаДоб = ДокументыКУтверждению.Добавить();
			СтрокаДоб.Утвердить = Истина;
			СтрокаДоб.Документ = Выборка.Ссылка;
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаб Из ДокументыКУтверждению Цикл
		СтрокаТаб.Утвердить = Истина;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого СтрокаТаб Из ДокументыКУтверждению Цикл
		СтрокаТаб.Утвердить = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДатуУтверждения(Команда)
	
	Дата = ТекущаяДата();
	Если ВвестиДату(Дата, "Укажите дату утверждения документов", ЧастиДаты.Дата) Тогда
		Для Каждого СтрокаТаб Из ДокументыКУтверждению Цикл
			Если СтрокаТаб.Утвердить Тогда
				СтрокаТаб.ДатаУтверждения = Дата;
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УтвердитьНаСервере()
	
	Для Каждого СтрокаТаб Из ДокументыКУтверждению Цикл
		Если СтрокаТаб.Утвердить Тогда
			ДокОб = СтрокаТаб.Документ.ПолучитьОбъект();
			ДокОб.ПризкакПодтвержденияВФинУчете = Истина;
			ДокОб.ДатаОтраженияВФинУчете = ?(ЗначениеЗаполнено(СтрокаТаб.ДатаУтверждения), СтрокаТаб.ДатаУтверждения, ДокОб.Дата);
			ДокОб.ДополнительныеСвойства.Вставить("ОтложенноеПроведение", Истина);
			ДокОб.Записать(РежимЗаписиДокумента.Проведение);
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура Утвердить(Команда)
	УтвердитьНаСервере();
	Закрыть();
КонецПроцедуры
