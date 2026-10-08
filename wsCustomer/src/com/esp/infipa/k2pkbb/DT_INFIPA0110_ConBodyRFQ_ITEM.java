/**
 * DT_INFIPA0110_ConBodyRFQ_ITEM.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.infipa.k2pkbb;

public class DT_INFIPA0110_ConBodyRFQ_ITEM  implements java.io.Serializable {
    /* 회사 코드 */
    private java.lang.String COMP_CD;

    /* KeP 견적요청번호 */
    private java.lang.String RFQ_NO;

    /* 견적요청차수 */
    private java.lang.String RFQ_CNT;

    /* 견적요청항번 */
    private java.lang.String RFQ_LNO;

    /* 구매 유형 */
    private java.lang.String PURC_TYP;

    /* 플랜트 코드 */
    private java.lang.String PLT_CD;

    /* 품목 코드 */
    private java.lang.String ITEM_CD;

    /* 품목 명 */
    private java.lang.String ITEM_NM;

    /* 화학물질 여부 */
    private java.lang.String CHEM_MATL_YN;

    /* 규격 */
    private java.lang.String SPEC;

    /* 단위 코드 */
    private java.lang.String UNIT_CD;

    /* 품목 수량 */
    private java.lang.String ITEM_QTY;

    /* 견적기준단가 */
    private java.lang.String RFQ_PRICE;

    /* 목표가 */
    private java.lang.String TGT_PRICE;

    /* 제한가 */
    private java.lang.String LMT_PRICE;

    /* 창고 코드 */
    private java.lang.String WH_CD;

    /* 납품요청일(물품) */
    private java.lang.String RD_DATE;

    /* 프로젝트 시작일(공사) */
    private java.lang.String PRD_SD;

    /* 프로젝트 종료일(공사) */
    private java.lang.String PRD_ED;

    /* 선정 여부 */
    private java.lang.String STL_YN;

    /* 선정 수량 */
    private java.lang.String STL_QTY;

    /* 가격단위 */
    private java.lang.String PRICE_UNIT;

    /* 통화 */
    private java.lang.String CUR;

    /* 구매요청번호 (SAP PR 정보) */
    private java.lang.String PR_NO;

    /* 구매요청 항번 (SAP PR 정보) */
    private java.lang.String PR_LNO;

    /* 구매요청 생성/변경일 (SAP PR 정보) */
    private java.lang.String PR_REQ_DATE;

    /* KAMS 구매요청번호 (SAP PR 정보) */
    private java.lang.String KAMS_PR_NO;

    /* 구매요청 품목범주 (SAP PR 정보) */
    private java.lang.String ITEM_CATE;

    /* 견적담당자 */
    private java.lang.String REG_ID;

    /* WBS */
    private java.lang.String WBS;

    /* WBS 내역 */
    private java.lang.String WBS_DESC;

    /* 구매요청자 */
    private java.lang.String ZZAFNAM;

    public DT_INFIPA0110_ConBodyRFQ_ITEM() {
    }

    public DT_INFIPA0110_ConBodyRFQ_ITEM(
           java.lang.String COMP_CD,
           java.lang.String RFQ_NO,
           java.lang.String RFQ_CNT,
           java.lang.String RFQ_LNO,
           java.lang.String PURC_TYP,
           java.lang.String PLT_CD,
           java.lang.String ITEM_CD,
           java.lang.String ITEM_NM,
           java.lang.String CHEM_MATL_YN,
           java.lang.String SPEC,
           java.lang.String UNIT_CD,
           java.lang.String ITEM_QTY,
           java.lang.String RFQ_PRICE,
           java.lang.String TGT_PRICE,
           java.lang.String LMT_PRICE,
           java.lang.String WH_CD,
           java.lang.String RD_DATE,
           java.lang.String PRD_SD,
           java.lang.String PRD_ED,
           java.lang.String STL_YN,
           java.lang.String STL_QTY,
           java.lang.String PRICE_UNIT,
           java.lang.String CUR,
           java.lang.String PR_NO,
           java.lang.String PR_LNO,
           java.lang.String PR_REQ_DATE,
           java.lang.String KAMS_PR_NO,
           java.lang.String ITEM_CATE,
           java.lang.String REG_ID,
           java.lang.String WBS,
           java.lang.String WBS_DESC,
           java.lang.String ZZAFNAM) {
           this.COMP_CD = COMP_CD;
           this.RFQ_NO = RFQ_NO;
           this.RFQ_CNT = RFQ_CNT;
           this.RFQ_LNO = RFQ_LNO;
           this.PURC_TYP = PURC_TYP;
           this.PLT_CD = PLT_CD;
           this.ITEM_CD = ITEM_CD;
           this.ITEM_NM = ITEM_NM;
           this.CHEM_MATL_YN = CHEM_MATL_YN;
           this.SPEC = SPEC;
           this.UNIT_CD = UNIT_CD;
           this.ITEM_QTY = ITEM_QTY;
           this.RFQ_PRICE = RFQ_PRICE;
           this.TGT_PRICE = TGT_PRICE;
           this.LMT_PRICE = LMT_PRICE;
           this.WH_CD = WH_CD;
           this.RD_DATE = RD_DATE;
           this.PRD_SD = PRD_SD;
           this.PRD_ED = PRD_ED;
           this.STL_YN = STL_YN;
           this.STL_QTY = STL_QTY;
           this.PRICE_UNIT = PRICE_UNIT;
           this.CUR = CUR;
           this.PR_NO = PR_NO;
           this.PR_LNO = PR_LNO;
           this.PR_REQ_DATE = PR_REQ_DATE;
           this.KAMS_PR_NO = KAMS_PR_NO;
           this.ITEM_CATE = ITEM_CATE;
           this.REG_ID = REG_ID;
           this.WBS = WBS;
           this.WBS_DESC = WBS_DESC;
           this.ZZAFNAM = ZZAFNAM;
    }


    /**
     * Gets the COMP_CD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return COMP_CD   * 회사 코드
     */
    public java.lang.String getCOMP_CD() {
        return COMP_CD;
    }


    /**
     * Sets the COMP_CD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param COMP_CD   * 회사 코드
     */
    public void setCOMP_CD(java.lang.String COMP_CD) {
        this.COMP_CD = COMP_CD;
    }


    /**
     * Gets the RFQ_NO value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return RFQ_NO   * KeP 견적요청번호
     */
    public java.lang.String getRFQ_NO() {
        return RFQ_NO;
    }


    /**
     * Sets the RFQ_NO value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param RFQ_NO   * KeP 견적요청번호
     */
    public void setRFQ_NO(java.lang.String RFQ_NO) {
        this.RFQ_NO = RFQ_NO;
    }


    /**
     * Gets the RFQ_CNT value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return RFQ_CNT   * 견적요청차수
     */
    public java.lang.String getRFQ_CNT() {
        return RFQ_CNT;
    }


    /**
     * Sets the RFQ_CNT value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param RFQ_CNT   * 견적요청차수
     */
    public void setRFQ_CNT(java.lang.String RFQ_CNT) {
        this.RFQ_CNT = RFQ_CNT;
    }


    /**
     * Gets the RFQ_LNO value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return RFQ_LNO   * 견적요청항번
     */
    public java.lang.String getRFQ_LNO() {
        return RFQ_LNO;
    }


    /**
     * Sets the RFQ_LNO value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param RFQ_LNO   * 견적요청항번
     */
    public void setRFQ_LNO(java.lang.String RFQ_LNO) {
        this.RFQ_LNO = RFQ_LNO;
    }


    /**
     * Gets the PURC_TYP value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return PURC_TYP   * 구매 유형
     */
    public java.lang.String getPURC_TYP() {
        return PURC_TYP;
    }


    /**
     * Sets the PURC_TYP value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param PURC_TYP   * 구매 유형
     */
    public void setPURC_TYP(java.lang.String PURC_TYP) {
        this.PURC_TYP = PURC_TYP;
    }


    /**
     * Gets the PLT_CD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return PLT_CD   * 플랜트 코드
     */
    public java.lang.String getPLT_CD() {
        return PLT_CD;
    }


    /**
     * Sets the PLT_CD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param PLT_CD   * 플랜트 코드
     */
    public void setPLT_CD(java.lang.String PLT_CD) {
        this.PLT_CD = PLT_CD;
    }


    /**
     * Gets the ITEM_CD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return ITEM_CD   * 품목 코드
     */
    public java.lang.String getITEM_CD() {
        return ITEM_CD;
    }


    /**
     * Sets the ITEM_CD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param ITEM_CD   * 품목 코드
     */
    public void setITEM_CD(java.lang.String ITEM_CD) {
        this.ITEM_CD = ITEM_CD;
    }


    /**
     * Gets the ITEM_NM value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return ITEM_NM   * 품목 명
     */
    public java.lang.String getITEM_NM() {
        return ITEM_NM;
    }


    /**
     * Sets the ITEM_NM value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param ITEM_NM   * 품목 명
     */
    public void setITEM_NM(java.lang.String ITEM_NM) {
        this.ITEM_NM = ITEM_NM;
    }


    /**
     * Gets the CHEM_MATL_YN value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return CHEM_MATL_YN   * 화학물질 여부
     */
    public java.lang.String getCHEM_MATL_YN() {
        return CHEM_MATL_YN;
    }


    /**
     * Sets the CHEM_MATL_YN value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param CHEM_MATL_YN   * 화학물질 여부
     */
    public void setCHEM_MATL_YN(java.lang.String CHEM_MATL_YN) {
        this.CHEM_MATL_YN = CHEM_MATL_YN;
    }


    /**
     * Gets the SPEC value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return SPEC   * 규격
     */
    public java.lang.String getSPEC() {
        return SPEC;
    }


    /**
     * Sets the SPEC value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param SPEC   * 규격
     */
    public void setSPEC(java.lang.String SPEC) {
        this.SPEC = SPEC;
    }


    /**
     * Gets the UNIT_CD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return UNIT_CD   * 단위 코드
     */
    public java.lang.String getUNIT_CD() {
        return UNIT_CD;
    }


    /**
     * Sets the UNIT_CD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param UNIT_CD   * 단위 코드
     */
    public void setUNIT_CD(java.lang.String UNIT_CD) {
        this.UNIT_CD = UNIT_CD;
    }


    /**
     * Gets the ITEM_QTY value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return ITEM_QTY   * 품목 수량
     */
    public java.lang.String getITEM_QTY() {
        return ITEM_QTY;
    }


    /**
     * Sets the ITEM_QTY value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param ITEM_QTY   * 품목 수량
     */
    public void setITEM_QTY(java.lang.String ITEM_QTY) {
        this.ITEM_QTY = ITEM_QTY;
    }


    /**
     * Gets the RFQ_PRICE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return RFQ_PRICE   * 견적기준단가
     */
    public java.lang.String getRFQ_PRICE() {
        return RFQ_PRICE;
    }


    /**
     * Sets the RFQ_PRICE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param RFQ_PRICE   * 견적기준단가
     */
    public void setRFQ_PRICE(java.lang.String RFQ_PRICE) {
        this.RFQ_PRICE = RFQ_PRICE;
    }


    /**
     * Gets the TGT_PRICE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return TGT_PRICE   * 목표가
     */
    public java.lang.String getTGT_PRICE() {
        return TGT_PRICE;
    }


    /**
     * Sets the TGT_PRICE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param TGT_PRICE   * 목표가
     */
    public void setTGT_PRICE(java.lang.String TGT_PRICE) {
        this.TGT_PRICE = TGT_PRICE;
    }


    /**
     * Gets the LMT_PRICE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return LMT_PRICE   * 제한가
     */
    public java.lang.String getLMT_PRICE() {
        return LMT_PRICE;
    }


    /**
     * Sets the LMT_PRICE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param LMT_PRICE   * 제한가
     */
    public void setLMT_PRICE(java.lang.String LMT_PRICE) {
        this.LMT_PRICE = LMT_PRICE;
    }


    /**
     * Gets the WH_CD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return WH_CD   * 창고 코드
     */
    public java.lang.String getWH_CD() {
        return WH_CD;
    }


    /**
     * Sets the WH_CD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param WH_CD   * 창고 코드
     */
    public void setWH_CD(java.lang.String WH_CD) {
        this.WH_CD = WH_CD;
    }


    /**
     * Gets the RD_DATE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return RD_DATE   * 납품요청일(물품)
     */
    public java.lang.String getRD_DATE() {
        return RD_DATE;
    }


    /**
     * Sets the RD_DATE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param RD_DATE   * 납품요청일(물품)
     */
    public void setRD_DATE(java.lang.String RD_DATE) {
        this.RD_DATE = RD_DATE;
    }


    /**
     * Gets the PRD_SD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return PRD_SD   * 프로젝트 시작일(공사)
     */
    public java.lang.String getPRD_SD() {
        return PRD_SD;
    }


    /**
     * Sets the PRD_SD value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param PRD_SD   * 프로젝트 시작일(공사)
     */
    public void setPRD_SD(java.lang.String PRD_SD) {
        this.PRD_SD = PRD_SD;
    }


    /**
     * Gets the PRD_ED value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return PRD_ED   * 프로젝트 종료일(공사)
     */
    public java.lang.String getPRD_ED() {
        return PRD_ED;
    }


    /**
     * Sets the PRD_ED value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param PRD_ED   * 프로젝트 종료일(공사)
     */
    public void setPRD_ED(java.lang.String PRD_ED) {
        this.PRD_ED = PRD_ED;
    }


    /**
     * Gets the STL_YN value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return STL_YN   * 선정 여부
     */
    public java.lang.String getSTL_YN() {
        return STL_YN;
    }


    /**
     * Sets the STL_YN value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param STL_YN   * 선정 여부
     */
    public void setSTL_YN(java.lang.String STL_YN) {
        this.STL_YN = STL_YN;
    }


    /**
     * Gets the STL_QTY value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return STL_QTY   * 선정 수량
     */
    public java.lang.String getSTL_QTY() {
        return STL_QTY;
    }


    /**
     * Sets the STL_QTY value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param STL_QTY   * 선정 수량
     */
    public void setSTL_QTY(java.lang.String STL_QTY) {
        this.STL_QTY = STL_QTY;
    }


    /**
     * Gets the PRICE_UNIT value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return PRICE_UNIT   * 가격단위
     */
    public java.lang.String getPRICE_UNIT() {
        return PRICE_UNIT;
    }


    /**
     * Sets the PRICE_UNIT value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param PRICE_UNIT   * 가격단위
     */
    public void setPRICE_UNIT(java.lang.String PRICE_UNIT) {
        this.PRICE_UNIT = PRICE_UNIT;
    }


    /**
     * Gets the CUR value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return CUR   * 통화
     */
    public java.lang.String getCUR() {
        return CUR;
    }


    /**
     * Sets the CUR value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param CUR   * 통화
     */
    public void setCUR(java.lang.String CUR) {
        this.CUR = CUR;
    }


    /**
     * Gets the PR_NO value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return PR_NO   * 구매요청번호 (SAP PR 정보)
     */
    public java.lang.String getPR_NO() {
        return PR_NO;
    }


    /**
     * Sets the PR_NO value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param PR_NO   * 구매요청번호 (SAP PR 정보)
     */
    public void setPR_NO(java.lang.String PR_NO) {
        this.PR_NO = PR_NO;
    }


    /**
     * Gets the PR_LNO value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return PR_LNO   * 구매요청 항번 (SAP PR 정보)
     */
    public java.lang.String getPR_LNO() {
        return PR_LNO;
    }


    /**
     * Sets the PR_LNO value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param PR_LNO   * 구매요청 항번 (SAP PR 정보)
     */
    public void setPR_LNO(java.lang.String PR_LNO) {
        this.PR_LNO = PR_LNO;
    }


    /**
     * Gets the PR_REQ_DATE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return PR_REQ_DATE   * 구매요청 생성/변경일 (SAP PR 정보)
     */
    public java.lang.String getPR_REQ_DATE() {
        return PR_REQ_DATE;
    }


    /**
     * Sets the PR_REQ_DATE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param PR_REQ_DATE   * 구매요청 생성/변경일 (SAP PR 정보)
     */
    public void setPR_REQ_DATE(java.lang.String PR_REQ_DATE) {
        this.PR_REQ_DATE = PR_REQ_DATE;
    }


    /**
     * Gets the KAMS_PR_NO value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return KAMS_PR_NO   * KAMS 구매요청번호 (SAP PR 정보)
     */
    public java.lang.String getKAMS_PR_NO() {
        return KAMS_PR_NO;
    }


    /**
     * Sets the KAMS_PR_NO value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param KAMS_PR_NO   * KAMS 구매요청번호 (SAP PR 정보)
     */
    public void setKAMS_PR_NO(java.lang.String KAMS_PR_NO) {
        this.KAMS_PR_NO = KAMS_PR_NO;
    }


    /**
     * Gets the ITEM_CATE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return ITEM_CATE   * 구매요청 품목범주 (SAP PR 정보)
     */
    public java.lang.String getITEM_CATE() {
        return ITEM_CATE;
    }


    /**
     * Sets the ITEM_CATE value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param ITEM_CATE   * 구매요청 품목범주 (SAP PR 정보)
     */
    public void setITEM_CATE(java.lang.String ITEM_CATE) {
        this.ITEM_CATE = ITEM_CATE;
    }


    /**
     * Gets the REG_ID value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return REG_ID   * 견적담당자
     */
    public java.lang.String getREG_ID() {
        return REG_ID;
    }


    /**
     * Sets the REG_ID value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param REG_ID   * 견적담당자
     */
    public void setREG_ID(java.lang.String REG_ID) {
        this.REG_ID = REG_ID;
    }


    /**
     * Gets the WBS value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return WBS   * WBS
     */
    public java.lang.String getWBS() {
        return WBS;
    }


    /**
     * Sets the WBS value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param WBS   * WBS
     */
    public void setWBS(java.lang.String WBS) {
        this.WBS = WBS;
    }


    /**
     * Gets the WBS_DESC value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return WBS_DESC   * WBS 내역
     */
    public java.lang.String getWBS_DESC() {
        return WBS_DESC;
    }


    /**
     * Sets the WBS_DESC value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param WBS_DESC   * WBS 내역
     */
    public void setWBS_DESC(java.lang.String WBS_DESC) {
        this.WBS_DESC = WBS_DESC;
    }


    /**
     * Gets the ZZAFNAM value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @return ZZAFNAM   * 구매요청자
     */
    public java.lang.String getZZAFNAM() {
        return ZZAFNAM;
    }


    /**
     * Sets the ZZAFNAM value for this DT_INFIPA0110_ConBodyRFQ_ITEM.
     * 
     * @param ZZAFNAM   * 구매요청자
     */
    public void setZZAFNAM(java.lang.String ZZAFNAM) {
        this.ZZAFNAM = ZZAFNAM;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_INFIPA0110_ConBodyRFQ_ITEM)) return false;
        DT_INFIPA0110_ConBodyRFQ_ITEM other = (DT_INFIPA0110_ConBodyRFQ_ITEM) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.COMP_CD==null && other.getCOMP_CD()==null) || 
             (this.COMP_CD!=null &&
              this.COMP_CD.equals(other.getCOMP_CD()))) &&
            ((this.RFQ_NO==null && other.getRFQ_NO()==null) || 
             (this.RFQ_NO!=null &&
              this.RFQ_NO.equals(other.getRFQ_NO()))) &&
            ((this.RFQ_CNT==null && other.getRFQ_CNT()==null) || 
             (this.RFQ_CNT!=null &&
              this.RFQ_CNT.equals(other.getRFQ_CNT()))) &&
            ((this.RFQ_LNO==null && other.getRFQ_LNO()==null) || 
             (this.RFQ_LNO!=null &&
              this.RFQ_LNO.equals(other.getRFQ_LNO()))) &&
            ((this.PURC_TYP==null && other.getPURC_TYP()==null) || 
             (this.PURC_TYP!=null &&
              this.PURC_TYP.equals(other.getPURC_TYP()))) &&
            ((this.PLT_CD==null && other.getPLT_CD()==null) || 
             (this.PLT_CD!=null &&
              this.PLT_CD.equals(other.getPLT_CD()))) &&
            ((this.ITEM_CD==null && other.getITEM_CD()==null) || 
             (this.ITEM_CD!=null &&
              this.ITEM_CD.equals(other.getITEM_CD()))) &&
            ((this.ITEM_NM==null && other.getITEM_NM()==null) || 
             (this.ITEM_NM!=null &&
              this.ITEM_NM.equals(other.getITEM_NM()))) &&
            ((this.CHEM_MATL_YN==null && other.getCHEM_MATL_YN()==null) || 
             (this.CHEM_MATL_YN!=null &&
              this.CHEM_MATL_YN.equals(other.getCHEM_MATL_YN()))) &&
            ((this.SPEC==null && other.getSPEC()==null) || 
             (this.SPEC!=null &&
              this.SPEC.equals(other.getSPEC()))) &&
            ((this.UNIT_CD==null && other.getUNIT_CD()==null) || 
             (this.UNIT_CD!=null &&
              this.UNIT_CD.equals(other.getUNIT_CD()))) &&
            ((this.ITEM_QTY==null && other.getITEM_QTY()==null) || 
             (this.ITEM_QTY!=null &&
              this.ITEM_QTY.equals(other.getITEM_QTY()))) &&
            ((this.RFQ_PRICE==null && other.getRFQ_PRICE()==null) || 
             (this.RFQ_PRICE!=null &&
              this.RFQ_PRICE.equals(other.getRFQ_PRICE()))) &&
            ((this.TGT_PRICE==null && other.getTGT_PRICE()==null) || 
             (this.TGT_PRICE!=null &&
              this.TGT_PRICE.equals(other.getTGT_PRICE()))) &&
            ((this.LMT_PRICE==null && other.getLMT_PRICE()==null) || 
             (this.LMT_PRICE!=null &&
              this.LMT_PRICE.equals(other.getLMT_PRICE()))) &&
            ((this.WH_CD==null && other.getWH_CD()==null) || 
             (this.WH_CD!=null &&
              this.WH_CD.equals(other.getWH_CD()))) &&
            ((this.RD_DATE==null && other.getRD_DATE()==null) || 
             (this.RD_DATE!=null &&
              this.RD_DATE.equals(other.getRD_DATE()))) &&
            ((this.PRD_SD==null && other.getPRD_SD()==null) || 
             (this.PRD_SD!=null &&
              this.PRD_SD.equals(other.getPRD_SD()))) &&
            ((this.PRD_ED==null && other.getPRD_ED()==null) || 
             (this.PRD_ED!=null &&
              this.PRD_ED.equals(other.getPRD_ED()))) &&
            ((this.STL_YN==null && other.getSTL_YN()==null) || 
             (this.STL_YN!=null &&
              this.STL_YN.equals(other.getSTL_YN()))) &&
            ((this.STL_QTY==null && other.getSTL_QTY()==null) || 
             (this.STL_QTY!=null &&
              this.STL_QTY.equals(other.getSTL_QTY()))) &&
            ((this.PRICE_UNIT==null && other.getPRICE_UNIT()==null) || 
             (this.PRICE_UNIT!=null &&
              this.PRICE_UNIT.equals(other.getPRICE_UNIT()))) &&
            ((this.CUR==null && other.getCUR()==null) || 
             (this.CUR!=null &&
              this.CUR.equals(other.getCUR()))) &&
            ((this.PR_NO==null && other.getPR_NO()==null) || 
             (this.PR_NO!=null &&
              this.PR_NO.equals(other.getPR_NO()))) &&
            ((this.PR_LNO==null && other.getPR_LNO()==null) || 
             (this.PR_LNO!=null &&
              this.PR_LNO.equals(other.getPR_LNO()))) &&
            ((this.PR_REQ_DATE==null && other.getPR_REQ_DATE()==null) || 
             (this.PR_REQ_DATE!=null &&
              this.PR_REQ_DATE.equals(other.getPR_REQ_DATE()))) &&
            ((this.KAMS_PR_NO==null && other.getKAMS_PR_NO()==null) || 
             (this.KAMS_PR_NO!=null &&
              this.KAMS_PR_NO.equals(other.getKAMS_PR_NO()))) &&
            ((this.ITEM_CATE==null && other.getITEM_CATE()==null) || 
             (this.ITEM_CATE!=null &&
              this.ITEM_CATE.equals(other.getITEM_CATE()))) &&
            ((this.REG_ID==null && other.getREG_ID()==null) || 
             (this.REG_ID!=null &&
              this.REG_ID.equals(other.getREG_ID()))) &&
            ((this.WBS==null && other.getWBS()==null) || 
             (this.WBS!=null &&
              this.WBS.equals(other.getWBS()))) &&
            ((this.WBS_DESC==null && other.getWBS_DESC()==null) || 
             (this.WBS_DESC!=null &&
              this.WBS_DESC.equals(other.getWBS_DESC()))) &&
            ((this.ZZAFNAM==null && other.getZZAFNAM()==null) || 
             (this.ZZAFNAM!=null &&
              this.ZZAFNAM.equals(other.getZZAFNAM())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getCOMP_CD() != null) {
            _hashCode += getCOMP_CD().hashCode();
        }
        if (getRFQ_NO() != null) {
            _hashCode += getRFQ_NO().hashCode();
        }
        if (getRFQ_CNT() != null) {
            _hashCode += getRFQ_CNT().hashCode();
        }
        if (getRFQ_LNO() != null) {
            _hashCode += getRFQ_LNO().hashCode();
        }
        if (getPURC_TYP() != null) {
            _hashCode += getPURC_TYP().hashCode();
        }
        if (getPLT_CD() != null) {
            _hashCode += getPLT_CD().hashCode();
        }
        if (getITEM_CD() != null) {
            _hashCode += getITEM_CD().hashCode();
        }
        if (getITEM_NM() != null) {
            _hashCode += getITEM_NM().hashCode();
        }
        if (getCHEM_MATL_YN() != null) {
            _hashCode += getCHEM_MATL_YN().hashCode();
        }
        if (getSPEC() != null) {
            _hashCode += getSPEC().hashCode();
        }
        if (getUNIT_CD() != null) {
            _hashCode += getUNIT_CD().hashCode();
        }
        if (getITEM_QTY() != null) {
            _hashCode += getITEM_QTY().hashCode();
        }
        if (getRFQ_PRICE() != null) {
            _hashCode += getRFQ_PRICE().hashCode();
        }
        if (getTGT_PRICE() != null) {
            _hashCode += getTGT_PRICE().hashCode();
        }
        if (getLMT_PRICE() != null) {
            _hashCode += getLMT_PRICE().hashCode();
        }
        if (getWH_CD() != null) {
            _hashCode += getWH_CD().hashCode();
        }
        if (getRD_DATE() != null) {
            _hashCode += getRD_DATE().hashCode();
        }
        if (getPRD_SD() != null) {
            _hashCode += getPRD_SD().hashCode();
        }
        if (getPRD_ED() != null) {
            _hashCode += getPRD_ED().hashCode();
        }
        if (getSTL_YN() != null) {
            _hashCode += getSTL_YN().hashCode();
        }
        if (getSTL_QTY() != null) {
            _hashCode += getSTL_QTY().hashCode();
        }
        if (getPRICE_UNIT() != null) {
            _hashCode += getPRICE_UNIT().hashCode();
        }
        if (getCUR() != null) {
            _hashCode += getCUR().hashCode();
        }
        if (getPR_NO() != null) {
            _hashCode += getPR_NO().hashCode();
        }
        if (getPR_LNO() != null) {
            _hashCode += getPR_LNO().hashCode();
        }
        if (getPR_REQ_DATE() != null) {
            _hashCode += getPR_REQ_DATE().hashCode();
        }
        if (getKAMS_PR_NO() != null) {
            _hashCode += getKAMS_PR_NO().hashCode();
        }
        if (getITEM_CATE() != null) {
            _hashCode += getITEM_CATE().hashCode();
        }
        if (getREG_ID() != null) {
            _hashCode += getREG_ID().hashCode();
        }
        if (getWBS() != null) {
            _hashCode += getWBS().hashCode();
        }
        if (getWBS_DESC() != null) {
            _hashCode += getWBS_DESC().hashCode();
        }
        if (getZZAFNAM() != null) {
            _hashCode += getZZAFNAM().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_INFIPA0110_ConBodyRFQ_ITEM.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://infipa.esp.com/k2pkbb", ">>DT_INFIPA0110_Con>Body>RFQ_ITEM"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("COMP_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "COMP_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_CNT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_CNT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_LNO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_LNO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PURC_TYP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PURC_TYP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PLT_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PLT_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ITEM_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ITEM_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ITEM_NM");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ITEM_NM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CHEM_MATL_YN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CHEM_MATL_YN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SPEC");
        elemField.setXmlName(new javax.xml.namespace.QName("", "SPEC"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("UNIT_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "UNIT_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ITEM_QTY");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ITEM_QTY"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_PRICE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_PRICE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("TGT_PRICE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "TGT_PRICE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LMT_PRICE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LMT_PRICE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("WH_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "WH_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RD_DATE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RD_DATE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PRD_SD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PRD_SD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PRD_ED");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PRD_ED"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("STL_YN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "STL_YN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("STL_QTY");
        elemField.setXmlName(new javax.xml.namespace.QName("", "STL_QTY"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PRICE_UNIT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PRICE_UNIT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CUR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CUR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PR_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PR_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PR_LNO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PR_LNO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PR_REQ_DATE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PR_REQ_DATE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("KAMS_PR_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "KAMS_PR_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ITEM_CATE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ITEM_CATE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("REG_ID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "REG_ID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("WBS");
        elemField.setXmlName(new javax.xml.namespace.QName("", "WBS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("WBS_DESC");
        elemField.setXmlName(new javax.xml.namespace.QName("", "WBS_DESC"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZZAFNAM");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ZZAFNAM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
