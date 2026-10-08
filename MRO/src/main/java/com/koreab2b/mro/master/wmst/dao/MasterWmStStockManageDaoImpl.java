package com.koreab2b.mro.master.wmst.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmStStockManageDao")
@Transactional
public class MasterWmStStockManageDaoImpl implements MasterWmStStockManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterWmStStockManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 데이터 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<Map<String, String>> resultList = null;
		resultList = sqlSessionTemplate.selectList("master.wmst.selectMasterWmStStockManageList", param);
		return resultList;
	}

	// 데이터 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {

		int _count = 0;
		_rtnMsg = "저장 되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				LOGGER.debug("===>> Start <<===");
				formData.putAll((Map<String, String>)gridData.get(i));
				if ( "U".equals(formData.get("sStatus")) ) {
					LOGGER.debug("===>> U <<===");
					// 재고UPDATE
					_count = sqlSessionTemplate.update("master.wmst.updateMasterWmStStockManage", formData);
					if ( _count != 1 ) {
						throw new RuntimeException("데이터 저장에 실패 했습니다.\n다시 확인하여 주십시요.");
					}
				}
				else if ( "I".equals(formData.get("sStatus")) ) {
					LOGGER.debug("===>> I <<===");
					// 기존데이터 재고 삭제
					sqlSessionTemplate.insert("master.wmst.deleteMasterWmStICOMCOD2StockManage", formData);
					// 현재 데이터 재고 INSERT
					_count = sqlSessionTemplate.insert("master.wmst.insertMasterWmStStockManage", formData);
					
					if ( _count != 1 ) {
						throw new RuntimeException("기존 등록품목이 있어 등록 불가능 합니다.\n다시 확인하여 주십시요.");
					}
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			throw new RuntimeException("n데이터 저장에 실패 했습니다.\n다시 확인하여 주십시요.");
		}
		
		return _rtnMsg;
	}
	
	
	// 데이터 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		int _count = 0;
		_rtnMsg = "삭제 되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));	
				_count = sqlSessionTemplate.update("master.wmst.deleteMasterWmStStockManage", formData);
				if ( _count != 1 ) {
					throw new RuntimeException("데이터 삭제 실패 했습니다.\n다시 확인하여 주십시요.");
				}
			}
		} catch(Exception e ) {
			LOGGER.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			throw new RuntimeException("데이터 삭제 실패 했습니다.\n다시 확인하여 주십시요.");
		}

		return _rtnMsg;		
	}
	
}
