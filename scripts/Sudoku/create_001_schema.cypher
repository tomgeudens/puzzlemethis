// create 001 - schema
CREATE CONSTRAINT uniqueCellid 
IF NOT EXISTS FOR (c:Cell) REQUIRE (c.id) IS UNIQUE;