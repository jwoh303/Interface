package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClSalesTaxsheetRemarkUploadService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	public String batchMasterCmClSalesTaxsheetRemarkUpload(Map<String, String> param,List<Object> gridData);
	
	public String saveMasterCmClSalesTaxsheetRemarkUpload(Map<String, String> param,List<Object> gridData);
	
}
