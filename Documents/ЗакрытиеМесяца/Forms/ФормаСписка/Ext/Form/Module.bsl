﻿
&НаКлиенте
Процедура ВыполнитьПересчетСебестоимостиИЗакрытиеМесяца(Команда)
	
	МесяцЗакрытия = НачалоМесяца(ТекущаяДата());
	Если ВвестиДату(МесяцЗакрытия, "Введите дату начала месяца расчета", ЧастиДаты.Дата) Тогда
		ДатаЗапрета = НастройкаПравДоступа.ПолучитьОбщуюДатуЗапретаДляПользователя();
		Если ДатаЗапрета >= МесяцЗакрытия Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Редактирование данных этого периода запрещено. Изменения не могут быть записаны...";
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;	
		РегламентныеЗаданияСервер.ПересчитатьСебестоимостьВПроводках(НачалоМесяца(МесяцЗакрытия));
	КонецЕсли;	
	
КонецПроцедуры

//+++АК Susk (Суслин К.В.) 2018.12.13 ЗМ
&НаСервереБезКонтекста
Процедура ВыгрузитьПроводкиПо10_6_В_БухгалтериюНаСервере()
	
	РегламентныеЗаданияСервер.ВыгрузитьПроводкиПо10_6_В_Бухгалтерию();
	
КонецПроцедуры

//+++АК Susk (Суслин К.В.) 2018.12.13 ЗМ
&НаКлиенте
Процедура ВыгрузитьПроводкиПо10_6_В_Бухгалтерию(Команда)
	ВыгрузитьПроводкиПо10_6_В_БухгалтериюНаСервере();
КонецПроцедуры

#Область Памятка_Разработчику
//+++AK sole 2018.04.05 

// При добавлении нового вида закрытия, для отображения 
// его текстового описания в форме списка необходимо
// в свойствах "ФормыСписка" и "ФормыВыбора" 
// открыть "Условное оформление" и добавить новое условие 
// для нового вида закрытия!


// ХэшТеги ;)
// #Основные движения(0)
// #Списание погрешностей расчета себестоимости(1)
// #Списание минусов склада и рекламных материалов на ТТ(2)
// #Движения по комплектам(3)
// #Списание остатков по закрытым ТТ(4)
// #Распределение деб. задолженности(5)
// #Расхождение склад/ТТ(6)
// #Расхождение склад/склад(7)
// #Расхождение ТТ/ТТ(8)
// #Закрытие 97 счёта (РБП)(9)
// #Списание погрешностей расчета себестоимости материалов(10)
// #Перепродажа между Вкусвилл и Луг да Поле(11)
// #Амортизация НМА(12)
// #Начисление НДС листов учета(13)
// #Распределение остатков прочих складов магазинов(14)

//---AK sole 2018.04.05
#КонецОбласти