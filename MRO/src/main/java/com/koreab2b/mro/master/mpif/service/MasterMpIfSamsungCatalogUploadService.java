package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfSamsungCatalogUploadService {	
	
	public List<Map<String, String>> getList(Map<String, Object> param);

	public String batchUploadList(Map<String, String> formData, List<Object> gridData);

	public String requestMasterMpIfSamsungCatalogUploadList(Map<String, String> formData, List<Object> gridData);

	public String saveList(Map<String, String> formData, List<Object> gridData);

	public String delList(Map<String, String> formData, List<Object> gridData);
	
}
