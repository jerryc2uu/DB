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

--직급
--직급 리스트 조회
SELECT
    DISTINCT job
FROM
    emp
;

SELECT
    emptno eno, ename
FROM
    emp
WHERE
    job = #{job}
;

--사원번호로 사원 정보 조회
SELECT
    e.empno eno, e.ename name, e.job, e.hiredate, e.sal, 
    NVL(TO_CHAR(e.comm), '커미션없음') comm, 
    dname, loc, grade, NVL(s.ename, '상사없음') sangsa
FROM
    emp e, emp s, dept d, salgrade
WHERE
    e.deptno = d.deptno
    AND e.mgr = s.empno(+)
    AND e.sal BETWEEN losal AND hisal
    AND e.empno = 7369
;

--부서번호
SELECT
    deptno dno, dname
FROM
    dept
;

--부서번호로 사원 리스트 조회
SELECT
    empno eno, ename
FROM
    emp
WHERE
    deptno = 10
;

--사원이름 첫 이니셜 종류 조회
SELECT
    DISTINCT SUBSTR(ename, 1, 1) ini
FROM
    emp
ORDER BY
    ini
;

--이니셜로 이름 조회
SELECT
    empno eno, ename
FROM
    emp
WHERE
    ename LIKE 'S' || '%' -- || : 결합연산자
;

CREATE TABLE singerType(
    no NUMBER(2)
        CONSTRAINT SINGERTYPE_NO_PK PRIMARY KEY,
    a_time VARCHAR2(2 CHAR)
        CONSTRAINT SINGERTYPE_TIME_CK CHECK (a_time IN('현재', '과거'))
        CONSTRAINT SINGERTYPE_TIME_NN NOT NULL,
    s_gen VARCHAR2(2 CHAR)
        CONSTRAINT SINGERTYPE_GEN_CK CHECK (s_gen IN('남자', '여자'))
        CONSTRAINT SINGERTYPE_GEN_NN NOT NULL
)
;

INSERT INTO
    singerType
VALUES(
    (SELECT NVL(MAX(no) + 1, 11) FROM singerType),
    '현재', '남자'
);
INSERT INTO
    singerType
VALUES(
    (SELECT NVL(MAX(no) + 1, 11) FROM singerType),
    '현재', '여자'
);
INSERT INTO
    singerType
VALUES(
    (SELECT NVL(MAX(no) + 1, 11) FROM singerType),
    '과거', '남자'
);
INSERT INTO
    singerType
VALUES(
    (SELECT NVL(MAX(no) + 1, 11) FROM singerType),
    '과거', '여자'
);


CREATE TABLE singer(
    num NUMBER(4)
        CONSTRAINT SINGER_NUM_PK PRIMARY KEY,
    s_type NUMBER(2)
        CONSTRAINT SINGER_TYPE_FK REFERENCES singerType(no)
        CONSTRAINT SINGER_TYPE_NN NOT NULL,
    name VARCHAR2(50 CHAR)
        CONSTRAINT SINGER_NAME_NN NOT NULL,
    scode CHAR(1)
        CONSTRAINT SINGER_CODE_CK CHECK (scode IN('G', 'M', 'S'))
        CONSTRAINT SINGER_CODE_NN NOT NULL,
    gno NUMBER(4)
)
;

INSERT INTO
    singer
VALUES(
    (SELECT NVL(MAX(num) + 1, 1001) FROM singer),
    12, '블랙핑크', 'G', null
);

INSERT INTO
    singer
VALUES(
    (SELECT NVL(MAX(num) + 1, 1001) FROM singer),
    12, '제니', 'M', 1001
);

INSERT INTO
    singer
VALUES(
    (SELECT NVL(MAX(num) + 1, 1001) FROM singer),
    12, '리사', 'M', 1001
);

INSERT INTO
    singer
VALUES(
    (SELECT NVL(MAX(num) + 1, 1001) FROM singer),
    12, '로제', 'M', 1001
);

INSERT INTO
    singer
VALUES(
    (SELECT NVL(MAX(num) + 1, 1001) FROM singer),
    12, '지수', 'M', 1001
);

INSERT INTO
    singer
VALUES(
    (SELECT NVL(MAX(num) + 1, 1001) FROM singer),
    13, '소방차', 'G', null
);

INSERT INTO
    singer
VALUES(
    (SELECT NVL(MAX(num) + 1, 1001) FROM singer),
    13, '정원관', 'M', 1001
);

