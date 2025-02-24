TRUNCATE TABLE artists CASCADE;
TRUNCATE TABLE genres CASCADE;
TRUNCATE TABLE albums CASCADE;
TRUNCATE TABLE collections CASCADE;

INSERT INTO artists (id, name)
VALUES
(1, 'Незнайка'),
(2, 'Винтик и Шпунтик'),
(3, 'Гусля'),
(4, 'Доктор Пилюлькин'),
(5, 'Хор коротышек');

INSERT INTO genres (id, name) 
VALUES
(1, 'Рок'),
(2, 'Шансон'),
(3, 'Классика'),
(4, 'Популярная музыка'),
(5, 'Блатняк');

INSERT INTO albums (id, name, release_year)
VALUES
(1, 'Роковая труба', 2018),
(2, 'Пой дудочка пой', 2020),
(3, 'Пора в путь дорогу', 2020),
(4, 'Песни народные, блатные, хороводные', 2022);

INSERT INTO tracks (id, name, duration, album_id)
VALUES
(1, 'Утренняя побудка', 120, 1),
(2, 'Все бегут, бегут, бегут', 15, 1),
(3, 'Непонятая мелодия', 30, 1),
(4, 'Коцерт для дудочки и скрипки', 30*60, 2),
(5, 'Коцерт для дудочки и трубы', 30*60, 2),
(6, 'Пора в путь дорогу', 200, 3),
(7, 'Автомобили', 180, 3),
(8, 'Незнайка нажми на тормоза', 190, 3),
(9, 'Мой Цветочный город', 300, 4),
(10, 'Все выше, выше и выше', 240, 4),
(11, 'Касторка и йод', 110, 4),
(12, 'Никто кроме меня', 115, 4);

INSERT INTO collections (id, name, release_year)
VALUES
(1, 'Концерт ко дню города', 2019),
(2, 'Лейся песня', 2020),
(3, 'Наше творчество', 2021);

INSERT INTO artists_albums (id, artist_id, album_id)
VALUES
(1, 1, 1), 
(2, 2, 3),
(3, 3, 2),
(4, 4, 4),
(5, 1, 4),
(6, 3, 4),
(7, 5, 4);

INSERT INTO genres_albums (id, genre_id, album_id)
VALUES
(1, 1, 1),
(2, 3, 2),
(3, 4, 3),
(4, 4, 4),
(5, 2, 4);

INSERT INTO tracks_collections (id, collection_id, track_id)
VALUES
(1, 1, 1),
(2, 1, 3),
(3, 1, 7),
(4, 1, 8),
(5, 2, 2),
(6, 2, 3),
(7, 2, 7),
(8, 2, 10),
(9, 3, 1),
(10, 3, 4),
(11, 3, 9),
(12, 3, 12);
