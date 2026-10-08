/**
 * T_APPR_OUT_STEP.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package hdli.cs.ws.server;

public class T_APPR_OUT_STEP  implements java.io.Serializable {
    private java.lang.String SYSID;

    private java.lang.String APPRID;

    private java.lang.String APPRTYPEID;

    private java.lang.String APPRTITLE;

    private java.lang.String APPRCONTENTSCLOB;

    private java.lang.String APPRCONTENTSCD;

    private java.lang.String COMPANYID;

    private java.lang.String DEPTOPENYN;

    private java.lang.String FLOWCASE;

    private java.lang.String FORMCODE;

    private java.lang.String INITDEPTOPENYN;

    private java.lang.String PRESERVATIONTERMCODE;

    private java.lang.String APPRSUBMITDT;

    private java.lang.String INSERTUID;

    private java.lang.String UPDATEUID;

    private java.lang.String APPRSTATUSCD;

    private hdli.cs.ws.server.T_APPR_LINE_OUT_STEP[] t_APPR_LINE_OUT_STEP;

    private hdli.cs.ws.server.WsApAttachFile[] ATTACHFILES;

    public T_APPR_OUT_STEP() {
    }

    public T_APPR_OUT_STEP(
           java.lang.String SYSID,
           java.lang.String APPRID,
           java.lang.String APPRTYPEID,
           java.lang.String APPRTITLE,
           java.lang.String APPRCONTENTSCLOB,
           java.lang.String APPRCONTENTSCD,
           java.lang.String COMPANYID,
           java.lang.String DEPTOPENYN,
           java.lang.String FLOWCASE,
           java.lang.String FORMCODE,
           java.lang.String INITDEPTOPENYN,
           java.lang.String PRESERVATIONTERMCODE,
           java.lang.String APPRSUBMITDT,
           java.lang.String INSERTUID,
           java.lang.String UPDATEUID,
           java.lang.String APPRSTATUSCD,
           hdli.cs.ws.server.T_APPR_LINE_OUT_STEP[] t_APPR_LINE_OUT_STEP,
           hdli.cs.ws.server.WsApAttachFile[] ATTACHFILES) {
           this.SYSID = SYSID;
           this.APPRID = APPRID;
           this.APPRTYPEID = APPRTYPEID;
           this.APPRTITLE = APPRTITLE;
           this.APPRCONTENTSCLOB = APPRCONTENTSCLOB;
           this.APPRCONTENTSCD = APPRCONTENTSCD;
           this.COMPANYID = COMPANYID;
           this.DEPTOPENYN = DEPTOPENYN;
           this.FLOWCASE = FLOWCASE;
           this.FORMCODE = FORMCODE;
           this.INITDEPTOPENYN = INITDEPTOPENYN;
           this.PRESERVATIONTERMCODE = PRESERVATIONTERMCODE;
           this.APPRSUBMITDT = APPRSUBMITDT;
           this.INSERTUID = INSERTUID;
           this.UPDATEUID = UPDATEUID;
           this.APPRSTATUSCD = APPRSTATUSCD;
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
     * Gets the COMPANYID value for this T_APPR_OUT_STEP.
     * 
     * @return COMPANYID
     */
    public java.lang.String getCOMPANYID() {
        return COMPANYID;
    }


    /**
     * Sets the COMPANYID value for this T_APPR_OUT_STEP.
     * 
     * @param COMPANYID
     */
    public void setCOMPANYID(java.lang.String COMPANYID) {
        this.COMPANYID = COMPANYID;
    }


    /**
     * Gets the DEPTOPENYN value for this T_APPR_OUT_STEP.
     * 
     * @return DEPTOPENYN
     */
    public java.lang.String getDEPTOPENYN() {
        return DEPTOPENYN;
    }


    /**
     * Sets the DEPTOPENYN value for this T_APPR_OUT_STEP.
     * 
     * @param DEPTOPENYN
     */
    public void setDEPTOPENYN(java.lang.String DEPTOPENYN) {
        this.DEPTOPENYN = DEPTOPENYN;
    }


    /**
     * Gets the FLOWCASE value for this T_APPR_OUT_STEP.
     * 
     * @return FLOWCASE
     */
    public java.lang.String getFLOWCASE() {
        return FLOWCASE;
    }


    /**
     * Sets the FLOWCASE value for this T_APPR_OUT_STEP.
     * 
     * @param FLOWCASE
     */
    public void setFLOWCASE(java.lang.String FLOWCASE) {
        this.FLOWCASE = FLOWCASE;
    }


    /**
     * Gets the FORMCODE value for this T_APPR_OUT_STEP.
     * 
     * @return FORMCODE
     */
    public java.lang.String getFORMCODE() {
        return FORMCODE;
    }


    /**
     * Sets the FORMCODE value for this T_APPR_OUT_STEP.
     * 
     * @param FORMCODE
     */
    public void setFORMCODE(java.lang.String FORMCODE) {
        this.FORMCODE = FORMCODE;
    }


    /**
     * Gets the INITDEPTOPENYN value for this T_APPR_OUT_STEP.
     * 
     * @return INITDEPTOPENYN
     */
    public java.lang.String getINITDEPTOPENYN() {
        return INITDEPTOPENYN;
    }


    /**
     * Sets the INITDEPTOPENYN value for this T_APPR_OUT_STEP.
     * 
     * @param INITDEPTOPENYN
     */
    public void setINITDEPTOPENYN(java.lang.String INITDEPTOPENYN) {
        this.INITDEPTOPENYN = INITDEPTOPENYN;
    }


    /**
     * Gets the PRESERVATIONTERMCODE value for this T_APPR_OUT_STEP.
     * 
     * @return PRESERVATIONTERMCODE
     */
    public java.lang.String getPRESERVATIONTERMCODE() {
        return PRESERVATIONTERMCODE;
    }


    /**
     * Sets the PRESERVATIONTERMCODE value for this T_APPR_OUT_STEP.
     * 
     * @param PRESERVATIONTERMCODE
     */
    public void setPRESERVATIONTERMCODE(java.lang.String PRESERVATIONTERMCODE) {
        this.PRESERVATIONTERMCODE = PRESERVATIONTERMCODE;
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
     * Gets the t_APPR_LINE_OUT_STEP value for this T_APPR_OUT_STEP.
     * 
     * @return t_APPR_LINE_OUT_STEP
     */
    public hdli.cs.ws.server.T_APPR_LINE_OUT_STEP[] getT_APPR_LINE_OUT_STEP() {
        return t_APPR_LINE_OUT_STEP;
    }


    /**
     * Sets the t_APPR_LINE_OUT_STEP value for this T_APPR_OUT_STEP.
     * 
     * @param t_APPR_LINE_OUT_STEP
     */
    public void setT_APPR_LINE_OUT_STEP(hdli.cs.ws.server.T_APPR_LINE_OUT_STEP[] t_APPR_LINE_OUT_STEP) {
        this.t_APPR_LINE_OUT_STEP = t_APPR_LINE_OUT_STEP;
    }

    public hdli.cs.ws.server.T_APPR_LINE_OUT_STEP getT_APPR_LINE_OUT_STEP(int i) {
        return this.t_APPR_LINE_OUT_STEP[i];
    }

    public void setT_APPR_LINE_OUT_STEP(int i, hdli.cs.ws.server.T_APPR_LINE_OUT_STEP _value) {
        this.t_APPR_LINE_OUT_STEP[i] = _value;
    }


    /**
     * Gets the ATTACHFILES value for this T_APPR_OUT_STEP.
     * 
     * @return ATTACHFILES
     */
    public hdli.cs.ws.server.WsApAttachFile[] getATTACHFILES() {
        return ATTACHFILES;
    }


    /**
     * Sets the ATTACHFILES value for this T_APPR_OUT_STEP.
     * 
     * @param ATTACHFILES
     */
    public void setATTACHFILES(hdli.cs.ws.server.WsApAttachFile[] ATTACHFILES) {
        this.ATTACHFILES = ATTACHFILES;
    }

    public hdli.cs.ws.server.WsApAttachFile getATTACHFILES(int i) {
        return this.ATTACHFILES[i];
    }

    public void setATTACHFILES(int i, hdli.cs.ws.server.WsApAttachFile _value) {
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
            ((this.APPRCONTENTSCLOB==null && other.getAPPRCONTENTSCLOB()==null) || 
             (this.APPRCONTENTSCLOB!=null &&
              this.APPRCONTENTSCLOB.equals(other.getAPPRCONTENTSCLOB()))) &&
            ((this.APPRCONTENTSCD==null && other.getAPPRCONTENTSCD()==null) || 
             (this.APPRCONTENTSCD!=null &&
              this.APPRCONTENTSCD.equals(other.getAPPRCONTENTSCD()))) &&
            ((this.COMPANYID==null && other.getCOMPANYID()==null) || 
             (this.COMPANYID!=null &&
              this.COMPANYID.equals(other.getCOMPANYID()))) &&
            ((this.DEPTOPENYN==null && other.getDEPTOPENYN()==null) || 
             (this.DEPTOPENYN!=null &&
              this.DEPTOPENYN.equals(other.getDEPTOPENYN()))) &&
            ((this.FLOWCASE==null && other.getFLOWCASE()==null) || 
             (this.FLOWCASE!=null &&
              this.FLOWCASE.equals(other.getFLOWCASE()))) &&
            ((this.FORMCODE==null && other.getFORMCODE()==null) || 
             (this.FORMCODE!=null &&
              this.FORMCODE.equals(other.getFORMCODE()))) &&
            ((this.INITDEPTOPENYN==null && other.getINITDEPTOPENYN()==null) || 
             (this.INITDEPTOPENYN!=null &&
              this.INITDEPTOPENYN.equals(other.getINITDEPTOPENYN()))) &&
            ((this.PRESERVATIONTERMCODE==null && other.getPRESERVATIONTERMCODE()==null) || 
             (this.PRESERVATIONTERMCODE!=null &&
              this.PRESERVATIONTERMCODE.equals(other.getPRESERVATIONTERMCODE()))) &&
            ((this.APPRSUBMITDT==null && other.getAPPRSUBMITDT()==null) || 
             (this.APPRSUBMITDT!=null &&
              this.APPRSUBMITDT.equals(other.getAPPRSUBMITDT()))) &&
            ((this.INSERTUID==null && other.getINSERTUID()==null) || 
             (this.INSERTUID!=null &&
              this.INSERTUID.equals(other.getINSERTUID()))) &&
            ((this.UPDATEUID==null && other.getUPDATEUID()==null) || 
             (this.UPDATEUID!=null &&
              this.UPDATEUID.equals(other.getUPDATEUID()))) &&
            ((this.APPRSTATUSCD==null && other.getAPPRSTATUSCD()==null) || 
             (this.APPRSTATUSCD!=null &&
              this.APPRSTATUSCD.equals(other.getAPPRSTATUSCD()))) &&
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
        if (getAPPRCONTENTSCLOB() != null) {
            _hashCode += getAPPRCONTENTSCLOB().hashCode();
        }
        if (getAPPRCONTENTSCD() != null) {
            _hashCode += getAPPRCONTENTSCD().hashCode();
        }
        if (getCOMPANYID() != null) {
            _hashCode += getCOMPANYID().hashCode();
        }
        if (getDEPTOPENYN() != null) {
            _hashCode += getDEPTOPENYN().hashCode();
        }
        if (getFLOWCASE() != null) {
            _hashCode += getFLOWCASE().hashCode();
        }
        if (getFORMCODE() != null) {
            _hashCode += getFORMCODE().hashCode();
        }
        if (getINITDEPTOPENYN() != null) {
            _hashCode += getINITDEPTOPENYN().hashCode();
        }
        if (getPRESERVATIONTERMCODE() != null) {
            _hashCode += getPRESERVATIONTERMCODE().hashCode();
        }
        if (getAPPRSUBMITDT() != null) {
            _hashCode += getAPPRSUBMITDT().hashCode();
        }
        if (getINSERTUID() != null) {
            _hashCode += getINSERTUID().hashCode();
        }
        if (getUPDATEUID() != null) {
            _hashCode += getUPDATEUID().hashCode();
        }
        if (getAPPRSTATUSCD() != null) {
            _hashCode += getAPPRSTATUSCD().hashCode();
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
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "T_APPR_OUT_STEP"));
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
        elemField.setFieldName("APPRCONTENTSCLOB");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRCONTENTSCLOB"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRCONTENTSCD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRCONTENTSCD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("COMPANYID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "COMPANYID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DEPTOPENYN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "DEPTOPENYN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("FLOWCASE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "FLOWCASE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("FORMCODE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "FORMCODE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("INITDEPTOPENYN");
        elemField.setXmlName(new javax.xml.namespace.QName("", "INITDEPTOPENYN"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PRESERVATIONTERMCODE");
        elemField.setXmlName(new javax.xml.namespace.QName("", "PRESERVATIONTERMCODE"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("APPRSUBMITDT");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRSUBMITDT"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
        elemField.setFieldName("APPRSTATUSCD");
        elemField.setXmlName(new javax.xml.namespace.QName("", "APPRSTATUSCD"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("t_APPR_LINE_OUT_STEP");
        elemField.setXmlName(new javax.xml.namespace.QName("", "T_APPR_LINE_OUT_STEP"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "T_APPR_LINE_OUT_STEP"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ATTACHFILES");
        elemField.setXmlName(new javax.xml.namespace.QName("", "ATTACHFILES"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "wsApAttachFile"));
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
