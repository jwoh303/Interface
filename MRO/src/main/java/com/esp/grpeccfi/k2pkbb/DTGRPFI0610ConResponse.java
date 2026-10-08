
package com.esp.grpeccfi.k2pkbb;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for DT_GRP_FI0610_Con_response complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="DT_GRP_FI0610_Con_response">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Header" type="{http://grpeccfi.esp.com/k2pkbb}DT_ResHeader"/>
 *         &lt;element name="Body">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="IT_RESULT" maxOccurs="unbounded" minOccurs="0">
 *                     &lt;complexType>
 *                       &lt;complexContent>
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                           &lt;sequence>
 *                             &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="O_BUKRS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="O_BELNR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="O_GJAHR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                             &lt;element name="O_MSG" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
@XmlType(name = "DT_GRP_FI0610_Con_response", propOrder = {
    "header",
    "body"
})
public class DTGRPFI0610ConResponse {

    @XmlElement(name = "Header", required = true)
    protected DTResHeader header;
    @XmlElement(name = "Body", required = true)
    protected DTGRPFI0610ConResponse.Body body;

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
     *     {@link DTGRPFI0610ConResponse.Body }
     *     
     */
    public DTGRPFI0610ConResponse.Body getBody() {
        return body;
    }

    /**
     * Sets the value of the body property.
     * 
     * @param value
     *     allowed object is
     *     {@link DTGRPFI0610ConResponse.Body }
     *     
     */
    public void setBody(DTGRPFI0610ConResponse.Body value) {
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
     *         &lt;element name="IT_RESULT" maxOccurs="unbounded" minOccurs="0">
     *           &lt;complexType>
     *             &lt;complexContent>
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *                 &lt;sequence>
     *                   &lt;element name="GRP_CD" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="O_BUKRS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="O_BELNR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="O_GJAHR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *                   &lt;element name="O_MSG" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
        "itresult"
    })
    public static class Body {

        @XmlElement(name = "IT_RESULT")
        protected List<DTGRPFI0610ConResponse.Body.ITRESULT> itresult;

        /**
         * Gets the value of the itresult property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the itresult property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getITRESULT().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link DTGRPFI0610ConResponse.Body.ITRESULT }
         * 
         * 
         */
        public List<DTGRPFI0610ConResponse.Body.ITRESULT> getITRESULT() {
            if (itresult == null) {
                itresult = new ArrayList<DTGRPFI0610ConResponse.Body.ITRESULT>();
            }
            return this.itresult;
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
         *         &lt;element name="O_BUKRS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="O_BELNR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="O_GJAHR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
         *         &lt;element name="O_MSG" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
            "obukrs",
            "obelnr",
            "ogjahr",
            "omsg"
        })
        public static class ITRESULT {

            @XmlElement(name = "GRP_CD", required = true)
            protected String grpcd;
            @XmlElement(name = "O_BUKRS")
            protected String obukrs;
            @XmlElement(name = "O_BELNR")
            protected String obelnr;
            @XmlElement(name = "O_GJAHR")
            protected String ogjahr;
            @XmlElement(name = "O_MSG")
            protected String omsg;

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
             * Gets the value of the obukrs property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getOBUKRS() {
                return obukrs;
            }

            /**
             * Sets the value of the obukrs property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setOBUKRS(String value) {
                this.obukrs = value;
            }

            /**
             * Gets the value of the obelnr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getOBELNR() {
                return obelnr;
            }

            /**
             * Sets the value of the obelnr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setOBELNR(String value) {
                this.obelnr = value;
            }

            /**
             * Gets the value of the ogjahr property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getOGJAHR() {
                return ogjahr;
            }

            /**
             * Sets the value of the ogjahr property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setOGJAHR(String value) {
                this.ogjahr = value;
            }

            /**
             * Gets the value of the omsg property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getOMSG() {
                return omsg;
            }

            /**
             * Sets the value of the omsg property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setOMSG(String value) {
                this.omsg = value;
            }

        }

    }

}
