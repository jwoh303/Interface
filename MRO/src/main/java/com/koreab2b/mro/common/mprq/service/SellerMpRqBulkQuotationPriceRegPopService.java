package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.util.CommonUtil;

public interface SellerMpRqBulkQuotationPriceRegPopService {
	
	// 엑셀 업로드
	public String batchSellerMpRqBulkQuotationPriceReg(Map<String, String> param,List<Object> gridData);
	
	// 업로드 결과 확인
	public List<Map<String, String>> checkSellerMpRqBulkQuotationPriceReg(Map<String, String> param);

	// 품목 등록
	public String saveSellerMpRqBulkQuotationPriceReg(Map<String, String> pMap);

}
