/**
 * DT_GRP_MM0710_ConBody.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.grpeccmm.fiber;

public class DT_GRP_MM0710_ConBody  implements java.io.Serializable {
    private com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIKP[] LIKP;

    private com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIPS[] LIPS;

    public DT_GRP_MM0710_ConBody() {
    }

    public DT_GRP_MM0710_ConBody(
           com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIKP[] LIKP,
           com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIPS[] LIPS) {
           this.LIKP = LIKP;
           this.LIPS = LIPS;
    }


    /**
     * Gets the LIKP value for this DT_GRP_MM0710_ConBody.
     * 
     * @return LIKP
     */
    public com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIKP[] getLIKP() {
        return LIKP;
    }


    /**
     * Sets the LIKP value for this DT_GRP_MM0710_ConBody.
     * 
     * @param LIKP
     */
    public void setLIKP(com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIKP[] LIKP) {
        this.LIKP = LIKP;
    }

    public com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIKP getLIKP(int i) {
        return this.LIKP[i];
    }

    public void setLIKP(int i, com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIKP _value) {
        this.LIKP[i] = _value;
    }


    /**
     * Gets the LIPS value for this DT_GRP_MM0710_ConBody.
     * 
     * @return LIPS
     */
    public com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIPS[] getLIPS() {
        return LIPS;
    }


    /**
     * Sets the LIPS value for this DT_GRP_MM0710_ConBody.
     * 
     * @param LIPS
     */
    public void setLIPS(com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIPS[] LIPS) {
        this.LIPS = LIPS;
    }

    public com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIPS getLIPS(int i) {
        return this.LIPS[i];
    }

    public void setLIPS(int i, com.esp.grpeccmm.fiber.DT_GRP_MM0710_ConBodyLIPS _value) {
        this.LIPS[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_GRP_MM0710_ConBody)) return false;
        DT_GRP_MM0710_ConBody other = (DT_GRP_MM0710_ConBody) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.LIKP==null && other.getLIKP()==null) || 
             (this.LIKP!=null &&
              java.util.Arrays.equals(this.LIKP, other.getLIKP()))) &&
            ((this.LIPS==null && other.getLIPS()==null) || 
             (this.LIPS!=null &&
              java.util.Arrays.equals(this.LIPS, other.getLIPS())));
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
        if (getLIKP() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getLIKP());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getLIKP(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getLIPS() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getLIPS());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getLIPS(), i);
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
        new org.apache.axis.description.TypeDesc(DT_GRP_MM0710_ConBody.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://grpeccmm.esp.com/k2pkbb", ">DT_GRP_MM0710_Con>Body"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LIKP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LIKP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://grpeccmm.esp.com/k2pkbb", ">>DT_GRP_MM0710_Con>Body>LIKP"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LIPS");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LIPS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://grpeccmm.esp.com/k2pkbb", ">>DT_GRP_MM0710_Con>Body>LIPS"));
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
