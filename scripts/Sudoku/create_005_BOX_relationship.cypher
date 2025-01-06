// create 005 - BOX relationship
MATCH (c:Cell)
WITH c.box AS box, c.id AS id
ORDER BY box, id
WITH box, collect(id) AS toconnect
CALL (box, toconnect) {
  UNWIND range(0,8) AS index
  WITH toconnect[index] AS sourceid, toconnect[index+1] AS targetid
  MATCH (source:Cell WHERE source.id = sourceid)
  MATCH (target:Cell WHERE target.id = targetid)
  CREATE (source)-[:BOX]->(target)
  RETURN count(*) AS connections
}
RETURN sum(connections) AS thecount;