package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.seller.mpcl.dao.SellerMpClCmsCmplReqDao;

@Service("sellerMpClCmsCmplReqService")
public class SellerMpClCmsCmplReqServiceImpl implements SellerMpClCmsCmplReqService {
	
	@Autowired
	private SellerMpClCmsCmplReqDao sellerMpClCmsCmplReqDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpClCmsCmplReqDao.selectList(formData);
	}	
	
	//품목보완요청
	public String saveSellerMpClCmsCmplReqItem(FileUploadForm uploadForm,Map<String,String>  formData){
		return sellerMpClCmsCmplReqDao.saveSellerMpClCmsCmplReqItem(uploadForm,formData);
	}	 	  

	
}
