package com.kep.kumh.pr.submit.dao;

import java.util.List;
import java.util.Map;

public interface GrLoadDao {

	public List<Map<String, String>> selectPlantList() throws Exception;

	public void insertKumhGr(Map<String, String> arrMap) throws Exception;

}
