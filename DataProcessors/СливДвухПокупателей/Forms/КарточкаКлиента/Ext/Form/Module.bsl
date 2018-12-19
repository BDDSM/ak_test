

&НаКлиенте
Процедура ТипПокупателяПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура SexПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура BirthdayПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура PhoneПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Email_factПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ГородПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УлицаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДомПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура informationПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура SMS_karta_noПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура MobilCartaПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры
  
// Выполянет запрос и резульатат запроса возвращает в таблицу значений
//
&НаСервере
Процедура База_ВыполнитьЗапросИЗаполнитьТаблицуЗначений(ТекстЗапроса, допПараметры = Неопределено)  
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "SMS_UNION");	
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры, СтрокаПодключения);
	тзРезультат = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();
	
    Для каждого ТекСтрока Из тзРезультат Цикл
		
		Если ТекСтрока.Дата <> NULL  Тогда
 			ТекСтрока.Дата = Дата(ТекСтрока.Дата);
		КонецЕсли;	
 
    КонецЦикла;	
    тзРезультат.Сортировать("Дата Убыв");
    
    Объект.ТЗ_СМС_ВсеПоКлиенту.Загрузить(тзРезультат);
	
КонецПроцедуры

&НаСервере
Процедура База_ВыполнитьЗапросИЗаполнитьТаблицуЗначенийПовторойКарте(ТекстЗапроса, допПараметры = Неопределено)  
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "SMS_UNION");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры, СтрокаПодключения);
	тзРезультат = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();
	
    Для каждого ТекСтрока Из тзРезультат Цикл
		
		Если ТекСтрока.Дата <> NULL  Тогда
 			ТекСтрока.Дата = Дата(ТекСтрока.Дата);
		КонецЕсли;	
 
    КонецЦикла;	
    тзРезультат.Сортировать("Дата Убыв");
    
    Объект.ТЗ_СМС_ВсеПоКлиенту1.Загрузить(тзРезультат);
	
КонецПроцедуры

&НаСервере
Процедура База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения = "")  
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры, СтрокаПодключения);
	//тзРезультат = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	Попытка
		RecordSet.Close();
	Исключение
	КонецПопытки;	
		
КонецПроцедуры


&НаСервере
Функция База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения = "")  
	Попытка
		Command = Новый COMОбъект("ADODB.Command");
		
		Если ТипЗнч(допПараметры) = Тип("Структура") тогда
			ЗаполнитьЗначенияСвойств(Command, допПараметры);
		КонецЕсли;			
		CurrentConnection = База_Подключение(СтрокаПодключения);
		Command.ActiveConnection = CurrentConnection;
		Command.CommandTimeout = 0;
		Command.CommandText = ТекстЗапроса;
		RecordSet = Новый COMОбъект("ADODB.RecordSet");
		RecordSet = Command.Execute(); //Выполнение и получение набора данных
		Возврат RecordSet;
	Исключение	
		ЗаписьЖурналаРегистрации("Ошибка слив двух покупателей",,,, ТекстЗапроса);
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;	
КонецФункции

&НаСервере
Функция База_Подключение(СтрокаПодключения) экспорт	
	
	Попытка
		CurrentConnection = Новый COMОбъект("ADODB.Connection");
		Catalog = Новый COMОбъект("ADOX.Catalog");					
		
		Catalog.ActiveConnection = СтрокаПодключения;
		CurrentConnection.Open(СтрокаПодключения);
		Возврат CurrentConnection;	
		
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();		
		#Если НаКлиенте тогда
		Сообщить(ОписаниеОшибки);			
		#КонецЕсли		
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

// На основе результата запроса (База_ВыполнитьЗапрос) создаем таблицу значений!!
&НаСервере
Функция База_РезульататЗапросВТаблицуЗначений(RecordSet) 
	
	тз = Новый ТаблицаЗначений;
	Если ТипЗнч(RecordSet) <> Тип("COMОбъект") тогда
		Возврат тз;
	КонецЕсли;
	
	// Инициализируем колонки
	Для НомерКолонки = 0 По RecordSet.Fields.Count-1 Цикл
		NameFiled = RecordSet.Fields.Item(НомерКолонки).Name;
		NameFiled = СтрЗаменить(NameFiled,"$","_");
		тз.Колонки.Добавить(NameFiled,,RecordSet.Fields.Item(НомерКолонки).Name, 15);
	КонецЦикла;
	
	// Перебор данных
	Если НЕ RecordSet.EOF() Тогда
		RecordSet.MoveFirst();                 
		Пока RecordSet.EOF() = 0 Цикл
			СтрокаТаблицыЗначений = тз.Добавить();
			Для НомерКолонки = 0 По RecordSet.Fields.Count-1 Цикл
				СтрокаТаблицыЗначений[НомерКолонки] = RecordSet.Fields(RecordSet.Fields.Item(НомерКолонки).Name).Value;
			КонецЦикла;
			RecordSet.MoveNext();  
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТЗ;
КонецФункции

// Закрываем датасет возвращаемй База_ВыполнитьЗапрос();
//
&НаСервере
Процедура База_ЗакрытьЗапрос(RecordSet) 
	Если ТипЗнч(RecordSet) = Тип("COMОбъект") тогда
		RecordSet.Close();
	КонецЕсли;		
КонецПроцедуры


&НаКлиенте
Процедура Картинка(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьИсториюИзменений(Команда)
	
	Табл = ПосмотретьИсториюИзмененийНаСервере();	
	Табл.Показать("История изменений по карте "+Email);	
	
КонецПроцедуры

&НаСервере
Функция ПосмотретьИсториюИзмененийНаСервере()
	
	
	ТекстЗапроса = "SELECT [Number]
	|,[user_change]
	|,[date_change]
	|,[field_change]
	|,[value_old]
	|
	|FROM [Loyalty].[dbo].[customer_hystory]
	|WHERE [Number] = '~~~~~'
	|ORDER BY [date_change];";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~",Email);
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();	
	
	
	
	Табл = Новый ТабличныйДокумент;
	Макет = ПолучитьОбщийМакет(Метаданные.ОбщиеМакеты.АК_ПечатьТаблицЗначений);
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапкаОсновной=Макет.ПолучитьОбласть("Шапка|Основной");
	ОбластьСтрокаОсновной=Макет.ПолучитьОбласть("Строка|Основной");
	ОбластьИтогОсновной=Макет.ПолучитьОбласть("Итог|Основной");
	ОбластьШапкаДОП=Макет.ПолучитьОбласть("Шапка|Показатели");
	ОбластьСтрокаДОП=Макет.ПолучитьОбласть("Строка|Показатели");
	ОбластьИтогДОП=Макет.ПолучитьОбласть("Итог|Показатели");
	
	
	ОбластьЗаголовок.Параметры.Заголовок = "История изменений по карте "+Email;
	Табл.Вывести(ОбластьЗаголовок);
	
	Табл.Вывести(ОбластьШапкаОсновной);
	
	Для Каждого Колонка из Тз.Колонки ЦИКЛ
		ОбластьШапкаДОП.Параметры.ИмяПоказателя=Колонка.Имя;
		Табл.Присоединить(ОбластьШапкаДОП);
	КонецЦикла;
	
	счетчик=0;
	Для каждого стр из Тз Цикл
		счетчик=счетчик+1;
		ОбластьСтрокаОсновной.Параметры.счетчик=счетчик; 
		Табл.Вывести(ОбластьСтрокаОсновной);
		Для Каждого Колонка из Тз.Колонки ЦИКЛ
			ОбластьСтрокаДОП.Параметры.ЗначениеКолонки=Формат(стр[Колонка.Имя],"ЧДЦ=2; ЧН=0,00; ЧГ=0");
			Табл.Присоединить(ОбластьСтрокаДОП);
		КонецЦикла;
	КонецЦикла;
	//Табл.Вывести(ОбластьИтогОсновной);
	
	//Для Каждого Колонка из Тз.Колонки ЦИКЛ
	//	ОбластьИтогДОП.Параметры.Итог=Формат(Тз.Итог(Колонка.Имя),"ЧДЦ=2; ЧН=0,00; ЧГ=0");
	//	Табл.Присоединить(ОбластьИтогДОП);
	//КонецЦикла;
	
	
	//Табл.Защита = Истина;
	//Табл.ОтображатьЗаголовки = Ложь;
	Табл.ОтображатьСетку = Ложь;
	Возврат Табл;
	
	
	
КонецФункции


