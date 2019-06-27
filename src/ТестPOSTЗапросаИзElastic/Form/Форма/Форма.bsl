﻿// ГУИДУдОбъкта =  <Объект не найден> (84:bf5600145e3710ab11dda4c605dbe824)
//	ГУИДУдОбъктаСтр = СтрЗаменить(ГУИДУдОбъкта,"<Объект не найден> (","");
//	ГУИДУдОбъктаСтр = СтрЗаменить(ГУИДУдОбъктаСтр,")","");
//	ГУИДУдОбъктаСтр = СтрЗаменить(ГУИДУдОбъктаСтр,"0x","");
//	ГУИДУдОбъктаСтр = Сред(ГУИДУдОбъктаСтр, Найти(ГУИДУдОбъктаСтр,":")+1, СтрДлина(ГУИДУдОбъктаСтр));
//	// Преобразуем GUID
//	ГУИД = Сред(ГУИДУдОбъктаСтр,25,8)+"-"+Сред(ГУИДУдОбъктаСтр,21,4)+"-"+Сред(ГУИДУдОбъктаСтр,17,4)+"-"+Сред(ГУИДУдОбъктаСтр,1,4)+"-"+Сред(ГУИДУдОбъктаСтр,5,12);			//и получаем ГУИД = 05dbe824-a4c6-11dd-bf56-00145e3710ab  

#Область ОбразецЗапроса
//Образец запроса к Elasticsearch
//для выбора данных по журналу регистрации
//GET /oncjornallog/_search
//{
//  "timeout": "10s", 
//  "size":"10",
//  "sort" : { "Date" : {"order" : "desc"}},
//  "query": {
//    "bool":{
//      "must": [{
//          "range": {
//              "Date": {
//                  "gte": "2019-03-29T12:30:00.000Z",
//                  "lte": "2019-03-29T12:40:00.000Z"
//              }
//          }
//      },
//      {
//      "query_string": {
//        "default_field": "EventPresentation",
//        "query": "*Добавление*"
//        }
//      },
//      {
//      "query_string": {
//        "default_field": "Metadata",
//        "query": "Справочник.Склады"
//        }
//      }, 
//      {
//      "query_string": {
//        "default_field": "UserName",
//        "query": "*Чебот*"
//        }
//      } 
//      ]
//    }
//  }
//}

//В эластик все записано в универсальном времени
//пример преобразования
//УниверсальноеВремя(<МестноеВремя>, <ЧасовойПояс>) - Преобразует местное время в заданном часовом поясе в универсальное время.
//В первом параметре передается время, которое мы хотим перевести в универсальное, во втором - часовой пояс. Если второй параметр не указан, то используется текущий часовой пояс.
//
//Для обратного преобразования используется функция МестноеВремя().
//МестноеВремя(<УниверсальноеВремя>, <ЧасовойПояс>) - Преобразует универсальное время в местное время заданного часового пояса.
#КонецОбласти

&НаКлиенте
Процедура СформироватьJSONЗапрос()
	записьJSON = Новый ЗаписьJSON;
	записьJSON.УстановитьСтроку();
	записьJSON.ЗаписатьНачалоОбъекта();//{
	
	//формируем json запрос
	//заполняем обязательные для нас поля
#Область Таймаут
	Если Таймаут > 0 Тогда
		//  "timeout": "10s", 
		записьJSON.ЗаписатьИмяСвойства("timeout");
		записьJSON.ЗаписатьЗначение(Формат(Таймаут,"ЧГ=; ЧФ=Чs"));
	КонецЕсли;
#КонецОбласти	
	//  "size":"10",
#Область РазмерЗапроса
	записьJSON.ЗаписатьИмяСвойства("size");
	записьJSON.ЗаписатьЗначение(XMLСтрока(КоличествоЗаписейВОтвете));
#КонецОбласти
#Область Сортировка
	//  "sort" : { "Date" : {"order" : "desc"}},
	записьJSON.ЗаписатьИмяСвойства("sort");
	записьJSON.ЗаписатьНачалоОбъекта();//{
	записьJSON.ЗаписатьИмяСвойства("Date");
	записьJSON.ЗаписатьНачалоОбъекта();//{
	записьJSON.ЗаписатьИмяСвойства("order");
	записьJSON.ЗаписатьЗначение("desc");
	записьJSON.ЗаписатьКонецОбъекта();//}
	записьJSON.ЗаписатьКонецОбъекта();//}
