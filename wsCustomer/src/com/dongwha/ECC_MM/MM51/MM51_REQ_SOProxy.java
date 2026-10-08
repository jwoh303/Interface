package com.dongwha.ECC_MM.MM51;

public class MM51_REQ_SOProxy implements com.dongwha.ECC_MM.MM51.MM51_REQ_SO {
  private String _endpoint = null;
  private com.dongwha.ECC_MM.MM51.MM51_REQ_SO mM51_REQ_SO = null;
  
  public MM51_REQ_SOProxy() {
    _initMM51_REQ_SOProxy();
  }
  
  public MM51_REQ_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initMM51_REQ_SOProxy();
  }
  
  private void _initMM51_REQ_SOProxy() {
    try {
      mM51_REQ_SO = (new com.dongwha.ECC_MM.MM51.MM51_REQ_SOServiceLocator()).getHTTPS_Port();
      if (mM51_REQ_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)mM51_REQ_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)mM51_REQ_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (mM51_REQ_SO != null)
      ((javax.xml.rpc.Stub)mM51_REQ_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.dongwha.ECC_MM.MM51.MM51_REQ_SO getMM51_REQ_SO() {
    if (mM51_REQ_SO == null)
      _initMM51_REQ_SOProxy();
    return mM51_REQ_SO;
  }
  
  public com.dongwha.ECC_MM.MM51.MM51_MRO_RESPROW[] MM51_REQ_SO(com.dongwha.ECC_MM.MM51.MM51_MRO_REQROW[] MM51_MRO_REQ_Msg) throws java.rmi.RemoteException{
    if (mM51_REQ_SO == null)
      _initMM51_REQ_SOProxy();
    return mM51_REQ_SO.MM51_REQ_SO(MM51_MRO_REQ_Msg);
  }
  
  
}