&НаКлиенте
Процедура СвязатьНаОдинСчет(Команда)
	
	Если Вопрос("Точно связать?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		СвязатьНаОдинСчетНаСервере();
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура СвязатьНаОдинСчетНаСервере()
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	ТекстЗапроса ="Select Top 1 D.CustomerUID , c.Фамилия , d2.Number ВтораяКарта
	|from [Loyalty].[dbo].DiscountCard (nolock) d
	|left join [Loyalty].[dbo].Customer (nolock) c on d.CustomerUID=c.CustomerUID
	|inner join [Loyalty].[dbo].Account (nolock) a on a.AccountUID=d.AccountUID
	|left join [Loyalty].[dbo].DiscountCard (nolock) d2 on d2.AccountUID=a.AccountUID and d2.DiscountCardUID<>d.DiscountCardUID
	|where D.Number=/**BPar1**/~~~~~/**FPar**/";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~", "'"+ВтораяКарта+"'");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();
	
	Если ТЗ.Количество() <> 0 Тогда
		
		ОбщегоНазначения.СообщитьИнформациюПользователю("Связать невозможно. уже есть вторая карта.");
		Возврат;
		
	КонецЕсли;
	
	//+++АК SHEP 2018.07.04 ИП-00018827
	//ТекстЗапроса = " update [Loyalty].[dbo].DiscountCard 
	//| set AccountUID=d1.AccountUID
	//| from [Loyalty].[dbo].DiscountCard  (nolock) d2
	//| inner join
	//| (Select d.AccountUID
	//| from [Loyalty].[dbo].DiscountCard (nolock) d
	//| where D.Number=/**BPar1**/~~~~~/**FPar**/ ) d1 on 1=1
	//| where D2.Number=/**BPar2**/^^^^^/**FPar**/
	//|
	//|
	//|update Loyalty.dbo.TransactionHistory
	//|set AccountUID=d1.AccountUID
	//|from Loyalty.dbo.TransactionHistory (nolock) th
	//|inner join [Loyalty].[dbo].DiscountCard  (nolock) d2 on d2.DiscountCardUID=th.DiscountCardUID
	//| inner join
	//| (Select d.AccountUID
	//| from [Loyalty].[dbo].DiscountCard (nolock) d
	//| where D.Number=/**BPar1**/~~~~~/**FPar**/ ) d1 on 1=1
	//| where D2.Number=/**BPar2**/^^^^^/**FPar**/
	//|
	//|
	//|insert into [Loyalty].[dbo].[Audit](
	//|      [AuditUID]
	//|     ,[AuditEventTypeID]
	//|     ,[DateTimeStamp]
	//|     ,[ClientIP]
	//|     ,[AuditEventStatusID]
	//|     ,[AccountUID]
	//|     ,[CustomerUID]
	//|     ,[DiscountCardUID]
	//|     ,[Login]
	//|     ,[SecretCode]
	//|     ,[EventDesc]
	//|     ,[ScriptURL])
	//| select NEWID() , 2 , GETDATE() , /**BPar3**/#####/**FPar**/, 1 , d1.AccountUID , null , null , 
	//| d2.Number , null , 'Общ контроль' , null
	//| from [Loyalty].[dbo].DiscountCard d2
	//|inner join
	//|(Select d.AccountUID
	//|from [Loyalty].[dbo].DiscountCard (nolock) d
	//|where D.Number=/**BPar1**/~~~~~/**FPar**/ ) d1 on 1=1
	//|where D2.Number=/**BPar2**/^^^^^/**FPar**/;";
	//
	//ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~", "'"+Email+"'");
	//ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "^^^^^", "'"+ВтораяКарта+"'");
	//ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#####", "'"+ВтораяКарта+"'");
	
	ТекстЗапроса = "
		|EXEC Loyalty.dbo.BC_MergingCards   
    	|	@BC_Number_1 = " + ВнешниеДанные.ФорматПоля(Email) + ",
    	|	@BC_Number_2 = " + ВнешниеДанные.ФорматПоля(ВтораяКарта) + ",
    	|	@UserName = " + Строка(ПараметрыСеанса.ТекущийПользователь);
	//---АК SHEP 2018.07.04
	
	База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, Неопределено, СтрокаПодключения);
		
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЭтоПомощникУправляющего() Тогда
		Предупреждение("Доступ закрыт!");	
		Закрыть();
	КонецЕсли;	
	
	//Email = Параметры.Email;
	//CustomerUID = Параметры.CustomerUID;
	//rowguid = Параметры.rowguid;
	
	//ЗаполнитьДанныеФормыНаСервере();
	//
	//Модифицированность = Ложь;
	
	УстановитьВидимостьПанелей();
	
КонецПроцедуры

