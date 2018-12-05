
&НаКлиенте
Процедура ЧекиПередУдалением(Элемент, Отказ)
	
	//Отказ = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дата = Параметры.Дата;
	ТТ = Параметры.ТТ;
	
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	
	ТабКешЧеки = Новый ТаблицаЗначений();
	ТабКешЧеки.Колонки.Добавить("УИНЧека");
	ТабКешЧеки.Колонки.Добавить("СуммаЧека");
	ТабКешЧеки.Колонки.Добавить("СуммаПоНдс10");
	ТабКешЧеки.Колонки.Добавить("СуммаПоНдс18");
	ТабКешЧеки.Индексы.Добавить("УИНЧека");
	
	Если ТТ.ТипРозничнойТочки = Перечисления.ТипыРозничныхТочек.Избенка Тогда
		СтрСоедиение = ОбменСAccess.ПолучитьСтрокуСоединения("sms_izbenka");
		
		ADOСоединение.ConnectionString  = СтрСоедиение;
		ADOСоединение.Open();
		
		СтрЗапрос = "SELECT Ch.CheckUID, Ch.CashID,
		|  Ch.BaseSum,
		|  Chl.SummaPoNDS10 as SummaPoNDS10,
		|  Chl.SummaPoNDS18 as SummaPoNDS18
		|FROM [SMS_IZBENKA].[dbo].[Checks] as Ch (nolock)
		|	LEFT OUTER JOIN (SELECT Chl.CheckUid As CheckUid,
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 10 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS10, 
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 18 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS18
		|						FROM [SMS_IZBENKA].[dbo].[CheckLine] as Chl (nolock)
		|						INNER JOIN IzbenkaFin.dbo.ArticleBin2UID as ArticleBin2UID (nolock)
		|						ON Chl.id_tov_cl = ArticleBin2UID.id_tov
		|						WHERE Chl.date_ch = '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-dd") + "' and Chl.id_tt_cl = " + Формат(ТТ.id_TT, "ЧГ=0") + " and Chl.OperationType_cl IN (1, 201, 3, 202, 203)
		|						GROUP BY Chl.CheckUid) as Chl ON Ch.CheckUID = Chl.CheckUid
		|where Ch.CloseDate >= '" + Формат(НачалоДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "' and Ch.CloseDate <= '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "' and Ch.OperationType IN (1, 201, 3, 202, 203)
		|and Ch.ShopNo IN (" + ВнешниеДанные.ФорматПоля(ТТ.НомерТочки) + ")
		|";
		
		rs = ADOСоединение.Execute(СтрЗапрос);
		
		Попытка
			rs.MoveFirst();
			
			Пока НЕ rs.EOF() Цикл
				СтрокаДоб = ТабКешЧеки.Добавить();
				СтрокаДоб.УИНЧека = Rs.Fields("CheckUID").Value;
				СтрокаДоб.СуммаЧека = Rs.Fields("BaseSum").Value;
				СтрокаДоб.СуммаПоНдс10 = Rs.Fields("SummaPoNDS10").Value;
				СтрокаДоб.СуммаПоНдс18 = Rs.Fields("SummaPoNDS18").Value;
				Если СтрокаДоб.СуммаЧека < 0 Тогда
					СтрокаДоб.СуммаЧека = СтрокаДоб.СуммаЧека * (-1)
				КонецЕсли;
				Если СтрокаДоб.СуммаПоНдс10 < 0 Тогда
					СтрокаДоб.СуммаПоНдс10 = СтрокаДоб.СуммаПоНдс10 * (-1)
				КонецЕсли;
				Если СтрокаДоб.СуммаПоНдс18 < 0 Тогда
					СтрокаДоб.СуммаПоНдс18 = СтрокаДоб.СуммаПоНдс18 * (-1)
				КонецЕсли;
				rs.MoveNext();
			КонецЦикла;
		Исключение
		КонецПопытки;
	Иначе
		СтрСоедиение = ОбменСAccess.ПолучитьСтрокуСоединения("sms_union");
		
		ADOСоединение.ConnectionString  = СтрСоедиение;
		ADOСоединение.Open();
		
		СтрЗапрос = "SELECT Ch.CheckUID,
		|  Ch.BaseSum,
		|  Chl.SummaPoNDS10 as SummaPoNDS10,
		|  Chl.SummaPoNDS18 as SummaPoNDS18
		|FROM [SMS_UNION].[dbo].[Checks] as Ch (nolock)
		|	LEFT OUTER JOIN (SELECT Chl.CheckUid As CheckUid,
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 10 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS10, 
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 18 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS18
		|						FROM [SMS_UNION].[dbo].[CheckLine] as Chl (nolock)
		|						INNER JOIN IzbenkaFin.dbo.ArticleBin2UID as ArticleBin2UID (nolock)
		|						ON Chl.id_tov_cl = ArticleBin2UID.id_tov
		|						WHERE Chl.date_ch = '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-dd") + "' and Chl.id_tt_cl = " + Формат(ТТ.id_TT, "ЧГ=0") + "
		|						GROUP BY Chl.CheckUid) as Chl ON Ch.CheckUID = Chl.CheckUid
		|where Ch.CloseDate >= '" + Формат(НачалоДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "' and Ch.CloseDate <= '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "'
		|and Ch.ShopNo = " + Формат(ТТ.НомерТочки, "ЧГ=0") + "
		|";
		
		rs = ADOСоединение.Execute(СтрЗапрос);
		
		Попытка
			rs.MoveFirst();
			
			Пока НЕ rs.EOF() Цикл
				СтрокаДоб = ТабКешЧеки.Добавить();
				СтрокаДоб.УИНЧека = Rs.Fields("CheckUID").Value;
				СтрокаДоб.СуммаЧека = Rs.Fields("BaseSum").Value;
				СтрокаДоб.СуммаПоНдс10 = Rs.Fields("SummaPoNDS10").Value;
				СтрокаДоб.СуммаПоНдс18 = Rs.Fields("SummaPoNDS18").Value;
				Если СтрокаДоб.СуммаЧека < 0 Тогда
					СтрокаДоб.СуммаЧека = СтрокаДоб.СуммаЧека * (-1)
				КонецЕсли;
				Если СтрокаДоб.СуммаПоНдс10 < 0 Тогда
					СтрокаДоб.СуммаПоНдс10 = СтрокаДоб.СуммаПоНдс10 * (-1)
				КонецЕсли;
				Если СтрокаДоб.СуммаПоНдс18 < 0 Тогда
					СтрокаДоб.СуммаПоНдс18 = СтрокаДоб.СуммаПоНдс18 * (-1)
				КонецЕсли;
				rs.MoveNext();
			КонецЦикла;
		Исключение
		КонецПопытки;
	КонецЕсли;	
	
	ADOСоединение.Close();
	
	СуммаПоНДС10 = ТабКешЧеки.Итог("СуммаПоНдс10");
	СуммаПоНДС18 = ТабКешЧеки.Итог("СуммаПоНдс18");
	
	Для н = 0 По Параметры.Чеки.Количество() - 1 Цикл
		СтрокаДоб = Чеки.Добавить();
		СтрокаДоб.УИНЧека = Параметры.Чеки[н].УИНЧека;
		СтрокаДоб.СуммаЧека = Параметры.Чеки[н].СуммаЧека;
		СтрокаКеш = ТабКешЧеки.Найти(Параметры.Чеки[н].УИНЧека, "УИНЧека");
		Если СтрокаКеш = Неопределено Тогда
			КоэффициентВыручкиПоНДС10 = ?(СуммаПоНДС10 + СуммаПоНДС18 = 0, 1, СуммаПоНДС10 / (СуммаПоНДС10 + СуммаПоНДС18));
			СтрокаДоб.СуммаПоНдс10 = СтрокаДоб.СуммаЧека * КоэффициентВыручкиПоНДС10;
			СтрокаДоб.СуммаПоНДС18 = СтрокаДоб.СуммаЧека - СтрокаДоб.СуммаПоНдс10;
		Иначе
			СтрокаДоб.СуммаПоНдс10 = СтрокаКеш.СуммаПоНдс10;
			СтрокаДоб.СуммаПоНдс18 = СтрокаКеш.СуммаПоНдс18;
		КонецЕсли;	
		СтрокаДоб.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	
	МассивВозврат = Новый Массив();
	Для Каждого СтрокаТаб Из Чеки Цикл
		Если СтрокаТаб.Выбран Тогда
			МассивВозврат.Добавить(Новый Структура("ПолученаСумма, СуммаПоНдс10, СуммаПоНдс18, УИНЧека"
						, СтрокаТаб.СуммаЧека, СтрокаТаб.СуммаПоНдс10, СтрокаТаб.СуммаПоНдс18, СтрокаТаб.УИНЧека));
		КонецЕсли;	
	КонецЦикла;	
	Закрыть(МассивВозврат);
	
