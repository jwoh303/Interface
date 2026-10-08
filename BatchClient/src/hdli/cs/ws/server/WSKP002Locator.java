/**
 * WSKP002Locator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package hdli.cs.ws.server;

public class WSKP002Locator extends org.apache.axis.client.Service implements WSKP002 {

	private String _mode	= "";
	
    public WSKP002Locator() {
    	_mode = "0";
    }
	
    public WSKP002Locator(String mode) {
    	_mode = mode;
    }

    public WSKP002Locator(org.apache.axis.EngineConfiguration config) {
        super(config);
    	_mode = "0";
    }

    public WSKP002Locator(String mode, org.apache.axis.EngineConfiguration config) {
        super(config);
    	_mode = mode;
    }

    public WSKP002Locator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    	_mode = "0";
    }

    public WSKP002Locator(String mode, java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    	_mode = mode;
    }

    // Use to get a proxy class for WSKP002WebServiceImplPort
    // 개발
    private java.lang.String WSKP002WebServiceImplPort_address_dev = "http://211.197.235.132/cs/webService/WSKP002";
//    private java.lang.String WSKP002WebServiceImplPort_address_dev = "https://cs.hanwha-defense.co.kr/cs/webService/WSKP002";
    // 운영
    private java.lang.String WSKP002WebServiceImplPort_address_live = "http://211.197.235.132/cs/webService/WSKP002";
//    private java.lang.String WSKP002WebServiceImplPort_address_live = "https://cs.hanwha-defense.co.kr/cs/webService/WSKP002";

    public java.lang.String getWSKP002WebServiceImplPortAddress() {
    	if ("2".equals(_mode)) 
    		return WSKP002WebServiceImplPort_address_live;
    	else 
    		return WSKP002WebServiceImplPort_address_dev;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String WSKP002WebServiceImplPortWSDDServiceName = "WSKP002WebServiceImplPort";

    public java.lang.String getWSKP002WebServiceImplPortWSDDServiceName() {
        return WSKP002WebServiceImplPortWSDDServiceName;
    }

    public void setWSKP002WebServiceImplPortWSDDServiceName(java.lang.String name) {
        WSKP002WebServiceImplPortWSDDServiceName = name;
    }

    public WSKP002WebService getWSKP002WebServiceImplPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
        	String WSKP002WebServiceImplPort_address	= "";
        	if ("2".equals(_mode)) 
        		WSKP002WebServiceImplPort_address = WSKP002WebServiceImplPort_address_live;
        	else 
        		WSKP002WebServiceImplPort_address = WSKP002WebServiceImplPort_address_dev;
        	
            endpoint = new java.net.URL(WSKP002WebServiceImplPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getWSKP002WebServiceImplPort(endpoint);
    }

    public WSKP002WebService getWSKP002WebServiceImplPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            WSKP002SoapBindingStub _stub = new WSKP002SoapBindingStub(portAddress, this);
            _stub.setPortName(getWSKP002WebServiceImplPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setWSKP002WebServiceImplPortEndpointAddress(java.lang.String address) {
    	if ("2".equals(_mode)) 
    		WSKP002WebServiceImplPort_address_live = address;
    	else 
    		WSKP002WebServiceImplPort_address_dev = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (WSKP002WebService.class.isAssignableFrom(serviceEndpointInterface)) {
            	String WSKP002WebServiceImplPort_address	= "";
            	if ("2".equals(_mode)) 
            		WSKP002WebServiceImplPort_address = WSKP002WebServiceImplPort_address_live;
            	else 
            		WSKP002WebServiceImplPort_address = WSKP002WebServiceImplPort_address_dev;
                WSKP002SoapBindingStub _stub = new WSKP002SoapBindingStub(new java.net.URL(WSKP002WebServiceImplPort_address), this);
                _stub.setPortName(getWSKP002WebServiceImplPortWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("WSKP002WebServiceImplPort".equals(inputPortName)) {
            return getWSKP002WebServiceImplPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "WSKP002");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "WSKP002WebServiceImplPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("WSKP002WebServiceImplPort".equals(portName)) {
            setWSKP002WebServiceImplPortEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
