package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface CommonInfoService {	 
	
	public List<Map<String,String>> loginProcess(Map<String,String>  pMap);
	
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
	
	
	public List<Map<String, String>> getFieldNames();
	
	/**
	 * 사용자권한조회(도안관리용)
	 * @param formData
	 * @return
	 */
	public Map<String,String> getUserRole(Map<String,String>  pMap);
	
	public String excelFileUpload(HttpServletRequest request, 
			ModelMap pModel, 
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
			@RequestParam Map<String, String> pMap);
	public String excelFileUpload(HttpServletRequest request, 
			ModelMap pModel, 
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
			@RequestParam Map<String, String> pMap, String sheetNum);

	// voc 유형별 담당자
	public Map<String, String> getVOCUser(Map<String, String> pMap);

	public Map<String, String> getFileUploadDetailMsds(Map<String, String> pMap);

	/**
	 * ICOMATCH 테이블에서 파일 완전 삭제 (DELETE)
	 * @param pMap - D_DOC_NO, D_DOC_SEQ 포함
	 */
	public void removeIcomatch(Map<String, String> pMap);
	
	// 파일 다운로드 시 허용 리스트 목록 조회
	public int getFileUploadAtYnCnt(Map<String, String> pMap);

}
