package com.koreab2b.mro.seller.mprq.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpRqQuotManageDao {
	
	//리뉴얼 > 전체탭 > 조회
	public List<Map<String,String>> getSellerMpRqQuotaList_v2(Map<String,Object>  formData);
	
	//리뉴얼 > 견적상세팝업 > 견적요청,포기
	public Map<String, Object> saveSellerMpRqQuotaDetailReqList_v2(Map<String,String>  formData);
	
	//리뉴얼 > 견적상세팝업 > 저장
	public Map<String, Object> saveSellerMpRqQuotaDetailProceList_v2(Map<String,String>  formData);
	
	//리뉴얼 > 견적요청탭 > 조회
	public List<Map<String,String>> getSellerMpRqQuotaReqList_v2(Map<String,Object>  formData);
	
	//리뉴얼 > 견적요청탭 > 견적제출,포기
	public String saveSellerMpRqQuotaReqList_v2(Map<String,String>  formData, List<Object> gridData);
	
	//리뉴얼 > 견적요청탭 > 견적제출,포기
	public String saveSellerMpRqQuotaList_v2(Map<String,String>  formData, List<Object> gridData);
}
