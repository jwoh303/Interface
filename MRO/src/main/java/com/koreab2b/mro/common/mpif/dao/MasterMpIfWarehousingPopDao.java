package com.koreab2b.mro.common.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfWarehousingPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

}
