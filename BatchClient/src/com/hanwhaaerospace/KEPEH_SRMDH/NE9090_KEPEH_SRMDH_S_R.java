/**
 * NE9090_KEPEH_SRMDH_S_R.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.hanwhaaerospace.KEPEH_SRMDH;

public class NE9090_KEPEH_SRMDH_S_R  implements java.io.Serializable {
    private com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RIFSTAT IFSTAT;

    private com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RT_GR_RETURN[] t_GR_RETURN;

    public NE9090_KEPEH_SRMDH_S_R() {
    }

    public NE9090_KEPEH_SRMDH_S_R(
           com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RIFSTAT IFSTAT,
           com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RT_GR_RETURN[] t_GR_RETURN) {
           this.IFSTAT = IFSTAT;
           this.t_GR_RETURN = t_GR_RETURN;
    }


    /**
     * Gets the IFSTAT value for this NE9090_KEPEH_SRMDH_S_R.
     * 
     * @return IFSTAT
     */
    public com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RIFSTAT getIFSTAT() {
        return IFSTAT;
    }


    /**
     * Sets the IFSTAT value for this NE9090_KEPEH_SRMDH_S_R.
     * 
     * @param IFSTAT
     */
    public void setIFSTAT(com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RIFSTAT IFSTAT) {
        this.IFSTAT = IFSTAT;
    }


    /**
     * Gets the t_GR_RETURN value for this NE9090_KEPEH_SRMDH_S_R.
     * 
     * @return t_GR_RETURN
     */
    public com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RT_GR_RETURN[] getT_GR_RETURN() {
        return t_GR_RETURN;
    }


    /**
     * Sets the t_GR_RETURN value for this NE9090_KEPEH_SRMDH_S_R.
     * 
     * @param t_GR_RETURN
     */
    public void setT_GR_RETURN(com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RT_GR_RETURN[] t_GR_RETURN) {
        this.t_GR_RETURN = t_GR_RETURN;
    }

    public com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RT_GR_RETURN getT_GR_RETURN(int i) {
        return this.t_GR_RETURN[i];
    }

    public void setT_GR_RETURN(int i, com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_RT_GR_RETURN _value) {
        this.t_GR_RETURN[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof NE9090_KEPEH_SRMDH_S_R)) return false;
        NE9090_KEPEH_SRMDH_S_R other = (NE9090_KEPEH_SRMDH_S_R) obj;
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
            ((this.t_GR_RETURN==null && other.getT_GR_RETURN()==null) || 
             (this.t_GR_RETURN!=null &&
              java.util.Arrays.equals(this.t_GR_RETURN, other.getT_GR_RETURN())));
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
        if (getT_GR_RETURN() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getT_GR_RETURN());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getT_GR_RETURN(), i);
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
        new org.apache.axis.description.TypeDesc(NE9090_KEPEH_SRMDH_S_R.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://hanwhaaerospace.com/KEPEH_SRMDH", "NE9090_KEPEH_SRMDH_S_R"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("IFSTAT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "IFSTAT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://hanwhaaerospace.com/KEPEH_SRMDH", ">NE9090_KEPEH_SRMDH_S_R>IFSTAT"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("t_GR_RETURN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "T_GR_RETURN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://hanwhaaerospace.com/KEPEH_SRMDH", ">NE9090_KEPEH_SRMDH_S_R>T_GR_RETURN"));
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
