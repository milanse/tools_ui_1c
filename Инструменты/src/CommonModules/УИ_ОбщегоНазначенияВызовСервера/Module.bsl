Функция ПараметрыСтартаСеанса() Экспорт

	ПараметрыСтартаСеанса=Новый Структура;
	
	Если ПравоДоступа("Администрирование", Метаданные) И Не РольДоступна("УИ_УниверсальныеИнструменты")
		И ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0 Тогда
		ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
		ТекущийПользователь.Роли.Добавить(Метаданные.Роли.УИ_УниверсальныеИнструменты);
		ТекущийПользователь.Записать();
		
		ПараметрыСтартаСеанса.Вставить("ДобавленыПраваНаРасширение", Истина);
	Иначе
		ПараметрыСтартаСеанса.Вставить("ДобавленыПраваНаРасширение", Ложь);
	КонецЕсли;
	
	ПараметрыСтартаСеанса.Вставить("НомерСеанса", НомерСеансаИнформационнойБазы());

	Возврат ПараметрыСтартаСеанса;
КонецФункции

// Устанавливает жирное оформление шрифта заголовков групп формы для их корректного отображения в интерфейсе 8.2.
// В интерфейсе Такси заголовки групп с обычным выделением и без выделения выводится большим шрифтом.
// В интерфейсе 8.2 такие заголовки выводятся как обычные надписи и не ассоциируются с заголовками.
// Эта функция предназначена для визуального выделения (жирным шрифтом) заголовков групп в режиме интерфейса 8.2.
//
// Параметры:
//  Форма - УправляемаяФорма - форма для изменения шрифта заголовков групп;
//  ИменаГрупп - Строка - список имен групп формы, разделенных запятыми. Если имена групп не указаны,
//                        то оформление будет применено ко всем группам на форме.
//
// Пример:
//  Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//    СтандартныеПодсистемыСервер.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект);
//
Процедура УстановитьОтображениеЗаголовковГрупп(Форма, ИменаГрупп = "") Экспорт

	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		ЖирныйШрифт = Новый Шрифт(, , Истина);
		Если Не ЗначениеЗаполнено(ИменаГрупп) Тогда
			Для Каждого Элемент Из Форма.Элементы Цикл
				Если Тип(Элемент) = Тип("ГруппаФормы") И Элемент.Вид = ВидГруппыФормы.ОбычнаяГруппа
					И Элемент.ОтображатьЗаголовок = Истина И (Элемент.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение
					Или Элемент.Отображение = ОтображениеОбычнойГруппы.Нет) Тогда
					Элемент.ШрифтЗаголовка = ЖирныйШрифт;
				КонецЕсли;
			КонецЦикла;
		Иначе
			МассивЗаголовков = УИ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаГрупп, , , Истина);
			Для Каждого ИмяЗаголовка Из МассивЗаголовков Цикл
				Элемент = Форма.Элементы[ИмяЗаголовка];
				Если Элемент.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение Или Элемент.Отображение
					= ОтображениеОбычнойГруппы.Нет Тогда
					Элемент.ШрифтЗаголовка = ЖирныйШрифт;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Функция КодОсновногоЯзыка() Экспорт
	Возврат УИ_ОбщегоНазначенияВызовСервера.КодОсновногоЯзыка();
КонецФункции

// См. СтандартныеПодсистемыПовтИсп.СсылкиПоИменамПредопределенных
Функция СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных) Экспорт

	Возврат УИ_ОбщегоНазначенияПовтИсп.СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных);

КонецФункции

Функция ЗначенияРеквизитовОбъекта(Ссылка, Знач Реквизиты, ВыбратьРазрешенные = Ложь) Экспорт

	Возврат УИ_ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты, ВыбратьРазрешенные);

КонецФункции