КонецПроцедуры

&НаКлиенте
Процедура ЧекиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.Чеки.ТекущиеДанные.УИНЧека = Строка(Новый УникальныйИдентификатор());
		Элементы.Чеки.ТекущиеДанные.Выбран = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивЧеков(СуммаЧека)
	
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	
	МассивВозврат = Новый Массив();
	
	Если ТТ.ТипРозничнойТочки = Перечисления.ТипыРозничныхТочек.Избенка Тогда
		СтрСоедиение = ОбменСAccess.ПолучитьСтрокуСоединения("sms_izbenka");
		
		ADOСоединение.ConnectionString  = СтрСоедиение;
		ADOСоединение.Open();
		
		СтрЗапрос = "SELECT Ch.CheckUID, Ch.CashCheckNo,
		|  Ch.BaseSum,
		|  Chl.SummaPoNDS10 as SummaPoNDS10,
		|  Chl.SummaPoNDS18 as SummaPoNDS18
		|FROM [SMS_IZBENKA].[dbo].[Checks] as Ch (nolock)
		|	LEFT OUTER JOIN (SELECT Chl.CheckUid As CheckUid,
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 10 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS10, 
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 18 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS18
		|						FROM [SMS_IZBENKA].[dbo].[CheckLine] as Chl (nolock)
		|						INNER JOIN IzbenkaFin.dbo.ArticleBin2UID as ArticleBin2UID (nolock)
		|						ON Chl.id_tov_cl = ArticleBin2UID.id_tov
		|						WHERE Chl.date_ch = '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-dd") + "' and Chl.id_tt_cl = " + Формат(ТТ.id_TT, "ЧГ=0") + " and Chl.OperationType_cl IN (1, 201, 3, 202, 203)
		|						GROUP BY Chl.CheckUid) as Chl ON Ch.CheckUID = Chl.CheckUid
		|where Ch.CloseDate >= '" + Формат(НачалоДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "' and Ch.CloseDate <= '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "' and Ch.OperationType IN (1, 201, 3, 202, 203)
		|and Ch.ShopNo IN (" + ТТ.НомерТочки + ") and (Ch.BaseSum = " + Формат(СуммаЧека, "ЧРД=.; ЧН=; ЧГ=0") + " or Ch.BaseSum = " + Формат(СуммаЧека * -1, "ЧРД=.; ЧН=; ЧГ=0") + ")
		|";
		
		rs = ADOСоединение.Execute(СтрЗапрос);
		
		Попытка
			rs.MoveFirst();
			
			Пока НЕ rs.EOF() Цикл
				СтруктураЧек = Новый Структура();
				СтруктураЧек.Вставить("УИНЧека", Rs.Fields("CheckUID").Value);
				СтруктураЧек.Вставить("НомерДокумента", Rs.Fields("CashCheckNo").Value);
				СтруктураЧек.Вставить("СуммаЧека", Rs.Fields("BaseSum").Value);
				СтруктураЧек.Вставить("СуммаПоНдс10", Rs.Fields("SummaPoNDS10").Value);
				СтруктураЧек.Вставить("СуммаПоНдс18", Rs.Fields("SummaPoNDS18").Value);
				Если СтруктураЧек.СуммаЧека < 0 Тогда
					СтруктураЧек.СуммаЧека = СтруктураЧек.СуммаЧека * (-1)
				КонецЕсли;
				Если СтруктураЧек.СуммаПоНдс10 < 0 Тогда
					СтруктураЧек.СуммаПоНдс10 = СтруктураЧек.СуммаПоНдс10 * (-1)
				КонецЕсли;
				Если СтруктураЧек.СуммаПоНдс18 < 0 Тогда
					СтруктураЧек.СуммаПоНдс18 = СтруктураЧек.СуммаПоНдс18 * (-1)
				КонецЕсли;
				МассивВозврат.Добавить(СтруктураЧек);
				rs.MoveNext();
			КонецЦикла;
		Исключение
		КонецПопытки;
	Иначе
		СтрСоедиение = ОбменСAccess.ПолучитьСтрокуСоединения("sms_union");
		
		ADOСоединение.ConnectionString  = СтрСоедиение;
		ADOСоединение.Open();
		
		СтрЗапрос = "SELECT Ch.CheckUID, Ch.CashCheckNo,
		|  Ch.BaseSum,
		|  Chl.SummaPoNDS10 as SummaPoNDS10,
		|  Chl.SummaPoNDS18 as SummaPoNDS18
		|FROM [SMS_UNION].[dbo].[Checks] as Ch (nolock)
		|	LEFT OUTER JOIN (SELECT Chl.CheckUid As CheckUid,
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 10 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS10, 
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 18 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS18
		|						FROM [SMS_UNION].[dbo].[CheckLine] as Chl (nolock)
		|						INNER JOIN IzbenkaFin.dbo.ArticleBin2UID as ArticleBin2UID (nolock)
		|						ON Chl.id_tov_cl = ArticleBin2UID.id_tov
		|						WHERE Chl.date_ch = '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-dd") + "' and Chl.id_tt_cl = " + Формат(ТТ.id_TT, "ЧГ=0") + "
		|						GROUP BY Chl.CheckUid) as Chl ON Ch.CheckUID = Chl.CheckUid
		|where Ch.CloseDate >= '" + Формат(НачалоДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "' and Ch.CloseDate <= '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "'
		|and Ch.ShopNo = " + Формат(ТТ.НомерТочки, "ЧГ=0") + " and (Ch.BaseSum = " + Формат(СуммаЧека, "ЧРД=.; ЧГ=0") + " or Ch.BaseSum = " + Формат(СуммаЧека * -1, "ЧРД=.; ЧГ=0") + ")
		|";
		
		rs = ADOСоединение.Execute(СтрЗапрос);
		
		Попытка
			rs.MoveFirst();
			
			Пока НЕ rs.EOF() Цикл
				СтруктураЧек = Новый Структура();
				СтруктураЧек.Вставить("УИНЧека", Rs.Fields("CheckUID").Value);
				СтруктураЧек.Вставить("НомерДокумента", Rs.Fields("CashCheckNo").Value);
				СтруктураЧек.Вставить("СуммаЧека", Rs.Fields("BaseSum").Value);
				СтруктураЧек.Вставить("СуммаПоНдс10", Rs.Fields("SummaPoNDS10").Value);
				СтруктураЧек.Вставить("СуммаПоНдс18", Rs.Fields("SummaPoNDS18").Value);
				Если СтруктураЧек.СуммаЧека < 0 Тогда
					СтруктураЧек.СуммаЧека = СтруктураЧек.СуммаЧека * (-1)
				КонецЕсли;
				Если СтруктураЧек.СуммаПоНдс10 < 0 Тогда
					СтруктураЧек.СуммаПоНдс10 = СтруктураЧек.СуммаПоНдс10 * (-1)
				КонецЕсли;
				Если СтруктураЧек.СуммаПоНдс18 < 0 Тогда
					СтруктураЧек.СуммаПоНдс18 = СтруктураЧек.СуммаПоНдс18 * (-1)
				КонецЕсли;
				МассивВозврат.Добавить(СтруктураЧек);
				rs.MoveNext();
			КонецЦикла;
		Исключение
		КонецПопытки;
	КонецЕсли;	
	
	ADOСоединение.Close();
	
	Возврат МассивВозврат;
	
