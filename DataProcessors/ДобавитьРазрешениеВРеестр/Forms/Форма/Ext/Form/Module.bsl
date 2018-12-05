
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//+++АК
	//golv 20.05.2016
	Попытка
		WshShell = Новый COMОбъект("WScript.Shell");	
		//РезультатЗапроса = WshShell.Exec("reg query ""HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\security_1cv8c.exe""").StdOut.ReadAll();
			
		// Добавить параметр
		WshShell.Run("reg add ""HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\security_1cv8c.exe"" /v about /t REG_DWORD /d 2 /f", 0, 0);
	Исключение
	КонецПопытки;
	//---АК
	
	Закрыть();

КонецПроцедуры
