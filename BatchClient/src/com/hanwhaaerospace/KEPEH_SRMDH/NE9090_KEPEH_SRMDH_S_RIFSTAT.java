/**
 * NE9090_KEPEH_SRMDH_S_RIFSTAT.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.hanwhaaerospace.KEPEH_SRMDH;

public class NE9090_KEPEH_SRMDH_S_RIFSTAT  implements java.io.Serializable {
    /* I/F ID */
    private java.lang.String PICODE;

    /* I/F 호출날짜(YYYYMMDD) */
    private java.lang.String PIDATE;

    /* I/F 호출시간(HHMMSS, 24H) */
    private java.lang.String PITIME;

    /* I/F 상태(S) */
    private java.lang.String PISTAT;

    /* I/F 상태 메시지(Success) */
    private java.lang.String PIMSG;

    /* GUID */
    private java.lang.String PIMSGID;

    /* 전송 유저 */
    private java.lang.String PIUSER;

    public NE9090_KEPEH_SRMDH_S_RIFSTAT() {
    }

    public NE9090_KEPEH_SRMDH_S_RIFSTAT(
           java.lang.String PICODE,
           java.lang.String PIDATE,
           java.lang.String PITIME,
           java.lang.String PISTAT,
           java.lang.String PIMSG,
           java.lang.String PIMSGID,
           java.lang.String PIUSER) {
           this.PICODE = PICODE;
           this.PIDATE = PIDATE;
           this.PITIME = PITIME;
           this.PISTAT = PISTAT;
           this.PIMSG = PIMSG;
           this.PIMSGID = PIMSGID;
           this.PIUSER = PIUSER;
    }


    /**
     * Gets the PICODE value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @return PICODE   * I/F ID
     */
    public java.lang.String getPICODE() {
        return PICODE;
    }


    /**
     * Sets the PICODE value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @param PICODE   * I/F ID
     */
    public void setPICODE(java.lang.String PICODE) {
        this.PICODE = PICODE;
    }


    /**
     * Gets the PIDATE value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @return PIDATE   * I/F 호출날짜(YYYYMMDD)
     */
    public java.lang.String getPIDATE() {
        return PIDATE;
    }


    /**
     * Sets the PIDATE value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @param PIDATE   * I/F 호출날짜(YYYYMMDD)
     */
    public void setPIDATE(java.lang.String PIDATE) {
        this.PIDATE = PIDATE;
    }


    /**
     * Gets the PITIME value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @return PITIME   * I/F 호출시간(HHMMSS, 24H)
     */
    public java.lang.String getPITIME() {
        return PITIME;
    }


    /**
     * Sets the PITIME value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @param PITIME   * I/F 호출시간(HHMMSS, 24H)
     */
    public void setPITIME(java.lang.String PITIME) {
        this.PITIME = PITIME;
    }


    /**
     * Gets the PISTAT value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @return PISTAT   * I/F 상태(S)
     */
    public java.lang.String getPISTAT() {
        return PISTAT;
    }


    /**
     * Sets the PISTAT value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @param PISTAT   * I/F 상태(S)
     */
    public void setPISTAT(java.lang.String PISTAT) {
        this.PISTAT = PISTAT;
    }


    /**
     * Gets the PIMSG value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @return PIMSG   * I/F 상태 메시지(Success)
     */
    public java.lang.String getPIMSG() {
        return PIMSG;
    }


    /**
     * Sets the PIMSG value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @param PIMSG   * I/F 상태 메시지(Success)
     */
    public void setPIMSG(java.lang.String PIMSG) {
        this.PIMSG = PIMSG;
    }


    /**
     * Gets the PIMSGID value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @return PIMSGID   * GUID
     */
    public java.lang.String getPIMSGID() {
        return PIMSGID;
    }


    /**
     * Sets the PIMSGID value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @param PIMSGID   * GUID
     */
    public void setPIMSGID(java.lang.String PIMSGID) {
        this.PIMSGID = PIMSGID;
    }


    /**
     * Gets the PIUSER value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @return PIUSER   * 전송 유저
     */
    public java.lang.String getPIUSER() {
        return PIUSER;
    }


    /**
     * Sets the PIUSER value for this NE9090_KEPEH_SRMDH_S_RIFSTAT.
     * 
     * @param PIUSER   * 전송 유저
     */
    public void setPIUSER(java.lang.String PIUSER) {
        this.PIUSER = PIUSER;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof NE9090_KEPEH_SRMDH_S_RIFSTAT)) return false;
        NE9090_KEPEH_SRMDH_S_RIFSTAT other = (NE9090_KEPEH_SRMDH_S_RIFSTAT) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.PICODE==null && other.getPICODE()==null) || 
             (this.PICODE!=null &&
              this.PICODE.equals(other.getPICODE()))) &&
            ((this.PIDATE==null && other.getPIDATE()==null) || 
             (this.PIDATE!=null &&
              this.PIDATE.equals(other.getPIDATE()))) &&
            ((this.PITIME==null && other.getPITIME()==null) || 
             (this.PITIME!=null &&
              this.PITIME.equals(other.getPITIME()))) &&
            ((this.PISTAT==null && other.getPISTAT()==null) || 
             (this.PISTAT!=null &&
              this.PISTAT.equals(other.getPISTAT()))) &&
            ((this.PIMSG==null && other.getPIMSG()==null) || 
             (this.PIMSG!=null &&
              this.PIMSG.equals(other.getPIMSG()))) &&
            ((this.PIMSGID==null && other.getPIMSGID()==null) || 
             (this.PIMSGID!=null &&
              this.PIMSGID.equals(other.getPIMSGID()))) &&
            ((this.PIUSER==null && other.getPIUSER()==null) || 
             (this.PIUSER!=null &&
              this.PIUSER.equals(other.getPIUSER())));
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
        if (getPICODE() != null) {
            _hashCode += getPICODE().hashCode();
        }
        if (getPIDATE() != null) {
            _hashCode += getPIDATE().hashCode();
        }
        if (getPITIME() != null) {
            _hashCode += getPITIME().hashCode();
        }
        if (getPISTAT() != null) {
            _hashCode += getPISTAT().hashCode();
        }
        if (getPIMSG() != null) {
            _hashCode += getPIMSG().hashCode();
        }
        if (getPIMSGID() != null) {
            _hashCode += getPIMSGID().hashCode();
        }
        if (getPIUSER() != null) {
            _hashCode += getPIUSER().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(NE9090_KEPEH_SRMDH_S_RIFSTAT.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://hanwhaaerospace.com/KEPEH_SRMDH", ">NE9090_KEPEH_SRMDH_S_R>IFSTAT"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PICODE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PICODE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PIDATE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PIDATE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PITIME");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PITIME"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PISTAT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PISTAT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PIMSG");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PIMSG"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PIMSGID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PIMSGID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PIUSER");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PIUSER"));
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
