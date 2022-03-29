/*
    <문자 함수 이어서>
    
    9) REPLACE() : 문자열이 특정 부분을 다른 문자열로 대체해서 반환해주는 함수
        
        [형식]
            REPLACE(데이터, 찾을 문자, 대치 문자)
            
    10) TRIM() : 문자열 중에서 앞 또는 뒤에 있는 지정한 문자를 삭제해서 반환해주는 함수(아이디 앞뒤로 공백 있을 때 삭제하는 용도 사용)
        
        [형식]
            TRIM([삭제할 문자 FROM] 데이터)
            
            [참고]
                중간에 있는 문자는 삭제하지 못한다.(밑에 예제 참고)
                
                같은 문자가 앞, 뒤에 연속되어 있으면 모두 지운다.
                
                가끔 데이터 앞 또는 뒤에 공백 문자가 들어간 경우가 있다. 
                이런 경우를 대비해 앞 뒤에 들어간 공백문자를 제거할 목적으로 사용
         
         10-1) LTRIM() : 왼쪽 문자만 지운다.
               RTRIM() : 오른쪽 문자만 지운다.
               
               [형식]
                    LTRIM(데이터, 삭제문자)
                    
    11) CHR() : ASCII 코드 알려주면 그 코드에 해당하는 문자 알려주는 함수
        
        [형식]
            CHR(숫자)
    
    12) ASCII() : 문자열에 해당하는 ASCII 코드값 알려주는 함수
    
        [형식]
            ASCII(데이터)
            
        [참고]
            두 글자 이상으로 된 문자열의 경우 첫문자의 코드값을 반환해준다.
            
    13) TRANSLATE() : REPLACE()와 마찬가지로 문자열 중 지정한 부분을 다른 문자열로 바꿔서 반환해주는 함수
                      단, REPLACE()는 바꿀 문자열 전체를 바꾸는데 이 함수는 문자 단위로 처리한다는 점이 다르다.  
        
        [형식]
            TRANSLATE(데이터, 바꿀문자열, 바뀔문자열)
    
        
*/

-- REPLACE() 예제
SELECT
    REPLACE('hong gil don', 'n', 'nn') 홍길동 --자바와 달리 모든 문자를 바꿔준다.
FROM
    dual
;

SELECT
    REPLACE('     hong gil don    ', ' ', '') 홍길동 -- 가운데 공백까지 없애준다.
FROM
    dual
;

--TRIM() 예제
SELECT
    TRIM('     hong gil don    ') 홍길동 -- 가운데 있는 공백은 제거해주지 않는다. 위처럼 REPLACE 사용해야..
FROM
    dual
;

SELECT
    TRIM(' ' FROM '     hong gil don    ') 홍길동 -- 가운데 있는 공백은 제거해주지 않는다. 위처럼 REPLACE 사용해야..
FROM
    dual
;

SELECT
    TRIM('o' FROM 'ooooooooooooooooooooracleooooooooooooooooooo') -- 양쪽 다 지운다.
FROM
    dual
;

--LTRIM() : 왼쪽만 지운다
SELECT
    LTRIM('ooooooooooooooooooooracleooooooooooooooooooo', 'o')
FROM
    dual
;

--RTRIM() : 오른쪽만 지운다
SELECT
    RTRIM('ooooooooooooooooooooracleooooooooooooooooooo', 'o')
FROM
    dual
;

--ASCII(), CHR()
SELECT
    ASCII('HONG') H의코드값,
    CHR(ASCII('HONG')) 알파벳
FROM
    dual
;

--TRANSLATE()
SELECT
    TRANSLATE('ADBC', 'ABCD', '1234') --REPLACE()로는 처리불가(문자열 단위기 때문)
    /*
        A -> 1, B -> 2, C -> 3, D -> 4 변환
    */
FROM
    dual
;

-----------------


/*
    <날짜 데이터>
    
    1) SYSDATE : 현재 시스템의 날짜와 시간을 알려주는 예약어 (연산자나 함수가 아님, 오라클의 기본 컬럼 취급, 
                 dual은 의사 테이블 이건 의사 컬럼..)
        [참고]
            날짜 - 날짜 연산식 가능, 날짜 연번끼리 - 연산을 하게 된다. (문자열 - 문자열 연산식은 불가능, || 사용해야..)
            
            날짜 데이터의 기준점은 1970년 1월 1일 0시 0분 0초, 자바와는 기준점이 다르기 때문에 별도로 함수 존재하는 것
            
            날짜 연번 = 날짜수.시간
            
            날짜 데이터의 연산은 오직 - 연산만 가능 ( +, *, / 는 불가)
            날짜 +(-) 숫자의 연산은 가능 => 날짜 연번 +(-) 숫자이므로 결국 날짜에서 원하는 숫자만큼 이동된 날짜를 표시하게 됨  
            
            
*/

