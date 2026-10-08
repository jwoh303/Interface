/**
 * ApprovalService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.hanwha.neo.branch.ss.approval.axisws;

public interface ApprovalService extends java.rmi.Remote {
    public com.hanwha.neo.branch.ss.approval.vo.DelegatedSignerInfo getOriginUserIDUseUserId(com.hanwha.neo.branch.ss.approval.vo.MisKey miskey, com.hanwha.neo.branch.ss.approval.vo.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, com.hanwha.neo.branch.ss.common.vo.WsException;
    public com.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentList[] getListByUserKeyUseUserId(com.hanwha.neo.branch.ss.approval.vo.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, com.hanwha.neo.branch.ss.common.vo.WsException;
    public java.lang.String submitApprovalUseUserId(com.hanwha.neo.branch.ss.approval.vo.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, com.hanwha.neo.branch.ss.common.vo.WsException;
    public com.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly[] getProcessIdByBulkMisId(com.hanwha.neo.branch.ss.approval.vo.MisKey[] miskey) throws java.rmi.RemoteException, com.hanwha.neo.branch.ss.common.vo.WsException;
    public java.lang.String submitApproval(com.hanwha.neo.branch.ss.approval.vo.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, com.hanwha.neo.branch.ss.common.vo.WsException;
    public com.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentStatus getStatusByMisId(com.hanwha.neo.branch.ss.approval.vo.MisKey miskey) throws java.rmi.RemoteException, com.hanwha.neo.branch.ss.common.vo.WsException;
    public java.lang.String cancelApproval(com.hanwha.neo.branch.ss.approval.vo.CancelApprovalDocument cancelApprovalDocument) throws java.rmi.RemoteException, com.hanwha.neo.branch.ss.common.vo.WsException;
    public com.hanwha.neo.branch.ss.approval.vo.DelegatedSignerInfo getOriginUserID(com.hanwha.neo.branch.ss.approval.vo.MisKey miskey, com.hanwha.neo.branch.ss.approval.vo.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, com.hanwha.neo.branch.ss.common.vo.WsException;
    public com.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentList[] getListByUserKey(com.hanwha.neo.branch.ss.approval.vo.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, com.hanwha.neo.branch.ss.common.vo.WsException;
}
