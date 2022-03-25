/*
    자바 주석 처리 부분
    
    sqldeveloper에서만 가능한 주석
    
    ----------------------------------------------
    
    질의명령 : 데이터베이스 관리시스템에게 해당 데이터가 어디 있는지 문의하는 것
        
        +) 질의 : 물어본다.
        
    -----------------------------------------------
    
    1. SQL(Structured Qurey Language)
        : 구조화된 쿼리(질의) 언어
          이미 구조화되어 있는 명령어(새로 생성 불가, 그래서 쉬움)를 사용해서 데이터를 조작하는 언어
          프로그램이 불가능하다는 점이 특징
          
          
          
        명령의 종류
            
            1. DML 명령 (Data Manipulation Language)
            
                : 데이터 조작 언어 (개체 안에서 데이터를 조작)
                
                데이터 추가, 수정, 삭제, 조회 등
                
                 종류
                            의미     명령
                    1) C : CREATE   INSERT
                    2) R : READ     SELECT
                    3) U : UPDATE   UPDATE
                    4) D : DELETE   DELETE
                    
                
            2. DDL 명령 (Data Definition Language)
            
                : 데이터 정의 언어
                
                db에서 개체를 만들고 수정
                
                                         
                    1) CREATE : 개체(테이블, 사용자, 함수, 인덱스.. 오라클에 등록되는 것들) 만들 때
                    2) ALTER :  개체 수정
                    3) DROP : 개체 삭제
                    4) TRUNCATE : 테이블 잘라내는 명령(데이터만 잘라서 버림)
                    
            
            3. DCL 명령 (Data Control Language)
            
                : 데이터 제어 언어
                
                - 작업 적용 (TCL 명령 : Transaction Control Language) 
                - 권한 부여
                
                1) COMMIT
                2) ROLLBACK
                
                3) GRANT
                4) REVOKE
                
----------------------------------------------
*/

-- 오라클 주석 처리 부분 (멀티라인 주석이 없다) => 어디서든지 사용할 수 있다.

select * from emp;

select 
    empno, ename, job, mgr, hiredate, sal, comm, dname, loc  -- select절

from    
    emp e, dept d -- from절
    
where 
    d.deptno = e.deptno; -- where(조건)절
    
/*
    오라클의 명령은 명령을 구분하는 문자로 ;를 사용
    
    따라서 질의명령 작성 시 ; 적지 않으면 명령이 끝나지 않은 것으로 간주
    
    하나의 명령이 종료되면 반드시 ; 붙인다.
*/

select * from emp

select * from dept;




/* 테이블 구조를 조회해보는 명령
    
    describe    테이블이름;
    desc    테이블이름;
*/

-- emp 테이블의 구조를 조회해보자

describe emp;

desc emp;

/*
    오라클의 데이터 타입
    
         숫자
            NUMBER 
            NUMBER(자릿수)
            NUMBER(유효자릿수, 소수이하자릿수)
         
         
         
         문자
           
           CHAR : 고정 문자 수 문자열데이터타입
            
                CHAR(숫자) => 바이트수만큼 문자 기억
                CHAR(숫자 CHAR) => 숫자 갯수 만큼 문자 기억
                
            VARCHAR2 :  가변 문자 수 문자열데이터타입(공간절약)
            
                VARCHAR2(숫자) => 숫자 수 만큼의 바이트 만큼 문자 기억
                VARCHAR2(숫자 CHAR) => 숫자 갯수 만큼의 문자를 기억
                
                ex) 
                    CHAR(10) 
                    
                        'A' => 이 문자 기억 시 10바이트 모두 사용
                    
                    VARCHAR2(10)
                    
                        'A' => 이 문자 기억 시 1바이트만 사용
                    
                    
         
         날짜
            
            Date
            
                형식 : Date
         
*/
-----
/*
    데이터 조회 명령
        
        SELECT
            컬럼 이름, 컬럼 이름...
        FROM
            테이블 이름, 테이블 이름....
        [WHERE
                    ]
        [GROUP BY
        
        [HAVING
                    ]]
        [ORDER BY
                    ]
        ;
*/

