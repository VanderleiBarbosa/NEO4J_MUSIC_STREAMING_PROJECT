// Executa a importação das músicas
CALL
  apoc.periodic.iterate(
    '
  LOAD CSV WITH HEADERS FROM "https://github.com/VanderleiBarbosa/NEO4J_MUSIC_STREAMING_PROJECT/raw/refs/heads/main/Files/spotify_dataset.csv" AS row
  RETURN row
  LIMIT 5000

  ',
    '
  MERGE (t:Track {songId: row.track_id})
  SET t.name = row.name,
      t.spotifyPreviewUrl = row.spotify_preview_url,
      t.spotifyId = row.spotify_id,
      t.year = toInteger(row.year),
      t.durationMs = toInteger(row.duration_ms),
      t.danceability = toFloat(row.danceability),
      t.energy = toFloat(row.energy),
      t.key = toInteger(row.key),
      t.loudness = toFloat(row.loudness),
      t.mode = toInteger(row.mode),
      t.speechiness = toFloat(row.speechiness),
      t.acousticness = toFloat(row.acousticness),
      t.instrumentalness = toFloat(row.instrumentalness),
      t.liveness = toFloat(row.liveness),
      t.valence = toFloat(row.valence),
      t.tempo = toFloat(row.tempo),
      t.timeSignature = toInteger(row.time_signature)

  MERGE (a:Artist {name: row.artist})
  MERGE (t)-[:BY_ARTIST]->(a)

  WITH t, a, row
  WHERE row.genre IS NOT NULL AND TRIM(row.genre) <> ""
  MERGE (g:Genre {name: TRIM(row.genre)})
  MERGE (t)-[:HAS_GENRE]->(g)

  ',
    {batchSize: 1000, parallel: false}
  )