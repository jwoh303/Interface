/**
 * T_APPR_LINE_RETURN.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.hwdefense;

@SuppressWarnings("serial")
public class T_APPR_LINE_RETURN  implements java.io.Serializable {
    private java.lang.String APPRID;

    private java.lang.String APPRSEQ;

    private java.lang.String APPRSTATUSCD;

    private java.lang.String ERRORDESC4;

    public T_APPR_LINE_RETURN() {
    }

    public T_APPR_LINE_RETURN(
           java.lang.String APPRID,
           java.lang.String APPRSEQ,
           java.lang.String APPRSTATUSCD,
           java.lang.String ERRORDESC4) {
           this.APPRID = APPRID;
           this.APPRSEQ = APPRSEQ;
           this.APPRSTATUSCD = APPRSTATUSCD;
           this.ERRORDESC4 = ERRORDESC4;
    }


    /**
     * Gets the APPRID value for this T_APPR_LINE_RETURN.
     * 
     * @return APPRID
     */
    public java.lang.String getAPPRID() {
        return APPRID;
    }


    /**
     * Sets the APPRID value for this T_APPR_LINE_RETURN.
     * 
     * @param APPRID
     */
    public void setAPPRID(java.lang.String APPRID) {
        this.APPRID = APPRID;
    }


    /**
     * Gets the APPRSEQ value for this T_APPR_LINE_RETURN.
     * 
     * @return APPRSEQ
     */
    public java.lang.String getAPPRSEQ() {
        return APPRSEQ;
    }


    /**
     * Sets the APPRSEQ value for this T_APPR_LINE_RETURN.
     * 
     * @param APPRSEQ
     */
    public void setAPPRSEQ(java.lang.String APPRSEQ) {
        this.APPRSEQ = APPRSEQ;
    }


    /**
     * Gets the APPRSTATUSCD value for this T_APPR_LINE_RETURN.
     * 
     * @return APPRSTATUSCD
     */
    public java.lang.String getAPPRSTATUSCD() {
        return APPRSTATUSCD;
    }


    /**
     * Sets the APPRSTATUSCD value for this T_APPR_LINE_RETURN.
     * 
     * @param APPRSTATUSCD
     */
    public void setAPPRSTATUSCD(java.lang.String APPRSTATUSCD) {
        this.APPRSTATUSCD = APPRSTATUSCD;
    }


    /**
     * Gets the ERRORDESC4 value for this T_APPR_LINE_RETURN.
     * 
     * @return ERRORDESC4
     */
    public java.lang.String getERRORDESC4() {
        return ERRORDESC4;
    }


    /**
     * Sets the ERRORDESC4 value for this T_APPR_LINE_RETURN.
     * 
     * @param ERRORDESC4
     */
    public void setERRORDESC4(java.lang.String ERRORDESC4) {
        this.ERRORDESC4 = ERRORDESC4;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof T_APPR_LINE_RETURN)) return false;
        T_APPR_LINE_RETURN other = (T_APPR_LINE_RETURN) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.APPRID==null && other.getAPPRID()==null) || 
             (this.APPRID!=null &&
              this.APPRID.equals(other.getAPPRID()))) &&
            ((this.APPRSEQ==null && other.getAPPRSEQ()==null) || 
             (this.APPRSEQ!=null &&
              this.APPRSEQ.equals(other.getAPPRSEQ()))) &&
            ((this.APPRSTATUSCD==null && other.getAPPRSTATUSCD()==null) || 
             (this.APPRSTATUSCD!=null &&
              this.APPRSTATUSCD.equals(other.getAPPRSTATUSCD()))) &&
            ((this.ERRORDESC4==null && other.getERRORDESC4()==null) || 
             (this.ERRORDESC4!=null &&
              this.ERRORDESC4.equals(other.getERRORDESC4())));
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
        if (getAPPRID() != null) {
            _hashCode += getAPPRID().hashCode();
        }
        if (getAPPRSEQ() != null) {
            _hashCode += getAPPRSEQ().hashCode();
        }
        if (getAPPRSTATUSCD() != null) {
            _hashCode += getAPPRSTATUSCD().hashCode();
        }
        if (getERRORDESC4() != null) {
            _hashCode += getERRORDESC4().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(T_APPR_LINE_RETURN.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "T_APPR_LINE_RETURN"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRSEQ");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRSEQ"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRSTATUSCD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRSTATUSCD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ERRORDESC4");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ERRORDESC4"));
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
