﻿
&НаКлиенте
Процедура АутентификацияWindowsПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	ФлагВидимости = НЕ Объект.АутентификацияWindows;
	
	Элементы.ЛогинSQL.Видимость = ФлагВидимости;
	Элементы.ПарольSQL.Видимость = ФлагВидимости;
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьТаблицуХраненияЗначенийАпдекса(Команда)
	Флаг = СоздатьТаблицуХраненияЗначенийАпдексаСервер();
	
	Если Флаг Тогда
		Сообщить("Таблица хранения данных для офлайн мониторинга успешно создана (пересоздана)!");
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция СоздатьТаблицуХраненияЗначенийАпдексаСервер()
	
	
	 Возврат APDEX_Мониторинг.СоздатьТаблицуХраненияЗначенийАпдексаСервер(Объект);
	
КонецФункции
