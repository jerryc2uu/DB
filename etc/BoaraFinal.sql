-- 총 댓글 수 조회 (페이징 처리)
SELECT
    COUNT(*) cnt
FROM
    reply
WHERE
    isshow IN('Y', 'S')
    AND bno = 100008
;
-- 전체 댓글 리스트 조회
SELECT
		    rowno, rno, bno, uprno, mno, id, oid, body, rdate, savename, isshow, step
		FROM
		    (
		    SELECT
		        ROWNUM rowno, rno, bno, uprno, mno, id, oid, body, rdate, savename, isshow, step
		    FROM
		        (
		        SELECT
		            r.rno, r.bno, uprno, r.mno, id, 
		            (
		            SELECT
		                id oid
		            FROM
		                member
		            WHERE
		                mno = (
		                        SELECT
		                            DISTINCT b.mno
		                        FROM
		                            reply r, board b
		                        WHERE
		                            b.bno = #{bno}
		                            )
		            ) oid,
		                body, rdate, savename, r.isshow, (level - 1) step         
		        FROM
		            reply r, member m, imgfile f
		        WHERE
		            r.isshow IN('Y', 'S')
		            AND r.mno = m.mno
		            AND m.mno = f.mno(+)
		            AND r.bno = #{bno}
		            AND f.isshow(+) = 'C'
		            AND f.whereis(+) = 'M'
		        START WITH
		            uprno IS NULL
		        CONNECT BY
		            PRIOR r.rno = uprno
		        ORDER SIBLINGS BY
		            rdate DESC
		        )
		    )
		WHERE
		    rowno BETWEEN #{startCont} AND #{endCont}
;

-- cno까지 가져오는 댓글 리스트 조회
SELECT
    rowno, rno, bno, uprno, cno, mno, id, oid, body, rdate, savename, isshow, step
FROM
    (
    SELECT
        ROWNUM rowno, rno, bno, uprno, cno, mno, id, oid, body, rdate, savename, isshow, step
    FROM
        (
        SELECT
            r.rno, r.bno, uprno, c.cno cno, r.mno, m.id, 
            (
            SELECT
                id oid
            FROM
                member
            WHERE
                mno = (
                        SELECT
                            DISTINCT b.mno
                        FROM
                            reply r, board b
                        WHERE
                            b.bno = 100008
                            )
            ) oid,
                r.body, rdate, savename, r.isshow, (level - 1) step         
        FROM
            reply r, member m, imgfile f, board b, collection c
        WHERE
            r.isshow IN('Y', 'S')
            AND c.mno = b.mno
            AND b.bno = r.bno
            AND r.mno = m.mno
            AND m.mno = f.mno(+)
            AND r.bno = 100008
            AND f.isshow(+) = 'C'
            AND f.whereis(+) = 'M'
        START WITH
            uprno IS NULL
        CONNECT BY
            PRIOR r.rno = uprno
        ORDER SIBLINGS BY
            rdate DESC
        )
    )
WHERE
    rowno BETWEEN 1 AND 3
;
--댓글 작성하는 회원 정보 조회
SELECT
    m.mno mno, savename
FROM
    member m, imgfile f
WHERE
    m.isshow IN('Y', 'A')
    AND m.mno = f.mno(+)
    AND f.isshow(+) = 'C'
    AND f.whereis(+) = 'M'
    AND m.id = 'psoy'
;
commit;
--새 댓글 작성
INSERT INTO
    reply(rno, bno, uprno, mno, body, isshow)
VALUES(
    (SELECT NVL(MAX(rno) + 1, 100001) FROM reply),
    100008, 100001, 1002, '다시 테스트', 'S'
);

--댓글 삭제
UPDATE
    reply
SET
    isshow = 'N'
WHERE
    rno = 100012;
    
--댓글 수정 폼보기 (작성자 아이디, 날짜, 댓글 내용, 스포일러 여부)
SELECT
    r.rno rno, uprno, r.mno mno, body, rdate, savename, r.isshow isshow, f.savename savename
FROM
    reply r, member m, imgfile f
WHERE
    r.isshow IN('Y', 'S')
    AND r.rno = 100001
    AND m.mno = f.mno(+)
    AND r.mno = m.mno
    AND m.id = 'psoy'
    AND f.isshow(+) = 'C'
    AND f.whereis(+) = 'M'
;

-- 댓글 수정 처리
UPDATE
    reply
SET
    body = '다시 수정!',
    isshow = 'S'
WHERE
    rno = 100001    
;
commit;
--댓글, 대댓글 작성 시 포인트 적립
INSERT INTO
    point(pno, mno, gnp, pcode, sumpoint)
