package com.kep.hans.dao;

import java.util.List;
import java.util.Map;

public interface HansDao {

	List<Map<String, Object>> selectHansPrTargetList() throws Exception;

	List<Map<String, Object>> selectPrList(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> selectHansGrList() throws Exception;

	void updatePrResult(Map<String, Object> paramMap) throws Exception;

	void updatePrError(Map<String, Object> errorMap) throws Exception;

	List<Map<String, Object>> selectHansPoStatusList() throws Exception;

	void updatePoStatusResult(Map<String, Object> paramMap) throws Exception;

	void updateHansGr(Map<String, Object> iMap)  throws Exception;

	List<Map<String, String>> selectMailInfo(Map<String, Object> errorMap)  throws Exception;

	void insertHansMail(Map<String, Object> errorMap) throws Exception;

	void updateIfProgress(List<Map<String, Object>> successList) throws Exception;

}
