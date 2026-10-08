/**
 * ApprovalService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.hanwhaEagle.neo.branch.ss.approval.axisws;

public interface ApprovalService extends java.rmi.Remote {
    public com.hanwhaEagle.neo.branch.ss.approval.vo.DelegatedSignerInfo getOriginUserIDUseUserId(com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey miskey, com.hanwhaEagle.neo.branch.ss.approval.vo.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentList[] getListByUserKeyUseUserId(com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public java.lang.String submitApprovalUseUserId(com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly[] getProcessIdByBulkMisId(com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey[] miskey) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public java.lang.String submitApproval(com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentStatus getStatusByMisId(com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey miskey) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public java.lang.String cancelApproval(com.hanwhaEagle.neo.branch.ss.approval.vo.CancelApprovalDocument cancelApprovalDocument) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.hanwhaEagle.neo.branch.ss.approval.vo.DelegatedSignerInfo getOriginUserID(com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey miskey, com.hanwhaEagle.neo.branch.ss.approval.vo.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentList[] getListByUserKey(com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException;
}