&НаСервере
Функция ЭтоПомощникУправляющего()
	
	ЭтоПомощник = Ложь;
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
			
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.ФизЛицо
		|ПОМЕСТИТЬ ТЗ1
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РолиПользователейСоставРоли.Ссылка
		|ПОМЕСТИТЬ ТЗ_2
		|ИЗ
		|	Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|ГДЕ
		|	РолиПользователейСоставРоли.Сотрудник В
		|			(ВЫБРАТЬ
		|				ТЗ1.ФизЛицо
		|			ИЗ
		|				ТЗ1 КАК ТЗ1)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА НЕ РолиПользователейТипыРолей.Ссылка ЕСТЬ NULL 
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Пометка,
		|	ТипыРолейПользователя.Ссылка КАК ТипРоли,
		|	ТипыРолейПользователя.Наименование КАК Наименование,
		|	ТипыРолейПользователя.ПометкаУдаления
		|ПОМЕСТИТЬ ТЗ_3
		|ИЗ
		|	ПланВидовХарактеристик.ТипыРолейПользователя КАК ТипыРолейПользователя
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
		|		ПО ТипыРолейПользователя.Ссылка = РолиПользователейТипыРолей.ТипРоли
		|			И (РолиПользователейТипыРолей.Ссылка В
		|				(ВЫБРАТЬ
		|					ТЗ_2.Ссылка
		|				ИЗ
		|					ТЗ_2 КАК ТЗ_2))
		|ГДЕ
		|	(НЕ ТипыРолейПользователя.ПометкаУдаления
		|			ИЛИ НЕ РолиПользователейТипыРолей.Ссылка ЕСТЬ NULL )
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЗ_3.Пометка,
		|	ТЗ_3.ТипРоли,
		|	ТЗ_3.Наименование,
		|	ТЗ_3.ПометкаУдаления
		|ИЗ
		|	ТЗ_3 КАК ТЗ_3
		|ГДЕ
		|	ТЗ_3.Пометка = ИСТИНА
		//+++ AK suvv 2018.06.08 ИП-00018376.01
		//|	И ТЗ_3.ТипРоли = &ТипРоли";
	    |	И (ТЗ_3.ТипРоли = &ТипРоли или ТЗ_3.ТипРоли = &ТипРолиСторонняяРозница)";
		//--- AK suvv
	Запрос.УстановитьПараметр("Ссылка", ТекПользователь);
	Запрос.УстановитьПараметр("ТипРоли", ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего);
	//+++ AK suvv 2018.06.08 ИП-00018376.01
	Запрос.УстановитьПараметр("ТипРолиСторонняяРозница", ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы);
	//--- AK suvv
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
		ЭтоПомощник = Истина;
	КонецЕсли;	
	
	Возврат ЭтоПомощник;
		
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьПанелей()
	
	//Если КартаИсточник Тогда
	//	Элементы.ГруппаКартаСКоторойПереносим.Видимость = Истина;
	//Иначе	
	//	Элементы.ГруппаКартаСКоторойПереносим.Видимость = Ложь;
	//КонецЕсли;
	
	Если КартаПриемник Тогда
		Элементы.ГруппаКартаСКоторойПереносим1.Видимость = Истина;
	Иначе	
		Элементы.ГруппаКартаСКоторойПереносим1.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыНаСервере()
	
	ТекстЗапроса = "SELECT  *  from dbo.Customer (nolock) WHERE ";
	
	Если ЗначениеЗаполнено(Email) Тогда
		ТекстЗапроса = ТекстЗапроса +" [Email] = '"+Email+"' ";
	КонецЕсли;
	
	//Если ЗначениеЗаполнено(CustomerUID) Тогда
	//	
	//	Если ЗначениеЗаполнено(Email) Тогда
	//		ТекстЗапроса = ТекстЗапроса +" AND [CustomerUID] = '" +CustomerUID+"' ";
	//	Иначе
	//		ТекстЗапроса = ТекстЗапроса +" [CustomerUID] = '" +CustomerUID+"' ";
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
	//Если ЗначениеЗаполнено(rowguid) Тогда
	//	Если ЗначениеЗаполнено(Email) ИЛИ ЗначениеЗаполнено(CustomerUID) Тогда
	//		ТекстЗапроса = ТекстЗапроса +" AND [rowguid] = '"+ rowguid +"' ";
	//	Иначе
	//		ТекстЗапроса = ТекстЗапроса +" [rowguid] = '"+ rowguid +"' ";
	//	КонецЕсли;	
	//КонецЕсли;
	
	
	ТекстЗапроса = ТекстЗапроса +" ;";
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	Объект.Customer.Очистить();
	Объект.Customer.Загрузить(ТЗ.Скопировать());
	Объект.Customer.Сортировать("Email");
	RecordSet.Close();
	
	Если ТЗ.Количество() > 0 Тогда
		ТекСтрТЗ = ТЗ[0];
		
		Для Каждого ТекКолонка Из ТЗ.Колонки Цикл
			
			Попытка
				Если ТекКолонка.Имя = "Sex" Тогда
					
					Если ТекСтрТЗ[ТекКолонка.Имя] = 1 Тогда
						ЭтаФорма[ТекКолонка.Имя] = Перечисления.АК_Пол.Ж;
					Иначе
						ЭтаФорма[ТекКолонка.Имя] = Перечисления.АК_Пол.М;
					КонецЕсли;
				ИначеЕсли ТекКолонка.Имя = "SMS_karta_no" Тогда 	
					Если ТекСтрТЗ[ТекКолонка.Имя] = 0 Тогда
						ЭтаФорма[ТекКолонка.Имя] = Ложь;
					Иначе
						ЭтаФорма[ТекКолонка.Имя] = Истина;
					КонецЕсли;
				ИначеЕсли ТекКолонка.Имя = "MobilCarta" Тогда 	
					Если ТекСтрТЗ[ТекКолонка.Имя] = 0 Тогда
						ЭтаФорма[ТекКолонка.Имя] = Ложь;
					Иначе
						ЭтаФорма[ТекКолонка.Имя] = Истина;
					КонецЕсли;
				ИначеЕсли ТекКолонка.Имя = "id_type_cust" Тогда	
					ЭтаФорма[ТекКолонка.Имя] = Перечисления.АК_ТипыПокупателей.Получить(ТекСтрТЗ[ТекКолонка.Имя]-1);
				Иначе	
					
					ЭтаФорма[ТекКолонка.Имя] = ТекСтрТЗ[ТекКолонка.Имя];	
					
				КонецЕсли;	
				
			Исключение				
			КонецПопытки;	
			
		КонецЦикла;	
		
		Иначе
		Сообщить("Анкета по карте "+Email+" не найдена");
	КонецЕсли;
		
	//ЭтаФорма.Заголовок = "Карта покупателя: "+СокрЛП(ТекСтрТЗ.Фамилия)+" "+СокрЛП(ТекСтрТЗ.FullName);
	
	// ВСЕ SMS
	
	Объект.ТЗ_СМС_ВсеПоКлиенту.Очистить();
	
	//ТекстЗапроса = "Select *
	//|from (
	//|select convert(datetime,i.Date  + ' ' + i.Time) Дата, i.text сообщение , 'Входящее' тип
	//| from SMSGate..Incoming (nolock) i 
	//| inner join Loyalty..Customer c (nolock) on c.Phone = i.nomer
	//| inner join Loyalty..DiscountCard d (nolock) on d.CustomerUID=c.CustomerUID
	//|where d.Number=/**BPar1**/~~~~~   /**FPar**/
	//|
	//|union all 
	//|
	//|select ou.SendDate, ou.Message ,  'Наш ответ' тип
	//|from IES..Outgoing (nolock) ou 
	//| inner join Loyalty..Customer c (nolock) on '7' + c.Phone = ou.Number
	//| inner join Loyalty..DiscountCard d (nolock) on d.CustomerUID=c.CustomerUID
	//|where d.Number=/**BPar1**/~~~~~   /**FPar**/  ) a
	//|
	//|
	//|order by Дата desc;";
	
	
	// 04.08.2014
	ТекстЗапроса = " Select *
	| from (
	| select convert(datetime,i.Date  + ' ' + i.Time) Дата, i.text сообщение , 'Входящее' тип
	| from SMSGate..Incoming (nolock) i
	| inner join Loyalty..Customer c (nolock) on c.Phone = i.nomer and LEN(c.phone)=10
	| inner join Loyalty..DiscountCard d (nolock) on d.CustomerUID=c.CustomerUID
	| where d.Number=/**BPar1**/~~~~~   /**FPar**/
	| union all
	| select ou.SendDate, ou.Message ,  'Наш ответ' тип
	| from IES..Outgoing (nolock) ou
	|  inner join Loyalty..Customer c (nolock) on '7' + c.Phone = ou.Number and LEN(c.phone)=10
	| inner join Loyalty..DiscountCard d (nolock) on d.CustomerUID=c.CustomerUID
	| where d.Number=/**BPar1**/~~~~~   /**FPar**/  ) a
	| order by Дата desc;";
	
	//ID_Строки = СокрЛП(ТекСтрТЗ.rowguid);
	//ВсегоСимволов = СтрДлина(ID_Строки);
	//
	//ID_Строки = Прав(ID_Строки, ВсегоСимволов-1);
	//ID_Строки = Лев(ID_Строки, ВсегоСимволов-2);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~", "'"+Email+"'");
	
	База_ВыполнитьЗапросИЗаполнитьТаблицуЗначений(ТекстЗапроса);
	
	// ЗВОНКИ		
	//"SELECT *
	//|FROM [select * from Звонки_покупателю UNION ALL select * from Звонки_ОК_покупателя ]. AS [%$##@_Alias]
	//|ORDER BY date_call DESC;";
	
	// БАЛЛЫ ПОКУПАТЕЛЯ		
	//+++АК sils 03.07.2018 ИП-00018890
	//ТекстЗапроса = "SELECT
	//|Тип = case when Indicator.IndicatorType=1 then 'ПокСНачМес' 
	//|           else 'Баллы' end ,
	//|Indicator.Balance Сумма
	//|   
	//|  FROM [Loyalty].[dbo].Indicator
	//|  inner join [SRV-SQL01].[Loyalty].[dbo].DiscountCard on Indicator.AccountUID=DiscountCard.AccountUID 
	//|
	//|  where DiscountCard.Number=/**BPar1**/~~~~~/**FPar**/ 
	//|  and (Indicator.IndicatorType=0 or Indicator.IndicatorType=1);";
	ТекстЗапроса = "SELECT
		|	Тип = 'Баллы', 
		|	a.AccountCurrentBalance Сумма 
		|   
		|FROM Loyalty.dbo.BC_Balances As b
		|  INNER JOIN Loyalty.dbo.BC_Accounts AS a 
		|		ON b.BC_AccountID = a.BC_AccountID
		|
		|  where b.BC_Number = ~~~~~
		|UNION
		|SELECT
		|	Тип = 'ПокСНачМес', 
		|	a.Sales_ost Сумма
		|   
		|FROM Loyalty.dbo.BC_Balances As b
		|  INNER JOIN Loyalty.dbo.BC_Accounts AS a 
		|		ON b.BC_AccountID = a.BC_AccountID
		|
		|  where b.BC_Number = ~~~~~;";
	//---АК
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~","'"+Email+"'");
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();
	
	Объект.БаллыПокупателя.Очистить();
	Объект.БаллыПокупателя.Загрузить(ТЗ.Скопировать());
	
	// КАРТЫ С РАВНЫМИ КОНТАКТАМИ
	
	ТекстЗапроса = " select Customer.Email НомерКарты, Customer.FullName ФИО, Customer.Email_fact Email, Customer.Phone Тел
	| from [Loyalty].[dbo].Customer (nolock)
	| left join (select *
	| from [Loyalty].[dbo].Customer  (nolock)
	| where Customer.email=/**BPar1**/~~~~~/**FPar**/  and charindex(Customer.Email_fact,'@',1)>0) as q1 on Customer.Email_fact=q1.Email_fact 
	| left join (select *
	| from [Loyalty].[dbo].Customer  (nolock)
	| where Customer.email=/**BPar1**/~~~~~/**FPar**/ and len(Customer.Phone)=10 ) as q2 on Customer.Phone=q2.Phone
	| where Customer.email<>/**BPar1**/~~~~~/**FPar**/
	| and (q1.CustomerUID is not null or q2.CustomerUID is not null);";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~","'"+Email+"'");
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();
	
	Объект.КартыСРавнымиКонтактами.Очистить();
	Объект.КартыСРавнымиКонтактами.Загрузить(ТЗ.Скопировать());
	
	// ФИН ОПЕРАЦИИ *********************************
	//ТекстЗапроса = "select * , case when ОстатокБонусов1=0 then ОстатокБонусов2 else ОстатокБонусов1 end ОстатокБонусов
	//|from (SELECT 
	//|   d.Number,
	//|   th.ChequeUID , 
	//|   max(case when (th.PromotionProgramUID is null and th.TransactionType=1) or th.TransactionType=2 then Time  else null end) Дата,
	//|   max(case when th.PromotionProgramUID is null and th.TransactionType=1 then ShopNo  else null end) Магазин,
	//|   max(case when th.PromotionProgramUID is null and th.TransactionType=1 then s.Name  else null end) АдресМагазина,
	//|   isnull(convert(real,max(case when th.PromotionProgramUID is null and th.TransactionType=1 then th.ChequeAmount  else null end)),0) СуммаПокупки,
	//|   isnull(convert(real,sum(case when th.PromotionProgramUID is not null and th.TransactionType=1 then th.BonusValue  else null end)),0) Начислено,
	//|   isnull(convert(real,sum(case when th.TransactionType=0 then th.BonusValue  else null end)),0) Использовано,
	//|   isnull(convert(real,max(case when i.IndicatorType=0 and th.TransactionType<>0 then th.FinalBalance  else null end)),0) ОстатокБонусов1,
	//|   isnull(convert(real,min(case when i.IndicatorType=0 and th.TransactionType=0 then th.FinalBalance  else null end)),0) ОстатокБонусов2
	//|
	//|  FROM [Loyalty].[dbo].[TransactionHistory] (nolock) th
	//|  inner join [Loyalty].dbo.DiscountCard  (nolock) d on d.DiscountCardUID=th.DiscountCardUID
	//|  inner join [Loyalty].dbo.Shop  (nolock) s on th.ShopNo=s.ShopId
	//|  left join (select * from [Loyalty].dbo.Indicator  (nolock) where IndicatorType=0 ) i on th.IndicatorUID=i.IndicatorUID
	//|  
	//|  inner join ( select d.AccountUID
	//|  from Loyalty..DiscountCard (nolock) d 
	//|  where d.Number=/**BPar1**/~~~~~/**FPar**/ ) acc on acc.AccountUID=th.AccountUID
	//|
	//|  group by th.ChequeUID, d.Number ) as a
	//|  order by дата desc;";
	
	ТекстЗапроса = "declare @d as uniqueidentifier
		|select @d=d.AccountUID
		|from Loyalty..DiscountCard (nolock) d
		|where d.Number=/**BPar1**/~~~~~/**FPar**/
		|
		|exec Loyalty..spGetAcctHistoryByDateRange @d  , {d'2012-01-01'}, {d'2100-01-01'} ,0 , 0;";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~","'"+Email+"'");
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();	
	
	Объект.ФинОпераци.Очистить();
	Объект.ФинОпераци.Загрузить(ТЗ.Скопировать());		
	
	
	Элементы.ГруппаКартаСКоторойПереносим.Заголовок = "Данные по карте: " +СокрЛП(Email) +". Покупатель: "+СокрЛП(Фамилия)+" "+СокрЛП(Имя)+" "+СокрЛП(Отчество);
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьДанныеВторойКартыНаСервере()
		
	ТекстЗапроса = "SELECT  *  from dbo.Customer (nolock) WHERE ";
	
	Если ЗначениеЗаполнено(Email1) Тогда
		ТекстЗапроса = ТекстЗапроса +" [Email] = '"+Email1+"' ";
	КонецЕсли;
	
	//Если ЗначениеЗаполнено(CustomerUID1) Тогда
	//	
	//	Если ЗначениеЗаполнено(Email1) Тогда
	//		ТекстЗапроса = ТекстЗапроса +" AND [CustomerUID] = '" +CustomerUID1+"' ";
	//	Иначе
	//		ТекстЗапроса = ТекстЗапроса +" [CustomerUID] = '" +CustomerUID1+"' ";
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
	//Если ЗначениеЗаполнено(rowguid1) Тогда
	//	Если ЗначениеЗаполнено(Email) ИЛИ ЗначениеЗаполнено(CustomerUID1) Тогда
	//		ТекстЗапроса = ТекстЗапроса +" AND [rowguid] = '"+ rowguid1 +"' ";
	//	Иначе
	//		ТекстЗапроса = ТекстЗапроса +" [rowguid] = '"+ rowguid1 +"' ";
	//	КонецЕсли;	
	//КонецЕсли;
	
	
	ТекстЗапроса = ТекстЗапроса +" ;";
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	Объект.Customer1.Очистить();
	Объект.Customer1.Загрузить(ТЗ.Скопировать());
	Объект.Customer1.Сортировать("Email");
	RecordSet.Close();
	
	Если ТЗ.Количество() > 0 Тогда
		ТекСтрТЗ = ТЗ[0];
		
		Для Каждого ТекКолонка Из ТЗ.Колонки Цикл
			
			Попытка
				Если ТекКолонка.Имя = "Sex" Тогда
					
					Если ТекСтрТЗ[ТекКолонка.Имя] = 1 Тогда
						ЭтаФорма[ТекКолонка.Имя+"1"] = Перечисления.АК_Пол.Ж;
					Иначе
						ЭтаФорма[ТекКолонка.Имя+"1"] = Перечисления.АК_Пол.М;
					КонецЕсли;
				ИначеЕсли ТекКолонка.Имя = "SMS_karta_no" Тогда 	
					Если ТекСтрТЗ[ТекКолонка.Имя] = 0 Тогда
						ЭтаФорма[ТекКолонка.Имя+"1"] = Ложь;
					Иначе
						ЭтаФорма[ТекКолонка.Имя+"1"] = Истина;
					КонецЕсли;
				ИначеЕсли ТекКолонка.Имя = "MobilCarta" Тогда 	
					Если ТекСтрТЗ[ТекКолонка.Имя] = 0 Тогда
						ЭтаФорма[ТекКолонка.Имя+"1"] = Ложь;
					Иначе
						ЭтаФорма[ТекКолонка.Имя+"1"] = Истина;
					КонецЕсли;
				ИначеЕсли ТекКолонка.Имя = "id_type_cust" Тогда	
					ЭтаФорма[ТекКолонка.Имя+"1"] = Перечисления.АК_ТипыПокупателей.Получить(ТекСтрТЗ[ТекКолонка.Имя]-1);
				Иначе	
					
					ЭтаФорма[ТекКолонка.Имя+"1"] = ТекСтрТЗ[ТекКолонка.Имя];	
					
				КонецЕсли;	
				
			Исключение				
			КонецПопытки;	
			
		КонецЦикла;	
	Иначе
		
		Сообщить("Анкета по карте "+Email1+" не найдена");
		
	КонецЕсли;
	//ЭтаФорма.Заголовок = "Карта покупателя: "+СокрЛП(ТекСтрТЗ.Фамилия1)+" "+СокрЛП(ТекСтрТЗ.FullName);
	
	// ВСЕ SMS
	
	Объект.ТЗ_СМС_ВсеПоКлиенту1.Очистить();
	
	//ТекстЗапроса = "Select *
	//|from (
	//|select convert(datetime,i.Date  + ' ' + i.Time) Дата, i.text сообщение , 'Входящее' тип
	//| from SMSGate..Incoming (nolock) i 
	//| inner join Loyalty..Customer c (nolock) on c.Phone = i.nomer
	//| inner join Loyalty..DiscountCard d (nolock) on d.CustomerUID=c.CustomerUID
	//|where d.Number=/**BPar1**/~~~~~   /**FPar**/
	//|
	//|union all 
	//|
	//|select ou.SendDate, ou.Message ,  'Наш ответ' тип
	//|from IES..Outgoing (nolock) ou 
	//| inner join Loyalty..Customer c (nolock) on '7' + c.Phone = ou.Number
	//| inner join Loyalty..DiscountCard d (nolock) on d.CustomerUID=c.CustomerUID
	//|where d.Number=/**BPar1**/~~~~~   /**FPar**/  ) a
	//|
	//|
	//|order by Дата desc;";
	
	// 04.08.2014
	ТекстЗапроса = " Select *
	| from (
	| select convert(datetime,i.Date  + ' ' + i.Time) Дата, i.text сообщение , 'Входящее' тип
	| from SMSGate..Incoming (nolock) i
	| inner join Loyalty..Customer c (nolock) on c.Phone = i.nomer and LEN(c.phone)=10
	| inner join Loyalty..DiscountCard d (nolock) on d.CustomerUID=c.CustomerUID
	| where d.Number=/**BPar1**/~~~~~   /**FPar**/
	| union all
	| select ou.SendDate, ou.Message ,  'Наш ответ' тип
	| from IES..Outgoing (nolock) ou
	|  inner join Loyalty..Customer c (nolock) on '7' + c.Phone = ou.Number and LEN(c.phone)=10
	| inner join Loyalty..DiscountCard d (nolock) on d.CustomerUID=c.CustomerUID
	| where d.Number=/**BPar1**/~~~~~   /**FPar**/  ) a
	| order by Дата desc;";
	
	//ID_Строки = СокрЛП(ТекСтрТЗ.rowguid);
	//ВсегоСимволов = СтрДлина(ID_Строки);
	//
	//ID_Строки = Прав(ID_Строки, ВсегоСимволов-1);
	//ID_Строки = Лев(ID_Строки, ВсегоСимволов-2);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~", "'"+Email1+"'");
	
	База_ВыполнитьЗапросИЗаполнитьТаблицуЗначенийПовторойКарте(ТекстЗапроса);
	
	// ЗВОНКИ		
	//"SELECT *
	//|FROM [select * from Звонки_покупателю UNION ALL select * from Звонки_ОК_покупателя ]. AS [%$##@_Alias]
	//|ORDER BY date_call DESC;";
	
	// БАЛЛЫ ПОКУПАТЕЛЯ		
	//+++АК sils 03.07.2018 ИП-00018890
	//ТекстЗапроса = "SELECT
	//|Тип = case when Indicator.IndicatorType=1 then 'ПокСНачМес' 
	//|           else 'Баллы' end ,
	//|Indicator.Balance Сумма
	//|   
	//|  FROM [Loyalty].[dbo].Indicator
	//|  inner join [SRV-SQL01].[Loyalty].[dbo].DiscountCard on Indicator.AccountUID=DiscountCard.AccountUID 
	//|
	//|  where DiscountCard.Number=/**BPar1**/~~~~~/**FPar**/ 
	//|  and (Indicator.IndicatorType=0 or Indicator.IndicatorType=1);";
	ТекстЗапроса = "SELECT
		|	Тип = 'Баллы', 
		|	a.AccountCurrentBalance Сумма 
		|   
		|FROM Loyalty.dbo.BC_Balances As b
		|  INNER JOIN Loyalty.dbo.BC_Accounts AS a 
		|		ON b.BC_AccountID = a.BC_AccountID
		|
		|  where b.BC_Number = ~~~~~
		|UNION
		|SELECT
		|	Тип = 'ПокСНачМес', 
		|	a.Sales_ost Сумма
		|   
		|FROM Loyalty.dbo.BC_Balances As b
		|  INNER JOIN Loyalty.dbo.BC_Accounts AS a 
		|		ON b.BC_AccountID = a.BC_AccountID
		|
		|  where b.BC_Number = ~~~~~;";
	//---АК
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~","'"+Email1+"'");
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();
	
	Объект.БаллыПокупателя1.Очистить();
	Объект.БаллыПокупателя1.Загрузить(ТЗ.Скопировать());
	
	// КАРТЫ С РАВНЫМИ КОНТАКТАМИ
	
	ТекстЗапроса = " select Customer.Email НомерКарты, Customer.FullName ФИО, Customer.Email_fact Email, Customer.Phone Тел
	| from [Loyalty].[dbo].Customer (nolock)
	| left join (select *
	| from [Loyalty].[dbo].Customer  (nolock)
	| where Customer.email=/**BPar1**/~~~~~/**FPar**/  and charindex(Customer.Email_fact,'@',1)>0) as q1 on Customer.Email_fact=q1.Email_fact 
	| left join (select *
	| from [Loyalty].[dbo].Customer  (nolock)
	| where Customer.email=/**BPar1**/~~~~~/**FPar**/ and len(Customer.Phone)=10 ) as q2 on Customer.Phone=q2.Phone
	| where Customer.email<>/**BPar1**/~~~~~/**FPar**/
	| and (q1.CustomerUID is not null or q2.CustomerUID is not null);";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~","'"+Email1+"'");
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();
	
	Объект.КартыСРавнымиКонтактами1.Очистить();
	Объект.КартыСРавнымиКонтактами1.Загрузить(ТЗ.Скопировать());
	
	// ФИН ОПЕРАЦИИ *********************************
	//ТекстЗапроса = "select * , case when ОстатокБонусов1=0 then ОстатокБонусов2 else ОстатокБонусов1 end ОстатокБонусов
	//|from (SELECT 
	//|   d.Number,
	//|   th.ChequeUID , 
	//|   max(case when (th.PromotionProgramUID is null and th.TransactionType=1) or th.TransactionType=2 then Time  else null end) Дата,
	//|   max(case when th.PromotionProgramUID is null and th.TransactionType=1 then ShopNo  else null end) Магазин,
	//|   max(case when th.PromotionProgramUID is null and th.TransactionType=1 then s.Name  else null end) АдресМагазина,
	//|   isnull(convert(real,max(case when th.PromotionProgramUID is null and th.TransactionType=1 then th.ChequeAmount  else null end)),0) СуммаПокупки,
	//|   isnull(convert(real,sum(case when th.PromotionProgramUID is not null and th.TransactionType=1 then th.BonusValue  else null end)),0) Начислено,
	//|   isnull(convert(real,sum(case when th.TransactionType=0 then th.BonusValue  else null end)),0) Использовано,
	//|   isnull(convert(real,max(case when i.IndicatorType=0 and th.TransactionType<>0 then th.FinalBalance  else null end)),0) ОстатокБонусов1,
	//|   isnull(convert(real,min(case when i.IndicatorType=0 and th.TransactionType=0 then th.FinalBalance  else null end)),0) ОстатокБонусов2
	//|
	//|  FROM [Loyalty].[dbo].[TransactionHistory] (nolock) th
	//|  inner join [Loyalty].dbo.DiscountCard  (nolock) d on d.DiscountCardUID=th.DiscountCardUID
	//|  inner join [Loyalty].dbo.Shop  (nolock) s on th.ShopNo=s.ShopId
	//|  left join (select * from [Loyalty].dbo.Indicator  (nolock) where IndicatorType=0 ) i on th.IndicatorUID=i.IndicatorUID
	//|  
	//|  inner join ( select d.AccountUID
	//|  from Loyalty..DiscountCard (nolock) d 
	//|  where d.Number=/**BPar1**/~~~~~/**FPar**/ ) acc on acc.AccountUID=th.AccountUID
	//|
	//|  group by th.ChequeUID, d.Number ) as a
	//|  order by дата desc;";
	
	ТекстЗапроса = "declare @d as uniqueidentifier
		|select @d=d.AccountUID
		|from Loyalty..DiscountCard (nolock) d
		|where d.Number=/**BPar1**/~~~~~/**FPar**/
		|
		|exec Loyalty..spGetAcctHistoryByDateRange @d  , {d'2012-01-01'}, {d'2100-01-01'} ,0 , 0;";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~","'"+Email1+"'");
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();	
	
	Объект.ФинОпераци1.Очистить();
	Объект.ФинОпераци1.Загрузить(ТЗ.Скопировать());		
	
	
	
	Элементы.ГруппаКартаСКоторойПереносим1.Заголовок = "Карта: " +СокрЛП(Email1) +". Покупатель: "+СокрЛП(Фамилия1)+" "+СокрЛП(Имя1)+" "+СокрЛП(Отчество1); 
	
