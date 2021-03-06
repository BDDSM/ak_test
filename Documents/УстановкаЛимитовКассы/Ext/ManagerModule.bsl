﻿функция разностьДат(датаОкончания, датаНачала) 
	возврат окр((началоДня(датаОкончания) - началоДня(датаНачала))/(24*60*60),0);
конецФункции

Функция Печать(документСсылка) Экспорт 
	
	
	табличныйДокумент = Новый ТабличныйДокумент;
	Макет = Документы.УстановкаЛимитовКассы.ПолучитьМакет("Распоряжение");
	ДокументОбъект = документСсылка.ПолучитьОбъект();
	лимитГруппыРазвития = константы.ЛимитГруппыРазвития.Получить();
	Попытка
	
		ДокументОбъект.Записать();
	
	Исключение
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить();
		
		Возврат табличныйДокумент;
	
	КонецПопытки;
	//---
	группаРазвитияОтработаноДней = 31;
	
	// Получение данных документа
	//---
	запрос = новый запрос;
	запрос.Текст =
	"ВЫБРАТЬ
	|	УстановкаЛимитовКассы.Ссылка,
	|	УстановкаЛимитовКассы.Организация,
	|	УстановкаЛимитовКассы.Дата,
	|	УстановкаЛимитовКассы.РасчетЛимитов.(
	|		Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		ВГруппеРазвития,
	|		Подразделение.Наименование КАК ПодразделениеНаименование,
	|		ДатаПриказа,
	|		ДатаПервогоОтчета,
	|		ОтработаноЗаМесяц,
	|		ОтработаноЗаКвартал,
	|		НаличныеЗаМесяц,
	|		НаличныеЗаКвартал,
	|		СреднийОборотЗаМесяц,
	|		СреднийОборотЗаКвартал,
	|		ЛимитЗаМесяц,
	|		ЛимитЗаКвартал,
	|		ЛимитИтоговый,
	|		ПериодИтоговый,
	|		КоличествоДнейМеждуИнкассациями,
	|		Печатать
	|	)
	|ИЗ
	|	Документ.УстановкаЛимитовКассы КАК УстановкаЛимитовКассы
	|ГДЕ
	|	УстановкаЛимитовКассы.Ссылка = &ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	запрос.УстановитьПараметр("ссылка", документСсылка);
	
	выборкаДокумент = запрос.Выполнить().Выбрать();
	если (не выборкаДокумент.следующий()) тогда
		возврат неопределено;
	конецЕсли;
	организация = выборкаДокумент.организация;
	датаДокумента = выборкаДокумент.дата;
	СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Организация, ДатаДокумента);
	//---
	организацияНаименование = ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование");
	организацияАдрес = ОписаниеОрганизации
	(
	СведенияОбОрганизации, 
	"ЮридическийАдрес,ИНН,КПП,КодПоОКПО,НомерСчета,Банк,БИК,КорСчет"
	);
	организацияАдрес = стрЗаменить(организацияАдрес, ", КПП", "/КПП");
	если (значениеЗаполнено(СведенияОбОрганизации.банк.город)) тогда
		организацияАдрес = стрЗаменить(организацияАдрес, ", БИК", " г." + сокрЛП(СведенияОбОрганизации.банк.город) + ", БИК");	
	конецЕсли;
	//---	
	РуководительФИО = ОбщегоНазначения.ФамилияИнициалыФизЛица(СокрЛП(Организация.ГенеральныйДиректор));
	РуководительДолжность = СокрЛП(Организация.должностьРуководителя);
	// Данные организации
	//---
	выборкаПодразделения = выборкаДокумент.РасчетЛимитов.выбрать();
	
	первый = истина;
		
	пока (выборкаПодразделения.следующий()) цикл
		
		Если выборкаПодразделения.Печатать = Ложь Тогда
		
			Продолжить;
		
		КонецЕсли;
		
		областьШапка = макет.ПолучитьОбласть("Шапка");
		//областьРасчетный = макет.ПолучитьОбласть("Расчетный");
		областьПрогнозируемый = макет.ПолучитьОбласть("Прогнозируемый");
		областьПодвал = макет.ПолучитьОбласть("Подвал");
		//---
		областьШапка.параметры.организацияНаименование = организацияНаименование;
		областьШапка.параметры.организацияАдрес = организацияАдрес;
		
		областьПодвал.параметры.руководительФИО = руководительФИО;
		областьПодвал.параметры.руководительДолжность = руководительДолжность;
		
		
		// Вывод листов по подразделениям
		//---
		лимит = выборкаПодразделения.лимитИтоговый;	
		валютаРубли = справочники.Валюты.НайтиПоКоду("643");
		
		//---
		областьШапка.Параметры.подразделениеНаименование = выборкаПодразделения.подразделениеНаименование;
		областьШапка.Параметры.датаПриказа = формат(выборкаПодразделения.датаПриказа, "ДФ='dd MMMM yyyy'") + " года";
		
		областьПодвал.Параметры.подразделениеНаименование = выборкаПодразделения.подразделениеНаименование;
		областьПодвал.Параметры.датаПриказа = формат(выборкаПодразделения.датаПриказа, "ДФ='dd MMMM yyyy'") + " года";        		
		//---
		ОкругленныйЛИмит = Цел(лимит)-лимит%10;
		лимитПрописью = числоПрописью(ОкругленныйЛИмит);//,"ДП = Истина","рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2");
		лимитПрописью = лев(лимитПрописью, стрДлина(лимитПрописью)-4);
		//областьШапка.параметры.лимитЧисло = строка(ОкругленныйЛИмит);
		областьШапка.параметры.лимитСтрока = строка(Цел(ОкругленныйЛИмит)) + " (" + лимитПрописью + ")"+" рублей";  
		
		областьШапка.Параметры.ПромежуточныйРезультат = Окр(?(выборкаПодразделения.ОтработаноЗаМесяц = 0,0
 		,выборкаПодразделения.НаличныеЗаМесяц/выборкаПодразделения.ОтработаноЗаМесяц),2);
		
		если (выборкаПодразделения.периодИтоговый = 0) тогда
			областьШапка.Параметры.ЛимитДоОкругления = выборкаПодразделения.ЛимитЗаМесяц;
		иначе
			областьШапка.Параметры.ЛимитДоОкругления = выборкаПодразделения.ЛимитЗаКвартал;
		конецЕсли;	

		областьШапка.Параметры.КоличествоДнейМеждуИнкассациями = выборкаПодразделения.КоличествоДнейМеждуИнкассациями;
		областьПодвал.Параметры.КоличествоДнейМеждуИнкассациями = выборкаПодразделения.КоличествоДнейМеждуИнкассациями;
		
	    вГруппеРазвития = Лимит  = лимитГруппыРазвития; 
		
		// В зависимости от нахождения в группе развития
		//---
		если вГруппеРазвития тогда
			
			// В группе развития
			областьШапка.параметры.поступлениеДенег = "3 100 000";
			областьШапка.Параметры.отработаноДней = группаРазвитияОтработаноДней;
			областьПрогнозируемый.Параметры.приставка = "прогнозируемая выручка";
			областьШапка.Параметры.ПромежуточныйРезультат = "100 000";
			областьШапка.Параметры.ЛимитДоОкругления = лимитГруппыРазвития;
			//областьШапка.Параметры.расчетныйПериод = ""
			
		иначе
			
			// Не в группе развития
			//если (выборкаПодразделения.периодИтоговый = 0) тогда
			//	период = "Месяц";
			//	//лимитДней = разностьДат(конецМесяца(датаДокумента), началоМесяца(датаДокумента));
			//	форматнаяСтрока = "ДФ='ММММ yyyy ""г.""'";
			//	областьПодвал.Параметры.расчетныйПериод = " (" + формат(датаДокумента, форматнаяСтрока) + ")";
			//	
			//	Приставка = Формат(выборкаПодразделения.датаПриказа-1, "ДФ='MMMM yyyy'");
			//	
			//иначе
				период = "Квартал";
				//лимитДней = разностьДат(конецМесяца(датаДокумента), началоКвартала(датаДокумента));
				форматнаяСтрока = "ДФ='к""-й квартал"" yyyy "" г.""'";
				областьПодвал.Параметры.расчетныйПериод = "";
				
				ПозапрошлыйМесяц = ДобавитьМесяц(началоМесяца(выборкаПодразделения.датаПриказа-1),-2);
				ПрошлыйМесяц = ДобавитьМесяц(началоМесяца(выборкаПодразделения.датаПриказа-1),-1);
				Приставка = Формат(ПозапрошлыйМесяц, "ДФ='MMMM yyyy'") + ", "+
				Формат(ПрошлыйМесяц, "ДФ='MMMM yyyy'") + ", "
				+ Формат(выборкаПодразделения.датаПриказа-1, "ДФ='MMMM yyyy'");
				
			//конецЕсли;	
			
			областьШапка.параметры.поступлениеДенег = выборкаПодразделения["НаличныеЗа" + период];
			областьШапка.Параметры.отработаноДней = выборкаПодразделения["ОтработаноЗа" + период];
			областьПрогнозируемый.Параметры.приставка = Приставка;
			//область.Параметры.лимитДней = лимитДней;
			областьПодвал.Параметры.лимитДней = выборкаПодразделения["ОтработаноЗа" + период];
			//область.Параметры.КоличествоДнейМеждуИнкассациями = выборкаПодразделения.КоличествоДнейМеждуИнкассациями;
			
			//область.Параметры.расчетныйПериод = " (" + формат(датаДокумента, форматнаяСтрока) + ")";
		конецЕсли;
		
		//---
		если (не первый) тогда
			табличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		конецЕсли;
		первый = ложь;		
		табличныйДокумент.Вывести(областьШапка);
		
		//Если вГруппеРазвития Тогда
			
			табличныйДокумент.Вывести(областьПрогнозируемый);	
			
		//Иначе
		//	
		//	табличныйДокумент.Вывести(областьРасчетный);	
		//	
		//КонецЕсли;
		
		табличныйДокумент.Вывести(областьПодвал);
		
	конецЦикла;
	
	//---
	Возврат ТабличныйДокумент;
	
