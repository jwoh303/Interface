package com.koreab2b.mro.common.mdcp.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mdcp.dao.MasterMdCpNewRegAgntcmpyInfoPopDao;
import com.koreab2b.mro.util.CommonUtil;

@Service("masterMdCpNewRegAgntcmpyInfoPopService")
public class MasterMdCpNewRegAgntcmpyInfoPopServiceImpl implements MasterMdCpNewRegAgntcmpyInfoPopService {
	
	@Autowired
	private MasterMdCpNewRegAgntcmpyInfoPopDao masterMdCpNewRegAgntcmpyInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCpNewRegAgntcmpyInfoPopDao.selectList(formData);
	}
	
	// 조회
	public String getMdmList(Map<String,String> formData) {
		return masterMdCpNewRegAgntcmpyInfoPopDao.selectMdmList(formData);
	}
	
	// 조회
	public List<Map<String,String>> getCmpyList(Map<String,Object> formData) {
		Map<String,Object>  data = new HashMap<String,Object>();
		data.putAll(formData);
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) formData.get("st_delete_com_code"),"@@");
		if(_list.size() > 0){
			data.put("st_delete_com_code_array", _list);
		} 
		return masterMdCpNewRegAgntcmpyInfoPopDao.selectCmpyList(data);
	}
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData) {
		return masterMdCpNewRegAgntcmpyInfoPopDao.updateSelectedData(formData);
	}
}
