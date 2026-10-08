/**
 * M2KEP0002M2016ServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.stw.kep.ws.service.M2KEP0002M2016;

public class M2KEP0002M2016ServiceLocator extends org.apache.axis.client.Service implements com.stw.kep.ws.service.M2KEP0002M2016.M2KEP0002M2016Service {

	private String _mode	= "0";	// 2:운영, 0:개발
    public M2KEP0002M2016ServiceLocator() {
    	_mode = "0";
    }
    
    public M2KEP0002M2016ServiceLocator(String mode) {
    	_mode = mode;
    }


    public M2KEP0002M2016ServiceLocator(String mode, org.apache.axis.EngineConfiguration config) {
        super(config);
    	_mode = mode;
    }

    public M2KEP0002M2016ServiceLocator(String mode, java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    	_mode = mode;
    }

    // Use to get a proxy class for M2KEP0002M2016Port
    private java.lang.String M2KEP0002M2016Port_address_live = "http://mro.hanwhaaerospace.co.kr:8607/kepif/jaxws-services/M2_KEP_0002_M2016";
    private java.lang.String M2KEP0002M2016Port_address_dev  = "http://mro.hanwhaaerospace.co.kr:8607/kepif/jaxws-services/M2_KEP_0002_M2016";

    public java.lang.String getM2KEP0002M2016PortAddress() {
    	if ("2".equals(_mode))
    		return M2KEP0002M2016Port_address_live;
    	else 
    		return M2KEP0002M2016Port_address_dev;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String M2KEP0002M2016PortWSDDServiceName = "M2KEP0002M2016Port";

    public java.lang.String getM2KEP0002M2016PortWSDDServiceName() {
        return M2KEP0002M2016PortWSDDServiceName;
    }

    public void setM2KEP0002M2016PortWSDDServiceName(java.lang.String name) {
        M2KEP0002M2016PortWSDDServiceName = name;
    }

    public com.stw.kep.ws.service.M2KEP0002M2016.M2KEP0002M2016 getM2KEP0002M2016Port() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
        	String M2KEP0002M2016Port_address	= "";
        	if ("2".equals(_mode)) 
        		M2KEP0002M2016Port_address = M2KEP0002M2016Port_address_live;
        	else 
        		M2KEP0002M2016Port_address = M2KEP0002M2016Port_address_dev;
            endpoint = new java.net.URL(M2KEP0002M2016Port_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getM2KEP0002M2016Port(endpoint);
    }

    public com.stw.kep.ws.service.M2KEP0002M2016.M2KEP0002M2016 getM2KEP0002M2016Port(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            com.stw.kep.ws.service.M2KEP0002M2016.M2KEP0002M2016ServiceSoapBindingStub _stub = new com.stw.kep.ws.service.M2KEP0002M2016.M2KEP0002M2016ServiceSoapBindingStub(portAddress, this);
            _stub.setPortName(getM2KEP0002M2016PortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setM2KEP0002M2016PortEndpointAddress(java.lang.String address) {
    	if ("2".equals(_mode))
    		M2KEP0002M2016Port_address_live = address;
    	else 
    		M2KEP0002M2016Port_address_dev  = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (com.stw.kep.ws.service.M2KEP0002M2016.M2KEP0002M2016.class.isAssignableFrom(serviceEndpointInterface)) {
            	String M2KEP0002M2016Port_address	= "";
            	if ("2".equals(_mode)) 
            		M2KEP0002M2016Port_address	= M2KEP0002M2016Port_address_live;
            	else 
            		M2KEP0002M2016Port_address	= M2KEP0002M2016Port_address_dev;
                com.stw.kep.ws.service.M2KEP0002M2016.M2KEP0002M2016ServiceSoapBindingStub _stub = new com.stw.kep.ws.service.M2KEP0002M2016.M2KEP0002M2016ServiceSoapBindingStub(new java.net.URL(M2KEP0002M2016Port_address), this);
                _stub.setPortName(getM2KEP0002M2016PortWSDDServiceName());
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
        if ("M2KEP0002M2016Port".equals(inputPortName)) {
            return getM2KEP0002M2016Port();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://M2KEP0002M2016.service.ws.kep.stw.com/", "M2KEP0002M2016Service");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://M2KEP0002M2016.service.ws.kep.stw.com/", "M2KEP0002M2016Port"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("M2KEP0002M2016Port".equals(portName)) {
            setM2KEP0002M2016PortEndpointAddress(address);
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
