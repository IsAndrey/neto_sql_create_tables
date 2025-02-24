CREATE TABLE IF NOT EXISTS genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS artists (
    id SERIAL PRIMARY KEY, 
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS albums (
    id SERIAL PRIMARY KEY, 
    name VARCHAR(255) NOT NULL, 
    release_year SMALLINT,
    CONSTRAINT min_release_year CHECK (release_year >= 1900),
    CONSTRAINT max_release_year CHECK (release_year <= EXTRACT(YEAR FROM CURRENT_DATE))
);

CREATE TABLE IF NOT EXISTS artists_albums (
    id SERIAL PRIMARY KEY, 
    artist_id INT NOT NULL,
    album_id INT NOT NULL,
    CONSTRAINT fk_artist FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE,
    CONSTRAINT fk_album FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE CASCADE,
    CONSTRAINT artist_album UNIQUE (artist_id, album_id)
);

CREATE TABLE IF NOT EXISTS genres_albums (
    id SERIAL PRIMARY KEY, 
    genre_id INT NOT NULL,
    album_id INT NOT NULL,
    CONSTRAINT fk_genre FOREIGN KEY (genre_id) REFERENCES genres(id) ON DELETE CASCADE,
    CONSTRAINT fk_album FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE CASCADE,
    CONSTRAINT genre_album UNIQUE (genre_id, album_id)
);

CREATE TABLE IF NOT EXISTS tracks (
    id SERIAL PRIMARY KEY, 
    name VARCHAR(255) NOT NULL,
    duration SMALLINT CHECK (duration > 0 AND duration < 4000),
    album_id INT REFERENCES albums(id) NOT NULL
);

CREATE TABLE IF NOT EXISTS collections (
    id SERIAL PRIMARY KEY, 
    name VARCHAR(255) NOT NULL, 
    release_year SMALLINT,
    CONSTRAINT min_release_year CHECK (release_year >= 1900),
    CONSTRAINT max_release_year CHECK (release_year <= EXTRACT(YEAR FROM CURRENT_DATE))
);

CREATE TABLE IF NOT EXISTS tracks_collections (
    id SERIAL PRIMARY KEY, 
    track_id INT NOT NULL,
    collection_id INT NOT NULL,
    CONSTRAINT fk_track FOREIGN KEY (track_id) REFERENCES tracks(id) ON DELETE CASCADE,
    CONSTRAINT fk_collection FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE,
    CONSTRAINT track_collection UNIQUE (track_id, collection_id)
);