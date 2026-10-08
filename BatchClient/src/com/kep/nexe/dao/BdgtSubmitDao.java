package com.kep.nexe.dao;

import java.util.List;
import java.util.Map;

public interface BdgtSubmitDao {

	List<Map<String, String>> selectNexeAccountCdList() throws Exception;

	void insertNexeBudget(Map<String, Object> resultMap) throws Exception;

}
