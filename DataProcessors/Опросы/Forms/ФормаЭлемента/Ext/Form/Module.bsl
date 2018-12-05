&НаСервере
Процедура ЗаписатьНаСервере()
	
	Если НЕ (ЗначениеЗаполнено(Name_poll) ИЛИ ЗначениеЗаполнено(subject)) Тогда
		Возврат;
	КонецЕсли;
	
	Если type = "После покупки" Тогда
		type_send = "1";
	Иначе
		type_send = "0";
	КонецЕсли;
	
	ТекстЗапроса =
	"DECLARE @ret int, @id_poll as int=" + Формат(id_poll, "ЧН=0; ЧГ=") + ", @message as varchar(max)
	|EXEC @ret = Telegram.dbo.BOT_Poll_Update
	|@id_poll OUTPUT,
	|@Name_poll = N'" + СокрЛП(Name_poll) + "',
	|@comment = N'',
	|@max_count = " + Формат(max_count, "ЧН=0; ЧГ=") + ",
	|@real_count = " + Формат(real_count, "ЧН=0; ЧГ=") + ",
	|@keyboard_id = " + ?(keyboard = "Горизонтальные", "1001", "1000") + ",
	|@is_active = " + ?(is_active, "1", "0") + ",
	|@type_send = " + type_send + ",
	|@sum_check_after = " + Формат(sum_check_after, "ЧН=0; ЧГ=") + ",
	|@sum_check_before = " + Формат(sum_check_before, "ЧН=0; ЧГ=") + ",
	|@subject = N'" + СокрЛП(subject) + "',
	|@message = @message OUTPUT
	|SELECT @ret as ret, @id_poll as id_poll, @message as message";
	
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса);	
	ТЗ = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);			
	Если ТЗ.Количество()>0 Тогда
		id_poll = ТЗ[0].id_poll;
	КонецЕсли;
	
	Если ТаблицаИзменена Тогда
		
		ТекстЗапроса =
		"DELETE FROM Telegram.dbo.BOT_PollAnswer_List WHERE id_poll = " + Формат(id_poll, "ЧН=0; ЧГ=");
		Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса);	

		
		Для каждого Стр Из ТаблицаОтветов Цикл
		
			ТекстЗапроса =
			"INSERT INTO [Telegram].[dbo].[BOT_PollAnswer_List]
			|([id_poll],[id_answer],[name_answer])
			|VALUES
			|(" + Формат(id_poll, "ЧН=0; ЧГ=") + "
			|," + Формат(Стр.id_answer, "ЧН=0; ЧГ=") + "
			|,N'" + СокрЛП(Стр.name_answer) + "')";
			Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса);	
		
		КонецЦикла; 
		
	КонецЕсли;
	
	ОбновитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьНаСервере();
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("id_poll") Тогда
		id_poll = Параметры.id_poll;
		ОбновитьДанные();
	КонецЕсли;
	СписокРассылок.Параметры.УстановитьЗначениеПараметра("id_poll", Строка(id_poll));
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанные()
	
	// Шапка опроса
	ТекстЗапроса = 
	"SELECT [id_poll],[Name_poll],[date_add],[comment],[max_count],[real_count],
	|[keyboard_id],[is_active],[type_send],[sum_check_after],[sum_check_before],
	|isNULL([subject], 'Без названия') as [subject]
	|FROM [Telegram].[dbo].[BOT_Poll] WHERE id_poll = " + ФОрмат(id_poll, "ЧГ=");	
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса);	
	ТЗ = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);			
	Если ТЗ.Количество()>0 Тогда
		subject = ТЗ[0].subject;
		Name_poll = ТЗ[0].Name_poll;
		max_count = ТЗ[0].max_count;
		real_count = ТЗ[0].real_count;
		sum_check_after = ТЗ[0].sum_check_after;
		sum_check_before = ТЗ[0].sum_check_before;
		is_active = (ТЗ[0].is_active = 1);
		keyboard = ?(ТЗ[0].keyboard_id = 1000, "Вертикальные", "Горизонтальные");
		Если ТЗ[0].type_send = 1 Тогда
			type = "После покупки";
		Иначе
			type = "Нет";
		КонецЕсли;
	КонецЕсли;
	
	// Таблица ответов
	ТекстЗапроса = 
	"SELECT BOT_PollAnswer_List.id_answer ,[name_answer], ISNULL(answer_count, 0) as answer_count
	|FROM [Telegram].[dbo].[BOT_PollAnswer_List] as BOT_PollAnswer_List
	|LEFT JOIN
	|(SELECT COUNT(distinct telegram_id)as answer_count,[id_answer]
	|FROM [Telegram].[dbo].[BOT_Polling_Answer]
	|WHERE id_poll = " + Формат(id_poll, "ЧГ=") + " GROUP BY id_answer) as ans on BOT_PollAnswer_List.id_answer = ans.id_answer
	|WHERE id_poll = " + Формат(id_poll, "ЧГ=");
	
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса);	
	ТЗ = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);	
	ТаблицаОтветов.Очистить();
	Для каждого Стр Из ТЗ Цикл	
		НоваяСтрока = ТаблицаОтветов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Стр); 
	КонецЦикла; 
	ТаблицаИзменена = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтветовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ТаблицаИзменена = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтветовПослеУдаления(Элемент)
	ТаблицаИзменена = Истина;
