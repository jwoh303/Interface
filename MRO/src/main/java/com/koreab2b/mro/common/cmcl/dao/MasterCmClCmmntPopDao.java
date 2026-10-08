package com.koreab2b.mro.common.cmcl.dao;

import java.util.List;
import java.util.Map;

public interface MasterCmClCmmntPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 조회
	public List<Map<String,String>> selectMasterCmClStndSettingPop(Map<String,Object> formData);

	// 미매핑 세금계산서 조회 팝업
	public List<Map<String,String>> selectMasterCmClIssueIdInfoPop(Map<String,Object> formData);
	
	// 미매핑 세금계산서 조회 팝업 (상단 그리드 조회)
	public List<Map<String,String>> selectMasterCmClIssueIdInfoPop1(Map<String,Object> formData);
	
	// 담당자 저장
	public String saveMasterCmClStndSettingPop(Map<String,String>  formData, List<Object> gridData);

	// 담당자 삭제
	public String delMasterCmClStndSettingPop(Map<String,String>  formData, List<Object> gridData);
	
	// 수정사유
	public List<Map<String,String>> selectMasterCmClStndSettingModifyPop(Map<String,Object> formData);
	
}
