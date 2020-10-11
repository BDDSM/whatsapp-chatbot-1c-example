﻿
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПодготовитьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Если ВыбранноеЗначение.ИмяФормы = "ПомощникПодключения" Тогда
			Объект.IdInstance = ВыбранноеЗначение.IdInstance;
			Объект.ApiToken = ВыбранноеЗначение.ApiToken;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовКомандФормы

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	ОбновитьСтатусСервиса();
	Элементы.СтатусПроверки.Видимость = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатус(Команда)
	
	ОбновитьСтатусСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаПомощник(Команда)
	
	ОткрытьФормуОбработки("ПомощникПодключения");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьБота(Команда)
	
	Элементы.ГруппаНеЗаполненыНастройки.Видимость = Ложь;
	Элементы.ГруппаНеСканированКод.Видимость = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.ApiToken) И Не ЗначениеЗаполнено(Объект.IdInstance) Тогда
		Элементы.ГруппаНеЗаполненыНастройки.Видимость = Истина;
		Возврат;
	КонецЕсли;
	
	Попытка
		ОбновитьСтатусСервиса();
	Исключение
		Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если СтатусСервиса Тогда
		ВыполнитьЗапускБота();
	Иначе
		Элементы.ГруппаНеСканированКод.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьЗапускБота()
	Элементы.ЗапуститьБота.Пометка = Не Элементы.ЗапуститьБота.Пометка;
	Если Элементы.ЗапуститьБота.Пометка Тогда
		Элементы.ЗапуститьБота.Заголовок = "Остановить бота";
		СтатусПолучениеСообщения = "Получение сообщений...";
	Иначе
		Элементы.ЗапуститьБота.Заголовок = "Запустить бота";
		СтатусПолучениеСообщения = "";
	КонецЕсли;
	Подключаемый_ЗапуститьБота();
	ПодключитьОбработчикОжидания("Подключаемый_ЗапуститьБота", 1);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьНастройки()
	
	ЭтотОбъект.Заголовок = ОбработкаОбъект().ВерсияОбработки();
	Объект.ИнтервалОтправкиСообщений = 500;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗапуститьБота() Экспорт
	Если Не БотЗапущен Тогда
		БотЗапущен = Истина;
		ЗапуститьБотаСервер();
		БотЗапущен = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗапуститьБотаСервер()
	
	ОбработкаОбъект = ОбработкаОбъект();
	ОбработкаОбъект.ЗапуститьБота();
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусСервиса()
	
	Если Не ЭтотОбъект.ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтатусСервиса = ОбработкаОбъект().ПолучитьСтатусСервиса();
	
	Если СтатусСервиса Тогда
		НастройкиСервиса = ОбработкаОбъект().ПолучитьНастройкиСервиса();

		Объект.ПолучатьВходящиеУведомления = ЗначениеЗаполнено(НастройкиСервиса.webhookUrl) И НастройкиСервиса.webhookUrl = ОбработкаОбъект().ХостВебхуковПоУмолчанию();
		Объект.webhookUrl = НастройкиСервиса.webhookUrl;
		Объект.ПолучатьВходящиеСообщенияИФайлы = НастройкиСервиса.incomingWebhook = "yes";
		Объект.ПолучатьСтатусыОтправленныхСообщений = НастройкиСервиса.outgoingWebhook = "yes";
		Объект.ПолучатьУведомленииОСостоянииТелефона = НастройкиСервиса.deviceWebhook = "yes";
		Объект.ПолучатьУведомленияОСостоянииАккаунта = НастройкиСервиса.stateWebhook = "yes";
		Объект.ОтмечатьВходящиеСообщенияПрочитанными = НастройкиСервиса.markIncomingMessagesReaded = "yes";
		Объект.ИнтервалОтправкиСообщений = Макс(НастройкиСервиса.delaySendMessagesMilliseconds, Объект.ИнтервалОтправкиСообщений);
		
		ЕстьНестадантныенастройки = Не (ЗначениеЗаполнено(НастройкиСервиса.webhookUrl) И НастройкиСервиса.webhookUrl = ОбработкаОбъект().ХостВебхуковПоУмолчанию());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Утилиты

&НаСервере
Функция ПолучитьТекстИзМакета(ИмяМакета)
	Об = ОбработкаОбъект();
	ОбластьМакета = Об.ПолучитьМакет(ИмяМакета);
	Возврат ОбластьМакета.ТекущаяОбласть.Текст;
КонецФункции

&НаСервере
Функция ОбработкаОбъект() 
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаСервере
Функция ЭтоВнешняяОбработкаОтчет() Экспорт
	ПолноеИмяМетаданных = ОбработкаОбъект().Метаданные().ПолноеИмя();
	Возврат Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных) = Неопределено
КонецФункции

&НаКлиенте
Функция ОткрытьФормуОбработки(ИмяФормы)
	
	Если ЭтоВнешняяОбработкаОтчет() Тогда
		ИмяОткрФормы = "ВнешняяОбработка.GreenAPI_ChatBot.Форма." + ИмяФормы;
	Иначе
		ИмяОткрФормы = "Обработка.GreenAPI_ChatBot.Форма." + ИмяФормы;
	КонецЕсли;
		
	ОткрытьФорму(ИмяОткрФормы, Новый Структура("IdInstance,ApiToken", Объект.IdInstance, Объект.ApiToken), ЭтотОбъект,,,,, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецФункции

&НаКлиенте
Процедура Декорация2Нажатие(Элемент)
	ПроверитьЗаполнение();
КонецПроцедуры

&НаКлиенте
Процедура Декорация5Нажатие(Элемент)
	Элементы.Разделы.ТекущаяСтраница = Элементы.НастройкиВнешние;
КонецПроцедуры

#КонецОбласти
