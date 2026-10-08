/**
 * _interfaceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.lottechilsung;

public class _interfaceLocator extends org.apache.axis.client.Service implements com.koreab2b.mro.webservice.lottechilsung._interface {

    public _interfaceLocator() {
    }


    public _interfaceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public _interfaceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for InterfaceSoap
    private java.lang.String InterfaceSoap_address = "http://portal.lottechilsung.co.kr/service/interface.asmx";

    public java.lang.String getInterfaceSoapAddress() {
        return InterfaceSoap_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String InterfaceSoapWSDDServiceName = "InterfaceSoap";

    public java.lang.String getInterfaceSoapWSDDServiceName() {
        return InterfaceSoapWSDDServiceName;
    }

    public void setInterfaceSoapWSDDServiceName(java.lang.String name) {
        InterfaceSoapWSDDServiceName = name;
    }

    public com.koreab2b.mro.webservice.lottechilsung.InterfaceSoap getInterfaceSoap() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(InterfaceSoap_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getInterfaceSoap(endpoint);
    }

    public com.koreab2b.mro.webservice.lottechilsung.InterfaceSoap getInterfaceSoap(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            com.koreab2b.mro.webservice.lottechilsung.InterfaceSoapStub _stub = new com.koreab2b.mro.webservice.lottechilsung.InterfaceSoapStub(portAddress, this);
            _stub.setPortName(getInterfaceSoapWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setInterfaceSoapEndpointAddress(java.lang.String address) {
        InterfaceSoap_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (com.koreab2b.mro.webservice.lottechilsung.InterfaceSoap.class.isAssignableFrom(serviceEndpointInterface)) {
                com.koreab2b.mro.webservice.lottechilsung.InterfaceSoapStub _stub = new com.koreab2b.mro.webservice.lottechilsung.InterfaceSoapStub(new java.net.URL(InterfaceSoap_address), this);
                _stub.setPortName(getInterfaceSoapWSDDServiceName());
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
        if ("InterfaceSoap".equals(inputPortName)) {
            return getInterfaceSoap();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://portal.lottechilsung.co.kr/", "Interface");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://portal.lottechilsung.co.kr/", "InterfaceSoap"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("InterfaceSoap".equals(portName)) {
            setInterfaceSoapEndpointAddress(address);
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
