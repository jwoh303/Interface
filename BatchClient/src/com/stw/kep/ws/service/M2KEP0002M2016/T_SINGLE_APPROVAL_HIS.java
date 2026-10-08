/**
 * T_SINGLE_APPROVAL_HIS.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.stw.kep.ws.service.M2KEP0002M2016;

public class T_SINGLE_APPROVAL_HIS  implements java.io.Serializable {
    private java.lang.String APPRID;

    private int APPRSEQ;

    private java.lang.String APPRSTATUSCD;

    private java.lang.String ERRORDESC4;

    private java.lang.String INSERTUID;

    private java.lang.String INSERTDT;

    private java.lang.String UPDATEUID;

    private java.lang.String UPDATEDT;

    public T_SINGLE_APPROVAL_HIS() {
    }

    public T_SINGLE_APPROVAL_HIS(
           java.lang.String APPRID,
           int APPRSEQ,
           java.lang.String APPRSTATUSCD,
           java.lang.String ERRORDESC4,
           java.lang.String INSERTUID,
           java.lang.String INSERTDT,
           java.lang.String UPDATEUID,
           java.lang.String UPDATEDT) {
           this.APPRID = APPRID;
           this.APPRSEQ = APPRSEQ;
           this.APPRSTATUSCD = APPRSTATUSCD;
           this.ERRORDESC4 = ERRORDESC4;
           this.INSERTUID = INSERTUID;
           this.INSERTDT = INSERTDT;
           this.UPDATEUID = UPDATEUID;
           this.UPDATEDT = UPDATEDT;
    }


    /**
     * Gets the APPRID value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @return APPRID
     */
    public java.lang.String getAPPRID() {
        return APPRID;
    }


    /**
     * Sets the APPRID value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @param APPRID
     */
    public void setAPPRID(java.lang.String APPRID) {
        this.APPRID = APPRID;
    }


    /**
     * Gets the APPRSEQ value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @return APPRSEQ
     */
    public int getAPPRSEQ() {
        return APPRSEQ;
    }


    /**
     * Sets the APPRSEQ value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @param APPRSEQ
     */
    public void setAPPRSEQ(int APPRSEQ) {
        this.APPRSEQ = APPRSEQ;
    }


    /**
     * Gets the APPRSTATUSCD value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @return APPRSTATUSCD
     */
    public java.lang.String getAPPRSTATUSCD() {
        return APPRSTATUSCD;
    }


    /**
     * Sets the APPRSTATUSCD value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @param APPRSTATUSCD
     */
    public void setAPPRSTATUSCD(java.lang.String APPRSTATUSCD) {
        this.APPRSTATUSCD = APPRSTATUSCD;
    }


    /**
     * Gets the ERRORDESC4 value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @return ERRORDESC4
     */
    public java.lang.String getERRORDESC4() {
        return ERRORDESC4;
    }


    /**
     * Sets the ERRORDESC4 value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @param ERRORDESC4
     */
    public void setERRORDESC4(java.lang.String ERRORDESC4) {
        this.ERRORDESC4 = ERRORDESC4;
    }


    /**
     * Gets the INSERTUID value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @return INSERTUID
     */
    public java.lang.String getINSERTUID() {
        return INSERTUID;
    }


    /**
     * Sets the INSERTUID value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @param INSERTUID
     */
    public void setINSERTUID(java.lang.String INSERTUID) {
        this.INSERTUID = INSERTUID;
    }


    /**
     * Gets the INSERTDT value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @return INSERTDT
     */
    public java.lang.String getINSERTDT() {
        return INSERTDT;
    }


    /**
     * Sets the INSERTDT value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @param INSERTDT
     */
    public void setINSERTDT(java.lang.String INSERTDT) {
        this.INSERTDT = INSERTDT;
    }


    /**
     * Gets the UPDATEUID value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @return UPDATEUID
     */
    public java.lang.String getUPDATEUID() {
        return UPDATEUID;
    }


    /**
     * Sets the UPDATEUID value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @param UPDATEUID
     */
    public void setUPDATEUID(java.lang.String UPDATEUID) {
        this.UPDATEUID = UPDATEUID;
    }


    /**
     * Gets the UPDATEDT value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @return UPDATEDT
     */
    public java.lang.String getUPDATEDT() {
        return UPDATEDT;
    }


    /**
     * Sets the UPDATEDT value for this T_SINGLE_APPROVAL_HIS.
     * 
     * @param UPDATEDT
     */
    public void setUPDATEDT(java.lang.String UPDATEDT) {
        this.UPDATEDT = UPDATEDT;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof T_SINGLE_APPROVAL_HIS)) return false;
        T_SINGLE_APPROVAL_HIS other = (T_SINGLE_APPROVAL_HIS) obj;
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
            this.APPRSEQ == other.getAPPRSEQ() &&
            ((this.APPRSTATUSCD==null && other.getAPPRSTATUSCD()==null) || 
             (this.APPRSTATUSCD!=null &&
              this.APPRSTATUSCD.equals(other.getAPPRSTATUSCD()))) &&
            ((this.ERRORDESC4==null && other.getERRORDESC4()==null) || 
             (this.ERRORDESC4!=null &&
              this.ERRORDESC4.equals(other.getERRORDESC4()))) &&
            ((this.INSERTUID==null && other.getINSERTUID()==null) || 
             (this.INSERTUID!=null &&
              this.INSERTUID.equals(other.getINSERTUID()))) &&
            ((this.INSERTDT==null && other.getINSERTDT()==null) || 
             (this.INSERTDT!=null &&
              this.INSERTDT.equals(other.getINSERTDT()))) &&
            ((this.UPDATEUID==null && other.getUPDATEUID()==null) || 
             (this.UPDATEUID!=null &&
              this.UPDATEUID.equals(other.getUPDATEUID()))) &&
            ((this.UPDATEDT==null && other.getUPDATEDT()==null) || 
             (this.UPDATEDT!=null &&
              this.UPDATEDT.equals(other.getUPDATEDT())));
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
        _hashCode += getAPPRSEQ();
        if (getAPPRSTATUSCD() != null) {
            _hashCode += getAPPRSTATUSCD().hashCode();
        }
        if (getERRORDESC4() != null) {
            _hashCode += getERRORDESC4().hashCode();
        }
        if (getINSERTUID() != null) {
            _hashCode += getINSERTUID().hashCode();
        }
        if (getINSERTDT() != null) {
            _hashCode += getINSERTDT().hashCode();
        }
        if (getUPDATEUID() != null) {
            _hashCode += getUPDATEUID().hashCode();
        }
        if (getUPDATEDT() != null) {
            _hashCode += getUPDATEDT().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(T_SINGLE_APPROVAL_HIS.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://M2KEP0002M2016.service.ws.kep.stw.com/", "T_SINGLE_APPROVAL_HIS"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRSEQ");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRSEQ"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
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
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("INSERTUID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "INSERTUID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("INSERTDT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "INSERTDT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("UPDATEUID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "UPDATEUID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("UPDATEDT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "UPDATEDT"));
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
