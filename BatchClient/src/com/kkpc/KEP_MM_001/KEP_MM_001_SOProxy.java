package com.kkpc.KEP_MM_001;

public class KEP_MM_001_SOProxy implements com.kkpc.KEP_MM_001.KEP_MM_001_SO {
  private String _endpoint = null;
  private com.kkpc.KEP_MM_001.KEP_MM_001_SO kEP_MM_001_SO = null;
  
  public KEP_MM_001_SOProxy() {
    _initKEP_MM_001_SOProxy();
  }
  
  public KEP_MM_001_SOProxy(String endpoint) {
    _endpoint = endpoint;
    _initKEP_MM_001_SOProxy();
  }
  
  private void _initKEP_MM_001_SOProxy() {
    try {
      kEP_MM_001_SO = (new com.kkpc.KEP_MM_001.KEP_MM_001_SOServiceLocator()).getHTTPS_Port();
      if (kEP_MM_001_SO != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)kEP_MM_001_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)kEP_MM_001_SO)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (kEP_MM_001_SO != null)
      ((javax.xml.rpc.Stub)kEP_MM_001_SO)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.kkpc.KEP_MM_001.KEP_MM_001_SO getKEP_MM_001_SO() {
    if (kEP_MM_001_SO == null)
      _initKEP_MM_001_SOProxy();
    return kEP_MM_001_SO;
  }
  
  public com.kkpc.KEP_MM_001.KEP_MM_001_DT_res_SOAP KEP_MM_001_SO(com.kkpc.KEP_MM_001.KEP_MM_001_DT_req_SOAPROW[] KEP_MM_001_MT_req_SOAP) throws java.rmi.RemoteException{
    if (kEP_MM_001_SO == null)
      _initKEP_MM_001_SOProxy();
    return kEP_MM_001_SO.KEP_MM_001_SO(KEP_MM_001_MT_req_SOAP);
  }
  
  
}