VALUES(
    (SELECT
        NVL(MAX(pno) + 1, 1000000001) 
     FROM
        point), 1003, 5, 102, 
        (SELECT
            sumpoint
        FROM
            point
        WHERE
            (
            SELECT
                MAX(pno)
            FROM
                point
            WHERE
                mno = 1003
            ) = pno) + 5
);
SELECT
    sumpoint
FROM
    point
WHERE
    (
    SELECT
        MAX(pno)
    FROM
        point
    WHERE
        mno = 1003
    ) = pno    
;

--게시글 목록
SELECT
    bno
FROM
    board
WHERE
    cno =
    (
    SELECT
        cno
    FROM
        collection
    WHERE
        mno = 1002
    )
;
--게시글 갯수
SELECT
    COUNT(*) bcnt
FROM
    board
WHERE
    cno =
    (
    SELECT
        cno
    FROM
        collection
    WHERE
        mno = 1002
    )
;

--댓글 갯수
SELECT
    COUNT(*) rcnt
FROM
    reply
WHERE
    mno = 1002 
;

--가입일 조회
SELECT  
    jdate
FROM
    member
WHERE
    mno = 1002
;

--총 포인트 조회
SELECT
    sumpoint
FROM
    point
WHERE
    pdate =
    (
    SELECT
        MAX(pdate)
    FROM
        point
    WHERE
        mno = 1003)
;

-- --게시글 수, 댓글 수, 가입일, 포인트 한번에 조회
SELECT
    jdate,
    (
        SELECT
            COUNT(*) rcnt
        FROM
            reply
        WHERE
            mno = 1002 
    ) rcnt,
    (
        SELECT
            bno
        FROM
            board
        WHERE
            cno =
            (
            SELECT
                cno
            FROM
                collection
            WHERE
                mno = 1003
            )
    ) bcnt,
    (
        SELECT
            sumpoint
        FROM
            point
        WHERE
            pdate =
            (
            SELECT
                MAX(pdate)
            FROM
                point
            WHERE
                mno = 1002)
            AND mno = 1002
    ) sumpoint
FROM
    member
WHERE
    id = 'psoy'
;


SELECT
    mno
FROM
    member
WHERE
    id = 'psoy'
;
SELECT
    mno
FROM
    member
WHERE
    id = 'psoy';
    (
        SELECT
            COUNT(*) rcnt
        FROM
            reply
        WHERE
            mno = 1002 
    ) rcnt,
    (
        SELECT
            COUNT(*) bcnt
        FROM
            board
        WHERE
            cno =
            (
            SELECT
                cno
            FROM
                collection
            WHERE
                mno = 1002
            )
    ) bcnt,
    (
        SELECT
            sumpoint
        FROM
            point
        WHERE
            pdate =
            (
            SELECT
                MAX(pdate)
            FROM
                point
            WHERE
                mno = 1002)
            AND mno = 1002
    ) sumpoint
    ;
SELECT
    rcnt, 
FROM
    (
        SELECT
            COUNT(*) rcnt
        FROM
            reply
    ),
    (
        SELECT
            COUNT(*) bcnt
        FROM
            board
        WHERE
            cno =
            (
            SELECT
                cno
            FROM
                collection
            WHERE
                mno = 1002
            )
    ),
    (
        SELECT
            sumpoint
        FROM
            point
        WHERE
            pdate =
            (
            SELECT
                MAX(pdate)
            FROM
                point
            WHERE
                mno = 1002)
            AND mno = 1002
    )
WHERE
    mno = 1002
;
--### 최종 ### 회원 프로필 사진, 가입일, 
SELECT
    m.jdate jdate, i.savename savename, p.sumpoint,
    (
        SELECT
            COUNT(*)
        FROM
            reply
        WHERE
            mno = (SELECT
                        mno
                    FROM
                        member
                    WHERE
                        id = 'ez') 
    ) rcnt,
    (
        SELECT
            COUNT(*)
        FROM
            board        
        WHERE
            mno = (SELECT
                        mno
                    FROM
                        member
                    WHERE
                        id = 'ez')
    ) bcnt
    
FROM
    member m, imgfile i, point p
WHERE
    id = 'ez'
    AND m.mno = i.mno
    AND i.isshow = 'C'
    AND i.whereis = 'M'
    AND m.mno = p.mno
    AND pdate = (
                    SELECT
                        MAX(pdate)
                    FROM
                        point
                    WHERE
                        mno = (SELECT
                                    mno
                                FROM
                                    member
                                WHERE
                                    id = 'ez')
                )
