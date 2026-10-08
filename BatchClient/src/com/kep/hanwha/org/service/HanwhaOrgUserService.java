package com.kep.hanwha.org.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.hanwha.neo.branch.ss.org.vo.OrgUserVO;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.hanwha.org.dao.HanwhaOrgUserDao;

public class HanwhaOrgUserService {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	public void getHanwhaUser() {
		HanwhaOrgUserDao dao	= new HanwhaOrgUserDao();
		try {
			List<Map<String, String>> companys = dao.selectHanwhaCompanyID();
			log.info("Compnay.size:"+companys.size() + "["+companys+"]");
			if (companys.size() > 0) {
				
				for (Map<String,String> iMap : companys) {
					log.info("Compnay["+iMap.get("COMPANY_ID")+"]");
					// KEP에 등록된 사용자 기준으로 인사 정보를 확인한다.
					List<Map<String, String>> lUsers = dao.selectHanwhaKepUserList(iMap);

					log.info("Compnay["+iMap.get("COMPANY_ID")+"]");
					log.info("General User-Compnay["+iMap.get("COMPANY_ID")+"]:"+lUsers.size() + "["+lUsers+"]");
					if ( lUsers.size() > 0 ) {
						String[] ids = new String[lUsers.size()];
						int j = 0;
						for( Map<String,String> jMap : lUsers ) {
							ids[j++] = jMap.get("LEGACY_USER_ID");
						}
						
						String _endpoint = CommonProperty.getNeoOrgWsImplPort_address() + iMap.get("COMPANY_ID");
						com.hanwha.neo.branch.ss.org.service.NeoOrgWsProxy proxy = new com.hanwha.neo.branch.ss.org.service.NeoOrgWsProxy(_endpoint);
						OrgUserVO[] users = proxy.searchUserByUserIdList(ids);
						
						for ( int k = 0 ; k < users.length ; k++ ) {
							Map<String, String> uMap = new HashMap<String,String>();
							
							uMap.put("USER_ID", users[k].getUserId());
							uMap.put("USER_NAME_LOC", users[k].getUserName());
							uMap.put("DEPT_CODE", users[k].getDeptId());
							uMap.put("DEPARTMENT", users[k].getDeptName());
							uMap.put("EMP_NO", users[k].getEmployeeNo());
							uMap.put("PLANT", users[k].getCompanyId());
							
							dao.mergeHanwhaOrgUser(uMap);
						}
					}
					
					// KEP에 등록된 부서 기준으로 정관리자의 인사정보를 확인한다.
					List<Map<String, String>> mUsers = dao.selectHanwhaOrgManagerList(iMap);
					log.info("Manager User-Compnay["+iMap.get("COMPANY_ID")+"]:"+mUsers.size() + "["+mUsers+"]");
					if (mUsers.size() > 0) {
						String[] ids = new String[lUsers.size()];
						int j = 0;
						for( Map<String,String> jMap : lUsers ) {
							ids[j++] = jMap.get("MANAGER_ID");
						}
						
						String _endpoint = CommonProperty.getNeoOrgWsImplPort_address() + iMap.get("COMPANY_ID");
						com.hanwha.neo.branch.ss.org.service.NeoOrgWsProxy proxy = new com.hanwha.neo.branch.ss.org.service.NeoOrgWsProxy(_endpoint);
						OrgUserVO[] users = proxy.searchUserByUserIdList(ids);
						
						for ( int k = 0 ; k < users.length ; k++ ) {
							Map<String, String> uMap = new HashMap<String,String>();
							
							uMap.put("USER_ID", users[k].getUserId());
							uMap.put("USER_NAME_LOC", users[k].getUserName());
							uMap.put("DEPT_CODE", users[k].getDeptId());
							uMap.put("DEPARTMENT", users[k].getDeptName());
							uMap.put("EMP_NO", users[k].getEmployeeNo());
							uMap.put("PLANT", users[k].getCompanyId());
							
							dao.mergeHanwhaOrgUser(uMap);
						}
					}
				}
			}
		} catch (Exception e) {
			log.error("getHanwhaUser:" + CommonUtil.printStackTraceToString(e));
		}
	}
}