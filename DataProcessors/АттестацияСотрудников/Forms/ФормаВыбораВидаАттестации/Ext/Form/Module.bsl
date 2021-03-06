﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнениеПараметровформы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	УдалитьВременныеФайлыКлиент(Строка(КаталогВременныхФайлов) + "\" + Этаформа.УникальныйИдентификатор);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок   

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ПроверитьВозможностьПрохожденияТестирования() Тогда	
		ПоказатьВопрос(Новый ОписаниеОповещения("НачатьТестированиеВопросЗавершение", ЭтаФорма), 
			НСтр("ru = 'Начать тестированое?'", "ru"), РежимДиалогаВопрос.ДаНет, 15 );
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ПроверитьВозможностьПрохожденияТестирования() Тогда	
		ПоказатьВопрос(Новый ОписаниеОповещения("НачатьТестированиеВопросЗавершение", ЭтаФорма), 
			НСтр("ru = 'Начать тестированое?'", "ru"), РежимДиалогаВопрос.ДаНет, 15 );
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаНачатьТестирование(Команда)
	
	Если НЕ ПроверитьВозможностьПрохожденияТестирования() Тогда
		
		ПоказатьВопрос(Новый ОписаниеОповещения("НачатьТестированиеВопросЗавершение", ЭтаФорма), 
			НСтр("ru = 'Начать тестированое?'", "ru"), РежимДиалогаВопрос.ДаНет, 15 );
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОткрытьИнструкцию(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ПолноеИмяФайла = "";
		
		СохранитьИнструкциюНаДискеСервер(КаталогВременныхФайлов,ТекущиеДанные.ВидАттестации, ПолноеИмяФайла); 
		
		Если ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
			ЗапуститьПриложение(ПолноеИмяФайла);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьПротокол(Команда)
	
	НапечататьПротоколКлиент();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещений

&НаКлиенте
Процедура НачатьТестированиеВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОбработатьВыборЗначения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнениеПараметровформы()
	
	Параметры.Свойство("Сотрудник", Сотрудник);
	Параметры.Свойство("Организация", Организация);
	
	КаталогВременныхФайлов = Аттестация.ПолучитьКаталогВременныхФайлов(); 
	
	Список.Параметры.УстановитьЗначениеПараметра("Сотрудник", Сотрудник); 
	Список.Параметры.УстановитьЗначениеПараметра("Организация", Организация);  
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДата());  

КонецПроцедуры

&НаСервере
Процедура СохранитьИнструкциюНаДискеСервер(КаталогВременныхФайлов, ВидАттестации, ПолноеИмяФайла);
	
	ПолноеИмяФайла = Строка(КаталогВременныхФайлов) + "\" + Этаформа.УникальныйИдентификатор + "\" +
	Строка(Новый УникальныйИдентификатор) + ".doc";
	
	ЭлементОбъект = РеквизитФормыВЗначение("Объект");
	
	Аттестация.СохранитьФайлНаДискеИзХранилищаСервер(ВидАттестации.Инструкция, ПолноеИмяФайла, ВидАттестации);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборЗначения()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено тогда
		Закрыть(ТекущиеДанные.ВидАттестации);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Функция ПроверитьВозможностьПрохожденияТестирования()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Отказ = Ложь;
	
	Если ТекущиеДанные <> Неопределено Тогда 
		Если НЕ ТекущиеДанные.Доступна И ТекущиеДанные.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Нет") Тогда 
			ПоказатьПредупреждение(, "Текущая аттестация уже пройдена!"); 
			Отказ = Истина;
		ИначеЕсли НЕ ТекущиеДанные.Доступна Тогда 
			ПоказатьПредупреждение(,СтрЗаменить(СтрЗаменить("Текущая аттестация будет доступна с НачалоПериода по КонецПериода", "НачалоПериода", 
						Формат(ТекущиеДанные.ДатаНачалаДействия, "ДФ=dd.MM.yyyy")),"КонецПериода", Формат(ТекущиеДанные.ПлановаяДата, "ДФ=dd.MM.yyyy"))); 
			Отказ = Истина;
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(,"Выберите аттестацию для прохождения тестирования!");
	КонецЕсли;
	
	Возврат Отказ;  
	
КонецФункции

&НаКлиенте
Процедура УдалитьВременныеФайлыКлиент(ВременныйКаталог)
	
	Попытка
		УдалитьФайлы(ВременныйКаталог);
	Исключение
	КонецПопытки
	
КонецПроцедуры // УдалитьВременныеФайлыHTMLКлиент()

&НаКлиенте
Процедура НапечататьПротоколКлиент()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда 
		
		НапечататьПротоколАттестации(Новый Структура("Организация, ВидАттестации, ФизЛицо, Период", 
				ТекущиеДанные.Организация, ТекущиеДанные.ВидАттестации, Сотрудник, ТекущаяДата()));
		
		Если ТабДок.Области.Количество()> 0 Тогда
			ОткрытьФорму("ОбщаяФорма.ФормаПечати", Новый Структура("ТабДок", ТабДок));
		Иначе
			ПоказатьПредупреждение(,СтрЗаменить("Сотрудник ФизЛицо еще не проходил текущую аттестацию! Печать протокола невозможна!","ФизЛицо", Сотрудник));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НапечататьПротоколАттестации(СтруктураПараметров)
	
	РегистрыСведений.ИтогиПрохожденияАттестацииСотрудников.НапечататьПротоколАттестации(СтруктураПараметров, ТабДок);
	
КонецПроцедуры

#КонецОбласти




