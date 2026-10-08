/**
 * DT_GRP_MM0710_ConBodyLIPS.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.grpeccmm.fiber;

public class DT_GRP_MM0710_ConBodyLIPS  implements java.io.Serializable {
    /* 납품문서번호 (SAP) */
    private java.lang.String VBELN;

    /* 입고예약번호 (KEP) */
    private java.lang.String LIFEX;

    /* 납품 일련번호 */
    private java.lang.String POSNR;

    /* 구매오더 번호 */
    private java.lang.String EBELN;

    /* 구매오더 항번 */
    private java.lang.String EBELP;

    /* 품목 코드 */
    private java.lang.String MATNR;

    /* 납품수량 */
    private java.lang.String MENGE;

    /* 단위 코드 */
    private java.lang.String MEINS;

    /* 업체 LOT 번호 */
    private java.lang.String LICHN;

    /* 원산국 국가코드 */
    private java.lang.String SPE_HERKL;

    /* 제조일자 */
    private java.lang.String HSDAT;

    /* 사업자 번호 */
    private java.lang.String STCD2;

    /* 업체명 */
    private java.lang.String NAME1;

    /* 비고1 */
    private java.lang.String TEXT1;

    /* 비고2 */
    private java.lang.String TEXT2;

    public DT_GRP_MM0710_ConBodyLIPS() {
    }

    public DT_GRP_MM0710_ConBodyLIPS(
           java.lang.String VBELN,
           java.lang.String LIFEX,
           java.lang.String POSNR,
           java.lang.String EBELN,
           java.lang.String EBELP,
           java.lang.String MATNR,
           java.lang.String MENGE,
           java.lang.String MEINS,
           java.lang.String LICHN,
           java.lang.String SPE_HERKL,
           java.lang.String HSDAT,
           java.lang.String STCD2,
           java.lang.String NAME1,
           java.lang.String TEXT1,
           java.lang.String TEXT2) {
           this.VBELN = VBELN;
           this.LIFEX = LIFEX;
           this.POSNR = POSNR;
           this.EBELN = EBELN;
           this.EBELP = EBELP;
           this.MATNR = MATNR;
           this.MENGE = MENGE;
           this.MEINS = MEINS;
           this.LICHN = LICHN;
           this.SPE_HERKL = SPE_HERKL;
           this.HSDAT = HSDAT;
           this.STCD2 = STCD2;
           this.NAME1 = NAME1;
           this.TEXT1 = TEXT1;
           this.TEXT2 = TEXT2;
    }


    /**
     * Gets the VBELN value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return VBELN   * 납품문서번호 (SAP)
     */
    public java.lang.String getVBELN() {
        return VBELN;
    }


    /**
     * Sets the VBELN value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param VBELN   * 납품문서번호 (SAP)
     */
    public void setVBELN(java.lang.String VBELN) {
        this.VBELN = VBELN;
    }


    /**
     * Gets the LIFEX value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return LIFEX   * 입고예약번호 (KEP)
     */
    public java.lang.String getLIFEX() {
        return LIFEX;
    }


    /**
     * Sets the LIFEX value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param LIFEX   * 입고예약번호 (KEP)
     */
    public void setLIFEX(java.lang.String LIFEX) {
        this.LIFEX = LIFEX;
    }


    /**
     * Gets the POSNR value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return POSNR   * 납품 일련번호
     */
    public java.lang.String getPOSNR() {
        return POSNR;
    }


    /**
     * Sets the POSNR value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param POSNR   * 납품 일련번호
     */
    public void setPOSNR(java.lang.String POSNR) {
        this.POSNR = POSNR;
    }


    /**
     * Gets the EBELN value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return EBELN   * 구매오더 번호
     */
    public java.lang.String getEBELN() {
        return EBELN;
    }


    /**
     * Sets the EBELN value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param EBELN   * 구매오더 번호
     */
    public void setEBELN(java.lang.String EBELN) {
        this.EBELN = EBELN;
    }


    /**
     * Gets the EBELP value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return EBELP   * 구매오더 항번
     */
    public java.lang.String getEBELP() {
        return EBELP;
    }


    /**
     * Sets the EBELP value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param EBELP   * 구매오더 항번
     */
    public void setEBELP(java.lang.String EBELP) {
        this.EBELP = EBELP;
    }


    /**
     * Gets the MATNR value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return MATNR   * 품목 코드
     */
    public java.lang.String getMATNR() {
        return MATNR;
    }


    /**
     * Sets the MATNR value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param MATNR   * 품목 코드
     */
    public void setMATNR(java.lang.String MATNR) {
        this.MATNR = MATNR;
    }


    /**
     * Gets the MENGE value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return MENGE   * 납품수량
     */
    public java.lang.String getMENGE() {
        return MENGE;
    }


    /**
     * Sets the MENGE value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param MENGE   * 납품수량
     */
    public void setMENGE(java.lang.String MENGE) {
        this.MENGE = MENGE;
    }


    /**
     * Gets the MEINS value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return MEINS   * 단위 코드
     */
    public java.lang.String getMEINS() {
        return MEINS;
    }


    /**
     * Sets the MEINS value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param MEINS   * 단위 코드
     */
    public void setMEINS(java.lang.String MEINS) {
        this.MEINS = MEINS;
    }


    /**
     * Gets the LICHN value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return LICHN   * 업체 LOT 번호
     */
    public java.lang.String getLICHN() {
        return LICHN;
    }


    /**
     * Sets the LICHN value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param LICHN   * 업체 LOT 번호
     */
    public void setLICHN(java.lang.String LICHN) {
        this.LICHN = LICHN;
    }


    /**
     * Gets the SPE_HERKL value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return SPE_HERKL   * 원산국 국가코드
     */
    public java.lang.String getSPE_HERKL() {
        return SPE_HERKL;
    }


    /**
     * Sets the SPE_HERKL value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param SPE_HERKL   * 원산국 국가코드
     */
    public void setSPE_HERKL(java.lang.String SPE_HERKL) {
        this.SPE_HERKL = SPE_HERKL;
    }


    /**
     * Gets the HSDAT value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return HSDAT   * 제조일자
     */
    public java.lang.String getHSDAT() {
        return HSDAT;
    }


    /**
     * Sets the HSDAT value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param HSDAT   * 제조일자
     */
    public void setHSDAT(java.lang.String HSDAT) {
        this.HSDAT = HSDAT;
    }


    /**
     * Gets the STCD2 value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return STCD2   * 사업자 번호
     */
    public java.lang.String getSTCD2() {
        return STCD2;
    }


    /**
     * Sets the STCD2 value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param STCD2   * 사업자 번호
     */
    public void setSTCD2(java.lang.String STCD2) {
        this.STCD2 = STCD2;
    }


    /**
     * Gets the NAME1 value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return NAME1   * 업체명
     */
    public java.lang.String getNAME1() {
        return NAME1;
    }


    /**
     * Sets the NAME1 value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param NAME1   * 업체명
     */
    public void setNAME1(java.lang.String NAME1) {
        this.NAME1 = NAME1;
    }


    /**
     * Gets the TEXT1 value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return TEXT1   * 비고1
     */
    public java.lang.String getTEXT1() {
        return TEXT1;
    }


    /**
     * Sets the TEXT1 value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param TEXT1   * 비고1
     */
    public void setTEXT1(java.lang.String TEXT1) {
        this.TEXT1 = TEXT1;
    }


    /**
     * Gets the TEXT2 value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @return TEXT2   * 비고2
     */
    public java.lang.String getTEXT2() {
        return TEXT2;
    }


    /**
     * Sets the TEXT2 value for this DT_GRP_MM0710_ConBodyLIPS.
     * 
     * @param TEXT2   * 비고2
     */
    public void setTEXT2(java.lang.String TEXT2) {
        this.TEXT2 = TEXT2;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DT_GRP_MM0710_ConBodyLIPS)) return false;
        DT_GRP_MM0710_ConBodyLIPS other = (DT_GRP_MM0710_ConBodyLIPS) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.VBELN==null && other.getVBELN()==null) || 
             (this.VBELN!=null &&
              this.VBELN.equals(other.getVBELN()))) &&
            ((this.LIFEX==null && other.getLIFEX()==null) || 
             (this.LIFEX!=null &&
              this.LIFEX.equals(other.getLIFEX()))) &&
            ((this.POSNR==null && other.getPOSNR()==null) || 
             (this.POSNR!=null &&
              this.POSNR.equals(other.getPOSNR()))) &&
            ((this.EBELN==null && other.getEBELN()==null) || 
             (this.EBELN!=null &&
              this.EBELN.equals(other.getEBELN()))) &&
            ((this.EBELP==null && other.getEBELP()==null) || 
             (this.EBELP!=null &&
              this.EBELP.equals(other.getEBELP()))) &&
            ((this.MATNR==null && other.getMATNR()==null) || 
             (this.MATNR!=null &&
              this.MATNR.equals(other.getMATNR()))) &&
            ((this.MENGE==null && other.getMENGE()==null) || 
             (this.MENGE!=null &&
              this.MENGE.equals(other.getMENGE()))) &&
            ((this.MEINS==null && other.getMEINS()==null) || 
             (this.MEINS!=null &&
              this.MEINS.equals(other.getMEINS()))) &&
            ((this.LICHN==null && other.getLICHN()==null) || 
             (this.LICHN!=null &&
              this.LICHN.equals(other.getLICHN()))) &&
            ((this.SPE_HERKL==null && other.getSPE_HERKL()==null) || 
             (this.SPE_HERKL!=null &&
              this.SPE_HERKL.equals(other.getSPE_HERKL()))) &&
            ((this.HSDAT==null && other.getHSDAT()==null) || 
             (this.HSDAT!=null &&
              this.HSDAT.equals(other.getHSDAT()))) &&
            ((this.STCD2==null && other.getSTCD2()==null) || 
             (this.STCD2!=null &&
              this.STCD2.equals(other.getSTCD2()))) &&
            ((this.NAME1==null && other.getNAME1()==null) || 
             (this.NAME1!=null &&
              this.NAME1.equals(other.getNAME1()))) &&
            ((this.TEXT1==null && other.getTEXT1()==null) || 
             (this.TEXT1!=null &&
              this.TEXT1.equals(other.getTEXT1()))) &&
            ((this.TEXT2==null && other.getTEXT2()==null) || 
             (this.TEXT2!=null &&
              this.TEXT2.equals(other.getTEXT2())));
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
        if (getVBELN() != null) {
            _hashCode += getVBELN().hashCode();
        }
        if (getLIFEX() != null) {
            _hashCode += getLIFEX().hashCode();
        }
        if (getPOSNR() != null) {
            _hashCode += getPOSNR().hashCode();
        }
        if (getEBELN() != null) {
            _hashCode += getEBELN().hashCode();
        }
        if (getEBELP() != null) {
            _hashCode += getEBELP().hashCode();
        }
        if (getMATNR() != null) {
            _hashCode += getMATNR().hashCode();
        }
        if (getMENGE() != null) {
            _hashCode += getMENGE().hashCode();
        }
        if (getMEINS() != null) {
            _hashCode += getMEINS().hashCode();
        }
        if (getLICHN() != null) {
            _hashCode += getLICHN().hashCode();
        }
        if (getSPE_HERKL() != null) {
            _hashCode += getSPE_HERKL().hashCode();
        }
        if (getHSDAT() != null) {
            _hashCode += getHSDAT().hashCode();
        }
        if (getSTCD2() != null) {
            _hashCode += getSTCD2().hashCode();
        }
        if (getNAME1() != null) {
            _hashCode += getNAME1().hashCode();
        }
        if (getTEXT1() != null) {
            _hashCode += getTEXT1().hashCode();
        }
        if (getTEXT2() != null) {
            _hashCode += getTEXT2().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DT_GRP_MM0710_ConBodyLIPS.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://grpeccmm.esp.com/k2pkbb", ">>DT_GRP_MM0710_Con>Body>LIPS"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("VBELN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "VBELN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LIFEX");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LIFEX"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("POSNR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "POSNR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("EBELN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "EBELN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("EBELP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "EBELP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MATNR");
        elemField.setXmlName(new javax.xml.namespace.QName("", "MATNR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MENGE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "MENGE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MEINS");
        elemField.setXmlName(new javax.xml.namespace.QName("", "MEINS"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("LICHN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "LICHN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SPE_HERKL");
        elemField.setXmlName(new javax.xml.namespace.QName("", "SPE_HERKL"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("HSDAT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "HSDAT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("STCD2");
        elemField.setXmlName(new javax.xml.namespace.QName("", "STCD2"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("NAME1");
        elemField.setXmlName(new javax.xml.namespace.QName("", "NAME1"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("TEXT1");
        elemField.setXmlName(new javax.xml.namespace.QName("", "TEXT1"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("TEXT2");
        elemField.setXmlName(new javax.xml.namespace.QName("", "TEXT2"));
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
