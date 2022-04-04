--day07

/*
    <제약조건 추가>
        
        [형식]
        
        1. 컬럼이름     데이터타입(길이)
            CONSTRAINT  제약조건이름   PRIMARY KEY
                                       REFERENCES 테이블이름(컬럼이름) --P or U만 참조 가능
                                       UNIQUE
                                       NOT NULL
                                       CHECK(컬럼이름 IN(데이터1, 데이터2))
        
        2. 컬럼이름     데이터타입(길이),
           컬럼이름     데이터타입(길이),
           ...
           CONSTRAINT   제약조건이름  PRIMARY KEY(컬럼이름),
                                      UNIQUE(컬럼이름),
                                      FOREIGHN KEY(컬럼이름) REFERENCES 테이블이름(컬럼이름),
                                      CHECK(컬럼이름 IN(데이터1, 데이터2))
                                      
            [주의]
             컬럼이 만들어진 이후에는 NOT NULL 제약조건 추가 불가      
             제약 조건을 추가하지 않고 테이블을 만들면 컬럼들은 NULL 데이터를 허용하게 된다.
             따라서 NOT NULL 제약조건은 이런 컬럼의 속성을 수정해야 한다.
        
        3. 제약조건 없이 테이블 만드는 경우 테이블 수정 명령으로 제약조건을 추가하는 방법
        
            ALTRE TABLE 테이블이름
            ADD CONSTRAINT 제약조건이름 제약조건(컬럼이름)
            ;
       
*/
CREATE TABLE TMP(
    no NUMBER(2), 
    name VARCHAR2(10 CHAR)
);

DESC TMP;

DROP TABLE TMP;

/*
    테이블 만드는 순서
    
    참조해주는 테이블부터 만든다...
*/

--아바타 테이블
CREATE TABLE avatar(
    ano NUMBER(2),
    aname VARCHAR2(15 CHAR),
    oriname VARCHAR2(50 CHAR),
    savename VARCHAR2(50 CHAR),
    dir VARCHAR2(100 CHAR),
    len NUMBER,
    adate DATE DEFAULT sysdate,
    isshow CHAR(1) DEFAULT 'Y',
    CONSTRAINT AVT_NO_PK PRIMARY KEY(ano),
    CONSTRAINT AVT_SNAME_UK UNIQUE(savename),
    CONSTRAINT AVT_SHOW_CK CHECK(isshow IN ('Y', 'N'))
);

-- NOT NULL 제약조건 수정
ALTER TABLE avatar
MODIFY aname
    CONSTRAINT AVT_NAME_NN NOT NULL
;

ALTER TABLE avatar
MODIFY oriname
    CONSTRAINT AVT_ONAME_NN NOT NULL
;

ALTER TABLE avatar
MODIFY savename
    CONSTRAINT AVT_SAME_NN NOT NULL
;

ALTER TABLE avatar
MODIFY dir
    CONSTRAINT AVT_DIR_NN NOT NULL
;

ALTER TABLE avatar
MODIFY len
    CONSTRAINT AVT_LEN_NN NOT NULL
;

ALTER TABLE avatar
MODIFY adate
    CONSTRAINT AVT_DATE_NN NOT NULL
;

ALTER TABLE avatar
MODIFY isshow
    CONSTRAINT AVT_SHOW_NN NOT NULL
;

--회원테이블 추가
CREATE TABLE MEMBER(
    mno NUMBER(4)
        CONSTRAINT MB_NO_PK PRIMARY KEY,
    name VARCHAR2(20 CHAR)
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
    avt NUMBER(2) DEFAULT 10
        CONSTRAINT MB_ANO_FK REFERENCES avatar(ano)
        CONSTRAINT MB_ANO_NN NOT NULL,
    gen CHAR(1)
        CONSTRAINT MB_GEN_CK CHECK(gen IN('F', 'M'))
        CONSTRAINT MB_GEN_NN NOT NULL,
    joindate DATE DEFAULT sysdate
        CONSTRAINT MB_DATE_NN NOT NULL,
    isshow CHAR(1)
        CONSTRAINT MB_SHOW_CK CHECK(isshow IN('Y', 'N'))
        CONSTRAINT MB_SHOW_NN NOT NULL
);

