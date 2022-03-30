/*
    <HAVING절>
    그룹화한 결과를 필터링 할 때 필터링 조건을 쓰는 절
    그룹함수 사용 가능 
        ex) COUNT(*)
    
    <WHERE절>
    그룹함수를 쓸 수 없다.
*/

/*
    <JOIN>
    관계형 데이터베이스(Relation DataBase Management System, RDMS)에서는 데이터의 중복을 피하기 위해(무결성 위해)
    테이블을 분리하고 이로 인해 테이블 간에 관계가 형성된다.
    분리된 테이블에서 데이터를 추출해낼 때 사용하는 문법이 "JOIN"
    
        [참고]
            오라클 역시 ER(테이블끼리의 관계로 테이블 관리하는 데이터베이스)형태의 데이터베이스
        
        [참고]
            관계형 데이터베이스에서는 여러 개의 테이블에서 동시에 검색하는 기능은 이미 가지고 있다.
            이때 여러 개의 테이블에서 데이터를 동시에 검색하면 Cartesian Product(모든 경우의 수, CROSS JOIN)가 만들어지는데 
            이 결과에는 정확하지 않은 데이터도 포함되어 있다.
            따라서 정확한 데이터만 필터링해서 꺼내와야 하는데 이 필터링하는 작업이 JOIN이라고 한다.
            
            정확하지 않고 쓸모 없는 데이터 걸러내는 작업이 JOIN..
            
        [종류]
            
            1. Inner Join : 나열된 테이블들의 결과 집합 안에서 꺼내오는 조인
                
                1) Equi Join : 동등비교 연산자로 조인하는 경우
                
                2) Non Equi Join : 동등비교 연산자 이외의 연산자로 조인하는 경우
            
            2. Outer Join : Catesian Product(결과 집합)에 포함되지 않는 데이터를 가져오는 조인 
                
                [형식]
                    테이블이름.필드이름 = 테이블이름.필드이름(+)
                    이때 (+)는 NULL로 표현되어야 할 테이블 쪽에 붙여준다.
                    
            3. Self Join : 대상 테이블이 같은 테이블을 사용하는 조인
            
        [참고]
            조인에서도 다른 일반 조건을 사용할 수 있다.
*/

-- 영문색상이름 테이블
CREATE TABLE ecolor (
    ceno NUMBER(3) -- 영문 칼라 일련번호
        CONSTRAINT ECLR_NO_PK PRIMARY KEY,
    code VARCHAR2(7)
        CONSTRAINT ECLR_CODE_UK UNIQUE
        CONSTRAINT ECLR_CODE_NN NOT NULL,
    name varchar2(20)
        CONSTRAINT ECLR_NAME_NN NOT NULL
);

--데이터 추가
INSERT INTO
    ecolor
VALUES(
    100, '#FF0000', 'red'
);
INSERT INTO
    ecolor
VALUES(
    101, '#00FF00', 'green'
);
INSERT INTO
    ecolor
VALUES(
    102, '#0000FF', 'blue'
);
INSERT INTO
    ecolor
VALUES(
    103, '#800080', 'purple'
);

--영문칼라테이블 조회
SELECT * FROM ecolor;
COMMIT; -- 메모리의 작업영역에서 작업한 내용을 데이터베이스에 적용시키는 명령

--DROP TABLE kcolor; 테이블 삭제 명령
CREATE TABLE kcolor (
    ckno NUMBER(3)
        CONSTRAINT KCLR_NO_PK PRIMARY KEY,
    code VARCHAR2(7)
        CONSTRAINT KCLR_CODE_UK UNIQUE
        CONSTRAINT KCLR_CODE_NN NOT NULL,
    name varchar2(20)
        CONSTRAINT KCLR_NAME_NN NOT NULL
);

--데이터 추가
INSERT INTO
    kcolor
VALUES(
    100, '#FF0000', '빨강'
);
INSERT INTO
    kcolor
VALUES(
    101, '#00FF00', '녹색'
);
INSERT INTO
    kcolor
