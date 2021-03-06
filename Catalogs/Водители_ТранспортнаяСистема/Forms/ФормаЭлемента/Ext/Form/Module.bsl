﻿
Процедура СгенерироватьКодДоступаНаСервере()
	
	ГСЧ = Новый ГенераторСлучайныхЧисел(Число(Формат(ТекущаяДата(), "ДФ=yyyyMMss")));
	Пока Истина Цикл
		СлучЧисло = "";
		Для н = 1 По 6 Цикл
			СлучЧисло = СлучЧисло + Строка(ГСЧ.СлучайноеЧисло(1, 9));
		КонецЦикла;
		Запрос = Новый Запрос();
		Запрос.Текст = "ВЫБРАТЬ
		               |	Водители_ТранспортнаяСистема.Ссылка
		               |ИЗ
		               |	Справочник.Водители_ТранспортнаяСистема КАК Водители_ТранспортнаяСистема
		               |ГДЕ
		               |	Водители_ТранспортнаяСистема.КодДоступа = &КодДоступа";
					   
		Запрос.УстановитьПараметр("КодДоступа", СлучЧисло);
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Объект.КодДоступа = СлучЧисло;
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура СгенерироватьКодДоступа(Команда)
	
	СгенерироватьКодДоступаНаСервере();
	
КонецПроцедуры
