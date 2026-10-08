package com.koreab2b.mro.common.mdcm.dao;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface MasterMdCmBuyerCatalogAlterPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	// 상세조회
	public List<Map<String,String>> selectDetailList(Map<String,String> formData);
	
	// CMS 담당자 여부 확인
	public String getCheckedCmsRoleUser(Map<String,String> formData);
	
	// 담당자 조회
	public List<Map<String,String>> selectUserSelectkorea(Map<String,String> formData);
	
	//저장
	public Map<String,String> saveSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//삭제취소
	public String deleteCancelSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//승인
	public String confirmSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 이미지등록
	public String addCatalogImagePop(FileUploadForm uploadForm, Map<String,String> pMap);
	
	// 이미지삭제
	public String delCatalogImagePop(Map<String,String> pMap);
	
	// 표준화 여부 확인
	public String getIsModifyCatalogCheckedByBusinessTeam(Map<String,String> formData);
	
	// MSDS상세조회
	public List<Map<String,String>> selectMsDsDetailList(Map<String,String> formData);
	
	// 납품가능협력사
	public List<Map<String,String>> selectBtoaDetailList(Map<String,String> formData);
	
	public String caRequest(Map<String,String>  formData);
	public String caCancel(Map<String,String>  formData);
	public String caApproval(Map<String,String>  formData);
	public String approvalAppendCqdt(Map<String,String>  formData);
	public String approvalIfPrice(Map<String,String>  formData);
	public String caReject(Map<String,String>  formData);
	public List<Map<String,String>> caResultList(Map<String,String>  formData);
	
	// 이미지상세등록
	public String addCatalogImageDetailPop(FileUploadForm uploadForm, Map<String,String> pMap);
	// 물질정보 요청
	public String reqMasterMdCmSellerChemicalMat(Map<String,String>  formData, List<Object> gridData);
	//재계약 관리 품의상신 
	public String rctRequest(Map<String,String>  formData);
	//재계약 품의화면
	public List<Map<String,String>> approvalRctListPop(Map<String,String> formData);
	//재계약 단가, 유효기간 변경 승인
	public String  rctApproval(Map<String, String> param);
	//재계약 단가, 유효기간 변경 승인
	public String  rctReject(Map<String, String> param);
	//카탈로그 상태변경 리스트
	public List<Map<String,String>> caStResultList(Map<String,String>  formData);
	//카탈로그 상태 변경
	public String caStApproval(Map<String,String>  formData);
	
	// 보관조건 저장
	public String saveCatalogTempCond(Map<String,String> pMap);
}
