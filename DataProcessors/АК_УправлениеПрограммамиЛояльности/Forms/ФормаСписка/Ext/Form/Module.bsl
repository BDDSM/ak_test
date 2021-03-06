﻿
//////////////////////////////////////////////////////////////
//ADO

//
//
Функция ADO_Execute(ADOСоединение, ТекстЗапроса) Экспорт
	
	//
	Попытка
		ADORecordSet = ADOСоединение.Execute(ТекстЗапроса);
	Исключение
		ADORecordSet = Неопределено;
		Сообщить(ОписаниеОшибки());
	КонецПопытки;	

	//
	Возврат ADORecordSet;
	
КонецФункции	

//
//
Функция ADO_Connection(СтрокаПоключения) Экспорт
	
	//
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	ADOСоединение.ConnectionString  = СтрокаПоключения;
	
	//
	Попытка
		ADOСоединение.Open();
	Исключение
		ADOСоединение = Неопределено;
		Сообщить(ОписаниеОшибки());
	КонецПопытки;	

	//
	Возврат ADOСоединение;
	
КонецФункции

//////////////////////////////////////////////////////////////
//ADO->1C

//
//
Функция RecordSet_в_ТаблицуЗначений(RecordSet) Экспорт 
	
	//
	РезультатТЗ = Новый ТаблицаЗначений;
	
	//
	Для Каждого Field Из RecordSet.Fields Цикл
		
		//
		РезультатТЗ.Колонки.Добавить(Field.Name);
		
	КонецЦикла;	
	
	//
	Если НЕ RecordSet.EOF Тогда
		
		//
		RecordSet.MoveFirst();
		
		//
		Пока НЕ RecordSet.EOF Цикл
			
			//
			НоваяСтрока = РезультатТЗ.Добавить();
			Для Каждого Колонка Из РезультатТЗ.Колонки Цикл
				
				//
				Индекс = РезультатТЗ.Колонки.Индекс(Колонка);
				
				//
				НоваяСтрока[Индекс] = RecordSet.Fields.Item(Индекс).Value;
					
			КонецЦикла;	
			
			//
			Если НЕ RecordSet.EOF Тогда 
				RecordSet.MoveNext();
			КонецЕсли;	
			
		КонецЦикла;	
		
	КонецЕсли;	
	
	//
	Возврат РезультатТЗ;
	
КонецФункции	

//////////////////////////////////////////////////////////////

&НаСервере
Процедура ОбновитьНаСервере()
	
	//
	ТЗ_Программы.Очистить();
	
	//
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуСоединенияSQL("{SQL Server}", , "Loyalty", , , "LANGUAGE=русский");
	
	//
	ADOСоединение = ADO_Connection(СтрокаПодключения);	
	Если ADOСоединение <> Неопределено Тогда
		
		//
		ТекстЗапроса = " SELECT DISTINCT 
						|	Cards.id_pc, 
						|	Cards.name_program_cards, 
						|	Cards.descr_pc, 
						|	Cards.sum_pc,
						|	CASE WHEN CardsDiapozon.id_pc IS NULL THEN 0 ELSE 1 END AS Used,
						|	ISNULL(CardsMove.number, 0) as ВсегоКартАктивировано,
						|	ISNULL(CardsDiapozon.number, 0) as ВсегоКартСгенерировали
						|FROM [Loyalty].[dbo].[Program_cards] (nolock) AS Cards
						|	LEFT OUTER JOIN (SELECT PCM.id_pc as id_pc, COUNT(DISTINCT PCM.number) as number FROM [Loyalty].[dbo].[Program_cards_move] as PCM (nolock) WHERE PCM.Summ < 0 GROUP BY PCM.id_pc) AS CardsMove
						|	ON Cards.id_pc = CardsMove.id_pc
						|	LEFT OUTER JOIN (SELECT PCM.id_pc as id_pc, COUNT(DISTINCT PCM.number) as number FROM [Loyalty].[dbo].[Program_cards_move] as PCM (nolock) WHERE PCM.Summ > 0 GROUP BY PCM.id_pc) AS CardsDiapozon
						|	ON Cards.id_pc = CardsDiapozon.id_pc
						|ORDER BY 
						|	Cards.id_pc";
		
		//
		RecordSet = ADO_Execute(ADOСоединение, ТекстЗапроса ); 
		
		//
		РезультатТЗ = RecordSet_в_ТаблицуЗначений(RecordSet); 
		Для каждого СтрокаТЗ Из РезультатТЗ Цикл
			
			//
			НоваяСтрока = ТЗ_Программы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЗ); 
			
			//
			НоваяСтрока.ПризнакТолькоПросмотр = СтрокаТЗ.Used; 
			
		КонецЦикла; 
		
	КонецЕсли;	

КонецПроцедуры

