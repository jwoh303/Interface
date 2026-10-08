package com.koreab2b.mro.common.mdct.service;

import java.util.Map;

public interface MasterMdCtContractProgressPopService {
	// 조회
	public Map<String,String> getList(Map<String,String>  formData);
	
	//저장
	public String updateReasonData(Map<String,String> formData);
	
	//저장
	public String updateVendorData(Map<String,String> formData);
	
	//저장
	public String updateMasterData(Map<String,String> formData);
	
	//인증서
	public String signValue(String signSource);
}
