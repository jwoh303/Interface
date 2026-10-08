package com.koreab2b.mro.buyer.wmgr.dao;

import java.util.ArrayList;
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

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.webservice.lottechilsung.InterfaceSoapProxy;

@Repository("buyerWmGrWarehousingRegDao")
@Transactional
public class BuyerWmGrWarehousingRegDaoImpl implements BuyerWmGrWarehousingRegDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerWmGrWarehousingRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// init
	public Map<String,String> getBuyerWmGrWarehousingRegInit(Map<String,String> formData){
		return sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingRegSlogic", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.selectBuyerWmGrWarehousingRegList", formData);
	}
	public List<Map<String,String>> getBuyerWmGrWarehousingRegList_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.getBuyerWmGrWarehousingRegList_v2", formData);
	}
	public List<Map<String,String>> getBuyerWmGrWarehousingRegList_v3(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.wmgr.getBuyerWmGrWarehousingRegList_v3", formData);
	}
	
	// 조회조건 - userList 조회
	public List<Map<String,String>> selectUserList(Map<String,String> formData) {
		
		String userType = CommonUtil.nvl(formData.get("st_user_type"));
		
		String queryId = "";
		if(userType.equals("PO")){
			queryId = "buyer.wmgr.selectBuyerWmGrWarehousingRegPoUserList";
		} else {
			queryId = "buyer.wmgr.selectBuyerWmGrWarehousingRegUserList";
		}
			
		return sqlSessionTemplate.selectList(queryId, formData);
	}
	
	
	// 입고번호 생성 - 입고등록 시 사용
	public String getOrderNo(Map<String,String> pMap){
		
		String orderNo = "";
		
		try{
			
			orderNo = CommonUtil.nvl((String)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGrNo", pMap));
			
			if(orderNo.equals("")){
				sqlSessionTemplate.insert("buyer.wmgr.insertBuyerWmGrWarehousingGrNo", pMap);
				
				orderNo = "" + Calendar.getInstance().get(Calendar.YEAR);
				orderNo = pMap.get("st_doc_type") + orderNo.substring(2,4) + "000001";
				
			} else {
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingGrNo", pMap);
			}
			
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("입고번호 생성 중 에러가 발생하였습니다.");
		}
		
		return orderNo;
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> pMap) {

		String _rtnMsg = "";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		Map<String,String> _processMap = null;
		String _processType = "";
		String _grYn = null;
		String _grQty = null;
		
		Map<String,String> _buyerMap = null;
		Map<String,Integer> _SeqMap = null;
		
		try{
			
			String car_check 	= CommonUtil.nvl(pMap.get("st_car_check"),""); //차파트너스인지 체크
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "&&");
			
			String grNo = getOrderNo(pMap);
			logger.debug("/wmgr/saveBuyerWmGrWarehousingRegList.do Map 요청 파라미터 : {}", pMap); 
			
			_buyerMap  = new HashMap<String, String>();
			_SeqMap = new HashMap<String, Integer>();
			
			_buyerMap.put(pMap.get("st_com_code"),grNo);
			_SeqMap.put(pMap.get("st_com_code"),1);
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("buyer", 		str[0]);
				_map.put("seller", 		str[1]);
				_map.put("po_no", 		str[2]);
				_map.put("po_seq", 		str[3]);
				_map.put("inv_no",		str[4]);
				_map.put("inv_seq",		str[5]);
				_map.put("user_id",		str[6]);
				_map.put("agent",		str[7]);
				_map.put("agent_price",	str[8]);
				_map.put("gr_date",		str[9]);
				_map.put("gr_qty",		str[10]);
				_map.put("gr_ref_pr_no", str[11]);
				_map.put("buyer_item_no", str[12]);
				
				String tmpgrNo = _buyerMap.getOrDefault(str[0], "0");
				int tmpgrSeq =  _SeqMap.getOrDefault(str[0], 1);
				
				if(tmpgrNo.equals("0")) {
					pMap.put("st_com_code", str[0]);
					tmpgrNo = getOrderNo(pMap);
					_buyerMap.put(str[0], tmpgrNo);
				}
				_map.put("gr_no", tmpgrNo);
				_map.put("gr_seq", String.valueOf(tmpgrSeq));
				_SeqMap.put(str[0], tmpgrSeq+1);
				
				_list.add(_map);
			}

			for(int i=0; i < _list.size(); i++){
				
				_map = (Map<String, String>)_list.get(i);
				
				// 입고등록 전 입고잠금 여부 확인
				_grYn = (String)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGrYnCheck", _map);
				
				if(Integer.parseInt(_grYn) > 0){
					_rtnMsg = (i+1)+"번 월마감이 종료되어 해당 월로 입고 불가합니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				// 입고등록 전 입고가능수량 체크 후 INSERT
				_grQty = (String)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGrQtyCheck", _map);
				
				logger.debug("_grQty ==>> " + _grQty);
				
				if(Integer.parseInt(_grQty) > 0){
					_rtnMsg = (i+1)+"번 입고수량이 송장수량보다 많을 수 없습니다.\n 재조회 후 다시 등록하시기 바랍니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
//				-- 1. UPDATE  ICOMPODT AND  UPDATE ICOMPRDT -- 관리번호 통일을 위해 REF_PR_NO 추가 24.02.02
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingPrdt", _map);
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingPodt", _map);
				
//				-- 2. SELECT process_type, warehouse_code
				_processMap = (Map<String,String>)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingProcessInfo", _map);
				_processType = _processMap.get("PROCESS_TYPE");
				
				_map.put("warehouse_code", _processMap.get("WAREHOUSE_CODE"));
//				_map.put("gr_seq", String.valueOf(i+1));
				
				if(_processType.trim().equals("0")){
//					-- 3. INSERT INTO ICOMGRDT
					sqlSessionTemplate.insert("buyer.wmgr.insertBuyerWmGrWarehousingGrdt", _map);
					
//					-- 4. UPDATE  ICOMIVDT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingIvdt", _map);
					
//				    -- 5. UPDATE  ICOMIVHD
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingIvhd", _map);
					
				} else {
//					-- 3_1. INSERT INTO ICOMGRDT
					sqlSessionTemplate.insert("buyer.wmgr.insertBuyerWmGrWarehousingGrdt1", _map);
					
//					-- 4_1. UPDATE  ICOMIVDT
					sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingIvdt1", _map);
				}
				
				//차파트너스 인 경우 추가로직 실행
				if(car_check.equals("true")) {
					//해당 buyer,buyer_item_no 를 key로 정보 있는지 조회
					String check = sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingCarStockCheck", _map);
					//재고테이블 처리
					if(check.equals("0")){ //없는 경우 insert
						sqlSessionTemplate.update("buyer.wmgr.insertBuyerWmGrWarehousingCarStock", _map);
					}else{ // 있는 경우 update
						sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingCarStockAdd", _map);				
					}
					//입고 이력테이블 처리
					sqlSessionTemplate.update("buyer.wmgr.insertBuyerWmGrWarehousingCarStockGrdt", _map);	
				}
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "고객사 입고등록 중 에러가 발생하였습니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
	return _rtnMsg;
		
	}
	
	// 롯데칠성 입고 결재 상신
	public Map<String,String> selectGrAppSendList(Map<String,String> pMap){
			
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		List<Map<String,String>> _processlist = new ArrayList<Map<String,String>>();
		Map<String,String> _map = null;
		Map<String,String> _processMap = null;
		Map<String,String> _rtnMap = new HashMap<String, String>();
		Map<String,String> _KeyMap = new HashMap<String, String>();
		String check = "OK";
		String gr_date = "";
		String ori_gr_date = "";
		
		try {
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "&&");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("buyer", 		str[0]);
				_map.put("po_no", 		str[1]);
				_map.put("po_seq", 		str[2]);
				_map.put("inv_no",		str[3]);
				_map.put("inv_seq",		str[4]);
				_map.put("user_id",		str[5]);
				_map.put("buyer_item_no", str[6]);
				_map.put("gr_date", str[7]);
				
				ori_gr_date = _map.put("gr_date", str[7]);
				gr_date = _map.get("gr_date").substring(0, 4) + "년 " +  _map.get("gr_date").substring(4, 6) + "월 " + _map.get("gr_date").substring(6) + "일";
				
				_list.add(_map);
			}
			
			for(int i=0; i < _list.size(); i++){
				
				_map = new HashMap<String, String>();
				_map = (Map<String, String>)_list.get(i);
				_processMap = sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGrAppSendList", _map);
				
				if(_processMap == null) {
					check = "PS";
					break;
				} 
//				else if (!_processMap.get("LEGACY_IV_SERIAL").equals(" ")) {
//					check = GrAppSendCheckList(_processMap);
//					break;
//				}
				_processlist.add(_processMap);
				
			}
			
			if (check.equals("PS") || check.equals("E") || (_processlist.size() != _list.size())  ) {
				_rtnMap.put("msg", "품의상신중인 문서가 존재합니다. 롯데칠성 그룹웨어에서 확인 바랍니다. 문의사항은 코리아이플랫폼(주) 담당자에게 연락 주세요");
				_rtnMap.put("chk", check);
				_rtnMap.put("callback", "");
				
			} else {
				
				System.out.println("_processlist = " + _processlist);
				
				Map<String,String> _Header = sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGrAppSendUserId", pMap);
				String key_no = sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGetKeyNo", pMap);
				_Header.put("check_sum_price",pMap.get("check_sum_price"));
				_Header.put("key_no", key_no);
				_Header.put("gr_date",gr_date);
				_Header.put("ori_gr_date",ori_gr_date);
				
				
				_rtnMap = getGrAppXml(_processlist, _Header);
				_rtnMap.put("msg", "결재 상신 처리합니다.");
				_rtnMap.put("chk", check);
				
				for(int i=0; i < _processlist.size(); i++){
					
					_map = new HashMap<String, String>();
					_map = (Map<String, String>)_processlist.get(i);
					_map.put("key_no",key_no);
					
					if(_map.get("INV_NO").contains("IV")) {
						sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLegacyIvNo1", _map);
					} else if (_map.get("INV_NO").contains("IK")) {
						sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingLegacyIvNo2", _map);
					}
				}
				
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingGrAppSendDBlinkList", _Header);
				
				InterfaceSoapProxy proxy = new InterfaceSoapProxy();
				String callback = proxy.requestDraft(_rtnMap.get("domain_code"), _rtnMap.get("id"), _rtnMap.get("systemid"), _rtnMap.get("keyvalue"), _rtnMap.get("moduleId"), _rtnMap.get("formAlias"), _rtnMap.get("mode"), _rtnMap.get("xmlData"));
				
				String start = callback.substring(0,1);
				if (start.equals("O")){
					callback = callback.replace("OK:","");
				}else {
					callback = callback.replace("ERR:","");
				}
				
				_rtnMap.put("callback",callback);
				System.out.println("_rtnMap : "+ _rtnMap);
			}
			
		} catch(Exception e){
			logger.error("SQL ERROR : ", e);
		}
		
		
		
		return _rtnMap;
	}
	
public String GrAppSendCheckList (Map<String,String> _processMap) {
		
		String chk = "OK";
		
		int cnt	= 0;
		
		try {
			
			cnt = sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGrAppSendDBlinkList", _processMap);
			
			if (cnt >= 1) {
				chk = "PS";
			}
				
		} catch(Exception e){
			chk = "E";
			logger.error("SQL ERROR : ", e);
		} 
		 
		return chk;
	}
	
	public Map<String,String> getGrAppXml (List<Map<String,String>> iMap, Map<String,String> Header){
		
		Map<String,String> _map = new HashMap<String, String>();
		StringBuffer xml	= new StringBuffer();
		int i = 1;
		
		for ( Map<String, String> pMap : iMap) {
			if (i == 1) {
				
				_map.put("domain_code","11");
				_map.put("id",Header.get("LEGACY_USER_ID"));
				_map.put("systemid","KEP");
				_map.put("keyvalue",Header.get("key_no"));
				_map.put("moduleId","WAREHOUSING");
				_map.put("formAlias","KEP_WAREHOUSING_CONFIRMATION");
				_map.put("mode","1");
				
				xml.append("<DBAPPROVAL><HEADER>");
				
				xml.append("<SYSTEMID>"+ _map.get("systemid") +"</SYSTEMID>");
				xml.append("<MODULEID>"+ _map.get("moduleId") +"</MODULEID>");
				xml.append("<FORMALIAS>"+ _map.get("formAlias") +"</FORMALIAS>");
				xml.append("<KEYVALUE><![CDATA[" + Header.get("key_no") + "]]></KEYVALUE>"); // 요청번호 채번해서 넣어야됨
				xml.append("<SUBJECT><![CDATA["+ "10002022, (주) 코리아이플랫폼, "+ pMap.get("DESCRIPTION") +"]]></SUBJECT>");
				xml.append("<LINKED_PID></LINKED_PID>");
				xml.append("<REF_PID></REF_PID>");
				xml.append("<ETC1></ETC1>");
				xml.append("<ETC2></ETC2>");
				xml.append("<ETC3></ETC3>");
				xml.append("<ETC4></ETC4>");
				xml.append("<ETC5></ETC5>");
				xml.append("</HEADER><BODY><CONTENT TYPE=\"XML\">");
				
				xml.append("<EBELN><![CDATA[" +  Header.get("key_no") +"]]></EBELN>");
				xml.append("<E_DATES><![CDATA[" +  Header.get("gr_date") +"]]></E_DATES>");
				xml.append("<STCD2><![CDATA[" +  "10002022" +"]]></STCD2>");
				xml.append("<NAME1><![CDATA[" +  "(주) 코리아이플랫폼" +"]]></NAME1>");
				xml.append("<EMPNM><![CDATA[" +  Header.get("USER_NAME_LOC") +"]]></EMPNM>");
				
				xml.append("<LINEITEM>");
			}
				xml.append("<ITEM>");
				xml.append("<LV_NO><![CDATA[" + String.valueOf(i) + "]]></LV_NO>");  // 주문번호
				xml.append("<MAKTX><![CDATA[" + pMap.get("DESCRIPTION") + "]]></MAKTX>");  //품명
				xml.append("<MEINS><![CDATA[" + pMap.get("UNIT_MEASURE") + "]]></MEINS>");  //단위
				xml.append("<BPMNG><![CDATA[" + String.valueOf(pMap.get("INV_QTY")) + "]]></BPMNG>");  //수량
				xml.append("<BDEPT><![CDATA[" + pMap.get("BUDGET_DEPT") + "]]></BDEPT>");  //예산부서
				xml.append("<SAKTO_T><![CDATA[" + pMap.get("ACCOUNT_TYPE") + "]]></SAKTO_T>"); //계정과목
															
				xml.append("<MATNR><![CDATA[" + pMap.get("BUYER_ITEM_NO") + "]]></MATNR>"); //품목코드
				xml.append("<LGORT_T> </LGORT_T>");  //저장위치
				xml.append("<NETPR><![CDATA[" + String.valueOf(pMap.get("UNIT_PRICE")) + "]]></NETPR>");  //단가
				xml.append("<COSTC><![CDATA[" + pMap.get("DEPT_CD") + "]]></COSTC>");  //코스트센터
				xml.append("<NETWR><![CDATA[" + String.valueOf(pMap.get("ITEM_AMT")) + "]]></NETWR>");  //주문금액
				
				xml.append("</ITEM>");
			
			i++;
		}
		xml.append("</LINEITEM></CONTENT></BODY></DBAPPROVAL>");
		_map.put("xmlData",xml.toString());
		
		return _map;
	}
	
	
	public String updateResetGrWarehousingReg(Map<String, String> formData, List<Object> gridData) {
		String rtnMsg = "";
		int cnt = 0;
		try {
			String buyer = formData.get("BUYER");
			formData.putAll((Map<String, String>) gridData.get(0));
			cnt = sqlSessionTemplate.selectOne("buyer.wmgr.selectResetGrWarehousingRegCnt",formData);
			  
			  if(!"KRLOTT0058".equals(buyer)){ //BUYER = 'KRLOTT0058'
				
				  rtnMsg = "고객사가 '롯데칠성음료(주)'인 경우에만 상신초기화 가능하십니다."; 
			  
			  }else if(cnt >= 1) { //SND_CHK AND LEGACY_IV_SERIAL_DT CHK 
				  
				  rtnMsg = "결재 진행중인 상태로 해당 발주 상신 초기화는 SR로 처리 가능하십니다.";
			  
			  }else if("".equals(formData.get("LEGACY_IV_SERIAL_DT"))) { 
			 
				  rtnMsg = "결재 상신전 상태 입니다.";
			  
			  }else{ //초기화 가능한 건
			  
				  sqlSessionTemplate.update("buyer.wmgr.updateResetGrWarehousingReg", formData);
				  rtnMsg = "상신초기화 정상적으로 처리 완료 되었습니다."; 
				  
			  }
			 
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("상신초기화 중 에러가 발생하였습니다.");
		}
		return rtnMsg;
	}
}
