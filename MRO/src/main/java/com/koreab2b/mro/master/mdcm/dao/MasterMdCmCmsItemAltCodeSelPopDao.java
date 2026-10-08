package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsItemAltCodeSelPopDao {

	Map<String,String> selectBase(Map<String,Object> param);

	List<Map<String,String>> selectList(Map<String,Object> param);

}
