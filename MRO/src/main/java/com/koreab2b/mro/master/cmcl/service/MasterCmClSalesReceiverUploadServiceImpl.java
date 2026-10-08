package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesReceiverUploadDao;

@Service("masterCmClSalesReceiverUploadService")
public class MasterCmClSalesReceiverUploadServiceImpl implements MasterCmClSalesReceiverUploadService {
	
	@Autowired
	private MasterCmClSalesReceiverUploadDao masterCmClSalesReceiverUploadDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClSalesReceiverUploadDao.selectList(param);
	}
	
	// 업로드
	public String batchMasterCmClSalesReceiverUpload(Map<String, String> param,List<Object> gridData)  {
		return masterCmClSalesReceiverUploadDao.batchMasterCmClSalesReceiverUpload(param , gridData);
	}
	
	// 일괄수정
	public String saveMasterCmClSalesReceiverUpload(Map<String, String> param,List<Object> gridData)  {
		return masterCmClSalesReceiverUploadDao.saveMasterCmClSalesReceiverUpload(param , gridData);
	}
}
	