#КонецОбласти
	//  "query": {
	записьJSON.ЗаписатьИмяСвойства("query");
	записьJSON.ЗаписатьНачалоОбъекта();//{
	//	  "bool":{
	//      "must": [{
	//          "range": {
	//              "Date": {
	//                  "gte": "2019-03-29T12:30:00.000Z",
	//                  "lte": "2019-03-29T12:40:00.000Z"
	//              }
	//          }
	//      },
		записьJSON.ЗаписатьИмяСвойства("bool");
		записьJSON.ЗаписатьНачалоОбъекта();//{ bool
		//формируем запрос с множеством условий
		
			записьJSON.ЗаписатьИмяСвойства("must");
			записьJSON.ЗаписатьНачалоМассива();  // must
#Область Range							
				записьJSON.ЗаписатьНачалоОбъекта();//{ элемент массива
					записьJSON.ЗаписатьИмяСвойства("range");
					записьJSON.ЗаписатьНачалоОбъекта();//{ range
						записьJSON.ЗаписатьИмяСвойства("Date");
						записьJSON.ЗаписатьНачалоОбъекта();//{  Date
							записьJSON.ЗаписатьИмяСвойства("gte");
							записьJSON.ЗаписатьЗначение(XMLСтрока(ДатаНачала)+".000Z");
							записьJSON.ЗаписатьИмяСвойства("lte");
							записьJSON.ЗаписатьЗначение(XMLСтрока(ДатаОкончания)+".999Z");
						записьJSON.ЗаписатьКонецОбъекта();//}  Date
					записьJSON.ЗаписатьКонецОбъекта();//} range
				записьJSON.ЗаписатьКонецОбъекта();//} элемент массива 
#КонецОбласти
#Область СтрокаСоединения
				записьJSON.ЗаписатьНачалоОбъекта();//{ элемент массива
					записьJSON.ЗаписатьИмяСвойства("match_phrase");
					записьJSON.ЗаписатьНачалоОбъекта();//{ match
					//поиск по keyword обеспечивает точное соответствие
						записьJSON.ЗаписатьИмяСвойства("ConnectionString.keyword");
						записьJSON.ЗаписатьЗначение(СтрокаСоединения);
					записьJSON.ЗаписатьКонецОбъекта();//} match
				записьJSON.ЗаписатьКонецОбъекта();//} элемент массива 
#КонецОбласти
#Область Уровень
			//уровень события системы  	
				Если ОтборУровня Тогда
					записьJSON.ЗаписатьНачалоОбъекта();//{ элемент массива
						записьJSON.ЗаписатьИмяСвойства("match");
						записьJSON.ЗаписатьНачалоОбъекта();//{ match
						//поиск по keyword обеспечивает точное соответствие
							записьJSON.ЗаписатьИмяСвойства("Level.keyword");
							записьJSON.ЗаписатьЗначение(Уровень);
						записьJSON.ЗаписатьКонецОбъекта();//} match
					записьJSON.ЗаписатьКонецОбъекта();//} элемент массива 					
				КонецЕсли;
#КонецОбласти
#Область Пользователь
				//не обязательные поля поиска
				//пользователь
				//{
				//      "match_phrase": {
				//        "UserName":
				//        "Имя Пользователя"
				//        }
				//}
				Если ОтборПользователяИБ Тогда
					записьJSON.ЗаписатьНачалоОбъекта(); //{ элемент массива
	      				записьJSON.ЗаписатьИмяСвойства("match_phrase");
						записьJSON.ЗаписатьНачалоОбъекта();//{ match_phrase
	        				записьJSON.ЗаписатьИмяСвойства("UserName");
							записьJSON.ЗаписатьЗначение(ПользовательИБ);
	                    записьJSON.ЗаписатьКонецОбъекта();//} match_phrase
					записьJSON.ЗаписатьКонецОбъекта();//} элемент массива 
				КонецЕсли;
				
				Если ОтборПользователяИБКлюч Тогда
					записьJSON.ЗаписатьНачалоОбъекта();//{ элемент массива
						записьJSON.ЗаписатьИмяСвойства("match");
						записьJSON.ЗаписатьНачалоОбъекта();//{ match
						//поиск по keyword обеспечивает точное соответствие
							записьJSON.ЗаписатьИмяСвойства("User.keyword");
							записьJSON.ЗаписатьЗначение(ПользовательИБКлюч);
						записьJSON.ЗаписатьКонецОбъекта();//} match
					записьJSON.ЗаписатьКонецОбъекта();//} элемент массива 					
				КонецЕсли;
