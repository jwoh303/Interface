package com.koreab2b.mro.buyer.mdam.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface BuyerMdAmGiCowayDao {

	// 조회
	public List<Map<String, String>> selectList(Map<String, String> formData);

	// 저장
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String, String> formData, List<Object> gridData);

	public List<Map<String, String>> getPrDetail(Map<String, String> param);

	public List<Map<String, String>> getReqUserInfo(Map<String, String> map);

	public List<Map<String, String>> getRecvUserInfo(Map<String, String> map);

	public List<Map<String, String>> getPassUserInfo(Map<String, String> map);

	public List<Map<String, String>> getReqDeptInfo(Map<String, String> map);

	public List<Map<String, String>> getHqUserInfo(Map<String, String> map);

	public HashMap<String, String> getOriPrInfo(Map<String, String> map);

	public List<Map<String, String>> getGiReqExcelList(Map<String, Object> map);
	
	/**
	 * 출고지시 엑셀 자료를 삭제한다.
	 * @param pMap
	 */
	public void deleteGsysDeliveryDisplaySum(Map<String, String> pMap);
	
	/**
	 * 출고지시 조회를 저장한다.
	 * @param pMap
	 */
	public void insertGsysDeliveryDisplay(Map<String, String> pMap);
	
	/**
	 * 출고지시 엑셀 자료를 저장한다.
	 * @param pMap
	 */
	public void insertGsysDeliveryDisplaySum(Map<String, String> pMap);
	
	/**
	 * 저장한 내용기준으로 pr정보를 세팅한다.
	 * @param pMap
	 */
	public void updateGsysDeliveryDisplayPrInfo(Map<String, String> pMap);
	
	/**
	 * 출고지시 조회 
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> selectGsysDeliveryDispaly(Map<String, String> pMap);
	
	/**
	 * 출고지시 조회를 일괄 저장한다.
	 * @param pList
	 */
	public void insertGsysDeliveryDisplayBatch(List<Map<String, String>> pList);
	
	public void insertGsysDeliveryDisplaySumBatch(List<Map<String, String>> pList);
	
	public void updateGsysDeliveryDisplaySumPrInfo(Map<String, String> pMap);
	
	public List<Map<String, String>> selectGsysDeliveryDispalySum(Map<String, String> pMap);
	
	public void updateExcelInfo(List<Map<String, String>> pList);
	
	/**
	 * 출고지시 팝업 내역 조회.
	 * @param pMap
	 * @return
	 */
	public Map<String, String> selectGiDetailInfo(Map<String, String> pMap);
}
