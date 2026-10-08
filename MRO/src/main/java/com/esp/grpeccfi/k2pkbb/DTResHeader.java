
package com.esp.grpeccfi.k2pkbb;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for DT_ResHeader complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="DT_ResHeader">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="zResultCd" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="zResultMsg" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "DT_ResHeader", propOrder = {
    "zResultCd",
    "zResultMsg"
})
public class DTResHeader {

    @XmlElement(required = true)
    protected String zResultCd;
    @XmlElement(required = true)
    protected String zResultMsg;

    /**
     * Gets the value of the zResultCd property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getZResultCd() {
        return zResultCd;
    }

    /**
     * Sets the value of the zResultCd property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setZResultCd(String value) {
        this.zResultCd = value;
    }

    /**
     * Gets the value of the zResultMsg property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getZResultMsg() {
        return zResultMsg;
    }

    /**
     * Sets the value of the zResultMsg property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setZResultMsg(String value) {
        this.zResultMsg = value;
    }

}
