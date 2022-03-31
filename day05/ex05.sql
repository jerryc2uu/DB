/*
    문제1]
        이름이 SMITH인 사원과 동일한 직급을 가진 사원의 정보 출력
        
*/
SELECT
    *
FROM
    emp
WHERE
    job = (SELECT
        job    
     FROM
        emp
     WHERE
        ename = 'SMITH'
    )
;

/*
    문제2]
        회사 평균 급여보다 급여 적게 받는 사원들의 이름, 직급, 급여, 회사평균급여 조회
*/
SELECT
    ename 이름, job 직급, sal 급여,
    (SELECT
        (SUM(sal) / COUNT(*)) avg   
     FROM
        emp
        ) 회사평균급여
FROM 
    emp
WHERE
    sal < (SELECT
                (SUM(sal) / COUNT(*)) avg   
            FROM
                emp
            )
;

/*
    문제3]
        사원들 중 급여가 제일 높은 사원의 이름, 직급, 급여, [최고급여] 조회 
*/
SELECT
    ename 이름, job 직급, sal 급여, 
    (SELECT
        MAX(sal)
     FROM
        emp
        ) 최고급여
FROM
    emp
WHERE
    sal = (SELECT
                MAX(sal)
            FROM
                emp
            )
;

/*
    문제 4 ]
        KING 사원보다 이후에 입사한 사원들의
        사원이름, 직급, 입사일[, KING사원입사일]
        을 조회하세요.
*/
SELECT
    ename 이름, job 직급, hiredate 입사일,
    (SELECT
        hiredate
     FROM
        emp
     WHERE
        ename = 'KING'
        ) 킹의입사일
FROM
    emp
WHERE
    hiredate > (SELECT
                    hiredate
                FROM
                    emp
                WHERE
                    ename = 'KING'
                )
;

/*
    문제 5 ]
        각 사원의 급여와 회사평균급여의 차를 출력하세요.
        조회형식은
            사원이름, 급여, 급여의 차, 회사평균급여
        로 조회하세요.
*/
SELECT
    ename, sal, 
    sal - (SELECT
        ROUND(SUM(sal) / COUNT(*))
     FROM
        emp
     ) 급여차, 
    (SELECT
        ROUND(SUM(sal) / COUNT(*))
     FROM
        emp
     ) 회사평균급여
FROM
    emp
;

/*
    문제 6 ]
        부서별 급여의 합이 제일 높은 부서 사원들의
        사원이름, 직급, 부서번호, 부서이름, 부서급여합계, 부서원수
        를 조회하세요.
        
*/
SELECT
    ename 이름, job 직급, dno 부서번호, dname 부서이름, sum 부서급여합계, cnt 부서원수
FROM
    emp e,
    dept d,
    (SELECT
        deptno dno, SUM(sal) sum, COUNT(*) cnt
     FROM
        emp
     GROUP BY
        deptno
     ) -- FROM절 안의 테이블 수 - 1 = 조인조건 수(테이블 수 만큼 쓸모없는 데이터가 만들어지니까)
WHERE
    e.deptno = dno -- 조인조건1
    AND e.deptno = d.deptno -- 조인조건2
    AND e.deptno = (
                        SELECT
                            deptno
                        FROM
                            emp
                        GROUP BY
                            deptno
                        HAVING
                            SUM(sal) = ( -- >= ALL
                                        SELECT
                                            MAX(SUM(sal))
                                        FROM
                                            emp
                                        GROUP BY
                                            deptno
                                        ))
;
/*
    문제 7 ]
        커미션을 받는 사원이 한명이라도 있는 부서의 사원들의
        사원이름, 직급, 부서번호, 커미션
        을 조회하세요.
*/
SELECT
    ename, job, deptno, comm
FROM
    emp
WHERE
    deptno = (SELECT
                    deptno
              FROM
                    emp
              GROUP BY
                    deptno
              HAVING
                    SUM(comm) IS NOT NULL
              )
;

/*
    문제 8 ]
        회사 평균급여보다 높고 
        이름이 4, 5글자인 사원들의
        사원이름, 급여, 이름글자길이[, 회사평균급여]
        를 조회하세요.
*/
SELECT
    ename 이름, sal 급여, LENGTH(ename) 이름글자길이,
    (SELECT
        SUM(sal) / COUNT(*)
     FROM
        emp
    ) 회사평균급여
FROM
    emp
WHERE
    LENGTH(ename) BETWEEN 4 AND 5
    AND sal > (SELECT
                    SUM(sal) / COUNT(*)
               FROM
                    emp
               )
;

/*
    문제 9 ]
        사원이름의 글자수가 4글자인 사원과 같은 직급을 가진 사워들의
        사원이름, 직급, 급여
        를 조회하세요.
*/
SELECT
    ename 이름, job 직급, sal 급여
FROM
    emp
WHERE
    job IN (SELECT
                job
           FROM
                emp
           WHERE
                LENGTH(ename) = 4)
;

/*
    문제 10]
        입사년도가 81년이 아닌 사원과 같은 부서에 있는 사원들의
        이름, 직급, 급여, 입사일, 부서번호 조회
*/
SELECT
    ename, job, sal, hiredate, deptno
FROM
    emp
WHERE
    deptno IN (SELECT
                deptno      
              FROM
                emp
              WHERE
                NOT TO_CHAR(hiredate, 'YY') = '81' 
            
                )    
;

/*
    문제11]
        직급별 평균급여보다 한 직급이라도 급여가 많이 받는 사원의
        이름, 직급, 급여, 입사일 조회
*/
SELECT
    ename, job, sal, hiredate
FROM
    emp
WHERE
    sal > ANY (SELECT
                AVG(sal) 
           FROM
                emp
           GROUP BY
                job
           )
;
/*
    문제12]
        모든 년도별 입사자의 평균 급여보다 많이 받는 사원의 이름, 급여, 입사년도
*/
SELECT
    ename 이름, sal 급여, TO_CHAR(hiredate, 'YY') 입사년도
FROM    
    emp
WHERE
    sal > ALL (SELECT
                    AVG(sal)
               FROM
                    emp
               GROUP BY
                    TO_CHAR(hiredate, 'YY')
               )
;

/*
    문제 13 ]
        최고급여자의 이름 글자수와 같은 글자수의 직원이 존재하면
        모든 사원의 사원이름, 이름글자수, 직급, 급여 를 조회하고
        존재하지 않으면 출력하지마세요.
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    EXISTS
    
    (SELECT
    LENGTH(ename) = (SELECT
                        LENGTH(ename) 
                                       
                     FROM
                        emp 
                     WHERE
                        sal = (SELECT
                                    MAX(sal)
                                FROM
                                    emp)
                        )
                        
;