;

--#### 최종에서 from절 수정 ####회원 프로필 사진, 가입일, 
SELECT
    m.jdate jdate, i.savename savename, p.sumpoint, NVL(rcnt, 0) rcnt,  NVL(bcnt, 0) bcnt
FROM
    member m, imgfile i, point p,
    (
        SELECT
            mno, NVL(COUNT(*), 0) rcnt
        FROM
            reply
        WHERE
            isshow IN('Y', 'S')
        GROUP BY
            mno
    ) r,
    (
        SELECT
            mno, NVL(COUNT(*), 0) bcnt
        FROM
            board        
        WHERE
            isshow IN('Y', 'L')
        GROUP BY    
            mno
    ) b
WHERE
    id = 'ez'
    AND m.mno = i.mno
    AND i.isshow = 'C'
    AND i.whereis = 'M'
    AND m.mno = p.mno
    AND r.mno = m.mno
    AND b.mno = m.mno
    AND pdate = (
                    SELECT
                        MAX(pdate)
                    FROM
                        point
                    WHERE
                        mno = (SELECT
                                    mno
                                FROM
                                    member
                                WHERE
                                    id = 'ez')
                )
;


    COMMIT;
SELECT  
    COUNT(*)
FROM
    board
WHERE
    cno =
    (
    SELECT
        c.cno, 
    FROM
        collection c, board b
    WHERE
        mno = 1002
    )
;

SELECT
    mno
FROM
    member
WHERE
    id = #{id}
;
-- 구매게시글 갯수
SELECT
    COUNT(pno)
FROM
    point p
WHERE
    pcode = 201
    AND p.mno = (SELECT mno FROM member WHERE id = 'ez')
;

-- 나의 구매글 리스트 조회 (cno)
SELECT
		    bno, cno, id, title, sdate, click 
		FROM
		    (
		    SELECT
		        ROWNUM rno, bno, cno, id, title, sdate, click 
		    FROM
		        (
		        SELECT
		            bno, cno, id, title, TO_CHAR(wdate, 'yyyy/MM/dd') sdate, click 
		        FROM
		            member m, board b
		        WHERE
		            m.mno = b.mno
		            AND bno IN (
		                    SELECT
		                        bno
		                    FROM
		                        point p
		                    WHERE
		                        pcode = 201
		                        AND p.mno = (SELECT mno FROM member WHERE id = 'ez')
		                    )
		        )
		    )
		WHERE
		    rno BETWEEN 1 AND 3
;

-- 나의 구매글 리스트 조회 (cname)
SELECT
    bno, cname, id, title, sdate, price
FROM
    (
    SELECT
        ROWNUM rno, bno, cname, id, title, sdate, price
    FROM
        (
        SELECT
            bno, cname, id, title, TO_CHAR(wdate, 'yyyy/MM/dd') sdate, price
        FROM
            member m, board b, collection c
        WHERE
            m.mno = b.mno
            AND b.cno = c.cno
            AND bno IN (
                    SELECT
                        bno
                    FROM
                        point p
                    WHERE
                        pcode = 201
                        AND p.mno = (SELECT mno FROM member WHERE id = 'psoy')
                    )
        )
    )
WHERE
    rno BETWEEN 1 AND 3
;

SELECT
    bno, cno, id, title, TO_CHAR(wdate, 'yyyy/MM/dd') sdate, click 
FROM
    member m, board b
WHERE
    m.mno = b.mno
    AND bno = (
            SELECT
                bno
            FROM
                point p
            WHERE
                pcode = 201
                AND p.mno = (SELECT mno FROM member WHERE id = 'psoy')
            )
;            
            
-- 나의 구매글 리스트 조회
SELECT
    bno, cname, id, title, sdate, click 
FROM
    (
    SELECT
        ROWNUM rno, bno, cname, id, title, sdate, click 
    FROM
        (
        SELECT
            b.bno, b.cno, id, title, TO_CHAR(wdate, 'yyyy/MM/dd') sdate, click 
        FROM
            member m, board b, collection c
        WHERE
            m.mno = b.mno
            AND b.cno = c.cno
            AND bno = (
                    SELECT
                        bno
                    FROM
                        point p
                    WHERE
                        pcode = 201
                        AND p.mno = (SELECT mno FROM member WHERE id = 'ez')
                    )
        )
    )
WHERE
    rno BETWEEN 1 AND 3
;


SELECT
    bno, cname, id, title, TO_CHAR(wdate, 'yyyy/MM/dd') sdate, click 
FROM
    member m, board b, collection c
