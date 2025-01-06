// misc 004 - export from grid
UNWIND range(1,9) AS row
UNWIND range(1,9) AS column
MATCH (cell:Cell WHERE cell.id = toInteger(toString(row) + toString(column)))
RETURN reduce(result="",entry in collect(cell.value) | result + entry) AS sudoku;