INSERT INTO
    singer
VALUES(
    (SELECT NVL(MAX(num) + 1, 1001) FROM singer),
    13, '도건우', 'M', 1001
);

INSERT INTO
    singer
VALUES(
    (SELECT NVL(MAX(num) + 1, 1001) FROM singer),
    13, '김태형', 'M', 1001
);

INSERT INTO
    singer
VALUES(
    (SELECT NVL(MAX(num) + 1, 1001) FROM singer),
    12, '아이유', 'S', null
);

CREATE TABLE photo(
    pno NUMBER(6)
        CONSTRAINT PHOTO_NO_PK PRIMARY KEY,
    s_num NUMBER(4)
        CONSTRAINT PHOTO_SNUM_FK REFERENCES singer(num)
        CONSTRAINT PHOTO_SNUM_NN NOT NULL,
    oname VARCHAR2(200 CHAR)
        CONSTRAINT PHOTO_ONAME_NN NOT NULL,
    sname VARCHAR2(200 CHAR)
        CONSTRAINT PHOTO_SNAME_UK UNIQUE
        CONSTRAINT PHOTO_SNAME_NN NOT NULL,
    dir VARCHAR2(200 CHAR)
        CONSTRAINT PHOTO_DIR_NN NOT NULL,
    len NUMBER
        CONSTRAINT PHOTO_LEN_NN NOT NULL,
    show CHAR(1) DEFAULT 'Y'
        CONSTRAINT PHOTO_SHOW_CK CHECK (show IN('C', 'Y', 'N'))
        CONSTRAINT PHOTO_SHOW_NN NOT NULL
)
;

INSERT INTO
    photo
VALUES(
    (SELECT NVL(MAX(pno) + 1, 100001) FROM photo),
    1002, 'jennie.jpg', 'jennie.jpg', '/img/photo/', 10451, 'C'   
)
;

INSERT INTO
    photo
VALUES(
    (SELECT NVL(MAX(pno) + 1, 100001) FROM photo),
    1003, 'lisa.jpg', 'lisa.jpg', '/img/photo/', 4565, 'C'   
)
;

INSERT INTO
    photo
VALUES(
    (SELECT NVL(MAX(pno) + 1, 100001) FROM photo),
    1004, 'lose.jpg', 'lose.jpg', '/img/photo/', 4630, 'C'   
)
;

INSERT INTO
    photo
VALUES(
    (SELECT NVL(MAX(pno) + 1, 100001) FROM photo),
    1005, 'jisoo.jpg', 'jisoo.jpg', '/img/photo/', 7171, 'C'   
)
;

INSERT INTO
    photo
VALUES(
    (SELECT NVL(MAX(pno) + 1, 100001) FROM photo),
    1010, 'IU.jpg', 'IU.jpg', '/img/photo/', 7394, 'C'   
)
;
commit;

drop table ardudata;
CREATE TABLE ardudata(
    ano NUMBER(4)
        CONSTRAINT ARDU_NO_PK PRIMARY KEY,
    ddata NUMBER(7, 4)
        CONSTRAINT ARDU_DATA_NN NOT NULL,
    wdate DATE DEFAULT sysdate
        CONSTRAINT ARDU_DATE_NN NOT NULL
);

INSERT INTO
    ardudata(ano, ddata)
VALUES(
    (SELECT NVL(MAX(ano) + 1, 1001) FROM ardudata),
    150.00
)
;

SELECT
    num, name
FROM
    singertype, singer, photo
WHERE
    no = s_type
    AND num = s_num(+)
    AND a_time = '과거'
    AND s_gen = '남자'
    AND scode = 'G'
;

SELECT
    *
FROM
    singertype
;

--멤버
SELECT
    num, name, scode
FROM
    singer
WHERE
    gno = 1001
;

--멤버 사진
SELECT
    sname
FROM
    photo
WHERE
    s_num = 1002
    AND show = 'C'
;

SELECT
    ano, ddata, TO_CHAR(wdate, 'yyyy/MM/dd HH:mi:ss')
FROM
    ardudata
ORDER BY
    wdate DESC
;

CREATE TABLE arduCount(
    acno NUMBER(6)
        CONSTRAINT ADCNT_NO_PK PRIMARY KEY,
    count NUMBER DEFAULT 0
        CONSTRAINT ADCNT_CNT_NN NOT NULL,
    cdate DATE DEFAULT sysdate
        CONSTRAINT ADCNT_DATE_UK UNIQUE
        CONSTRAINT ADCNT_DATE_NN NOT NULL
);

