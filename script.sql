-- rows to insert
SELECT 'insert' AS operation, * FROM new
WHERE ${key} NOT IN
(
	SELECT DISTINCT ${key} FROM old
)
UNION
-- rows to update
SELECT 'update', * FROM
(
	SELECT * FROM new EXCEPT SELECT * FROM old
)
WHERE ${key} IN
(
	SELECT DISTINCT ${key} FROM old
)
UNION
-- rows to delete
SELECT 'delete', * FROM
(
	SELECT * FROM old EXCEPT SELECT * FROM new
)
WHERE ${key} NOT IN
(
	SELECT DISTINCT ${key} FROM new
);
