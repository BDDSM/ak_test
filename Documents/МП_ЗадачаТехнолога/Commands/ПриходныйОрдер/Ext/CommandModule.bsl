﻿
Функция ПолучитьПризнакПроведенности(СсылкаНаОбъект)
	
	Возврат СсылкаНаОбъект.Проведен;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если НЕ ПолучитьПризнакПроведенности(ПараметрКоманды) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Документ не проведён! Для печати необходимо провести документ!");
		Возврат;
	КонецЕсли;
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.МП_ЗадачаТехнолога",
		"ПриходныйОрдерСклад",
		ПараметрКоманды,
		Неопределено,
		Новый Структура("Тип", "МП_ЗадачаТехнолога"));

	////
	//ТабДок = Печать(ПараметрКоманды);
	//Если ТабДок <> Неопределено Тогда
	//	ТабДок.ОтображатьСетку 		= Ложь;
	//	ТабДок.Защита 				= Истина;
	//	ТабДок.ТолькоПросмотр 		= Истина;
	//	ТабДок.ОтображатьЗаголовки 	= Ложь;
	//	ТабДок.Показать();
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция Печать(ПараметрКоманды)
	
	НаПринтер = Ложь;
	КоличествоЭкземпляров = 1;
	НепосредственнаяПечать = Ложь;
	
	//+++VERN
	Ордер=Документы.МП_ЗадачаТехнолога.ПолучитьОрдерНаВозврат(ПараметрКоманды);
	Если ЗначениеЗаполнено(Ордер) тогда
		ТабДокумент = Документы.ПриходныйОрдерСклад.Печать(Ордер);
		УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(Ордер, ""), НепосредственнаяПечать);
		Возврат Неопределено;
		
	иначе
		ТабДокумент = Новый ТабличныйДокумент;
	КонецЕсли;
	//---VERN
	
	Возврат ТабДокумент;
	
КонецФункции
