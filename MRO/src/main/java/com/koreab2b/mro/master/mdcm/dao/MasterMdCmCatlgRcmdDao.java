package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatlgRcmdDao {
	// 업로드 후 조회
	public List<Map<String,String>> selectUploadList(Map<String,Object> param);

	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// BNTRXL 저장
	public String updateUploadData(Map<String,String>  formData, List<Object> gridData);
	
	// 추천
	public String updateData(Map<String,String>  formData, List<Object> gridData);
}
