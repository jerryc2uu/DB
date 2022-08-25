SELECT
    mno, id
FROM
    member
;

SELECT
    *
FROM
    member
WHERE
    mno = 1001
;

UPDATE
    member
SET
    tel = '010-1212-1212'
WHERE
    id = ?
;

commit;

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen, joindate, isshow)
VALUES(
        (SELECT
            NVL(MAX(mno) + 1, 1001)
        FROM
            member), 
        '홍길동', 'gildong', '12345', 'gil@githrd.com', '010-0532-0753', '17', 'M', sysdate, 'Y'
);

SELECT
    mno, name, id, pw, mail, tel, avt, gen, joindate, isshow
FROM
    MEMBER
WHERE
    mno =  (SELECT
                MAX(mno)
            FROM
                MEMBER
            )
;
