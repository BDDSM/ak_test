﻿
//+++АК LATV 2018.11.30 ИП-00020296
Функция КодДляВыполненияВПериодическихЗаданиях(ТекущаяОбработка, Параметры) Экспорт

	Получатели = Справочники.ПериодическиеЗадания.ПолучателиРассылки(ТекущаяОбработка);
	
	// Выполнение отчета
	ВыполняемыйОтчет = Отчеты.МониторингЗагрузкиРаспределения.Создать();
	
	ВыполняемыйОтчет.КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Вставить("РежимРассылки");
	ВыполняемыйОтчет.КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Вставить("Получатели", Получатели);
	
	ВыполняемыйОтчет.СкомпоноватьРезультат(Новый ТабличныйДокумент, Неопределено);

КонецФункции
