/**
 * NE9090_KEPEH_SRMDH_SPAGING.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.hanwhaaerospace.KEPEH_SRMDH;

public class NE9090_KEPEH_SRMDH_SPAGING  implements java.io.Serializable {
    /* 현재 페이지 번호 */
    private java.lang.String CURRENT_PAGE;

    /* 마지막 페이지 번호 */
    private java.lang.String LAST_PAGE;

    /* GUID(UUID) */
    private java.lang.String GUID;

    public NE9090_KEPEH_SRMDH_SPAGING() {
    }

    public NE9090_KEPEH_SRMDH_SPAGING(
           java.lang.String CURRENT_PAGE,
           java.lang.String LAST_PAGE,
           java.lang.String GUID) {
           this.CURRENT_PAGE = CURRENT_PAGE;
           this.LAST_PAGE = LAST_PAGE;
           this.GUID = GUID;
    }


    /**
     * Gets the CURRENT_PAGE value for this NE9090_KEPEH_SRMDH_SPAGING.
     * 
     * @return CURRENT_PAGE   * 현재 페이지 번호
     */
    public java.lang.String getCURRENT_PAGE() {
        return CURRENT_PAGE;
    }


    /**
     * Sets the CURRENT_PAGE value for this NE9090_KEPEH_SRMDH_SPAGING.
     * 
     * @param CURRENT_PAGE   * 현재 페이지 번호
     */
    public void setCURRENT_PAGE(java.lang.String CURRENT_PAGE) {
        this.CURRENT_PAGE = CURRENT_PAGE;
    }


    /**
     * Gets the LAST_PAGE value for this NE9090_KEPEH_SRMDH_SPAGING.
     * 
     * @return LAST_PAGE   * 마지막 페이지 번호
     */
    public java.lang.String getLAST_PAGE() {
        return LAST_PAGE;
    }


    /**
     * Sets the LAST_PAGE value for this NE9090_KEPEH_SRMDH_SPAGING.
     * 
     * @param LAST_PAGE   * 마지막 페이지 번호
     */
    public void setLAST_PAGE(java.lang.String LAST_PAGE) {
        this.LAST_PAGE = LAST_PAGE;
    }


    /**
     * Gets the GUID value for this NE9090_KEPEH_SRMDH_SPAGING.
     * 
     * @return GUID   * GUID(UUID)
     */
    public java.lang.String getGUID() {
        return GUID;
    }


    /**
     * Sets the GUID value for this NE9090_KEPEH_SRMDH_SPAGING.
     * 
     * @param GUID   * GUID(UUID)
     */
    public void setGUID(java.lang.String GUID) {
        this.GUID = GUID;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof NE9090_KEPEH_SRMDH_SPAGING)) return false;
        NE9090_KEPEH_SRMDH_SPAGING other = (NE9090_KEPEH_SRMDH_SPAGING) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.CURRENT_PAGE==null && other.getCURRENT_PAGE()==null) || 
             (this.CURRENT_PAGE!=null &&
              this.CURRENT_PAGE.equals(other.getCURRENT_PAGE()))) &&
            ((this.LAST_PAGE==null && other.getLAST_PAGE()==null) || 
             (this.LAST_PAGE!=null &&
              this.LAST_PAGE.equals(other.getLAST_PAGE()))) &&
            ((this.GUID==null && other.getGUID()==null) || 
             (this.GUID!=null &&
              this.GUID.equals(other.getGUID())));
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
        if (getCURRENT_PAGE() != null) {
            _hashCode += getCURRENT_PAGE().hashCode();
        }
        if (getLAST_PAGE() != null) {
            _hashCode += getLAST_PAGE().hashCode();
        }
        if (getGUID() != null) {
            _hashCode += getGUID().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(NE9090_KEPEH_SRMDH_SPAGING.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://hanwhaaerospace.com/KEPEH_SRMDH", ">NE9090_KEPEH_SRMDH_S>PAGING"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CURRENT_PAGE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CURRENT_PAGE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LAST_PAGE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LAST_PAGE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("GUID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "GUID"));
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
