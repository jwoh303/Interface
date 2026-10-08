/**
 * DT_INFIPA0110_ConBodyQTA_REF_VENDOR.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.infipa.k2pkbb;

public class DT_INFIPA0110_ConBodyQTA_REF_VENDOR  implements java.io.Serializable {
    /* 회사 코드 */
    private java.lang.String COMP_CD;

    /* 업체 코드 */
    private java.lang.String VD_CD;

    /* KeP 견적번호 */
    private java.lang.String QTA_NO;

    /* 견적 회수 */
    private java.lang.String QTA_CNT;

    /* 견적 항번 */
    private java.lang.String QTA_LNO;

    /* 2차 벤더 사업자 번호 */
    private java.lang.String REF_BIZ_NO;

    /* 2차 벤더 명칭 */
    private java.lang.String REF_VD_NM;

    /* 2차 벤더 견적 수량 */
    private java.lang.String REF_ITEM_QTY;

    /* 2차 벤더 최초 견적 단가 */
    private java.lang.String REF_ITEM_PRICE_F;

    /* 2차 벤더 견적 단가 */
    private java.lang.String REF_ITEM_PRICE;

    /* 비고 */
    private java.lang.String REF_REM;

    public DT_INFIPA0110_ConBodyQTA_REF_VENDOR() {
    }

    public DT_INFIPA0110_ConBodyQTA_REF_VENDOR(
           java.lang.String COMP_CD,
           java.lang.String VD_CD,
           java.lang.String QTA_NO,
           java.lang.String QTA_CNT,
           java.lang.String QTA_LNO,
           java.lang.String REF_BIZ_NO,
           java.lang.String REF_VD_NM,
           java.lang.String REF_ITEM_QTY,
           java.lang.String REF_ITEM_PRICE_F,
           java.lang.String REF_ITEM_PRICE,
           java.lang.String REF_REM) {
           this.COMP_CD = COMP_CD;
           this.VD_CD = VD_CD;
           this.QTA_NO = QTA_NO;
           this.QTA_CNT = QTA_CNT;
           this.QTA_LNO = QTA_LNO;
           this.REF_BIZ_NO = REF_BIZ_NO;
           this.REF_VD_NM = REF_VD_NM;
           this.REF_ITEM_QTY = REF_ITEM_QTY;
           this.REF_ITEM_PRICE_F = REF_ITEM_PRICE_F;
           this.REF_ITEM_PRICE = REF_ITEM_PRICE;
           this.REF_REM = REF_REM;
    }


    /**
     * Gets the COMP_CD value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @return COMP_CD   * 회사 코드
     */
    public java.lang.String getCOMP_CD() {
        return COMP_CD;
    }


    /**
     * Sets the COMP_CD value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @param COMP_CD   * 회사 코드
     */
    public void setCOMP_CD(java.lang.String COMP_CD) {
        this.COMP_CD = COMP_CD;
    }


    /**
     * Gets the VD_CD value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @return VD_CD   * 업체 코드
     */
    public java.lang.String getVD_CD() {
        return VD_CD;
    }


    /**
     * Sets the VD_CD value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @param VD_CD   * 업체 코드
     */
    public void setVD_CD(java.lang.String VD_CD) {
        this.VD_CD = VD_CD;
    }


    /**
     * Gets the QTA_NO value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @return QTA_NO   * KeP 견적번호
     */
    public java.lang.String getQTA_NO() {
        return QTA_NO;
    }


    /**
     * Sets the QTA_NO value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @param QTA_NO   * KeP 견적번호
     */
    public void setQTA_NO(java.lang.String QTA_NO) {
        this.QTA_NO = QTA_NO;
    }


    /**
     * Gets the QTA_CNT value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @return QTA_CNT   * 견적 회수
     */
    public java.lang.String getQTA_CNT() {
        return QTA_CNT;
    }


    /**
     * Sets the QTA_CNT value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @param QTA_CNT   * 견적 회수
     */
    public void setQTA_CNT(java.lang.String QTA_CNT) {
        this.QTA_CNT = QTA_CNT;
    }


    /**
     * Gets the QTA_LNO value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @return QTA_LNO   * 견적 항번
     */
    public java.lang.String getQTA_LNO() {
        return QTA_LNO;
    }


    /**
     * Sets the QTA_LNO value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @param QTA_LNO   * 견적 항번
     */
    public void setQTA_LNO(java.lang.String QTA_LNO) {
        this.QTA_LNO = QTA_LNO;
    }


    /**
     * Gets the REF_BIZ_NO value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @return REF_BIZ_NO   * 2차 벤더 사업자 번호
     */
    public java.lang.String getREF_BIZ_NO() {
        return REF_BIZ_NO;
    }


    /**
     * Sets the REF_BIZ_NO value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @param REF_BIZ_NO   * 2차 벤더 사업자 번호
     */
    public void setREF_BIZ_NO(java.lang.String REF_BIZ_NO) {
        this.REF_BIZ_NO = REF_BIZ_NO;
    }


    /**
     * Gets the REF_VD_NM value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @return REF_VD_NM   * 2차 벤더 명칭
     */
    public java.lang.String getREF_VD_NM() {
        return REF_VD_NM;
    }


    /**
     * Sets the REF_VD_NM value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @param REF_VD_NM   * 2차 벤더 명칭
     */
    public void setREF_VD_NM(java.lang.String REF_VD_NM) {
        this.REF_VD_NM = REF_VD_NM;
    }


    /**
     * Gets the REF_ITEM_QTY value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @return REF_ITEM_QTY   * 2차 벤더 견적 수량
     */
    public java.lang.String getREF_ITEM_QTY() {
        return REF_ITEM_QTY;
    }


    /**
     * Sets the REF_ITEM_QTY value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @param REF_ITEM_QTY   * 2차 벤더 견적 수량
     */
    public void setREF_ITEM_QTY(java.lang.String REF_ITEM_QTY) {
        this.REF_ITEM_QTY = REF_ITEM_QTY;
    }


    /**
     * Gets the REF_ITEM_PRICE_F value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @return REF_ITEM_PRICE_F   * 2차 벤더 최초 견적 단가
     */
    public java.lang.String getREF_ITEM_PRICE_F() {
        return REF_ITEM_PRICE_F;
    }


    /**
     * Sets the REF_ITEM_PRICE_F value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @param REF_ITEM_PRICE_F   * 2차 벤더 최초 견적 단가
     */
    public void setREF_ITEM_PRICE_F(java.lang.String REF_ITEM_PRICE_F) {
        this.REF_ITEM_PRICE_F = REF_ITEM_PRICE_F;
    }


    /**
     * Gets the REF_ITEM_PRICE value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @return REF_ITEM_PRICE   * 2차 벤더 견적 단가
     */
    public java.lang.String getREF_ITEM_PRICE() {
        return REF_ITEM_PRICE;
    }


    /**
     * Sets the REF_ITEM_PRICE value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @param REF_ITEM_PRICE   * 2차 벤더 견적 단가
     */
    public void setREF_ITEM_PRICE(java.lang.String REF_ITEM_PRICE) {
        this.REF_ITEM_PRICE = REF_ITEM_PRICE;
    }


    /**
     * Gets the REF_REM value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @return REF_REM   * 비고
     */
    public java.lang.String getREF_REM() {
        return REF_REM;
    }


    /**
     * Sets the REF_REM value for this DT_INFIPA0110_ConBodyQTA_REF_VENDOR.
     * 
     * @param REF_REM   * 비고
     */
    public void setREF_REM(java.lang.String REF_REM) {
        this.REF_REM = REF_REM;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_INFIPA0110_ConBodyQTA_REF_VENDOR)) return false;
        DT_INFIPA0110_ConBodyQTA_REF_VENDOR other = (DT_INFIPA0110_ConBodyQTA_REF_VENDOR) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.COMP_CD==null && other.getCOMP_CD()==null) || 
             (this.COMP_CD!=null &&
              this.COMP_CD.equals(other.getCOMP_CD()))) &&
            ((this.VD_CD==null && other.getVD_CD()==null) || 
             (this.VD_CD!=null &&
              this.VD_CD.equals(other.getVD_CD()))) &&
            ((this.QTA_NO==null && other.getQTA_NO()==null) || 
             (this.QTA_NO!=null &&
              this.QTA_NO.equals(other.getQTA_NO()))) &&
            ((this.QTA_CNT==null && other.getQTA_CNT()==null) || 
             (this.QTA_CNT!=null &&
              this.QTA_CNT.equals(other.getQTA_CNT()))) &&
            ((this.QTA_LNO==null && other.getQTA_LNO()==null) || 
             (this.QTA_LNO!=null &&
              this.QTA_LNO.equals(other.getQTA_LNO()))) &&
            ((this.REF_BIZ_NO==null && other.getREF_BIZ_NO()==null) || 
             (this.REF_BIZ_NO!=null &&
              this.REF_BIZ_NO.equals(other.getREF_BIZ_NO()))) &&
            ((this.REF_VD_NM==null && other.getREF_VD_NM()==null) || 
             (this.REF_VD_NM!=null &&
              this.REF_VD_NM.equals(other.getREF_VD_NM()))) &&
            ((this.REF_ITEM_QTY==null && other.getREF_ITEM_QTY()==null) || 
             (this.REF_ITEM_QTY!=null &&
              this.REF_ITEM_QTY.equals(other.getREF_ITEM_QTY()))) &&
            ((this.REF_ITEM_PRICE_F==null && other.getREF_ITEM_PRICE_F()==null) || 
             (this.REF_ITEM_PRICE_F!=null &&
              this.REF_ITEM_PRICE_F.equals(other.getREF_ITEM_PRICE_F()))) &&
            ((this.REF_ITEM_PRICE==null && other.getREF_ITEM_PRICE()==null) || 
             (this.REF_ITEM_PRICE!=null &&
              this.REF_ITEM_PRICE.equals(other.getREF_ITEM_PRICE()))) &&
            ((this.REF_REM==null && other.getREF_REM()==null) || 
             (this.REF_REM!=null &&
              this.REF_REM.equals(other.getREF_REM())));
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
        if (getCOMP_CD() != null) {
            _hashCode += getCOMP_CD().hashCode();
        }
        if (getVD_CD() != null) {
            _hashCode += getVD_CD().hashCode();
        }
        if (getQTA_NO() != null) {
            _hashCode += getQTA_NO().hashCode();
        }
        if (getQTA_CNT() != null) {
            _hashCode += getQTA_CNT().hashCode();
        }
        if (getQTA_LNO() != null) {
            _hashCode += getQTA_LNO().hashCode();
        }
        if (getREF_BIZ_NO() != null) {
            _hashCode += getREF_BIZ_NO().hashCode();
        }
        if (getREF_VD_NM() != null) {
            _hashCode += getREF_VD_NM().hashCode();
        }
        if (getREF_ITEM_QTY() != null) {
            _hashCode += getREF_ITEM_QTY().hashCode();
        }
        if (getREF_ITEM_PRICE_F() != null) {
            _hashCode += getREF_ITEM_PRICE_F().hashCode();
        }
        if (getREF_ITEM_PRICE() != null) {
            _hashCode += getREF_ITEM_PRICE().hashCode();
        }
        if (getREF_REM() != null) {
            _hashCode += getREF_REM().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_INFIPA0110_ConBodyQTA_REF_VENDOR.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://infipa.esp.com/k2pkbb", ">>DT_INFIPA0110_Con>Body>QTA_REF_VENDOR"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("COMP_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "COMP_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("VD_CD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "VD_CD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_CNT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_CNT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("QTA_LNO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "QTA_LNO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("REF_BIZ_NO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "REF_BIZ_NO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("REF_VD_NM");
        elemField.setXmlName(new javax.xml.namespace.QName("", "REF_VD_NM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("REF_ITEM_QTY");
        elemField.setXmlName(new javax.xml.namespace.QName("", "REF_ITEM_QTY"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("REF_ITEM_PRICE_F");
        elemField.setXmlName(new javax.xml.namespace.QName("", "REF_ITEM_PRICE_F"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("REF_ITEM_PRICE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "REF_ITEM_PRICE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("REF_REM");
        elemField.setXmlName(new javax.xml.namespace.QName("", "REF_REM"));
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