VALUES(
    102, '#0000FF', '파랑'
);

COMMIT;

SELECT * FROM ecolor;
SELECT * FROM kcolor;

SELECT
    *
FROM
    ecolor, kcolor -- ==> 모든 경우의 수가 포함돼 있으니 밑에서 코드값이 같은 것만 추려내기로 한다.
;


SELECT
    *
FROM
    emp e, emp ee -- 테이블 여러 개 나열 가능, 이걸로 하나의 테이블 만든다. 모든 경우의 수 중 정확한 데이터만 골라오는 게 JOIN
;

SELECT
    e.ceno cno, e.code, e.name ename, k.name kname 
FROM
    ecolor e, kcolor k
WHERE
    e.code = k.code -- JOIN 조건
;

--Outer Join
SELECT
    e.ceno cno, e.code, e.name ename, k.name kname 
FROM
    ecolor e, kcolor k
WHERE
    e.code = k.code(+) -- NULL값으로 표현되어야 할 곳에 (+) 붙인다.
;

--Self Join     사원들의 이름, 상사번호, 상사이름, 상사급여 조회
SELECT
    e.ename 사원이름, e.mgr 상사번호, s.ename 상사이름, s.sal 상사급여
FROM
    emp e, emp s -- 여러 개의 테이블을 하나의 테이블로 만든다.
WHERE
    e.mgr = s.empno(+)
;

CREATE TABLE sansa
as
    select * from emp;
    
-- Non Equi Join    사원들의 이름, 직급, 급여, 급여등급 조회
SELECT
    ename 이름, job 직급, sal 급여, grade 급여등급    
FROM
    emp, salgrade
WHERE
    sal BETWEEN losal AND hisal -- 이퀄연산자 안 씀
;

-- Equi Join    사원들의 사원번호, 이름, 직급, 부서이름, 부서위치 조회
SELECT
    empno 사원번호, ename 이름, job 직급, dname 부서이름, loc 부서위치
FROM
    emp e, dept d
WHERE
    e.deptno = d.deptno
;

--일반조건 사용    81년 입사한 사원의 이름, 직급, 입사일, 부서이름 조회
SELECT
    ename 이름, job 직급, TO_CHAR(hiredate, 'YYYY"년 "MM"월 "DD "일 "') 입사일, dname 부서이름
FROM
    emp, dept
WHERE
    emp.deptno = dept.deptno -- 조인조건
    AND TO_CHAR(hiredate, 'YY') = '81' -- 일반조건
;

SELECT
    *
FROM
    emp, salgrade
WHERE
    ename = 'SMITH'
    AND sal BETWEEN losal AND hisal
;

--------------- <ANSI JOIN>

/*
    <ANSI Join>
    : 질의명령은 데이터베이스(DBMS)에 따라서 약간씩 그 문법이 다르다.
      
      ANSI 형식이란 미국 국립 표준 협회(ANSI)에서 만든 통일된 방식의 질의명령
      따라서 테이블만 있다면 DBMS 가리지 않고 실행 가능
    
        1. Cross Join : 오라클의 Cartesian Product를 생성하는 조인
            
            [형식]
                SELECT
                    필드이름, ...
                FROM
                    테이블1 CROSS JOIN 테이블2
                ;
                
        2. Inner Join  
            1) Equi Join
            2) Non Equi Join
            3) Self Join
            
            [형식]
            SELECT
                필드이름 ...
            FROM
                테이블1 [INNER] JOIN 테이블2
            ON
                조인조건
            [WHERE
                일반조건]
            ;
            
            [참고]
                조인조건은 ON절에 기술
                일반조건은 WHERE절에 기술
                
            [참고]
                INNER JOIN이 가장 일반적, INNER 생략 가능
        
        3. Outer Join : Cartesian Product에 없는 결과를 조회하는 조인 명령
            
            [형식]
                SELECT
                    필드이름 ...
                FROM
                    테이블1 LEFT 또는 RIGHT 또는 FULL OUTER JOIN 테이블2 
                        => 이 때 방향은 데이터가 있는 테이블 방향(null이 없는)을 기술
                           FULL은 양쪽 다 NULL 데이터 표현
                ON
                    조인조건...
                ;
            
        [참고]
            조인이 2개 이상 되는 경우
            
            [형식]
                SELECT
                
                FROM
                    테이블1 
                JOIN 
                    테이블2
                ON
                    조인조건
                JOIN 
                    테이블3
                ON 
                    조인조건2
                ;
 
*/

