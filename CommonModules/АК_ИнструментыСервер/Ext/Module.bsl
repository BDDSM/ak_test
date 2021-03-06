﻿
//+++АК sole 2018.06.04 ИП-00018850
Функция СоздатьВременныйФайлНаСервере(СтрокаBase64, РасширениеФайла) Экспорт
	
	Перем ИмяФайлаНаСервере, дд;
	
	дд = Base64Значение(СтрокаBase64);
	ИмяФайлаНаСервере = ПолучитьИмяВременногоФайла(РасширениеФайла);
	дд.Записать(ИмяФайлаНаСервере);
	
	Возврат ИмяФайлаНаСервере;
	
КонецФункции

//+++АК sole 2018.06.07 ИП-00018850
Процедура ВыполнитьПроцедуруНаСервере_Сервер(ИмяПроцедуры, АдресВХранилище) Экспорт
	мПараметры = ПолучитьИзВременногоХранилища(АдресВХранилище);
	УдалитьИзВременногоХранилища(АдресВХранилище);
	
	ВыполняемыйКод = "";
	
	Для Инд = 0 По мПараметры.ВГраница() Цикл
		Параметр = мПараметры[Инд];
		ВыполняемыйКод = ВыполняемыйКод + ", мПараметры[" + Формат(Инд, "ЧГ=0; ЧН=0") + "]";
	КонецЦикла;
	ВыполняемыйКод = Сред(ВыполняемыйКод, 2, СтрДлина(ВыполняемыйКод));
	
	ВыполняемыйКод = ИмяПроцедуры + "(" + ВыполняемыйКод + ");" ;
	
	Выполнить(ВыполняемыйКод);
	
КонецПроцедуры

//+++АК sole 2018.06.09 ИП-00018850
Функция ОбновитьФайлВложение_Сервер(ИмяФайла, ИмяФайлаНаСервере, СправочникФайлыСсылка) Экспорт
	
	Если СправочникФайлыСсылка = Справочники.Файлы.ПустаяСсылка() Тогда
		оФайл = Справочники.Файлы.СоздатьЭлемент(); 	
	Иначе
		оФайл = СправочникФайлыСсылка.ПолучитьОбъект();
	КонецЕсли;	
	
	оФайл.ИмяФайла = ИмяФайла;
	оФайл.ИмяФайлаНаСервере = ИмяФайлаНаСервере;
	оФайл.Записать();
	
	Возврат оФайл.Ссылка;
	
КонецФункции

//+++АК sole 2018.06.09 ИП-00018850
Функция ПолучитьДанныеИзХранилищаФайлов_Сервер(СправочникФайлыСсылка) Экспорт
	Перем СтрокаBase64;
	
	СтрокаBase64 = Base64Строка(АК_Инструменты.ПолучитьДанныеИзХранилищаФайлов(СправочникФайлыСсылка));
	
	Возврат СтрокаBase64;
КонецФункции

//