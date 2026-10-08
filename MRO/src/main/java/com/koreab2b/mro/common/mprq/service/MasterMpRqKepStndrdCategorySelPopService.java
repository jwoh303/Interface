package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqKepStndrdCategorySelPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	// 조회
	public List<Map<String,String>> getCategorySelPop(Map<String,String>  formData);

}
