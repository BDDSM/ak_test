﻿//+++АК LAGP 2018.02.14 ИП-00017918 Создана общая функция для получения счёта по условию.
//КодСчета 			- строка, код счёта 				(строка)
//ПланСчетов    	- план счетов 						(строка)
//СтруктураУсловия 	- дополнительные параметры поиска 	(структура)
Функция ВернутьСчетПоУсловию(КодСчета, ПланСчетов = "Хозрасчетный", СтруктураУсловия = Неопределено) Экспорт

	//В этом блоке регистрируется смена счетов в зависимости от условия, например до 2018 использовать ФИН 57.4, после - 51.2
	Если КодСчета = "57.4" И ПланСчетов = "Финансовый" Тогда 
		Если ЗначениеЗаполнено(СтруктураУсловия) и СтруктураУсловия.Свойство("ДатаЗапроса") Тогда
			КодСчета = ?(СтруктураУсловия.ДатаЗапроса < Дата("20180101"), "57.4", "51.2");			
		КонецЕсли;
	//+++АК LAGP 2018.02.27 ИП-00017984 Если плата за обслуживание корп. карты , то должно быть списание на 44.3, а не на 51.1	
	ИначеЕсли КодСчета = "51.1" И ПланСчетов = "Финансовый" Тогда 
		Если ЗначениеЗаполнено(СтруктураУсловия) и СтруктураУсловия.Свойство("Событие") Тогда
			КодСчета = ?(СтруктураУсловия.Событие = "платазаобслуживаниебанковскойкарты", "51.2", "51.1");			
		КонецЕсли;	
	//---АК LAGP	
	ИначеЕсли КодСчета = "51.02" И ПланСчетов = "Хозрасчетный" Тогда
		Если ЗначениеЗаполнено(СтруктураУсловия) и СтруктураУсловия.Свойство("ДатаЗапроса") Тогда
			КодСчета = ?(СтруктураУсловия.ДатаЗапроса < Дата("20180101"), "55.04", "51.02");			
		КонецЕсли;			
	КонецЕсли;	
	
	Возврат ПланыСчетов[ПланСчетов].НайтиПоКоду(КодСчета);	
	
КонецФункции

//+++АК LAGP 2018.02.20 ИП-00017984 Создана общая функция для получения статьи ДДС по условию.
//КодСтатьи 		- строка, код статьи в справочнике 									(строка)
//ДДС_БУ    		- признак обращения к справочнику "СтатьиДвиженияДенежныхСредствБУ" (булево)
//СтруктураУсловия 	- дополнительные параметры поиска 									(структура)
Функция ВернутьСтатьюДДСПоУсловию(КодСтатьи, ДДС_БУ = Ложь, СтруктураУсловия = Неопределено) Экспорт

	//В этом блоке регистрируется смена статей в зависимости от условия, 
	//например до 2018 использовать статью ДДС_БУ "Оплата с корпоративной карты" ("901046   "), после - "Услуги банка" ("000000016")
	Если КодСтатьи = "901046   " И ДДС_БУ Тогда 
		Если ЗначениеЗаполнено(СтруктураУсловия) и СтруктураУсловия.Свойство("ДатаЗапроса") Тогда
			КодСтатьи = ?(СтруктураУсловия.ДатаЗапроса < Дата("20180101"), "901046   ", "000000016");			
		КонецЕсли;			
	КонецЕсли;	
	
	НаименованиеСправочника = "СтатьиДвиженияДенежныхСредств" + ?(ДДС_БУ, "БУ", "");
	
	Возврат Справочники[НаименованиеСправочника].НайтиПоКоду(КодСтатьи);	
	
КонецФункции

