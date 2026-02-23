//Criação dos Nós
MERGE (u:User {id: 0})
SET u.name = "Test Name"
MERGE (t:Track {name: "Test Track"})
MERGE (a:Artist {name: "Test Artist"})
MERGE (g:Genre {name: "Test Genre"})

// Criação dos Relacionamentos
MERGE (u)-[:LIKED]->(t)
MERGE (u)-[:LIKES_ARTIST]->(a)
MERGE (t)-[:BY_ARTIST]->(a)
MERGE (t)-[:HAS_GENRE]->(g)

