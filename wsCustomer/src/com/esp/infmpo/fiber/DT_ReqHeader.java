/**
 * DT_ReqHeader.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.infmpo.fiber;

public class DT_ReqHeader  implements java.io.Serializable {
    private java.lang.String zInterfaceId;

    private java.lang.String zConSysId;

    private java.lang.String zProSysId;

    private java.lang.String zUserId;

    private java.lang.String zPiUser;

    private java.lang.String zTimeId;

    public DT_ReqHeader() {
    }

    public DT_ReqHeader(
           java.lang.String zInterfaceId,
           java.lang.String zConSysId,
           java.lang.String zProSysId,
           java.lang.String zUserId,
           java.lang.String zPiUser,
           java.lang.String zTimeId) {
           this.zInterfaceId = zInterfaceId;
           this.zConSysId = zConSysId;
           this.zProSysId = zProSysId;
           this.zUserId = zUserId;
           this.zPiUser = zPiUser;
           this.zTimeId = zTimeId;
    }


    /**
     * Gets the zInterfaceId value for this DT_ReqHeader.
     * 
     * @return zInterfaceId
     */
    public java.lang.String getZInterfaceId() {
        return zInterfaceId;
    }


    /**
     * Sets the zInterfaceId value for this DT_ReqHeader.
     * 
     * @param zInterfaceId
     */
    public void setZInterfaceId(java.lang.String zInterfaceId) {
        this.zInterfaceId = zInterfaceId;
    }


    /**
     * Gets the zConSysId value for this DT_ReqHeader.
     * 
     * @return zConSysId
     */
    public java.lang.String getZConSysId() {
        return zConSysId;
    }


    /**
     * Sets the zConSysId value for this DT_ReqHeader.
     * 
     * @param zConSysId
     */
    public void setZConSysId(java.lang.String zConSysId) {
        this.zConSysId = zConSysId;
    }


    /**
     * Gets the zProSysId value for this DT_ReqHeader.
     * 
     * @return zProSysId
     */
    public java.lang.String getZProSysId() {
        return zProSysId;
    }


    /**
     * Sets the zProSysId value for this DT_ReqHeader.
     * 
     * @param zProSysId
     */
    public void setZProSysId(java.lang.String zProSysId) {
        this.zProSysId = zProSysId;
    }


    /**
     * Gets the zUserId value for this DT_ReqHeader.
     * 
     * @return zUserId
     */
    public java.lang.String getZUserId() {
        return zUserId;
    }


    /**
     * Sets the zUserId value for this DT_ReqHeader.
     * 
     * @param zUserId
     */
    public void setZUserId(java.lang.String zUserId) {
        this.zUserId = zUserId;
    }


    /**
     * Gets the zPiUser value for this DT_ReqHeader.
     * 
     * @return zPiUser
     */
    public java.lang.String getZPiUser() {
        return zPiUser;
    }


    /**
     * Sets the zPiUser value for this DT_ReqHeader.
     * 
     * @param zPiUser
     */
    public void setZPiUser(java.lang.String zPiUser) {
        this.zPiUser = zPiUser;
    }


    /**
     * Gets the zTimeId value for this DT_ReqHeader.
     * 
     * @return zTimeId
     */
    public java.lang.String getZTimeId() {
        return zTimeId;
    }


    /**
     * Sets the zTimeId value for this DT_ReqHeader.
     * 
     * @param zTimeId
     */
    public void setZTimeId(java.lang.String zTimeId) {
        this.zTimeId = zTimeId;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_ReqHeader)) return false;
        DT_ReqHeader other = (DT_ReqHeader) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.zInterfaceId==null && other.getZInterfaceId()==null) || 
             (this.zInterfaceId!=null &&
              this.zInterfaceId.equals(other.getZInterfaceId()))) &&
            ((this.zConSysId==null && other.getZConSysId()==null) || 
             (this.zConSysId!=null &&
              this.zConSysId.equals(other.getZConSysId()))) &&
            ((this.zProSysId==null && other.getZProSysId()==null) || 
             (this.zProSysId!=null &&
              this.zProSysId.equals(other.getZProSysId()))) &&
            ((this.zUserId==null && other.getZUserId()==null) || 
             (this.zUserId!=null &&
              this.zUserId.equals(other.getZUserId()))) &&
            ((this.zPiUser==null && other.getZPiUser()==null) || 
             (this.zPiUser!=null &&
              this.zPiUser.equals(other.getZPiUser()))) &&
            ((this.zTimeId==null && other.getZTimeId()==null) || 
             (this.zTimeId!=null &&
              this.zTimeId.equals(other.getZTimeId())));
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
        if (getZInterfaceId() != null) {
            _hashCode += getZInterfaceId().hashCode();
        }
        if (getZConSysId() != null) {
            _hashCode += getZConSysId().hashCode();
        }
        if (getZProSysId() != null) {
            _hashCode += getZProSysId().hashCode();
        }
        if (getZUserId() != null) {
            _hashCode += getZUserId().hashCode();
        }
        if (getZPiUser() != null) {
            _hashCode += getZPiUser().hashCode();
        }
        if (getZTimeId() != null) {
            _hashCode += getZTimeId().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_ReqHeader.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", "DT_ReqHeader"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZInterfaceId");
        elemField.setXmlName(new javax.xml.namespace.QName("", "zInterfaceId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZConSysId");
        elemField.setXmlName(new javax.xml.namespace.QName("", "zConSysId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZProSysId");
        elemField.setXmlName(new javax.xml.namespace.QName("", "zProSysId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZUserId");
        elemField.setXmlName(new javax.xml.namespace.QName("", "zUserId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZPiUser");
        elemField.setXmlName(new javax.xml.namespace.QName("", "zPiUser"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ZTimeId");
        elemField.setXmlName(new javax.xml.namespace.QName("", "zTimeId"));
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
