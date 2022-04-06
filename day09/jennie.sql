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

-- 계정 권한 => 오류남
SELECT grantee, privilege, admin_option FROM dba_sys_privs;

-- 객체(테이블에 부여된) 권한
SELECT * FROM USER_TAB_PRIVS;

--롤 권한 조회
SELECT
    *
FROM
    USER_ROLE_PRIVS
;
