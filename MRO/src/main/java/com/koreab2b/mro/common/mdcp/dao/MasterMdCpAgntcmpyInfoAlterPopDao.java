package com.koreab2b.mro.common.mdcp.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCpAgntcmpyInfoAlterPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 납품가능지역
	public List<Map<String,String>> selectDelyAreaList(Map<String,String> formData);
	
	// 저장
	public String updateSelectedData(Map<String,String> formData);
	
	// 저장
	public String updateSelectedDataAvl(Map<String,String> formData);
	
	// 삭제
	public String deleteSelectedData(Map<String,String> formData);
	
	//cck_temp에서 협력사ID로 암호화된 데이터 가져오기
	public String getEncryptText(Map<String,String> formData);
}