#КонецОбласти				
#Область Метаданные
			//метаданные
				Если ОтборМетаданныеИмя Тогда
					записьJSON.ЗаписатьНачалоОбъекта(); //{ элемент массива
	      				записьJSON.ЗаписатьИмяСвойства("match_phrase");
						записьJSON.ЗаписатьНачалоОбъекта();//{ match_phrase
	        				записьJSON.ЗаписатьИмяСвойства("MetadataPresentation");
							записьJSON.ЗаписатьЗначение(МетаданныеИмя);
	                    записьJSON.ЗаписатьКонецОбъекта();//} match_phrase
					записьJSON.ЗаписатьКонецОбъекта();//} элемент массива 
				КонецЕсли;
				
				Если ОтборМетаданныеКлюч Тогда
					записьJSON.ЗаписатьНачалоОбъекта();//{ элемент массива
						записьJSON.ЗаписатьИмяСвойства("match");
						записьJSON.ЗаписатьНачалоОбъекта();//{ match
						//поиск по keyword обеспечивает точное соответствие
							записьJSON.ЗаписатьИмяСвойства("Metadata.keyword");
							записьJSON.ЗаписатьЗначение(МетаданныеКлюч);
						записьJSON.ЗаписатьКонецОбъекта();//} match
					записьJSON.ЗаписатьКонецОбъекта();//} элемент массива 					
				КонецЕсли;
#КонецОбласти
#Область Данные 
			//данные  
				Если ОтборДанныеОписание Тогда
					записьJSON.ЗаписатьНачалоОбъекта(); //{ элемент массива
	      				записьJSON.ЗаписатьИмяСвойства("match");
						записьJSON.ЗаписатьНачалоОбъекта();//{ match_phrase
	        				записьJSON.ЗаписатьИмяСвойства("DataPresentation");
							записьJSON.ЗаписатьЗначение(ДанныеОписание);
	                    записьJSON.ЗаписатьКонецОбъекта();//} match
					записьJSON.ЗаписатьКонецОбъекта();//} элемент массива 
				КонецЕсли;
				
				Если ОтборДанныеКлюч Тогда
					записьJSON.ЗаписатьНачалоОбъекта();//{ элемент массива
						записьJSON.ЗаписатьИмяСвойства("match");
						записьJSON.ЗаписатьНачалоОбъекта();//{ match
						//поиск по keyword обеспечивает точное соответствие
							записьJSON.ЗаписатьИмяСвойства("Data.keyword");
							записьJSON.ЗаписатьЗначение(ДанныеКлюч);
						записьJSON.ЗаписатьКонецОбъекта();//} match
					записьJSON.ЗаписатьКонецОбъекта();//} элемент массива 					
				КонецЕсли;
#КонецОбласти
#Область Событие
			//события системы  
				Если ОтборСобытиеСистемы Тогда
					записьJSON.ЗаписатьНачалоОбъекта(); //{ элемент массива
	      				записьJSON.ЗаписатьИмяСвойства("match_phrase");
						записьJSON.ЗаписатьНачалоОбъекта();//{ match_phrase
	        				записьJSON.ЗаписатьИмяСвойства("EventPresentation");
							записьJSON.ЗаписатьЗначение(СобытиеСистемы);
	                    записьJSON.ЗаписатьКонецОбъекта();//} match_phrase
					записьJSON.ЗаписатьКонецОбъекта();//} элемент массива 
				КонецЕсли;
				
				Если ОтборСобытиеСистемыКлюч Тогда
					записьJSON.ЗаписатьНачалоОбъекта();//{ элемент массива
						записьJSON.ЗаписатьИмяСвойства("match");
						записьJSON.ЗаписатьНачалоОбъекта();//{ match
						//поиск по keyword обеспечивает точное соответствие
							записьJSON.ЗаписатьИмяСвойства("Event.keyword");
							записьJSON.ЗаписатьЗначение(СобытиеСистемыКлюч);
						записьJSON.ЗаписатьКонецОбъекта();//} match
					записьJSON.ЗаписатьКонецОбъекта();//} элемент массива 					
				КонецЕсли;
