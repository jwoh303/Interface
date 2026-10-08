package com.kep.soulbrain.dao;

import java.util.List;
import java.util.Map;

public interface soulbrainMsdsDao {

	List<Map<String, String>> selectTargetList() throws Exception;

	void updateMsdsResult(Map<String, String> resultMap) throws Exception;

	void saveErrLog(Map<String, String> resultData) throws Exception;

	void updateReSendList(Map<String, String> resultMap) throws Exception;


}
