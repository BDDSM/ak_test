﻿
////////////////////////////////////////////////////////////////             
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПреобразоватьИз10ВСистемуСчисления(Число10, Система) Экспорт
	
	Если Система > 36 или Система < 2 тогда
		Сообщить("Выбранная Система исчисления не поддерживается");
		Возврат -1;
	КонецЕсли;
	
	СтрокаЗначений = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	СтрокаСистема = "";
	Пока Число10 > 0 цикл
		РезДеления = Число10/Система;
		ЧислоСистема = цел(РезДеления);
		остатокОтДеления = Число10 - Система*(ЧислоСистема);
		СтрокаСистема = сред(СтрокаЗначений,остатокОтДеления+1,1)+ СтрокаСистема;
		Число10 = ?(ЧислоСистема=0,0,РезДеления); 
	КонецЦикла;
	
	Нечётное = стрДлина(СтрокаСистема) - цел(стрДлина(СтрокаСистема)/2)*2;
	Если Нечётное тогда
		СтрокаСистема = "0"+СтрокаСистема;
	КонецЕсли;
	
	Возврат СтрокаСистема;
	
КонецФункции

Функция URLEncode(стр) Экспорт	
	
	Длина=СтрДлина(Стр);
	Итог="";
	Для Н=1 По Длина Цикл
		Знак=Сред(Стр,Н,1);
		Код=КодСимвола(Знак);
		
		если ((Знак>="a")и(Знак<="z")) или
			 ((Знак>="A")и(Знак<="Z")) или
			 ((Знак>="0")и(Знак<="9")) тогда
			Итог=Итог+Знак;
		Иначе
			Если (Код>=КодСимвола("А"))И(Код<=КодСимвола("п")) Тогда
				Итог=Итог+"%"+ПреобразоватьИз10ВСистемуСчисления(208,16)+"%"+ПреобразоватьИз10ВСистемуСчисления(144+Код-КодСимвола("А"),16);
			ИначеЕсли (Код>=КодСимвола("р"))И(Код<=КодСимвола("я")) Тогда
				Итог=Итог+"%"+ПреобразоватьИз10ВСистемуСчисления(209,16)+"%"+ПреобразоватьИз10ВСистемуСчисления(128+Код-КодСимвола("р"),16);
			ИначеЕсли (Знак="ё") Тогда
				Итог=Итог+"%"+ПреобразоватьИз10ВСистемуСчисления(209,16)+"%"+ПреобразоватьИз10ВСистемуСчисления(145,16);
			ИначеЕсли (Знак="Ё") Тогда
				Итог=Итог+"%"+ПреобразоватьИз10ВСистемуСчисления(208,16)+"%"+ПреобразоватьИз10ВСистемуСчисления(129,16);
			Иначе
				Итог=Итог+"%"+ПреобразоватьИз10ВСистемуСчисления(Код,16);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Итог;
	
КонецФункции

Функция ПреобразоватьИз16В10СистемуСчисления(Знач Значение)
	
	Значение = НРег(Значение);
	ДлинаСтроки = СтрДлина(Значение);
	
	Результат = 0;
	Для НомерСимвола = 1 По ДлинаСтроки Цикл
		Результат = Результат * 16 + Найти("0123456789abcdef", Сред(Значение, НомерСимвола, 1)) - 1;
	КонецЦикла;
	
	Возврат Формат(Результат, "ЧГ=0");
	
КонецФункции

Функция JSON_Encode(СтрокаJSON) Экспорт	
	
	ДлинаСтроки = СтрДлина(СтрокаJSON);
	Стр = "";
	Для Сч = 1 По ДлинаСтроки Цикл
		Симв = Сред(СтрокаJSON, Сч, 1);
		Если Симв = "\" И Сред(СтрокаJSON, Сч, 2) = "\u" Тогда
			Стр = Стр + Символ(ПреобразоватьИз16В10СистемуСчисления(Сред(СтрокаJSON, Сч + 2, 4)));
			Сч = Сч + 5;
		Иначе
			Стр = Стр + Симв;
		КонецЕсли;
	КонецЦикла;
	Возврат Стр;
	
КонецФункции

Функция ПолучитьДатуВремяИзUnixTime(unixtime) Экспорт
	
	Если ТипЗнч(unixtime) = Тип("Строка") Тогда
		unixtime = Число(unixtime);
	КонецЕсли;
	
	Возврат Дата("19700101") + unixtime;
	
