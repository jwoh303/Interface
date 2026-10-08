package com.hanwhaaerospace.KEPEH_SRMDH;

public class NE9090_KEPEH_SRMDH_SOProxy implements com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SO {
  private String _endpoint = null;
  private com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SO nE9090_KEPEH_SRMDH_SO = null;
  
  public NE9090_KEPEH_SRMDH_SOProxy() {
    _initNE9090_KEPEH_SRMDH_SOProxy();
  }
  
  public NE9090_KEPEH_SRMDH_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initNE9090_KEPEH_SRMDH_SOProxy();
  }
  
  private void _initNE9090_KEPEH_SRMDH_SOProxy() {
    try {
      nE9090_KEPEH_SRMDH_SO = (new com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SOServiceLocator()).getHTTPS_Port();
      if (nE9090_KEPEH_SRMDH_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)nE9090_KEPEH_SRMDH_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)nE9090_KEPEH_SRMDH_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (nE9090_KEPEH_SRMDH_SO != null)
      ((javax.xml.rpc.Stub)nE9090_KEPEH_SRMDH_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_SO getNE9090_KEPEH_SRMDH_SO() {
    if (nE9090_KEPEH_SRMDH_SO == null)
      _initNE9090_KEPEH_SRMDH_SOProxy();
    return nE9090_KEPEH_SRMDH_SO;
  }
  
  public com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S_R NE9090_KEPEH_SRMDH_SO(com.hanwhaaerospace.KEPEH_SRMDH.NE9090_KEPEH_SRMDH_S NE9090_KEPEH_SRMDH_S) throws java.rmi.RemoteException{
    if (nE9090_KEPEH_SRMDH_SO == null)
      _initNE9090_KEPEH_SRMDH_SOProxy();
    return nE9090_KEPEH_SRMDH_SO.NE9090_KEPEH_SRMDH_SO(NE9090_KEPEH_SRMDH_S);
  }
  
  
}