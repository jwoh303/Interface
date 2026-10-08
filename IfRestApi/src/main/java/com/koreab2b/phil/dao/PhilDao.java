package com.koreab2b.phil.dao;

import java.util.Map;

public interface PhilDao {

	void insertIfLog(Map<String, Object> logMap) throws Exception;

}
