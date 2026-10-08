package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIvAgntcmpyDeliveryRecordRegPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	// 긴급납기
	public List<Map<String,String>> selectMasterMpIvUrgentManagementPop(Map<String,Object>  formData);
	
}
