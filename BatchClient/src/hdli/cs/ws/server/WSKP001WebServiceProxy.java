package hdli.cs.ws.server;

public class WSKP001WebServiceProxy implements WSKP001WebService {
  private String _endpoint = null;
  private WSKP001WebService wSKP001WebService = null;
  private String _mode	= "0";	// 2:운영, 0:개발
  
  public WSKP001WebServiceProxy() {
    _initWSKP001WebServiceProxy();
  }

  public WSKP001WebServiceProxy(String mode) {
	_mode = mode;  
    _initWSKP001WebServiceProxy();
  }
  
  public WSKP001WebServiceProxy(String mode, String endpoint) {
	_mode = mode;  
    _endpoint = endpoint;
    _initWSKP001WebServiceProxy();
  }
  
  private void _initWSKP001WebServiceProxy() {
    try {
      wSKP001WebService = (new WSKP001Locator(_mode)).getWSKP001WebServiceImplPort();
      if (wSKP001WebService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)wSKP001WebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)wSKP001WebService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (wSKP001WebService != null)
      ((javax.xml.rpc.Stub)wSKP001WebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public WSKP001WebService getWSKP001WebService() {
    if (wSKP001WebService == null)
      _initWSKP001WebServiceProxy();
    return wSKP001WebService;
  }
  
  public T_APPR_RETURN[] process(T_APPR_OUT_STEP[] arg0) throws java.rmi.RemoteException{
    if (wSKP001WebService == null)
      _initWSKP001WebServiceProxy();
    return wSKP001WebService.process(arg0);
  }
  
  
}