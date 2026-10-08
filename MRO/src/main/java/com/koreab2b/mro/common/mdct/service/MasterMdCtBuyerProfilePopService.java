package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface MasterMdCtBuyerProfilePopService {
	
	// 팝업 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 팝업 매핑 조회
	public List<Map<String,String>> getMappingList(Map<String,Object>  param);
	
	// 팝업 방문일지 조회
	public List<Map<String,String>> getCardList(Map<String,Object>  param);
	
	// 팝업 등록
	public String regSelectedData(Map<String,String>  formData);
	
	// 팝업 + 매핑 등록
	public String regAllSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 영업Map 이미지 등록
	public String addSalesImagePop(FileUploadForm uploadForm, Map<String,String> formData);
	
	// 조직도 이미지 등록
	public String addOrgImagePop(FileUploadForm uploadForm, Map<String,String> formData);
	
	// 시스템프로세스 이미지 등록
	public String addSysImagePop(FileUploadForm uploadForm, Map<String,String> formData);
	
	// 팝업 저장
	public String saveSelectedData(Map<String,String>  formData);
	
	// 팝업 + 매핑 저장
	public String saveAllSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 팝업 매핑 삭제
	public String delMappingData(Map<String,String>  formData, List<Object> gridData);
	
	// 팝업 재계약 등록
	public String regReContractData(Map<String,String>  formData);
}