//+++АК LAGP  2018.11.30 Оптимизация. Функция возвращает строку букв и цифр, всё лишнее удаляется
Функция ВернутьСтрокуПоУсловию(СтрокаИсточник, ОставитьБуквы = Истина, ОставитьЦифры = Истина, СтрокаРазрешенныхДополнительныхСимволов = Неопределено) Экспорт
	
	ОбработаннаяСтрока = "";
	
	Для НомерСимвола = 1 По СтрДлина(СтрокаИсточник) Цикл
		ОбрабатываемыйСимвол = Сред(СтрокаИсточник, НомерСимвола, 1);
		КодОбрабатываемогоСимвола = КодСимвола(ОбрабатываемыйСимвол);
		
		УсловиеБуквы        = Ложь;
		УсловиеЦифры        = Ложь;
		УсловиеВхожденияДоп = Ложь;
		
		Если ОставитьБуквы Тогда
			УсловиеБуквы = (КодОбрабатываемогоСимвола >= 65 И КодОбрабатываемогоСимвола <= 90) ИЛИ (КодОбрабатываемогоСимвола >= 97 И КодОбрабатываемогоСимвола <= 122) ИЛИ (КодОбрабатываемогоСимвола >= 1040 И КодОбрабатываемогоСимвола <= 1103); //1,2 английский алфавит в разных регистрах, 3 - русский			
		КонецЕсли;
		
		Если ОставитьЦифры Тогда
			УсловиеЦифры = (КодОбрабатываемогоСимвола >= 48 И КодОбрабатываемогоСимвола <= 57);
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(СтрокаРазрешенныхДополнительныхСимволов) Тогда
			УсловиеВхожденияДоп = Найти(СтрокаРазрешенныхДополнительныхСимволов, ОбрабатываемыйСимвол) > 0;
		КонецЕсли;	
			
		Если УсловиеБуквы ИЛИ УсловиеЦифры ИЛИ УсловиеВхожденияДоп Тогда
			ОбработаннаяСтрока = ОбработаннаяСтрока + ОбрабатываемыйСимвол;		
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат ОбработаннаяСтрока;
	
КонецФункции	  

// Функция возвращает реквизиты объекта
//
// Параметры
//	Ссылка				- <Произвольный>, ссылка на объект
//	СтруктураПолей		- <Структура>, реквизиты объекта, которые необходимо получить
//	ПолноеИмяОбъекта	- <Строка>, полное имя объекта, например "Справочник.Пользователи"
//
// Возвращаемое значение
//	Структура
//
Функция ПолучитьЗначенияРеквизитовОбъекта(Ссылка, СтруктураПолей, ПолноеИмяОбъекта = Неопределено) Экспорт

	Если ПолноеИмяОбъекта = Неопределено Тогда
		ПолноеИмяОбъекта = Ссылка.Метаданные().ПолноеИмя();
	КонецЕсли; 

	ТекстЗапроса = "";
	
	Для Каждого Элемент Из СтруктураПолей Цикл
		
		ИмяПоля = Элемент.Значение;
		
		Если НЕ ЗначениеЗаполнено(ИмяПоля) Тогда
			ИмяПоля = СокрЛП(Элемент.Ключ);
		КонецЕсли;
		
		ТекстЗапроса  = ТекстЗапроса + ?(ПустаяСтрока(ТекстЗапроса), "", ",") + "
		|	" + ИмяПоля + " КАК " + СокрЛП(Элемент.Ключ);
	КонецЦикла;

	Запрос = Новый Запрос();

	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ" + ТекстЗапроса + "
	|ИЗ
	|	" + ПолноеИмяОбъекта + " КАК ТаблицаОбъекта
	|ГДЕ
	|	Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка" , Ссылка);

	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый Структура;
	Если Выборка.Следующий() Тогда
		Для Каждого КлючИЗначение ИЗ СтруктураПолей Цикл
			Результат.Вставить(КлючИЗначение.Ключ, Выборка[КлючИЗначение.Ключ]);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращает объект WSПрокси созданный с переданными параметрами.
//
// Параметры соответствуют конструктору объекта WSПрокси.
//
//+++АК LAGP 2018.02.14 добавлены директивы компиляции для использования этого общегомодуля с клиента.
&НаСервере
Функция WSПрокси(Знач АдресWSDL, Знач URIПространстваИмен, Знач ИмяСервиса,
	Знач ИмяТочкиПодключения, Знач ИмяПользователя, Знач Пароль, Знач Таймаут) Экспорт
	
	Возврат СервисДанныхЕдиныхГосРеестров.ВнутренняяWSПрокси(АдресWSDL, URIПространстваИмен, ИмяСервиса, 
		ИмяТочкиПодключения, ИмяПользователя, Пароль, Таймаут);
	