INSERT INTO
    arduCount(acno)
VALUES(
    (SELECT NVL(MAX(acno) + 1, 100001) FROM arduCount)
);

SELECT
    cno, cate_name, cate
FROM
    category
WHERE
    cate LIKE '%#' || 100001 || '#'
;

--대 카테고리 조회
SELECT
    cno, cate_name cname
FROM
    char_cate
WHERE   
    cate = '#'
;

--진짜소 카테고리 조회
SELECT
    cno, cate_name cname, cate
FROM
    char_cate
WHERE
    cate = (
            SELECT
                cate || 100003 || '#'
            FROM
                char_cate
            WHERE
                cno = 100003
            )
;

INSERT INTO
    char_cate
VALUES(
    100001, '가전/TV', '#'
);

INSERT INTO
    char_cate
VALUES(
    100002,	'TV', '#100001#'
);

INSERT INTO
    char_cate
VALUES(
    100003,	'80인치이상', '#100001#100002#'
);

INSERT INTO
    char_cate
VALUES(
    100004,	'90인치이상', '#100001#100002#100003#'
);

INSERT INTO
    char_cate
VALUES(
    100005,	'86/88인치', '#100001#100002#100003#'
);

INSERT INTO
    char_cate
VALUES(
    100006, '85인치', '#100001#100002#100003#'
);

INSERT INTO
    char_cate
VALUES(
    100007, '82/83인치', '#100001#100002#100003#'
);
	
INSERT INTO charcate
    SELECT
        *
    FROM
        CHAR_CATE
;

CREATE TABLE charCate(
    cno NUMBER(6)
        CONSTRAINT CCATE_NO_PK PRIMARY KEY,
    cate_name VARCHAR2(30 CHAR)
        CONSTRAINT CCATE_NAME_NN NOT NULL,
    cate VARCHAR2(4000)
        CONSTRAINT CCATE_CATE_NN NOT NULL
);

CREATE TABLE category(
    cno NUMBER(6)
        CONSTRAINT CATE_NO_PK PRIMARY KEY,
    cate_name VARCHAR2(30 CHAR)
        CONSTRAINT CATEG_NAME_NN NOT NULL,
    upno NUMBER(6)
);

INSERT INTO
    category
VALUES(
    100001,	'가전/TV',	NULL
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '컴퓨터/노트북', NULL
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '패션/잡화/뷰티', NULL
);

---------------------------- 중 카테고리 -------------------------------------------
-- 가전/TV
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '프로젝터/스크린', 100001
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '홈시어터/오디오', 100001
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '에어컨/선풍기/제습기', 100001
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '생활가전', 100001
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '주방가전', 100001
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '계절가전', 100001
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '미용욕실가전', 100001
);

-- 컴퓨터/노트북
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '컴퓨터', 100008
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '노트북', 100008
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '브랜드PC/조립PC', 100008
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '모니터/사운드', 100008
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    'PC주요부품', 100008
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    'PC저장장치', 100008
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    'PC주변기기', 100008
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '복합기/프린터/SW', 100008
);

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),	
    '게임기/게이밍가구', 100008
);

--패션/잡화/뷰티

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '가방/지갑', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '시계/주얼리', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '남성신발', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '여성신발', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '잡화/벨트/소품', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '남성의류', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '여성의류', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '언더웨어', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '스킨케어', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '헤어케어', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '바디케어', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '향수/메이크업', 100009
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '남성뷰티', 100009
);


--TV

INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
    '80인치 이상', 100002
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
'70인치대', 100002
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
'60인치대', 100002
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
'50인치대', 100002
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
'40인치대', 100002
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
'39인치 이하', 100002
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
'디스플레이별', 100002
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
'중소 제조사', 100002
);
INSERT INTO
    category
VALUES(
    (SELECT NVL(MAX(cno) + 1, 100001) FROM category),
'셋톱박스/TV스탠드', 100002
);

--------------

SELECT
    cno, cate_name, upno
FROM
    category
WHERE
    upno = 100001
;

commit;

------------------------------------------------------------------------------------
INSERT INTO
    category
VALUES(
    100002,	'TV', 100001
);

INSERT INTO
    category
