package com.kep.woojin.dao;

import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface KepAppStatusDao {

	public SqlMapClient getSqlMapper();
	
	/**
	 * 처리 대상의 진행상태 확인.
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectAppTargetList() throws Exception;
	
	/**
	 * 처리대상의 이력을 수정함.
	 * @param pMap
	 * @throws Exception
	 */
	public void updateAppTargetInfo(Map<String, String> pMap) throws Exception;
	
	/**
	 * 처리대상의 결재 상태를 변경함.
	 * @param pMap
	 * @throws Exception
	 */
	public void updateAppStatus(Map<String, String> pMap) throws Exception;
}
