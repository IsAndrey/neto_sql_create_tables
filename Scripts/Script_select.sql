--Название и продолжительность самого длинного трека (ов)
SELECT 
    t.name as name,
    t.duration as duration
FROM tracks as t
INNER JOIN
(SELECT
    MAX(duration) as d
FROM tracks) AS select_max
ON duration = select_max.d

--Название треков с продолжительностью не менее 3,5 мин
SELECT
    t.name as name,
    t.duration as duration
FROM tracks t 
WHERE t.duration >= 3.5*60

--Названия сборников, вышедших в период с 2018 по 2020
SELECT 
    c."name" as name,
    c.release_year as year
FROM collections c 
WHERE c.release_year BETWEEN 2018 AND 2020

--Названия треков, которые содержат слова мой или my
SELECT 
    t.name as name 
FROM tracks t
WHERE t.name like '%Мой%' OR t.name like '%мой%'