#КонецОбласти
		//завершение составного фильтра
			записьJSON.ЗаписатьКонецМассива(); //must
		записьJSON.ЗаписатьКонецОбъекта();//} 
	записьJSON.ЗаписатьКонецОбъекта();//} 	bool
	
	записьJSON.ЗаписатьКонецОбъекта();//}  query
	
	
	ЗапросКСервису = записьJSON.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправитьЗапрос(Команда)
	СформироватьJSONЗапрос();
	POSTЗапросНаСервере();
КонецПроцедуры

&НаСервере
Процедура POSTЗапросНаСервере()
	ответ = POSTЗапросИз1С(АдресСервера, ПортСервера, Сервис, ЗапросКСервису, Таймаут);
	стрОтвет = СтрЗаменить(ответ.ПолучитьТелоКакСтроку(), "@", "");
	//Сообщить(стрОтвет);
	чтение = Новый ЧтениеJSON;
	чтение.УстановитьСтроку(стрОтвет);
	результат = ПрочитатьJSON(чтение, Ложь, "timestamp,Date");
	ВывестиРезультатЗапросаВФорму(результат);
	Попытка
		Сообщить(результат.hits.hits.Количество());
	Исключение
		
	КонецПопытки;
КонецПроцедуры

&НаСервереБезКонтекста
Функция POSTЗапросИз1С(АдресСервера, ПортСервера, Сервис, ЗапросКСервису, Таймаут = 20)
    Соединение = Новый HTTPСоединение(СокрЛП(АдресСервера),ПортСервера,,,,Таймаут);
	
    Запрос = Новый HTTPЗапрос(Сервис);
    
	Запрос.Заголовки.Вставить("Content-Type", "application/json");
	Запрос.УстановитьТелоИзСтроки(ЗапросКСервису);
	
	Попытка
    	Ответ = Соединение.Post(Запрос);
		Возврат Ответ;
	Исключение
		ошибка = ОписаниеОшибки();
		ВызватьИсключение Ошибка;
	КонецПопытки;
КонецФункции

&НаСервере
Процедура ВывестиРезультатЗапросаВФорму(результат)
	РезультатЗапроса.Очистить();
	
	Если результат.Свойство("hits") И
		результат.hits.Свойство("hits") И
		ТипЗнч(результат.hits.hits) = Тип("Массив") И
		результат.hits.hits.Количество() > 0 
	Тогда
		Для Каждого элт Из результат.hits.hits Цикл
			стр = РезультатЗапроса.Добавить();
			ЗаполнитьЗначенияСвойств(стр, элт._source);
			стр.DateMSK = МестноеВремя(стр.Date);
			стр.Date = УниверсальноеВремя(стр.DateMSK);
	    КонецЦикла;
	КонецЕсли;	
	
	РезультатЗапроса.Сортировать("DateMSK Убыв");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеЗначения(значение)
	представление = Неопределено;
	Попытка
		представление = XMLСтрока(значение);
	Исключение
		представление = XMLСтрока(""+значение);
	КонецПопытки;
	
	Возврат представление;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСоответствиеИменКолонокЖР()
	соотв = Новый Соответствие;
	соотв.Вставить("Уровень", 				"Level");
	соотв.Вставить("Дата", 					"Date");
	соотв.Вставить("Пользователь", 			"User");
	соотв.Вставить("Компьютер", 			"Computer");
	соотв.Вставить("ИмяПриложения", 		"ApplicationName");
	соотв.Вставить("Событие", 				"Event");
	соотв.Вставить("Комментарий", 			"Comment");
	соотв.Вставить("Метаданные", 			"Metadata");
	соотв.Вставить("Данные", 				"Data");
	соотв.Вставить("ПредставлениеДанных",	"DataPresentation");
	соотв.Вставить("ИмяПользователя", 		"UserName");
	соотв.Вставить("ПредставлениеПриложения","ApplicationPresentation");
	соотв.Вставить("ПредставлениеСобытия",	"EventPresentation");
	соотв.Вставить("ПредставлениеМетаданных","MetadataPresentation");
	соотв.Вставить("СтатусТранзакции", 		"TransactionStatus");
	соотв.Вставить("Транзакция", 			"TransactionID");
	соотв.Вставить("Сеанс", 				"Session");
	соотв.Вставить("Соединение", 			"Connection");
	соотв.Вставить("РабочийСервер", 		"ServerName");
	соотв.Вставить("ОсновнойIPПорт", 		"Port");
	соотв.Вставить("ВспомогательныйIPПорт", "SyncPort");

	Возврат соотв;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокТиповыхСобытий()
