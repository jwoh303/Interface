package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface SellerMpRqQuotManageService {
	
	//리뉴얼 > 전체탭 > 조회
	public List<Map<String,String>> getSellerMpRqQuotaList_v2(Map<String,Object>  formData);
	
	//리뉴얼 > 견적상세 > 견적요청,포기
	public Map<String, Object> saveSellerMpRqQuotaDetailReqList_v2(Map<String,String>  formData);
	
	//리뉴얼 > 견적상세 > 저장
	public Map<String, Object> saveSellerMpRqQuotaDetailProceList_v2(Map<String,String>  formData);
	
	//리뉴얼 > 견적요청탭 > 조회
	public List<Map<String,String>> getSellerMpRqQuotaReqList_v2(Map<String,Object>  formData);
	
	//리뉴얼 > 견적요청탭 > 견적요청,포기
	public String saveSellerMpRqQuotaReqList_v2(Map<String,String>  formData, List<Object> gridData);
	
	//리뉴얼 > 견적요청탭 > 저장
	public String saveSellerMpRqQuotaList_v2(Map<String,String>  formData, List<Object> gridData);
	
	
}
