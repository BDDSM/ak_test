﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
		
	ТТПоАйпи = ПолучитьТТПоАйпи();
	НомерТочки = ПолучитьНомерТочкиПоТТ(ТТПоАйпи);
	
	Если НЕ ЗначениеЗаполнено(ТТПоАйпи) ИЛИ НомерТочки = 999 Тогда
		ОткрытьФорму("Документ.СообщениеМОС.Форма.ФормаСпискаЦО",,, "СЩ_СписокЦО", ПараметрыВыполненияКоманды.Окно);
	Иначе
		Магазины_Клиент.УправлениеОкнамиМагазинов("Сообщения");
		Если ОбщегоНазначения.ЭтоКопияБазы() Тогда
			ОткрытьФорму("Документ.СообщениеМОС.Форма.ФормаСпискаМагазина4",,, "СЩ_РабочийСтол", ПараметрыВыполненияКоманды.Окно);
		Иначе
			ОткрытьФорму("Документ.СообщениеМОС.Форма.ФормаСпискаМагазина4",,, "СЩ_РабочийСтол", ПараметрыВыполненияКоманды.Окно);
		КонецЕсли;
	КонецЕсли;
	//+++АК mika 2018.08.09 ИП-00019475 "Статистика использования(Удалить)"↓
	ОбщегоНазначенияСервер.СтатистикаИспользованияПодсистемДобавитьЗапись(Новый Структура("Подсистема, ИмяОбъекта, ИмяФормы, ИмяЭлемента, ДопИнформация", 
			"Магазины", "ОбщаяКоманда.Сообщения" , , ,"ОткрытьФорму(Документ.СообщениеМОС.Форма.ФормаСпискаМагазина4)")); 
	//---АК mika		
КонецПроцедуры

Функция ПолучитьТТПоАйпи()

	Возврат ПараметрыСеанса.ТорговаяТочкаПоАйпи;

КонецФункции // ()

Функция ПолучитьНомерТочкиПоТТ(ТТ)

	Возврат ТТ.НомерТочки;

КонецФункции // ()