/*
    등록된 제약조건 확인하는 방법
    : 등록된 제약 조건은 오라클이 테이블을 이용해서 관리한다.
      이 테이블 이름이 USER_CONSTRAINTS 이다.
      
      따라서 이 테이블의 내용을 확인하면 등록된 제약조건을 확인할 수 있다.
      
      [참고]
        CONSTRAINT_TYPE
            
            P : PRIMARY KEY
            R : FOREIGN KEY
            U : UNIQUE
            C : NOT NULL, CHECK
            
    ----------
    
    <제약조건 삭제>
        
        [형식]
            ALTER TABLE 테이블이름
            DROP CONSTRAINT 제약조건이름;
            
        [참고]
            기본키(PRIMARY KEY)의 경우 제약조건 이름을 몰라도 삭제할 수 있다.
            기본키는 테이블에 오직 한 개만 만들어지기 때문
            
            [형식]
                ALTER TABLE 테이블이름
                DROP PRIMARY KEY;
*/

DESC USER_CONSTRAINTS;

--아바타 테이블의 제약조건 조회
SELECT
    constraint_name 제약조건이름, constraint_type 제약조건, table_name 테이블이름
FROM
    user_constraints
WHERE
    table_name IN('AVATAR', 'MEMBER')
;

--회원테이블 기본키 제약조건 삭제해보기
ALTER TABLE member
DROP PRIMARY KEY
;

--다시 기본키 추가해보기
ALTER TABLE member
ADD CONSTRAINT MB_NO_PK PRIMARY KEY(mno)
;

CREATE TABLE tmp(
    no NUMBER(4)
);

/*
    테이블 수정하기
    
        1. 필드 추가하기
            
            [형식]
                ALTER TABLE 테이블이름
                ADD (
                    필드이름    데이터타입(길이)
                       CONSTRAINT 제약조건이름 제약조건
                );
        2. 필드 이름 변경
            
            [형식]
                ALTER TABLE 테이블이름
                RENAME COLUMN 기존필드이름 TO 바뀔이름;
                
        3. 필드 길이 변경
            
            [형식]
                ALTER TABLE 테이블이름
                MODIFY 필드이름 테이터타입(길이);
                
            [참고]
                --DEFAULT 값 추가
                
                ALTRE TABLE 테이블이름
                MODIFY 필드이름 DEFAULT 데이터;
                
            [참고]
                길이 변경은 현재 길이보다 늘이는 것은 가능하나 줄이는 것은 불가능
                이미 입력되어 있는 데이터가 수정된 길이를 넘어설 수 있기 때문.
        
        4. 필드 삭제
            
            [형식]
                ALTER TABLE 테이블이름
                DROP COLUMN 필드이름;
        
    <테이블 이름 변경>
    
        [형식]
            ALTER TABLE 테이블이름
            RENAME TO 변경될테이블이름;
    
    <테이블 삭제>
        
        [참고]
            테이블 내의 모든 데이터도 같이 삭제된다.
            
        [형식]
            
            1. DROP TABLE 테이블이름;
            
            2. DROP TABLE 테이블이름 purge;
                => 오라클의 휴지통에 넣지 말고 완전 삭제하라는 뜻
                
        [참고]
            DML 명령은 복구 가능하지만
            DDL 명령은 복구가 원칙적으로 불가능하다
        
        [참고]
            10g부터 휴지통 개념을 추가해서 삭제된 데이터를 휴지통에 보관하도록 하고 있다.
        
        [휴지통 관리]
            
            1. 휴지통에 있는 모든 데이터 완전 지우기
            
                purge recyclebin;
            
            2. 휴지통에 있는 특정 테이블만 완전 삭제
                
                purge table 테이블이름;
            
            3. 휴지통 확인하기
                
                show recyclebin;
                
            4. 휴지통의 테이블 복구
                
                flashback table 테이블이름 to before drop;
*/

