package com.koreab2b.mro.export.exol.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("exportExOlExportProgressPopDao")
@Transactional
public class ExportExOlExportProgressPopDaoImpl implements ExportExOlExportProgressPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// Lot 상세정보 팝업
	public List<Map<String,String>> selectLotList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("export.exol.selectExportExOlExportProgressLotList", param);
	}
	
	// CI, PL 상세정보 팝업 상단 헤더
	public List<Map<String,String>> selectCiData(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("export.exol.selectExportExOlExportProgressCiData", formData);
	}
	
	// CI, PL 상세정보 팝업 하단 그리드
	public List<Map<String,String>> selectCiList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("export.exol.selectExportExOlExportProgressCiList", param);
	}
	
	// BL 상세정보 팝업 상단 헤더
	public List<Map<String,String>> selectBlData(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("export.exol.selectExportExOlExportProgressBlData", formData);
	}
	
	// BL 상세정보 팝업 하단 그리드
	public List<Map<String,String>> selectBlList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("export.exol.selectExportExOlExportProgressBlList", param);
	}
	//  CI, PL 상세정보 팝업 하단 그리드 삭제
	@SuppressWarnings("unchecked")
	public String saveExportExOlExportProgressCiList(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				//CI 삭제
				sqlSessionTemplate.update("export.exol.saveExportExOlExportProgressCiList", formData);
			}	
		} catch (Exception e) {
			_rtnMsg = "처리 실패했습니다.";
			throw new RuntimeException("처리 실패했습니다.");
		}
		return _rtnMsg;
	}
}