КонецФункции
	
// Возвращает объект WSОпределения созданный с переданными параметрами.
//
// Параметры:
//  АдресWSDL - Строка - месторасположение wsdl.
//  ИмяПользователя - Строка - имя пользователя для входа на сервер.
//  Пароль - Строка - пароль пользователя.
//
// Примечание: при получении определения используется кэш, обновление которого осуществляется
//  при смене версии конфигурации. Если для целей отладки требуется обновить
//  значения в кэше, раньше этого времени, следует удалить из регистра сведений.
//  КэшПрограммныхИнтерфейсов соответствующие записи.
//
//+++АК LAGP 2018.02.14 добавлены директивы компиляции для использования этого общегомодуля с клиента.
&НаСервере
Функция WSОпределения(Знач АдресWSDL, Знач ИмяПользователя, Знач Пароль) Экспорт
	
	Возврат СервисДанныхЕдиныхГосРеестров.WSОпределения(АдресWSDL, ИмяПользователя, Пароль);
	
КонецФункции

//+++АК Susk (Суслин К.В.) 2018.03.15 б/н оптимизация
Функция ПолучитьУзелОбменаПоКоду(КодУзла) Экспорт
	
	Возврат ПланыОбмена.ОбменИзбенкаСБП.НайтиПоКоду(КодУзла);
	
КонецФункции

//+++АК SHEP 2018.05.03 ИП-00018453
Функция СторонняяПереработкаДляОрганизации(Организация) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтруктурныеЕдиницы.Ссылка,
		|	СтруктурныеЕдиницы.Организация,
		|	СтруктурныеЕдиницы.СторонняяПереработка
		|ИЗ
		|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|ГДЕ
		|	СтруктурныеЕдиницы.СторонняяПереработка
		|	И СтруктурныеЕдиницы.Организация = &Организация");
	Запрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		ЭтоВкусВилл = (Организация = Справочники.Организации.НайтиПоРеквизиту("ИНН", "7734675810"));
		// на всякий случай, для пустой организации возвращаем "старый" элемент справочника "СторонняяПереработка"
		Возврат ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы." + ?(ЗначениеЗаполнено(Организация) И НЕ ЭтоВкусВилл, "ПустаяСсылка", "СторонняяПереработка"));
	КонецЕсли;
	
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаЗапроса.Следующий();
	Возврат ВыборкаЗапроса.Ссылка;
	
КонецФункции

Функция ПолучитьПравоПользователяУпр(Право, ЗначениеПоУмолчанию) Экспорт
	Возврат УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(Право, ЗначениеПоУмолчанию);
КонецФункции

Функция НастройкиСтатей() Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатьиДоходовРасходовСписокСчетовУчета.СчетУчета,
		|	СтатьиДоходовРасходовСписокСчетовУчета.ОсновнойСчет,
		|	ВЫБОР
		|		КОГДА СтатьиДоходовРасходовСписокСчетовУчета.СчетУчета В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Финансовый.ЗатратыДляРаспределения))
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ВГруппе,
		|	СтатьиДоходовРасходовСписокСчетовУчета.Ссылка
		|ИЗ
		|	Справочник.СтатьиДоходовРасходов.СписокСчетовУчета КАК СтатьиДоходовРасходовСписокСчетовУчета
		|ГДЕ
		|	СтатьиДоходовРасходовСписокСчетовУчета.СчетУчета.Родитель = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.ЗатратыДляРаспределения)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();	

КонецФункции

