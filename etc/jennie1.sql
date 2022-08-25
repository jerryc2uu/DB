UPDATE member
SET mno = 1018
WHERE name = '이제리';

commit;

alter table guestboard
modify body varchar2(200 char);


/*
    방명록 페이지에서 필요한 데이터
    
        글번호, 작성자 아이디, 본문, 작성일, 아바타 저장 이름 
    
        방명록테이블 : 글번호, 본문, 작성일
        회원테이블 : 작성자 아이디
        아바타 테이블 : 저장이름
        
    따라서 3개의 테이블을 조인해야 한다.
    최종적으로 rownum 기준으로 일부 데이터만 가져와야 하므로
    조건절에 rownum을 비교하는 구문이 포함되어야 한다.
*/

--정렬방식은 작성일 기준 내림차순

SELECT
    gno, id, body, wdate, savename
FROM
    member m, guestboard g, avatar a
WHERE
    g.isshow = 'Y'
    AND mno = writer
    AND avt = ano
ORDER BY
    wdate DESC
;

-- => rownum을 붙여준다.

SELECT
    ROWNUM rno, gno, id, body, wdate, savename
FROM
    (   SELECT
            gno, id, body, wdate, savename
        FROM
            member m, guestboard g, avatar a
        WHERE
            g.isshow = 'Y'
            AND mno = writer
            AND avt = ano
        ORDER BY
            wdate DESC
    )
;

--ROWNUM을 스칼라데이터로 만들고

SELECT
    rno, gno, id, body, wdate, savename
FROM
(
    SELECT
        ROWNUM rno, gno, id, body, wdate, savename
    FROM
        (   SELECT
                gno, id, body, wdate, savename
            FROM
                member m, guestboard g, avatar a
            WHERE
                g.isshow = 'Y'
                AND mno = writer
                AND avt = ano
            ORDER BY
                wdate DESC
        )
)
WHERE
    rno BETWEEN 4 AND 6
;

SELECT
    *
FROM
    member
;
