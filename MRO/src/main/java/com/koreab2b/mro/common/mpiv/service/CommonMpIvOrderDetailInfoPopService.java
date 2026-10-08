package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface CommonMpIvOrderDetailInfoPopService {
	// 조회
	public Map<String, String> getInfo(Map<String,String>  formData);
	public Map<String,String> getInfo_v2(Map<String,String> formData);

}