Функция ПодразделенияТилси(ДатаДокумента) Экспорт
	ПодрТилсиОбщий 		= Справочники.СтруктурныеЕдиницы.ПолучитьСсылку(Новый УникальныйИдентификатор("788cf095-310f-11e8-9c51-005056a714c6")); // Тилси(Общий)	
	ОрганизацияТилси 	= Справочники.Организации.ПолучитьСсылку(Новый УникальныйИдентификатор("aec7bdbc-0fdd-11e8-8b52-005056a714c6")); // Тилси
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Орг_Тилси", ОрганизацияТилси);
	
	//+++АК CISA 2018.10.17 ИП-00020148
	ДопТекстЗапроса = "";
	Если ДатаДокумента <> Неопределено Тогда
		ДопТекстЗапроса = "ИЛИ (ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница.СтатусТорговойТочки = ЗНАЧЕНИЕ(Перечисление.СтатусыТорговыхТочек.Закрыт)"
				  			+ "И ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница.ДатаЗакрытия > &ДатаДокумента)";
		Запрос.УстановитьПараметр("ДатаДокумента", ДатаДокумента);
	КонецЕсли;
	//---АК CISA
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЦФОСтруктурныхЕдиниц.ЦФО,
	               |	ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница
	               |ПОМЕСТИТЬ ВР_ттТилси
	               |ИЗ
	               |	РегистрСведений.ЦФОСтруктурныхЕдиниц КАК ЦФОСтруктурныхЕдиниц
	               |ГДЕ
	               |	ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница <> ЦФОСтруктурныхЕдиниц.ЦФО
	               |			И НЕ ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница ЕСТЬ NULL
	               |			И ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	               |			И ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница.ТипРозничнойТочки В (ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.Перекресток),ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.Пятерочка))
					//+++АК KIRN 2018.09.14 ИП-00018562				   
				   |			И (ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница.СтатусТорговойТочки <> ЗНАЧЕНИЕ(Перечисление.СтатусыТорговыхТочек.Закрыт) 
				   //+++АК CISA 2018.10.17 ИП-00020148
				   |"+ ДопТекстЗапроса + "
				   //---АК CISA
				   |			И ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница.СтатусТорговойТочки <> ЗНАЧЕНИЕ(Перечисление.СтатусыТорговыхТочек.Приостановлен))
	               //|			И (ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница.СтатусТорговойТочки = ЗНАЧЕНИЕ(Перечисление.СтатусыТорговыхТочек.Открыт)
	               //|				ИЛИ ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница.СтатусТорговойТочки = ЗНАЧЕНИЕ(Перечисление.СтатусыТорговыхТочек.ПустаяСсылка)
	               //|				ИЛИ ЦФОСтруктурныхЕдиниц.СтруктурнаяЕдиница.СтатусТорговойТочки ЕСТЬ NULL)
				   //---АК KIRN 
	               |			И ЦФОСтруктурныхЕдиниц.Организация = &Орг_Тилси
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВложенныйЗапрос.ТТ
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ВР_ттТилси.ЦФО КАК ТТ
	               |	ИЗ
	               |		ВР_ттТилси КАК ВР_ттТилси
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ВР_ттТилси.СтруктурнаяЕдиница
	               |	ИЗ
	               |		ВР_ттТилси КАК ВР_ттТилси) КАК ВложенныйЗапрос
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВложенныйЗапрос.ТТ";
	Результат = Запрос.Выполнить();
	СЗ_ттТилси = Новый Соответствие;
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл 
			СЗ_ттТилси[Выборка.ТТ] = Выборка.ТТ;
		КонецЦикла;
	КонецЕсли;
	
	
	СЗ_ттТилси[ПодрТилсиОбщий] = ПодрТилсиОбщий;
	
	Возврат СЗ_ттТилси

КонецФункции

Функция СчетПринадлежитЭлементу(Счет, Элемент) Экспорт
	Возврат Счет.ПринадлежитЭлементу(Элемент);
КонецФункции

Функция СвойстваСчета(Счет) Экспорт 
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Счет, "Забалансовый");
КонецФункции

Функция ЗначениеКонстанты(ИмяКонстанты) Экспорт
	Возврат Константы[ИмяКонстанты].Получить();
КонецФункции

Функция ПолучитьДатуЗапретаМСФО() Экспорт
	Возврат АК_УчетМСФОПривилегированный.ПолучитьДатуЗапретаМСФО()
