package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

public interface BoardService {	 	 
	
	public List<Map<String,String>> boardList(Map<String,String>  pMap);
	
	public void boardWrite(Map<String,String>  pMap);
	
	public Map<String, String> boardDetail(Map<String,String>  pMap);
	
	public void boardUpdate(Map<String,String>  pMap);
	
	public void boardDelete(Map<String,String>  pMap);
	
	public List<Map<String,String>> codeMasterList(Map<String,String>  pMap);
	
	public void codeMasterProcess(List<Object>pList,Map<String,String>  pMap);
	
	public List<Map<String,String>> getMasterMdAmSelectCompanyPop(Map<String,String>  pMap);
	
	public String boardConfirm(Map<String,String>  pMap);
	
}
