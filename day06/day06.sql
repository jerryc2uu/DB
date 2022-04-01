/*
    <제약조건>
        : 데이터 입력 시 이상 있는 데이터 막는 기능의 오라클 개체
          
        [목적]
            데이터 베이스의 이상 현상 제거
        
        [종류]
            1. 기본키(PRIMARY KEY) 제약 조건
                : 속성값으로 데이터 구분 가능해야 한다.
                  필수는 아니지만 추가하는 것이 좋다. 
                  기본키는 유일키 + NOT NULL 제약 조건
                  
            2. 유일키(UNIQUE) 제약 조건
                : 속성값이 다른 데이터와 구분이 되어야 한다.
                  NULL 데이터 입력 가능
                  
            3. 참조키(외래키, FOREIGN KEY) 제약 조건
                : 참조하는 테이블의 키값을 반드시 사용해야 하는 제약 조건
                  입력되지 않은 키값은 입력하지 못하도록 막는 제약 조건
                  만약 테이블을 삭제하려고 하면 먼저 참조하고 있는 테이블을 삭제한 뒤 해당 테이블 삭제해야 함
                  
            4. NOT NULL 제약 조건
                : 속성값으로 null 데이터가 입력되지 않도록 막는 제약 조건
                
            5. CHECK 제약 조건
                : 입력되어야 할 속성값이 정해져 있는 경우(성별, 노출여부 등)
                  입력될 속성값 이외의 값이 입력되는 것을 방지하는 제약 조건
*/
DROP TABLE DEPT;
-- => emp 테이블 먼저 지워야 dept 지우기 가능

--emp 테이블에 둘리 사원을 입력하는데 입사일은 현재 시간, 부서는 50번 부서로 입력하라
INSERT INTO
    emp(empno, ename, hiredate, deptno)
VALUES(
    (
        SELECT
            NVL(MAX(empno) + 1, 1001)
        FROM
            emp
    ), 
    '둘리', sysdate, 50
);-- => deptno 참조키 위반..

/*
    논리적 설계에서 타입 결정, 개체 간 관계 설정..
    
    과제 ]
        방명록을 만들려고 한다.
        방명록은 회원가입을 하면 이 페이지로 자동 전환되도록 할 예정이다.
        방명록에는 회원아이디, 인삿말이 포함되어야 한다. (제목은 없다. 1인 1개 작성)
        
        방명록의 ER Model Diagram, ER-D, 테이블명세서, DDL 질의명령을 작성하라.
*/

/*
    오라클에서 사용할 수 있는 데이터 형태
        
        1. 문자형
            
            1) CHAR : 고정 길이형 문자형 (공간이 남아도 정해진 byte 안에 저장)
            
                [형식]
                    CHAR(최대길이)
                    : 최대 길이 2000 바이트
                   
            2) VARCHAR2 : 가변 길이형 문자형
                
                [형식]
                    VARCHAR2(최대길이)
                    : 최대 길이는 4000 바이트(4KB)
                        
            3) LONG : 가변 길이형 문자형
                
                [형식]
                    LONG
                    : 최대 길이 2gb
                        
            4) CLOB : 가변 길이형 문자형
                      VARCHAR2 넘어가는 문자 저장하기 위한 타입
                        
                [형식]
                    CLOB
                    : 최대 길이 4GB
            
            [참고]
                고정길이 문자형 : 문자의 길이를 미리 지정한 후 입력한 문자가 길이보다 짧으면 공백을 이용해서
                                  반드시 같은 길이의 문자를 만들어 입력하는 방식
                                  
                                  처리속도 빠름
                                  
                                  ex) 우편번호 등 길이가 고정된 데이터
                                  
                가변길이 문자형 : 입력한 문자의 길이에 따라서 스스로 사용하는 공간을 변경
                                  
                                  ex) 게시판 본문 등 길이 알 수 없는 데이터                    
            
        2. 숫자형
            
            1) NUMBER 
                [형식]
                    NUMBER(숫자1[, 숫자2])
                        숫자1 = 전체 자릿수(유효 자릿수)
                        숫자2 = 실수 자릿수(소수 이하 자릿수), 소수점 이하 표기 안 할거면 생략 가능
                 
                [참고]
                    숫자1보다 큰 수는 입력 불가
                    숫자2보다 소수 이하가 많으면 자동으로 반올림해서 입력한다.
        3. 날짜형
            
            1) DATE
                [형식]
                    DATE
        
        [참고]
            데이터베이스에 따라서 데이터 형태도 조금씩 다르다.
            모든 데이터베이스에 적용 가능한 ANSI 데이터 형태가 있음
                    
*/