КонецФункции

////////////////////////////////////////////////////////////////             
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБРАБОТКИ ОТВЕТОВ XML

Функция ПолучитьЗначениеУзлаXML(ЧтениеXML) Экспорт
	
	Значение = "";
	Имя = ЧтениеXML.ЛокальноеИмя;
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		ТипУзла = ЧтениеXML.ТипУзла;
		
		Если ТипУзла = ТипУзлаXML.Текст Тогда
			Значение = СокрП(ЧтениеXML.Значение);
			
		ИначеЕсли ЧтениеXML.ЛокальноеИмя = Имя И ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Прервать;
			
		Иначе
			Возврат Неопределено;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат XMLЗначение(Тип("Строка"), Значение);
	
КонецФункции

Процедура ПропуститьЭлементXML(ЧтениеXML) Экспорт

	КолвоВложений = 0; // количество одноименных вложений

	Имя = ЧтениеXML.ЛокальноеИмя;
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.ЛокальноеИмя <> Имя Тогда
			Продолжить;
		КонецЕсли;
		
		ТипУзла = ЧтениеXML.ТипУзла;
			
		Если ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
				
			Если КолвоВложений = 0 Тогда
					
				Прервать;
					
			Иначе
					
				КолвоВложений = КолвоВложений - 1;
					
			КонецЕсли;
				
		ИначеЕсли ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
			КолвоВложений = КолвоВложений + 1;
				
		КонецЕсли;
					
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаполнитьСтруктуруИзОтветаXML(ЧтениеXML) Экспорт
	
	Результат = Новый Структура;
	Имя = ЧтениеXML.ЛокальноеИмя;
	
	Пока ЧтениеXML.Прочитать() Цикл
		ТипУзла = ЧтениеXML.ТипУзла;
		
		Если ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			ЛокальноеИмяУзла = ЧтениеXML.ЛокальноеИмя;
			Если ЛокальноеИмяУзла = "attachment" ИЛИ ЛокальноеИмяУзла = "attachments" Тогда
				ПропуститьЭлементXML(ЧтениеXML);
				Продолжить;
			КонецЕсли;
			
			Результат.Вставить(ЛокальноеИмяУзла, ПолучитьЗначениеУзлаXML(ЧтениеXML));
			
		ИначеЕсли ЧтениеXML.ЛокальноеИмя = Имя И ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////             
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ И ОБРАБОТКИ ОТВЕТОВ JSON

Функция СформироватьСтрокуJSONИзМассива(Объект)
	
	СтрокаJSON = "[";
	
	Для каждого Элемент Из Объект Цикл
		//СтрокаJSON = СтрокаJSON + СформироватьСтрокуJSON(Элемент) + ",";
		
		Если ТипЗнч(Элемент) = Тип("Строка") Тогда
			//СтрокаJSON = СтрокаJSON + """" + РаботаСВнешнимВебСервером.URLEncode(Элемент) + """";
			СтрокаJSON = СтрокаJSON + """" + Элемент + """";
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("Число") Тогда
			СтрокаJSON = СтрокаJSON + СтрЗаменить(Строка(Элемент), Символы.НПП, "");
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("Булево") Тогда
			СтрокаJSON = СтрокаJSON + Формат(Элемент, "БЛ=false; БИ=true");
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("Дата") Тогда
			// преобразование в unixtime
			СтрокаJSON = СтрокаJSON + Формат(Элемент - Дата(1970,1,1,1,0,0), "ЧГ=0");
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("Массив") Тогда
			СтрокаJSON = СтрокаJSON + СформироватьСтрокуJSON(Элемент);
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("Структура") Тогда
			СтрокаJSON = СтрокаJSON + СформироватьСтрокуJSON(Элемент);
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("ТаблицаЗначений") Тогда
			СтрокаJSON = СтрокаJSON + СформироватьСтрокуJSON(Элемент);
			
		Иначе
			СтрокаJSON = СтрокаJSON + """" + РаботаСВнешнимВебСервером.URLEncode(Строка(Элемент)) + """";
			
		КонецЕсли;
		
		СтрокаJSON = СтрокаJSON + ",";
	КонецЦикла;
	
	Если Прав(СтрокаJSON, 1) = "," Тогда
		СтрокаJSON = Лев(СтрокаJSON, СтрДлина(СтрокаJSON)-1);
	КонецЕсли;
	
	Возврат СтрокаJSON + "]";
	