WHERE
    m.mno = b.mno
    AND b.cno = c.cno
    AND m.mno = c.mno
    AND bno = (
            SELECT
                bno
            FROM
                point p
            WHERE
                pcode = 201
                AND p.mno = (SELECT mno FROM member WHERE id = 'ez')
            )
;

SELECT
    m.mno mno, cname
FROM
    member m, board b, collection c
WHERE
    m.mno = b.mno
    AND b.mno = c.mno
    AND b.cno = c.cno
    AND m.mno = c.mno
;

--총 포인트 내역 갯수
SELECT
    COUNT(pno)
FROM
    point
WHERE
    mno = (
            SELECT
                mno
            FROM
                member
            WHERE
                id = 'ez'
            )
;
--포인트 이용 내역
SELECT
    pno, gnp, sdate, pcode, detail
FROM
    (
    SELECT
        ROWNUM rno, pno, gnp, sdate, pcode, detail
    FROM
        (
        SELECT
            pno, p.gnp gnp, TO_CHAR(p.pdate, 'yyyy/MM/dd') sdate, p.pcode pcode, detail
        FROM
            point p, detailcode d
        WHERE   
            p.pcode = d.pcode
            AND mno = (
                    SELECT
                        mno
                    FROM
                        member
                    WHERE
                        id = 'ez'
                    )
        ORDER BY
            pno DESC
        )
    )
WHERE
    rno BETWEEN 1 AND 3
;

--좋아요 갯수 조회
SELECT
    COUNT(MKNO)
FROM
    mark
WHERE
     mno = (
            SELECT
                mno
            FROM
                member
            WHERE
                id = 'ez'
            )
    AND isshow = 'L'
;

-- 찜 갯수 조회
SELECT
    COUNT(MKNO)
FROM
    mark
WHERE
     mno = (
            SELECT
                mno
            FROM
                member
            WHERE
                id = 'ez'
            )
    AND isshow = 'J'
;
--좋아요 목록 조회
SELECT
    b.bno bno, b.title, TO_CHAR(wdate, 'yyyy/MM/dd') sdate, b.click click, c.cname cname, 
FROM
    member m, board b, collection c
WHERE
    m.mno = b.mno

    AND b.cno = c.cno
    AND b.bno = (
                SELECT
                    bno
                FROM
                    mark
                WHERE
                    mno = (
                            SELECT
                                mno
                            FROM
                                member
                            WHERE
                                id = 'ez'
                            )
                    AND isshow = 'L'
                )
;

--찐 좋아요 목록

SELECT
    bno, cname, id, title, sdate, click 
FROM
    (
    SELECT
        ROWNUM rno, bno, cname, id, title, sdate, click 
    FROM
        (
        SELECT
            bno, cname, id, title, TO_CHAR(wdate, 'yyyy/MM/dd') sdate, click 
        FROM
            member m, board b, collection c
        WHERE
            m.mno = b.mno
            AND b.cno = c.cno
            AND bno IN (
                        SELECT
                            bno
                        FROM
                            mark
                        WHERE
                            mno = (
                                    SELECT
                                        mno
                                    FROM
                                        member
                                    WHERE
                                        id = 'ez'
                                    )
                            AND isshow = 'L'
                        )
        )
    )
WHERE
    rno BETWEEN 1 AND 6
;

-- 찜 목록 조회
SELECT
    bno, cname, id, title, sdate, click 
FROM
    (
    SELECT
        ROWNUM rno, bno, cname, id, title, sdate, click 
    FROM
        (
        SELECT
            bno, cname, id, title, TO_CHAR(wdate, 'yyyy/MM/dd') sdate, click 
        FROM
            member m, board b, collection c
        WHERE
            m.mno = b.mno
            AND b.cno = c.cno
            AND bno IN (
                        SELECT
                            bno
                        FROM
                            mark
                        WHERE
                            mno = (
                                    SELECT
                                        mno
                                    FROM
                                        member
                                    WHERE
                                        id = 'ez'
                                    )
                            AND isshow = 'J'
                        )
        )
    )
WHERE
    rno BETWEEN 1 AND 6
;

--내가 작성한 게시글
SELECT
    COUNT(bno)
FROM
    board
WHERE
    mno = (
            SELECT
                mno
            FROM
                member
            WHERE
                id = 'psoy'
            )
;
SELECT
    bno, cname, title, sdate, click           
