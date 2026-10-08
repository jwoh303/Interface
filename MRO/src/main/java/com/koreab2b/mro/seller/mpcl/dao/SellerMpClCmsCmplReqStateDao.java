package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface SellerMpClCmsCmplReqStateDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);


}
