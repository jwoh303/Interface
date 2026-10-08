package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpStLogisFeeListDao {
	
	// 물류수수료(부서별)
	public List<Map<String,String>> selectDeptList(Map<String,Object> param);
	
	// 물류수수료(고객사별)
	public List<Map<String,String>> selectBuyerList(Map<String,Object> param);
	
	// 물류수수료(사유별)
	public List<Map<String,String>> selectReasonList(Map<String,Object> param);
}
