package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsItemChangeReqService {

	public List<Map<String,String>> getStatusList(Map<String,Object> param);

	public List<Map<String,String>> getReqList(Map<String,Object> param);

	public int getOpenReqCount(Map<String,Object> param);

	public String saveChangeReq(Map<String,Object> param, List<Map<String,String>> items);

	public String saveChangeReqFromExcel(Map<String,Object> param, List<Map<String,String>> items);

	public int cancelChangeReq(Map<String,Object> param);

	public Map<String,String> getHeader(Map<String,Object> param);

	public List<Map<String,String>> getDtList(Map<String,Object> param);

	public int approveChangeReq(Map<String,Object> param);

	public int rejectChangeReq(Map<String,Object> param);
}
