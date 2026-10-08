package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpClTaxsheetIssueStateDao {

	// 조회 (레거시)
	public List<Map<String,String>> selectList(Map<String,String> formData);

	// 조회 (리뉴얼)
	public List<Map<String,String>> selectList_v2(Map<String,String> formData);

}