--tmp에 name 필드 추가
ALTER TABLE tmp
ADD(
    name VARCHAR2(10 CHAR)
        CONSTRAINT TMP_NAME_NN NOT NULL
);

--tmp 테이블의 no 필드에 기본키제약조건 추가
ALTER TABLE tmp
ADD CONSTRAINT TMP_NO_PK PRIMARY KEY(no)
;

--no를 tno로 바꾸기
ALTER TABLE tmp
RENAME COLUMN no TO tno;

--휴지통 확인
show recyclebin;

----------------------

/*
    여기까지 배운 DDL : CREATE, ALTER, DROP
    
    <TRUNCATE>
    : DML 명령 중 DELETE 명령과 같이 테이블 안의 모든 데이터 삭제하는 명령
    
        [형식]
            TRUNCATE TABLE 테이블이름;
            
        [참고]
            DELETE 명령은 DML 소속이기에 복구(Rollback) 가능
            TRUNCATE 명령은 DDL 소속이기에 복구 불가능
*/

/*
    무결성 체크
    : 이상 데이터가 입력되는 것을 방지하는 기능
    
      데이터베이스는 프로그램 등 전산에서 작업할 때 필요한 데이터를 제공해주는 보조 프로그램
      따라서 데이터베이스가 가진 데이터는 항상 완벽한 데이터여야 한다.
      그런데 데이터를 입력하는 것은 사람의 몫이기에 완벽한 데이터를 보장할 수 없다.
      
      각각의 테이블에 들어가서는 안 될 데이터나 빠지면 안 되는 데이터 등을 미리 결정해놓고
      데이터를 입력하는 사람이 잘못 입력하면 그 데이터는 아예 입력되지 못하도록 방지하는 역할을 하는 기능이다.
      
      따라서 이 기능은 반드시 필요한 기능은 아니다.
      (입력하는 사람이 제대로 입력하면 되니까)
      실수를 미연에 방지할 수 있도록 하는 기능일 뿐...
*/

/*
    +)
    <제약조건>
    
    기본키 제약조건 : 하나의 키값으로 한 행을 통째로 가져올 수 있는 제약조건
                      UNIQUE이면서 NOT NULL이어야 기본키로 사용 가능
    참조키 제약조건 : 
    
    체크 : 도메인 정해놓고 그 안에 있는 데이터만 입력되도록
    
    NOT NULL : NULL 입력 안 되도록
*/

/*
    [참고]
        테이블을 생성하는 명령으로
        서브질의의 결과를 이용해서 테이블을 만드는 방법도 있다.
        
        CREATE TABLE 테이블이름
        AS
            서브질의
        ;
        
        [참고]
            이렇게 복사하게 되면 모든 데이터와 테이블의 구조를 복사할 수 있지만
            NOT NULL 제약조건을 제외한 모든 제약조건은 복사해오지 않는다.
            
        [참고]
            이 때 복사할 테이블의 구조만 복사하고 싶은 경우
            
            CREATE TABLE 테이블이름
            AS
                SELECT * FROM 테이블이름 WHERE 1=2;
                
                ==
            
*/

-- MEMBER 테이블 복사해서 MEMB02 테이블 만들어보자
CREATE TABLE memb02
AS
    SELECT * FROM member
;

--기본키 제약조건 추가
ALTER TABLE memb02
ADD CONSTRAINT MB02_NO_PK PRIMARY KEY(mno);

--SCOTT.EMP
SELECT
    ename, job, hiredate, deptno
FROM
    emp
WHERE
    ename = 'SMITH'-- => 테이블의 한 행씩 꺼내서 조건절이 참일 때만 포함.(한 번에 꺼내는 게 아님)
;

SELECT
    ename, job, hiredate, deptno
