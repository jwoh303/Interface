package com.koreab2b.inv.dao;

import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

public interface GRP_MM0710_Dao {
	
	public SqlMapClient getSqlMapClient();

	/**
	 * 직납데이터에 대해서 거래명세서 헤더 정보를 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> selectIVHeader(Map<String, String> pMap) throws Exception;
	
	/**
	 * 직납 데이터에 대해서 거래명세서 라인 정보를 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> selectIKDetail(Map<String, String> pMap) throws Exception;

	/**
	 * TR 데이터에 대해서 거래명세서 헤더 정보를 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> selectIKHeader(Map<String, String> pMap) throws Exception;
	
	/**
	 * TR 데이터에 대해서 거래명세서 라인 정보를 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> selectIVDetail(Map<String, String> pMap) throws Exception;
	
	/**
	 * 직납 데이터에 대해서 전송이 성골할 경우 전송 결과를 저장
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int saveIVLegacyIvSerial(Map<String, String> pMap) throws Exception;
	
	/**
	 * TR 데이터에 대해서 전송이 성공한 경우 전송 결과를 저장
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int saveIKLegacyIvSerial(Map<String, String> pMap) throws Exception;
	
	/**
	 * 전송한 거래명세서 헤더 정보 이력을 저장
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int saveLIKP(Map<String, String> pMap) throws Exception;
	
	/**
	 * 전송한 거래명세서 라인 정보 이력을 저장
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int saveLIPS(Map<String, String> pMap) throws Exception;
	
	/**
	 * 납품서 인터페이스 대상 확인.
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> getIvTargets() throws Exception;
	
	/************* 추가작업 ********************/
	/**
	 * update IF_KOLON_LIKP
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateIF_KOLON_LIKP_ALL(Map<String, String> pMap) throws Exception;
	/**
	 * update IF_KOLON_LIKP
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateIF_KOLON_LIKP_SUCCESS(Map<String, String> pMap) throws Exception;
	/**
	 * update IF_KOLON_LIKP
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateIF_KOLON_LIKP_FAIL(Map<String, String> pMap) throws Exception;
	/**
	 * update IF_KOLON_LIPS
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateIF_KOLON_LIPS(Map<String, String> pMap) throws Exception;
	/**
	 * 전송대상 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>>selectSendList(Map<String, String> pMap) throws Exception;
	/**
	 * LIKP 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>>selectLikpList(Map<String, String> pMap) throws Exception;
	/**
	 * LIPS 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>>selectLipsList(Map<String, String> pMap) throws Exception;
}
