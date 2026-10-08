package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface CommonInfoDao {	 
	
	public List<Map<String,String>> loginProcess(Map<String,String> pMap);
	
	public List<Map<String,String>> ajaxCombo(Map<String, String> pMap);
	public List<Map<String,String>> ajaxQueryIdCombo(String queryId);
	public List<Map<String,String>> ajaxQueryIdCombo(Map<String, String> pMap);
	public List<Map<String,String>> ajaxQueryIdComboNoCache(Map<String, String> pMap);
	
	public String fileUpload(FileUploadForm uploadForm, Map<String,String> _pList);
	public String imageFileUpload(FileUploadForm uploadForm, Map<String,String> _pList);
	
	public List<Map<String,String>> getFileUploadList(Map<String,String>  pMap);
	public void removeFileInfo(Map<String, String> pMap);
	public Map<String,String> getFileUploadDetail(Map<String, String> pMap);
	public List<Map<String, String>> getFileUploadDetail_v2(Map<String, String> pMap);
	public List<Map<String, String>> getFileUploadDetailMulti_v2(Map<String, Object> pMap);
	
	
	/**
	 * 필드명/코드 취득
	 */
	public List<Map<String,String>> selectFieldNames();

	/**
	 * 사용자권한조회(도안관리용)
	 * @param formData
	 * @return
	 */
	public Map<String,String> selectUserRole(Map<String,String> formData);

	/**
	 * 거래명세서 레포트 ID 조회
	 * @param pMap
	 * @return
	 */
	public String selectRptUrl(Map<String,String> pMap);

	/**
	 * VOC 유형별 담당자 ID 조회
	 * @param pMap
	 * @return
	 * */
	public Map<String, String> getVOCUser(Map<String, String> pMap);
	/**
	 * 파일 다운로드 MSDS
	 * @param pMap
	 * @return
	 * */
	public Map<String, String> getFileUploadDetailMsds(Map<String, String> pMap);

	/**
	 * ICOMATCH 테이블에서 파일 완전 삭제 (DELETE)
	 * @param pMap - D_DOC_NO, D_DOC_SEQ 포함
	 */
	public void removeIcomatch(Map<String, String> pMap);

	
	public int getFileUploadAtYnCnt(Map<String, String> pMap);

}