-- 부서정보테이블의 정보를 조회하라
SELECT
    deptno, dname, loc
FROM
    dept
;

-- 1 + 4의 결과 조회하라

SELECT 1 + 4 from emp;

select '이제리' from emp;

/*
    문자열 데이터 표현 : ''
    
    => 오라클에서는 문자와 문자열을 구분하지 않는다.

    오라클에서 테이블이름, 컬럼이름, 연산자, 명령어, 함수이름은 대소문자 구분하지 않는다.
    데이터 자체는 대소문자를 구분한다.
*/

-- 조건 검색
/*
    SELET
        컬럼이름
    FROM
        테이블이름
    WHERE
        조건(결과값이 반드시 논리값으로 나와야 한다.)
       
       비교연산자 
        = : 같다
        > : 크다
        < : 작다
        <= : 작거나 같다
        >= : 크거나 같다
        != : 다르다
        <> : 다르다
        
        -오라클에서도 동시에 두 개를 비교하는 것은 안 된다.
            ex) 
                700 < SAL < 1200  => (X)
                
        -오라클은 데이터의 형태를 매우 중요시한다.
        원칙적으로 문자는 문자끼리만, 숫자는 숫자끼리만 비교할 수 있다.
        단, 날짜는 문자처럼 비교할 수 있다.
            (날짜 데이터와 문자 데이터를 비교하는 게 아니고, 문자를 날짜로 변환한 후 비교하는 것)
            
        
        -오라클은 문자끼리도 크기 비교가 가능하다. (아스키코드값으로 비교하기 때문)
        
        -오라클은 문자와 문자열의 구분이 없다. 대소문자는 구분한다.
        
        -조건을 비교하는 방법은 오라클이 한 줄 출력할 때마다 
         그 행이 조건에 맞는지를 매번 확인한 후 조건이 맞으면 출력하는 것
         
        -조건절에 조건을 여러 개 나열하는 경우 AND 또는 OR 연산자 이용
        
            조회시간은 처음 조건이 많이 걸러내는 조건일수록 짧아진다.
*/

-- 사원 이름이 'smith'인 사원의 급여를 조회하라
SELECT
    sal -- 조회하고 싶은 컬럼
FROM
    emp -- 조회할 데이터가 있는 테이블
WHERE
    ename = 'smith' -- 데이터 자체는 대소문자 구분 필수
;

--사원 중 직급이 MANAGER이고 부서번호가 10번인 사원의 이름을 조회하라
SELECT
    ename
FROM
    emp
WHERE
    job = 'MANAGER'--많이 걸러내는 조건 적기
    AND deptno = 10   
;

--------------
/*
    1. 사원 이름이 SMITH인 사원의 이름, 직급, 입사일을 조회하라.
*/

SELECT
    ename, job, hiredate
FROM
    emp
WHERE
    ename = 'SMITH'
;
/*
    2. 직급이 MANAGER인 사원의 이름, 직급, 급여를 조회하라
*/

SELECT
    ename, job, sal
FROM
    emp
WHERE
    job = 'MANAGER'
;

/*
    3. 급여가 1500 넘는 사원들의 이름, 직급, 급여를 조회하라
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    sal > 1500
;
/*
    4. 이름이 'S' 이상의 문자로 시작하는 사원들의 이름, 직급, 급여를 조회하라
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    ename >= 'S' -- 'S' < 'Sa'
;
/*
    입사일이 '81/08' 이전인 사원들의 이름, 입사일, 급여 조회
*/
SELECT
    ename, hiredate, sal
FROM
    emp
WHERE
    hiredate < '81/08/01'
;

/*
    부서 번호가 10번 또는 30번인 사원들의 이름, 직급, 부서번호를 조회하라
*/
SELECT
    ename, job, deptno
FROM
    emp
WHERE
/*
    deptno = 10
    OR deptno = 30
*/
    
    deptno IN (10, 30)
;


