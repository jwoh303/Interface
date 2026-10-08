package com.koreab2b.mro.master.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpds.dao.MasterMpDsAgrchemiPckmtrlDao;

@Service("masterMpDsAgrchemiPckmtrlService")
public class MasterMpDsAgrchemiPckmtrlServiceImpl implements MasterMpDsAgrchemiPckmtrlService {
	
	@Autowired
	private MasterMpDsAgrchemiPckmtrlDao masterMpDsAgrchemiPckmtrlDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpDsAgrchemiPckmtrlDao.selectList(param);
	}	
	public List<Map<String,String>> getListSub(Map<String,Object> param) {
		return masterMpDsAgrchemiPckmtrlDao.selectListSub(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpDsAgrchemiPckmtrlDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpDsAgrchemiPckmtrlDao.deleteSelectedData(formData, gridData);
	}
}
