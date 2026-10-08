package com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016;

public class M2KEP0001M2016Proxy implements com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016.M2KEP0001M2016 {
  private String _endpoint = null;
  private com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016.M2KEP0001M2016 m2KEP0001M2016 = null;
  
  private String _mode	= "";	// 2:운영, 0:개발
  
  public M2KEP0001M2016Proxy() {
    _initM2KEP0001M2016Proxy();
  }
  
  public M2KEP0001M2016Proxy(String mode) {
    _mode	= mode;
    _initM2KEP0001M2016Proxy();
  }
  
  public M2KEP0001M2016Proxy(String mode, String endpoint) {
    _mode	= mode;
    _endpoint = endpoint;
    _initM2KEP0001M2016Proxy();
  }
  
  private void _initM2KEP0001M2016Proxy() {
    try {
      m2KEP0001M2016 = (new com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016.M2KEP0001M2016ServiceLocator(_mode)).getM2KEP0001M2016Port();
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
  
  public String get_mode() {
	return _mode;
  }

  public void set_mode(String p_mode) {
	_mode = p_mode;
  }

  public com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016.M2KEP0001M2016 getM2KEP0001M2016() {
    if (m2KEP0001M2016 == null)
      _initM2KEP0001M2016Proxy();
    return m2KEP0001M2016;
  }
  
  public boolean process(com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016.T_APPR_OUT_STEP[] m2KEP0001M2016Req) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016.Exception{
    if (m2KEP0001M2016 == null)
      _initM2KEP0001M2016Proxy();
    return m2KEP0001M2016.process(m2KEP0001M2016Req);
  }
  
}
