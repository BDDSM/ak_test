//+++АК sole 2018.08.24 ИП-00019249
Функция ДатуВСтроку(ДатаВремя)
	Возврат Формат(ДатаВремя, "ДФ=ггггММдд") + " " + Формат(ДатаВремя, "ДФ=ЧЧ:мм:сс");
КонецФункции

//+++АК sole 2018.08.24 ИП-00019249
Процедура ЗапроситьВидеоНаСервере(БПР) Экспорт

	Перем НомерТочки;

	Если БПР.КамерыСписок.Количество() = 0 И БПР.ТипЗапроса = "Фото" Тогда
		Сообщить("Запрос с типом фото возможен только по камерам.");
		Возврат;
	КонецЕсли;

	Если НЕ БПР.Магазин.Пустая() Тогда
		НомерТочки = ОбщегоНазначения.ПолучитьЗначениеРеквизита(БПР.Магазин, "НомерТочки");
	КонецЕсли;

	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();

	Камеры = "";

	Для Каждого Стр Из БПР.КамерыСписок Цикл
		Если Не Стр["Выбрать"] Тогда
			Продолжить;
		КонецЕсли;

		Если Камеры = "" Тогда
			Камеры = Стр["ID_Камеры"];
		Иначе
			Камеры = Камеры + "," + Стр["ID_Камеры"];
		КонецЕсли;

	КонецЦикла;

	Cmd = Новый COMОбъект("ADODB.Command");
	Cmd.ActiveConnection = ADOСоединение;
	Cmd.NamedParameters = Истина;
	Cmd.CommandText = "SMS_REPL.dbo.VideoPhotoOrder";
	Cmd.CommandType = ТипКомандыАДО("adcmdstoredproc");
	//+++ AK suvv 2018.10.09 ИП-00020096
	Cmd.CommandTimeout = 300;
	//--- AK suvv
	
	advarchar = КонстантаАДО("advarchar");
	adinteger = КонстантаАДО("adinteger");
	adsmallint = КонстантаАДО("adsmallint");
	adboolean = КонстантаАДО("adboolean");
	//+++ AK suvv 2018.10.09 ИП-00020096
	adlongvarchar = КонстантаАДО("adlongvarchar");
	//--- AK suvv
	
	adParamInput = ТипПараметраАДО("adParamInput");

	Если ЗначениеЗаполнено(НомерТочки) Тогда

		НомерТочкиСтрока = Формат(НомерТочки, "ЧГ=0");

		prm = Cmd.CreateParameter
			(
				"@Shops",
				advarchar,
				adParamInput,
				СтрДлина(НомерТочкиСтрока),
				НомерТочкиСтрока
			);

		Cmd.Parameters.Append(prm);
	КонецЕсли;


	Если Камеры <> "" Тогда

		prm = Cmd.CreateParameter
			(
				"@IPCams",
			    //+++ AK suvv 2018.10.09 ИП-00020096
				//advarchar,
				adlongvarchar,
				//--- AK suvv
				adParamInput,
				СтрДлина(Камеры),
				Камеры
			);

		Cmd.Parameters.Append(prm);

	КонецЕсли;


	Если НЕ БПР.ОбъектНаблюдения.Пустая() Тогда

		Если ТипЗнч(БПР.ОбъектНаблюдения) = Тип("СправочникСсылка.РабочиеМеста") Тогда

			СтруктурнаяЕдиница = ОбщегоНазначения.ПолучитьЗначениеРеквизита(БПР.ОбъектНаблюдения, "СтруктурнаяЕдиница");
			НомерТочки = ОбщегоНазначения.ПолучитьЗначениеРеквизита(СтруктурнаяЕдиница, "НомерТочки");
			Ракурс = Формат(НомерТочки, "ЧГ=0") + ОбщегоНазначения.ПолучитьЗначениеРеквизита(БПР.ОбъектНаблюдения, "НомерРабочегоМеста");

		Иначе

			Ракурс = ОбщегоНазначения.ПолучитьЗначениеРеквизита(БПР.ОбъектНаблюдения, "Наименование");

		КонецЕсли;


		prm = Cmd.CreateParameter
			(
				"@Rakurs",
				advarchar,
				adParamInput,
				СтрДлина(Ракурс),
				Ракурс
			);

		Cmd.Parameters.Append(prm);

	КонецЕсли;

	НачалоТекст = ДатуВСтроку(БПР.Начало);

	prm = Cmd.CreateParameter
		(
			"@timeST_Sec",
			advarchar,
			adParamInput,
			СтрДлина(НачалоТекст),
			НачалоТекст
		);

	Cmd.Parameters.Append(prm);


	ОкончаниеТекст = ДатуВСтроку(БПР.Окончание);

	prm = Cmd.CreateParameter
		(
			"@timeFIN_Sec",
			advarchar,
			adParamInput,
			СтрДлина(ОкончаниеТекст),
			ОкончаниеТекст
		);

	Cmd.Parameters.Append(prm);


	prm = Cmd.CreateParameter
		(
			"@TypeVideo",
			adinteger,
			adParamInput,
			,
			10
		);

	Cmd.Parameters.Append(prm);


	Если БПР.НомерЧека <> 0 Тогда

		prm = Cmd.CreateParameter
		(
			"@CashCheckNo",
			adinteger,
			adParamInput,
			,
			БПР.НомерЧека
		);

		Cmd.Parameters.Append(prm);

	КонецЕсли;


	ЭтоФото = (БПР.ТипЗапроса = "Фото");

	prm = Cmd.CreateParameter
		(
			"@isPhoto",
			adboolean,
			adParamInput,
			,
			ЭтоФото
		);

	Cmd.Parameters.Append(prm);

	Если БПР.КомментарийКВидео <> "" Тогда

		prm = Cmd.CreateParameter
			(
				"@TextVideo",
				advarchar,
				adParamInput,
				СтрДлина(БПР.КомментарийКВидео),
				БПР.КомментарийКВидео
			);

		Cmd.Parameters.Append(prm);

	КонецЕсли;


	prm = Cmd.CreateParameter
		(
			"@isUrgent",
			adsmallint,
			adParamInput,
			,
			?(БПР.Срочно, 1, 0)
		);

	Cmd.Parameters.Append(prm);


	МаркерПОЗаказчика = "1С";

	prm = Cmd.CreateParameter
		(
			"@UserAdd",
			advarchar,
			adParamInput,
			СтрДлина(МаркерПОЗаказчика),
			МаркерПОЗаказчика
		);

	Cmd.Parameters.Append(prm);


	prm = Cmd.CreateParameter
		(
			"@isOnlyCams",
			adboolean,
			adParamInput,
			,
			Истина
		);

	Cmd.Parameters.Append(prm);


	prm = Cmd.CreateParameter
		(
			"@isShopActive",
			adboolean,
			adParamInput,
			,
			Истина
		);

	Cmd.Parameters.Append(prm);


	prm = Cmd.CreateParameter
		(
			"@isIpCamsControlIsActive",
			adboolean,
			adParamInput,
			,
			Истина
		);

	Cmd.Parameters.Append(prm);


	prm = Cmd.CreateParameter
		(
			"@isConsiderStatusChanel",
			adboolean,
			adParamInput,
			,
			Истина
		);

	Cmd.Parameters.Append(prm);


	prm = Cmd.CreateParameter
		(
			"@Duration",
			adinteger,
			adParamInput,
			,
			(БПР.Окончание - БПР.Начало)
		);

	Cmd.Parameters.Append(prm);

	Cmd.Execute();
	
	ADOСоединение.Close();
