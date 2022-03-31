/* 
    <계층형 질의> (오라클에만 있음)
    
    댓글형 게시판의 경우
    목록을 꺼내올 때 상위글 바로 다음에
    그 글의 댓글이 조회되어야 한다.
    
    오라클의 경우
    계층형 결과를 볼 수 있는 문법을 만들어 제공하고 있다.
        
        [형식]
            SELECT
            
            FROM
            
            START WITH
                계층 추적 시작 값
            CONNECT BY
                계층 추적 조건
            ORDER SIBLINGS BY
                계층 간 정렬
                
                [참고]
                    PRIOR : 이전 계층 
*/

-- 사원들을 조회하는데 사장부터 계층으로 조회하라
SELECT
    LPAD(' ', (LEVEL - 1) * 3, ' ') || empno || ' - ' || ename || ' - ' || job || ' - ' || mgr || ' - ' || LEVEL 정보, hiredate-- SYSDATE 같은 의사 컬럼, START WITH절이 있을 때만 사용 가능
FROM
    emp
START WITH
    mgr IS NULL
CONNECT BY
    mgr = PRIOR empno
ORDER SIBLINGS BY
    hiredate DESC
;

------------------

/*
    CRUD : 데이터 다루는 명령들의 약자
    
    따라서 CRUD를 이야기하면 DML 명령을 사용할 수 있는지 말하는 것
    
    지금까지 배운 명령들은 모두 CRUD 중에서 R에 해당하는 SELECT 질의명령
    
    C - CREATE - INSERT 명령
    U - UPDATE - UPDATE
    D - DELETE - DELETE
    
    1. INSERT   : 이미 만들어진 테이블에 데이터 추가하는 명령
        
        [형식]
            INSERT INTO
                테이블이름[(필드이름1, 필드이름2 ...)]
            VALUES(
                필드 이름 안 쓸 경우 테이블이 가지는 모든 필드의 데이터 입력
                만약 필드 이름을 지정해놓으면 위에서 지정한 순서대로 필드에 해당하는 데이터 입력 
            );
        
        [주의사항]
            입력 시 필드의 순서에 맞게 반드시 데이터의 갯수와 순서 일치시켜서 입력
            
        [참고]
            만약 데이터가 준비되지 않아 데이터가 부족할 경우
                1. NULL로 대신 채운다. (NOT NULL 제약조건 아닌 경우)
                2. 필드 이름 지정 시 생략
        
        필드에 설정된 디폴트값으로 입력되게 하려면 필드 나열 시 생략하면 된다.
*/

-- 연습용 테이블 복사   emp 테이블 구조만 복사해서 emp1으로 만들자
CREATE TABLE emp1
AS
    SELECT
        *   
    FROM
        emp
    WHERE
        1 = 2 -- select 뽑고 where절이 참일 때만 추가, 이 경우 늘 거짓이기 때문에 데이터 없이 빈테이블 만듦
;

-- emp1에 '제니' 사원을 입력해보자
INSERT INTO
    emp1
VALUES(
    1001, '제니', '사장', null, sysdate, 300, 116, 99 
);

ALTER TABLE emp1
MODIFY hiredate DEFAULT sysdate;

ALTER TABLE emp1
ADD CONSTRAINT EMP1_NO_PK PRIMARY KEY(empno)
;

DESC emp1;

-- emp1에 '로제' 사원을 넣어보자
INSERT INTO
    emp1(empno, ename)
VALUES(
    1002, '로제'
);

-- emp1에 '리사' 사원을 넣어보자
INSERT INTO
    emp1(ename, empno)
VALUES(
    '리사', 1003 -- 순서가 중요
);

/*
    DML명령은 메모리 상에 확보한 세션 공간에서만 작업이 이루어진다.
    따라서 데이터베이스에 적용은 안 되어 있는 상태다.
    작업 내용을 데이터베이스에 적용되기를 원한다면 반드시 commit 명령을 실행해야 한다.
*/

commit;

INSERT INTO
    emp1(ename, empno)
VALUES(
    '지수', 1004 -- cmd창에서 하는 것과 결과 다름, 서로 다른 메모리 공간을 할당받아 작업하기 때문
);

INSERT INTO
    emp1(empno, ename, job, mgr, sal, comm, deptno)
VALUES(
    1005, '둘리'
);

-- 다른 테이블의 데이터를 복사해서 입력하는 방법    emp 테이블에 있는 KING 사원의 정보를 emp1 테이블에 복사하라
INSERT INTO
    emp1
(
    SELECT
        *
     FROM
        emp
     WHERE
        ename = 'KING'
     )
;
-------------

/*
    2. UPDATE : 기존 데이터의 내용을 수정하는 명령
        
        [형식]
            UPDATE
                테이블이름
            SET
                필드이름 = 데이터, 
                필드이름 = 데이터, 
                ...
            [WHERE
                조건식]
            ;
            
        [참고]
            WHERE 조건절이 없는 경우 모든 데이터가 같은 내용으로 수정된다.
*/

CREATE TABLE emp2 --DDL 명령 내려지는 순간 작업했던 내용 모두 DB에 저장
AS
    SELECT
        *
    FROM
        emp1   
;

--지수 직급 바꾸기
UPDATE
    emp2
