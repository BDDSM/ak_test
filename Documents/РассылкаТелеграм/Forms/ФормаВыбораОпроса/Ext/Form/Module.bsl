
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	 
	ТекстЗапроса = 
	"SELECT [BOT_Poll].[id_poll], isNULL([BOT_Poll].subject, '') as subject,[BOT_Poll].[Name_poll],[keyboard_id],
	|COUNT(DISTINCT BOT_PollAnswer_List.id_answer) as answers_count ,COUNT(DISTINCT BOT_Polling_Answer.telegram_id) as answers
	|FROM [Telegram].[dbo].[BOT_Poll] as BOT_Poll left join [Telegram].dbo.BOT_PollAnswer_List as BOT_PollAnswer_List on BOT_Poll.id_poll = BOT_PollAnswer_List.id_poll
	|left join [Telegram].dbo.BOT_Polling_Answer as BOT_Polling_Answer on BOT_Poll.id_poll = BOT_Polling_Answer.id_poll
	|GROUP BY BOT_Poll.id_poll, [BOT_Poll].[Name_poll], [BOT_Poll].[keyboard_id], [BOT_Poll].subject";
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса);	
	РТЗ = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);	
	ЭтаФорма.ТЗ.Загрузить(РТЗ);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьЭлементОпроса();
	
КонецПроцедуры

&НаКлиенте
Процедура ТЗВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыбратьЭлементОпроса();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЭлементОпроса()
	
	Имя = Элементы.ТЗ.ТекущиеДанные.subject;	
	Текст = Элементы.ТЗ.ТекущиеДанные.Name_poll;
	Клавиатура = Элементы.ТЗ.ТекущиеДанные.keyboard_id;
	id_Poll = Элементы.ТЗ.ТекущиеДанные.id_Poll;
	
	ЭтаФорма.ВладелецФормы.Объект.Опрос = Имя;
	ЭтаФорма.ВладелецФормы.Объект.ТекстСообщения = Текст;
	ЭтаФорма.ВладелецФормы.Объект.Клавиатура = Клавиатура;
	ЭтаФорма.ВладелецФормы.Объект.id_Poll = id_Poll;
	ЭтаФорма.ВладелецФормы.Модифицированность = Истина;
		
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	Результат = ОткрытьФормуМодально("Обработка.Опросы.Форма.ФормаЭлемента",,ЭтаФорма);
	ЗаполнитьТаблицу();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицу()
	
	ТекстЗапроса = 
	"SELECT [BOT_Poll].[id_poll], isNULL([BOT_Poll].subject, '') as subject,[BOT_Poll].[Name_poll],[keyboard_id],
	|COUNT(DISTINCT BOT_PollAnswer_List.id_answer) as answers_count ,COUNT(DISTINCT BOT_Polling_Answer.telegram_id) as answers
	|FROM [Telegram].[dbo].[BOT_Poll] as BOT_Poll left join [Telegram].dbo.BOT_PollAnswer_List as BOT_PollAnswer_List on BOT_Poll.id_poll = BOT_PollAnswer_List.id_poll
	|left join [Telegram].dbo.BOT_Polling_Answer as BOT_Polling_Answer on BOT_Poll.id_poll = BOT_Polling_Answer.id_poll
	|GROUP BY BOT_Poll.id_poll, [BOT_Poll].[Name_poll], [BOT_Poll].[keyboard_id], [BOT_Poll].subject";
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса);	
	РТЗ = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);	
	ЭтаФорма.ТЗ.Загрузить(РТЗ);
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	РедактироватьСтроку();
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСтроку()
	ТД = Элементы.ТЗ.ТекущиеДанные;
	Если НЕ ТД = Неопределено Тогда
		ПараметрыФормы = Новый Структура("id_poll", ТД.id_poll);
		Результат = ОткрытьФормуМодально("Обработка.Опросы.Форма.ФормаЭлемента",ПараметрыФормы,ЭтаФорма);
	КонецЕсли;
	ЗаполнитьТаблицу();
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	ТД = Элементы.ТЗ.ТекущиеДанные;
	
	Если ТД = Неопределено  Тогда
		Возврат;
	ИначеЕсли ТД.answers > 0 Тогда
		Сообщить("По этому опросу есть ответы!", СтатусСообщения.Важное);
		Возврат;
	ИначеЕсли Вопрос("Удалить опрос?", РежимДиалогаВопрос.ДаНетОтмена) = КодВозвратаДиалога.Да Тогда
		УдалитьНаСервере(ТД.id_poll);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНаСервере(id_poll)	
	ТекстЗапроса = 
	"DELETE FROM [Telegram].[dbo].[BOT_Poll] WHERE id_poll = " + Формат(id_poll, "ЧН=0; ЧГ=");	
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса);
	ЗаполнитьТаблицу();	
КонецПроцедуры

