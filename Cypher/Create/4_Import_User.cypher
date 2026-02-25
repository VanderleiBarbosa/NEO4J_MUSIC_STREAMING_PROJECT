
// importação dos usuários 
CALL apoc.periodic.iterate(
  '
  LOAD CSV WITH HEADERS FROM "https://github.com/VanderleiBarbosa/NEO4J_MUSIC_STREAMING_PROJECT/raw/refs/heads/main/Files/user.csv" AS row
  RETURN row
  ',
  '
  MERGE (u:User {userId: toInteger(row.userId)})
    ON CREATE SET
        u.name = row.name,
        u.email = row.email,
        u.age = toInteger(row.age),
        u.gender = row.gender,
        u.country = row.country,
        u.city = row.city,
        u.language = row.language,
        u.subscriber = toBoolean(row.subscriber),
        u.signupDate = date(row.signup_date),
        u.listeningTime = row.listening_time,
        u.device = row.device;
  ',
  {batchSize: 1000, parallel: false}
);
