package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

public interface MasterCmClSalesTaxsheetRemarkUploadDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	public String batchMasterCmClSalesTaxsheetRemarkUpload(Map<String, String> param,List<Object> gridData);
	
	public String saveMasterCmClSalesTaxsheetRemarkUpload(Map<String, String> param,List<Object> gridData);
}
