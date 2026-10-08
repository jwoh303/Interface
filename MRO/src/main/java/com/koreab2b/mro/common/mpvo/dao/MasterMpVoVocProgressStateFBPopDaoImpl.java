package com.koreab2b.mro.common.mpvo.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpvo.dao.MasterMpVoVocReceiptDaoImpl;

@Repository("masterMpVoVocProgressStateFBPopDaoImpl")
@Transactional
public class MasterMpVoVocProgressStateFBPopDaoImpl implements MasterMpVoVocProgressStateFBPopDao {
	
	private static final Logger logger = LoggerFactory.getLogger(MasterMpVoVocReceiptDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocProgressStatePop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpvo.selectMasterMpVoVocProgressStatePop", formData);
	}

	// 조회
	public List<Map<String,String>> getMasterMpVoVocProgressStateFBPop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpvo.selectMasterMpVoVocProgressStateFBPop", formData);
	}
	
	// 저장
	public String saveMasterMpVoVocDsUserInfo(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			//처리담당자 변경
			sqlSessionTemplate.update("common.mpvo.updateMasterMpVoVocDsUserInfo", formData);
			//처리자 변경 메일
			sqlSessionTemplate.update("common.mpvo.insertMasterMpVoVocDsUserInfoMail", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("처리담당자 변경 실패 하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 저장
	public String saveMasterMpVoVocProgressStatePop(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			if(!formData.get("st_ds_user_id").equals(formData.get("st_session_user_id")) && !formData.get("st_cd_user_id").equals(formData.get("st_session_user_id"))) {
				throw new RuntimeException("접수/처리담당자와 현재 입력자와 다릅니다.");
			}
			
			sqlSessionTemplate.update("common.mpvo.updateMasterMpVoVocProgressStatePop", formData);
			//제출처리 했을때 접수자에게 메일 발송 및 제출 이력입력
			if(formData.get("st_recv_flag").equals("PA")) {
				sqlSessionTemplate.update("common.mpvo.insertMasterMpVoVocProgressMail", formData);
				sqlSessionTemplate.update("common.mpvo.insertMpVoVocDsUserInfo", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("VOC 진행현황 제출 처리에 실패 하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 저장
	public String saveMasterMpVoVocProgressStateFbChangePop(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.update("common.mpvo.updateMasterMpVoVocProgressStateFbChangePop", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("VOC 진행현황 Feedback 처리에 실패 하였습니다.");
		}
		return _rtnMsg;
	}

	// VOC 이력
	public List<Map<String, String>> getMasterMpVoVocHistPop(Map<String, Object> formData) {
		return sqlSessionTemplate.selectList("common.mpvo.selectMpVoVocHistPop", formData);
	}

	// VOC 이력 저장
	public int saveVocRevisionPop(Map<String, String> formData) {
		logger.debug("insert SQL ERROR Form DATA : ", formData);
		return sqlSessionTemplate.insert("common.mpvo.insertMpVoVocRevPop", formData);
	}

	// VOC 이력 저장시 update
	public String updateMasterMpVoVocProgressStateReReqPop(Map<String, String> formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.update("common.mpvo.updateMasterMpVoVocProgressStateReReqPop", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("VOC 진행현황 재요청 처리에 실패 하였습니다.");
		}
		return _rtnMsg;
	}
	// VOC 중간 저장
	public String saveMasterMpVoVocProgressPCPop(Map<String,String>  formData) {
		String _rtnMsg = "OK";
		try {
			if(!formData.get("st_ds_user_id").equals(formData.get("st_session_user_id")) && !formData.get("st_cd_user_id").equals(formData.get("st_session_user_id"))) {
				throw new RuntimeException("접수/처리담당자와 현재 입력자와 다릅니다.");
			}
			sqlSessionTemplate.update("common.mpvo.updateMasterMpVoVocProgressPCPop", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 처리에 실패 하였습니다.");
		}
		return _rtnMsg;
	}

}
