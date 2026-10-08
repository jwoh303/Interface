package com.koreab2b.mro.master.wmco.service;

import java.util.List;
import java.util.Map;

public interface MasterWmCoMgService {
	
	// warehouse_code 조회
	public String getForwarehouseCode(Map<String,Object>  pMap);
	
	// warehouse_agent 조회
	public String getForwarehouseAgent(Map<String,Object>  pMap);

}
