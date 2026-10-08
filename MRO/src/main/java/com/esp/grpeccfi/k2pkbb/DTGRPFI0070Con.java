
package com.esp.grpeccfi.k2pkbb;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for DT_GRP_FI0070_Con complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="DT_GRP_FI0070_Con">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Header" type="{http://grpeccfi.esp.com/k2pkbb}DT_ReqHeader"/>
 *         &lt;element name="Body">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="B_SEARCH" maxOccurs="unbounded" minOccurs="0">
 *                     &lt;complexType>
 *                       &lt;complexContent>
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                           &lt;sequence>
 *                             &lt;element name="BUKRS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="COM_SAP_CODE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="COM_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="S01" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="COUNTRY_CODE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="IRS_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="S02" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="S03" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="CORP_REG_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="CEO_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="INDUSTRY_TYPE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="BUSINESS_ITEMS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="S04" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="F_ADD_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="T_ADD_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="F_CHANGE_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="T_CHANGE_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                           &lt;/sequence>
 *                         &lt;/restriction>
 *                       &lt;/complexContent>
 *                     &lt;/complexType>
 *                   &lt;/element>
 *                 &lt;/sequence>
 *               &lt;/restriction>
 *             &lt;/complexContent>
 *           &lt;/complexType>
 *         &lt;/element>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "DT_GRP_FI0070_Con", propOrder = {
    "header",
    "body"
})
public class DTGRPFI0070Con {

    @XmlElement(name = "Header", required = true)
    protected DTReqHeader header;
    @XmlElement(name = "Body", required = true)
    protected DTGRPFI0070Con.Body body;

    /**
     * Gets the value of the header property.
     * 
     * @return
     *     possible object is
     *     {@link DTReqHeader }
     *     
     */
    public DTReqHeader getHeader() {
        return header;
    }

    /**
     * Sets the value of the header property.
     * 
     * @param value
     *     allowed object is
     *     {@link DTReqHeader }
     *     
     */
    public void setHeader(DTReqHeader value) {
        this.header = value;
    }

    /**
     * Gets the value of the body property.
     * 
     * @return
     *     possible object is
     *     {@link DTGRPFI0070Con.Body }
     *     
     */
    public DTGRPFI0070Con.Body getBody() {
        return body;
    }

    /**
     * Sets the value of the body property.
     * 
     * @param value
     *     allowed object is
     *     {@link DTGRPFI0070Con.Body }
     *     
     */
    public void setBody(DTGRPFI0070Con.Body value) {
        this.body = value;
    }


    /**
     * <p>Java class for anonymous complex type.
     * 
     * <p>The following schema fragment specifies the expected content contained within this class.
     * 
     * <pre>
     * &lt;complexType>
     *   &lt;complexContent>
     *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *       &lt;sequence>
     *         &lt;element name="B_SEARCH" maxOccurs="unbounded" minOccurs="0">
     *           &lt;complexType>
     *             &lt;complexContent>
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *                 &lt;sequence>
     *                   &lt;element name="BUKRS" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="COM_SAP_CODE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="COM_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="S01" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="COUNTRY_CODE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="IRS_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="S02" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="S03" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="CORP_REG_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="CEO_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="INDUSTRY_TYPE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="BUSINESS_ITEMS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="S04" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="F_ADD_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="T_ADD_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="F_CHANGE_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="T_CHANGE_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                 &lt;/sequence>
     *               &lt;/restriction>
     *             &lt;/complexContent>
     *           &lt;/complexType>
     *         &lt;/element>
     *       &lt;/sequence>
     *     &lt;/restriction>
     *   &lt;/complexContent>
     * &lt;/complexType>
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "bsearch"
    })
    public static class Body {

        @XmlElement(name = "B_SEARCH")
        protected List<DTGRPFI0070Con.Body.BSEARCH> bsearch;

        /**
         * Gets the value of the bsearch property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the bsearch property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getBSEARCH().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link DTGRPFI0070Con.Body.BSEARCH }
         * 
         * 
         */
        public List<DTGRPFI0070Con.Body.BSEARCH> getBSEARCH() {
            if (bsearch == null) {
                bsearch = new ArrayList<DTGRPFI0070Con.Body.BSEARCH>();
            }
            return this.bsearch;
        }


        /**
         * <p>Java class for anonymous complex type.
         * 
         * <p>The following schema fragment specifies the expected content contained within this class.
         * 
         * <pre>
         * &lt;complexType>
         *   &lt;complexContent>
         *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
         *       &lt;sequence>
         *         &lt;element name="BUKRS" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="COM_SAP_CODE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="COM_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="S01" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="COUNTRY_CODE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="IRS_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="S02" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="S03" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="CORP_REG_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="CEO_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="INDUSTRY_TYPE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="BUSINESS_ITEMS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="S04" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="F_ADD_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="T_ADD_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="F_CHANGE_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="T_CHANGE_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *       &lt;/sequence>
         *     &lt;/restriction>
         *   &lt;/complexContent>
         * &lt;/complexType>
         * </pre>
         * 
         * 
         */
        @XmlAccessorType(XmlAccessType.FIELD)
        @XmlType(name = "", propOrder = {
            "bukrs",
            "comsapcode",
            "comnameloc",
            "s01",
            "countrycode",
            "irsno",
            "s02",
            "s03",
            "corpregno",
            "ceonameloc",
            "industrytype",
            "businessitems",
            "s04",
            "fadddate",
            "tadddate",
            "fchangedate",
            "tchangedate"
        })
        public static class BSEARCH {

