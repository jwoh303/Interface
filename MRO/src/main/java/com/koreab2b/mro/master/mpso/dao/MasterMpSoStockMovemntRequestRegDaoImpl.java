package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpSoStockMovemntRequestRegDao")
@Transactional
public class MasterMpSoStockMovemntRequestRegDaoImpl implements MasterMpSoStockMovemntRequestRegDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoStockMovemntRequestRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoStockMovemntRequestRegList", param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> selectExcelList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoStockMovemntRequestRegExcel", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {

		_rtnMsg = "재고이동 요청 등록이 완료 되었습니다.";
		try {
			String _moveNo = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoStockMovemntRequestRegMoveNo", formData);
			formData.put("st_move_no", _moveNo);
			
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));
				String _avilQty = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoStockMovemntRequestRegAvailQty", formData);
				
				if (Integer.parseInt(_avilQty) >= (Integer.parseInt(formData.get("REQ_QTY")))) {
					// STEP1
					sqlSessionTemplate.update("master.mpso.insertMasterMpSoStockMovemntRequestReg", formData);
				}
			}
			
		} catch (Exception e) {
				logger.error("SQL ERROR : ", e);
				throw new RuntimeException("재고이동 요청 등록이 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "재고이동 요청 삭제가 완료 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		

				sqlSessionTemplate.update("master.mpso.deleteMasterMpSoStockMovemntRequestReg", formData);
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("재고이동 요청 삭제에 실패하였습니다");
		}

		return _rtnMsg;		
		
	}	

}
