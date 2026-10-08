package com.kep.hancom.dao;

import java.util.List;
import java.util.Map;

public interface HanComDao {
	public List<Map<String,String>> selectIfCode() throws Exception;	
}
