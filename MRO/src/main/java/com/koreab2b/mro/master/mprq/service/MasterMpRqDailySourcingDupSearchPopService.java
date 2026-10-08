package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqDailySourcingDupSearchPopService {

	public List<Map<String,String>> getCatList(Map<String,Object> formData);

	public List<Map<String,String>> getStdList(Map<String,Object> formData);

}
