package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

public interface CommonCoCoBuyerCurrencyPopService {
	//리스트조회
	public List<Map<String,String>> getCommonCoCoBuyerCurrencyPop(Map<String,Object>  pMap);
	// 생성
	public String saveCommonCoCoBuyerCurrencyPop(Map<String,String>  formData, List<Object> gridData);
	//삭제
	public String deleteCommonCoCoBuyerCurrencyPop(Map<String,String>  formData, List<Object> gridData);
}
