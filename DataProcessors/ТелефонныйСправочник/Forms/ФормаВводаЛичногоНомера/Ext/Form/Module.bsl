﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ФизЛицо",ФизЛицо);
	Параметры.Свойство("Номер",Номер);
	
	Если Не ЗначениеЗаполнено(Номер) И ЗначениеЗаполнено(ФизЛицо) Тогда 
		Номер = ВернутьЛичныйНомер(ФизЛицо);
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ЗафиксироватьНаСервере()
	
	Менеджер = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
	Менеджер.Объект = ФизЛицо;
	Менеджер.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонФизЛица;
	Менеджер.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
	Менеджер.Представление = Номер;
	Менеджер.Записать();
	
	
КонецПроцедуры

&НаКлиенте
Процедура Зафиксировать(Команда)
	
	Если Не ЗначениеЗаполнено(ФизЛицо) 
		ИЛИ Не ЗначениеЗаполнено(Номер) Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не указано физ лицо или номер телефона";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	Если СтрДлина(СтрЗаменить(Номер," ","")) < 11 Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Номер указан некорректно, в строке номер должно быть 11 символов, только числа";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;	
	
	ЗафиксироватьНаСервере();
	
	ОповеститьОВыборе("ЗафиксироватьЛичныйНомер");
	
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ФизЛицо) Тогда 
		Номер = ВернутьЛичныйНомер(ФизЛицо);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВернутьЛичныйНомер(ФизЛицо)

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтактнаяИнформация.Представление
		|ИЗ
		|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Объект = &ФизЛицо
		|	И КонтактнаяИнформация.Тип = &Тип
		|	И КонтактнаяИнформация.Вид = &Вид";
	
	Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.ТелефонФизЛица);
	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.Телефон);
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда 
		Возврат ВыборкаДетальныеЗаписи.Представление;
	Иначе 
		Возврат "";
	КонецЕсли;
	
КонецФункции

