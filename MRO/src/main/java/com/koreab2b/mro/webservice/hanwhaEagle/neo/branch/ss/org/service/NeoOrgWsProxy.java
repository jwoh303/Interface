package com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.service;

public class NeoOrgWsProxy implements com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.service.NeoOrgWs {
  private String _endpoint = null;
  private com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.service.NeoOrgWs neoOrgWs = null;
  
  public NeoOrgWsProxy() {
    _initNeoOrgWsProxy();
  }
  
  public NeoOrgWsProxy(String endpoint) {
    _endpoint = endpoint;
    _initNeoOrgWsProxy();
  }
  
  private void _initNeoOrgWsProxy() {
    try {
      neoOrgWs = (new com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.service.NeoOrgWsImplServiceLocator()).getNeoOrgWsImplPort();
      if (neoOrgWs != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)neoOrgWs)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)neoOrgWs)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (neoOrgWs != null)
      ((javax.xml.rpc.Stub)neoOrgWs)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.service.NeoOrgWs getNeoOrgWs() {
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs;
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserIdListIncConcurrentPosition(java.lang.String[] userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByUserIdListIncConcurrentPosition(userId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptVO[] searchDeptByDeptIdIncludeChild(java.lang.String deptId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchDeptByDeptIdIncludeChild(deptId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO searchDefaultUserByUserId(java.lang.String userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchDefaultUserByUserId(userId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptVO[] searchDeptByDeptName(java.lang.String deptName) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchDeptByDeptName(deptName);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgCodeVO[] getOrgClassList() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.getOrgClassList();
  }
  
  public java.lang.String orgSyncForHDSCircle() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.orgSyncForHDSCircle();
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserKeyListIncConcurrentPosition(java.lang.String[] userKey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByUserKeyListIncConcurrentPosition(userKey);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgFunctionId(java.lang.String orgFunctionId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByOrgFunctionId(orgFunctionId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserKey(java.lang.String userKey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByUserKey(userKey);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgClassId(java.lang.String orgClassId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByOrgClassId(orgClassId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptVO[] searchDeptByCompanyId() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchDeptByCompanyId();
  }
  
  public java.lang.String orgSyncForCircle() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.orgSyncForCircle();
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptVO[] searchDeptByCompanyIdForPaging(int pageNo, int pageSize) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchDeptByCompanyIdForPaging(pageNo, pageSize);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgPositionIdIncConcurrentPosition(java.lang.String orgPositionId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByOrgPositionIdIncConcurrentPosition(orgPositionId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchGroupUserByEmpolyeeNo(java.lang.String employeeNo) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchGroupUserByEmpolyeeNo(employeeNo);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByEmpolyeeNo(java.lang.String employeeNo) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByEmpolyeeNo(employeeNo);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByDeptIdForPaging(java.lang.String deptId, int pageNo, int pageSize) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByDeptIdForPaging(deptId, pageNo, pageSize);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByMailList(java.lang.String[] email) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByMailList(email);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgCodeVO[] getOrgPositionList() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.getOrgPositionList();
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByMailIncConcurrentPosition(java.lang.String email) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByMailIncConcurrentPosition(email);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserKeyIncConcurrentPosition(java.lang.String userKey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByUserKeyIncConcurrentPosition(userKey);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgPositionId(java.lang.String orgPositionId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByOrgPositionId(orgPositionId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserNameIncConcurrentPosition(java.lang.String userName) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByUserNameIncConcurrentPosition(userName);
  }
  
  public java.lang.String getUserLoginInfo(java.lang.String user_id) throws java.rmi.RemoteException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.getUserLoginInfo(user_id);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByDeptId(java.lang.String deptId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByDeptId(deptId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgCompanyVO[] getGroupCompanyList() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.getGroupCompanyList();
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByDeptIdIncConcurrentPosition(java.lang.String deptId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByDeptIdIncConcurrentPosition(deptId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchGroupUserByUserId(java.lang.String userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchGroupUserByUserId(userId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptVO[] searchDeptByDeptId(java.lang.String deptId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchDeptByDeptId(deptId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserIdList(java.lang.String[] userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByUserIdList(userId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgClassIdIncConcurrentPosition(java.lang.String orgClassId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByOrgClassIdIncConcurrentPosition(orgClassId);
  }
  
  public boolean checkExistUserId(java.lang.String type, java.lang.String value) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.checkExistUserId(type, value);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgFunctionIdIncConcurrentPosition(java.lang.String orgFunctionId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByOrgFunctionIdIncConcurrentPosition(orgFunctionId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByEmpolyeeNoIncConcurrentPosition(java.lang.String employeeNo) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByEmpolyeeNoIncConcurrentPosition(employeeNo);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByMail(java.lang.String email) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByMail(email);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserName(java.lang.String userName) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByUserName(userName);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptUserVO[] searchDeptUserByDeptIdIncConcurrentPosition(java.lang.String deptId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchDeptUserByDeptIdIncConcurrentPosition(deptId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserId(java.lang.String userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByUserId(userId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserIdIncConcurrentPosition(java.lang.String userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByUserIdIncConcurrentPosition(userId);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserKeyList(java.lang.String[] userKey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByUserKeyList(userKey);
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgCodeVO[] getOrgFunctionList() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.getOrgFunctionList();
  }
  
  public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByMailListIncConcurrentPosition(java.lang.String[] email) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException{
    if (neoOrgWs == null)
      _initNeoOrgWsProxy();
    return neoOrgWs.searchUserByMailListIncConcurrentPosition(email);
  }
  
  
}