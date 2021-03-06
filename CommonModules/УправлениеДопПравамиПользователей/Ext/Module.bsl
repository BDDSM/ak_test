﻿////////////////////////////////////////////////////////////////////////////////
//
// Проверка дополнительных прав выполняется путем вызова функции, относящейся к этому праву.
// Для нового дополнительного права должна быть создана отдельная функция.
//
////////////////////////////////////////////////////////////////////////////////

// Функция возвращает значение, которое означает, что право разрешено
//
Функция ПолучитьЗначениеРазрешенногоПрава(Право)
	
	Результат = Истина;

	Возврат Результат;

КонецФункции

// Функция возвращает список значений права, установленных для пользователя или группы пользователя.
// Если нет установленных прав , то возвращается значение по умолчанию
//
// Параметры:
//  Право               - право, для которого определяются значения
//  ЗначениеПоУмолчанию - значение по умолчанию для передаваемого права (возвращается в случае
//                        отсутствия значений в регистре сведений)
//  Пользователь		- пользователь
//
// Возвращаемое значение:
//  Список всех значений, установленных для пользователя или группы пользователя
//
Функция ПрочитатьЗначениеПраваПользователя(Право, ЗначениеПоУмолчанию, Пользователь) Экспорт
	
	ВозвращаемыеЗначения = Новый Массив;
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь"     , Пользователь);
	Запрос.УстановитьПараметр("ПравоПользователя", Право);

	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	РегистрЗначениеПрав.Значение
	|ИЗ
	|	РегистрСведений.ЗначенияДополнительныхПравПользователя КАК РегистрЗначениеПрав
	|ГДЕ
	|	РегистрЗначениеПрав.Право = &ПравоПользователя
	|	И РегистрЗначениеПрав.Пользователь В
	|			(ВЫБРАТЬ
	|				ПользователиГруппы.Ссылка КАК Ссылка
	|			ИЗ
	|				Справочник.ГруппыПользователей.ПользователиГруппы КАК ПользователиГруппы
	|			ГДЕ
	|				ПользователиГруппы.Пользователь = &Пользователь
	|		
	|			ОБЪЕДИНИТЬ ВСЕ
	|		
	|			ВЫБРАТЬ
	|				ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи)
	|		
	|			ОБЪЕДИНИТЬ ВСЕ
	|		
	|			ВЫБРАТЬ
	|				&Пользователь)";
	
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Количество() = 0 Тогда
		ВозвращаемыеЗначения.Добавить(ЗначениеПоУмолчанию);
	Иначе
		Пока Выборка.Следующий() Цикл
			ВозвращаемыеЗначения.Добавить(Выборка.Значение);
		КонецЦикла;
	КонецЕсли;

	Возврат ВозвращаемыеЗначения;

КонецФункции

