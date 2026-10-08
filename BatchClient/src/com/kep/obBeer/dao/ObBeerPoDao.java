package com.kep.obBeer.dao;

import java.util.List;
import java.util.Map;

public interface ObBeerPoDao {

	void insertObBeerPo(Map<String, String> resultMap) throws Exception;

	List<Map<String, String>> selectPoStatusTargetList() throws Exception;

	void updateObAppSubmitResult(Map<String, String> iMap) throws Exception;

	List<Map<String, String>> selectIvSendTargetList()  throws Exception;

	void updateObIvSendResult(Map<String, String> iMap)  throws Exception;

	
	
	

}
