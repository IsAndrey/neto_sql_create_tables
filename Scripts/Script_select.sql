--Название и продолжительность самого длинного трека (ов)
SELECT 
    t.name as name,
    t.duration as duration
FROM tracks t
INNER JOIN (
    SELECT MAX(duration) as max_duration
    FROM tracks
    ) q
ON t.duration = q.max_duration;

--Название треков с продолжительностью не менее 3,5 мин
SELECT
    t.name as name,
    t.duration as duration
FROM tracks t 
WHERE t.duration >= 3.5*60;

--Названия сборников, вышедших в период с 2018 по 2020
SELECT 
    c."name" as name,
    c.release_year as year
FROM collections c 
WHERE c.release_year BETWEEN 2018 AND 2020;

--Названия треков, которые содержат слова мой или my
SELECT 
    t.name as name 
FROM tracks t
WHERE 
    t.name like '%Мой%'
    OR t.name like '%мой%'
    OR t.name like '%My%'
    OR t.name like '%my%';

 --Количество исполнителей в каждом жанре
SELECT 
    g.name as name,
    COUNT(aa.artist_id) as artists_count
FROM genres g 
LEFT JOIN genres_albums ga 
ON g.id = ga.genre_id 
LEFT JOIN artists_albums aa 
ON ga.album_id = aa.album_id 
GROUP BY g.name;

--Количество треков в альбомах 2019-2020
SELECT COUNT(*) as track_count
FROM tracks t 
INNER JOIN albums a 
ON t.album_id = a.id
WHERE a.release_year BETWEEN 2019 AND 2020;

--Средняя продолжительность треков по альбомам
SELECT 
    a.name as name,
AVG(t.duration)
FROM tracks t 
INNER JOIN albums a 
ON t.album_id = a.id 
GROUP BY a.name;

--Исполнители, которые не выпустили альбомы в 2020
SELECT a.name as name
FROM artists a
EXCEPT
SELECT a1.name as name
FROM artists a1
LEFT JOIN artists_albums aa
ON a1.id = aa.artist_id 
LEFT JOIN albums al
ON aa.album_id = al.id 
WHERE al.release_year = 2020;

--названия сборников в которые присутствует исполнитель Гусля
SELECT c.name as name
FROM collections c 
INNER JOIN tracks_collections tc 
ON c.id = tc.collection_id 
INNER JOIN tracks t 
ON tc.track_id = t.id 
INNER JOIN artists_albums aa 
ON t.album_id = aa.album_id  
INNER JOIN artists a 
ON aa.artist_id = a.id 
WHERE a.name = 'Гусля'
GROUP BY c.name;

--названия альбомов с исполнителями более 1 жанра
SELECT al.name as name
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
WHERE q.genre_count > 1
GROUP BY al.name;

--названия треков которые не входят в сборники
SELECT t.name as name
FROM tracks t
INNER JOIN (
    SELECT t1.id as id
    FROM tracks t1
    EXCEPT 
    SELECT tc.track_id 
    FROM tracks_collections tc 
    GROUP BY tc.track_id
) q
ON t.id = q.id;

--исполнитель(и) с самым коротким треком
SELECT a.name as name
FROM artists a
INNER JOIN artists_albums aa 
ON a.id = aa.artist_id 
INNER JOIN tracks t 
ON aa.album_id = t.album_id 
INNER JOIN (
    SELECT MIN(t1.duration) as min_duration
    FROM tracks t1 
) q
ON t.duration = q.min_duration;

--альбом(ы) с наименьшим количеством треков
SELECT *
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