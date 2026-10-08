package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfCowayBillDao {

	public List<Map<String, String>> selectMasterMpIfCowayBillList(Map<String, Object> pMap);
}
