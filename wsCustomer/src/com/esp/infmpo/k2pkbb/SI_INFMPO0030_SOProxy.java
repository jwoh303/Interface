package com.esp.infmpo.k2pkbb;

public class SI_INFMPO0030_SOProxy implements com.esp.infmpo.k2pkbb.SI_INFMPO0030_SO {
  private String _endpoint = null;
  private com.esp.infmpo.k2pkbb.SI_INFMPO0030_SO sI_INFMPO0030_SO = null;
  
  public SI_INFMPO0030_SOProxy() {
    _initSI_INFMPO0030_SOProxy();
  }
  
  public SI_INFMPO0030_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initSI_INFMPO0030_SOProxy();
  }
  
  private void _initSI_INFMPO0030_SOProxy() {
    try {
      sI_INFMPO0030_SO = (new com.esp.infmpo.k2pkbb.SI_INFMPO0030_SOServiceLocator()).getHTTPS_Port();
      if (sI_INFMPO0030_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)sI_INFMPO0030_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)sI_INFMPO0030_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (sI_INFMPO0030_SO != null)
      ((javax.xml.rpc.Stub)sI_INFMPO0030_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.esp.infmpo.k2pkbb.SI_INFMPO0030_SO getSI_INFMPO0030_SO() {
    if (sI_INFMPO0030_SO == null)
      _initSI_INFMPO0030_SOProxy();
    return sI_INFMPO0030_SO;
  }
  
  public com.esp.infmpo.k2pkbb.DT_INFMPO0030_Con_response SI_INFMPO0030_SO(com.esp.infmpo.k2pkbb.DT_INFMPO0030_Con MT_INFMPO0030_Con) throws java.rmi.RemoteException{
    if (sI_INFMPO0030_SO == null)
      _initSI_INFMPO0030_SOProxy();
    return sI_INFMPO0030_SO.SI_INFMPO0030_SO(MT_INFMPO0030_Con);
  }
  
  
}