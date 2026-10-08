package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBulkQuotationProceListService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 동일 단가 적용 
	public String setSamePrice(Map<String, Object> param);

	// DM 메일발송 이력 팝업
	public List<Map<String, String>> getDmPop(Map<String, String> pMap);

	// 엑셀 다운로드
	public List<Map<String, String>> getExcelList(Map<String, Object> param);

	// 협력사 목록
	public List<Map<String, String>> getAgentList(Map<String, Object> pMap);

}
