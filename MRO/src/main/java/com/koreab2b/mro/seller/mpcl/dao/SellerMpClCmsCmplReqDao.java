package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface SellerMpClCmsCmplReqDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	//품목보완요청
	public String saveSellerMpClCmsCmplReqItem(FileUploadForm uploadForm,Map<String,String>  formData);

}
