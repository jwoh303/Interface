package com.koreab2b.phil.dao;

import java.util.List;
import java.util.Map;

public interface PhilPrmtDao {

	void insertPointBatch(List<Map<String, Object>> pointList) throws Exception;

}