VALUES(
    100003,	'80인치이상', 100002
);

INSERT INTO
    category
VALUES(
    100004,	'90인치이상', 100003
);

INSERT INTO
    category
VALUES(
    100005,	'86/88인치', 100003
);

INSERT INTO
    category
VALUES(
    100006,	'85인치', 100003
);

INSERT INTO
    category
VALUES(
100007,	'82/83인치', 100003
);

commit;

CREATE TABLE product(
    pno NUMBER(6)
        CONSTRAINT PRODUCT_NO_PK PRIMARY KEY,
    pname VARCHAR2(50 CHAR)
        CONSTRAINT PRODUCT_NAME_NN NOT NULL,
    cno NUMBER(6)
        CONSTRAINT PRODUCT_CNO_FK REFERENCES category(cno)
        CONSTRAINT PRODUCT_CNO_NN NOT NULL,
    price NUMBER(8)
        CONSTRAINT PRODUCT_PRICE_NN NOT NULL,
    summary VARCHAR2(4000)
        CONSTRAINT PRODUCT_SUMMARY_NN NOT NULL,
    manuf_co VARCHAR2(50 CHAR)
        CONSTRAINT PRODUCT_MANUCO_NN NOT NULL,
    reldate DATE
        CONSTRAINT PRODUCT_RDATE_NN NOT NULL,
    pisshow CHAR(1) DEFAULT 'Y'
        CONSTRAINT PRODUCT_SHOW_CK CHECK (pisshow IN('Y', 'N'))
        CONSTRAINT PRODUCT_SHOW_NN NOT NULL   
);

--pno, pname, cno, price, summary, manu_co, reldate
INSERT INTO
    product(pno, pname, cno, price, summary, manuf_co, reldate)
VALUES(
    (SELECT NVL(MAX(pno) + 1, 100001) FROM product),
    'LG전자 울트라HD 86UQ9300KNA', 100005, 2741560, 
    'LED TV / 214cm(85인치) / LED / 4K UHD / 4K업스케일링 / 크리스털UHD / HDR10+ / HLG / 게임: ALLM / 스마트: 타이젠OS, 넷플릭스, 유튜브, 미러링, 음성인식, 구글어시스턴트 / 사운드: 돌비디지털, 인공지능, 블루투스 / 스피커: 2.0채널 / 출력: 20W / HDMI(전체): 3개 / USB: 2개 / 지원: eARC, CEC / Wi-Fi / Wi-Fi다이렉트 / LAN / 블루투스 / 옵티컬 / 컴포넌트 / 에너지효율: 1등급 / 소비전력: 310W / 베사홀: 600x400mm / 2021년형 / 크기(가로x세로x깊이): 1901x1086(1132)x27(395)mm',
    'LG전자', TO_DATE('2021/10/01', 'YYYY/MM/DD')
);

INSERT INTO
    product(pno, pname, cno, price, summary, manuf_co, reldate)
VALUES(
    (SELECT NVL(MAX(pno) + 1, 100001) FROM product),
    'Neo QLED KQ75QNB85AFXKR', 100004, 12822280, 'mini LED TV / 247cm(98인치) / 네오QLED / 4K UHD / 최대주사율 : 120Hz / 직하형 / 4K업스케일링 / 인공지능화질 / 네오퀀텀프로세서4K / HDR10+ / HLG / 게임: FreeSync , ALLM , 게임모드 / 스마트: 타이젠OS , 넷플릭스 , 유튜브 , 미러링 , 음성인식 , 구글어시스턴트 / 사운드: 돌비디지털 , 인공지능 , 블루투스 / 스피커 : 4.2.2채널 / 출력 : 60W / HDMI(전체) : 4개 / USB : 2개 / 지원: HDMI2.1 , eARC , CEC / Wi-Fi / Wi-Fi다이렉트 / LAN / 블루투스 / 옵티컬 / 소비전력 : 435W / 베사홀 : 600x400mm / 2021년형 / 크기(가로x세로x깊이): 2185x1249(1319)x31(367)mm',
    '삼성전자', TO_DATE('2021/08/01', 'YYYY/MM/DD')
);

INSERT INTO
    product(pno, pname, cno, price, summary, manuf_co, reldate)