КонецФункции	

&НаСервере
Функция ПолучитьЧекПоНомеру(НомерЧека)
	
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	
	МассивВозврат = Новый Массив();
	
	Если ТТ.ТипРозничнойТочки = Перечисления.ТипыРозничныхТочек.Избенка Тогда
		СтрСоедиение = ОбменСAccess.ПолучитьСтрокуСоединения("sms_izbenka");
		
		ADOСоединение.ConnectionString  = СтрСоедиение;
		ADOСоединение.Open();
		
		СтрЗапрос = "SELECT Ch.CheckUID, Ch.CashCheckNo,
		|  Ch.BaseSum,
		|  Chl.SummaPoNDS10 as SummaPoNDS10,
		|  Chl.SummaPoNDS18 as SummaPoNDS18
		|FROM [SMS_IZBENKA].[dbo].[Checks] as Ch (nolock)
		|	LEFT OUTER JOIN (SELECT Chl.CheckUid As CheckUid,
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 10 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS10, 
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 18 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS18
		|						FROM [SMS_IZBENKA].[dbo].[CheckLine] as Chl (nolock)
		|						INNER JOIN IzbenkaFin.dbo.ArticleBin2UID as ArticleBin2UID (nolock)
		|						ON Chl.id_tov_cl = ArticleBin2UID.id_tov
		|						WHERE Chl.date_ch = '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-dd") + "' and Chl.id_tt_cl = " + Формат(ТТ.id_TT, "ЧГ=0") + " and Chl.OperationType_cl IN (1, 201, 3, 202, 203)
		|						GROUP BY Chl.CheckUid) as Chl ON Ch.CheckUID = Chl.CheckUid
		|where Ch.CloseDate >= '" + Формат(НачалоДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "' and Ch.CloseDate <= '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "' and Ch.OperationType IN (1, 201, 3, 202, 203)
		|and Ch.ShopNo IN (" + ТТ.НомерТочки + ") and Ch.CashCheckNo = " + Формат(НомерЧека, "ЧН=; ЧГ=0") + "
		|";
		
		rs = ADOСоединение.Execute(СтрЗапрос);
		
		Попытка
			rs.MoveFirst();
			
			Пока НЕ rs.EOF() Цикл
				СтруктураЧек = Новый Структура();
				СтруктураЧек.Вставить("УИНЧека", Rs.Fields("CheckUID").Value);
				СтруктураЧек.Вставить("НомерДокумента", Rs.Fields("CashCheckNo").Value);
				СтруктураЧек.Вставить("СуммаЧека", Rs.Fields("BaseSum").Value);
				СтруктураЧек.Вставить("СуммаПоНдс10", Rs.Fields("SummaPoNDS10").Value);
				СтруктураЧек.Вставить("СуммаПоНдс18", Rs.Fields("SummaPoNDS18").Value);
				Если СтруктураЧек.СуммаЧека < 0 Тогда
					СтруктураЧек.СуммаЧека = СтруктураЧек.СуммаЧека * (-1)
				КонецЕсли;
				Если СтруктураЧек.СуммаПоНдс10 < 0 Тогда
					СтруктураЧек.СуммаПоНдс10 = СтруктураЧек.СуммаПоНдс10 * (-1)
				КонецЕсли;
				Если СтруктураЧек.СуммаПоНдс18 < 0 Тогда
					СтруктураЧек.СуммаПоНдс18 = СтруктураЧек.СуммаПоНдс18 * (-1)
				КонецЕсли;
				МассивВозврат.Добавить(СтруктураЧек);
				rs.MoveNext();
			КонецЦикла;
		Исключение
		КонецПопытки;
	Иначе
		СтрСоедиение = ОбменСAccess.ПолучитьСтрокуСоединения("sms_union");
		
		ADOСоединение.ConnectionString  = СтрСоедиение;
		ADOСоединение.Open();
		
		СтрЗапрос = "SELECT Ch.CheckUID, Ch.CashCheckNo,
		|  Ch.BaseSum,
		|  Chl.SummaPoNDS10 as SummaPoNDS10,
		|  Chl.SummaPoNDS18 as SummaPoNDS18
		|FROM [SMS_UNION].[dbo].[Checks] as Ch (nolock)
		|	LEFT OUTER JOIN (SELECT Chl.CheckUid As CheckUid,
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 10 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS10, 
		|				   				SUM(CASE WHEN ArticleBin2UID.Stavka = 18 THEN Chl.BaseSum * -1 ELSE 0 END) as SummaPoNDS18
		|						FROM [SMS_UNION].[dbo].[CheckLine] as Chl (nolock)
		|						INNER JOIN IzbenkaFin.dbo.ArticleBin2UID as ArticleBin2UID (nolock)
		|						ON Chl.id_tov_cl = ArticleBin2UID.id_tov
		|						WHERE Chl.date_ch = '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-dd") + "' and Chl.id_tt_cl = " + Формат(ТТ.id_TT, "ЧГ=0") + "
		|						GROUP BY Chl.CheckUid) as Chl ON Ch.CheckUID = Chl.CheckUid
		|where Ch.CloseDate >= '" + Формат(НачалоДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "' and Ch.CloseDate <= '" + Формат(КонецДня(Дата), "ДФ=yyyy-MM-ddTHH:mm:ss") + "'
		|and Ch.ShopNo = " + Формат(ТТ.НомерТочки, "ЧГ=0") + " and Ch.CashCheckNo = " + Формат(НомерЧека, "ЧН=; ЧГ=0") + "
		|";
		
		rs = ADOСоединение.Execute(СтрЗапрос);
		
		Попытка
			rs.MoveFirst();
			
			Пока НЕ rs.EOF() Цикл
				СтруктураЧек = Новый Структура();
				СтруктураЧек.Вставить("УИНЧека", Rs.Fields("CheckUID").Value);
				СтруктураЧек.Вставить("НомерДокумента", Rs.Fields("CashCheckNo").Value);
				СтруктураЧек.Вставить("СуммаЧека", Rs.Fields("BaseSum").Value);
				СтруктураЧек.Вставить("СуммаПоНдс10", Rs.Fields("SummaPoNDS10").Value);
				СтруктураЧек.Вставить("СуммаПоНдс18", Rs.Fields("SummaPoNDS18").Value);
				Если СтруктураЧек.СуммаЧека < 0 Тогда
					СтруктураЧек.СуммаЧека = СтруктураЧек.СуммаЧека * (-1)
				КонецЕсли;
				Если СтруктураЧек.СуммаПоНдс10 < 0 Тогда
					СтруктураЧек.СуммаПоНдс10 = СтруктураЧек.СуммаПоНдс10 * (-1)
				КонецЕсли;
				Если СтруктураЧек.СуммаПоНдс18 < 0 Тогда
					СтруктураЧек.СуммаПоНдс18 = СтруктураЧек.СуммаПоНдс18 * (-1)
				КонецЕсли;
				МассивВозврат.Добавить(СтруктураЧек);
				rs.MoveNext();
			КонецЦикла;
		Исключение
		КонецПопытки;
	КонецЕсли;	
	
	ADOСоединение.Close();
	
	Возврат МассивВозврат;
	