FROM
    (
    SELECT
        ROWNUM rno, bno, cname, title, sdate, click
    FROM
        (
        SELECT
            bno, cname, b.title title, TO_CHAR(wdate, 'yyyy/MM/dd') sdate, click   
        FROM
            board b, collection c
        WHERE
            b.cno = c.cno
            AND b.mno = (
                    SELECT
                        mno
                    FROM
                        member
                    WHERE
                        id = 'psoy'
                    )
        ORDER BY
            wdate DESC
        )
    )
WHERE
    rno BETWEEN 1 AND 5
;

--내가 작성한 댓글
SELECT
    COUNT(rno)
FROM
    reply
WHERE
    mno = (
            SELECT
                mno
            FROM
                member
            WHERE
                id = 'psoy'
            )
    AND isshow IN ('Y', 'S')
;
SELECT
    rno, body, sdate, title
FROM
    (
    SELECT
        ROWNUM rowno, rno, body, sdate, title
    FROM
        (
            SELECT
                rno, r.body body, TO_CHAR(rdate, 'yyyy/MM/dd') sdate, b.title title
            FROM
                reply r, board b
            WHERE
                r.bno = b.bno
                AND r.mno = (
                            SELECT
                                mno
                            FROM
                                member
                            WHERE
                                id = 'psoy'
                            )
                AND r.isshow IN ('Y', 'S')
            )
        )
WHERE   
    rowno BETWEEN 1 AND 5
;

--전체 댓글 리스트 조회 (게시글 작성자 아이디까지)
SELECT
    rowno, rno, bno, uprno, mno, id, oid, body, rdate, savename, isshow, step
FROM
    (
    SELECT
        ROWNUM rowno, rno, bno, uprno, mno, id, oid, body, rdate, savename, isshow, step
    FROM
        (
        SELECT
            r.rno, r.bno, uprno, r.mno, id, 
            (
            SELECT
                id oid
            FROM
                member
            WHERE
                mno = (
                        SELECT
                            DISTINCT b.mno
                        FROM
                            reply r, board b
                        WHERE
                            b.bno = r.bno
                            )
            ) oid,
                body, rdate, savename, r.isshow, (level - 1) step         
        FROM
            reply r, member m, imgfile f
        WHERE
            r.isshow IN('Y', 'S')
            AND r.mno = m.mno
            AND m.mno = f.mno(+)
            AND r.bno = 100008
            AND f.isshow(+) = 'C'
            AND f.whereis(+) = 'M'
        START WITH
            uprno IS NULL
        CONNECT BY
            PRIOR r.rno = uprno
        ORDER SIBLINGS BY
            rdate DESC
        )
    )
WHERE
    rowno BETWEEN 1 AND 3
;
SELECT
    id oid
FROM
    member
WHERE
    mno = (
            SELECT
                DISTINCT b.mno
            FROM
                reply r, board b
            WHERE
                b.bno = r.bno
                )
;
-- 댓글 수정 폼보기
SELECT
    r.rno rno, uprno, r.mno mno, m.id id, body, rdate, savename, r.isshow isshow, f.savename savename
FROM
    reply r, member m, imgfile f
WHERE
    r.isshow IN('Y', 'S')
    AND r.rno = 100002
    AND m.mno = f.mno(+)
    AND r.mno = m.mno
    AND m.id = 'ez'
    AND f.isshow(+) = 'C'
    AND f.whereis(+) = 'M'
;

--포인트 충전 처리
INSERT INTO
    point(pno, mno, gnp, pcode, sumpoint)
VALUES(
    (SELECT
        NVL(MAX(pno) + 1, 1000000001) 
     FROM
        point),
    (
    SELECT
        mno
    FROM
        member
    WHERE
        id = 'psoy'
    ), 5000, 101, 
        (SELECT
            sumpoint
        FROM
            point
        WHERE
            (
            SELECT
                MAX(pno)
            FROM
                point
            WHERE
                mno = (
                    SELECT
                        mno
                    FROM
                        member
                    WHERE
                        id = 'psoy'
                    )
            ) = pno) + 5000
);

SELECT
    sumpoint
FROM
    point
WHERE
    (
    SELECT
        MAX(pno)
    FROM
        point
    WHERE
        mno = (
            SELECT
                mno
            FROM
                member
            WHERE
                id = 'ksoy'
            )
    ) = pno
;

--게시글 구매
INSERT INTO
    point(pno, mno, gnp, pcode, sumpoint, bno)
VALUES(
    (SELECT
        NVL(MAX(pno) + 1, 1000000001) 
     FROM
        point),
    (
    SELECT
        mno
    FROM
        member
    WHERE
        id = 'psoy'
    ), -500, 201, 
        (SELECT
            sumpoint
        FROM
            point
        WHERE
            (
            SELECT
                MAX(pno)
            FROM
                point
            WHERE
                mno = (
                    SELECT
                        mno
                    FROM
                        member
                    WHERE
                        id = 'psoy'
                    )
            ) = pno) - 500, 100011
);

