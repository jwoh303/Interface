package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface CommonMpIvAgrmntDetailPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	public String selectMailYn(Map<String,String> formData);

	public String insertCommonCoCoScmActionDetailPop(Map<String,String> formData);
	
}
