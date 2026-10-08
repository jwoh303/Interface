package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmChemicalMatInfoDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	//물질정보 상세 팝업 조성정보 헤드 조회	
	public List<Map<String,String>> getMasterMdCmChemicalMatInfoHdList(Map<String,String> formData);	
	// 취소
	public String cancleMasterMdCmChemicalMatInfo(Map<String,String>  formData, List<Object> gridData);
	// 저장
	public String saveMasterMdCmChemicalMatInfo(Map<String,String>  formData, List<Object> gridData);
}
