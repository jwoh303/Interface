package com.koreab2b.mro.master.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIvDeliveryRecordManageDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

}
