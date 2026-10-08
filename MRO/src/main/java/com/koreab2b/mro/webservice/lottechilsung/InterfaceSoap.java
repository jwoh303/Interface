/**
 * InterfaceSoap.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.lottechilsung;

public interface InterfaceSoap extends java.rmi.Remote {

    /**
     * 롯데칠성 연동결재 기안시 호출하는 메소드, return : string → OK(성공)/ERR(에러):성공시
     * URL, 실패시 에러메시지
     */
    public java.lang.String requestDraft(java.lang.String domain_code, java.lang.String id, java.lang.String systemid, java.lang.String keyvalue, java.lang.String moduleId, java.lang.String formAlias, java.lang.String mode, java.lang.String xmlData) throws java.rmi.RemoteException;

    /**
     * 결재상태 요청
     */
    public java.lang.String requestState(java.lang.String keyValue) throws java.rmi.RemoteException;

    /**
     * 결재문서에 대한 삭제요청 S(성공), E(에러)→에러시 에러메시지 보냄
     */
    public java.lang.String requestDelete(java.lang.String domain_code, java.lang.String id, java.lang.String pid) throws java.rmi.RemoteException;
    public java.lang.String load(java.lang.String domain_code, java.lang.String id, java.lang.String pid) throws java.rmi.RemoteException;

    /**
     * 롯데칠성 연동결재 자동기안시 호출하는 메소드, return : string → OK(성공)/ERR(에러):성공시
     * URL, 실패시 에러메시지
     */
    public java.lang.String requestDraftAuto(java.lang.String domain_code, java.lang.String id, java.lang.String systemid, java.lang.String keyvalue, java.lang.String moduleId, java.lang.String formAlias, java.lang.String mode, java.lang.String xmlData) throws java.rmi.RemoteException;

    /**
     * SAP 결재문서에 대한 역분개 요청 S(성공), E(에러)→에러시 에러메시지 보냄
     */
    public java.lang.String requestSlipReversal(java.lang.String domain_code, java.lang.String id, java.lang.String pid) throws java.rmi.RemoteException;
}
