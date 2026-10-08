package com.koreab2b.mro.common.mdcp.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCpUserDetailViewPopDao")
@Transactional
public class MasterMdCpUserDetailViewPopDaoImpl implements MasterMdCpUserDetailViewPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpUserDetailViewPopDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		/* 로그관련 셋팅 시작 */
		String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("common.mdcp.selectMasterMdCpUserDetailViewPopList").getBoundSql(formData).getSql();
		String attr_01 = "";
		for(Map.Entry<String, String>entry: formData.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, String> data = new HashMap<String, String>();
		data.putAll(formData);
		data.put("SYSTEM", "KOREAB2B");
		if(formData.get("callType").equals("A")){
			data.put("MENU", "사용자상세조회(관리자승인)");
		}else if(formData.get("callType").equals("B")){
			data.put("MENU", "사용자상세조회(사용자조회)");
		}else {
			data.put("MENU", "사용자상세조회(팝업)");
		}
		data.put("LOG_TYPE", "조회");
		data.put("ATTR_01", strSql+"/"+attr_01);
		data.put("ATTR_02", formData.get("st_user_id")); // 검색한 아이디(대상)
		data.put("ATTR_03", "");
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		/* 로그관련 셋팅 끝 */
		
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpUserDetailViewPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectApprovedList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpUserDetailViewApproved", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectReferList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdcp.selectMasterMdCpUserDetailViewRefer", formData);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "";
		Map<String, String> _pMap = new HashMap<String, String>();
		try {
			sqlSessionTemplate.update("common.mdcp.updateMasterMdCpUserDetailViewPop",formData);
			
			String old_role = formData.get("st_old_role");
			String old_user_group = formData.get("st_old_user_group");
			String new_role = formData.get("st_role");
			String new_user_group = formData.get("st_user_group");
						
			if(old_role.equals(new_role))
				formData.put("st_role","");
			if(old_user_group.equals(new_user_group))
				formData.put("st_user_group","");
			
			if(!formData.get("st_role").equals("") || !formData.get("st_user_group").equals("")) {
				sqlSessionTemplate.update("common.mdcp.insertMasterMdCpUserInfoLog",formData);
				
				_pMap.put("COM_CODE", formData.get("st_user_com_code"));
				_pMap.put("USER_ID", formData.get("st_user_id"));
				sqlSessionTemplate.update("master.mdcp.SP_PROC_USERAUTH_GEN", _pMap);
			}
			
			String old_department = formData.get("st_old_department");
			String new_department = formData.get("st_department");
			String old_pur_department = formData.get("st_old_pur_department");
			String new_pur_department = formData.get("st_pur_department");
			
			if(old_department.equals(new_department)) {
				formData.put("st_department","");
			}
			
			if(old_pur_department.equals(new_pur_department)) {
				formData.put("st_pur_department","");
			}
			
			if(!formData.get("st_department").equals("") || !formData.get("st_pur_department").equals("")) {
				sqlSessionTemplate.update("common.mdcp.insertMasterMdCpUserChangeLog",formData);
			}
			
			_rtnMsg = "OK";
		} catch(Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("사용자 정보 수정이 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
	
}
