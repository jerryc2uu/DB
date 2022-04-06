--day09

--system 계정으로 접속해서 작성하고 실행
begin dbms_xdb.sethttpport('9090');
end;
/

/*
    사용자 관리 : 관리자 계정에서 권한 설정하는 방법
    
    계정이란?
        은행의 통장과 같다.
        하나의 통장은 한 사람이 사용할 수 있듯이
        계정은 한 사람이 사용할 수 있는 가장 작은 단위의 데이터베이스이다.
        
        1. 사용자 만들기(계정 생성)
            
            1) 관리자모드로 접속
                
                sqlplus / as sysdba => 계정 없이 바로 db에 접근
                                       이 명령이 오류 없이 실행되면 관리자 계정으로 오라클에 접속한 상태
            
            
            2) 사용자 만들기
                
                [형식]
                    CREATE USER 계정이름 IDENTIFIED BY 비밀번호  [ACCOUNT UNLOCK];
                    
                    => ACCOUNT UNLOCK : 계정의 잠금 상태를 해제하는 옵션
                    
                        (개체 만드는 건 무조건 CREATE)
                
                [예]
                    CREATE USER test01 IDENTIFIED BY 12345 ACCOUNT UNLOCK;
                    
                    => test01 계정을 비밀번호 12345로 만들고, 계정 만듦과 동시에 활성화 시킨다.
                
        [참고] 현재 접속 계정이 어떤 계정인지 알아보는 명령
            
            SHOW USER;
        
        [참고] 계정을 만들게 되면 만든 그 계정은 아무런 권한도 받지 못했기 때문에
               어떤 작업도 할 수 없는 상태로 만들어진다.
        
        2. 권한 주기
        
            [참고] DML => 메모리상에서만 작업, COMMIT 필수..
                DCL 명령의 종류
                    
                    1) 트랜젝션 처리 명령
                        
                        commit
                        follback
                        savepoint
                        
                    2) 권한 관련 명령
                        
                        GRANT : 권한 부여
                        REVOKE : 권한 회수
                        
                    
            [형식] 
                1) GRANT   권한이름1, 권한이름2, ...    TO  계정이름; 
                
                2) 기타 권한은 위에서 지정한 형식에 의해 필요한 권한을 부여하면 된다.
                
                    [예] 테이블을 만들 수 있는 권한을 test01에게 부여하자
                        
                        GRANT UNLIMITED TABLESPAE, CREATE TABLE TO test01;
                        
            [참고]
                SESSION이란?
                    오라클로의 접속을 의미
                    오라클에 접속하면 오라클이 제공하는 권리를 말하며 오라클의 가격에 따라서 제공되는 갯수가 달라진다.
            
                    
                    
                
                
                SQLPLUS, SQLDEVELOPER => 명령 전달 프로그램          
                    
*/
-- [문제1] test02 계정을 67890이라는 비번으로 만들라
                    
CREATE USER test02 IDENTIFIED BY 67890 ACCOUNT UNLOCK;

--test02 계정에 테이블을 만들 수 있는 권한, 접속할 수 있는 권한을 부여하라
GRANT UNLIMITED TABLESPACE, CREATE TABLE, CREATE SESSION TO test02;


--========================

/*
    [참고]
        권한을 부여할 때 사용되는 옵션
        
            WITH ADMIN OPTION
            => 관리자 권한을 위임받을 수 있도록 하는 옵션
               부여하는 권한에 한해서만 관리자 권한을 부여..
*/

-- test02 계정에게 뷰를 만들 수 있는 권한을 관리자 권한까지 포함해서 부여하라
GRANT CREATE VIEW TO test02 WITH ADMIN OPTION; -- => 뷰에 한해서 관리자 권한을 같이 준다.

--=======================

/*
        3. 다른 계정의 테이블 사용하기
            => 원칙적으로는 하나의 계정은 그 계정 내의 테이블만 사용할 수 있다.
               
               하지만 여러 계정들이 다른 계정의 테이블을 공동으로 사용할 수도 있다.
               이렇게 하려면 그에 따른 권한을 설정해줘야 한다.
               
               다른 계정 테이블을 조회할 수 있는 권한을 부여하는 방법
               
               GRANT SELECT ON 계정.테이블이름 TO 권한받을계정이름;
*/

