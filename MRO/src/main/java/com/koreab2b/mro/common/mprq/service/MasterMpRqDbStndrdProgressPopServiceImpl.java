package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.mprq.dao.MasterMpRqDbStndrdProgressPopDao;

@Service("masterMpRqDbStndrdProgressPopService")
public class MasterMpRqDbStndrdProgressPopServiceImpl implements MasterMpRqDbStndrdProgressPopService {
	
	@Autowired
	private MasterMpRqDbStndrdProgressPopDao masterMpRqDbStndrdProgressPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMpRqDbStndrdProgressPopDao.selectList(formData);
	}	
	
	// 이미지등록
	public String addDbStndrdPop(FileUploadForm uploadForm, Map<String,String> _pList) {
		return masterMpRqDbStndrdProgressPopDao.addDbStndrdPop(uploadForm, _pList);
	}	
	
	// 견적이관저장.
	@Transactional
	public String saveMasterMpRqCmsRecvDate(Map<String,String>  formData) {
		return masterMpRqDbStndrdProgressPopDao.saveMasterMpRqCmsRecvDate(formData);
	}
}
