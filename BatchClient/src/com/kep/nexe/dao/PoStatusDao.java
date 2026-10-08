package com.kep.nexe.dao;

import java.util.List;
import java.util.Map;

public interface PoStatusDao {

	public List<Map<String, String>> selectPoSatusTargetList()  throws Exception;
	
	public void updateNexePoResult(Map<String, String> resultMap) throws Exception;

	public void insertNexePoResult(Map<String, String> resultMap) throws Exception;

	public void updateNexePoDelete(Map<String, String> resultMap)throws Exception;

	public void insertNexePoDelete(Map<String, String> resultMap)throws Exception;

	public void execNexePoStatus() throws Exception;

}
