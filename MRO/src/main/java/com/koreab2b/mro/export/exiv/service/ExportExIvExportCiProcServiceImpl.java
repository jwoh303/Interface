package com.koreab2b.mro.export.exiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.export.exiv.dao.ExportExIvExportCiProcDao;

@Service("exportExIvExportCiProcService")
public class ExportExIvExportCiProcServiceImpl implements ExportExIvExportCiProcService {
	
	@Autowired
	private ExportExIvExportCiProcDao exportExIvExportCiProcDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return exportExIvExportCiProcDao.selectList(param);
	}	
	
	// CI Item 추가등록 대상 조회
	public List<Map<String,String>> getItemList(Map<String,Object> param) {
		return exportExIvExportCiProcDao.selectItemList(param);
	}
	
	// 상세입고등록
	@Transactional
	public String updateSelectedHdData(Map<String,String>  formData, List<Object> gridData) {
		return exportExIvExportCiProcDao.updateSelectedHdData(formData, gridData);
	}
	
	// 리스트 상세조회
	public List<Map<String,String>> getDetailData(Map<String,Object> param) {
		return exportExIvExportCiProcDao.selectDetailList(param);
	}	

	// icomcod2 조회팝업
	public List<Map<String,String>> getExportExIvIcomCodPop(Map<String,Object> param) {
		return exportExIvExportCiProcDao.selectExportExIvIcomCodPop(param);
	}	

	// C/L, P/L 등록
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return exportExIvExportCiProcDao.updateSelectedData(formData, gridData);
	}
	
	// 입고취소
	@Transactional
	public String cancleExportExIvExportReceipt(Map<String,String>  formData, List<Object> gridData) {
		return exportExIvExportCiProcDao.cancleExportExIvExportReceipt(formData, gridData);
	}
	
	// CI 체크
	public String getCICheck(Map<String,String> formData) {
		return exportExIvExportCiProcDao.selectCICheck(formData);
	}
}