COMMIT;

SELECT
    COUNT(*) bought
FROM
    point
WHERE
    bno = 100011
    AND mno = (SELECT mno FROM member WHERE id = 'ez');
    
--hot 포스팅 추가
INSERT INTO
    hot(hno, bno)
VALUES(
    (SELECT NVL(MAX(hno) + 1, 100001) FROM hot),
    100001
);

--내가 작성한 게시글 목록 (hno 추가)
SELECT
    bno, cname, title, sdate, click, hno           
FROM
    (
    SELECT
        ROWNUM rno, bno, cname, title, sdate, click, hno
    FROM
        (
        SELECT
            b.bno, cname, b.title title, TO_CHAR(wdate, 'yyyy/MM/dd') sdate, click, h.hno hno   
        FROM
            board b, collection c, hot h
        WHERE
            b.cno = c.cno
            AND h.bno(+) = b.bno
            AND h.hend(+) > sysdate
            AND b.mno = (
                    SELECT
                        mno
                    FROM
                        member
                    WHERE
                        id = 'psoy'
                    )
        ORDER BY
            wdate DESC
        )
    )
WHERE
    rno BETWEEN 1 AND 3
;

SELECT
    b.bno, h.hno
FROM
    board b, hot h
WHERE
    b.bno = h.bno
;

--핫 포스팅 등록시 포인트 차감
INSERT INTO
        point(pno, mno, gnp, pcode, sumpoint)
VALUES(
    (SELECT
        NVL(MAX(pno) + 1, 1000000001) 
     FROM
        point),
    (
    SELECT
        mno
    FROM
        member
    WHERE
        id = 'psoy'
    ), -5000, 204, 
        (SELECT
            sumpoint
        FROM
            point
        WHERE
            (
            SELECT
                MAX(pno)
            FROM
                point
            WHERE
                mno = (
                    SELECT
                        mno
                    FROM
                        member
                    WHERE
                        id = 'psoy'
                    )
            ) = pno) - 5000
)
;
commit;

--총 포인트 조회
SELECT
    sumpoint
FROM
    point
WHERE
    pdate =
    (
    SELECT
        MAX(pdate)
    FROM
        point
    WHERE
        mno = (
                SELECT
                    mno
                FROM
                    member
                WHERE
                    id = 'psoy'
                )
        AND pcode = 101
    
    )
;


SELECT
		    pno, gnp, sdate, pcode, detail
		FROM
		    (
		    SELECT
		        ROWNUM rno, pno, gnp, sdate, pcode, detail
		    FROM
		        (
		        SELECT
		            pno, p.gnp gnp, TO_CHAR(p.pdate, 'yyyy/MM/dd') sdate, p.pcode pcode, detail
		        FROM
		            point p, detailcode d
		        WHERE   
		            p.pcode = d.pcode
		            AND mno = (
		                    SELECT
		                        mno
		                    FROM
		                        member
		                    WHERE
		                        id = 'psoy'
		                    )
                    AND p.pcode = 101
		        ORDER BY
		            pno DESC
		        )
		    )
		WHERE
		    rno BETWEEN #{startCont} AND #{endCont}
;

SELECT
		    pno, gnp, sdate, pcode, detail, NVL(payno, 0)
		FROM
		    (
		    SELECT
		        ROWNUM rno, pno, gnp, sdate, pcode, detail, payno
		    FROM
		        (
		        SELECT
		            pno, p.gnp gnp, TO_CHAR(p.pdate, 'yyyy/MM/dd') sdate, p.pcode pcode, detail, p.payno
		        FROM
		            point p, detailcode d
		        WHERE   
		            p.pcode = d.pcode
		            AND mno = (
		                    SELECT
		                        mno
		                    FROM
		                        member
		                    WHERE
		                        id = 'psoy'
		                    )
		        ORDER BY
		            pno DESC
		        )
		    )
		WHERE
		    rno BETWEEN 1 AND 3;

-- 환불 처리
UPDATE
    point
SET
    isRefund = 'N'
WHERE
    imp_uid = 'imp_940138130783'
;

-- 환불 내역 입력
INSERT INTO
    point(pno, mno, gnp, pcode, sumpoint)
