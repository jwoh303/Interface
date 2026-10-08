package com.kep.taxbill.dao;

import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface TaxBillMyListDao {
	
	/**
	 * SqlMapClient 획득.
	 * @return
	 */
	public SqlMapClient getSqlMapClient();

	/**
	 * 미처리함 조회 조건 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectSearchMyListCondition() throws Exception;
	
	/**
	 * 세금계산서 미처리함 조회결과 저장.
	 * @param pMap
	 * @throws Exception
	 */
	public void insertTaxBillMyListInfo(Map<String, Object> pMap) throws Exception;
	
	/**
	 * 세금계산서 미처리함 조회결과 수정.
	 * @param pMap
	 * @throws Exception
	 */
	public void updateTaxBillMyListInfo(Map<String, Object> pMap) throws Exception;
	
	/**
	 * 미처리함 저장여부 확인.
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> checkMyListInfo(Map<String, Object> pMap) throws Exception;
	
	/**
	 * Dti 상태값 정보 여부 확인
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectDtiStatusInfoCount(Map<String, Object> pMap) throws Exception;

	/**
	 * Dti 상태값 정보 저장.
	 * @param pMap
	 * @throws Exception
	 */
	public void insertTaxBillDtiStatusInfo(Map<String, Object> pMap) throws Exception;
}