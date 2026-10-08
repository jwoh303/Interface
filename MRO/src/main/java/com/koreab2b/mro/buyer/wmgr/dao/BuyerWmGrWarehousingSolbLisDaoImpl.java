package com.koreab2b.mro.buyer.wmgr.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerWmGrWarehousingSolbLisDao")
@Transactional
public class BuyerWmGrWarehousingSolbLisDaoImpl implements BuyerWmGrWarehousingSolbLisDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerWmGrWarehousingSolbLisDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// init
	public Map<String,String> getBuyerWmGrWarehousingLisInit(Map<String,String> formData){
		return sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingSolbLisSlogic", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingSolbLisList", formData);
	}
	public List<Map<String,String>> getBuyerWmGrWarehousingSolbLisList_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.getBuyerWmGrWarehousingSolbLisList_v2", formData);
	}
	public List<Map<String,String>> getBuyerWmGrWarehousingSolbLisList_v3(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.getBuyerWmGrWarehousingSolbLisList_v3", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> pMap) {

		String _rtnMsg = "";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		Map<String,String> _processMap = null;
		String processType = "";
		
		try{
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("com_code",	str[0]);
				_map.put("buyer",	str[0]);
				_map.put("user_id", 	str[1]);
				_map.put("gr_no", 		str[2]);
				_map.put("gr_seq", 		str[3]);			
				_map.put("iv_exist",	str[4]);
				_map.put("gr_qty",		str[5]);
				_list.add(_map);
			}

			for(int i=0; i < _list.size(); i++){
				
				_map = (Map<String, String>)_list.get(i);
				
				int gr_lock_cnt = (Integer)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingSolbLockCheck", _map);
				if(gr_lock_cnt > 0){
					_rtnMsg = "월마감이 종료되어 입고취소 불가합니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				int existBillCnt = (Integer)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingSolbLisExistBillCnt", _map);

				if(existBillCnt == 0){
					
//					-- 2. UPDATE  ICOMGRDT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisGrdt", _map);

//					-- 3. UPDATE  ICOMPODT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisPodt", _map);
					
					if("Y".equals(_map.get("iv_exist"))){
						
//						-- 4. SELECT process_type, warehouse_code
						_processMap = (Map<String,String>)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingSolbLisProcessInfo", _map);
						processType = CommonUtil.nvl(_processMap.get("PROCESS_TYPE"));
						
						_map.put("warehouse_code", CommonUtil.nvl(_processMap.get("WAREHOUSE_CODE")));
						
						if(processType.trim().equals("0")){
//							-- 5. UPDATE  ICOMIVDT
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisIvdt", _map);
							
//							-- 6. UPDATE  ICOMIVHD
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisIvhd", _map);
							
						} else {
							if("".equals(_map.get("inv_no"))){
//							    -- 5_1. UPDATE WMSIVDT inv 없는놈 실행
								sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisWmsIvdt1", _map);
								
							} else {
//								-- 5_2. UPDATE WMSIVDT inv 있는놈 실행
								sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisWmsIvdt2", _map);
							}
						}
					}
					
				} else {
					_rtnMsg = "세금계산서가 발행되었습니다.\n\n입고취소 불가합니다.";
					throw new RuntimeException(_rtnMsg);
				}	
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "고객사 입고취소 중 에러가 발생하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
		
	}
	@SuppressWarnings("unchecked")
	public String updateSelectedData_v3(Map<String,String> pMap) {

		String _rtnMsg = "";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		Map<String,String> _processMap = null;
		String processType = "";
		
		try{
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("com_code",	str[0]);
				_map.put("buyer",	str[0]);
				_map.put("user_id", 	str[1]);
				_map.put("gr_no", 		str[2]);
				_map.put("gr_seq", 		str[3]);			
				_map.put("iv_exist",	str[4]);
				_map.put("gr_qty",		str[5]);
				_list.add(_map);
			}

			for(int i=0; i < _list.size(); i++){
				
				_map = (Map<String, String>)_list.get(i);
				
				int gr_lock_cnt = (Integer)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingSolbLockCheck", _map);
				if(gr_lock_cnt > 0){
					_rtnMsg = "월마감이 종료되어 입고취소 불가합니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				int existBillCnt = (Integer)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingSolbLisExistBillCnt_v3", _map);

				if(existBillCnt == 0){
					
//					-- 2. UPDATE  ICOMGRDT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisGrdt", _map);

//					-- 3. UPDATE  ICOMPODT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisPodt", _map);
					
					if("Y".equals(_map.get("iv_exist"))){
						
//						-- 4. SELECT process_type, warehouse_code
						_processMap = (Map<String,String>)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingSolbLisProcessInfo", _map);
						processType = CommonUtil.nvl(_processMap.get("PROCESS_TYPE"));
						
						_map.put("warehouse_code", CommonUtil.nvl(_processMap.get("WAREHOUSE_CODE")));
						
						if(processType.trim().equals("0")){
//							-- 5. UPDATE  ICOMIVDT
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisIvdt", _map);
							
//							-- 6. UPDATE  ICOMIVHD
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisIvhd", _map);
							
						} else {
							if("".equals(_map.get("inv_no"))){
//							    -- 5_1. UPDATE WMSIVDT inv 없는놈 실행
								sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisWmsIvdt1", _map);
								
							} else {
//								-- 5_2. UPDATE WMSIVDT inv 있는놈 실행
								sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbLisWmsIvdt2", _map);
							}
						}
					}
					
				} else {
					_rtnMsg = "세금계산서가 발행되었습니다.\n\n입고취소 불가합니다.";
					throw new RuntimeException(_rtnMsg);
				}	
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "고객사 입고취소 중 에러가 발생하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
		
	}
	// 관리번호 변경 저장
	@SuppressWarnings("unchecked")
	public String updateSolbRefNo(Map<String, String> pMap) {
		
		String _rtnMsg = "";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		Map<String,String> _processMap = null;
		String processType = "";		
		
		try{
			
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "&||&");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("com_code",	str[0]);
				_map.put("buyer",	str[0]);				
				_map.put("gr_no", 		str[1]);
				_map.put("gr_seq", 		str[2]);
				_map.put("iv_exist",	str[3]);
				_map.put("ref_no",		str[4]);
				_list.add(_map);
			}

			for(int i=0; i < _list.size(); i++){
				
				_map = (Map<String, String>)_list.get(i);
				
					
//					-- 2. UPDATE  ICOMGRDT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbRefNoGrdt", _map);

//					-- 3. UPDATE  ICOMPODT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbRefNoPodt", _map);
					
					if("Y".equals(_map.get("iv_exist"))){
						
//						-- 4. SELECT process_type, warehouse_code
						_processMap = (Map<String,String>)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingSolbLisProcessInfo", _map);
						processType = CommonUtil.nvl(_processMap.get("PROCESS_TYPE"));
						
						_map.put("warehouse_code", CommonUtil.nvl(_processMap.get("WAREHOUSE_CODE")));
						
						if(processType.trim().equals("0")){
//							-- 5. UPDATE  ICOMIVDT
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbRefNoIvdt", _map);
							
						} else {
							if("".equals(_map.get("inv_no"))){
//							    -- 5_1. UPDATE WMSIVDT inv 없는놈 실행
								sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbRefNoWmsIvdt1", _map);
								
							} else {
//								-- 5_2. UPDATE WMSIVDT inv 있는놈 실행
								sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbRefNoWmsIvdt2", _map);
							}
						}
					}
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "관리번호 저장 중 오류 발생하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
		
	}

	// 입고 확정 및 취소
	public String updateSolbGrConfirm(Map<String, String> pMap) {
		String _rtnMsg = "";
		Map<String,String> _map = null;
		try{		
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("com_code",	str[0]);
				_map.put("buyer",	str[0]);
				_map.put("user_id", 	str[1]);
				_map.put("gr_no", 		str[2]);
				_map.put("gr_seq", 		str[3]);			
				_map.put("st_type",	str[4]);
				
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbGrConfirm", _map);
			}

			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "고객사 입고 확정 및 취소 중 에러가 발생하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}

	// 회계 확정 및 취소
	public String updateSolbDlConfirm(Map<String, String> pMap) {
		String _rtnMsg = "";
		Map<String,String> _map = null;
		try{		
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("com_code",	str[0]);
				_map.put("buyer",	str[0]);
				_map.put("user_id", 	str[1]);
				_map.put("gr_no", 		str[2]);
				_map.put("gr_seq", 		str[3]);			
				_map.put("st_type",	str[4]);
				
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingSolbDlConfirm", _map);
			}

			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "고객사 회계 확정 및 취소 중 에러가 발생하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}

	@Override
	public List<Map<String, String>> selectErpList(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingSolbErpList", formData);
	}
	
}