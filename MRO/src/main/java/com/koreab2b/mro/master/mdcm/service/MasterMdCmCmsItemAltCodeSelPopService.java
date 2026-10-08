package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsItemAltCodeSelPopService {

	Map<String,String> getBase(Map<String,Object> param);

	List<Map<String,String>> getList(Map<String,Object> param);

}
