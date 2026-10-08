/**
 * DT_INFMPO0030_Con_response.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.infmpo.k2pkbb;

public class DT_INFMPO0030_Con_response  implements java.io.Serializable {
    private com.esp.infmpo.k2pkbb.DT_ResHeader header;

    public DT_INFMPO0030_Con_response() {
    }

    public DT_INFMPO0030_Con_response(
           com.esp.infmpo.k2pkbb.DT_ResHeader header) {
           this.header = header;
    }


    /**
     * Gets the header value for this DT_INFMPO0030_Con_response.
     * 
     * @return header
     */
    public com.esp.infmpo.k2pkbb.DT_ResHeader getHeader() {
        return header;
    }


    /**
     * Sets the header value for this DT_INFMPO0030_Con_response.
     * 
     * @param header
     */
    public void setHeader(com.esp.infmpo.k2pkbb.DT_ResHeader header) {
        this.header = header;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_INFMPO0030_Con_response)) return false;
        DT_INFMPO0030_Con_response other = (DT_INFMPO0030_Con_response) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.header==null && other.getHeader()==null) || 
             (this.header!=null &&
              this.header.equals(other.getHeader())));
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
        if (getHeader() != null) {
            _hashCode += getHeader().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_INFMPO0030_Con_response.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", "DT_INFMPO0030_Con_response"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("header");
        elemField.setXmlName(new javax.xml.namespace.QName("", "Header"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", "DT_ResHeader"));
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
