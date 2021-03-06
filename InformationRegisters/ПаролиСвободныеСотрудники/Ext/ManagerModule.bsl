﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Генерирует пароль для входа в Web интерфейс свободно-занятых сотрудников
//
// Параметры:
//  Сотрудник  - <Тип.СправочникСсылка.ФизическиеЛица> - Физ. лицо.
//
// Возвращаемое значение:
//   Структура параметров <Тип.Структура>   - Структура параметров, содержащая Логин и Пароль
//
Функция СгенерироватьПарольСвободноЗанятогоСотрудника(Сотрудник) Экспорт
	
	ГСЧ = Новый ГенераторСлучайныхЧисел(ТекущаяУниверсальнаяДатаВМиллисекундах());
	
	Пароль = "";
	ИспользуемыеСимволы = "1243456789AQWERTYUIPASDFGHJKLZXCVBNMqwertyuipasdfghjklzxcvbnm";
	
	КвоСимволов = СтрДлина(ИспользуемыеСимволы);
	Пока СтрДлина(Пароль) < 7 Цикл
		НовыйСимвол = Сред(ИспользуемыеСимволы ,(ГСЧ.СлучайноеЧисло(1, КвоСимволов)),1);
		Пароль = Пароль + НовыйСимвол;
	КонецЦикла;        
	
	Возврат Новый Структура("Логин, Пароль", "L" + ОбщегоНазначения.ПолучитьЗначениеРеквизита(Сотрудник,"Код"), Пароль);
	  
КонецФункции // СгенерироватьПарольСвободноЗанятогоСотрудника()
 