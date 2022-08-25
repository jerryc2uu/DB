SELECT
    ano, savename, gen
FROM
    avatar
WHERE
    gen IN('M', 'F')
    AND isshow = 'Y'
;

INSERT INTO
    member(mno, name, id, pw, mail, tel, gen, avt)
VALUES(
    (SELECT NVL(MAX(mno) + 1, 1001) FROM member),
    #{name}, #{id}, #{pw}, #{mail}, #{tel}, #{gen}, #{ano} 
);

SELECT
    mno, name
FROM
    member
WHERE
    isshow = 'Y'
;

SELECT
    mno, name, id, mail, tel, m.gen, joindate jdate, ano, savename
FROM
    member m, avatar a
WHERE
    avt = ano
    AND id = 'jennie';
    
SELECT
    ano, savename
FROM
    avatar
WHERE
    gen = 
    AND isshow = 'Y';

SELECT
     id, avatar, wdate, body
FROM
    (
        SELECT
            ROWNUM rno, id, avatar, wdate, body
        FROM    
            (    
                SELECT
                    id, savename avatar, wdate, body
                FROM
                    guestboard g, member m, avatar a
                WHERE
                    g.isshow = 'Y'
                    AND writer = mno
                    AND avt = ano
                ORDER BY
                    wdate DESC
            )
    )
WHERE
    rno BETWEEN 4 AND 6
    rno BETWEEN #{startCont} AND #{endCont}
;

SELECT
    bno, id, body, wdate, avatar, step
FROM
    (
    SELECT
        ROWNUM rno, bno, id, body, wdate, avatar, step
    FROM
        (
            SELECT  
                rbno bno, id, body, wdate, savename avatar, (level - 1) step        
            FROM
                reboard r, member m, avatar a    
            WHERE
                rbmno = mno
                AND avt = ano
                AND r.isshow = 'Y'
            START WITH
                upno IS NULL
            CONNECT BY
                PRIOR rbno = upno
            ORDER SIBLINGS BY
                wdate DESC
        )
    )
WHERE
    rno BETWEEN 4 AND 6
;


SELECT
    COUNT(*)
FROM
    reboard
WHERE
    isshow = 'Y'
;

INSERT INTO
    reboard(rbno, upno, rbmno, body)
VALUES(
    (SELECT NVL(MAX(rbno) + 1, 100001) FROM reboard),
    #{
);

SELECT
    bno, title, NVL(cnt, 0) cnt
FROM
    board b,
    (
        SELECT
            fbno, COUNT(*) cnt
        FROM
            fileinfo
        WHERE
            isshow = 'Y'
        GROUP BY
            fbno
    )
WHERE
    bno = fbno(+)
;

SELECT
    mno, savename avatar, rbno upno, body    
FROM    
    member m, avatar a, reboard r
WHERE
    avt = ano
    AND id = 'jennie'
    AND rbno = 100001
;

SELECT
    mno, savename avatar, rbno upno, body, wdate
FROM    
    member m, avatar a, reboard r
WHERE
    avt = ano
    AND mno = rbmno
    AND rbno = 100001
;

SELECT
    rbno, upno, body, (level - 1) step
FROM
    reboard
WHERE
    isshow = 'Y'
START WITH
    upno IS NULL
CONNECT BY
    PRIOR rbno = upno
ORDER SIBLINGS BY
    wdate DESC
;

UPDATE
    reboard
SET
    isshow = 'N'
WHERE
    rbno IN (
                SELECT
                    rbno
                FROM
                    reboard
                WHERE
                    isshow = 'Y'
                START WITH
                    rbno = 100005
                CONNECT BY
                    PRIOR rbno = upno
            )
;

-----------------------------------------
--설문조사 만들기
-----------------------------------------

CREATE TABLE surveyInfo(
    sino NUMBER(4)
        CONSTRAINT SI_NO_PK PRIMARY KEY,
    sititle VARCHAR2(50 CHAR)
        CONSTRAINT SI_TITLE_NN NOT NULL,
    sistart DATE,
    siend DATE    
);

CREATE TABLE surveyQuest(
    sqno NUMBER(6)
        CONSTRAINT SQ_NO_PK PRIMARY KEY,
    sqbody VARCHAR2(50 CHAR)
        CONSTRAINT SQ_BODY_NN NOT NULL,
    squpno NUMBER(6),
    sq_sino NUMBER(4)
        CONSTRAINT SQ_SINO_FK REFERENCES surveyInfo(sino)
        CONSTRAINT SQ_SINO_NN NOT NULL
);

