package com.koreab2b.mro.seller.mdct.dao;

import java.util.List;
import java.util.Map;

public interface SellerMdCtChemicalMatSendDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	// 저장 V2
	public String updateSelectedDataV2(Map<String,String>  formData, List<Object> gridData);
	//물질정보 상세 팝업 조성정보 조회
	public List<Map<String,String>> getSellerMdCtChemicalMatRegPop(Map<String,Object> param);
	//물질정보 상세 팝업 조성정보 헤드 조회
	public List<Map<String,String>> getSellerMdCtChemicalMatRegPopHd(Map<String,String> formData);
	// 물질정보 오분류
	public String returnSellerMdCtChemicalMatSendList(Map<String,String>  formData, List<Object> gridData);
	// 물질정보 오분류 V2
	public String returnSellerMdCtChemicalMatSendListV2(Map<String,String>  formData, List<Object> gridData);
	// 발주 후 제출(협력사)
	public String afterSellerMdCtChemicalMatSendList(Map<String,String>  formData, List<Object> gridData);
	// 발주 후 제출(협력사) V2
	public String afterSellerMdCtChemicalMatSendListV2(Map<String,String>  formData, List<Object> gridData);
}
