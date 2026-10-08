package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmHarmfulChemistryDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	// 실적데이터 생성
	public String createMasterMdCmHarmfulChemistry(Map<String,String>  formData);
}
