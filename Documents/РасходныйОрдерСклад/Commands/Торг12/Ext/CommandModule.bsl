﻿
&НаСервере
Функция ПолучитьПризкакПроведенности(СсылкаНаОбъект)
	
	Возврат СсылкаНаОбъект.Проведен;
	
КонецФункции

&НаСервере
Функция ПолучитьВидОперации(СсылкаНаОбъект)
	
	Возврат СсылкаНаОбъект.ВидОперации;
	
КонецФункции

&НаСервере
Функция ПолучитьОрганизацию(СсылкаНаОбъект)
	
	Возврат СсылкаНаОбъект.Организация;
	
КонецФункции

&НаСервере
Функция ПечатьТорг12(ПараметрКоманды, МассивОшибок)
	//+++АК BELN 2018.11.06 ИП-00019252 
	УстановитьПривилегированныйРежим(Истина);
	Если НЕ Документы.РасходныйОрдерСклад.ДоступнаПечать() Тогда
		Сообщить("Нет права на печать");
		Возврат Неопределено;
	КонецЕсли; 
	//---АК BELN 2018.11.06	
	Возврат Документы.РасходныйОрдерСклад.ПечатьТорг12(ПараметрКоманды, МассивОшибок);
	
КонецФункции

&НаСервере
Функция ПечатьТОРГ12_ДляТочки(ПараметрКоманды)
	//+++АК BELN 2018.11.06 ИП-00019252 
	УстановитьПривилегированныйРежим(Истина);
	Если НЕ Документы.РасходныйОрдерСклад.ДоступнаПечать() Тогда
		Сообщить("Нет права на печать");
		Возврат Неопределено;
	КонецЕсли; 
	//---АК BELN 2018.11.06	
	//+++АК SHEP 2018.10.04 ИП-00020060
	Если ОбщегоНазначенияКлиентСервер.ЭтоСторонняяРозница(ПараметрКоманды.Получатель) Тогда
		мсДоки = Новый Массив;
		мсДоки.Добавить(ПараметрКоманды.Ссылка);
		ОбщиеПроцедуры.ОбновитьРТУПоОрдерам(мсДоки);
	КонецЕСли;
	//---АК SHEP 2018.10.04
	
	Возврат Документы.РасходныйОрдерСклад.ПечатьТОРГ12_ДляТочки(ПараметрКоманды)
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если НЕ ПолучитьПризкакПроведенности(ПараметрКоманды) Тогда
		ОбщегоНазначения.СообщитьИнформациюПользователю("Документ не проведен! Для печати необходимо провести документ!");
		Возврат;
	КонецЕсли;
	
	ВидОперации = ПолучитьВидОперации(ПараметрКоманды);
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСкладскойУчет.ОтгрузкаВТорговуюТочку")Тогда
		
		ТабДок = ПечатьТОРГ12_ДляТочки(ПараметрКоманды);
		
		ТабДок.ОтображатьСетку 		= Ложь;
		//ТабДок.Защита 			= Истина;
		ТабДок.ТолькоПросмотр 		= Истина;
		ТабДок.ОтображатьЗаголовки 	= Ложь;
		ТабДок.Показать();
		
	Иначе
		
		Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСкладскойУчет.Реализация")
				ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСкладскойУчет.ВозвратПоставщику") 
				//+++АК BELN 2018.07.31 ИП-00019402      
				ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСкладскойУчет.УтилизацияБой") 
				ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСкладскойУчет.Утилизация") 
				ИЛИ ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСкладскойУчет.СписаниеОтходовОтПереработки") 
				//---АК BELN 2018.07.31 
				
				Тогда
			
			Если НЕ ЗначениеЗаполнено(ПолучитьОрганизацию(ПараметрКоманды)) Тогда
				ОбщегоНазначения.СообщитьИнформациюПользователю("Печать не возможна! Не заполнено поле ""Организация""!");
				Возврат;
			КонецЕсли;
			
			МассивОшибок = Новый Массив;
			
			ТабДок = ПечатьТорг12(ПараметрКоманды, МассивОшибок);
			
			Если ТабДок <> Неопределено Тогда
				
				ТабДок.ОтображатьСетку 		= Ложь;
				//ТабДок.Защита 			= Истина;
				ТабДок.ТолькоПросмотр 		= Истина;
				ТабДок.ОтображатьЗаголовки 	= Ложь;
				ТабДок.Показать();
				
			КонецЕсли;
			
			Если МассивОшибок.Количество()>0 Тогда
				
				Для Каждого СтрокаМассива Из МассивОшибок Цикл
					ОбщегоНазначения.СообщитьИнформациюПользователю(СтрокаМассива);
				КонецЦикла;
				
			КонецЕсли;
			
		Иначе
			ОбщегоНазначения.СообщитьИнформациюПользователю("Печать Торг-12 возможна только для вида операции ""Реализация""
				//+++АК BELN 2018.07.31 ИП-00019402      
			|или ""Возврат поставщику"" или ""Утилизация (бой)""  или ""Утилизация (технологом)"" или ""Списание отходов от переработки""");
				//---АК BELN 2018.07.31 
		КонецЕсли;
		
		
	КонецЕсли;

КонецПроцедуры

