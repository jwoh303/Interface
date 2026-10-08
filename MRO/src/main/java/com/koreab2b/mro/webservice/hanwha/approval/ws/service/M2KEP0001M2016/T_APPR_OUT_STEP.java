/**
 * T_APPR_OUT_STEP.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016;

@SuppressWarnings("serial")
public class T_APPR_OUT_STEP  implements java.io.Serializable {
    private java.lang.String SYSID;

    private java.lang.String APPRID;

    private java.lang.String APPRTYPEID;

    private java.lang.String APPRTITLE;

    private java.lang.String APPRSTATUSCD;

    private java.lang.String APPRTRANSSTATUSCD;

    private java.lang.String APPRCONTENTSCLOB;

    private java.lang.String APPRCONTENTSCD;

    private java.lang.String APPRKEY;

    private java.lang.String APPRREVNO;

    private java.lang.String APPRSUBMITDT;

    private java.lang.String APPRCONFIRMDT;

    private java.lang.String INSERTUID;

    private java.lang.String UPDATEUID;

    private java.lang.String SGSVRLOCANM;

    private java.lang.String COMPCD;

    private java.lang.String SHIFTDATA;

    private T_APPR_LINE_OUT_STEP[] t_APPR_LINE_OUT_STEP;

    private WsApAttachFile[] ATTACHFILES;

    public T_APPR_OUT_STEP() {
    }

    public T_APPR_OUT_STEP(
           java.lang.String SYSID,
           java.lang.String APPRID,
           java.lang.String APPRTYPEID,
           java.lang.String APPRTITLE,
           java.lang.String APPRSTATUSCD,
           java.lang.String APPRTRANSSTATUSCD,
           java.lang.String APPRCONTENTSCLOB,
           java.lang.String APPRCONTENTSCD,
           java.lang.String APPRKEY,
           java.lang.String APPRREVNO,
           java.lang.String APPRSUBMITDT,
           java.lang.String APPRCONFIRMDT,
           java.lang.String INSERTUID,
           java.lang.String UPDATEUID,
           java.lang.String SGSVRLOCANM,
           java.lang.String COMPCD,
           java.lang.String SHIFTDATA,
           T_APPR_LINE_OUT_STEP[] t_APPR_LINE_OUT_STEP,
           WsApAttachFile[] ATTACHFILES) {
           this.SYSID = SYSID;
           this.APPRID = APPRID;
           this.APPRTYPEID = APPRTYPEID;
           this.APPRTITLE = APPRTITLE;
           this.APPRSTATUSCD = APPRSTATUSCD;
           this.APPRTRANSSTATUSCD = APPRTRANSSTATUSCD;
           this.APPRCONTENTSCLOB = APPRCONTENTSCLOB;
           this.APPRCONTENTSCD = APPRCONTENTSCD;
           this.APPRKEY = APPRKEY;
           this.APPRREVNO = APPRREVNO;
           this.APPRSUBMITDT = APPRSUBMITDT;
           this.APPRCONFIRMDT = APPRCONFIRMDT;
           this.INSERTUID = INSERTUID;
           this.UPDATEUID = UPDATEUID;
           this.SGSVRLOCANM = SGSVRLOCANM;
           this.COMPCD = COMPCD;
           this.SHIFTDATA = SHIFTDATA;
           this.t_APPR_LINE_OUT_STEP = t_APPR_LINE_OUT_STEP;
           this.ATTACHFILES = ATTACHFILES;
    }


    /**
     * Gets the SYSID value for this T_APPR_OUT_STEP.
     * 
     * @return SYSID
     */
    public java.lang.String getSYSID() {
        return SYSID;
    }


    /**
     * Sets the SYSID value for this T_APPR_OUT_STEP.
     * 
     * @param SYSID
     */
    public void setSYSID(java.lang.String SYSID) {
        this.SYSID = SYSID;
    }


    /**
     * Gets the APPRID value for this T_APPR_OUT_STEP.
     * 
     * @return APPRID
     */
    public java.lang.String getAPPRID() {
        return APPRID;
    }


    /**
     * Sets the APPRID value for this T_APPR_OUT_STEP.
     * 
     * @param APPRID
     */
    public void setAPPRID(java.lang.String APPRID) {
        this.APPRID = APPRID;
    }


    /**
     * Gets the APPRTYPEID value for this T_APPR_OUT_STEP.
     * 
     * @return APPRTYPEID
     */
    public java.lang.String getAPPRTYPEID() {
        return APPRTYPEID;
    }


    /**
     * Sets the APPRTYPEID value for this T_APPR_OUT_STEP.
     * 
     * @param APPRTYPEID
     */
    public void setAPPRTYPEID(java.lang.String APPRTYPEID) {
        this.APPRTYPEID = APPRTYPEID;
    }


    /**
     * Gets the APPRTITLE value for this T_APPR_OUT_STEP.
     * 
     * @return APPRTITLE
     */
    public java.lang.String getAPPRTITLE() {
        return APPRTITLE;
    }


    /**
     * Sets the APPRTITLE value for this T_APPR_OUT_STEP.
     * 
     * @param APPRTITLE
     */
    public void setAPPRTITLE(java.lang.String APPRTITLE) {
        this.APPRTITLE = APPRTITLE;
    }


    /**
     * Gets the APPRSTATUSCD value for this T_APPR_OUT_STEP.
     * 
     * @return APPRSTATUSCD
     */
    public java.lang.String getAPPRSTATUSCD() {
        return APPRSTATUSCD;
    }


    /**
     * Sets the APPRSTATUSCD value for this T_APPR_OUT_STEP.
     * 
     * @param APPRSTATUSCD
     */
    public void setAPPRSTATUSCD(java.lang.String APPRSTATUSCD) {
        this.APPRSTATUSCD = APPRSTATUSCD;
    }


    /**
     * Gets the APPRTRANSSTATUSCD value for this T_APPR_OUT_STEP.
     * 
     * @return APPRTRANSSTATUSCD
     */
    public java.lang.String getAPPRTRANSSTATUSCD() {
        return APPRTRANSSTATUSCD;
    }


    /**
     * Sets the APPRTRANSSTATUSCD value for this T_APPR_OUT_STEP.
     * 
     * @param APPRTRANSSTATUSCD
     */
    public void setAPPRTRANSSTATUSCD(java.lang.String APPRTRANSSTATUSCD) {
        this.APPRTRANSSTATUSCD = APPRTRANSSTATUSCD;
    }


    /**
     * Gets the APPRCONTENTSCLOB value for this T_APPR_OUT_STEP.
     * 
     * @return APPRCONTENTSCLOB
     */
    public java.lang.String getAPPRCONTENTSCLOB() {
        return APPRCONTENTSCLOB;
    }


    /**
     * Sets the APPRCONTENTSCLOB value for this T_APPR_OUT_STEP.
     * 
     * @param APPRCONTENTSCLOB
     */
    public void setAPPRCONTENTSCLOB(java.lang.String APPRCONTENTSCLOB) {
        this.APPRCONTENTSCLOB = APPRCONTENTSCLOB;
    }


    /**
     * Gets the APPRCONTENTSCD value for this T_APPR_OUT_STEP.
     * 
     * @return APPRCONTENTSCD
     */
    public java.lang.String getAPPRCONTENTSCD() {
        return APPRCONTENTSCD;
    }


    /**
     * Sets the APPRCONTENTSCD value for this T_APPR_OUT_STEP.
     * 
     * @param APPRCONTENTSCD
     */
    public void setAPPRCONTENTSCD(java.lang.String APPRCONTENTSCD) {
        this.APPRCONTENTSCD = APPRCONTENTSCD;
    }


    /**
     * Gets the APPRKEY value for this T_APPR_OUT_STEP.
     * 
     * @return APPRKEY
     */
    public java.lang.String getAPPRKEY() {
        return APPRKEY;
    }


    /**
     * Sets the APPRKEY value for this T_APPR_OUT_STEP.
     * 
     * @param APPRKEY
     */
    public void setAPPRKEY(java.lang.String APPRKEY) {
        this.APPRKEY = APPRKEY;
    }


    /**
     * Gets the APPRREVNO value for this T_APPR_OUT_STEP.
     * 
     * @return APPRREVNO
     */
    public java.lang.String getAPPRREVNO() {
        return APPRREVNO;
    }


    /**
     * Sets the APPRREVNO value for this T_APPR_OUT_STEP.
     * 
     * @param APPRREVNO
     */
    public void setAPPRREVNO(java.lang.String APPRREVNO) {
        this.APPRREVNO = APPRREVNO;
    }


    /**
     * Gets the APPRSUBMITDT value for this T_APPR_OUT_STEP.
     * 
     * @return APPRSUBMITDT
     */
    public java.lang.String getAPPRSUBMITDT() {
        return APPRSUBMITDT;
    }


    /**
     * Sets the APPRSUBMITDT value for this T_APPR_OUT_STEP.
     * 
     * @param APPRSUBMITDT
     */
    public void setAPPRSUBMITDT(java.lang.String APPRSUBMITDT) {
        this.APPRSUBMITDT = APPRSUBMITDT;
    }


    /**
     * Gets the APPRCONFIRMDT value for this T_APPR_OUT_STEP.
     * 
     * @return APPRCONFIRMDT
     */
    public java.lang.String getAPPRCONFIRMDT() {
        return APPRCONFIRMDT;
    }


    /**
     * Sets the APPRCONFIRMDT value for this T_APPR_OUT_STEP.
     * 
     * @param APPRCONFIRMDT
     */
    public void setAPPRCONFIRMDT(java.lang.String APPRCONFIRMDT) {
        this.APPRCONFIRMDT = APPRCONFIRMDT;
    }


    /**
     * Gets the INSERTUID value for this T_APPR_OUT_STEP.
     * 
     * @return INSERTUID
     */
    public java.lang.String getINSERTUID() {
        return INSERTUID;
    }


    /**
     * Sets the INSERTUID value for this T_APPR_OUT_STEP.
     * 
     * @param INSERTUID
     */
    public void setINSERTUID(java.lang.String INSERTUID) {
        this.INSERTUID = INSERTUID;
    }


    /**
     * Gets the UPDATEUID value for this T_APPR_OUT_STEP.
     * 
     * @return UPDATEUID
     */
    public java.lang.String getUPDATEUID() {
        return UPDATEUID;
    }


    /**
     * Sets the UPDATEUID value for this T_APPR_OUT_STEP.
     * 
     * @param UPDATEUID
     */
    public void setUPDATEUID(java.lang.String UPDATEUID) {
        this.UPDATEUID = UPDATEUID;
    }


    /**
     * Gets the SGSVRLOCANM value for this T_APPR_OUT_STEP.
     * 
     * @return SGSVRLOCANM
     */
    public java.lang.String getSGSVRLOCANM() {
        return SGSVRLOCANM;
    }


    /**
     * Sets the SGSVRLOCANM value for this T_APPR_OUT_STEP.
     * 
     * @param SGSVRLOCANM
     */
    public void setSGSVRLOCANM(java.lang.String SGSVRLOCANM) {
        this.SGSVRLOCANM = SGSVRLOCANM;
    }


    /**
     * Gets the COMPCD value for this T_APPR_OUT_STEP.
     * 
     * @return COMPCD
     */
    public java.lang.String getCOMPCD() {
        return COMPCD;
    }


    /**
     * Sets the COMPCD value for this T_APPR_OUT_STEP.
     * 
     * @param COMPCD
     */
    public void setCOMPCD(java.lang.String COMPCD) {
        this.COMPCD = COMPCD;
    }


    /**
     * Gets the SHIFTDATA value for this T_APPR_OUT_STEP.
     * 
     * @return SHIFTDATA
     */
    public java.lang.String getSHIFTDATA() {
        return SHIFTDATA;
    }


    /**
     * Sets the SHIFTDATA value for this T_APPR_OUT_STEP.
     * 
     * @param SHIFTDATA
     */
    public void setSHIFTDATA(java.lang.String SHIFTDATA) {
        this.SHIFTDATA = SHIFTDATA;
    }


    /**
     * Gets the t_APPR_LINE_OUT_STEP value for this T_APPR_OUT_STEP.
     * 
     * @return t_APPR_LINE_OUT_STEP
     */
    public T_APPR_LINE_OUT_STEP[] getT_APPR_LINE_OUT_STEP() {
        return t_APPR_LINE_OUT_STEP;
    }


    /**
     * Sets the t_APPR_LINE_OUT_STEP value for this T_APPR_OUT_STEP.
     * 
     * @param t_APPR_LINE_OUT_STEP
     */
    public void setT_APPR_LINE_OUT_STEP(T_APPR_LINE_OUT_STEP[] t_APPR_LINE_OUT_STEP) {
        this.t_APPR_LINE_OUT_STEP = t_APPR_LINE_OUT_STEP;
    }

    public T_APPR_LINE_OUT_STEP getT_APPR_LINE_OUT_STEP(int i) {
        return this.t_APPR_LINE_OUT_STEP[i];
    }

    public void setT_APPR_LINE_OUT_STEP(int i, T_APPR_LINE_OUT_STEP _value) {
        this.t_APPR_LINE_OUT_STEP[i] = _value;
    }


    /**
     * Gets the ATTACHFILES value for this T_APPR_OUT_STEP.
     * 
     * @return ATTACHFILES
     */
    public WsApAttachFile[] getATTACHFILES() {
        return ATTACHFILES;
    }


    /**
     * Sets the ATTACHFILES value for this T_APPR_OUT_STEP.
     * 
     * @param ATTACHFILES
     */
    public void setATTACHFILES(WsApAttachFile[] ATTACHFILES) {
        this.ATTACHFILES = ATTACHFILES;
    }

    public WsApAttachFile getATTACHFILES(int i) {
        return this.ATTACHFILES[i];
    }

    public void setATTACHFILES(int i, WsApAttachFile _value) {
        this.ATTACHFILES[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof T_APPR_OUT_STEP)) return false;
        T_APPR_OUT_STEP other = (T_APPR_OUT_STEP) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.SYSID==null && other.getSYSID()==null) || 
             (this.SYSID!=null &&
              this.SYSID.equals(other.getSYSID()))) &&
            ((this.APPRID==null && other.getAPPRID()==null) || 
             (this.APPRID!=null &&
              this.APPRID.equals(other.getAPPRID()))) &&
            ((this.APPRTYPEID==null && other.getAPPRTYPEID()==null) || 
             (this.APPRTYPEID!=null &&
              this.APPRTYPEID.equals(other.getAPPRTYPEID()))) &&
            ((this.APPRTITLE==null && other.getAPPRTITLE()==null) || 
             (this.APPRTITLE!=null &&
              this.APPRTITLE.equals(other.getAPPRTITLE()))) &&
            ((this.APPRSTATUSCD==null && other.getAPPRSTATUSCD()==null) || 
             (this.APPRSTATUSCD!=null &&
              this.APPRSTATUSCD.equals(other.getAPPRSTATUSCD()))) &&
            ((this.APPRTRANSSTATUSCD==null && other.getAPPRTRANSSTATUSCD()==null) || 
             (this.APPRTRANSSTATUSCD!=null &&
              this.APPRTRANSSTATUSCD.equals(other.getAPPRTRANSSTATUSCD()))) &&
            ((this.APPRCONTENTSCLOB==null && other.getAPPRCONTENTSCLOB()==null) || 
             (this.APPRCONTENTSCLOB!=null &&
              this.APPRCONTENTSCLOB.equals(other.getAPPRCONTENTSCLOB()))) &&
            ((this.APPRCONTENTSCD==null && other.getAPPRCONTENTSCD()==null) || 
             (this.APPRCONTENTSCD!=null &&
              this.APPRCONTENTSCD.equals(other.getAPPRCONTENTSCD()))) &&
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
            ((this.UPDATEUID==null && other.getUPDATEUID()==null) || 
             (this.UPDATEUID!=null &&
              this.UPDATEUID.equals(other.getUPDATEUID()))) &&
            ((this.SGSVRLOCANM==null && other.getSGSVRLOCANM()==null) || 
             (this.SGSVRLOCANM!=null &&
              this.SGSVRLOCANM.equals(other.getSGSVRLOCANM()))) &&
            ((this.COMPCD==null && other.getCOMPCD()==null) || 
             (this.COMPCD!=null &&
              this.COMPCD.equals(other.getCOMPCD()))) &&
            ((this.SHIFTDATA==null && other.getSHIFTDATA()==null) || 
             (this.SHIFTDATA!=null &&
              this.SHIFTDATA.equals(other.getSHIFTDATA()))) &&
            ((this.t_APPR_LINE_OUT_STEP==null && other.getT_APPR_LINE_OUT_STEP()==null) || 
             (this.t_APPR_LINE_OUT_STEP!=null &&
              java.util.Arrays.equals(this.t_APPR_LINE_OUT_STEP, other.getT_APPR_LINE_OUT_STEP()))) &&
            ((this.ATTACHFILES==null && other.getATTACHFILES()==null) || 
             (this.ATTACHFILES!=null &&
              java.util.Arrays.equals(this.ATTACHFILES, other.getATTACHFILES())));
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
        if (getSYSID() != null) {
            _hashCode += getSYSID().hashCode();
        }
        if (getAPPRID() != null) {
            _hashCode += getAPPRID().hashCode();
        }
        if (getAPPRTYPEID() != null) {
            _hashCode += getAPPRTYPEID().hashCode();
        }
        if (getAPPRTITLE() != null) {
            _hashCode += getAPPRTITLE().hashCode();
        }
        if (getAPPRSTATUSCD() != null) {
            _hashCode += getAPPRSTATUSCD().hashCode();
        }
        if (getAPPRTRANSSTATUSCD() != null) {
            _hashCode += getAPPRTRANSSTATUSCD().hashCode();
        }
        if (getAPPRCONTENTSCLOB() != null) {
            _hashCode += getAPPRCONTENTSCLOB().hashCode();
        }
        if (getAPPRCONTENTSCD() != null) {
            _hashCode += getAPPRCONTENTSCD().hashCode();
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
        if (getUPDATEUID() != null) {
            _hashCode += getUPDATEUID().hashCode();
        }
        if (getSGSVRLOCANM() != null) {
            _hashCode += getSGSVRLOCANM().hashCode();
        }
        if (getCOMPCD() != null) {
            _hashCode += getCOMPCD().hashCode();
        }
        if (getSHIFTDATA() != null) {
            _hashCode += getSHIFTDATA().hashCode();
        }
        if (getT_APPR_LINE_OUT_STEP() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getT_APPR_LINE_OUT_STEP());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getT_APPR_LINE_OUT_STEP(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getATTACHFILES() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getATTACHFILES());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getATTACHFILES(), i);
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
        new org.apache.axis.description.TypeDesc(T_APPR_OUT_STEP.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://M2KEP0001M2016.service.ws.kep.stw.com/", "T_APPR_OUT_STEP"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SYSID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "SYSID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRTYPEID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRTYPEID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRTITLE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRTITLE"));
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
        elemField.setFieldName("APPRCONTENTSCLOB");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRCONTENTSCLOB"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRCONTENTSCD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRCONTENTSCD"));
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
        elemField.setFieldName("UPDATEUID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "UPDATEUID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SGSVRLOCANM");
        elemField.setXmlName(new javax.xml.namespace.QName("", "SGSVRLOCANM"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("COMPCD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "COMPCD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("SHIFTDATA");
        elemField.setXmlName(new javax.xml.namespace.QName("", "SHIFTDATA"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("t_APPR_LINE_OUT_STEP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "T_APPR_LINE_OUT_STEP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://M2KEP0001M2016.service.ws.kep.stw.com/", "T_APPR_LINE_OUT_STEP"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ATTACHFILES");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ATTACHFILES"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://M2KEP0001M2016.service.ws.kep.stw.com/", "wsApAttachFile"));
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