VALUES(
    (SELECT
        NVL(MAX(pno) + 1, 1000000001) 
     FROM
        point),
    (
    SELECT
        mno
    FROM
        member
    WHERE
        id = #{id}
    ), #{gnp}, 205, 
        (SELECT
            sumpoint
        FROM
            point
        WHERE
            (
            SELECT
                MAX(pno)
            FROM
                point
            WHERE
                mno = (
                    SELECT
                        mno
                    FROM
                        member
                    WHERE
                        id = #{id}
                    )
            ) = pno) - #{gnp}
);


COMMIT;

INSERT INTO
		    point(pno, mno, gnp, pcode, sumpoint, merchant_uid, imp_uid, isRefund)
		VALUES(
		    (SELECT
		        NVL(MAX(pno) + 1, 1000000001) 
		     FROM
		        point),
		    (
		    SELECT
		        mno
		    FROM
		        member
		    WHERE
		        id = #{id}
		    ), #{gnp}, 101, 
		        (SELECT
		            sumpoint
		        FROM
		            point
		        WHERE
		            (
		            SELECT
		                MAX(pno)
		            FROM
		                point
		            WHERE
		                mno = (
		                    SELECT
		                        mno
		                    FROM
		                        member
		                    WHERE
		                        id = #{id}
		                    )
		            ) = pno) + #{gnp}
		)
;


-- 구매시 작가한테 포인트 추가
INSERT INTO
		    point(pno, mno, gnp, pcode, sumpoint)
		VALUES(
		    (SELECT
		        NVL(MAX(pno) + 1, 1000000001) 
		     FROM
		        point),
		    (
		    SELECT
		        mno
		    FROM
		        member
		    WHERE
		        id = 'psoy'
		    ), 500, 104, 
		        (SELECT
		            sumpoint
		        FROM
		            point
		        WHERE
		            (
		            SELECT
		                MAX(pno)
		            FROM
		                point
		            WHERE
		                mno = (
		                    SELECT
		                        mno
		                    FROM
		                        member
		                    WHERE
		                        id = 'psoy'
		                    )
		            ) = pno) + 500
		)
;
(SELECT
    sumpoint
FROM
    point
WHERE
    (
    SELECT
        MAX(pno)
    FROM
        point
    WHERE
        mno = (
            SELECT
                mno
            FROM
                member
            WHERE
                id = 'psoy'
            )
    ) = pno);
    
--포인트 조회
SELECT
		    sumpoint
		FROM
		    point
		WHERE
		    pno =
		    (
		    SELECT
		        MAX(pno)
		    FROM
		        point
		    WHERE
		        mno = (
		                SELECT
		                    mno
		                FROM
		                    member
		                WHERE
		                    id = 'ksoy'
		                )
		    
		    );
            
            --이미 자동 충전 설정 돼있으면 자동결제 선택 못함...

-- 자동 충전 스케줄러 데이터 조회
SELECT
    pno, mno, gnp,
    
FROM
    point
WHERE
    pno = (
            SELECT
                MAX(pno)
            FROM
                point
            WHERE
                isauto = 'A'
            )
;

SELECT
    p.sumpoint
FROM
    point p, autopayment a
WHERE
    p.mno = tmno
    p.pno = (
            SELECT
                MAX(pno)
            FROM
                point
            WHERE
                isauto = 'A'
            )
;
---------------------------최종완성!!!------------------------------------------------
--자동결제한 회원, 금액, 합계 포인트 조회
SELECT
    p.mno mno, m.id, p.gnp gnp, a.sumpoint sumpoint
FROM
    point p,
        (SELECT
                sumpoint, mno
            FROM
                point
            WHERE
                pno IN (
                        SELECT
                            MAX(pno)
                        FROM
                            point
                        GROUP BY
                            mno
                        )
                AND mno IN (
                            SELECT
                                mno
                            FROM
                                autopayment
                            WHERE
                                isauto = 'A'
                            )
                    ) a, member m
WHERE
    p.mno = a.mno
    AND p.mno = m.mno
    AND isauto = 'A'
    AND pno IN (
                SELECT
                    MAX(pno)
                FROM
                    point
                WHERE
                    isauto = 'A'
                GROUP BY
                    mno
                ) 
;

--자동 충전 처리
INSERT INTO
    point(pno, mno, gnp, pcode, sumpoint, isRefund, isauto)
VALUES(
    (SELECT
        NVL(MAX(pno) + 1, 1000000001) 
     FROM
        point), 1001, 1000, 101, 
        (SELECT
            sumpoint
        FROM
            point
        WHERE
            (
            SELECT
                MAX(pno)
            FROM
                point
            WHERE
                mno = 1001
            ) = pno) + 1000, 'N', 'A'
    )
