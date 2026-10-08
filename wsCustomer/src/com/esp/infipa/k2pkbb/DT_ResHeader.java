/**
 * DT_ResHeader.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.infipa.k2pkbb;

public class DT_ResHeader  implements java.io.Serializable {
    private java.lang.String zResultCd;

    private java.lang.String zResultMsg;

    public DT_ResHeader() {
    }

    public DT_ResHeader(
           java.lang.String zResultCd,
           java.lang.String zResultMsg) {
           this.zResultCd = zResultCd;
           this.zResultMsg = zResultMsg;
    }


    /**
     * Gets the zResultCd value for this DT_ResHeader.
     * 
     * @return zResultCd
     */
    public java.lang.String getZResultCd() {
        return zResultCd;
    }


    /**
     * Sets the zResultCd value for this DT_ResHeader.
     * 
     * @param zResultCd
     */
    public void setZResultCd(java.lang.String zResultCd) {
        this.zResultCd = zResultCd;
    }


    /**
     * Gets the zResultMsg value for this DT_ResHeader.
     * 
     * @return zResultMsg
     */
    public java.lang.String getZResultMsg() {
        return zResultMsg;
    }


    /**
     * Sets the zResultMsg value for this DT_ResHeader.
     * 
     * @param zResultMsg
     */
    public void setZResultMsg(java.lang.String zResultMsg) {
        this.zResultMsg = zResultMsg;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_ResHeader)) return false;
        DT_ResHeader other = (DT_ResHeader) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.zResultCd==null && other.getZResultCd()==null) || 
             (this.zResultCd!=null &&
              this.zResultCd.equals(other.getZResultCd()))) &&
            ((this.zResultMsg==null && other.getZResultMsg()==null) || 
             (this.zResultMsg!=null &&
              this.zResultMsg.equals(other.getZResultMsg())));
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
        if (getZResultCd() != null) {
            _hashCode += getZResultCd().hashCode();
        }
        if (getZResultMsg() != null) {
            _hashCode += getZResultMsg().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_ResHeader.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://infipa.esp.com/k2pkbb", "DT_ResHeader"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZResultCd");
        elemField.setXmlName(new javax.xml.namespace.QName("", "zResultCd"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZResultMsg");
        elemField.setXmlName(new javax.xml.namespace.QName("", "zResultMsg"));
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
