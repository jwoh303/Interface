/**
 * WSKP003Locator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package hdli.cs.ws.server;

public class WSKP003Locator extends org.apache.axis.client.Service implements WSKP003 {

	private String _mode	= "";
	
    public WSKP003Locator() {
    }
	
    public WSKP003Locator(String mode) {
    	_mode = mode;
    }

    public WSKP003Locator(org.apache.axis.EngineConfiguration config) {
        super(config);
    	_mode = "0";
    }

    public WSKP003Locator(String mode, org.apache.axis.EngineConfiguration config) {
        super(config);
    	_mode = "0";
    }

    public WSKP003Locator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    	_mode = "0";
    }

    public WSKP003Locator(String mode, java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    	_mode = mode;
    }

    // Use to get a proxy class for WSKP003WebServiceImplPort
    private java.lang.String WSKP003WebServiceImplPort_address_dev = "http://211.197.235.132/cs/webService/WSKP003";
    private java.lang.String WSKP003WebServiceImplPort_address_live = "http://211.197.235.132/cs/webService/WSKP003";

    public java.lang.String getWSKP003WebServiceImplPortAddress() {
    	if ("2".equals(_mode)) 
    		return WSKP003WebServiceImplPort_address_live;
    	else 
    		return WSKP003WebServiceImplPort_address_dev;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String WSKP003WebServiceImplPortWSDDServiceName = "WSKP003WebServiceImplPort";

    public java.lang.String getWSKP003WebServiceImplPortWSDDServiceName() {
        return WSKP003WebServiceImplPortWSDDServiceName;
    }

    public void setWSKP003WebServiceImplPortWSDDServiceName(java.lang.String name) {
        WSKP003WebServiceImplPortWSDDServiceName = name;
    }

    public WSKP003WebService getWSKP003WebServiceImplPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
        	String WSKP003WebServiceImplPort_address	= "";
        	if ("2".equals(_mode)) 
        		WSKP003WebServiceImplPort_address	= WSKP003WebServiceImplPort_address_live;
        	else 
        		WSKP003WebServiceImplPort_address	= WSKP003WebServiceImplPort_address_dev;
            endpoint = new java.net.URL(WSKP003WebServiceImplPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getWSKP003WebServiceImplPort(endpoint);
    }

    public WSKP003WebService getWSKP003WebServiceImplPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            WSKP003SoapBindingStub _stub = new WSKP003SoapBindingStub(portAddress, this);
            _stub.setPortName(getWSKP003WebServiceImplPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setWSKP003WebServiceImplPortEndpointAddress(java.lang.String address) {
    	if ("2".equals(_mode)) 
    		WSKP003WebServiceImplPort_address_live = address;
    	else 
    		WSKP003WebServiceImplPort_address_dev = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (WSKP003WebService.class.isAssignableFrom(serviceEndpointInterface)) {

            	String WSKP003WebServiceImplPort_address	= "";
            	if ("2".equals(_mode)) 
            		WSKP003WebServiceImplPort_address	= WSKP003WebServiceImplPort_address_live;
            	else 
            		WSKP003WebServiceImplPort_address	= WSKP003WebServiceImplPort_address_dev;
            	
                WSKP003SoapBindingStub _stub = new WSKP003SoapBindingStub(new java.net.URL(WSKP003WebServiceImplPort_address), this);
                _stub.setPortName(getWSKP003WebServiceImplPortWSDDServiceName());
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
        if ("WSKP003WebServiceImplPort".equals(inputPortName)) {
            return getWSKP003WebServiceImplPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "WSKP003");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "WSKP003WebServiceImplPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("WSKP003WebServiceImplPort".equals(portName)) {
            setWSKP003WebServiceImplPortEndpointAddress(address);
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
