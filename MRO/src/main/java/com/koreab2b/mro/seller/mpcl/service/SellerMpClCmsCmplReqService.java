package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface SellerMpClCmsCmplReqService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	//품목보완요청
	public String saveSellerMpClCmsCmplReqItem(FileUploadForm uploadForm,Map<String,String>  formData);
	
}
