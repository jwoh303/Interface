package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfSamsungCatalogUploadDao {

	List<Map<String, String>> getList(Map<String, Object> param);

	String batchUploadList(Map<String, String> formData, List<Object> gridData);

	String requestMasterMpIfSamsungCatalogUploadList(Map<String, String> formData, List<Object> gridData);

	String saveList(Map<String, String> formData, List<Object> gridData);

	String delList(Map<String, String> formData, List<Object> gridData);
	
	
}