КонецФункции

Функция СформироватьСтрокуJSONИзСтруктуры(Объект)
	
	СтрокаJSON = "{";
	
	Для каждого Элемент Из Объект Цикл
		
		Если Элемент.Значение = "" Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаJSON = СтрокаJSON + """" + Элемент.Ключ + """" + ":";
		
		Если ТипЗнч(Элемент.Значение) = Тип("Строка") Тогда
			//СтрокаJSON = СтрокаJSON + """" + РаботаСВнешнимВебСервером.URLEncode(Элемент.Значение) + """";
			СтрокаJSON = СтрокаJSON + """" + Элемент.Значение + """";
			
		ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Число") Тогда
			СтрокаJSON = СтрокаJSON + СтрЗаменить(Строка(Элемент.Значение), Символы.НПП, "");
			
		ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Булево") Тогда
			СтрокаJSON = СтрокаJSON + Формат(Элемент.Значение, "БЛ=false; БИ=true");
			
		ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Дата") Тогда
			// преобразование в unixtime
			СтрокаJSON = СтрокаJSON + Формат(Элемент.Значение - Дата(1970,1,1,1,0,0), "ЧГ=0");
			
		ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Массив") Тогда
			СтрокаJSON = СтрокаJSON + СформироватьСтрокуJSON(Элемент.Значение);
			
		ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("Структура") Тогда
			СтрокаJSON = СтрокаJSON + СформироватьСтрокуJSON(Элемент.Значение);
			
		ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("ТаблицаЗначений") Тогда
			СтрокаJSON = СтрокаJSON + СформироватьСтрокуJSON(Элемент.Значение);
			
		Иначе
			СтрокаJSON = СтрокаJSON + """" + РаботаСВнешнимВебСервером.URLEncode(Строка(Элемент.Значение)) + """";
			
		КонецЕсли;
		
		СтрокаJSON = СтрокаJSON + ",";
		
	КонецЦикла;
	
	Если Прав(СтрокаJSON, 1) = "," Тогда
		СтрокаJSON = Лев(СтрокаJSON, СтрДлина(СтрокаJSON)-1);
	КонецЕсли;
	
	Возврат СтрокаJSON + "}";
	
КонецФункции

Функция СформироватьСтрокуJSON(Объект) Экспорт
	
	СтрокаJSON = "";
	
	Если ТипЗнч(Объект) = Тип("Массив") Тогда
		СтрокаJSON = СформироватьСтрокуJSONИзМассива(Объект);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("Структура") Тогда
		СтрокаJSON = СформироватьСтрокуJSONИзСтруктуры(Объект);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ТаблицаЗначений") Тогда
		// преобразуем таблицу значений в массив структур - работает дольше, но кода меньше
		// если нужна скорость, то нужно отдельно обработать таблицу значений
		
		СоставСтруктуры = "";
		Для каждого Колонка Из Объект.Колонки Цикл
			СоставСтруктуры = СоставСтруктуры + ?(ЗначениеЗаполнено(СоставСтруктуры), ",", "") + Колонка.Имя;
		КонецЦикла;
		
		МассивСтрок = Новый Массив;
		Для каждого Строка Из Объект Цикл
			СтруктураКолонок = Новый Структура(СоставСтруктуры);
			ЗаполнитьЗначенияСвойств(СтруктураКолонок, Строка);
			МассивСтрок.Добавить(СтруктураКолонок);
		КонецЦикла;
		
		СтрокаJSON = СформироватьСтрокуJSONИзМассива(МассивСтрок);
		
	КонецЕсли;
	
	Возврат СтрокаJSON;
	
КонецФункции

