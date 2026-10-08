/**
 * COMMON11_MRO_RESP.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.dongwha.COMMON.COMMON11;

public class COMMON11_MRO_RESP  implements java.io.Serializable {
    private java.lang.String IFSTATUS;

    public COMMON11_MRO_RESP() {
    }

    public COMMON11_MRO_RESP(
           java.lang.String IFSTATUS) {
           this.IFSTATUS = IFSTATUS;
    }


    /**
     * Gets the IFSTATUS value for this COMMON11_MRO_RESP.
     * 
     * @return IFSTATUS
     */
    public java.lang.String getIFSTATUS() {
        return IFSTATUS;
    }


    /**
     * Sets the IFSTATUS value for this COMMON11_MRO_RESP.
     * 
     * @param IFSTATUS
     */
    public void setIFSTATUS(java.lang.String IFSTATUS) {
        this.IFSTATUS = IFSTATUS;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof COMMON11_MRO_RESP)) return false;
        COMMON11_MRO_RESP other = (COMMON11_MRO_RESP) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.IFSTATUS==null && other.getIFSTATUS()==null) || 
             (this.IFSTATUS!=null &&
              this.IFSTATUS.equals(other.getIFSTATUS())));
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
        if (getIFSTATUS() != null) {
            _hashCode += getIFSTATUS().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(COMMON11_MRO_RESP.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://dongwha.com/COMMON/COMMON11", "COMMON11_MRO_RESP"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("IFSTATUS");
        elemField.setXmlName(new javax.xml.namespace.QName("", "IFSTATUS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
