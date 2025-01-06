// misc 001 - how many left todo
MATCH (c:Cell WHERE c.value = 0)
RETURN count(*) AS todo