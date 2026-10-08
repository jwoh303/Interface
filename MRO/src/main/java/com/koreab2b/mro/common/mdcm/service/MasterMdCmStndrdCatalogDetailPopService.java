package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface MasterMdCmStndrdCatalogDetailPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 저장
	public String updateSelectedData (Map<String,String> formData);
	
	// 이미지 등록
	public String addMasterMdCmStndCatalogAlterPop(FileUploadForm uploadForm, Map<String,String> formData);
	
	// 이미지상세등록
	public String addMasterMdCmStndCatalogAlterDetailPop(FileUploadForm uploadForm, Map<String,String> formData);
}
