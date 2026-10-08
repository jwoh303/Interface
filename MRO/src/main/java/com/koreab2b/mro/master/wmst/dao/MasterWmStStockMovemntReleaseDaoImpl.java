package com.koreab2b.mro.master.wmst.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterWmStStockMovemntReleaseDao")
@Transactional
public class MasterWmStStockMovemntReleaseDaoImpl implements MasterWmStStockMovemntReleaseDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmStStockMovemntReleaseDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmst.selectMasterWmStStockMovemntReleaseList", param);
	}
	
	// 리스트 조회
	public List<Map<String, String>> selectWarehouseList(Map<String, String> param) {
		List<Map<String, String>> _warehouseCodeList = sqlSessionTemplate.selectList("master.wmst.selectMasterWmStStockMovemntReleaseWarehouseCode", param);
		if (_warehouseCodeList.size() == 0) {
			Map<String, String> _warehouseCode = new HashMap<String, String>();
			_warehouseCode.put("WAREHOUSE_CODE", "");
			_warehouseCodeList.add(_warehouseCode);
		}
		
		return _warehouseCodeList;
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "출고지시가 완료 되었습니다.";
		String _availQty = "";
		String stdcatlg_id = "";
		String flag = "Y";
		try {
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				_availQty = sqlSessionTemplate.selectOne("master.wmst.selectMasterWmStStockMovemntReleaseAvailQty", formData);
				
				if (Integer.parseInt(formData.get("REQ_QTY")) >= Integer.parseInt(formData.get("INV_QTY"))) {
					if (Integer.parseInt(_availQty) >= Integer.parseInt(formData.get("INV_QTY"))) {
						// STEP1
						sqlSessionTemplate.update("master.wmst.updateMasterWmStStockMovemntRelease", formData);
						sqlSessionTemplate.update("master.wmst.updateMasterWmStStockMovemntReleaseBntwmsmove", formData);
					} else {
						if (!stdcatlg_id.equals("")) {
							stdcatlg_id += ", ";
						}
						stdcatlg_id +=  formData.get("STDCATLG_ID");
						_rtnMsg = "출고수량이 재고수량 보다 많습니다.";
						flag = "N";
					}
				} else {
					if (!stdcatlg_id.equals("")) {
						stdcatlg_id += ", ";
					}
					flag = "N";
					stdcatlg_id +=  formData.get("STDCATLG_ID");
					_rtnMsg = "출고수량이 요청수량 보다 많습니다.";
				}
			}
			
			if (flag.equals("N")) {
				_rtnMsg = "품목코드 " + stdcatlg_id + " 의 " + _rtnMsg;
			}
			
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("출고지시에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "재고이동요청 취소완료 되었습니다.";
		
		try {
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));		

				sqlSessionTemplate.update("master.wmst.deleteMasterWmStStockMovemntRelease", formData);

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("재고이동요청 취소에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
