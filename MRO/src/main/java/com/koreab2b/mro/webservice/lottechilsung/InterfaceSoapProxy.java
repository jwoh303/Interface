package com.koreab2b.mro.webservice.lottechilsung;

public class InterfaceSoapProxy implements com.koreab2b.mro.webservice.lottechilsung.InterfaceSoap {
  private String _endpoint = null;
  private com.koreab2b.mro.webservice.lottechilsung.InterfaceSoap interfaceSoap = null;
  
  public InterfaceSoapProxy() {
    _initInterfaceSoapProxy();
  }
  
  public InterfaceSoapProxy(String endpoint) {
    _endpoint = endpoint;
    _initInterfaceSoapProxy();
  }
  
  private void _initInterfaceSoapProxy() {
    try {
      interfaceSoap = (new com.koreab2b.mro.webservice.lottechilsung._interfaceLocator()).getInterfaceSoap();
      if (interfaceSoap != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)interfaceSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)interfaceSoap)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (interfaceSoap != null)
      ((javax.xml.rpc.Stub)interfaceSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.koreab2b.mro.webservice.lottechilsung.InterfaceSoap getInterfaceSoap() {
    if (interfaceSoap == null)
      _initInterfaceSoapProxy();
    return interfaceSoap;
  }
  
  public java.lang.String requestDraft(java.lang.String domain_code, java.lang.String id, java.lang.String systemid, java.lang.String keyvalue, java.lang.String moduleId, java.lang.String formAlias, java.lang.String mode, java.lang.String xmlData) throws java.rmi.RemoteException{
    if (interfaceSoap == null)
      _initInterfaceSoapProxy();
    return interfaceSoap.requestDraft(domain_code, id, systemid, keyvalue, moduleId, formAlias, mode, xmlData);
  }
  
  public java.lang.String requestState(java.lang.String keyValue) throws java.rmi.RemoteException{
    if (interfaceSoap == null)
      _initInterfaceSoapProxy();
    return interfaceSoap.requestState(keyValue);
  }
  
  public java.lang.String requestDelete(java.lang.String domain_code, java.lang.String id, java.lang.String pid) throws java.rmi.RemoteException{
    if (interfaceSoap == null)
      _initInterfaceSoapProxy();
    return interfaceSoap.requestDelete(domain_code, id, pid);
  }
  
  public java.lang.String load(java.lang.String domain_code, java.lang.String id, java.lang.String pid) throws java.rmi.RemoteException{
    if (interfaceSoap == null)
      _initInterfaceSoapProxy();
    return interfaceSoap.load(domain_code, id, pid);
  }
  
  public java.lang.String requestDraftAuto(java.lang.String domain_code, java.lang.String id, java.lang.String systemid, java.lang.String keyvalue, java.lang.String moduleId, java.lang.String formAlias, java.lang.String mode, java.lang.String xmlData) throws java.rmi.RemoteException{
    if (interfaceSoap == null)
      _initInterfaceSoapProxy();
    return interfaceSoap.requestDraftAuto(domain_code, id, systemid, keyvalue, moduleId, formAlias, mode, xmlData);
  }
  
  public java.lang.String requestSlipReversal(java.lang.String domain_code, java.lang.String id, java.lang.String pid) throws java.rmi.RemoteException{
    if (interfaceSoap == null)
      _initInterfaceSoapProxy();
    return interfaceSoap.requestSlipReversal(domain_code, id, pid);
  }
  
  
}