﻿
Функция СрокДействияДоговора() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ВложенныйЗапросСрокиДействия.ДатаОкончанияДоговора) КАК ДатаОкончанияДоговора
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДополнительноеСоглашение.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|		МАКСИМУМ(ДополнительноеСоглашение.ДатаОкончанияДоговора) КАК ДатаОкончанияДоговора
	|	ИЗ
	|		Документ.ДополнительноеСоглашение КАК ДополнительноеСоглашение
	|	ГДЕ
	|		ДополнительноеСоглашение.ДоговорКонтрагента = &Договор
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ДополнительноеСоглашение.ДоговорКонтрагента
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗаключениеДоговораАренды.ДоговорКонтрагента,
	|		МАКСИМУМ(ЗаключениеДоговораАренды.ДатаОкончанияДоговора)
	|	ИЗ
	|		Документ.ЗаключениеДоговораАренды КАК ЗаключениеДоговораАренды
	|	ГДЕ
	|		ЗаключениеДоговораАренды.ДоговорКонтрагента = &Договор
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ЗаключениеДоговораАренды.ДоговорКонтрагента
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДоговорыКонтрагентов.Ссылка,
	|		ДоговорыКонтрагентов.СрокДействия
	|	ИЗ
	|		Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|	ГДЕ
	|		ДоговорыКонтрагентов.Ссылка = &Договор) КАК ВложенныйЗапросСрокиДействия";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Договор", ЭтотОбъект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ДатаОкончанияДоговора;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции	

Функция ПолучитьТорговыеТочкиДопСоглашения() Экспорт
	
	МассивТТ = Новый Массив;
	Если ЭтотОбъект.ЭтоНовый() Тогда
		Возврат МассивТТ;
	КонецЕсли;
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент"	, ЭтотОбъект.Владелец);
	Запрос.УстановитьПараметр("Договор"		, ЭтотОбъект.Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДополнительныеСоглашенияТорговыеТочки.ТорговаяТочка
	|ИЗ
	|	Справочник.ДополнительныеСоглашения.ТорговыеТочки КАК ДополнительныеСоглашенияТорговыеТочки
	|ГДЕ
	|	ДополнительныеСоглашенияТорговыеТочки.Ссылка.Владелец = &Контрагент
	|	И ДополнительныеСоглашенияТорговыеТочки.Ссылка.Договор = &Договор";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат МассивТТ;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ТорговаяТочка");
	
КонецФункции


Процедура ПередЗаписью(Отказ)
	//+++ak ziga ИП-00015987 2017111201
	Аренда=?(ТипДоговора=Перечисления.ТипыДоговоровСПоставщиком.Аренда,Истина,Ложь);	
	//НаименованиеДопПрава="Полный доступ к договорам аренды";	
	МассивПраваАренда=УправлениеДопПравамиПользователей.ПрочитатьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.ПолныйДоступКДоговорамАренды,Ложь,ПараметрыСеанса.ТекущийПользователь);	
	ПравоАренда=МассивПраваАренда[0];
	//НаименованиеДопПрава="Полный доступ к договорам, кроме аренды";	
	МассивПраваНеАренда=УправлениеДопПравамиПользователей.ПрочитатьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.ПолныйДоступКДоговорамКромеАренды,Ложь,ПараметрыСеанса.ТекущийПользователь);	
	ПравоНеАренда=МассивПраваНеАренда[0];

	Если не РольДоступна("ПолныеПрава") Тогда
		Если Аренда Тогда
			//ЭтаФорма.ТолькоПросмотр=Не ПравоАренда;
			Если Не ПравоАренда Тогда
			Сообщить("Нет прав на изменение договоров с типом Аренда");
			КонецЕсли;
		Отказ=Не ПравоАренда;
		Иначе
			//ЭтаФорма.ТолькоПросмотр=Не ПравоНеАренда;
			Если Не ПравоНеАренда Тогда 
			Сообщить("Нет прав на изменение договоров с типом не Аренда");
			КонецЕсли;
			Отказ=Не ПравоНеАренда;
		КонецЕсли;
		Если Не РольДоступна("УчетДоговоров") Тогда
			Если Не ПравоАренда и (Не ПравоНеАренда) Тогда
				//ЭтаФорма.ТолькоПросмотр=Истина;
				Отказ=Истина;
				Сообщить("Нет доп прав на изменение договоров");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	//---ak ziga ИП-00015987 2017111201

	Если ЭтотОбъект.ЭтоНовый()
			И (НЕ ЭтотОбъект.ЭтоГруппа)
			И ЭтотОбъект.МетодРасчетаНеполныхПериодов.Пустая() Тогда
		ЭтотОбъект.МетодРасчетаНеполныхПериодов = Перечисления.МетодыРасчетаНеполныхПериодов.ОкруглениеДоПолногоМесяца;
	КонецЕсли;
	
	//++++ АК AZAP 24.03.2017 ИП-00015381
	//если ставка ндс изменилась
	//Если ЭтотОбъект.СтавкаНДС <> Ссылка.СтавкаНДС Тогда
	//	Режим = РежимДиалогаВопрос.ДаНет;
	//	Текст = "ru = ""Установить основным этот договор с "+Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy")+" в регистре?"";";
	//	Ответ = Вопрос(НСтр(Текст), Режим, 0);
	//	Если Ответ = КодВозвратаДиалога.Нет Тогда
	//		Возврат;
	//	КонецЕсли;
	//КонецЕсли;
	//---- АК AZAP
	
	ПолныеПраваНаДоговораАренды = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.ПолныйДоступКДоговорамАренды, Ложь);
	ПолныеПраваКромеАренды = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.ПолныйДоступКДоговорамКромеАренды, Ложь);
	
	Если НЕ ((ПолныеПраваНаДоговораАренды
					И ЭтотОбъект.ТипДоговора = Перечисления.ТипыДоговоровСПоставщиком.Аренда)
				ИЛИ (НЕ ЭтотОбъект.ТипДоговора = Перечисления.ТипыДоговоровСПоставщиком.Аренда)
				ИЛИ РольДоступна("ПолныеПрава")) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЭтотОбъект.ЧислоОплатыАренды = 0 Тогда
		ЭтотОбъект.ЧислоОплатыАренды = 1;
	КонецЕсли;
	
	Если ЭтотОбъект.СрокОплатыАренды = 0 Тогда
		ЭтотОбъект.СрокОплатыАренды = 1;
	КонецЕсли;
	
	//++++ АК AZAP 24.03.2017 ИП-00015381
	//Отбор = Новый Структура;
	//Отбор.Вставить("Контрагент", ЭтотОбъект.Владелец);
	// ОснДоговор = РегистрыСведений.ОсновныеДоговораКонтрагентов.ПолучитьПоследнее(ТекущаяДата(), Отбор);
	////если это основной договор и ставка ндс не равна ставке контрагента
	//Если Ссылка = ОснДоговор.ДоговорКонтрагента И ЭтотОбъект.Владелец.СтавкаНДС <> ЭтотОбъект.СтавкаНДС Тогда
	//	КонтрагентОбъект = ЭтотОбъект.Владелец.ПолучитьОбъект();
	//	КонтрагентОбъект.СтавкаНДС = ЭтотОбъект.СтавкаНДС;
	//	КонтрагентОбъект.Записать();
	//КонецЕсли;
	//---- АК AZAP
	
КонецПроцедуры
