--N 1
--Название и продолжительность самого длинного трека (ов)
SELECT 
    t.name as name,
    t.duration as duration
FROM tracks t
WHERE t.duration = (
    SELECT MAX(duration) as max_duration
    FROM tracks
    )

-- N 2
--Название треков с продолжительностью не менее 3,5 мин
SELECT
    t.name as name,
    t.duration as duration
FROM tracks t 
WHERE t.duration >= 3.5*60;

--N 3
--Названия сборников, вышедших в период с 2018 по 2020
SELECT 
    c.name as name,
    c.release_year as year
FROM collections c 
WHERE c.release_year BETWEEN 2018 AND 2020;

--N 4
--Исполнители, чье имя состоит из 1 слова, был пропущен
SELECT *
FROM artists a 
WHERE a.name NOT LIKE '% %'

--N 5
--Названия треков, которые содержат слова мой или my
SELECT 
    t.name as name 
FROM tracks t
WHERE 
    t.name like '%Мой%'
    OR t.name like '%мой%'
    OR t.name like '%My%'
    OR t.name like '%my%';

--N 6
--Количество исполнителей в каждом жанре
SELECT g.name as name, q.artists_count as artists_count
FROM genres g 
LEFT JOIN(
    SELECT ga.genre_id as genre_id, COUNT(aa.artist_id) as artists_count
    FROM genres_albums ga 
    LEFT JOIN artists_albums aa 
    ON ga.album_id = aa.album_id 
    GROUP BY ga.genre_id
) q
ON g.id = q.genre_id
WHERE q.artists_count IS NOT NULL;



-- N 7
--Количество треков в альбомах 2019-2020
SELECT COUNT(*) as track_count
FROM tracks t 
INNER JOIN albums a 
ON t.album_id = a.id
WHERE a.release_year BETWEEN 2019 AND 2020;

-- N 8
--Средняя продолжительность треков по альбомам
SELECT a.name as name, q.d as avr_duration
FROM albums a 
INNER JOIN (
    SELECT 
        a1.id as album_id,
        AVG(t.duration) as d
    FROM tracks t 
    INNER JOIN albums a1 
    ON t.album_id = a1.id 
    GROUP BY a1.id
) q
ON a.id = q.album_id;

-- N 9
--Исполнители, которые не выпустили альбомы в 2020
SELECT a.name as name
FROM artists a 
INNER JOIN (
    SELECT a1.id as artist_id
    FROM artists as a1
    EXCEPT
    SELECT DISTINCT aa.artist_id
    FROM artists_albums aa
    INNER JOIN albums al
    ON aa.album_id = al.id
    WHERE al.release_year = 2020
) q
ON a.id = q.artist_id
--Более точный запрос соединение через id

-- N 10
--названия сборников в которые присутствует исполнитель Гусля
SELECT DISTINCT c.name as name
FROM collections c 
INNER JOIN tracks_collections tc 
ON c.id = tc.collection_id 
INNER JOIN tracks t 
ON tc.track_id = t.id 
INNER JOIN artists_albums aa 
ON t.album_id = aa.album_id  
INNER JOIN artists a 
ON aa.artist_id = a.id 
WHERE a.name = 'Гусля';

-- N 11
--названия альбомов с исполнителями более 1 жанра
--обращаю внимание на то, что жанры я привязал к альбомам
--а не к исполнителям (как было в предыдущем задании)
--поэтому для определения артистов нескольких жанров нужен вложенный запрос
SELECT DISTINCT al.name as name
FROM albums al
INNER JOIN artists_albums aa 
ON al.id = aa.album_id 
INNER JOIN (
    SELECT aa1.artist_id as artist_id, COUNT(ga.genre_id) as genre_count
    FROM artists_albums aa1  
    INNER JOIN genres_albums ga 
    ON aa1.album_id = ga.album_id 
    GROUP BY aa1.artist_id
    ) q
ON aa.artist_id = q.artist_id 
WHERE q.genre_count > 1;
--через HAVING без вложенного запроса не получается

-- N 12
--названия треков которые не входят в сборники
SELECT t.name as name
FROM tracks t
LEFT JOIN tracks_collections tc
ON t.id = tc.track_id 
WHERE tc.track_id IS NULL;

-- N 13
--исполнитель(и) с самым коротким треком
SELECT a.name as name
FROM artists a
INNER JOIN artists_albums aa 
ON a.id = aa.artist_id 
INNER JOIN tracks t 
ON aa.album_id = t.album_id 
WHERE t.duration = (
    SELECT MIN(t1.duration) as min_duration
    FROM tracks t1 
)

-- N 14
--альбом(ы) с наименьшим количеством треков
--вариант 1
SELECT a.name as name
FROM albums a
INNER JOIN (
    SELECT
        t.album_id as album_id,
        COUNT(*) as count_track
    FROM tracks t
    GROUP BY t.album_id
) q
ON a.id = q.album_id
INNER JOIN (
    SELECT
        MIN(q2.count_track) as min_count_track
   	FROM (
        SELECT
            t1.album_id as album_id,
            COUNT(*) as count_track
   	    FROM tracks t1 
        GROUP BY t1.album_id
   	) q2
) q1
ON q.count_track = q1.min_count_track;

--вариант 2
SELECT a.name as name
FROM albums a
INNER JOIN (
    SELECT 
        t.album_id,
        COUNT(*)
    FROM tracks t 
    GROUP BY t.album_id
    HAVING COUNT(*) = (
        SELECT
            COUNT(*) as c_min
        FROM tracks t 
        GROUP BY t.album_id
        ORDER BY c_min
        LIMIT 1
    )
) q
ON a.id = q.album_id

-- мне кажется, что поиск минимального значения выполняется бытрее
-- чем сортировка по убыванию.
