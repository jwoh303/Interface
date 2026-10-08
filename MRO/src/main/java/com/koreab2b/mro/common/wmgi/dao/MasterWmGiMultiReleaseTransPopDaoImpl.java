package com.koreab2b.mro.common.wmgi.dao;

import java.math.BigDecimal;
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

import com.koreab2b.mro.util.CommonProperty;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.HmacSha256Util;
import com.koreab2b.mro.util.HttpClientUtil;

@Repository("masterWmGiMultiReleaseTransPopDao")
@Transactional
public class MasterWmGiMultiReleaseTransPopDaoImpl implements MasterWmGiMultiReleaseTransPopDao {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGiMultiReleaseTransPopDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgi.selectMasterWmGiMultiReleaseTransPopList", formData);
	}
	
	// TR다중출고지시
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData){
		List<Map<String,String>>_list2 = null;
		
		String rtnMsg = "OK";
		String Invk_no = "";
		String legacyIvSerial = "";
		String prev_inv_no = "";
		String invk_no_list = "";
		String legacy_po_list = "";
		String box_qty_list = "";
		// 일양, 한진 택배사 선택
		String deliCompany = formData.get("select_deliCompany");
		int boxCnt = 0;
		try{
			//여신한도 초과시 수주접수 불가능.
			_list2 = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrCreditLimitOrderCheck",formData);
			String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
			if(credit_limit_flag.equals("Y")){
				rtnMsg = "출고지시가 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
						+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
				throw new RuntimeException(rtnMsg);
			}
			
			for(int i=0; i<gridData.size(); i++){
				formData.putAll((Map<String,String>)gridData.get(i));
				
				// 출고 가능 수량 실시간 확인 (출고 전량 = 가능 전량)
				try{
					List<Map<String,Object>> posb_check_list = sqlSessionTemplate.selectList("common.wmgi.selectMasterWmGiMultiReleaseTransPopCheck", formData);
					String posb_check = posb_check_list.get(0).get("POSB_CHECK").toString();
					
					if(posb_check.equals("N")){
						rtnMsg = "출고 가능 수량이 변경되었습니다. 다시 조회하여 사용해주세요.";
						throw new RuntimeException("출고 가능 수량이 변경되었습니다. 다시 조회하여 사용해주세요.");
					}
				}catch(Exception e){
					rtnMsg = "출고 가능 수량 계산 중 에러가 발생 하였습니다.";
					throw new RuntimeException("출고 가능 수량 계산 중 에러가 발생 하였습니다.");
				}
				
				// INV번호가 변경되는 때마다 실행
				if(!prev_inv_no.equals(formData.get("INV_NO"))){
					try{
						List<Map<String,Object>> _rtnListorderno= sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreORDERNO", formData);
						
						//현재 Company 코드에 해당하는 type의 코드가 존재하지 않는 경우 새로 번호를 생성한다.
						if(_rtnListorderno.size() != 1){
							sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreIcomsqmt", formData);
			                
							int year_num = Calendar.getInstance().get(Calendar.YEAR);
			                String year_str = String.valueOf(year_num);
			                Invk_no = "IK" + year_str.substring(2,4) + "000001";
						}else{
							sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreIcomsqmt", formData);
							
							Invk_no = _rtnListorderno.get(0).get("ORDERNO").toString();
						}
						
						boxCnt = 1; // 일양, 한진택배 SEQ
						
					}catch(Exception se){
						rtnMsg = "송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.";
						throw new Exception();
					}
					
					//SLOGIC-START
					if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-02")){
						try{
							List<Map<String,Object>> _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialHyosungSAP", formData);
							
							legacyIvSerial = _rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString();
						}catch(Exception e){
							rtnMsg = "효성 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다";
							throw new RuntimeException("효성 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
						}
					}
					//SLOGIC-END
				}
				
				//WMSIVDT INSERT					
				//물류센터 송장 INSERT
				try{
					formData.put("INV_SEQ_I", String.valueOf(i+1));
					formData.put("INVK_NO", Invk_no);
					formData.put("LEGACY_IV_SERIAL", legacyIvSerial);
					int insCnt = 0;
					insCnt = sqlSessionTemplate.update("common.wmgi.insertMasterWmGiMultiReleaseTransPopList", formData);
					
					if(insCnt < 1){
						rtnMsg = "출고지시 대상 데이터가 없어 송장을 생성하지 못했습니다.";
						throw new RuntimeException(rtnMsg);
					}
					
					// 출고예정일 변경 ICOMPORS BUYER_DS_DATE UPDATE
					sqlSessionTemplate.update("common.wmgi.updateMasterWmGiMultiReleaseTransPopICOMPORS", formData);
				}catch(Exception se){
					rtnMsg = "송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.";
					throw new Exception();
				}
				
				try{
					sqlSessionTemplate.update("common.wmgi.updateMasterWmGiMultiReleaseTransPopICOMPODT", formData);
				}catch(Exception se){
					rtnMsg ="송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.";
					throw new RuntimeException("송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.");
				}
				
				try{
					sqlSessionTemplate.update("common.wmgi.updateMasterWmGiMultiReleaseTransPopICOMIVDT", formData);
				}catch(Exception se){
					rtnMsg ="송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다.";
					throw new RuntimeException("송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다.");
				}
				
				if(checkDuplicate(formData)){
					rtnMsg ="송장생성중( Duplicate Check ) 에러가 발생하였습니다.\n\nDuplicate Check ERROR.";
					throw new RuntimeException("송장생성중( Duplicate Check ) 에러가 발생하였습니다.\n\nDuplicate Check ERROR");
				}
				
				prev_inv_no = formData.get("INV_NO");
				
				invk_no_list += Invk_no + "@@";
				legacy_po_list += CommonUtil.nvl(formData.get("LEGACY_PO_NO"), "") + "@@";
				box_qty_list += formData.get("BOX_QTY") + "@@";
				
				if(i == (gridData.size()-1)) {
					invk_no_list = invk_no_list + "^^";
					legacy_po_list = legacy_po_list + "^^";
					box_qty_list = box_qty_list + "^^";
				}
				boolean itemQty = formData.get("WMS_GW_QTY").startsWith("-"); // 마이너스인 경우 true
				
				if(!itemQty) { // 마이너스 수량이 아닌경우에만 실행
					  if(deliCompany.equals("IY")) {  // 택배사 일양 선택
						  try {
							  Map<String,String> _dataDetailParam = null;
							  _dataDetailParam = new HashMap<String,String>() ;
							  _dataDetailParam.put("WAREHOUSE_CODE", formData.get("st_warehouse_code"));
							  _dataDetailParam.put("BUYER", formData.get("BUYER"));
							  _dataDetailParam.put("INV_NO", Invk_no);
							  _dataDetailParam.put("BOX_SEQ", Integer.toString(boxCnt));				
							  _dataDetailParam.put("USER_ID", formData.get("st_user_id")); //로그인 사용자 ID
							  _dataDetailParam.put("PO_NO", formData.get("PO_NO")); //발주번호
							  //일양택배 송장 매핑 insert
							  sqlSessionTemplate.update("common.wmgi.insertMasterWmIyangLogisHawb", _dataDetailParam);
							  //WMSIVDT 택배사, 송장번호 업데이트.
							  sqlSessionTemplate.update("common.wmgi.updateMasterWmIyangWmsivdt", _dataDetailParam);
							  boxCnt++;
						  } catch (Exception e) {
							  	
						}
						  
						  
					} else if(deliCompany.equals("HJ")) { // 택배사 한진 선택
						 try {
							 	//HMAC 생성
								String HMAC = "";
								HMAC = getHanjinHMAC();							
				            	String url = "";				            	
				            	Map<String,String> _dataDetailParam = null;
				            	_dataDetailParam = new HashMap<String,String>() ;
				            	_dataDetailParam.put("WAREHOUSE_CODE", formData.get("st_warehouse_code"));
				            	_dataDetailParam.put("BUYER", formData.get("BUYER"));
				            	_dataDetailParam.put("INV_NO", Invk_no);
				            	_dataDetailParam.put("BOX_SEQ", Integer.toString(boxCnt));					
				            	_dataDetailParam.put("USER_ID", formData.get("st_user_id")); //로그인 사용자 ID
				            	_dataDetailParam.put("PO_NO", formData.get("PO_NO")); //발주번호
				            	
								sqlSessionTemplate.update("common.wmgi.insertHanjinHd", _dataDetailParam);
								
								//전송할 택배데이터 조회
				            	List<Map<String,Object>> itemHdLst = sqlSessionTemplate.selectList("common.wmgi.selectHanjinItemHdLst",_dataDetailParam);
				            	Map<String, Object> itemHd = null;
				            	Map<String, Object> result = new HashMap<String,Object>();
				            	if(!itemHdLst.isEmpty()) {
				            		itemHd = itemHdLst.get(0);
				            		try {
			            				logger.info("##### Hanjin 택배 Order 전 데이터  : "+ itemHd.toString());
			            				//1. 한진 운송장출력 API 데이터 저장
			            				Map<String,Object> parcelMap = new HashMap<String,Object>();
			            				parcelMap.put("client_id", CommonProperty.getHanjinClientId());
			            				parcelMap.put("address", itemHd.get("rcvrBaseAddr")); // 배송지 주소
			            				parcelMap.put("snd_zip", itemHd.get("sndrZip")); // 출발지 우편번호
			            				parcelMap.put("rcv_zip", itemHd.get("rcvrZip")); // 배송지 우편번호
			            				parcelMap.put("msg_key", itemHd.get("custOrdNo")); // 고객사코드 + IK번호		            				
			            				url = CommonProperty.getHanjinParcelPrdUrl();
			            				result = HttpClientUtil.apiCallHttps("POST", "HANJIN", url, parcelMap, null);
			            				if("OK".equals(result.get("result_code"))) {
			            					logger.info("##### Hanjin 택배 운송장 출력 성공  ");		    		       				
			    		       				// KEP_PARCEL_HJ_LB 운송장 출력 테이블 업데이트
			            					result.put("parcelNo", itemHd.get("wblNo"));
			            					result.put("msg_seq", String.format("%06d", boxCnt));
			    							sqlSessionTemplate.update("common.wmgi.updateHanjinParcelLb", result);
			    							
				            				//2. 한진 API 택배 주문 등록
				            				url = CommonProperty.getHanjinPrdUrl() + "/parcel-delivery/v1/order/insert-order";
				            				result = HttpClientUtil.apiCallHttps("POST", "HANJIN", url, itemHd, HMAC);
				            				
				            				if("OK".equals(result.get("resultCode"))) {
				            					logger.info("##### Hanjin 택배 주문 등록 성공  ");
				    		       				result.put("flag", "Y");		    		       		    		       				
				    		       				result.put("buyer", _dataDetailParam.get("BUYER"));
				    		       				result.put("inv_no", _dataDetailParam.get("INV_NO"));
				    		       				// WMSIVDT 운송장번호 업데이트
				    							sqlSessionTemplate.update("common.wmgi.updateHanjinWmsivdt", result);
					            				sqlSessionTemplate.update("common.wmgi.updateHanjinItemHd", result);
				    		       			}else {
				    		       				logger.info("##### Hanjin 택배 주문 등록 실패  : "+ result.get("resultMessage"));			    		       				
				    		       				throw new Exception("한진택배 주문정보 등록 중 오류 발생하였습니다.");
				    		       			}	
			    		       			}else {
			    		       				logger.info("##### Hanjin 택배 운송장 출력 실패  : "+ result.get("resultMessage"));
			    		       				throw new Exception("한진택배 운송장 출력 중 오류 발생하였습니다.");
			    		       			}
			            				boxCnt++;
			            				
				            		} catch (Exception e) {
				            			throw new RuntimeException(e.getMessage());
									}
				            	}
								
						 } catch (Exception e) {
							 	rtnMsg ="송장생성중( 한진택배 ) 에러가 발생하였습니다.";
							  	throw new RuntimeException("송장생성중( 한진택배 ) 에러가 발생하였습니다.");
						 }	 
							
							
						}
					
				}
					
				
			} //END FOR
			
			// 마지막 자리 구분자 확인(도중에 잘리지 않았는지)
			String invk_no_list_check = invk_no_list.substring(invk_no_list.length() - 2);
			String legacy_po_list_check = legacy_po_list.substring(legacy_po_list.length() - 2);
			String box_qty_list_check = box_qty_list.substring(box_qty_list.length() - 2);
			
			if(!invk_no_list_check.equals("^^") || !legacy_po_list_check.equals("^^") || !box_qty_list_check.equals("^^")) {
				rtnMsg ="송장생성중( 전달 파라미터 길이 초과 ) 에러가 발생하였습니다.";
				throw new RuntimeException("송장생성중( 전달 파라미터 길이 초과 ) 에러가 발생하였습니다.");
			}
			
			rtnMsg += invk_no_list + legacy_po_list + box_qty_list + deliCompany;
			
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(rtnMsg);
		}
		
		return rtnMsg;
	}	

	private boolean checkDuplicate(Map<String,String> formData) throws RuntimeException{
		boolean isDuplicate = false;
		List<Map<String,Object>> wmsStckForSTCKCount  = sqlSessionTemplate.selectList("common.wmgi.checkMasterWmGiMultiReleaseTransPopDuplicate", formData);
		BigDecimal tempINV_QTY = new BigDecimal(wmsStckForSTCKCount.get(0).get("INV_QTY").toString());
		BigDecimal tempWMS_IVK_QTY = new BigDecimal(wmsStckForSTCKCount.get(0).get("WMS_IVK_QTY").toString());
		
		if(tempINV_QTY.compareTo(tempWMS_IVK_QTY) == -1){
			isDuplicate = true;
		}
		
		return isDuplicate;
	}
	
	//한진택배 TOKEN API
	@SuppressWarnings("unchecked")
	public String getHanjinHMAC(){
		//한진 API 토큰 호출
		String clientId = CommonProperty.getHanjinClientId();
		String securityKey = CommonProperty.getHanjinSecretKey();
		String method = "POST";
		String url = CommonProperty.getHanjinPrdUrl() + "/parcel-delivery/v1/order/insert-order";
				
		// HMAC 생성
		String HMAC = HmacSha256Util.hmacGenerate(method, url, clientId, securityKey);
		logger.info("##### Hanjin HMAC  : "+ HMAC);
		
		return HMAC;
	}
}