// Функция возвращает значение дополнительного права профиля пользователя
//
//	Параметры:
//  	Право               - право, наличие которого проверяется (Тип ПВХ.ПраваПользователей)
//  	ЗначениеПоУмолчанию - значение по умолчанию для передаваемого права (возвращается в случае
//                        	отсутствия значений в регистре сведений). Тип - булево
//
//	Возвращаемое значение: массив значений права
//
Функция ПолучитьЗначениеПраваПользователя(Право, ЗначениеПоУмолчанию) Экспорт
	
	КэшДополнительныхПрав = глЗначениеПеременной("ЗначенияДополнительныхПравПользователя");
	
	МассивЗначенийПрава = КэшДополнительныхПрав[Право];
	
	Если МассивЗначенийПрава = Неопределено Тогда
		МассивЗначенийПрава = Новый Массив;
		
		Если РольДоступна("ПолныеПрава") Тогда
			ЗначениеПрава = ПолучитьЗначениеРазрешенногоПрава(Право);
			МассивЗначенийПрава.Добавить(ЗначениеПрава);
		Иначе
			ОбъектПрав = глЗначениеПеременной("ПрофильПолномочийПользователя");
			Если ЗначениеЗаполнено(ОбъектПрав) Тогда
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("ОбъектПрав"			, ОбъектПрав);
				Запрос.УстановитьПараметр("ПравоПользователя"	, Право);
				
				Запрос.Текст =
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	РегистрЗначениеПрав.Значение КАК Значение
				|ИЗ
				|	РегистрСведений.ЗначенияДополнительныхПравПользователя КАК РегистрЗначениеПрав
				|ГДЕ
				|	РегистрЗначениеПрав.Право = &ПравоПользователя
				|	И РегистрЗначениеПрав.Пользователь = &ОбъектПрав";
				
				Выборка = Запрос.Выполнить().Выбрать();
				
				Если Выборка.Следующий() Тогда
					ЗначениеПрава = Выборка.Значение;
				Иначе
					ЗначениеПрава = ЗначениеПоУмолчанию;
				КонецЕсли;
				МассивЗначенийПрава.Добавить(ЗначениеПрава);
			Иначе
				ТекущийПользователь = глЗначениеПеременной("глТекущийПользователь");	
				МассивЗначенийПрава = ПрочитатьЗначениеПраваПользователя(Право, ЗначениеПоУмолчанию, ТекущийПользователь);
			КонецЕсли;
		КонецЕсли; 
		
		КэшДополнительныхПрав[Право] = МассивЗначенийПрава;
		
		#Если Сервер Тогда
			глЗначениеПеременнойУстановить("ЗначенияДополнительныхПравПользователя", КэшДополнительныхПрав, Истина);
		#КонецЕсли
	КонецЕсли;
	
	Возврат МассивЗначенийПрава;
	
КонецФункции

//Функция проверяет наличие дополнительного права пользователя
//Функция предназначена для работы с дополнительными правами, имеющими значение типа Булево
//Параметры:
//  Право               - право, наличие которого проверяется (Тип ПВХ.ПраваПользователей)
//  ЗначениеПоУмолчанию - значение по умолчанию для передаваемого права (возвращается в случае
//                        отсутствия значений в регистре сведений). Тип - булево
//Возвращаемое значение: Булево (Истина, если право у пользователя есть)
Функция ПравоЕстьУПользователя(Право, ЗначениеПоУмолчанию)
	
	МассивЗначенийПрава = ПолучитьЗначениеПраваПользователя(Право, ЗначениеПоУмолчанию);
	
	Возврат МассивЗначенийПрава.Найти(Истина) <> Неопределено;
	
КонецФункции

// Функция возвращает право печатать непроведенные документы.
//
// Параметры:
//  Проведен     - признак проведен ли документ (если документ не проводной,
//                 то либо параметр опускается, либо равен Истина)
//
// Возвращаемое значение:
//  Истина - если можно печатать, иначе Ложь.
//
Функция РазрешитьПечатьНепроведенныхДокументов(Проведен = Истина) Экспорт

	Если Проведен Тогда
		Возврат Истина;
	КонецЕсли;

	Возврат ПравоЕстьУПользователя(ПланыВидовХарактеристик.ПраваПользователей.ПечатьНепроведенныхДокументов, Ложь);
	
КонецФункции

// Функция возвращает признак защищать таблицу от редактирования или нет.
//
// Возвращаемое значение:
//  Истина - если таблицу необходимо защитить от редактирования, иначе Ложь.
//
Функция ЗащитаТаблиц() Экспорт
	
	Возврат НЕ ПравоЕстьУПользователя(ПланыВидовХарактеристик.ПраваПользователей.РедактированиеТаблиц, Ложь);

КонецФункции

 // Функция возвращает право редактировать КИ в списке
//
// Параметры:
//  Нет
//
// Возвращаемое значение:
//  Истина - если можно редактировать КИ в списке
//
Функция РазрешитьРедактированиеКИвСписке() Экспорт

	Возврат ПравоЕстьУПользователя(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьРедактированиеКИвСписке, Ложь);

