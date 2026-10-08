package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIvDivsnDeliveryPlanAlterPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  _pMap);
	
	public String updateMasterMpIvDivsnDeliveryPlanAlterPop(Map<String,String> _pMap);

}
