package com.koreab2b.mro.master.cmcl.service;

import java.util.Map;


public interface MasterCmClSmartBillUploadingCreationService {
	//스마트빌 전송상태 업데이트
	public String saveXXSBDtiStatusInfo(Map<String, String> formData);
	//스마트빌 전송성공 
	public String sendSuccessSmartbill(Map<String, String> formData);
	//스마트빌 전송상태 업데이트
	public String errorSendSmartBill(Map<String, String> formData);
	//취소처리 성공
	public String cancleSuccessSmartBill(Map<String, String> formData);
}
