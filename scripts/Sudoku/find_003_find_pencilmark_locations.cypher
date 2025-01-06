// find 003 - find pencilmark locations
MATCH (cell:Cell)
REMOVE cell.pencilmark
WITH DISTINCT "pencilmarks cleared" AS message
UNWIND range(1,9) AS value
WITH value, COUNT {MATCH (cell:Cell) WHERE cell.value = value} AS frequency
ORDER BY frequency DESC
WITH value, frequency
WHERE frequency < 9
CALL (value) {
  CALL (value) {
    MATCH (cell:Cell) 
    // the cell is empty
    WHERE cell.value = 0
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
    }
    WITH cell.box AS box, collect(cell.id) AS theids
    RETURN theids AS options, "box" AS reason 
  }
  RETURN options, reason
  UNION
  CALL (value) { 
    MATCH (cell:Cell) 
    // the cell is empty
    WHERE cell.value = 0
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
    }
    WITH cell.row AS row, collect(cell.id) AS theids
    RETURN theids AS options, "row" AS reason
  }
  RETURN options, reason
  UNION
  CALL (value) {
    MATCH (cell:Cell) 
    // the cell is empty
    WHERE cell.value = 0
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
    }
    WITH cell.column AS column, collect(cell.id) AS theids
    RETURN theids AS options, "column" AS reason
  }
  RETURN options, reason
}
WITH options, collect(value) as values // don't care about the reasons
ORDER BY options
WITH options, values
WITH options, reduce(uniquevalues=[], value in values | CASE WHEN value IN uniquevalues THEN uniquevalues ELSE uniquevalues + value END) AS uniquevalues
WHERE size(options) = size(uniquevalues)
AND size(options) > 1
RETURN options, uniquevalues
