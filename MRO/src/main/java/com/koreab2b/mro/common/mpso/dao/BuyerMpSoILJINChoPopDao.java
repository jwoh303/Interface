package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoILJINChoPopDao {

	// 조회
	public List<Map<String,String>> selectLegacyUserIdList(Map<String,String> formData);

	public List<Map<String,String>> selectIljinProject(Map<String,String>  pMap);
	
	public Map<String, String> selectItemItemInfo(Map<String,String> pMap);
}
