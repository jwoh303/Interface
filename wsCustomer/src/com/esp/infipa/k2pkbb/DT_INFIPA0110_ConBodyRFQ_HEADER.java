/**
 * DT_INFIPA0110_ConBodyRFQ_HEADER.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.infipa.k2pkbb;

public class DT_INFIPA0110_ConBodyRFQ_HEADER  implements java.io.Serializable {
    /* Business Model */
    private java.lang.String BIZ_CLS;

    /* 회사코드 */
    private java.lang.String COMP_CD;

    /* KeP 견적요청번호 */
    private java.lang.String RFQ_NO;

    /* 견적요청차수 */
    private java.lang.String RFQ_CNT;

    /* 견적요청제목 */
    private java.lang.String RFQ_TIT;

    /* RFx요청유형 */
    private java.lang.String RFQ_REQ_TYP;

    /* RFX유형 */
    private java.lang.String RFX_TYP;

    /* 입찰방식 */
    private java.lang.String BID_TYP;

    /* 경쟁 방식 */
    private java.lang.String CPT_TYPE_CD;

    /* 업체선정방식 */
    private java.lang.String VD_STL_TYP;

    /* 가격선정방식 */
    private java.lang.String PRC_STL_TYP;

    /* 견적요청일자 */
    private java.lang.String RFQ_DATE;

    /* 견적요청시작일시 */
    private java.lang.String RFQ_START_DT;

    /* 견적요청마감일시 */
    private java.lang.String RFQ_CLOSE_DT;

    /* 견적요청변경마감일시 */
    private java.lang.String RFQ_MOD_CLOSE_DT;

    /* 구매그룹코드 */
    private java.lang.String PURC_GRP_CD;

    /* 견적기준통화 */
    private java.lang.String RFQ_CUR;

    /* 내외자구분 */
    private java.lang.String SHIPPER_TYPE;

    /* 구매 유형 */
    private java.lang.String PURC_TYP;

    /* 견적요청 진행상태 */
    private java.lang.String RFQ_PROG_STS;

    /* 견적요청 종료상태 */
    private java.lang.String RFQ_END_STS;

    /* 지체상금율 */
    private java.lang.String DELAY_RATE;

    public DT_INFIPA0110_ConBodyRFQ_HEADER() {
    }

    public DT_INFIPA0110_ConBodyRFQ_HEADER(
           java.lang.String BIZ_CLS,
           java.lang.String COMP_CD,
           java.lang.String RFQ_NO,
           java.lang.String RFQ_CNT,
           java.lang.String RFQ_TIT,
           java.lang.String RFQ_REQ_TYP,
           java.lang.String RFX_TYP,
           java.lang.String BID_TYP,
           java.lang.String CPT_TYPE_CD,
           java.lang.String VD_STL_TYP,
           java.lang.String PRC_STL_TYP,
           java.lang.String RFQ_DATE,
           java.lang.String RFQ_START_DT,
           java.lang.String RFQ_CLOSE_DT,
           java.lang.String RFQ_MOD_CLOSE_DT,
           java.lang.String PURC_GRP_CD,
           java.lang.String RFQ_CUR,
           java.lang.String SHIPPER_TYPE,
           java.lang.String PURC_TYP,
           java.lang.String RFQ_PROG_STS,
           java.lang.String RFQ_END_STS,
           java.lang.String DELAY_RATE) {
           this.BIZ_CLS = BIZ_CLS;
           this.COMP_CD = COMP_CD;
           this.RFQ_NO = RFQ_NO;
           this.RFQ_CNT = RFQ_CNT;
           this.RFQ_TIT = RFQ_TIT;
           this.RFQ_REQ_TYP = RFQ_REQ_TYP;
           this.RFX_TYP = RFX_TYP;
           this.BID_TYP = BID_TYP;
           this.CPT_TYPE_CD = CPT_TYPE_CD;
           this.VD_STL_TYP = VD_STL_TYP;
           this.PRC_STL_TYP = PRC_STL_TYP;
           this.RFQ_DATE = RFQ_DATE;
           this.RFQ_START_DT = RFQ_START_DT;
           this.RFQ_CLOSE_DT = RFQ_CLOSE_DT;
           this.RFQ_MOD_CLOSE_DT = RFQ_MOD_CLOSE_DT;
           this.PURC_GRP_CD = PURC_GRP_CD;
           this.RFQ_CUR = RFQ_CUR;
           this.SHIPPER_TYPE = SHIPPER_TYPE;
           this.PURC_TYP = PURC_TYP;
           this.RFQ_PROG_STS = RFQ_PROG_STS;
           this.RFQ_END_STS = RFQ_END_STS;
           this.DELAY_RATE = DELAY_RATE;
    }


    /**
     * Gets the BIZ_CLS value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return BIZ_CLS   * Business Model
     */
    public java.lang.String getBIZ_CLS() {
        return BIZ_CLS;
    }


    /**
     * Sets the BIZ_CLS value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param BIZ_CLS   * Business Model
     */
    public void setBIZ_CLS(java.lang.String BIZ_CLS) {
        this.BIZ_CLS = BIZ_CLS;
    }


    /**
     * Gets the COMP_CD value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return COMP_CD   * 회사코드
     */
    public java.lang.String getCOMP_CD() {
        return COMP_CD;
    }


    /**
     * Sets the COMP_CD value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param COMP_CD   * 회사코드
     */
    public void setCOMP_CD(java.lang.String COMP_CD) {
        this.COMP_CD = COMP_CD;
    }


    /**
     * Gets the RFQ_NO value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFQ_NO   * KeP 견적요청번호
     */
    public java.lang.String getRFQ_NO() {
        return RFQ_NO;
    }


    /**
     * Sets the RFQ_NO value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFQ_NO   * KeP 견적요청번호
     */
    public void setRFQ_NO(java.lang.String RFQ_NO) {
        this.RFQ_NO = RFQ_NO;
    }


    /**
     * Gets the RFQ_CNT value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFQ_CNT   * 견적요청차수
     */
    public java.lang.String getRFQ_CNT() {
        return RFQ_CNT;
    }


    /**
     * Sets the RFQ_CNT value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFQ_CNT   * 견적요청차수
     */
    public void setRFQ_CNT(java.lang.String RFQ_CNT) {
        this.RFQ_CNT = RFQ_CNT;
    }


    /**
     * Gets the RFQ_TIT value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFQ_TIT   * 견적요청제목
     */
    public java.lang.String getRFQ_TIT() {
        return RFQ_TIT;
    }


    /**
     * Sets the RFQ_TIT value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFQ_TIT   * 견적요청제목
     */
    public void setRFQ_TIT(java.lang.String RFQ_TIT) {
        this.RFQ_TIT = RFQ_TIT;
    }


    /**
     * Gets the RFQ_REQ_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFQ_REQ_TYP   * RFx요청유형
     */
    public java.lang.String getRFQ_REQ_TYP() {
        return RFQ_REQ_TYP;
    }


    /**
     * Sets the RFQ_REQ_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFQ_REQ_TYP   * RFx요청유형
     */
    public void setRFQ_REQ_TYP(java.lang.String RFQ_REQ_TYP) {
        this.RFQ_REQ_TYP = RFQ_REQ_TYP;
    }


    /**
     * Gets the RFX_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFX_TYP   * RFX유형
     */
    public java.lang.String getRFX_TYP() {
        return RFX_TYP;
    }


    /**
     * Sets the RFX_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFX_TYP   * RFX유형
     */
    public void setRFX_TYP(java.lang.String RFX_TYP) {
        this.RFX_TYP = RFX_TYP;
    }


    /**
     * Gets the BID_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return BID_TYP   * 입찰방식
     */
    public java.lang.String getBID_TYP() {
        return BID_TYP;
    }


    /**
     * Sets the BID_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param BID_TYP   * 입찰방식
     */
    public void setBID_TYP(java.lang.String BID_TYP) {
        this.BID_TYP = BID_TYP;
    }


    /**
     * Gets the CPT_TYPE_CD value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return CPT_TYPE_CD   * 경쟁 방식
     */
    public java.lang.String getCPT_TYPE_CD() {
        return CPT_TYPE_CD;
    }


    /**
     * Sets the CPT_TYPE_CD value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param CPT_TYPE_CD   * 경쟁 방식
     */
    public void setCPT_TYPE_CD(java.lang.String CPT_TYPE_CD) {
        this.CPT_TYPE_CD = CPT_TYPE_CD;
    }


    /**
     * Gets the VD_STL_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return VD_STL_TYP   * 업체선정방식
     */
    public java.lang.String getVD_STL_TYP() {
        return VD_STL_TYP;
    }


    /**
     * Sets the VD_STL_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param VD_STL_TYP   * 업체선정방식
     */
    public void setVD_STL_TYP(java.lang.String VD_STL_TYP) {
        this.VD_STL_TYP = VD_STL_TYP;
    }


    /**
     * Gets the PRC_STL_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return PRC_STL_TYP   * 가격선정방식
     */
    public java.lang.String getPRC_STL_TYP() {
        return PRC_STL_TYP;
    }


    /**
     * Sets the PRC_STL_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param PRC_STL_TYP   * 가격선정방식
     */
    public void setPRC_STL_TYP(java.lang.String PRC_STL_TYP) {
        this.PRC_STL_TYP = PRC_STL_TYP;
    }


    /**
     * Gets the RFQ_DATE value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFQ_DATE   * 견적요청일자
     */
    public java.lang.String getRFQ_DATE() {
        return RFQ_DATE;
    }


    /**
     * Sets the RFQ_DATE value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFQ_DATE   * 견적요청일자
     */
    public void setRFQ_DATE(java.lang.String RFQ_DATE) {
        this.RFQ_DATE = RFQ_DATE;
    }


    /**
     * Gets the RFQ_START_DT value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFQ_START_DT   * 견적요청시작일시
     */
    public java.lang.String getRFQ_START_DT() {
        return RFQ_START_DT;
    }


    /**
     * Sets the RFQ_START_DT value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFQ_START_DT   * 견적요청시작일시
     */
    public void setRFQ_START_DT(java.lang.String RFQ_START_DT) {
        this.RFQ_START_DT = RFQ_START_DT;
    }


    /**
     * Gets the RFQ_CLOSE_DT value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFQ_CLOSE_DT   * 견적요청마감일시
     */
    public java.lang.String getRFQ_CLOSE_DT() {
        return RFQ_CLOSE_DT;
    }


    /**
     * Sets the RFQ_CLOSE_DT value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFQ_CLOSE_DT   * 견적요청마감일시
     */
    public void setRFQ_CLOSE_DT(java.lang.String RFQ_CLOSE_DT) {
        this.RFQ_CLOSE_DT = RFQ_CLOSE_DT;
    }


    /**
     * Gets the RFQ_MOD_CLOSE_DT value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFQ_MOD_CLOSE_DT   * 견적요청변경마감일시
     */
    public java.lang.String getRFQ_MOD_CLOSE_DT() {
        return RFQ_MOD_CLOSE_DT;
    }


    /**
     * Sets the RFQ_MOD_CLOSE_DT value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFQ_MOD_CLOSE_DT   * 견적요청변경마감일시
     */
    public void setRFQ_MOD_CLOSE_DT(java.lang.String RFQ_MOD_CLOSE_DT) {
        this.RFQ_MOD_CLOSE_DT = RFQ_MOD_CLOSE_DT;
    }


    /**
     * Gets the PURC_GRP_CD value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return PURC_GRP_CD   * 구매그룹코드
     */
    public java.lang.String getPURC_GRP_CD() {
        return PURC_GRP_CD;
    }


    /**
     * Sets the PURC_GRP_CD value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param PURC_GRP_CD   * 구매그룹코드
     */
    public void setPURC_GRP_CD(java.lang.String PURC_GRP_CD) {
        this.PURC_GRP_CD = PURC_GRP_CD;
    }


    /**
     * Gets the RFQ_CUR value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFQ_CUR   * 견적기준통화
     */
    public java.lang.String getRFQ_CUR() {
        return RFQ_CUR;
    }


    /**
     * Sets the RFQ_CUR value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFQ_CUR   * 견적기준통화
     */
    public void setRFQ_CUR(java.lang.String RFQ_CUR) {
        this.RFQ_CUR = RFQ_CUR;
    }


    /**
     * Gets the SHIPPER_TYPE value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return SHIPPER_TYPE   * 내외자구분
     */
    public java.lang.String getSHIPPER_TYPE() {
        return SHIPPER_TYPE;
    }


    /**
     * Sets the SHIPPER_TYPE value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param SHIPPER_TYPE   * 내외자구분
     */
    public void setSHIPPER_TYPE(java.lang.String SHIPPER_TYPE) {
        this.SHIPPER_TYPE = SHIPPER_TYPE;
    }


    /**
     * Gets the PURC_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return PURC_TYP   * 구매 유형
     */
    public java.lang.String getPURC_TYP() {
        return PURC_TYP;
    }


    /**
     * Sets the PURC_TYP value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param PURC_TYP   * 구매 유형
     */
    public void setPURC_TYP(java.lang.String PURC_TYP) {
        this.PURC_TYP = PURC_TYP;
    }


    /**
     * Gets the RFQ_PROG_STS value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFQ_PROG_STS   * 견적요청 진행상태
     */
    public java.lang.String getRFQ_PROG_STS() {
        return RFQ_PROG_STS;
    }


    /**
     * Sets the RFQ_PROG_STS value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFQ_PROG_STS   * 견적요청 진행상태
     */
    public void setRFQ_PROG_STS(java.lang.String RFQ_PROG_STS) {
        this.RFQ_PROG_STS = RFQ_PROG_STS;
    }


    /**
     * Gets the RFQ_END_STS value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return RFQ_END_STS   * 견적요청 종료상태
     */
    public java.lang.String getRFQ_END_STS() {
        return RFQ_END_STS;
    }


    /**
     * Sets the RFQ_END_STS value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param RFQ_END_STS   * 견적요청 종료상태
     */
    public void setRFQ_END_STS(java.lang.String RFQ_END_STS) {
        this.RFQ_END_STS = RFQ_END_STS;
    }


    /**
     * Gets the DELAY_RATE value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @return DELAY_RATE   * 지체상금율
     */
    public java.lang.String getDELAY_RATE() {
        return DELAY_RATE;
    }


    /**
     * Sets the DELAY_RATE value for this DT_INFIPA0110_ConBodyRFQ_HEADER.
     * 
     * @param DELAY_RATE   * 지체상금율
     */
    public void setDELAY_RATE(java.lang.String DELAY_RATE) {
        this.DELAY_RATE = DELAY_RATE;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_INFIPA0110_ConBodyRFQ_HEADER)) return false;
        DT_INFIPA0110_ConBodyRFQ_HEADER other = (DT_INFIPA0110_ConBodyRFQ_HEADER) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.BIZ_CLS==null && other.getBIZ_CLS()==null) || 
             (this.BIZ_CLS!=null &&
              this.BIZ_CLS.equals(other.getBIZ_CLS()))) &&
            ((this.COMP_CD==null && other.getCOMP_CD()==null) || 
             (this.COMP_CD!=null &&
              this.COMP_CD.equals(other.getCOMP_CD()))) &&
            ((this.RFQ_NO==null && other.getRFQ_NO()==null) || 
             (this.RFQ_NO!=null &&
              this.RFQ_NO.equals(other.getRFQ_NO()))) &&
            ((this.RFQ_CNT==null && other.getRFQ_CNT()==null) || 
             (this.RFQ_CNT!=null &&
              this.RFQ_CNT.equals(other.getRFQ_CNT()))) &&
            ((this.RFQ_TIT==null && other.getRFQ_TIT()==null) || 
             (this.RFQ_TIT!=null &&
              this.RFQ_TIT.equals(other.getRFQ_TIT()))) &&
            ((this.RFQ_REQ_TYP==null && other.getRFQ_REQ_TYP()==null) || 
             (this.RFQ_REQ_TYP!=null &&
              this.RFQ_REQ_TYP.equals(other.getRFQ_REQ_TYP()))) &&
            ((this.RFX_TYP==null && other.getRFX_TYP()==null) || 
             (this.RFX_TYP!=null &&
              this.RFX_TYP.equals(other.getRFX_TYP()))) &&
            ((this.BID_TYP==null && other.getBID_TYP()==null) || 
             (this.BID_TYP!=null &&
              this.BID_TYP.equals(other.getBID_TYP()))) &&
            ((this.CPT_TYPE_CD==null && other.getCPT_TYPE_CD()==null) || 
             (this.CPT_TYPE_CD!=null &&
              this.CPT_TYPE_CD.equals(other.getCPT_TYPE_CD()))) &&
            ((this.VD_STL_TYP==null && other.getVD_STL_TYP()==null) || 
             (this.VD_STL_TYP!=null &&
              this.VD_STL_TYP.equals(other.getVD_STL_TYP()))) &&
            ((this.PRC_STL_TYP==null && other.getPRC_STL_TYP()==null) || 
             (this.PRC_STL_TYP!=null &&
              this.PRC_STL_TYP.equals(other.getPRC_STL_TYP()))) &&
            ((this.RFQ_DATE==null && other.getRFQ_DATE()==null) || 
             (this.RFQ_DATE!=null &&
              this.RFQ_DATE.equals(other.getRFQ_DATE()))) &&
            ((this.RFQ_START_DT==null && other.getRFQ_START_DT()==null) || 
             (this.RFQ_START_DT!=null &&
              this.RFQ_START_DT.equals(other.getRFQ_START_DT()))) &&
            ((this.RFQ_CLOSE_DT==null && other.getRFQ_CLOSE_DT()==null) || 
             (this.RFQ_CLOSE_DT!=null &&
              this.RFQ_CLOSE_DT.equals(other.getRFQ_CLOSE_DT()))) &&
            ((this.RFQ_MOD_CLOSE_DT==null && other.getRFQ_MOD_CLOSE_DT()==null) || 
             (this.RFQ_MOD_CLOSE_DT!=null &&
              this.RFQ_MOD_CLOSE_DT.equals(other.getRFQ_MOD_CLOSE_DT()))) &&
            ((this.PURC_GRP_CD==null && other.getPURC_GRP_CD()==null) || 
             (this.PURC_GRP_CD!=null &&
              this.PURC_GRP_CD.equals(other.getPURC_GRP_CD()))) &&
            ((this.RFQ_CUR==null && other.getRFQ_CUR()==null) || 
             (this.RFQ_CUR!=null &&
              this.RFQ_CUR.equals(other.getRFQ_CUR()))) &&
            ((this.SHIPPER_TYPE==null && other.getSHIPPER_TYPE()==null) || 
             (this.SHIPPER_TYPE!=null &&
              this.SHIPPER_TYPE.equals(other.getSHIPPER_TYPE()))) &&
            ((this.PURC_TYP==null && other.getPURC_TYP()==null) || 
             (this.PURC_TYP!=null &&
              this.PURC_TYP.equals(other.getPURC_TYP()))) &&
            ((this.RFQ_PROG_STS==null && other.getRFQ_PROG_STS()==null) || 
             (this.RFQ_PROG_STS!=null &&
              this.RFQ_PROG_STS.equals(other.getRFQ_PROG_STS()))) &&
            ((this.RFQ_END_STS==null && other.getRFQ_END_STS()==null) || 
             (this.RFQ_END_STS!=null &&
              this.RFQ_END_STS.equals(other.getRFQ_END_STS()))) &&
            ((this.DELAY_RATE==null && other.getDELAY_RATE()==null) || 
             (this.DELAY_RATE!=null &&
              this.DELAY_RATE.equals(other.getDELAY_RATE())));
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
        if (getBIZ_CLS() != null) {
            _hashCode += getBIZ_CLS().hashCode();
        }
        if (getCOMP_CD() != null) {
            _hashCode += getCOMP_CD().hashCode();
        }
        if (getRFQ_NO() != null) {
            _hashCode += getRFQ_NO().hashCode();
        }
        if (getRFQ_CNT() != null) {
            _hashCode += getRFQ_CNT().hashCode();
        }
        if (getRFQ_TIT() != null) {
            _hashCode += getRFQ_TIT().hashCode();
        }
        if (getRFQ_REQ_TYP() != null) {
            _hashCode += getRFQ_REQ_TYP().hashCode();
        }
        if (getRFX_TYP() != null) {
            _hashCode += getRFX_TYP().hashCode();
        }
        if (getBID_TYP() != null) {
            _hashCode += getBID_TYP().hashCode();
        }
        if (getCPT_TYPE_CD() != null) {
            _hashCode += getCPT_TYPE_CD().hashCode();
        }
        if (getVD_STL_TYP() != null) {
            _hashCode += getVD_STL_TYP().hashCode();
        }
        if (getPRC_STL_TYP() != null) {
            _hashCode += getPRC_STL_TYP().hashCode();
        }
        if (getRFQ_DATE() != null) {
            _hashCode += getRFQ_DATE().hashCode();
        }
        if (getRFQ_START_DT() != null) {
            _hashCode += getRFQ_START_DT().hashCode();
        }
        if (getRFQ_CLOSE_DT() != null) {
            _hashCode += getRFQ_CLOSE_DT().hashCode();
        }
        if (getRFQ_MOD_CLOSE_DT() != null) {
            _hashCode += getRFQ_MOD_CLOSE_DT().hashCode();
        }
        if (getPURC_GRP_CD() != null) {
            _hashCode += getPURC_GRP_CD().hashCode();
        }
        if (getRFQ_CUR() != null) {
            _hashCode += getRFQ_CUR().hashCode();
        }
        if (getSHIPPER_TYPE() != null) {
            _hashCode += getSHIPPER_TYPE().hashCode();
        }
        if (getPURC_TYP() != null) {
            _hashCode += getPURC_TYP().hashCode();
        }
        if (getRFQ_PROG_STS() != null) {
            _hashCode += getRFQ_PROG_STS().hashCode();
        }
        if (getRFQ_END_STS() != null) {
            _hashCode += getRFQ_END_STS().hashCode();
        }
        if (getDELAY_RATE() != null) {
            _hashCode += getDELAY_RATE().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_INFIPA0110_ConBodyRFQ_HEADER.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://infipa.esp.com/k2pkbb", ">>DT_INFIPA0110_Con>Body>RFQ_HEADER"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("BIZ_CLS");
        elemField.setXmlName(new javax.xml.namespace.QName("", "BIZ_CLS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
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
        elemField.setFieldName("RFQ_TIT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_TIT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_REQ_TYP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_REQ_TYP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFX_TYP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFX_TYP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("BID_TYP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "BID_TYP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CPT_TYPE_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CPT_TYPE_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("VD_STL_TYP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "VD_STL_TYP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PRC_STL_TYP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PRC_STL_TYP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_DATE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_DATE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_START_DT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_START_DT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_CLOSE_DT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_CLOSE_DT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_MOD_CLOSE_DT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_MOD_CLOSE_DT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PURC_GRP_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PURC_GRP_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_CUR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_CUR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SHIPPER_TYPE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "SHIPPER_TYPE"));
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
        elemField.setFieldName("RFQ_PROG_STS");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_PROG_STS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_END_STS");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_END_STS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DELAY_RATE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "DELAY_RATE"));
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
