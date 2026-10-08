package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface MasterMpRqDbStndrdProgressPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	// 이미지등록
	public String addDbStndrdPop(FileUploadForm uploadForm, Map<String,String> _pList);
	//견적이관저장.
	public String saveMasterMpRqCmsRecvDate(Map<String,String> formData);

}
