package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBulkQuotationProceListDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 동일 단가 적용
	public String updatePrice(Map<String, Object> param);	
	
	// DM 팝업 조회
	public List<Map<String, String>> selectDmList(Map<String, String> param);

	// 엑셀다운로드
	public List<Map<String, String>> selectExcelList(Map<String, Object> param);

	// 협력사 목록
	public List<Map<String, String>> selectAgentList(Map<String, Object> param);
	
}
