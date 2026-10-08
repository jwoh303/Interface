package com.koreab2b.mro.common.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpvo.dao.MasterMpVoVocProgressStateFBPopDao;

@Service("masterMpVoVocProgressStateFBPopServiceImpl")
public class MasterMpVoVocProgressStateFBPopServiceImpl  implements MasterMpVoVocProgressStateFBPopService {
	@Autowired
	private MasterMpVoVocProgressStateFBPopDao masterMpVoVocProgressStateFBPopDao;
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocProgressStatePop(Map<String,Object> formData) {
		return masterMpVoVocProgressStateFBPopDao.getMasterMpVoVocProgressStatePop(formData);
	}

	// 조회
	public List<Map<String,String>> getMasterMpVoVocProgressStateFBPop(Map<String,Object> formData) {
		return masterMpVoVocProgressStateFBPopDao.getMasterMpVoVocProgressStateFBPop(formData);
	}
	
	// 저장
	public String saveMasterMpVoVocDsUserInfo(Map<String,String>  formData) {
		return masterMpVoVocProgressStateFBPopDao.saveMasterMpVoVocDsUserInfo(formData);
	}
	
	// 저장
	public String saveMasterMpVoVocProgressStatePop(Map<String,String>  formData) {
		return masterMpVoVocProgressStateFBPopDao.saveMasterMpVoVocProgressStatePop(formData);
	}
	
	// 저장
	public String saveMasterMpVoVocProgressStateFbChangePop(Map<String,String>  formData) {
		return masterMpVoVocProgressStateFBPopDao.saveMasterMpVoVocProgressStateFbChangePop(formData);
	}

	// 	VOC 이력
	public List<Map<String, String>> getMasterMpVoVocHistPop(Map<String, Object> formData) {
		return masterMpVoVocProgressStateFBPopDao.getMasterMpVoVocHistPop(formData);
	}

	// VOC 차수 저장
	public int saveVocRevisionPop(Map<String, String> formData) {
		return masterMpVoVocProgressStateFBPopDao.saveVocRevisionPop(formData);
	}
	
	// VOC 차수 저장시 update
	public String updateVocRevisionPop(Map<String, String> formData) {
		return masterMpVoVocProgressStateFBPopDao.updateMasterMpVoVocProgressStateReReqPop(formData);
	}
	
	// VOC 중간 저장
	public String saveMasterMpVoVocProgressPCPop(Map<String,String>  formData) {
		return masterMpVoVocProgressStateFBPopDao.saveMasterMpVoVocProgressPCPop(formData);
	}
}
