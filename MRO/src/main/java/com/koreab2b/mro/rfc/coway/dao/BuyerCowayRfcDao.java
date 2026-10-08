package com.koreab2b.mro.rfc.coway.dao;

import java.util.List;
import java.util.Map;

public interface BuyerCowayRfcDao {
	/**
	 * JCO connection
	 * 
	 * @param paramMap
	 */
	public void getRfcConnection(Map<String, String> paramMap);

	/**
	 * 수수료 대표코드 및 자재 마스터 전송
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<Map<String, String>> execZmmClsiteGirequestDisplay(Map<String, String> paramMap);

	/**
	 * 지급요청한 문서번호가 기준으로 요청 상태 확인
	 * 
	 * @param paramMap
	 * @param pList
	 * @return
	 */
	public List<Map<String, String>> execZmmGsysReqStatusDisplay(Map<String, String> paramMap, List<Map<String, String>> pList);

	/**
	 * 지급요청 체크 및 저장
	 * 
	 * @param paramMap
	 * @return
	 */
	public Map<String, String> execZmmGsysGirequestCheck(Map<String, String> paramMap);

	/**
	 * 반납 요청 저장 전 송장처리 체크
	 * 
	 * @param paramMap
	 * @param pList
	 * @return
	 */
	public Map<String, String> execZmmGsysRerequestIvCheck(Map<String, String> paramMap, List<Map<String, String>> pList);

	/**
	 * 반납 요청 체크 및 저장
	 * 
	 * @param paramMap
	 * @param pList
	 * @return
	 */
	public Map<String, String> execZmmGsysRerequestCheck(Map<String, String> paramMap, List<Map<String, String>> pList);

	/**
	 * 재고관리 품목의 경우 지급(출고)확정 - 한건씩 처리하는 경우
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<Map<String, String>> execZmmGsysDeliveryCheck(Map<String, String> paramMap);

	/**
	 * 재고관리 품목의 경우 지급(출고)확정 - 한건 이상의 대량 데이터 처리하는 경우
	 * 
	 * @param paramMap
	 * @return
	 */
	public Map<String, String> execZmmGsysDeReCheck(Map<String, String> paramMap);

	/**
	 * 재고관리 품목 조회
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<Map<String, String>> execZmmGsysDeliveryDisplay(Map<String, String> paramMap);

	/**
	 * 월별 지급 신청 내역
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<Map<String, String>> execZmmGsysReqList(Map<String, String> paramMap);

	/**
	 * 지급(출고)조회 엑셀다운로드용
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<Map<String, String>> execZmmGsysDeliveryDisplaySum(Map<String, String> paramMap);

	/**
	 * 재고관리 품목 출고, 반납조회
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<Map<String, String>> execZmmGsysDeRerDisplay(Map<String, String> paramMap);

}
