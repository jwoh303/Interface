/**
 * NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.hanwhaaerospace.KEPEH_SRMDH;

public class NE9090_KEPEH_SRMDH_S_RT_GR_RETURN  implements java.io.Serializable {
    /* 회사코드 */
    private java.lang.String companyCode;

    /* 입고예정번호 */
    private java.lang.String grNo;

    /* 입고예정순번 */
    private java.lang.String grSeq;

    /* 결과코드 */
    private java.lang.String msgTy;

    /* 메시지 */
    private java.lang.String msgText;

    public NE9090_KEPEH_SRMDH_S_RT_GR_RETURN() {
    }

    public NE9090_KEPEH_SRMDH_S_RT_GR_RETURN(
           java.lang.String companyCode,
           java.lang.String grNo,
           java.lang.String grSeq,
           java.lang.String msgTy,
           java.lang.String msgText) {
           this.companyCode = companyCode;
           this.grNo = grNo;
           this.grSeq = grSeq;
           this.msgTy = msgTy;
           this.msgText = msgText;
    }


    /**
     * Gets the companyCode value for this NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.
     * 
     * @return companyCode   * 회사코드
     */
    public java.lang.String getCompanyCode() {
        return companyCode;
    }


    /**
     * Sets the companyCode value for this NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.
     * 
     * @param companyCode   * 회사코드
     */
    public void setCompanyCode(java.lang.String companyCode) {
        this.companyCode = companyCode;
    }


    /**
     * Gets the grNo value for this NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.
     * 
     * @return grNo   * 입고예정번호
     */
    public java.lang.String getGrNo() {
        return grNo;
    }


    /**
     * Sets the grNo value for this NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.
     * 
     * @param grNo   * 입고예정번호
     */
    public void setGrNo(java.lang.String grNo) {
        this.grNo = grNo;
    }


    /**
     * Gets the grSeq value for this NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.
     * 
     * @return grSeq   * 입고예정순번
     */
    public java.lang.String getGrSeq() {
        return grSeq;
    }


    /**
     * Sets the grSeq value for this NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.
     * 
     * @param grSeq   * 입고예정순번
     */
    public void setGrSeq(java.lang.String grSeq) {
        this.grSeq = grSeq;
    }


    /**
     * Gets the msgTy value for this NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.
     * 
     * @return msgTy   * 결과코드
     */
    public java.lang.String getMsgTy() {
        return msgTy;
    }


    /**
     * Sets the msgTy value for this NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.
     * 
     * @param msgTy   * 결과코드
     */
    public void setMsgTy(java.lang.String msgTy) {
        this.msgTy = msgTy;
    }


    /**
     * Gets the msgText value for this NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.
     * 
     * @return msgText   * 메시지
     */
    public java.lang.String getMsgText() {
        return msgText;
    }


    /**
     * Sets the msgText value for this NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.
     * 
     * @param msgText   * 메시지
     */
    public void setMsgText(java.lang.String msgText) {
        this.msgText = msgText;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof NE9090_KEPEH_SRMDH_S_RT_GR_RETURN)) return false;
        NE9090_KEPEH_SRMDH_S_RT_GR_RETURN other = (NE9090_KEPEH_SRMDH_S_RT_GR_RETURN) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.companyCode==null && other.getCompanyCode()==null) || 
             (this.companyCode!=null &&
              this.companyCode.equals(other.getCompanyCode()))) &&
            ((this.grNo==null && other.getGrNo()==null) || 
             (this.grNo!=null &&
              this.grNo.equals(other.getGrNo()))) &&
            ((this.grSeq==null && other.getGrSeq()==null) || 
             (this.grSeq!=null &&
              this.grSeq.equals(other.getGrSeq()))) &&
            ((this.msgTy==null && other.getMsgTy()==null) || 
             (this.msgTy!=null &&
              this.msgTy.equals(other.getMsgTy()))) &&
            ((this.msgText==null && other.getMsgText()==null) || 
             (this.msgText!=null &&
              this.msgText.equals(other.getMsgText())));
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
        if (getCompanyCode() != null) {
            _hashCode += getCompanyCode().hashCode();
        }
        if (getGrNo() != null) {
            _hashCode += getGrNo().hashCode();
        }
        if (getGrSeq() != null) {
            _hashCode += getGrSeq().hashCode();
        }
        if (getMsgTy() != null) {
            _hashCode += getMsgTy().hashCode();
        }
        if (getMsgText() != null) {
            _hashCode += getMsgText().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(NE9090_KEPEH_SRMDH_S_RT_GR_RETURN.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://hanwhaaerospace.com/KEPEH_SRMDH", ">NE9090_KEPEH_SRMDH_S_R>T_GR_RETURN"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("companyCode");
        elemField.setXmlName(new javax.xml.namespace.QName("", "companyCode"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grNo");
        elemField.setXmlName(new javax.xml.namespace.QName("", "grNo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("grSeq");
        elemField.setXmlName(new javax.xml.namespace.QName("", "grSeq"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("msgTy");
        elemField.setXmlName(new javax.xml.namespace.QName("", "msgTy"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("msgText");
        elemField.setXmlName(new javax.xml.namespace.QName("", "msgText"));
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
