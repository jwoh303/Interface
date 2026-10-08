package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfCretecPoListDao {

	public List<Map<String, String>> selectList(Map<String, Object> pMap);

	public List<Map<String,String>> selectMpIfCretecPoListPop(Map<String, Object> pMap);

	public String submitMpIfCretecPoListPop(Map<String, String> pMap);

}
