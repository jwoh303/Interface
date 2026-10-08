package com.kep.wonbiz.dao;

import java.util.List;
import java.util.Map;

public interface WonbizDao {

	List<Map<String,Object>> selectWonbizTargetList() throws Exception;

	void updateSubmitResult(Map<String, Object> iMap)  throws Exception;


}
