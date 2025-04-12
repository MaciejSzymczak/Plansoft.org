1. See data removal

2. Health check
SELECT LISTAGG(name, ', ') WITHIN GROUP (ORDER BY name) AS GRUPY_DUPLIKATY
FROM groups
GROUP BY upper(name)
having count(1)>1
order by 1

???ATTENDANCE_LIST_HELPER