SET
    job = '매니저'
;

rollback;


UPDATE
    emp2
SET
    job = '매니저'
WHERE
    ename = '지수'
;

commit;

/*
    서브질의를 사용해서 데이터 수정 가능 
    이 때 여러 개의 필드를 동시에 질의명령의 결과로 대체하려면
    
    [형식]
        UPDATE
        
        SET
            (필드1, 필드2) = (
                                SELECT
                                    꺼낼필드1, 꺼낼필드2
                                FROM
                                    테이블이름
                                WHERE
                                    조건식
                              )
        WHERE
            조건식
        ;
    
    [참고]
        만약 수정을 원하지 않는 데이터를 반드시 써야 한다면
        현재 데이터를 그대로 사용해도 된다.
*/

--로제의 직급과 급여를 emp 테이블의 SMITH 사원의 데이터를 복사해서 수정
UPDATE
    emp2
SET
    (job, sal) = (
                    SELECT
                        job, sal + 300
                    FROM
                        emp
                    WHERE
                        ename = 'SMITH'
                  )
WHERE
    ename = '로제'
;

commit;

UPDATE
    emp2
SET
    sal = sal,
    job = job
WHERE
    ename = '로제'
;

commit; -- UPDATE, INSERT, DELETE는 커밋 반드시 필요

-------------

/*
    <DELETE> : 현재 데이터 중 필요하지 않은 데이터 삭제
               한 행을 통째로 지운다는 의미
        
        [형식]
            DELETE
            FROM
                테이블이름
            [WHERE
                조건식]
            ;
            
        [참고]
            조건식을 제시하지 않으면 모든 데이터가 삭제된다.
        
        [참고]
            이 명령은 되도록이면 사용하지 않는 게 좋다.
            
            현업에서는 isShow CHAR(1)라는 필드를 준비해두고 기본값은 'Y'
            그리고 삭제가 필요한 경우는 'N'으로 데이터를 수정한다.
            그리고 조회 질의명령에서는 반드시 
                WHERE
                    ishow = 'Y'
                    를 추가해서 조회한다.
*/

DELETE FROM emp2;

rollback;

----------

/*
    [참고]
        데이터베이스 명령 종류
        
            1. DML - commit 후 적용
                1) C - CREATE - INSERT
                2) R - READ   - SELECT => QUERY
                3) U - UPDATE - UPDATE 
                4) D - DELETE - DELETE
                
            2. DDL(Data Definition Language) : 데이터베이스 개체에 관련된 명령
                - 바로 적용, commit 불필요
                1) CREATE : 개체 만듦
                2) ALTER : 만들어진 개체 수정
                3) DROP : 삭제
                4) TRUNCATE : 테이블의 데이터 잘라내는 명령
                
            3. DCL
            
            
            
            --- 밑에는 안 배움
            4. 관리자 모드 처리
            
            5. PL/SQL
*/

TRUNCATE TABLE emp2;

insert into emp2
values(
    null, null, null, null, null, null, null, null
);

rollback; -- dcl 명령

/*
    [참고] 
            오라클은 정규화된 데이터를 기억하도록 하는 데이터베이스의 일종(= 정형 데이터베이스)
        
            정규화데이터는 규칙이 정해진 데이터를 말하는데
            오라클은 어떤 데이터를 기억할지 미리 정해놓고 그 형식에 맞는 데이터들만 기억하도록 한다.
            
            따라서 테이블 설계 시 정규화 규칙을 정해놓고 테이블에 들어갈 데이터를 결정해야 한다.
        
        [데이터베이스 설계 과정]        
            
            1. 개념적(추상적) 설계
                => 개념적 데이터 모델 생성
            
            2. 논리적 설계
                => 개념적 설계의 결과를 물리적 저장장치에 저장할 수 있도록 특정 데이터베이스가 지원하는
                   논리적인 자료구조(데이터 타입)로 변환시키는 과정
            
                   데이터타입과 데이터들 간의 관계가 표현되는 구간
                    
                   결과물 : ER-D, 테이블 명세서 
                   
            3. 물리적 설계
                => 논리적 설계의 결과를 물리적으로 구현하는 단계
                   질의명령 작성하는 구간
                   DDL 명령 작성하는 구간
                   
                   결과물 : SQL문
        
        [정규화]
            과정
            1. 제1정규화 : 개체가 갖는 속성은 원자값(나눌 수 없는 단계까지 분해가 돼야 함)을 가져야 한다.
                
                결과물 : 제1정규형
                
            2. 제2정규화 : 기본키에 대해서 모든 키는 완전함수 종속이어야 한다. (기본키 주라는 뜻, 한 속성값으로 각 행을 구분할 수 있어야..)
                
                => 제2정규형
                
            3. 제3정규화 : 이행적(부분적) 함수 종속에서 벗어나야 한다. (deptno알면 dname과 loc 알 수 있음, 중복데이터 있으면, 이런 경우 테이블 따로 분리해라)
                
                
            ---- 밑에는 잘 안씀
            4. BCNF 정규화
            
            5. 제4정규화
            
            ...
*/

CREATE TABLE tmp1
AS
    SELECT
        e.*, dname, loc
    FROM
        emp e, dept d   
    WHERE
        e.deptno = d.deptno
;
