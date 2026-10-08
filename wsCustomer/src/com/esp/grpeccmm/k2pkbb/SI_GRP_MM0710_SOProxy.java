package com.esp.grpeccmm.k2pkbb;

public class SI_GRP_MM0710_SOProxy implements com.esp.grpeccmm.k2pkbb.SI_GRP_MM0710_SO {
  private String _endpoint = null;
  private com.esp.grpeccmm.k2pkbb.SI_GRP_MM0710_SO sI_GRP_MM0710_SO = null;
  
  public SI_GRP_MM0710_SOProxy() {
    _initSI_GRP_MM0710_SOProxy();
  }
  
  public SI_GRP_MM0710_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initSI_GRP_MM0710_SOProxy();
  }
  
  private void _initSI_GRP_MM0710_SOProxy() {
    try {
      sI_GRP_MM0710_SO = (new com.esp.grpeccmm.k2pkbb.SI_GRP_MM0710_SOServiceLocator()).getHTTPS_Port();
      if (sI_GRP_MM0710_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)sI_GRP_MM0710_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)sI_GRP_MM0710_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (sI_GRP_MM0710_SO != null)
      ((javax.xml.rpc.Stub)sI_GRP_MM0710_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.esp.grpeccmm.k2pkbb.SI_GRP_MM0710_SO getSI_GRP_MM0710_SO() {
    if (sI_GRP_MM0710_SO == null)
      _initSI_GRP_MM0710_SOProxy();
    return sI_GRP_MM0710_SO;
  }
  
  public com.esp.grpeccmm.k2pkbb.DT_GRP_MM0710_Con_response SI_GRP_MM0710_SO(com.esp.grpeccmm.k2pkbb.DT_GRP_MM0710_Con MT_GRP_MM0710_Con) throws java.rmi.RemoteException{
    if (sI_GRP_MM0710_SO == null)
      _initSI_GRP_MM0710_SOProxy();
    return sI_GRP_MM0710_SO.SI_GRP_MM0710_SO(MT_GRP_MM0710_Con);
  }
  
  
}