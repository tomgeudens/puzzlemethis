// misc 002 - frequency count
UNWIND range(1,9) AS value
WITH value, COUNT {MATCH (cell:Cell) WHERE cell.value = value} AS frequency
ORDER BY frequency DESC
WITH value, frequency
WHERE frequency < 9
RETURN value, frequency