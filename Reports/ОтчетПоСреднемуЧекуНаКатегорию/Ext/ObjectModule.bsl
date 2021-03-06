﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	
	ДатаНачала = '00010101';
	ДатаОкончания = '00010101';
	Категория=Справочники.Номенклатура.ПустаяСсылка();
	Для Каждого ПользПоле Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И Строка(ПользПоле.Параметр) = "Период" Тогда
			ДатаНачала = ПользПоле.Значение.ДатаНачала;
			ДатаОкончания = КонецДня(ПользПоле.Значение.ДатаОкончания);
		КонецЕсли;	
		Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И Строка(ПользПоле.Параметр) = "Категория" И ПользПоле.Использование Тогда
			Категория = ПользПоле.Значение;
		КонецЕсли;		
	КонецЦикла;
	СтандартнаяОбработка = Ложь;
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение("10.0.0.40");
	
	Если ADOСоединение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапросаSQL =
		"SELECT
		|	(vt.CheckUID) CheckUID,
		|	 (kat._description) podkat,
		|	 (kat1._description) kat,
		|	sum(vt.BaseSum) BaseSum,
		|   vt.CloseDate
		|From(
		|SELECT
	    |	dbo_CheckLine.id_tov_cl  id_tov, 
		|	dbo_CheckLine.CheckUID,
		|	sum(dbo_CheckLine.BaseSum) BaseSum,
		|   cast(cast(dbo_Checks.CloseDate-datepart(weekday,dbo_Checks.CloseDate)+1 as date)as datetime) CloseDate
		|
		| FROM [SMS_UNION].[dbo].[CheckLine] (nolock) as dbo_CheckLine
		|	inner join 	 SMS_Union.dbo.Checks (nolock) as dbo_Checks on (dbo_CheckLine.CheckUID = dbo_Checks.CheckUID
        |	and dbo_Checks.CloseDate BETWEEN " + ВнешниеДанные.ФорматПоля(НачалоДня(ДатаНачала))+" and " + ВнешниеДанные.ФорматПоля(КонецДня(ДатаОкончания))+ "
		| and dbo_Checks.OperationType IN (1))
		|group by dbo_CheckLine.id_tov_cl, 
		|	dbo_CheckLine.CheckUID,
		|cast(cast(dbo_Checks.CloseDate-datepart(weekday,dbo_Checks.CloseDate)+1 as date)as datetime)) vt
		| 	Inner Join IzbenkaFin.._Reference29 as SprTovary (nolock) 
		| 	Inner Join IzbenkaFin.._Reference29 as Kat (nolock)
		| 	Inner Join IzbenkaFin.._Reference29 as Kat1 (nolock) on Kat1._fld760 is null and Kat._fld760 is null and Kat1._idrref=Kat._parentidrref  
		|	on   Kat._fld760 is null  and Kat._idrref=SprTovary._parentidrref 
		|	on vt.id_tov=SprTovary._fld760
		|	"+?(ЗначениеЗаполнено(Категория),"where Kat._Code="+ВнешниеДанные.ФорматПоля((Категория.Код))+" or "+" isnull(Kat1._Code,1)="+ВнешниеДанные.ФорматПоля((Категория.Код)),"")+" 
		|group by 		
		|	 (kat._description) ,CheckUID,
		|	 (kat1._description) ,  
		|   vt.CloseDate";
	ТЗНоменклатура=Новый ТаблицаЗначений;
	ТЗНоменклатура.Колонки.Добавить("НеделяДата",Новый ОписаниеТипов("Дата"));
	ТЗНоменклатура.Колонки.Добавить("Категория",Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(30)));
	ТЗНоменклатура.Колонки.Добавить("Подкатегория",Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(30)));
	ТЗНоменклатура.Колонки.Добавить("Чек",Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(50)));
	ТЗНоменклатура.Колонки.Добавить("Сумма",Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 3)));
	ТЗНоменклатура.Колонки.Добавить("Неделя",Новый ОписаниеТипов("Число"));
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);

	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	Номенклатура.Ссылка,
	//	|	Номенклатура.Код
	//	|ИЗ
	//	|	Справочник.Номенклатура КАК Номенклатура
	//	|ГДЕ
	//	|	Номенклатура.ЭтоГруппа = ИСТИНА";

	//Результат = Запрос.Выполнить();

	//ТЗГруппы = Результат.Выгрузить();
 
	
	
	Попытка
		rs.MoveFirst();
		//
		Сч=0;
		Пока НЕ rs.EOF() Цикл
			Сч=Сч+1;
			//ТекКатегория=Неопределено;
			//ТекПодкатегория=Неопределено;
			//Если ЗначениеЗаполнено(Rs.Fields("kat").Value) Тогда
			//	ТекКатегория=ТЗГруппы.НайтиСтроки(Новый Структура("Код",Rs.Fields("kat").Value))[0].Ссылка;
			//КонецЕсли; 
			//Если ЗначениеЗаполнено(Rs.Fields("podkat").Value) Тогда
			//	ТекПодкатегория=ТЗГруппы.НайтиСтроки(Новый Структура("Код",Rs.Fields("podkat").Value))[0].Ссылка;
			//КонецЕсли; 
			//Если ЗначениеЗаполнено(Категория) Тогда
			//	Если Не ТекПодкатегория.ПринадлежитЭлементу(Категория) Тогда
			//		rs.MoveNext();
			//		Продолжить;	
			//	КонецЕсли; 
			//КонецЕсли; 
			НовСтр=ТЗНоменклатура.Добавить();
			НовСтр.Категория=Rs.Fields("kat").Value;
			НовСтр.Подкатегория=Rs.Fields("podkat").Value;
			НовСтр.Сумма=Rs.Fields("BaseSum").Value;
			НовСтр.НеделяДата=Rs.Fields("CloseDate").Value;
			НовСтр.Чек=Rs.Fields("CheckUID").Value;
			НовСтр.Неделя=	(НачалоНедели(ТекущаяДата())-НовСтр.НеделяДата)/(7*24*60*60);
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;


	
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("НаборДанных1", ТЗНоменклатура);
	
	//Макет компоновки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	//Компоновка данных
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	//Вывод результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
КонецПроцедуры