            @XmlElement(name = "BUKRS", required = true)
            protected String bukrs;
            @XmlElement(name = "COM_SAP_CODE")
            protected String comsapcode;
            @XmlElement(name = "COM_NAME_LOC")
            protected String comnameloc;
            @XmlElement(name = "S01")
            protected String s01;
            @XmlElement(name = "COUNTRY_CODE")
            protected String countrycode;
            @XmlElement(name = "IRS_NO")
            protected String irsno;
            @XmlElement(name = "S02")
            protected String s02;
            @XmlElement(name = "S03")
            protected String s03;
            @XmlElement(name = "CORP_REG_NO")
            protected String corpregno;
            @XmlElement(name = "CEO_NAME_LOC")
            protected String ceonameloc;
            @XmlElement(name = "INDUSTRY_TYPE")
            protected String industrytype;
            @XmlElement(name = "BUSINESS_ITEMS")
            protected String businessitems;
            @XmlElement(name = "S04")
            protected String s04;
            @XmlElement(name = "F_ADD_DATE")
            protected String fadddate;
            @XmlElement(name = "T_ADD_DATE")
            protected String tadddate;
            @XmlElement(name = "F_CHANGE_DATE")
            protected String fchangedate;
            @XmlElement(name = "T_CHANGE_DATE")
            protected String tchangedate;

            /**
             * Gets the value of the bukrs property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getBUKRS() {
                return bukrs;
            }

            /**
             * Sets the value of the bukrs property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setBUKRS(String value) {
                this.bukrs = value;
            }

            /**
             * Gets the value of the comsapcode property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getCOMSAPCODE() {
                return comsapcode;
            }

            /**
             * Sets the value of the comsapcode property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setCOMSAPCODE(String value) {
                this.comsapcode = value;
            }

            /**
             * Gets the value of the comnameloc property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getCOMNAMELOC() {
                return comnameloc;
            }

            /**
             * Sets the value of the comnameloc property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setCOMNAMELOC(String value) {
                this.comnameloc = value;
            }

            /**
             * Gets the value of the s01 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getS01() {
                return s01;
            }

            /**
             * Sets the value of the s01 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setS01(String value) {
                this.s01 = value;
            }

            /**
             * Gets the value of the countrycode property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getCOUNTRYCODE() {
                return countrycode;
            }

            /**
             * Sets the value of the countrycode property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setCOUNTRYCODE(String value) {
                this.countrycode = value;
            }

            /**
             * Gets the value of the irsno property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getIRSNO() {
                return irsno;
            }

            /**
             * Sets the value of the irsno property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setIRSNO(String value) {
                this.irsno = value;
            }

            /**
             * Gets the value of the s02 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getS02() {
                return s02;
            }

            /**
             * Sets the value of the s02 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setS02(String value) {
                this.s02 = value;
            }

            /**
             * Gets the value of the s03 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getS03() {
                return s03;
            }

            /**
             * Sets the value of the s03 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setS03(String value) {
                this.s03 = value;
            }

            /**
             * Gets the value of the corpregno property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getCORPREGNO() {
                return corpregno;
            }

            /**
             * Sets the value of the corpregno property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setCORPREGNO(String value) {
                this.corpregno = value;
            }

            /**
             * Gets the value of the ceonameloc property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getCEONAMELOC() {
                return ceonameloc;
            }

            /**
             * Sets the value of the ceonameloc property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setCEONAMELOC(String value) {
                this.ceonameloc = value;
            }

            /**
             * Gets the value of the industrytype property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getINDUSTRYTYPE() {
                return industrytype;
            }

            /**
             * Sets the value of the industrytype property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setINDUSTRYTYPE(String value) {
                this.industrytype = value;
            }

            /**
             * Gets the value of the businessitems property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getBUSINESSITEMS() {
                return businessitems;
            }

            /**
             * Sets the value of the businessitems property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setBUSINESSITEMS(String value) {
                this.businessitems = value;
            }

            /**
             * Gets the value of the s04 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getS04() {
                return s04;
            }

            /**
             * Sets the value of the s04 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setS04(String value) {
                this.s04 = value;
            }

            /**
             * Gets the value of the fadddate property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getFADDDATE() {
                return fadddate;
            }

            /**
             * Sets the value of the fadddate property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setFADDDATE(String value) {
                this.fadddate = value;
            }

            /**
             * Gets the value of the tadddate property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getTADDDATE() {
                return tadddate;
            }

            /**
             * Sets the value of the tadddate property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setTADDDATE(String value) {
                this.tadddate = value;
            }

            /**
             * Gets the value of the fchangedate property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getFCHANGEDATE() {
                return fchangedate;
            }

            /**
             * Sets the value of the fchangedate property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setFCHANGEDATE(String value) {
                this.fchangedate = value;
            }

            /**
             * Gets the value of the tchangedate property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getTCHANGEDATE() {
                return tchangedate;
            }

            /**
             * Sets the value of the tchangedate property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setTCHANGEDATE(String value) {
                this.tchangedate = value;
            }

        }

    }

}
