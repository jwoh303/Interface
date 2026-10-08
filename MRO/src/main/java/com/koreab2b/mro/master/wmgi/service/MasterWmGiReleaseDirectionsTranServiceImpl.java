package com.koreab2b.mro.master.wmgi.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;

import com.koreab2b.mro.master.wmgi.dao.MasterWmGiReleaseDirectionsTranDao;

@Service("masterWmGiReleaseDirectionsTranService")
public class MasterWmGiReleaseDirectionsTranServiceImpl implements MasterWmGiReleaseDirectionsTranService {
	
	@Autowired
	private MasterWmGiReleaseDirectionsTranDao masterWmGiReleaseDirectionsTranDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmGiReleaseDirectionsTranDao.selectList(param);
	}	
	// 일괄리스트 조회
	public List<Map<String,String>> getBpList(Map<String,Object> param) {
		return masterWmGiReleaseDirectionsTranDao.selectBpList(param);
	}
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGiReleaseDirectionsTranDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGiReleaseDirectionsTranDao.deleteSelectedData(formData, gridData);
	}
	
	// 엑셀 리스트 조회
	public List<Map<String,String>> getExcelList(Map<String,Object> param) {
		return masterWmGiReleaseDirectionsTranDao.selecExceltList(param);
	}
	
	// 일양, 한진택배 여부 조회
	public String getDeliCompany(Map<String, String> param) {
		return masterWmGiReleaseDirectionsTranDao.getDeliCompany(param);
	}
}
