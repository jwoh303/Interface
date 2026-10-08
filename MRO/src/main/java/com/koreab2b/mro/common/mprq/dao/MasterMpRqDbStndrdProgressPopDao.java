package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;

public interface MasterMpRqDbStndrdProgressPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	// 이미지등록
	public String addDbStndrdPop(FileUploadForm uploadForm, Map<String,String> _pList);
	// 이관저장
	public String saveMasterMpRqCmsRecvDate(Map<String,String>  formData);

}
