package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfCowayDoctorService {

	/**
	 * 닥터AS내역 조회
	 * @param pMap
	 * @return
	 */
	public List<Map<String,String>> getDoctorAsList(Map<String, Object> pMap);
	
	/**
	 * 닥터AS내역 임시저장 내역 삭제.
	 * @param gridData
	 * @return
	 */
	public String delMasterMpIfCowayDoctorAsList(List<Object> gridData);
	
	/**
	 * 닥터AS내역 임시저장
	 * @param gridData
	 * @return
	 */
	public String batchMasterMpIfCowayDoctorAsList(List<Object> gridData);
	
	/**
	 * 전송대기 상태로 변경
	 * @param gridData
	 * @return
	 */
	public String sendMasterMpIfCowayDoctorAsList(List<Object> gridData);
	
	/**
	 * 비고를 저장함.
	 * @param gridData
	 * @return
	 */
	public String saveMasterMpIfCowayDoctorAsList(List<Object> gridData);
}
