package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

public interface MasterMpStPriceAdjustmentService {
	
	// 견적 최저가 예외 현황
	public List<Map<String,String>> getMasterMpStQuotExceptionList(Map<String,Object>  param);
	
	// 견적 최저가 예외 상세
	public List<Map<String,String>> getMasterMpStQuotExceptionDetailList(Map<String,Object>  param);
	
	// 주문 단가조정 현황
	public List<Map<String,String>> getMasterMpStPoPriceAdjustList(Map<String,Object>  param);
	
	// 주문 단가조정 상세
	public List<Map<String,String>> getMasterMpStPoPriceAdjustDetailList(Map<String,Object>  param);
}
