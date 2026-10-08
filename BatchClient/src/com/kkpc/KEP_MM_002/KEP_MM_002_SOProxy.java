package com.kkpc.KEP_MM_002;

public class KEP_MM_002_SOProxy implements com.kkpc.KEP_MM_002.KEP_MM_002_SO {
  private String _endpoint = null;
  private com.kkpc.KEP_MM_002.KEP_MM_002_SO kEP_MM_002_SO = null;
  
  public KEP_MM_002_SOProxy() {
    _initKEP_MM_002_SOProxy();
  }
  
  public KEP_MM_002_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initKEP_MM_002_SOProxy();
  }
  
  private void _initKEP_MM_002_SOProxy() {
    try {
      kEP_MM_002_SO = (new com.kkpc.KEP_MM_002.KEP_MM_002_SOServiceLocator()).getHTTPS_Port();
      if (kEP_MM_002_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)kEP_MM_002_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)kEP_MM_002_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (kEP_MM_002_SO != null)
      ((javax.xml.rpc.Stub)kEP_MM_002_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.kkpc.KEP_MM_002.KEP_MM_002_SO getKEP_MM_002_SO() {
    if (kEP_MM_002_SO == null)
      _initKEP_MM_002_SOProxy();
    return kEP_MM_002_SO;
  }
  
  public com.kkpc.KEP_MM_002.KEP_MM_002_DT_res_SOAPROW[] KEP_MM_002_SO(com.kkpc.KEP_MM_002.KEP_MM_002_DT_req_SOAP KEP_MM_002_MT_req_SOAP) throws java.rmi.RemoteException{
    if (kEP_MM_002_SO == null)
      _initKEP_MM_002_SOProxy();
    return kEP_MM_002_SO.KEP_MM_002_SO(KEP_MM_002_MT_req_SOAP);
  }
  
  
}