FROM
    emp 
WHERE
    1 = 2 -- => 언제나 거짓. 따라서 모든 데이터를 포함시키지 않겠다는 뜻.
;

-- INSERT 명령에 서브질의를 사용할 수 있다.
/*
    [형식]
        INSERT INTO 테이블이름
            서브질의
        ;
*/

-- emp 테이블의 사원 중 부서번호가 10번인 사원들의 데이터만 복사하라
INSERT INTO emp2
    SELECT
        *
    FROM
        emp   
    WHERE
        deptno = 10
;

------------ DDL 명령 끝

/*
    <DCL(Data Control Language) 명령>
    
        트랜젝션 처리
        : 오라클이 처리(실행)하는 명령 단위 의미
        
          테이블 생성 시 CREATE 명령 입력하고 엔터키 누르면 그 명령을 실행한다.
          이것을 "트랜젝션이 실행되었다"라고 표현한다.
          위와 같이 대부분의 명령은 엔터키 누르는 순간 명령이 실행되고
          그것은 곡 트랜젝션이 실행된 것이므로 결국 오라클은 명령 한 줄이 곧 하나의 트랜젝션이 된다.
          
          그런데 DML 명령 만큼은 트랜젝션 단위가 달라진다.
            
            [참고]
                DML 명령 : (SELECT) INSERT, UPDATE, DELETE
                => DML 명령은 곧장 실행되는 것이 아니고 버퍼 장소(임시 기억장소)에 그 명령을 모아만 놓는다.
                   결국 트랜잭션이 실행되지 않는다는 뜻.
                   
                   따라서 DML 명령은 강제로 트랜젝션 실행 명령을 내려야 한다.
                   이 때 트랜젝션은 한 번만 일어나게 된다.
                        이유?
                        DML 명령은 데이터를 변경하는 명령
                        데이터베이스에서 가장 중요한 개념은 무결성인데
                        이런 곳에 DML 명령이 한 순간 트랜젝션 처리가 된다면
                        데이터의 무결성이 깨질 수 있다.
                        이런 문제점을 해결하기 위한 목적으로 트랜젝션 방식을 변경해 놓았다.
                        
                        
                        버퍼에 모아놓은 명령을 트랜젝션 처리하는 방법
                        
                            자동 트랜젝션 처리
                                
                                1. sqlplus를 정상적으로 종료하는 순간 트랜젝션 처리가 일어난다.
                                       = exit 명령으로 세션을 정상적으로 닫는 순간 트랜젝션 처리가 일어남
                                
                                2. DDL 명령이나 DCL 명령이 내려지는 순간
                                
                                       
                            수동 트랜젝션 처리
                                
                                3. commit 이라고 강제로 명령 내리는 순간
                                
                            [참고]
                                버퍼에 모아놓은 명령이 실행되지 않는 순간 
                                = 트랜젝션 처리가 되지 못하고 버려지는 경우
                                
                                자동
                                    1. 정전 등에 의해 시스템이 셧다운되는 순간
                                    
                                    2. sqlplus를 비정상 종료하는 순간
                                
                                수동
                                    3. rollback이라고 명령을 내리는 순간
                                    
            [결론]
                DML 명령을 내린 후 다시 검토해서 완벽한 명령이라고 판단되면
                COMMIT이라고 명령해서 트랜젝션을 발생시키고
                만약 검토과정 중 오류가 발견되면 
                ROLLBACK 명령으로 잘못된 명령을 취소하도록 한다.
                
    <책갈피 만들기>
        SAVEPOINT 적당한이름;
        
        이것을 사용해 ROLLBACK 하는 방법
            
            ROLLBACK TO SAVEPOINT이름;
        
        [예]
            SAVEPOINT a;
                DML (1)
                DML (2)
                DML (3)
            SAVEPOINT b;
                DML (4)
                DML (5)
                DML (6)
            SAVEPOINT c;
                DML (7)
                DDML (8)
                DML (9)
                
            ROLLBACK TO c;  7,8,9 취소
            ROLLBACK TO b;  4,5,6[,7,8,9] 취소
            ROLLBACK TO a;  1,2,3[,4,5,6,7,8,9] 취소
            
        [참고]
            트랜젝션이 처리되면 SAVEPOINT는 자동 파괴된다.
                

            
*/

