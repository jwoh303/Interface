package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

public interface MasterMpStLogisFeeListService {
	
	// 물류수수료(부서별)
	public List<Map<String,String>> getDeptList(Map<String,Object>  param);
	
	// 물류수수료(고객사별)
	public List<Map<String,String>> getBuyerList(Map<String,Object>  param);
	
	// 물류수수료(사유별)
	public List<Map<String,String>> getReasonList(Map<String,Object>  param);
}
