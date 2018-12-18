﻿
Перем ИсторияИзмененияРеквизитов; //+++АК SHEP 2018.12.19 ИП-00018753.05: сохраняем историю изменения реквизитов

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	Поставщик = ПараметрыСеанса.ТекущийКонтрагент;
	ЗаполнитьКонтактыДляЗаказа();
	УстановитьПривилегированныйРежим(Ложь);
	
	Статус = Перечисления.СтатусыКарточекТовараПоставщиков.ВРаботе;
	
КонецПроцедуры

Процедура ЗаполнитьКонтактыДляЗаказа() Экспорт
	
	Справочники.ХарактеристикиНоменклатурыПоставщиков.ЗаполнитьКонтактыДляЗаказаПоставщика(Поставщик, ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Статус = Перечисления.СтатусыКарточекТовараПоставщиков.ВРаботе;
	ХарактеристикаНоменклатуры = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	//+++АК SHEP 2018.12.19 ИП-00018753.05: сохраняем историю изменения реквизитов
	ИсторияИзмененияРеквизитов = РегистрыСведений.ИсторияИзмененияРеквизитовЛКПоставщика.ЗаполнитьДанныеДляИстории(ЭтотОбъект, "Статус");
	//---АК SHEP 2018.12.19
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//+++АК SHEP 2018.12.19 ИП-00018753.05: сохраняем историю изменения реквизитов
	Если ИсторияИзмененияРеквизитов.Количество() > 0 Тогда
		РегистрыСведений.ИсторияИзмененияРеквизитовЛКПоставщика.ЗаписатьИсторию(Ссылка, ИсторияИзмененияРеквизитов);
	КонецЕсли;
	//---АК SHEP 2018.12.19
	
КонецПроцедуры
