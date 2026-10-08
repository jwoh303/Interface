package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfObPoAlterDao {

	public List<Map<String, String>> selectList(Map<String, Object> pMap);

	public String updateSelectedDataExcelCheck(Map<String, String> formData, List<Object> gridData);

	public String executeDataList(Map<String, String> formData, List<Object> gridData);

	public String deleteSelectedData(Map<String, String> formData, List<Object> gridData);

}