CREATE TABLE survey(
    svno NUMBER(6)
        CONSTRAINT SV_NO_PK PRIMARY KEY,
    smno NUMBER(4)
        CONSTRAINT SV_MNO_FK REFERENCES member(mno)
        CONSTRAINT SV_MNO_NN NOT NULL,
    sv_sqno NUMBER(6)
        CONSTRAINT SV_QNO_FK REFERENCES surveyquest(sqno)
        CONSTRAINT SV_QNO_NN NOT NULL,
    svdate DATE DEFAULT sysdate
        CONSTRAINT SV_DATE_NN NOT NULL
);

INSERT INTO
    surveyInfo
VALUES(
    1001, '2022년 상반기 아이돌 선호도 조사', '2022/06/10', '2022/06/16'
);

-- 1번 문제
INSERT INTO
    surveyQuest
VALUES(
    100001, '제일 좋아하는 여성 아이돌 그룹을 선택하세요', null, 1001
);

INSERT INTO
    surveyQuest
VALUES(
    100002, '블랙핑크', 100001, 1001
);

INSERT INTO
    surveyQuest
VALUES(
    100003, '에스파', 100001, 1001
);

INSERT INTO
    surveyQuest
VALUES(
    100004, '아이브', 100001, 1001
);

INSERT INTO
    surveyQuest
VALUES(
    100005, '에이핑크', 100001, 1001
);

-- 2번 문제
INSERT INTO
    surveyQuest
VALUES(
    (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '제일 좋아하는 남성 아이돌 그룹을 선택하세요', null, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '샤이니', 100006, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '엑소', 100006, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), 'BTS', 100006, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '동방신기', 100006, 1001
);

-- 3번 문제
INSERT INTO
    surveyQuest
VALUES(
    (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '제일 좋아하는 남자 아이돌 멤버 선택', null, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), 'RM', 100011, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '유노윤호', 100011, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '차은우', 100011, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '런쥔', 100011, 1001
);

-- 4번 문제
INSERT INTO
    surveyQuest
