--test02 계정으로 접속해서 작업

CREATE OR REPLACE VIEW showno
AS
    SELECT
        no
    FROM
        test01
;


GRANT CREATE VIEW TO test01;

GRANT SELECT ANY TABLE TO test01; -- => 모든 테이블 조회 권한. 에러남..

--권한 회수
REVOKE CREATE VIEW FROM test01;

SELECT
    *
FROM
    scott.emp  -- => 자신이 가지고 있는 테이블 쓸 때는 계정 생략 가능
WHERE
    deptno = 10
;

SELECT
    *
FROM
    jennie.member
;

-- test01에게 권한을 줄 수 있는 권한까지 포함해서 scott.emp를 조회할 수 있는 권한을 부여하라
GRANT SELECT ON scott.emp TO test01 WITH GRANT OPTION;

