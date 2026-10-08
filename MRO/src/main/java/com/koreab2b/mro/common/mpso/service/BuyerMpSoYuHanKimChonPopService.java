package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoYuHanKimChonPopService {
	// 조회
	public List<Map<String,String>> getLegacyUserId(Map<String,String>  formData);
	public List<Map<String,String>> getRefHdInfo(Map<String,String>  formData);
	 
	
	public String  getUserNameLoc(Map<String,String>  formData);
	public String  getUserAddressLoc(Map<String,String>  formData);
	public String  getCenterCode(Map<String,String>  formData);
	public String  getprofitSegmentCode(Map<String,String>  formData);
	
	public String  saveBuyerYuhanRetUpdate(Map<String,String>  formData);

}
