package com.koreab2b.mro.master.mpvo.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpVoDashBoardDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 리스트 조회
	public String getCountBuyerOwn(Map<String, Object> pParam);
	
	public List<Map<String,String>> getDashBoardList1(Map<String,Object> param);
	
	public List<Map<String,String>> getDashBoardList2(Map<String,Object> param);
	
	public List<Map<String,String>> getDashBoardList3(Map<String,Object> param);
	
	public List<Map<String,String>> getDashBoardList4(Map<String,Object> param);

}
