/*
    문제1]
        직급이 MANAGER인 사원의
        이름, 직급, 입사일, 급여, 부서이름 조회
*/
SELECT
    ename, job, hiredate, sal, dname 
FROM
    emp, dept
WHERE
    emp.deptno = dept.deptno
    AND job = 'MANAGER'
;

/*
    문제2]
        사원이름이 5글자인 사원들의
        이름, 직급, 입사일, 급여, 급여등급 조회
*/
SELECT
    ename, job, hiredate, sal, grade
FROM
    emp, salgrade
WHERE
    sal BETWEEN losal AND hisal
    AND LENGTH(ename) = 5
;

/*
    문제3]
        입사일이 81년이고 직급이 MANAGER인 사원들의
        이름, 직급, 입사일, 급여, 급여등급, 부서이름, 부서위치 조회
*/
SELECT
    ename 이름, job 직급, hiredate 입사일, sal 급여, grade 급여등급, dname 부서이름, loc 부서위치
FROM
    emp, dept, salgrade
WHERE
    emp.deptno = dept.deptno  --조인조건1
    AND sal BETWEEN losal AND hisal -- 조인조건2
    AND TO_CHAR(hiredate, 'YY') = '81' -- 일반조건1
    AND job = 'MANAGER' -- 일반조건2  
;

/*
    문제 4 ]
        사원들의
        사원이름, 직급, 급여, 급여등급, 상사이름
        을 조회하세요.
        
        +) 상사가 없는 사원은 상사이름을 '상사없음'으로 조회하라
*/
SELECT
    e.ename 사원이름, e.job 직급, e.sal 급여, grade 급여등급, COALESCE(s.ename, '상사없음') 상사이름
    
FROM
    emp e, emp s, salgrade
WHERE
    e.sal BETWEEN losal AND hisal
    AND e.mgr = s.empno(+) -- 사원의 상사번호 = 상사의 사원번호
;

/*
    문제 5 ]
        사원들의
        사원이름, 직급, 급여, 상사이름, 부서이름, 급여등급을 조회하세요.
*/
SELECT
    e.ename 사원이름, e.job 직급, e.sal 급여, NVL(s.ename, '상사없음') 상사이름, dname 부서이름, grade 급여등급
FROM
    emp e, emp s, dept, salgrade
WHERE
    e.mgr = s.empno(+)
    AND e.deptno = dept.deptno
    AND e.sal BETWEEN losal AND hisal -- 테이블갯수 - 1 = 조인조건 갯수
;

--위 문제들을 ANSI JOIN으로 풀어라

/*
    문제 1 ]
        직급이 MANAGER 인 사원의
        사원이름, 직급, 입사일, 급여, 부서이름을 조회하세요.
        
        INNER JOIN(EQUI JOIN)
        NATURAL JOIN
*/
SELECT
    ename, job, hiredate, sal, dname
FROM
    emp INNER JOIN dept
ON
    emp.deptno = dept.deptno
WHERE
    job = 'MANAGER'
;

SELECT
    ename, job, hiredate, sal, dname
FROM
    emp
NATURAL JOIN
    dept
WHERE
    job = 'MANAGER'
;

/*
    문제 2 ]
        사원이름이 5글자인 사원들의
        사원이름, 직급, 입사일, 급여, 급여등급을 조회하세요.
        
        INNER JOIN(NON EQUI JOIN)
*/
SELECT
    ename, job, hiredate, sal, grade
FROM
    emp INNER JOIN salgrade    
ON
    sal BETWEEN losal AND hisal
WHERE
    LENGTH(ename) = 5
;

/*
    문제 3 ]
        입사일이 81년이고
        직급이 MANAGER인 사원들의
        사원이름, 직급, 입사일, 급여, 급여등급, 부서이름, 부서위치를 조회하세요.
        
    조인 2개, INNER JOIN
*/

SELECT
    ename, job, hiredate, sal, grade, dname, loc
FROM
    emp 

JOIN 
    dept
ON
    emp.deptno = dept.deptno
JOIN
    salgrade        
ON
    sal BETWEEN losal AND hisal
WHERE
    TO_CHAR(hiredate, 'YY') = '81'
    AND job = 'MANAGER'
;
--
SELECT
    ename, job, hiredate, sal, grade, dname, loc
FROM
    emp
NATURAL JOIN
    dept
JOIN
    salgrade
ON
    sal BETWEEN losal AND hisal
    
WHERE
    TO_CHAR(hiredate, 'YY') = '81'
    AND job = 'MANAGER'
;

/*
    문제 4 ]
        사원들의
        사원이름, 직급, 급여, 급여등급, 상사이름
        을 조회하세요.
        
    OUTER JOIN, 조인2개
*/
SELECT
    e.ename 사원이름, e.job 직급, e.sal 급여, grade 급여등급, NVL(s.ename, '상사없음') 상사이름
FROM
    emp e LEFT OUTER JOIN emp s
ON
    e.mgr = s.empno
JOIN
    salgrade
ON
    e.sal BETWEEN losal AND hisal
;

SELECT
    e.ename, e.job, e.sal, grade, s.ename
FROM
    emp e
LEFT OUTER JOIN
    emp s
ON
    e.mgr = s.empno
    
;

/*
    문제 5 ]
        사원들의
        사원이름, 직급, 급여, 상사이름, 부서이름, 급여등급을 조회하세요.
        
    조인 3개
*/
SELECT
    e.ename 사원이름, e.job 직급, e.sal 급여, s.ename 상사이름, dname 부서이름, grade 급여등급 
FROM
    emp e
JOIN 
    salgrade
ON
    e.sal BETWEEN losal AND hisal

LEFT OUTER JOIN
    emp s
ON
    e.mgr = s.empno

JOIN
    dept
ON
    e.deptno = dept.deptno
;