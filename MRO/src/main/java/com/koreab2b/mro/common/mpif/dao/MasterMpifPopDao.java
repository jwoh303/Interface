package com.koreab2b.mro.common.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpifPopDao {

	public List<Map<String,String>> selectMasterMpifMessagePop(Map<String,String> pMap);
}
