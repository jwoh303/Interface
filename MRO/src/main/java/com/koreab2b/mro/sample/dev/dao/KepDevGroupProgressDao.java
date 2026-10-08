package com.koreab2b.mro.sample.dev.dao;

import java.util.List;
import java.util.Map;

public interface KepDevGroupProgressDao {
	
	public int updateSelectedData(Map<String,String> formData, List<Object> gridData);
}