--------

/*
    1. 테이블 만들기
    
    CREATE TABLE 테이블이름(                                     ==> (CREATE : 개체 만드는 명령)
        필드이름        데이터타입(길이),
        필드이름        데이터타입(길이),
        ...
    );
    
    테이블이 만들어져 있는지 확인하는 방법   
        
        SELECT tname From tab; (tab : 시스템이 가지는 테이블)
    
    
    2. 테이블 구조 간단하게 확인하기
        
        1) DESCRIBE 테이블이름;
        2) DESC 테이블이름;
*/

--jennie 계정 생성 (system 계정에서 실행)
CREATE USER jennie IDENTIFIED BY "12345" ACCOUNT UNLOCK;
GRANT resource, connect TO jennie;
ALTER USER jennie DEFAULT TABLESPACE USERS; --DDL 명령, 바로 적용 COMMIT 불필요

--jennie 계정에서 실행
--Memb 테이블 생성
CREATE TABLE memb(
    mno NUMBER(4), 
    name VARCHAR2(20 CHAR),
    id VARCHAR2(15 CHAR),
    pw VARCHAR2(15 CHAR),
    mail VARCHAR2(50 CHAR),
    tel VARCHAR2(13 CHAR),
    addr VARCHAR2(100 CHAR),
    gen CHAR(1),
    joindate DATE DEFAULT sysdate,
    isShow CHAR(1) DEFAULT 'Y'
);

/*
    <제약 조건 부여하는 방법>
    
    [참고]
        제약조건의 이름을 부여하는 규칙
            
            [형태]
                테이블이름_필드이름_제약조건
                
                ex) 멤버 테이블의 기본키 제약 조건 
                    MEMB_MNO_PK
            
        1. 테이블 생성 시 추가
            
          * 1) 필드 정의 시 추가
                [형식]
                    필드이름    데이터타입(길이)
                        CONSTRAINT  제약조건이름  제약조건1
                        CONSTRAINT  제약조건이름  제약조건2

                [참고]
                    참조키 제약 조건
                        [형식]
                        CONSTRAINT  제약조건이름  REFERENCES  테이블이름(필드이름)
                    
                    체크 제약 조건
                        [형식]
                        CONSTRAINT  제약조건이름  CHECK   (필드이름 IN (데이터1, 데이터2, ...))
            
            2) 필드 미리 정의, 나중에 추가
            
            3) 무명 제약 조건으로 등록하는 방법
            
        
*/

--memb 테이블 삭제
DROP TABLE memb;

CREATE TABLE memb(
    mno NUMBER(4) PRIMARY KEY, 
    name VARCHAR2(20 CHAR),
    id VARCHAR2(15 CHAR),
    pw VARCHAR2(15 CHAR),
    mail VARCHAR2(50 CHAR),
    tel VARCHAR2(13 CHAR),
    addr VARCHAR2(100 CHAR),
    gen CHAR(1),
    joindate DATE DEFAULT sysdate,
    isShow CHAR(1) DEFAULT 'Y'
);

INSERT INTO
    memb(mno, name)
VALUES(
    1001, '고길동'
);