VALUES(
    (SELECT NVL(MAX(pno) + 1, 100001) FROM product),
    '삼성전자 QLED KQ85QB70AFXKR ', 100005, 2821920, 'mini LED TV / 247cm(98인치) / 네오QLED / 4K UHD / 최대주사율 : 120Hz / 직하형 / 4K업스케일링 / 인공지능화질 / 네오퀀텀프로세서4K / HDR10+ / HLG / 게임: FreeSync , ALLM , 게임모드 / 스마트: 타이젠OS , 넷플릭스 , 유튜브 , 미러링 , 음성인식 , 구글어시스턴트 / 사운드: 돌비디지털 , 인공지능 , 블루투스 / 스피커 : 4.2.2채널 / 출력 : 60W / HDMI(전체) : 4개 / USB : 2개 / 지원: HDMI2.1 , eARC , CEC / Wi-Fi / Wi-Fi다이렉트 / LAN / 블루투스 / 옵티컬 / 소비전력 : 435W / 베사홀 : 600x400mm / 2021년형 / 크기(가로x세로x깊이): 2185x1249(1319)x31(367)mm',
    '삼성전자', TO_DATE('2021/08/01', 'YYYY/MM/DD')
);



-------------------------------------------
--아두이노
-------------------------------------------
CREATE TABLE dailyTemp(
    no NUMBER
        CONSTRAINT DTMP_NO_PK PRIMARY KEY,
    tmp NUMBER(7,2)
        CONSTRAINT DTMP_TMP_NN NOT NULL,
    hum NUMBER(3)
        CONSTRAINT DTMP_HUM_NN NOT NULL,
    mdate DATE DEFAULT sysdate
        CONSTRAINT DTMP_DATE_NN NOT NULL
);

INSERT INTO
    dailytemp(no, tmp, hum)
VALUES(
    (SELECT NVL(MAX(no) + 1, 1) FROM dailytemp),
    #{tmp}, #{num}
);

SELECT
    no, tmp, hum, TO_CHAT(mdate, 'YYYY/MM/dd HH:mi:ss');
FROM
    dailytemp
WHERE
    ROWNUM BETWEEN 1 AND 5
ORDER BY
    no DESC
;


SELECT
    cno, cate_name cname
FROM
    category
WHERE
    upno IS NULL
;

SELECT
    cno, cate_name cname, level
FROM
    category
START WITH
    upno IS NULL
CONNECT BY
    PRIOR cno = upno
ORDER BY
    level
;

SELECT
    cno, cate_name cname
FROM
    category
WHERE   
    upno = 100008
;


commit;

SELECT * FROM product;



SELECT
    pno, pname, savename sname, price, manuf_co 
FROM
    product, fileInfo
WHERE
    pno = fbno -- join 조건
    AND dir = '/www/img/product/'
    AND cno = 100004
;

commit;

CREATE TABLE MEMBER_BACK
AS
    SELECT
        m.*, sysdate backup_date
    FROM
        member m
    WHERE
        1 = 2
;

CREATE TABLE SURVEY_BACK
AS
    SELECT
        m.*, sysdate backup_date
    FROM
        survey m
    WHERE
        1 = 2
;

CREATE TABLE BOARD_BACK
AS
    SELECT
        m.*, sysdate backup_date
    FROM
        board m
    WHERE
        1 = 2
;

CREATE TABLE REBOARD_BACK
AS
    SELECT
        m.*, sysdate backup_date
    FROM
        reboard m
    WHERE
        1 = 2
;

CREATE TABLE GUESTBOARD_BACK
AS
    SELECT
        m.*, sysdate backup_date
    FROM
        guestboard m
    WHERE
        1 = 2
;

ALTER TABLE member_back
MODIFY backup_date
    CONSTRAINT MEMBER_BD_NN NOT NULL
;
ALTER TABLE survey_back
MODIFY backup_date
    CONSTRAINT SVBACK_BD_NN NOT NULL
;
ALTER TABLE board_back
MODIFY backup_date
    CONSTRAINT BRD_BD_NN NOT NULL
;
ALTER TABLE guestboard_back
MODIFY backup_date
    CONSTRAINT GBRDBACK_BD_NN NOT NULL
;
ALTER TABLE reboard_back
MODIFY backup_date
    CONSTRAINT RDRDBACK_BD_NN NOT NULL
;
COMMIT;
-- 제약조건 비활성
ALTER TABLE guestboard
ENABLE CONSTRAINT GB_WRITER_FK;

ALTER TABLE board
ENABLE CONSTRAINT BRD_MNO_FK;