КонецПроцедуры

//+++АК sole 2018.08.29 ИП-00019249
Процедура ПолучитьИДКамер(БПР) Экспорт
	
	Перем НомерТочки;
	
	БПР.КамерыСписок.Очистить();
	
	Если БПР.Магазин.Пустая() И БПР.ОбъектНаблюдения.Пустая() Тогда
		Возврат;	
	КонецЕсли;
	
	ЭтоВидео = (БПР.ТипЗапроса = "Видео");
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	Cmd = Новый COMОбъект("ADODB.Command");
	Cmd.ActiveConnection = ADOСоединение;
	Cmd.NamedParameters = Истина;
	Cmd.CommandText = "SMS_REPL.dbo.sp_GetCamList1C";
	Cmd.CommandType = ТипКомандыАДО("adcmdstoredproc");
	
	advarchar = КонстантаАДО("advarchar");
	adinteger = КонстантаАДО("adinteger");
	
	adParamInput = ТипПараметраАДО("adParamInput");
	
	Если НЕ БПР.Магазин.Пустая() Тогда
		НомерТочки = ОбщегоНазначения.ПолучитьЗначениеРеквизита(БПР.Магазин, "НомерТочки");
		
		prm = Cmd.CreateParameter
			(
				"@ShopNo", 
				adinteger, 
				adParamInput,
				, 
				НомерТочки
			);  
		
		Cmd.Parameters.Append(prm);  	
	КонецЕсли;
	
	Если НЕ БПР.ОбъектНаблюдения.Пустая() Тогда
			
		Ракурс = ОбщегоНазначения.ПолучитьЗначениеРеквизита(БПР.ОбъектНаблюдения, "Наименование");		
		
		prm = Cmd.CreateParameter
			(
				"@Rakurs", 
				advarchar, 
				adParamInput,
				СтрДлина(Ракурс), 
				Ракурс
			);  
		
		Cmd.Parameters.Append(prm);	
		
	КонецЕсли;
	
	rs = Cmd.Execute();
	
	Если rs.RecordCount <> 0 Тогда
		
		Пока Не rs.EOF Цикл
			НСтр = БПР.КамерыСписок.Добавить();
			НСтр["ID_Камеры"] = rs.Fields(0).value;
			НСтр["МагазинНаименование"] = rs.Fields(1).value;
			НСтр["Описание"] = rs.Fields(2).value;
			Если rs.Fields(3).value = 1 Тогда
				НСтр["СтатусКанала"] = Перечисления.АК_СтатусыКаналаКамеры.Плохой;
			Иначе
				НСтр["СтатусКанала"] = Перечисления.АК_СтатусыКаналаКамеры.Хороший;
			КонецЕсли;
			
			Если БПР.Срочно И ЭтоВидео Тогда
				Если НСтр["СтатусКанала"]= Перечисления.АК_СтатусыКаналаКамеры.Плохой Тогда
					НСтр["Выбрать"] = Ложь;
				Иначе
					НСтр["Выбрать"] = Истина;	
				КонецЕсли;
			Иначе
				НСтр["Выбрать"] = Истина;	
			КонецЕсли;

			rs.MoveNext();	
		КонецЦикла;
		
	КонецЕсли;
	
	rs.Close();	
	ADOСоединение.Close();
	
