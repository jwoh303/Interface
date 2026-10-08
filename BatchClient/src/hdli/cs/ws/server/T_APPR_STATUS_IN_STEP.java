/**
 * T_APPR_STATUS_IN_STEP.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package hdli.cs.ws.server;

@SuppressWarnings("serial")
public class T_APPR_STATUS_IN_STEP  implements java.io.Serializable {
    private java.lang.String APPRID;

    private java.lang.String APPRSTATUSCD;

    private java.lang.String APPRTRANSSTATUSCD;

    private java.lang.String APPRKEY;

    private java.lang.String APPRREVNO;

    private java.lang.String APPRSUBMITDT;

    private java.lang.String APPRCONFIRMDT;

    private java.lang.String INSERTUID;

    private java.lang.String INSERTDT;

    private java.lang.String UPDATEUID;

    private java.lang.String UPDATEDT;

    private java.lang.String ERRORDETAIL;

    private hdli.cs.ws.server.T_APPR_LINE_IN_STEP[] t_APPR_LINE_IN_STEP;

    public T_APPR_STATUS_IN_STEP() {
    }

    public T_APPR_STATUS_IN_STEP(
           java.lang.String APPRID,
           java.lang.String APPRSTATUSCD,
           java.lang.String APPRTRANSSTATUSCD,
           java.lang.String APPRKEY,
           java.lang.String APPRREVNO,
           java.lang.String APPRSUBMITDT,
           java.lang.String APPRCONFIRMDT,
           java.lang.String INSERTUID,
           java.lang.String INSERTDT,
           java.lang.String UPDATEUID,
           java.lang.String UPDATEDT,
           java.lang.String ERRORDETAIL,
           hdli.cs.ws.server.T_APPR_LINE_IN_STEP[] t_APPR_LINE_IN_STEP) {
           this.APPRID = APPRID;
           this.APPRSTATUSCD = APPRSTATUSCD;
           this.APPRTRANSSTATUSCD = APPRTRANSSTATUSCD;
           this.APPRKEY = APPRKEY;
           this.APPRREVNO = APPRREVNO;
           this.APPRSUBMITDT = APPRSUBMITDT;
           this.APPRCONFIRMDT = APPRCONFIRMDT;
           this.INSERTUID = INSERTUID;
           this.INSERTDT = INSERTDT;
           this.UPDATEUID = UPDATEUID;
           this.UPDATEDT = UPDATEDT;
           this.ERRORDETAIL = ERRORDETAIL;
           this.t_APPR_LINE_IN_STEP = t_APPR_LINE_IN_STEP;
    }


    /**
     * Gets the APPRID value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return APPRID
     */
    public java.lang.String getAPPRID() {
        return APPRID;
    }


    /**
     * Sets the APPRID value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param APPRID
     */
    public void setAPPRID(java.lang.String APPRID) {
        this.APPRID = APPRID;
    }


    /**
     * Gets the APPRSTATUSCD value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return APPRSTATUSCD
     */
    public java.lang.String getAPPRSTATUSCD() {
        return APPRSTATUSCD;
    }


    /**
     * Sets the APPRSTATUSCD value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param APPRSTATUSCD
     */
    public void setAPPRSTATUSCD(java.lang.String APPRSTATUSCD) {
        this.APPRSTATUSCD = APPRSTATUSCD;
    }


    /**
     * Gets the APPRTRANSSTATUSCD value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return APPRTRANSSTATUSCD
     */
    public java.lang.String getAPPRTRANSSTATUSCD() {
        return APPRTRANSSTATUSCD;
    }


    /**
     * Sets the APPRTRANSSTATUSCD value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param APPRTRANSSTATUSCD
     */
    public void setAPPRTRANSSTATUSCD(java.lang.String APPRTRANSSTATUSCD) {
        this.APPRTRANSSTATUSCD = APPRTRANSSTATUSCD;
    }


    /**
     * Gets the APPRKEY value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return APPRKEY
     */
    public java.lang.String getAPPRKEY() {
        return APPRKEY;
    }


    /**
     * Sets the APPRKEY value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param APPRKEY
     */
    public void setAPPRKEY(java.lang.String APPRKEY) {
        this.APPRKEY = APPRKEY;
    }


    /**
     * Gets the APPRREVNO value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return APPRREVNO
     */
    public java.lang.String getAPPRREVNO() {
        return APPRREVNO;
    }


    /**
     * Sets the APPRREVNO value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param APPRREVNO
     */
    public void setAPPRREVNO(java.lang.String APPRREVNO) {
        this.APPRREVNO = APPRREVNO;
    }


    /**
     * Gets the APPRSUBMITDT value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return APPRSUBMITDT
     */
    public java.lang.String getAPPRSUBMITDT() {
        return APPRSUBMITDT;
    }


    /**
     * Sets the APPRSUBMITDT value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param APPRSUBMITDT
     */
    public void setAPPRSUBMITDT(java.lang.String APPRSUBMITDT) {
        this.APPRSUBMITDT = APPRSUBMITDT;
    }


    /**
     * Gets the APPRCONFIRMDT value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return APPRCONFIRMDT
     */
    public java.lang.String getAPPRCONFIRMDT() {
        return APPRCONFIRMDT;
    }


    /**
     * Sets the APPRCONFIRMDT value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param APPRCONFIRMDT
     */
    public void setAPPRCONFIRMDT(java.lang.String APPRCONFIRMDT) {
        this.APPRCONFIRMDT = APPRCONFIRMDT;
    }


    /**
     * Gets the INSERTUID value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return INSERTUID
     */
    public java.lang.String getINSERTUID() {
        return INSERTUID;
    }


    /**
     * Sets the INSERTUID value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param INSERTUID
     */
    public void setINSERTUID(java.lang.String INSERTUID) {
        this.INSERTUID = INSERTUID;
    }


    /**
     * Gets the INSERTDT value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return INSERTDT
     */
    public java.lang.String getINSERTDT() {
        return INSERTDT;
    }


    /**
     * Sets the INSERTDT value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param INSERTDT
     */
    public void setINSERTDT(java.lang.String INSERTDT) {
        this.INSERTDT = INSERTDT;
    }


    /**
     * Gets the UPDATEUID value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return UPDATEUID
     */
    public java.lang.String getUPDATEUID() {
        return UPDATEUID;
    }


    /**
     * Sets the UPDATEUID value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param UPDATEUID
     */
    public void setUPDATEUID(java.lang.String UPDATEUID) {
        this.UPDATEUID = UPDATEUID;
    }


    /**
     * Gets the UPDATEDT value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return UPDATEDT
     */
    public java.lang.String getUPDATEDT() {
        return UPDATEDT;
    }


    /**
     * Sets the UPDATEDT value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param UPDATEDT
     */
    public void setUPDATEDT(java.lang.String UPDATEDT) {
        this.UPDATEDT = UPDATEDT;
    }


    /**
     * Gets the ERRORDETAIL value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return ERRORDETAIL
     */
    public java.lang.String getERRORDETAIL() {
        return ERRORDETAIL;
    }


    /**
     * Sets the ERRORDETAIL value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param ERRORDETAIL
     */
    public void setERRORDETAIL(java.lang.String ERRORDETAIL) {
        this.ERRORDETAIL = ERRORDETAIL;
    }


    /**
     * Gets the t_APPR_LINE_IN_STEP value for this T_APPR_STATUS_IN_STEP.
     * 
     * @return t_APPR_LINE_IN_STEP
     */
    public hdli.cs.ws.server.T_APPR_LINE_IN_STEP[] getT_APPR_LINE_IN_STEP() {
        return t_APPR_LINE_IN_STEP;
    }


    /**
     * Sets the t_APPR_LINE_IN_STEP value for this T_APPR_STATUS_IN_STEP.
     * 
     * @param t_APPR_LINE_IN_STEP
     */
    public void setT_APPR_LINE_IN_STEP(hdli.cs.ws.server.T_APPR_LINE_IN_STEP[] t_APPR_LINE_IN_STEP) {
        this.t_APPR_LINE_IN_STEP = t_APPR_LINE_IN_STEP;
    }

    public hdli.cs.ws.server.T_APPR_LINE_IN_STEP getT_APPR_LINE_IN_STEP(int i) {
        return this.t_APPR_LINE_IN_STEP[i];
    }

    public void setT_APPR_LINE_IN_STEP(int i, hdli.cs.ws.server.T_APPR_LINE_IN_STEP _value) {
        this.t_APPR_LINE_IN_STEP[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof T_APPR_STATUS_IN_STEP)) return false;
        T_APPR_STATUS_IN_STEP other = (T_APPR_STATUS_IN_STEP) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.APPRID==null && other.getAPPRID()==null) || 
             (this.APPRID!=null &&
              this.APPRID.equals(other.getAPPRID()))) &&
            ((this.APPRSTATUSCD==null && other.getAPPRSTATUSCD()==null) || 
             (this.APPRSTATUSCD!=null &&
              this.APPRSTATUSCD.equals(other.getAPPRSTATUSCD()))) &&
            ((this.APPRTRANSSTATUSCD==null && other.getAPPRTRANSSTATUSCD()==null) || 
             (this.APPRTRANSSTATUSCD!=null &&
              this.APPRTRANSSTATUSCD.equals(other.getAPPRTRANSSTATUSCD()))) &&
            ((this.APPRKEY==null && other.getAPPRKEY()==null) || 
             (this.APPRKEY!=null &&
              this.APPRKEY.equals(other.getAPPRKEY()))) &&
            ((this.APPRREVNO==null && other.getAPPRREVNO()==null) || 
             (this.APPRREVNO!=null &&
              this.APPRREVNO.equals(other.getAPPRREVNO()))) &&
            ((this.APPRSUBMITDT==null && other.getAPPRSUBMITDT()==null) || 
             (this.APPRSUBMITDT!=null &&
              this.APPRSUBMITDT.equals(other.getAPPRSUBMITDT()))) &&
            ((this.APPRCONFIRMDT==null && other.getAPPRCONFIRMDT()==null) || 
             (this.APPRCONFIRMDT!=null &&
              this.APPRCONFIRMDT.equals(other.getAPPRCONFIRMDT()))) &&
            ((this.INSERTUID==null && other.getINSERTUID()==null) || 
             (this.INSERTUID!=null &&
              this.INSERTUID.equals(other.getINSERTUID()))) &&
            ((this.INSERTDT==null && other.getINSERTDT()==null) || 
             (this.INSERTDT!=null &&
              this.INSERTDT.equals(other.getINSERTDT()))) &&
            ((this.UPDATEUID==null && other.getUPDATEUID()==null) || 
             (this.UPDATEUID!=null &&
              this.UPDATEUID.equals(other.getUPDATEUID()))) &&
            ((this.UPDATEDT==null && other.getUPDATEDT()==null) || 
             (this.UPDATEDT!=null &&
              this.UPDATEDT.equals(other.getUPDATEDT()))) &&
            ((this.ERRORDETAIL==null && other.getERRORDETAIL()==null) || 
             (this.ERRORDETAIL!=null &&
              this.ERRORDETAIL.equals(other.getERRORDETAIL()))) &&
            ((this.t_APPR_LINE_IN_STEP==null && other.getT_APPR_LINE_IN_STEP()==null) || 
             (this.t_APPR_LINE_IN_STEP!=null &&
              java.util.Arrays.equals(this.t_APPR_LINE_IN_STEP, other.getT_APPR_LINE_IN_STEP())));
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
        if (getAPPRID() != null) {
            _hashCode += getAPPRID().hashCode();
        }
        if (getAPPRSTATUSCD() != null) {
            _hashCode += getAPPRSTATUSCD().hashCode();
        }
        if (getAPPRTRANSSTATUSCD() != null) {
            _hashCode += getAPPRTRANSSTATUSCD().hashCode();
        }
        if (getAPPRKEY() != null) {
            _hashCode += getAPPRKEY().hashCode();
        }
        if (getAPPRREVNO() != null) {
            _hashCode += getAPPRREVNO().hashCode();
        }
        if (getAPPRSUBMITDT() != null) {
            _hashCode += getAPPRSUBMITDT().hashCode();
        }
        if (getAPPRCONFIRMDT() != null) {
            _hashCode += getAPPRCONFIRMDT().hashCode();
        }
        if (getINSERTUID() != null) {
            _hashCode += getINSERTUID().hashCode();
        }
        if (getINSERTDT() != null) {
            _hashCode += getINSERTDT().hashCode();
        }
        if (getUPDATEUID() != null) {
            _hashCode += getUPDATEUID().hashCode();
        }
        if (getUPDATEDT() != null) {
            _hashCode += getUPDATEDT().hashCode();
        }
        if (getERRORDETAIL() != null) {
            _hashCode += getERRORDETAIL().hashCode();
        }
        if (getT_APPR_LINE_IN_STEP() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getT_APPR_LINE_IN_STEP());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getT_APPR_LINE_IN_STEP(), i);
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
        new org.apache.axis.description.TypeDesc(T_APPR_STATUS_IN_STEP.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "T_APPR_STATUS_IN_STEP"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRSTATUSCD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRSTATUSCD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRTRANSSTATUSCD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRTRANSSTATUSCD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRKEY");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRKEY"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRREVNO");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRREVNO"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRSUBMITDT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRSUBMITDT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRCONFIRMDT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRCONFIRMDT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("INSERTUID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "INSERTUID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("INSERTDT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "INSERTDT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("UPDATEUID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "UPDATEUID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("UPDATEDT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "UPDATEDT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ERRORDETAIL");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ERRORDETAIL"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("t_APPR_LINE_IN_STEP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "T_APPR_LINE_IN_STEP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "T_APPR_LINE_IN_STEP"));
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
