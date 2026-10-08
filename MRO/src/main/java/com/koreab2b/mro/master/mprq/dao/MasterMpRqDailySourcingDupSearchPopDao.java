package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqDailySourcingDupSearchPopDao {

	public List<Map<String,String>> selectCatList(Map<String,Object> formData);

	public List<Map<String,String>> selectStdList(Map<String,Object> formData);

}