--사원들의 근무일수 조회
SELECT
    ename 이름, FLOOR(SYSDATE - hiredate) 근무일수 -- 소수점 이하는 시간 데이터
FROM
    emp
;

SELECT
    SYSDATE + 10
FROM
    dual
;

/*
    <날짜 함수>
    
    1. ADD_MONTHS() : 지정한 날짜에 지정한 달수를 더하거나 뺀 날짜를 반환해주는 함수
        
        [형식]
            ADD_MONTHS(날짜, 더할개월수)
            
        [참고]    
            더할 개월 수에 음수 입력 시 해당 개월수를 뺀 날짜를 알려준다.
    
    2. MONTHS_BETWEEN() : 두 날짜 데이터의 개월 수 반환해주는 함수
        
        [형식]
            MONTHS_BETWEEN(날짜, 날짜)
    
    3. LAST_DAY : 지정한 날짜가 포함된 월의 마지막 날짜를 알려주는 함수(윤년 계산 시 사용)
    
        [형식]
            LAST_DAY(날짜)
    
    4. NEXT_DAY : 지정한 날짜 이후에 가장 처음 오는 지정한 요일에 해당하는 날짜를 반환해주는 함수
        
        [형식]
            NEXT_DAY(날짜, 요일)
            
        [참고]
            요일 정하는 법
            
            1. 한글 세팅된 오라클이므로 한글로 써주면 된다.
            2. 영문권에서는 'SUN', 'MON', 'SUNDAY', 'MONDAY'...
    
    5. ROUND() : 날짜를 기준단위에서 반올림하는 함수 (기준단위는 년, 월, 일...)
        
        [형식]
            ROUND(날짜, 기준단위)
    
        
*/

--오늘부터 4개월 뒤

SELECT
    ADD_MONTHS(SYSDATE, 4) "4개월후",
    ADD_MONTHS(SYSDATE, -3) "3개월전"
FROM
    dual
;   

--사원들의 근무 개월 수 조회
SELECT
    ename 이름,
    hiredate 입사일,
    TRUNC(MONTHS_BETWEEN(SYSDATE, hiredate)) 근무개월수
FROM
    emp
;

--이번 달 마지막 날짜를 조회
SELECT
    LAST_DAY(SYSDATE)
FROM
    dual
;

--사원들의 첫번째 월급날 조회, 월급날은 매월 말일
SELECT
    ename 이름, sal 급여, hiredate 입사일,
    LAST_DAY(hiredate) 첫급여일
FROM
    emp
;

--익일 1일이라면?
SELECT
    ename 이름,
    sal 급여,
    hiredate 입사일,
    LAST_DAY(hiredate) + 1 첫급여일
FROM
    emp
;

--이번주 일요일이 며칠인지 조회
SELECT
    NEXT_DAY(SYSDATE, '일')
FROM
    dual
;

--올해 성탄절 이후 첫 토요일 조회
SELECT
    NEXT_DAY(TO_DATE('2022/12/25', 'YYYY/MM/DD'), '토') 성탄절이후첫토요일-- 원래 날짜 넣어줘야 하는데 문자열 넣어도 됨. 문자와 날짜는 서로 자동 형변환 되기 때문에
FROM
    dual
;

--현재 시간의 년도 기준으로 반올림
SELECT
    TO_CHAR(ROUND(SYSDATE, 'YEAR'), 'YYYY/MM/DD HH24:mi:ss') 반올림
FROM
    dual
;

--현재 시간 월 기준으로 반올림
SELECT
    ROUND(SYSDATE, 'MONTH') 월반올림,
    ROUND(SYSDATE, 'DAY') 주반올림,
    ROUND(SYSDATE, 'DD') 일반올림
FROM
    dual
;

----------------------