КонецФункции

// Функция возвращает нужно ли рассчитывать долг при открытии форм.
//
// Параметры:
//  нет.
//
// Возвращаемое значение:
//  Истина - если нужно рассчитывать, иначе Ложь.
//
Функция РассчитыватьДолгПриОткрытииФорм() Экспорт

	Возврат ПравоЕстьУПользователя(ПланыВидовХарактеристик.ПраваПользователей.РассчитыватьДолгПриОткрытииФорм, Истина);

КонецФункции

// Функция возвращает признак, разрешено ли проведение без контроля взаиморсчетов
//
Функция ПравоРазрешитьПроведениеБезКонтроляВзаиморасчетов() Экспорт
	
	ЗначениеПрава = ПравоЕстьУПользователя(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьПроведениеБезКонтроляВзаиморасчетов, Истина);
	
	Возврат ЗначениеПрава;
	
КонецФункции

// Функция возвращает признак, разрешено ли проводить ППИ без заявки
//
Функция ПравоРазрешитьПроведениеПлатежаБезЗаявки() Экспорт

	ЗначениеПрава = ПравоЕстьУПользователя(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьПроведениеПлатежаБезЗаявки, Истина);
	
	Возврат ЗначениеПрава;

КонецФункции

// Функция возвращает признак разрешено ли превышать свободный остаток денежных средств
//
Функция ПравоРазрешитьПревышениеСвободногоОстаткаДС() Экспорт

	ЗначениеПрава = ПравоЕстьУПользователя(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьПревышениеСвободногоОстаткаДС, Истина);
	
	Возврат ЗначениеПрава;

КонецФункции

Функция ПолучитьПравоПользователяУпр(Право, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	//
	УстановитьПривилегированныйРежим(Истина);
	
	//
	ЗначениеПрава = Неопределено;
	
	//
	КэшПрава = Новый Соответствие;
	
	//
	Если НЕ РаботаСОбщимиПеременными.ПолучитьИзКэшаКонфигурации("КэшПрава", КэшПрава, Неопределено, Истина) Тогда
		
		//
		КэшПрава = Новый Соответствие;
		
		//
		РаботаСОбщимиПеременными.УстановитьЗначениеПеременной("КэшПрава", КэшПрава);
		
	Иначе
		
		//
		Попытка
			
			//
			ЗначениеПрава = КэшПрава.Получить(Право);
			Если ЗначениеПрава <> Неопределено Тогда
				Возврат ЗначениеПрава;
			КонецЕсли;	
			
		Исключение
		КонецПопытки;	
		
	КонецЕсли;
	
	
	//Если РольДоступна("ПолныеПрава") Тогда
	//	Возврат;
	//КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбъектПрав"			, ПараметрыСеанса.ТекущийПользователь);
	Запрос.УстановитьПараметр("ПравоПользователя"	, Право);
	
	Если ЗначениеЗаполнено(ПараметрыСеанса.ТекущийПользователь.ПрофильПолномочийПользователя) Тогда
		Запрос.УстановитьПараметр("ОбъектПрав"		, ПараметрыСеанса.ТекущийПользователь.ПрофильПолномочийПользователя);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РегистрЗначениеПрав.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.ЗначенияДополнительныхПравПользователя КАК РегистрЗначениеПрав
		|ГДЕ
		|	РегистрЗначениеПрав.Право = &ПравоПользователя
		|	И РегистрЗначениеПрав.Пользователь = &ОбъектПрав";
	Иначе	
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РегистрЗначениеПрав.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.ЗначенияДополнительныхПравПользователя КАК РегистрЗначениеПрав
		|ГДЕ
		|	РегистрЗначениеПрав.Право = &ПравоПользователя
		|	И РегистрЗначениеПрав.Пользователь = &ОбъектПрав";
	КонецЕсли;	
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		//
		ЗначениеПрава = Выборка.Значение;
		
		//
		КэшПрава.Вставить(Право, ЗначениеПрава);
		
		//
		РаботаСОбщимиПеременными.УстановитьЗначениеПеременной("КэшПрава", КэшПрава);
		
	Иначе
		ЗначениеПрава = ЗначениеПоУмолчанию;
	КонецЕсли;
	
	//
	Возврат ЗначениеПрава;
	
КонецФункции	

// Возвращает наличие прав для администрирования пользователей
//
Функция ЕстьПравоАдминистрированияПользователей(ПользовательИБ = Неопределено) Экспорт
	
	Если ПользовательИБ = Неопределено Тогда
		ЕстьПраво = (РольДоступна("ПолныеПрава") 
						ИЛИ РольДоступна("АдминистраторПользователей") 
						ИЛИ РольДоступна("РедактированиеПользователей"));
	Иначе
		ЕстьПраво = (ПользовательИБ.Роли.Содержит(Метаданные.Роли.ПолныеПрава)
						ИЛИ ПользовательИБ.Роли.Содержит(Метаданные.Роли.АдминистраторПользователей)
						ИЛИ ПользовательИБ.Роли.Содержит(Метаданные.Роли.РедактированиеПользователей));
	КонецЕсли; 
	
	Возврат ЕстьПраво;

КонецФункции

// Возвращает наличие прав для редактирования служебного телефона физ. лица
//
Функция РазрешитьРедактированиеСлужебногоТелефонаФизЛица()Экспорт
	
	ТекущийПользователь = глЗначениеПеременной("глТекущийПользователь");
	МассивЗначенийПрава = ПрочитатьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьРедактированиеСлужебногоТелефонаФизЛица, Ложь, ТекущийПользователь);
	
	Возврат МассивЗначенийПрава.Найти(Истина) <> Неопределено;
	