КонецФункции

Функция СчетВИерархии(Счет, Эталон) Экспорт

	Если ЗначениеЗаполнено(Счет) Тогда
		Возврат Счет = Эталон ИЛИ Счет.ПринадлежитЭлементу(Эталон);
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Функция ПолучитьПараметрыУчетаОС() Экспорт 
	Возврат АК_УчетМСФОПривилегированный.ПолучитьПараметрыУчетаОС();
КонецФункции

//+++АК Susk (Суслин К.В.) 2018.05.29 ИП-00018816
Функция ПолучитьСписокЗапрещенныхВПроводкахЦФО() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СтруктурныеЕдиницы.Ссылка КАК ЦФО
	               |ИЗ
	               |	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	               |ГДЕ
	               |	СтруктурныеЕдиницы.ЗапрещеноВыбиратьКакЦфоВПроводки";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ЦФО");
	
КонецФункции

//+++АК Susk (Суслин К.В.) 2018.05.07 ИП-00017910
Функция ПолучитьТаблицуПроверкиИзмененийЛУ()
	
	ТаблицаПроверки = Новый ТаблицаЗначений;
	ТаблицаПроверки.Колонки.Добавить("Сущность");
	ТаблицаПроверки.Колонки.Добавить("МассивРеквизитов");
		
	//Шапка
	МассивШапка = Новый Массив;
	МассивШапка.Добавить("ТорговаяТочка");
	МассивШапка.Добавить("Терминал");
	МассивШапка.Добавить("Дата");
	МассивШапка.Добавить("Организация");	
	МассивШапка.Добавить("ПометкаУдаления");	
	МассивШапка.Добавить("Проведен");
	
	СтрШапка = ТаблицаПроверки.Добавить();
	СтрШапка.Сущность = "Шапка";
	СтрШапка.МассивРеквизитов = МассивШапка;
	
	//ZОтчеты
	МассивЗО = Новый Массив;
	МассивЗО.Добавить("СуммаПоНал");	
	МассивЗО.Добавить("СуммаПоБезнал");
	
	СтрЗО = ТаблицаПроверки.Добавить();
	СтрЗО.Сущность = "ZОтчеты";
	СтрЗО.МассивРеквизитов = МассивЗО;
	
	//ОплатыБК
	МассивОплатыБК = Новый Массив;
	МассивОплатыБК.Добавить("Сумма");	
	МассивОплатыБК.Добавить("СуммаДоставка");
	МассивОплатыБК.Добавить("РабочееМестоВСкл");
	
	СтрОплатыБК = ТаблицаПроверки.Добавить();
	СтрОплатыБК.Сущность = "ОплатыПоБанковскимКартам";
	СтрОплатыБК.МассивРеквизитов = МассивОплатыБК;

	//Выручка
	МассивВыручка = Новый Массив;
	МассивВыручка.Добавить("Сумма");
	
	СтрВыручка = ТаблицаПроверки.Добавить();
	СтрВыручка.Сущность = "Выручка";
	СтрВыручка.МассивРеквизитов = МассивВыручка;
	
	//АктыКм3
	МассивАктыКм3 = Новый Массив;
	МассивАктыКм3.Добавить("ЭтоВозвратБезнал");	
	МассивАктыКм3.Добавить("СуммаПоНДС10");
	МассивАктыКм3.Добавить("СуммаПоНДС18");
	
	СтрАктыКм3 = ТаблицаПроверки.Добавить();
	СтрАктыКм3.Сущность = "АктыКМ3";
	СтрАктыКм3.МассивРеквизитов = МассивАктыКм3;

	//Товары по возвратам
	МассивТовары = Новый Массив;
	МассивТовары.Добавить("Номенклатура");	
	МассивТовары.Добавить("Количество");
	МассивТовары.Добавить("СтавкаНДС");
	МассивТовары.Добавить("Сумма");
	
	СтрТовары = ТаблицаПроверки.Добавить();
	СтрТовары.Сущность = "ТоварыПоВозвратам";
	СтрТовары.МассивРеквизитов = МассивТовары;
	
	Возврат ТаблицаПроверки;	
	