INSERT INTO
    memb(mno, name)
VALUES(
    1001, '또치'
);

DROP TABLE memb;

--필드를 선언하면서 제약조건 추가
CREATE TABLE memb(
    mno NUMBER(4) 
        CONSTRAINT MEMB_NO_PK PRIMARY KEY, 
    name VARCHAR2(20 CHAR)
        CONSTRAINT MEMB_NAME_NN NOT NULL,
    id VARCHAR2(15 CHAR)
        CONSTRAINT MEMB_ID_UK UNIQUE
        CONSTRAINT MEMB_ID_NN NOT NULL,
    pw VARCHAR2(15 CHAR)
        CONSTRAINT MEMB_PW_NN NOT NULL,
    mail VARCHAR2(50 CHAR)
        CONSTRAINT MEMB_MAIL_UK UNIQUE
        CONSTRAINT MEMB_MAIL_NN NOT NULL,
    tel VARCHAR2(13 CHAR)
        CONSTRAINT MEMB_TEL_UK UNIQUE
        CONSTRAINT MEMB_TEL_NN NOT NULL,
    addr VARCHAR2(100 CHAR)
        CONSTRAINT MEMB_ADDR_NN NOT NULL,
    gen CHAR(1)
        CONSTRAINT MEMB_GEN_CK CHECK(gen IN('F', 'M'))
        CONSTRAINT MEMB_GEN_NN NOT NULL,
    joindate DATE DEFAULT sysdate
        CONSTRAINT MEMB_JOIN_NN NOT NULL,
    isShow CHAR(1) DEFAULT 'Y'
        CONSTRAINT MEMB_SHOW_CK CHECK(isShow IN('Y', 'N'))
        CONSTRAINT MEMB_SHOW_NN NOT NULL
);


--GESI 테이블
CREATE TABLE GESI(
    bno NUMBER(6)
        CONSTRAINT GESI_NO_PK PRIMARY KEY,
    upno NUMBER(6)
        CONSTRAINT GESI_UPNO_UK UNIQUE,
    bmno NUMBER(4)
        CONSTRAINT GESI_BMNO_FK REFERENCES MEMB(MNO) 
        CONSTRAINT GESI_BMNO_NN NOT NULL,
    title VARCHAR2(30 CHAR)
        CONSTRAINT GESI_TITLE_NN NOT NULL,
    body VARCHAR2(4000)
        CONSTRAINT GESI_BODY_NN NOT NULL,
    bdate DATE
        CONSTRAINT GESI_BDATE_NN NOT NULL,
    edate DATE,
    click NUMBER(6)
        CONSTRAINT GESI_CLICK_NN NOT NULL,
    isShow CHAR(1)
        CONSTRAINT GESI_SHOW_NN NOT NULL

);
--CHUMBU 테이블
CREATE TABLE CHUMBU(
    ino NUMBER(7)
        CONSTRAINT CHUMBU_INO_PK PRIMARY KEY,
    fno NUMBER(6)
        CONSTRAINT CHUMBU_FNO_FK REFERENCES GESI(BNO)
        CONSTRAINT CHUMBU_FNO_NN NOT NULL,
    wno VARCHAR2(50)
        CONSTRAINT CHUMBU_WNO_NN NOT NULL,
    sname VARCHAR2(50 CHAR)
        CONSTRAINT CHUMBU_SNAME_UK UNIQUE
        CONSTRAINT CHUMBU_SNAME_NN NOT NULL,
    spath VARCHAR2(200)
        CONSTRAINT CHUMBU_SPATH_NN NOT NULL,
    fsize NUMBER(12)
        CONSTRAINT CHUMBU_FSIZE_NN NOT NULL,
    down NUMBER(6)
        CONSTRAINT CHUMBU_DOWN_NN NOT NULL,
    dele CHAR(1)
        CONSTRAINT CHUMBU_DELE_NN NOT NULL
);