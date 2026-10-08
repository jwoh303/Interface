package com.koreab2b.mro.master.mpds.service;

import java.util.List;
import java.util.Map;

public interface MasterMpDsUserService {

	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 저장
	public int updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
