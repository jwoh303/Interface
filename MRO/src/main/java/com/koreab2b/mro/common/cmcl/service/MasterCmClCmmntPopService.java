package com.koreab2b.mro.common.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClCmmntPopService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 담당자정보조회
	public List<Map<String,String>> getMasterCmClStndSettingPop(Map<String,Object>  formData);
	// 미매핑 세금계산서 조회 팝업
	public List<Map<String,String>> getMasterCmClIssueIdInfoPop(Map<String,Object>  formData);
	// 미매핑 세금계산서 조회 팝업 (상단 그리드)
	public List<Map<String,String>> getMasterCmClIssueIdInfoPop1(Map<String,Object>  formData);
	// 담당자정보저장
	public String saveMasterCmClStndSettingPop(Map<String,String>  formData, List<Object> gridData);
	// 담당자정보삭제
	public String delMasterCmClStndSettingPop(Map<String,String>  formData, List<Object> gridData);
	// 수정사유
	public List<Map<String,String>> getMasterCmClStndSettingModifyPop(Map<String,Object>  formData);

}
