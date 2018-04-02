module DB.Lab2 where

import ReportBase
import Data.List (intersperse)
import Text.LaTeX.Packages.Graphicx (IGOption (..), includegraphics)

writeReport :: IO ()
writeReport = do
  ddl <- readFile "../db/lab2.sql"
  dat <- readFile "../db/lab2data.sql"
  renderFile "./renders/DB-Lab2.tex" (execLaTeXM (reportTeX (ddl, dat)))

reportTeX :: (String, String) -> LaTeXM ()
reportTeX (ddlSql, dataSql) = do
  baseHeader
  usepackage [] "fancyvrb"
  usepackage [] "textcomp"
  document $ do
    baseTitlePage ("ЛАБОРАТОРНАЯ РАБОТА №2", "Базы данных", Just "Вариант 2886", "2018 г.")
    sectionstar "Задание"
    enumerate $ do
      item Nothing <> "На основе предложенной предметной области (текста) составить ее описание. Из полученного описания выделить сущности, их атрибуты и связи."
      item Nothing <> "Составить инфологическую модель."
      item Nothing <> "Составить даталогическую модель. При описании типов данных для атрибутов должны использоваться типы из СУБД PostgreSQL."
      item Nothing <> "Реализовать даталогическую модель в PostgreSQL. При описании и реализации даталогической модели должны учитываться ограничения целостности, которые характерны для полученной предметной области."
      item Nothing <> "Заполнить созданные таблицы тестовыми данными."
    sectionstar "Предметная область"
    textit "Все забыли даже о шахматах, предпочитая проводить время у телескопов или иллюминаторов. Смотрели, слушали музыку, разговаривали. И по крайней мере один роман достиг своей кульминации: частые исчезновения Макса Браиловского и Жени Марченко давали повод для множества беззлобных шуток." <> parbreak
    "Для отслеживания успешности прохождения экипажем заданной миссии ведется бортовой журнал. Поскольку основной целью является сбор научных наблюдений, полученных с использованием установленных на борту инструментов, необходимо хранить пометки о каждом наблюдении. Обязательно упоминание авторства каждой пометки и применявшегося инструмента. В случае эксплуатации нескольких приборов (" <> textit "к примеру, телескопа и гамма-спектрометра" <> "), допустимо создание нескольких пометок, подряд связанных друг с другом." <> parbreak
    "Большое внимание уделяется отношениям в коллективе. Взаимодействия условно делятся на " <> textit "соревнование" <> " -- дружественное противостояние, участники которого либо выигрывают, либо проигрывают в результате взаимодействия, " <> textit "конфликт" <> ", в результате которого происходит временный раскол между сторонами, и " <> textit "кооперацию" <> ", в которой нет проигравшей стороны. Темами взаимодействия являются " <> textit "миссия, личные отношения," <> " и " <> textit "игры" <> " -- например, шахматы." <> parbreak
    "Результатами взаимодействий являются отношения -- " <> textit "дружественные, романтические, антагонистические." <> " Считается, что началом и концом отношений являются отдельные взаимодействия. При этом в отношениях могут участвовать более двух людей, независимо от их типа." <> parbreak
    "Для коммуникации экипаж использует внутрикорабельную систему оповещения, которая может находиться в бездействиии, озвучивать текстовое сообщение или вещать музыкальную запись." <> parbreak
    "Помимо отслеживания коммуникаций, важной частью контроля экипажа является наблюдение за перемещениями по отсекам корабля. Одновременное передвижение нескольких людей должно отражаться в записях для каждого из них, при этом временная пометка записей выставляется идентично." <> parbreak
    sectionstar "Сущности"
    let entitylist = mconcat . (intersperse ", ") . ((\(n, d) -> textit n <> " -- " <> d) <$>)
    textbf "Стержневые: "
    entitylist
      [ ("crew_members", "члены команды")
      , ("interactions", "взаимодействия между людьми")
      , ("relationships", "отношения между людьми")
      , ("scientific_observations", "заметки о научных наблюдениях")
      , ("observation_tools", "инструменты для научных наблюдений")
      , ("intercom_broadcasts", "оповещения системы коммуникации")
      , ("ship_rooms", "отсеки корабля") ]
    "." <> parbreak <> textbf "Ассоциативные: "
    entitylist
      [ ("relationships <-> crew_members", "отношение включения членов команды в отношения") ]
    "." <> parbreak <> textbf "Характеристические: "
    entitylist
      [ ("interaction_participants <-> interactions", "отношение участников к взаимодействиям")
      , ("interaction_participants <-> crew_members", "участие в отдельном взаимодействии")
      , ("crew_relocations <-> crew_members", "перемещения членов команды")
      , ("crew_relocations <-> ship_rooms", "перемещения между отсеками") ]
    "."
    sectionstar "Инфологическая модель"
    includegraphics [IGWidth $ Cm 16] "../src/DB/Lab2-ER.pdf" <> lnbk
    sectionstar "Даталогическая модель"
    includegraphics [IGWidth $ Cm 19] "../src/DB/Lab2-DDL.png" <> lnbk
    sectionstar "Реализация даталогической модели"
    environment "Verbatim" $ raw . fromString $ "\n" ++ ddlSql ++ "\n"
    raw "\n"
    sectionstar "Тестовые данные"
    environment "Verbatim" $ raw . fromString $ "\n" ++ dataSql ++ "\n"
    raw "\n"
    newpage
    sectionstar "Вывод"
    "В ходе выполнения лабораторной работы я познакомился с основными ограничениями целостности (" <> textit "constraints" <> ") в СУБД PostgreSQL, а именно " <> textit "check" <> ", проверяющим истинность выражения, " <> textit "not null" <> ", запрещающим " <> textit "null" <> " значения, " <> textit "unique" <> ", обеспечивающим уникальность одного или пары значений, и " <> textit "foreign key" <> ", позволяющим сохранить ссылочную ценность." <> parbreak
    "При этом я обратил внимание на то, что " <> textit "constraints" <> " распространяются только на отдельную строку, т.е. не могут проверять значения других строк или таблиц. Для моей инфологической модели было необходимо ограничение, учитывающее записи из других таблиц, и для его реализации мне пришлось использовать триггер."