/*
    <변환 함수>
    : 데이터의 형태를 바꿔서 특정 함수에 사용 가능하도록 해주는 함수
    
    함수는 데이터 형태에 따라서 사용하는 함수가 달라진다. (숫자와 날짜의 ROUND()는 다르다)
    현재 가진 데이터가 사용하려는 함수에 필요한 데이터가 아닌 경우에는 데이터의 형태를 변환해서 사용해야 한다.
    이 때 필요한 함수가 "형변환 함수"
    
        NUMBER ----------->  CHAR  <---------- DATE
                 TO_CHAR()           TO_CHAR()
               <-----------         ---------->
                 TO_NUMBER()         TO_DATE()
    1. TO_CHAR() : 날짜나 숫자를 문자로 변환
        
        [형식]
            1. TO_CHAR(날짜 또는 숫자)
            2. TO_CHAR(날짜 또는 숫자, 형식) : 해당 형식의 문자열로 변환
                
               
                [주의]
                    숫자를 문자로 변환 시 형식으로 사용하는 문자는
                        9 : 무효숫자는 표현 안 함
                        0 : 무효숫자도 표현함
    
    2. TO_DATE() : 문자로 된 날짜를 날짜로 변환
        
        [형식]
            1. TO_DATE(날짜 형식 문자열)
            2. TO_DATE(날짜 형식 문자열, '변환형식') : 오라클이 지정하는 형식의 날짜처럼 만들지 못한 경우 사용
            
              '12/09/91' 처럼 월, 일, 년의 순서로 문자가 만들어졌을 때 사용
                
                * 변환형식 : 입력한 문자데이터가 어떤 의미를 가지고 만들어졌는지 알려주는 기능
            
    3. TO_NUMBER() : 숫자 형식의 문자를 숫자로 변환(문자데이터는 +, - 연산이 안 되기 때문)
        
        [형식]
            1. TO_NUMBER(숫자 형식의 문자데이터)   
            2. TO_NUMBER(숫자 형식의 문자데이터, 변환형식)
                
                * 변환형식 : 현재 문자열이 어떤 의미로 만들어졌는지 알려주는 기능
                
                '1,234' + '5,678'의 경우 사용
*/

--사원들의 이름, 입사일, 부서번호 조회. 입사일은 'XXXX년 XX월 XX일'의 형식으로 조회
SELECT
    ename 이름, 
    TO_CHAR(hiredate, 'YYYY') || '년' || TO_CHAR(hiredate, 'MM') || '월' || TO_CHAR(hiredate, 'DD') || '일' 입사일,
    TO_CHAR(hiredate, 'YYYY"년 "MM"월 "DD"일 "') 한글입사일,
    deptno 부서번호
FROM
    emp
;

--사원급여 조회하는데 앞에는 $ 붙이고 3자리마다 , 를 붙여서 조회
SELECT
    ename 이름, sal 급여, TO_CHAR(sal, '$9,999,999,999,999') 문자급여1, TO_CHAR(sal, '$0,000,000') 문자급여2
    
FROM
    emp
;

--급여가 100 ~ 999 사이인 사원의 정보 조회. 
SELECT
    *
FROM
    emp
WHERE
--    TO_CHAR(sal) LIKE '___'
    LENGTH(TO_CHAR(sal)) = 3
;

SELECT
    *
FROM
    emp
WHERE
    sal BETWEEN 100 AND 999
;

-- TO_DATE() : 내가 지금까지 며칠동안 살고 있는지 알아보자
SELECT
    FLOOR(SYSDATE - TO_DATE('95/10/24')) 살아온날수,
    FLOOR(SYSDATE - TO_DATE('951024')) 날수
FROM
    dual
;   

SELECT
    FLOOR(SYSDATE - TO_DATE('10/24/1995', 'MM/DD/YYYY'))
FROM
    dual
;

SELECT
    FLOOR(SYSDATE - TO_DATE('10241995', 'MMDDYYYY'))
FROM
    dual
;

--TO_NUMBER() :  '123', '456' 더한 결과 조회
SELECT
-- '123' + '456' => 이 경우 형변환 함수가 자동 호출
    TO_NUMBER('123') + TO_NUMBER('456') result
FROM
    dual
;

SELECT
    TO_NUMBER('1,234', '9,999') + TO_NUMBER('5,678', '9,999,999') result
FROM
    dual
;

-------------------

/*
    <기타함수>
    
    1. NVL() : NULL 데이터는 모든 연산(함수)에 적용되지 않는다.
               이를 해결하기 위해 제시된 함수
               
            [형식]
                NVL(데이터, 바꿀데이터)
                
            [의미]
                NULL 데이터면 강제로 지정한 데이터로 바꿔서 연산하거나 함수에 적용하도록 한다.
                
            [주의]
                지정한 데이터와 바꿀 데이터는 반드시 형태(타입)가 동일해야 한다.
                
    2. NVL2()
        
        [형식]
            NVL2(필드이름, 처리내용1, 처리내용2)
        
        [의미]
            필드의 내용이 NULL 이면 처리내용2로, NULL이 아니면 처리내용1으로 처리하라.
            
    3. NULLIF()
        
        [형식]
            NULLIF(데이터1, 데이터2)
            
        [의미]
            두 데이터가 같으면 NULL로 처리, 다르면 데이터1으로 처리
    
    4. COALESCE()
    
        [형식]
            COALESCE(데이터1, 데이터2)
        
        [의미]
            여러 개의 데이터 중 가장 첫 번째 나오는 NULL이 아닌 데이터를 출력
*/      

