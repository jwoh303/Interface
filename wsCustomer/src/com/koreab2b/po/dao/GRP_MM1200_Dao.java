package com.koreab2b.po.dao;

import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface GRP_MM1200_Dao {
	public SqlMapClient getSqlMapClient();
	
	/**
	 * 납품예정정보 조회
	 * @return
	 */
	public List<Map<String, String>> selectDeliveryList() throws Exception;
	
	/**
	 * 전송대기 데이터 확인
	 * @return
	 */
	public int updateReadyData() throws Exception;
	
	/**
	 * 전송후 데이터 처리
	 * @return
	 */
	public int updateSendData(Map<String, String> pMap) throws Exception;
}
