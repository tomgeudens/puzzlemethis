// create 004 - COLUMN relationship
MATCH (c:Cell)
WITH c.column AS column, c.id AS id
ORDER BY column, id
WITH column, collect(id) AS toconnect
CALL (column, toconnect) {
  UNWIND range(0,8) AS index
  WITH toconnect[index] AS sourceid, toconnect[index+1] AS targetid
  MATCH (source:Cell WHERE source.id = sourceid)
  MATCH (target:Cell WHERE target.id = targetid)
  CREATE (source)-[:COLUMN]->(target)
  RETURN count(*) AS connections
}
RETURN sum(connections) AS thecount;