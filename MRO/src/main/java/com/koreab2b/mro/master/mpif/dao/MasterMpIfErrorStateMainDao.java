package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfErrorStateMainDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//납품요구일변경
	public String updateSelectedDataRdDate(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//삼성전자 품의상신 번호 업데이트
	public String updateIfPoListInfoApprDate(Map<String, String> formData, List<Object> gridData, String iFKey);

	//삼성전자 품의상신 번호 업데이트
	public String SelectBuyerIFkey(Map<String, String> formData);

}
