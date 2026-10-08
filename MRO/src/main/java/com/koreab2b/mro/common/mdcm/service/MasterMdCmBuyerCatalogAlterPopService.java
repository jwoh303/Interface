package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface MasterMdCmBuyerCatalogAlterPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 상세조회
	public List<Map<String,String>> getDetailList(Map<String,String>  formData);
	
	// CMS 담당자 여부 확인
	public String getCheckedCmsRoleUser(Map<String,String>  formData);
	
	// 담당자 조회
	public List<Map<String,String>> getUserSelectkorea(Map<String,String>  formData);
	
	// 저장
	public Map<String,String> saveSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제취소
	public String delCancelSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 승인
	public String confirmSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 이미지등록
	public String addCatalogImagePop(FileUploadForm uploadForm, Map<String,String> formData);
	
	// 이미지삭제
	public String delCatalogImagePop(Map<String,String> formData);
	
	// 표준화 여부 확인
	public String getIsModifyCatalogCheckedByBusinessTeam(Map<String,String>  formData);
	
	// MSDS상세조회
	public List<Map<String,String>> getMsDsDetailList(Map<String,String>  formData);
	
	// 납품가능협력사
	public List<Map<String,String>> getBtoaDetailList(Map<String,String>  formData);

	// 이미지상세등록
	public String addCatalogImageDetailPop(FileUploadForm uploadForm, Map<String,String> formData);
	
	// 물질정보요청
	public String reqMasterMdCmSellerChemicalMat(Map<String,String>  formData, List<Object> gridData);
	
	// 보관조건 저장
	public String saveCatalogTempCond(Map<String,String> formData);
}
