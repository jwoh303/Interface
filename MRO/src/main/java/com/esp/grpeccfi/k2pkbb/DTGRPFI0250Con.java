
package com.esp.grpeccfi.k2pkbb;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for DT_GRP_FI0250_Con complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="DT_GRP_FI0250_Con">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Header" type="{http://grpeccfi.esp.com/k2pkbb}DT_ReqHeader"/>
 *         &lt;element name="Body">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="IT_REVERSE" maxOccurs="unbounded" minOccurs="0">
 *                     &lt;complexType>
 *                       &lt;complexContent>
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                           &lt;sequence>
 *                             &lt;element name="SEQ" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="BUKRS" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="GJAHR" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="BELNR" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="BUDAT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
@XmlType(name = "DT_GRP_FI0250_Con", propOrder = {
    "header",
    "body"
})
public class DTGRPFI0250Con {

    @XmlElement(name = "Header", required = true)
    protected DTReqHeader header;
    @XmlElement(name = "Body", required = true)
    protected DTGRPFI0250Con.Body body;

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
     *     {@link DTGRPFI0250Con.Body }
     *     
     */
    public DTGRPFI0250Con.Body getBody() {
        return body;
    }

    /**
     * Sets the value of the body property.
     * 
     * @param value
     *     allowed object is
     *     {@link DTGRPFI0250Con.Body }
     *     
     */
    public void setBody(DTGRPFI0250Con.Body value) {
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
     *         &lt;element name="IT_REVERSE" maxOccurs="unbounded" minOccurs="0">
     *           &lt;complexType>
     *             &lt;complexContent>
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *                 &lt;sequence>
     *                   &lt;element name="SEQ" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="BUKRS" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="GJAHR" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="BELNR" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="BUDAT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
        "itreverse"
    })
    public static class Body {

        @XmlElement(name = "IT_REVERSE")
        protected List<DTGRPFI0250Con.Body.ITREVERSE> itreverse;

        /**
         * Gets the value of the itreverse property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the itreverse property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getITREVERSE().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link DTGRPFI0250Con.Body.ITREVERSE }
         * 
         * 
         */
        public List<DTGRPFI0250Con.Body.ITREVERSE> getITREVERSE() {
            if (itreverse == null) {
                itreverse = new ArrayList<DTGRPFI0250Con.Body.ITREVERSE>();
            }
            return this.itreverse;
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
         *         &lt;element name="SEQ" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="BUKRS" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="GJAHR" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="BELNR" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="BUDAT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
            "seq",
            "bukrs",
            "gjahr",
            "belnr",
            "budat"
        })
        public static class ITREVERSE {

            @XmlElement(name = "SEQ", required = true)
            protected String seq;
            @XmlElement(name = "BUKRS", required = true)
            protected String bukrs;
            @XmlElement(name = "GJAHR", required = true)
            protected String gjahr;
            @XmlElement(name = "BELNR", required = true)
            protected String belnr;
            @XmlElement(name = "BUDAT")
            protected String budat;

            /**
             * Gets the value of the seq property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getSEQ() {
                return seq;
            }

            /**
             * Sets the value of the seq property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setSEQ(String value) {
                this.seq = value;
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
             * Gets the value of the gjahr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getGJAHR() {
                return gjahr;
            }

            /**
             * Sets the value of the gjahr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setGJAHR(String value) {
                this.gjahr = value;
            }

            /**
             * Gets the value of the belnr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getBELNR() {
                return belnr;
            }

            /**
             * Sets the value of the belnr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setBELNR(String value) {
                this.belnr = value;
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

        }

    }

}
