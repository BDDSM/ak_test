﻿
///////////////////////////////////////////////////////////////////////////////
// ИНФОРМАЦИОННЫЕ БАЗЫ ДЛЯ ОБМЕНА
//////////////////////////////////////////////////////////////////////////////

Процедура ОткрытьФормуВыполненияОбменаРИБ() Экспорт
	
	ФормаВыполненияОбмена = ПолучитьОбщуюФорму("ФормаВыполненияОбменаДанными");
	ФормаВыполненияОбмена.ОтборПоТипуПланаОбмена = ПланыОбмена.Полный.ПустаяСсылка();
		
	ФормаВыполненияОбмена.Открыть();
	
КонецПроцедуры

Процедура ОткрытьФормуВыполненияОбменаРИБПоОрганизации() Экспорт
	
	ФормаВыполненияОбмена = ПолучитьОбщуюФорму("ФормаВыполненияОбменаДанными");
	ФормаВыполненияОбмена.ОтборПоТипуПланаОбмена = ПланыОбмена.ПоОрганизации.ПустаяСсылка();
		
	ФормаВыполненияОбмена.Открыть();
	
КонецПроцедуры
	
Процедура ОткрытьМониторОбменовДляОбменаРИБ() Экспорт
	
	ФормаМонитора = ПолучитьОбщуюФорму("МониторНастроекОбменаДанными");
	ФормаМонитора.ТипДанныхДляПоказа = ПланыОбмена.ОбменРозницаЗарплатаИУправлениеПерсоналом.ПустаяСсылка();
	ФормаМонитора.Открыть();	
	
КонецПроцедуры

Процедура ОткрытьМониторОбменовДляОбменаРИБПоОрганизации() Экспорт
	
	ФормаМонитора = ПолучитьОбщуюФорму("МониторНастроекОбменаДанными");
	ФормаМонитора.ТипДанныхДляПоказа = ПланыОбмена.ПоОрганизации.ПустаяСсылка();
	ФормаМонитора.Открыть();	
	
КонецПроцедуры
