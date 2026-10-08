package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.mprq.dao.MasterMpRqAddImgRegPopDao;

@Service("masterMpRqAddImgRegPopService")
public class MasterMpRqAddImgRegPopServiceImpl implements MasterMpRqAddImgRegPopService {
	
	@Autowired
	private MasterMpRqAddImgRegPopDao masterMpRqAddImgRegPopDao;

	// 이미지등록
	public String addImgRegPop(FileUploadForm uploadForm, Map<String,String> _pList) {
		return masterMpRqAddImgRegPopDao.addImgRegPop(uploadForm, _pList);
	}

	

}
