/**
 * DT_GRP_MM0710_ConBodyLIKP.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.grpeccmm.k2pkbb;

public class DT_GRP_MM0710_ConBodyLIKP  implements java.io.Serializable {
    /* 입고예약번호 (KEP) */
    private java.lang.String LIFEX;

    /* 납품문서번호 (SAP) */
    private java.lang.String VBELN;

    /* 공급업체 코드 (SAP) */
    private java.lang.String LIFNR;

    /* 납품일자 */
    private java.lang.String LFDAT;

    /* 상태 */
    private java.lang.String TYPE;

    public DT_GRP_MM0710_ConBodyLIKP() {
    }

    public DT_GRP_MM0710_ConBodyLIKP(
           java.lang.String LIFEX,
           java.lang.String VBELN,
           java.lang.String LIFNR,
           java.lang.String LFDAT,
           java.lang.String TYPE) {
           this.LIFEX = LIFEX;
           this.VBELN = VBELN;
           this.LIFNR = LIFNR;
           this.LFDAT = LFDAT;
           this.TYPE = TYPE;
    }


    /**
     * Gets the LIFEX value for this DT_GRP_MM0710_ConBodyLIKP.
     * 
     * @return LIFEX   * 입고예약번호 (KEP)
     */
    public java.lang.String getLIFEX() {
        return LIFEX;
    }


    /**
     * Sets the LIFEX value for this DT_GRP_MM0710_ConBodyLIKP.
     * 
     * @param LIFEX   * 입고예약번호 (KEP)
     */
    public void setLIFEX(java.lang.String LIFEX) {
        this.LIFEX = LIFEX;
    }


    /**
     * Gets the VBELN value for this DT_GRP_MM0710_ConBodyLIKP.
     * 
     * @return VBELN   * 납품문서번호 (SAP)
     */
    public java.lang.String getVBELN() {
        return VBELN;
    }


    /**
     * Sets the VBELN value for this DT_GRP_MM0710_ConBodyLIKP.
     * 
     * @param VBELN   * 납품문서번호 (SAP)
     */
    public void setVBELN(java.lang.String VBELN) {
        this.VBELN = VBELN;
    }


    /**
     * Gets the LIFNR value for this DT_GRP_MM0710_ConBodyLIKP.
     * 
     * @return LIFNR   * 공급업체 코드 (SAP)
     */
    public java.lang.String getLIFNR() {
        return LIFNR;
    }


    /**
     * Sets the LIFNR value for this DT_GRP_MM0710_ConBodyLIKP.
     * 
     * @param LIFNR   * 공급업체 코드 (SAP)
     */
    public void setLIFNR(java.lang.String LIFNR) {
        this.LIFNR = LIFNR;
    }


    /**
     * Gets the LFDAT value for this DT_GRP_MM0710_ConBodyLIKP.
     * 
     * @return LFDAT   * 납품일자
     */
    public java.lang.String getLFDAT() {
        return LFDAT;
    }


    /**
     * Sets the LFDAT value for this DT_GRP_MM0710_ConBodyLIKP.
     * 
     * @param LFDAT   * 납품일자
     */
    public void setLFDAT(java.lang.String LFDAT) {
        this.LFDAT = LFDAT;
    }


    /**
     * Gets the TYPE value for this DT_GRP_MM0710_ConBodyLIKP.
     * 
     * @return TYPE   * 상태
     */
    public java.lang.String getTYPE() {
        return TYPE;
    }


    /**
     * Sets the TYPE value for this DT_GRP_MM0710_ConBodyLIKP.
     * 
     * @param TYPE   * 상태
     */
    public void setTYPE(java.lang.String TYPE) {
        this.TYPE = TYPE;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_GRP_MM0710_ConBodyLIKP)) return false;
        DT_GRP_MM0710_ConBodyLIKP other = (DT_GRP_MM0710_ConBodyLIKP) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.LIFEX==null && other.getLIFEX()==null) || 
             (this.LIFEX!=null &&
              this.LIFEX.equals(other.getLIFEX()))) &&
            ((this.VBELN==null && other.getVBELN()==null) || 
             (this.VBELN!=null &&
              this.VBELN.equals(other.getVBELN()))) &&
            ((this.LIFNR==null && other.getLIFNR()==null) || 
             (this.LIFNR!=null &&
              this.LIFNR.equals(other.getLIFNR()))) &&
            ((this.LFDAT==null && other.getLFDAT()==null) || 
             (this.LFDAT!=null &&
              this.LFDAT.equals(other.getLFDAT()))) &&
            ((this.TYPE==null && other.getTYPE()==null) || 
             (this.TYPE!=null &&
              this.TYPE.equals(other.getTYPE())));
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
        if (getLIFEX() != null) {
            _hashCode += getLIFEX().hashCode();
        }
        if (getVBELN() != null) {
            _hashCode += getVBELN().hashCode();
        }
        if (getLIFNR() != null) {
            _hashCode += getLIFNR().hashCode();
        }
        if (getLFDAT() != null) {
            _hashCode += getLFDAT().hashCode();
        }
        if (getTYPE() != null) {
            _hashCode += getTYPE().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_GRP_MM0710_ConBodyLIKP.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://grpeccmm.esp.com/k2pkbb", ">>DT_GRP_MM0710_Con>Body>LIKP"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LIFEX");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LIFEX"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("VBELN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "VBELN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LIFNR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LIFNR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LFDAT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LFDAT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("TYPE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "TYPE"));
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
