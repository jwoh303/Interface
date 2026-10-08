package com.koreab2b.mro.master.wmco.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmCoMgDao {
	
	// warehouse_code
	public String getForwarehouseCode(Map<String,Object> param);
	
	// warehouse_agnet
	public String getForwarehouseAgent(Map<String,Object> param);

}
