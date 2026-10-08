/**
 * DT_INFIPA0110_ConBodyQTA_ITEM.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.infipa.k2pkbb;

public class DT_INFIPA0110_ConBodyQTA_ITEM  implements java.io.Serializable {
    /* 회사 코드 */
    private java.lang.String COMP_CD;

    /* 업체 코드 */
    private java.lang.String VD_CD;

    /* KeP 견적번호 */
    private java.lang.String QTA_NO;

    /* 견적 회수 */
    private java.lang.String QTA_CNT;

    /* 견적 항번 */
    private java.lang.String QTA_LNO;

    /* KeP 견적요청번호 */
    private java.lang.String RFQ_NO;

    /* 견적요청 회수 */
    private java.lang.String RFQ_CNT;

    /* 견적요청 항번 */
    private java.lang.String RFQ_LNO;

    /* 품목 코드 */
    private java.lang.String ITEM_CD;

    /* 품목 명 */
    private java.lang.String ITEM_NM;

    /* 규격 */
    private java.lang.String SPEC;

    /* 단위 코드 */
    private java.lang.String UNIT_CD;

    /* 품목 수량 */
    private java.lang.String ITEM_QTY;

    /* 품목 단가 */
    private java.lang.String ITEM_PRICE;

    /* 품목 금액 */
    private java.lang.String ITEM_AMT;

    /* 선정 수량 */
    private java.lang.String STL_QTY;

    /* 선정 여부 */
    private java.lang.String STL_YN;

    /* 비고 */
    private java.lang.String REM;

    /* 구매요청 번호 */
    private java.lang.String PR_NO;

    /* 구매요청 항번 */
    private java.lang.String PR_LNO;

    /* 납품소요일수 */
    private java.lang.String LEAD_TIME;

    public DT_INFIPA0110_ConBodyQTA_ITEM() {
    }

    public DT_INFIPA0110_ConBodyQTA_ITEM(
           java.lang.String COMP_CD,
           java.lang.String VD_CD,
           java.lang.String QTA_NO,
           java.lang.String QTA_CNT,
           java.lang.String QTA_LNO,
           java.lang.String RFQ_NO,
           java.lang.String RFQ_CNT,
           java.lang.String RFQ_LNO,
           java.lang.String ITEM_CD,
           java.lang.String ITEM_NM,
           java.lang.String SPEC,
           java.lang.String UNIT_CD,
           java.lang.String ITEM_QTY,
           java.lang.String ITEM_PRICE,
           java.lang.String ITEM_AMT,
           java.lang.String STL_QTY,
           java.lang.String STL_YN,
           java.lang.String REM,
           java.lang.String PR_NO,
           java.lang.String PR_LNO,
           java.lang.String LEAD_TIME) {
           this.COMP_CD = COMP_CD;
           this.VD_CD = VD_CD;
           this.QTA_NO = QTA_NO;
           this.QTA_CNT = QTA_CNT;
           this.QTA_LNO = QTA_LNO;
           this.RFQ_NO = RFQ_NO;
           this.RFQ_CNT = RFQ_CNT;
           this.RFQ_LNO = RFQ_LNO;
           this.ITEM_CD = ITEM_CD;
           this.ITEM_NM = ITEM_NM;
           this.SPEC = SPEC;
           this.UNIT_CD = UNIT_CD;
           this.ITEM_QTY = ITEM_QTY;
           this.ITEM_PRICE = ITEM_PRICE;
           this.ITEM_AMT = ITEM_AMT;
           this.STL_QTY = STL_QTY;
           this.STL_YN = STL_YN;
           this.REM = REM;
           this.PR_NO = PR_NO;
           this.PR_LNO = PR_LNO;
           this.LEAD_TIME = LEAD_TIME;
    }


    /**
     * Gets the COMP_CD value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return COMP_CD   * 회사 코드
     */
    public java.lang.String getCOMP_CD() {
        return COMP_CD;
    }


    /**
     * Sets the COMP_CD value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param COMP_CD   * 회사 코드
     */
    public void setCOMP_CD(java.lang.String COMP_CD) {
        this.COMP_CD = COMP_CD;
    }


    /**
     * Gets the VD_CD value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return VD_CD   * 업체 코드
     */
    public java.lang.String getVD_CD() {
        return VD_CD;
    }


    /**
     * Sets the VD_CD value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param VD_CD   * 업체 코드
     */
    public void setVD_CD(java.lang.String VD_CD) {
        this.VD_CD = VD_CD;
    }


    /**
     * Gets the QTA_NO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return QTA_NO   * KeP 견적번호
     */
    public java.lang.String getQTA_NO() {
        return QTA_NO;
    }


    /**
     * Sets the QTA_NO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param QTA_NO   * KeP 견적번호
     */
    public void setQTA_NO(java.lang.String QTA_NO) {
        this.QTA_NO = QTA_NO;
    }


    /**
     * Gets the QTA_CNT value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return QTA_CNT   * 견적 회수
     */
    public java.lang.String getQTA_CNT() {
        return QTA_CNT;
    }


    /**
     * Sets the QTA_CNT value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param QTA_CNT   * 견적 회수
     */
    public void setQTA_CNT(java.lang.String QTA_CNT) {
        this.QTA_CNT = QTA_CNT;
    }


    /**
     * Gets the QTA_LNO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return QTA_LNO   * 견적 항번
     */
    public java.lang.String getQTA_LNO() {
        return QTA_LNO;
    }


    /**
     * Sets the QTA_LNO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param QTA_LNO   * 견적 항번
     */
    public void setQTA_LNO(java.lang.String QTA_LNO) {
        this.QTA_LNO = QTA_LNO;
    }


    /**
     * Gets the RFQ_NO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return RFQ_NO   * KeP 견적요청번호
     */
    public java.lang.String getRFQ_NO() {
        return RFQ_NO;
    }


    /**
     * Sets the RFQ_NO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param RFQ_NO   * KeP 견적요청번호
     */
    public void setRFQ_NO(java.lang.String RFQ_NO) {
        this.RFQ_NO = RFQ_NO;
    }


    /**
     * Gets the RFQ_CNT value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return RFQ_CNT   * 견적요청 회수
     */
    public java.lang.String getRFQ_CNT() {
        return RFQ_CNT;
    }


    /**
     * Sets the RFQ_CNT value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param RFQ_CNT   * 견적요청 회수
     */
    public void setRFQ_CNT(java.lang.String RFQ_CNT) {
        this.RFQ_CNT = RFQ_CNT;
    }


    /**
     * Gets the RFQ_LNO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return RFQ_LNO   * 견적요청 항번
     */
    public java.lang.String getRFQ_LNO() {
        return RFQ_LNO;
    }


    /**
     * Sets the RFQ_LNO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param RFQ_LNO   * 견적요청 항번
     */
    public void setRFQ_LNO(java.lang.String RFQ_LNO) {
        this.RFQ_LNO = RFQ_LNO;
    }


    /**
     * Gets the ITEM_CD value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return ITEM_CD   * 품목 코드
     */
    public java.lang.String getITEM_CD() {
        return ITEM_CD;
    }


    /**
     * Sets the ITEM_CD value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param ITEM_CD   * 품목 코드
     */
    public void setITEM_CD(java.lang.String ITEM_CD) {
        this.ITEM_CD = ITEM_CD;
    }


    /**
     * Gets the ITEM_NM value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return ITEM_NM   * 품목 명
     */
    public java.lang.String getITEM_NM() {
        return ITEM_NM;
    }


    /**
     * Sets the ITEM_NM value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param ITEM_NM   * 품목 명
     */
    public void setITEM_NM(java.lang.String ITEM_NM) {
        this.ITEM_NM = ITEM_NM;
    }


    /**
     * Gets the SPEC value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return SPEC   * 규격
     */
    public java.lang.String getSPEC() {
        return SPEC;
    }


    /**
     * Sets the SPEC value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param SPEC   * 규격
     */
    public void setSPEC(java.lang.String SPEC) {
        this.SPEC = SPEC;
    }


    /**
     * Gets the UNIT_CD value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return UNIT_CD   * 단위 코드
     */
    public java.lang.String getUNIT_CD() {
        return UNIT_CD;
    }


    /**
     * Sets the UNIT_CD value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param UNIT_CD   * 단위 코드
     */
    public void setUNIT_CD(java.lang.String UNIT_CD) {
        this.UNIT_CD = UNIT_CD;
    }


    /**
     * Gets the ITEM_QTY value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return ITEM_QTY   * 품목 수량
     */
    public java.lang.String getITEM_QTY() {
        return ITEM_QTY;
    }


    /**
     * Sets the ITEM_QTY value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param ITEM_QTY   * 품목 수량
     */
    public void setITEM_QTY(java.lang.String ITEM_QTY) {
        this.ITEM_QTY = ITEM_QTY;
    }


    /**
     * Gets the ITEM_PRICE value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return ITEM_PRICE   * 품목 단가
     */
    public java.lang.String getITEM_PRICE() {
        return ITEM_PRICE;
    }


    /**
     * Sets the ITEM_PRICE value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param ITEM_PRICE   * 품목 단가
     */
    public void setITEM_PRICE(java.lang.String ITEM_PRICE) {
        this.ITEM_PRICE = ITEM_PRICE;
    }


    /**
     * Gets the ITEM_AMT value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return ITEM_AMT   * 품목 금액
     */
    public java.lang.String getITEM_AMT() {
        return ITEM_AMT;
    }


    /**
     * Sets the ITEM_AMT value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param ITEM_AMT   * 품목 금액
     */
    public void setITEM_AMT(java.lang.String ITEM_AMT) {
        this.ITEM_AMT = ITEM_AMT;
    }


    /**
     * Gets the STL_QTY value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return STL_QTY   * 선정 수량
     */
    public java.lang.String getSTL_QTY() {
        return STL_QTY;
    }


    /**
     * Sets the STL_QTY value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param STL_QTY   * 선정 수량
     */
    public void setSTL_QTY(java.lang.String STL_QTY) {
        this.STL_QTY = STL_QTY;
    }


    /**
     * Gets the STL_YN value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return STL_YN   * 선정 여부
     */
    public java.lang.String getSTL_YN() {
        return STL_YN;
    }


    /**
     * Sets the STL_YN value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param STL_YN   * 선정 여부
     */
    public void setSTL_YN(java.lang.String STL_YN) {
        this.STL_YN = STL_YN;
    }


    /**
     * Gets the REM value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return REM   * 비고
     */
    public java.lang.String getREM() {
        return REM;
    }


    /**
     * Sets the REM value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param REM   * 비고
     */
    public void setREM(java.lang.String REM) {
        this.REM = REM;
    }


    /**
     * Gets the PR_NO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return PR_NO   * 구매요청 번호
     */
    public java.lang.String getPR_NO() {
        return PR_NO;
    }


    /**
     * Sets the PR_NO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param PR_NO   * 구매요청 번호
     */
    public void setPR_NO(java.lang.String PR_NO) {
        this.PR_NO = PR_NO;
    }


    /**
     * Gets the PR_LNO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return PR_LNO   * 구매요청 항번
     */
    public java.lang.String getPR_LNO() {
        return PR_LNO;
    }


    /**
     * Sets the PR_LNO value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param PR_LNO   * 구매요청 항번
     */
    public void setPR_LNO(java.lang.String PR_LNO) {
        this.PR_LNO = PR_LNO;
    }


    /**
     * Gets the LEAD_TIME value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @return LEAD_TIME   * 납품소요일수
     */
    public java.lang.String getLEAD_TIME() {
        return LEAD_TIME;
    }


    /**
     * Sets the LEAD_TIME value for this DT_INFIPA0110_ConBodyQTA_ITEM.
     * 
     * @param LEAD_TIME   * 납품소요일수
     */
    public void setLEAD_TIME(java.lang.String LEAD_TIME) {
        this.LEAD_TIME = LEAD_TIME;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_INFIPA0110_ConBodyQTA_ITEM)) return false;
        DT_INFIPA0110_ConBodyQTA_ITEM other = (DT_INFIPA0110_ConBodyQTA_ITEM) obj;
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
            ((this.VD_CD==null && other.getVD_CD()==null) || 
             (this.VD_CD!=null &&
              this.VD_CD.equals(other.getVD_CD()))) &&
            ((this.QTA_NO==null && other.getQTA_NO()==null) || 
             (this.QTA_NO!=null &&
              this.QTA_NO.equals(other.getQTA_NO()))) &&
            ((this.QTA_CNT==null && other.getQTA_CNT()==null) || 
             (this.QTA_CNT!=null &&
              this.QTA_CNT.equals(other.getQTA_CNT()))) &&
            ((this.QTA_LNO==null && other.getQTA_LNO()==null) || 
             (this.QTA_LNO!=null &&
              this.QTA_LNO.equals(other.getQTA_LNO()))) &&
            ((this.RFQ_NO==null && other.getRFQ_NO()==null) || 
             (this.RFQ_NO!=null &&
              this.RFQ_NO.equals(other.getRFQ_NO()))) &&
            ((this.RFQ_CNT==null && other.getRFQ_CNT()==null) || 
             (this.RFQ_CNT!=null &&
              this.RFQ_CNT.equals(other.getRFQ_CNT()))) &&
            ((this.RFQ_LNO==null && other.getRFQ_LNO()==null) || 
             (this.RFQ_LNO!=null &&
              this.RFQ_LNO.equals(other.getRFQ_LNO()))) &&
            ((this.ITEM_CD==null && other.getITEM_CD()==null) || 
             (this.ITEM_CD!=null &&
              this.ITEM_CD.equals(other.getITEM_CD()))) &&
            ((this.ITEM_NM==null && other.getITEM_NM()==null) || 
             (this.ITEM_NM!=null &&
              this.ITEM_NM.equals(other.getITEM_NM()))) &&
            ((this.SPEC==null && other.getSPEC()==null) || 
             (this.SPEC!=null &&
              this.SPEC.equals(other.getSPEC()))) &&
            ((this.UNIT_CD==null && other.getUNIT_CD()==null) || 
             (this.UNIT_CD!=null &&
              this.UNIT_CD.equals(other.getUNIT_CD()))) &&
            ((this.ITEM_QTY==null && other.getITEM_QTY()==null) || 
             (this.ITEM_QTY!=null &&
              this.ITEM_QTY.equals(other.getITEM_QTY()))) &&
            ((this.ITEM_PRICE==null && other.getITEM_PRICE()==null) || 
             (this.ITEM_PRICE!=null &&
              this.ITEM_PRICE.equals(other.getITEM_PRICE()))) &&
            ((this.ITEM_AMT==null && other.getITEM_AMT()==null) || 
             (this.ITEM_AMT!=null &&
              this.ITEM_AMT.equals(other.getITEM_AMT()))) &&
            ((this.STL_QTY==null && other.getSTL_QTY()==null) || 
             (this.STL_QTY!=null &&
              this.STL_QTY.equals(other.getSTL_QTY()))) &&
            ((this.STL_YN==null && other.getSTL_YN()==null) || 
             (this.STL_YN!=null &&
              this.STL_YN.equals(other.getSTL_YN()))) &&
            ((this.REM==null && other.getREM()==null) || 
             (this.REM!=null &&
              this.REM.equals(other.getREM()))) &&
            ((this.PR_NO==null && other.getPR_NO()==null) || 
             (this.PR_NO!=null &&
              this.PR_NO.equals(other.getPR_NO()))) &&
            ((this.PR_LNO==null && other.getPR_LNO()==null) || 
             (this.PR_LNO!=null &&
              this.PR_LNO.equals(other.getPR_LNO()))) &&
            ((this.LEAD_TIME==null && other.getLEAD_TIME()==null) || 
             (this.LEAD_TIME!=null &&
              this.LEAD_TIME.equals(other.getLEAD_TIME())));
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
        if (getVD_CD() != null) {
            _hashCode += getVD_CD().hashCode();
        }
        if (getQTA_NO() != null) {
            _hashCode += getQTA_NO().hashCode();
        }
        if (getQTA_CNT() != null) {
            _hashCode += getQTA_CNT().hashCode();
        }
        if (getQTA_LNO() != null) {
            _hashCode += getQTA_LNO().hashCode();
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
        if (getITEM_CD() != null) {
            _hashCode += getITEM_CD().hashCode();
        }
        if (getITEM_NM() != null) {
            _hashCode += getITEM_NM().hashCode();
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
        if (getITEM_PRICE() != null) {
            _hashCode += getITEM_PRICE().hashCode();
        }
        if (getITEM_AMT() != null) {
            _hashCode += getITEM_AMT().hashCode();
        }
        if (getSTL_QTY() != null) {
            _hashCode += getSTL_QTY().hashCode();
        }
        if (getSTL_YN() != null) {
            _hashCode += getSTL_YN().hashCode();
        }
        if (getREM() != null) {
            _hashCode += getREM().hashCode();
        }
        if (getPR_NO() != null) {
            _hashCode += getPR_NO().hashCode();
        }
        if (getPR_LNO() != null) {
            _hashCode += getPR_LNO().hashCode();
        }
        if (getLEAD_TIME() != null) {
            _hashCode += getLEAD_TIME().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_INFIPA0110_ConBodyQTA_ITEM.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://infipa.esp.com/k2pkbb", ">>DT_INFIPA0110_Con>Body>QTA_ITEM"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("COMP_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "COMP_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("VD_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "VD_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_CNT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_CNT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_LNO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_LNO"));
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
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ITEM_QTY");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ITEM_QTY"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ITEM_PRICE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ITEM_PRICE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ITEM_AMT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ITEM_AMT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("STL_QTY");
        elemField.setXmlName(new javax.xml.namespace.QName("", "STL_QTY"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("STL_YN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "STL_YN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("REM");
        elemField.setXmlName(new javax.xml.namespace.QName("", "REM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
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
        elemField.setFieldName("LEAD_TIME");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LEAD_TIME"));
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
