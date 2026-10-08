package com.koreab2b.mro.common.mdcp.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMdCpModuSignWebhookDao")
@Transactional
public class MasterMdCpModuSignWebhookDaoImpl implements MasterMdCpModuSignWebhookDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpModuSignWebhookDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// WEBHOOK 결과 상태 변경
	public String updateModuSignStatus(Map<String,String> formData) {

		String _rtnMsg = "OK";
		String com_code = "";
		
		try { 
			sqlSessionTemplate.update("common.mdcp.updateModuSignStatus", formData);
			
			//System.out.println("updateModuSignStatus end =============== " + formData.get("doc_status") + "\n");
			// document_all_signed 서명완료
			if("F".equals(formData.get("doc_status"))){
				//System.out.println("formData doc_id =============== " + formData.get("doc_id") + "\n");
				// 1. doc_id 로 협력사코드 조회
				com_code = sqlSessionTemplate.selectOne("common.mdcp.selectComCodewithDocId", formData);
				
				// 2. 모든 서명 완료 시 협력사 승인
				formData.put("com_code", com_code);
				//System.out.println("formData com_code =============== " + formData.get("com_code") + "\n");
				sqlSessionTemplate.update("common.mdcp.updateAgentConfirm1", formData);
				//System.out.println("updateAgentConfirm1 end =============== " + formData.get("com_code") + "\n");
				sqlSessionTemplate.update("common.mdcp.updateAgentConfirm2", formData);
				//System.out.println("updateAgentConfirm2 end =============== " + formData.get("com_code") + "\n");
				sqlSessionTemplate.update("common.mdcp.updateAgentConfirm3", formData);
				//System.out.println("updateAgentConfirm3 end =============== " + formData.get("confirmId") + "\n");
				sqlSessionTemplate.update("common.mdcp.updateAgentConfirm4", formData);
				//System.out.println("updateAgentConfirm4 end =============== " + formData.get("confirmId") + "\n");
				sqlSessionTemplate.update("common.mdcp.updateAgentConfirm5", formData);
			}
			
		} catch(Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("전자계약 상태 변경 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 재계약전송 후 DOC_ID 저장
	public String updateModuSignDocId(Map<String,String> formData) {

		String _rtnMsg = "OK";
		
		try {
			sqlSessionTemplate.update("common.mdcp.updateModuSignDocId", formData);
			
		} catch(Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("전자계약 DOC_ID 변경 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
