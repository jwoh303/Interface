package com.esp.infipa.k2pkbb;

public class SI_INFIPA0110_SOProxy implements com.esp.infipa.k2pkbb.SI_INFIPA0110_SO {
  private String _endpoint = null;
  private com.esp.infipa.k2pkbb.SI_INFIPA0110_SO sI_INFIPA0110_SO = null;
  
  public SI_INFIPA0110_SOProxy() {
    _initSI_INFIPA0110_SOProxy();
  }
  
  public SI_INFIPA0110_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initSI_INFIPA0110_SOProxy();
  }
  
  private void _initSI_INFIPA0110_SOProxy() {
    try {
      sI_INFIPA0110_SO = (new com.esp.infipa.k2pkbb.SI_INFIPA0110_SOServiceLocator()).getHTTPS_Port();
      if (sI_INFIPA0110_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)sI_INFIPA0110_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)sI_INFIPA0110_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (sI_INFIPA0110_SO != null)
      ((javax.xml.rpc.Stub)sI_INFIPA0110_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.esp.infipa.k2pkbb.SI_INFIPA0110_SO getSI_INFIPA0110_SO() {
    if (sI_INFIPA0110_SO == null)
      _initSI_INFIPA0110_SOProxy();
    return sI_INFIPA0110_SO;
  }
  
  public com.esp.infipa.k2pkbb.DT_INFIPA0110_Con_response SI_INFIPA0110_SO(com.esp.infipa.k2pkbb.DT_INFIPA0110_Con MT_INFIPA0110_Con) throws java.rmi.RemoteException{
    if (sI_INFIPA0110_SO == null)
      _initSI_INFIPA0110_SOProxy();
    return sI_INFIPA0110_SO.SI_INFIPA0110_SO(MT_INFIPA0110_Con);
  }
  
  
}