package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqQuotaProceStateAdminService {
	public List<Map<String,String>> getList(Map<String,String>  formData);
	//신규품목 등록현황조회
	public List<Map<String,String>> getSourcList(Map<String,String>  formData);
	//신규발주현황
	public List<Map<String,String>> getNewPoList(Map<String,String>  formData);	
}