#Область ТиповыеСобытия
	стр = "
		|_$Access$_.Access:Доступ. Доступ;
		|_$Access$_.AccessDenied:Доступ. Отказ в доступе;
		|_$Data$_.Delete:Данные. Удаление; 
		|_$Data$_.DeletePredefinedData:Данные. Удаление предопределенных данных; 
		|_$Data$_.DeleteVersions:Данные. Удаление версий; 
		|_$Data$_.New:Данные. Добавление; 
		|_$Data$_.NewPredefinedData:Данные. Добавление предопределенных данных; 
		|_$Data$_.NewVersion:Данные. Добавление версии; 
		|_$Data$_.Post:Данные. Проведение; 
		|_$Data$_.PredefinedDataInitialization:Данные. Инициализация предопределенных данных; 
		|_$Data$_.PredefinedDataInitializationDataNotFound:Данные. Инициализация предопределенных данных. Данные не найдены; 
		|_$Data$_.SetPredefinedDataInitialization:Данные. Установка инициализации предопределенных данных; 
		|_$Data$_.SetStandardODataInterfaceContent:Данные. Изменение состава стандартного интерфейса OData; 
		|_$Data$_.TotalsMaxPeriodUpdate:Данные. Изменение максимального периода рассчитанных итогов; 
		|_$Data$_.TotalsMinPeriodUpdate:Данные. Изменение минимального периода рассчитанных итогов; 
		|_$Data$_.Unpost:Данные. Отмена проведения; 
		|_$Data$_.Update:Данные. Изменение; 
		|_$Data$_.UpdatePredefinedData:Данные. Изменение предопределенных данных; 
		|_$Data$_.VersionCommentUpdate:Данные. Изменение комментария версии; 
		|_$InfoBase$_.ConfigExtensionUpdate:Информационная база. Изменение расширения конфигурации;
		|_$InfoBase$_.ConfigUpdate:Информационная база. Изменение конфигурации; 
		|_$InfoBase$_.DBConfigBackgroundUpdateCancel:Информационная база. Отмена фонового обновления; 
		|_$InfoBase$_.DBConfigBackgroundUpdateFinish:Информационная база. Завершение фонового обновления; 
		|_$InfoBase$_.DBConfigBackgroundUpdateResume:Информационная база. Продолжение (после приостановки) процесса фонового обновления; 
		|_$InfoBase$_.DBConfigBackgroundUpdateStart:Информационная база. Запуск фонового обновления; 
		|_$InfoBase$_.DBConfigBackgroundUpdateSuspend:Информационная база. Приостановка (пауза) процесса фонового обновления; 
		|_$InfoBase$_.DBConfigExtensionUpdate:Информационная база. Изменение расширения конфигурации;
		|_$InfoBase$_.DBConfigExtensionUpdateError:Информационная база. Ошибка изменения расширения конфигурации;
		|_$InfoBase$_.DBConfigUpdate:Информационная база. Изменение конфигурации базы данных; 
		|_$InfoBase$_.DBConfigUpdateError:Информационная база. Ошибка изменения конфигурации базы данных; 
		|_$InfoBase$_.DumpError:Информационная база. Ошибка выгрузки в файл;
		|_$InfoBase$_.DumpFinish:Информационная база. Окончание выгрузки в файл;
		|_$InfoBase$_.DumpStart:Информационная база. Начало выгрузки в файл;
		|_$InfoBase$_.EraseData:Информационная база. Удаление данных информационной баз; 
		|_$InfoBase$_.EventLogReduce:Информационная база. Сокращение журнала регистрации;
		|_$InfoBase$_.EventLogReduceError:Информационная база. Ошибка сокращения журнала регистрации;
		|_$InfoBase$_.EventLogSettingsUpdate:Информационная база. Изменение настроек журнала регистрации;
		|_$InfoBase$_.EventLogSettingsUpdateError:Информационная база. Ошибка изменения настроек журнала регистрации;
		|_$InfoBase$_.InfoBaseAdmParamsUpdate:Информационная база. Изменение параметров информационной базы;
		|_$InfoBase$_.InfoBaseAdmParamsUpdateError:Информационная база. Ошибка изменения параметров информационной базы;
		|_$InfoBase$_.MasterNodeUpdate:Информационная база. Изменение главного узла; 
		|_$InfoBase$_.PredefinedDataUpdate:Информационная база. Обновление предопределенных данных; 
		|_$InfoBase$_.RegionalSettingsUpdate:Информационная база. Изменение региональных установок; 
		|_$InfoBase$_.RestoreError:Информационная база. Ошибка загрузки из файла;
		|_$InfoBase$_.RestoreFinish:Информационная база. Окончание загрузки из файла;
		|_$InfoBase$_.RestoreStart:Информационная база. Начало загрузки из файла;
		|_$InfoBase$_.SetPredefinedDataUpdate:Информационная база. Установить обновление предопределенных данных; 
		|_$InfoBase$_.TARImportant:Тестирование и исправление. Ошибка; 
		|_$InfoBase$_.TARInfo:Тестирование и исправление. Сообщение; 
		|_$InfoBase$_.TARMess:Тестирование и исправление. Предупреждение; 
		|_$Job$_.Cancel:Фоновое задание. Отмена; 
		|_$Job$_.Fail:Фоновое задание. Ошибка выполнения; 
		|_$Job$_.Start:Фоновое задание. Запуск; 
		|_$Job$_.Succeed:Фоновое задание. Успешное завершение; 
		|_$Job$_.Terminate:Фоновое задание. Принудительное завершение; 
		|_$OpenIDProvider$_.NegativeAssertion:Провайдер OpenID. Отклонено;
		|_$OpenIDProvider$_.PositiveAssertion:Провайдер OpenID. Подтверждено;
		|_$PerformError$_:Ошибка выполнения; 
		|_$Session$_.Authentication:Сеанс. Аутентификация;
		|_$Session$_.AuthenticationError:Сеанс. Ошибка аутентификации;
		|_$Session$_.ConfigExtensionApplyError:Сеанс. Ошибка применения расширения конфигурации;
		|_$Session$_.Finish:Сеанс. Завершение; 
		|_$Session$_.Start:Сеанс. Начало; 
		|_$Transaction$_.Begin:Транзакция. Начало; 
		|_$Transaction$_.Commit:Транзакция. Фиксация; 
		|_$Transaction$_.Rollback:Транзакция. Отмена; 
		|_$User$_.Delete:Пользователи. Удаление;
		|_$User$_.DeleteError:Пользователи. Ошибка удаления;
		|_$User$_.New:Пользователи. Добавление;
		|_$User$_.NewError:Пользователи. Ошибка добавления;
		|_$User$_.Update:Пользователи. Изменение;
		|_$User$_.UpdateError:Пользователи. Ошибка изменения;";
