﻿
&НаКлиенте
Процедура ВремяНачалаПриИзменении(Элемент)
	Объект.Наименование=Строка(Формат(Объект.ВремяНачала,"ДФ=HH:mm:ss"))+" - "+Строка(Формат(Объект.ВремяОкончания,"ДФ=HH:mm:ss"));
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияПриИзменении(Элемент)
	Объект.Наименование=Строка(Формат(Объект.ВремяНачала,"ДФ=HH:mm:ss"))+" - "+Строка(Формат(Объект.ВремяОкончания,"ДФ=HH:mm:ss"));
КонецПроцедуры
