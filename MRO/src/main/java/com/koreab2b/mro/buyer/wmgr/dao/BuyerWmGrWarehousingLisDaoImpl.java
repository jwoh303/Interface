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

@Repository("buyerWmGrWarehousingLisDao")
@Transactional
public class BuyerWmGrWarehousingLisDaoImpl implements BuyerWmGrWarehousingLisDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerWmGrWarehousingLisDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// init
	public Map<String,String> getBuyerWmGrWarehousingLisInit(Map<String,String> formData){
		return sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingLisSlogic", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		String excelType = CommonUtil.nvl(formData.get("st_excel_type"));
		
		if("TYPE1".equals(excelType)){
			
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisType1List", formData);
			
		} else if("TYPE2".equals(excelType)){
			
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisType2List", formData);
			
		} else if("TYPE5".equals(excelType)){ // 기본 QUERY + 거래유형/결재경로 추가(셀트리온제약)
			
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisType5List", formData);
			
		} else if("TYPE6".equals(excelType)){ // 대한제분 그룹사 ERP업로드 양식  (KRWOOR0059, KRDH-V0001, KRBONA0001, KRVITI0001, KRDNB-0001)
			
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingDhErpList", formData);
			
		} else if("TYPE8".equals(excelType)){ // 차파트너스 그룹인 경우
			
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingCarLisList", formData);
			
		} else if("TYPE10".equals(excelType)){ // 램리서치
			
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLamAsnList", formData);
			
		} else if("TYPE11".equals(excelType)){ // 한컴라이프케어
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingHanComLCLisList", formData);
			
		} else if("TYPE12".equals(excelType)){ // 아모레 마감데이터 양식
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingAmoreLisList", formData);
		
		} else if("TYPE13".equals(excelType)){ // 깨끗한나라 ERP양식
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingKleannaraList", formData);

		} else { // 기본 QUERY
			
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisList", formData);
		}
		
		return _list;
	}
	
	public List<Map<String,String>> getBuyerWmGrWarehousingLisList_v2(Map<String,Object> formData) {
		String excelType = CommonUtil.nvl((String)formData.get("st_excel_type"));
		
		if("TYPE1".equals(excelType)){
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisType1List", formData);
			
		} else if("TYPE2".equals(excelType)){
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisType2List", formData);
			
		} else if("TYPE5".equals(excelType)){ // 기본 QUERY + 거래유형/결재경로 추가(셀트리온제약)
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisType5List", formData);
			
		} else if("TYPE6".equals(excelType)){ // 대한제분 그룹사 ERP업로드 양식  (KRWOOR0059, KRDH-V0001, KRBONA0001, KRVITI0001, KRDNB-0001)
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingDhErpList", formData);
			
		} else if("TYPE8".equals(excelType)){ // 차파트너스 그룹인 경우
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingCarLisList", formData);
			
		} else if("TYPE10".equals(excelType)){ // 램리서치
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLamAsnList", formData);
			
		} else if("TYPE11".equals(excelType)){ // 한컴라이프케어
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingHanComLCLisList", formData);
			
		} else if("TYPE12".equals(excelType)){ // 아모레 마감데이터 양식
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingAmoreLisList", formData);
		
		} else if("TYPE13".equals(excelType)){ // 깨끗한나라 ERP양식
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingKleannaraList", formData);

		} else { // 기본 QUERY
			
			return sqlSessionTemplate.selectList("buyer.wmgr.getBuyerWmGrWarehousingLisList_v2", formData);
		}
	}
	public List<Map<String,String>> getBuyerWmGrWarehousingLisList_v3(Map<String,Object> formData) {
		String excelType = CommonUtil.nvl((String)formData.get("st_excel_type"));
		
		if("TYPE1".equals(excelType)){
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisType1List", formData);
			
		} else if("TYPE2".equals(excelType)){
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisType2List", formData);
			
		} else if("TYPE5".equals(excelType)){ // 기본 QUERY + 거래유형/결재경로 추가(셀트리온제약)
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisType5List_v3", formData);
			
		} else if("TYPE6".equals(excelType)){ // 대한제분 그룹사 ERP업로드 양식  (KRWOOR0059, KRDH-V0001, KRBONA0001, KRVITI0001, KRDNB-0001)
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingDhErpList", formData);
			
		} else if("TYPE8".equals(excelType)){ // 차파트너스 그룹인 경우
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingCarLisList", formData);
			
		} else if("TYPE10".equals(excelType)){ // 램리서치
			
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLamAsnList", formData);
			
		} else if("TYPE11".equals(excelType)){ // 한컴라이프케어
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingHanComLCLisList_v3", formData);
			
		} else if("TYPE12".equals(excelType)){ // 아모레 마감데이터 양식
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingAmoreLisList", formData);
		
		} else if("TYPE13".equals(excelType)){ // 깨끗한나라 ERP양식
			return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingKleannaraList", formData);

		} else { // 기본 QUERY
			
			return sqlSessionTemplate.selectList("buyer.wmgr.getBuyerWmGrWarehousingLisList_v3", formData);
		}
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> pMap) {

		String _rtnMsg = "";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		Map<String,String> _processMap = null;
		String processType = "";
		String check_qty = "";
		
		try{
			String car_check 	= CommonUtil.nvl(pMap.get("st_car_check"),""); //차파트너스인지 체크
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
				_map.put("po_no", 		str[4]);
				_map.put("po_seq", 		str[5]);
				_map.put("iv_exist",	str[6]);
				_map.put("inv_no",		str[7]);
				_map.put("inv_seq",		str[8]);
				_map.put("gr_qty",		str[9]);
				_map.put("buyer_item_no",		str[10]);
				
				_list.add(_map);
			}

			for(int i=0; i < _list.size(); i++){
				
				_map = (Map<String, String>)_list.get(i);
				
				int gr_lock_cnt = (Integer)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingLockCheck", _map);
				if(gr_lock_cnt > 0){
					_rtnMsg = "월마감이 종료되어 입고취소 불가합니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				int existBillCnt = (Integer)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingLisExistBillCnt", _map);

				if(existBillCnt == 0){
					
//					-- 2. UPDATE  ICOMGRDT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisGrdt", _map);

//					-- 3. UPDATE  ICOMPODT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisPodt", _map);
					
					if("Y".equals(_map.get("iv_exist"))){
						
//						-- 4. SELECT process_type, warehouse_code
						_processMap = (Map<String,String>)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingLisProcessInfo", _map);
						processType = CommonUtil.nvl(_processMap.get("PROCESS_TYPE"));
						
						_map.put("warehouse_code", CommonUtil.nvl(_processMap.get("WAREHOUSE_CODE")));
						
						if(processType.trim().equals("0")){
//							-- 5. UPDATE  ICOMIVDT
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisIvdt", _map);
							
//							-- 6. UPDATE  ICOMIVHD
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisIvhd", _map);
							
						} else {
							if("".equals(_map.get("inv_no"))){
//							    -- 5_1. UPDATE WMSIVDT inv 없는놈 실행
								sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisWmsIvdt1", _map);
								
							} else {
//								-- 5_2. UPDATE WMSIVDT inv 있는놈 실행
								sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisWmsIvdt2", _map);
							}
						}
					}
					
					//차파트너스 인 경우 추가로직 실행
					if(car_check.equals("true")) {
						//해당 품목이 재고테이블에 존재하는지 확인
						String check = sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingLisCarStockGrdtCheck", _map);
						if(!check.equals("0")){ //car_stock_grdt 에 해당 gr_no 정보가 있는 경우에만 나머지 특수로직 실행
							
							//(기존입고수량 - 취소하려는 입고수량)-출고수량 < 0 이 되면 안됨  
							check_qty = sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingLisCarStockCheckQty", _map);
							if(Integer.parseInt(check_qty) < 0) {
								_rtnMsg = "남은 재고수량보다 많은 수량을 취소할 수 없습니다.\n확인해주시기 바랍니다.";
								throw new RuntimeException(_rtnMsg);
							}
							
							//재고테이블에서 마이너스 처리
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisCarStockMinus", _map);
							//이력테이블 삭제 처리
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisCarStockGrdt", _map);
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
		String check_qty = "";
		
		try{
			String car_check 	= CommonUtil.nvl(pMap.get("st_car_check"),""); //차파트너스인지 체크
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
				_map.put("po_no", 		str[4]);
				_map.put("po_seq", 		str[5]);
				_map.put("iv_exist",	str[6]);
				_map.put("inv_no",		str[7]);
				_map.put("inv_seq",		str[8]);
				_map.put("gr_qty",		str[9]);
				_map.put("buyer_item_no",		str[10]);
				
				_list.add(_map);
			}

			for(int i=0; i < _list.size(); i++){
				
				_map = (Map<String, String>)_list.get(i);
				
				int gr_lock_cnt = (Integer)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingLockCheck", _map);
				if(gr_lock_cnt > 0){
					_rtnMsg = "월마감이 종료되어 입고취소 불가합니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				int existBillCnt = (Integer)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingLisExistBillCnt_v3", _map);

				if(existBillCnt == 0){
					
//					-- 2. UPDATE  ICOMGRDT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisGrdt", _map);

//					-- 3. UPDATE  ICOMPODT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisPodt", _map);
					
					if("Y".equals(_map.get("iv_exist"))){
						
//						-- 4. SELECT process_type, warehouse_code
						_processMap = (Map<String,String>)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingLisProcessInfo", _map);
						processType = CommonUtil.nvl(_processMap.get("PROCESS_TYPE"));
						
						_map.put("warehouse_code", CommonUtil.nvl(_processMap.get("WAREHOUSE_CODE")));
						
						if(processType.trim().equals("0")){
//							-- 5. UPDATE  ICOMIVDT
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisIvdt", _map);
							
//							-- 6. UPDATE  ICOMIVHD
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisIvhd", _map);
							
						} else {
							if("".equals(_map.get("inv_no"))){
//							    -- 5_1. UPDATE WMSIVDT inv 없는놈 실행
								sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisWmsIvdt1", _map);
								
							} else {
//								-- 5_2. UPDATE WMSIVDT inv 있는놈 실행
								sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisWmsIvdt2", _map);
							}
						}
					}
					
					//차파트너스 인 경우 추가로직 실행
					if(car_check.equals("true")) {
						//해당 품목이 재고테이블에 존재하는지 확인
						String check = sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingLisCarStockGrdtCheck", _map);
						if(!check.equals("0")){ //car_stock_grdt 에 해당 gr_no 정보가 있는 경우에만 나머지 특수로직 실행
							
							//(기존입고수량 - 취소하려는 입고수량)-출고수량 < 0 이 되면 안됨  
							check_qty = sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingLisCarStockCheckQty", _map);
							if(Integer.parseInt(check_qty) < 0) {
								_rtnMsg = "남은 재고수량보다 많은 수량을 취소할 수 없습니다.\n확인해주시기 바랍니다.";
								throw new RuntimeException(_rtnMsg);
							}
							
							//재고테이블에서 마이너스 처리
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisCarStockMinus", _map);
							//이력테이블 삭제 처리
							sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLisCarStockGrdt", _map);
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
	
	// 마감 EXCEL 다운로드
	public List<Map<String,String>> selectCloseExcelList(Map<String,String> formData) {
		
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		String closeexcelType = CommonUtil.nvl(formData.get("st_close_excel_type"));
		if("TYPE2".equals(closeexcelType)){
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisCloseType2List", formData);
		} else {
			_list = sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingLisCloseList", formData);			
		}
		return _list;
	}
	
	// 관리번호별 집계 팝업
	public List<Map<String,String>> selectRefTotalList(Map<String,String> formData) {
		
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		_list = sqlSessionTemplate.selectList("buyer.wmgr.selectRefTotalList", formData);
		return _list;
	}
	
	// 한컴라이프 ERP 양식 다운로드
	public List<Map<String,String>> selectHLCERPList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.selectHLCERPList", formData);
	}
}