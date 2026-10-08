package com.hanwhaEagle.neo.branch.ss.approval.axisws;

public class ApprovalServiceProxy implements com.hanwhaEagle.neo.branch.ss.approval.axisws.ApprovalService {
  private String _endpoint = null;
  private com.hanwhaEagle.neo.branch.ss.approval.axisws.ApprovalService approvalService = null;
  private String _mode	= "0";	// 2:운영, 0:개발
  
  public ApprovalServiceProxy() {
    _initApprovalServiceProxy();
  }
  
  public ApprovalServiceProxy(String mode) {
	   _mode = mode;  
	    _initApprovalServiceProxy();
	  }
 public ApprovalServiceProxy(String mode, String endpoint) {
	  _mode = mode;  
     _endpoint = endpoint;
     _initApprovalServiceProxy();
 }
  
  private void _initApprovalServiceProxy() {
    try {
      approvalService = (new com.hanwhaEagle.neo.branch.ss.approval.axisws.ApprovalServiceServiceLocator(_mode)).getApprovalService();
      if (approvalService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)approvalService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)approvalService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (approvalService != null)
      ((javax.xml.rpc.Stub)approvalService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.hanwhaEagle.neo.branch.ss.approval.axisws.ApprovalService getApprovalService() {
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService;
  }
  
  public com.hanwhaEagle.neo.branch.ss.approval.vo.DelegatedSignerInfo getOriginUserIDUseUserId(com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey miskey, com.hanwhaEagle.neo.branch.ss.approval.vo.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getOriginUserIDUseUserId(miskey, delegatedSignerInfo);
  }
  
  public com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentList[] getListByUserKeyUseUserId(com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getListByUserKeyUseUserId(approvalUserKey);
  }
  
  public java.lang.String submitApprovalUseUserId(com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.submitApprovalUseUserId(approvalDocument);
  }
  
  public com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly[] getProcessIdByBulkMisId(com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey[] miskey) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getProcessIdByBulkMisId(miskey);
  }
  
  public java.lang.String submitApproval(com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocument approvalDocument) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.submitApproval(approvalDocument);
  }
  
  public com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentStatus getStatusByMisId(com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey miskey) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getStatusByMisId(miskey);
  }
  
  public java.lang.String cancelApproval(com.hanwhaEagle.neo.branch.ss.approval.vo.CancelApprovalDocument cancelApprovalDocument) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.cancelApproval(cancelApprovalDocument);
  }
  
  public com.hanwhaEagle.neo.branch.ss.approval.vo.DelegatedSignerInfo getOriginUserID(com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey miskey, com.hanwhaEagle.neo.branch.ss.approval.vo.DelegatedSignerInfo delegatedSignerInfo) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getOriginUserID(miskey, delegatedSignerInfo);
  }
  
  public com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentList[] getListByUserKey(com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalUserKey approvalUserKey) throws java.rmi.RemoteException, com.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (approvalService == null)
      _initApprovalServiceProxy();
    return approvalService.getListByUserKey(approvalUserKey);
  }
  
  
}