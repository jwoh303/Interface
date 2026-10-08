SELECT
A.cstmr_id as "고객사코드",
A.bizmn_regst_no as "사업자번호",
(select biznplc_clss_nm from kepmdcp03 where biznplc_clss_no = A.cstmr_id) as "고객사명",
sum(A.PURCHASE_PRICE) as "합계: 재고금액",
sum(A.won_cnvrs_sls_amt) as "합계: 정산금액"
FROM KEPMPCL02 A
WHERE A.BIZ_CLSS_CD = 'C002'
AND   A.CLSN_YYMON = '202108'  ----------- 정산년월
AND   A.USE_CHK = 'Y'
AND   A.SLS_CNFRM_CHK = 'Y'
group by A.cstmr_id, A.bizmn_regst_no
;