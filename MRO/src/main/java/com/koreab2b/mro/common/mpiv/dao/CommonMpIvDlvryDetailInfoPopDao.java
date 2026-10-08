package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface CommonMpIvDlvryDetailInfoPopDao {

	// 조회
	public Map<String, String> selectInfo(Map<String,String> formData);
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

}