КонецПроцедуры	



&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность И Вопрос("Данные были изменены, хотите записать их в базу?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		//Состояние("Идёт запись данных... Ожидайте.");
		//ЗаписатьДанныеКлиентаНаСервере();
		//Состояние("");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеКлиентаНаСервере()
	
	
	ВремТЗ = Объект.Customer.Выгрузить();
	
	ТаблИзменений = Новый ТаблицаЗначений;
	ТаблИзменений.Колонки.Добавить("КлючСтроки");
	ТаблИзменений.Колонки.Добавить("ЗначениеСтроки");
	ТаблИзменений.Колонки.Добавить("ЗначениеСтрокиСтарое");
	
	Для каждого ТекКолонка Из ВремТЗ.Колонки Цикл
		
		Попытка
			Если ТекКолонка.Имя = "Sex" Тогда
				
				Если ЭтаФорма.Sex = Перечисления.АК_Пол.Ж Тогда
					ТекЗначение = 1;
				Иначе
					ТекЗначение = 0;
				КонецЕсли;	
					
				
			ИначеЕсли ТекКолонка.Имя = "id_type_cust" Тогда
				
				Если ЭтаФорма.id_type_cust = Перечисления.АК_ТипыПокупателей.ГорячийПоклонник Тогда
					ТекЗначение = 1;
				ИначеЕсли ЭтаФорма.id_type_cust = Перечисления.АК_ТипыПокупателей.Нейтральный Тогда
					ТекЗначение = 2;
				ИначеЕсли ЭтаФорма.id_type_cust = Перечисления.АК_ТипыПокупателей.НеБеспокоить Тогда
					ТекЗначение = 3;
				Иначе
					ТекЗначение = 4;
				КонецЕсли;					
				
				
			ИначеЕсли ТекКолонка.Имя = "MobilCarta" Тогда
				
				Если ЭтаФорма[ТекКолонка.Имя] Тогда
					ТекЗначение = 1;	
				Иначе	
					ТекЗначение = 0;
				КонецЕсли;
				
			ИначеЕсли ТекКолонка.Имя = "SMS_karta_no" Тогда
				
				Если ЭтаФорма[ТекКолонка.Имя] Тогда
					ТекЗначение = 1;	
				Иначе	
					ТекЗначение = 0;
				КонецЕсли;	
				
			Иначе	
				ТекЗначение = ЭтаФорма[ТекКолонка.Имя];
			КонецЕсли;	
			
			Если ТекЗначение <> ВремТЗ[0][ТекКолонка.Имя] Тогда
				НоваяСтрока = ТаблИзменений.Добавить();
				
				НоваяСтрока.КлючСтроки = ТекКолонка.Имя;
				НоваяСтрока.ЗначениеСтроки = ТекЗначение;
				НоваяСтрока.ЗначениеСтрокиСтарое = ВремТЗ[0][ТекКолонка.Имя];
				
			КонецЕсли;				
			
		Исключение
			
		КонецПопытки;	
		
	КонецЦикла;
	
	Для каждого ТекСтрИзменений Из ТаблИзменений Цикл
		
		ТекстЗапроса = " UPDATE dbo.Customer ";
 	    ТекстЗапроса = ТекстЗапроса + " SET "+ТекСтрИзменений.КлючСтроки+" = '"+ТекСтрИзменений.ЗначениеСтроки+"' ";
		
		Если ЗначениеЗаполнено(Email) Тогда
			ТекстЗапроса = ТекстЗапроса +" WHERE [Email] = '"+Email+"' ";
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса +" ;";
		
		СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
		
		База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, Неопределено, СтрокаПодключения);
				
		ТекстЗапроса ="INSERT INTO [Loyalty].[dbo].[customer_hystory]([user_change], [date_change], [field_change], [value_old], [Number]) VALUES ('"+ПараметрыСеанса.ТекущийПользователь+"','"+ТекущаяДата()+"','"+ТекСтрИзменений.КлючСтроки+"','"+ТекСтрИзменений.ЗначениеСтрокиСтарое+"','"+Email+"' );";
		//'"+" (SELECT (SELECT MAX([id_cust_hyst]) FROM [Loyalty].[dbo].[customer_hystory]) + 1) "+"'
		База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, Неопределено, СтрокаПодключения);
		
 	КонецЦикла;	
		
