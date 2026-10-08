package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

public interface SellerMpClTaxsheetIssueStateService {
	// 조회 (레거시)
	public List<Map<String,String>> getList(Map<String,String>  formData);

	// 조회 (리뉴얼)
	public List<Map<String,String>> getList_v2(Map<String,String>  formData);

}