КонецФункции



//************************************************************************
// Возвращает структуру данных со сводным описанием контрагента
//
// Параметры: 
//  СписокСведений - список значений со значенийми параметров организации
//   СписокСведений формируется функцией СведенияОЮрФизЛице
//  Список         - список запрашиваемых параметров организаиии
//  СПрефиксом     - Признак выводить или нет префикс параметра организации
//
// Возвращаемое значение:
//  Строка - описатель организации / контрагента / физ.лица.
//

Функция ОписаниеОрганизации(СписокСведений, Список = "", СПрефиксом = Истина) Экспорт

	Если ПустаяСтрока(Список) Тогда
		
		Список = "ИНН,Свидетельство,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет";
		Если Не СписокСведений.Свойство("НаименованиеДляПечатныхФорм") Тогда
			Список = "НаименованиеПолное," + Список;
		Иначе
			Список = "НаименованиеДляПечатныхФорм," + Список;
		КонецЕсли;
		
	КонецЕсли;

	Результат = "";

	СоответствиеПараметров = Новый Соответствие();
	СоответствиеПараметров.Вставить("ПолноеНаименование",			" ");
	СоответствиеПараметров.Вставить("СокращенноеНаименование",		" ");
	СоответствиеПараметров.Вставить("НаименованиеДляПечатныхФорм",	" ");
	СоответствиеПараметров.Вставить("ИНН",							" ИНН ");
	СоответствиеПараметров.Вставить("КПП",							" КПП ");
	СоответствиеПараметров.Вставить("Свидетельство",				" ");
	СоответствиеПараметров.Вставить("СвидетельствоДатаВыдачи",		" от ");
	СоответствиеПараметров.Вставить("ЮридическийАдрес",				" ");
	СоответствиеПараметров.Вставить("Телефоны",						" тел.: ");
	СоответствиеПараметров.Вставить("НомерСчета",					" р/с ");
	СоответствиеПараметров.Вставить("Банк",               			" в банке ");
	СоответствиеПараметров.Вставить("БИК",                			" БИК ");
	СоответствиеПараметров.Вставить("КоррСчет",           			" к/с ");
	СоответствиеПараметров.Вставить("КодПоОКПО",          			" Код по ОКПО ");

	Список          = Список + ?(Прав(Список, 1) = ",", "", ",");
	ЧислоПараметров = СтрЧислоВхождений(Список, ",");

	Для Счетчик = 1 по ЧислоПараметров Цикл

		ПозЗапятой = Найти(Список, ",");

		Если ПозЗапятой > 0  Тогда
			ИмяПараметра = Лев(Список, ПозЗапятой - 1);
			Список = Сред(Список, ПозЗапятой + 1, СтрДлина(Список));

			Попытка
				СтрокаДополнения = "";
				СписокСведений.Свойство(ИмяПараметра, СтрокаДополнения);

				Если ПустаяСтрока(СтрокаДополнения) Тогда
					Продолжить;
				КонецЕсли;

				Префикс = СоответствиеПараметров[ИмяПараметра];
				Если Не ПустаяСтрока(Результат)  Тогда
					Результат = Результат + ",";
				КонецЕсли; 

				Результат = Результат + ?(СПрефиксом = Истина, ?(ПустаяСтрока(Результат), СокрЛ(Префикс), Префикс), "") + СтрокаДополнения;

			Исключение

				Сообщить("Не удалось определить значение параметра организации: " + ИмяПараметра, СтатусСообщения.Внимание);

			КонецПопытки;

		КонецЕсли; 

	КонецЦикла;

	Возврат Результат;

КонецФункции // ОписаниеОрганизации()

