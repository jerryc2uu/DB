--아바타 정보 테이블
CREATE TABLE AVATAR(
    ano NUMBER(2)
        CONSTRAINT AVT_ANO_PK PRIMARY KEY,
    sname VARCHAR2(50 CHAR)
        CONSTRAINT AVT_SNAME_UK UNIQUE
        CONSTRAINT AVT_SNAME_NN NOT NULL,
    dir VARCHAR2(100 CHAR)
        CONSTRAINT AVT_DIR_NN NOT NULL,
    gen CHAR(1)
        CONSTRAINT AVT_GENN_CK CHECK(gen IN('F', 'M'))
        CONSTRAINT AVT_GEN_NN NOT NULL,
    isshow CHAR(1) DEFAULT 'Y'
        CONSTRAINT AVT_SHOW_CK CHECK(isshow IN('Y', 'N'))
        CONSTRAINT AVT_SHOW_NN NOT NULL
);

--회원 정보 테이블
CREATE TABLE MEMBER(
    mno NUMBER(4)
        CONSTRAINT MB_MNO_PK PRIMARY KEY,
    mname VARCHAR2(15 CHAR)
        CONSTRAINT MB_NAME_NN NOT NULL,
    id VARCHAR2(15 CHAR)
        CONSTRAINT MB_ID_UK UNIQUE
        CONSTRAINT MB_ID_NN NOT NULL,
    pw VARCHAR2(15 CHAR)
        CONSTRAINT MB_PW_NN NOT NULL,
    mail VARCHAR2(50 CHAR)
        CONSTRAINT MB_MAIL_UK UNIQUE
        CONSTRAINT MB_MAIL_NN NOT NULL,
    tel VARCHAR2(13 CHAR)
        CONSTRAINT MB_TEL_UK UNIQUE
        CONSTRAINT MB_TEL_NN NOT NULL,
    avt NUMBER(2)
        CONSTRAINT MB_AVT_FK REFERENCES AVATAR(ANO)
        CONSTRAINT MB_AVT_NN NOT NULL,
    gen CHAR(1)
        CONSTRAINT MB_GEN_CK CHECK(gen IN('F', 'M'))
        CONSTRAINT MB_GEN_NN NOT NULL,
    joindate DATE DEFAULT sysdate
        CONSTRAINT MB_DATE_NN NOT NULL,
    isshow CHAR(1) DEFAULT 'Y'
        CONSTRAINT MB_SHOW_CK CHECK(isshow IN('Y', 'N'))
        CONSTRAINT MB_SHOW_NN NOT NULL
);

--방명록 정보 테이블
CREATE TABLE GUESTBOARD(
    gno NUMBER(4)
        CONSTRAINT GB_GNO_PK PRIMARY KEY,
    writer NUMBER(4)
        CONSTRAINT GB_WRT_FK REFERENCES MEMBER(MNO)
        CONSTRAINT GB_WRT_UK UNIQUE
        CONSTRAINT GB_WRT_NN NOT NULL,
    body VARCHAR2(4000)
        CONSTRAINT GB_BODY_NN NOT NULL,
    wdate DATE DEFAULT sysdate
        CONSTRAINT GB_DATE_NN NOT NULL,
    isshow CHAR(1) DEFAULT 'Y'
        CONSTRAINT GB_SHOW_CK CHECK(isshow IN('Y', 'N'))
        CONSTRAINT GB_SHOW_NN NOT NULL
);