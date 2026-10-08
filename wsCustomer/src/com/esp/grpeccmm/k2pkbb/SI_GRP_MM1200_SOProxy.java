package com.esp.grpeccmm.k2pkbb;

public class SI_GRP_MM1200_SOProxy implements com.esp.grpeccmm.k2pkbb.SI_GRP_MM1200_SO {
  private String _endpoint = null;
  private com.esp.grpeccmm.k2pkbb.SI_GRP_MM1200_SO sI_GRP_MM1200_SO = null;
  
  public SI_GRP_MM1200_SOProxy() {
    _initSI_GRP_MM1200_SOProxy();
  }
  
  public SI_GRP_MM1200_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initSI_GRP_MM1200_SOProxy();
  }
  
  private void _initSI_GRP_MM1200_SOProxy() {
    try {
      sI_GRP_MM1200_SO = (new com.esp.grpeccmm.k2pkbb.SI_GRP_MM1200_SOServiceLocator()).getHTTPS_Port();
      if (sI_GRP_MM1200_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)sI_GRP_MM1200_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)sI_GRP_MM1200_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (sI_GRP_MM1200_SO != null)
      ((javax.xml.rpc.Stub)sI_GRP_MM1200_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.esp.grpeccmm.k2pkbb.SI_GRP_MM1200_SO getSI_GRP_MM1200_SO() {
    if (sI_GRP_MM1200_SO == null)
      _initSI_GRP_MM1200_SOProxy();
    return sI_GRP_MM1200_SO;
  }
  
  public com.esp.grpeccmm.k2pkbb.DT_GRP_MM1200_Con_response SI_GRP_MM1200_SO(com.esp.grpeccmm.k2pkbb.DT_GRP_MM1200_Con MT_GRP_MM1200_Con) throws java.rmi.RemoteException{
    if (sI_GRP_MM1200_SO == null)
      _initSI_GRP_MM1200_SOProxy();
    return sI_GRP_MM1200_SO.SI_GRP_MM1200_SO(MT_GRP_MM1200_Con);
  }
  
  
}