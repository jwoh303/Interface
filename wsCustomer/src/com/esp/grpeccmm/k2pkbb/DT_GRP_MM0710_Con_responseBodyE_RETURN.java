/**
 * DT_GRP_MM0710_Con_responseBodyE_RETURN.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.grpeccmm.k2pkbb;

public class DT_GRP_MM0710_Con_responseBodyE_RETURN  implements java.io.Serializable {
    /* 리턴 메시지 타입 */
    private java.lang.String MSGTYPE;

    /* 리턴 메시지 */
    private java.lang.String MESSAGE;

    /* 입고예약번호 (KEP) */
    private java.lang.String LIFEX;

    /* 납품문서번호 (SAP) */
    private java.lang.String VBELN;

    public DT_GRP_MM0710_Con_responseBodyE_RETURN() {
    }

    public DT_GRP_MM0710_Con_responseBodyE_RETURN(
           java.lang.String MSGTYPE,
           java.lang.String MESSAGE,
           java.lang.String LIFEX,
           java.lang.String VBELN) {
           this.MSGTYPE = MSGTYPE;
           this.MESSAGE = MESSAGE;
           this.LIFEX = LIFEX;
           this.VBELN = VBELN;
    }


    /**
     * Gets the MSGTYPE value for this DT_GRP_MM0710_Con_responseBodyE_RETURN.
     * 
     * @return MSGTYPE   * 리턴 메시지 타입
     */
    public java.lang.String getMSGTYPE() {
        return MSGTYPE;
    }


    /**
     * Sets the MSGTYPE value for this DT_GRP_MM0710_Con_responseBodyE_RETURN.
     * 
     * @param MSGTYPE   * 리턴 메시지 타입
     */
    public void setMSGTYPE(java.lang.String MSGTYPE) {
        this.MSGTYPE = MSGTYPE;
    }


    /**
     * Gets the MESSAGE value for this DT_GRP_MM0710_Con_responseBodyE_RETURN.
     * 
     * @return MESSAGE   * 리턴 메시지
     */
    public java.lang.String getMESSAGE() {
        return MESSAGE;
    }


    /**
     * Sets the MESSAGE value for this DT_GRP_MM0710_Con_responseBodyE_RETURN.
     * 
     * @param MESSAGE   * 리턴 메시지
     */
    public void setMESSAGE(java.lang.String MESSAGE) {
        this.MESSAGE = MESSAGE;
    }


    /**
     * Gets the LIFEX value for this DT_GRP_MM0710_Con_responseBodyE_RETURN.
     * 
     * @return LIFEX   * 입고예약번호 (KEP)
     */
    public java.lang.String getLIFEX() {
        return LIFEX;
    }


    /**
     * Sets the LIFEX value for this DT_GRP_MM0710_Con_responseBodyE_RETURN.
     * 
     * @param LIFEX   * 입고예약번호 (KEP)
     */
    public void setLIFEX(java.lang.String LIFEX) {
        this.LIFEX = LIFEX;
    }


    /**
     * Gets the VBELN value for this DT_GRP_MM0710_Con_responseBodyE_RETURN.
     * 
     * @return VBELN   * 납품문서번호 (SAP)
     */
    public java.lang.String getVBELN() {
        return VBELN;
    }


    /**
     * Sets the VBELN value for this DT_GRP_MM0710_Con_responseBodyE_RETURN.
     * 
     * @param VBELN   * 납품문서번호 (SAP)
     */
    public void setVBELN(java.lang.String VBELN) {
        this.VBELN = VBELN;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_GRP_MM0710_Con_responseBodyE_RETURN)) return false;
        DT_GRP_MM0710_Con_responseBodyE_RETURN other = (DT_GRP_MM0710_Con_responseBodyE_RETURN) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.MSGTYPE==null && other.getMSGTYPE()==null) || 
             (this.MSGTYPE!=null &&
              this.MSGTYPE.equals(other.getMSGTYPE()))) &&
            ((this.MESSAGE==null && other.getMESSAGE()==null) || 
             (this.MESSAGE!=null &&
              this.MESSAGE.equals(other.getMESSAGE()))) &&
            ((this.LIFEX==null && other.getLIFEX()==null) || 
             (this.LIFEX!=null &&
              this.LIFEX.equals(other.getLIFEX()))) &&
            ((this.VBELN==null && other.getVBELN()==null) || 
             (this.VBELN!=null &&
              this.VBELN.equals(other.getVBELN())));
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
        if (getMSGTYPE() != null) {
            _hashCode += getMSGTYPE().hashCode();
        }
        if (getMESSAGE() != null) {
            _hashCode += getMESSAGE().hashCode();
        }
        if (getLIFEX() != null) {
            _hashCode += getLIFEX().hashCode();
        }
        if (getVBELN() != null) {
            _hashCode += getVBELN().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_GRP_MM0710_Con_responseBodyE_RETURN.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://grpeccmm.esp.com/k2pkbb", ">>DT_GRP_MM0710_Con_response>Body>E_RETURN"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MSGTYPE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "MSGTYPE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MESSAGE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "MESSAGE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LIFEX");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LIFEX"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("VBELN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "VBELN"));
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
