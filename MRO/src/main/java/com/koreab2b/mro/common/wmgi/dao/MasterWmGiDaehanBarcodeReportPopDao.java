package com.koreab2b.mro.common.wmgi.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGiDaehanBarcodeReportPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

}
