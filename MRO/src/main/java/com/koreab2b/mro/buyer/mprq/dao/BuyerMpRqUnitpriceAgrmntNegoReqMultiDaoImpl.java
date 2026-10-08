package com.koreab2b.mro.buyer.mprq.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerMpRqUnitpriceAgrmntNegoReqMultiDao")
@Transactional
public class BuyerMpRqUnitpriceAgrmntNegoReqMultiDaoImpl implements BuyerMpRqUnitpriceAgrmntNegoReqMultiDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqUnitpriceAgrmntNegoReqMultiDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;

	// 조회
	public List<Map<String,String>> selectListMulti(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mprq.selectBuyerMpRqUnitpriceAgrmntNegoReqMultiList", formData);
	}
	public List<Map<String,String>> getBuyerMpRqUnitpriceAgrmntNegoReqMultiList_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.mprq.getBuyerMpRqUnitpriceAgrmntNegoReqMultiList_v2", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedDataMulti(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상적으로 Nego요청 접수 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				int rqdtChkFlag = sqlSessionTemplate.update("buyer.mprq.updateNegoBuyerRqdtMulti", formData);
				if (rqdtChkFlag != 1){
					_rtnMsg = "네고요청 RQDT 처리중 오류가 발생했습니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				int qtdtChkFlag = sqlSessionTemplate.update("buyer.mprq.updateNegoBuyerQtdtMulti", formData);
				if (qtdtChkFlag <= 0){
					_rtnMsg = "네고요청 QTDT 처리중 오류가 발생했습니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("Nego요청을 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
	return _rtnMsg;
		
	}
	// 단가합의 - 저장
	@SuppressWarnings("unchecked")
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmntMulti(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "정상적으로 단가합의 되었습니다.";
		String _gw_no = "N";
		String _checkpass = null;
		String _passflag = "N";
		Map<String, String> pMap = new HashMap<String, String>();
		Map<String, String> cMap = new HashMap<String, String>();
		
		try{
			formData.put("DOC_TYPE", "NS");
			_checkpass = sqlSessionTemplate.selectOne("buyer.mprq.getPassCheckMulti",formData);
			_passflag = sqlSessionTemplate.selectOne("buyer.mprq.getPassFlagMulti",formData);
			
			if (_checkpass.equals("0") || _checkpass.equals(null)){ // 결재 처리를 하지 않는 경우
				formData.put("RECV_FLAG", "CM");
			} else {
				formData.put("RECV_FLAG", "GA");
				_gw_no = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer2"), "NS");
			}
			formData.put("GW_NO", _gw_no);
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));	
				
				if (formData.get("st_nocode_yn").equals("Y")) {
					
					cMap.put("BUYER", formData.get("st_buyer2"));
					cMap.put("REG_ITEM_NO", formData.get("st_buyer_item_no3"));
					// 실코드 != 품목코드
					if (!formData.get("st_buyer_item_no3").equals(formData.get("st_buyer_item_no2"))) {
						String _itemDupChk  = sqlSessionTemplate.selectOne("master.mprq.getItemDupChk", cMap); 
						if (!"0".equals(_itemDupChk)){
							_rtnMsg = "중복된 품목코드 입니다.";
							pMap.put("MSG", _rtnMsg);
							pMap.put("GW_NO", "N");
							pMap.put("passflag", _passflag);
							return pMap;
						}
					}
				}
				
				sqlSessionTemplate.update("buyer.mprq.updateBuyerItemNoMulti", formData);
				
				if(formData.get("st_user_id") == "SNT76721"){         
					_passflag = "N";    
			    }
				
				if (formData.get("GW_NO").equals("N")){ // 결재 처리를 하지 않는 경우
					sqlSessionTemplate.update("buyer.mprq.updateNpassCqdtUnitMulti", formData);
					sqlSessionTemplate.update("buyer.mprq.updateNpassCqdtMulti", formData);
					sqlSessionTemplate.update("buyer.mprq.updateNpassByitMulti", formData);
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
					sqlSessionTemplate.update("buyer.mprq.updateNpassRqdtMulti", formData);

				} else { // 결재 처리 하는 경우
					if (_passflag.equals("N")){
						_rtnMsg = "전자 결재 처리 하시겠습니까? \n\n직접 합의 하시려면 취소버튼을 눌러 주십시오.";
					}
					sqlSessionTemplate.update("buyer.mprq.updatePassRqdtMulti", formData); 
					
				}
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
		
		pMap.put("MSG", _rtnMsg);
		pMap.put("GW_NO", _gw_no);
		pMap.put("passflag", _passflag);
		
		return pMap;
	}
	// 견적종료
	@SuppressWarnings("unchecked")
	public Map<String,String> saveBuyerMpRqCloseRemarkMulti(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "견적종료 처리 완료되었습니다.";

		Map<String, String> pMap = new HashMap<String, String>();
		
		try{
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));	
				sqlSessionTemplate.update("buyer.mprq.updateCloseRqdtMulti", formData); //rqdt 견적종료
				sqlSessionTemplate.update("buyer.mprq.updateCloseByitMulti", formData);  //byit 견적종료
				sqlSessionTemplate.update("buyer.mprq.InsertMailCloseRqdtMulti", formData); //Mail Send
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적종료 처리 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
		
		pMap.put("MSG", _rtnMsg);
		
		return pMap;
	}
	// 단가합의 - 저장
	@SuppressWarnings("unchecked")
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmntNonPassMulti(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "정상적으로 단가합의 되었습니다.";
		Map<String, String> pMap = new HashMap<String, String>();
		Map<String, String> cMap = new HashMap<String, String>();
		try{
				
			formData.put("RECV_FLAG", "CM");
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
					if (formData.get("st_nocode_yn").equals("Y")) {
					
					cMap.put("BUYER", formData.get("st_buyer2"));
					cMap.put("REG_ITEM_NO", formData.get("st_buyer_item_no3"));
					// 실코드 != 품목코드
					if (!formData.get("st_buyer_item_no3").equals(formData.get("st_buyer_item_no2"))) {
						String _itemDupChk  = sqlSessionTemplate.selectOne("master.mprq.getItemDupChkMulti", cMap); 
						if (!"0".equals(_itemDupChk)){
							_rtnMsg = "중복된 품목코드 입니다.";
							pMap.put("MSG", _rtnMsg);
							return pMap;
						}
					}
				}		
				
				sqlSessionTemplate.update("buyer.mprq.updateBuyerItemNoMulti", formData);
				
				sqlSessionTemplate.update("buyer.mprq.updateNpassCqdtUnitMulti", formData);
				sqlSessionTemplate.update("buyer.mprq.updateNpassCqdtMulti", formData);
				sqlSessionTemplate.update("buyer.mprq.updateNpassByitMulti", formData);
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
				sqlSessionTemplate.update("buyer.mprq.updateNpassRqdtMulti", formData);
			}	
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
		
		pMap.put("MSG", _rtnMsg);
		
		return pMap;
	}
	
	
	// 단가합의 결재 요청 후 처리(NS)
	public String nsRequestMulti(Map<String,String> formData){
		formData.put("RECV_FLAG", "GS");
		// STEP1
		sqlSessionTemplate.update("buyer.mprq.updateNsCancelKEPRQDTMulti", formData);
		
		return "OK";
	}
	
	// 단가합의 결재 상신취소 후 처리(NS)
	public String nsCancelMulti(Map<String,String> formData){
		// STEP1
		formData.put("RECV_FLAG", "GA");
		sqlSessionTemplate.update("buyer.mprq.updateNsCancelKEPRQDTMulti", formData);
        
		return "OK";
	}
	
	// 단가합의 결재 승인 후 처리(NS)
	public String nsApprovalMulti(Map<String,String> formData){
		
		formData.put("RECV_FLAG", "CM");
		
		// STEP1 - KEPRQDT
		sqlSessionTemplate.update("buyer.mprq.updateNsApproval1Multi", formData);

		// 신규, 실코드 입력 update 확인
		Map<String, String> _map = sqlSessionTemplate.selectOne("buyer.mprq.getItemRqdtMulti",formData);
		if (_map == null || _map.size() == 0){
		} else {
			sqlSessionTemplate.update("buyer.mprq.updateNsApproval_BYITMulti", _map);
			sqlSessionTemplate.update("buyer.mprq.updateNsApproval_CQDTMulti", _map);
		}
		// STEP3 - ICOMCQDT
		sqlSessionTemplate.update("buyer.mprq.updateNsApproval3Multi", formData);
//				// STEP4 - ICOMCQEP
//				sqlSessionTemplate.update("buyer.mprq.updateNsApproval4", formData);
		// STEP5 - ICOMCQEP
		sqlSessionTemplate.update("buyer.mprq.updateNsApproval5Multi", formData);
		// STEP2 - ICOMBYIT
		sqlSessionTemplate.update("buyer.mprq.updateNsApproval2Multi", formData); 
		return "OK";
	}
	
	// 단가합의 결재 반려 후 처리(NS)
	public String nsRejectMulti(Map<String,String> formData){
		
		formData.put("RECV_FLAG", "GR");
        
		// STEP1
        sqlSessionTemplate.update("buyer.mprq.updateNsRejectMulti", formData);
		
		return "OK";
	}
	public List<Map<String,String>> nsResultListMulti(Map<String,String> param) {
		return sqlSessionTemplate.selectList("buyer.mprq.selectNsResultListMulti", param);
	}
}
