package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClLogisRateDetailService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	public List<Map<String,String>> getList_v2(Map<String,Object>  param);

}
