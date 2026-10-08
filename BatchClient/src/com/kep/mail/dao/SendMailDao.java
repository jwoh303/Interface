package com.kep.mail.dao;

import java.util.List;
import java.util.Map;

public interface SendMailDao {

	/*
	 * 전송대상 조회 - 매출번호 기준으로 정산 담당자 정보 획득
	 */
	public List<Map<String, String>> getTargetList() throws Exception;
	
	/**
	 * 엑셀 자료 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getExcelDataList(Map<String, String> pMap) throws Exception;
	
	/**
	 * 처리결과 저장
	 * @param pMap
	 * @throws Exception
	 */
	public void setResult(Map<String, String> pMap) throws Exception;
	
	/**
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> getCretecItemTargetList() throws Exception;
	
	/**
	 * 코웨이 폐기 발주 조회기간 확인
	 * @return 기간, 메일 수신자.
	 * @throws Exception
	 */
	public List<Map<String, String>> selectCowayScrapRecvMailList() throws Exception;
	
	/**
	 * 코웨이 폐기 발주 목록
	 * @param iMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCowayScrapList(Map<String, String> iMap) throws Exception;
}