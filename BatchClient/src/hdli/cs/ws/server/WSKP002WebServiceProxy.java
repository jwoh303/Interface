package hdli.cs.ws.server;

public class WSKP002WebServiceProxy implements WSKP002WebService {
  private String _endpoint = null;
  private WSKP002WebService wSKP002WebService = null;
  private String _mode	= "0";	// 2:운영, 0:개발
  
  public WSKP002WebServiceProxy() {
    _initWSKP002WebServiceProxy();
  }
  
  public WSKP002WebServiceProxy(String mode) {
	_mode	= mode;
	_initWSKP002WebServiceProxy();
  }
  
  public WSKP002WebServiceProxy(String mode, String endpoint) {
    _endpoint = endpoint;
    _mode = mode;
    _initWSKP002WebServiceProxy();
  }
  
  private void _initWSKP002WebServiceProxy() {
    try {
      wSKP002WebService = (new WSKP002Locator(_mode)).getWSKP002WebServiceImplPort();
      if (wSKP002WebService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)wSKP002WebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)wSKP002WebService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (wSKP002WebService != null)
      ((javax.xml.rpc.Stub)wSKP002WebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public WSKP002WebService getWSKP002WebService() {
    if (wSKP002WebService == null)
      _initWSKP002WebServiceProxy();
    return wSKP002WebService;
  }
  
  public T_APPR_STATUS_IN_STEP[] process(T_APPR_STATUS_LIST_CALL[] arg0) throws java.rmi.RemoteException{
    if (wSKP002WebService == null)
      _initWSKP002WebServiceProxy();
    return wSKP002WebService.process(arg0);
  }
  
  
}