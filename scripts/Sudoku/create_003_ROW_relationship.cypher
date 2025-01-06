// create 003 - ROW relationship
MATCH (c:Cell)
WITH c.row AS row, c.id AS id
ORDER BY row, id
WITH row, collect(id) AS toconnect
CALL (row, toconnect) {
  UNWIND range(0,8) AS index
  WITH toconnect[index] AS sourceid, toconnect[index+1] AS targetid
  MATCH (source:Cell WHERE source.id = sourceid)
  MATCH (target:Cell WHERE target.id = targetid)
  CREATE (source)-[:ROW]->(target)
  RETURN count(*) AS connections
}
RETURN sum(connections) AS thecount;