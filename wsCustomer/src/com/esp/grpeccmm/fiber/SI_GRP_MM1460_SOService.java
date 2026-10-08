/**
 * SI_GRP_MM1460_SOService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.esp.grpeccmm.fiber;

public interface SI_GRP_MM1460_SOService extends javax.xml.rpc.Service {
    public java.lang.String getHTTPS_PortAddress();

    public com.esp.grpeccmm.fiber.SI_GRP_MM1460_SO getHTTPS_Port() throws javax.xml.rpc.ServiceException;

    public com.esp.grpeccmm.fiber.SI_GRP_MM1460_SO getHTTPS_Port(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
    public java.lang.String getHTTP_PortAddress();

    public com.esp.grpeccmm.fiber.SI_GRP_MM1460_SO getHTTP_Port() throws javax.xml.rpc.ServiceException;

    public com.esp.grpeccmm.fiber.SI_GRP_MM1460_SO getHTTP_Port(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