--1. CROSS JOIN     사원 정보와 부서정보를 크로스조인하라
SELECT
    *
FROM
    emp CROSS JOIN dept
;

--2. INNER JOIN     사원들의 사원이름, 직급, 부서번호, 부서이름 조회
SELECT
    ename 사원이름, job 직급, emp.deptno 부서번호, dname 부서이름
FROM
    emp INNER JOIN dept
ON
    emp.deptno = dept.deptno
;

-- 81년 입사한 사원들의 이름, 직급, 입사년도, 부서이름 조회
SELECT
    ename 사원이름, job 직급, TO_CHAR(hiredate, 'YY') 입사년도, dname 부서이름
FROM
    emp INNER JOIN dept
ON
    emp.deptno = dept.deptno
WHERE
    TO_CHAR(hiredate, 'YY') = '81'
;

-- NON EQUI JOIN 사원들의 사원이름, 급여, 급여등급 조회하라
SELECT
    ename 사원이름, sal 급여, grade 급여등급
FROM
    emp JOIN salgrade
ON
    sal BETWEEN losal AND hisal
;

-- SELF JOIN    사원들의 이름, 상사이름 조회
SELECT
    e.ename 사원이름, NVL(s.ename) 상사이름
FROM
    emp e JOIN emp s
ON
    e.mgr = s.empno -- (+) 쓰면 안 됨
;

--3. OUTER JOIN    사원들의 사원이름, 상사이름 조회
SELECT
    e.ename 사원이름, NVL(s.ename, '상사없음') 상사이름
FROM
    emp e LEFT OUTER JOIN emp s   -- 데이터가 있는 쪽 방향을 써준다.
ON
    e.mgr = s.empno
;

-- 사원들의 사원이름, 부서이름, 급여, 급여등급 조회
SELECT
    ename, dname, sal, grade
FROM
    emp e -- 공통적으로 조인해야 할 테이블
JOIN 
    dept d
ON
    e.deptno = d.deptno
JOIN
    salgrade
ON
    e.sal BETWEEN losal AND hisal
;

---------------

/*
    4. NATURAL JOIN : 자동 조인, 
                     조인 조건식에 사용하는 필드의 이름이 동일하고 
                     반드시 동일한 필드가 한 개일 때 사용
                     자동으로 중복되는 필드를 사용해서 조인하기 때문에 조인조건 기술 불필요
        [형식]
            SELECT
                필드이름
            FROM
                테이블1
            NATURAL JOIN
                테이블2
            ;
            
    5. USING JOIN : 조인조건식에 사용하는 필드의 이름이 동일한 경우
                    같은 이름의 필드가 여러 개일 때 사용
                    
        [형식]
            SELECT
                필드이름 ...
            FROM
                테이블1
            JOIN
                테이블2
            USING
                (조인에 사용할 필드이름)
            ;
*/

--사원들의 사원이름, 부서이름 조회
SELECT
    ename 사원이름, dname 부서이름
FROM
    emp -- 같은 이름의 필드 deptno를 뽑아내 조인한다.
NATURAL JOIN
    dept
;

CREATE TABLE tmp
AS
    SELECT
        e.*, dname
    FROM
        emp e, dept d
    WHERE
        e.deptno = d.deptno
;

--TMP 테이블과 부서정보 테이블 이용해서 사원이름, 부서위치 조회
SELECT
    ename, loc
FROM
    tmp
JOIN
    dept
USING
    (deptno)
;

alter table tmp
rename column dno to deptno;

------------

/*

*/