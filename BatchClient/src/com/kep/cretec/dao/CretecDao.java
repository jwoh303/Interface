package com.kep.cretec.dao;

import java.util.List;
import java.util.Map;

public interface CretecDao {

	/**
	 * 크레텍 인터페이스 속성값 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getCretecProperty(Map<String, String> pMap) throws Exception;

	/**
	 * 크레텍 발주 전송 대상 확인.
	 * @return
	 */
	public List<Map<String, String>> getPOList() throws Exception;

	/**
	 * 크레텍 발주 전송 결과 저장.
	 * @param iMap
	 * @throws Exception
	 */
	public void updatePOResult(Map<String, String> pMap) throws Exception;

	/**
	 * 크레텍 발주 상세 내역 호출
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getPODTList(Map<String, String> pMap) throws Exception;
	
	/**
	 * 크레텍 배송정보 확인 대상.
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> getDeliveryList(Map<String, String> pMap) throws Exception;
	
	/**
	 * PORS_ADD 이벤트 등록 여부확인
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public Integer checkPORSEvent(Map<String, String> pMap) throws Exception;
	
	/**
	 * PORS_ADD 이벤트 등록
	 * @param pMap
	 * @throws Exception
	 */
	public void insertPORSEvent(Map<String, String> pMap) throws Exception;
	
	/**
	 * get Item list for Checking.
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> getItemCheckList() throws Exception;

	/**
	 * Delete Cretec Item Info
	 * @throws Exception
	 */
	public void deleteCretecItemInfo() throws Exception;
	
	/**
	 * Insert Item info.
	 * @param pMap
	 * @throws Exception
	 */
	public void insertCretecItemInfo(Map<String, String> pMap) throws Exception;
	
	/**
	 * get Item Detail Info
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> getCretecItemDetailInfo(Map<String, String> pMap) throws Exception;
	
	/**
	 * 변경할 카탈로그 대상 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> getCretecTargetCatalogList() throws Exception;
	
	/**
	 * 알람목록 삭제
	 * @throws Exception
	 */
	public void deleteAlertList() throws Exception;
	/**
	 * 단종처리대상 저장.
	 * @param pMap
	 * @throws Exception
	 */
	public void insertCretecItemCloseAlertList(Map<String, String> pMap) throws Exception;
	/**
	 * 단종처리
	 * @throws Exceptino
	 */
	public void updateCretecItemClose(Map<String, String> pMap) throws Exception;
	/**
	 * 복원처리대상 저장
	 * @param pMap
	 * @throws Exception
	 */
	public void insertCretecItemRecoverAlertList(Map<String, String> pMap) throws Exception;
	/**
	 * 복원처리
	 * @throws Exceptino
	 */
	public void updateCretecItemRecover(Map<String, String> pMap) throws Exception;
	
	public void updateCretecItemStatus() throws Exception;

	public void insertCretecIv(Map<String, String> resultMap) throws Exception;

	public void insertCretecIvMail() throws Exception;
	
}