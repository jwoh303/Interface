
package com.esp.grpeccfi.k2pkbb;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for DT_ReqHeader complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="DT_ReqHeader">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="zInterfaceId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="zConSysId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="zProSysId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="zUserId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="zPiUser" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="zTimeId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "DT_ReqHeader", propOrder = {
    "zInterfaceId",
    "zConSysId",
    "zProSysId",
    "zUserId",
    "zPiUser",
    "zTimeId"
})
public class DTReqHeader {

    @XmlElement(required = true)
    protected String zInterfaceId;
    @XmlElement(required = true)
    protected String zConSysId;
    @XmlElement(required = true)
    protected String zProSysId;
    @XmlElement(required = true)
    protected String zUserId;
    @XmlElement(required = true)
    protected String zPiUser;
    @XmlElement(required = true)
    protected String zTimeId;

    /**
     * Gets the value of the zInterfaceId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getZInterfaceId() {
        return zInterfaceId;
    }

    /**
     * Sets the value of the zInterfaceId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setZInterfaceId(String value) {
        this.zInterfaceId = value;
    }

    /**
     * Gets the value of the zConSysId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getZConSysId() {
        return zConSysId;
    }

    /**
     * Sets the value of the zConSysId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setZConSysId(String value) {
        this.zConSysId = value;
    }

    /**
     * Gets the value of the zProSysId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getZProSysId() {
        return zProSysId;
    }

    /**
     * Sets the value of the zProSysId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setZProSysId(String value) {
        this.zProSysId = value;
    }

    /**
     * Gets the value of the zUserId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getZUserId() {
        return zUserId;
    }

    /**
     * Sets the value of the zUserId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setZUserId(String value) {
        this.zUserId = value;
    }

    /**
     * Gets the value of the zPiUser property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getZPiUser() {
        return zPiUser;
    }

    /**
     * Sets the value of the zPiUser property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setZPiUser(String value) {
        this.zPiUser = value;
    }

    /**
     * Gets the value of the zTimeId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getZTimeId() {
        return zTimeId;
    }

    /**
     * Sets the value of the zTimeId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setZTimeId(String value) {
        this.zTimeId = value;
    }

}
