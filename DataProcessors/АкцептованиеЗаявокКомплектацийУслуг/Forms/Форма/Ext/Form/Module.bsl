﻿
&НаКлиенте
Процедура Акцептовать(Команда)
	АкцептоватьСервер();
КонецПроцедуры

&НаСервере
Процедура АкцептоватьСервер()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КомплектацияМагазинаПоСделкамСПоставщикомУслугиПоСчетам.Ссылка КАК Ссылка,
		|	КомплектацияМагазинаПоСделкамСПоставщикомУслугиПоСчетам.Ссылка.Дата КАК Дата
		|ИЗ
		|	Документ.КомплектацияМагазинаПоСделкамСПоставщиком.УслугиПоСчетам КАК КомплектацияМагазинаПоСделкамСПоставщикомУслугиПоСчетам
		|ГДЕ
		|	КомплектацияМагазинаПоСделкамСПоставщикомУслугиПоСчетам.Ссылка.Проведен
		|	И КомплектацияМагазинаПоСделкамСПоставщикомУслугиПоСчетам.Заявка.Дата МЕЖДУ &Дата1 И &Дата2
		|
		|СГРУППИРОВАТЬ ПО
		|	КомплектацияМагазинаПоСделкамСПоставщикомУслугиПоСчетам.Ссылка,
		|	КомплектацияМагазинаПоСделкамСПоставщикомУслугиПоСчетам.Ссылка.Дата
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	Ссылка";

	Запрос.УстановитьПараметр("Дата1", Период.ДатаНачала);
	Запрос.УстановитьПараметр("Дата2", КонецДня(Период.ДатаОкончания));

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МасНомеров = Новый Массив;
		Для каждого СтрокаТЧ Из ВыборкаДетальныеЗаписи.Ссылка.УслугиПоСчетам Цикл
			Если  ЗначениеЗаполнено(СтрокаТЧ.Заявка) и СтрокаТЧ.Заявка.Статус=Перечисления.СтатусыЗаявокНаРасходованиеСредств.НеАкцептована 
				и СтрокаТЧ.Заявка.Дата>=Период.ДатаНачала и СтрокаТЧ.Заявка.Дата<=КонецДня(Период.ДатаОкончания) Тогда
				//ДокОбъект=СтрокаТЧ.Заявка.ПолучитьОбъект();
				//Если  Не НастройкаПравДоступа.ДокументВЗакрытомПериоде(ДокОбъект)  Тогда
					МасНомеров.Добавить(СтрокаТЧ.НомерСтроки);
				//КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;
		СоответствиеНомеровИЗаявок = Новый Соответствие;
		
		//
		Документы.КомплектацияМагазинаПоСделкамСПоставщиком.АкцептоватьЗаявкиСервер(ВыборкаДетальныеЗаписи.Ссылка, МасНомеров, СоответствиеНомеровИЗаявок);
	КонецЦикла;

	
КонецПроцедуры
