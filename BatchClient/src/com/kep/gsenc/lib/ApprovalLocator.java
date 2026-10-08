/**
 * ApprovalLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.kep.gsenc.lib;

public class ApprovalLocator extends org.apache.axis.client.Service implements com.kep.gsenc.lib.Approval {

    public ApprovalLocator() {
    }


    public ApprovalLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public ApprovalLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for ApprovalSoap
    private java.lang.String ApprovalSoap_address = "http://localhost:56665/RealEA.API/WS/Approval.asmx";

    public java.lang.String getApprovalSoapAddress() {
        return ApprovalSoap_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String ApprovalSoapWSDDServiceName = "ApprovalSoap";

    public java.lang.String getApprovalSoapWSDDServiceName() {
        return ApprovalSoapWSDDServiceName;
    }

    public void setApprovalSoapWSDDServiceName(java.lang.String name) {
        ApprovalSoapWSDDServiceName = name;
    }

    public com.kep.gsenc.lib.ApprovalSoap getApprovalSoap() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(ApprovalSoap_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getApprovalSoap(endpoint);
    }

    public com.kep.gsenc.lib.ApprovalSoap getApprovalSoap(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            com.kep.gsenc.lib.ApprovalSoapStub _stub = new com.kep.gsenc.lib.ApprovalSoapStub(portAddress, this);
            _stub.setPortName(getApprovalSoapWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setApprovalSoapEndpointAddress(java.lang.String address) {
        ApprovalSoap_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (com.kep.gsenc.lib.ApprovalSoap.class.isAssignableFrom(serviceEndpointInterface)) {
                com.kep.gsenc.lib.ApprovalSoapStub _stub = new com.kep.gsenc.lib.ApprovalSoapStub(new java.net.URL(ApprovalSoap_address), this);
                _stub.setPortName(getApprovalSoapWSDDServiceName());
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
        if ("ApprovalSoap".equals(inputPortName)) {
            return getApprovalSoap();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://www.realweb21.com/", "Approval");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://www.realweb21.com/", "ApprovalSoap"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("ApprovalSoap".equals(portName)) {
            setApprovalSoapEndpointAddress(address);
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
