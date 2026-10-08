package com.koreab2b.rfq.dao;

import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface GRP_MM1460_Dao {

	/**
	 * SqlMapClient 객체 리천
	 * @return
	 */
	public SqlMapClient getSqlMapClient();
	
	/**
	 * Kolon Items 상태 변경
	 * @param pMap
	 * @throws Exception
	 */
	public void updateKolonItems(Map<String,String> pMap) throws Exception;
	
	/**
	 * Kolon Items 데이터 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectKolonItems() throws Exception;
}
