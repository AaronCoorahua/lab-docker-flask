CREATE TABLE IF NOT EXISTS item (
  item_id serial PRIMARY KEY,
  priority varchar(256),
  task varchar(256)
);
