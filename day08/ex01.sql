/*
    employee 테이블의 사원들 중 전화번호가 011로 시작하는 사원들만 조회해서 5명씩 한 페이지에 보여주려 한다.
    이 때 3페이지에 표시될 사원을 조회하라
    first_name 순 오름차순
*/
SELECT
    *
FROM
    (SELECT
        ROWNUM rno, g.*
    FROM
        (SELECT
            *   
        FROM
            employees
        WHERE
            phone_number LIKE '011%'
        ORDER BY
            first_name) g)
WHERE
    rno BETWEEN 11 AND 15
;