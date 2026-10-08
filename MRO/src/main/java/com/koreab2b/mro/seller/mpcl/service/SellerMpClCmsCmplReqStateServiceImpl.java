package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.seller.mpcl.dao.SellerMpClCmsCmplReqStateDao;

@Service("sellerMpClCmsCmplReqStateService")
public class SellerMpClCmsCmplReqStateServiceImpl implements SellerMpClCmsCmplReqStateService {
	
	@Autowired
	private SellerMpClCmsCmplReqStateDao sellerMpClCmsCmplReqStateDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpClCmsCmplReqStateDao.selectList(formData);
	}	

	
}
