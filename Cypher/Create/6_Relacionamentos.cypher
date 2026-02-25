
// Relaciona pessoas com artistas e pessoas com músicas

//por usuário
MATCH (u:User)
WITH u

//filtra artistas com pelo menos 5 músicas
MATCH (a:Artist)<-[:BY_ARTIST]-(t:Track)
WITH u, a, count(s) AS totalMusicas
WHERE totalMusicas >= 5
WITH u, collect(DISTINCT a) AS artistasValidos

//sorteia entre 10 e 20 artistas
WITH u, artistasValidos, toInteger(rand() * 11) + 10 AS qtdArtistas
WITH u, apoc.coll.randomItems(artistasValidos, qtdArtistas) AS artistasSorteados
UNWIND artistasSorteados AS artista
MERGE (u)-[:LIKES_ARTIST]->(artista) 
WITH u, artistasSorteados

//sorteia entre 5 e 15 artistas para curtir músicas
WITH u, artistasSorteados, toInteger(rand() * 11) + 5 AS qtdArtistasLikes
WITH u, apoc.coll.randomItems(artistasSorteados, qtdArtistasLikes) AS artistasParaLikes
UNWIND artistasParaLikes AS artistaLike

// pega entre 1 e 5 músicas do artista que ainda não foram curtidas pelo usuário
MATCH (artistaLike)<-[:BY_ARTIST]-(t:Track)
WHERE NOT (u)-[:LIKED]->(t)
WITH u, artistaLike, collect(DISTINCT s) AS musicasPossiveis, toInteger(rand() * 5) + 1 AS qtdMusicas
WITH u, apoc.coll.randomItems(musicasPossiveis, qtdMusicas) AS musicasSorteadas
UNWIND musicasSorteadas AS musica
MERGE (u)-[:LIKED]->(musica) // Relaciona as pessoas com as músicas
