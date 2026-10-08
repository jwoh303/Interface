/**
 * DT_GRP_MM1460_ConBodyT_DATA.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.grpeccmm.fiber;

public class DT_GRP_MM1460_ConBodyT_DATA  implements java.io.Serializable {
    /* 정보레코드 번호 */
    private java.lang.String INFNR;

    /* 생성/수정/삭제 플래그 */
    private java.lang.String CRUD_FLAG;

    /* 공급업체 번호 */
    private java.lang.String LIFNR;

    /* 자재코드 */
    private java.lang.String MATNR;

    /* 구매조직 */
    private java.lang.String EKORG;

    /* 플랜트 */
    private java.lang.String WERKS;

    /* 정보범주 */
    private java.lang.String ESOKZ;

    /* 지급조건 */
    private java.lang.String ZTERM;

    /* 업체자재번호 */
    private java.lang.String INDNLF;

    /* 제조자 */
    private java.lang.String MFRNR;

    /* 계획 납품기간 */
    private java.lang.String APLFZ;

    /* 구매그룹 */
    private java.lang.String EKGRP;

    /* 확정제어 */
    private java.lang.String BSTAE;

    /* 세금코드 */
    private java.lang.String MWSKZ;

    /* 단가 결정 절차 */
    private java.lang.String EXPRF;

    /* Over-Tolrence */
    private java.lang.String UEBTO;

    /* 인도조건 1 */
    private java.lang.String INCO1;

    /* 인도조건 2 */
    private java.lang.String INCO2;

    /* 효력 시작일 */
    private java.lang.String DATAB;

    /* 효력 종료일 */
    private java.lang.String DATBI;

    /* 구매 요청 번호 */
    private java.lang.String BANFN;

    /* 구매 요청 품목 번호 */
    private java.lang.String BNFPO;

    /* 2차사 Vendor 명칭 */
    private java.lang.String LIFNR_2_NAME;

    /* 여분 */
    private java.lang.String CHAR1;

    /* 여분 */
    private java.lang.String CHAR2;

    /* 여분 */
    private java.lang.String CHAR3;

    /* 여분 */
    private java.lang.String CHAR4;

    /* 여분 */
    private java.lang.String CHAR5;

    /* 단가 */
    private java.lang.String KBETR;

    /* 통화 키 */
    private java.lang.String KONWA;

    /* 오더 단위 */
    private java.lang.String MEINS;

    /* 가격단위 */
    private java.lang.String KPEIN;

    public DT_GRP_MM1460_ConBodyT_DATA() {
    }

    public DT_GRP_MM1460_ConBodyT_DATA(
           java.lang.String INFNR,
           java.lang.String CRUD_FLAG,
           java.lang.String LIFNR,
           java.lang.String MATNR,
           java.lang.String EKORG,
           java.lang.String WERKS,
           java.lang.String ESOKZ,
           java.lang.String ZTERM,
           java.lang.String INDNLF,
           java.lang.String MFRNR,
           java.lang.String APLFZ,
           java.lang.String EKGRP,
           java.lang.String BSTAE,
           java.lang.String MWSKZ,
           java.lang.String EXPRF,
           java.lang.String UEBTO,
           java.lang.String INCO1,
           java.lang.String INCO2,
           java.lang.String DATAB,
           java.lang.String DATBI,
           java.lang.String BANFN,
           java.lang.String BNFPO,
           java.lang.String LIFNR_2_NAME,
           java.lang.String CHAR1,
           java.lang.String CHAR2,
           java.lang.String CHAR3,
           java.lang.String CHAR4,
           java.lang.String CHAR5,
           java.lang.String KBETR,
           java.lang.String KONWA,
           java.lang.String MEINS,
           java.lang.String KPEIN) {
           this.INFNR = INFNR;
           this.CRUD_FLAG = CRUD_FLAG;
           this.LIFNR = LIFNR;
           this.MATNR = MATNR;
           this.EKORG = EKORG;
           this.WERKS = WERKS;
           this.ESOKZ = ESOKZ;
           this.ZTERM = ZTERM;
           this.INDNLF = INDNLF;
           this.MFRNR = MFRNR;
           this.APLFZ = APLFZ;
           this.EKGRP = EKGRP;
           this.BSTAE = BSTAE;
           this.MWSKZ = MWSKZ;
           this.EXPRF = EXPRF;
           this.UEBTO = UEBTO;
           this.INCO1 = INCO1;
           this.INCO2 = INCO2;
           this.DATAB = DATAB;
           this.DATBI = DATBI;
           this.BANFN = BANFN;
           this.BNFPO = BNFPO;
           this.LIFNR_2_NAME = LIFNR_2_NAME;
           this.CHAR1 = CHAR1;
           this.CHAR2 = CHAR2;
           this.CHAR3 = CHAR3;
           this.CHAR4 = CHAR4;
           this.CHAR5 = CHAR5;
           this.KBETR = KBETR;
           this.KONWA = KONWA;
           this.MEINS = MEINS;
           this.KPEIN = KPEIN;
    }


    /**
     * Gets the INFNR value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return INFNR   * 정보레코드 번호
     */
    public java.lang.String getINFNR() {
        return INFNR;
    }


    /**
     * Sets the INFNR value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param INFNR   * 정보레코드 번호
     */
    public void setINFNR(java.lang.String INFNR) {
        this.INFNR = INFNR;
    }


    /**
     * Gets the CRUD_FLAG value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return CRUD_FLAG   * 생성/수정/삭제 플래그
     */
    public java.lang.String getCRUD_FLAG() {
        return CRUD_FLAG;
    }


    /**
     * Sets the CRUD_FLAG value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param CRUD_FLAG   * 생성/수정/삭제 플래그
     */
    public void setCRUD_FLAG(java.lang.String CRUD_FLAG) {
        this.CRUD_FLAG = CRUD_FLAG;
    }


    /**
     * Gets the LIFNR value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return LIFNR   * 공급업체 번호
     */
    public java.lang.String getLIFNR() {
        return LIFNR;
    }


    /**
     * Sets the LIFNR value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param LIFNR   * 공급업체 번호
     */
    public void setLIFNR(java.lang.String LIFNR) {
        this.LIFNR = LIFNR;
    }


    /**
     * Gets the MATNR value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return MATNR   * 자재코드
     */
    public java.lang.String getMATNR() {
        return MATNR;
    }


    /**
     * Sets the MATNR value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param MATNR   * 자재코드
     */
    public void setMATNR(java.lang.String MATNR) {
        this.MATNR = MATNR;
    }


    /**
     * Gets the EKORG value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return EKORG   * 구매조직
     */
    public java.lang.String getEKORG() {
        return EKORG;
    }


    /**
     * Sets the EKORG value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param EKORG   * 구매조직
     */
    public void setEKORG(java.lang.String EKORG) {
        this.EKORG = EKORG;
    }


    /**
     * Gets the WERKS value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return WERKS   * 플랜트
     */
    public java.lang.String getWERKS() {
        return WERKS;
    }


    /**
     * Sets the WERKS value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param WERKS   * 플랜트
     */
    public void setWERKS(java.lang.String WERKS) {
        this.WERKS = WERKS;
    }


    /**
     * Gets the ESOKZ value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return ESOKZ   * 정보범주
     */
    public java.lang.String getESOKZ() {
        return ESOKZ;
    }


    /**
     * Sets the ESOKZ value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param ESOKZ   * 정보범주
     */
    public void setESOKZ(java.lang.String ESOKZ) {
        this.ESOKZ = ESOKZ;
    }


    /**
     * Gets the ZTERM value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return ZTERM   * 지급조건
     */
    public java.lang.String getZTERM() {
        return ZTERM;
    }


    /**
     * Sets the ZTERM value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param ZTERM   * 지급조건
     */
    public void setZTERM(java.lang.String ZTERM) {
        this.ZTERM = ZTERM;
    }


    /**
     * Gets the INDNLF value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return INDNLF   * 업체자재번호
     */
    public java.lang.String getINDNLF() {
        return INDNLF;
    }


    /**
     * Sets the INDNLF value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param INDNLF   * 업체자재번호
     */
    public void setINDNLF(java.lang.String INDNLF) {
        this.INDNLF = INDNLF;
    }


    /**
     * Gets the MFRNR value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return MFRNR   * 제조자
     */
    public java.lang.String getMFRNR() {
        return MFRNR;
    }


    /**
     * Sets the MFRNR value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param MFRNR   * 제조자
     */
    public void setMFRNR(java.lang.String MFRNR) {
        this.MFRNR = MFRNR;
    }


    /**
     * Gets the APLFZ value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return APLFZ   * 계획 납품기간
     */
    public java.lang.String getAPLFZ() {
        return APLFZ;
    }


    /**
     * Sets the APLFZ value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param APLFZ   * 계획 납품기간
     */
    public void setAPLFZ(java.lang.String APLFZ) {
        this.APLFZ = APLFZ;
    }


    /**
     * Gets the EKGRP value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return EKGRP   * 구매그룹
     */
    public java.lang.String getEKGRP() {
        return EKGRP;
    }


    /**
     * Sets the EKGRP value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param EKGRP   * 구매그룹
     */
    public void setEKGRP(java.lang.String EKGRP) {
        this.EKGRP = EKGRP;
    }


    /**
     * Gets the BSTAE value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return BSTAE   * 확정제어
     */
    public java.lang.String getBSTAE() {
        return BSTAE;
    }


    /**
     * Sets the BSTAE value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param BSTAE   * 확정제어
     */
    public void setBSTAE(java.lang.String BSTAE) {
        this.BSTAE = BSTAE;
    }


    /**
     * Gets the MWSKZ value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return MWSKZ   * 세금코드
     */
    public java.lang.String getMWSKZ() {
        return MWSKZ;
    }


    /**
     * Sets the MWSKZ value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param MWSKZ   * 세금코드
     */
    public void setMWSKZ(java.lang.String MWSKZ) {
        this.MWSKZ = MWSKZ;
    }


    /**
     * Gets the EXPRF value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return EXPRF   * 단가 결정 절차
     */
    public java.lang.String getEXPRF() {
        return EXPRF;
    }


    /**
     * Sets the EXPRF value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param EXPRF   * 단가 결정 절차
     */
    public void setEXPRF(java.lang.String EXPRF) {
        this.EXPRF = EXPRF;
    }


    /**
     * Gets the UEBTO value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return UEBTO   * Over-Tolrence
     */
    public java.lang.String getUEBTO() {
        return UEBTO;
    }


    /**
     * Sets the UEBTO value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param UEBTO   * Over-Tolrence
     */
    public void setUEBTO(java.lang.String UEBTO) {
        this.UEBTO = UEBTO;
    }


    /**
     * Gets the INCO1 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return INCO1   * 인도조건 1
     */
    public java.lang.String getINCO1() {
        return INCO1;
    }


    /**
     * Sets the INCO1 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param INCO1   * 인도조건 1
     */
    public void setINCO1(java.lang.String INCO1) {
        this.INCO1 = INCO1;
    }


    /**
     * Gets the INCO2 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return INCO2   * 인도조건 2
     */
    public java.lang.String getINCO2() {
        return INCO2;
    }


    /**
     * Sets the INCO2 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param INCO2   * 인도조건 2
     */
    public void setINCO2(java.lang.String INCO2) {
        this.INCO2 = INCO2;
    }


    /**
     * Gets the DATAB value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return DATAB   * 효력 시작일
     */
    public java.lang.String getDATAB() {
        return DATAB;
    }


    /**
     * Sets the DATAB value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param DATAB   * 효력 시작일
     */
    public void setDATAB(java.lang.String DATAB) {
        this.DATAB = DATAB;
    }


    /**
     * Gets the DATBI value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return DATBI   * 효력 종료일
     */
    public java.lang.String getDATBI() {
        return DATBI;
    }


    /**
     * Sets the DATBI value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param DATBI   * 효력 종료일
     */
    public void setDATBI(java.lang.String DATBI) {
        this.DATBI = DATBI;
    }


    /**
     * Gets the BANFN value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return BANFN   * 구매 요청 번호
     */
    public java.lang.String getBANFN() {
        return BANFN;
    }


    /**
     * Sets the BANFN value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param BANFN   * 구매 요청 번호
     */
    public void setBANFN(java.lang.String BANFN) {
        this.BANFN = BANFN;
    }


    /**
     * Gets the BNFPO value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return BNFPO   * 구매 요청 품목 번호
     */
    public java.lang.String getBNFPO() {
        return BNFPO;
    }


    /**
     * Sets the BNFPO value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param BNFPO   * 구매 요청 품목 번호
     */
    public void setBNFPO(java.lang.String BNFPO) {
        this.BNFPO = BNFPO;
    }


    /**
     * Gets the LIFNR_2_NAME value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return LIFNR_2_NAME   * 2차사 Vendor 명칭
     */
    public java.lang.String getLIFNR_2_NAME() {
        return LIFNR_2_NAME;
    }


    /**
     * Sets the LIFNR_2_NAME value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param LIFNR_2_NAME   * 2차사 Vendor 명칭
     */
    public void setLIFNR_2_NAME(java.lang.String LIFNR_2_NAME) {
        this.LIFNR_2_NAME = LIFNR_2_NAME;
    }


    /**
     * Gets the CHAR1 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return CHAR1   * 여분
     */
    public java.lang.String getCHAR1() {
        return CHAR1;
    }


    /**
     * Sets the CHAR1 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param CHAR1   * 여분
     */
    public void setCHAR1(java.lang.String CHAR1) {
        this.CHAR1 = CHAR1;
    }


    /**
     * Gets the CHAR2 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return CHAR2   * 여분
     */
    public java.lang.String getCHAR2() {
        return CHAR2;
    }


    /**
     * Sets the CHAR2 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param CHAR2   * 여분
     */
    public void setCHAR2(java.lang.String CHAR2) {
        this.CHAR2 = CHAR2;
    }


    /**
     * Gets the CHAR3 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return CHAR3   * 여분
     */
    public java.lang.String getCHAR3() {
        return CHAR3;
    }


    /**
     * Sets the CHAR3 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param CHAR3   * 여분
     */
    public void setCHAR3(java.lang.String CHAR3) {
        this.CHAR3 = CHAR3;
    }


    /**
     * Gets the CHAR4 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return CHAR4   * 여분
     */
    public java.lang.String getCHAR4() {
        return CHAR4;
    }


    /**
     * Sets the CHAR4 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param CHAR4   * 여분
     */
    public void setCHAR4(java.lang.String CHAR4) {
        this.CHAR4 = CHAR4;
    }


    /**
     * Gets the CHAR5 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return CHAR5   * 여분
     */
    public java.lang.String getCHAR5() {
        return CHAR5;
    }


    /**
     * Sets the CHAR5 value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param CHAR5   * 여분
     */
    public void setCHAR5(java.lang.String CHAR5) {
        this.CHAR5 = CHAR5;
    }


    /**
     * Gets the KBETR value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return KBETR   * 단가
     */
    public java.lang.String getKBETR() {
        return KBETR;
    }


    /**
     * Sets the KBETR value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param KBETR   * 단가
     */
    public void setKBETR(java.lang.String KBETR) {
        this.KBETR = KBETR;
    }


    /**
     * Gets the KONWA value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return KONWA   * 통화 키
     */
    public java.lang.String getKONWA() {
        return KONWA;
    }


    /**
     * Sets the KONWA value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param KONWA   * 통화 키
     */
    public void setKONWA(java.lang.String KONWA) {
        this.KONWA = KONWA;
    }


    /**
     * Gets the MEINS value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return MEINS   * 오더 단위
     */
    public java.lang.String getMEINS() {
        return MEINS;
    }


    /**
     * Sets the MEINS value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param MEINS   * 오더 단위
     */
    public void setMEINS(java.lang.String MEINS) {
        this.MEINS = MEINS;
    }


    /**
     * Gets the KPEIN value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @return KPEIN   * 가격단위
     */
    public java.lang.String getKPEIN() {
        return KPEIN;
    }


    /**
     * Sets the KPEIN value for this DT_GRP_MM1460_ConBodyT_DATA.
     * 
     * @param KPEIN   * 가격단위
     */
    public void setKPEIN(java.lang.String KPEIN) {
        this.KPEIN = KPEIN;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_GRP_MM1460_ConBodyT_DATA)) return false;
        DT_GRP_MM1460_ConBodyT_DATA other = (DT_GRP_MM1460_ConBodyT_DATA) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.INFNR==null && other.getINFNR()==null) || 
             (this.INFNR!=null &&
              this.INFNR.equals(other.getINFNR()))) &&
            ((this.CRUD_FLAG==null && other.getCRUD_FLAG()==null) || 
             (this.CRUD_FLAG!=null &&
              this.CRUD_FLAG.equals(other.getCRUD_FLAG()))) &&
            ((this.LIFNR==null && other.getLIFNR()==null) || 
             (this.LIFNR!=null &&
              this.LIFNR.equals(other.getLIFNR()))) &&
            ((this.MATNR==null && other.getMATNR()==null) || 
             (this.MATNR!=null &&
              this.MATNR.equals(other.getMATNR()))) &&
            ((this.EKORG==null && other.getEKORG()==null) || 
             (this.EKORG!=null &&
              this.EKORG.equals(other.getEKORG()))) &&
            ((this.WERKS==null && other.getWERKS()==null) || 
             (this.WERKS!=null &&
              this.WERKS.equals(other.getWERKS()))) &&
            ((this.ESOKZ==null && other.getESOKZ()==null) || 
             (this.ESOKZ!=null &&
              this.ESOKZ.equals(other.getESOKZ()))) &&
            ((this.ZTERM==null && other.getZTERM()==null) || 
             (this.ZTERM!=null &&
              this.ZTERM.equals(other.getZTERM()))) &&
            ((this.INDNLF==null && other.getINDNLF()==null) || 
             (this.INDNLF!=null &&
              this.INDNLF.equals(other.getINDNLF()))) &&
            ((this.MFRNR==null && other.getMFRNR()==null) || 
             (this.MFRNR!=null &&
              this.MFRNR.equals(other.getMFRNR()))) &&
            ((this.APLFZ==null && other.getAPLFZ()==null) || 
             (this.APLFZ!=null &&
              this.APLFZ.equals(other.getAPLFZ()))) &&
            ((this.EKGRP==null && other.getEKGRP()==null) || 
             (this.EKGRP!=null &&
              this.EKGRP.equals(other.getEKGRP()))) &&
            ((this.BSTAE==null && other.getBSTAE()==null) || 
             (this.BSTAE!=null &&
              this.BSTAE.equals(other.getBSTAE()))) &&
            ((this.MWSKZ==null && other.getMWSKZ()==null) || 
             (this.MWSKZ!=null &&
              this.MWSKZ.equals(other.getMWSKZ()))) &&
            ((this.EXPRF==null && other.getEXPRF()==null) || 
             (this.EXPRF!=null &&
              this.EXPRF.equals(other.getEXPRF()))) &&
            ((this.UEBTO==null && other.getUEBTO()==null) || 
             (this.UEBTO!=null &&
              this.UEBTO.equals(other.getUEBTO()))) &&
            ((this.INCO1==null && other.getINCO1()==null) || 
             (this.INCO1!=null &&
              this.INCO1.equals(other.getINCO1()))) &&
            ((this.INCO2==null && other.getINCO2()==null) || 
             (this.INCO2!=null &&
              this.INCO2.equals(other.getINCO2()))) &&
            ((this.DATAB==null && other.getDATAB()==null) || 
             (this.DATAB!=null &&
              this.DATAB.equals(other.getDATAB()))) &&
            ((this.DATBI==null && other.getDATBI()==null) || 
             (this.DATBI!=null &&
              this.DATBI.equals(other.getDATBI()))) &&
            ((this.BANFN==null && other.getBANFN()==null) || 
             (this.BANFN!=null &&
              this.BANFN.equals(other.getBANFN()))) &&
            ((this.BNFPO==null && other.getBNFPO()==null) || 
             (this.BNFPO!=null &&
              this.BNFPO.equals(other.getBNFPO()))) &&
            ((this.LIFNR_2_NAME==null && other.getLIFNR_2_NAME()==null) || 
             (this.LIFNR_2_NAME!=null &&
              this.LIFNR_2_NAME.equals(other.getLIFNR_2_NAME()))) &&
            ((this.CHAR1==null && other.getCHAR1()==null) || 
             (this.CHAR1!=null &&
              this.CHAR1.equals(other.getCHAR1()))) &&
            ((this.CHAR2==null && other.getCHAR2()==null) || 
             (this.CHAR2!=null &&
              this.CHAR2.equals(other.getCHAR2()))) &&
            ((this.CHAR3==null && other.getCHAR3()==null) || 
             (this.CHAR3!=null &&
              this.CHAR3.equals(other.getCHAR3()))) &&
            ((this.CHAR4==null && other.getCHAR4()==null) || 
             (this.CHAR4!=null &&
              this.CHAR4.equals(other.getCHAR4()))) &&
            ((this.CHAR5==null && other.getCHAR5()==null) || 
             (this.CHAR5!=null &&
              this.CHAR5.equals(other.getCHAR5()))) &&
            ((this.KBETR==null && other.getKBETR()==null) || 
             (this.KBETR!=null &&
              this.KBETR.equals(other.getKBETR()))) &&
            ((this.KONWA==null && other.getKONWA()==null) || 
             (this.KONWA!=null &&
              this.KONWA.equals(other.getKONWA()))) &&
            ((this.MEINS==null && other.getMEINS()==null) || 
             (this.MEINS!=null &&
              this.MEINS.equals(other.getMEINS()))) &&
            ((this.KPEIN==null && other.getKPEIN()==null) || 
             (this.KPEIN!=null &&
              this.KPEIN.equals(other.getKPEIN())));
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
        if (getINFNR() != null) {
            _hashCode += getINFNR().hashCode();
        }
        if (getCRUD_FLAG() != null) {
            _hashCode += getCRUD_FLAG().hashCode();
        }
        if (getLIFNR() != null) {
            _hashCode += getLIFNR().hashCode();
        }
        if (getMATNR() != null) {
            _hashCode += getMATNR().hashCode();
        }
        if (getEKORG() != null) {
            _hashCode += getEKORG().hashCode();
        }
        if (getWERKS() != null) {
            _hashCode += getWERKS().hashCode();
        }
        if (getESOKZ() != null) {
            _hashCode += getESOKZ().hashCode();
        }
        if (getZTERM() != null) {
            _hashCode += getZTERM().hashCode();
        }
        if (getINDNLF() != null) {
            _hashCode += getINDNLF().hashCode();
        }
        if (getMFRNR() != null) {
            _hashCode += getMFRNR().hashCode();
        }
        if (getAPLFZ() != null) {
            _hashCode += getAPLFZ().hashCode();
        }
        if (getEKGRP() != null) {
            _hashCode += getEKGRP().hashCode();
        }
        if (getBSTAE() != null) {
            _hashCode += getBSTAE().hashCode();
        }
        if (getMWSKZ() != null) {
            _hashCode += getMWSKZ().hashCode();
        }
        if (getEXPRF() != null) {
            _hashCode += getEXPRF().hashCode();
        }
        if (getUEBTO() != null) {
            _hashCode += getUEBTO().hashCode();
        }
        if (getINCO1() != null) {
            _hashCode += getINCO1().hashCode();
        }
        if (getINCO2() != null) {
            _hashCode += getINCO2().hashCode();
        }
        if (getDATAB() != null) {
            _hashCode += getDATAB().hashCode();
        }
        if (getDATBI() != null) {
            _hashCode += getDATBI().hashCode();
        }
        if (getBANFN() != null) {
            _hashCode += getBANFN().hashCode();
        }
        if (getBNFPO() != null) {
            _hashCode += getBNFPO().hashCode();
        }
        if (getLIFNR_2_NAME() != null) {
            _hashCode += getLIFNR_2_NAME().hashCode();
        }
        if (getCHAR1() != null) {
            _hashCode += getCHAR1().hashCode();
        }
        if (getCHAR2() != null) {
            _hashCode += getCHAR2().hashCode();
        }
        if (getCHAR3() != null) {
            _hashCode += getCHAR3().hashCode();
        }
        if (getCHAR4() != null) {
            _hashCode += getCHAR4().hashCode();
        }
        if (getCHAR5() != null) {
            _hashCode += getCHAR5().hashCode();
        }
        if (getKBETR() != null) {
            _hashCode += getKBETR().hashCode();
        }
        if (getKONWA() != null) {
            _hashCode += getKONWA().hashCode();
        }
        if (getMEINS() != null) {
            _hashCode += getMEINS().hashCode();
        }
        if (getKPEIN() != null) {
            _hashCode += getKPEIN().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_GRP_MM1460_ConBodyT_DATA.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://grpeccmm.esp.com/k2pkbb", ">>DT_GRP_MM1460_Con>Body>T_DATA"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("INFNR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "INFNR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CRUD_FLAG");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CRUD_FLAG"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LIFNR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LIFNR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MATNR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "MATNR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("EKORG");
        elemField.setXmlName(new javax.xml.namespace.QName("", "EKORG"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("WERKS");
        elemField.setXmlName(new javax.xml.namespace.QName("", "WERKS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ESOKZ");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ESOKZ"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZTERM");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ZTERM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("INDNLF");
        elemField.setXmlName(new javax.xml.namespace.QName("", "INDNLF"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MFRNR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "MFRNR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APLFZ");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APLFZ"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("EKGRP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "EKGRP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("BSTAE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "BSTAE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MWSKZ");
        elemField.setXmlName(new javax.xml.namespace.QName("", "MWSKZ"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("EXPRF");
        elemField.setXmlName(new javax.xml.namespace.QName("", "EXPRF"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("UEBTO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "UEBTO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("INCO1");
        elemField.setXmlName(new javax.xml.namespace.QName("", "INCO1"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("INCO2");
        elemField.setXmlName(new javax.xml.namespace.QName("", "INCO2"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DATAB");
        elemField.setXmlName(new javax.xml.namespace.QName("", "DATAB"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DATBI");
        elemField.setXmlName(new javax.xml.namespace.QName("", "DATBI"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("BANFN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "BANFN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("BNFPO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "BNFPO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LIFNR_2_NAME");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LIFNR_2_NAME"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CHAR1");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CHAR1"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CHAR2");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CHAR2"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CHAR3");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CHAR3"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CHAR4");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CHAR4"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CHAR5");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CHAR5"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("KBETR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "KBETR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("KONWA");
        elemField.setXmlName(new javax.xml.namespace.QName("", "KONWA"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MEINS");
        elemField.setXmlName(new javax.xml.namespace.QName("", "MEINS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("KPEIN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "KPEIN"));
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
