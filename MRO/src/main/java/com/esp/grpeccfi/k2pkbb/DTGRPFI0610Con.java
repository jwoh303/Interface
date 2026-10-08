
package com.esp.grpeccfi.k2pkbb;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for DT_GRP_FI0610_Con complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="DT_GRP_FI0610_Con">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Header" type="{http://grpeccfi.esp.com/k2pkbb}DT_ReqHeader"/>
 *         &lt;element name="Body">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="IT_HEADER" maxOccurs="unbounded" minOccurs="0">
 *                     &lt;complexType>
 *                       &lt;complexContent>
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                           &lt;sequence>
 *                             &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="BUKRS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="BLDAT" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="BUDAT" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="BLART" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="WAERS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="KURSF" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="XBLNR" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="BKTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="ZZ_CNAME" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="XREF1_HD" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="XREF2_HD" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="ZZ_TAXINV_TYPE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="ZZ_TAXINV_MAIL" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                           &lt;/sequence>
 *                         &lt;/restriction>
 *                       &lt;/complexContent>
 *                     &lt;/complexType>
 *                   &lt;/element>
 *                   &lt;element name="IT_AP_LINE" maxOccurs="unbounded" minOccurs="0">
 *                     &lt;complexType>
 *                       &lt;complexContent>
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                           &lt;sequence>
 *                             &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="SHKZG" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="LIFNR" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="UMSKZ" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="HKONT" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="WRBTR" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="DMBTR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="ZTERM" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="ZFBDT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="ZLSCH" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="BVTYP" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="BUPLA" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="MWSKZ" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="ZUONR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="XREF1" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="XREF2" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="XREF3" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="SGTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                           &lt;/sequence>
 *                         &lt;/restriction>
 *                       &lt;/complexContent>
 *                     &lt;/complexType>
 *                   &lt;/element>
 *                   &lt;element name="IT_GL_LINE" maxOccurs="unbounded" minOccurs="0">
 *                     &lt;complexType>
 *                       &lt;complexContent>
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                           &lt;sequence>
 *                             &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="SHKZG" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="HKONT" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="WRBTR" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="DMBTR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="PRCTR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="KOSTL" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="BUPLA" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="MWSKZ" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="ZUONR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="XREF1" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="XREF2" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="XREF3" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="SGTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                           &lt;/sequence>
 *                         &lt;/restriction>
 *                       &lt;/complexContent>
 *                     &lt;/complexType>
 *                   &lt;/element>
 *                   &lt;element name="IT_TAX_LINE" maxOccurs="unbounded" minOccurs="0">
 *                     &lt;complexType>
 *                       &lt;complexContent>
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                           &lt;sequence>
 *                             &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="SHKZG" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="HKONT" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="WRBTR" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="FWBAS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="BUPLA" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="MWSKZ" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="XREF1" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="XREF2" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="XREF3" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="SGTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
@XmlType(name = "DT_GRP_FI0610_Con", propOrder = {
    "header",
    "body"
})
public class DTGRPFI0610Con {

    @XmlElement(name = "Header", required = true)
    protected DTReqHeader header;
    @XmlElement(name = "Body", required = true)
    protected DTGRPFI0610Con.Body body;

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
     *     {@link DTGRPFI0610Con.Body }
     *     
     */
    public DTGRPFI0610Con.Body getBody() {
        return body;
    }

    /**
     * Sets the value of the body property.
     * 
     * @param value
     *     allowed object is
     *     {@link DTGRPFI0610Con.Body }
     *     
     */
    public void setBody(DTGRPFI0610Con.Body value) {
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
     *         &lt;element name="IT_HEADER" maxOccurs="unbounded" minOccurs="0">
     *           &lt;complexType>
     *             &lt;complexContent>
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *                 &lt;sequence>
     *                   &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="BUKRS" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="BLDAT" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="BUDAT" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="BLART" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="WAERS" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="KURSF" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="XBLNR" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="BKTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="ZZ_CNAME" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="XREF1_HD" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="XREF2_HD" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="ZZ_TAXINV_TYPE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="ZZ_TAXINV_MAIL" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                 &lt;/sequence>
     *               &lt;/restriction>
     *             &lt;/complexContent>
     *           &lt;/complexType>
     *         &lt;/element>
     *         &lt;element name="IT_AP_LINE" maxOccurs="unbounded" minOccurs="0">
     *           &lt;complexType>
     *             &lt;complexContent>
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *                 &lt;sequence>
     *                   &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="SHKZG" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="LIFNR" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="UMSKZ" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="HKONT" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="WRBTR" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="DMBTR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="ZTERM" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="ZFBDT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="ZLSCH" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="BVTYP" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="BUPLA" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="MWSKZ" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="ZUONR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="XREF1" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="XREF2" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="XREF3" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="SGTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                 &lt;/sequence>
     *               &lt;/restriction>
     *             &lt;/complexContent>
     *           &lt;/complexType>
     *         &lt;/element>
     *         &lt;element name="IT_GL_LINE" maxOccurs="unbounded" minOccurs="0">
     *           &lt;complexType>
     *             &lt;complexContent>
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *                 &lt;sequence>
     *                   &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="SHKZG" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="HKONT" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="WRBTR" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="DMBTR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="PRCTR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="KOSTL" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="BUPLA" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="MWSKZ" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="ZUONR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="XREF1" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="XREF2" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="XREF3" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="SGTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                 &lt;/sequence>
     *               &lt;/restriction>
     *             &lt;/complexContent>
     *           &lt;/complexType>
     *         &lt;/element>
     *         &lt;element name="IT_TAX_LINE" maxOccurs="unbounded" minOccurs="0">
     *           &lt;complexType>
     *             &lt;complexContent>
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *                 &lt;sequence>
     *                   &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="SHKZG" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="HKONT" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="WRBTR" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="FWBAS" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="BUPLA" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="MWSKZ" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="XREF1" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="XREF2" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="XREF3" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="SGTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
        "itheader",
        "itapline",
        "itglline",
        "ittaxline"
    })
    public static class Body {

        @XmlElement(name = "IT_HEADER")
        protected List<DTGRPFI0610Con.Body.ITHEADER> itheader;
        @XmlElement(name = "IT_AP_LINE")
        protected List<DTGRPFI0610Con.Body.ITAPLINE> itapline;
        @XmlElement(name = "IT_GL_LINE")
        protected List<DTGRPFI0610Con.Body.ITGLLINE> itglline;
        @XmlElement(name = "IT_TAX_LINE")
        protected List<DTGRPFI0610Con.Body.ITTAXLINE> ittaxline;

        /**
         * Gets the value of the itheader property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the itheader property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getITHEADER().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link DTGRPFI0610Con.Body.ITHEADER }
         * 
         * 
         */
        public List<DTGRPFI0610Con.Body.ITHEADER> getITHEADER() {
            if (itheader == null) {
                itheader = new ArrayList<DTGRPFI0610Con.Body.ITHEADER>();
            }
            return this.itheader;
        }

        /**
         * Gets the value of the itapline property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the itapline property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getITAPLINE().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link DTGRPFI0610Con.Body.ITAPLINE }
         * 
         * 
         */
        public List<DTGRPFI0610Con.Body.ITAPLINE> getITAPLINE() {
            if (itapline == null) {
                itapline = new ArrayList<DTGRPFI0610Con.Body.ITAPLINE>();
            }
            return this.itapline;
        }

        /**
         * Gets the value of the itglline property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the itglline property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getITGLLINE().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link DTGRPFI0610Con.Body.ITGLLINE }
         * 
         * 
         */
        public List<DTGRPFI0610Con.Body.ITGLLINE> getITGLLINE() {
            if (itglline == null) {
                itglline = new ArrayList<DTGRPFI0610Con.Body.ITGLLINE>();
            }
            return this.itglline;
        }

        /**
         * Gets the value of the ittaxline property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the ittaxline property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getITTAXLINE().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link DTGRPFI0610Con.Body.ITTAXLINE }
         * 
         * 
         */
        public List<DTGRPFI0610Con.Body.ITTAXLINE> getITTAXLINE() {
            if (ittaxline == null) {
                ittaxline = new ArrayList<DTGRPFI0610Con.Body.ITTAXLINE>();
            }
            return this.ittaxline;
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
         *         &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="SHKZG" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="LIFNR" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="UMSKZ" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="HKONT" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="WRBTR" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="DMBTR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="ZTERM" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="ZFBDT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="ZLSCH" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="BVTYP" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="BUPLA" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="MWSKZ" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="ZUONR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="XREF1" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="XREF2" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="XREF3" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="SGTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
            "grpcd",
            "shkzg",
            "lifnr",
            "umskz",
            "hkont",
            "wrbtr",
            "dmbtr",
            "zterm",
            "zfbdt",
            "zlsch",
            "bvtyp",
            "bupla",
            "mwskz",
            "zuonr",
            "xref1",
            "xref2",
            "xref3",
            "sgtxt"
        })
        public static class ITAPLINE {

            @XmlElement(name = "GRP_CD", required = true)
            protected String grpcd;
            @XmlElement(name = "SHKZG", required = true)
            protected String shkzg;
            @XmlElement(name = "LIFNR", required = true)
            protected String lifnr;
            @XmlElement(name = "UMSKZ")
            protected String umskz;
            @XmlElement(name = "HKONT", required = true)
            protected String hkont;
            @XmlElement(name = "WRBTR", required = true)
            protected String wrbtr;
            @XmlElement(name = "DMBTR")
            protected String dmbtr;
            @XmlElement(name = "ZTERM")
            protected String zterm;
            @XmlElement(name = "ZFBDT")
            protected String zfbdt;
            @XmlElement(name = "ZLSCH")
            protected String zlsch;
            @XmlElement(name = "BVTYP")
            protected String bvtyp;
            @XmlElement(name = "BUPLA")
            protected String bupla;
            @XmlElement(name = "MWSKZ")
            protected String mwskz;
            @XmlElement(name = "ZUONR")
            protected String zuonr;
            @XmlElement(name = "XREF1")
            protected String xref1;
            @XmlElement(name = "XREF2")
            protected String xref2;
            @XmlElement(name = "XREF3")
            protected String xref3;
            @XmlElement(name = "SGTXT")
            protected String sgtxt;

            /**
             * Gets the value of the grpcd property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getGRPCD() {
                return grpcd;
            }

            /**
             * Sets the value of the grpcd property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setGRPCD(String value) {
                this.grpcd = value;
            }

            /**
             * Gets the value of the shkzg property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getSHKZG() {
                return shkzg;
            }

            /**
             * Sets the value of the shkzg property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setSHKZG(String value) {
                this.shkzg = value;
            }

            /**
             * Gets the value of the lifnr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getLIFNR() {
                return lifnr;
            }

            /**
             * Sets the value of the lifnr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setLIFNR(String value) {
                this.lifnr = value;
            }

            /**
             * Gets the value of the umskz property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getUMSKZ() {
                return umskz;
            }

            /**
             * Sets the value of the umskz property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setUMSKZ(String value) {
                this.umskz = value;
            }

            /**
             * Gets the value of the hkont property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getHKONT() {
                return hkont;
            }

            /**
             * Sets the value of the hkont property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setHKONT(String value) {
                this.hkont = value;
            }

            /**
             * Gets the value of the wrbtr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getWRBTR() {
                return wrbtr;
            }

            /**
             * Sets the value of the wrbtr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setWRBTR(String value) {
                this.wrbtr = value;
            }

            /**
             * Gets the value of the dmbtr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getDMBTR() {
                return dmbtr;
            }

            /**
             * Sets the value of the dmbtr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setDMBTR(String value) {
                this.dmbtr = value;
            }

            /**
             * Gets the value of the zterm property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getZTERM() {
                return zterm;
            }

            /**
             * Sets the value of the zterm property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setZTERM(String value) {
                this.zterm = value;
            }

            /**
             * Gets the value of the zfbdt property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getZFBDT() {
                return zfbdt;
            }

            /**
             * Sets the value of the zfbdt property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setZFBDT(String value) {
                this.zfbdt = value;
            }

            /**
             * Gets the value of the zlsch property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getZLSCH() {
                return zlsch;
            }

            /**
             * Sets the value of the zlsch property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setZLSCH(String value) {
                this.zlsch = value;
            }

            /**
             * Gets the value of the bvtyp property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getBVTYP() {
                return bvtyp;
            }

            /**
             * Sets the value of the bvtyp property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setBVTYP(String value) {
                this.bvtyp = value;
            }

            /**
             * Gets the value of the bupla property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getBUPLA() {
                return bupla;
            }

            /**
             * Sets the value of the bupla property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setBUPLA(String value) {
                this.bupla = value;
            }

            /**
             * Gets the value of the mwskz property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getMWSKZ() {
                return mwskz;
            }

            /**
             * Sets the value of the mwskz property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setMWSKZ(String value) {
                this.mwskz = value;
            }

            /**
             * Gets the value of the zuonr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getZUONR() {
                return zuonr;
            }

            /**
             * Sets the value of the zuonr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setZUONR(String value) {
                this.zuonr = value;
            }

            /**
             * Gets the value of the xref1 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXREF1() {
                return xref1;
            }

            /**
             * Sets the value of the xref1 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXREF1(String value) {
                this.xref1 = value;
            }

            /**
             * Gets the value of the xref2 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXREF2() {
                return xref2;
            }

            /**
             * Sets the value of the xref2 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXREF2(String value) {
                this.xref2 = value;
            }

            /**
             * Gets the value of the xref3 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXREF3() {
                return xref3;
            }

            /**
             * Sets the value of the xref3 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXREF3(String value) {
                this.xref3 = value;
            }

            /**
             * Gets the value of the sgtxt property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getSGTXT() {
                return sgtxt;
            }

            /**
             * Sets the value of the sgtxt property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setSGTXT(String value) {
                this.sgtxt = value;
            }

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
         *         &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="SHKZG" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="HKONT" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="WRBTR" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="DMBTR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="PRCTR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="KOSTL" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="BUPLA" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="MWSKZ" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="ZUONR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="XREF1" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="XREF2" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="XREF3" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="SGTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
            "grpcd",
            "shkzg",
            "hkont",
            "wrbtr",
            "dmbtr",
            "prctr",
            "kostl",
            "bupla",
            "mwskz",
            "zuonr",
            "xref1",
            "xref2",
            "xref3",
            "sgtxt"
        })
        public static class ITGLLINE {

            @XmlElement(name = "GRP_CD", required = true)
            protected String grpcd;
            @XmlElement(name = "SHKZG", required = true)
            protected String shkzg;
            @XmlElement(name = "HKONT", required = true)
            protected String hkont;
            @XmlElement(name = "WRBTR", required = true)
            protected String wrbtr;
            @XmlElement(name = "DMBTR")
            protected String dmbtr;
            @XmlElement(name = "PRCTR")
            protected String prctr;
            @XmlElement(name = "KOSTL")
            protected String kostl;
            @XmlElement(name = "BUPLA")
            protected String bupla;
            @XmlElement(name = "MWSKZ")
            protected String mwskz;
            @XmlElement(name = "ZUONR")
            protected String zuonr;
            @XmlElement(name = "XREF1")
            protected String xref1;
            @XmlElement(name = "XREF2")
            protected String xref2;
            @XmlElement(name = "XREF3")
            protected String xref3;
            @XmlElement(name = "SGTXT")
            protected String sgtxt;

            /**
             * Gets the value of the grpcd property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getGRPCD() {
                return grpcd;
            }

            /**
             * Sets the value of the grpcd property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setGRPCD(String value) {
                this.grpcd = value;
            }

            /**
             * Gets the value of the shkzg property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getSHKZG() {
                return shkzg;
            }

            /**
             * Sets the value of the shkzg property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setSHKZG(String value) {
                this.shkzg = value;
            }

            /**
             * Gets the value of the hkont property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getHKONT() {
                return hkont;
            }

            /**
             * Sets the value of the hkont property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setHKONT(String value) {
                this.hkont = value;
            }

            /**
             * Gets the value of the wrbtr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getWRBTR() {
                return wrbtr;
            }

            /**
             * Sets the value of the wrbtr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setWRBTR(String value) {
                this.wrbtr = value;
            }

            /**
             * Gets the value of the dmbtr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getDMBTR() {
                return dmbtr;
            }

            /**
             * Sets the value of the dmbtr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setDMBTR(String value) {
                this.dmbtr = value;
            }

            /**
             * Gets the value of the prctr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getPRCTR() {
                return prctr;
            }

            /**
             * Sets the value of the prctr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setPRCTR(String value) {
                this.prctr = value;
            }

            /**
             * Gets the value of the kostl property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getKOSTL() {
                return kostl;
            }

            /**
             * Sets the value of the kostl property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setKOSTL(String value) {
                this.kostl = value;
            }

            /**
             * Gets the value of the bupla property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getBUPLA() {
                return bupla;
            }

            /**
             * Sets the value of the bupla property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setBUPLA(String value) {
                this.bupla = value;
            }

            /**
             * Gets the value of the mwskz property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getMWSKZ() {
                return mwskz;
            }

            /**
             * Sets the value of the mwskz property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setMWSKZ(String value) {
                this.mwskz = value;
            }

            /**
             * Gets the value of the zuonr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getZUONR() {
                return zuonr;
            }

            /**
             * Sets the value of the zuonr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setZUONR(String value) {
                this.zuonr = value;
            }

            /**
             * Gets the value of the xref1 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXREF1() {
                return xref1;
            }

            /**
             * Sets the value of the xref1 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXREF1(String value) {
                this.xref1 = value;
            }

            /**
             * Gets the value of the xref2 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXREF2() {
                return xref2;
            }

            /**
             * Sets the value of the xref2 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXREF2(String value) {
                this.xref2 = value;
            }

            /**
             * Gets the value of the xref3 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXREF3() {
                return xref3;
            }

            /**
             * Sets the value of the xref3 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXREF3(String value) {
                this.xref3 = value;
            }

            /**
             * Gets the value of the sgtxt property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getSGTXT() {
                return sgtxt;
            }

            /**
             * Sets the value of the sgtxt property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setSGTXT(String value) {
                this.sgtxt = value;
            }

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
         *         &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="BUKRS" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="BLDAT" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="BUDAT" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="BLART" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="WAERS" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="KURSF" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="XBLNR" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="BKTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="ZZ_CNAME" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="XREF1_HD" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="XREF2_HD" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="ZZ_TAXINV_TYPE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="ZZ_TAXINV_MAIL" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
            "grpcd",
            "bukrs",
            "bldat",
            "budat",
            "blart",
            "waers",
            "kursf",
            "xblnr",
            "bktxt",
            "zzcname",
            "xref1HD",
            "xref2HD",
            "zztaxinvtype",
            "zztaxinvmail"
        })
        public static class ITHEADER {

            @XmlElement(name = "GRP_CD", required = true)
            protected String grpcd;
            @XmlElement(name = "BUKRS", required = true)
            protected String bukrs;
            @XmlElement(name = "BLDAT", required = true)
            protected String bldat;
            @XmlElement(name = "BUDAT", required = true)
            protected String budat;
            @XmlElement(name = "BLART", required = true)
            protected String blart;
            @XmlElement(name = "WAERS", required = true)
            protected String waers;
            @XmlElement(name = "KURSF")
            protected String kursf;
            @XmlElement(name = "XBLNR", required = true)
            protected String xblnr;
            @XmlElement(name = "BKTXT")
            protected String bktxt;
            @XmlElement(name = "ZZ_CNAME")
            protected String zzcname;
            @XmlElement(name = "XREF1_HD")
            protected String xref1HD;
            @XmlElement(name = "XREF2_HD")
            protected String xref2HD;
            @XmlElement(name = "ZZ_TAXINV_TYPE")
            protected String zztaxinvtype;
            @XmlElement(name = "ZZ_TAXINV_MAIL")
            protected String zztaxinvmail;

            /**
             * Gets the value of the grpcd property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getGRPCD() {
                return grpcd;
            }

            /**
             * Sets the value of the grpcd property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setGRPCD(String value) {
                this.grpcd = value;
            }

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
             * Gets the value of the bldat property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getBLDAT() {
                return bldat;
            }

            /**
             * Sets the value of the bldat property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setBLDAT(String value) {
                this.bldat = value;
            }

            /**
             * Gets the value of the budat property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getBUDAT() {
                return budat;
            }

            /**
             * Sets the value of the budat property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setBUDAT(String value) {
                this.budat = value;
            }

            /**
             * Gets the value of the blart property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getBLART() {
                return blart;
            }

            /**
             * Sets the value of the blart property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setBLART(String value) {
                this.blart = value;
            }

            /**
             * Gets the value of the waers property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getWAERS() {
                return waers;
            }

            /**
             * Sets the value of the waers property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setWAERS(String value) {
                this.waers = value;
            }

            /**
             * Gets the value of the kursf property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getKURSF() {
                return kursf;
            }

            /**
             * Sets the value of the kursf property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setKURSF(String value) {
                this.kursf = value;
            }

            /**
             * Gets the value of the xblnr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXBLNR() {
                return xblnr;
            }

            /**
             * Sets the value of the xblnr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXBLNR(String value) {
                this.xblnr = value;
            }

            /**
             * Gets the value of the bktxt property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getBKTXT() {
                return bktxt;
            }

            /**
             * Sets the value of the bktxt property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setBKTXT(String value) {
                this.bktxt = value;
            }

            /**
             * Gets the value of the zzcname property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getZZCNAME() {
                return zzcname;
            }

            /**
             * Sets the value of the zzcname property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setZZCNAME(String value) {
                this.zzcname = value;
            }

            /**
             * Gets the value of the xref1HD property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXREF1HD() {
                return xref1HD;
            }

            /**
             * Sets the value of the xref1HD property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXREF1HD(String value) {
                this.xref1HD = value;
            }

            /**
             * Gets the value of the xref2HD property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXREF2HD() {
                return xref2HD;
            }

            /**
             * Sets the value of the xref2HD property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXREF2HD(String value) {
                this.xref2HD = value;
            }

            /**
             * Gets the value of the zztaxinvtype property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getZZTAXINVTYPE() {
                return zztaxinvtype;
            }

            /**
             * Sets the value of the zztaxinvtype property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setZZTAXINVTYPE(String value) {
                this.zztaxinvtype = value;
            }

            /**
             * Gets the value of the zztaxinvmail property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getZZTAXINVMAIL() {
                return zztaxinvmail;
            }

            /**
             * Sets the value of the zztaxinvmail property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setZZTAXINVMAIL(String value) {
                this.zztaxinvmail = value;
            }

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
         *         &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="SHKZG" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="HKONT" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="WRBTR" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="FWBAS" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="BUPLA" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="MWSKZ" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="XREF1" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="XREF2" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="XREF3" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="SGTXT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
            "grpcd",
            "shkzg",
            "hkont",
            "wrbtr",
            "fwbas",
            "bupla",
            "mwskz",
            "xref1",
            "xref2",
            "xref3",
            "sgtxt"
        })
        public static class ITTAXLINE {

            @XmlElement(name = "GRP_CD", required = true)
            protected String grpcd;
            @XmlElement(name = "SHKZG", required = true)
            protected String shkzg;
            @XmlElement(name = "HKONT", required = true)
            protected String hkont;
            @XmlElement(name = "WRBTR", required = true)
            protected String wrbtr;
            @XmlElement(name = "FWBAS", required = true)
            protected String fwbas;
            @XmlElement(name = "BUPLA", required = true)
            protected String bupla;
            @XmlElement(name = "MWSKZ", required = true)
            protected String mwskz;
            @XmlElement(name = "XREF1")
            protected String xref1;
            @XmlElement(name = "XREF2")
            protected String xref2;
            @XmlElement(name = "XREF3")
            protected String xref3;
            @XmlElement(name = "SGTXT")
            protected String sgtxt;

            /**
             * Gets the value of the grpcd property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getGRPCD() {
                return grpcd;
            }

            /**
             * Sets the value of the grpcd property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setGRPCD(String value) {
                this.grpcd = value;
            }

            /**
             * Gets the value of the shkzg property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getSHKZG() {
                return shkzg;
            }

            /**
             * Sets the value of the shkzg property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setSHKZG(String value) {
                this.shkzg = value;
            }

            /**
             * Gets the value of the hkont property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getHKONT() {
                return hkont;
            }

            /**
             * Sets the value of the hkont property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setHKONT(String value) {
                this.hkont = value;
            }

            /**
             * Gets the value of the wrbtr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getWRBTR() {
                return wrbtr;
            }

            /**
             * Sets the value of the wrbtr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setWRBTR(String value) {
                this.wrbtr = value;
            }

            /**
             * Gets the value of the fwbas property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getFWBAS() {
                return fwbas;
            }

            /**
             * Sets the value of the fwbas property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setFWBAS(String value) {
                this.fwbas = value;
            }

            /**
             * Gets the value of the bupla property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getBUPLA() {
                return bupla;
            }

            /**
             * Sets the value of the bupla property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setBUPLA(String value) {
                this.bupla = value;
            }

            /**
             * Gets the value of the mwskz property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getMWSKZ() {
                return mwskz;
            }

            /**
             * Sets the value of the mwskz property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setMWSKZ(String value) {
                this.mwskz = value;
            }

            /**
             * Gets the value of the xref1 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXREF1() {
                return xref1;
            }

            /**
             * Sets the value of the xref1 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXREF1(String value) {
                this.xref1 = value;
            }

            /**
             * Gets the value of the xref2 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXREF2() {
                return xref2;
            }

            /**
             * Sets the value of the xref2 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXREF2(String value) {
                this.xref2 = value;
            }

            /**
             * Gets the value of the xref3 property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getXREF3() {
                return xref3;
            }

            /**
             * Sets the value of the xref3 property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setXREF3(String value) {
                this.xref3 = value;
            }

            /**
             * Gets the value of the sgtxt property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getSGTXT() {
                return sgtxt;
            }

            /**
             * Sets the value of the sgtxt property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setSGTXT(String value) {
                this.sgtxt = value;
            }

        }

    }

}
