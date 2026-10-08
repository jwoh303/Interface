package com.koreab2b.mro.common.mdct.dao;

import java.util.Map;

public interface MasterMdCtContractProgressPopDao {

	// 조회
	public Map<String,String> selectList(Map<String,String> formData);
	
	//저장
	public String updateReasonData(Map<String,String> formData);
	
	//저장
	public String updateVendorData(Map<String,String> formData);
	
	//저장
	public String updateMasterData(Map<String,String> formData);
}
