/**
 * DT_INFMPO0030_ConBodyRFQ_VENDOR.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.infmpo.k2pkbb;

public class DT_INFMPO0030_ConBodyRFQ_VENDOR  implements java.io.Serializable {
    /* 회사코드 */
    private java.lang.String COMP_CD;

    /* KeP 견적요청번호 */
    private java.lang.String RFQ_NO;

    /* 견적요청 회수 */
    private java.lang.String RFQ_CNT;

    /* 업체 코드 (사업자번호) */
    private java.lang.String VD_CD;

    /* 업체담당자 모바일번호 */
    private java.lang.String VD_CHR_PHONE_NO;

    /* 업체담당자 이메일 */
    private java.lang.String VD_CHR_EMAIL;

    /* 업체선정사유 */
    private java.lang.String VD_STL_CAUSE;

    /* 견적 제출 일시 */
    private java.lang.String QTA_SBMT_DATE;

    /* 견적 포기 여부 */
    private java.lang.String QTA_ABD_YN;

    /* 견적 포기 사유 */
    private java.lang.String QTA_ABD_CAUSE;

    public DT_INFMPO0030_ConBodyRFQ_VENDOR() {
    }

    public DT_INFMPO0030_ConBodyRFQ_VENDOR(
           java.lang.String COMP_CD,
           java.lang.String RFQ_NO,
           java.lang.String RFQ_CNT,
           java.lang.String VD_CD,
           java.lang.String VD_CHR_PHONE_NO,
           java.lang.String VD_CHR_EMAIL,
           java.lang.String VD_STL_CAUSE,
           java.lang.String QTA_SBMT_DATE,
           java.lang.String QTA_ABD_YN,
           java.lang.String QTA_ABD_CAUSE) {
           this.COMP_CD = COMP_CD;
           this.RFQ_NO = RFQ_NO;
           this.RFQ_CNT = RFQ_CNT;
           this.VD_CD = VD_CD;
           this.VD_CHR_PHONE_NO = VD_CHR_PHONE_NO;
           this.VD_CHR_EMAIL = VD_CHR_EMAIL;
           this.VD_STL_CAUSE = VD_STL_CAUSE;
           this.QTA_SBMT_DATE = QTA_SBMT_DATE;
           this.QTA_ABD_YN = QTA_ABD_YN;
           this.QTA_ABD_CAUSE = QTA_ABD_CAUSE;
    }


    /**
     * Gets the COMP_CD value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @return COMP_CD   * 회사코드
     */
    public java.lang.String getCOMP_CD() {
        return COMP_CD;
    }


    /**
     * Sets the COMP_CD value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @param COMP_CD   * 회사코드
     */
    public void setCOMP_CD(java.lang.String COMP_CD) {
        this.COMP_CD = COMP_CD;
    }


    /**
     * Gets the RFQ_NO value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @return RFQ_NO   * KeP 견적요청번호
     */
    public java.lang.String getRFQ_NO() {
        return RFQ_NO;
    }


    /**
     * Sets the RFQ_NO value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @param RFQ_NO   * KeP 견적요청번호
     */
    public void setRFQ_NO(java.lang.String RFQ_NO) {
        this.RFQ_NO = RFQ_NO;
    }


    /**
     * Gets the RFQ_CNT value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @return RFQ_CNT   * 견적요청 회수
     */
    public java.lang.String getRFQ_CNT() {
        return RFQ_CNT;
    }


    /**
     * Sets the RFQ_CNT value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @param RFQ_CNT   * 견적요청 회수
     */
    public void setRFQ_CNT(java.lang.String RFQ_CNT) {
        this.RFQ_CNT = RFQ_CNT;
    }


    /**
     * Gets the VD_CD value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @return VD_CD   * 업체 코드 (사업자번호)
     */
    public java.lang.String getVD_CD() {
        return VD_CD;
    }


    /**
     * Sets the VD_CD value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @param VD_CD   * 업체 코드 (사업자번호)
     */
    public void setVD_CD(java.lang.String VD_CD) {
        this.VD_CD = VD_CD;
    }


    /**
     * Gets the VD_CHR_PHONE_NO value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @return VD_CHR_PHONE_NO   * 업체담당자 모바일번호
     */
    public java.lang.String getVD_CHR_PHONE_NO() {
        return VD_CHR_PHONE_NO;
    }


    /**
     * Sets the VD_CHR_PHONE_NO value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @param VD_CHR_PHONE_NO   * 업체담당자 모바일번호
     */
    public void setVD_CHR_PHONE_NO(java.lang.String VD_CHR_PHONE_NO) {
        this.VD_CHR_PHONE_NO = VD_CHR_PHONE_NO;
    }


    /**
     * Gets the VD_CHR_EMAIL value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @return VD_CHR_EMAIL   * 업체담당자 이메일
     */
    public java.lang.String getVD_CHR_EMAIL() {
        return VD_CHR_EMAIL;
    }


    /**
     * Sets the VD_CHR_EMAIL value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @param VD_CHR_EMAIL   * 업체담당자 이메일
     */
    public void setVD_CHR_EMAIL(java.lang.String VD_CHR_EMAIL) {
        this.VD_CHR_EMAIL = VD_CHR_EMAIL;
    }


    /**
     * Gets the VD_STL_CAUSE value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @return VD_STL_CAUSE   * 업체선정사유
     */
    public java.lang.String getVD_STL_CAUSE() {
        return VD_STL_CAUSE;
    }


    /**
     * Sets the VD_STL_CAUSE value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @param VD_STL_CAUSE   * 업체선정사유
     */
    public void setVD_STL_CAUSE(java.lang.String VD_STL_CAUSE) {
        this.VD_STL_CAUSE = VD_STL_CAUSE;
    }


    /**
     * Gets the QTA_SBMT_DATE value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @return QTA_SBMT_DATE   * 견적 제출 일시
     */
    public java.lang.String getQTA_SBMT_DATE() {
        return QTA_SBMT_DATE;
    }


    /**
     * Sets the QTA_SBMT_DATE value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @param QTA_SBMT_DATE   * 견적 제출 일시
     */
    public void setQTA_SBMT_DATE(java.lang.String QTA_SBMT_DATE) {
        this.QTA_SBMT_DATE = QTA_SBMT_DATE;
    }


    /**
     * Gets the QTA_ABD_YN value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @return QTA_ABD_YN   * 견적 포기 여부
     */
    public java.lang.String getQTA_ABD_YN() {
        return QTA_ABD_YN;
    }


    /**
     * Sets the QTA_ABD_YN value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @param QTA_ABD_YN   * 견적 포기 여부
     */
    public void setQTA_ABD_YN(java.lang.String QTA_ABD_YN) {
        this.QTA_ABD_YN = QTA_ABD_YN;
    }


    /**
     * Gets the QTA_ABD_CAUSE value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @return QTA_ABD_CAUSE   * 견적 포기 사유
     */
    public java.lang.String getQTA_ABD_CAUSE() {
        return QTA_ABD_CAUSE;
    }


    /**
     * Sets the QTA_ABD_CAUSE value for this DT_INFMPO0030_ConBodyRFQ_VENDOR.
     * 
     * @param QTA_ABD_CAUSE   * 견적 포기 사유
     */
    public void setQTA_ABD_CAUSE(java.lang.String QTA_ABD_CAUSE) {
        this.QTA_ABD_CAUSE = QTA_ABD_CAUSE;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_INFMPO0030_ConBodyRFQ_VENDOR)) return false;
        DT_INFMPO0030_ConBodyRFQ_VENDOR other = (DT_INFMPO0030_ConBodyRFQ_VENDOR) obj;
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
            ((this.VD_CD==null && other.getVD_CD()==null) || 
             (this.VD_CD!=null &&
              this.VD_CD.equals(other.getVD_CD()))) &&
            ((this.VD_CHR_PHONE_NO==null && other.getVD_CHR_PHONE_NO()==null) || 
             (this.VD_CHR_PHONE_NO!=null &&
              this.VD_CHR_PHONE_NO.equals(other.getVD_CHR_PHONE_NO()))) &&
            ((this.VD_CHR_EMAIL==null && other.getVD_CHR_EMAIL()==null) || 
             (this.VD_CHR_EMAIL!=null &&
              this.VD_CHR_EMAIL.equals(other.getVD_CHR_EMAIL()))) &&
            ((this.VD_STL_CAUSE==null && other.getVD_STL_CAUSE()==null) || 
             (this.VD_STL_CAUSE!=null &&
              this.VD_STL_CAUSE.equals(other.getVD_STL_CAUSE()))) &&
            ((this.QTA_SBMT_DATE==null && other.getQTA_SBMT_DATE()==null) || 
             (this.QTA_SBMT_DATE!=null &&
              this.QTA_SBMT_DATE.equals(other.getQTA_SBMT_DATE()))) &&
            ((this.QTA_ABD_YN==null && other.getQTA_ABD_YN()==null) || 
             (this.QTA_ABD_YN!=null &&
              this.QTA_ABD_YN.equals(other.getQTA_ABD_YN()))) &&
            ((this.QTA_ABD_CAUSE==null && other.getQTA_ABD_CAUSE()==null) || 
             (this.QTA_ABD_CAUSE!=null &&
              this.QTA_ABD_CAUSE.equals(other.getQTA_ABD_CAUSE())));
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
        if (getVD_CD() != null) {
            _hashCode += getVD_CD().hashCode();
        }
        if (getVD_CHR_PHONE_NO() != null) {
            _hashCode += getVD_CHR_PHONE_NO().hashCode();
        }
        if (getVD_CHR_EMAIL() != null) {
            _hashCode += getVD_CHR_EMAIL().hashCode();
        }
        if (getVD_STL_CAUSE() != null) {
            _hashCode += getVD_STL_CAUSE().hashCode();
        }
        if (getQTA_SBMT_DATE() != null) {
            _hashCode += getQTA_SBMT_DATE().hashCode();
        }
        if (getQTA_ABD_YN() != null) {
            _hashCode += getQTA_ABD_YN().hashCode();
        }
        if (getQTA_ABD_CAUSE() != null) {
            _hashCode += getQTA_ABD_CAUSE().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_INFMPO0030_ConBodyRFQ_VENDOR.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", ">>DT_INFMPO0030_Con>Body>RFQ_VENDOR"));
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
        elemField.setFieldName("VD_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "VD_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("VD_CHR_PHONE_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "VD_CHR_PHONE_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("VD_CHR_EMAIL");
        elemField.setXmlName(new javax.xml.namespace.QName("", "VD_CHR_EMAIL"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("VD_STL_CAUSE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "VD_STL_CAUSE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_SBMT_DATE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_SBMT_DATE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_ABD_YN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_ABD_YN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_ABD_CAUSE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_ABD_CAUSE"));
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