-- SCOTT 계정의 emp 테이블을 조회할 수 있는 권한을 test02 계정에게 부여하라
GRANT SELECT ON scott.emp TO test02 WITH GRANT OPTION;

-- test02 계정에게 모든 계정의 테이블을 조회할 수 있는 권한을 부여하라
GRANT SELECT ANY TABLE TO test02; -- => 실제로 사용하는 일은 거의 없음.. 위험해요

--------------------------

/*
        4. 관리자에게 부여받은 권한을 다른 계정에게 전파하기
        
            GRANT 권한이름 TO 계정
            WITH GRANT OPTION;
*/

CREATE USER test03 IDENTIFIED BY 12345 ACCOUNT UNLOCK;

GRANT CREATE SESSION, UNLIMITED TABLESPACE TO test03;

-----------------

/*
        5. 사용자 권한 수정
            
            GRANT 명령을 사용해서 해당 계정에게 권한을 부여한다.
        
        6. 권한 회수
        
            REVOKE 권한이름 FROM 계정이름;
        
        7. 계정 삭제
            
            DROP USER 계정이름 CASCADE;
            
*/

-- test01, test02, test03 계정을 삭제하라

DROP USER test01 CASCADE;
DROP USER test02 CASCADE;
DROP USER test03 CASCADE;

-------------------------

/*
    롤(ROLE)을 이용한 권한 부여
    => 권한 부여는 관리자가 각각의 계정에게 필요한 권한을 하나씩 지정해서 주는 방식으로 처리.
       
       롤(ROLE)이란?
            권한들의 묶음
            
            관련된 권한을 묶어놓은 객체(권한들의 셋트)를 의미
            
            따라서 롤을 사용한 권한 부여는 여러 개의 권한을 동시에 부여하는 방법이다.
            
            [방법]
                1. 이미 만들어진 롤을 이용
                    
                    * 1) CONNECT
                        => 주로 CREATE와 관련된 권한을 묶어 놓은 롤
                    
                    * 2) RESOURCE
                        => 사용자 객체 생성에 관련된 권한을 묶어 놓은 롤
                            (뷰는 별도임)
                        
                    3) DBA
                        => 관리자 계정에서 처리할 수 있는 관리자 권한을 묶어 놓은 롤
                    
                    [권한 주는 방법]
                        
                        GRANT 롤이름 TO 계정이름;
                        
                2. 직접 롤을 만들어서 권한 부여
                
                    => 롤 안에 그 롤에 필요한 권한을 사용자가 지정해서 만든 후 부여하는 방법
                    
                    * [권한 만드는 명령]
                        1) 롤을 만든다.
                            CREATE ROLE 롤이름;
                        2) 롤에 권한을 부여한다.
                            GRANT 권한이름, 권한이름, ... TO 롤이름;
                        3) 만들어진 롤을 계정에게 부여한다.
                            GRANT 롤이름 TO 계정이름;
                            
        
        <부여된 롤을 회수하는 방법>
        => 롤을 이용해 부여된 권한을 회수하는 방법
        
            [형식]
                REVOKE 롤이름 FROM 계정이름;
        
        <롤 삭제하는 방법>
        
            [형식]
                DROP ROLE 롤이름;
                     
*/

-- 1. test01/12345 계정을 만들어라 
CREATE USER test01 IDENTIFIED BY 12345 ACCOUNT UNLOCK;
ALTER USER DEFAULT TABLESPACE USERS;
--ALTER USER test01 IDENTIFIED BY 12345 ACCOUNT UNLOCK;

-- 2. 테이블스페이스 관련된 권한과 세션을 만들 수 있는 권한, connect, resource 의 권한을 가지는 USERROLE01을 만들고
--    이 롤을 이용해서 test01에게 권한을 부여하라

--1) 롤 만들고
CREATE ROLE userrole01;
--2) 롤에 권한 부여
GRANT 
    UNLIMITED TABLESPACE, 
    CREATE SESSION, 
    CONNECT, RESOURCE 
TO 
    userrole01;
--3) 계정에게 롤로 권한 부여
GRANT userrole01 TO test01;

--+) CREATE : 뷰, 시퀀스, 테이블 만들 때..

--------------------

--jennie 계정 접속해서 작업
CREATE VIEW MEMBview
AS
    SELECT
        mno, name, id
    FROM
        member   
