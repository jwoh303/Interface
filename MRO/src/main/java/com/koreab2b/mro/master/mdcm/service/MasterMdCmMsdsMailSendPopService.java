package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmMsdsMailSendPopService {
	
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 메일 전송
	public String saveMasterMdcmMsdsMailSend(Map<String,String>  formData, List<Object> gridData);
	// 메일수신여부 변경
	public String saveMailRecv(Map<String,String> formData);
	
}
