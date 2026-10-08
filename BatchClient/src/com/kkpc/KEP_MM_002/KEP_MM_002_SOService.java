/**
 * KEP_MM_002_SOService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.kkpc.KEP_MM_002;

public interface KEP_MM_002_SOService extends javax.xml.rpc.Service {
    public java.lang.String getHTTPS_PortAddress();

    public com.kkpc.KEP_MM_002.KEP_MM_002_SO getHTTPS_Port() throws javax.xml.rpc.ServiceException;

    public com.kkpc.KEP_MM_002.KEP_MM_002_SO getHTTPS_Port(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
    public java.lang.String getHTTP_PortAddress();

    public com.kkpc.KEP_MM_002.KEP_MM_002_SO getHTTP_Port() throws javax.xml.rpc.ServiceException;

    public com.kkpc.KEP_MM_002.KEP_MM_002_SO getHTTP_Port(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
