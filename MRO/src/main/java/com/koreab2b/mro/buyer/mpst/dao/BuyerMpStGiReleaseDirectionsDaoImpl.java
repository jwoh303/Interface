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
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpStGiReleaseDirectionsDao")
@Transactional
public class BuyerMpStGiReleaseDirectionsDaoImpl implements BuyerMpStGiReleaseDirectionsDao {
	
	private static final Logger logger = LoggerFactory.getLogger(BuyerMpStGiReleaseDirectionsDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, String>> selectList(Map<String, Object> pFormData) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("buyer.mpst.selectBuyerMpStGiReleaseDirectionsList", pFormData);
	}

	
	@Override
	public String updateSelectedGiData(Map<String, String> pFormData, List<Object> pGridData) {
		// TODO Auto-generated method stub
		
		/*출고지시*/
		String doc_type = "GI";
		String gi_no = "";
		String _rtnMsg = "";
		String delyToLocation = "";
		int res_cnt = 0;
		Map<String, Object> resMap = new HashMap<String, Object>();
		
		logger.error(pFormData.toString());
		logger.error(pGridData.toString());
		
		try {
			
			// 키 생성
			gi_no = getOrderNo(pFormData.get("st_com_code"), doc_type);
			pFormData.put("BUYER", pFormData.get("st_com_code"));
			pFormData.put("USER_ID", pFormData.get("st_user_id"));
			pFormData.put("STATUS_FLAG", "C");
			// 업데이트 & 인서트	출고 테이블
			for(int i = 0 ; i < pGridData.size() ; i++ ){
				pFormData.putAll((Map<String, String>)pGridData.get(i));
				pFormData.put("GI_NO", gi_no);
				pFormData.put("GI_SEQ", String.valueOf(i+1));
				
				if(i == 0){
					delyToLocation = pFormData.get("DELY_TO_LOCATION");
				}else{
					if(!delyToLocation.equals(pFormData.get("DELY_TO_LOCATION"))){
						_rtnMsg = "직납처가 다른건은 한 출고번호로 묶을수 없습니다.";
						throw new RuntimeException(_rtnMsg);
					}
				}
				
				// 1.기 출고처리 체크
				res_cnt = (Integer)sqlSessionTemplate.selectOne("buyer.mpst.seletCntForDuplicatedGiRelease", pFormData);
				
				if(res_cnt != 0){
					_rtnMsg = "출고지시가 이미 처리된 상태 입니다";
					throw new RuntimeException(_rtnMsg);
				}
				
				// 2. 재고 수량 체크
				res_cnt = (Integer)sqlSessionTemplate.selectOne("buyer.mpst.seletCheckStockQty", pFormData);
				
				if(res_cnt < 0){
					_rtnMsg = "재고수량이 부족합니다.";
					throw new RuntimeException(_rtnMsg);
				}
				// 3. BUYER_STOCK_LIST 체크
				res_cnt = (Integer)sqlSessionTemplate.selectOne("buyer.mpst.seletCheckStockListExists", pFormData);
				
				if(res_cnt > 0){
					_rtnMsg = "STOCK_LIST에 데이터가 존재합니다";
					throw new RuntimeException(_rtnMsg);
				}	
				// 4.INSERT INTO BUYER_STOCK_LIST
				res_cnt = sqlSessionTemplate.insert("buyer.mpst.insertBuyerStockList",pFormData);
				
				if(res_cnt != 1){
					_rtnMsg = "출고지시중(INSERT INTO BUYER_STOCK_LIST) 에러발생";
					throw new RuntimeException(_rtnMsg);
				}	
				
				// 5.MERGE INTO BUYER_STOCK
				res_cnt = sqlSessionTemplate.insert("buyer.mpst.insertBuyerStock",pFormData);
				
				if(res_cnt != 1){
					_rtnMsg = "출고지시중(MERGE INTO BUYER_STOCK) 에러발생";
					throw new RuntimeException(_rtnMsg);
				}	
				
				// 6.BUYER_STOCK_GIDT INSERT
				res_cnt = sqlSessionTemplate.insert("buyer.mpst.insertBuyerStockGidt",pFormData);
				
				if(res_cnt != 1){
					_rtnMsg = "출고지시중(INSERT INTO BUYER_STOCK_GIDT) 에러발생";
					throw new RuntimeException(_rtnMsg);
				}
				
				// 7.BUYER_STOCK_RSDT UPDATE
				res_cnt = sqlSessionTemplate.update("buyer.mpst.updateBuyerMpStGiReleaseDirections",pFormData);
				
				if(res_cnt < 1){
					_rtnMsg = "출고지시중(UPDATE BUYER_STOCK_RSDT) 에러발생";
					throw new RuntimeException(_rtnMsg);
				}
			}
			
			_rtnMsg	= "출고지시 처리가 완료되었습니다.";
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "출고지시중 에러발생으로 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		//resMap.put("msg", _rtnMsg);
		
		return _rtnMsg;
	}

	@Override
	public String updateSelectedGiCancelData(Map<String, String> pFormData, List<Object> pGridData) {
		// TODO Auto-generated method stub
		// 출고취소
		
		// 기존 데이터 체크
		String _rtnMsg = "";
		int res_cnt = 0;
		Map<String, Object> resMap = new HashMap<String, Object>();
		//Map<String, String> _gridData = new HashMap<String, String>();
		List<Map<String, String>> dataList = null;
		try {
			pFormData.put("BUYER", pFormData.get("st_com_code"));
			pFormData.put("USER_ID", pFormData.get("st_user_id"));
			pFormData.put("STATUS_FLAG", "D");
			
			dataList = sqlSessionTemplate.selectList("buyer.mpst.selectBuyerMpStGidtList", pFormData);
			
			if(pGridData != null){
				for(int i=0; i < dataList.size(); i++){
					
					pFormData.putAll((Map<String, String>)dataList.get(i));
					// 1. 출고처리 확인
						
					// 2.BUYER_STOCK_LIST 존재체크
					res_cnt = (Integer)sqlSessionTemplate.selectOne("buyer.mpst.seletCheckStockListDeleteExists", pFormData);
					
					if(res_cnt > 0){
						_rtnMsg = "STOCK_LIST에 출고취소 데이터가 존재합니다";
						throw new RuntimeException(_rtnMsg);
					}	
					
					// 3.BUYER_STOCK_LIST 수량체크
					res_cnt = (Integer)sqlSessionTemplate.selectOne("buyer.mpst.seletCheckStockListQty", pFormData);
					
					if(res_cnt != 0){
						_rtnMsg = "출고취소 수량에 문제가있습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 4.INSERT INTO BUYER_STOCK_LIST
					res_cnt = sqlSessionTemplate.insert("buyer.mpst.insertBuyerStockList",pFormData);
					
					if(res_cnt != 1){
						_rtnMsg = "출고지시중(INSERT INTO BUYER_STOCK_LIST) 에러발생";
						throw new RuntimeException(_rtnMsg);
					}	
					
					// 5.MERGE INTO BUYER_STOCK
					res_cnt = sqlSessionTemplate.insert("buyer.mpst.insertBuyerStock",pFormData);
					
					if(res_cnt != 1){
						_rtnMsg = "출고지시중(MERGE INTO BUYER_STOCK) 에러발생";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 6.출고데이터 삭제 STATUS = 'D'
					res_cnt = sqlSessionTemplate.update("buyer.mpst.updateBuyerMpStGidtCancel", pFormData);
					if(res_cnt < 1){
						_rtnMsg = "출고데이터 삭제 중 오류발생";
						throw new RuntimeException(_rtnMsg);
					}
						
					// 7.출고예정 데이터원복
					res_cnt = sqlSessionTemplate.update("buyer.mpst.updateBuyerMpStGiCancelReleaseDirections", pFormData);
					if(res_cnt < 1){
						_rtnMsg = "출고데이터 원복 중 오류발생";
						throw new RuntimeException(_rtnMsg);
					}
				
				
				}
			}
			_rtnMsg	= "출고취소처리가 완료되었습니다.";
			
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "출고취소 중 에러발생으로 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}	
		// 업데이트
		//resMap.put("msg", _rtnMsg);
		
		return _rtnMsg;
	}

	//확정
	@Override
	public String updateSelectedGiCompleteData(Map<String, String> pFormData, List<Object> pGridData) {
		// TODO Auto-generated method stub
		
		String _rtnMsg = "";
		int res_cnt = 0;
		Map<String, Object> resMap = new HashMap<String, Object>();
		Map<String, Object> checkMap = new HashMap<String, Object>();
		// 1. 출고 확정
		
		pFormData.put("BUYER", pFormData.get("st_com_code"));
		
		try {
			
			for(int i=0; i<pGridData.size(); i++){
				pFormData.putAll((Map<String, String>)pGridData.get(i));
				checkMap.put(pFormData.get("GI_NO"), 1);
			}
			
			// 출고번호 다수체크
			if(checkMap.size() > 1){
				_rtnMsg = "선택된 출고번호가 2개 이상입니다.";
				throw new RuntimeException(_rtnMsg);
			}
			
			// 출고 확정건 체크
			res_cnt = sqlSessionTemplate.selectOne("buyer.mpst.seletCntForDecidedGiRelease",pFormData);
			
			if(res_cnt > 0){
				_rtnMsg = "이미 출고확정된 건이 있습니다.";
				throw new RuntimeException(_rtnMsg);
			}
						
			res_cnt = sqlSessionTemplate.update("buyer.mpst.updateBuyerMpStGiDecideReleaseDirections",pFormData);
			
			if(res_cnt == 0){
				_rtnMsg = "출고확정 중 에러가 발생하였습니다.";
				throw new RuntimeException(_rtnMsg);
			}
			
			res_cnt = sqlSessionTemplate.update("buyer.mpst.updateBuyerMpStGiDecideIfData",pFormData);
			
			if(res_cnt == 0){
				_rtnMsg = "출고확정 중 에러가 발생하였습니다.";
				throw new RuntimeException(_rtnMsg);
			}
			
			_rtnMsg	= "출고확정처리가 완료되었습니다.";
			
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "출고확정 중 에러발생으로 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		// 업데이트
		//resMap.put("msg", _rtnMsg);
		
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
			logger.debug("채번 - returnValue : ", returnValue);
			
			if (returnValue == null || "".equals(returnValue) ||  returnValue.isEmpty()){
				sqlSessionTemplate.insert("common.insertDocuNo", pMap);
				
				String year = "0" + Calendar.getInstance().get(Calendar.YEAR );
				returnValue = docType +year.substring(3,5) + "000001";
				
			} else {
				sqlSessionTemplate.update("common.updateDocuNo", pMap);
			}
			logger.debug("채번 - returnValue : ", returnValue);
			
		} catch (Exception e){
			logger.debug("채번 Exception : ", e);
			throw new RuntimeException( "채번 취득에 실패하였습니다.");
		} finally {
			
		}
		return returnValue;
	}
	
}