// Значение реквизита, прочитанного из информационной базы по ссылке на объект.
//
// Если необходимо зачитать реквизит независимо от прав текущего пользователя,
// то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  Ссылка    - ЛюбаяСсылка - объект, значения реквизитов которого необходимо получить.
//            - Строка      - полное имя предопределенного элемента, значения реквизитов которого необходимо получить.
//  ИмяРеквизита       - Строка - имя получаемого реквизита.
//  ВыбратьРазрешенные - Булево - если Истина, то запрос к объекту выполняется с учетом прав пользователя, и в случае,
//                                    - если есть ограничение на уровне записей, то возвращается Неопределено;
//                                    - если нет прав для работы с таблицей, то возникнет исключение.
//                              - если Ложь, то возникнет исключение при отсутствии прав на таблицу
//                                или любой из реквизитов.
//
// Возвращаемое значение:
//  Произвольный - зависит от типа значения прочитанного реквизита.
//               - если в параметр Ссылка передана пустая ссылка, то возвращается Неопределено.
//               - если в параметр Ссылка передана ссылка несуществующего объекта (битая ссылка), 
//                 то возвращается Неопределено.
//
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные = Ложь) Экспорт

	Возврат УИ_ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные);

КонецФункции

Функция ДанныеСохраненногоПароляПользователяИБ(ИмяПользователя) Экспорт
	Возврат УИ_Пользователи.ДанныеСохраненногоПароляПользователяИБ(ИмяПользователя);
КонецФункции

Процедура УстановитьПарольПользователюИБ(ИмяПользователя, Пароль) Экспорт
	УИ_Пользователи.УстановитьПарольПользователюИБ(ИмяПользователя, Пароль);
КонецПроцедуры

Процедура ВосстановитьДанныеПользователяПослеЗапускаСеансаПодПользователем(ИмяПользователя, ДанныеСохраненногоПароляПользователяИБ) Экспорт
	УИ_Пользователи.ВосстановитьДанныеПользователяПослеЗапускаСеансаПодПользователем(ИмяПользователя, ДанныеСохраненногоПароляПользователяИБ);
КонецПроцедуры

#Область Алгоритмы

Функция ПолучитьСсылкуСправочникАлгоритмы(Алгоритм) Экспорт
	Возврат УИ_ОбщегоНазначения.ПолучитьСсылкуСправочникАлгоритмы(Алгоритм);
КонецФункции

Функция ВыполнитьАлгоритм(АлгоритмСсылка, ВходящиеПараметры = Неопределено, ОшибкаВыполнения = Ложь,
	СообщениеОбОшибке = "") Экспорт
	Возврат УИ_ОбщегоНазначения.ВыполнитьАлгоритм(АлгоритмСсылка, ВходящиеПараметры, ОшибкаВыполнения,
		СообщениеОбОшибке);
КонецФункции

#КонецОбласти

#Область Отладка

Функция ЗаписатьДанныеДляОтладкиВСправочник(ТипОбъектаОтладки, ДанныеДляОтладки) Экспорт
	КлючНастроек=ТипОбъектаОтладки + "/" + ИмяПользователя() + "/" + Формат(ТекущаяДата(), "ДФ=yyyyMMddHHmmss;");
	КлючОбъектаДанныхОтладки=УИ_ОбщегоНазначенияКлиентСервер.КлючДанныхОбъектаДанныхОтладкиВХранилищеНастроек();

	УИ_ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить(КлючОбъектаДанныхОтладки, КлючНастроек, ДанныеДляОтладки);

	Возврат "Запись выполнена успешно. Ключ настроек " + КлючНастроек;
КонецФункции

Функция СтруктураДанныхОбъектаОтладкиИзСправочникаДанныхОтладки(СсылкаНаДанные) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ТипОбъектаОтладки", СсылкаНаДанные.ТипОбъектаОтладки);
	Результат.Вставить("АдресОбъектаОтладки", ПоместитьВоВременноеХранилище(
		СсылкаНаДанные.ХранилищеОбъектаОтладки.Получить()));

	Возврат Результат;
КонецФункции