КонецПроцедуры	

&НаКлиенте
Процедура ФинОперациВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Состояние("Идёт выборка данных по чеку... Ожидайте!");
	ТекID = Объект.ФинОпераци[ВыбраннаяСтрока].CheckUID;
	ТекМагазин = Объект.ФинОпераци[ВыбраннаяСтрока].ShopNo;
	ТекСуммаЧека = Объект.ФинОпераци[ВыбраннаяСтрока].ChequeAmount;
	ТекNumber = Объект.ФинОпераци[ВыбраннаяСтрока].CardNum;
	ТекDateTimeStamp = Объект.ФинОпераци[ВыбраннаяСтрока].DateTimeStamp;
	Табл = ФинОперациВыборНаСервере(ТекID, ТекМагазин, ТекСуммаЧека, ТекNumber, ТекDateTimeStamp);
	Состояние("");
	
	Табл.Показать("Чек_unf ");

	
КонецПроцедуры

&НаСервере
Функция ФинОперациВыборНаСервере(ТекID, ТекМагазин, ТекСуммаЧека, ТекNumber, ТекDateTimeStamp)
	
	ТекстЗапроса = "Select  *
	|from
	|(select chl.CashCheckLineNo N_строки, t.Name_tov Товар, chl.Quantity Колво, 
	|round(chl.BaseSum / chl.Quantity,2) Цена, chl.BaseSum Сумма , chl.BasePrice РознЦена
	|from SMS_IZBENKA..Checkline chl (nolock)
	|inner join M2..Tovari t on t.id_tov = chl.id_tov_cl
	|where chl.CheckUID = '~~~~~'
	|
	|union all
	|
	|select chl.CashCheckLineNo , t.Name_tov , chl.Quantity , 
	|chl.BasePrice , chl.BaseSum , chl.Price_retail
	|from SMS_union..Checkline chl (nolock)
	|inner join M2..Tovari t on t.id_tov = chl.id_tov_cl
	|where chl.CheckUID = '~~~~~') a
	|order by a.N_строки;";
	
	ВсегоДл = СтрДлина(ТекID);	
	ТекID = Лев(ТекID, ВсегоДл -1);
	ВсегоДл = СтрДлина(ТекID);
	ТекID = Прав(ТекID, ВсегоДл -1);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~", ТекID);
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, Неопределено, СтрокаПодключения);	
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();
		
	ТЗ.Колонки.Удалить("N_строки");
	Табл = Новый ТабличныйДокумент;
	Макет = ПолучитьОбщийМакет(Метаданные.ОбщиеМакеты.АК_ПечатьТаблицЗначений);
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапкаОсновной=Макет.ПолучитьОбласть("Шапка|Основной");
	ОбластьСтрокаОсновной=Макет.ПолучитьОбласть("Строка|Основной");
	ОбластьИтогОсновной=Макет.ПолучитьОбласть("Итог|Основной");
	ОбластьШапкаДОП=Макет.ПолучитьОбласть("Шапка|Показатели");
	ОбластьСтрокаДОП=Макет.ПолучитьОбласть("Строка|Показатели");
	ОбластьИтогДОП=Макет.ПолучитьОбласть("Итог|Показатели");
	
	
	ОбластьЗаголовок.Параметры.Заголовок = "Чек_unf ";
	Табл.Вывести(ОбластьЗаголовок);
	
	Табл.Вывести(ОбластьШапкаОсновной);
	
	Для Каждого Колонка из Тз.Колонки ЦИКЛ
		ОбластьШапкаДОП.Параметры.ИмяПоказателя=Колонка.Имя;
		Табл.Присоединить(ОбластьШапкаДОП);
	КонецЦикла;
	
	счетчик=0;
	Для каждого стр из Тз Цикл
		счетчик=счетчик+1;
		ОбластьСтрокаОсновной.Параметры.счетчик=счетчик; 
		Табл.Вывести(ОбластьСтрокаОсновной);
		Для Каждого Колонка из Тз.Колонки ЦИКЛ
			ОбластьСтрокаДОП.Параметры.ЗначениеКолонки=Формат(стр[Колонка.Имя],"ЧДЦ=2; ЧН=0,00; ЧГ=0");
			Табл.Присоединить(ОбластьСтрокаДОП);
		КонецЦикла;
	КонецЦикла;
	//Табл.Вывести(ОбластьИтогОсновной);
	
	//Для Каждого Колонка из Тз.Колонки ЦИКЛ
	//	ОбластьИтогДОП.Параметры.Итог=Формат(Тз.Итог(Колонка.Имя),"ЧДЦ=2; ЧН=0,00; ЧГ=0");
	//	Табл.Присоединить(ОбластьИтогДОП);
	//КонецЦикла;
	
	
	//Табл.Защита = Истина;
	//Табл.ОтображатьЗаголовки = Ложь;
	Табл.ОтображатьСетку = Ложь;
	Возврат Табл;
		