--NVL()
SELECT
--  ename 이름, NVL(comm, 'NONE') 커미션 ==> comm은 숫자, 대체할 데이터와 형태가 달라서 불가능
    ename 이름, NVL(TO_CHAR(comm), 'NONE') 커미션 -- 반드시 데이터와 대체할 데이터의 타입이 동일해야 한다.
FROM
    emp
;


--NVL2()    커미션이 있으면 급여 = 급여 + 커미션, 커미션 없으면 급여 그대로 출력
SELECT
    ename 이름, sal 원급여, comm 커미션,
    NVL2(comm, sal + comm, sal) 인상급여
FROM
    emp
;

--COALESCE()    커미션 출력하는데 만약 커미션이 NULL이면 급여를 대신 출력
SELECT
    ename, sal, comm, COALESCE(comm, sal)
FROM
    emp
;

/*
    문제1]
        
        커미션이 존재하면 
            현재 급여의 10% 인상한 금액 + 커미션,
        커미션이 존재하지 않으면
            현재 급여의 5% 인상한 금액 + 100으로 
            
            이름, 급여, 커미션, 지급급여 조회
*/
SELECT
    ename 이름, sal 급여, comm 커미션, 
    NVL2(comm, sal * 1.1 + comm, sal*1.05 + 100) 지급급여1, 
    COALESCE(sal * 1.1 + comm, sal * 1.05 + 100) 지급급여2
FROM
    emp
;


/*
    문제2]
        
        커미션에 50%를 추가해서 지급하고자 한다.
        만약 커미션이 존재하지 않으면 급여를 이용해서 10%를 추가해서 지급하고자 한다.
        사원 이름, 급여, 커미션, 지급급여 조회
*/
SELECT
    ename 이름, 
    sal 급여, 
    comm 커미션, 
    (NVL2(comm, comm * 1.5, sal * 1.1)) 지급커미션1,
    COALESCE(comm * 1.5, sal * 1.1) 지급커미션2
FROM
    emp
;

-----------------

/*
    <조건 처리 함수>
    : 함수라기보다는 명령에 가깝다. 자바의 switch ~ case, if를 대신함
    
    1. DECODE() : switch ~ case 명령에 해당하는 함수
        
        [형식]
            DECODE(필드이름, 값1, 처리내용1, 값2, 처리내용2 ... 처리내용n)
            
        [의미]
            필드의 내용이 값1과 같으면 처리내용1을,
                          값2와 괕으면 처리내용2를,
                          그 이외의 값은 처리내용n으로 처리하라.
        
        [주의사항]
            DECODE() 내에서는 조건식 사용 불가, 데이터만 명시할 수 있음
    
    2. CASE : if 명령에 해당하는 명령
        
        [형식]
        
            1.    CASE    WHEN    조건식1    THEN    내용1     
                          WHEN    조건식2    THEN    내용2
                          ...
                          ELSE    내용n
             
                   END
                  
        [의미]
            
            조건식1이 참이면 내용1을
            조건식2가 참이면 내용2를
            ...
            그 이외는 내용n을 실행하라
                   
                   
            2.     CASE     필드이름    WHEN    값1    THEN    실행내용1
                                        WHEN    값2    THEN    실행내용2
                                        ...
                                        ELSE 실행내용n
                    END
        [의미]
            
            DECODE()와 동일
            암묵적으로 필드이름과 값의 동등비교만 사용하는 명령
            
*/

-- DECODE() : 사원들의 이름, 직급, 부서번호, 부서이름 조회. 
--            부서이름은 부서번호가 10번이면 회계부, 20번이면 연구부, 30번이면 영업부, 나머지는 관리부
SELECT
    ename 이름, job 직급, deptno 부서번호, 
    DECODE(deptno, 10, '회계부', 
                   20, '연구부', 
                   30, '영업부', 
                       '관리부') 부서이름 
FROM
    emp
ORDER BY
    deptno
;

--CASE  급여가 1000미만이면 20% 인상, 1000 ~ 3000미만이면 15% 인상, 3000 이상이면 10% 인상.
SELECT
    ename 이름, sal 원급여,
    FLOOR(
    CASE WHEN sal < 1000 THEN sal * 1.2 
         WHEN sal < 3000 THEN sal * 1.15 -- 이미 조건1을 만족했기 때문에 굳이 명시해줄 필요 없음
         ELSE sal * 1.1 
    END) 인상급여
