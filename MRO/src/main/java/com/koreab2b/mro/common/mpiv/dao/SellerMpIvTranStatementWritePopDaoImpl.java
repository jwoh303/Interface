package com.koreab2b.mro.common.mpiv.dao;

import java.util.ArrayList;
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

@Repository("sellerMpIvTranStatementWritePopDao")
@Transactional
public class SellerMpIvTranStatementWritePopDaoImpl implements SellerMpIvTranStatementWritePopDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementWritePopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 기본정보 조회
	public List<Map<String,String>> selectInfo(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvTranStatementWritePopInfo", pMap);
	}
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvTranStatementWritePopList", pMap);
	}
	public List<Map<String,String>> getSellerMpIvTranStatementWritePop_v2(Map<String,Object> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.getSellerMpIvTranStatementWritePop_v2", pMap);
	}
	
	// 구매사 차량정보 입력여부 조회
	public String getSellerMpivBuyerCarInfo(Map<String,String> pMap){
	
		String car_flag = "";
		List<Map<String,String>> list = null;
		
		String type = CommonUtil.nvl(pMap.get("st_type"));
//		String buyer = CommonUtil.nvl(formData.get("st_buyer"));
		
		if("cBuyer".equals(type)){
			
			// COM_CODE = #{st_buyer}
			//list = sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvBuyerCarInfoList", formData);
			car_flag = sqlSessionTemplate.selectOne("common.mpiv.selectSellerMpIvBuyerCarInfoList", pMap);
			
		} else if("cBuyerList".equals(type)){
			
				
//			String[] str = buyer.split("@@",-1);
			
			//formData.put("buyerList", str);
			
			
			// COM_CODE IN (#{st_buyer})
			list = sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvBuyerCarInfoList", pMap);
		}
		
//		car_flag = ((Map<String,String>)CommonUtil.getListNvl(list).get(0)).get("CAR_FLAG");
		
		return car_flag;
	}
	
	// 거래명세서 작성 저장
	public Map<String, String> saveSellerMpIvTranStatementWritePop(Map<String, String> pMap){
		
		Map<String, String> resMap = new HashMap<String, String>();
		String _rtnMsg = "";
		String _actionFlag = "";
		
		Map<String, String> lastLoginList = null;
//		Parameters =  [ {
		
//		query +=  buyer         + "@@";
//		query +=  po_no         + "@@";
//		query +=  po_seq        + "@@";
//		query +=  cd_qty        + "@@";
//		query +=  invoice_date  + "@@";
//		query +=  ds_date       + "@@";
//		query +=  complete_mark       ;
//		  st_query	= 	KRKITU0003@@PO14000014@@000001@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000002@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000003@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000004@@50@@20140620@@20140613@@Y^||^
//		, st_seller=KRKORE0001
//		, st_process_type=0
//		, st_legacy_po_no=N
//		, st_inv_no=
//		, st_type=
//		, st_car_info=
//		, st_car_flag=N
//		, st_inv_amt=324500
//		, st_inv_tax_amt=32450
//		, st_inv_tax_rate=0.1
//		, st_invoice_date_text=2014/06/20
//		, st_inv_tot_amt=356950
//		, st_remark=
//		, st_buyer=KRKITU0003
//		, st_po_no=PO14000014
//		, st_ds_date=20140613
//		, st_po_seq=000001
//		, st_cd_qty=50
//		, st_po_qty=100
//		, st_iv_qty=50
//		, st_iv_cre_check=1, checkbox0=, checkbox1=, checkbox2=, checkbox3=
//		, display_item_cnt=4
//		, legacy_po_seq_tot=@@@@@@@@
//		, st_pur_id=LKDSPQ09
//		, st_inv_data=}, ]
		
//	    Vector v                = new Vector();
	    
		Map<String, String> map;
		Map<String, String> map_hd;
		int res_cnt = 0;
		
		String doc_type 		= "IV";
		String inv_no			= "";	// 송장번호
		String legacy_iv_no 	= "";	// 두산메카텍 공작기계 LEGACY_IV_NO 생성/입력함.
		
		try{
		    String query_str				= CommonUtil.nvl(pMap.get("st_query"),"");
		    List<Map<String, String>> list	= new ArrayList<Map<String, String>>();
		    
		    String process_type     = CommonUtil.nvl(pMap.get("st_process_type"),"");
			String action_id		= CommonUtil.nvl(pMap.get("st_action_id"),"");
			String car_info			= CommonUtil.nvl(pMap.get("st_car_info"),"");
			String car_flag			= CommonUtil.nvl(pMap.get("st_car_flag"),"");
			//박스수량 입력
			String ktag_box_qty			= CommonUtil.nvl(pMap.get("ktag_box_qty"),"");
			
			int pm_cnt=0;
			// actionId 조회 - 현재 작업중인지 확인..
			String action_flag = CommonUtil.getActionIdList(action_id);
			
			if("Y".equals(action_flag)){
				_actionFlag = "DO";
				_rtnMsg = "해당건에 대해서 현재 작업중입니다.";
				throw new RuntimeException(_rtnMsg);
			} else {
				
				pMap.put("doc_type", doc_type);
			    // doc_type별 inv_no(송장번호) 생성
				inv_no = getOrderNo(pMap);

				
				String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
				
				for(int i=0 ; i < check_str.length; i++){
					String str[] = check_str[i].split("@@",-1);
					
					map = new HashMap<String, String>();
					map.put("st_buyer", 			str[0]);
					map.put("buyer", 			str[0]);
					map.put("po_no", 			str[1]);
					map.put("st_po_no", 			str[1]);
					map.put("po_seq", 			str[2]);
					map.put("st_po_seq", 			str[2]);
					map.put("cd_qty", 			str[3]);
					map.put("invoice_date", 	str[4]);
					map.put("ds_date", 			str[5]);
					map.put("complete_mark", 	str[6]);
					
					// 길이, 수량 이용 시 JSP에서 하기 항목들 추가되어 넘어옴
					if(str != null && str.length >= 8){
						map.put("size_yn", 			str[7]);
						map.put("size_len", 			str[8]);
						map.put("size_qty", 			str[9]);
					}
					map.put("ktag_box_qty", ktag_box_qty);
					//여신한도 초과 체크
					List<Map<String,String>>_list2 = null;
					_list2 = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivCreditLimitSttsCheck",map);
					String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
					if(credit_limit_flag.equals("Y")){
						_rtnMsg = "거래명세서 생성이 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
								+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
						throw new RuntimeException(_rtnMsg);
						
					}
					list.add(map);
				}
				
				map_hd = list.get(0);
				
				for(int i=0; i < list.size(); i++){
					map = (Map<String, String>)list.get(i);

					//0. KeP내부 품의 진행중일때 거래명세서 생성이 안되도록 hyun
					pm_cnt= (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckPM", map);
					logger.debug(" 품의진행체크  pm_cnt ==>> " + pm_cnt);
					if(pm_cnt != 0) {
						String mngInfo = sqlSessionTemplate.selectOne("common.mpiv.selectBuyerMngInfo", map);
						_rtnMsg = "KeP내부 품의 진행건이므로 거래명세서 생성이 불가능합니다.\n담당자("+mngInfo+")에게 문의 바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 납품 중복생성 체크
					res_cnt = (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckInvoice", map);
						
					logger.debug(" 납품 중복생성 체크  result_cnt ==>> " + res_cnt);
				
					if(res_cnt != 0) {
						_rtnMsg = "납품서가 이미 생성되어 있습니다. 다시 한번 확인해 주시기 바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}
					

					// 2. buyer == KRDOOS0003  : 두산메카텍 공작기계 ==>> LEGACY_IV_NO 생성/입력함.
					if(map.get("buyer").equals("KRDOOS0003")){
//						legacy_iv_no = getLegacyIvNo();
						
						legacy_iv_no = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvNo");
						logger.debug("LEGACY_IV_NO  ==>> " + legacy_iv_no);
						
						if("".equals(CommonUtil.nvl(legacy_iv_no))){
							logger.debug("LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
//							_rtnMsg = "LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
//							throw new RuntimeException(_rtnMsg);
						}
					}

					
					map.put("inv_no", 		inv_no);
					map.put("inv_seq", String.valueOf(i+1));
					map.put("legacy_iv_no", CommonUtil.nvl(legacy_iv_no));
					

//					map.put("buyer", 			str[0]);	KRKITU0003
//					map.put("po_no", 			str[1]);	PO14000014
//					map.put("po_seq", 			str[2]);	000001
//					map.put("cd_qty", 			str[3]);	50
//					map.put("invoice_date", 	str[4]);	20140620
//					map.put("ds_date", 			str[5]);	20140613
//					map.put("complete_mark", 	str[6]);	Y
//					map.put("inv_no", 		inv_no);		IV14150295
//					map.put("inv_seq", String.valueOf(i+1));
//					map.put("legacy_iv_no", legacy_iv_no);	IV14060001
					
					// 3. ICOMIVDT insert - 납품송장정보 insert					
					res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvdt", map);
					
					if( res_cnt != 1){
						_rtnMsg = "송장생성중(INSERT INTO ICOMIVDT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}					
					
					// 4. ICOMPODT update - 발주제품정보 송장수량, 송장작성완료유무 update 
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePodt", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPODT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
		
	                // 5. ICOMPORS update - 발주 수주접수 COMPLETE_MARK(분할여부) = 'Y' update
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePors", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPORS) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					map.put("BUYER", CommonUtil.nvl(map.get("buyer"), ""));
					map.put("PO_NO", CommonUtil.nvl(map.get("po_no"), ""));
					map.put("PO_SEQ", CommonUtil.nvl(map.get("po_seq"), ""));
					
					lastLoginList = sqlSessionTemplate.selectOne("master.mpso.selectLastLoginIdWithPoInfo", map);
					
					// 주문요청자, 발주자 마지막 로그인정보 UPDATE
					map.put("LAST_LOGIN_ID", CommonUtil.nvl(lastLoginList.get("REQ_USER_ID"), ""));
					map.put("LAST_LOGIN_ID1",CommonUtil.nvl(lastLoginList.get("PURCHASER_ID"), ""));
					
					// 주문요청자 마지막 로그인 정보 UPDATE
			        sqlSessionTemplate.insert("login.saveLogintime", map);
			        
			        // 발주자 마지막 로그인 정보 UPDATE
			        sqlSessionTemplate.insert("login.saveLogintime1", map);
				}
				
				// 6. ICOMPOHD(발주마스터정보)에 COMPLETE_MARK를 'Y'로 UPDATE 할지를 결정하기 위한 SELECT
				
				String complete_mark_dis = sqlSessionTemplate.selectOne("common.mpiv.selectCompleteMarkDis", map_hd);
				
				// COMPLETE_MARK가 Y가 아닌경우 Y로 UPDATE
				if(!"".equals(CommonUtil.nvl(complete_mark_dis))){
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePohd", map_hd);
					
					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPOHD) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
				}
				
				// 7. ICOMIVHD insert start ====================
				logger.debug("7. ICOMIVHD insert start ====================");
				
	            String danger_good_flag  = "N";
	            String pkg_type          = "*";
	            String pkg_qty           = "0";
	            String weight_unit       = "*";
	            String gross_weight      = "0";
	            String measurement       = "0";
	            String ship_method       = "ROD";
	            String depart_port       = "*";
	            String arrival_port      = "*";
	            String lc_no             = " ";
	            
	            pMap.put("inv_no"			, inv_no);
	            
	            pMap.put("danger_good_flag"	, danger_good_flag);
	            pMap.put("pkg_type"			, pkg_type);
	            pMap.put("pkg_qty"			, pkg_qty);
	            pMap.put("weight_unit"		, weight_unit);
	            pMap.put("gross_weight"		, gross_weight);
	            pMap.put("measurement"		, measurement);
	            pMap.put("ship_method"		, ship_method);
	            pMap.put("depart_port"		, depart_port);
	            pMap.put("arrival_port"		, arrival_port);
	            pMap.put("lc_no"			, lc_no);

	            if(process_type.equals("0") && car_flag.equals("Y")){
	            	String tmp_str[] = car_info.split("@@",-1); 
	            	pMap.put("car_no"			, String.valueOf(tmp_str[1]));
	            	pMap.put("car_person_name"	, String.valueOf(tmp_str[2]));
	            	pMap.put("car_person_tel"	, String.valueOf(tmp_str[3]));
	            }
	            
	            String buyer = map_hd.get("buyer");
	            String po_no = map_hd.get("po_no");
	            
	            pMap.put("buyer", buyer);
	            pMap.put("po_no", po_no);
	            
	            
				// 7-1. legacy_iv_serial_doos0006  조회 후 ICOMIVHD insert 시 사용.
	            logger.debug("****************************************");
	            logger.debug("* Buyer        : " + pMap.get("buyer"));
				logger.debug("* Inv No       : " + inv_no);
				logger.debug("* Po No        : " + pMap.get("po_no"));
				logger.debug("* Process Type : " + process_type);
				logger.debug("****************************************");
				
				
				String legacy_iv_serial = "";
				String query = "";
				
				
				//SLOGIC-BEGIN(P06-0000004) : 거래명세서 저장시, 직납일때, LEGACY_IV_SERIAL 생성로직 다름
				String sLogicData = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000004","COL01_DATA");
				//SLOGIC-END
				
				logger.debug("==============================================================");
				logger.debug("buyer : "+ buyer );
				logger.debug("sLogicData : "+ sLogicData );
				logger.debug("==============================================================");
				
	            if(sLogicData.equals("TK") && process_type.equals("0")) {	//buyer.equals("KRDOOS0006")
					
	            	legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialDoos0006");

	            	if("".equals(CommonUtil.nvl(legacy_iv_serial))){
	            		logger.debug("두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.");
//						_rtnMsg = "두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("HYOS") && process_type.equals("0")) {	//(buyer.equals("KRHYOS0017") || buyer.equals("KRHYOS0018"))

					query = "FUN_SEQ_MNG('SEQ_HYOS_INV_NO')||'^'||FUN_SEQ_MNG('SEQ_HYOS_MNG_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
							
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("HYOS_SAP") && process_type.equals("0")) {	//(buyer.equals("KRHYOS0033") || buyer.equals("KRHYOS0034") || buyer.equals("KRHYOS0036") || buyer.equals("KRHYOS0037"))
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer2", pMap);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
					
					
//					pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
	                
				} else if(sLogicData.equals("SUNG") && process_type.equals("0")) {	//buyer.equals("KRSUNG0254")
	                
					query = "FUN_SEQ_MNG('SEQ_SDSM_INV_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
	                
				} else if(sLogicData.equals("SSAN") && process_type.equals("0")) {	//buyer.equals("KRSSAN0025")
	                
					query = "GET_CSTMR_DEAL_STTMN_NO('KRSSAN0025')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("LTAL2") && process_type.equals("0")) {
					query = "FUN_SEQ_MNG('SEQ_LTAL2_INV_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
				}
//				else {
//	                pstmt6.setString(20,""                       );      // LEGACY_IV_SERIAL
//					pMap.put("legacy_iv_serial", "");
//				}
	            
	            pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
	            
	            logger.debug("pMap 출력 start ====================");
	            
	            Set<String> keySet = pMap.keySet();
	            Iterator<String> iterator = keySet.iterator();
	            
	            while(iterator.hasNext()){
	            	String key = iterator.next();
	            	String value = pMap.get(key);
	            	logger.debug("key : "+key+", value : "+value);
	            }
	            
	            logger.debug("pMap 출력 end ====================");
	            
	            res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvhd", pMap);
	            logger.debug("7. ICOMIVHD insert end ====================");
				// 7. ICOMIVHD insert  end =========================
	            
	            
	            // 8. 조건에 따라 대우조선 송장 차수 생성 - ICOMIVHD update	            
//	            if(buyer.equals("KRDAEW0016") && !process_type.equals("2") ){
//	            	
//	            	legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerial", pMap);
//	            	
//	            	if("".equals(CommonUtil.nvl(legacy_iv_serial))){
//	            		logger.debug("대우조선 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
////	            		_rtnMsg = "대우조선 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
////						throw new RuntimeException(_rtnMsg);
//	            	}
//	            	
//	            	pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
//	            	
//	            	res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWriteIvhd", pMap);
//	            	
////	            	if( res_cnt != 1){
////	            		_rtnMsg = "대우조선 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
////						throw new RuntimeException(_rtnMsg);
////					}
//	            }
			}
		
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "거래명세서 작성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		
		resMap.put("action_flag", _actionFlag);
		resMap.put("msg", _rtnMsg);
		resMap.put("inv_no", inv_no);
		
		return resMap;
	}
	public Map<String, String> saveSellerMpIvTranStatementWritePop_v3(Map<String, String> pMap){
		
		Map<String, String> resMap = new HashMap<String, String>();
		String _rtnMsg = "";
		String _actionFlag = "";
		
		Map<String, String> lastLoginList = null;
//		Parameters =  [ {
		
//		query +=  buyer         + "@@";
//		query +=  po_no         + "@@";
//		query +=  po_seq        + "@@";
//		query +=  cd_qty        + "@@";
//		query +=  invoice_date  + "@@";
//		query +=  ds_date       + "@@";
//		query +=  complete_mark       ;
//		  st_query	= 	KRKITU0003@@PO14000014@@000001@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000002@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000003@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000004@@50@@20140620@@20140613@@Y^||^
//		, st_seller=KRKORE0001
//		, st_process_type=0
//		, st_legacy_po_no=N
//		, st_inv_no=
//		, st_type=
//		, st_car_info=
//		, st_car_flag=N
//		, st_inv_amt=324500
//		, st_inv_tax_amt=32450
//		, st_inv_tax_rate=0.1
//		, st_invoice_date_text=2014/06/20
//		, st_inv_tot_amt=356950
//		, st_remark=
//		, st_buyer=KRKITU0003
//		, st_po_no=PO14000014
//		, st_ds_date=20140613
//		, st_po_seq=000001
//		, st_cd_qty=50
//		, st_po_qty=100
//		, st_iv_qty=50
//		, st_iv_cre_check=1, checkbox0=, checkbox1=, checkbox2=, checkbox3=
//		, display_item_cnt=4
//		, legacy_po_seq_tot=@@@@@@@@
//		, st_pur_id=LKDSPQ09
//		, st_inv_data=}, ]
		
//	    Vector v                = new Vector();
	    
		Map<String, String> map;
		Map<String, String> map_hd;
		int res_cnt = 0;
		
		String doc_type 		= "IV";
		String inv_no			= "";	// 송장번호
		String legacy_iv_no 	= "";	// 두산메카텍 공작기계 LEGACY_IV_NO 생성/입력함.
		
		try{
		    String query_str				= CommonUtil.nvl(pMap.get("st_query"),"");
		    List<Map<String, String>> list	= new ArrayList<Map<String, String>>();
		    
		    String process_type     = CommonUtil.nvl(pMap.get("st_process_type"),"");
			String action_id		= CommonUtil.nvl(pMap.get("st_action_id"),"");
			String car_info			= CommonUtil.nvl(pMap.get("st_car_info"),"");
			String car_flag			= CommonUtil.nvl(pMap.get("st_car_flag"),"");
			//박스수량 입력
			String ktag_box_qty			= CommonUtil.nvl(pMap.get("ktag_box_qty"),"");
			
			int pm_cnt=0;
			// actionId 조회 - 현재 작업중인지 확인..
			String action_flag = CommonUtil.getActionIdList(action_id);
			
			if("Y".equals(action_flag)){
				_actionFlag = "DO";
				_rtnMsg = "해당건에 대해서 현재 작업중입니다.";
				throw new RuntimeException(_rtnMsg);
			} else {
				
				pMap.put("doc_type", doc_type);
			    // doc_type별 inv_no(송장번호) 생성
				inv_no = getOrderNo(pMap);

				
				String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
				
				for(int i=0 ; i < check_str.length; i++){
					String str[] = check_str[i].split("@@",-1);
					
					map = new HashMap<String, String>();
					map.put("st_buyer", 			str[0]);
					map.put("buyer", 			str[0]);
					map.put("po_no", 			str[1]);
					map.put("st_po_no", 			str[1]);
					map.put("po_seq", 			str[2]);
					map.put("st_po_seq", 			str[2]);
					map.put("cd_qty", 			str[3]);
					map.put("invoice_date", 	str[4]);
					map.put("ds_date", 			str[5]);
					map.put("complete_mark", 	str[6]);
					
					// 길이, 수량 이용 시 JSP에서 하기 항목들 추가되어 넘어옴
					if(str != null && str.length >= 8){
						map.put("size_yn", 			str[7]);
						map.put("size_len", 			str[8]);
						map.put("size_qty", 			str[9]);
					}
					map.put("ktag_box_qty", ktag_box_qty);
					//여신한도 초과 체크
					List<Map<String,String>>_list2 = null;
					_list2 = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivCreditLimitSttsCheck",map);
					String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
					if(credit_limit_flag.equals("Y")){
						_rtnMsg = "거래명세서 생성이 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
								+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
						throw new RuntimeException(_rtnMsg);
						
					}
					list.add(map);
				}
				
				map_hd = list.get(0);
				
				for(int i=0; i < list.size(); i++){
					map = (Map<String, String>)list.get(i);

					//0. KeP내부 품의 진행중일때 거래명세서 생성이 안되도록 hyun
					pm_cnt= (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckPM", map);
					logger.debug(" 품의진행체크  pm_cnt ==>> " + pm_cnt);
					if(pm_cnt != 0) {
						String mngInfo = sqlSessionTemplate.selectOne("common.mpiv.selectBuyerMngInfo", map);
						_rtnMsg = "KeP내부 품의 진행건이므로 거래명세서 생성이 불가능합니다.\n담당자("+mngInfo+")에게 문의 바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 납품 중복생성 체크
					res_cnt = (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckInvoice", map);
						
					logger.debug(" 납품 중복생성 체크  result_cnt ==>> " + res_cnt);
				
					if(res_cnt != 0) {
						_rtnMsg = "납품서가 이미 생성되어 있습니다. 다시 한번 확인해 주시기 바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}
					

					// 2. buyer == KRDOOS0003  : 두산메카텍 공작기계 ==>> LEGACY_IV_NO 생성/입력함.
					if(map.get("buyer").equals("KRDOOS0003")){
//						legacy_iv_no = getLegacyIvNo();
						
						legacy_iv_no = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvNo");
						logger.debug("LEGACY_IV_NO  ==>> " + legacy_iv_no);
						
						if("".equals(CommonUtil.nvl(legacy_iv_no))){
							logger.debug("LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
//							_rtnMsg = "LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
//							throw new RuntimeException(_rtnMsg);
						}
					}

					
					map.put("inv_no", 		inv_no);
					map.put("inv_seq", String.valueOf(i+1));
					map.put("legacy_iv_no", CommonUtil.nvl(legacy_iv_no));
					

//					map.put("buyer", 			str[0]);	KRKITU0003
//					map.put("po_no", 			str[1]);	PO14000014
//					map.put("po_seq", 			str[2]);	000001
//					map.put("cd_qty", 			str[3]);	50
//					map.put("invoice_date", 	str[4]);	20140620
//					map.put("ds_date", 			str[5]);	20140613
//					map.put("complete_mark", 	str[6]);	Y
//					map.put("inv_no", 		inv_no);		IV14150295
//					map.put("inv_seq", String.valueOf(i+1));
//					map.put("legacy_iv_no", legacy_iv_no);	IV14060001
					
					// 3. ICOMIVDT insert - 납품송장정보 insert					
					res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvdt_v3", map);
					
					if( res_cnt != 1){
						_rtnMsg = "송장생성중(INSERT INTO ICOMIVDT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}					
					
					// 4. ICOMPODT update - 발주제품정보 송장수량, 송장작성완료유무 update 
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePodt", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPODT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
		
	                // 5. ICOMPORS update - 발주 수주접수 COMPLETE_MARK(분할여부) = 'Y' update
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePors", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPORS) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					map.put("BUYER", CommonUtil.nvl(map.get("buyer"), ""));
					map.put("PO_NO", CommonUtil.nvl(map.get("po_no"), ""));
					map.put("PO_SEQ", CommonUtil.nvl(map.get("po_seq"), ""));
					
					lastLoginList = sqlSessionTemplate.selectOne("master.mpso.selectLastLoginIdWithPoInfo", map);
					
					// 주문요청자, 발주자 마지막 로그인정보 UPDATE
					map.put("LAST_LOGIN_ID", CommonUtil.nvl(lastLoginList.get("REQ_USER_ID"), ""));
					map.put("LAST_LOGIN_ID1",CommonUtil.nvl(lastLoginList.get("PURCHASER_ID"), ""));
					
					// 주문요청자 마지막 로그인 정보 UPDATE
			        sqlSessionTemplate.insert("login.saveLogintime", map);
			        
			        // 발주자 마지막 로그인 정보 UPDATE
			        sqlSessionTemplate.insert("login.saveLogintime1", map);
				}
				
				// 6. ICOMPOHD(발주마스터정보)에 COMPLETE_MARK를 'Y'로 UPDATE 할지를 결정하기 위한 SELECT
				
				String complete_mark_dis = sqlSessionTemplate.selectOne("common.mpiv.selectCompleteMarkDis", map_hd);
				
				// COMPLETE_MARK가 Y가 아닌경우 Y로 UPDATE
				if(!"".equals(CommonUtil.nvl(complete_mark_dis))){
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePohd", map_hd);
					
					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPOHD) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
				}
				
				// 7. ICOMIVHD insert start ====================
				logger.debug("7. ICOMIVHD insert start ====================");
				
	            String danger_good_flag  = "N";
	            String pkg_type          = "*";
	            String pkg_qty           = "0";
	            String weight_unit       = "*";
	            String gross_weight      = "0";
	            String measurement       = "0";
	            String ship_method       = "ROD";
	            String depart_port       = "*";
	            String arrival_port      = "*";
	            String lc_no             = " ";
	            
	            pMap.put("inv_no"			, inv_no);
	            
	            pMap.put("danger_good_flag"	, danger_good_flag);
	            pMap.put("pkg_type"			, pkg_type);
	            pMap.put("pkg_qty"			, pkg_qty);
	            pMap.put("weight_unit"		, weight_unit);
	            pMap.put("gross_weight"		, gross_weight);
	            pMap.put("measurement"		, measurement);
	            pMap.put("ship_method"		, ship_method);
	            pMap.put("depart_port"		, depart_port);
	            pMap.put("arrival_port"		, arrival_port);
	            pMap.put("lc_no"			, lc_no);

	            if(process_type.equals("0") && car_flag.equals("Y")){
	            	String tmp_str[] = car_info.split("@@",-1); 
	            	pMap.put("car_no"			, String.valueOf(tmp_str[1]));
	            	pMap.put("car_person_name"	, String.valueOf(tmp_str[2]));
	            	pMap.put("car_person_tel"	, String.valueOf(tmp_str[3]));
	            }
	            
	            String buyer = map_hd.get("buyer");
	            String po_no = map_hd.get("po_no");
	            
	            pMap.put("buyer", buyer);
	            pMap.put("po_no", po_no);
	            
	            
				// 7-1. legacy_iv_serial_doos0006  조회 후 ICOMIVHD insert 시 사용.
	            logger.debug("****************************************");
	            logger.debug("* Buyer        : " + pMap.get("buyer"));
				logger.debug("* Inv No       : " + inv_no);
				logger.debug("* Po No        : " + pMap.get("po_no"));
				logger.debug("* Process Type : " + process_type);
				logger.debug("****************************************");
				
				
				String legacy_iv_serial = "";
				String query = "";
				
				
				//SLOGIC-BEGIN(P06-0000004) : 거래명세서 저장시, 직납일때, LEGACY_IV_SERIAL 생성로직 다름
				String sLogicData = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000004","COL01_DATA");
				//SLOGIC-END
				
				logger.debug("==============================================================");
				logger.debug("buyer : "+ buyer );
				logger.debug("sLogicData : "+ sLogicData );
				logger.debug("==============================================================");
				
	            if(sLogicData.equals("TK") && process_type.equals("0")) {	//buyer.equals("KRDOOS0006")
					
	            	legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialDoos0006");

	            	if("".equals(CommonUtil.nvl(legacy_iv_serial))){
	            		logger.debug("두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.");
//						_rtnMsg = "두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("HYOS") && process_type.equals("0")) {	//(buyer.equals("KRHYOS0017") || buyer.equals("KRHYOS0018"))

					query = "FUN_SEQ_MNG('SEQ_HYOS_INV_NO')||'^'||FUN_SEQ_MNG('SEQ_HYOS_MNG_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
							
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("HYOS_SAP") && process_type.equals("0")) {	//(buyer.equals("KRHYOS0033") || buyer.equals("KRHYOS0034") || buyer.equals("KRHYOS0036") || buyer.equals("KRHYOS0037"))
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer2", pMap);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
					
					
//					pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
	                
				} else if(sLogicData.equals("SUNG") && process_type.equals("0")) {	//buyer.equals("KRSUNG0254")
	                
					query = "FUN_SEQ_MNG('SEQ_SDSM_INV_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
	                
				} else if(sLogicData.equals("SSAN") && process_type.equals("0")) {	//buyer.equals("KRSSAN0025")
	                
					query = "GET_CSTMR_DEAL_STTMN_NO('KRSSAN0025')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("LTAL2") && process_type.equals("0")) {
					query = "FUN_SEQ_MNG('SEQ_LTAL2_INV_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
				}
//				else {
//	                pstmt6.setString(20,""                       );      // LEGACY_IV_SERIAL
//					pMap.put("legacy_iv_serial", "");
//				}
	            
	            pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
	            
	            logger.debug("pMap 출력 start ====================");
	            
	            Set<String> keySet = pMap.keySet();
	            Iterator<String> iterator = keySet.iterator();
	            
	            while(iterator.hasNext()){
	            	String key = iterator.next();
	            	String value = pMap.get(key);
	            	logger.debug("key : "+key+", value : "+value);
	            }
	            
	            logger.debug("pMap 출력 end ====================");
	            
	            res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvhd", pMap);
	            logger.debug("7. ICOMIVHD insert end ====================");
				// 7. ICOMIVHD insert  end =========================
	            
	            
	            // 8. 조건에 따라 대우조선 송장 차수 생성 - ICOMIVHD update	            
//	            if(buyer.equals("KRDAEW0016") && !process_type.equals("2") ){
//	            	
//	            	legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerial", pMap);
//	            	
//	            	if("".equals(CommonUtil.nvl(legacy_iv_serial))){
//	            		logger.debug("대우조선 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
////	            		_rtnMsg = "대우조선 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
////						throw new RuntimeException(_rtnMsg);
//	            	}
//	            	
//	            	pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
//	            	
//	            	res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWriteIvhd", pMap);
//	            	
////	            	if( res_cnt != 1){
////	            		_rtnMsg = "대우조선 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
////						throw new RuntimeException(_rtnMsg);
////					}
//	            }
			}
		
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "거래명세서 작성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		
		resMap.put("action_flag", _actionFlag);
		resMap.put("msg", _rtnMsg);
		resMap.put("inv_no", inv_no);
		
		return resMap;
	}

	/**
	 * doc_type별 번호생성
	 * 
	 * @param pMap
	 * @param doc_type
	 * @return
	 */
	public String getOrderNo(Map<String, String> pMap){
		
		String order_no = "";
		String doc_type = "";
		try{
			doc_type = pMap.get("doc_type");
		
			// doc_type별 번호 생성
			order_no = sqlSessionTemplate.selectOne("common.mpiv.selectOrderNo", pMap);
			
			if("".equals(CommonUtil.nvl(order_no))){
			
				// 현재 Company 코드에 해당하는 type의 코드가 존재하지 않는 경우 새로 번호를 생성한다.
				sqlSessionTemplate.insert("common.mpiv.insertOrderNo", pMap);
				
				int year_num = Calendar.getInstance().get(Calendar.YEAR);
	            String year_str = String.valueOf(year_num);
	            order_no = doc_type+year_str.substring(2,4) + "000001";
	            
			} else {
				sqlSessionTemplate.update("common.mpiv.updateOrderNo",pMap);
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("거래명세서 작성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
		}
			
		return order_no;
	}

	// 리스트 조회_분할납품
	public List<Map<String,String>> selectDoosanmecaList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvTranStatementWriteDoosanmecaPopList", pMap);
	}
	public List<Map<String,String>> getSellerMpIvTranStatementWriteDoosanmecaPop_v2(Map<String,Object> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.getSellerMpIvTranStatementWriteDoosanmecaPop_v2", pMap);
	}
	
	

	// 거래명세서 작성 저장_Doosanmeca
	public Map<String, String> saveSellerMpIvTranStatementWriteDoosanmecaPop(Map<String, String> pMap){
		
		Map<String, String> resMap = new HashMap<String, String>();
		String _rtnMsg = "";
		String _actionFlag = "";
		
		
//		Parameters =  [ {
		
//		query +=  buyer         + "@@";
//		query +=  po_no         + "@@";
//		query +=  po_seq        + "@@";
//		query +=  cd_qty        + "@@";
//		query +=  invoice_date  + "@@";
//		query +=  ds_date       + "@@";
//		query +=  complete_mark       ;
//		  st_query	= 	KRKITU0003@@PO14000014@@000001@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000002@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000003@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000004@@50@@20140620@@20140613@@Y^||^
//		, st_seller=KRKORE0001
//		, st_process_type=0
//		, st_legacy_po_no=N
//		, st_inv_no=
//		, st_type=
//		, st_car_info=
//		, st_car_flag=N
//		, st_inv_amt=324500
//		, st_inv_tax_amt=32450
//		, st_inv_tax_rate=0.1
//		, st_invoice_date_text=2014/06/20
//		, st_inv_tot_amt=356950
//		, st_remark=
//		, st_buyer=KRKITU0003
//		, st_po_no=PO14000014
//		, st_ds_date=20140613
//		, st_po_seq=000001
//		, st_cd_qty=50
//		, st_po_qty=100
//		, st_iv_qty=50
//		, st_iv_cre_check=1, checkbox0=, checkbox1=, checkbox2=, checkbox3=
//		, display_item_cnt=4
//		, legacy_po_seq_tot=@@@@@@@@
//		, st_pur_id=LKDSPQ09
//		, st_inv_data=}, ]
		
//	    Vector v                = new Vector();
	    
		Map<String, String> map;
		Map<String, String> map_hd;
		int res_cnt = 0;
		int pm_cnt=0;
		
		String doc_type 		= "IV";
		String inv_no			= "";	// 송장번호
		String legacy_iv_no 	= "";	// 두산메카텍 공작기계 LEGACY_IV_NO 생성/입력함.
		
		double tot_inv_qty = 0;
		
		try{
		    String query_str				= CommonUtil.nvl(pMap.get("st_query"),"");
		    List<Map<String, String>> list	= new ArrayList<Map<String, String>>();
		    
		    String process_type     = CommonUtil.nvl(pMap.get("st_process_type"),"");

			String action_id		= CommonUtil.nvl(pMap.get("st_action_id"),"");
			String car_info			= CommonUtil.nvl(pMap.get("st_car_info"),"");
			String car_flag			= CommonUtil.nvl(pMap.get("st_car_flag"),"");
			//박스수량 입력
			String ktag_box_qty			= CommonUtil.nvl(pMap.get("ktag_box_qty"),"");
			
			// 배송유형
			String parcel_yn 		= CommonUtil.nvl(pMap.get("st_parcel_yn"),"N");  
			
			// actionId 조회 - 현재 작업중인지 확인..
			String action_flag = CommonUtil.getActionIdList(action_id);
			
			if("Y".equals(action_flag)){
				_actionFlag = "DO";
				_rtnMsg = "해당건에 대해서 현재 작업중입니다.";
				throw new RuntimeException(_rtnMsg);
			} else {

				pMap.put("doc_type", doc_type);
			    // doc_type별 inv_no(송장번호) 생성
			    inv_no = getOrderNo(pMap);
								

				
				String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
				
				for(int i=0 ; i < check_str.length; i++){
					String str[] = check_str[i].split("@@",-1);
					
					map = new HashMap<String, String>();
					
					map.put("st_buyer", 			str[0]);
					map.put("buyer", 			str[0]);
					map.put("po_no", 			str[1]);
					map.put("st_po_no", 			str[1]);
					map.put("po_seq", 			str[2]);
					map.put("st_po_seq", 			str[2]);
					map.put("cd_qty", 			str[3]);
					map.put("invoice_date", 	str[4]);
					map.put("ds_date", 			str[5]);
					map.put("complete_mark", 	str[6]);
					map.put("po_qty", 			str[7]);
					map.put("inv_qty", 			str[8]);
					
					// 길이, 수량 이용 시 JSP에서 하기 항목들 추가되어 넘어옴
					if(str != null && str.length >= 10){
						map.put("size_yn", 			str[9]);
						map.put("size_len", 			str[10]);
						map.put("size_qty", 			str[11]);
					}
					map.put("ktag_box_qty", ktag_box_qty);
					map.put("parcel_yn", parcel_yn);
					list.add(map);
					//여신한도 초과 체크
					List<Map<String,String>>_list2 = null;
					_list2 = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivCreditLimitSttsCheck",map);
					String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
					if(credit_limit_flag.equals("Y")){
						_rtnMsg = "거래명세서 생성이 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
								+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
						throw new RuntimeException(_rtnMsg);
						
					}
				}
				
				map_hd = list.get(0);
				
				for(int i=0; i < list.size(); i++){
					map = (Map<String, String>)list.get(i);
					
					//0. KeP내부 품의 진행중일때 거래명세서 생성이 안되도록 hyun
					pm_cnt= (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckPM", map);
					logger.debug(" 품의진행체크  pm_cnt ==>> " + pm_cnt);
					if(pm_cnt != 0) {
						String mngInfo = sqlSessionTemplate.selectOne("common.mpiv.selectBuyerMngInfo", map);
						_rtnMsg = "KeP내부 품의 진행건이므로 거래명세서 생성이 불가능합니다.\n담당자("+mngInfo+")에게 문의 바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 납품 중복생성 체크
					res_cnt = (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckInvoice", map);
						
					logger.debug(" 납품 중복생성 체크  result_cnt ==>> " + res_cnt);
				
					if(res_cnt != 0) {
						_rtnMsg = "납품서가 이미 생성되어 있습니다. 다시 한번 확인해 주시기 바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}
					

					// 2. buyer == KRDOOS0003  : 두산메카텍 공작기계 ==>> LEGACY_IV_NO 생성/입력함.
					if(map.get("buyer").equals("KRDOOS0003")){
//						legacy_iv_no = getLegacyIvNo();
						
						legacy_iv_no = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvNo");
						logger.debug("LEGACY_IV_NO  ==>> " + legacy_iv_no);
						
						if("".equals(CommonUtil.nvl(legacy_iv_no))){
							logger.debug("LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
						
//							_rtnMsg = "LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
//							throw new RuntimeException(_rtnMsg);
						}
					}

					
					tot_inv_qty = Double.parseDouble(map.get("cd_qty")) + Double.parseDouble(map.get("inv_qty"));
					
					if(Double.parseDouble(map.get("po_qty")) < tot_inv_qty) {
						_rtnMsg = "납품서 수량 초과 발행";
						throw new RuntimeException(_rtnMsg);
					}  

				    // doc_type별 inv_no(송장번호) 생성
					//inv_no = getOrderNo(pMap);
					map.put("inv_no", 		inv_no);
					map.put("inv_seq", String.valueOf(i+1));
					map.put("legacy_iv_no", CommonUtil.nvl(legacy_iv_no));
					

//					map.put("buyer", 			str[0]);	KRKITU0003
//					map.put("po_no", 			str[1]);	PO14000014
//					map.put("po_seq", 			str[2]);	000001
//					map.put("cd_qty", 			str[3]);	50
//					map.put("invoice_date", 	str[4]);	20140620
//					map.put("ds_date", 			str[5]);	20140613
//					map.put("complete_mark", 	str[6]);	Y
//					map.put("inv_no", 		inv_no);		IV14150295
//					map.put("inv_seq", String.valueOf(i+1));
//					map.put("legacy_iv_no", legacy_iv_no);	IV14060001
					
					// 3. ICOMIVDT insert - 납품송장정보 insert					
					res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvdt", map);
					
					if( res_cnt != 1){
						_rtnMsg = "송장생성중(INSERT INTO ICOMIVDT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
	                // 5. ICOMPORS update - 발주 수주접수 COMPLETE_MARK(분할여부) = 'Y' update
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePors", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPORS) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 4. ICOMPODT update - 발주제품정보 송장수량, 송장작성완료유무 update 
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePodt", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPODT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
				}
				
				// 6. ICOMPOHD(발주마스터정보)에 COMPLETE_MARK를 'Y'로 UPDATE 할지를 결정하기 위한 SELECT
				
				String complete_mark_dis = sqlSessionTemplate.selectOne("common.mpiv.selectCompleteMarkDis", map_hd);
				
				// COMPLETE_MARK가 Y가 아닌경우 Y로 UPDATE
				if(!"".equals(CommonUtil.nvl(complete_mark_dis))){
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePohd", map_hd);
					
					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPOHD) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
				}
				
				// 7. ICOMIVHD insert start ====================
				logger.debug("7. ICOMIVHD insert start ====================");
				
	            String danger_good_flag  = "N";
	            String pkg_type          = "*";
	            String pkg_qty           = "0";
	            String weight_unit       = "*";
	            String gross_weight      = "0";
	            String measurement       = "0";
	            String ship_method       = "ROD";
	            String depart_port       = "*";
	            String arrival_port      = "*";
	            String lc_no             = " ";
	            
	            pMap.put("inv_no"			, inv_no);
	            
	            pMap.put("danger_good_flag"	, danger_good_flag);
	            pMap.put("pkg_type"			, pkg_type);
	            pMap.put("pkg_qty"			, pkg_qty);
	            pMap.put("weight_unit"		, weight_unit);
	            pMap.put("gross_weight"		, gross_weight);
	            pMap.put("measurement"		, measurement);
	            pMap.put("ship_method"		, ship_method);
	            pMap.put("depart_port"		, depart_port);
	            pMap.put("arrival_port"		, arrival_port);
	            pMap.put("lc_no"			, lc_no);

	            if(process_type.equals("0") && car_flag.equals("Y")){
	            	String tmp_str[] = car_info.split("@@",-1); 
	            	pMap.put("car_no"			, String.valueOf(tmp_str[1]));
	            	pMap.put("car_person_name"	, String.valueOf(tmp_str[2]));
	            	pMap.put("car_person_tel"	, String.valueOf(tmp_str[3]));
	            }
	            
	            String buyer = map_hd.get("buyer");
	            String po_no = map_hd.get("po_no");
	            
	            pMap.put("buyer", buyer);
	            pMap.put("po_no", po_no);
	            
	            
				// 7-1. legacy_iv_serial_doos0006  조회 후 ICOMIVHD insert 시 사용.
	            logger.debug("****************************************");
	            logger.debug("* Buyer        : " + pMap.get("buyer"));
	            logger.debug("* Inv No       : " + inv_no);
	            logger.debug("* Po No        : " + pMap.get("po_no"));
	            logger.debug("* Process Type : " + process_type);
	            logger.debug("****************************************");
				
				
				String legacy_iv_serial = "";
				String query = "";
				
				//SLOGIC-BEGIN(P06-0000004) : 거래명세서 저장시, 직납일때, LEGACY_IV_SERIAL 생성로직 다름
				String sLogicData = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000004","COL01_DATA");
				//SLOGIC-END
				
				logger.debug("==============================================================");
				logger.debug("buyer : "+ buyer );
				logger.debug("sLogicData : "+ sLogicData );
				logger.debug("==============================================================");
				
	            if(sLogicData.equals("TK") && process_type.equals("0")) {	//buyer.equals("KRDOOS0006")
	            	
	            	legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialDoos0006");
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.");
//						_rtnMsg = "두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("HYOS") && process_type.equals("0")) {	//(buyer.equals("KRHYOS0017") || buyer.equals("KRHYOS0018"))

					query = "FUN_SEQ_MNG('SEQ_HYOS_INV_NO')||'^'||FUN_SEQ_MNG('SEQ_HYOS_MNG_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("HYOS_SAP") && process_type.equals("0")) {	//(buyer.equals("KRHYOS0033") || buyer.equals("KRHYOS0034") || buyer.equals("KRHYOS0036") || buyer.equals("KRHYOS0037"))
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer2", pMap);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
	                
				} else if(sLogicData.equals("SUNG") && process_type.equals("0")) {	//buyer.equals("KRSUNG0254")
	                
					query = "FUN_SEQ_MNG('SEQ_SDSM_INV_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
	                
				} else if(sLogicData.equals("SSAN") && process_type.equals("0")) {	//buyer.equals("KRSSAN0025")
	                
					query = "GET_CSTMR_DEAL_STTMN_NO('KRSSAN0025')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
				} else if(sLogicData.equals("LTAL2") && process_type.equals("0")) {
					query = "FUN_SEQ_MNG('SEQ_LTAL2_INV_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
				}
//				else {
//					pMap.put("legacy_iv_serial", "");
//				}
				
	            pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
	            
	            logger.debug("pMap 출력 start ====================");
	            
	            Set<String> keySet = pMap.keySet();
	            Iterator<String> iterator = keySet.iterator();
	            
	            while(iterator.hasNext()){
	            	String key = iterator.next();
	            	String value = pMap.get(key);
	            	logger.debug("key : "+key+", value : "+value);
	            }
	            
	            logger.debug("pMap 출력 end ====================");
	            
	            res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvhd", pMap);
	            logger.debug("7. ICOMIVHD insert end ====================");
	            
	            if( res_cnt != 1){
	            	_rtnMsg = "송장생성중(INSERT ICOMIVHD ) 에러가 발생하였습니다.";
					throw new RuntimeException(_rtnMsg);
	            }
				// 7. ICOMIVHD insert  end =========================
	            
			}
		
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			
			if(_rtnMsg.equals("")){
				_rtnMsg = "거래명세서 작성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
			}
			
			throw new RuntimeException(_rtnMsg);
		}
		
		
		resMap.put("action_flag", _actionFlag);
		resMap.put("msg", _rtnMsg);
		resMap.put("inv_no", inv_no);
		
		return resMap;
	}
public Map<String, String> saveSellerMpIvTranStatementWriteDoosanmecaPop_v3(Map<String, String> pMap){
		
		Map<String, String> resMap = new HashMap<String, String>();
		String _rtnMsg = "";
		String _actionFlag = "";
		
		
//		Parameters =  [ {
		
//		query +=  buyer         + "@@";
//		query +=  po_no         + "@@";
//		query +=  po_seq        + "@@";
//		query +=  cd_qty        + "@@";
//		query +=  invoice_date  + "@@";
//		query +=  ds_date       + "@@";
//		query +=  complete_mark       ;
//		  st_query	= 	KRKITU0003@@PO14000014@@000001@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000002@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000003@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000004@@50@@20140620@@20140613@@Y^||^
//		, st_seller=KRKORE0001
//		, st_process_type=0
//		, st_legacy_po_no=N
//		, st_inv_no=
//		, st_type=
//		, st_car_info=
//		, st_car_flag=N
//		, st_inv_amt=324500
//		, st_inv_tax_amt=32450
//		, st_inv_tax_rate=0.1
//		, st_invoice_date_text=2014/06/20
//		, st_inv_tot_amt=356950
//		, st_remark=
//		, st_buyer=KRKITU0003
//		, st_po_no=PO14000014
//		, st_ds_date=20140613
//		, st_po_seq=000001
//		, st_cd_qty=50
//		, st_po_qty=100
//		, st_iv_qty=50
//		, st_iv_cre_check=1, checkbox0=, checkbox1=, checkbox2=, checkbox3=
//		, display_item_cnt=4
//		, legacy_po_seq_tot=@@@@@@@@
//		, st_pur_id=LKDSPQ09
//		, st_inv_data=}, ]
		
//	    Vector v                = new Vector();
	    
		Map<String, String> map;
		Map<String, String> map_hd;
		int res_cnt = 0;
		int pm_cnt=0;
		
		String doc_type 		= "IV";
		String inv_no			= "";	// 송장번호
		String legacy_iv_no 	= "";	// 두산메카텍 공작기계 LEGACY_IV_NO 생성/입력함.
		
		double tot_inv_qty = 0;
		
		try{
		    String query_str				= CommonUtil.nvl(pMap.get("st_query"),"");
		    List<Map<String, String>> list	= new ArrayList<Map<String, String>>();
		    
		    String process_type     = CommonUtil.nvl(pMap.get("st_process_type"),"");

			String action_id		= CommonUtil.nvl(pMap.get("st_action_id"),"");
			String car_info			= CommonUtil.nvl(pMap.get("st_car_info"),"");
			String car_flag			= CommonUtil.nvl(pMap.get("st_car_flag"),"");
			//박스수량 입력
			String ktag_box_qty			= CommonUtil.nvl(pMap.get("ktag_box_qty"),"");
			
			// 배송유형
			String parcel_yn 		= CommonUtil.nvl(pMap.get("st_parcel_yn"),"N");  
			
			// actionId 조회 - 현재 작업중인지 확인..
			String action_flag = CommonUtil.getActionIdList(action_id);
			
			if("Y".equals(action_flag)){
				_actionFlag = "DO";
				_rtnMsg = "해당건에 대해서 현재 작업중입니다.";
				throw new RuntimeException(_rtnMsg);
			} else {

				pMap.put("doc_type", doc_type);
			    // doc_type별 inv_no(송장번호) 생성
			    inv_no = getOrderNo(pMap);
								

				
				String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
				
				for(int i=0 ; i < check_str.length; i++){
					String str[] = check_str[i].split("@@",-1);
					
					map = new HashMap<String, String>();
					
					map.put("st_buyer", 			str[0]);
					map.put("buyer", 			str[0]);
					map.put("po_no", 			str[1]);
					map.put("st_po_no", 			str[1]);
					map.put("po_seq", 			str[2]);
					map.put("st_po_seq", 			str[2]);
					map.put("cd_qty", 			str[3]);
					map.put("invoice_date", 	str[4]);
					map.put("ds_date", 			str[5]);
					map.put("complete_mark", 	str[6]);
					map.put("po_qty", 			str[7]);
					map.put("inv_qty", 			str[8]);
					
					// 길이, 수량 이용 시 JSP에서 하기 항목들 추가되어 넘어옴
					if(str != null && str.length >= 10){
						map.put("size_yn", 			str[9]);
						map.put("size_len", 			str[10]);
						map.put("size_qty", 			str[11]);
					}
					map.put("ktag_box_qty", ktag_box_qty);
					map.put("parcel_yn", parcel_yn);
					list.add(map);
					//여신한도 초과 체크
					List<Map<String,String>>_list2 = null;
					_list2 = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivCreditLimitSttsCheck",map);
					String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
					if(credit_limit_flag.equals("Y")){
						_rtnMsg = "거래명세서 생성이 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
								+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
						throw new RuntimeException(_rtnMsg);
						
					}
				}
				
				map_hd = list.get(0);
				
				for(int i=0; i < list.size(); i++){
					map = (Map<String, String>)list.get(i);
					
					//0. KeP내부 품의 진행중일때 거래명세서 생성이 안되도록 hyun
					pm_cnt= (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckPM", map);
					logger.debug(" 품의진행체크  pm_cnt ==>> " + pm_cnt);
					if(pm_cnt != 0) {
						String mngInfo = sqlSessionTemplate.selectOne("common.mpiv.selectBuyerMngInfo", map);
						_rtnMsg = "KeP내부 품의 진행건이므로 거래명세서 생성이 불가능합니다.\n담당자("+mngInfo+")에게 문의 바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 납품 중복생성 체크
					res_cnt = (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckInvoice", map);
						
					logger.debug(" 납품 중복생성 체크  result_cnt ==>> " + res_cnt);
				
					if(res_cnt != 0) {
						_rtnMsg = "납품서가 이미 생성되어 있습니다. 다시 한번 확인해 주시기 바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}
					

					// 2. buyer == KRDOOS0003  : 두산메카텍 공작기계 ==>> LEGACY_IV_NO 생성/입력함.
					if(map.get("buyer").equals("KRDOOS0003")){
//						legacy_iv_no = getLegacyIvNo();
						
						legacy_iv_no = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvNo");
						logger.debug("LEGACY_IV_NO  ==>> " + legacy_iv_no);
						
						if("".equals(CommonUtil.nvl(legacy_iv_no))){
							logger.debug("LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
						
//							_rtnMsg = "LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
//							throw new RuntimeException(_rtnMsg);
						}
					}

					
					tot_inv_qty = Double.parseDouble(map.get("cd_qty")) + Double.parseDouble(map.get("inv_qty"));
					
					if(Double.parseDouble(map.get("po_qty")) < tot_inv_qty) {
						_rtnMsg = "납품서 수량 초과 발행";
						throw new RuntimeException(_rtnMsg);
					}  

				    // doc_type별 inv_no(송장번호) 생성
					//inv_no = getOrderNo(pMap);
					map.put("inv_no", 		inv_no);
					map.put("inv_seq", String.valueOf(i+1));
					map.put("legacy_iv_no", CommonUtil.nvl(legacy_iv_no));
					

//					map.put("buyer", 			str[0]);	KRKITU0003
//					map.put("po_no", 			str[1]);	PO14000014
//					map.put("po_seq", 			str[2]);	000001
//					map.put("cd_qty", 			str[3]);	50
//					map.put("invoice_date", 	str[4]);	20140620
//					map.put("ds_date", 			str[5]);	20140613
//					map.put("complete_mark", 	str[6]);	Y
//					map.put("inv_no", 		inv_no);		IV14150295
//					map.put("inv_seq", String.valueOf(i+1));
//					map.put("legacy_iv_no", legacy_iv_no);	IV14060001
					
					// 3. ICOMIVDT insert - 납품송장정보 insert					
					res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvdt_v3", map);
					
					if( res_cnt != 1){
						_rtnMsg = "송장생성중(INSERT INTO ICOMIVDT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
	                // 5. ICOMPORS update - 발주 수주접수 COMPLETE_MARK(분할여부) = 'Y' update
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePors", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPORS) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 4. ICOMPODT update - 발주제품정보 송장수량, 송장작성완료유무 update 
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePodt", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPODT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
				}
				
				// 6. ICOMPOHD(발주마스터정보)에 COMPLETE_MARK를 'Y'로 UPDATE 할지를 결정하기 위한 SELECT
				
				String complete_mark_dis = sqlSessionTemplate.selectOne("common.mpiv.selectCompleteMarkDis", map_hd);
				
				// COMPLETE_MARK가 Y가 아닌경우 Y로 UPDATE
				if(!"".equals(CommonUtil.nvl(complete_mark_dis))){
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePohd", map_hd);
					
					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPOHD) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
				}
				
				// 7. ICOMIVHD insert start ====================
				logger.debug("7. ICOMIVHD insert start ====================");
				
	            String danger_good_flag  = "N";
	            String pkg_type          = "*";
	            String pkg_qty           = "0";
	            String weight_unit       = "*";
	            String gross_weight      = "0";
	            String measurement       = "0";
	            String ship_method       = "ROD";
	            String depart_port       = "*";
	            String arrival_port      = "*";
	            String lc_no             = " ";
	            
	            pMap.put("inv_no"			, inv_no);
	            
	            pMap.put("danger_good_flag"	, danger_good_flag);
	            pMap.put("pkg_type"			, pkg_type);
	            pMap.put("pkg_qty"			, pkg_qty);
	            pMap.put("weight_unit"		, weight_unit);
	            pMap.put("gross_weight"		, gross_weight);
	            pMap.put("measurement"		, measurement);
	            pMap.put("ship_method"		, ship_method);
	            pMap.put("depart_port"		, depart_port);
	            pMap.put("arrival_port"		, arrival_port);
	            pMap.put("lc_no"			, lc_no);

	            if(process_type.equals("0") && car_flag.equals("Y")){
	            	String tmp_str[] = car_info.split("@@",-1); 
	            	pMap.put("car_no"			, String.valueOf(tmp_str[1]));
	            	pMap.put("car_person_name"	, String.valueOf(tmp_str[2]));
	            	pMap.put("car_person_tel"	, String.valueOf(tmp_str[3]));
	            }
	            
	            String buyer = map_hd.get("buyer");
	            String po_no = map_hd.get("po_no");
	            
	            pMap.put("buyer", buyer);
	            pMap.put("po_no", po_no);
	            
	            
				// 7-1. legacy_iv_serial_doos0006  조회 후 ICOMIVHD insert 시 사용.
	            logger.debug("****************************************");
	            logger.debug("* Buyer        : " + pMap.get("buyer"));
	            logger.debug("* Inv No       : " + inv_no);
	            logger.debug("* Po No        : " + pMap.get("po_no"));
	            logger.debug("* Process Type : " + process_type);
	            logger.debug("****************************************");
				
				
				String legacy_iv_serial = "";
				String query = "";
				
				//SLOGIC-BEGIN(P06-0000004) : 거래명세서 저장시, 직납일때, LEGACY_IV_SERIAL 생성로직 다름
				String sLogicData = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000004","COL01_DATA");
				//SLOGIC-END
				
				logger.debug("==============================================================");
				logger.debug("buyer : "+ buyer );
				logger.debug("sLogicData : "+ sLogicData );
				logger.debug("==============================================================");
				
	            if(sLogicData.equals("TK") && process_type.equals("0")) {	//buyer.equals("KRDOOS0006")
	            	
	            	legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialDoos0006");
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.");
//						_rtnMsg = "두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("HYOS") && process_type.equals("0")) {	//(buyer.equals("KRHYOS0017") || buyer.equals("KRHYOS0018"))

					query = "FUN_SEQ_MNG('SEQ_HYOS_INV_NO')||'^'||FUN_SEQ_MNG('SEQ_HYOS_MNG_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("HYOS_SAP") && process_type.equals("0")) {	//(buyer.equals("KRHYOS0033") || buyer.equals("KRHYOS0034") || buyer.equals("KRHYOS0036") || buyer.equals("KRHYOS0037"))
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer2", pMap);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
	                
				} else if(sLogicData.equals("SUNG") && process_type.equals("0")) {	//buyer.equals("KRSUNG0254")
	                
					query = "FUN_SEQ_MNG('SEQ_SDSM_INV_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
	                
				} else if(sLogicData.equals("SSAN") && process_type.equals("0")) {	//buyer.equals("KRSSAN0025")
	                
					query = "GET_CSTMR_DEAL_STTMN_NO('KRSSAN0025')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
				} else if(sLogicData.equals("LTAL2") && process_type.equals("0")) {
					query = "FUN_SEQ_MNG('SEQ_LTAL2_INV_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
				}
//				else {
//					pMap.put("legacy_iv_serial", "");
//				}
				
	            pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
	            
	            logger.debug("pMap 출력 start ====================");
	            
	            Set<String> keySet = pMap.keySet();
	            Iterator<String> iterator = keySet.iterator();
	            
	            while(iterator.hasNext()){
	            	String key = iterator.next();
	            	String value = pMap.get(key);
	            	logger.debug("key : "+key+", value : "+value);
	            }
	            
	            logger.debug("pMap 출력 end ====================");
	            
	            res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvhd", pMap);
	            logger.debug("7. ICOMIVHD insert end ====================");
	            
	            if( res_cnt != 1){
	            	_rtnMsg = "송장생성중(INSERT ICOMIVHD ) 에러가 발생하였습니다.";
					throw new RuntimeException(_rtnMsg);
	            }
				// 7. ICOMIVHD insert  end =========================
	            
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			
			if(_rtnMsg.equals("")){
				_rtnMsg = "거래명세서 작성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
			}
			
			throw new RuntimeException(_rtnMsg);
		}
		
		
		resMap.put("action_flag", _actionFlag);
		resMap.put("msg", _rtnMsg);
		resMap.put("inv_no", inv_no);
		
		return resMap;
	}

	// 리스트조회_두산인프라용 팝업
	public List<Map<String,String>> selectDiList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvTranStatementWriteDiPopList", pMap);
	}
	public List<Map<String,String>> getSellerMpIvTranStatementWriteDiPop_v2(Map<String,Object> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.getSellerMpIvTranStatementWriteDiPop_v2", pMap);
	}
	
	// 리스트조회_두산인프라 팝업 PO LIST 조회
	public List<Map<String,String>> selectLegacyPoList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvTranStatementWritePoList", pMap);
	}
		
	public Map<String,String> getInvHdList(Map<String,String> pMap){
		return sqlSessionTemplate.selectOne("common.mpiv.selectSellerMpIvInvHdList", pMap);
	}
	
	public List<Map<String,String>> getInvDtList(Map<String,String> pMap){
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvInvDtList", pMap);
	}
	
	public String updateIvdt(Map<String,String> pMap){
		
		int res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementIvdt", pMap);
		
		return res_cnt+"";
	}
	
	// 물질정보제출 협력사 요청
	public Map<String, String> saveSellerMpIvTranStatementWriteChemicalInfo(Map<String, String> pMap){
		
		Map<String, String> resMap = new HashMap<String, String>();
		String _rtnMsg = "";
		
		Map<String, String> map;
		
		try{
		    String query_str				= CommonUtil.nvl(pMap.get("st_query"),"");
		    String st_user_id				= CommonUtil.nvl(pMap.get("st_user_id"),"");
		    List<Map<String, String>> list	= new ArrayList<Map<String, String>>();
			
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				map = new HashMap<String, String>();
				map.put("st_buyer", 			str[0]);
				map.put("st_po_no", 			str[1]);
				map.put("st_user_id", 			st_user_id);
				
				list.add(map);
			}
			
			for(int i=0; i < list.size(); i++){
				map = (Map<String, String>)list.get(i);

				map.put("st_buyer", CommonUtil.nvl(map.get("st_buyer"), ""));
				map.put("st_po_no", CommonUtil.nvl(map.get("st_po_no"), ""));
				map.put("st_user_id", CommonUtil.nvl(map.get("st_user_id"), ""));
				
				sqlSessionTemplate.insert("common.mpiv.insertSellerMpIvChemicalInfo", map);
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "물질정보제출 요청에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		
		resMap.put("msg", _rtnMsg);
		
		return resMap;
	}
	
	// 물류센터 고객사 체크
	@Override	
	public String getW001Flag(Map<String, String> pMap) {
		
		String flag = "N";
		int cnt = 0;
		cnt = (Integer)sqlSessionTemplate.selectOne("common.mpiv.getW001Flag", pMap);
		
		if(cnt > 0) {
			flag = "Y";
		}
		
		return flag;
	}
	
	
	// 거래명세서 작성 저장-품목별(다중)
	public Map<String, String> saveSellerMpIvTranStatementWriteItemPop(Map<String, String> pMap){
		
		Map<String, String> resMap = new HashMap<String, String>();
		String _rtnMsg = "";
		String _actionFlag = "";
		
		Map<String, String> lastLoginList = null;
	    
		Map<String, String> map;
		Map<String, String> map_hd = null;
		int res_cnt = 0;
		
		String group_no_arr_temp = CommonUtil.nvl(pMap.get("st_group_no_arr"),"");
		String group_no_arr[]  = CommonUtil.StrToArray(group_no_arr_temp , ",");
		
		String doc_type 		= "IV";
		String inv_no			= "";	// 송장번호
		String legacy_iv_no 	= "";	// 두산메카텍 공작기계 LEGACY_IV_NO 생성/입력함.
		
		try{
		    String query_str				= CommonUtil.nvl(pMap.get("st_query"),"");
		    List<Map<String, String>> list	= new ArrayList<Map<String, String>>();
		    
			String action_id		= CommonUtil.nvl(pMap.get("st_action_id"),"");
			int pm_cnt=0;
			// actionId 조회 - 현재 작업중인지 확인..
			String action_flag = CommonUtil.getActionIdList(action_id);
			
			if("Y".equals(action_flag)){
				_actionFlag = "DO";
				_rtnMsg = "해당건에 대해서 현재 작업중입니다.";
				throw new RuntimeException(_rtnMsg);
			} else {
				String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
				for(int i=0 ; i < check_str.length; i++){
					String str[] = check_str[i].split("@@",-1);
					map = new HashMap<String, String>();
					map.put("st_buyer", 			str[0]);
					map.put("buyer", 			str[0]);
					map.put("po_no", 			str[1]);
					map.put("st_po_no", 			str[1]);
					map.put("po_seq", 			str[2]);
					map.put("st_po_seq", 			str[2]);
					map.put("po_qty", 			str[3]);
					map.put("cd_qty", 			str[4]);
					map.put("invoice_date", 	str[5]);
					map.put("ds_date", 			str[6]);
					map.put("complete_mark", 	str[7]);
					map.put("process_type", 	str[8]);
					map.put("seller", 	str[9]);
					map.put("group_no", 	str[10]);
					
					// 길이, 수량 이용 시 JSP에서 하기 항목들 추가되어 넘어옴
					if(str != null && str.length >= 12){
						map.put("size_yn", 			str[11]);
						map.put("size_len", 			str[12]);
						map.put("size_qty", 			str[13]);
					}
					
					map.put("ktag_box_qty", "0"); //출력때 box입력해서 여기선 제외하기로함
					//여신한도 초과 체크
					List<Map<String,String>>_list2 = null;
					_list2 = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivCreditLimitSttsCheck",map);
					
					String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
					if(credit_limit_flag.equals("Y")){
						_rtnMsg = "거래명세서 생성이 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
								+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
						throw new RuntimeException(_rtnMsg);
						
					}
					list.add(map);
				}
				
				for(int j = 0; j<group_no_arr.length;j++){
					//group_no가 일치한것들 inv돌려야됨
					int seq = 0;
					for(int i=0; i < list.size(); i++){
						map = (Map<String, String>)list.get(i);
						if(group_no_arr[j].equals(map.get("group_no"))){
							seq += 1;
							if(seq == 1){ //처음에만 inv번호 생성
								map_hd = list.get(i);
								pMap.put("doc_type", doc_type);
								pMap.put("st_seller", map.get("seller"));
							    // doc_type별 inv_no(송장번호) 생성
								inv_no = getOrderNo(pMap);
							}
							//0. KeP내부 품의 진행중일때 거래명세서 생성이 안되도록 hyun
							pm_cnt= (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckPM", map);
							logger.debug(" 품의진행체크  pm_cnt ==>> " + pm_cnt);
							if(pm_cnt != 0) {
								String mngInfo = sqlSessionTemplate.selectOne("common.mpiv.selectBuyerMngInfo", map);
								_rtnMsg = "KeP내부 품의 진행건이므로 거래명세서 생성이 불가능합니다.\n담당자("+mngInfo+")에게 문의 바랍니다.";
								throw new RuntimeException(_rtnMsg);
							}
							
							// 납품 중복생성 체크
							res_cnt = (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckInvoice", map);
								
							logger.debug(" 납품 중복생성 체크  result_cnt ==>> " + res_cnt);
						
							if(res_cnt != 0) {
								_rtnMsg = "납품서가 이미 생성되어 있습니다. 다시 한번 확인해 주시기 바랍니다.";
								throw new RuntimeException(_rtnMsg);
							}
							

							// 2. buyer == KRDOOS0003  : 두산메카텍 공작기계 ==>> LEGACY_IV_NO 생성/입력함.
							if(map.get("buyer").equals("KRDOOS0003")){
//								legacy_iv_no = getLegacyIvNo();
								
								legacy_iv_no = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvNo");
								logger.debug("LEGACY_IV_NO  ==>> " + legacy_iv_no);
								
								if("".equals(CommonUtil.nvl(legacy_iv_no))){
									logger.debug("LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
//									_rtnMsg = "LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
//									throw new RuntimeException(_rtnMsg);
								}
							}

							
							map.put("inv_no", 		inv_no);
							map.put("inv_seq", String.valueOf(seq));
							map.put("legacy_iv_no", CommonUtil.nvl(legacy_iv_no));
							

//							map.put("buyer", 			str[0]);	KRKITU0003
//							map.put("po_no", 			str[1]);	PO14000014
//							map.put("po_seq", 			str[2]);	000001
//							map.put("cd_qty", 			str[3]);	50
//							map.put("invoice_date", 	str[4]);	20140620
//							map.put("ds_date", 			str[5]);	20140613
//							map.put("complete_mark", 	str[6]);	Y
//							map.put("inv_no", 		inv_no);		IV14150295
//							map.put("inv_seq", String.valueOf(i+1));
//							map.put("legacy_iv_no", legacy_iv_no);	IV14060001
							
							// 3. ICOMIVDT insert - 납품송장정보 insert					
							res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvdt", map);
							
							if( res_cnt != 1){
								_rtnMsg = "송장생성중(INSERT INTO ICOMIVDT) 에러가 발생하였습니다.";
								throw new RuntimeException(_rtnMsg);
							}					
							
							// 4. ICOMPODT update - 발주제품정보 송장수량, 송장작성완료유무 update 
							res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePodt", map);

							if( res_cnt != 1){
								_rtnMsg = "송장생성중(UPDATE ICOMPODT) 에러가 발생하였습니다.";
								throw new RuntimeException(_rtnMsg);
							}
				
			                // 5. ICOMPORS update - 발주 수주접수 COMPLETE_MARK(분할여부) = 'Y' update
							res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePors", map);

							if( res_cnt != 1){
								_rtnMsg = "송장생성중(UPDATE ICOMPORS) 에러가 발생하였습니다.";
								throw new RuntimeException(_rtnMsg);
							}
							
							map.put("BUYER", CommonUtil.nvl(map.get("buyer"), ""));
							map.put("PO_NO", CommonUtil.nvl(map.get("po_no"), ""));
							map.put("PO_SEQ", CommonUtil.nvl(map.get("po_seq"), ""));
							
							lastLoginList = sqlSessionTemplate.selectOne("master.mpso.selectLastLoginIdWithPoInfo", map);
							
							// 주문요청자, 발주자 마지막 로그인정보 UPDATE
							map.put("LAST_LOGIN_ID", CommonUtil.nvl(lastLoginList.get("REQ_USER_ID"), ""));
							map.put("LAST_LOGIN_ID1",CommonUtil.nvl(lastLoginList.get("PURCHASER_ID"), ""));
							
							// 주문요청자 마지막 로그인 정보 UPDATE
					        sqlSessionTemplate.insert("login.saveLogintime", map);
					        
					        // 발주자 마지막 로그인 정보 UPDATE
					        sqlSessionTemplate.insert("login.saveLogintime1", map);
						}
					}
					// 6. ICOMPOHD(발주마스터정보)에 COMPLETE_MARK를 'Y'로 UPDATE 할지를 결정하기 위한 SELECT
					
					String complete_mark_dis = sqlSessionTemplate.selectOne("common.mpiv.selectCompleteMarkDis", map_hd);
					
					// COMPLETE_MARK가 Y가 아닌경우 Y로 UPDATE
					if(!"".equals(CommonUtil.nvl(complete_mark_dis))){
						res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePohd", map_hd);
						
						if( res_cnt != 1){
							_rtnMsg = "송장생성중(UPDATE ICOMPOHD) 에러가 발생하였습니다.";
							throw new RuntimeException(_rtnMsg);
						}
					}
					
					// 7. ICOMIVHD insert start ====================
					logger.debug("7. ICOMIVHD insert start ====================");
					
		            String danger_good_flag  = "N";
		            String pkg_type          = "*";
		            String pkg_qty           = "0";
		            String weight_unit       = "*";
		            String gross_weight      = "0";
		            String measurement       = "0";
		            String ship_method       = "ROD";
		            String depart_port       = "*";
		            String arrival_port      = "*";
		            String lc_no             = " ";
		            
		            pMap.put("inv_no"			, inv_no);
		            
		            pMap.put("danger_good_flag"	, danger_good_flag);
		            pMap.put("pkg_type"			, pkg_type);
		            pMap.put("pkg_qty"			, pkg_qty);
		            pMap.put("weight_unit"		, weight_unit);
		            pMap.put("gross_weight"		, gross_weight);
		            pMap.put("measurement"		, measurement);
		            pMap.put("ship_method"		, ship_method);
		            pMap.put("depart_port"		, depart_port);
		            pMap.put("arrival_port"		, arrival_port);
		            pMap.put("lc_no"			, lc_no);

		            String buyer = map_hd.get("buyer");
		            String po_no = map_hd.get("po_no");
		            String process_type = map_hd.get("process_type");
		            
		            pMap.put("buyer", buyer);
		            pMap.put("po_no", po_no);
		            pMap.put("st_process_type", process_type);
		            
		            
					// 7-1. legacy_iv_serial_doos0006  조회 후 ICOMIVHD insert 시 사용.
		            logger.debug("****************************************");
		            logger.debug("* Buyer        : " + pMap.get("buyer"));
					logger.debug("* Inv No       : " + inv_no);
					logger.debug("* Po No        : " + pMap.get("po_no"));
					logger.debug("****************************************");
					
					
					String legacy_iv_serial = "";
					String query = "";
					
					
					//SLOGIC-BEGIN(P06-0000004) : 거래명세서 저장시, 직납일때, LEGACY_IV_SERIAL 생성로직 다름
					String sLogicData = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000004","COL01_DATA");
					//SLOGIC-END
					
					logger.debug("==============================================================");
					logger.debug("buyer : "+ buyer );
					logger.debug("sLogicData : "+ sLogicData );
					logger.debug("==============================================================");
					
		            if(sLogicData.equals("HYOS_SAP") && process_type.equals("0")) {	//(buyer.equals("KRHYOS0033") || buyer.equals("KRHYOS0034") || buyer.equals("KRHYOS0036") || buyer.equals("KRHYOS0037"))
						
						legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer2", pMap);
						
						if("".equals(CommonUtil.nvl(legacy_iv_serial))){
							logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//							_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//							throw new RuntimeException(_rtnMsg);
						}
						
						
						
//						pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
		                
					}
		            
		            pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
		            
		            logger.debug("pMap 출력 start ====================");
		            
		            Set<String> keySet = pMap.keySet();
		            Iterator<String> iterator = keySet.iterator();
		            
		            while(iterator.hasNext()){
		            	String key = iterator.next();
		            	String value = pMap.get(key);
		            	logger.debug("key : "+key+", value : "+value);
		            }
		            
		            logger.debug("pMap 출력 end ====================");
		            
		            res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvhd", pMap);
		            logger.debug("7. ICOMIVHD insert end ====================");
					// 7. ICOMIVHD insert  end =========================
				}
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "거래명세서 작성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		resMap.put("action_flag", _actionFlag);
		resMap.put("msg", _rtnMsg);
		resMap.put("inv_cnt", String.valueOf(group_no_arr.length));
		
		return resMap;
	}
	public Map<String, String> saveSellerMpIvTranStatementWriteItemPop_v3(Map<String, String> pMap){
		
		Map<String, String> resMap = new HashMap<String, String>();
		String _rtnMsg = "";
		String _actionFlag = "";
		
		Map<String, String> lastLoginList = null;
	    
		Map<String, String> map;
		Map<String, String> map_hd = null;
		int res_cnt = 0;
		
		String group_no_arr_temp = CommonUtil.nvl(pMap.get("st_group_no_arr"),"");
		String group_no_arr[]  = CommonUtil.StrToArray(group_no_arr_temp , ",");
		
		String doc_type 		= "IV";
		String inv_no			= "";	// 송장번호
		String legacy_iv_no 	= "";	// 두산메카텍 공작기계 LEGACY_IV_NO 생성/입력함.
		
		try{
		    String query_str				= CommonUtil.nvl(pMap.get("st_query"),"");
		    List<Map<String, String>> list	= new ArrayList<Map<String, String>>();
		    
			String action_id		= CommonUtil.nvl(pMap.get("st_action_id"),"");
			int pm_cnt=0;
			// actionId 조회 - 현재 작업중인지 확인..
			String action_flag = CommonUtil.getActionIdList(action_id);
			
			if("Y".equals(action_flag)){
				_actionFlag = "DO";
				_rtnMsg = "해당건에 대해서 현재 작업중입니다.";
				throw new RuntimeException(_rtnMsg);
			} else {
				String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
				for(int i=0 ; i < check_str.length; i++){
					String str[] = check_str[i].split("@@",-1);
					map = new HashMap<String, String>();
					map.put("st_buyer", 			str[0]);
					map.put("buyer", 			str[0]);
					map.put("po_no", 			str[1]);
					map.put("st_po_no", 			str[1]);
					map.put("po_seq", 			str[2]);
					map.put("st_po_seq", 			str[2]);
					map.put("po_qty", 			str[3]);
					map.put("cd_qty", 			str[4]);
					map.put("invoice_date", 	str[5]);
					map.put("ds_date", 			str[6]);
					map.put("complete_mark", 	str[7]);
					map.put("process_type", 	str[8]);
					map.put("seller", 	str[9]);
					map.put("group_no", 	str[10]);
					
					// 길이, 수량 이용 시 JSP에서 하기 항목들 추가되어 넘어옴
					if(str != null && str.length >= 12){
						map.put("size_yn", 			str[11]);
						map.put("size_len", 			str[12]);
						map.put("size_qty", 			str[13]);
					}
					
					map.put("ktag_box_qty", "0"); //출력때 box입력해서 여기선 제외하기로함
					//여신한도 초과 체크
					List<Map<String,String>>_list2 = null;
					_list2 = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivCreditLimitSttsCheck",map);
					
					String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
					if(credit_limit_flag.equals("Y")){
						_rtnMsg = "거래명세서 생성이 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
								+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
						throw new RuntimeException(_rtnMsg);
						
					}
					list.add(map);
				}
				
				for(int j = 0; j<group_no_arr.length;j++){
					//group_no가 일치한것들 inv돌려야됨
					int seq = 0;
					for(int i=0; i < list.size(); i++){
						map = (Map<String, String>)list.get(i);
						if(group_no_arr[j].equals(map.get("group_no"))){
							seq += 1;
							if(seq == 1){ //처음에만 inv번호 생성
								map_hd = list.get(i);
								pMap.put("doc_type", doc_type);
								pMap.put("st_seller", map.get("seller"));
							    // doc_type별 inv_no(송장번호) 생성
								inv_no = getOrderNo(pMap);
							}
							//0. KeP내부 품의 진행중일때 거래명세서 생성이 안되도록 hyun
							pm_cnt= (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckPM", map);
							logger.debug(" 품의진행체크  pm_cnt ==>> " + pm_cnt);
							if(pm_cnt != 0) {
								String mngInfo = sqlSessionTemplate.selectOne("common.mpiv.selectBuyerMngInfo", map);
								_rtnMsg = "KeP내부 품의 진행건이므로 거래명세서 생성이 불가능합니다.\n담당자("+mngInfo+")에게 문의 바랍니다.";
								throw new RuntimeException(_rtnMsg);
							}
							
							// 납품 중복생성 체크
							res_cnt = (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckInvoice", map);
								
							logger.debug(" 납품 중복생성 체크  result_cnt ==>> " + res_cnt);
						
							if(res_cnt != 0) {
								_rtnMsg = "납품서가 이미 생성되어 있습니다. 다시 한번 확인해 주시기 바랍니다.";
								throw new RuntimeException(_rtnMsg);
							}
							

							// 2. buyer == KRDOOS0003  : 두산메카텍 공작기계 ==>> LEGACY_IV_NO 생성/입력함.
							if(map.get("buyer").equals("KRDOOS0003")){
//								legacy_iv_no = getLegacyIvNo();
								
								legacy_iv_no = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvNo");
								logger.debug("LEGACY_IV_NO  ==>> " + legacy_iv_no);
								
								if("".equals(CommonUtil.nvl(legacy_iv_no))){
									logger.debug("LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
//									_rtnMsg = "LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
//									throw new RuntimeException(_rtnMsg);
								}
							}

							
							map.put("inv_no", 		inv_no);
							map.put("inv_seq", String.valueOf(seq));
							map.put("legacy_iv_no", CommonUtil.nvl(legacy_iv_no));
							

//							map.put("buyer", 			str[0]);	KRKITU0003
//							map.put("po_no", 			str[1]);	PO14000014
//							map.put("po_seq", 			str[2]);	000001
//							map.put("cd_qty", 			str[3]);	50
//							map.put("invoice_date", 	str[4]);	20140620
//							map.put("ds_date", 			str[5]);	20140613
//							map.put("complete_mark", 	str[6]);	Y
//							map.put("inv_no", 		inv_no);		IV14150295
//							map.put("inv_seq", String.valueOf(i+1));
//							map.put("legacy_iv_no", legacy_iv_no);	IV14060001
							
							// 3. ICOMIVDT insert - 납품송장정보 insert					
							res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvdt_v3", map);
							
							if( res_cnt != 1){
								_rtnMsg = "송장생성중(INSERT INTO ICOMIVDT) 에러가 발생하였습니다.";
								throw new RuntimeException(_rtnMsg);
							}					
							
							// 4. ICOMPODT update - 발주제품정보 송장수량, 송장작성완료유무 update 
							res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePodt", map);

							if( res_cnt != 1){
								_rtnMsg = "송장생성중(UPDATE ICOMPODT) 에러가 발생하였습니다.";
								throw new RuntimeException(_rtnMsg);
							}
				
			                // 5. ICOMPORS update - 발주 수주접수 COMPLETE_MARK(분할여부) = 'Y' update
							res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePors", map);

							if( res_cnt != 1){
								_rtnMsg = "송장생성중(UPDATE ICOMPORS) 에러가 발생하였습니다.";
								throw new RuntimeException(_rtnMsg);
							}
							
							map.put("BUYER", CommonUtil.nvl(map.get("buyer"), ""));
							map.put("PO_NO", CommonUtil.nvl(map.get("po_no"), ""));
							map.put("PO_SEQ", CommonUtil.nvl(map.get("po_seq"), ""));
							
							lastLoginList = sqlSessionTemplate.selectOne("master.mpso.selectLastLoginIdWithPoInfo", map);
							
							// 주문요청자, 발주자 마지막 로그인정보 UPDATE
							map.put("LAST_LOGIN_ID", CommonUtil.nvl(lastLoginList.get("REQ_USER_ID"), ""));
							map.put("LAST_LOGIN_ID1",CommonUtil.nvl(lastLoginList.get("PURCHASER_ID"), ""));
							
							// 주문요청자 마지막 로그인 정보 UPDATE
					        sqlSessionTemplate.insert("login.saveLogintime", map);
					        
					        // 발주자 마지막 로그인 정보 UPDATE
					        sqlSessionTemplate.insert("login.saveLogintime1", map);
						}
					}
					// 6. ICOMPOHD(발주마스터정보)에 COMPLETE_MARK를 'Y'로 UPDATE 할지를 결정하기 위한 SELECT
					
					String complete_mark_dis = sqlSessionTemplate.selectOne("common.mpiv.selectCompleteMarkDis", map_hd);
					
					// COMPLETE_MARK가 Y가 아닌경우 Y로 UPDATE
					if(!"".equals(CommonUtil.nvl(complete_mark_dis))){
						res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePohd", map_hd);
						
						if( res_cnt != 1){
							_rtnMsg = "송장생성중(UPDATE ICOMPOHD) 에러가 발생하였습니다.";
							throw new RuntimeException(_rtnMsg);
						}
					}
					
					// 7. ICOMIVHD insert start ====================
					logger.debug("7. ICOMIVHD insert start ====================");
					
		            String danger_good_flag  = "N";
		            String pkg_type          = "*";
		            String pkg_qty           = "0";
		            String weight_unit       = "*";
		            String gross_weight      = "0";
		            String measurement       = "0";
		            String ship_method       = "ROD";
		            String depart_port       = "*";
		            String arrival_port      = "*";
		            String lc_no             = " ";
		            
		            pMap.put("inv_no"			, inv_no);
		            
		            pMap.put("danger_good_flag"	, danger_good_flag);
		            pMap.put("pkg_type"			, pkg_type);
		            pMap.put("pkg_qty"			, pkg_qty);
		            pMap.put("weight_unit"		, weight_unit);
		            pMap.put("gross_weight"		, gross_weight);
		            pMap.put("measurement"		, measurement);
		            pMap.put("ship_method"		, ship_method);
		            pMap.put("depart_port"		, depart_port);
		            pMap.put("arrival_port"		, arrival_port);
		            pMap.put("lc_no"			, lc_no);

		            String buyer = map_hd.get("buyer");
		            String po_no = map_hd.get("po_no");
		            String process_type = map_hd.get("process_type");
		            
		            pMap.put("buyer", buyer);
		            pMap.put("po_no", po_no);
		            pMap.put("st_process_type", process_type);
		            
		            
					// 7-1. legacy_iv_serial_doos0006  조회 후 ICOMIVHD insert 시 사용.
		            logger.debug("****************************************");
		            logger.debug("* Buyer        : " + pMap.get("buyer"));
					logger.debug("* Inv No       : " + inv_no);
					logger.debug("* Po No        : " + pMap.get("po_no"));
					logger.debug("****************************************");
					
					
					String legacy_iv_serial = "";
					String query = "";
					
					
					//SLOGIC-BEGIN(P06-0000004) : 거래명세서 저장시, 직납일때, LEGACY_IV_SERIAL 생성로직 다름
					String sLogicData = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000004","COL01_DATA");
					//SLOGIC-END
					
					logger.debug("==============================================================");
					logger.debug("buyer : "+ buyer );
					logger.debug("sLogicData : "+ sLogicData );
					logger.debug("==============================================================");
					
		            if(sLogicData.equals("HYOS_SAP") && process_type.equals("0")) {	//(buyer.equals("KRHYOS0033") || buyer.equals("KRHYOS0034") || buyer.equals("KRHYOS0036") || buyer.equals("KRHYOS0037"))
						
						legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer2", pMap);
						
						if("".equals(CommonUtil.nvl(legacy_iv_serial))){
							logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//							_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//							throw new RuntimeException(_rtnMsg);
						}
						
						
						
//						pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
		                
					}
		            
		            pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
		            
		            logger.debug("pMap 출력 start ====================");
		            
		            Set<String> keySet = pMap.keySet();
		            Iterator<String> iterator = keySet.iterator();
		            
		            while(iterator.hasNext()){
		            	String key = iterator.next();
		            	String value = pMap.get(key);
		            	logger.debug("key : "+key+", value : "+value);
		            }
		            
		            logger.debug("pMap 출력 end ====================");
		            
		            res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvhd", pMap);
		            logger.debug("7. ICOMIVHD insert end ====================");
					// 7. ICOMIVHD insert  end =========================
				}
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "거래명세서 작성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		resMap.put("action_flag", _actionFlag);
		resMap.put("msg", _rtnMsg);
		resMap.put("inv_cnt", String.valueOf(group_no_arr.length));
		
		return resMap;
	}
	
	
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListItemAll_v2(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("common.mpiv.getSellerMpIvTranStatementWriteListItemAll_v2", pMap);
	}
	
	// 거래명세서 작성 저장-품목별(다중)
	public Map<String, String> saveSellerMpIvTranStatementWriteAllPop(Map<String, String> pMap){
		
		Map<String, String> resMap = new HashMap<String, String>();
		String _rtnMsg = "";
		String _actionFlag = "";


		Map<String, String> map;
		Map<String, String> map_hd;
		int res_cnt = 0;
		
//		String doc_type 		= "IV";
		String inv_no			= "";	// 송장번호
		String legacy_iv_no 	= "";	// 두산메카텍 공작기계 LEGACY_IV_NO 생성/입력함.
		
		double tot_inv_qty = 0;
		List<Map<String,String>>_list2 = null;
		
		try{
		    String query_str				= CommonUtil.nvl(pMap.get("st_query"),"");
		    List<Map<String, String>> list	= new ArrayList<Map<String, String>>();
		    
		    
//		    String seller           = CommonUtil.nvl(pMap.get("st_seller"),"");
		    String process_type     = CommonUtil.nvl(pMap.get("st_process_type"),"");
//		    String inv_amt          = CommonUtil.nvl(pMap.get("st_inv_amt"),"");
//		    String inv_tax_amt      = CommonUtil.nvl(pMap.get("st_inv_tax_amt"),"");
//		    String inv_tax_rate     = CommonUtil.nvl(pMap.get("st_inv_tax_rate"),"");
//		    String inv_tot_amt      = CommonUtil.nvl(pMap.get("st_inv_tot_amt"),"");
//		    String remark_inv       = CommonUtil.nvl(pMap.get("st_remark"),"");
//		    String invoice_date     = CommonUtil.nvl(pMap.get("st_invoice_date"),"");
//		    String legacy_po_no     = CommonUtil.nvl(pMap.get("st_legacy_po_no"),"");
//		    
//		    String user_id          = CommonUtil.nvl(pMap.get("user_id"),"");
	
//			String action_id		= CommonUtil.nvl(pMap.get("st_action_id"),"");
			
			// actionId 조회 - 현재 작업중인지 확인..
//			String action_flag = CommonUtil.getActionIdList(action_id);
			String action_flag = "";
			
			if("Y".equals(action_flag)){
				_actionFlag = "DO";
				_rtnMsg = "해당건에 대해서 현재 작업중입니다.";
				throw new RuntimeException(_rtnMsg);
			} else {
				
				inv_no = pMap.get("st_inv_no");
				
				String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
				
				for(int i=0 ; i < check_str.length; i++){
					String str[] = check_str[i].split("@@",-1);
					
					map = new HashMap<String, String>();

					map.put("buyer", 			str[0]);
					map.put("po_no", 			str[1]);
					map.put("st_po_no", 			str[1]);
					map.put("po_seq", 			str[2]);
					map.put("st_po_seq", 			str[2]);
					map.put("cd_qty", 			str[3]);
					map.put("invoice_date", 	str[4]);
					map.put("ds_date", 			str[5]);
					map.put("complete_mark", 	str[6]);
					map.put("po_qty", 			str[7]);
					map.put("inv_qty", 			str[8]);
					map.put("st_buyer", 			str[0]);
					map.put("ktag_box_qty", "1");
					//여신한도 초과시 수주접수 불가능.
					_list2 = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivCreditLimitSttsCheck",map);
					String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
					if(credit_limit_flag.equals("Y")){
						_rtnMsg = "거래명세서 생성이 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
								+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
						throw new RuntimeException(_rtnMsg);
						
					}
					list.add(map);
				}
				
				map_hd = list.get(0);
				
				for(int i=0; i < list.size(); i++){
					map = (Map<String, String>)list.get(i);

					// 납품 중복생성 체크
					res_cnt = (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckInvoice", map);
						
					logger.debug(" 납품 중복생성 체크  result_cnt ==>> " + res_cnt);
				
					if(res_cnt != 0) {
						_rtnMsg = "납품서가 이미 생성되어 있습니다. 다시 한번 확인해 주시기 바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}
					

					tot_inv_qty = Double.parseDouble(map.get("cd_qty")) + Double.parseDouble(map.get("inv_qty"));
					
					if(Double.parseDouble(map.get("po_qty")) < tot_inv_qty) {
						_rtnMsg = "납품서 수량 초과 발행";
						throw new RuntimeException(_rtnMsg);
					}  


					map.put("inv_no", 		inv_no);
					map.put("inv_seq", String.valueOf(i+1));
					map.put("legacy_iv_no", legacy_iv_no);
					

					// 3. ICOMIVDT insert - 납품송장정보 insert
					res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvdt", map);
					
					if( res_cnt != 1){
						_rtnMsg = "송장생성중(INSERT INTO ICOMIVDT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
	                // 5. ICOMPORS update - 발주 수주접수 COMPLETE_MARK(분할여부) = 'Y' update
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePors", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPORS) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 4. ICOMPODT update - 발주제품정보 송장수량, 송장작성완료유무 update 
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePodt", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPODT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 6. ICOMPOHD(발주마스터정보)에 COMPLETE_MARK를 'Y'로 UPDATE 할지를 결정하기 위한 SELECT
					String complete_mark_dis = sqlSessionTemplate.selectOne("common.mpiv.selectCompleteMarkDis", map);
					
					// COMPLETE_MARK가 Y가 아닌경우 Y로 UPDATE
					if(!"".equals(CommonUtil.nvl(complete_mark_dis))){
						res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePohd", map);
						
						if( res_cnt != 1){
							_rtnMsg = "송장생성중(UPDATE ICOMPOHD) 에러가 발생하였습니다.";
							throw new RuntimeException(_rtnMsg);
						}
					}
					
				}
				
				// 7. ICOMIVHD insert start ====================
				logger.debug("7. ICOMIVHD insert start ====================");
				
	            String danger_good_flag  = "N";
	            String pkg_type          = "*";
	            String pkg_qty           = "0";
	            String weight_unit       = "*";
	            String gross_weight      = "0";
	            String measurement       = "0";
	            String ship_method       = "ROD";
	            String depart_port       = "*";
	            String arrival_port      = "*";
	            String lc_no             = " ";
	            
	            pMap.put("inv_no"			, inv_no);
	            
	            pMap.put("danger_good_flag"	, danger_good_flag);
	            pMap.put("pkg_type"			, pkg_type);
	            pMap.put("pkg_qty"			, pkg_qty);
	            pMap.put("weight_unit"		, weight_unit);
	            pMap.put("gross_weight"		, gross_weight);
	            pMap.put("measurement"		, measurement);
	            pMap.put("ship_method"		, ship_method);
	            pMap.put("depart_port"		, depart_port);
	            pMap.put("arrival_port"		, arrival_port);
	            pMap.put("lc_no"			, lc_no);

	            String buyer = map_hd.get("buyer");
	            String po_no = map_hd.get("po_no");
	            
	            pMap.put("buyer", buyer);
	            pMap.put("po_no", po_no);
	            
	            
				// 7-1. legacy_iv_serial_doos0006  조회 후 ICOMIVHD insert 시 사용.
	            logger.debug("****************************************");
	            logger.debug("* Buyer        : " + pMap.get("buyer"));
	            logger.debug("* Inv No       : " + inv_no);
	            logger.debug("* Po No        : " + pMap.get("po_no"));
	            logger.debug("* Process Type : " + process_type);
	            logger.debug("****************************************");
				
				
				String legacy_iv_serial = "";
				String query = "";
				
				//SLOGIC-BEGIN(P06-0000004) : 거래명세서 저장시, 직납일때, LEGACY_IV_SERIAL 생성로직 다름
				String sLogicData = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000004","COL01_DATA");
				//SLOGIC-END
				
				logger.debug("==============================================================");
				logger.debug("buyer : "+ buyer );
				logger.debug("sLogicData : "+ sLogicData );
				logger.debug("==============================================================");
				
	            if(sLogicData.equals("HYOS_SAP") && process_type.equals("0")) {
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer2", pMap);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
	                
				}
				
	            pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
	            
	            logger.debug("pMap 출력 start ====================");
	            
	            Set<String> keySet = pMap.keySet();
	            Iterator<String> iterator = keySet.iterator();
	            
	            while(iterator.hasNext()){
	            	String key = iterator.next();
	            	String value = pMap.get(key);
	            	logger.debug("key : "+key+", value : "+value);
	            }
	            
	            logger.debug("pMap 출력 end ====================");
	            
	            
	            
	            res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvhd", pMap);
	            logger.debug("7. ICOMIVHD insert end ====================");
				// 7. ICOMIVHD insert  end =========================
	            
			}
		
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		resMap.put("action_flag", _actionFlag);
		resMap.put("msg", _rtnMsg);
		resMap.put("inv_no", inv_no);
		
	return resMap;
	}
	
	public Map<String, String> saveSellerMpIvTranStatementWriteAllPop_v3(Map<String, String> pMap){
		
		Map<String, String> resMap = new HashMap<String, String>();
		String _rtnMsg = "";
		String _actionFlag = "";


		Map<String, String> map;
		Map<String, String> map_hd;
		int res_cnt = 0;
		
//		String doc_type 		= "IV";
		String inv_no			= "";	// 송장번호
		String legacy_iv_no 	= "";	// 두산메카텍 공작기계 LEGACY_IV_NO 생성/입력함.
		
		double tot_inv_qty = 0;
		List<Map<String,String>>_list2 = null;
		
		try{
		    String query_str				= CommonUtil.nvl(pMap.get("st_query"),"");
		    List<Map<String, String>> list	= new ArrayList<Map<String, String>>();
		    
		    
//		    String seller           = CommonUtil.nvl(pMap.get("st_seller"),"");
		    String process_type     = CommonUtil.nvl(pMap.get("st_process_type"),"");
//		    String inv_amt          = CommonUtil.nvl(pMap.get("st_inv_amt"),"");
//		    String inv_tax_amt      = CommonUtil.nvl(pMap.get("st_inv_tax_amt"),"");
//		    String inv_tax_rate     = CommonUtil.nvl(pMap.get("st_inv_tax_rate"),"");
//		    String inv_tot_amt      = CommonUtil.nvl(pMap.get("st_inv_tot_amt"),"");
//		    String remark_inv       = CommonUtil.nvl(pMap.get("st_remark"),"");
//		    String invoice_date     = CommonUtil.nvl(pMap.get("st_invoice_date"),"");
//		    String legacy_po_no     = CommonUtil.nvl(pMap.get("st_legacy_po_no"),"");
//		    
//		    String user_id          = CommonUtil.nvl(pMap.get("user_id"),"");
	
//			String action_id		= CommonUtil.nvl(pMap.get("st_action_id"),"");
			
			// actionId 조회 - 현재 작업중인지 확인..
//			String action_flag = CommonUtil.getActionIdList(action_id);
			String action_flag = "";
			
			if("Y".equals(action_flag)){
				_actionFlag = "DO";
				_rtnMsg = "해당건에 대해서 현재 작업중입니다.";
				throw new RuntimeException(_rtnMsg);
			} else {
				
				inv_no = pMap.get("st_inv_no");
				
				String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
				
				for(int i=0 ; i < check_str.length; i++){
					String str[] = check_str[i].split("@@",-1);
					
					map = new HashMap<String, String>();

					map.put("buyer", 			str[0]);
					map.put("po_no", 			str[1]);
					map.put("st_po_no", 			str[1]);
					map.put("po_seq", 			str[2]);
					map.put("st_po_seq", 			str[2]);
					map.put("cd_qty", 			str[3]);
					map.put("invoice_date", 	str[4]);
					map.put("ds_date", 			str[5]);
					map.put("complete_mark", 	str[6]);
					map.put("po_qty", 			str[7]);
					map.put("inv_qty", 			str[8]);
					map.put("st_buyer", 			str[0]);
					map.put("ktag_box_qty", "1");
					//여신한도 초과시 수주접수 불가능.
					_list2 = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivCreditLimitSttsCheck",map);
					String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
					if(credit_limit_flag.equals("Y")){
						_rtnMsg = "거래명세서 생성이 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
								+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
						throw new RuntimeException(_rtnMsg);
						
					}
					list.add(map);
				}
				
				map_hd = list.get(0);
				
				for(int i=0; i < list.size(); i++){
					map = (Map<String, String>)list.get(i);

					// 납품 중복생성 체크
					res_cnt = (Integer)sqlSessionTemplate.selectOne("common.mpiv.selectCheckInvoice", map);
						
					logger.debug(" 납품 중복생성 체크  result_cnt ==>> " + res_cnt);
				
					if(res_cnt != 0) {
						_rtnMsg = "납품서가 이미 생성되어 있습니다. 다시 한번 확인해 주시기 바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}
					

					tot_inv_qty = Double.parseDouble(map.get("cd_qty")) + Double.parseDouble(map.get("inv_qty"));
					
					if(Double.parseDouble(map.get("po_qty")) < tot_inv_qty) {
						_rtnMsg = "납품서 수량 초과 발행";
						throw new RuntimeException(_rtnMsg);
					}  


					map.put("inv_no", 		inv_no);
					map.put("inv_seq", String.valueOf(i+1));
					map.put("legacy_iv_no", legacy_iv_no);
					

					// 3. ICOMIVDT insert - 납품송장정보 insert
					res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvdt_v3", map);
					
					if( res_cnt != 1){
						_rtnMsg = "송장생성중(INSERT INTO ICOMIVDT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
	                // 5. ICOMPORS update - 발주 수주접수 COMPLETE_MARK(분할여부) = 'Y' update
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePors", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPORS) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 4. ICOMPODT update - 발주제품정보 송장수량, 송장작성완료유무 update 
					res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePodt", map);

					if( res_cnt != 1){
						_rtnMsg = "송장생성중(UPDATE ICOMPODT) 에러가 발생하였습니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					// 6. ICOMPOHD(발주마스터정보)에 COMPLETE_MARK를 'Y'로 UPDATE 할지를 결정하기 위한 SELECT
					String complete_mark_dis = sqlSessionTemplate.selectOne("common.mpiv.selectCompleteMarkDis", map);
					
					// COMPLETE_MARK가 Y가 아닌경우 Y로 UPDATE
					if(!"".equals(CommonUtil.nvl(complete_mark_dis))){
						res_cnt = sqlSessionTemplate.update("common.mpiv.updateSellerMpivTranStatementWritePohd", map);
						
						if( res_cnt != 1){
							_rtnMsg = "송장생성중(UPDATE ICOMPOHD) 에러가 발생하였습니다.";
							throw new RuntimeException(_rtnMsg);
						}
					}
					
				}
				
				// 7. ICOMIVHD insert start ====================
				logger.debug("7. ICOMIVHD insert start ====================");
				
	            String danger_good_flag  = "N";
	            String pkg_type          = "*";
	            String pkg_qty           = "0";
	            String weight_unit       = "*";
	            String gross_weight      = "0";
	            String measurement       = "0";
	            String ship_method       = "ROD";
	            String depart_port       = "*";
	            String arrival_port      = "*";
	            String lc_no             = " ";
	            
	            pMap.put("inv_no"			, inv_no);
	            
	            pMap.put("danger_good_flag"	, danger_good_flag);
	            pMap.put("pkg_type"			, pkg_type);
	            pMap.put("pkg_qty"			, pkg_qty);
	            pMap.put("weight_unit"		, weight_unit);
	            pMap.put("gross_weight"		, gross_weight);
	            pMap.put("measurement"		, measurement);
	            pMap.put("ship_method"		, ship_method);
	            pMap.put("depart_port"		, depart_port);
	            pMap.put("arrival_port"		, arrival_port);
	            pMap.put("lc_no"			, lc_no);

	            String buyer = map_hd.get("buyer");
	            String po_no = map_hd.get("po_no");
	            
	            pMap.put("buyer", buyer);
	            pMap.put("po_no", po_no);
	            
	            
				// 7-1. legacy_iv_serial_doos0006  조회 후 ICOMIVHD insert 시 사용.
	            logger.debug("****************************************");
	            logger.debug("* Buyer        : " + pMap.get("buyer"));
	            logger.debug("* Inv No       : " + inv_no);
	            logger.debug("* Po No        : " + pMap.get("po_no"));
	            logger.debug("* Process Type : " + process_type);
	            logger.debug("****************************************");
				
				
				String legacy_iv_serial = "";
				String query = "";
				
				//SLOGIC-BEGIN(P06-0000004) : 거래명세서 저장시, 직납일때, LEGACY_IV_SERIAL 생성로직 다름
				String sLogicData = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000004","COL01_DATA");
				//SLOGIC-END
				
				logger.debug("==============================================================");
				logger.debug("buyer : "+ buyer );
				logger.debug("sLogicData : "+ sLogicData );
				logger.debug("==============================================================");
				
	            if(sLogicData.equals("HYOS_SAP") && process_type.equals("0")) {
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer2", pMap);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
	                
				}
				
	            pMap.put("legacy_iv_serial", CommonUtil.nvl(legacy_iv_serial));
	            
	            logger.debug("pMap 출력 start ====================");
	            
	            Set<String> keySet = pMap.keySet();
	            Iterator<String> iterator = keySet.iterator();
	            
	            while(iterator.hasNext()){
	            	String key = iterator.next();
	            	String value = pMap.get(key);
	            	logger.debug("key : "+key+", value : "+value);
	            }
	            
	            logger.debug("pMap 출력 end ====================");
	            
	            
	            
	            res_cnt = sqlSessionTemplate.insert("common.mpiv.insertSellerMpivTranStatementWriteIvhd", pMap);
	            logger.debug("7. ICOMIVHD insert end ====================");
				// 7. ICOMIVHD insert  end =========================
	            
			}
		
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		resMap.put("action_flag", _actionFlag);
		resMap.put("msg", _rtnMsg);
		resMap.put("inv_no", inv_no);
		
	return resMap;
	}
}
