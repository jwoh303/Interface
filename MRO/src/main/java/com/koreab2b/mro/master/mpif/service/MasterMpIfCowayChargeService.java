package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfCowayChargeService {
	
	/**
	 * 코웨이 수수료입력 내역 조회.
	 * @param pMap
	 * @return
	 */
	public List<Map<String,String>> getCowayChargeList(Map<String, Object> pMap);
	
	/*
	 * 수수료 전송 대상 엑셀 업로드
	 */
	public String batchMasterMpIfCowayChargeList(List<Object> gridData);
	
	/**
	 * 일괄 업로드 내역 삭제 처리.
	 * @param gridData
	 * @return
	 */
	public String delMasterMpIfCowayChargeList(List<Object> gridData);
}
