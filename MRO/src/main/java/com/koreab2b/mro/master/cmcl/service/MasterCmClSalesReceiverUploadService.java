package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClSalesReceiverUploadService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	public String batchMasterCmClSalesReceiverUpload(Map<String, String> param,List<Object> gridData);
	
	public String saveMasterCmClSalesReceiverUpload(Map<String, String> param,List<Object> gridData);
	
}
