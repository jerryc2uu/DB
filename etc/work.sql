SELECT
    rbno, upno, rbmno, level, (level - 1) step
FROM
    reboard 
START WITH
    upno IS NULL
CONNECT BY
    PRIOR rbno = upno
ORDER SIBLINGS BY
    wdate DESC
;

/*
    upno ==> '#100001'
         ==> '#100001#100004
         
    step    ==>  시작: 1
                 댓글 달 때마다 그 글의 step에서 1 누적
*/

SELECT
    mno, savename   
FROM
    member m, avatar a
WHERE
    m.isshow = 'Y'
    AND avt = ano
    AND id = 'jennie'
;

INSERT INTO
    reboard(rbno, upno, rbmno, body)
VALUES(
    (SELECT NVL(MAX(rbno) + 1, 100001) FROM reboard), 
    ?, ?, ?    
)
;

SELECT
    rbno, body, id, savename
FROM
    reboard r, member m, avatar a
WHERE
    r.isshow = 'Y'
    AND rbno = ? -- 글번호
    AND avt = ano
    AND id = ? --로그인 한 사람 아이디
;

SELECT

FROM
    A, B, C
;

UPDATE
    reboard
SET
    isshow = 'N'
WHERE
    rbno = 100005
;

CREATE TABLE board(
    bno NUMBER(6)
        CONSTRAINT BRD_NO_PK PRIMARY KEY,
    bmno NUMBER(4)
        CONSTRAINT BRD_MNO_FK REFERENCES member(mno)
        CONSTRAINT BRD_MNO_NN NOT NULL,
    title VARCHAR2(30 CHAR)
        CONSTRAINT BRD_TITLE_NN NOT NULL,
    body VARCHAR2(4000)
        CONSTRAINT BRD_BODY_NN NOT NULL,
    wdate DATE DEFAULT sysdate
        CONSTRAINT BRD_DATE_NN NOT NULL,
    click NUMBER(4) DEFAULT 0
        CONSTRAINT BRD_CLICK_NN NOT NULL,
    isshow CHAR(1) DEFAULT 'Y'
        CONSTRAINT BRD_SHOW_CK CHECK (isshow IN('Y', 'N'))
        CONSTRAINT BRD_SHOW_NN NOT NULL
);

--ALTER TABLE board
--RENAME TO fboard;

CREATE TABLE fileinfo(
    fno NUMBER(8)
        CONSTRAINT FI_NO_PK PRIMARY KEY,
    fbno NUMBER(6)
        CONSTRAINT FI_BNO_FK REFERENCES board(bno)
        CONSTRAINT FI_BNO_NN NOT NULL,
    oriname VARCHAR2(50 CHAR)
        CONSTRAINT FI_ONAME_NN NOT NULL,
    savename VARCHAR2(50 CHAR)
        CONSTRAINT FI_SNAME_UK UNIQUE
        CONSTRAINT FI_SNAME_NN NOT NULL,
    dir VARCHAR2(200 CHAR)
        CONSTRAINT FI_DIR_NN NOT NULL,
    len NUMBER
        CONSTRAINT FI_LEN_NN NOT NULL,
    savedate DATE DEFAULT sysdate
        CONSTRAINT FI_SDATE_NN NOT NULL
    isshow CHAR(1) DEFAULT 'Y'
        CONSTRAINT FI_SHOW_CK CHECK(isshow IN('Y', 'N'))
        CONSTRAINT FI_SHOW_NN NOT NULL
);

CREATE TABLE fileinfo(
    fno NUMBER(8)
        CONSTRAINT FI_NO_PK PRIMARY KEY,
    fbno NUMBER(6)
        CONSTRAINT FI_BNO_FK REFERENCES board(bno)
        CONSTRAINT FI_BNO_NN NOT NULL,
    oriname VARCHAR2(50 CHAR)
        CONSTRAINT FI_ONAME_NN NOT NULL,
    savename VARCHAR2(50 CHAR)
        CONSTRAINT FI_SNAME_UK UNIQUE
        CONSTRAINT FI_SNAME_NN NOT NULL,
    dir VARCHAR2(200 CHAR)
        CONSTRAINT FI_DIR_NN NOT NULL,
    len NUMBER
        CONSTRAINT FI_LEN_NN NOT NULL,
    savedate DATE DEFAULT sysdate
        CONSTRAINT FI_SDATE_NN NOT NULL,
    isshow CHAR(1) DEFAULT 'Y'
        CONSTRAINT FI_SHOW_CK CHECK(isshow IN('Y', 'N'))
        CONSTRAINT FI_SHOW_NN NOT NULL
);

select * from fileinfo;

desc fileinfo;



INSERT INTO
    board(bno, bmno, title, body)
VALUES(
    (SELECT NVL(MAX(bno) + 1, 100001) FROM board),
    (SELECT mno FROM member WHERE id = ?),
    ?, ?
)
;


INSERT INTO
    fileinfo(fno, fbno, oriname, savename, dir, len)
VALUES(
    (SELECT NVL(MAX(fno) + 1, 10000001) FROM fileinfo),
    (
        SELECT 
            MAX(bno) 
        FROM 
            board
        WHERE
            bmno = (
                        SELECT
                            mno
                        FROM
                            member
                        WHERE
                            id = ?
                    )
    ), ?, ?, ?, ?
)
;

SELECT
    COUNT(*) cnt
FROM
    board
WHERE
    isshow = 'Y'
;

--첨부파일 없는 거까지 포함해 첨부파일 갯수 꺼내기
SELECT
    bno, title, NVL(cnt, 0) cnt
FROM
    board b,
    (
        SELECT
            fbno, count(*) cnt
        FROM
            fileinfo
        WHERE
            isshow = 'Y'
        group by
            fbno
    )
WHERE
    isshow = 'Y'
    AND bno = fbno(+)
    AND bno = 100004
;

--게시물 리스트 페이지에 보일 것 조회

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
                            fbno, count(*) cnt
                        FROM
                            fileinfo
                        WHERE
                            isshow = 'Y'
                        group by
                            fbno
                    )
                WHERE
                    bmno = mno
                    AND bno = fbno(+)
                    AND b.isshow = 'Y'
                    AND m.isshow = 'Y'
                ORDER BY
                    wdate DESC
            )
    )
WHERE
    rno BETWEEN ? AND ?
;

--boardDetail
/*
    글번호, 작성자 아이디, 제목, 본문, 작성일, 조회수, 파일저장이름
    
    게시판 - 글번호, 제목, 본문, 작성일, 조회수
    회원 - 아이디
    파일 - 저장이름
    
    첨부파일이 없는 경우? 아우터조인
*/

SELECT
    bno, id, title, body, wdate, click, savename, fno, oriname, dir
FROM
    board b, member m, fileinfo f
WHERE
    bmno = mno
    AND bno = fbno(+)
--    AND f.isshow = 'Y'
--    AND m.isshow = 'Y'   파일 게시판 리스트에 보인다는 건 이미 'Y'라는 뜻이니까 생략
    AND b.isshow = 'Y'
    AND bno = 100003
;

--대댓글 달 때 사용.. 이해 안 간다..
SELECT
    rbno, body, wdate, mno, id, savename
FROM
    reboard r, member m, avatar a
WHERE
    r.isshow = 'Y'
    AND rbno = 100001
    AND avt = ano
    AND id = 'dolphin'
;