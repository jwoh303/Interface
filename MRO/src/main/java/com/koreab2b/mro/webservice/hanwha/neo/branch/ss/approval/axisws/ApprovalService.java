/**
 * ApprovalService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.axisws;

public interface ApprovalService extends java.rmi.Remote {
    public com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.DelegatedSignerInfo getOriginUserIDUseUserId(com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.MisKey miskey, com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwha.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentList[] getListByUserKeyUseUserId(com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwha.neo.branch.ss.common.vo.WsException;
    public java.lang.String submitApprovalUseUserId(com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwha.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly[] getProcessIdByBulkMisId(com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.MisKey[] miskey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwha.neo.branch.ss.common.vo.WsException;
    public java.lang.String submitApproval(com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwha.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentStatus getStatusByMisId(com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.MisKey miskey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwha.neo.branch.ss.common.vo.WsException;
    public java.lang.String cancelApproval(com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.CancelApprovalDocument cancelApprovalDocument) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwha.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.DelegatedSignerInfo getOriginUserID(com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.MisKey miskey, com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwha.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentList[] getListByUserKey(com.koreab2b.mro.webservice.hanwha.neo.branch.ss.approval.vo.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwha.neo.branch.ss.common.vo.WsException;
}
