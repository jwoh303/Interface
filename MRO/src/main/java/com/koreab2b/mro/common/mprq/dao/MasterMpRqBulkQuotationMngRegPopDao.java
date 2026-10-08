package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBulkQuotationMngRegPopDao {
	
	// 엑셀 업로드(고객사용)
	public String batchdata(Map<String, String> param, List<Object> gridData);
	
	// 업로드 결과 확인
	public List<Map<String, String>> selectdata(Map<String, String> param);

	// 품목등록
	public String savedata(Map<String, String> param);

}