КонецПроцедуры

&НаКлиенте
Процедура typeПриИзменении(Элемент)
	Если НЕ type = "После покупки" Тогда
		max_count = 0;
		real_count = 0;
		sum_check_after = 0;
		sum_check_before = 0;
	КонецЕсли;
КонецПроцедуры

//Раков П.с. Открытие документа рассылки ++
&НаКлиенте
Процедура СписокРассылокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	keyboard_id = ПолучитьКнопки();
	
	Форм = ПолучитьФорму("Документ.РассылкаТелеграм.ФормаОбъекта");
	
	Форм.Объект.Опрос = subject;
	Форм.Объект.Клавиатура = keyboard_id;
	Форм.Объект.ТекстСообщения = Name_poll;
	форм.Открыть();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКнопки()

	ТекстЗапроса = 
	"SELECT 
	|[keyboard_id]
	|FROM [Telegram].[dbo].[BOT_Poll] WHERE id_poll = " + ФОрмат(id_poll, "ЧГ=");	
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса);	
	ТЗ = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);			
	Если ТЗ.Количество()>0 Тогда
		Возврат ТЗ[0].keyboard_id;
	КонецЕсли;
	возврат "";

КонецФункции // ПолучитьКнопки()
//Раков П.с. --

//+++ АК rakp@automacon.ru, 16.11.2017 14:09:41,  ИП-00017259
Процедура ОбновитьтАблицуОтветов()
	
	Попытка
	
	ТаблицаОтветовТД.Очистить();
	
	Если НЕ ЗначениеЗаполнено(id_poll) тогда
		Возврат;
	КонецЕсли;	
	// Таблица ответов
	ТекстЗапроса = 
	"SELECT BOT_PollAnswer_List.id_answer ,[name_answer], ISNULL(answer_count, 0) as answer_count
	|FROM [Telegram].[dbo].[BOT_PollAnswer_List] as BOT_PollAnswer_List with (nolock)
	|LEFT JOIN
	|(SELECT COUNT(distinct telegram_id)as answer_count,[id_answer]
	|FROM [Telegram].[dbo].[BOT_Polling_Answer] with (nolock)
	|WHERE id_poll = " + Формат(id_poll, "ЧГ=") + " GROUP BY id_answer) as ans on BOT_PollAnswer_List.id_answer = ans.id_answer
	|WHERE id_poll = " + Формат(id_poll, "ЧГ=");
	
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса);	
	ТЗ = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);
	
	//ТекстЗапроса = 
	//"SELECT Answer.telegram_id , isnull(comment,'') as comment, date_add, FullName, id_answer, email 
	//|FROM [Telegram].[dbo].[BOT_Polling_Answer]  as Answer with(nolock)
	//|left join (SELECT  *
	//|FROM  [Loyalty].[dbo].[Customer] with (nolock)) as Loy on Answer.telegram_id = Loy.telegram_id
	//|WHERE id_poll = " + Формат(id_poll, "ЧГ=") +" order by case when comment IS NULL then 1 else 0 end, comment"; //+  and id_answer = " + Элемент.ТекущиеДанные.id_answer + "";
	
	ТекстЗапроса = 
	"SELECT Answer.telegram_id, comment, date_add, id_answer, FullName, Loy.number from 
	|(SELECT telegram_id , isnull(comment,'') as comment, date_add, id_answer, Number 
	|FROM [Telegram].[dbo].[BOT_Polling_Answer] (nolock) WHERE id_poll = " + Формат(id_poll, "ЧГ=") + ")  as Answer
	|left join [vv03].[dbo].[Cards] (nolock) as Loy on Answer.Number = Loy.number
	|order by case when comment IS NULL then 1 else 0 end, comment";	
	
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса);	
	ТЗ2 = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);
	
	Макет = обработки.Опросы.ПолучитьМакет("Макет");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ТаблицаОтветовТД.Вывести(Шапка);
	//ТаблицаОтветов.НачатьАвтогруппировкуСтрок();
	
	Если ТЗ2.Колонки.Количество() = 0 тогда
		ТЗ2.Колонки.Добавить("telegram_id");
		ТЗ2.Колонки.Добавить("comment");
		ТЗ2.Колонки.Добавить("date_add");
		ТЗ2.Колонки.Добавить("FullName");
		ТЗ2.Колонки.Добавить("id_answer");
		ТЗ2.Колонки.Добавить("number");
	КонецЕсли;
	
	для Каждого СтрокаТЗ из ТЗ цикл
		Итог = Макет.ПолучитьОбласть("Итог");
		Итог.Параметры.Заполнить(СтрокаТЗ);	
		ТаблицаОтветовТД.Вывести(Итог);
	КонецЦикла;	
	
	Ком = Макет.ПолучитьОбласть("Ком");
	ТаблицаОтветовТД.Вывести(Ком);
	
	для Каждого СтрокаТЗ из ТЗ цикл
		Строка = Макет.ПолучитьОбласть("Строка");
		Строка.Параметры.Заполнить(СтрокаТЗ);	
		СтрОтбора = новый Структура;
		СтрОтбора.Вставить("id_answer", СтрокаТЗ.id_answer);
		Ответы = ТЗ2.НайтиСтроки(СтрОтбора);
		Для Каждого СтроОтвета из Ответы цикл
			Строка.Параметры.Заполнить(СтроОтвета);	
			ТаблицаОтветовТД.Вывести(Строка);
		КонецЦикла;	
	КонецЦикла;		
	
	ТаблицаОтветовТД.ЗакончитьАвтогруппировкуСтрок();

	Исключение
		Сообщить("Не удалось сформировать таблицу ответов." + Символы.ПС + ОписаниеОшибки());
	КонецПопытки;
	//
	//ТекстЗапроса = 
	//"	SELECT BOT_PollAnswer_List.id_answer ,[name_answer], ISNULL(answer_count, 0) as answer_count, telegram_id, comment,date_add,FullName
	//|FROM [srv-sql03].[Telegram].[dbo].[BOT_PollAnswer_List] as BOT_PollAnswer_List 
	//|LEFT JOIN
	//|(SELECT COUNT(distinct telegram_id)as answer_count,[id_answer]
	//|FROM [srv-sql03].[Telegram].[dbo].[BOT_Polling_Answer]
	//|WHERE id_poll = " + Формат(id_poll, "ЧГ=") + " and par1 = '" + Объект.Номер  + "' GROUP BY id_answer) as ans on BOT_PollAnswer_List.id_answer = ans.id_answer
	//| LEFT join (
	//|SELECT Answer.telegram_id , comment, date_add, FullName, id_answer as IDANSWER 
	//|FROM [srv-sql03].[Telegram].[dbo].[BOT_Polling_Answer]  as Answer with(nolock)
	//|left join (SELECT  *
	//|FROM  [srv-sql02].[Loyalty].[dbo].[Customer]) as Loy on Answer.telegram_id = Loy.telegram_id WHERE id_poll = " + Формат(id_poll, "ЧГ=") + " and par1 = '" + Объект.Номер  + "' ) as Detail on BOT_PollAnswer_List.id_answer = IDANSWER 
	//|WHERE id_poll = " + Формат(id_poll, "ЧГ=");
	//Результат = ПолучитьРезультатЗапросаТЗ2(ТекстЗапроса);	
	//ТЗ = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтветы(Команда)
	ОбновитьтАблицуОтветов();
КонецПроцедуры

&НаКлиенте
Процедура Группа2ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	//+++ АК rakp@automacon.ru, 16.11.2017 14:08:43,  ИП-00017259
	Если ТекущаяСтраница.Имя = "Ответы" тогда
		ОбновитьтАблицуОтветов();
	КонецЕсли;	
	//--- АК rakp@automacon.ru
КонецПроцедуры
//--- АК rakp@automacon.ru
