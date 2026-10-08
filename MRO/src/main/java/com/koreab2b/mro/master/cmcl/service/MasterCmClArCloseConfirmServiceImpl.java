package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClArCloseConfirmDao;


@Service("masterCmClArCloseConfirmService")
public class MasterCmClArCloseConfirmServiceImpl implements MasterCmClArCloseConfirmService {
	
	@Autowired
	private MasterCmClArCloseConfirmDao masterCmClArCloseConfirmDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClArCloseConfirmDao.selectList(param);
	}

	// 마감 미제출자 리스트 조회
	public List<Map<String, String>> getPopList(Map<String, Object> param) {
		return masterCmClArCloseConfirmDao.selectPopList(param);
	}
	public List<Map<String, String>> getPopList_v2(Map<String, Object> param) {
		return masterCmClArCloseConfirmDao.selectPopList_v2(param);
	}

	// 제출취소, 마감완료, 회계전송
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData) {
		return masterCmClArCloseConfirmDao.updateSelectedData(formData, gridData);
	}
	
}