#КонецОбласти

	мСобытия = СтрРазделить(стр, ";", Ложь);
	список = Новый СписокЗначений;
	Для Каждого событие Из мСобытия Цикл
		мСобытие = СтрРазделить(событие, ":", Ложь);
		список.Добавить(СокрЛП(мСобытие[0]), СокрЛП(мСобытие[1]));
	КонецЦикла;
		
	Возврат список;
КонецФункции

&НаСервере
Процедура КомандаПрочитатьНастройкиНаСервере()
	об = РеквизитФормыВЗначение("Объект");
	настройки = об.ПолучитьНастройкиДоступаКElastic();
	
	АдресСервера = настройки.АдресСервера;
	ПортСервера	 = настройки.ПортЗапросов;
	Сервис		 = настройки.Сервис;
	Таймаут		 = настройки.Таймаут;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПрочитатьНастройки(Команда)
	КомандаПрочитатьНастройкиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	КомандаПрочитатьНастройкиНаСервере();
	СтрокаСоединения = ВРег(СтрокаСоединенияИнформационнойБазы());
	
	ДатаОкончания = ТекущаяДата();
	ДатаНачала = ТекущаяДата() - 72*3600;
	
	КоличествоЗаписейВОтвете = 100;
		
	//список уровней событий
	представление = ПредставлениеЗначения(УровеньЖурналаРегистрации.Информация);
	Элементы.Уровень.СписокВыбора.Добавить(представление);	
	представление = ПредставлениеЗначения(УровеньЖурналаРегистрации.Ошибка);
	Элементы.Уровень.СписокВыбора.Добавить(представление);	
	представление = ПредставлениеЗначения(УровеньЖурналаРегистрации.Предупреждение);
	Элементы.Уровень.СписокВыбора.Добавить(представление);	
	представление = ПредставлениеЗначения(УровеньЖурналаРегистрации.Примечание);
	Элементы.Уровень.СписокВыбора.Добавить(представление);	

	Для Каждого элтПользователь Из ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл
		Элементы.ПользовательИБ.СписокВыбора.Добавить(элтПользователь.УникальныйИдентификатор, элтПользователь.Имя);
	КонецЦикла;
	
	////формируем список метаданных
	соотвМетаданные = Новый Соответствие;
	табСтруктуры = ПолучитьСтруктуруХраненияБазыДанных();
	
	Для Каждого стр Из табСтруктуры Цикл
		мИмяМетаданных = СтрРазделить(стр.Метаданные, ".", Ложь);
		
		Если мИмяМетаданных.Количество() < 2 Тогда
			Продолжить;
		КонецЕсли;
		
		имяМетаданных = СокрЛП(мИмяМетаданных[0])+"."+СокрЛП(мИмяМетаданных[1]);
		соотвМетаданные.Вставить(имяМетаданных, 
				Новый ФиксированнаяСтруктура("Имя, Синоним", имяМетаданных,
							Метаданные.НайтиПоПолномуИмени(имяМетаданных).Синоним
				)
		);
	КонецЦикла;
	
	Для Каждого элтМета Из соотвМетаданные Цикл
		Элементы.МетаданныеИмя.СписокВыбора.Добавить(элтМета.Значение, элтМета.Ключ);
	КонецЦикла;
	Элементы.МетаданныеИмя.СписокВыбора.СортироватьПоПредставлению();
	
	СписокТиповыхСобытий = ПолучитьСписокТиповыхСобытий();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМассивТиповыхСобытий()
