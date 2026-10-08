package com.koreab2b.mro.seller.mpds.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpDsOrderProgressManageDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	//납품실적등록
	public String updateSelectedDataDiReg(Map<String,String>  formData, List<Object> gridData);
	
	// 납품실적취소	
	public String updateSelectedDataDiCancel(Map<String,String>  formData, List<Object> gridData);
	
	// 거래명세서삭제
	public String updateSelectedDataIvCancel(Map<String,String>  formData, List<Object> gridData);
	
}
