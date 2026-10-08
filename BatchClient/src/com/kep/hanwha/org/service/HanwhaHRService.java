package com.kep.hanwha.org.service;

import java.rmi.RemoteException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.hanwha.org.dao.HanwhaOrgDao;

public class HanwhaHRService {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	public void getHanwhaOrg() {
		/**
		 * 부문 3개에 대해서 각각의 부서목록을 받아온다.
		 * 방산 402 / 글로벌 403 / 기계 410 
		 */
		
		String[] coms = {"402","403","410"};
		List<Map<String, String>> companys = new ArrayList<Map<String,String>>();

		Map<String, String> iMap = new HashMap<String,String>();
		Map<String, String> iMap1 = new HashMap<String,String>();
		iMap1.put("COMPANY_ID", "402");
		iMap1.put("COMPANY_NAME", "(주)한화");
		companys.add(iMap1);
		Map<String, String> iMap2 = new HashMap<String,String>();
		iMap2.put("COMPANY_ID", "403");
		iMap2.put("COMPANY_NAME", "(주)한화/글로벌");
		companys.add(iMap2);
		Map<String, String> iMap3 = new HashMap<String,String>();
		iMap3.put("COMPANY_ID", "410");
		iMap3.put("COMPANY_NAME", "(주)한화/기계");
		companys.add(iMap3);
		
		HanwhaOrgDao dao = new HanwhaOrgDao();
		Map<String, String> pMap = new HashMap<String, String>();
		
		for (int i=0 ; i < companys.size() ; i++) {
			String _endpoint = CommonProperty.getNeoOrgWsImplPort_address() + companys.get(i).get("COMPANY_ID");
			
			log.info(companys.get(i));
			
			com.hanwha.neo.branch.ss.org.service.NeoOrgWsProxy proxy = new com.hanwha.neo.branch.ss.org.service.NeoOrgWsProxy(_endpoint);
			
			try {
				com.hanwha.neo.branch.ss.org.vo.OrgDeptVO[] orgs =  proxy.searchDeptByCompanyId();
				
				if (orgs.length > 0) {
					pMap.clear();
					pMap.put("COMPANY_ID", coms[i]);
					
					try {
//						dao.deleteHanwhaOrg(pMap);

						// 회사정보 추가.
						iMap.clear();
						iMap.put("DEPT_ID", companys.get(i).get("COMPANY_ID"));
						iMap.put("DEPT_NAME", companys.get(i).get("COMPANY_NAME"));
						iMap.put("PARENT_DEPT_ID", "000");
						iMap.put("PARENT_DEPT_NAME", "");
						iMap.put("ABBREVIATION", "");
						iMap.put("ACTIVE_YN", "Y");
						iMap.put("SORT_NO", "0");
						iMap.put("COMPANY_ID", companys.get(i).get("COMPANY_ID"));
						iMap.put("COMPANY_NAME", companys.get(i).get("COMPANY_NAME"));
						iMap.put("CHILD_INC_YN", "Y");
						iMap.put("MANAGER_ID", "");
						iMap.put("SUBMANAGER_ID", "");
						iMap.put("DEPT_CODE", "");
						log.info(iMap);
						try {
//							dao.insertHanwhaOrgInfo(iMap);	
						} catch (Exception e) {
							log.error(CommonUtil.printStackTraceToString(e));
						}
						
						for(com.hanwha.neo.branch.ss.org.vo.OrgDeptVO iObj : orgs) {
							iMap.clear();
							iMap.put("DEPT_ID", iObj.getDeptId());
							iMap.put("DEPT_NAME", iObj.getDeptName());
							iMap.put("PARENT_DEPT_ID", iObj.getParentDeptId());
							iMap.put("PARENT_DEPT_NAME", iObj.getParentDeptName());
							iMap.put("ABBREVIATION", iObj.getAbbreviation());
							iMap.put("ACTIVE_YN", iObj.getActiveYn());
							iMap.put("SORT_NO", Integer.toString(iObj.getSortNo()));
							iMap.put("COMPANY_ID", iObj.getCompanyId());
							iMap.put("COMPANY_NAME", iObj.getCompanyName());
							iMap.put("CHILD_INC_YN", iObj.getChildIncYn());
							iMap.put("MANAGER_ID", iObj.getManagerId());
							iMap.put("SUBMANAGER_ID", iObj.getSubManagerId());
							iMap.put("DEPT_CODE", iObj.getDeptCode());
							
//							dao.insertHanwhaOrgInfo(iMap);
						}
					} catch (Exception e) {
						log.error(CommonUtil.printStackTraceToString(e));
					}
				}
			} catch (com.hanwha.neo.branch.ss.common.vo.WsException e) {
				log.error(CommonUtil.printStackTraceToString(e));
			} catch (RemoteException e) {
				log.error(CommonUtil.printStackTraceToString(e));
			}
		}
	}
	
	public void getHanwhaUser() {
		
	}
}