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

import com.koreab2b.mro.master.wmgr.dao.MasterWmGrTrGrCreDaoImpl;
import com.koreab2b.mro.util.CommonProperty;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.HmacSha256Util;
import com.koreab2b.mro.util.HttpClientUtil;

@Repository("masterWmGiReleaseTransPopDao")
@Transactional
public class MasterWmGiReleaseTransPopDaoImpl implements MasterWmGiReleaseTransPopDao {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrTrGrCreDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgi.selectMasterWmGiReleaseTransPopList", formData);
	}
	
	//출고지시 
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData){
		
		String rtnMsg = "OK";
		String Invk_no = "";
		String legacyIvSerial = "";
		String stWareHouseCd = "";//물류센터
		String stBuyer = "";//고객사 
		String stIYgbn ="N"; //일양택배대상 여부.
		String stPrUserId = ""; //구매요청자ID
		String stPoNo = ""; //고객사 발주번호		
		List<Map<String,String>>_list2 = null;		
		
		try{
			
			if("Y".equals(formData.get("st_hub_yn"))){ // 간선
				for(int i=0; i<gridData.size(); i++){
					formData.putAll((Map<String,String>)gridData.get(i));
					
					// ICOMIVDT.HUB_FLAG 변경
					formData.put("HUB_FLAG", "C");
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomivdt", formData);
					// HUBIVDT 변경
					sqlSessionTemplate.update("common.wmgi.updateMasterWmGiReleaseTransPopHUBIVDT", formData);
				}
			}else{ // 일반 출고지시
				//여신한도 초과시 수주접수 불가능.
				_list2 = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrCreditLimitOrderCheck",formData);
				String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
				
				if(credit_limit_flag.equals("Y")){
					rtnMsg = "출고지시가 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
							+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
					throw new RuntimeException(rtnMsg);
				}
				
				List<Map<String,Object>>  _rtnListorderno= sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreORDERNO", formData);
				
				//현재 Company 코드에 해당하는 type의 코드가 존재하지 않는 경우 새로 번호를 생성한다.
				if(_rtnListorderno.size() !=1){
					sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreIcomsqmt", formData);
	                int year_num = Calendar.getInstance().get(Calendar.YEAR);
	                String year_str = String.valueOf(year_num);
	                Invk_no = "IK"+year_str.substring(2,4) + "000001";
				}else{
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreIcomsqmt", formData);
					Invk_no = _rtnListorderno.get(0).get("ORDERNO").toString();
				}
				
				for(int i=0; i < gridData.size(); i++){
					formData.putAll((Map<String,String>)gridData.get(i));
					
					if(i==0){
						//효성SAP
						if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-02")){
							try{
								List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialHyosungSAP", formData);
								legacyIvSerial = _rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString();
								//formData.put("LEGACY_IV_SERIAL",_rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString());
								
							}catch(Exception e){
								rtnMsg = "효성 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다";
								throw new RuntimeException("효성 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
							}
						}
						
						if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-04")){
							try{
								List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialSsangyong", formData);
								legacyIvSerial = _rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString();
								//formData.put("LEGACY_IV_SERIAL",_rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString());
							}catch(Exception e){
								rtnMsg = "쌍용자동차 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.";
								throw new RuntimeException("쌍용자동차 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.");
							}
							
						//SLOGIC-BEGIN(P08-0000003-05)
						}else if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-05")){
							try{
								List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialLTAL", formData);
								legacyIvSerial = _rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString();
							}catch(Exception e){
								rtnMsg = "롯데알미늄 송장번호(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.";
								throw new RuntimeException("롯데알미늄 송장번호(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.");
							}
						}
						//SLOGIC-END
						
						//물류센터, 고객사, 구매요청자ID 데이터 셋팅
						stWareHouseCd =formData.get("st_warehouse_code"); 
						stBuyer =formData.get("BUYER");
						stPrUserId =formData.get("PR_USER_ID");
						stPoNo =formData.get("PO_NO");
					} //i== 0 end
					
					//WMSIVDT INSERT
					//물류센터 송장 INSERT
					
					try{
						formData.put("INV_SEQ_I", String.valueOf(i+1));
						formData.put("INVK_NO", Invk_no);

						if("KRDAEW0016".equals(formData.get("BUYER"))  &&("1".equals(formData.get("PROCESS_TYPE")) || "2".equals(formData.get("PROCESS_TYPE")) ||"3".equals(formData.get("PROCESS_TYPE")))){
							formData.put("LEGACY_IV_SERIAL", "");
						}else{
							formData.put("LEGACY_IV_SERIAL", legacyIvSerial);
						}
						int insCnt = 0;
						
						insCnt = sqlSessionTemplate.update("common.wmgi.insertMasterWmGiReleaseTransPopList", formData);
						
						if(insCnt < 1){
							rtnMsg = "출고지시 대상 데이터가 없어 송장을 생성하지 못했습니다.";
							throw new RuntimeException(rtnMsg);
						}
						

						// 출고예정일 변경 ICOMPORS BUYER_DS_DATE UPDATE
						sqlSessionTemplate.update("common.wmgi.updateMasterWmGiDstbtrICOMPORS_GiOrder", formData);

					}catch(Exception se)	{
						rtnMsg = "송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.";
						//throw new RuntimeException("송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.");
						throw new Exception();
					}

					
					try{
						sqlSessionTemplate.update("common.wmgi.updateMasterWmGiReleaseTransPopICOMPODT", formData);	
					}catch(Exception se)	{
						rtnMsg ="송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.";
						throw new RuntimeException("송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.");
					}
					
					try{
						sqlSessionTemplate.update("common.wmgi.updateMasterWmGiReleaseTransPopICOMIVDT", formData);	
					}catch(Exception se)	{
						rtnMsg ="송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다.";
						throw new RuntimeException("송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다.");
					}
					
					if("1".equals(formData.get("PROCESS_TYPE"))){
						try{
							sqlSessionTemplate.update("common.wmgi.updateMasterWmGiReleaseTransPopWMSSTCK", formData);	
						}catch(Exception se)	{
							rtnMsg ="송장생성중(WMS UPDATE WMSSTCK) 에러가 발생하였습니다.";
							throw new RuntimeException("송장생성중(WMS UPDATE WMSSTCK) 에러가 발생하였습니다.");
						}
					}else if("3".equals(formData.get("PROCESS_TYPE"))){
						try{
							sqlSessionTemplate.update("common.wmgi.updateMasterWmGiReleaseTransPopWMSSTCK2", formData);	
						}catch(Exception se)	{
							rtnMsg ="송장생성중(WMS UPDATE WMSSTCK) 에러가 발생하였습니다.";
							throw new RuntimeException("송장생성중(WMS UPDATE WMSSTCK) 에러가 발생하였습니다..");
						}
					}
					
					if(checkDuplicate(formData)){
						rtnMsg ="송장생성중( Duplicate Check ) 에러가 발생하였습니다.\n\nDuplicate Check ERROR.";
						throw new RuntimeException("송장생성중( Duplicate Check ) 에러가 발생하였습니다.\n\nDuplicate Check ERROR");
					}
				} //END FOR
				
				// 일양, 한진 택배사 선택
				String deliCompany = formData.get("select_deliCompany");
				try{					
					//일양택배송장 데이터 생성대상 체크.
					List<Map<String,String>>_listIYsendYn = null;					
					Map<String,String> _dataParam = null;
					_dataParam = new HashMap<String,String>() ;
					_dataParam.put("BUYER", stBuyer);
					_dataParam.put("PR_USER_ID", stPrUserId);
					_dataParam.put("INV_NO", Invk_no);
					_dataParam.put("USER_ID", formData.get("st_user_id")); //로그인 사용자 ID
					boolean itemQty = formData.get("IVK_QTY").startsWith("-"); // 마이너스인 경우 true
					_listIYsendYn = sqlSessionTemplate.selectList("common.wmgi.selectMasterWmIyangLogisHawb",_dataParam);
					//일양택배
					String IYsendYn = CommonUtil.getListKeyValue(_listIYsendYn,"IY_SEND_YN","N");
					if((IYsendYn.equals("Y") || deliCompany.equals("IY"))  && !itemQty){
						int box_qty = 1;
						//출고지시, 일괄출고지시 구분
						if(formData.get("st_box_qty") != null) {							
							box_qty = Integer.parseInt(formData.get("st_box_qty"));
						}else {
							if(formData.get("ktag_box_qty") != null) {								
								box_qty = Integer.parseInt(formData.get("ktag_box_qty"));
							}
						}
						
						for(int i=1; i <= box_qty; i++){
							Map<String,String> _dataDetailParam = null;
							_dataDetailParam = new HashMap<String,String>() ;
							_dataDetailParam.put("WAREHOUSE_CODE", stWareHouseCd);
							_dataDetailParam.put("BUYER", stBuyer);
							_dataDetailParam.put("INV_NO", Invk_no);
							_dataDetailParam.put("BOX_SEQ",Integer.toString(i)); //박스수량 SEQ
							_dataDetailParam.put("PR_USER_ID", stPrUserId); //구매요청자 ID
							_dataDetailParam.put("USER_ID", formData.get("st_user_id")); //로그인 사용자 ID
							_dataDetailParam.put("PO_NO", stPoNo); //발주번호
							//일양택배 송장 매핑 insert
							sqlSessionTemplate.update("common.wmgi.insertMasterWmIyangLogisHawb", _dataDetailParam);						
						}
						
						//WMSIVDT 택배사, 송장번호 업데이트.
						sqlSessionTemplate.update("common.wmgi.updateMasterWmIyangWmsivdt", _dataParam);
						stIYgbn = "Y";
					}
				}catch(Exception se)	{
					rtnMsg ="일양택배 생성중 에러가 발생하였습니다.";
					throw new RuntimeException(rtnMsg);
				}
				
				//한진택배 추가
				try{											
					List<Map<String,String>>_listHjsendYn = null;					
					Map<String, Object> result = new HashMap<String,Object>();
					Map<String,String> _dataParam = null;					
					Map<String, Object> itemHd = null;
					_dataParam = new HashMap<String,String>() ;
					_dataParam.put("BUYER", stBuyer);
					_dataParam.put("PR_USER_ID", stPrUserId);
					_dataParam.put("INV_NO", Invk_no);
					boolean itemQty = formData.get("IVK_QTY").startsWith("-"); // 마이너스인 경우 true
					_listHjsendYn = sqlSessionTemplate.selectList("common.wmgi.selectHanjinSendYn",_dataParam);					
					String hjsendYn = CommonUtil.getListKeyValue(_listHjsendYn,"HJ_SEND_YN","N");
					
					if((hjsendYn.equals("Y") || deliCompany.equals("HJ")) && !itemQty){		
						int box_qty = 1;
						//출고지시, 일괄출고지시 구분
						if(formData.get("st_box_qty") != null) {							
							box_qty = Integer.parseInt(formData.get("st_box_qty"));
						}else {
							if(formData.get("ktag_box_qty") != null) {								
								box_qty = Integer.parseInt(formData.get("ktag_box_qty"));
							}
						}
						
						//HMAC 생성
						String HMAC = "";
						HMAC = getHanjinHMAC();
						
		            	String url = "";
		            	logger.info("##### Hanjin box_qty  : "+ box_qty);
						for(int i=1; i <= box_qty; i++){

							sqlSessionTemplate.update("common.wmgi.insertHanjinHd", _dataParam);
							
			            	//전송할 택배데이터 조회
			            	List<Map<String,Object>> itemHdLst = sqlSessionTemplate.selectList("common.wmgi.selectHanjinItemHdLst",_dataParam);
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
		            					result.put("msg_seq", String.format("%06d", i));
		    							sqlSessionTemplate.update("common.wmgi.updateHanjinParcelLb", result);
		    							
			            				//2. 한진 API 택배 주문 등록
			            				url = CommonProperty.getHanjinPrdUrl() + "/parcel-delivery/v1/order/insert-order";
			            				result = HttpClientUtil.apiCallHttps("POST", "HANJIN", url, itemHd, HMAC);
			            				
			            				if("OK".equals(result.get("resultCode"))) {
			            					logger.info("##### Hanjin 택배 주문 등록 성공  ");
			    		       				result.put("flag", "Y");		    		       		    		       				
			    		       				result.put("buyer", _dataParam.get("BUYER"));
			    		       				result.put("inv_no", _dataParam.get("INV_NO"));
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
			            		} catch (Exception e) {
			            			throw new RuntimeException(e.getMessage());
								}
			            	}				
						}						
									
						stIYgbn = "HJ";
					}
				}catch(Exception se)	{					
					throw new RuntimeException(se.getMessage());
				}
				
				rtnMsg +=Invk_no+"@@"+stIYgbn;
			}
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException(e.getMessage());
		}
		
		return rtnMsg;
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
	
	
	private boolean checkDuplicate(Map<String,String>  formData)throws RuntimeException{
	boolean isDuplicate = false;
	List<Map<String,Object>> wmsStckForSTCKCount  = sqlSessionTemplate.selectList("common.wmgi.checkMasterWmGiReleaseTransPopDuplicate", formData);
	BigDecimal tempINV_QTY = new BigDecimal(wmsStckForSTCKCount.get(0).get("INV_QTY").toString());
	BigDecimal tempWMS_IVK_QTY = new BigDecimal(wmsStckForSTCKCount.get(0).get("WMS_IVK_QTY").toString());

	if(tempINV_QTY.compareTo(tempWMS_IVK_QTY) ==-1){
		isDuplicate = true;
	}

	return isDuplicate;
	}
}
