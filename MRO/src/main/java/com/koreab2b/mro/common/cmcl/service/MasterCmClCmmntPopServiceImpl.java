package com.koreab2b.mro.common.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.cmcl.dao.MasterCmClCmmntPopDao;

@Service("masterCmClCmmntPopService")
public class MasterCmClCmmntPopServiceImpl implements MasterCmClCmmntPopService {
	
	@Autowired
	private MasterCmClCmmntPopDao masterCmClCmmntPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterCmClCmmntPopDao.selectList(formData);
	}	
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClCmmntPopDao.updateSelectedData(formData, gridData);
	}	

	// 담당자정보조회
	public List<Map<String,String>> getMasterCmClStndSettingPop(Map<String,Object> formData) {
		return masterCmClCmmntPopDao.selectMasterCmClStndSettingPop(formData);
	}
	
	// 미매핑 세금계산서 조회 팝업
	public List<Map<String,String>> getMasterCmClIssueIdInfoPop(Map<String,Object> formData) {
		return masterCmClCmmntPopDao.selectMasterCmClIssueIdInfoPop(formData);
	}
	
	// 미매핑 세금계산서 조회 팝업 (상단 그리드 조회)
	public List<Map<String,String>> getMasterCmClIssueIdInfoPop1(Map<String,Object> formData) {
		return masterCmClCmmntPopDao.selectMasterCmClIssueIdInfoPop1(formData);
	}
	
	// 담당자정보저장
	@Transactional
	public String saveMasterCmClStndSettingPop(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClCmmntPopDao.saveMasterCmClStndSettingPop(formData, gridData);
	}
	
	// 담당자정보삭제
	@Transactional
	public String delMasterCmClStndSettingPop(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClCmmntPopDao.delMasterCmClStndSettingPop(formData, gridData);
	}
	
	// 수정사유
	public List<Map<String,String>> getMasterCmClStndSettingModifyPop(Map<String,Object> formData) {
		return masterCmClCmmntPopDao.selectMasterCmClStndSettingModifyPop(formData);
	}
}
