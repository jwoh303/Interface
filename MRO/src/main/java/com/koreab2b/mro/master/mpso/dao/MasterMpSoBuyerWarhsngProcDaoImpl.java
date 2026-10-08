package com.koreab2b.mro.master.mpso.dao;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpSoBuyerWarhsngProcDao")
@Transactional
public class MasterMpSoBuyerWarhsngProcDaoImpl implements MasterMpSoBuyerWarhsngProcDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoBuyerWarhsngProcDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoBuyerWarhsngProcList", param);
	}
	public List<Map<String,String>> selectList_v2(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoBuyerWarhsngProcList_v2", param);
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "입고등록 완료되었습니다.";		
		
		String _grQty = null;
		
		try{
			
			String buyer = formData.get("BUYER");
			String grNo = getOrderNo(buyer, "GR");
			String autoGrFlag = (String)sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoBuyerAutoGrFlagCheck", formData);
			
			if(!"KRKORE0001".equals(buyer)) { // 코리아이플랫폼 고객사는 KEP_BUYER_FLAG 미등록이라 제외
				if(autoGrFlag.equals("Y")) {
					_rtnMsg = "자동입고처리 대상 고객사로 수동 입고처리 불가합니다.";
					throw new RuntimeException(_rtnMsg);
				}
			}
			
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
								
				// 입고등록 전 입고가능수량 체크 후 INSERT
				_grQty = (String)sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoBuyerGrQtyCheck", formData);
				
				logger.debug("_grQty ==>> " + _grQty);
				
				if(Integer.parseInt(_grQty) > 0){
					_rtnMsg = (i+1)+"번째 입고수량이 송장수량보다 많을 수 없습니다.\n 재조회 후 다시 등록하시기 바랍니다.";
				//	throw new RuntimeException(_rtnMsg);
				} else {
				
					logger.debug("MasterMpSoBuyerWarhsngProcDaoImpl 고객사입고처리 parameter 출력 start ====================");
					
					Set<String> keySet = formData.keySet();
					Iterator<String> iterator = keySet.iterator();
					
					while(iterator.hasNext()){
						String key = iterator.next();
						String value = formData.get(key);
						logger.debug("key : "+key+", value : "+value);
					}
					
					logger.debug("MasterMpSoBuyerWarhsngProcDaoImpl 고객사입고처리 parameter 출력 end ====================");
	
					formData.put("GR_NO", grNo);
					formData.put("GR_SEQ", String.valueOf(i+1));
					
	//				-- 1. INSERT ICOMGRDT
					sqlSessionTemplate.insert("master.mpso.insertMasterMpSoBuyerWarhsngProcGrdt", formData);
					
	//				-- 2. UPDATE ICOMPODT
					sqlSessionTemplate.update("master.mpso.updateMasterMpSoBuyerWarhsngProcPodt", formData);
	
	//				-- 3. SELECT process_type, warehouse_code	- 고객사 쿼리 사용
					//_processMap = (Map<String,String>)sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoBuyerWarhsngProcessInfo", formData);
					
					//_processType = _processMap.get("PROCESS_TYPE");
					
					//formData.put("WAREHOUSE_CODE", _processMap.get("WAREHOUSE_CODE"));
				
					
					if(formData.get("PROCESS_TYPE").equals("0")){
	//					-- 4. UPDATE  ICOMIVDT
						sqlSessionTemplate.update("master.mpso.updateMasterMpSoBuyerWarhsngProcIvdt", formData);
						
	//				    -- 5. UPDATE  ICOMIVHD
						sqlSessionTemplate.update("master.mpso.updateMasterMpSoBuyerWarhsngProcIvhd", formData);
						
					} else {
						
	//					-- 4_1. UPDATE  WMSIVDT
						sqlSessionTemplate.update("master.mpso.updateMasterMpSoBuyerWarhsngProcWmsIvdt", formData);
					}
					
					//고객사가 차파트너스인 경우 추가 로직 실행
					boolean p070000025 = CommonUtil.getSpecialCheckReturn(formData.get("BUYER"), "P07-0000025");
					if(p070000025) {
						//해당 buyer,buyer_item_no 를 key로 정보 있는지 조회
						String check = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoBuyerWarhsngProcCarStockCheck", formData);
						//재고테이블 처리
						if(check.equals("0")){ //없는 경우 insert
							sqlSessionTemplate.update("master.mpso.insertMasterMpSoBuyerWarhsngProcCarStock", formData);
						}else{ // 있는 경우 update
							sqlSessionTemplate.update("master.mpso.updateMasterMpSoBuyerWarhsngProcCarStockAdd", formData);				
						}
						//입고 이력테이블 처리
						sqlSessionTemplate.update("master.mpso.insertMasterMpSoBuyerWarhsngProcCarStockGrdt", formData);
					}
				}
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "고객사 입고등록에 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "입고등록 완료되었습니다.";		
		
		String _grQty = null;
		
		try{
			
			String buyer = formData.get("BUYER");
			String grNo = getOrderNo(buyer, "GR");
			String autoGrFlag = (String)sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoBuyerAutoGrFlagCheck", formData);
			
			if(!"KRKORE0001".equals(buyer)) { // 코리아이플랫폼 고객사는 KEP_BUYER_FLAG 미등록이라 제외
				if(autoGrFlag.equals("Y")) {
					_rtnMsg = "자동입고처리 대상 고객사로 수동 입고처리 불가합니다.";
					throw new RuntimeException(_rtnMsg);
				}
			}
			
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
								
				// 입고등록 전 입고가능수량 체크 후 INSERT
				_grQty = (String)sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoBuyerGrQtyCheck", formData);
				
				logger.debug("_grQty ==>> " + _grQty);
				
				if(Integer.parseInt(_grQty) > 0){
					_rtnMsg = (i+1)+"번째 입고수량이 송장수량보다 많을 수 없습니다.\n 재조회 후 다시 등록하시기 바랍니다.";
				//	throw new RuntimeException(_rtnMsg);
				} else {
				
					logger.debug("MasterMpSoBuyerWarhsngProcDaoImpl 고객사입고처리 parameter 출력 start ====================");
					
					Set<String> keySet = formData.keySet();
					Iterator<String> iterator = keySet.iterator();
					
					while(iterator.hasNext()){
						String key = iterator.next();
						String value = formData.get(key);
						logger.debug("key : "+key+", value : "+value);
					}
					
					logger.debug("MasterMpSoBuyerWarhsngProcDaoImpl 고객사입고처리 parameter 출력 end ====================");
	
					formData.put("GR_NO", grNo);
					formData.put("GR_SEQ", String.valueOf(i+1));
					
	//				-- 1. INSERT ICOMGRDT
					sqlSessionTemplate.insert("master.mpso.insertMasterMpSoBuyerWarhsngProcGrdt", formData);
					
	//				-- 2. UPDATE ICOMPODT
					sqlSessionTemplate.update("master.mpso.updateMasterMpSoBuyerWarhsngProcPodt", formData);
	
	//				-- 3. SELECT process_type, warehouse_code	- 고객사 쿼리 사용
					//_processMap = (Map<String,String>)sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoBuyerWarhsngProcessInfo", formData);
					
					//_processType = _processMap.get("PROCESS_TYPE");
					
					//formData.put("WAREHOUSE_CODE", _processMap.get("WAREHOUSE_CODE"));
				
					
					if(formData.get("PROCESS_TYPE").equals("0")){
	//					-- 4. UPDATE  ICOMIVDT
						sqlSessionTemplate.update("master.mpso.updateMasterMpSoBuyerWarhsngProcIvdt", formData);
						
	//				    -- 5. UPDATE  ICOMIVHD
						sqlSessionTemplate.update("master.mpso.updateMasterMpSoBuyerWarhsngProcIvhd", formData);
						
					} else {
						
	//					-- 4_1. UPDATE  WMSIVDT
						sqlSessionTemplate.update("master.mpso.updateMasterMpSoBuyerWarhsngProcWmsIvdt", formData);
					}
				}
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "고객사 입고등록에 실패하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		return _rtnMsg;
	}
	//채번
	public String getOrderNo(String comCode, String docType){

		String orderNo = "";
		Map<String,String> _map = new HashMap<String,String>();
		
		try{
			
			_map.put("st_com_code", comCode);
			_map.put("st_doc_type", docType);
			
			// 기존 고객사화면에서 사용하는 쿼리 사용
			orderNo = CommonUtil.nvl((String)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGrNo", _map));
			
			if(orderNo.equals("")){
				sqlSessionTemplate.insert("buyer.wmgr.insertBuyerWmGrWarehousingGrNo", _map);
				
				orderNo = "" + Calendar.getInstance().get(Calendar.YEAR);
				orderNo = _map.get("st_doc_type") + orderNo.substring(2,4) + "000001";
				
			} else {
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingGrNo", _map);
			}
			
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("입고번호 생성 중 에러가 발생하였습니다.");
		}
		
		return orderNo;
	}
	//고객사 메일발송
	@SuppressWarnings("unchecked")
	public String updateMpSoBuyerWarhsngMailList(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "정상적으로 메일전송 되었습니다.";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				// 메일전송 insert
				sqlSessionTemplate.update("master.mpso.insertMpSoBuyerWarhsngMailList", formData);
				//메일이력 insert
				sqlSessionTemplate.update("master.mpso.call_GR_NOTICE_MB_PROC_USE_PGM_MNG", formData);
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("메일전송 중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		return _rtnMsg;
	}
}