#Область События	
	стрСобытия = "
			|Доступ.Доступ
			|Доступ.Отказ в доступе
			|Данные.Удаление 
			|Данные.Удаление предопределенных данных 
			|Данные.Удаление версий 
			|Данные.Добавление 
			|Данные.Добавление предопределенных данных 
			|Данные.Добавление версии 
			|Данные.Проведение 
			|Данные.Инициализация предопределенных данных 
			|Данные.Инициализация предопределенных данных.Данные не найдены 
			|Данные.Установка инициализации предопределенных данных 
			|Данные.Изменение состава стандартного интерфейса OData 
			|Данные.Изменение максимального периода рассчитанных итогов 
			|Данные.Изменение минимального периода рассчитанных итогов 
			|Данные.Отмена проведения 
			|Данные.Изменение 
			|Данные.Изменение предопределенных данных 
			|Данные.Изменение комментария версии 
			|Информационная база.Изменение расширения конфигурации
			|Информационная база.Изменение конфигурации 
			|Информационная база.Отмена фонового обновления 
			|Информационная база.Завершение фонового обновления 
			|Информационная база.Продолжение (после приостановки) процесса фонового обновления 
			|Информационная база.Запуск фонового обновления 
			|Информационная база.Приостановка (пауза) процесса фонового обновления 
			|Информационная база.Изменение расширения конфигурации
			|Информационная база.Ошибка изменения расширения конфигурации
			|Информационная база.Изменение конфигурации базы данных 
			|Информационная база.Ошибка изменения конфигурации базы данных 
			|Информационная база.Ошибка выгрузки в файл
			|Информационная база.Окончание выгрузки в файл
			|Информационная база.Начало выгрузки в файл
			|Информационная база.Удаление данных информационной баз 
			|Информационная база.Сокращение журнала регистрации
			|Информационная база.Ошибка сокращения журнала регистрации
			|Информационная база.Изменение настроек журнала регистрации
			|Информационная база.Ошибка изменения настроек журнала регистрации
			|Информационная база.Изменение параметров информационной базы
			|Информационная база.Ошибка изменения параметров информационной базы
			|Информационная база.Изменение главного узла 
			|Информационная база.Обновление предопределенных данных 
			|Информационная база.Изменение региональных установок 
			|Информационная база.Ошибка загрузки из файла
			|Информационная база.Окончание загрузки из файла
			|Информационная база.Начало загрузки из файла событие доступно при выгрузке и просмотре только для администратора 
			|Информационная база.Установить обновление предопределенных данных 
			|Тестирование и исправление.Ошибка 
			|Тестирование и исправление.Сообщение 
			|Тестирование и исправление.Предупреждение 
			|Фоновое задание.Отмена 
			|Фоновое задание.Ошибка выполнения 
			|Фоновое задание.Запуск 
			|Фоновое задание.Успешное завершение 
			|Фоновое задание.Принудительное завершение 
			|Провайдер OpenID.Отклонено
			|Провайдер OpenID.Подтверждено
			|Ошибка выполнения 
			|Сеанс.Аутентификация
			|Сеанс.Ошибка аутентификации
			|Сеанс.Ошибка применения расширения конфигурации
			|Сеанс.Завершение 
			|Сеанс.Начало 
			|Транзакция.Начало 
			|Транзакция.Фиксация 
			|Транзакция.Отмена 
			|Пользователи.Удаление
			|Пользователи.Ошибка удаления
			|Пользователи.Добавление
			|Пользователи.Ошибка добавления
			|Пользователи.Изменение
			|Пользователи.Ошибка изменения";		
