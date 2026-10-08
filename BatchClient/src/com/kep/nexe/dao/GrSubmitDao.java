package com.kep.nexe.dao;

import java.util.List;
import java.util.Map;

public interface GrSubmitDao {

	public List<Map<String, String>> selectGrTargetList() throws Exception;

	public List<Map<String, String>> selectGrList(Map<String, String> map) throws Exception;

	public void updateNexeGrResult(Map<String, String> resultMap) throws Exception;

}