/*
    NOT 연산자
        : 조건식의 결과를 부정하는 연산자
        
        형식 : WHERE
                    NOT 조건식
*/

-- 부서번호가 10번이 아닌 사원들의 이름, 직급, 부서번호 조회하라

SELECT
    ename, job, deptno
FROM
    emp
WHERE
  -- 1. NOT deptno = 10
  -- 2. deptno != 10
  -- 3.
  deptno <> 10
;

-------------
/*
    5. 급여가 1000 ~ 3000 사이인 사원들의 이름, 직급, 급여 조회
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    sal >= 1000
    AND sal <= 3000
;

/*
    6. 직급이 MANAGER이면서 급여가 1000 이상인 사원들의
        이름, 직급, 입사일, 급여 조회하라
*/
SELECT
    ename, job, hiredate, sal --컬럼
FROM
    emp -- 테이블
WHERE
    job = 'MANAGER'
    AND sal >= 1000 --조건
;

/*
    특별한 조건 연산자
    
    1. BETWEEN ~ AND : 데이터가 특정 범위 안에 있는지 확인
        
        <형식>
            컬럼이름    BETWEEN     (작은)데이터1    AND    (큰)데이터2 
            
            컬럼 내용이 데이터1과 데이터2 사이에 있는지 검사
            
        <부정형식>
            NOT BEETWEEN ~ AND 
    
    2. IN : 데이터가 주어진 데이터들 중 하나인지 검사
    
        <형식>
            필드  [NOT]   IN(데이터1, 데이터2...)
            
     
        
    
    3. LIKE : 문자열 데이터 비교 시 사용
              문자열 처리 시만 사용, 문자열의 일부를 와일드카드 처리하여 
              조건식을 제시하는 방법
        <형식>
            필드(데이터)     LIKE    '와일드카드'
            = 데이터가 지정한 문자열 형식과 동일한지 판단
            
        <와일드카드 사용법>
            _ : 한 개당 한 문자만을 와일드카드로 지정
            % : 문자 수에 관계 없이 모든 문자를 와일드카드로 지정
            
            문자를 쓰게 되면 그 위치에 문자가 와야 한다.
            
            ex) 'M%' = 'M'으로 시작하는 모든 문자열
                'M__' = 'M'으로 시작하는 세 문자로 이루어진 문자열
                '%M%' = 'M'이 포함된 모든 문자열
                '%M' = 'M'으로 끝나는 문자열
                
*/

--  [BETWEEN ~ AND 연산자] 급여가 1000 ~ 3000 사이인 사원들의 이름, 급여 조회
SELECT
    ename, sal
FROM
    emp
WHERE
    sal BETWEEN 1000 AND 3000
;

-- 부서 번호가 10, 30번인 사원들의 이름, 직급, 부서번호 조회  
SELECT
    ename, job, deptno
FROM
    emp
WHERE
    deptno IN(10, 30)
;

-- [IN 연산자] 직급이 MANAGER, SALESMAN이 아닌 사원들의 이름, 직급, 급여 조회

SELECT
    ename, job, sal
FROM
    emp
WHERE
    job NOT IN('MANAGER', 'SALESMAN')
;


-- [LIKE 연산자] 이름이 다섯글자인 사원들의 이름, 직급 조회

SELECT
    ename, job
FROM
    emp
WHERE
    ename LIKE '_____'
;

-- 입사일이 1월인 사원들의 이름, 입사일 조회

SELECT
    ename, hiredate
FROM
    emp
WHERE
    hiredate LIKE '__/01/__'
;

/*
    조회되는 컬럼에 별칭을 부여해서 조회할 수 있다.
    
    [형식]
        컬럼 이름   별칭
        
        컬럼 이름   AS  별칭
        
        ---------------------------
        
        +) 공백 포함 별칭은 큰 따옴표로 감싸줌
        
        컬럼 이름   "별칭"

        컬럼 이름   AS   "별칭"
*/

