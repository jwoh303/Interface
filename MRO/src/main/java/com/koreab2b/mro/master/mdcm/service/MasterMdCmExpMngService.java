package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmExpMngService {
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 저장
	public String saveMasterMdCmExpMng(Map<String,String>  formData, List<Object> gridData);

}
