﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Если Объект.Предопределенный И НЕ Объект.Товары Тогда
	//	Объект.Товары = Истина;
	//	Записать();
	//КонецЕсли; 
	
	Если РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
		Элементы.Код.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
	КонецЕсли;
	
КонецПроцедуры


Процедура НастроитьЭлементыФормы()

	//Если Объект.Предопределенный И НЕ РольДоступна("ПолныеПрава") Тогда
	//	Элементы.Товары.ТолькоПросмотр = Истина;
	//Иначе
	//	Элементы.Товары.ТолькоПросмотр = Ложь;
	//КонецЕсли;
	
	Если Объект.Товары Тогда
		Элементы.РольПолучателя.ТолькоПросмотр = Истина;
		Если ЗначениеЗаполнено(Объект.РольПолучателя) Тогда
			Объект.РольПолучателя = Неопределено;
		КонецЕсли;
	Иначе
		Элементы.РольПолучателя.ТолькоПросмотр = Ложь;
	КонецЕсли; 
	
	Элементы.ВидПолучателей.Видимость = Объект.ПрименяетсяВЦентре;
	Если Объект.ПрименяетсяВЦентре И Объект.ВидПолучателей = Перечисления.ВидыПолучателейМОС.УказаннаяРоль Тогда
		Элементы.РольПолучателя.Видимость = Истина;
	ИначеЕсли Объект.ПрименяетсяВМагазине И Объект.ТипСообщения = Перечисления.ТипыСообщенийМОС.ИнформационноеСообщение Тогда
		Элементы.РольПолучателя.Видимость = Истина;
	Иначе
		Элементы.РольПолучателя.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ТипИнцидента.Видимость = Объект.ТипСообщения = Перечисления.ТипыСообщенийМОС.Инцидент;
	Элементы.ТипИнцидентаТипРоли.Видимость = Элементы.ТипИнцидента.Видимость;
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры


&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.Товары Тогда
		Если ЗначениеЗаполнено(Объект.РольПолучателя) Тогда
			Сообщить("Одновременное заполнение роли получателя и установка флажка ""Товары"" недопустимо");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	Иначе
		Если Объект.ТипСообщения = ПредопределенноеЗначение("Перечисление.ТипыСообщенийМОС.Инцидент") Тогда
			Если НЕ ЗначениеЗаполнено(Объект.ТипИнцидента) Тогда
				Сообщить("Не заполнен тип инцидента");
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			Объект.РольПолучателя = Неопределено;
		Иначе
			//Если НЕ ЗначениеЗаполнено(Объект.РольПолучателя) Тогда
			//	Сообщить("Должна быть либо заполненной роль получателя либо установлен флажок ""Товары""");
			//	Отказ = Истина;
			//	Возврат;
			//КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ТипСообщенияПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

