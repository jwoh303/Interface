package com.koreab2b.mro.master.wmpg.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmPgPrewarhsngStateDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 저장
	public String updateMasterWmPgPrewarhsngState(Map<String,String>  formData, List<Object> gridData);
}
