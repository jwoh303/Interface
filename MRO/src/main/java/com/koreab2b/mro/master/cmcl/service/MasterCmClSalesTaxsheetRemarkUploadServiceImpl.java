package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesTaxsheetRemarkUploadDao;

@Service("masterCmClSalesTaxsheetRemarkUploadService")
public class MasterCmClSalesTaxsheetRemarkUploadServiceImpl implements MasterCmClSalesTaxsheetRemarkUploadService {
	
	@Autowired
	private MasterCmClSalesTaxsheetRemarkUploadDao masterCmClSalesTaxsheetRemarkUploadDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClSalesTaxsheetRemarkUploadDao.selectList(param);
	}
	
	// 업로드
	public String batchMasterCmClSalesTaxsheetRemarkUpload(Map<String, String> param,List<Object> gridData)  {
		return masterCmClSalesTaxsheetRemarkUploadDao.batchMasterCmClSalesTaxsheetRemarkUpload(param , gridData);
	}
	
	// 일괄수정
	public String saveMasterCmClSalesTaxsheetRemarkUpload(Map<String, String> param,List<Object> gridData)  {
		return masterCmClSalesTaxsheetRemarkUploadDao.saveMasterCmClSalesTaxsheetRemarkUpload(param , gridData);
	}
}
	
