package com.koreab2b.mro.seller.mpiv.dao;

import java.util.ArrayList;
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

@Repository("sellerMpIvTranStatementDivsnWriteDao")
@Transactional
public class SellerMpIvTranStatementDivsnWriteDaoImpl implements SellerMpIvTranStatementDivsnWriteDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementDivsnWriteDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvTranStatementDivsnWriteList", pMap);
	}
	
	// 저장
	public Map<String, String> saveSellerMpIvTranStatementDivsnWrite(Map<String,String> pMap) {

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
				
//				inv_no = getOrderNo( conn , seller,"IV" );
				
//				pMap.put("doc_type", doc_type);
				
			    // doc_type별 inv_no(송장번호) 생성
//				inv_no = getOrderNo(pMap);
				inv_no = pMap.get("st_inv_no");
				
				String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
				
				for(int i=0 ; i < check_str.length; i++){
					String str[] = check_str[i].split("@@",-1);
					
					map = new HashMap<String, String>();
					

//					map.put("buyer", 			str[0]);
//					map.put("po_no", 			str[1]);
//					map.put("po_seq", 			str[2]);
//					map.put("cd_qty", 			str[3]);
//					map.put("invoice_date", 	str[4]);
//					map.put("ds_date", 			str[5]);
//					map.put("complete_mark", 	str[6]);
					
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

					// 1. 납품서 중복생성 체크
//					doubleIvCheckRst = getDoubleCheckInvoiceCreate(str);

//					map = new HashMap<String, String>();
//
//					map.put("buyer", 			str[0]);
//					map.put("po_no", 			str[1]);
//					map.put("po_seq", 			str[2]);
//					map.put("cd_qty", 			str[3]);
//					map.put("invoice_date", 	str[4]);
//					map.put("ds_date", 			str[5]);
//					map.put("complete_mark", 	str[6]);
//					map.put("po_qty", 			str[7]);
//					map.put("inv_qty", 			str[8]);
					
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
							_rtnMsg = "LEGACY_IV_NO 생성에 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.";
							throw new RuntimeException(_rtnMsg);
						}
					}

					
					tot_inv_qty = Double.parseDouble(map.get("cd_qty")) + Double.parseDouble(map.get("inv_qty"));
					
					if(Double.parseDouble(map.get("po_qty")) < tot_inv_qty) {
						_rtnMsg = "납품서 수량 초과 발행";
						throw new RuntimeException(_rtnMsg);
					}  


					map.put("inv_no", 		inv_no);
					map.put("inv_seq", String.valueOf(i+1));
					map.put("legacy_iv_no", legacy_iv_no);
					

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

//	            if(process_type.equals("0") && car_flag.equals("Y")){
//	            	String tmp_str[] = car_info.split("@@",-1); 
//	            	pMap.put("car_no"			, String.valueOf(tmp_str[1]));
//	            	pMap.put("car_person_name"	, String.valueOf(tmp_str[2]));
//	            	pMap.put("car_person_tel"	, String.valueOf(tmp_str[3]));
//	            }
	            
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
				
	            if(sLogicData.equals("TK") && process_type.equals("0")) {
					
	            	legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialDoos0006");
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.");
//						_rtnMsg = "두산메카텍 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("HYOS") && process_type.equals("0")) {

					query = "FUN_SEQ_MNG('SEQ_HYOS_INV_NO')||'^'||FUN_SEQ_MNG('SEQ_HYOS_MNG_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
				} else if(sLogicData.equals("HYOS_SAP") && process_type.equals("0")) {
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer2", pMap);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
	                
				} else if(sLogicData.equals("SUNG") && process_type.equals("0")) {
	                
					query = "FUN_SEQ_MNG('SEQ_SDSM_INV_NO')";
					
					legacy_iv_serial = sqlSessionTemplate.selectOne("common.mpiv.selectLegacyIvSerialBuyer", query);
					
					if("".equals(CommonUtil.nvl(legacy_iv_serial))){
						logger.debug("납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
//						_rtnMsg = "납품서 번호(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.";
//						throw new RuntimeException(_rtnMsg);
					}
					
//					pMap.put("legacy_iv_serial", legacy_iv_serial);
					
	                
				} else if(sLogicData.equals("SSAN") && process_type.equals("0")) {
	                
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
