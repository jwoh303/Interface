SELECT
        DECODE(CL01.ALANC_CLSS_CD,'C001','KA','C002','SA','C003','KW','C005','IT','KW') AS IF_SYSTEM,
        '1000' CD_COMPANY,
        CL01.SLS_TAX_BILL_NO AS ROW_ID,
        ROW_NUMBER() OVER(PARTITION BY CL01.SLS_TAX_BILL_NO ORDER BY CL01.FRST_REGST_DATM) SEQ,	
        '2021' CD_EPCODE,
        '1000' CD_PC,
        '110020' CD_WDEPT,
        CL01.TAX_BILL_PBLCTN_DATE AS DT_ACCT,
        DECODE( CL01.TAX_CLSS_CD, 
        '11','11',	-- (매출)과세매출
        '12','14',	-- (매출)영세매출
        '13','16',	-- (매출)면세매출
        '16','15',	-- (매출)영세-수출
        '17','12',	-- (매출)카드매출
        '18','19' 	-- (매출)면세카드매출
        ) CD_EVID,
        '' DT_START, '' DT_END,
        ( SELECT T.GDS_NM
          FROM   KEPCMCL02 T
          WHERE  T.TAX_BILL_NO = CL01.SLS_TAX_BILL_NO
          AND T.PRCHS_SLS_CLSS_CD='SA'
          AND ROWNUM=1 ) NM_NOTE,
        NVL(CC01.SLS_AMT,0) AM_TAXSTD,
        NVL(CC01.ADJUSTED_SLS_VAT,0) AM_ADDTAX,
        DECODE(
            GETALANCINFO(CL01.CMPNY_ALANC_ID,'BIZMN_REGST_NO')
            , '1078185880', 'SE'
            , '1138523209', 'GU'
            , '6158508913', 'CW'
            , ' ' ) CD_BIZAREA,
        CC01.ERP_DEPT_CD CD_CC,
        CC01.ERP_DEPT_CD CD_DEPT,
        REPLACE(CL01.RESGTR_ID, 'KEP', '') CD_EMPLOY,
        REPLACE(CL01.BIZMN_REGST_NO,'-','') CD_PARTNER,
        REPLACE(CL01.BIZMN_REGST_NO,'-','') NO_COMPANY,
        CL01.CSTMR_ID CD_UMNG1,
        CC01.ERP_DEPT_CD CD_MNGD1,
        CL01.CMP_NM NM_MNGD1,
        REPLACE(CL01.BIZMN_REGST_NO,'-','') CD_MNGD2,
        CL01.CMP_NM NM_MNGD2,	'' CD_MNGD3,	'' NM_MNGD3,	'' CD_MNGD4,	'' NM_MNGD4,
        '' CD_MNGD5,	NVL(CC01.ADJUSTED_SLS_VAT,0) NM_MNGD5,	'' CD_MNGD6,	'' NM_MNGD6,	'' CD_MNGD7,
        '' NM_MNGD7,	CL01.CSTMR_ID CD_MNGD8,	CL01.CMP_NM NM_MNGD8,	'' CD_MNGD9,	CL01.SLS_TAX_BILL_NO NM_MNGD9,
        DECODE(CL01.ALANC_CLSS_CD,'C001','KA','C002','SA','C003','KW','C005','IT','KW') CD_MNGD10,	
        DECODE(CL01.ALANC_CLSS_CD,'C001','구매대행','C002','건설','C003','유통','C005','IT','유통') NM_MNGD10,
        CASE
          WHEN  NVL((
                /*+INDEX DESC (MPCL02 KEPMPCL02_PK)*/
                SELECT MPCL02.CURR_CD
                FROM   KEPMPCL02 MPCL02
                WHERE  MPCL02.SLS_TAX_BILL_NO = CL01.SLS_TAX_BILL_NO
                AND    MPCL02.USE_CHK = 'Y'
                AND    ROWNUM = 1
                ),'KRW') != 'KRW' THEN '001' 
          ELSE '000'
        END CD_EXCH,	
        NVL((
        /*+INDEX DESC (MPCL02 KEPMPCL02_PK)*/
        SELECT DECODE(MPCL02.CURR_CD,'KRW',0, MPCL02.EXRATE)
        FROM   KEPMPCL02 MPCL02
        WHERE  MPCL02.SLS_TAX_BILL_NO = CL01.SLS_TAX_BILL_NO
        AND    MPCL02.USE_CHK = 'Y'
        AND    ROWNUM = 1
        ),0) RT_EXCH,	
        NVL((
        SELECT SUM(DECODE(MPCL02.CURR_CD,'KRW',0, MPCL02.WON_CNVRS_SLS_AMT))
        FROM   KEPMPCL02 MPCL02
        WHERE  MPCL02.SLS_TAX_BILL_NO = CL01.SLS_TAX_BILL_NO
        AND    MPCL02.USE_CHK = 'Y'
        ),0) AM_EX,
        '' ST_MUTUAL,	'' NO_TO,	'' DT_SHIPPING,	
        DECODE( CL01.TAX_CLSS_CD, 
        '11','3',	-- (매출)과세매출
        '12','3',	-- (매출)영세매출
        '13','4',	-- (매출)면세매출
        '16','0',	-- (매출)영세-수출
        '17','0',	-- (매출)카드매출
        '18','0' 	-- (매출)면세카드매출            
        ) TP_EVIDENCE
FROM   KEPCMCL01 CL01
    ,  VW_ERP_SLS_CMCL01 CC01
WHERE  1=1
AND    CL01.ERP_SND_STATE_CD ='T'
AND    (CL01.MILE_CHK = 'N' OR CL01.MILE_CHK IS NULL)
AND    CL01.BILL_CNFRM_CHK = 'Y'
AND    (( CL01.ELCTR_TAX_BILL_PBLCTN_CHK='Y' AND CL01.ATTR_1='Y')
        OR
        ( CL01.ELCTR_TAX_BILL_PBLCTN_CHK IS NULL )
        OR
        ( CL01.ELCTR_TAX_BILL_PBLCTN_CHK = 'N' )
       )
AND    CL01.USE_CHK = 'Y'
AND    CL01.SLS_TAX_BILL_NO = CC01.SLS_TAX_BILL_NO
ORDER BY CL01.SLS_TAX_BILL_NO