КонецФункции	


&НаКлиенте
Процедура ЧекиСуммаЧекаПриИзменении(Элемент)
	
	ТекДанные = Элементы.Чеки.ТекущиеДанные;
	Если ТекДанные.СуммаЧека <> 0 Тогда
		ЧекиМассив = ПолучитьМассивЧеков(ТекДанные.СуммаЧека);
	КонецЕсли;
	
	Если ЧекиМассив.Количество() = 0 Тогда
		НомерДокумента = 0;
		Если ВвестиЧисло(НомерДокумента, "Чек не найден, введите номер", 10, 0) Тогда
			ЧекиПоНомеру = ПолучитьЧекПоНомеру(НомерДокумента);
			Если ЧекиПоНомеру.Количество() > 0 Тогда
				ТекДанные.СуммаПоНДС10 = ЧекиПоНомеру[0].СуммаПоНдс10;
				ТекДанные.СуммаПоНдс18 = ЧекиПоНомеру[0].СуммаПоНдс18;
				ТекДанные.УинЧека = ЧекиПоНомеру[0].УИНЧека;
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Чек с таким номером не найден");
				КоэффициентВыручкиПоНДС10 = ?(СуммаПоНДС10 + СуммаПоНДС18 = 0, 1, СуммаПоНДС10 / (СуммаПоНДС10 + СуммаПоНДС18));
				ТекДанные.СуммаПоНдс10 = ТекДанные.СуммаЧека * КоэффициентВыручкиПоНДС10;
				ТекДанные.СуммаПоНДС18 = ТекДанные.СуммаЧека - ТекДанные.СуммаПоНдс10;
			КонецЕсли;	
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Чек с такой суммой не найден");
			КоэффициентВыручкиПоНДС10 = ?(СуммаПоНДС10 + СуммаПоНДС18 = 0, 1, СуммаПоНДС10 / (СуммаПоНДС10 + СуммаПоНДС18));
			ТекДанные.СуммаПоНдс10 = ТекДанные.СуммаЧека * КоэффициентВыручкиПоНДС10;
			ТекДанные.СуммаПоНДС18 = ТекДанные.СуммаЧека - ТекДанные.СуммаПоНдс10;
		КонецЕсли;	
	ИначеЕсли ЧекиМассив.Количество() = 1 Тогда
		ТекДанные.СуммаПоНДС10 = ЧекиМассив[0].СуммаПоНдс10;
		ТекДанные.СуммаПоНдс18 = ЧекиМассив[0].СуммаПоНдс18;
		ТекДанные.УинЧека = ЧекиМассив[0].УИНЧека;
	Иначе
		СписокКВыбору = Новый СписокЗначений();
		Для Каждого ЭлементМассив Из ЧекиМассив Цикл
			СписокКВыбору.Добавить(ЭлементМассив, ЭлементМассив.НомерДокумента);
		КонецЦикла;	
		Выбранный = СписокКВыбору.ВыбратьЭлемент("Выберите номер чека");
		Если Выбранный <> Неопределено Тогда
			ТекДанные.СуммаПоНДС10 = Выбранный.Значение.СуммаПоНдс10;
			ТекДанные.СуммаПоНдс18 = Выбранный.Значение.СуммаПоНдс18;
			ТекДанные.УинЧека = Выбранный.Значение.УИНЧека;
		Иначе
			ТекДанные.СуммаПоНДС10 = ТекДанные.СуммаЧека;
		КонецЕсли;	
	КонецЕсли;
	
	Если ТекДанные.СуммаПоНдс10 + ТекДанные.СуммаПоНДС18 <> ТекДанные.СуммаЧека Тогда
		КоэффициентВыручкиПоНДС10 = ?(СуммаПоНДС10 + СуммаПоНДС18 = 0, 1, СуммаПоНДС10 / (СуммаПоНДС10 + СуммаПоНДС18));
		ТекДанные.СуммаПоНдс10 = ТекДанные.СуммаЧека * КоэффициентВыручкиПоНДС10;
		ТекДанные.СуммаПоНДС18 = ТекДанные.СуммаЧека - ТекДанные.СуммаПоНдс10;
	КонецЕсли;	
	
КонецПроцедуры
