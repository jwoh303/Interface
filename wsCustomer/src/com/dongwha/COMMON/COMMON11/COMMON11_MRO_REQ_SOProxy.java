package com.dongwha.COMMON.COMMON11;

public class COMMON11_MRO_REQ_SOProxy implements com.dongwha.COMMON.COMMON11.COMMON11_MRO_REQ_SO {
  private String _endpoint = null;
  private com.dongwha.COMMON.COMMON11.COMMON11_MRO_REQ_SO cOMMON11_MRO_REQ_SO = null;
  
  public COMMON11_MRO_REQ_SOProxy() {
    _initCOMMON11_MRO_REQ_SOProxy();
  }
  
  public COMMON11_MRO_REQ_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initCOMMON11_MRO_REQ_SOProxy();
  }
  
  private void _initCOMMON11_MRO_REQ_SOProxy() {
    try {
      cOMMON11_MRO_REQ_SO = (new com.dongwha.COMMON.COMMON11.COMMON11_MRO_REQ_SOServiceLocator()).getHTTPS_Port();
      if (cOMMON11_MRO_REQ_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)cOMMON11_MRO_REQ_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)cOMMON11_MRO_REQ_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (cOMMON11_MRO_REQ_SO != null)
      ((javax.xml.rpc.Stub)cOMMON11_MRO_REQ_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.dongwha.COMMON.COMMON11.COMMON11_MRO_REQ_SO getCOMMON11_MRO_REQ_SO() {
    if (cOMMON11_MRO_REQ_SO == null)
      _initCOMMON11_MRO_REQ_SOProxy();
    return cOMMON11_MRO_REQ_SO;
  }
  
  public com.dongwha.COMMON.COMMON11.COMMON11_MRO_RESP COMMON11_MRO_REQ_SO(com.dongwha.COMMON.COMMON11.COMMON11_MRO_REQ COMMON11_MRO_REQ_Msg) throws java.rmi.RemoteException{
    if (cOMMON11_MRO_REQ_SO == null)
      _initCOMMON11_MRO_REQ_SOProxy();
    return cOMMON11_MRO_REQ_SO.COMMON11_MRO_REQ_SO(COMMON11_MRO_REQ_Msg);
  }
  
  
}