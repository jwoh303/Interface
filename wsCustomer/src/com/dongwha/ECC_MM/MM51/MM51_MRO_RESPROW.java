/**
 * MM51_MRO_RESPROW.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dongwha.ECC_MM.MM51;

public class MM51_MRO_RESPROW  implements java.io.Serializable {
    private java.lang.String IF_NO;

    private java.lang.String RESULT_FLAG;

    private java.lang.String RESULT_MSG;

    public MM51_MRO_RESPROW() {
    }

    public MM51_MRO_RESPROW(
           java.lang.String IF_NO,
           java.lang.String RESULT_FLAG,
           java.lang.String RESULT_MSG) {
           this.IF_NO = IF_NO;
           this.RESULT_FLAG = RESULT_FLAG;
           this.RESULT_MSG = RESULT_MSG;
    }


    /**
     * Gets the IF_NO value for this MM51_MRO_RESPROW.
     * 
     * @return IF_NO
     */
    public java.lang.String getIF_NO() {
        return IF_NO;
    }


    /**
     * Sets the IF_NO value for this MM51_MRO_RESPROW.
     * 
     * @param IF_NO
     */
    public void setIF_NO(java.lang.String IF_NO) {
        this.IF_NO = IF_NO;
    }


    /**
     * Gets the RESULT_FLAG value for this MM51_MRO_RESPROW.
     * 
     * @return RESULT_FLAG
     */
    public java.lang.String getRESULT_FLAG() {
        return RESULT_FLAG;
    }


    /**
     * Sets the RESULT_FLAG value for this MM51_MRO_RESPROW.
     * 
     * @param RESULT_FLAG
     */
    public void setRESULT_FLAG(java.lang.String RESULT_FLAG) {
        this.RESULT_FLAG = RESULT_FLAG;
    }


    /**
     * Gets the RESULT_MSG value for this MM51_MRO_RESPROW.
     * 
     * @return RESULT_MSG
     */
    public java.lang.String getRESULT_MSG() {
        return RESULT_MSG;
    }


    /**
     * Sets the RESULT_MSG value for this MM51_MRO_RESPROW.
     * 
     * @param RESULT_MSG
     */
    public void setRESULT_MSG(java.lang.String RESULT_MSG) {
        this.RESULT_MSG = RESULT_MSG;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof MM51_MRO_RESPROW)) return false;
        MM51_MRO_RESPROW other = (MM51_MRO_RESPROW) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.IF_NO==null && other.getIF_NO()==null) || 
             (this.IF_NO!=null &&
              this.IF_NO.equals(other.getIF_NO()))) &&
            ((this.RESULT_FLAG==null && other.getRESULT_FLAG()==null) || 
             (this.RESULT_FLAG!=null &&
              this.RESULT_FLAG.equals(other.getRESULT_FLAG()))) &&
            ((this.RESULT_MSG==null && other.getRESULT_MSG()==null) || 
             (this.RESULT_MSG!=null &&
              this.RESULT_MSG.equals(other.getRESULT_MSG())));
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
        if (getIF_NO() != null) {
            _hashCode += getIF_NO().hashCode();
        }
        if (getRESULT_FLAG() != null) {
            _hashCode += getRESULT_FLAG().hashCode();
        }
        if (getRESULT_MSG() != null) {
            _hashCode += getRESULT_MSG().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(MM51_MRO_RESPROW.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://dongwha.co.kr/ECC_MM/MM51", ">MM51_MRO_RESP>ROW"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("IF_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "IF_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RESULT_FLAG");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RESULT_FLAG"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RESULT_MSG");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RESULT_MSG"));
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
