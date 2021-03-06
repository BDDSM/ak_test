﻿//+++АК LAGP 2017.12.06 ИП-00017389
Процедура ПередЗаписью(Отказ, Замещение)
	
	ПолныеПраваНаДоговораАренды = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.ПолныйДоступКДоговорамАренды, Ложь);
	ПолныеПраваКромеАренды = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.ПолныйДоступКДоговорамКромеАренды, Ложь);
	КонтрагентЯвляетсяАрендодателем = ЭтотОбъект.Отбор.Контрагент.Значение.ЯвляетсяАрендодателем;
	
	Если РольДоступна("УчетДоговоров") ИЛИ РольДоступна("ПолныеПрава") Тогда
		Если НЕ ((ПолныеПраваНаДоговораАренды И КонтрагентЯвляетсяАрендодателем)
				ИЛИ (ПолныеПраваКромеАренды И НЕ КонтрагентЯвляетсяАрендодателем)  
				ИЛИ РольДоступна("ПолныеПрава")) Тогда
			Отказ = Истина;
			Сообщить("Нет прав на изменение данного типа договоров.");
		КонецЕсли;
	Иначе
		Отказ = Истина;
		Сообщить("Нет прав работы с договорами.");	
	КонецЕсли;
	
КонецПроцедуры
