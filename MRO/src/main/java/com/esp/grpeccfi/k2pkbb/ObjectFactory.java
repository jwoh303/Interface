
package com.esp.grpeccfi.k2pkbb;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.esp.grpeccfi.k2pkbb package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _MTGRPFI0250Con_QNAME = new QName("http://grpeccfi.esp.com/k2pkbb", "MT_GRP_FI0250_Con");
    private final static QName _MTGRPFI0250ConResponse_QNAME = new QName("http://grpeccfi.esp.com/k2pkbb", "MT_GRP_FI0250_Con_response");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.esp.grpeccfi.k2pkbb
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link DTGRPFI0250Con.Body }
     * 
     */
    public DTGRPFI0250Con.Body createDTGRPFI0250ConBody() {
        return new DTGRPFI0250Con.Body();
    }

    /**
     * Create an instance of {@link DTReqHeader }
     * 
     */
    public DTReqHeader createDTReqHeader() {
        return new DTReqHeader();
    }

    /**
     * Create an instance of {@link DTGRPFI0250ConResponse }
     * 
     */
    public DTGRPFI0250ConResponse createDTGRPFI0250ConResponse() {
        return new DTGRPFI0250ConResponse();
    }

    /**
     * Create an instance of {@link DTResHeader }
     * 
     */
    public DTResHeader createDTResHeader() {
        return new DTResHeader();
    }

    /**
     * Create an instance of {@link DTGRPFI0250ConResponse.Body }
     * 
     */
    public DTGRPFI0250ConResponse.Body createDTGRPFI0250ConResponseBody() {
        return new DTGRPFI0250ConResponse.Body();
    }

    /**
     * Create an instance of {@link DTGRPFI0250Con }
     * 
     */
    public DTGRPFI0250Con createDTGRPFI0250Con() {
        return new DTGRPFI0250Con();
    }

    /**
     * Create an instance of {@link DTGRPFI0250ConResponse.Body.ITRESULT }
     * 
     */
    public DTGRPFI0250ConResponse.Body.ITRESULT createDTGRPFI0250ConResponseBodyITRESULT() {
        return new DTGRPFI0250ConResponse.Body.ITRESULT();
    }

    /**
     * Create an instance of {@link DTGRPFI0250Con.Body.ITREVERSE }
     * 
     */
    public DTGRPFI0250Con.Body.ITREVERSE createDTGRPFI0250ConBodyITREVERSE() {
        return new DTGRPFI0250Con.Body.ITREVERSE();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link DTGRPFI0250Con }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://grpeccfi.esp.com/k2pkbb", name = "MT_GRP_FI0250_Con")
    public JAXBElement<DTGRPFI0250Con> createMTGRPFI0250Con(DTGRPFI0250Con value) {
        return new JAXBElement<DTGRPFI0250Con>(_MTGRPFI0250Con_QNAME, DTGRPFI0250Con.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link DTGRPFI0250ConResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://grpeccfi.esp.com/k2pkbb", name = "MT_GRP_FI0250_Con_response")
    public JAXBElement<DTGRPFI0250ConResponse> createMTGRPFI0250ConResponse(DTGRPFI0250ConResponse value) {
        return new JAXBElement<DTGRPFI0250ConResponse>(_MTGRPFI0250ConResponse_QNAME, DTGRPFI0250ConResponse.class, null, value);
    }

}
