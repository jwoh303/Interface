package com.koreab2b.mro.export.exol.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.export.exol.dao.ExportExOlExportProgressPopDao;

@Service("exportExOlExportProgressPopService")
public class ExportExOlExportProgressPopServiceImpl implements ExportExOlExportProgressPopService {
	@Autowired
	private ExportExOlExportProgressPopDao exportExOlExportProgressPopDao;

	// Lot 상세정보 팝업
	public List<Map<String,String>> getLotList(Map<String,Object> param) {
		return exportExOlExportProgressPopDao.selectLotList(param);
	}
	
	// CI, PL 상세정보 팝업 상단 헤더
	public List<Map<String,String>> getCiData(Map<String,String> formData) {
		return exportExOlExportProgressPopDao.selectCiData(formData);
	}
	
	// CI, PL 상세정보 팝업 하단 그리드
	public List<Map<String,String>> getCiList(Map<String,Object> param) {
		return exportExOlExportProgressPopDao.selectCiList(param);
	}
	
	// BL 상세정보 팝업 상단 헤더
	public List<Map<String,String>> getBlData(Map<String,String> formData) {
		return exportExOlExportProgressPopDao.selectBlData(formData);
	}
	
	// BL 상세정보 팝업 하단 그리드
	public List<Map<String,String>> getBlList(Map<String,Object> param) {
		return exportExOlExportProgressPopDao.selectBlList(param);
	}
	
	// CI, PL 상세정보 팝업 하단 그리드 삭제
	@Transactional
	public String saveExportExOlExportProgressCiList(Map<String,String>  formData, List<Object> gridData) {
		return exportExOlExportProgressPopDao.saveExportExOlExportProgressCiList(formData, gridData);
	}
}
