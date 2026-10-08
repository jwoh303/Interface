/**
 * ApprovalService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.hanwhaCleverse.neo.branch.ss.approval.axisws;

public interface ApprovalService extends java.rmi.Remote {
    public com.hanwhaCleverse.neo.branch.ss.approval.vo.DelegatedSignerInfo getOriginUserIDUseUserId(com.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey miskey, com.hanwhaCleverse.neo.branch.ss.approval.vo.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, com.hanwhaCleverse.neo.branch.ss.common.vo.WsException;
    public com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocumentList[] getListByUserKeyUseUserId(com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, com.hanwhaCleverse.neo.branch.ss.common.vo.WsException;
    public java.lang.String submitApprovalUseUserId(com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, com.hanwhaCleverse.neo.branch.ss.common.vo.WsException;
    public com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly[] getProcessIdByBulkMisId(com.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey[] miskey) throws java.rmi.RemoteException, com.hanwhaCleverse.neo.branch.ss.common.vo.WsException;
    public java.lang.String submitApproval(com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, com.hanwhaCleverse.neo.branch.ss.common.vo.WsException;
    public com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocumentStatus getStatusByMisId(com.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey miskey) throws java.rmi.RemoteException, com.hanwhaCleverse.neo.branch.ss.common.vo.WsException;
    public java.lang.String cancelApproval(com.hanwhaCleverse.neo.branch.ss.approval.vo.CancelApprovalDocument cancelApprovalDocument) throws java.rmi.RemoteException, com.hanwhaCleverse.neo.branch.ss.common.vo.WsException;
    public com.hanwhaCleverse.neo.branch.ss.approval.vo.DelegatedSignerInfo getOriginUserID(com.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey miskey, com.hanwhaCleverse.neo.branch.ss.approval.vo.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, com.hanwhaCleverse.neo.branch.ss.common.vo.WsException;
    public com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocumentList[] getListByUserKey(com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, com.hanwhaCleverse.neo.branch.ss.common.vo.WsException;
}
