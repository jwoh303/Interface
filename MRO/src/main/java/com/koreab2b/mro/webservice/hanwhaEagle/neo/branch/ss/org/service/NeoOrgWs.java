/**
 * NeoOrgWs.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.service;

public interface NeoOrgWs extends java.rmi.Remote {
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserIdListIncConcurrentPosition(java.lang.String[] userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptVO[] searchDeptByDeptIdIncludeChild(java.lang.String deptId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO searchDefaultUserByUserId(java.lang.String userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptVO[] searchDeptByDeptName(java.lang.String deptName) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgCodeVO[] getOrgClassList() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public java.lang.String orgSyncForHDSCircle() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserKeyListIncConcurrentPosition(java.lang.String[] userKey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgFunctionId(java.lang.String orgFunctionId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserKey(java.lang.String userKey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgClassId(java.lang.String orgClassId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptVO[] searchDeptByCompanyId() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public java.lang.String orgSyncForCircle() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptVO[] searchDeptByCompanyIdForPaging(int pageNo, int pageSize) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgPositionIdIncConcurrentPosition(java.lang.String orgPositionId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchGroupUserByEmpolyeeNo(java.lang.String employeeNo) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByEmpolyeeNo(java.lang.String employeeNo) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByDeptIdForPaging(java.lang.String deptId, int pageNo, int pageSize) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByMailList(java.lang.String[] email) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgCodeVO[] getOrgPositionList() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByMailIncConcurrentPosition(java.lang.String email) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserKeyIncConcurrentPosition(java.lang.String userKey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgPositionId(java.lang.String orgPositionId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserNameIncConcurrentPosition(java.lang.String userName) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public java.lang.String getUserLoginInfo(java.lang.String user_id) throws java.rmi.RemoteException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByDeptId(java.lang.String deptId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgCompanyVO[] getGroupCompanyList() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByDeptIdIncConcurrentPosition(java.lang.String deptId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchGroupUserByUserId(java.lang.String userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptVO[] searchDeptByDeptId(java.lang.String deptId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserIdList(java.lang.String[] userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgClassIdIncConcurrentPosition(java.lang.String orgClassId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public boolean checkExistUserId(java.lang.String type, java.lang.String value) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByOrgFunctionIdIncConcurrentPosition(java.lang.String orgFunctionId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByEmpolyeeNoIncConcurrentPosition(java.lang.String employeeNo) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByMail(java.lang.String email) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserName(java.lang.String userName) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgDeptUserVO[] searchDeptUserByDeptIdIncConcurrentPosition(java.lang.String deptId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserId(java.lang.String userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserIdIncConcurrentPosition(java.lang.String userId) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByUserKeyList(java.lang.String[] userKey) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgCodeVO[] getOrgFunctionList() throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
    public com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.org.vo.OrgUserVO[] searchUserByMailListIncConcurrentPosition(java.lang.String[] email) throws java.rmi.RemoteException, com.koreab2b.mro.webservice.hanwhaEagle.neo.branch.ss.common.vo.WsException;
}