Функция СтруктураДанныхОбъектаОтладкиИзСистемногоХранилищаНастроек(КлючНастроек) Экспорт
	КлючОбъектаДанныхОтладки=УИ_ОбщегоНазначенияКлиентСервер.КлючДанныхОбъектаДанныхОтладкиВХранилищеНастроек();
	НастройкиОтладки=УИ_ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(КлючОбъектаДанныхОтладки, КлючНастроек);

	Если НастройкиОтладки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	МассивПодСтрокКлюча=СтрРазделить(КлючНастроек, "/");

	Результат = Новый Структура;
	Результат.Вставить("ТипОбъектаОтладки", МассивПодСтрокКлюча[0]);
	Результат.Вставить("АдресОбъектаОтладки", ПоместитьВоВременноеХранилище(
		НастройкиОтладки));

	Возврат Результат;
КонецФункции

Функция СериализоватьОбъектСКДДляОтладки(СКД, НастройкиСКД, ВнешниеНаборыДанных) Экспорт
	СтруктураОбъекта = Новый Структура;

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, СКД, "dataCompositionSchema",
		"http://v8.1c.ru/8.1/data-composition-system/schema");

	СтруктураОбъекта.Вставить("ТекстСКД", ЗаписьXML.Закрыть());

	Если НастройкиСКД = Неопределено Тогда
		Настройки=СКД.НастройкиПоУмолчанию;
	Иначе
		Настройки=НастройкиСКД;

	КонецЕсли;

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Настройки, "Settings",
		"http://v8.1c.ru/8.1/data-composition-system/settings");
	СтруктураОбъекта.Вставить("ТекстНастроекСКД", ЗаписьXML.Закрыть());

	Если ТипЗнч(ВнешниеНаборыДанных)=Тип("Структура") Тогда
		Наборы=Новый Структура;
		
		Для Каждого КлючЗначение ИЗ ВнешниеНаборыДанных Цикл
			Если ТипЗнч(КлючЗначение.Значение)<>Тип("ТаблицаЗначений") Тогда
				Продолжить;
			КонецЕсли;
			
			Наборы.Вставить(КлючЗначение.Ключ, ЗначениеВСтрокуВнутр(КлючЗначение.Значение));
		КонецЦикла;
		
		Если Наборы.Количество()>0 Тогда
			СтруктураОбъекта.Вставить("ВнешниеНаборыДанных", Наборы);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураОбъекта;

КонецФункции

Функция СтруктураВременныхТаблицМенеджераВременныхТаблиц(МенеджерВременныхТаблиц) Экспорт
	СтруктураВременныхТаблиц = Новый Структура;
	Для Каждого ТаблицаВТ Из МенеджерВременныхТаблиц.Таблицы Цикл
		СтруктураВременныхТаблиц.Вставить(ТаблицаВТ.ПолноеИмя, ТаблицаВТ.ПолучитьДанные().Выгрузить());
	КонецЦикла;

	Возврат СтруктураВременныхТаблиц;
КонецФункции

