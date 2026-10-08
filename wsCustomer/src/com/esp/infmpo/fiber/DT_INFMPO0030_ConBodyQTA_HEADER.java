/**
 * DT_INFMPO0030_ConBodyQTA_HEADER.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.infmpo.fiber;

public class DT_INFMPO0030_ConBodyQTA_HEADER  implements java.io.Serializable {
    /* 회사 코드 */
    private java.lang.String COMP_CD;

    /* 업체 코드 */
    private java.lang.String VD_CD;

    /* KeP 견적번호 */
    private java.lang.String QTA_NO;

    /* 견적 회수 */
    private java.lang.String QTA_CNT;

    /* KeP 견적요청번호 */
    private java.lang.String RFQ_NO;

    /* 견적요청 회수 */
    private java.lang.String RFQ_CNT;

    /* 견적 유효 일자 */
    private java.lang.String QTA_EFF_DATE;

    /* 견적 총금액 */
    private java.lang.String QTA_AMT;

    /* 통화 */
    private java.lang.String CUR;

    /* 업체견적 진행 상태 */
    private java.lang.String PROG_STS;

    /* 비고 */
    private java.lang.String REM;

    /* 선정 여부 */
    private java.lang.String STL_YN;

    /* 파일 그룹 번호 */
    private java.lang.String ATT_GRP_NO;

    public DT_INFMPO0030_ConBodyQTA_HEADER() {
    }

    public DT_INFMPO0030_ConBodyQTA_HEADER(
           java.lang.String COMP_CD,
           java.lang.String VD_CD,
           java.lang.String QTA_NO,
           java.lang.String QTA_CNT,
           java.lang.String RFQ_NO,
           java.lang.String RFQ_CNT,
           java.lang.String QTA_EFF_DATE,
           java.lang.String QTA_AMT,
           java.lang.String CUR,
           java.lang.String PROG_STS,
           java.lang.String REM,
           java.lang.String STL_YN,
           java.lang.String ATT_GRP_NO) {
           this.COMP_CD = COMP_CD;
           this.VD_CD = VD_CD;
           this.QTA_NO = QTA_NO;
           this.QTA_CNT = QTA_CNT;
           this.RFQ_NO = RFQ_NO;
           this.RFQ_CNT = RFQ_CNT;
           this.QTA_EFF_DATE = QTA_EFF_DATE;
           this.QTA_AMT = QTA_AMT;
           this.CUR = CUR;
           this.PROG_STS = PROG_STS;
           this.REM = REM;
           this.STL_YN = STL_YN;
           this.ATT_GRP_NO = ATT_GRP_NO;
    }


    /**
     * Gets the COMP_CD value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return COMP_CD   * 회사 코드
     */
    public java.lang.String getCOMP_CD() {
        return COMP_CD;
    }


    /**
     * Sets the COMP_CD value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param COMP_CD   * 회사 코드
     */
    public void setCOMP_CD(java.lang.String COMP_CD) {
        this.COMP_CD = COMP_CD;
    }


    /**
     * Gets the VD_CD value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return VD_CD   * 업체 코드
     */
    public java.lang.String getVD_CD() {
        return VD_CD;
    }


    /**
     * Sets the VD_CD value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param VD_CD   * 업체 코드
     */
    public void setVD_CD(java.lang.String VD_CD) {
        this.VD_CD = VD_CD;
    }


    /**
     * Gets the QTA_NO value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return QTA_NO   * KeP 견적번호
     */
    public java.lang.String getQTA_NO() {
        return QTA_NO;
    }


    /**
     * Sets the QTA_NO value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param QTA_NO   * KeP 견적번호
     */
    public void setQTA_NO(java.lang.String QTA_NO) {
        this.QTA_NO = QTA_NO;
    }


    /**
     * Gets the QTA_CNT value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return QTA_CNT   * 견적 회수
     */
    public java.lang.String getQTA_CNT() {
        return QTA_CNT;
    }


    /**
     * Sets the QTA_CNT value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param QTA_CNT   * 견적 회수
     */
    public void setQTA_CNT(java.lang.String QTA_CNT) {
        this.QTA_CNT = QTA_CNT;
    }


    /**
     * Gets the RFQ_NO value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return RFQ_NO   * KeP 견적요청번호
     */
    public java.lang.String getRFQ_NO() {
        return RFQ_NO;
    }


    /**
     * Sets the RFQ_NO value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param RFQ_NO   * KeP 견적요청번호
     */
    public void setRFQ_NO(java.lang.String RFQ_NO) {
        this.RFQ_NO = RFQ_NO;
    }


    /**
     * Gets the RFQ_CNT value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return RFQ_CNT   * 견적요청 회수
     */
    public java.lang.String getRFQ_CNT() {
        return RFQ_CNT;
    }


    /**
     * Sets the RFQ_CNT value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param RFQ_CNT   * 견적요청 회수
     */
    public void setRFQ_CNT(java.lang.String RFQ_CNT) {
        this.RFQ_CNT = RFQ_CNT;
    }


    /**
     * Gets the QTA_EFF_DATE value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return QTA_EFF_DATE   * 견적 유효 일자
     */
    public java.lang.String getQTA_EFF_DATE() {
        return QTA_EFF_DATE;
    }


    /**
     * Sets the QTA_EFF_DATE value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param QTA_EFF_DATE   * 견적 유효 일자
     */
    public void setQTA_EFF_DATE(java.lang.String QTA_EFF_DATE) {
        this.QTA_EFF_DATE = QTA_EFF_DATE;
    }


    /**
     * Gets the QTA_AMT value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return QTA_AMT   * 견적 총금액
     */
    public java.lang.String getQTA_AMT() {
        return QTA_AMT;
    }


    /**
     * Sets the QTA_AMT value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param QTA_AMT   * 견적 총금액
     */
    public void setQTA_AMT(java.lang.String QTA_AMT) {
        this.QTA_AMT = QTA_AMT;
    }


    /**
     * Gets the CUR value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return CUR   * 통화
     */
    public java.lang.String getCUR() {
        return CUR;
    }


    /**
     * Sets the CUR value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param CUR   * 통화
     */
    public void setCUR(java.lang.String CUR) {
        this.CUR = CUR;
    }


    /**
     * Gets the PROG_STS value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return PROG_STS   * 업체견적 진행 상태
     */
    public java.lang.String getPROG_STS() {
        return PROG_STS;
    }


    /**
     * Sets the PROG_STS value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param PROG_STS   * 업체견적 진행 상태
     */
    public void setPROG_STS(java.lang.String PROG_STS) {
        this.PROG_STS = PROG_STS;
    }


    /**
     * Gets the REM value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return REM   * 비고
     */
    public java.lang.String getREM() {
        return REM;
    }


    /**
     * Sets the REM value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param REM   * 비고
     */
    public void setREM(java.lang.String REM) {
        this.REM = REM;
    }


    /**
     * Gets the STL_YN value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return STL_YN   * 선정 여부
     */
    public java.lang.String getSTL_YN() {
        return STL_YN;
    }


    /**
     * Sets the STL_YN value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param STL_YN   * 선정 여부
     */
    public void setSTL_YN(java.lang.String STL_YN) {
        this.STL_YN = STL_YN;
    }


    /**
     * Gets the ATT_GRP_NO value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @return ATT_GRP_NO   * 파일 그룹 번호
     */
    public java.lang.String getATT_GRP_NO() {
        return ATT_GRP_NO;
    }


    /**
     * Sets the ATT_GRP_NO value for this DT_INFMPO0030_ConBodyQTA_HEADER.
     * 
     * @param ATT_GRP_NO   * 파일 그룹 번호
     */
    public void setATT_GRP_NO(java.lang.String ATT_GRP_NO) {
        this.ATT_GRP_NO = ATT_GRP_NO;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_INFMPO0030_ConBodyQTA_HEADER)) return false;
        DT_INFMPO0030_ConBodyQTA_HEADER other = (DT_INFMPO0030_ConBodyQTA_HEADER) obj;
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
            ((this.RFQ_NO==null && other.getRFQ_NO()==null) || 
             (this.RFQ_NO!=null &&
              this.RFQ_NO.equals(other.getRFQ_NO()))) &&
            ((this.RFQ_CNT==null && other.getRFQ_CNT()==null) || 
             (this.RFQ_CNT!=null &&
              this.RFQ_CNT.equals(other.getRFQ_CNT()))) &&
            ((this.QTA_EFF_DATE==null && other.getQTA_EFF_DATE()==null) || 
             (this.QTA_EFF_DATE!=null &&
              this.QTA_EFF_DATE.equals(other.getQTA_EFF_DATE()))) &&
            ((this.QTA_AMT==null && other.getQTA_AMT()==null) || 
             (this.QTA_AMT!=null &&
              this.QTA_AMT.equals(other.getQTA_AMT()))) &&
            ((this.CUR==null && other.getCUR()==null) || 
             (this.CUR!=null &&
              this.CUR.equals(other.getCUR()))) &&
            ((this.PROG_STS==null && other.getPROG_STS()==null) || 
             (this.PROG_STS!=null &&
              this.PROG_STS.equals(other.getPROG_STS()))) &&
            ((this.REM==null && other.getREM()==null) || 
             (this.REM!=null &&
              this.REM.equals(other.getREM()))) &&
            ((this.STL_YN==null && other.getSTL_YN()==null) || 
             (this.STL_YN!=null &&
              this.STL_YN.equals(other.getSTL_YN()))) &&
            ((this.ATT_GRP_NO==null && other.getATT_GRP_NO()==null) || 
             (this.ATT_GRP_NO!=null &&
              this.ATT_GRP_NO.equals(other.getATT_GRP_NO())));
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
        if (getRFQ_NO() != null) {
            _hashCode += getRFQ_NO().hashCode();
        }
        if (getRFQ_CNT() != null) {
            _hashCode += getRFQ_CNT().hashCode();
        }
        if (getQTA_EFF_DATE() != null) {
            _hashCode += getQTA_EFF_DATE().hashCode();
        }
        if (getQTA_AMT() != null) {
            _hashCode += getQTA_AMT().hashCode();
        }
        if (getCUR() != null) {
            _hashCode += getCUR().hashCode();
        }
        if (getPROG_STS() != null) {
            _hashCode += getPROG_STS().hashCode();
        }
        if (getREM() != null) {
            _hashCode += getREM().hashCode();
        }
        if (getSTL_YN() != null) {
            _hashCode += getSTL_YN().hashCode();
        }
        if (getATT_GRP_NO() != null) {
            _hashCode += getATT_GRP_NO().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_INFMPO0030_ConBodyQTA_HEADER.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", ">>DT_INFMPO0030_Con>Body>QTA_HEADER"));
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
        elemField.setFieldName("QTA_EFF_DATE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_EFF_DATE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_AMT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_AMT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CUR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CUR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PROG_STS");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PROG_STS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
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
        elemField.setFieldName("STL_YN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "STL_YN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ATT_GRP_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ATT_GRP_NO"));
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
