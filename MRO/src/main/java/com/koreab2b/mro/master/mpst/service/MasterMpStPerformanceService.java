package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

public interface MasterMpStPerformanceService {

	List<Map<String, String>> masterPerformanceList(Map<String, Object> pMap);

	List<Map<String, String>> getAllDeptList(Map<String, String> pMap);

}