//https://infostart.ru/public/1207287/
Функция ВыполнитьСравнениеДвухТаблицЗначений(ТаблицаБазовая, ТаблицаСравнения, СписокКолонокСравнения) Экспорт
	СписокКолонок = УИ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СписокКолонокСравнения, ",", Истина);
	//Результирующая таблица
	ВременнаяТаблица = Новый ТаблицаЗначений;
	Для Каждого Колонка Из СписокКолонок Цикл
		ВременнаяТаблица.Колонки.Добавить(Колонка);
		ВременнаяТаблица.Колонки.Добавить(Колонка + "Сравнение");
	КонецЦикла;
	ВременнаяТаблица.Колонки.Добавить("НомерСтр");
	ВременнаяТаблица.Колонки.Добавить("НомерСтр" + "Сравнение");
	//---------
	СравниваемаяТаблица = ТаблицаСравнения.Скопировать();
	СравниваемаяТаблица.Колонки.Добавить("УжеИспользуем", Новый ОписаниеТипов("Булево"));

	Для Каждого Строка Из ТаблицаБазовая Цикл
		НоваяСтрока = ВременнаяТаблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НоваяСтрока.НомерСтр = Строка.НомерСтроки;
		//формируем структуру для поиска по заданному сопоставлению
		ОтборДляПоискаСтрок = Новый Структура("УжеИспользуем", Ложь);
		Для Каждого Колонка Из СписокКолонок Цикл
			ОтборДляПоискаСтрок.Вставить(Колонка, Строка[Колонка]);
		КонецЦикла;

		НайдемСтроки = СравниваемаяТаблица.НайтиСтроки(ОтборДляПоискаСтрок);
		Если НайдемСтроки.Количество() > 0 Тогда
			СтрокаСопоставления = НайдемСтроки[0];
			НоваяСтрока.НомерСтрСравнение = СтрокаСопоставления.НомерСтроки;
			Для Каждого Колонка Из СписокКолонок Цикл
				Реквизит = Колонка + "Сравнение";
				НоваяСтрока[Реквизит] = СтрокаСопоставления[Колонка];
			КонецЦикла;
			СтрокаСопоставления.УжеИспользуем = Истина;
		КонецЕсли;
	КонецЦикла;
	//Смотрим что осталось +++
	ОтборДляПоискаСтрок = Новый Структура("УжеИспользуем", Ложь);
	НайдемСтроки = СравниваемаяТаблица.НайтиСтроки(ОтборДляПоискаСтрок);
	Для Каждого Строка Из НайдемСтроки Цикл
		НоваяСтрока = ВременнаяТаблица.Добавить();
		НоваяСтрока.НомерСтрСравнение = Строка.НомерСтроки;
		Для Каждого Колонка Из СписокКолонок Цикл
			Реквизит = Колонка + "Сравнение";
			НоваяСтрока[Реквизит] = Строка[Колонка];
		КонецЦикла;	
	КонецЦикла
	;
	//Проверяем что получилось
	ТаблицыИдентичны = Истина;
	Для Каждого Строка Из ВременнаяТаблица Цикл
		Для Каждого Колонка Из СписокКолонок Цикл
			Если (Не ЗначениеЗаполнено(Строка[Колонка])) Или (Не ЗначениеЗаполнено(Строка[Колонка + "Сравнение"])) Тогда
				ТаблицыИдентичны = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не ТаблицыИдентичны Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат Новый Структура("ИдентичныеТаблицы,ТаблицаРасхождений", ТаблицыИдентичны, ВременнаяТаблица);
КонецФункции

#КонецОбласти

#Область СохранениеЧтениеДанныхКонсолей

Функция ПодготовленныеДанныеКонсолиДляЗаписиВФайл(ИмяКонсоли, ИмяФайла, АдресДанныхСохранения,
	СтруктураОписанияСохраняемогоФайла) Экспорт
	Файл=Новый Файл(ИмяФайла);

	Если ЭтоАдресВременногоХранилища(АдресДанныхСохранения) Тогда
		ДанныеСохранения=ПолучитьИзВременногоХранилища(АдресДанныхСохранения);
	Иначе
		ДанныеСохранения=АдресДанныхСохранения;
	КонецЕсли;

	Если ВРег(ИмяКонсоли) = "КОНСОЛЬHTTPЗАПРОСОВ" Тогда
		МенеджерКонсоли=Обработки.УИ_КонсольHTTPЗапросов;
	Иначе
		МенеджерКонсоли=Неопределено;
	КонецЕсли;

	Если МенеджерКонсоли = Неопределено Тогда
		Если ТипЗнч(ДанныеСохранения) = Тип("Строка") Тогда
			НовыеДанныеСохранения=ДанныеСохранения;
		Иначе
			НовыеДанныеСохранения=ЗначениеВСтрокуВнутр(ДанныеСохранения);
		КонецЕсли;
	Иначе
		Попытка
			НовыеДанныеСохранения=МенеджерКонсоли.СериализованныеДанныеСохранения(Файл.Расширение, ДанныеСохранения);
		Исключение
			НовыеДанныеСохранения=ЗначениеВСтрокуВнутр(ДанныеСохранения);
		КонецПопытки;
	КонецЕсли;

	Поток=Новый ПотокВПамяти;
	ЗаписьТекста=Новый ЗаписьДанных(Поток);
	ЗаписьТекста.ЗаписатьСтроку(НовыеДанныеСохранения);

	Возврат ПоместитьВоВременноеХранилище(Поток.ЗакрытьИПолучитьДвоичныеДанные());
	
//	Возврат НовыеДанныеСохранения;	

КонецФункции

#КонецОбласти