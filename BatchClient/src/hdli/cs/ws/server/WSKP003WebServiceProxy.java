package hdli.cs.ws.server;

public class WSKP003WebServiceProxy implements hdli.cs.ws.server.WSKP003WebService {
  private String _endpoint = null;
  private hdli.cs.ws.server.WSKP003WebService wSKP003WebService = null;
  private String _mode	= "0";	// 2:운영, 0:개발
  
  public WSKP003WebServiceProxy() {
    _initWSKP003WebServiceProxy();
  }
  public WSKP003WebServiceProxy(String mode) {
    _mode	= mode;
    _initWSKP003WebServiceProxy();
  }
  
  public WSKP003WebServiceProxy(String mode,String endpoint) {
    _endpoint = endpoint;
    _mode = mode;
    _initWSKP003WebServiceProxy();
  }
  
  private void _initWSKP003WebServiceProxy() {
    try {
      wSKP003WebService = (new hdli.cs.ws.server.WSKP003Locator(_mode)).getWSKP003WebServiceImplPort();
      if (wSKP003WebService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)wSKP003WebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)wSKP003WebService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (wSKP003WebService != null)
      ((javax.xml.rpc.Stub)wSKP003WebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public hdli.cs.ws.server.WSKP003WebService getWSKP003WebService() {
    if (wSKP003WebService == null)
      _initWSKP003WebServiceProxy();
    return wSKP003WebService;
  }
  
  public hdli.cs.ws.server.T_GR_RETURN[] process(hdli.cs.ws.server.T_GR_INFO[] arg0) throws java.rmi.RemoteException{
    if (wSKP003WebService == null)
      _initWSKP003WebServiceProxy();
    return wSKP003WebService.process(arg0);
  }
  
  
}