package com.koreab2b.jwph.dao;

import java.util.Map;

public interface JwPhDao {

	void insertJwPoData(Map<String, Object> pMap) throws Exception;

	void insertJwReData(Map<String, Object> pMap) throws Exception;

}
