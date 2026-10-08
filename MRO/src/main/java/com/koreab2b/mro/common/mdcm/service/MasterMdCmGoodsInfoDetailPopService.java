package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmGoodsInfoDetailPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 속성정보 조회
	public List<Map<String,String>> getList2(Map<String,String>  formData);
	
	// 매핑정보 조회
	public List<Map<String,String>> getList3(Map<String,String>  formData);

}
