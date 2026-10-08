package com.koreab2b.mro.common.mdcm.dao;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface MasterMdCmStndrdCatalogDetailPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	//저장
	public String updateSelectedData(Map<String,String> formData);
	
	// 이미지등록
	public String addMasterMdCmStndCatalogAlterPop(FileUploadForm uploadForm, Map<String,String> pMap);

	// 이미지상세등록
	public String addMasterMdCmStndCatalogAlterDetailPop(FileUploadForm uploadForm, Map<String,String> pMap);
	
}