Процедура ЗаполнитьДанныеИзОтветаJSON(Результат, ТекстJSON, ТипДанных)
	
	ТекстJSON = СокрЛП(Сред(ТекстJSON, 2));	// удалим открывающий символ структуры(массива)
	
	НомерЗначения = 0;
	
	Пока ТекстJSON <> "" Цикл
		
		ПервыйСимвол = Лев(ТекстJSON, 1);
		Если ПервыйСимвол = """" Тогда
			ТекстJSON = Сред(ТекстJSON, 2);
			ПервыйСимвол = Лев(ТекстJSON, 1);
		КонецЕсли;
		
		Если ПервыйСимвол = "{" Тогда
			// вложенная структура
			Значение = Новый Структура;
			ЗаполнитьДанныеИзОтветаJSON(Значение, ТекстJSON, "Структура");
			
			Если ТипДанных = "Структура" Тогда
				Результат.Вставить("Значение" + ?(НомерЗначения = 0, "", НомерЗначения), Значение);
				НомерЗначения = НомерЗначения + 1;
			ИначеЕсли ТипДанных = "Массив" Тогда
				Результат.Добавить(Значение);
			КонецЕсли;
		
		ИначеЕсли ПервыйСимвол = "[" Тогда
			// вложенный массив
			Значение = Новый Массив;
			ЗаполнитьДанныеИзОтветаJSON(Значение, ТекстJSON, "Массив");
			
			Если ТипДанных = "Структура" Тогда
				Результат.Вставить("Значение" + ?(НомерЗначения = 0, "", НомерЗначения), Значение);
				НомерЗначения = НомерЗначения + 1;
			Иначе
				Результат.Добавить(Значение);
			КонецЕсли;
			
		ИначеЕсли ПервыйСимвол = "}" И ТипДанных = "Структура" Тогда
			// структура закончилась
			ТекстJSON = СокрЛП(Сред(ТекстJSON, 2));
			Если Лев(ТекстJSON, 1) = "," Тогда
				ТекстJSON = СокрЛП(Сред(ТекстJSON, 2));
			КонецЕсли;
			
			Возврат;
			
		ИначеЕсли ПервыйСимвол = "]" И ТипДанных = "Массив" Тогда
			// массив закончился
			ТекстJSON = СокрЛП(Сред(ТекстJSON, 2));
			Если Лев(ТекстJSON, 1) = "," Тогда
				ТекстJSON = СокрЛП(Сред(ТекстJSON, 2));
			КонецЕсли;
			
			Возврат;
			
		Иначе
			
			Если ТипДанных = "Структура" Тогда
				
				Поз = Найти(ТекстJSON, ":");
				Если Поз = 0 Тогда
					// неверный формат, прервемся
					Прервать;
				КонецЕсли;
				
				ИмяЗначения = СокрЛП(Лев(ТекстJSON, Поз-1));
				ИмяЗначения = СтрЗаменить(ИмяЗначения, """", "");
				
				ТекстJSON = СокрЛП(Сред(ТекстJSON, Поз+1));
				
				Если Лев(ТекстJSON, 1) = "{" Тогда
					// значение является структурой
					Значение = Новый Структура;
					ЗаполнитьДанныеИзОтветаJSON(Значение, ТекстJSON, "Структура");
					
				ИначеЕсли Лев(ТекстJSON, 1) = "[" Тогда
					// значение является массивом
					Значение = Новый Массив;
					ЗаполнитьДанныеИзОтветаJSON(Значение, ТекстJSON, "Массив");
					
				Иначе
					
					// значение в кавычках
					ПервыйСимвол = Лев(ТекстJSON, 1);
					Если ПервыйСимвол = """" Тогда
						Значение = "";
						ТекстJSON = Сред(ТекстJSON, 2);
						
						// находим первые кавычки; если \", это ещё не конец значения
						Поз = Найти(ТекстJSON, """");
						Пока Поз <> 0 Цикл
							Значение = Значение + Лев(ТекстJSON, Поз - 1);
							//ТекстJSON = Сред(ТекстJSON, Поз + ?(Сред(ТекстJSON, Поз + 1, 1) = ",", 2, 1));
							ТекстJSON = Сред(ТекстJSON, Поз + 1);
							
							Если Прав(Значение, 1) <> "\" Тогда
								ТекстJSON = СокрЛП(?(Лев(ТекстJSON, 1) = ",", Сред(ТекстJSON, 2), ТекстJSON));
								Прервать;
							КонецЕсли;
							
							Значение = Лев(Значение, СтрДлина(Значение) - 1) + """"; // добавляем кавычку
							Поз = Найти(ТекстJSON, """");
						КонецЦикла;
						
					Иначе
						// обычное значение
						Поз = 0;
						Для Сч = 1 По СтрДлина(ТекстJSON) Цикл
							Символ = Сред(ТекстJSON, Сч, 1);
							Если Символ = "," ИЛИ Символ = "]" ИЛИ Символ = "}" Тогда
								Поз = Сч;
								Прервать;
							КонецЕсли;
						КонецЦикла;
						
						Если Поз = 0 Тогда
							Значение = ТекстJSON;
							ТекстJSON = "";
							
						Иначе
							Значение = Лев(ТекстJSON, Поз-1);
							ТекстJSON = СокрЛП(Сред(ТекстJSON, Поз + ?(Сред(ТекстJSON, Поз, 1) = ",", 1, 0)));
							
						КонецЕсли;
					КонецЕсли;
					
					Значение = СтрЗаменить(Значение, "\/", "/");
					Значение = СтрЗаменить(Значение, "\n",Символы.ПС);
					
					Если Найти(Значение, "\u") <> 0 Тогда
						Значение = JSON_Encode(Значение);
					КонецЕсли;
					
					Значение = СокрЛП(Значение);
					//Если ОбщегоНазначения.ТолькоЦифрыВСтроке(Значение) Тогда
					//	Значение = Число(Значение);
					//КонецЕсли;
					
				КонецЕсли;
				
				Результат.Вставить(ИмяЗначения, Значение);
				
			ИначеЕсли ТипДанных = "Массив" Тогда
				
				// обычное значение
				Поз = 0;
				Для Сч = 1 По СтрДлина(ТекстJSON) Цикл
					Символ = Сред(ТекстJSON, Сч, 1);
					Если Символ = "," ИЛИ Символ = "]" ИЛИ Символ = "}" Тогда
						Поз = Сч;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если Поз = 0 Тогда
					Значение = ТекстJSON;
					ТекстJSON = "";
					
				Иначе
					Значение = Лев(ТекстJSON, Поз-1);
					ТекстJSON = СокрЛП(Сред(ТекстJSON, Поз + ?(Сред(ТекстJSON, Поз, 1) = ",", 1, 0)));
					
				КонецЕсли;
				
				Значение = СокрЛП(Значение);
				
				Результат.Добавить(Значение);
				
			КонецЕсли;
				
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаполнитьСтруктуруИзОтветаJSON(Знач ТекстJSON) Экспорт
	
	Результат = Новый Структура;
	
	//ТекстJSON = СтрЗаменить(ТекстJSON, "\""", """");	// заменим последовательность \" на "
	//ТекстJSON = СтрЗаменить(ТекстJSON, """", "");		// а теперь удалим все кавычки
	
	Если Лев(ТекстJSON, 1) = "{" Тогда
		// начало структуры
		ЗаполнитьДанныеИзОтветаJSON(Результат, ТекстJSON, "Структура");
		
	ИначеЕсли Лев(ТекстJSON, 1) = "[" Тогда
		// начало массива
		МассивДанных = Новый Массив;
		ЗаполнитьДанныеИзОтветаJSON(МассивДанных, ТекстJSON, "Массив");
		
		Результат.Вставить("Значение", МассивДанных);
		
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

//**
//* Выполняет преобразование структуры/массива структур в формат
//* JSON и возвращает строку. В структуре должны быть переданы только
//* примитивные типы.
//*
//* @param {Массив.<Структура> || Структура} СтруктураДанных
//* @return {Строка}
//*
Функция СтруктураДанныхВJSON(СтруктураДанных) Экспорт
    
    ЗаписьJSON = Новый ЗаписьJSON;
    ЗаписьJSON.УстановитьСтроку();
    ЗаписатьJSON(ЗаписьJSON, СтруктураДанных);
    
    Возврат ЗаписьJSON.Закрыть();
    
КонецФункции

//+++АК SHEP 2018.04.11 общая функция
// Считывает значение из JSON-текста. JSON-текст должен быть корректным.
// Возвращает: Массив, Структуру или Соответствие
Функция СтруктураДанныхИзJSON(ТекстJSON, ПрочитатьВСоответствие = Ложь) Экспорт
    
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТекстJSON);
	СтруктураДанных = ПрочитатьJSON(ЧтениеJSON, ПрочитатьВСоответствие);
	ЧтениеJSON.Закрыть();
	Возврат СтруктураДанных;
    
КонецФункции
