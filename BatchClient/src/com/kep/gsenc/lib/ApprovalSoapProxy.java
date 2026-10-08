package com.kep.gsenc.lib;

public class ApprovalSoapProxy implements com.kep.gsenc.lib.ApprovalSoap {
  private String _endpoint = null;
  private com.kep.gsenc.lib.ApprovalSoap approvalSoap = null;
  
  public ApprovalSoapProxy() {
    _initApprovalSoapProxy();
  }
  
  public ApprovalSoapProxy(String endpoint) {
    _endpoint = endpoint;
    _initApprovalSoapProxy();
  }
  
  private void _initApprovalSoapProxy() {
    try {
      approvalSoap = (new com.kep.gsenc.lib.ApprovalLocator()).getApprovalSoap();
      if (approvalSoap != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)approvalSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)approvalSoap)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (approvalSoap != null)
      ((javax.xml.rpc.Stub)approvalSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.kep.gsenc.lib.ApprovalSoap getApprovalSoap() {
    if (approvalSoap == null)
      _initApprovalSoapProxy();
    return approvalSoap;
  }
  
  public java.lang.String approvalSubmit(java.lang.String json) throws java.rmi.RemoteException{
    if (approvalSoap == null)
      _initApprovalSoapProxy();
    return approvalSoap.approvalSubmit(json);
  }
  
  public com.kep.gsenc.lib.TaskOfString approvalSubmitAsyncAwait(java.lang.String json) throws java.rmi.RemoteException{
    if (approvalSoap == null)
      _initApprovalSoapProxy();
    return approvalSoap.approvalSubmitAsyncAwait(json);
  }
  
  
}