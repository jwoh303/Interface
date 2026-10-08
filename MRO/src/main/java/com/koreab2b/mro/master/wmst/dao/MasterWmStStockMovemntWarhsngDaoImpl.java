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

@Repository("masterWmStStockMovemntWarhsngDao")
@Transactional
public class MasterWmStStockMovemntWarhsngDaoImpl implements MasterWmStStockMovemntWarhsngDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmStStockMovemntWarhsngDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmst.selectMasterWmStStockMovemntWarhsngList", param);
	}
	
	// 리스트 조회
		public List<Map<String, String>> selectWarehouseList(Map<String, String> param) {
			List<Map<String, String>> _warehouseCodeList = sqlSessionTemplate.selectList("master.wmst.selectMasterWmStStockMovemntWarhsngWarehouseCode", param);
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
		
		_rtnMsg = "입고확정이 완료되었습니다.";
		String  wmsstckCnt = "";
		String stdcatlg_id = "";
		String flag = "Y";
		
		try {
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				wmsstckCnt =sqlSessionTemplate.selectOne("master.wmst.selectMasterWmStStockMovemntWarhsngWmsstckCnt", formData);
				
				if (Integer.parseInt(wmsstckCnt) > 0) {
					// STEP1
					sqlSessionTemplate.update("master.wmst.updateMasterWmStStockMovemntWarhsng", formData);
					sqlSessionTemplate.update("master.wmst.updateMasterWmStStockMovemntWarhsngBntwmsmove", formData);
				} else {
					if (!stdcatlg_id.equals("")) {
						stdcatlg_id += ", ";
					}
					flag = "N";
					stdcatlg_id +=  formData.get("STDCATLG_ID");
				}
			}

			if (flag.equals("N")) {
				_rtnMsg = "품목코드 " + stdcatlg_id + " 의 재고수량 정보가 없습니다.";
			}
			
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("입고확정 저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.wmst.deleteMasterWmStStockMovemntWarhsng", formData);
				logger.error("deleteMasterWmStStockMovemntWarhsng 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
