package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsItemService {

	public List<Map<String,String>> getList(Map<String,Object> param);

	public Map<String,String> getDetail(Map<String,Object> param);

	public List<Map<String,String>> getDetailAttrList(Map<String,Object> param);

	public List<Map<String,String>> getDetailBuyInfoList(Map<String,Object> param);

	public List<Map<String,String>> getHistoryList(Map<String,Object> param);

	public List<Map<String,String>> getBasePriceHistoryList(Map<String,Object> param);

	public Map<String,String> getBasePriceInfo(Map<String,Object> param);

	public String saveBasePrice(Map<String,String> param);

	public String saveBasePriceBulk(Map<String,String> param, List<Object> gridData);

	public String saveSelectedMsdsMapping(Map<String,String> param, List<Object> gridData);

	public String saveSelectedMsdsClean(Map<String,String> param, List<Object> gridData);

}
