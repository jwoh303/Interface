package com.koreab2b.mro.common.mdcm.service;

import java.util.Map;

public interface MasterMdCmItemDetailInfoViewPopService {
	// 조회
	public Map<String,String> getList(Map<String,String>  formData);

	public String procMasterMdCmItemDetailInfoViewPop(Map<String,String> formData);
}
