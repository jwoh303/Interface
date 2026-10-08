/**
 * WSKP001Locator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.hwdefense;

@SuppressWarnings("serial")
public class WSKP001Locator extends org.apache.axis.client.Service implements WSKP001 {
	
	private String _mode	= "";

    public WSKP001Locator() {
    	_mode = "0";
    }
    public WSKP001Locator(String mode) {
    	_mode = mode;
    }

    public WSKP001Locator(org.apache.axis.EngineConfiguration config) {
        super(config);
    	_mode = "0";
    }

    public WSKP001Locator(String mode, org.apache.axis.EngineConfiguration config) {
        super(config);
    	_mode = mode;
    }

    public WSKP001Locator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    	_mode = "0";
    }

    public WSKP001Locator(String mode, java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    	_mode = mode;
    }

    // Use to get a proxy class for WSKP001WebServiceImplPort
    private java.lang.String WSKP001WebServiceImplPort_address_dev = "http://211.197.235.132_DEV/cs/webService/WSKP001";
    private java.lang.String WSKP001WebServiceImplPort_address_live = "http://211.197.235.132/cs/webService/WSKP001";

    public java.lang.String getWSKP001WebServiceImplPortAddress() {
    	if ("2".equals(_mode)) 
    		return WSKP001WebServiceImplPort_address_live;
    	else 
    		return WSKP001WebServiceImplPort_address_dev;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String WSKP001WebServiceImplPortWSDDServiceName = "WSKP001WebServiceImplPort";

    public java.lang.String getWSKP001WebServiceImplPortWSDDServiceName() {
        return WSKP001WebServiceImplPortWSDDServiceName;
    }

    public void setWSKP001WebServiceImplPortWSDDServiceName(java.lang.String name) {
        WSKP001WebServiceImplPortWSDDServiceName = name;
    }

    public WSKP001WebService getWSKP001WebServiceImplPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
        	
        	String WSKP001WebServiceImplPort_address	= "";

        	if ("2".equals(_mode)) 
        		WSKP001WebServiceImplPort_address	= WSKP001WebServiceImplPort_address_live;
        	else 
        		WSKP001WebServiceImplPort_address	= WSKP001WebServiceImplPort_address_dev;
        	
            endpoint = new java.net.URL(WSKP001WebServiceImplPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getWSKP001WebServiceImplPort(endpoint);
    }

    public WSKP001WebService getWSKP001WebServiceImplPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            WSKP001SoapBindingStub _stub = new WSKP001SoapBindingStub(portAddress, this);
            _stub.setPortName(getWSKP001WebServiceImplPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setWSKP001WebServiceImplPortEndpointAddress(java.lang.String address) {
    	if ("2".equals(_mode)) 
    		WSKP001WebServiceImplPort_address_live = address;
    	else 
    		WSKP001WebServiceImplPort_address_dev = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (WSKP001WebService.class.isAssignableFrom(serviceEndpointInterface)) {
            	
            	String WSKP001WebServiceImplPort_address	= "";

            	if ("2".equals(_mode)) 
            		WSKP001WebServiceImplPort_address	= WSKP001WebServiceImplPort_address_live;
            	else 
            		WSKP001WebServiceImplPort_address	= WSKP001WebServiceImplPort_address_dev;
            	
                WSKP001SoapBindingStub _stub = new WSKP001SoapBindingStub(new java.net.URL(WSKP001WebServiceImplPort_address), this);
                _stub.setPortName(getWSKP001WebServiceImplPortWSDDServiceName());
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
        if ("WSKP001WebServiceImplPort".equals(inputPortName)) {
            return getWSKP001WebServiceImplPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "WSKP001");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://server.ws.cs.hdli/", "WSKP001WebServiceImplPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("WSKP001WebServiceImplPort".equals(portName)) {
            setWSKP001WebServiceImplPortEndpointAddress(address);
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
