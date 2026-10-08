package com.koreab2b.mro.buyer.mprq.dao;

import java.io.BufferedInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.webservice.lottechilsung.InterfaceSoapProxy;
import com.org.json.JSONArray;

@Repository("buyerMpRqUnitpriceAgrmntNegoReqDao")
@Transactional
public class BuyerMpRqUnitpriceAgrmntNegoReqDaoImpl implements BuyerMpRqUnitpriceAgrmntNegoReqDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqUnitpriceAgrmntNegoReqDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mprq.selectBuyerMpRqUnitpriceAgrmntNegoReqList", formData);
	}
	
	// 견적합의대상_v2
	public List<Map<String,String>> selectList_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.mprq.selectBuyerMpRqUnitpriceAgrmntNegoReqList_v2", formData);
	}
	
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상적으로 Nego요청 접수 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				int rqdtChkFlag = sqlSessionTemplate.update("buyer.mprq.updateNegoBuyerRqdt", formData);
				if (rqdtChkFlag != 1){
					_rtnMsg = "네고요청 RQDT 처리중 오류가 발생했습니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				int qtdtChkFlag = sqlSessionTemplate.update("buyer.mprq.updateNegoBuyerQtdt", formData);
				if (qtdtChkFlag <= 0){
					_rtnMsg = "네고요청 QTDT 처리중 오류가 발생했습니다.";
					throw new RuntimeException(_rtnMsg);
				}
				//네고요청시 KeP담당자, 소싱담당자에게 메일서비스
				sqlSessionTemplate.update("buyer.mprq.insertNegoBuyerBmMail", formData);
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("Nego요청을 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
	return _rtnMsg;
		
	}
	// 저장(네고요청)_v2
	@SuppressWarnings("unchecked")
	public String updateSelectedData_v2(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상적으로 Nego요청 접수 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				formData.put("BTOA_END_TIME2", "190000"); // 마감시간 고정
				
				int rqdtChkFlag = sqlSessionTemplate.update("buyer.mprq.updateNegoBuyerRqdt_v2", formData);
				if (rqdtChkFlag != 1){
					_rtnMsg = "네고요청 RQDT 처리중 오류가 발생했습니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				int qtdtChkFlag = sqlSessionTemplate.update("buyer.mprq.updateNegoBuyerQtdt_v2", formData);
				if (qtdtChkFlag <= 0){
					_rtnMsg = "네고요청 QTDT 처리중 오류가 발생했습니다.";
					throw new RuntimeException(_rtnMsg);
				}
				//네고요청시 KeP담당자, 소싱담당자에게 메일서비스
				sqlSessionTemplate.update("buyer.mprq.insertNegoBuyerBmMail_v2", formData);
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("Nego요청을 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
	return _rtnMsg;
		
	}
	// 취소
	@SuppressWarnings("unchecked")
	public String updateSelectedCancleData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상적으로 견적 취소처리 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				int rqdtChkFlag = sqlSessionTemplate.update("buyer.mprq.updateBuyerRqdtCancle", formData);
				if (rqdtChkFlag != 1){
					_rtnMsg = "견적 취소 처리중 오류가 발생했습니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				/* 견적 취소 메일 전송 (고객사 특수로직 관리) */
				boolean qt_cancel_mail_flag = CommonUtil.getSpecialCheckReturn(formData.get("st_buyer2"),"P04-4056-01");
				
				if(qt_cancel_mail_flag == true){
					sqlSessionTemplate.update("buyer.mprq.insertBuyerMpRqQtCancelMail", formData); //Mail Send
				}
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 취소처리 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
	return _rtnMsg;
		
	}
	
	// 취소_v2
	@SuppressWarnings("unchecked")
	public String updateSelectedCancleData_v2(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상적으로 견적 취소처리 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				LOGGER.debug("saveBuyerMpRqUnitpriceAgrmntCancleReqList_v2 DAO 파라미터 formData : {}", formData);
				
				int rqdtChkFlag = sqlSessionTemplate.update("buyer.mprq.updateBuyerRqdtCancel_v2", formData);
				if (rqdtChkFlag != 1){
					_rtnMsg = "견적 취소 처리중 오류가 발생했습니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				/* 견적 취소 메일 전송 (고객사 특수로직 관리) */
				boolean qt_cancel_mail_flag = CommonUtil.getSpecialCheckReturn(formData.get("st_buyer2"),"P04-4056-01");
				
				if(qt_cancel_mail_flag == true){
					sqlSessionTemplate.update("buyer.mprq.insertBuyerMpRqQtCancelMail_v2", formData); //Mail Send
				}
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 취소처리 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
	return _rtnMsg;
		
	}
	// 단가합의 - 저장(최초)
	@SuppressWarnings("unchecked")
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmnt(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "정상적으로 단가합의 되었습니다.";
		String _gw_no = "N";
		String _checkpass = null;
		String _passflag = "N";
		String _exceptPassflag = "N";
		Map<String, String> pMap = new HashMap<String, String>();
		Map<String, String> cMap = new HashMap<String, String>();
		
		String _callurl	= "";
		String _buyerpopflag = "N";
		
		try{
			formData.put("DOC_TYPE", "NS");
			_checkpass = sqlSessionTemplate.selectOne("buyer.mprq.getPassCheck",formData);
			_passflag = sqlSessionTemplate.selectOne("buyer.mprq.getPassFlag",formData);
			
			if (_checkpass.equals("0") || _checkpass.equals(null)){ // 결재 처리를 하지 않는 경우
				formData.put("RECV_FLAG", "CM");
			} else {
				formData.put("RECV_FLAG", "GA");
				//_gw_no = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer2"), "NS");
				_gw_no = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "QA"); // 전체 고객사 QA로 단가합의 채번 통일(다른 고객사도 묶어서 합의 결재 할 수 있도록 QA만으로 조회조건 사용)
			}
			// 특수로직 추가 - 결재 번호 채번. RX
			
			// 특수로직 추가
			// 결재 상신 후 결재정보 인터페이스 테이블에 등록처리. P11-0000004
			// 고객사 요청으로 결재정보를 넘겨줄 경우 이 방법을 사용함.
			boolean p110000004 = CommonUtil.getSpecialCheckReturn(formData.get("st_buyer2"),"P11-0000004"); // 권한특수로직
			//단가합의시 장바구니 담기
			boolean p04403134 = CommonUtil.getSpecialCheckReturn(formData.get("st_buyer2"),"P04-4031-34"); // 권한특수로직
			
			// 고객사 견적 예외사항 체크
			boolean buyer_exception_yn = CommonUtil.getSpecialCheckReturn(formData.get("st_buyer2"),"P04-4027-10"); // 권한특수로직
			
			String buyer_exception_type	= "";
			if (buyer_exception_yn) {
				buyer_exception_type = CommonUtil.getSpecialCheckReturn(formData.get("st_buyer2"), "P04-4027-10", "COL01_DATA");
			}
			
			// 결재 후처리 타입 
			String st_type	= null;
			try {
				st_type = CommonUtil.getSpecialCheckReturn(formData.get("st_buyer2"), "P11-0000004", "COL01_DATA");
			} catch (Exception e) {
				st_type	= "X";
			}
			if (p110000004) {
				if ("TYPE04".equals(st_type)) {
					_gw_no = masterMpRqBuyerReqDao.nextVal("KRLOTTG004", "RX");
				}
			}
			LOGGER.debug("단가합의 파라미터 ::::::::::::::::::::::: {} ", formData);
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));	
				LOGGER.debug(i+"th 단가합의 파라미터 ::::::::::::::::::::::: {} ", formData);
				if (formData.get("st_nocode_yn").equals("Y")) {
					
					cMap.put("BUYER", formData.get("st_buyer2"));
					cMap.put("REG_ITEM_NO", formData.get("st_buyer_item_no2"));
					// 실코드 != 품목코드
//					if (!formData.get("st_buyer_item_no3").equals(formData.get("st_buyer_item_no2"))) {
//						String _itemDupChk  = sqlSessionTemplate.selectOne("master.mprq.getItemDupChk", cMap); 
//						if (!"0".equals(_itemDupChk)){
//							_rtnMsg = "중복된 품목코드 입니다.";
//							pMap.put("MSG", _rtnMsg);
//							pMap.put("GW_NO", "N");
//							pMap.put("passflag", _passflag);
//							return pMap;
//						}
//					}
				}
				
				sqlSessionTemplate.update("buyer.mprq.updateBuyerItemNo", formData);
				
				if(formData.get("st_user_id") == "SNT76721"){         
					_passflag = "N";    
			    }
				
				formData.put("GW_NO", _gw_no);
				
				// 고객사별 견적 특수로직 시작
				// TYPE1 - 고객사카테고리 따라 결재여부 판단(휴온스 그룹)
				if(buyer_exception_type.equals("TYPE1")) {
					if(!"H02".equals(formData.get("st_categ_code"))) {
						formData.put("GW_NO", "N");
					}
				}
				// 고객사별 견적 특수로직 끝
				
				if (formData.get("GW_NO").equals("N")){ // 결재 처리를 하지 않는 경우
					// 고객사별 견적 특수로직 시작
					// 깨끗한나라 & MSDS NO가 있는 품목(KEP와 기준이 다름) & 단가합의자(화학물질담당자 X) -> 단가합의 하지 않고 MSDS STATUS 변경 -> 화학물질담당자가 단가합의 시에는 아래 기존 단가합의 로직 타도록. 결재 받는 경우는 적용이 현재 안됨.
					if(buyer_exception_type.equals("TYPE2") && !formData.get("st_msds_no").equals("") && formData.get("st_msds_search_flag").equals("N")){
						sqlSessionTemplate.update("buyer.mprq.updateNpassMsdsStatus", formData);
					// 고객사별 견적 특수로직 끝
					
					}else{ // 기존 단가합의 로직
						// 해당 카탈로그 정보 변경
						sqlSessionTemplate.update("buyer.mprq.updateNpassCqdtUnit", formData);
						sqlSessionTemplate.update("buyer.mprq.updateNpassCqdt", formData);
						sqlSessionTemplate.update("buyer.mprq.updateNpassByit", formData);
						
						//견적 멀티(그룹 내 카탈로그) 선택 기등록건 업데이트 Start
						List<Map<String,String>> list = null;
						list = sqlSessionTemplate.selectList("buyer.mprq.selectNpassGCqdtGList", formData);
						
						//기등록건 N계약건 업데이트 Start. 데이터 없으면 update 0 row
						//기등록건 icomcqdt 대상 있으면 업데이트
					    if(list.size() > 0){
					    	for(int j=0; j<list.size(); j++){
					    		Map<String,String> mp = (Map<String,String>)list.get(j);
								
					    		//계약정보 가져옴
								String st_buyer = CommonUtil.nvl(mp.get("BUYER"),"");
								String  _contract_info[] = mp.get("CONTRACT_INFO").split("&&");
								
								//계약정보 있을경우 데이터 업데이트.
								//LOGGER.debug("_contract_info:::::::::::::::::::::::  "+_contract_info.length);
								if (_contract_info.length >0){
									for( int k=0 ; k < _contract_info.length; k++){
										String str[] =  _contract_info[k].split("@@",-1);
								        //LOGGER.debug(" str.length:::::::::::::::::::::::  "+ str.length);
								        
								        if (str != null && str.length == 2){
								        	Map<String,String> _dataParam = null;
											_dataParam = new HashMap<String,String>();
											_dataParam.put("G_BUYER", st_buyer);
											_dataParam.put("G_CONTRACT_NO",str[0]);
											_dataParam.put("G_CONTRACT_SEQ",str[1]);
											_dataParam.put("st_user_id", formData.get("st_user_id"));
											_dataParam.putAll((Map<String, String>)gridData.get(i));
											
											//기등록건 계약 업데이트
											sqlSessionTemplate.update("buyer.mprq.updateNpassGCqdt", _dataParam);
											
											//기등록건 이력 인서트
											sqlSessionTemplate.update("buyer.mprq.updateNpassGCqep", _dataParam);				        	
								        }
									}
								}				
							}
						}//견적 멀티 선택 기등록건 업데이트 End
					    
					    // 휴온스 그룹의 경우 결재 처리를 하지않더라도 GA로 들어가는 경우가 있어 결재처리 하지않을 때 RECV_FLAG = CM으로 변경
					    formData.put("RECV_FLAG", "CM");
						
					    //견적업데이트
						sqlSessionTemplate.update("buyer.mprq.updateNpassRqdt", formData);
						
						//단가합의 후 장바구니 담기
						if(p04403134 == true) {
							sqlSessionTemplate.update("buyer.mprq.insertUnitPriceRqdtCart", formData);
						}
						
						//선입고 장바구니 특수로직 체크
						String BUYER = formData.get("st_buyer2");
						boolean sCartYn = CommonUtil.getSpecialCheckReturn( BUYER,"P04-4031-01");
						
						//선입고 특수로직있고 견적건에 선입고 체크 되어 있으면 선입고 장바구니 입력
						LOGGER.debug("선입고 견적여부==>" + formData.get("st_pre_gr_flag")+"/"+sCartYn);
						if (sCartYn == true && formData.get("st_pre_gr_flag").equals("Y")){
							LOGGER.debug("선입고 장바구니 등록");
							
							int cart_result = sqlSessionTemplate.update("buyer.mprq.insertUnitPricePreCart", formData);
							
							if(cart_result < 0) {
								throw new RuntimeException("선입고 장바구니 등록정보가 없습니다.");
							}					
						}
					}
				} else { // 결재 처리 하는 경우
					if (_passflag.equals("N")){
						_rtnMsg = "전자 결재 처리 하시겠습니까? \n\n직접 합의 하시려면 취소버튼을 눌러 주십시오.";
					}
					
					// 결재 한번이라도 했다면
					_exceptPassflag = "Y";

					if (p110000004 && "TYPE04".equals(st_type)) {
						// 고객사 결재 연동시 상신시작 시점을 저장함.
						formData.put("RECV_FLAG","GS");
						sqlSessionTemplate.update("buyer.mprq.updatePassRqdtIF", formData);
					} else {
						sqlSessionTemplate.update("buyer.mprq.updatePassRqdt", formData);	
					}
				}
			}

			/**
			 * 롯데알미늄 결재 연동 인터페이스 추가.
			 */
			if (p110000004) {
				if ("TYPE04".equals(st_type)) {
					// 롯데알미늄 2
					Map<String, String> pMap2 = new HashMap<String, String>();
					pMap2.put("BUYER", formData.get("st_buyer2"));
					pMap2.put("GW_NO", formData.get("GW_NO"));
					
					String xmlStr	= makeBuyerXmlData(pMap2);
					String st_legacy_user_id	= formData.get("st_legacy_user_id");
					
					Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("st_buyer2"), "P11-0000004");

					String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
					String st_host	= CommonUtil.nvl(slgMap.get("COL03_DATA"));
					String st_mode	= CommonUtil.nvl(slgMap.get("COL04_DATA"));

					// 재개발 2020-12-10
					int rc = 0;
			        HttpPost post = new HttpPost(st_url);
			        
			        List<NameValuePair> params = new ArrayList<NameValuePair>();
			        
			        params.add(new BasicNameValuePair("host", st_host));
			        params.add(new BasicNameValuePair("id", st_legacy_user_id));
			        params.add(new BasicNameValuePair("mode", st_mode));
			        params.add(new BasicNameValuePair("xmlData", xmlStr));
			        post.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));

			        HttpClient client = HttpClientBuilder.create().build();
			        HttpResponse resp = client.execute(post);
			        
			        rc = resp.getStatusLine().getStatusCode();
			        
			        if (rc == 200) {
			        	System.out.println(resp.toString());
			        	
			        	HttpEntity ent = resp.getEntity();
			        	InputStream is	= ent.getContent();
			        	String content = "";
			        	
			        	BufferedInputStream bis = new BufferedInputStream(is);
			        	byte[] buffer = new byte[10240];
			        	while((bis.read(buffer)) != -1) {
			        		content += new String(buffer, "UTF-8");
			        	}
			        	try {
			        		bis.close();
						} catch (Exception e) {e.printStackTrace();}

			        	JSONArray ja = new JSONArray(content);

		        		if (!"OK".equals(ja.getString(0))) {
		        			System.out.println("LTAL RFQ APP ERR : " + ja.getString(1));
		        			throw new RuntimeException(ja.getString(1));
		        		} else {
		        			_callurl = ja.getString(1);
		        		}
				        _buyerpopflag	= "Y";
			        } else {
						pMap2.put("RECV_FLAG", "GA");
			        	sqlSessionTemplate.update("buyer.mprq.updateNsReject", formData);
				        _buyerpopflag	= "N";
			        }
				}
			}
			
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
		
		// 결재를 받은 적이 없다면 jsp 리턴시에도 결재 생략
		if(_exceptPassflag.equals("N")) {
			_gw_no = "N";
		}
		
		pMap.put("MSG", _rtnMsg);
		pMap.put("GW_NO", _gw_no);
		pMap.put("passflag", _passflag);
		pMap.put("callurl", _callurl);
		pMap.put("buyerpopflag", _buyerpopflag);

		return pMap;
	}
	// 견적종료
	@SuppressWarnings("unchecked")
	public Map<String,String> saveBuyerMpRqCloseRemark(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "견적종료 처리 완료되었습니다.";

		Map<String, String> pMap = new HashMap<String, String>();
		
		try{
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));	
				sqlSessionTemplate.update("buyer.mprq.updateCloseRqdt", formData); //rqdt 견적종료
				sqlSessionTemplate.update("buyer.mprq.updateCloseByit", formData);  //byit 견적종료
				sqlSessionTemplate.update("buyer.mprq.InsertMailCloseRqdt", formData); //Mail Send
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적종료 처리 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
		
		pMap.put("MSG", _rtnMsg);
		
		return pMap;
	}
	// 단가합의 - 저장(화면 갔다가 재호출-결재 메시지 후 미결재대상 재처리)
	@SuppressWarnings("unchecked")
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmntNonPass(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "정상적으로 단가합의 되었습니다.";
		Map<String, String> pMap = new HashMap<String, String>();
		Map<String, String> cMap = new HashMap<String, String>();
		try{
				
			formData.put("RECV_FLAG", "CM");
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
					if (formData.get("st_nocode_yn").equals("Y")) {
					
					cMap.put("BUYER", formData.get("st_buyer2"));
					cMap.put("REG_ITEM_NO", formData.get("st_buyer_item_no2"));
					// 실코드 != 품목코드
//					if (!formData.get("st_buyer_item_no3").equals(formData.get("st_buyer_item_no2"))) {
//						String _itemDupChk  = sqlSessionTemplate.selectOne("master.mprq.getItemDupChk", cMap); 
//						if (!"0".equals(_itemDupChk)){
//							_rtnMsg = "중복된 품목코드 입니다.";
//							pMap.put("MSG", _rtnMsg);
//							return pMap;
//						}
//					}
				}		
				
				sqlSessionTemplate.update("buyer.mprq.updateBuyerItemNo", formData);
				
				sqlSessionTemplate.update("buyer.mprq.updateNpassCqdtUnit", formData);
				sqlSessionTemplate.update("buyer.mprq.updateNpassCqdt", formData);
				sqlSessionTemplate.update("buyer.mprq.updateNpassByit", formData);
				//견적 멀티 선택 기등록건 업데이트 Start
				List<Map<String,String>> list = null;
				list = sqlSessionTemplate.selectList("buyer.mprq.selectNpassGCqdtGList", formData);
				//기등록건 N계약건 업데이트. 데이터 없으면 update 0 row
				//기등록건 icomcqdt 대상 있으면 업데이트
			    if(list.size() > 0){
					for(int j=0; j<list.size(); j++){
						Map<String,String> mp = (Map<String,String>)list.get(j);
						//계약정보 가져옴
						String st_buyer = CommonUtil.nvl(mp.get("BUYER"),"");
						String  _contract_info[] = mp.get("CONTRACT_INFO").split("&&");
						//계약정보 있을경우 데이터 업데이트.
						LOGGER.debug("_contract_info:::::::::::::::::::::::  "+_contract_info.length);
						 if (_contract_info.length >0){
							 for( int k=0 ; k < _contract_info.length; k++){
						        String str[] =  _contract_info[k].split("@@",-1);
						        LOGGER.debug(" str.length:::::::::::::::::::::::  "+ str.length);
						        if (str != null && str.length == 2){
						        	Map<String,String> _dataParam = null;
									_dataParam = new HashMap<String,String>() ;
									_dataParam.put("G_BUYER", st_buyer);
									_dataParam.put("G_CONTRACT_NO",str[0]);
									_dataParam.put("G_CONTRACT_SEQ",str[1]);
									_dataParam.put("st_user_id", formData.get("st_user_id"));
									_dataParam.putAll((Map<String, String>)gridData.get(i));
									//기등록건 계약 업데이트
									sqlSessionTemplate.update("buyer.mprq.updateNpassGCqdt", _dataParam);
									//기등록건 이력 인서트
									sqlSessionTemplate.update("buyer.mprq.updateNpassGCqep", _dataParam);				        	
						        }
							 }
						 }				
					}
			    }//견적 멀티 선택 기등록건 업데이트 End
				sqlSessionTemplate.update("buyer.mprq.updateNpassRqdt", formData);
			}	
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
		
		pMap.put("MSG", _rtnMsg);
		
		return pMap;
	}
	
	// 결재상신
	@SuppressWarnings("unchecked")
	public Map<String,String> getAppSendList(Map<String,String> formData, List<Object> gridData) {
			
		String _rtnMsg = "";
		String chk = "OK";
		Map<String, String> pMap = new HashMap<String, String>();
		Map<String, String> _rtnMap = new HashMap<String, String>();
		List<Map<String,String>> _processlist = new ArrayList<Map<String,String>>();
		
		try {
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));	
				System.out.println("formData2 : " + formData);
				pMap = sqlSessionTemplate.selectOne("buyer.mprq.selectRqAppSendList",formData); 
				
				if (pMap == null) {
					chk = "PS";
					break;
				}
				_processlist.add(pMap);
			}	
			
			System.out.println("_processlist : " + _processlist);
			
			if (chk.equals("PS") || gridData.size() != _processlist.size()) {
				_rtnMap.put("msg", "품의상신중인 문서가 존재합니다. 롯데칠성 그룹웨어에서 확인 바랍니다. 문의사항은 코리아이플랫폼(주) 담당자에게 연락 주세요");
				_rtnMap.put("chk", chk);
				_rtnMap.put("callback", "");
			} else {
				String key_no = sqlSessionTemplate.selectOne("buyer.mprq.selectMpRqGetKeyNo");
				
				_rtnMap = getRqAppXml(_processlist,key_no);
				_rtnMap.put("chk", chk);
				
				for(int i=0; i < _processlist.size(); i++){
					
					pMap = new HashMap<String, String>();
					pMap = (Map<String, String>)_processlist.get(i);
					pMap.put("key_no",key_no);
					
					sqlSessionTemplate.update("buyer.mprq.updateRqdtAppSend", pMap);
					
//					System.out.println("pMap : " + pMap);
				}
				
				sqlSessionTemplate.update("buyer.mprq.updateRqdtAppSendDBlinkList", pMap);
				
				InterfaceSoapProxy proxy = new InterfaceSoapProxy();
				String callback = proxy.requestDraft(_rtnMap.get("domain_code"), _rtnMap.get("id"), _rtnMap.get("systemid"), _rtnMap.get("keyvalue"), _rtnMap.get("moduleId"), _rtnMap.get("formAlias"), _rtnMap.get("mode"), _rtnMap.get("xmlData"));
				
				String start = callback.substring(0,1);
				if (start.equals("O")){
					callback = callback.replace("OK:","");
				}else {
					callback = callback.replace("ERR:","");
				}
				
				_rtnMap.put("callback",callback);
				
				System.out.println("_rtnMap : " + _rtnMap);
			}
			
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("결재상신 중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
		
		return _rtnMap;
	}
	
	// 결재 상신 xml 구성
	public Map<String,String> getRqAppXml (List<Map<String,String>> iMap, String key_no){
		
		Map<String,String> _map = new HashMap<String, String>();
		StringBuffer xml	= new StringBuffer();
		int i = 1;
		
		for (Map<String,String>pMap : iMap) {
			if (i == 1) {
				
				_map.put("domain_code","11");
				_map.put("id",pMap.get("LEGACY_USER_ID"));
				_map.put("systemid","KEP");
				_map.put("keyvalue",key_no);
				_map.put("moduleId","ORDER");
				_map.put("formAlias","KEP_ORDER_REQUEST");
				_map.put("mode","1");
				
				xml.append("<DBAPPROVAL><HEADER>");
				
				xml.append("<SYSTEMID>"+ _map.get("systemid") +"</SYSTEMID>");
				xml.append("<MODULEID>"+ _map.get("moduleId") +"</MODULEID>");
				xml.append("<FORMALIAS>"+ _map.get("formAlias") +"</FORMALIAS>");
				xml.append("<KEYVALUE><![CDATA[" +key_no + "]]></KEYVALUE>"); // 요청번호 채번해서 넣어야됨
				xml.append("<SUBJECT><![CDATA["+ "10002022, (주) 코리아이플랫폼, "+ pMap.get("DESCRIPTION") +"]]></SUBJECT>");
				xml.append("<LINKED_PID></LINKED_PID>");
				xml.append("<REF_PID></REF_PID>");
				xml.append("<ETC1></ETC1>");
				xml.append("<ETC2></ETC2>");
				xml.append("<ETC3></ETC3>");
				xml.append("<ETC4></ETC4>");
				xml.append("<ETC5></ETC5>");
				xml.append("</HEADER><BODY><CONTENT TYPE=\"XML\">");
				
				xml.append("<KTEXT><![CDATA[" + pMap.get("BTOA_USER_DEPT") + "]]></KTEXT>"); // 의뢰부서
				xml.append("<BADAT><![CDATA[" + pMap.get("BTOA_DATE") + "]]></BADAT>"); // 의뢰일자 BTOA_DATE
				xml.append("<DEPTNM><![CDATA[" + pMap.get("BTOA_USER_DEPT") + "]]></DEPTNM>"); // 코스트센터
				xml.append("<BANFN><![CDATA[" + key_no + "]]></BANFN>"); // 의뢰번호
				
			}
				xml.append("<ITEM>");
				xml.append("<LV_NO><![CDATA[" + String.valueOf(i) + "]]></LV_NO>");  // 주문번호
				xml.append("<GROES><![CDATA[" + pMap.get("SPECIFICATION") + "]]></GROES>");  // 규격
				xml.append("<BSTME><![CDATA[" + pMap.get("UNIT_MEASURE") + "]]></BSTME>");  // 단위
				xml.append("<MENGE><![CDATA[" + String.valueOf(pMap.get("ITEM_QTY")) + "]]></MENGE>");  // 수량
				xml.append("<LFDAT_T><![CDATA[" + pMap.get("BTOA_END_DATE") + "]]></LFDAT_T>");  // 요구일자  BTOA_END_DATE
				
				xml.append("<TXZ01><![CDATA[" + pMap.get("DESCRIPTION") + "]]></TXZ01>");  // 품명
				xml.append("<MATNR><![CDATA[" + pMap.get("BUYER_ITEM_NO") + "]]></MATNR>");  // 품목코드
				
				xml.append("</ITEM>");
				
			i++;
		}
		xml.append("</CONTENT></BODY></DBAPPROVAL>");
		_map.put("xmlData",xml.toString());
		
		return _map;
	}
	
	// 단가합의 결재 요청 후 처리(NS)
	public String nsRequest(Map<String,String> formData){
		formData.put("RECV_FLAG", "GS");
		// STEP1
		sqlSessionTemplate.update("buyer.mprq.updateNsCancelKEPRQDT", formData);
		
		return "OK";
	}
	
	// 단가합의 결재 상신취소 후 처리(NS)
	public String nsCancel(Map<String,String> formData){
		// STEP1
		formData.put("RECV_FLAG", "GA");
		sqlSessionTemplate.update("buyer.mprq.updateNsCancelKEPRQDT", formData);
        
		return "OK";
	}
	
	// 단가합의 결재 승인 후 처리(NS)
	public String nsApproval(Map<String,String> formData){
		
		formData.put("RECV_FLAG", "CM");
		
		// STEP1 - KEPRQDT
		sqlSessionTemplate.update("buyer.mprq.updateNsApproval1", formData);

		// 신규, 실코드 입력 update 확인
		Map<String, String> _map = sqlSessionTemplate.selectOne("buyer.mprq.getItemRqdt",formData);
		if (_map == null || _map.size() == 0){
		} else {
			sqlSessionTemplate.update("buyer.mprq.updateNsApproval_BYIT", _map);
			sqlSessionTemplate.update("buyer.mprq.updateNsApproval_CQDT", _map);
		}
		
		// STEP3 - ICOMCQDT
		sqlSessionTemplate.update("buyer.mprq.updateNsApproval3", formData);
//				// STEP4 - ICOMCQEP
//				sqlSessionTemplate.update("buyer.mprq.updateNsApproval4", formData);
		// STEP5 - ICOMCQEP
		sqlSessionTemplate.update("buyer.mprq.updateNsApproval5", formData);
		//견적 멀티 선택 기등록건 업데이트 Start
		List<Map<String,String>> list = null;
		Map<String,String> _dataParam = null;
		list = sqlSessionTemplate.selectList("buyer.mprq.selectNsApprovalList", formData);
		//기등록건 icomcqdt 대상 있으면 업데이트
	    if(list.size() > 0){
			for(int i=0; i<list.size(); i++){
				Map<String,String> mp = (Map<String,String>)list.get(i);
				//계약정보 가져옴
				String st_buyer = CommonUtil.nvl(mp.get("BUYER"),"");
				String st_quotatgion_no = CommonUtil.nvl(mp.get("QUOTATION_NO"),"");
				String st_quotation_seq = CommonUtil.nvl(mp.get("QUOTATION_SEQ"),"");
				String st_revision = CommonUtil.nvl(mp.get("REVISION"),"");
				String  _contract_info[] = mp.get("CONTRACT_INFO").split("&&");
				//계약정보 있을경우 데이터 업데이트.
				LOGGER.debug("_contract_info:::::::::::::::::::::::  "+_contract_info.length);
				 if (_contract_info.length >0){
					 for( int k=0 ; k < _contract_info.length; k++){
				        String str[] =  _contract_info[k].split("@@",-1);
				        LOGGER.debug(" str.length:::::::::::::::::::::::  "+ str.length);
				        if (str != null && str.length == 2){
				        	LOGGER.debug("_dataParam:  "+str[0]+"/"+str[1]+"/"+st_buyer+"/"+st_quotatgion_no+"/"+st_quotation_seq+"/"+st_revision);
							_dataParam = new HashMap<String,String>() ;
							_dataParam.put("BUYER", st_buyer);
							_dataParam.put("QUOTATION_NO", st_quotatgion_no);
							_dataParam.put("QUOTATION_SEQ", st_quotation_seq);
							_dataParam.put("REVISION", st_revision);
							_dataParam.put("CONTRACT_NO",str[0]);
							_dataParam.put("CONTRACT_SEQ",str[1]);
							_dataParam.put("USER_ID", formData.get("USER_ID"));
							//기등록건 계약 업데이트
							sqlSessionTemplate.update("buyer.mprq.updateNsApproval6", _dataParam);
							//기등록건 이력 인서트
							sqlSessionTemplate.update("buyer.mprq.updateNsApproval7", _dataParam);				        	
				        }
					 }
				 }				
			}
	    }
		//견적 멀티 선택 기등록건 업데이트 End
		// STEP2 - ICOMBYIT
		sqlSessionTemplate.update("buyer.mprq.updateNsApproval2", formData);
		//STEP6 -ICOMCART 등록 선입고 특수로직있고 견적건에 선입고 체크 되어 있으면 선입고 장바구니 입력
		sqlSessionTemplate.update("buyer.mprq.insertNsUnitPricePreCart", formData);

		return "OK";
	}
	
	// 단가합의 결재 반려 후 처리(NS)
	public String nsReject(Map<String,String> formData){
		
		formData.put("RECV_FLAG", "GR");
        
		// STEP1
        sqlSessionTemplate.update("buyer.mprq.updateQaReject", formData);
		
		return "OK";
	}
	public List<Map<String,String>> nsResultList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("buyer.mprq.selectNsResultList", param);
	}
	public List<Map<String,String>> nsResultList_v2(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("buyer.mprq.selectNsResultList_v2", param);
	}
	
	/**
	 * 롯데 알미늄 결재 연동 목적으로 xml 생성
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	private String makeBuyerXmlData(Map<String, String> pMap) throws Exception {
		String xmlStr	= null;
		
		List<Map<String, Object>> prAppInfo = sqlSessionTemplate.selectList("buyer.mprq.selectLtalPriceConfirmAppInfo", pMap);
		
		String subject = (String)prAppInfo.get(0).get("SUBJECT");
		
		StringBuffer tmpXml	= new StringBuffer();
		tmpXml.append("<DBAPPROVAL>\n");
		tmpXml.append("<HEADER>\n");
		tmpXml.append("<SYSTEMID><![CDATA[MRO]]></SYSTEMID>\n");
		tmpXml.append("<MODULEID><![CDATA[MM]]></MODULEID>\n");
		tmpXml.append("<KEYVALUE><![CDATA[MROMM000000_KRLOTTG004_" + pMap.get("GW_NO")+"]]></KEYVALUE>\n");
		tmpXml.append("<FORMALIAS><![CDATA[MRO_001]]></FORMALIAS>\n");
		tmpXml.append("<TITLE><![CDATA[단가 합의서]]></TITLE>\n");
		tmpXml.append("<SUBJECT><![CDATA["+subject+"]]></SUBJECT>\n");
		tmpXml.append("<LINKED_PID><![CDATA[]]></LINKED_PID>\n");
		tmpXml.append("<REF_PID><![CDATA[]]></REF_PID>\n");
		tmpXml.append("<CALLBACKURI><![CDATA[]]></CALLBACKURI>\n");
		tmpXml.append("<ETC1><![CDATA[]]></ETC1>\n");
		tmpXml.append("<ETC2><![CDATA[]]></ETC2>\n");
		tmpXml.append("<ETC3><![CDATA[]]></ETC3>\n");
		tmpXml.append("</HEADER>\n");
		tmpXml.append("<BODY>\n");
		tmpXml.append("<CONTENT TYPE='XML'>\n");
		tmpXml.append("<LIST>\n");
		for(Map<String, Object> iMap : prAppInfo) {
			tmpXml.append("<ITEM>\n");
			tmpXml.append("<PLANT><![CDATA["+iMap.get("PLANT")+"]]></PLANT>\n");
			tmpXml.append("<QUOTATION_NO><![CDATA["+iMap.get("QUOTATION_NO")+"]]></QUOTATION_NO>\n");
			tmpXml.append("<QUOTATION_SEQ><![CDATA["+iMap.get("QUOTATION_SEQ")+"]]></QUOTATION_SEQ>\n");
			tmpXml.append("<BUYER_ITEM_NO><![CDATA["+iMap.get("BUYER_ITEM_NO")+"]]></BUYER_ITEM_NO>\n");
			tmpXml.append("<DESCRIPTION><![CDATA["+iMap.get("DESCRIPTION")+"]]></DESCRIPTION>\n");
			tmpXml.append("<SPECIFICATION><![CDATA["+iMap.get("SPECIFICATION")+"]]></SPECIFICATION>\n");
			tmpXml.append("<UNIT_MEASURE><![CDATA["+iMap.get("UNIT_MEASURE")+"]]></UNIT_MEASURE>\n");
			tmpXml.append("<ITEM_QTY><![CDATA["+iMap.get("ITEM_QTY")+"]]></ITEM_QTY>\n");
			tmpXml.append("<BTOA_DATE><![CDATA["+iMap.get("BTOA_DATE")+"]]></BTOA_DATE>\n");
			tmpXml.append("<BTOA_END_DATE><![CDATA["+iMap.get("BTOA_END_DATE")+"]]></BTOA_END_DATE>\n");
			tmpXml.append("<DELIVERY_LT><![CDATA["+iMap.get("DELIVERY_LT")+"]]></DELIVERY_LT>\n");
			tmpXml.append("<MAKER_NAME><![CDATA["+iMap.get("MAKER_NAME")+"]]></MAKER_NAME>\n");
			tmpXml.append("<ORIGIN_NAME><![CDATA["+iMap.get("ORIGIN_NAME")+"]]></ORIGIN_NAME>\n");
			tmpXml.append("<TARGET_PRICE><![CDATA["+iMap.get("TARGET_PRICE")+"]]></TARGET_PRICE>\n");
			tmpXml.append("<ATOB_UNIT_PRICE><![CDATA["+iMap.get("ATOB_UNIT_PRICE")+"]]></ATOB_UNIT_PRICE>\n");
			tmpXml.append("<REQ_USER_NAME><![CDATA["+iMap.get("REQ_USER_NAME")+"]]></REQ_USER_NAME>\n");
			tmpXml.append("<REQ_USER_DEPT_NAME><![CDATA["+iMap.get("REQ_USER_DEPT_NAME")+"]]></REQ_USER_DEPT_NAME>\n");
			tmpXml.append("<ATOB_REMARK><![CDATA["+iMap.get("ATOB_REMARK")+"]]></ATOB_REMARK>\n");
			tmpXml.append("</ITEM>\n");
		}
		tmpXml.append("</LIST>\n");
		tmpXml.append("</CONTENT>\n");
		tmpXml.append("</BODY>\n");
		tmpXml.append("</DBAPPROVAL>\n");

        xmlStr	= tmpXml.toString();
        System.out.println("xmlStr : \n" + xmlStr);
		
		return xmlStr;
	}

	// 단가합의 비고 란 저장
	public Map<String, String> saveBuyerMpRqUnitpriceAgrmntNegoReqPop(Map<String, String> formData) {
		
		
		String _rtnMsg = "저장 되었습니다.";
		Map<String, String> pMap = new HashMap<String, String>();
		try {
			sqlSessionTemplate.update("buyer.mprq.saveBuyerMpRqUnitpriceAgrmntNegoReqPop", formData);
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("단가합의 비고 란 저장 중 오류가 발생했습니다.");
		}
		
		pMap.put("MSG", _rtnMsg);
		
		return pMap;
	}
}