ALTER TABLE survey
ENABLE CONSTRAINT SV_MNO_FK;

ALTER TABLE reboard
ENABLE CONSTRAINT RBRD_MNO_FK;

--제약조건 활성화
ALTER TABLE guestboard
DISABLE CONSTRAINT GB_WRITER_FK;

ALTER TABLE board
DISABLE CONSTRAINT BRD_MNO_FK;

ALTER TABLE survey
DISABLE CONSTRAINT SV_MNO_FK;

ALTER TABLE REboard
DISABLE CONSTRAINT RBRD_MNO_FK;

--삭제 질의명령

--member
DELETE FROM member
WHERE
    mno = #{mno}

--board
DELETE FROM board
WHERE
    bno IN (
            SELECT
                bno
            FROM
                board
            WHERE
                bmno = #{mno}
            )
;

--guestboard
DELETE FROM guestboard
WHERE
    gno IN (
            SELECT
                gno
            FROM
                guestboard
            WHERE
                writer = #{mno}        
            )
;

--reboard
DELETE FROM reboard
WHERE
    rbno IN (
            SELECT
                DISTINCT rbno
            FROM
                reboard
            WHERE
                isshow = 'Y'
            START WITH
                rbmno = #{mno}
            CONNECT BY
                PRIOR rbno = upno;
            )
;

--survey
DELETE FROM survey
WHERE
    rbno IN (
            SELECT
                DISTINCT rbno
            FROM
                reboard
            WHERE
                isshow = 'Y'
            START WITH
                rbmno = #{mno}
            CONNECT BY
                PRIOR rbno = upno;
            )
;

--제약조건 수정
ALTER TABLE survey
DROP CONSTRAINT SV_MNO_NN;

ALTER TABLE survey
DROP CONSTRAINT SV_MNO_FK;

ALTER TABLE survey
MODIFY smno CONSTRAINT
    SV_MNO_FK FOREIGN KEY REFERENCES member(mno);

update survey
set
    smno = null    
where
    smno = 1017
;

DELETE FROM member WHERE mno = 1017;

rollback;



SELECT
    DISTINCT rbno
FROM
    reboard
WHERE
    isshow = 'Y'
START WITH
    rbmno = #{mno}
CONNECT BY
    PRIOR rbno = upno;
;

ALTER TABLE fileinfo
DROP CONSTRAINT FI_BNO_FK;

-- 제약조건  변경

-- 게시판
ALTER TABLE board
DROP CONSTRAINT BRD_MNO_FK;

ALTER TABLE board
ADD CONSTRAINT BRD_MNO_FK FOREIGN KEY(bmno) REFERENCES member(mno)
ON DELETE CASCADE;

ALTER TABLE fileinfo
DROP CONSTRAINT FI_BNO_FK;

-- 방명록
ALTER TABLE guestboard
DROP CONSTRAINT GB_WRITER_FK;

-- 댓글 게시판
ALTER TABLE reboard
DROP CONSTRAINT RBRD_MNO_FK;

ALTER TABLE reboard
ADD CONSTRAINT RBRD_MNO_FK FOREIGN KEY(rbmno) REFERENCES member(mno)
ON DELETE CASCADE;

-- 설문조사
ALTER TABLE survey
DROP CONSTRAINT SV_MNO_FK;

ALTER TABLE survey
DROP CONSTRAINT SV_QNO_NN;



-- 게시글에 데이터추가
INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    (SELECT NVL(MAX(mno) + 1, 1001) FROM member),
    'test1', 'test1', '12345', 'test1@githrd.com', '010-9292-7272', 13, 'M'
);

INSERT INTO
    board(bno, bmno, title, body)
VALUES(
    (SELECT NVL(MAX(bno) + 1, 100001) FROM board),
    1027, '삭제 테스트', '회원 삭제 시 게시글 삭제 테스트'
);

INSERT INTO
    member(mno, id, pw, name, mail, tel, gen) 
VALUES(
    1, 'admin', '12345', '관리자', 'admin@githrd.com', '010-1112-1112', 'F'
);

commit;



INSERT INTO member_back(mno, name, id, pw, mail, tel, avt, gen, joindate, isshow, backup_date)
VALUES(
			SELECT
				mno, name, id, pw, mail, tel, avt, gen, joindate, isshow, sysdate
			FROM
				member
			WHERE
				id = 'test1'
);	