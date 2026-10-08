package com.koreab2b.mro.master.cmcl.service;
import java.util.Map;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClSmartBillUploadingCreationDao;



@Service("masterCmClSmartBillUploadingCreationService")
public class MasterCmClSmartBillUploadingCreationServiceImpl implements MasterCmClSmartBillUploadingCreationService {
	@Autowired
	private MasterCmClSmartBillUploadingCreationDao masterCmClSmartBillUploadingCreationDao;
	// 스마트빌 전송상태 업데이트
	public String saveXXSBDtiStatusInfo(Map<String,String>  formData){
		return masterCmClSmartBillUploadingCreationDao.saveXXSBDtiStatusInfo(formData);
	}	
	// 스마트빌 전송성공 업데이트
	public String sendSuccessSmartbill(Map<String,String>  formData){
		return masterCmClSmartBillUploadingCreationDao.sendSuccessSmartbill(formData);
	}	
	// 스마트빌 전송실패 업데이트
	public String errorSendSmartBill(Map<String,String>  formData){
		return masterCmClSmartBillUploadingCreationDao.errorSendSmartBill(formData);
	}
	// 취소처리 성공
	public String cancleSuccessSmartBill(Map<String,String>  formData){
		return masterCmClSmartBillUploadingCreationDao.cancleSuccessSmartBill(formData);
	}
}
