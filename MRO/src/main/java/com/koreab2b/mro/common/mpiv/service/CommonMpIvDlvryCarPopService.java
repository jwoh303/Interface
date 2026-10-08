package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface CommonMpIvDlvryCarPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  pMap);

	// 저장
	public String saveCommonMpIvDlvryCarPop(Map<String,String>  pMap);
	
}
