//Модуль для быстрого доступа к процедурам для отладки


// Описание
// 
// Выполняет запуск соответсвующего инструмента для толстого клиента или производит запись данных в базу для дальнейшей отладки
// 
// Если контекст запуска отладки является толстым клиентом открытие формы консоли происходит сразу по окончании выполнения вызова кода
// Если отладка вызывается в контексте сервера или тонкого или веб клиента, необходимая информация сохраняется в справочник Данные для отладки. 
// В таком случае вызов отладки проиходит потом из списка справочника "Данные для отладки".
// 
// Параметры:
// 	ОбъектОтладки - Объект типа Запрос
// Возвращаемое значение:
// СсылкаНаДанныеОтладки- Тип Строка.
// Результат выполнения сохранения данных отладки
// 	
Функция _От(ОбъектОтладки, НастройкиСКДИлиСоединениеHTTP = Неопределено, ВнешниеНаборыДанных = Неопределено) Экспорт
	Возврат УИ_ОбщегоНазначенияКлиентСервер.ОтладитьОбъект(ОбъектОтладки, НастройкиСКДИлиСоединениеHTTP,ВнешниеНаборыДанных);
КонецФункции

#Если Не ВебКлиент Тогда


// Описание
// 
// Параметры:
// 	ПутьКФайлу - Строка, ЧтениеXML, Поток - откуда нужно прочитать XML 
// 	УпроститьЭлементы - Булево - стоит ли при чтении убирать лишние элементы структуры
// Возвращаемое значение:
// 	Соответствие, Структура, Неопределено - результат чтения данных xml
Функция _XMLОбъект(ПутьЧтения, УпроститьЭлементы=Истина) Экспорт
	Возврат УИ_ПарсерXML.мПрочитать(ПутьЧтения, УпроститьЭлементы);
КонецФункции

#КонецЕсли

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ТолстыйКлиентУправляемоеПриложение Тогда
	
// Описание
// 
// Возвращает струтктуру таблиц запроса или менеджера временных таблиц
// Если передается запрос, то он превариательно выполняется.
// Если в запросе есть менеджер временных таблиц, в структуру добавляются таблицы менеджера временных таблиц запроса
//
// Параметры:
// 	ЗапросИЛИМенеджерВременныхТаблиц- Тип Запрос или МенеджерВременныхТаблиц
// Возвращаемое значение:
// 	Структура- Тип Структура
// Где 
// Ключ- ИмяВременнойТаблицы
// Значение- Содержание временной таблицы
Функция _ВТ(ЗапросИЛИМенеджерВременныхТаблиц) Экспорт
	Если ТипЗнч(ЗапросИЛИМенеджерВременныхТаблиц) = Тип("МенеджерВременныхТаблиц") Тогда
		Возврат УИ_ОбщегоНазначенияВызовСервера.СтруктураВременныхТаблицМенеджераВременныхТаблиц(
			ЗапросИЛИМенеджерВременныхТаблиц);
	ИначеЕсли ТипЗнч(ЗапросИЛИМенеджерВременныхТаблиц) = Тип("Запрос") Тогда
		Запрос=Новый Запрос;
		Запрос.Текст=ЗапросИЛИМенеджерВременныхТаблиц.Текст;
		Для Каждого Пар Из ЗапросИЛИМенеджерВременныхТаблиц.Параметры Цикл
			Запрос.УстановитьПараметр(Пар.Ключ, Пар.Значение);
		КонецЦикла;

		Если ЗапросИЛИМенеджерВременныхТаблиц.МенеджерВременныхТаблиц = Неопределено Тогда
			Запрос.МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц;
		Иначе
			Запрос.МенеджерВременныхТаблиц=ЗапросИЛИМенеджерВременныхТаблиц.МенеджерВременныхТаблиц;
		КонецЕсли;

		Попытка
			Запрос.ВыполнитьПакет();
		Исключение
			Возврат "Ошибка выполнения запроса " + ОписаниеОшибки();
		КонецПопытки;

		Возврат УИ_ОбщегоНазначенияВызовСервера.СтруктураВременныхТаблицМенеджераВременныхТаблиц(
			Запрос.МенеджерВременныхТаблиц);
	КонецЕсли;
КонецФункции


// Описание
// Выполняет сравнение двух таблиц значений по заданному списку колонок
// 
// Параметры:
// 	ТаблицаБазовая		- ТаблицаЗначений - первая таблица для сравнения
// 	ТаблицаСравнения	- ТаблицаЗначений - вторая таблица для сравнения
// 	СписокИзмерений		- Строка 		  - Список колонок по которым нужно выполнить сравнение. 
// 											Колонки должны присутствовать в обеих таблицах
// 											Если параметр не указан, сравнение происходит по колонкам базовой таблицы
// 	
// 	
// Возвращаемое значение:
// 
// 	Структура - Описание:
// 	
// * ИдентичныеТаблицы 		- Булево 			- Признак идентичности таблиц
// * ТаблицаРасхождений 	- ТаблицаЗначений 	- Таблица, в которой показаны расхождения сравниваемых таблиц
Функция _ТЗСр(ТаблицаБазовая, ТаблицаСравнения, СписокКолонок = Неопределено) Экспорт
	Если СписокКолонок = Неопределено Тогда
		КолонкиДляСравнения="";
	Иначе
		КолонкиДляСравнения=СписокКолонок;
	КонецЕсли;

	Попытка
		Возврат УИ_ОбщегоНазначенияВызовСервера.ВыполнитьСравнениеДвухТаблицЗначений(ТаблицаБазовая, ТаблицаСравнения,
			КолонкиДляСравнения);
	Исключение
		Возврат ОписаниеОшибки();
	КонецПопытки;
КонецФункции

#КонецЕсли