package com.koreab2b.mro.buyer.mdam.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface BuyerMdAmGiCowayService {
	// 조회
	public List<Map<String, String>> getList(Map<String, String> formData);

	// 저장
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String, String> formData, List<Object> gridData);

	public List<Map<String, String>> getPrDetail(Map<String, String> map);

	/**
	 * 요청자정보
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, String>> getReqUserInfo(Map<String, String> map);

	/**
	 * 서비스 받는 조직 정보
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, String>> getRecvUserInfo(Map<String, String> map);

	/**
	 * 결재권자 리스트
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, String>> getPassUserInfo(Map<String, String> map);

	public List<Map<String, String>> getReqDeptInfo(Map<String, String> map);

	public List<Map<String, String>> getHqUserInfo(Map<String, String> map);

	public HashMap<String, String> getOriPrInfo(Map<String, String> map);

	public List<Map<String, String>> getGiReqExcelList(Map<String, Object> paramMap);
	
	public void delGsysDeliveryDispaly(Map<String, String> pMap);
	
	public void setGsysDeliveryDispaly(Map<String, String> pMap);
	
	public void setGsysDeliveryDispalySum(Map<String, String> pMap);
	
	public void setGsysDeliveryDispalyPrInfo(Map<String, String> pMap);
	
	public List<Map<String, String>> getGsysDeliveryDispaly(Map<String, String> pMap);
	
	public void setGsysDeliveryDispalyBatch(List<Map<String, String>> pList);
	
	public void setGsysDeliveryDispalySumBatch(List<Map<String, String>> pList);
	
	public void setGsysDeliveryDispalySumPrInfo(Map<String, String> pMap);
	
	public List<Map<String, String>> getGsysDeliveryDispalySum(Map<String, String> pMap);
	
	/**
	 * 엑셀자료 테이블에 업데이트
	 * @param pList
	 */
	public void updateExcelInfo(List<Map<String, String>> pList);
	
	/**
	 * 출고지시 내역 상세 팝업데이터 조회
	 * @param pMap
	 * @return
	 */
	public Map<String, String> getGiDetailInfo(Map<String, String> pMap);
}
