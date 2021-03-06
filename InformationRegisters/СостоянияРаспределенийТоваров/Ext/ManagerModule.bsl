﻿
//+++АК SHEP 2018.07.26 ИП-00019254
//+++АК SHEP 2018.10.08 ИП-00020026: добавил комментарий
Процедура ИзменитьСостояние(УИДРаспределения, Состояние, Комментарий = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи = РегистрыСведений.СостоянияРаспределенийТоваров.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДата();
	МенеджерЗаписи.УИД = УИДРаспределения;
	МенеджерЗаписи.Состояние = Состояние;
	МенеджерЗаписи.Комментарий = Комментарий; //+++АК SHEP 2018.10.08 ИП-00020026
	МенеджерЗаписи.Пользователь = ОбщегоНазначенияПовтИсп.ТекущийПользовательСеанса();
	МенеджерЗаписи.Записать();
	
	//+++АК SHEP 2018.10.10 ИП-00020026: разблокируем товары
	Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияРаспределенияТоваров.РаспределениеЗавершено")
	ИЛИ Состояние = ПредопределенноеЗначение("Перечисление.СостоянияРаспределенияТоваров.ОшибкаРаспределения") Тогда
	
		МенЗап = РегистрыСведений.РаспределенияТоваров.СоздатьМенеджерЗаписи();
		МенЗап["УИД"] = УИДРаспределения;
		МенЗап.Прочитать();
		
		Если НЕ МенЗап.Выбран() Тогда Возврат; КонецЕсли;
		
		МассивИдТов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрЗаменить(МенЗап.ИдентификаторыТоваров, "'", ""), ",", Истина, Истина);
		
		КвоЭлтов = МассивИдТов.ВГраница();
		Для Сч = 0 По КвоЭлтов Цикл
			МассивИдТов[Сч] = Число(МассивИдТов[Сч]);
		КонецЦикла;
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Номенклатура.Ссылка,
			|	Номенклатура.id_tov
			|ИЗ
			|	Справочник.Номенклатура КАК Номенклатура
			|ГДЕ
			|	Номенклатура.id_tov В(&МассивИдТов)");
		Запрос.УстановитьПараметр("МассивИдТов", МассивИдТов);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			ДопМодульСервер.УстановитьПризнакБлокировкиДляРаспределения(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка"), МенЗап.СтруктурноеПодразделение, Ложь);
		КонецЕсли;
		
	КонецЕсли;
	//---АК SHEP 2018.10.10
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры
