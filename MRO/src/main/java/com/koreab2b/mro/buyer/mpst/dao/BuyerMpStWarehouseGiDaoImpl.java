package com.koreab2b.mro.buyer.mpst.dao;

import java.util.Calendar;

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

@Repository("buyerMpStWarehouseGiDao")
@Transactional
public class BuyerMpStWarehouseGiDaoImpl implements BuyerMpStWarehouseGiDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpStWarehouseGiDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("buyer.mpst.selectBuyerMpStWarehouseGiList", param);
	}
		
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "삭제 완료되었습니다.";
		String check_qty = "";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				//현재 출고수량 보다 많은 수량을 출고취소 할 수 없음
				check_qty = sqlSessionTemplate.selectOne("buyer.mpst.selectBuyerMpStWarehouseGiCheckQty", formData);
				if(Integer.parseInt(check_qty) < 0) {
					_rtnMsg = "기존 출고수량보다 많은 수량을 취소할 수 없습니다.\n확인해주시기 바랍니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				//재고테이블에서 출고 마이너스 처리
				sqlSessionTemplate.update("buyer.mpst.updateBuyerMpStWarehouseGiMinus", formData);
				//출고이력테이블에서 해당 내역 삭제
				sqlSessionTemplate.update("buyer.mpst.deleteBuyerMpStWarehouseGi", formData);

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "출고삭제 실패하였습니다.\n재조회후 확인해주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;		
		
	}
	
	// 출고
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String setSelectedData(Map<String,String>  formData, List<Object> gridData) {
			
		String _rtnMsg = "출고 완료되었습니다.";
		String check_qty = "";
		String check_stock = "";
		
		try{
			String buyer = formData.get("st_buyer");
			String ivNo = getOrderNo(buyer, "GI");
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("IV_NO", ivNo);
				
				//재고테이블에 입고등록이 되었는지 확인
				check_stock = sqlSessionTemplate.selectOne("buyer.mpst.selectBuyerMpStWarehouseGiStockCheck", formData);
				if(check_stock.equals("0")){ //없는 경우
					_rtnMsg = "재고가 존재하지 않는 품목은 출고할 수 없습니다.\n재고조회 화면에서 확인해주시기 바랍니다.\n";
					throw new RuntimeException(_rtnMsg);
				}
				
				//재고수량(입고수량-출고수량)보다 많은 수량 출고 안됨
				check_qty = sqlSessionTemplate.selectOne("buyer.mpst.selectBuyerMpStWarehouseGiCheckStockQty", formData);
				if(Integer.parseInt(check_qty) < 0) {
					_rtnMsg = "재고수량보다 많은 수량을 출고할 수 없습니다.\n확인해주시기 바랍니다.\n";
					throw new RuntimeException(_rtnMsg);
				}
				
				//재고테이블에서 출고수량 플러스 처리
				sqlSessionTemplate.update("buyer.mpst.updateBuyerMpStWarehouseGiAdd", formData);
				//출고이력테이블에 추가
				sqlSessionTemplate.update("buyer.mpst.insertBuyerMpStWarehouseGi", formData);
				}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "출고 실패하였습니다.\n재업로드 후 확인해주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;		
		
	}
	
	//채번
	public String getOrderNo(String cmpyId, String docType) throws Exception{
		String returnValue = null;
		Map<String, String>  pMap = new HashMap<String, String>();
			
		pMap.put("COM_CODE", cmpyId);
		pMap.put("DOC_TYPE", docType);
		try {
			returnValue = sqlSessionTemplate.selectOne("common.getDocuNo", pMap);
			LOGGER.debug("채번 - returnValue : ", returnValue);
			
			if (returnValue == null || "".equals(returnValue) ||  returnValue.isEmpty()){
				sqlSessionTemplate.insert("common.insertDocuNo", pMap);
				
				String year = "0" + Calendar.getInstance().get(Calendar.YEAR );
				returnValue = docType +year.substring(3,5) + "000001";
				
			} else {
				sqlSessionTemplate.update("common.updateDocuNo", pMap);
			}
			LOGGER.debug("채번 - returnValue : ", returnValue);
			
		} catch (Exception e){
			LOGGER.debug("채번 Exception : ", e);
			throw new RuntimeException( "채번 취득에 실패하였습니다.");
		} finally {
			
		}
		return returnValue;
	}
}
