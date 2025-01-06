// create 002 - nodes
FOREACH(row IN range(1,9) |
  FOREACH(column IN range(1,9) |
    CREATE (:Cell {
      id: toInteger(toString(row) + toString(column)), 
      stringid: "r" + toString(row) + "c" + toString(column),
      row: row,
      column: column,
      gridlocation: point({ x: column - 1, y: (row - 9) * -1 }),
      value: 0,
      box: 3 * ( ( row  - 1 ) / 3 ) + ( ( column  - 1 ) / 3 ) + 1
    })
  )
)
WITH "created the nodes" AS result
MATCH (:Cell)
RETURN count(*) AS thecount;