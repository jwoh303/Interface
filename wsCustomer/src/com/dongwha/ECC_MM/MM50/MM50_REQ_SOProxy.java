package com.dongwha.ECC_MM.MM50;

public class MM50_REQ_SOProxy implements com.dongwha.ECC_MM.MM50.MM50_REQ_SO {
  private String _endpoint = null;
  private com.dongwha.ECC_MM.MM50.MM50_REQ_SO mM50_REQ_SO = null;
  
  public MM50_REQ_SOProxy() {
    _initMM50_REQ_SOProxy();
  }
  
  public MM50_REQ_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initMM50_REQ_SOProxy();
  }
  
  private void _initMM50_REQ_SOProxy() {
    try {
      mM50_REQ_SO = (new com.dongwha.ECC_MM.MM50.MM50_REQ_SOServiceLocator()).getHTTPS_Port();
      if (mM50_REQ_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)mM50_REQ_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)mM50_REQ_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (mM50_REQ_SO != null)
      ((javax.xml.rpc.Stub)mM50_REQ_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.dongwha.ECC_MM.MM50.MM50_REQ_SO getMM50_REQ_SO() {
    if (mM50_REQ_SO == null)
      _initMM50_REQ_SOProxy();
    return mM50_REQ_SO;
  }
  
  public com.dongwha.ECC_MM.MM50.MM50_MRO_RESPROW[] MM50_REQ_SO(com.dongwha.ECC_MM.MM50.MM50_MRO_REQROW[] MM50_MRO_REQ_Msg) throws java.rmi.RemoteException{
    if (mM50_REQ_SO == null)
      _initMM50_REQ_SOProxy();
    return mM50_REQ_SO.MM50_REQ_SO(MM50_MRO_REQ_Msg);
  }
  
  
}