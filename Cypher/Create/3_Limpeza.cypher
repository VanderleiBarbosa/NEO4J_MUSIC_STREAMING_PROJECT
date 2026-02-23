// Limpa os dados teste inseridos para criação dos nós
MATCH (n) WHERE n.name CONTAINS "test"
DETACH DELETE n