;

INSERT INTO
    member(mno, name, id, pw, mail, tel, gen, avt)
VALUES(
    MEMBSEQ.nextval, 'yuna', 'yuna', '12345', 'yuna@githrd.com', '010-6464-6464', 'F', '14'  
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, gen, avt)
VALUES(
    MEMBSEQ.nextval, 'seora', 'seora', '12345', 'seora@githrd.com', '010-3434-3434', 'F', '15'  
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, gen, avt)
VALUES(
    MEMBSEQ.nextval, '백서진', 'sjin', '12345', 'sjin@githrd.com', '010-3737-3737', 'F', '16'  
);

UPDATE
    member
SET
    name = '정유나'
WHERE
    name = 'yuna'
;

UPDATE
    member
SET
    name = '한서라'
WHERE
    name = 'seora'
;

commit;

CREATE OR REPLACE VIEW buddy
AS
    SELECT
        mno, name, id, gen
    FROM
        member    
;    

SELECT
    *
FROM
    buddy
;

SELECT
    *
FROM
    scott.emp
;

CREATE SYNONYM jemp
FOR scott.emp;

SELECT
    *
FROM   
    jemp
;

CREATE PUBLIC SYNONYM pemp
FOR scott.emp;

CREATE OR REPLACE VIEW TVIEW -- => 서브질의는 안 되고 뷰로는 가능..
AS
    SELECT
            mno, name, id
    FROM
            member
;

CREATE PUBLIC SYNONYM tmp
FOR tview
;
----------------------------------

/*
    <동의어(SYNONYM)>
    : 테이블 자체에 별칭을 부여해서 여러 사용자가 여러 이름으로 하나의 테이블을 사용하도록 하는 것
      즉, 실제 객체(테이블, 뷰, 시퀀스, 프로시저)의 이름은 감추고 사용자 별로 별칭을 부여해서 객체를 보호하는 방법
      
      포털사이트에서 이름 대신 아이디를 사용하는 것과 마찬가지로 정보 보호를 목적으로 실제 이름을 감추기 위한 것
      
      뷰 : 원래 테이블 구조를 감추기 위해 사용하기도 함..  
    
        다른 계정을 사용하는 사용자가 테이블 이름을 알면 곤란하기 때문에
        이들에게는 거짓 테이블 이름을 알려주면서 실제 테이블 이름은 감출 때 사용    
        
        [형식]
            
            CREATE [PUBLIC] SYNONYM 동의어이름
            FOR 실제이름;
            
            [참고]
                PUBLIC이 생략되면 이 동의어는 같은 계정에서만 사용할 수 있다.
                (권한을 주면 다른 계정에서도 사용 가능)
                PUBLIC도 쓰면 자동적으로 다른 계정에서도 이 동의어를 이용해 테이블을 사용할 수 있다.
            
            [참고]
                PUBLIC 동의어를 사용하기 위해서는 해당 객체(SYNONYM)가 PUBLIC 사용 권한을 부여 받아야 한다.
        
        [PUBLIC 동의어 정리]
            PUBLIC SYNONYM
            => 모든 계정에서 특정 객체(테이블, 뷰, 시퀀스, ...)를 사용할 수 있도록 하는 것
                
               1. 동의어 만들 계정에서 PUBLIC SYNONYM을 만들고
               
               2. 관리자 계정에서 공개할 동의어에 PUBLIC 사용 권한을 부여
               
               3. 다른 계정에서 사용
               
*/

-- 동의어
-- jennie 계정에게 scott이 가지고 있는 emp 테이블을 조회할 수 있는 권한을 부여
GRANT SELECT ON scott.emp TO jennie;

GRANT CREATE SYNONYM, CREATE PUBLIC SYNONYM TO jennie;

GRANT SELECT ON pemp TO PUBLIC; -- => jennie가 만든 공개 동의어를 다른 곳에서도 사용할 수 있도록 공개..

----------------

GRANT SELECT ON tmp TO PUBLIC;


--롤 이외의 권한 조회
SELECT grantee, privilege, admin_option FROM dba_sys_privs WHERE grantee = 'JENNIE';

SELECT grantee, OWNER, TABLE_NAME, privilege, GRANTOR FROM USER_TAB_PRIVS;
