package com.koreab2b.mro.common.mdcm.service;

import java.util.Map;

public interface MasterMdCmItemDetailInfoModifyPopService {
	// 조회
	public Map<String,String> getList(Map<String,String>  formData);

	public String saveMasterMdCmItemDetailInfoDeleteNotAccept(Map<String,String> formData);
	
	public String saveMasterMdCmItemDetailInfoModifyPop(Map<String,String> formData);
	
	
}
