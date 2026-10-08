/**
 * DT_INFMPO0030_ConBody.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.infmpo.fiber;

public class DT_INFMPO0030_ConBody  implements java.io.Serializable {
    private com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_HEADER[] RFQ_HEADER;

    private com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ITEM[] RFQ_ITEM;

    private com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_VENDOR[] RFQ_VENDOR;

    private com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_HEADER[] QTA_HEADER;

    private com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_ITEM[] QTA_ITEM;

    private com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ATTACH[] RFQ_ATTACH;

    private com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_REF_VENDOR[] QTA_REF_VENDOR;

    public DT_INFMPO0030_ConBody() {
    }

    public DT_INFMPO0030_ConBody(
           com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_HEADER[] RFQ_HEADER,
           com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ITEM[] RFQ_ITEM,
           com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_VENDOR[] RFQ_VENDOR,
           com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_HEADER[] QTA_HEADER,
           com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_ITEM[] QTA_ITEM,
           com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ATTACH[] RFQ_ATTACH,
           com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_REF_VENDOR[] QTA_REF_VENDOR) {
           this.RFQ_HEADER = RFQ_HEADER;
           this.RFQ_ITEM = RFQ_ITEM;
           this.RFQ_VENDOR = RFQ_VENDOR;
           this.QTA_HEADER = QTA_HEADER;
           this.QTA_ITEM = QTA_ITEM;
           this.RFQ_ATTACH = RFQ_ATTACH;
           this.QTA_REF_VENDOR = QTA_REF_VENDOR;
    }


    /**
     * Gets the RFQ_HEADER value for this DT_INFMPO0030_ConBody.
     * 
     * @return RFQ_HEADER
     */
    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_HEADER[] getRFQ_HEADER() {
        return RFQ_HEADER;
    }


    /**
     * Sets the RFQ_HEADER value for this DT_INFMPO0030_ConBody.
     * 
     * @param RFQ_HEADER
     */
    public void setRFQ_HEADER(com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_HEADER[] RFQ_HEADER) {
        this.RFQ_HEADER = RFQ_HEADER;
    }

    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_HEADER getRFQ_HEADER(int i) {
        return this.RFQ_HEADER[i];
    }

    public void setRFQ_HEADER(int i, com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_HEADER _value) {
        this.RFQ_HEADER[i] = _value;
    }


    /**
     * Gets the RFQ_ITEM value for this DT_INFMPO0030_ConBody.
     * 
     * @return RFQ_ITEM
     */
    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ITEM[] getRFQ_ITEM() {
        return RFQ_ITEM;
    }


    /**
     * Sets the RFQ_ITEM value for this DT_INFMPO0030_ConBody.
     * 
     * @param RFQ_ITEM
     */
    public void setRFQ_ITEM(com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ITEM[] RFQ_ITEM) {
        this.RFQ_ITEM = RFQ_ITEM;
    }

    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ITEM getRFQ_ITEM(int i) {
        return this.RFQ_ITEM[i];
    }

    public void setRFQ_ITEM(int i, com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ITEM _value) {
        this.RFQ_ITEM[i] = _value;
    }


    /**
     * Gets the RFQ_VENDOR value for this DT_INFMPO0030_ConBody.
     * 
     * @return RFQ_VENDOR
     */
    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_VENDOR[] getRFQ_VENDOR() {
        return RFQ_VENDOR;
    }


    /**
     * Sets the RFQ_VENDOR value for this DT_INFMPO0030_ConBody.
     * 
     * @param RFQ_VENDOR
     */
    public void setRFQ_VENDOR(com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_VENDOR[] RFQ_VENDOR) {
        this.RFQ_VENDOR = RFQ_VENDOR;
    }

    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_VENDOR getRFQ_VENDOR(int i) {
        return this.RFQ_VENDOR[i];
    }

    public void setRFQ_VENDOR(int i, com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_VENDOR _value) {
        this.RFQ_VENDOR[i] = _value;
    }


    /**
     * Gets the QTA_HEADER value for this DT_INFMPO0030_ConBody.
     * 
     * @return QTA_HEADER
     */
    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_HEADER[] getQTA_HEADER() {
        return QTA_HEADER;
    }


    /**
     * Sets the QTA_HEADER value for this DT_INFMPO0030_ConBody.
     * 
     * @param QTA_HEADER
     */
    public void setQTA_HEADER(com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_HEADER[] QTA_HEADER) {
        this.QTA_HEADER = QTA_HEADER;
    }

    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_HEADER getQTA_HEADER(int i) {
        return this.QTA_HEADER[i];
    }

    public void setQTA_HEADER(int i, com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_HEADER _value) {
        this.QTA_HEADER[i] = _value;
    }


    /**
     * Gets the QTA_ITEM value for this DT_INFMPO0030_ConBody.
     * 
     * @return QTA_ITEM
     */
    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_ITEM[] getQTA_ITEM() {
        return QTA_ITEM;
    }


    /**
     * Sets the QTA_ITEM value for this DT_INFMPO0030_ConBody.
     * 
     * @param QTA_ITEM
     */
    public void setQTA_ITEM(com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_ITEM[] QTA_ITEM) {
        this.QTA_ITEM = QTA_ITEM;
    }

    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_ITEM getQTA_ITEM(int i) {
        return this.QTA_ITEM[i];
    }

    public void setQTA_ITEM(int i, com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_ITEM _value) {
        this.QTA_ITEM[i] = _value;
    }


    /**
     * Gets the RFQ_ATTACH value for this DT_INFMPO0030_ConBody.
     * 
     * @return RFQ_ATTACH
     */
    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ATTACH[] getRFQ_ATTACH() {
        return RFQ_ATTACH;
    }


    /**
     * Sets the RFQ_ATTACH value for this DT_INFMPO0030_ConBody.
     * 
     * @param RFQ_ATTACH
     */
    public void setRFQ_ATTACH(com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ATTACH[] RFQ_ATTACH) {
        this.RFQ_ATTACH = RFQ_ATTACH;
    }

    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ATTACH getRFQ_ATTACH(int i) {
        return this.RFQ_ATTACH[i];
    }

    public void setRFQ_ATTACH(int i, com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyRFQ_ATTACH _value) {
        this.RFQ_ATTACH[i] = _value;
    }


    /**
     * Gets the QTA_REF_VENDOR value for this DT_INFMPO0030_ConBody.
     * 
     * @return QTA_REF_VENDOR
     */
    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_REF_VENDOR[] getQTA_REF_VENDOR() {
        return QTA_REF_VENDOR;
    }


    /**
     * Sets the QTA_REF_VENDOR value for this DT_INFMPO0030_ConBody.
     * 
     * @param QTA_REF_VENDOR
     */
    public void setQTA_REF_VENDOR(com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_REF_VENDOR[] QTA_REF_VENDOR) {
        this.QTA_REF_VENDOR = QTA_REF_VENDOR;
    }

    public com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_REF_VENDOR getQTA_REF_VENDOR(int i) {
        return this.QTA_REF_VENDOR[i];
    }

    public void setQTA_REF_VENDOR(int i, com.esp.infmpo.fiber.DT_INFMPO0030_ConBodyQTA_REF_VENDOR _value) {
        this.QTA_REF_VENDOR[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_INFMPO0030_ConBody)) return false;
        DT_INFMPO0030_ConBody other = (DT_INFMPO0030_ConBody) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.RFQ_HEADER==null && other.getRFQ_HEADER()==null) || 
             (this.RFQ_HEADER!=null &&
              java.util.Arrays.equals(this.RFQ_HEADER, other.getRFQ_HEADER()))) &&
            ((this.RFQ_ITEM==null && other.getRFQ_ITEM()==null) || 
             (this.RFQ_ITEM!=null &&
              java.util.Arrays.equals(this.RFQ_ITEM, other.getRFQ_ITEM()))) &&
            ((this.RFQ_VENDOR==null && other.getRFQ_VENDOR()==null) || 
             (this.RFQ_VENDOR!=null &&
              java.util.Arrays.equals(this.RFQ_VENDOR, other.getRFQ_VENDOR()))) &&
            ((this.QTA_HEADER==null && other.getQTA_HEADER()==null) || 
             (this.QTA_HEADER!=null &&
              java.util.Arrays.equals(this.QTA_HEADER, other.getQTA_HEADER()))) &&
            ((this.QTA_ITEM==null && other.getQTA_ITEM()==null) || 
             (this.QTA_ITEM!=null &&
              java.util.Arrays.equals(this.QTA_ITEM, other.getQTA_ITEM()))) &&
            ((this.RFQ_ATTACH==null && other.getRFQ_ATTACH()==null) || 
             (this.RFQ_ATTACH!=null &&
              java.util.Arrays.equals(this.RFQ_ATTACH, other.getRFQ_ATTACH()))) &&
            ((this.QTA_REF_VENDOR==null && other.getQTA_REF_VENDOR()==null) || 
             (this.QTA_REF_VENDOR!=null &&
              java.util.Arrays.equals(this.QTA_REF_VENDOR, other.getQTA_REF_VENDOR())));
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
        if (getRFQ_HEADER() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getRFQ_HEADER());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getRFQ_HEADER(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getRFQ_ITEM() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getRFQ_ITEM());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getRFQ_ITEM(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getRFQ_VENDOR() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getRFQ_VENDOR());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getRFQ_VENDOR(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getQTA_HEADER() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getQTA_HEADER());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getQTA_HEADER(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getQTA_ITEM() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getQTA_ITEM());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getQTA_ITEM(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getRFQ_ATTACH() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getRFQ_ATTACH());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getRFQ_ATTACH(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getQTA_REF_VENDOR() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getQTA_REF_VENDOR());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getQTA_REF_VENDOR(), i);
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
        new org.apache.axis.description.TypeDesc(DT_INFMPO0030_ConBody.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", ">DT_INFMPO0030_Con>Body"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_HEADER");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_HEADER"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", ">>DT_INFMPO0030_Con>Body>RFQ_HEADER"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_ITEM");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_ITEM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", ">>DT_INFMPO0030_Con>Body>RFQ_ITEM"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_VENDOR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_VENDOR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", ">>DT_INFMPO0030_Con>Body>RFQ_VENDOR"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_HEADER");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_HEADER"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", ">>DT_INFMPO0030_Con>Body>QTA_HEADER"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_ITEM");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_ITEM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", ">>DT_INFMPO0030_Con>Body>QTA_ITEM"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("RFQ_ATTACH");
        elemField.setXmlName(new javax.xml.namespace.QName("", "RFQ_ATTACH"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", ">>DT_INFMPO0030_Con>Body>RFQ_ATTACH"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_REF_VENDOR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_REF_VENDOR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://infmpo.esp.com/k2pkbb", ">>DT_INFMPO0030_Con>Body>QTA_REF_VENDOR"));
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
