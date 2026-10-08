package com.kep.woojin.dao;

import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface WoojinAppStatusDao {
	
	/**
	 * sqlMapper 객체 반환
	 * @return
	 */
	public SqlMapClient getSqlMapper();

	/**
	 * 결재 완료건 (승인,반려,상신취소) 조회
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> selectBuyerAppInfo(Map<String, String> pMap) throws Exception;
}