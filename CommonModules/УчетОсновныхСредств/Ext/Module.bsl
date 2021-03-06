﻿
// Функция проверяет, доступен ли текущему пользователю передаваемый в качестве параметра счет учета в качестве счета учета ОС.
//
// Параметры;
//	мСчетУчета - ПланСчетовСсылка.Финансовый.
//
// Возвращаемое значение:
//	Булево.
//
Функция СчетУчетаЗабалансовыйРазрешен(мСчетУчета) Экспорт
	
	Перем Запрос, Выборка;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОграничениеПоСчетамДляОС.СчетУчетаЗабалансовый
	|ИЗ
	|	РегистрСведений.ОграничениеПоСчетамДляОС КАК ОграничениеПоСчетамДляОС
	|ГДЕ
	|	ОграничениеПоСчетамДляОС.Пользователь = &Пользователь";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 0 Тогда
		Возврат Истина;
	Иначе
		Пока Выборка.Следующий() Цикл
			Если Выборка.СчетУчетаЗабалансовый = мСчетУчета Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Функция определяет счет учета, указанный в последнем поступлении передаваемого в качестве параметра основного средства.
//
// Параметры:
// 	мОсновноеСредство 	- СправочникСсылка.ОсновныеСредства;
//	мДата				- Дата, дата, раньше которой были поступления ОС.
//
// Возвращаемое значение:
// 	ПланСчетовСсылка.Финансовый.
//
Функция ПолучитьСчетУчетаОС(мОсновноеСредство, мДата) Экспорт
	
	Перем Запрос, Выборка;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсновноеСредство", мОсновноеСредство);
	Запрос.УстановитьПараметр("Дата"			, мДата);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФинансовыйОстатки.Счет
	|ИЗ
	|	РегистрБухгалтерии.Финансовый.Остатки(&Дата, Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Финансовый.ОсновныеСредства)), , Субконто3 = &ОсновноеСредство) КАК ФинансовыйОстатки";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Счет;
	Иначе
		Возврат ПланыСчетов.Финансовый.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Функция определяет статью ДДС для передаваемого в качестве параметра основного средства
// как статью ДДС, указанную в последнем на дату (второй параметр) документе поступления данного ОС.
//
// Параметры:
// 	 мОсновноеСредство 	- СправочникСсылка.ОсновныеСредства;
//   мДата				- Дата.
//
Функция ПолучитьСтатьюДДСОС(мОсновноеСредство, мДата) Экспорт
	
	Перем Запрос, Выборка;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсновноеСредство", мОсновноеСредство);
	Запрос.УстановитьПараметр("Дата"			, мДата);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ПоступлениеОСНоменклатура.Ссылка.СтатьяДвиженияДенежныхСредств КАК СтатьяДДС
	|ИЗ
	|	Документ.ПоступлениеОС.Номенклатура КАК ПоступлениеОСНоменклатура
	|ГДЕ
	|	ПоступлениеОСНоменклатура.Ссылка.Дата < &Дата
	|	И ПоступлениеОСНоменклатура.Ссылка.Проведен
	|	И ПоступлениеОСНоменклатура.ОсновноеСредство = &ОсновноеСредство
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПоступлениеОСНоменклатура.Ссылка.МоментВремени УБЫВ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтатьяДДС;
	Иначе
		Возврат Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции
