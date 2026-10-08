package com.koreab2b.mro.master.wmre.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmre.dao.MasterWmReReturnRegDao;

@Service("masterWmReReturnRegService")
public class MasterWmReReturnRegServiceImpl implements MasterWmReReturnRegService {
	
	@Autowired
	private MasterWmReReturnRegDao masterWmReReturnRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmReReturnRegDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmReReturnRegDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmReReturnRegDao.deleteSelectedData(formData, gridData);
	}
	// 수주접수이력체크
	public List<Map<String,String>> getPorsYn(Map<String,String> formData) {
		return masterWmReReturnRegDao.getPorsYn(formData);
	}
	// 계산서발행체크
	public List<Map<String,String>> getArApYn(Map<String,String> formData) {
		return masterWmReReturnRegDao.getArApYn(formData);
	}
	public List<Map<String,String>> getArApYn_v2(Map<String,String> formData) {
		return masterWmReReturnRegDao.getArApYn_v2(formData);
	}
	// 입고출력물 .
	public List<Map<String,String>> getIvGrYn(Map<String,String> formData) {
		return masterWmReReturnRegDao.getIvGrYn(formData);
	}
	// 발주초기화
	@Transactional
	public Map<String,String> saveMasterWmReCancleReturn(Map<String,String>  formData, List<Object> gridData) {
		return masterWmReReturnRegDao.saveMasterWmReCancleReturn(formData, gridData);
	}
	
	// 반품일괄종결
	@Transactional
	public String updateEndAllData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmReReturnRegDao.updateEndAllData(formData, gridData);
	}
}
