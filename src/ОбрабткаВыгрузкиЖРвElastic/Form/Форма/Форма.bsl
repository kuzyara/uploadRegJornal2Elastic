﻿#Область ОбработкаФормы

&НаСервере
Процедура КомандаОтправитьЖурналСервер()
	об = РеквизитФормыВЗначение("Объект");
	об.ОтправитьЖРвLogstash();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправитьЖурнал(Команда)
	КомандаСохранитьНастройкиНаСервере();
	КомандаОтправитьЖурналСервер();
	КомандаПрочитатьГраницуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//АдресСервера = "172.16.3.133";
	//ПортСервера = 5044;
	//Сервис 		= "";
	//Дебаг		= Ложь;
	//ДатаГраницы = ПолучитьДатуНижнейГраницыВыгрузкиЖР();
	//Попытка
	//	ОтправитьЖРвLogstash("192.168.45.88", 5044, "");
	//Исключение
	//	ошибка = ОписаниеОшибки();
	//КонецПопытки;
	//ЗавершитьРаботуСистемы(Ложь);	
	Если Найти(ПараметрЗапуска, "ExportToLogstash") Тогда
		Состояние("Отправка данных в Elasic... " + Символы.ПС + ДатаГраницы + " - " + Период + " с.");
		КомандаОтправитьЖурналСервер();
		ЗавершитьРаботуСистемы(Ложь, Ложь);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура КомандаСохранитьНастройкиНаСервере()
	об = РеквизитФормыВЗначение("Объект");
	настройки = об.СтруктураНастроекДоступаКElastic();
	
	настройки.АдресСервера 	= АдресСервера;
	настройки.ПортСервера	= ПортСервера;
	настройки.Сервис		= Сервис;
	настройки.Дебаг			= Дебаг;
	настройки.Таймаут		= Таймаут;
	настройки.Период		= Период;
	настройки.ПортЗапросов	= ПортЗапросов;
	
	об.СохранитьНастройкиДоступаКElastic(настройки);
КонецПроцедуры

&НаКлиенте
Процедура КомандаСохранитьНастройки(Команда)
	КомандаСохранитьНастройкиНаСервере();
КонецПроцедуры

&НаСервере
Процедура КомандаПрочитатьНастройкиНаСервере()
	об = РеквизитФормыВЗначение("Объект");
	настройки = об.ПолучитьНастройкиДоступаКElastic();
	
	АдресСервера = настройки.АдресСервера;
	ПортСервера	 = настройки.ПортСервера;
	Сервис		 = настройки.Сервис;
	Дебаг		 = настройки.Дебаг;
	Период		 = настройки.Период;
	Таймаут		 = настройки.Таймаут;
	ПортЗапросов = настройки.ПортЗапросов;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПрочитатьНастройки(Команда)
	КомандаПрочитатьНастройкиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	об = РеквизитФормыВЗначение("Объект");
	КомандаПрочитатьНастройкиНаСервере();
	ДатаГраницы = об.ПолучитьДатуНижнейГраницыВыгрузкиЖР();	
КонецПроцедуры

&НаСервере
Процедура КомандаПрочитатьГраницуНаСервере()
	об = РеквизитФормыВЗначение("Объект");
	ДатаГраницы = об.ПолучитьДатуНижнейГраницыВыгрузкиЖР();	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПрочитатьГраницу(Команда)
	КомандаПрочитатьГраницуНаСервере();
КонецПроцедуры

&НаСервере
Процедура СохранитьГраницуВыгрузкиНаСервере() 
	об = РеквизитФормыВЗначение("Объект");
	об.СохранитьДатуНижнейГраницыВыгрузкиЖР(ДатаГраницы);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьГраницуВыгрузки(ответ, допПарам) Экспорт
	Если ответ = КодВозвратаДиалога.Да Тогда
		СохранитьГраницуВыгрузкиНаСервере();
	КонецЕсли;
	КомандаПрочитатьГраницуНаСервере();	
КонецПроцедуры
	
&НаКлиенте
Процедура КомандаСохранитьГраницуВыгрузки(Команда)
	описание = Новый ОписаниеОповещения("СохранитьГраницуВыгрузки", ЭтаФорма);
	ПоказатьВопрос(описание, 
			"Смещение границы выгрузки может привести к не полной выгрузке данных в Elasticsearch. Продолжить?", 
			РежимДиалогаВопрос.ДаНет,,
			КодВозвратаДиалога.Нет
	);
КонецПроцедуры

#КонецОбласти
