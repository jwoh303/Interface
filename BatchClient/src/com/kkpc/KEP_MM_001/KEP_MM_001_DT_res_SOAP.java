/**
 * KEP_MM_001_DT_res_SOAP.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.kkpc.KEP_MM_001;

public class KEP_MM_001_DT_res_SOAP  implements java.io.Serializable {
    private java.lang.String EBELN;

    private java.lang.String ZRTCD;

    private java.lang.String ZRTMSG;

    public KEP_MM_001_DT_res_SOAP() {
    }

    public KEP_MM_001_DT_res_SOAP(
           java.lang.String EBELN,
           java.lang.String ZRTCD,
           java.lang.String ZRTMSG) {
           this.EBELN = EBELN;
           this.ZRTCD = ZRTCD;
           this.ZRTMSG = ZRTMSG;
    }


    /**
     * Gets the EBELN value for this KEP_MM_001_DT_res_SOAP.
     * 
     * @return EBELN
     */
    public java.lang.String getEBELN() {
        return EBELN;
    }


    /**
     * Sets the EBELN value for this KEP_MM_001_DT_res_SOAP.
     * 
     * @param EBELN
     */
    public void setEBELN(java.lang.String EBELN) {
        this.EBELN = EBELN;
    }


    /**
     * Gets the ZRTCD value for this KEP_MM_001_DT_res_SOAP.
     * 
     * @return ZRTCD
     */
    public java.lang.String getZRTCD() {
        return ZRTCD;
    }


    /**
     * Sets the ZRTCD value for this KEP_MM_001_DT_res_SOAP.
     * 
     * @param ZRTCD
     */
    public void setZRTCD(java.lang.String ZRTCD) {
        this.ZRTCD = ZRTCD;
    }


    /**
     * Gets the ZRTMSG value for this KEP_MM_001_DT_res_SOAP.
     * 
     * @return ZRTMSG
     */
    public java.lang.String getZRTMSG() {
        return ZRTMSG;
    }


    /**
     * Sets the ZRTMSG value for this KEP_MM_001_DT_res_SOAP.
     * 
     * @param ZRTMSG
     */
    public void setZRTMSG(java.lang.String ZRTMSG) {
        this.ZRTMSG = ZRTMSG;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof KEP_MM_001_DT_res_SOAP)) return false;
        KEP_MM_001_DT_res_SOAP other = (KEP_MM_001_DT_res_SOAP) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.EBELN==null && other.getEBELN()==null) || 
             (this.EBELN!=null &&
              this.EBELN.equals(other.getEBELN()))) &&
            ((this.ZRTCD==null && other.getZRTCD()==null) || 
             (this.ZRTCD!=null &&
              this.ZRTCD.equals(other.getZRTCD()))) &&
            ((this.ZRTMSG==null && other.getZRTMSG()==null) || 
             (this.ZRTMSG!=null &&
              this.ZRTMSG.equals(other.getZRTMSG())));
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
        if (getEBELN() != null) {
            _hashCode += getEBELN().hashCode();
        }
        if (getZRTCD() != null) {
            _hashCode += getZRTCD().hashCode();
        }
        if (getZRTMSG() != null) {
            _hashCode += getZRTMSG().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(KEP_MM_001_DT_res_SOAP.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://kkpc.com/KEP_MM_001", "KEP_MM_001_DT_res_SOAP"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("EBELN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "EBELN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZRTCD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ZRTCD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZRTMSG");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ZRTMSG"));
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
