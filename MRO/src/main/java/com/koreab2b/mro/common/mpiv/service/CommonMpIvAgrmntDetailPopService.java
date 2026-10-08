package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface CommonMpIvAgrmntDetailPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	public String getMailYn(Map<String,String> formData);

	public String insertCommonCoCoScmActionDetailPop(Map<String,String> formData);
}
