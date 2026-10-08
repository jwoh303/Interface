package com.kep.josu.dao;

import java.util.Map;

public interface JosuPoDao {

	void insertPohd(Map<String, Object> map) throws Exception;

	void insertPodt(Map<String, Object> map) throws Exception;

	void updatePohd(Map<String, Object> map) throws Exception;

	void updatePodt(Map<String, Object> map) throws Exception;

	int selectPoCnt(Map<String, Object> map) throws Exception;

	int selectHdCnt(Map<String, Object> poSelectMap) throws Exception;

	int selectDtCnt(Map<String, Object> poSelectMap) throws Exception;

	int selectJosunPoCnt() throws Exception;

}