&НаСервере
Функция УдалитьНаСервере(ТекущийКод)
	
	//
	ВсеОК = Истина;
	
	//
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуСоединенияSQL("{SQL Server}", , "Loyalty", , , "LANGUAGE=русский");
	
	//
	ADOСоединение = ADO_Connection(СтрокаПодключения);	
	Если ADOСоединение <> Неопределено Тогда
	
		//
		ТекстЗапроса = " BEGIN TRANSACTION 
						|
						|DELETE FROM [Loyalty].[dbo].[Program_cards]
      					|WHERE id_pc = &Код
						|
						|DELETE FROM [Loyalty].[dbo].[Program_cards_diapazon]
      					|WHERE id_pc = &Код
						|	
						|IF @@ERROR = 0
						|COMMIT
						|ELSE
						|ROLLBACK";
		
		//
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Код", ТекущийКод);
						
		//
		RecordSet = ADO_Execute(ADOСоединение, ТекстЗапроса); 
		Если RecordSet = Неопределено Тогда
			ВсеОК = Ложь;	
		КонецЕсли; 
		
	КонецЕсли;	
	
	//
	Возврат ВсеОК;

КонецФункции

&НаСервере
Функция АктивироватьНаСервере(ТекущийКод)
	
	//
	ВсеОК = Истина;
	
	//
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуСоединенияSQL("{SQL Server}", , "Loyalty", , , "LANGUAGE=русский");
	
	//
	ADOСоединение = ADO_Connection(СтрокаПодключения);	
	Если ADOСоединение <> Неопределено Тогда
	
		//
		ТекстЗапроса = "EXEC loyalty.dbo.create_Program_cards @id_pc = &Код";
		
		//
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Код", ТекущийКод);
						
		//
		RecordSet = ADO_Execute(ADOСоединение, ТекстЗапроса); 
		Если RecordSet = Неопределено Тогда
			ВсеОК = Ложь;	
		КонецЕсли; 
		
	КонецЕсли;	
	
	//
	Возврат ВсеОК;

КонецФункции



///////////////////////////////////////////////////////

&НаКлиенте
Процедура КомандаОбновить(Команда)
	ОбновитьНаСервере();
КонецПроцедуры

///////////////////////////////////////////////////////

&НаКлиенте
Процедура КомандаДобавить(Команда)
	
	//
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Код", 0);
	ПараметрыОткрытия.Вставить("ПризнакТолькоПросмотр", Ложь);
	
	//
	Форма = ПолучитьФорму("Обработка.АК_УправлениеПрограммамиЛояльности.Форма.ФормаЭлемента", ПараметрыОткрытия);
	
	//
	Результат = Форма.ОткрытьМодально();
	
	//
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУдалить(Команда)
	
	//
	ТекущиеДанные = Элементы.ТЗ_Программы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//
	Если ТекущиеДанные.ПризнакТолькоПросмотр = Истина Тогда
		
		//
		Предупреждение("Программа '" + СокрЛП(ТекущиеДанные.name_program_cards) + "' уже активирована.
					   |Удаление запрещено.");
						
		//
		Возврат;
	
	КонецЕсли; 
	
	//
	ТекущийКод = Формат(ТекущиеДанные.id_pc, "ЧН=0; ЧГ=");
	
	//
	ВсеОК = УдалитьНаСервере(ТекущийКод);
	
	//
	Если НЕ ВсеОК Тогда
		Предупреждение("не удалось удалить '" + СокрЛП(ТекущиеДанные.name_program_cards) + "'(см. сообщения)");		
	КонецЕсли; 
	
	//
	ОбновитьНаСервере();
	
КонецПроцедуры

///////////////////////////////////////////////////////

&НаКлиенте
Процедура ТЗ_ПрограммыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	//
	ТекущиеДанные = Элементы.ТЗ_Программы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	//
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Код", ТекущиеДанные.id_pc);
	ПараметрыОткрытия.Вставить("ПризнакТолькоПросмотр", ТекущиеДанные.ПризнакТолькоПросмотр);
	
	//
	Форма = ПолучитьФорму("Обработка.АК_УправлениеПрограммамиЛояльности.Форма.ФормаЭлемента", ПараметрыОткрытия);
	Результат = Форма.ОткрытьМодально(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаАктивироватьПрограмму(Команда)
	
	//
	ТекущиеДанные = Элементы.ТЗ_Программы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//
	Если ТекущиеДанные.ПризнакТолькоПросмотр = Истина Тогда
		
		//
		Предупреждение("Программа '" + СокрЛП(ТекущиеДанные.name_program_cards) + "' уже активирована.");
						
		//
		Возврат;
	
	КонецЕсли; 
	
	//
	ТекущийКод = Формат(ТекущиеДанные.id_pc, "ЧН=0; ЧГ=");
	
	//
	ВсеОК = АктивироватьНаСервере(ТекущийКод);
	
	//
	Если ВсеОК Тогда
		Предупреждение("Программа '" + СокрЛП(ТекущиеДанные.name_program_cards) + "' активирована");		
	КонецЕсли; 
	
	//
	ОбновитьНаСервере();
	
КонецПроцедуры
