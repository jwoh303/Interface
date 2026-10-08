package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqDailySourcingDbManageListDao {

	public List<Map<String,String>> selectList(Map<String,Object> param);

}
