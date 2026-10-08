package com.koreab2b.mro.export.exiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.export.exiv.dao.ExportExIvExportWarhsngProcDao;

@Service("exportExIvExportWarhsngProcService")
public class ExportExIvExportWarhsngProcServiceImpl implements ExportExIvExportWarhsngProcService {
	
	@Autowired
	private ExportExIvExportWarhsngProcDao exportExIvExportWarhsngProcDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return exportExIvExportWarhsngProcDao.selectList(param);
	}	

	// 상세입고등록
	@Transactional
	public String updateSelectedHdData(Map<String,String>  formData, List<Object> gridData) {
		return exportExIvExportWarhsngProcDao.updateSelectedHdData(formData, gridData);
	}
	
	// 상세입고등록
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return exportExIvExportWarhsngProcDao.updateSelectedData(formData, gridData);
	}
	
	// 납품상세조회
	public List<Map<String,String>> getDetail(Map<String,Object> formData) {
		return exportExIvExportWarhsngProcDao.selectDetail(formData);
	}
	
	// 납품상세조회 품목
	public List<Map<String,String>> getDetailData(Map<String,Object> formData) {
		return exportExIvExportWarhsngProcDao.selectDetailData(formData);
	}
	// 상세 리스트 조회
	public List<Map<String,String>> getDetailList(Map<String,Object> param) {
		return exportExIvExportWarhsngProcDao.selectDetailList(param);
	}	

}
