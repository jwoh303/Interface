package com.koreab2b.mro.webservice.kumh;

public class EzRSAEncSoapProxy implements com.koreab2b.mro.webservice.kumh.EzRSAEncSoap {
  private String _endpoint = null;
  private com.koreab2b.mro.webservice.kumh.EzRSAEncSoap ezRSAEncSoap = null;
  
  public EzRSAEncSoapProxy() {
    _initEzRSAEncSoapProxy();
  }
  
  public EzRSAEncSoapProxy(String endpoint) {
    _endpoint = endpoint;
    _initEzRSAEncSoapProxy();
  }
  
  private void _initEzRSAEncSoapProxy() {
    try {
      ezRSAEncSoap = (new com.koreab2b.mro.webservice.kumh.EzRSAEncLocator()).getezRSAEncSoap();
      if (ezRSAEncSoap != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)ezRSAEncSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)ezRSAEncSoap)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (ezRSAEncSoap != null)
      ((javax.xml.rpc.Stub)ezRSAEncSoap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.koreab2b.mro.webservice.kumh.EzRSAEncSoap getEzRSAEncSoap() {
    if (ezRSAEncSoap == null)
      _initEzRSAEncSoapProxy();
    return ezRSAEncSoap;
  }
  
  public java.lang.String decryptString(java.lang.String pOrgStr) throws java.rmi.RemoteException{
    if (ezRSAEncSoap == null)
      _initEzRSAEncSoapProxy();
    return ezRSAEncSoap.decryptString(pOrgStr);
  }
  
  
}