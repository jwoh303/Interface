/**
 * DT_GRP_MM1200_Con.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.grpeccmm.k2pkbb;

public class DT_GRP_MM1200_Con  implements java.io.Serializable {
    private com.esp.grpeccmm.k2pkbb.DT_ReqHeader header;

    private com.esp.grpeccmm.k2pkbb.DT_GRP_MM1200_ConBodyDELIVERY_INFO[] body;

    public DT_GRP_MM1200_Con() {
    }

    public DT_GRP_MM1200_Con(
           com.esp.grpeccmm.k2pkbb.DT_ReqHeader header,
           com.esp.grpeccmm.k2pkbb.DT_GRP_MM1200_ConBodyDELIVERY_INFO[] body) {
           this.header = header;
           this.body = body;
    }


    /**
     * Gets the header value for this DT_GRP_MM1200_Con.
     * 
     * @return header
     */
    public com.esp.grpeccmm.k2pkbb.DT_ReqHeader getHeader() {
        return header;
    }


    /**
     * Sets the header value for this DT_GRP_MM1200_Con.
     * 
     * @param header
     */
    public void setHeader(com.esp.grpeccmm.k2pkbb.DT_ReqHeader header) {
        this.header = header;
    }


    /**
     * Gets the body value for this DT_GRP_MM1200_Con.
     * 
     * @return body
     */
    public com.esp.grpeccmm.k2pkbb.DT_GRP_MM1200_ConBodyDELIVERY_INFO[] getBody() {
        return body;
    }


    /**
     * Sets the body value for this DT_GRP_MM1200_Con.
     * 
     * @param body
     */
    public void setBody(com.esp.grpeccmm.k2pkbb.DT_GRP_MM1200_ConBodyDELIVERY_INFO[] body) {
        this.body = body;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_GRP_MM1200_Con)) return false;
        DT_GRP_MM1200_Con other = (DT_GRP_MM1200_Con) obj;
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
              this.header.equals(other.getHeader()))) &&
            ((this.body==null && other.getBody()==null) || 
             (this.body!=null &&
              java.util.Arrays.equals(this.body, other.getBody())));
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
        if (getBody() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getBody());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getBody(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_GRP_MM1200_Con.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://grpeccmm.esp.com/k2pkbb", "DT_GRP_MM1200_Con"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("header");
        elemField.setXmlName(new javax.xml.namespace.QName("", "Header"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://grpeccmm.esp.com/k2pkbb", "DT_ReqHeader"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("body");
        elemField.setXmlName(new javax.xml.namespace.QName("", "Body"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://grpeccmm.esp.com/k2pkbb", ">>DT_GRP_MM1200_Con>Body>DELIVERY_INFO"));
        elemField.setNillable(false);
        elemField.setItemQName(new javax.xml.namespace.QName("", "DELIVERY_INFO"));
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
