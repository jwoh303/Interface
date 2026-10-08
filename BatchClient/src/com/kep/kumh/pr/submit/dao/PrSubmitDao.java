package com.kep.kumh.pr.submit.dao;

import java.util.List;
import java.util.Map;

public interface PrSubmitDao {

	public List<Map<String, String>> selectTargetList() throws Exception;

	public List<Map<String, String>> selectPrList(Map<String, String> map) throws Exception;

	public void updateResultData(Map<String, String> pMap) throws Exception;

	public void insertMail(Map<String, String> pMap) throws Exception;

	public List<Map<String, String>> selectMailInfo(Map<String, String> pMap) throws Exception;

	

}
