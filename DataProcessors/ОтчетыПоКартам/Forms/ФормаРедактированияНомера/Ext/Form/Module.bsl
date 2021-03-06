﻿
&НаСервере
Функция База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения = "")  
	Попытка
		
		//Dim rs2 As ADODB.Recordset
		//
		//Set rs2 = CreateObject("ADODB.Recordset")
		//
		//rs2.Open cmd
		//
		//Debug.Print rs2.GetString
		
		
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

&НаСервере
Функция ПроверитьНомерНаСервере()
	
	Если MobilCarta Тогда
		
		ТекстЗапроса = "SELECT [Phone] FROM [Loyalty].[dbo].[customer]
		//+++АК SHEP 2018.05.08 ИП-00018563
		//|WHERE [Phone] = '~~~~~' AND [MobilCarta] = 1 AND [Email] <> '`````';";
		|WHERE [Phone] = '~~~~~' AND [MobilCarta] = 1 AND [bc_number] <> '`````';";
		//---АК SHEP 2018.05.08
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~", НомерТелефона);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "`````", Email);
		
		СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
		
		RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
		ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
		RecordSet.Close();
		
		Если ТЗ.Количество() > 0 Тогда		
			Возврат Истина;
		КонецЕсли;	
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции	

&НаКлиенте
Процедура Ок(Команда)
	
	Если СокрЛП(НомерТелефона) <> "" И СтрДлина(СокрЛП(НомерТелефона)) < 10 Тогда
		
		Предупреждение("Номер должен состоять из 10 цифр!");
		Возврат;
		
	КонецЕсли;
	
	Если ПроверитьНомерНаСервере() Тогда
		Предупреждение("Для номера телефона "+НомерТелефона+" уже установлен признак МОБИЛЬНАЯ КАРТА = Да!");
		Возврат;
	КонецЕсли;	
	
	Закрыть(НомерТелефона);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры
