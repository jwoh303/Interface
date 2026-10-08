SELECT a.BIZMN_REGST_NO                                               AS 거래처코드,
  a.ALANC_ID                                                          AS 회사코드 ,
  a.ALANC_NM                                                          AS "거래처명(한)" ,
  a.BIZMN_REGST_NO                                                    AS 사업자등록번호,
  a.ALANC_ABBRE_NM                                                    AS "거래처명(약어)",
  DECODE(a.BIZSCL_CD,'CM','001','CS','002','ID','003','005')          AS 거래처구분,
  DECODE(a.ALANC_TYP_CD,'C001','002','C002','001','C004','003','004') AS 거래처분류,
  '0730'                                                              AS 담당부서 ,
  '0730'                                                              AS "C/C(코스트센터)",
  a.RPRDR_NM                                                          AS 대표자명,
  a.BIZNPLC_POSTCD                                                    AS 본사우편번호 ,
  a.BIZNPLC_ADDR_BSC                                                  AS "본사주소(기본)",
  a.BIZNPLC_ADDR_DTAIL                                                AS "본사주소(상세)",
  a.RPRSNT_PHON_NO                                                    AS 본사전화번호,
  a.RPRSNT_FAX_NO                                                     AS 본사FAX,
  a.BIZCND_NM                                                         AS 업태,
  a.ITM_NM                                                            AS 종목 ,
  '11'                                                                AS 과세유형,
  ''                                                                  AS 휴폐업구분,
  ''                                                                  AS 폐업일자,
  a.note                                                              AS 비고 
  a.use_chk                                                           AS 사용유무
FROM kepmdcp01 a --, kepmdcp05 b
where a.BIZ_CLSS_CD = 'C002' 
--and a.alanc_id = b.alanc_id

;

