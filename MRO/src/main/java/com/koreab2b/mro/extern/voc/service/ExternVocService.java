package com.koreab2b.mro.extern.voc.service;

import java.util.List;
import java.util.Map;

public interface ExternVocService {

	/**
	 * get list for referer check Domain
	 * @return
	 */
	public List<Map<String, String>> getDomainKeywordList();
	
	/**
	 * insert / update voc Info
	 * @param pMap
	 * @return
	 */
	public String saveExternVoc(Map<String, String> pMap);
	
	/**
	 * get list of requester
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> getExternVocList(Map<String, String> pMap);

	public int getExternVocCount(Map<String, String> pMap);
}