КонецПроцедуры

//+++АК sole 2018.08.24 ИП-00019249
Функция ТипКомандыАДО( АдоКонст ) Экспорт
   АдоКонст = Нрег(АдоКонст);
   Если АдоКонст = "adcmdtext" тогда возврат 1; //для оператора T-SQL
   ИначеЕсли АдоКонст = "adcmdtable" тогда возврат 2;
   ИначеЕсли АдоКонст = "adcmdstoredproc" тогда возврат 4; //для хранимой процедуры
   Иначе Возврат 8; //adcmdunknown
   КонецЕсли;
КонецФункции

//+++АК sole 2018.08.24 ИП-00019249
Функция КонстантаАДО( Конст )  Экспорт
  АдоКонст = НРег(Конст);
  Если АдоКонст = "adEmpty" тогда Возврат 0;
  иначеесли АдоКонст = "adtinyint" тогда Возврат 16;
  иначеесли АдоКонст = "adsmallint" тогда Возврат 2;
  иначеесли АдоКонст = "adinteger" тогда Возврат 3;
  иначеесли АдоКонст = "adbigint" тогда Возврат 20;
  иначеесли АдоКонст = "adunsignedtinyint" тогда Возврат   17;
  иначеесли АдоКонст = "adunsignedsmallint" тогда Возврат  18;
  иначеесли АдоКонст = "adunsignedint" тогда Возврат 19;
  иначеесли АдоКонст = "adunsignedbigint" тогда Возврат   21;
  иначеесли АдоКонст = "adsingle" тогда Возврат 4;
  иначеесли АдоКонст = "addouble" тогда Возврат 5;
  иначеесли АдоКонст = "adcurrency" тогда Возврат 6;
  иначеесли АдоКонст = "addecimal" тогда Возврат 14;
  иначеесли АдоКонст = "adnumeric" тогда Возврат 131;
  иначеесли АдоКонст = "adboolean" тогда Возврат 11;
  иначеесли АдоКонст = "aderror" тогда Возврат 10;
  иначеесли АдоКонст = "aduserdefined" тогда Возврат 132;
  иначеесли АдоКонст = "advariant" тогда Возврат 12;
  иначеесли АдоКонст = "adidispatch" тогда Возврат 9;
  иначеесли АдоКонст = "adiunknown" тогда Возврат 13;
  иначеесли АдоКонст = "adguid" тогда Возврат 72;
  иначеесли АдоКонст = "addate" тогда Возврат 7;
  иначеесли АдоКонст = "addbdate" тогда Возврат 133;
  иначеесли АдоКонст = "addbtime" тогда Возврат 134;
  иначеесли АдоКонст = "addbtimestamp" тогда Возврат 135;
  иначеесли АдоКонст = "adbstr" тогда Возврат 8;
  иначеесли АдоКонст = "adchar" тогда Возврат 129;
  иначеесли АдоКонст = "advarchar" тогда Возврат 200;
  иначеесли АдоКонст = "adlongvarchar" тогда Возврат 201;
  иначеесли АдоКонст = "adwchar" тогда Возврат 130;
  иначеесли АдоКонст = "advarwchar" тогда Возврат 202;
  иначеесли АдоКонст = "adlongvarwchar" тогда Возврат 203;
  иначеесли АдоКонст = "adbinary" тогда Возврат 128;
  иначеесли АдоКонст = "advarbinary" тогда Возврат 204;
  иначеесли АдоКонст = "adlongvarbinary" тогда Возврат   205;
  иначе возврат 0;
  конецесли;
КонецФункции

//+++АК sole 2018.08.24 ИП-00019249
Функция ТипПараметраАДО( Конст ) Экспорт
   АдоКонст = НРег(Конст);
   Если АдоКонст = "adparamunknown" тогда Возврат 0;
   иначеесли АдоКонст = "adparaminput"тогда Возврат 1;
   иначеесли АдоКонст = "adparamoutput"тогда Возврат 2;
   иначеесли АдоКонст = "adparaminputoutput"тогда Возврат  3;
   иначеесли АдоКонст = "adparamreturnvalue"тогда Возврат  4;
   КонецЕсли;
 КонецФункции

//