КонецФункции

//+++АК Susk (Суслин К.В.) 2018.05.07 ИП-00017910
Функция ПолучитьСтруктуруЗапросаПроверкиИзмененийЛУ() Экспорт
	
	ТаблицаПроверкиИзменений = ПолучитьТаблицуПроверкиИзмененийЛУ();
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ЛистУчета.Ссылка&РеквизитыОбъекта
	               |ИЗ
	               |	Документ.ЛистУчета КАК ЛистУчета
	               |ГДЕ
	               |	ЛистУчета.Ссылка = &Ссылка" + Символы.ПС;
	
	СтрокаРеквизитовОбъекта = "";
	
	ЗаготовкаТекстаДляТч = ";							
							|ВЫБРАТЬ &РеквизитыТЧ Из Документ.ЛистУчета.";	
	
	Для Каждого СтрТаблицы Из ТаблицаПроверкиИзменений Цикл
		
		Если СтрТаблицы.Сущность = "Шапка" Тогда
			МассивШапка = СтрТаблицы.МассивРеквизитов;
			
			Для Каждого Рекв Из МассивШапка Цикл
				СтрокаРеквизитовОбъекта = СтрокаРеквизитовОбъекта + ",ЛистУчета." + Рекв;
			КонецЦикла;
		Иначе
			
			ИмяТч = СтрТаблицы.Сущность;
			МассивТЧ = СтрТаблицы.МассивРеквизитов;
			
			ТекстЗапроса = ТекстЗапроса + ЗаготовкаТекстаДляТч + ИмяТч + " КАК ЛистУчета ГДЕ ЛистУчета.Ссылка = &Ссылка" + Символы.ПС;
			СтрокаРеквизитовТЧ = "ЛистУчета.НомерСтроки";
			
			Для Каждого Рекв Из МассивТч Цикл
				СтрокаРеквизитовТЧ = СтрокаРеквизитовТЧ + ", ЛистУчета." + Рекв;
			КонецЦикла;
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РеквизитыТЧ", СтрокаРеквизитовТЧ);			
			
		КонецЕсли;		
		
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РеквизитыОбъекта", СтрокаРеквизитовОбъекта);
	
	ДанныеВозврата = Новый Структура;
	ДанныеВозврата.Вставить("ТекстЗапроса", ТекстЗапроса);
	ДанныеВозврата.Вставить("ТаблицаПроверкиИзменений", ТаблицаПроверкиИзменений);	
	
	Возврат ДанныеВозврата;

КонецФункции

Функция МассивДоступныхРолейДляНоменклатуры() Экспорт
	МассивДоступныхРолей 		= Новый Массив;
	МассивДоступныхТиповРолей 	= Новый Массив;
	
	//
	ТЗ =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РолиПользователейТипыРолей.Ссылка,
	|	РолиПользователейТипыРолей.ТипРоли,
	|	РолиПользователейТипыРолей.ТипРоли.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы
	|ИЗ
	|	Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
	|{ГДЕ
	|	РолиПользователейТипыРолей.Ссылка.* КАК Роль,
	|	РолиПользователейТипыРолей.ТипРоли.* КАК ТипРоли,
	|	РолиПользователейТипыРолей.ТипРоли.ТипСтруктурнойЕдиницы.* КАК ТипСтруктурнойЕдиницы}";
	
	//
	ПЗ = Новый ПостроительЗапроса;
	ПЗ.Текст = ТЗ;
	
	//
	ПЗ.Выполнить();
	
	//
	Выборка = ПЗ.Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		//
		Если Выборка.ТипРоли.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Номенклатура")) Тогда
			
			//
			МассивДоступныхРолей.Добавить(Выборка.Ссылка);
			МассивДоступныхТиповРолей.Добавить(Выборка.ТипРоли);
			
		КонецЕсли; 
		
	КонецЦикла; 
	
	Возврат Новый Структура("МассивДоступныхРолей, МассивДоступныхТиповРолей", МассивДоступныхРолей, МассивДоступныхТиповРолей);
