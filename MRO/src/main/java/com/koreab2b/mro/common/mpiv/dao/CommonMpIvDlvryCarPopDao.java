package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface CommonMpIvDlvryCarPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap);
	

	// 저장
	public String saveCommonMpIvDlvryCarPop(Map<String,String>  pMap);

}
