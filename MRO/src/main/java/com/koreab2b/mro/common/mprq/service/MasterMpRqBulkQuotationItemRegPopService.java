package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.util.CommonUtil;

public interface MasterMpRqBulkQuotationItemRegPopService {
	
	// 엑셀 업로드
	public String batchMasterMpRqBulkQuotationItemReg(Map<String, String> param,List<Object> gridData);
	
	// 업로드 결과 확인
	public List<Map<String, String>> checkMasterMpRqBulkQuotationItemReg(Map<String, String> param);

	// 품목 등록
	public String saveMasterMpRqBulkQuotationItemReg(Map<String, String> pMap);

}
