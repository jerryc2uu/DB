CREATE TABLE member(
    mno NUMBER(4)
        CONSTRAINT MEMB_NO_PK PRIMARY KEY,
    id VARCHAR2(10 CHAR)
        CONSTRAINT MEMB_ID_UK UNIQUE
        CONSTRAINT MEMB_ID_NN NOT NULL,
    pw VARCHAR2(20 CHAR)
        CONSTRAINT MEMB_PW_NN NOT NULL,
    name VARCHAR2(5 CHAR)
        CONSTRAINT MEMB_NAME_NN NOT NULL,
    mail VARCHAR2(30 CHAR)
        CONSTRAINT MEMB_MAIL_UK UNIQUE
        CONSTRAINT MEMB_MAIL_NN NOT NULL,
    tel VARCHAR2(11 CHAR)
        CONSTRAINT MEMB_TEL_UK UNIQUE
        CONSTRAINT MEMB_TEL_NN NOT NULL,
    jdate DATE DEFAULT sysdate
        CONSTRAINT MEMB_DATE_NN NOT NULL,
    isshow CHAR(1) DEFAULT 'R'
        CONSTRAINT MEMB_SHOW_CK CHECK (isshow IN('Y', 'A', 'R', 'N'))
        CONSTRAINT MEMB_SHOW_NN NOT NULL
);

INSERT INTO
    member(mno, id, pw, name, mail, tel, isshow)
VALUES(
    1001, 'jerry', '12345',
    '이제리', 'jerry@naver.com', '01012345678', 'Y'
);

SELECT
    COUNT(*) cnt
FROM
    member
WHERE
    id = 'jerry'
    AND pw = '12345'
    AND isshow = 'Y'
;