FROM
    emp
;

----------- <단일행 함수>

/*
    <그룹 함수>
    : 여러 행의 데이터를 하나로 만들어서 뭔가를 계산하는 함수
    
        [참고]
            그룹 함수는 결과가 오직 한 개만 나오게 된다.
            따라서 그룹함수는 결과가 여러 개 나오는 경우(단일행 함수, 각 필드)와 혼용해서 사용할 수 없다.
            오직 결과가 한 줄로만 나오는 것과만 혼용 가능
        
        1. SUM() : 데이터의 합계
            
            [형식]
                SUM(필드이름)
        
        2. AVG() : 데이터의 평균
            
            [형식]
                AVG(필드이름)
            
            [참고]
                NULL 데이터는 모든 연산에서 제외되기 때문에 
                평균 구하는 연산에서도 완전히 제외된다.
        
        3. COUNT() : 데이터들의 갯수
                     (지정한 필드 중 데이터가 존재(NULL이 아닌)하는 필드의 갯수 반환)
            
            [형식]
                COUNT(필드이름)
                
            [참고]
                필드 이름 대신 *을 사용하면
                각 필드의 카운터를 구한 후 가장 큰 값을 반환한다.
                
        4. MAX() / MIN() : 지정한 필드의 최댓값과 최솟값
            
            [형식]
                MAX / MIN(필드이름)
                
        ----------------
        
        5. STDDEV() : 표준편차
        
        6. VARIANCE() : 분산        
*/

-- 급여 합계 조회
SELECT
    SUM(sal) 급여합계,
    MAX(sal) 최대급여,
    MIN(sal) 최소급여,
    FLOOR(AVG(sal)) 급여평균,
    COUNT(*) 사원수
--    deptno => 일반필드라 오류
    
FROM
    emp
;

SELECT
    AVG(comm) -- NULL 사원들은 제외, 4명만 계산
FROM
    emp
;

----------------

/*
    <GROUP BY절>
    : 그룹 함수에 적용되는 그룹을 지정하는 것
      조회 시 대상을 그룹핑해서 조회하는 방법
    
        [예]
            부서별 급여의 합계
            직급별 급여의 평균
        
        [형식]
            SELECT
                그룹 함수, 그룹 기준 필드
            FROM
                테이블 이름
            [WHERE
                조건식] ==> 일반 조건절
            GROUP BY
                필드 이름 ==> WHERE절까지 필터링된 데이터만 취급
            [HAVING
                조건] ==> 위 결과 중 다시 필터링(GROUP BY의 조건절)  
            ORDER BY
                필드 이름
        
        [참고]
            GROUP BY 사용 시
            GROUP BY에 적용된 필드는 같이 조회 가능
            
    <HAVING절>
    : 그룹화한 경우 계산된 그룹 중 출력에 적용될 그룹을 지정하는 조건식 기술
    
        [참고]
            WHERE 조건절은 계산에 포함된 데이터를 선택
            HAVING 조건절은 그룹화해서 계산한 후 출력할지 말지 결정
            
        [참고]
            WHERE절 안에서는 그룹 함수 사용 불가능
            HAVING절 안에서는 그룹 함수 사용 가능
*/

-- 직급별 급여 평균을 직급명과 함께 조회
SELECT
    job 부서이름, FLOOR(AVG(sal)) 부서급여평균
FROM
    emp
GROUP BY
    job
;

--부서별 최대 급여 조회. 부서번호, 부서이름, 부서최대급여
SELECT
    deptno 부서번호, 
    DECODE(deptno, 10, '회계부',
                   20, '연구부',
                   30, '영업부',
                       '관리부') 부서이름,
    MAX(sal) 부서최대급여
                       
FROM
    emp 
GROUP BY
    deptno
ORDER BY
    deptno
;

-- 부서별 평균 급여 조회, 단 부서평균 급여가 2000 이상인 부서만 출력 
SELECT
    deptno 부서번호, FLOOR(AVG(sal)) 부서평균급여
FROM
    emp
GROUP BY
    deptno
HAVING
    AVG(sal) >= 2000 -- ==> 그룹 함수 사용 가능, WHERE절에서는 불가능
ORDER BY
    deptno
;

-- 직급별 사원 수 조회. 단, 사원 수가 1명인 직급은 조호되지 않게 하라 
SELECT
    job 직급, count(*) 사원수
FROM
    emp
GROUP BY
    job
HAVING
    count(*) > 1 
;
