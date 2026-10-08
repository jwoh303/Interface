
package com.esp.grpeccfi.k2pkbb;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for DT_GRP_FI0450_Con_response complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="DT_GRP_FI0450_Con_response">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Header" type="{http://grpeccfi.esp.com/k2pkbb}DT_ResHeader"/>
 *         &lt;element name="Body">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="S_RECV" maxOccurs="unbounded" minOccurs="0">
 *                     &lt;complexType>
 *                       &lt;complexContent>
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                           &lt;sequence>
 *                             &lt;element name="BUKRS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="COM_SAP_CODE" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="COM_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="S01" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="COUNTRY_CODE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="ADDRESS_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="IRS_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="S02" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="CEO_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="INDUSTRY_TYPE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="BUSINESS_ITEMS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="S03" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="S04" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="CORP_REG_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="TEL_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="FAX_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="HP_ADDRESS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="S05" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="ADD_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="CHANGE_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
@XmlType(name = "DT_GRP_FI0450_Con_response", propOrder = {
    "header",
    "body"
})
public class DTGRPFI0450ConResponse {

    @XmlElement(name = "Header", required = true)
    protected DTResHeader header;
    @XmlElement(name = "Body", required = true)
    protected DTGRPFI0450ConResponse.Body body;

    /**
     * Gets the value of the header property.
     * 
     * @return
     *     possible object is
     *     {@link DTResHeader }
     *     
     */
    public DTResHeader getHeader() {
        return header;
    }

    /**
     * Sets the value of the header property.
     * 
     * @param value
     *     allowed object is
     *     {@link DTResHeader }
     *     
     */
    public void setHeader(DTResHeader value) {
        this.header = value;
    }

    /**
     * Gets the value of the body property.
     * 
     * @return
     *     possible object is
     *     {@link DTGRPFI0450ConResponse.Body }
     *     
     */
    public DTGRPFI0450ConResponse.Body getBody() {
        return body;
    }

    /**
     * Sets the value of the body property.
     * 
     * @param value
     *     allowed object is
     *     {@link DTGRPFI0450ConResponse.Body }
     *     
     */
    public void setBody(DTGRPFI0450ConResponse.Body value) {
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
     *         &lt;element name="S_RECV" maxOccurs="unbounded" minOccurs="0">
     *           &lt;complexType>
     *             &lt;complexContent>
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *                 &lt;sequence>
     *                   &lt;element name="BUKRS" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="COM_SAP_CODE" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="COM_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="S01" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="COUNTRY_CODE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="ADDRESS_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="IRS_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="S02" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="CEO_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="INDUSTRY_TYPE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="BUSINESS_ITEMS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="S03" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="S04" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="CORP_REG_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="TEL_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="FAX_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="HP_ADDRESS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="S05" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="ADD_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="CHANGE_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
        "srecv"
    })
    public static class Body {

        @XmlElement(name = "S_RECV")
        protected List<DTGRPFI0450ConResponse.Body.SRECV> srecv;

        /**
         * Gets the value of the srecv property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the srecv property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getSRECV().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link DTGRPFI0450ConResponse.Body.SRECV }
         * 
         * 
         */
        public List<DTGRPFI0450ConResponse.Body.SRECV> getSRECV() {
            if (srecv == null) {
                srecv = new ArrayList<DTGRPFI0450ConResponse.Body.SRECV>();
            }
            return this.srecv;
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
         *         &lt;element name="COM_SAP_CODE" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="COM_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="S01" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="COUNTRY_CODE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="ADDRESS_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="IRS_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="S02" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="CEO_NAME_LOC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="INDUSTRY_TYPE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="BUSINESS_ITEMS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="S03" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="S04" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="CORP_REG_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="TEL_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="FAX_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="HP_ADDRESS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="S05" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="ADD_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="CHANGE_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
            "addressloc",
            "irsno",
            "s02",
            "ceonameloc",
            "industrytype",
            "businessitems",
            "s03",
            "s04",
            "corpregno",
            "telno",
            "faxno",
            "hpaddress",
            "s05",
            "adddate",
            "changedate"
        })
        public static class SRECV {

            @XmlElement(name = "BUKRS", required = true)
            protected String bukrs;
            @XmlElement(name = "COM_SAP_CODE", required = true)
            protected String comsapcode;
            @XmlElement(name = "COM_NAME_LOC")
            protected String comnameloc;
            @XmlElement(name = "S01")
            protected String s01;
            @XmlElement(name = "COUNTRY_CODE")
            protected String countrycode;
            @XmlElement(name = "ADDRESS_LOC")
            protected String addressloc;
            @XmlElement(name = "IRS_NO")
            protected String irsno;
            @XmlElement(name = "S02")
            protected String s02;
            @XmlElement(name = "CEO_NAME_LOC")
            protected String ceonameloc;
            @XmlElement(name = "INDUSTRY_TYPE")
            protected String industrytype;
            @XmlElement(name = "BUSINESS_ITEMS")
            protected String businessitems;
            @XmlElement(name = "S03")
            protected String s03;
            @XmlElement(name = "S04")
            protected String s04;
            @XmlElement(name = "CORP_REG_NO")
            protected String corpregno;
            @XmlElement(name = "TEL_NO")
            protected String telno;
            @XmlElement(name = "FAX_NO")
            protected String faxno;
            @XmlElement(name = "HP_ADDRESS")
            protected String hpaddress;
            @XmlElement(name = "S05")
            protected String s05;
            @XmlElement(name = "ADD_DATE")
            protected String adddate;
            @XmlElement(name = "CHANGE_DATE")
            protected String changedate;

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
             * Gets the value of the addressloc property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getADDRESSLOC() {
                return addressloc;
            }

            /**
             * Sets the value of the addressloc property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setADDRESSLOC(String value) {
                this.addressloc = value;
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
             * Gets the value of the telno property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getTELNO() {
                return telno;
            }

            /**
             * Sets the value of the telno property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setTELNO(String value) {
                this.telno = value;
            }

            /**
             * Gets the value of the faxno property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getFAXNO() {
                return faxno;
            }

            /**
             * Sets the value of the faxno property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setFAXNO(String value) {
                this.faxno = value;
            }

            /**
             * Gets the value of the hpaddress property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getHPADDRESS() {
                return hpaddress;
            }

            /**
             * Sets the value of the hpaddress property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setHPADDRESS(String value) {
                this.hpaddress = value;
            }

            /**
             * Gets the value of the s05 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getS05() {
                return s05;
            }

            /**
             * Sets the value of the s05 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setS05(String value) {
                this.s05 = value;
            }

            /**
             * Gets the value of the adddate property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getADDDATE() {
                return adddate;
            }

            /**
             * Sets the value of the adddate property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setADDDATE(String value) {
                this.adddate = value;
            }

            /**
             * Gets the value of the changedate property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getCHANGEDATE() {
                return changedate;
            }

            /**
             * Sets the value of the changedate property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setCHANGEDATE(String value) {
                this.changedate = value;
            }

        }

    }

}
