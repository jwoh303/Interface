package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

public interface MasterCmClSalesTaxsheetRaIssueDao {

	public List<Map<String, String>> selectList(Map<String,Object> param);
	
	public List<Map<String, String>> getRaIssueFormat(Map<String,Object> param);
	
	public String delSelectedData(Map<String, String> pFormData, List<Object> pGridData);
}
