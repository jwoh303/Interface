package com.koreab2b.mro.export.exbl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.export.exbl.dao.ExportExBlExportBlProcDao;

@Service("exportExBlExportBlProcService")
public class ExportExBlExportBlProcServiceImpl implements ExportExBlExportBlProcService {
	
	@Autowired
	private ExportExBlExportBlProcDao exportExBlExportBlProcDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return exportExBlExportBlProcDao.selectList(param);
	}	

	// 리스트 상세 조회
	public List<Map<String,String>> getDetailData(Map<String,Object> param) {
		return exportExBlExportBlProcDao.selectDetailList(param);
	}

	// B/L 등록
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return exportExBlExportBlProcDao.updateSelectedData(formData, gridData);
	}
}