#КонецОбласти	

	мСобытия = СтрРазделить(стрСобытия, Символы.ПС, Ложь);
	Возврат мСобытия;
КонецФункции

&НаКлиенте
Процедура ОбработатьЗакрытиеРедактированияПериода(период, допПарам) Экспорт
	Если ЗначениеЗаполнено(период) Тогда
		ДатаНачала 		= период.ДатаНачала;
		ДатаОкончания 	= период.ДатаОкончания;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУказатьПериод(Команда)
	оповещение = Новый ОписаниеОповещения("ОбработатьЗакрытиеРедактированияПериода", ЭтаФорма);
	длгПериода = Новый ДиалогРедактированияСтандартногоПериода;
	длгПериода.Период.ДатаНачала 	= ДатаНачала;
	длгПериода.Период.ДатаОкончания = ДатаОкончания;
	длгПериода.Показать(оповещение);
КонецПроцедуры

&НаКлиенте
Процедура СобытиеСистемыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Элементы.ОтборСобытиеСистемыКлюч.Доступность = ЗначениеЗаполнено(ВыбранноеЗначение);
	ОтборСобытиеСистемыКлюч = Ложь;
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		значВыбора = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
		СобытиеСистемы = значВыбора.Представление;
		СобытиеСистемыКлюч = значВыбора.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИБОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		значВыбора = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
		ПользовательИБ = значВыбора.Представление;
		ПользовательИБКлюч = значВыбора.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МетаданныеИмяОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		значВыбора = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
		МетаданныеИмя = ""+значВыбора.Значение.Имя;
		МетаданныеКлюч = ""+значВыбора.Значение.Синоним;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИБОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПользовательИБ = Текст;
	ПользовательИБКлюч = "";
КонецПроцедуры

&НаКлиенте
Процедура МетаданныеИмяОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ДанныеВыбора) Тогда
		МетаданныеКлюч = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗакрытияОкнаВыбораДанных(результат, допПарам) Экспорт
	Если ЗначениеЗаполнено(результат) Тогда
		ДанныеОписание =""+результат;
		Попытка
			ДанныеКлюч = ""+результат.УникальныйИдентификатор();
		Исключение
			
		КонецПопытки;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(МетаданныеИмя) 
		И ЗначениеЗаполнено(МетаданныеКлюч)
	Тогда
		оповещение = Новый ОписаниеОповещения("ОбработкаЗакрытияОкнаВыбораДанных", ЭтаФорма);
		Попытка
			ОткрытьФорму(МетаданныеИмя+".ФормаВыбора",,
							ЭтаФорма,,,,оповещение, 
							РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
						); 
						
		Исключение
			ПоказатьПредупреждение(Неопределено, МетаданныеКлюч+" нет формы выбора.");
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СобытиеСистемыОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	//Если Не ЗначениеЗаполнено(ДанныеВыбора) Тогда
	//	СобытиеСистемыКлюч = "";
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеФормыВыбораСобытия(результат, допПараметр) Экспорт
	Если результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СобытиеСистемы 		= результат.Значение;
	СобытиеСистемыКлюч 	= результат.Ключ;
КонецПроцедуры

&НаКлиенте
Процедура СобытиеСистемыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	парам = Новый Структура("Список, ЗакрыватьПриВыборе", СписокТиповыхСобытий, Истина); 	
	оповещениеОЗакрытии = Новый ОписаниеОповещения("ЗакрытиеФормыВыбораСобытия", ЭтаФорма);
	ОткрытьФорму("ВнешняяОбработка.ТестPOSTЗапросаИзElastic.Форма.ФормаВыбораИзСписка", парам,ЭтаФорма,,,, оповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры
