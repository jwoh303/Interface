/**
 * MM51_MRO_REQROW.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dongwha.ECC_MM.MM51;

public class MM51_MRO_REQROW  implements java.io.Serializable {
    private java.lang.String IF_NO;

    private java.lang.String CATEGORY_NO;

    private java.lang.String DESCRIPTION_ENG;

    private java.lang.String DESCRIPTION_LOC;

    private java.lang.String SPECIFICATION_ENG;

    private java.lang.String MAKER_NAME;

    private java.lang.String DATA01;

    private java.lang.String ADD_USER_ID;

    private java.lang.String UNIT_MEASURE;

    public MM51_MRO_REQROW() {
    }

    public MM51_MRO_REQROW(
           java.lang.String IF_NO,
           java.lang.String CATEGORY_NO,
           java.lang.String DESCRIPTION_ENG,
           java.lang.String DESCRIPTION_LOC,
           java.lang.String SPECIFICATION_ENG,
           java.lang.String MAKER_NAME,
           java.lang.String DATA01,
           java.lang.String ADD_USER_ID,
           java.lang.String UNIT_MEASURE) {
           this.IF_NO = IF_NO;
           this.CATEGORY_NO = CATEGORY_NO;
           this.DESCRIPTION_ENG = DESCRIPTION_ENG;
           this.DESCRIPTION_LOC = DESCRIPTION_LOC;
           this.SPECIFICATION_ENG = SPECIFICATION_ENG;
           this.MAKER_NAME = MAKER_NAME;
           this.DATA01 = DATA01;
           this.ADD_USER_ID = ADD_USER_ID;
           this.UNIT_MEASURE = UNIT_MEASURE;
    }


    /**
     * Gets the IF_NO value for this MM51_MRO_REQROW.
     * 
     * @return IF_NO
     */
    public java.lang.String getIF_NO() {
        return IF_NO;
    }


    /**
     * Sets the IF_NO value for this MM51_MRO_REQROW.
     * 
     * @param IF_NO
     */
    public void setIF_NO(java.lang.String IF_NO) {
        this.IF_NO = IF_NO;
    }


    /**
     * Gets the CATEGORY_NO value for this MM51_MRO_REQROW.
     * 
     * @return CATEGORY_NO
     */
    public java.lang.String getCATEGORY_NO() {
        return CATEGORY_NO;
    }


    /**
     * Sets the CATEGORY_NO value for this MM51_MRO_REQROW.
     * 
     * @param CATEGORY_NO
     */
    public void setCATEGORY_NO(java.lang.String CATEGORY_NO) {
        this.CATEGORY_NO = CATEGORY_NO;
    }


    /**
     * Gets the DESCRIPTION_ENG value for this MM51_MRO_REQROW.
     * 
     * @return DESCRIPTION_ENG
     */
    public java.lang.String getDESCRIPTION_ENG() {
        return DESCRIPTION_ENG;
    }


    /**
     * Sets the DESCRIPTION_ENG value for this MM51_MRO_REQROW.
     * 
     * @param DESCRIPTION_ENG
     */
    public void setDESCRIPTION_ENG(java.lang.String DESCRIPTION_ENG) {
        this.DESCRIPTION_ENG = DESCRIPTION_ENG;
    }


    /**
     * Gets the DESCRIPTION_LOC value for this MM51_MRO_REQROW.
     * 
     * @return DESCRIPTION_LOC
     */
    public java.lang.String getDESCRIPTION_LOC() {
        return DESCRIPTION_LOC;
    }


    /**
     * Sets the DESCRIPTION_LOC value for this MM51_MRO_REQROW.
     * 
     * @param DESCRIPTION_LOC
     */
    public void setDESCRIPTION_LOC(java.lang.String DESCRIPTION_LOC) {
        this.DESCRIPTION_LOC = DESCRIPTION_LOC;
    }


    /**
     * Gets the SPECIFICATION_ENG value for this MM51_MRO_REQROW.
     * 
     * @return SPECIFICATION_ENG
     */
    public java.lang.String getSPECIFICATION_ENG() {
        return SPECIFICATION_ENG;
    }


    /**
     * Sets the SPECIFICATION_ENG value for this MM51_MRO_REQROW.
     * 
     * @param SPECIFICATION_ENG
     */
    public void setSPECIFICATION_ENG(java.lang.String SPECIFICATION_ENG) {
        this.SPECIFICATION_ENG = SPECIFICATION_ENG;
    }


    /**
     * Gets the MAKER_NAME value for this MM51_MRO_REQROW.
     * 
     * @return MAKER_NAME
     */
    public java.lang.String getMAKER_NAME() {
        return MAKER_NAME;
    }


    /**
     * Sets the MAKER_NAME value for this MM51_MRO_REQROW.
     * 
     * @param MAKER_NAME
     */
    public void setMAKER_NAME(java.lang.String MAKER_NAME) {
        this.MAKER_NAME = MAKER_NAME;
    }


    /**
     * Gets the DATA01 value for this MM51_MRO_REQROW.
     * 
     * @return DATA01
     */
    public java.lang.String getDATA01() {
        return DATA01;
    }


    /**
     * Sets the DATA01 value for this MM51_MRO_REQROW.
     * 
     * @param DATA01
     */
    public void setDATA01(java.lang.String DATA01) {
        this.DATA01 = DATA01;
    }


    /**
     * Gets the ADD_USER_ID value for this MM51_MRO_REQROW.
     * 
     * @return ADD_USER_ID
     */
    public java.lang.String getADD_USER_ID() {
        return ADD_USER_ID;
    }


    /**
     * Sets the ADD_USER_ID value for this MM51_MRO_REQROW.
     * 
     * @param ADD_USER_ID
     */
    public void setADD_USER_ID(java.lang.String ADD_USER_ID) {
        this.ADD_USER_ID = ADD_USER_ID;
    }


    /**
     * Gets the UNIT_MEASURE value for this MM51_MRO_REQROW.
     * 
     * @return UNIT_MEASURE
     */
    public java.lang.String getUNIT_MEASURE() {
        return UNIT_MEASURE;
    }


    /**
     * Sets the UNIT_MEASURE value for this MM51_MRO_REQROW.
     * 
     * @param UNIT_MEASURE
     */
    public void setUNIT_MEASURE(java.lang.String UNIT_MEASURE) {
        this.UNIT_MEASURE = UNIT_MEASURE;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof MM51_MRO_REQROW)) return false;
        MM51_MRO_REQROW other = (MM51_MRO_REQROW) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.IF_NO==null && other.getIF_NO()==null) || 
             (this.IF_NO!=null &&
              this.IF_NO.equals(other.getIF_NO()))) &&
            ((this.CATEGORY_NO==null && other.getCATEGORY_NO()==null) || 
             (this.CATEGORY_NO!=null &&
              this.CATEGORY_NO.equals(other.getCATEGORY_NO()))) &&
            ((this.DESCRIPTION_ENG==null && other.getDESCRIPTION_ENG()==null) || 
             (this.DESCRIPTION_ENG!=null &&
              this.DESCRIPTION_ENG.equals(other.getDESCRIPTION_ENG()))) &&
            ((this.DESCRIPTION_LOC==null && other.getDESCRIPTION_LOC()==null) || 
             (this.DESCRIPTION_LOC!=null &&
              this.DESCRIPTION_LOC.equals(other.getDESCRIPTION_LOC()))) &&
            ((this.SPECIFICATION_ENG==null && other.getSPECIFICATION_ENG()==null) || 
             (this.SPECIFICATION_ENG!=null &&
              this.SPECIFICATION_ENG.equals(other.getSPECIFICATION_ENG()))) &&
            ((this.MAKER_NAME==null && other.getMAKER_NAME()==null) || 
             (this.MAKER_NAME!=null &&
              this.MAKER_NAME.equals(other.getMAKER_NAME()))) &&
            ((this.DATA01==null && other.getDATA01()==null) || 
             (this.DATA01!=null &&
              this.DATA01.equals(other.getDATA01()))) &&
            ((this.ADD_USER_ID==null && other.getADD_USER_ID()==null) || 
             (this.ADD_USER_ID!=null &&
              this.ADD_USER_ID.equals(other.getADD_USER_ID()))) &&
            ((this.UNIT_MEASURE==null && other.getUNIT_MEASURE()==null) || 
             (this.UNIT_MEASURE!=null &&
              this.UNIT_MEASURE.equals(other.getUNIT_MEASURE())));
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
        if (getIF_NO() != null) {
            _hashCode += getIF_NO().hashCode();
        }
        if (getCATEGORY_NO() != null) {
            _hashCode += getCATEGORY_NO().hashCode();
        }
        if (getDESCRIPTION_ENG() != null) {
            _hashCode += getDESCRIPTION_ENG().hashCode();
        }
        if (getDESCRIPTION_LOC() != null) {
            _hashCode += getDESCRIPTION_LOC().hashCode();
        }
        if (getSPECIFICATION_ENG() != null) {
            _hashCode += getSPECIFICATION_ENG().hashCode();
        }
        if (getMAKER_NAME() != null) {
            _hashCode += getMAKER_NAME().hashCode();
        }
        if (getDATA01() != null) {
            _hashCode += getDATA01().hashCode();
        }
        if (getADD_USER_ID() != null) {
            _hashCode += getADD_USER_ID().hashCode();
        }
        if (getUNIT_MEASURE() != null) {
            _hashCode += getUNIT_MEASURE().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(MM51_MRO_REQROW.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://dongwha.co.kr/ECC_MM/MM51", ">MM51_MRO_REQ>ROW"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("IF_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "IF_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CATEGORY_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CATEGORY_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DESCRIPTION_ENG");
        elemField.setXmlName(new javax.xml.namespace.QName("", "DESCRIPTION_ENG"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DESCRIPTION_LOC");
        elemField.setXmlName(new javax.xml.namespace.QName("", "DESCRIPTION_LOC"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SPECIFICATION_ENG");
        elemField.setXmlName(new javax.xml.namespace.QName("", "SPECIFICATION_ENG"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MAKER_NAME");
        elemField.setXmlName(new javax.xml.namespace.QName("", "MAKER_NAME"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DATA01");
        elemField.setXmlName(new javax.xml.namespace.QName("", "DATA01"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ADD_USER_ID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ADD_USER_ID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("UNIT_MEASURE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "UNIT_MEASURE"));
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
