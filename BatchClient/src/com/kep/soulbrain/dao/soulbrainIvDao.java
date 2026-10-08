package com.kep.soulbrain.dao;

import java.util.List;
import java.util.Map;

public interface soulbrainIvDao {

	void updateIvResult(Map<String, String> pMap) throws Exception;

	List<Map<String, String>> selectTargetHdList() throws Exception;

	List<Map<String, String>> selectTargetDtList(Map<String, String> map) throws Exception;

	void saveIvResult(Map<String, String> resultMap) throws Exception;

}
