// misc 003 - set the board
WITH split($input,'') AS entries
UNWIND range(1,9) AS row
UNWIND range(1,9) AS column
MATCH (cell:Cell WHERE cell.id = toInteger(toString(row) + toString(column)))
SET cell.value = toInteger(entries[((row - 1) * 9) + (column - 1)])
REMOVE cell.pencilmark;