;
---------------------------------------------------------------------------------

--가장 최근 합계포인트
SELECT
    mno, sumpoint
FROM
    point
WHERE
    pno = (
            SELECT
                MAX(pno)
            FROM
                point
            WHERE
                mno = (
                        SELECT
                            mno
                        FROM
                            autopayment
                        WHERE
                            isauto = 'A'
                        )
            GROUP BY
                mno
            )
;

-- 가장 최근 합계 포인트
SELECT
    sumpoint
FROM
    point
WHERE
    pno IN (
            SELECT
                MAX(pno)
            FROM
                point
            GROUP BY
                mno
            )
    AND mno IN (
                SELECT
                    mno
                FROM
                    autopayment
                WHERE
                    isauto = 'A'
                )
;


--질의명령 에러 확인
SELECT
		    p.mno mno, m.id, p.gnp gnp, a.sumpoint sumpoint
		FROM
		    point p,
		        (SELECT
		                sumpoint, mno
		            FROM
		                point
		            WHERE
		                pno IN (
		                        SELECT
		                            MAX(pno)
		                        FROM
		                            point
		                        GROUP BY
		                            mno
		                        )
		                AND mno IN (
		                            SELECT
		                                mno
		                            FROM
		                                autopayment
		                            WHERE
		                                isauto = 'A'
		                            )
		                    ) a, member m
		WHERE
		    p.mno = a.mno
		    AND p.mno = m.mno
		    AND isauto = 'A'
		    AND pno IN (
		                SELECT
		                    MAX(pno)
		                FROM
		                    point
		                WHERE
		                    isauto = 'A'
		                GROUP BY
		                    mno
		                ) 
                        
----------

INSERT INTO
    point(pno, mno, gnp, pcode, sumpoint, isRefund, isauto)
VALUES(
    (SELECT
        NVL(MAX(pno) + 1, 1000000001) 
     FROM
        point), 1001, 1000, 101, 
        (SELECT
            sumpoint
        FROM
            point
        WHERE
            (
            SELECT
                MAX(pno)
            FROM
                point
            WHERE
                mno = 1001
            ) = pno) + 1000, 'N', 'A'
);	

------------------

INSERT INTO
		    point(pno, mno, gnp, pcode, sumpoint, isRefund, isAuto)
		VALUES(
		    (SELECT
		        NVL(MAX(pno) + 1, 1000000001) 
		     FROM
		        point),
		    (
		    SELECT
		        mno
		    FROM
		        member
		    WHERE
		        id = 'ez'
		    ), 1000, 101, 
		        (SELECT
		            sumpoint
		        FROM
		            point
		        WHERE
		            (
		            SELECT
		                MAX(pno)
		            FROM
		                point
		            WHERE
		                mno = (
		                    SELECT
		                        mno
		                    FROM
		                        member
		                    WHERE
		                        id = 'ez'
		                    )
		            ) = pno) + 1000, 'N', 'A'
		);
        
commit;


--마이페이지 메인 해지버튼 까지~~
SELECT
    m.jdate jdate, i.savename savename, p.sumpoint,
    (
        SELECT
            COUNT(*)
        FROM
            reply
        WHERE
            mno = (SELECT
                        mno
                    FROM
                        member
                    WHERE
                        id = 'psoy') 
    ) rcnt,
    (
        SELECT
            COUNT(*)
        FROM
            board        
        WHERE
            mno = (SELECT
                        mno
                    FROM
                        member
                    WHERE
                        id ='psoy')
    ) bcnt, a.isauto
    
FROM
    member m, imgfile i, point p, autopayment a
WHERE
    id ='psoy'
    AND a.mno(+) = p.mno
    AND m.mno = i.mno
    AND i.isshow = 'C'
    AND i.whereis = 'M'
    AND m.mno = p.mno
    AND a.tno = (SELECT
                    MAX(tno)
                FROM
                    autopayment
                WHERE
                    id = 'psoy'
                )
    AND pno = (
                    SELECT
                        MAX(pno)
                    FROM
                        point
                    WHERE
                        pdate = (SELECT MAX(pdate)
                                FROM point
                                WHERE mno = (
                                    SELECT mno
                                    FROM member
                                    WHERE id = 'psoy')
                                )
                        AND mno = (SELECT mno FROM member WHERE id = 'psoy')
                    GROUP BY
                        pdate
                )
    
;

COMMIT;

UPDATE
    autopayment
SET
    isAuto = 'N'
WHERE
    mno = (
            SELECT
                mno
            FROM
                member
            WHERE
                id = 'psoy'
            );