----------------------------------------------------------------------
/*
    문제 1]
        부서 번호가 10번인 사원들의 이름, 직급, 입사일, 부서번호 조회
*/
SELECT
    ename 이름, job 직급, hiredate 입사일, deptno 부서번호
FROM
    emp
WHERE
    deptno = 10
;

/*
    문제 2]
        직급이 'SALESMAN'인 사원들의 사원이름, 직급, 급여 조회
        단, 필드 이름은 제시한 이름으로 조회되게 하라
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    job = 'SALESMAN'
;
/*
    문제 3]
        급여가 1000보다 적은 사원들의 이름, 직급, 급여 조회
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    sal < 1000
;
/*
    문제 4]
        사원 이름이 'M'이전의 문자로 시작하는 사원들의
        사원이름, 직급, 급여 조회
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    ename < 'M'
;
/*
    문제 5]
        입사일이 1981년 9월 8일인 사원들의 이름, 직급, 입사일 조회 
*/
SELECT
    ename, job, hiredate
FROM
    emp
WHERE
    hiredate = '81/09/08'
;

/*
    문제 6]
        사원이름이 'M'이후 문자로 시작하는 사원 중 급여가 1000이상인 사원의
        이름, 직급, 급여 조회
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    ename > 'M'
    AND sal >= 1000
;   
/*
    문제 7]
        직급이 'MANAGER'이고 급여가 1000보다 크고 부서번호가 10번인 사원의
        이름, 직급, 급여, 부서번호 조회
*/
SELECT
    ename, job, sal, deptno
FROM
    emp
WHERE
    job = 'MANAGER'
    AND sal > 1000
    AND deptno = 10
;

/*
    문제 8]
        직급이 'MANAGER'인 사원을 제외한 사원들의 이름, 직급, 입사일 조회
        단, NOT 연산자 사용
*/
SELECT
    ename, job, hiredate
FROM    
    emp
WHERE
    job NOT IN 'MANAGER'
;    
/*
    문제 9]
        이름이 'C'로 시작하는 것보다 크거나 같고 'M'으로 시작하는 것보다 작거나 같은
        사원의 이름, 직급, 급여 조회
        단, BETWEEN 연산자 사용        
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    ename BETWEEN 'C' AND 'M'
;
/*
    문제 10]
        급여가 800, 950이 아닌 사원들의 이름, 직급, 급여 조회
        단, IN 연산자 사용
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    sal NOT IN(800, 950)
;
/*
    문제 11]
        이름이 'S'로 시작하고 다섯글자인 사원들의 이름, 직급, 급여 조회        
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    ename LIKE 'S____'
;    
/*
    문제 12]
        입사일이 3일인 사원들의 이름, 직급, 입사일 조회
*/
SELECT
    ename, job, hiredate
FROM
    emp
WHERE
    hiredate LIKE '__/__/03'
;
/*
    문제 13]
        이름이 4글자이거나 5글자인 사원들의 이름, 직급 조회
*/
SELECT
    ename, job
FROM
    emp
WHERE
    ename LIKE '____' or  ename LIKE '_____'  
;
/*
    문제 14]
        입사 년도가 81년도이거나 82년도인 사원들의 이름, 급여, 입사일 조회
*/
SELECT
    ename, sal, hiredate
FROM
    emp         
WHERE
    hiredate LIKE '81/__/__' OR hiredate LIKE '82/__/__'
; 
/*
    문제 15]
        이름이 'S'로 끝나는 사원들의 이름, 급여, 커미션을 조회
*/
SELECT
    ename, sal, comm
FROM
    emp
WHERE
   ename LIKE '%S'
;

/*
    데이터 결합 연산자
        
        [형식]
            
            데이터1 || 데이터2    
*/

SELECT 10 || 20 FROM dual;

-- 사원들 이름에 MR. 붙여서 조회하라
SELECT
    'Mr.' || ename 이름, sal || '달러' 급여, hiredate 입사일 
FROM
    emp
;

SELECT
    ename 이름, sal 원급여, sal + 1000 "보너스 적용 급여", sal * 1.5 인상급여
FROM
    emp
;