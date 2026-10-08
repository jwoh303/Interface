/**
 * ApprovalSoap.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.kep.gsenc.lib;

public interface ApprovalSoap extends java.rmi.Remote {

    /**
     * 실질 적으로 Legacy에서 상신 요청 들어오는 부분
     */
    public java.lang.String approvalSubmit(java.lang.String json) throws java.rmi.RemoteException;

    /**
     * 실질 적으로 Legacy에서 상신 요청 들어오는 부분 : 비동기로 Worker Thread
     */
    public com.kep.gsenc.lib.TaskOfString approvalSubmitAsyncAwait(java.lang.String json) throws java.rmi.RemoteException;
}
