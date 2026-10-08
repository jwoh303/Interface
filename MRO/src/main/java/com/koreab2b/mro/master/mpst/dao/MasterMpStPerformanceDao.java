package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpStPerformanceDao {

	List<Map<String, String>> masterPerformanceList(Map<String, Object> pMap);

	List<Map<String, String>> getAllDeptList(Map<String, String> pMap);

}
