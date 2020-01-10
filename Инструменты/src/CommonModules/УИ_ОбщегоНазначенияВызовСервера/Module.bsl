Функция ПриНачалеРаботыСистемыРасширение() Экспорт
	
	Если Истина
		И ПравоДоступа("Администрирование", Метаданные) 
		И Не РольДоступна("УИ_УниверсальныеИнструменты")
		И ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0
	Тогда
		ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
		ТекущийПользователь.Роли.Добавить(Метаданные.Роли.УИ_УниверсальныеИнструменты);
		ТекущийПользователь.Записать();
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
	
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
		ЖирныйШрифт = Новый Шрифт(,, Истина);
		Если НЕ ЗначениеЗаполнено(ИменаГрупп) Тогда 
			Для Каждого Элемент Из Форма.Элементы Цикл 
				Если Тип(Элемент) = Тип("ГруппаФормы")
					И Элемент.Вид = ВидГруппыФормы.ОбычнаяГруппа
					И Элемент.ОтображатьЗаголовок = Истина 
					И (Элемент.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение
					Или Элемент.Отображение = ОтображениеОбычнойГруппы.Нет) Тогда 
						Элемент.ШрифтЗаголовка = ЖирныйШрифт;
				КонецЕсли;
			КонецЦикла;
		Иначе
			МассивЗаголовков = УИ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаГрупп,,, Истина);
			Для Каждого ИмяЗаголовка Из МассивЗаголовков Цикл
				Элемент = Форма.Элементы[ИмяЗаголовка];
				Если Элемент.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение ИЛИ Элемент.Отображение = ОтображениеОбычнойГруппы.Нет Тогда 
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


#Область Алгоритмы

Функция ПолучитьСсылкуСправочникАлгоритмы(Алгоритм) Экспорт
	Возврат УИ_ОбщегоНазначения.ПолучитьСсылкуСправочникАлгоритмы(Алгоритм);   
КонецФункции

Функция ВыполнитьАлгоритм(АлгоритмСсылка,ВходящиеПараметры=Неопределено, ОшибкаВыполнения = Ложь,СообщениеОбОшибке = "") Экспорт
	Возврат УИ_ОбщегоНазначения.ВыполнитьАлгоритм(АлгоритмСсылка,ВходящиеПараметры,ОшибкаВыполнения,СообщениеОбОшибке);
КонецФункции



#КонецОбласти

#Область Отладка

Функция ЗаписатьДанныеДляОтладкиВСправочник(ТипОбъектаОтладки,ДанныеДляОтладки) Экспорт
	НовыйЭлемент=Справочники.УИ_ДанныеДляОтладки.СоздатьЭлемент();
	НовыйЭлемент.Автор=ИмяПользователя();
	НовыйЭлемент.ДатаСоздания=ТекущаяДата();
	НовыйЭлемент.Наименование=НовыйЭлемент.ДатаСоздания;
	НовыйЭлемент.ТипОбъектаОтладки=ТипОбъектаОтладки;
	НовыйЭлемент.ХранилищеОбъектаОтладки=Новый ХранилищеЗначения(ДанныеДляОтладки,Новый СжатиеДанных(9));
	НовыйЭлемент.Записать();
	
	Возврат НовыйЭлемент.Ссылка;
КонецФункции

Функция СтруктураДанныхОбъектаОтладкиИзСправочникаДанныхОтладки(СсылкаНаДанные) Экспорт
	Результат=Новый Структура;
	Результат.Вставить("ТипОбъектаОтладки",СсылкаНаДанные.ТипОбъектаОтладки);
	Результат.Вставить("АдресОбъектаОтладки",ПоместитьВоВременноеХранилище(СсылкаНаДанные.ХранилищеОбъектаОтладки.Получить()));

	Возврат Результат;
КонецФункции


#КонецОбласти