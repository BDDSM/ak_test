﻿
&НаКлиенте
Процедура ЗакрытьТекФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВБД(Команда)
	Если Добавление = 1 И Вопрос("Желаете записать новый элемент в базу?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		ЗаписатьВБДНаСервере();
		Закрыть();
	Иначе
		
	КонецЕсли;	
	
КонецПроцедуры


&НаСервере
Процедура ЗаписатьВБДНаСервере()
	
	//+++АК SHEP 2018.05.24 ИП-00018711
	НомераТТСтрокой = "";
	Если СписокМагазинов.Количество() > 0 Тогда
		СоответствиеТТНомерТочки = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СписокМагазинов.ВыгрузитьЗначения(), "НомерТочки");
		Для Каждого КлючИЗначение Из СоответствиеТТНомерТочки Цикл
			ТекЗнач = КлючИЗначение.Значение;
			Если НЕ ЗначениеЗаполнено(ТекЗнач) Тогда Продолжить; КонецЕсли;
			НомераТТСтрокой = НомераТТСтрокой + ?(ПустаяСтрока(НомераТТСтрокой), "", ",") + ВнешниеДанные.ФорматПоля(ТекЗнач);
		КонецЦикла;
	КонецЕсли;
	//---АК SHEP 2018.05.24
	
	ТекстЗапроса = "INSERT INTO [Loyalty].[dbo].[Types_coupon]
	|([name_coupon]
	|,[date_st]
	|,[date_fi]
	|,[Sum_check]
	|,[Sum_coupon]
	//+++АК SHEP 2018.05.24 ИП-00018711
	|,[Shops_Coupon]
	//---АК SHEP 2018.05.24
	//+++AK GOLV 2018.11.14 ИП-00020425      
	|,[for_Sale]
	//---AK GOLV 2018.11.14
	|,[kind])
	|VALUES 
	|";
	
	ТекстЗапроса = ТекстЗапроса +"('"+ name_coupon +"', ";	
	ТекстЗапроса = ТекстЗапроса +"'"+ date_st +"', ";
	ТекстЗапроса = ТекстЗапроса +"'"+ date_fi +"', "; 
	ТекстЗапроса = ТекстЗапроса +""+ Формат(Sum_check,"ЧН=0; ЧГ=0") +", ";
	ТекстЗапроса = ТекстЗапроса +""+ Формат(Sum_coupon,"ЧН=0; ЧГ=0") +", ";
	ТекстЗапроса = ТекстЗапроса +""+ ВнешниеДанные.ФорматПоля(НомераТТСтрокой) +", "; //+++АК SHEP 2018.05.24 ИП-00018711
	//+++AK GOLV 2018.11.14 ИП-00020425      
	ТекстЗапроса = ТекстЗапроса + ?(for_Sale, "1", "0")  +", "; 
	//---AK GOLV 2018.11.14	
	ТекстЗапроса = ТекстЗапроса +""+ kind +")"	;
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение("10.0.0.40");
	
	Если ADOСоединение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ADOСоединение.Execute(ТекстЗапроса);	
	ADOСоединение.Close();
		
КонецПроцедуры

//+++АК SHEP 2018.05.24 ИП-00018711
&НаКлиенте
Процедура СписокМагазиновНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокМагазиновДляВыбора = Новый СписокЗначений;
	СписокМагазиновДляВыбора.ЗагрузитьЗначения(ПолныеПрава.ПолучитьМассивМагазинов(, Истина));
	
	Для Каждого ЭлементСписка Из СписокМагазинов Цикл
		СписокМагазиновДляВыбора.НайтиПоЗначению(ЭлементСписка.Значение).Пометка = Истина;
	КонецЦикла;
	
	Оповещение = Новый ОписаниеОповещения("СписокМагазиновПослеОтметкиЭлементов", ЭтаФорма);
	СписокМагазиновДляВыбора.ПоказатьОтметкуЭлементов(Оповещение, "Выберите магазины...");
	
КонецПроцедуры

//+++АК SHEP 2018.05.24 ИП-00018711
&НаКлиенте
Процедура СписокМагазиновПослеОтметкиЭлементов(Список, Параметры) Экспорт
	
	СписокМагазинов.Очистить();
	
	Если Список = Неопределено Тогда Возврат; КонецЕсли;
	
	Для Каждого ЭлементСписка Из Список Цикл
		Если ЭлементСписка.Пометка Тогда
			СписокМагазинов.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

