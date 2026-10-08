package com.kep.jwph.dao;

import java.util.List;
import java.util.Map;

public interface JwphDao {

	List<Map<String, String>> selectPoStatusTargetList() throws Exception;

	void updateJwphAppSubmitResult(Map<String, String> iMap)  throws Exception;

	List<Map<String, String>> selectItemTargetList() throws Exception;

	void updateJwphItSubmitResult(Map<String, String> resultMap) throws Exception;


}