ALTER TABLE emp2
ADD CONSTRAINT EMP2_NO_PK PRIMARY KEY(empno);

-------------------

/*
    뷰(VIEW)
    : 질의명령의 결과를 바라볼 수 있는 하나의 창문
    
    [예]
        SELECT * FROM EMP;
        => 이 질의명령을 실행하면 결과가 발생하는데 
           그 결과 중에서 일부분만 볼 수 있는 창문을 만들어 사용하는 것
        
        테이블과 유사하나 데이터베이스에 필드들이 만들어져 있지 않다는 점이 다르다.
        => 자주 사용하는 복잡한 질의명령을 따로 저장해놓고 
           이 질의명령의 결과를 손쉽게 처리할 수 있도록 하는 것
    
    [종류]
        1. 단순뷰
            : 하나의 테이블만 이용해서 만들어진 뷰
              DML 명령(INSERT, UPDATE, DELETE)이 원칙적으로 가능하다.
        
        2. 복합뷰
            : 두 개 이상의 테이블을 이용해서(조인해서) 만들어진 뷰
              DML 명령의 사용이 불가능
              
              => SELECT(조회)만 가능
    
    [참고]
        원칙적으로 사용자 계정은 관리자가 허락한 일만 할 수 있다.
        그런데 뷰를 만드는 권한은 아직 부여되어 있지 않다.
        따라서 권한을 부여하고 뷰를 만들어야 한다.

----------

    [권한 부여 방법] - 관리자 계정(SYSTEM)에서 해야함
        
        GRANT 권한이름, 권한이름, ... TO 계정이름;

----------

    [뷰 만드는 방법]
    
        1. CREATE[ OR REPLACE] VIEW 뷰이름
           AS 
                서브질의;
        
            [참고]
                뷰를 확인하는 방법
                    오라클에서는 뷰를 관리하는 테이블이 존재하고 그 테이블에서 관리한다.
                    그 테이블 이름이 USER_VIEWS 이다.
                
        
        2. CREATE [OR REPLACE] VIEW 뷰이름
           AS
                서브질의
           WITH CHECK OPTION;
           
            DML 명령으로 데이터를 변경할 때 변경된 데이터는 기본 테이블만 변경되므로
           뷰 입장에서 보면 그 데이터를 실제로 사용할 수 없을 수 있다.
            
            WHERE절 안의 내용이 수정되는지 아닌지 체크함..
        
        3. CREATE [OR REPLACE] VIEW 뷰이름
           AS
                질의명령
           WITH READ ONLY;
        
            뷰를 이용해서 데이터 변경하면 뷰를 사용하는 데이터만 변경 가능
            이것은 원본 테이블의 입장에서는 문제가 발생할 수 있다.
            뷰를 통해서 데이터를 수정하지 못하도록 하는 방지하는 형식
            
            뷰 자체 수정 불가..
            
    ---------------------------
    
    [참고]
        원래 뷰는 기본테이블이 있을 때 그것을 바라보는 창문을 만드는 개념
        (따라서 테이블 내용이 바뀌면 뷰도 바뀐다.)
        그런데 기본 테이블이 없어도 뷰를 만들 수 있다.
        
        [형식]
            CREATE OR REPLACE FORCE VIEW 뷰이름
            AS
                질의명령
            ...
            ;
            
        [참고]
            진짜로 테이블 없이 뷰가 작동되는 건 아님.
            테이블은 필요하나 이 명령을 내리는 순간만 없는 경우에 급할 때 사용하는 방법
            나중에 테이블이 만들어지면 그때 데이터를 불러오게 된다.
    
    
    
    <뷰 삭제 방법>
        
        [형식]
            DROP VIEW 뷰이름;

*/

