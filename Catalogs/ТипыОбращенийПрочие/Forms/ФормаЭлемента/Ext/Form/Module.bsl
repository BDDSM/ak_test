﻿
//+++АК SHEP 20160514
&НаКлиенте
Процедура ЗаполнитьОповещения(Команда)
	
	Если Объект.Оповещения.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект.Оповещения.Добавить(), Новый Структура("РольИсполнителя, Сообщения1С, ЭлПочта", ПредопределенноеЗначение("Справочник.РолиИсполнителей.Инициатор")			, Истина, Ложь));
	ЗаполнитьЗначенияСвойств(Объект.Оповещения.Добавить(), Новый Структура("РольИсполнителя, Сообщения1С, ЭлПочта", ПредопределенноеЗначение("Справочник.РолиИсполнителей.Исполнитель")			, Истина, Ложь));
	ЗаполнитьЗначенияСвойств(Объект.Оповещения.Добавить(), Новый Структура("РольИсполнителя, Сообщения1С, ЭлПочта", ПредопределенноеЗначение("Справочник.РолиИсполнителей.ПомощникУправляющего"), Ложь	, Ложь));
	ЗаполнитьЗначенияСвойств(Объект.Оповещения.Добавить(), Новый Структура("РольИсполнителя, Сообщения1С, ЭлПочта", ПредопределенноеЗначение("Справочник.РолиИсполнителей.Управляющий")			, Ложь	, Ложь));	
	
КонецПроцедуры
//---АК SHEP 20160514