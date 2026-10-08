/**
 * NE9090_KEPEH_SRMDH_S.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.hanwhaaerospace.KEPEH_SRMDH;

public class NE9090_KEPEH_SRMDH_S  implements java.io.Serializable {
    private com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SIFSTAT IFSTAT;

    private com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SPAGING PAGING;

    private com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_ST_GR_INFO[] t_GR_INFO;

    public NE9090_KEPEH_SRMDH_S() {
    }

    public NE9090_KEPEH_SRMDH_S(
           com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SIFSTAT IFSTAT,
        //   com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SPAGING PAGING,
           com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_ST_GR_INFO[] t_GR_INFO) {
           this.IFSTAT = IFSTAT;
           this.PAGING = PAGING;
           this.t_GR_INFO = t_GR_INFO;
    }


    /**
     * Gets the IFSTAT value for this NE9090_KEPEH_SRMDH_S.
     * 
     * @return IFSTAT
     */
    public com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SIFSTAT getIFSTAT() {
        return IFSTAT;
    }


    /**
     * Sets the IFSTAT value for this NE9090_KEPEH_SRMDH_S.
     * 
     * @param IFSTAT
     */
    public void setIFSTAT(com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SIFSTAT IFSTAT) {
        this.IFSTAT = IFSTAT;
    }


    /**
     * Gets the PAGING value for this NE9090_KEPEH_SRMDH_S.
     * 
     * @return PAGING
     */
    public com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SPAGING getPAGING() {
        return PAGING;
    }


    /**
     * Sets the PAGING value for this NE9090_KEPEH_SRMDH_S.
     * 
     * @param PAGING
     */
    public void setPAGING(com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SPAGING PAGING) {
        this.PAGING = PAGING;
    }


    /**
     * Gets the t_GR_INFO value for this NE9090_KEPEH_SRMDH_S.
     * 
     * @return t_GR_INFO
     */
    public com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_ST_GR_INFO[] getT_GR_INFO() {
        return t_GR_INFO;
    }


    /**
     * Sets the t_GR_INFO value for this NE9090_KEPEH_SRMDH_S.
     * 
     * @param t_GR_INFO
     */
    public void setT_GR_INFO(com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_ST_GR_INFO[] t_GR_INFO) {
        this.t_GR_INFO = t_GR_INFO;
    }

    public com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_ST_GR_INFO getT_GR_INFO(int i) {
        return this.t_GR_INFO[i];
    }

    public void setT_GR_INFO(int i, com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_ST_GR_INFO _value) {
        this.t_GR_INFO[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof NE9090_KEPEH_SRMDH_S)) return false;
        NE9090_KEPEH_SRMDH_S other = (NE9090_KEPEH_SRMDH_S) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.IFSTAT==null && other.getIFSTAT()==null) || 
             (this.IFSTAT!=null &&
              this.IFSTAT.equals(other.getIFSTAT()))) &&
            ((this.PAGING==null && other.getPAGING()==null) || 
             (this.PAGING!=null &&
              this.PAGING.equals(other.getPAGING()))) &&
            ((this.t_GR_INFO==null && other.getT_GR_INFO()==null) || 
             (this.t_GR_INFO!=null &&
              java.util.Arrays.equals(this.t_GR_INFO, other.getT_GR_INFO())));
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
        if (getIFSTAT() != null) {
            _hashCode += getIFSTAT().hashCode();
        }
        if (getPAGING() != null) {
            _hashCode += getPAGING().hashCode();
        }
        if (getT_GR_INFO() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getT_GR_INFO());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getT_GR_INFO(), i);
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
        new org.apache.axis.description.TypeDesc(NE9090_KEPEH_SRMDH_S.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://hanwhaaerospace.com/KEPEH_SRMDH", "NE9090_KEPEH_SRMDH_S"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("IFSTAT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "IFSTAT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://hanwhaaerospace.com/KEPEH_SRMDH", ">NE9090_KEPEH_SRMDH_S>IFSTAT"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PAGING");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PAGING"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://hanwhaaerospace.com/KEPEH_SRMDH", ">NE9090_KEPEH_SRMDH_S>PAGING"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("t_GR_INFO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "T_GR_INFO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://hanwhaaerospace.com/KEPEH_SRMDH", ">NE9090_KEPEH_SRMDH_S>T_GR_INFO"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
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
