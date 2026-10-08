package com.koreab2b.mro.master.mpso.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoStockMovemntRequestRegDao;
import com.koreab2b.mro.util.CommonUtil;

@Service("masterMpSoStockMovemntRequestRegService")
public class MasterMpSoStockMovemntRequestRegServiceImpl implements MasterMpSoStockMovemntRequestRegService {
	
	@Autowired
	private MasterMpSoStockMovemntRequestRegDao masterMpSoStockMovemntRequestRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpSoStockMovemntRequestRegDao.selectList(param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> getExcelList(Map<String,Object> param) {
		Map<String,Object>  data = new HashMap<String,Object>();
		data.putAll(param);
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_stdcatlg_id"),"@@");
		if(_list.size() > 0){
			data.put("st_stdcatlg_id_array", _list);
		} 
		
		return masterMpSoStockMovemntRequestRegDao.selectExcelList(data);
	}

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoStockMovemntRequestRegDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoStockMovemntRequestRegDao.deleteSelectedData(formData, gridData);
	}
}
