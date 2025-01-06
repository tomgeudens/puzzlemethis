// update 001 - naked singles
UNWIND range(1,9) AS value
WITH value, COUNT {MATCH (cell:Cell) WHERE cell.value = value} AS frequency
ORDER BY frequency DESC
WITH value, frequency
WHERE frequency < 9
CALL (value) {
  CALL (value) {
    MATCH (cell:Cell) 
    // the cell is empty
    WHERE cell.value = 0 AND cell.pencilmark IS NULL
    // and there's nothing in the cell's row that has the value
    AND NOT EXISTS {
      MATCH (cell)-[:ROW]-+(other) WHERE other.value = value
    }
    // and there's nothing in the cell's column that has the value
    AND NOT EXISTS {
      MATCH (cell)-[:COLUMN]-+(other) WHERE other.value = value
    }
    // and there's nothing in the cell's box that has the value
    AND NOT EXISTS {
      MATCH (cell)-[:BOX]-+(other) WHERE other.value = value
      OR value IN other.pencilmark // reason is "box" here
    }
    WITH cell.box AS box, collect(cell.id) AS theids
    WHERE size(theids) = 1
    RETURN theids[0] AS single, "box" AS reason // there's only one possibility for the value in the box
  }
  RETURN single, reason
  UNION
  CALL (value) { 
    MATCH (cell:Cell) 
    // the cell is empty
    WHERE cell.value = 0 AND cell.pencilmark IS NULL
    // and there's nothing in the cell's row that has the value
    AND NOT EXISTS {
      MATCH (cell)-[:ROW]-+(other) WHERE other.value = value
      OR value IN other.pencilmark // reason is "row" here
    }
    // and there's nothing in the cell's column that has the value
    AND NOT EXISTS {
      MATCH (cell)-[:COLUMN]-+(other) WHERE other.value = value
    }
    // and there's nothing in the cell's box that has the value
    AND NOT EXISTS {
      MATCH (cell)-[:BOX]-+(other) WHERE other.value = value
    }
    WITH cell.row AS row, collect(cell.id) AS theids
    WHERE size(theids) = 1
    RETURN theids[0] AS single, "row" AS reason // there's only one possibility for the value in the row
  }
  RETURN single, reason
  UNION
  CALL (value) {
    MATCH (cell:Cell) 
    // the cell is empty
    WHERE cell.value = 0 AND cell.pencilmark IS NULL
    // and there's nothing in the cell's row that has the value
    AND NOT EXISTS {
      MATCH (cell)-[:ROW]-+(other) WHERE other.value = value
    }
    // and there's nothing in the cell's column that has the value
    AND NOT EXISTS {
      MATCH (cell)-[:COLUMN]-+(other) WHERE other.value = value
      OR value IN other.pencilmark // reason is "column" here
    }
    // and there's nothing in the cell's box that has the value
    AND NOT EXISTS {
      MATCH (cell)-[:BOX]-+(other) WHERE other.value = value
    }
    WITH cell.column AS column, collect(cell.id) AS theids
    WHERE size(theids) = 1
    RETURN theids[0] AS single, "column" AS reason // there's only one possibility for the value in the column
  }
  RETURN single, reason
}
WITH value, single, collect(reason) as reasons
MATCH (cell:Cell WHERE cell.id = single)
SET cell.value = value
REMOVE cell.pencilmark
RETURN count(*);
