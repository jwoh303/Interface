package com.stw.kep.ws.service.M2KEP0001M2016;

public class M2KEP0001M2016Proxy implements com.stw.kep.ws.service.M2KEP0001M2016.M2KEP0001M2016 {
  private String _endpoint = null;
  private com.stw.kep.ws.service.M2KEP0001M2016.M2KEP0001M2016 m2KEP0001M2016 = null;
  
  public M2KEP0001M2016Proxy() {
    _initM2KEP0001M2016Proxy();
  }
  
  public M2KEP0001M2016Proxy(String endpoint) {
    _endpoint = endpoint;
    _initM2KEP0001M2016Proxy();
  }
  
  private void _initM2KEP0001M2016Proxy() {
    try {
      m2KEP0001M2016 = (new com.stw.kep.ws.service.M2KEP0001M2016.M2KEP0001M2016ServiceLocator()).getM2KEP0001M2016Port();
      if (m2KEP0001M2016 != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)m2KEP0001M2016)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)m2KEP0001M2016)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (m2KEP0001M2016 != null)
      ((javax.xml.rpc.Stub)m2KEP0001M2016)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.stw.kep.ws.service.M2KEP0001M2016.M2KEP0001M2016 getM2KEP0001M2016() {
    if (m2KEP0001M2016 == null)
      _initM2KEP0001M2016Proxy();
    return m2KEP0001M2016;
  }
  
  public boolean process(com.stw.kep.ws.service.M2KEP0001M2016.T_APPR_OUT_STEP[] m2KEP0001M2016Req) throws java.rmi.RemoteException, com.stw.kep.ws.service.M2KEP0001M2016.Exception{
    if (m2KEP0001M2016 == null)
      _initM2KEP0001M2016Proxy();
    return m2KEP0001M2016.process(m2KEP0001M2016Req);
  }
  
  
}