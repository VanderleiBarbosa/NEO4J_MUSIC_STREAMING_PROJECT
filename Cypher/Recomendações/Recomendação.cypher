
// Músicas de artistas seguidos que ainda não foram curtidas

//Por usuário, testando com um em específico
MATCH (u:User {name: "Isabella Rossi"})-[:LIKES_ARTIST]->(a:Artist)


MATCH (a)<-[:BY_ARTIST]-(t:Track)

// Filtra apenas as músicas que o usuário não ouviu
WHERE NOT (u)-[:LIKED]->(t)


WITH u, a, t
ORDER BY rand()
LIMIT 5

// Cria ou mescla o nó do algoritmo específico
MERGE (algo:Algorithm {tipo: "LikeArtist"})
SET
  algo.descricao = "recomendação com base nos artistas que o usuário curte",
  algo.versao = "1.0",
  algo.releaseDate = "2020-01-01"

// Cria o nó de recomendação
CREATE
  (rec:Rec
    {
      id: randomUUID(),
      data: date(),
      tipo: "baseado_em_artista_seguido",
      influenciadoPor: a.name,
      recomendadoPara: u.name
    })

// Relaciona o algoritmo à recomendação
MERGE (algo)-[rb:RECOMMENDED_BY]->(rec)

// Relaciona a recomendação à pessoa
MERGE (rec)-[rt:TARGETED_TO]->(u)

// Relaciona cada música à recomendação
MERGE (rec)-[rs:SUGGESTS]->(t)

// Relaciona cada música ao artista que a influenciou
MERGE (t)-[ri:INFLUENCED_BY]->(a)
SET a: InfluencerA

// Retorna os elementos do grafo para visualização
RETURN algo, rec, u, t, a, rb, rt, rs, ri
