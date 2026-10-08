package com.koreab2b.jwph.service;

import java.util.Map;

public interface JwPhService {
	
	void insertJwPhPoData(Map<String, Object> pMap) throws Exception;

	void insertJwPhReData(Map<String, Object> pMap) throws Exception;
}
