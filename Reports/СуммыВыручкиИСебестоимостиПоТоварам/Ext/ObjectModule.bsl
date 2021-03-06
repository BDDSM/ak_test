﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ДатаНачала = '00010101';
	ДатаОкончания = '00010101';
	Для Каждого ПользПоле Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И Строка(ПользПоле.Параметр) = "Период" Тогда
			ДатаНачала = ПользПоле.Значение.ДатаНачала;
			ДатаОкончания = КонецДня(ПользПоле.Значение.ДатаОкончания);
		КонецЕсли;	
	КонецЦикла;
	
	ТаблицаДанных = Новый ТаблицаЗначений();
	ТаблицаДанных.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаДанных.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДанных.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("СуммаПродаж", Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("СебестоимостьПродаж", Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("КоличествоВозврат", Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("СуммаВозврат", Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("СебестоимостьВозврат", Новый ОписаниеТипов("Число"));
								
	СтандартнаяОбработка = Ложь;
	
	ДатаОбработки = ДатаНачала;
	Пока ДатаОбработки <= ДатаОкончания Цикл
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("ТекДата", КонецДня(ДатаОбработки));
		Запрос.Текст = "ВЫБРАТЬ
		               |	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница,
		               |	ЦФОСтруктурныхЕдиницСрезПоследних.Организация
		               |ИЗ
		               |	РегистрСведений.ЦФОСтруктурныхЕдиниц.СрезПоследних(&ТекДата, ) КАК ЦФОСтруктурныхЕдиницСрезПоследних
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ВЗ_Запрос.Номенклатура,
		               |	МАКСИМУМ(ВЗ_Запрос.Цена) КАК Цена,
		               |	МАКСИМУМ(ВЗ_Запрос.Себестоимость) КАК Себестоимость
		               |ИЗ
		               |	(ВЫБРАТЬ
		               |		ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
		               |		ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
		               |		0 КАК Себестоимость
		               |	ИЗ
		               |		РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
		               |				&ТекДата,
		               |				ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.ОсновнойТипЦенПродаж)
		               |					И ТорговаяТочка = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)) КАК ЦеныНоменклатурыСрезПоследних
		               |	
		               |	ОБЪЕДИНИТЬ ВСЕ
		               |	
		               |	ВЫБРАТЬ
		               |		СебестоимостьТоваровСрезПоследних.Номенклатура,
		               |		0,
		               |		СебестоимостьТоваровСрезПоследних.Себестоимость
		               |	ИЗ
		               |		РегистрСведений.СебестоимостьТоваров.СрезПоследних(&ТекДата, ) КАК СебестоимостьТоваровСрезПоследних) КАК ВЗ_Запрос
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	ВЗ_Запрос.Номенклатура";
					   
		Результаты = Запрос.ВыполнитьПакет();
		ТабКешТТ = Результаты[0].Выгрузить();
		ТабКешТовары = Результаты[1].Выгрузить();
		ТабКешТТ.Индексы.Добавить("СтруктурнаяЕдиница");
		ТабКешТовары.Индексы.Добавить("Номенклатура");
		
		ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
		ТекстЗапроса = "create table #ls (id_tt int, id_tov int, 
					|	summa numeric(15, 3), rashod numeric(15, 3)
					|	, vozvrat_pok numeric(15, 3)) 
                    |
					|Insert into #ls
					|exec ('SELECT
					|	DTT.id_tt
					|	,DTT.id_tov
					|	,SUM([summa]) summa
					|	,SUM([quantity]) rashod
					|	,SUM([vozvrat_pok]) vozvrat_pok
					|FROM [vv03].[dbo].[DTT] DTT (nolock) 
                    |
					|where date_tt >= '" + ВнешниеДанные.ФорматПоля(Макс(ДатаНачала, НачалоМесяца(ДатаОбработки)), Истина) + "' and date_tt <= '" + ВнешниеДанные.ФорматПоля(Мин(ДатаОкончания, КонецМесяца(ДатаОбработки)), Истина) + "'
					|GROUP BY 
					|	DTT.id_tt, DTT.id_tov') at [SRV-SQL03]
					
					|	
					|CREATE INDEX index_idtt
					|ON #ls(id_tt)
					|
					|CREATE INDEX index_id_tov
					|ON #ls(id_tov)
					|
					|SELECT 
					//+++ AK suvv ИП-00018379
					//|	UINTT._Fld4946 as TTUID
					|   Case when UINTT._Fld4946 is NULL then '' else UINTT._Fld4946 end as TTUID
					//--- AK suvv	
					|	,UINTov._Fld4946 as TovarUID
					|	,[summa] summa
					|	,[rashod] rashod
					|	,[vozvrat_pok] vozvrat_pok
					|FROM #ls DTT (nolock) 
					|LEFT OUTER JOIN IzbenkaFin.dbo._InfoRg4943 UINTT (nolock) ON DTT.id_tt = UINTT._Fld4953 and UINTT._Fld4944_TYPE = 0x08 and UINTT._Fld4944_RTRef = 0x0000002A and UINTT._Fld4947 = 1
					|LEFT OUTER JOIN IzbenkaFin.dbo._InfoRg4943 UINTov (nolock) ON DTT.id_tov = UINTov._Fld4953 and UINTov._Fld4944_TYPE = 0x08 and UINTov._Fld4944_RTRef = 0x0000001D
					|LEFT OUTER JOIN IzbenkaFin.dbo._Reference29 TovSpr (nolock) ON DTT.id_tov = TovSpr._Fld760
					|WHERE TovSpr._Fld3860 = 0
					//+++ AK suvv ИП-00018379
					|and UINTov._Fld4946 is not NULL
					//--- AK suvv
                    |
					|";
	
		rs = ADOСоединение.Execute(ТекстЗапроса);
		Пока rs <> Неопределено И rs.Fields.Count <= 0 Цикл
			rs=rs.NextRecordSet();
		КонецЦикла;
			
		Попытка
			rs.MoveFirst();
			
			Пока НЕ rs.EOF() Цикл
				СтрокаДоб = ТаблицаДанных.Добавить();
				СтрокаДоб.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Rs.Fields("TovarUID").Value));
				//+++ AK suvv ИП-00018379
				//ТТСсылка = Справочники.СтруктурныеЕдиницы.ПолучитьСсылку(Новый УникальныйИдентификатор(Rs.Fields("TTUID").Value));
				TTUID = Rs.Fields("TTUID").Value;
				Если TTUID <> "" Тогда 
					ТТСсылка = Справочники.СтруктурныеЕдиницы.ПолучитьСсылку(Новый УникальныйИдентификатор(TTUID));
					//--- AK suvv
					СтрокаКешТТ = ТабКешТТ.Найти(ТТСсылка, "СтруктурнаяЕдиница");
					Если СтрокаКешТТ <> Неопределено Тогда
						СтрокаДоб.Организация = СтрокаКешТТ.Организация;
					КонецЕсли;
					//+++ AK suvv ИП-00018379
				КонецЕсли;
				//--- AK suvv
				СтрокаДоб.Количество = Rs.Fields("rashod").Value;
				СтрокаДоб.СуммаПродаж = Rs.Fields("summa").Value;
				СтрокаКешТовар = ТабКешТовары.Найти(СтрокаДоб.Номенклатура, "Номенклатура");
				Если СтрокаКешТовар <> Неопределено Тогда
					СтрокаДоб.СебестоимостьПродаж = СтрокаКешТовар.Себестоимость * СтрокаДоб.Количество;
				КонецЕсли;
				СтрокаДоб.КоличествоВозврат = Rs.Fields("vozvrat_pok").Value;
				Если СтрокаКешТовар <> Неопределено Тогда
					СтрокаДоб.СебестоимостьВозврат = СтрокаКешТовар.Себестоимость * СтрокаДоб.КоличествоВозврат;
					СтрокаДоб.СуммаВозврат = СтрокаКешТовар.Цена * СтрокаДоб.КоличествоВозврат;
				КонецЕсли;	
				rs.MoveNext();
			КонецЦикла;
		Исключение
		КонецПопытки;
		ADOСоединение.Close();
		ADOСоединение = Неопределено;
		
		
		ДатаОбработки = ДобавитьМесяц(ДатаОбработки, 1);
	КонецЦикла;	
	
	ТаблицаДанных.Свернуть("Организация, Номенклатура", "Количество, СуммаПродаж, СебестоимостьПродаж, КоличествоВозврат, СебестоимостьВозврат, СуммаВозврат");
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТабДанные", ТаблицаДанных);
	
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
