ALTER TABLE jemp
ADD CONSTRAINT JEMP_NO_PK PRIMARY KEY(empno);

ALTER TABLE jemp
ADD CONSTRAINT JEMP_DNO_FK FOREIGN KEY(deptno) REFERENCES dept(deptno);

--jemp 테이블의 hiredate에 dafault값 부여

ALTER TABLE jemp
MODIFY hiredate DEFAULT sysdate;

INSERT INTO
    jemp(empno, ename, job, deptno) 
VALUES(
    1002, 'LISA', 'ANALYST', 20 
);

SELECT
    empno, ename, job, hiredate, deptno
FROM
    jemp
WHERE
    hiredate = (
                    SELECT
                        MAX(hiredate)
                    FROM
                        jemp
    
                )
;

commit;

--emp 테이블의 30번 부서 사원들의 정보를 jemp 테이블에 복사
INSERT INTO jemp
SELECT
    *
FROM
    emp
WHERE
    deptno = 30
        
;
--jemp 테이블과 같은 구조 가지는 JBACKUP 테이블을 FDATE 칼럼 추가해서 생성

CREATE TABLE jbackup
AS
    SELECT
        e.*, sysdate fdate 
    FROM
        jemp e
    WHERE
        1 = 2
;

drop TABLE jbackup;

--퇴직일의 기본값 : sysdate
ALTER TABLE jbackup
MODIFY fdate DEFAULT sysdate;

--기본키 제약조건 추가
ALTER TABLE jbackup
ADD
    CONSTRAINT JBUP_NO_PK PRIMARY KEY(empno);

--backup 질의명령
INSERT INTO jbackup
SELECT
    e.*, sysdate
FROM
    jemp e
WHERE
    deptno = 30
;

--30번 부서원 삭제 질의명령
DELETE FROM
    jemp
WHERE
    deptno = 30
;

SELECT
	e.empno, e.ename, e.sal, m - e.sal 부서최대급여와의차이, m 부서최대급여, TRUNC(a, -1) 부서평균급여
FROM
	emp e,
	
	(SELECT
		deptno dno, MAX(sal) m, AVG(sal) a		
	 FROM
		emp s
	 GROUP BY
		deptno
	 )
WHERE
	deptno = dno		
;