КонецФункции

#Если Клиент Тогда
	
// Копирует значения доп.прав
//
// Параметры:
//		ТаблицаДопПрав	- <Таблица значений>, колонки "Право", "Значение". 
//						Содержит доп.права, которые нужно скопировать
//		СписокПрофилей	- <Массив>, содержит ссылки на профили для которых нужно скопировать доп.права
//
Процедура КопироватьДополнительныеПрава(ТаблицаДопПрав, СписокПрофилей) Экспорт

	Если ТаблицаДопПрав.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ПрофильСсылка Из СписокПрофилей Цикл
		                            
		Если ПрофильСсылка.ЭтоГруппа Тогда			
			Продолжить;
		КонецЕсли;
		
		ЕстьПолныеПрава = ПрофильСсылка.СоставРолей.Найти("ПолныеПрава", "ИмяРоли") <> Неопределено;
		Если ЕстьПолныеПрава Тогда
			ОбщегоНазначения.Сообщение("Профиль содержит роль ""Полные права"". Доп.права не скопированы. "+ ПрофильСсылка, Перечисления.ВидыСообщений.ВажнаяИнформация, "Копирование доп.прав", ПрофильСсылка);
			
			Продолжить;
		КонецЕсли; 
		
		Для каждого СтрокаТаблицыДопПрав Из ТаблицаДопПрав Цикл
			МенеджерЗаписиДопПрав = РегистрыСведений.ЗначенияДополнительныхПравПользователя.СоздатьМенеджерЗаписи();
			
			МенеджерЗаписиДопПрав.Пользователь = ПрофильСсылка;
			МенеджерЗаписиДопПрав.Право        = СтрокаТаблицыДопПрав.Право;
			МенеджерЗаписиДопПрав.Значение     = СтрокаТаблицыДопПрав.Значение;
			
			МенеджерЗаписиДопПрав.Записать();
		КонецЦикла; 
		
		ОбщегоНазначения.Сообщение("Выполнено копирование доп.прав для профиля: " + ПрофильСсылка, Перечисления.ВидыСообщений.Информация, "Копирование доп.прав", ПрофильСсылка);
	КонецЦикла; 
	
КонецПроцедуры //
 	
	
#КонецЕсли
