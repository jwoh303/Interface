package com.koreab2b.mro.master.mdcp.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCpAdminApprovalObjctDao")
@Transactional
public class MasterMdCpAdminApprovalObjctDaoImpl implements MasterMdCpAdminApprovalObjctDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpAdminApprovalObjctDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcp.selectMasterMdCpAdminApprovalObjctList", param);
	}

	// 승인 및 거절
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		if (formData.get("st_status").equals("C")) {
			_rtnMsg = "사용자 승인이 완료 되었습니다.";
		} else {
			_rtnMsg = "사용자 거절이 완료 되었습니다.";
		}

		try {
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));
				// STEP1
				sqlSessionTemplate.update("master.mdcp.updateMasterMdCpAdminApprovalObjct", formData);
				
				if (formData.get("st_status").equals("C")) {
					sqlSessionTemplate.update("master.mdcp.insertMasterMdCpAdminApprovalObjct", formData);
					
					if (formData.get("BUSINESS_COND").equals("B")) {
						formData.put("AUTH_ID",  "ROLE_BADM001");
					} else if (formData.get("BUSINESS_COND").equals("S")) {
						formData.put("AUTH_ID",  "ROLE_SADM001");
					} else {
						formData.put("AUTH_ID",  "ROLE_MADM001");
					}
//					String _authChk =  sqlSessionTemplate.selectOne("master.mdcp.getMasterMdCpAdminApprovalObjctUserAuth",formData);
//					if (Integer.parseInt(_authChk) > 0) {
//						sqlSessionTemplate.update("master.mdcp.updateMasterMdCpAdminApprovalObjctUserAuth",formData);
//					} else {
//						sqlSessionTemplate.insert("master.mdcp.insertMasterMdCpAdminApprovalObjctUserAuth",formData);
//					}
					
					sqlSessionTemplate.update("master.mdcp.SP_PROC_USERAUTH_GEN", formData);
				}
			}
			
		} catch (Exception e) {
			if (formData.get("st_status").equals("C")) {
				_rtnMsg = "사용자 승인이 실패하였습니다.";
			} else {
				_rtnMsg = "사용자 거절이 실패하였습니다.";
			}
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("사용자 승인/거절 중(UPDATE ICOMLUSR) 에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mdcp.deleteMasterMdCpAdminApprovalObjct", formData);
				logger.error("deleteMasterMdCpAdminApprovalObjct 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
