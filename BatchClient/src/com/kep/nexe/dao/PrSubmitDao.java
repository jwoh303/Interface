package com.kep.nexe.dao;

import java.util.List;
import java.util.Map;

public interface PrSubmitDao {

	public List<Map<String, String>> selectPrTargetList() throws Exception;

	public List<Map<String, String>> selectPrList(Map<String, String> map)  throws Exception;

	public void updateNexePrSendResult(Map<String, String> resultMap) throws Exception;

	public List<Map<String, String>> selectOfcPrTargetList() throws Exception;

	public void updateNexeOfcPrSendResult(Map<String, String> resultMap) throws Exception;

}