VALUES(
    (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '제일 좋아하는 여자 아이돌 멤버 선택', null, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '태연', 100016, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '제니', 100016, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '손나은', 100016, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '레이', 100016, 1001
);

-- 5번 문제
INSERT INTO
    surveyQuest
VALUES(
    (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '제일 좋아하는 블핑 멤버 선택', null, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '제니', 100021, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '리사', 100021, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '로제', 100021, 1001
);

INSERT INTO
    surveyQuest
VALUES(
     (SELECT NVL(MAX(sqno) + 1, 100001) FROM surveyquest), '지수', 100021, 1001
);

-- survey 테이블

INSERT INTO
    survey(svno, smno, sv_sqno)
VALUES(
    (SELECT NVL(MAX(svno) + 1, 100001) FROM survey),
    1000, 100002
);

INSERT INTO
    survey(svno, smno, sv_sqno)
VALUES(
    (SELECT NVL(MAX(svno) + 1, 100001) FROM survey),
    1000, 100009
);

INSERT INTO
    survey(svno, smno, sv_sqno)
VALUES(
    (SELECT NVL(MAX(svno) + 1, 100001) FROM survey),
    1000, 100014
);

INSERT INTO
    survey(svno, smno, sv_sqno)
VALUES(
    (SELECT NVL(MAX(svno) + 1, 100001) FROM survey),
    1000, 100018
);

INSERT INTO
    survey(svno, smno, sv_sqno)
VALUES(
    (SELECT NVL(MAX(svno) + 1, 100001) FROM survey),
    1000, 100022
);

commit;

-------------------------------------
-- 현재 진행중인 설문의 문항들만 조회
SELECT
    sqno qno, sqbody body
FROM
    surveyquest
WHERE
    sq_sino IN (
                    SELECT
                        sino
                    FROM
                        surveyinfo
                    WHERE
                        sysdate BETWEEN sistart AND siend
                )
    AND squpno IS NULL
;
-- 현재 진행중인 설문의 보기들만 조회
SELECT
    sqno qno, sqbody body
FROM
    surveyquest
WHERE
    sq_sino IN (
                    SELECT
                        sino
                    FROM
                        surveyinfo
                    WHERE
                        sysdate BETWEEN sistart AND siend
                )
    AND squpno = 100001
;


SELECT
    i.sino
FROM
    surveyinfo i, surveyquest
WHERE  
    sq_sino = (
                SELECT
                    sino
                FROM
                    surveyinfo
                WHERE
                    sysdate BETWEEN sistart AND siend
              )
;

--내가 참여 설문 번호
---------------------------------------------------------------
-- jennie 회원이 현재 진행 중인 설문 중 참여하지 않은 갯수 조회
---------------------------------------------------------------
SELECT
    COUNT(*)
FROM
    surveyinfo
WHERE
    sysdate BETWEEN sistart AND siend
    AND sino NOT IN (
                    SELECT
                        DISTINCT sq_sino
                    FROM
                        survey, surveyquest, member
                    WHERE
                        sv_sqno = sqno
                        AND smno = mno
                        AND id = 'jennie'
                    )
;


SELECT
    sq_sino
FROM
    surveyquest
WHERE
    sqno = 100002
;

SELECT
    smno
FROM
    survey
WHERE
    sv_sqno = (
                SELECT
                    sqno
                FROM
                    surveyquest
                WHERE
                    sq_sino = (
                                SELECT
                                    sino
                                FROM
                                    surveyinfo
                                WHERE
                                    sysdate BETWEEN sistart AND siend
                                )
                )
;

-- 참여한 갯수
SELECT
    COUNT(*) cnt
FROM
    survey
WHERE
    sv_sqno = (
                SELECT
                    sqno
                FROM
                    surveyquest
                WHERE
                    sq_sino = 
                                (
                                SELECT
                                    sino
                                FROM
                                    surveyinfo
                                WHERE
                                    sysdate BETWEEN sistart AND siend
                                )
                )
    AND smno = 1001
;

--내가 참여한 설문조사 갯수 조회
SELECT
    sino, sititle title,
    NVL(
        (SELECT
            COUNT(DISTINCT sq_sino)
        FROM
            survey, surveyquest, member
        WHERE
            sv_sqno(+) = sqno
            AND smno = mno
            AND id = 'jerryc'
        GROUP BY
            sq_sino
        HAVING
            sq_sino = sino)
    , 0) cnt
FROM
    surveyinfo
WHERE
    sysdate BETWEEN sistart AND siend
;

SELECT
    sino, sititle,
    (
       SELECT
            COUNT(*)
        FROM
            surveyinfo
        WHERE
            sysdate BETWEEN sistart AND siend
            AND sino NOT IN (
                            SELECT
                                DISTINCT sq_sino
                            FROM
                                survey, surveyquest, member
                            WHERE
                                sv_sqno = sqno
                                AND smno = mno
                                AND id = 'jennie'
                            )
    ) cnt
FROM
    surveyinfo
WHERE
    sysdate BETWEEN sistart AND siend
;

-- 설문 번호로 설문 주제 조회
SELECT
    sino, sititle title
FROM
    surveyinfo
WHERE
    sino = 1001
;

-- 설문 번호(sino)로 설문 문항만 조회
SELECT
    sqno qno, sqbody body
FROM
    surveyquest
WHERE
    sq_sino = 1001
    AND squpno IS NULL
ORDER BY
    sqno
;

--문항 번호로 보기 조회
SELECT
    sqno qno, sqbody body
FROM
    surveyquest
WHERE
    squpno = 100001
ORDER BY
    sqno
;

--계층 질의 명령으로 문제와 보기 조회
SELECT
    sqno, sqbody body, NVL(squpno, sqno) upno
FROM
    surveyquest
WHERE
    sq_sino = 1001
START WITH
    squpno IS NULL
CONNECT BY
    PRIOR sqno = squpno
ORDER SIBLINGS BY
    sqno
;

-- 설문조사 응답 추가
INSERT INTO
    survey(svno, smno, sv_sqno)
VALUES(
    (SELECT NVL(MAX(svno) + 1, 100001) FROM survey),
    1001, 100002 
);

SELECT
				mno
			FROM
				member
			WHERE
				id = 'jennie';
                
-- 설문에 응답한 수 조회
SELECT
    count(DISTINCT smno) total
FROM
    survey
WHERE
    sv_sqno IN(
                SELECT
                    sqno
                FROM
                    surveyQuest
                WHERE
                    sq_sino = 1001
               )
;

SELECT
    count(DISTINCT smno) total
FROM
    survey, surveyQuest
WHERE
    sv_sqno(+) = sqno
    AND sq_sino = 1001
;

-- result 페이지 열 때 필요한 데이터 sino
-- 문항 내용, 문항의 보기들, 보기들 득표율 조회
-- 득표율 = 획득 표 / 전체표

-- 각 문항 별 득표 수
SELECT
    sqno, COUNT(sv_sqno) cnt
FROM
    surveyquest, survey
WHERE   
    sqno = sv_sqno(+)
    AND squpno IS NOT NULL 
    AND sq_sino = 1001
GROUP BY
    sqno       
;

--설문 주제 번호로 문항과 보기, 득표율 한 번에 조회
SELECT
    sqno, sqbody body, NVL(squpno, sqno) upno, NVL(ROUND(cnt / total * 100, 2), 0) per
FROM
    surveyquest,
    (
        SELECT
            sqno qno, COUNT(sv_sqno) cnt
        FROM
            surveyquest, survey
        WHERE   
            sqno = sv_sqno(+)
            AND squpno IS NOT NULL 
            AND sq_sino = 1001
        GROUP BY
            sqno
        ORDER BY
            qno
    ),
    (
        SELECT
            count(DISTINCT smno) total
        FROM
            survey, surveyQuest
        WHERE
            sv_sqno(+) = sqno
            AND sq_sino = 1001
    )
WHERE
    sqno = qno(+)
ORDER BY
    upno, sqno
;

-- 한 문항에 해당하는 보기와 득표율만 조회
SELECT
    sqno, sqbody, NVL(squpno, sqno) upno, ROUND(cnt / total * 100, 2) per
FROM
    surveyquest,
     (
        SELECT
            sqno qno, COUNT(sv_sqno) cnt
        FROM
            surveyquest, survey
        WHERE   
            sqno = sv_sqno(+)
            AND squpno = 100001
        GROUP BY
            sqno
        ORDER BY
            qno
    ),
    (
        SELECT
            count(DISTINCT smno) total
        FROM
            survey, surveyQuest
        WHERE
            sv_sqno(+) = sqno
            AND squpno = 100001
    )
WHERE
    sqno = qno
ORDER BY
    upno, sqno
;

-- =======================================
-- ======== 파일게시판 ===================
-- =======================================

--총 게시글 수 조회
SELECT
    COUNT(*)
FROM
    board 
WHERE
    isshow = 'Y'
;

-- 총 게시글 리스트 조회
SELECT
    bno, id, title, wdate, click, cnt
FROM
    (
    SELECT
        ROWNUM rno, bno, id, title, wdate, click, cnt
    FROM
        (
        SELECT
            bno, id, title, wdate, click, NVL(cnt, 0) cnt
        FROM
            board b, member m,
            (
                SELECT
                    fbno, COUNT(*) cnt
                FROM
                    fileinfo
                WHERE
                    isshow ='Y'
                GROUP BY
                    fbno
            )
        WHERE
            b.isshow = 'Y'
            AND bmno = mno
            AND fbno(+) = bno
        ORDER BY
            wdate DESC
        )
    )
WHERE
    rno BETWEEN 1 AND 3
;

--파일 갯수 조회 (글번호, 파일 갯수)
SELECT
    fbno, COUNT(*) cnt
FROM
    fileinfo
WHERE
    isshow ='Y'
GROUP BY
    fbno
;

-- 센세 버전
SELECT
    bno, id, title, wdate, click, cnt
FROM
    (
    SELECT
        ROWNUM rno, bno, id, title, wdate, click, cnt
    FROM
        (
            SELECT
                bno, id, title, wdate, click, cnt     
            FROM
                board, member,
                (
                    SELECT
                        bno fbno, NVL(COUNT(fno), 0) cnt
                    FROM
                        board, fileInfo
                    WHERE
                        bno = fbno(+)
                    GROUP BY
                        bno
                )
            WHERE
                bno = fbno
                AND bmno = mno
                AND board.isshow = 'Y'
            ORDER BY
                bno DESC
        )
    )
WHERE
    rno BETWEEN 1 AND 3
;

SELECT
    bno, fno
FROM
    board, fileinfo
WHERE
    bno = fbno(+)
;

-- 게시글 내용 조회 (글번호, 아이디, 타이틀, 본문, 작성일)
SELECT
    bno, id, title, body, wdate
FROM
    board, member
WHERE
    bmno = mno
    AND isshow = 'Y'
    ANDbno = 100002
;

-- 게시글의 첨부파일 조회
SELECT
    savename, dir
FROM
    fileinfo
WHERE
    fbno = 100004 
    AND isshow = 'Y'
;

SELECT 
    NVL(MAX(bno) + 1, 100001) 
FROM 
    board
;

INSERT INTO
    board(bno, bmno, title, body)
VALUES(
    #{bno},
    (SELECT mno FROM member WHERE id = #{id}),
    #{title}, #{body}
);

SELECT 
    NVL(MAX(fno) + 1, 10000001) 
FROM 
    fileinfo
;

INSERT INTO
    fileinfo(fno, fbno, oriname, savename, dir, len)
VALUES(
    #{fno}, #{bno}, #{oriname}, #{savename}, #{dir}, #{len}
);