КонецФункции

Функция КаталогХраненияФайловНоменклатуры() Экспорт
	Возврат ОбщегоНазначенияСервер.КаталогХраненияФайловНоменклатуры();
КонецФункции

Функция ВкусВилл(Дата) Экспорт
	Возврат АК_УчетМСФО.ОрганизацияВкусВилл(Дата);
КонецФункции

Функция Тилси() Экспорт
	Возврат Справочники.Организации.ПолучитьСсылку(Новый УникальныйИдентификатор("aec7bdbc-0fdd-11e8-8b52-005056a714c6"));
КонецФункции

//+++АК SHEP 2018.07.19 ИП-00019254
Функция ПутьБДРаспределенияSQL() Экспорт
	Возврат Константы.ПутьБДРаспределенияSQL.Получить();
КонецФункции

//+++АК SHEP 2018.07.19 ИП-00019254
Функция ЭтоКопияБазы() Экспорт
	Возврат ОбщегоНазначения.ЭтоКопияБазы();
КонецФункции

//+++АК SHEP 2018.07.30 б/н
Функция ТекущийПользовательСеанса() Экспорт
	Возврат ПараметрыСеанса.ТекущийПользователь;
КонецФункции

//+++АК SaMi 2018.10.29 ИП-00020204
Функция ПолучитьАналогиУпаковокПереработчика() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АналогУпаковкиУПереработчика.Аналог
	|ИЗ
	|	РегистрНакопления.АналогУпаковкиУПереработчика КАК АналогУпаковкиУПереработчика");
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Аналог");	
	
КонецФункции  
//---АК SaMi  2018.10.29 

// Получает и возвращает объект внешней обработки или отчета //+++АК mika 2018.11.01 БезЗадачи
// Следует использовать для алгоритмов, которые подразумевают регулярное использование объекта в работе.
// (Для "единоразового" использования следует пользоваться функцией ОбщийМодуль.ОбщегоНазначения.ПолучитьИПодключитьВнешнююОбработку())
//
// Параметры:
//  Наименование  - <Тип.Строка> - Наименование обработки/отчета 
//  ЭтоОтчет - <Тип.Булево> - Признак для возврата внешнего отчета
//
// Возвращаемое значение:
//   <Тип.ОбработкаОбъект, Тип.ОтчетОбъект, Неопределено>   
//
Функция ПолучитьОбъектВнешнейОбработкиОтчетаПоНаименованиюСервер(Наименование, ЭтоОтчет = Ложь) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	ВнешниеОбработкиСсылка = Справочники.ВнешниеОбработки.НайтиПоНаименованию(Наименование);
	
	Если НЕ ЗначениеЗаполнено(ВнешниеОбработкиСсылка) Тогда 
		Возврат Неопределено; 
	КонецЕсли;
	
	ДвоичныеДанные = ВнешниеОбработкиСсылка.ХранилищеВнешнейОбработки.Получить();
	
	Если ЭтоОтчет Тогда
		
		#Если Сервер Тогда
			АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
			ИмяОбработки = ВнешниеОтчеты.Подключить(АдресВоВременномХранилище, , Ложь);
		#Иначе
			ИмяОбработки = ПолучитьИмяВременногоФайла("erf");
			ДвоичныеДанные.Записать(ИмяОбработки); 
		#КонецЕсли
		
		ВнешнийОбъект = ВнешниеОтчеты.Создать(ИмяОбработки);
		
	Иначе
		
		#Если Сервер Тогда
			АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
			ИмяОбработки = ВнешниеОбработки.Подключить(АдресВоВременномХранилище, , Ложь);
		#Иначе
			ИмяОбработки = ПолучитьИмяВременногоФайла("epf");
			ДвоичныеДанные.Записать(ИмяОбработки); 
		#КонецЕсли
		
		ВнешнийОбъект = ВнешниеОбработки.Создать(ИмяОбработки);
		
	КонецЕсли;

	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ВнешнийОбъект;

КонецФункции // ПолучитьОбъектВнешнейОбработкиПоНаименованиюСервер()
  
