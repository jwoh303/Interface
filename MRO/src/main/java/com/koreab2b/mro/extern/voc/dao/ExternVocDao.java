package com.koreab2b.mro.extern.voc.dao;

import java.util.List;
import java.util.Map;

public interface ExternVocDao {

	/**
	 * get list for referer check Domain
	 * @return
	 */
	public List<Map<String, String>> selectDomainKeywordList();
	
	/**
	 * insert / update voc Info
	 * @param pMap
	 * @return
	 */
	public String insertExternVoc(Map<String, String> pMap);
	
	/**
	 * get list of requester
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> selectExternVocList(Map<String, String> pMap);
	
	public int selectExternVocCount(Map<String, String> pMap);
}
