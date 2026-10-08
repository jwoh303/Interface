package com.koreab2b.mro.common.mdcm.dao;

import java.util.Map;

public interface MasterMdCmItemDetailInfoViewPopDao {

	// 조회
	public Map<String,String> selectList(Map<String,String> formData);

	public String updateMasterMdCmItemDetailInfoViewPop(Map<String,String> formData);
}
