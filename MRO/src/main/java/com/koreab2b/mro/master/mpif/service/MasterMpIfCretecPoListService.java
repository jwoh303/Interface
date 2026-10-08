package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfCretecPoListService {

	// 리스트조회
	public List<Map<String, String>> getList(Map<String, Object> pMap);

	//크레텍 발주 리스트 상세 팝업
	public List<Map<String,String>> getMpIfCretecPoListPop(Map<String, Object> pMap);

	//크레텍 발주 상세 팝업 저장
	public String submitMpIfCretecPoListPop(Map<String, String> pMap);

}
