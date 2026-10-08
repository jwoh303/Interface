/**
 * DT_INFMPO0030_ConBodyRFQ_ATTACH.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.infmpo.k2pkbb;

public class DT_INFMPO0030_ConBodyRFQ_ATTACH  implements java.io.Serializable {
    /* 첨부파일 그룹 번호 */
    private java.lang.String ATT_GRP_NO;

    /* 첨부파일 일련 번호 */
    private java.lang.String ATT_FILE_SEQ;

    /* 첨부파일명 */
    private java.lang.String ATT_FILE_NM;

    /* 첨부파일 크기 */
    private java.lang.String ATT_FILE_SIZ;

    /* 첨부파일 경로 */
    private java.lang.String ATT_FILE_PATH;

    public DT_INFMPO0030_ConBodyRFQ_ATTACH() {
    }

    public DT_INFMPO0030_ConBodyRFQ_ATTACH(
           java.lang.String ATT_GRP_NO,
           java.lang.String ATT_FILE_SEQ,
           java.lang.String ATT_FILE_NM,
           java.lang.String ATT_FILE_SIZ,
           java.lang.String ATT_FILE_PATH) {
           this.ATT_GRP_NO = ATT_GRP_NO;
           this.ATT_FILE_SEQ = ATT_FILE_SEQ;
           this.ATT_FILE_NM = ATT_FILE_NM;
           this.ATT_FILE_SIZ = ATT_FILE_SIZ;
           this.ATT_FILE_PATH = ATT_FILE_PATH;
    }


    /**
     * Gets the ATT_GRP_NO value for this DT_INFMPO0030_ConBodyRFQ_ATTACH.
     * 
     * @return ATT_GRP_NO   * 첨부파일 그룹 번호
     */
    public java.lang.String getATT_GRP_NO() {
        return ATT_GRP_NO;
    }


    /**
     * Sets the ATT_GRP_NO value for this DT_INFMPO0030_ConBodyRFQ_ATTACH.
     * 
     * @param ATT_GRP_NO   * 첨부파일 그룹 번호
     */
    public void setATT_GRP_NO(java.lang.String ATT_GRP_NO) {
        this.ATT_GRP_NO = ATT_GRP_NO;
    }


    /**
     * Gets the ATT_FILE_SEQ value for this DT_INFMPO0030_ConBodyRFQ_ATTACH.
     * 
     * @return ATT_FILE_SEQ   * 첨부파일 일련 번호
     */
    public java.lang.String getATT_FILE_SEQ() {
        return ATT_FILE_SEQ;
    }


    /**
     * Sets the ATT_FILE_SEQ value for this DT_INFMPO0030_ConBodyRFQ_ATTACH.
     * 
     * @param ATT_FILE_SEQ   * 첨부파일 일련 번호
     */
    public void setATT_FILE_SEQ(java.lang.String ATT_FILE_SEQ) {
        this.ATT_FILE_SEQ = ATT_FILE_SEQ;
    }


    /**
     * Gets the ATT_FILE_NM value for this DT_INFMPO0030_ConBodyRFQ_ATTACH.
     * 
     * @return ATT_FILE_NM   * 첨부파일명
     */
    public java.lang.String getATT_FILE_NM() {
        return ATT_FILE_NM;
    }


    /**
     * Sets the ATT_FILE_NM value for this DT_INFMPO0030_ConBodyRFQ_ATTACH.
     * 
     * @param ATT_FILE_NM   * 첨부파일명
     */
    public void setATT_FILE_NM(java.lang.String ATT_FILE_NM) {
        this.ATT_FILE_NM = ATT_FILE_NM;
    }


    /**
     * Gets the ATT_FILE_SIZ value for this DT_INFMPO0030_ConBodyRFQ_ATTACH.
     * 
     * @return ATT_FILE_SIZ   * 첨부파일 크기
     */
    public java.lang.String getATT_FILE_SIZ() {
        return ATT_FILE_SIZ;
    }


    /**
     * Sets the ATT_FILE_SIZ value for this DT_INFMPO0030_ConBodyRFQ_ATTACH.
     * 
     * @param ATT_FILE_SIZ   * 첨부파일 크기
     */
    public void setATT_FILE_SIZ(java.lang.String ATT_FILE_SIZ) {
        this.ATT_FILE_SIZ = ATT_FILE_SIZ;
    }


    /**
     * Gets the ATT_FILE_PATH value for this DT_INFMPO0030_ConBodyRFQ_ATTACH.
     * 
     * @return ATT_FILE_PATH   * 첨부파일 경로
     */
    public java.lang.String getATT_FILE_PATH() {
        return ATT_FILE_PATH;
    }


    /**
     * Sets the ATT_FILE_PATH value for this DT_INFMPO0030_ConBodyRFQ_ATTACH.
     * 
     * @param ATT_FILE_PATH   * 첨부파일 경로
     */
    public void setATT_FILE_PATH(java.lang.String ATT_FILE_PATH) {
        this.ATT_FILE_PATH = ATT_FILE_PATH;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_INFMPO0030_ConBodyRFQ_ATTACH)) return false;
        DT_INFMPO0030_ConBodyRFQ_ATTACH other = (DT_INFMPO0030_ConBodyRFQ_ATTACH) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.ATT_GRP_NO==null && other.getATT_GRP_NO()==null) || 
             (this.ATT_GRP_NO!=null &&
              this.ATT_GRP_NO.equals(other.getATT_GRP_NO()))) &&
            ((this.ATT_FILE_SEQ==null && other.getATT_FILE_SEQ()==null) || 
             (this.ATT_FILE_SEQ!=null &&
              this.ATT_FILE_SEQ.equals(other.getATT_FILE_SEQ()))) &&
            ((this.ATT_FILE_NM==null && other.getATT_FILE_NM()==null) || 
             (this.ATT_FILE_NM!=null &&
              this.ATT_FILE_NM.equals(other.getATT_FILE_NM()))) &&
            ((this.ATT_FILE_SIZ==null && other.getATT_FILE_SIZ()==null) || 
             (this.ATT_FILE_SIZ!=null &&
              this.ATT_FILE_SIZ.equals(other.getATT_FILE_SIZ()))) &&
            ((this.ATT_FILE_PATH==null && other.getATT_FILE_PATH()==null) || 
             (this.ATT_FILE_PATH!=null &&
              this.ATT_FILE_PATH.equals(other.getATT_FILE_PATH())));
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
        if (getATT_GRP_NO() != null) {
            _hashCode += getATT_GRP_NO().hashCode();
        }
        if (getATT_FILE_SEQ() != null) {
            _hashCode += getATT_FILE_SEQ().hashCode();
        }
        if (getATT_FILE_NM() != null) {
            _hashCode += getATT_FILE_NM().hashCode();
        }
        if (getATT_FILE_SIZ() != null) {
            _hashCode += getATT_FILE_SIZ().hashCode();
        }
        if (getATT_FILE_PATH() != null) {
            _hashCode += getATT_FILE_PATH().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_INFMPO0030_ConBodyRFQ_ATTACH.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", ">>DT_INFMPO0030_Con>Body>RFQ_ATTACH"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ATT_GRP_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ATT_GRP_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ATT_FILE_SEQ");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ATT_FILE_SEQ"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ATT_FILE_NM");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ATT_FILE_NM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ATT_FILE_SIZ");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ATT_FILE_SIZ"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ATT_FILE_PATH");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ATT_FILE_PATH"));
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