-- 관리자 계정에서 작업
GRANT CREATE VIEW TO scott;

GRANT CREATE VIEW TO jennie;

-- 단일뷰 만들기
CREATE VIEW dnosal -- CREATE : 개발자는 쓸 일이 없음...
AS
    SELECT
        deptno dno, max(sal) max, min(sal) min, sum(sal) sum, avg(sal) avg, count(*) cnt
    FROM
        emp
    GROUP BY
        deptno
;

--사원들의 사원이름, 부서번호, 부서최대급여, 부서원수 조회
SELECT
    ename 이름, deptno 부서번호, max 부서최대급여, cnt 부서원수
FROM
    emp, dnosal
WHERE
    deptno = dno
;

-- USER_VIEWS 구조 확인
DESC USER_VIEWS;

SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'DNOSAL';

-- emp 테이블의 사원들의 사원번호, 사원이름, 부서번호, 부서이름, 부서위치 를 조회하는 뷰 EMP_DNO를 만들라

CREATE OR REPLACE VIEW emp_dno
AS 
    SELECT
        empno, ename, e.deptno, dname, loc   
    FROM
        emp e, dept d
    WHERE
        e.deptno = d.deptno
;

-- 데이터 추가
INSERT INTO
    emp_dno
VALUES(
    8000, 'JENNIE', 40, 'OPERATIONS', 'BOSTON'
); -- => 두 테이블 조인해서 만든 복합뷰라서 DML 명령 사용 불가, 에러남

--10번 부서 사원들의 사원번호, 이름, 급여, 커미션 조회하는 뷰 dno10 만들라

CREATE OR REPLACE VIEW dno10
AS
    SELECT
        empno, ename, sal, comm
    FROM
        emp   
    WHERE
        deptno = 10
;

--제니 추가
INSERT INTO
    dno10
VALUES(
    8000, 'jennie', 7000, 10000
);

ROLLBACK;

-- emp 테이블을 복사해서 employee 테이블을 만들라. 기본키 제약조건과 참조키 제약조건도 추가하라
CREATE TABLE employee
AS
    SELECT
        *
    FROM
        emp
;

-- PK 추가
ALTER TABLE employee
ADD CONSTRAINT EMPLY_NO_PK PRIMARY KEY(empno);

--FK
ALTER TABLE employee
ADD CONSTRAINT EMPLY_DNO_FK FOREIGN KEY(deptno) REFERENCES dept(deptno);

-- [문제3] employee 테이블의 10번 부서 사원들의 사원번호, 이름, 급여, 커미션, 부서번호 조회하는 뷰 dno10 만들라
--  뷰를 만드는 조건으로 사용되는 컬럼의 데이터는 수정하지 못하도록 하라

CREATE OR REPLACE VIEW dno10
AS
    SELECT
        empno, ename, sal, comm, deptno
    FROM
        employee
    WHERE
        deptno = 10
WITH CHECK OPTION
;

-- dno10 조회
SELECT * FROM dno10;

-- CLARK의 커미션을 500 인상
UPDATE
    dno10
SET
    comm = NVL(comm + 500, 500)
WHERE
    ename = 'CLARK'
;

-- KING의 부서번호 40으로 수정 => 에러남
UPDATE
    dno10
SET
    deptno = 40
WHERE
    ename = 'KING'
;

UPDATE
    employee
SET
    deptno = 40
WHERE
    ename = 'KING'
;

rollback;

--게시판 테이블(BOARD)의 글번호, 작성자번호, 글제목, 작성일, 클릭수를 조회하는 뷰 작성
CREATE OR REPLACE FORCE VIEW brdlist
AS
    SELECT
        bno, bmno, title, wdate, click
    FROM
        board   
;-- => 만들어지긴 하나 사용 불가..

--drdlist 삭제
DROP VIEW brdlist;