КонецФункции

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	
	Состояние("Идёт обновление данных формы. Ожидайте...");
	
	//Email = Параметры.Email;
	//CustomerUID = Параметры.CustomerUID;
	//rowguid = Параметры.rowguid;
	Если ЗначениеЗаполнено(Email) И ЗначениеЗаполнено(Email1) Тогда
		
		Для каждого ТекЭлемент Из ЭтаФорма.Элементы Цикл
  
  	    	ТекИмяЭлемента = ТекЭлемент.Имя;
			Если ТекИмяЭлемента = "Email" ИЛИ ТекИмяЭлемента = "Email1" Тогда
				Продолжить;
			КонецЕсли;
			
			Попытка
				ЭтаФорма[ТекИмяЭлемента] = Неопределено;
			Исключение
			КонецПопытки;
			
  		КонецЦикла;
		
		Объект.Customer.Очистить();
		Объект.Customer1.Очистить();
		Объект.БаллыПокупателя.Очистить();
		Объект.БаллыПокупателя1.Очистить();
		Объект.ЗвонкиПокупателяВсе.Очистить();
		Объект.ЗвонкиПокупателяВсе1.Очистить();
		Объект.КартыСРавнымиКонтактами.Очистить();
		Объект.КартыСРавнымиКонтактами1.Очистить();
		Объект.ТЗ_СМС_ВсеПоКлиенту.Очистить();
		Объект.КартыСРавнымиКонтактами1.Очистить();
		Объект.ТЗ_СМС_ВсеПоКлиенту.Очистить();
		Объект.ТЗ_СМС_ВсеПоКлиенту1.Очистить();
		Объект.ФинОпераци.Очистить();
		Объект.ФинОпераци1.Очистить();
		
		ЗаполнитьДанныеФормыНаСервере();
		ЗаполнитьДанныеВторойКартыНаСервере();
	Иначе
		Предупреждение("Должны быть заполнены номера карты источника и приёмника!");
	КонецЕсли;
	
	//Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанные_Автомат()
	
	Состояние("Идёт обновление данных формы. Ожидайте...");
	
	Если ЗначениеЗаполнено(Email) И ЗначениеЗаполнено(Email1) Тогда
		
		Для каждого ТекЭлемент Из ЭтаФорма.Элементы Цикл
  
  	    	ТекИмяЭлемента = ТекЭлемент.Имя;
			Если ТекИмяЭлемента = "Email" ИЛИ ТекИмяЭлемента = "Email1" Тогда
				Продолжить;
			КонецЕсли;
			
			Попытка
				ЭтаФорма[ТекИмяЭлемента] = Неопределено;
			Исключение
			КонецПопытки;
			
  		КонецЦикла;
		
		Объект.Customer.Очистить();
		Объект.Customer1.Очистить();
		Объект.БаллыПокупателя.Очистить();
		Объект.БаллыПокупателя1.Очистить();
		Объект.ЗвонкиПокупателяВсе.Очистить();
		Объект.ЗвонкиПокупателяВсе1.Очистить();
		Объект.КартыСРавнымиКонтактами.Очистить();
		Объект.КартыСРавнымиКонтактами1.Очистить();
		Объект.ТЗ_СМС_ВсеПоКлиенту.Очистить();
		Объект.КартыСРавнымиКонтактами1.Очистить();
		Объект.ТЗ_СМС_ВсеПоКлиенту.Очистить();
		Объект.ТЗ_СМС_ВсеПоКлиенту1.Очистить();
		Объект.ФинОпераци.Очистить();
		Объект.ФинОпераци1.Очистить();
		
		ЗаполнитьДанныеФормыНаСервере();
		ЗаполнитьДанныеВторойКартыНаСервере();
	Иначе
	//	Предупреждение("Должны быть заполнены номера карты источника и приёмника!");
	КонецЕсли;
	
	//Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиИзСтарогоНаПустыеНового(Команда)
	
	Состояние("Идёт обработка. Ожидайте...");
	ПеренестиИзСтарогоНаПустыеНовогоНаСервере();	
	Состояние("Идёт обновление данных формы. Ожидайте...");
	ОбновитьДанные(Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиИзСтарогоНаПустыеНовогоНаСервере()	
		
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиОперации(Команда)
	
	Состояние("Идёт обработка. Ожидайте...");
	ПеренестиОперацииНаСервере();
	Состояние("Идёт обновление данных формы. Ожидайте...");
	ОбновитьДанные(Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиОперацииНаСервере()
	
	//Если Объект.Customer.Количество() > 0 И ЗначениеЗаполнено(Объект.Customer[0].CustomerUID) Тогда 
		
		СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
		
		//ТекстЗапроса = "SET NOCOUNT ON		
		//| declare @c_old uniqueidentifier
		//|declare @c_new uniqueidentifier
		//|declare @a_new uniqueidentifier
		//|declare @i0_new uniqueidentifier
		//|declare @i1_new uniqueidentifier
		//|
		//|SELECT @c_old = [DiscountCardUID]
		//|   FROM [Loyalty].[dbo].[DiscountCard]
		//|where [DiscountCard].Number=/**BPar1**/'~~~~~'/**FPar**/ 
		//|
		//|SELECT @c_new = [DiscountCardUID], @a_new=[DiscountCard].AccountUID
		//|, @i0_new=i0.IndicatorUID , @i1_new=i1.IndicatorUID  
		//|   FROM [Loyalty].[dbo].[DiscountCard]
		//|  inner join (select * from [Loyalty].[dbo].Indicator where IndicatorType=0) i0 on [DiscountCard].AccountUID =i0.AccountUID
		//|  inner join (select * from [Loyalty].[dbo].Indicator where IndicatorType=1) i1 on [DiscountCard].AccountUID =i1.AccountUID
		//|where [DiscountCard].Number=/**BPar2**/'^^^^^'/**FPar**/ 
		//|
		//|update [Loyalty].[dbo].Customer
		//|set Customer.id_type_cust=4 
		//|from [Loyalty].[dbo].Customer
		//|inner join [Loyalty].[dbo].[DiscountCard] dc on dc.CustomerUID=Customer.CustomerUID
		//|where dc.DiscountCardUID=@c_old 
		//|
		//|-- сделать архив старых записей
		//|insert into [Loyalty].[dbo].[TransactionHistory_join]
		//| SELECT *
		//|FROM [Loyalty].[dbo].[TransactionHistory] (nolock)
		//|where [TransactionHistory].DiscountCardUID=@c_old
		//|
		//|-- заменить в tranzact старый код на новый
		//|update [Loyalty].[dbo].[TransactionHistory]
		//|set [DiscountCardUID] = @c_new
		//|      ,[AccountUID] = @a_new
		//|      ,[IndicatorUID] = case 
		//|when TransactionType=1 and PromotionProgramUID is null then  @i1_new
		//|else @i0_new
		//|end                       
		//|where DiscountCardUID=@c_old
		//|
		//|update [SMS_UNION].dbo.Checks
		//|set Checks.BONUSCARD=/**BPar2**/'^^^^^'/**FPar**/ 
		//|where Checks.BONUSCARD=/**BPar1**/'~~~~~'/**FPar**/ 
		//|
		//|update [SMS_IZBENKA].dbo.Checks
		//|set Checks.BONUSCARD=/**BPar2**/'^^^^^'/**FPar**/ 
		//|where Checks.BONUSCARD=/**BPar1**/'~~~~~'/**FPar**/;";
		
		//ТекстЗапроса = "declare @c_old uniqueidentifier
		//|declare @c_new uniqueidentifier
		//|declare @a_new uniqueidentifier
		//|declare @i0_new uniqueidentifier
		//|declare @i1_new uniqueidentifier
		//|
		//|SELECT @c_old = [DiscountCardUID]
		//|FROM [Loyalty].[dbo].[DiscountCard]
		//|where [DiscountCard].Number=/**BPar1**/'~~~~~'/**FPar**/
		//|
		//|SELECT @c_new = [DiscountCardUID], @a_new=[DiscountCard].AccountUID
		//|, @i0_new=i0.IndicatorUID , @i1_new=i1.IndicatorUID
		//|FROM [Loyalty].[dbo].[DiscountCard]
		//|inner join (select * from [Loyalty].[dbo].Indicator where IndicatorType=0) i0 on [DiscountCard].AccountUID =i0.AccountUID
		//|inner join (select * from [Loyalty].[dbo].Indicator where IndicatorType=1) i1 on [DiscountCard].AccountUID =i1.AccountUID
		//|where [DiscountCard].Number=/**BPar2**/'^^^^^'/**FPar**/
		//|
		//|update [Loyalty].[dbo].Customer
		//|set Customer.id_type_cust=4
		//|from [Loyalty].[dbo].Customer
		//|inner join [Loyalty].[dbo].[DiscountCard] dc on dc.CustomerUID=Customer.CustomerUID
		//|where dc.DiscountCardUID=@c_old
		//|
		//|insert into [Loyalty].[dbo].[TransactionHistory_join]
		//|SELECT *
		//|FROM [Loyalty].[dbo].[TransactionHistory] (nolock)
		//|where [TransactionHistory].DiscountCardUID=@c_old
		//|
		//|/*update в курсоре - начало*/
		//|DECLARE @th_UID uniqueidentifier
		//|
		//|DECLARE cursor_th CURSOR FOR  
		//| select th.TransactionHistoryUID 
		//| from [Loyalty].[dbo].[TransactionHistory] (nolock) th
		//| where th.DiscountCardUID=@c_old
		//|
		//|OPEN cursor_th 
		//| FETCH NEXT FROM  cursor_th INTO @th_UID
		//|
		//| WHILE @@FETCH_STATUS = 0  
		//| BEGIN 
		//|  update [Loyalty].[dbo].[TransactionHistory]
		//|  set [DiscountCardUID] = @c_new
		//|  ,[AccountUID] = @a_new
		//|  ,[IndicatorUID] = case
		//|  when th.TransactionType=1 and th.PromotionProgramUID is null then @i1_new
		//|  else @i0_new
		//|  end
		//|  from [Loyalty].[dbo].[TransactionHistory] (nolock) th
		//|  where th.TransactionHistoryUID=@th_UID
		//|
		//|  FETCH NEXT FROM  cursor_th 
		//|     INTO @th_UID
		//| END 
		//|
		//|CLOSE cursor_th 
		//|DEALLOCATE cursor_th
		//|/*update в курсоре - конец*/
		//|
		//|update [SMS_UNION].dbo.Checks
		//|set Checks.BONUSCARD=/**BPar2**/'^^^^^'/**FPar**/
		//|where Checks.BONUSCARD=/**BPar1**/'~~~~~'/**FPar**/
		//|update [SMS_IZBENKA].dbo.Checks
		//|set Checks.BONUSCARD=/**BPar2**/'^^^^^'/**FPar**/
		//|where Checks.BONUSCARD=/**BPar1**/'~~~~~'/**FPar**/;";
		
		
		//ТекстЗапроса = "declare @bc_old nvarchar (7) = '~~~~~'
		//|
		//|declare @bc_new nvarchar (7) = '^^^^^'
		//|
		//|declare @c_old uniqueidentifier
		//|
		//|declare @c_new uniqueidentifier
		//|
		//|declare @a_new uniqueidentifier
		//|
		//|declare @i0_new uniqueidentifier
		//|
		//|declare @i1_new uniqueidentifier
		//|
		//|/*заполняем необходимые параметры*/
		//|
		//|SELECT @c_old = [DiscountCardUID]
		//|
		//|FROM [Loyalty].[dbo].[DiscountCard]
		//|
		//|where [DiscountCard].Number=@bc_old
		//|
		//|SELECT @c_new = [DiscountCardUID], @a_new=[DiscountCard].AccountUID
		//|
		//|, @i0_new=i0.IndicatorUID , @i1_new=i1.IndicatorUID
		//|
		//|FROM [Loyalty].[dbo].[DiscountCard]
		//|
		//|inner join (select * from [Loyalty].[dbo].Indicator where IndicatorType=0) i0 on [DiscountCard].AccountUID =i0.AccountUID
		//|
		//|inner join (select * from [Loyalty].[dbo].Indicator where IndicatorType=1) i1 on [DiscountCard].AccountUID =i1.AccountUID
		//|
		//|where [DiscountCard].Number=@bc_new
		//|
		//|/*меняем BONUSCARD в чеках Вкусвилл*/
		//|
		//|DECLARE @Union_ChkUID uniqueidentifier
		//|
		//|DECLARE cursor_union CURSOR FOR  
		//|
		//| select CheckUID from [SMS_UNION].dbo.Checks
		//|
		//| where Checks.BONUSCARD=@bc_old
		//|
		//|OPEN cursor_union 
		//|
		//| FETCH NEXT FROM  cursor_union INTO @Union_ChkUID
		//|
		//| WHILE @@FETCH_STATUS = 0  
		//|
		//| BEGIN 
		//| 
		//|
		//|            update [SMS_UNION].dbo.Checks
		//|
		//|            set Checks.BONUSCARD=@bc_new
		//|
		//|            where Checks.CheckUID=@Union_ChkUID
		//|
		//|            FETCH NEXT FROM  cursor_union INTO @Union_ChkUID
		//|
		//| END 
		//|
		//|DEALLOCATE cursor_union
		//|
		//| 
		//|
		//|/*меняем BONUSCARD в чеках избенки*/
		//|
		//|DECLARE @IZBENKA_ChkUID uniqueidentifier
		//|
		//|DECLARE cursor_IZBENKA CURSOR FOR  
		//|
		//| select CheckUID from [SMS_IZBENKA].dbo.Checks
		//|
		//| where Checks.BONUSCARD=@bc_old
		//| OPEN cursor_IZBENKA
		//|
		//| FETCH NEXT FROM  cursor_IZBENKA INTO @IZBENKA_ChkUID
		//| WHILE @@FETCH_STATUS = 0  
		//|
		//| BEGIN 
		//|            update [SMS_IZBENKA].dbo.Checks
		//|
		//|            set Checks.BONUSCARD=@bc_new
		//|
		//|            where Checks.CheckUID=@Union_ChkUID
		//|
		//|            FETCH NEXT FROM  cursor_IZBENKA INTO @IZBENKA_ChkUID
		//|
		//| END 
		//|
		//|DEALLOCATE cursor_IZBENKA
		//|/*
		//|
		//|после замены в чеках триггер поменяет в th записи по начислению баллов
		//|
		//|остается поменять хвосты в th. 
		//|
		//|*/
		//|
		//|update [Loyalty].[dbo].Customer
		//|
		//|set Customer.id_type_cust=4
		//|
		//|from [Loyalty].[dbo].Customer
		//|
		//|inner join [Loyalty].[dbo].[DiscountCard] dc on dc.CustomerUID=Customer.CustomerUID
		//|
		//|where dc.DiscountCardUID=@c_old
		//|insert into [Loyalty].[dbo].[TransactionHistory_join]
		//|
		//|SELECT *
		//|
		//|FROM [Loyalty].[dbo].[TransactionHistory] (nolock)
		//|
		//|where [TransactionHistory].DiscountCardUID=@c_old
		//|DECLARE @th_UID uniqueidentifier
		//|DECLARE cursor_th CURSOR FOR  
		//|
		//| select th.TransactionHistoryUID 
		//|
		//| from [Loyalty].[dbo].[TransactionHistory] (nolock) th
		//|
		//| where th.DiscountCardUID=@c_old
		//|OPEN cursor_th 
		//| FETCH NEXT FROM  cursor_th INTO @th_UID
		//| WHILE @@FETCH_STATUS = 0  
		//| BEGIN 
		//|  update [Loyalty].[dbo].[TransactionHistory]
		//|  set [DiscountCardUID] = @c_new
		//|  ,[AccountUID] = @a_new
		//|  ,[IndicatorUID] = case
		//|  when th.TransactionType=1 and th.PromotionProgramUID is null then @i1_new
		//|  else @i0_new
		//|  end
		//|  from [Loyalty].[dbo].[TransactionHistory] (nolock) th
		//|  where th.TransactionHistoryUID=@th_UID
		//|  FETCH NEXT FROM  cursor_th 
		//|     INTO @th_UID
		//| END 
		//|CLOSE cursor_th 
		//|DEALLOCATE cursor_th";
		
		//// 15.07.2014 По просьбе Андрея Кривенко
		//ТекстЗапроса = "declare @bc_old nvarchar (7) = '~~~~~'
		//
		//|declare @bc_new nvarchar (7) = '^^^^^'
		//|
		//|declare @c_old uniqueidentifier
		//|
		//|declare @c_new uniqueidentifier
		//|
		//|declare @a_new uniqueidentifier
		//|
		//|declare @i0_new uniqueidentifier
		//|
		//|declare @i1_new uniqueidentifier
		//|
		//|/*g`onkmel menaundhl{e o`p`lerp{*/
		//|
		//|SELECT @c_old = [DiscountCardUID]
		//|
		//|FROM [Loyalty].[dbo].[DiscountCard]
		//|
		//|where [DiscountCard].Number=@bc_old
		//|
		//|SELECT @c_new = [DiscountCardUID], @a_new=[DiscountCard].AccountUID
		//|
		//|, @i0_new=i0.IndicatorUID , @i1_new=i1.IndicatorUID
		//|
		//|FROM [Loyalty].[dbo].[DiscountCard]
		//|
		//|inner join (select * from [Loyalty].[dbo].Indicator where IndicatorType=0) i0 on [DiscountCard].AccountUID =i0.AccountUID
		//|
		//|inner join (select * from [Loyalty].[dbo].Indicator where IndicatorType=1) i1 on [DiscountCard].AccountUID =i1.AccountUID
		//|
		//|where [DiscountCard].Number=@bc_new
		//|
		//|
		//|/*lemel BONUSCARD b wej`u Bjsqbhkk*/
		//|
		//|DECLARE @Union_ChkUID uniqueidentifier
		//|
		//|DECLARE cursor_union CURSOR FOR  
		//|
		//| select CheckUID from [SMS_UNION].dbo.Checks
		//|
		//| where Checks.BONUSCARD=@bc_old
		//|
		//|OPEN cursor_union 
		//|
		//| FETCH NEXT FROM  cursor_union INTO @Union_ChkUID
		//|
		//| WHILE @@FETCH_STATUS = 0  
		//|
		//| BEGIN 
		//| 
		//|
		//|            update [SMS_UNION].dbo.Checks
		//|
		//|            set Checks.BONUSCARD=@bc_new
		//|
		//|            where Checks.CheckUID=@Union_ChkUID
		//|
		//|            FETCH NEXT FROM  cursor_union INTO @Union_ChkUID
		//|
		//| END 
		//|
		//|DEALLOCATE cursor_union
		//|
		//| 
		//|
		//|/*lemel BONUSCARD b wej`u hgaemjh*/
		//|
		//|DECLARE @IZBENKA_ChkUID uniqueidentifier
		//|
		//|DECLARE cursor_IZBENKA CURSOR FOR  
		//|
		//| select CheckUID from [SMS_IZBENKA].dbo.Checks
		//|
		//| where Checks.BONUSCARD=@bc_old
		//| OPEN cursor_IZBENKA
		//|
		//| FETCH NEXT FROM  cursor_IZBENKA INTO @IZBENKA_ChkUID
		//| WHILE @@FETCH_STATUS = 0  
		//|
		//| BEGIN 
		//|            update [SMS_IZBENKA].dbo.Checks
		//|
		//|            set Checks.BONUSCARD=@bc_new
		//|
		//|            where Checks.CheckUID=@IZBENKA_ChkUID
		//|
		//|            FETCH NEXT FROM  cursor_IZBENKA INTO @IZBENKA_ChkUID
		//|
		//| END 
		//|
		//|DEALLOCATE cursor_IZBENKA
		//|/*
		//|
		//|onqke g`lem{ b wej`u rphccep onlemer b th g`ohqh on m`whqkemh~ a`kknb
		//|
		//|nqr`erq onlemr| ubnqr{ b th. 
		//|
		//|*/
		//|
		//|update [Loyalty].[dbo].Customer
		//|
		//|set Customer.id_type_cust=4
		//|
		//|from [Loyalty].[dbo].Customer
		//|
		//|inner join [Loyalty].[dbo].[DiscountCard] dc on dc.CustomerUID=Customer.CustomerUID
		//|
		//|where dc.DiscountCardUID=@c_old
		//|insert into [Loyalty].[dbo].[TransactionHistory_join]
		//|
		//|SELECT *
		//|
		//|FROM [Loyalty].[dbo].[TransactionHistory] (nolock)
		//|
		//|where [TransactionHistory].DiscountCardUID=@c_old
		//|DECLARE @th_UID uniqueidentifier
		//|DECLARE cursor_th CURSOR FOR  
		//|
		//| select th.TransactionHistoryUID 
		//|
		//| from [Loyalty].[dbo].[TransactionHistory] (nolock) th
		//|
		//| where th.DiscountCardUID=@c_old
		//|OPEN cursor_th 
		//| FETCH NEXT FROM  cursor_th INTO @th_UID
		//| WHILE @@FETCH_STATUS = 0  
		//| BEGIN 
		//|  update [Loyalty].[dbo].[TransactionHistory]
		//|  set [DiscountCardUID] = @c_new
		//|  ,[AccountUID] = @a_new
		//|  ,[IndicatorUID] = case
		//|  when th.TransactionType=1 and th.PromotionProgramUID is null then @i1_new
		//|  else @i0_new
		//|  end
		//|  from [Loyalty].[dbo].[TransactionHistory] (nolock) th
		//|  where th.TransactionHistoryUID=@th_UID
		//|  FETCH NEXT FROM  cursor_th 
		//|     INTO @th_UID
		//| END 
		//|CLOSE cursor_th 
		//|DEALLOCATE cursor_th
		//|
		//|insert into [Loyalty].[dbo].[Join_customer]
		//|       ([OLD_number]
		//|      ,[New_number]
		//|      ,[CustomerUID_old]
		//|      ,[CustomerUID_new]
		//|      ,[user_join]
		//|      ,[date_join]
		//|      ,[is_join])
		//|select @bc_old , @bc_new , @c_old , @c_new , '1c' , GETDATE() , 1";
		
		// 04.08.2014
		ТекстЗапроса = "insert into [jobs].[dbo].[Jobs]
      		|([job_name]
      		|,[prefix_job]
      		|)
			|select 'loyalty..perenos_cards_all' , '~~~~~|^^^^^'";
			
			лкEmail = Email;
			лкEmail_1 = Email1;
		//KL ITseboev + 18.12.2018 ИП-00020715 в связи с использованием букв
		//в номере карты делать преобразование в число более не возможно 	
		//лкEmail = Формат(Число(лкEmail), "ЧГ=0");	
		//лкEmail_1 = Формат(Число(лкEmail_1), "ЧГ=0");
		лкEmail = СокрЛП(лкEmail);	
		лкEmail_1 = СокрЛП(лкEmail_1);
		//KL ITseboev - 18.12.2018 ИП-00020715
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~", лкEmail);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "^^^^^", лкEmail_1);
		//ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~", "'" + лкEmail + "'");
		//ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "^^^^^", "'" + лкEmail_1 + "'");
		
		ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение("10.0.0.40");
	
		Если ADOСоединение = Неопределено Тогда
			Возврат;
		КонецЕсли;

		ADOСоединение.Execute(ТекстЗапроса);	
		ADOСоединение.Close();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбращенияКПокупателям.id_3p,
		|	ОбращенияКПокупателям.GUID_Загрузки,
		|	ОбращенияКПокупателям.КтоЗвонил
		|ИЗ
		|	РегистрСведений.ОбращенияКПокупателям КАК ОбращенияКПокупателям
		|ГДЕ
		|	ОбращенияКПокупателям.НомерКарты_3p = &НомерКарты_3p";
		
		Запрос.УстановитьПараметр("НомерКарты_3p", Email);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Набор = РегистрыСведений.ОбращенияКПокупателям.СоздатьНаборЗаписей();
			Набор.Отбор.id_3p.Установить(ВыборкаДетальныеЗаписи.id_3p);
			Набор.Отбор.GUID_Загрузки.Установить(ВыборкаДетальныеЗаписи.GUID_Загрузки);
			Набор.Отбор.КтоЗвонил.Установить(ВыборкаДетальныеЗаписи.КтоЗвонил);
			Набор.Прочитать();
			Для каждого ТекСтрока Из Набор Цикл
				
				ТекСтрока.НомерКарты_3p = Email1;	
				
			КонецЦикла; 
			Попытка
				Набор.Записать();
			Исключение
				
			КонецПопытки;
					
		КонецЦикла;
		
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбращенияПокупателей.id_OK,
		|	ОбращенияПокупателей.GUID_Загрузки,
		|	ОбращенияПокупателей.ДатаДок
		|ИЗ
		|	РегистрСведений.ОбращенияПокупателей КАК ОбращенияПокупателей
		|ГДЕ
		|	ОбращенияПокупателей.Номер_Карты_ОК = &Номер_Карты_ОК";
		
		Запрос.УстановитьПараметр("Номер_Карты_ОК", Email);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Набор = РегистрыСведений.ОбращенияПокупателей.СоздатьНаборЗаписей();
			Набор.Отбор.id_OK.Установить(ВыборкаДетальныеЗаписи.id_OK);
			Набор.Отбор.GUID_Загрузки.Установить(ВыборкаДетальныеЗаписи.GUID_Загрузки);
			Набор.Отбор.ДатаДок.Установить(ВыборкаДетальныеЗаписи.ДатаДок);
			Набор.Прочитать();
			Для каждого ТекСтрока Из Набор Цикл
				
				ТекСтрока.Номер_Карты_ОК = Email1;	
				
			КонецЦикла;
			Попытка
				Набор.Записать();
			Исключение
				
			КонецПопытки;	
			
		КонецЦикла;
    					
	//Иначе
	//	ОбщегоНазначения.СообщитьИнформациюПользователю("Карта не найдена");
	//КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КартаИсточникПриИзменении(Элемент)
	УстановитьВидимостьПанелей();
КонецПроцедуры

&НаКлиенте
Процедура КартаПриемникПриИзменении(Элемент)
	УстановитьВидимостьПанелей();
КонецПроцедуры

&НаКлиенте
Процедура ФинОпераци1Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
	Состояние("Идёт выборка данных по чеку... Ожидайте!");
	ТекID = Объект.ФинОпераци1[ВыбраннаяСтрока].CheckUID;
	ТекМагазин = Объект.ФинОпераци1[ВыбраннаяСтрока].ShopNo;
	ТекСуммаЧека = Объект.ФинОпераци1[ВыбраннаяСтрока].ChequeAmount;
	ТекNumber = Объект.ФинОпераци1[ВыбраннаяСтрока].CardNum;
	ТекDateTimeStamp = Объект.ФинОпераци1[ВыбраннаяСтрока].DateTimeStamp;
	Табл = ФинОперациВыборНаСервере(ТекID, ТекМагазин, ТекСуммаЧека, ТекNumber, ТекDateTimeStamp);
	Состояние("");
	
	Табл.Показать("Чек_unf ");
	
КонецПроцедуры

&НаСервере
Функция ПоказатьИсториюПереносаКартСервере(ТекНомерКарты)
		
	ТекстЗапроса = "SELECT OLD_number as 'СтарыйНомер', New_number as 'НовыйНомер', date_join as 'ДатаСлияния',user_join as 'Пользователь'
	|FROM [Loyalty].[dbo].[Join_customer] j
	|inner join Loyalty..DiscountCard (nolock) d1 on d1.Number=j.New_number
	|inner join Loyalty..DiscountCard (nolock) d2 on d2.Number=j.Old_number
	| inner join Loyalty..DiscountCard (nolock) d3 on d1.AccountUID=d3.AccountUID
	|inner join Loyalty..DiscountCard (nolock) d4 on d2.AccountUID=d4.AccountUID
	|where (d3.Number = ('~~~~~')
	|
	|or d4.Number = ('~~~~~') ) and is_join=1
	|
	|order by date_join;";	
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~",ТекНомерКарты);
	
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();	
		
	Табл = Новый ТабличныйДокумент;
	Макет = ПолучитьОбщийМакет(Метаданные.ОбщиеМакеты.АК_ПечатьТаблицЗначений);
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапкаОсновной=Макет.ПолучитьОбласть("Шапка|Основной");
	ОбластьСтрокаОсновной=Макет.ПолучитьОбласть("Строка|Основной");
	ОбластьИтогОсновной=Макет.ПолучитьОбласть("Итог|Основной");
	ОбластьШапкаДОП=Макет.ПолучитьОбласть("Шапка|Показатели");
	ОбластьСтрокаДОП=Макет.ПолучитьОбласть("Строка|Показатели");
	ОбластьИтогДОП=Макет.ПолучитьОбласть("Итог|Показатели");
		
	ОбластьЗаголовок.Параметры.Заголовок = "История изменений по карте "+ТекНомерКарты;
	Табл.Вывести(ОбластьЗаголовок);
	
	Табл.Вывести(ОбластьШапкаОсновной);
	
	Для Каждого Колонка из Тз.Колонки ЦИКЛ
		ОбластьШапкаДОП.Параметры.ИмяПоказателя=Колонка.Имя;
		Табл.Присоединить(ОбластьШапкаДОП);
	КонецЦикла;
	
	счетчик=0;
	Для каждого стр из Тз Цикл
		счетчик=счетчик+1;
		ОбластьСтрокаОсновной.Параметры.счетчик=счетчик; 
		Табл.Вывести(ОбластьСтрокаОсновной);
		Для Каждого Колонка из Тз.Колонки ЦИКЛ
			ОбластьСтрокаДОП.Параметры.ЗначениеКолонки=Формат(стр[Колонка.Имя],"ЧДЦ=2; ЧН=0,00; ЧГ=0");
			Табл.Присоединить(ОбластьСтрокаДОП);
		КонецЦикла;
	КонецЦикла;
	//Табл.Вывести(ОбластьИтогОсновной);
	
	//Для Каждого Колонка из Тз.Колонки ЦИКЛ
	//	ОбластьИтогДОП.Параметры.Итог=Формат(Тз.Итог(Колонка.Имя),"ЧДЦ=2; ЧН=0,00; ЧГ=0");
	//	Табл.Присоединить(ОбластьИтогДОП);
	//КонецЦикла;
	
	
	//Табл.Защита = Истина;
	//Табл.ОтображатьЗаголовки = Ложь;
	Табл.ОтображатьСетку = Ложь;
	Возврат Табл;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьИсториюПереносаКарт(Команда)
	Табл = ПоказатьИсториюПереносаКартСервере(Email);	
	Табл.Показать("История изменений по карте "+Email);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьИсториюПереносаКарт1(Команда)
	Табл = ПоказатьИсториюПереносаКартСервере(Email1);	
	Табл.Показать("История изменений по карте "+Email1);
КонецПроцедуры

&НаКлиенте
Процедура EmailПриИзменении(Элемент)
	
	ОбновитьДанные_Автомат();
	
КонецПроцедуры

&НаКлиенте
Процедура Email1ПриИзменении(Элемент)
	
	ОбновитьДанные_Автомат();
	
КонецПроцедуры

Функция КартаОтправительУтеряна()
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	Если ADOСоединение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстЗапроса = "SELECT 
					 |     Cust.id_type_cust
					 |FROM [Loyalty].[dbo].[Customer] (nolock) as Cust
					 |Where Email = " + ВнешниеДанные.ФорматПоля(Email);
	
	rs = ADOСоединение.Execute(ТекстЗапроса);
	Пока rs <> Неопределено И rs.Fields.Count <= 0 Цикл
		rs=rs.NextRecordSet();
	КонецЦикла;
	
	Результат = Ложь;
	
	Попытка
		rs.MoveFirst();
		
		Если НЕ rs.EOF() Тогда
			Результат = Rs.Fields("id_type_cust").Value = 4;
		КонецЕсли;
	Исключение
	КонецПопытки;
	ADOСоединение.Close();
	ADOСоединение = Неопределено;
	
	Возврат Результат;
	
КонецФункции	

&НаКлиенте
Процедура ПеренестиДанные(Команда)
	
	//+++АК MIND 2017.11.02 спросим точно ли пользователь понимает что делает и считаем именно динамически
	Если КартаОтправительУтеряна() Тогда
		Ответ = Вопрос("Карта, с которой вы пытаетесь перенести данные (" + Email + ") стоит в статусе ""Утеряна"". Продолжить?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;	
	КонецЕсли;	
	//---АК MIND 
	ОбновитьДанные_Автомат();
	Состояние("Идёт обработка. Ожидайте...");
	ПеренестиИзСтарогоНаПустыеНовогоНаСервере();
	ПеренестиОперацииНаСервере();
	ОбновитьДанные_Автомат();
	
КонецПроцедуры


