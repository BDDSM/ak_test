﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ИзменениеЗакупочныхЦен") Тогда
		ОтправитьЗапросРуководителюНаИзменениеЦенСервер(ПараметрКоманды);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтправитьЗапросРуководителюНаИзменениеЦенСервер(СсылкаНаДокумент)
	
    НаборЗаписей = РегистрыСведений.ОчередьДокументовДляОтправки.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(СсылкаНаДокумент);
	
	НаборЗаписей.Прочитать();
	
	Для каждого ЗаписьНабора Из НаборЗаписей Цикл
		Документы.ИзменениеЗакупочныхЦен.ОтправитьЗапросРуководителюНаИзменениеЦен(ЗначениеИзСтрокиВнутр(ЗаписьНабора.СтруктураПараметровСтрока));
	КонецЦикла;

КонецПроцедуры

#КонецОбласти



