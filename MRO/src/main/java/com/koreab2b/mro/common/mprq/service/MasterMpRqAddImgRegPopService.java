package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface MasterMpRqAddImgRegPopService {
	// 이미지등록
	public String addImgRegPop(FileUploadForm uploadForm, Map<String,String> _pList);

}
