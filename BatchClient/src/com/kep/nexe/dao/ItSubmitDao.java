package com.kep.nexe.dao;

import java.util.List;
import java.util.Map;

public interface ItSubmitDao {

	public List<Map<String, String>> selectItemTargetList() throws Exception;

	public void updateNexeItSendResult(Map<String, String> resultMap) throws Exception;

	public void insertNexeItSendResult(Map<String, String> resultMap) throws Exception;

	public void execQuotationSend() throws Exception;

	public void execRtnProcess() throws Exception;

}
