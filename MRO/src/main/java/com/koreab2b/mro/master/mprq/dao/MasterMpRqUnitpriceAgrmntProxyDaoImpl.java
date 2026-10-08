package com.koreab2b.mro.master.mprq.dao;

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
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpRqUnitpriceAgrmntProxyDao")
@Transactional
public class MasterMpRqUnitpriceAgrmntProxyDaoImpl implements MasterMpRqUnitpriceAgrmntProxyDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqUnitpriceAgrmntProxyDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(_list.size() > 0){
			param.put("st_buyerArr", _list);
		}
		
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("master.mprq.selectMasterMpRqUnitpriceAgrmntProxyList", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqUnitpriceAgrmntProxyList", param);
		}
		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 단가합의 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if (formData.get("PRODUCT_CLOSE_FLAG").equals("G") || (formData.get("PRODUCT_CLOSE_FLAG").equals("S") && formData.get("BUYER_ITEM_NO").indexOf("NO_CODE") > -1)){ 
						
					if (formData.get("REG_ITEM_NO") != formData.get("BUYER_ITEM_NO")) {
						String _itemDupChk  = sqlSessionTemplate.selectOne("master.mprq.getItemDupChk", formData); 
						if (!"0".equals(_itemDupChk)){
							_rtnMsg = "중복된 품목코드 입니다.";
							return _rtnMsg;
						}
					}
				}
				
				int qtdt_result = sqlSessionTemplate.update("master.mprq.updateAgrmntKEPQTDT", formData);
				if(qtdt_result <=0) {
					throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
				}
				//icomcqdt 업데이트	
				int cqdt_unit_result = sqlSessionTemplate.update("master.mprq.updateAgrmntICOMCQDT", formData);
				if(cqdt_unit_result < 0) {
					throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
				}
				//icomcqep 인서트
				int cqep_result = sqlSessionTemplate.insert("master.mprq.insertAgrmntICOMCQEP", formData);
				if(cqep_result < 0) {
					throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
				}
				//견적 멀티 선택 기등록건 업데이트 Start
				List<Map<String,String>> list = null;
				list = sqlSessionTemplate.selectList("master.mprq.selectAgremntRQDTList", formData);
				//기등록건 icomcqdt 대상 있으면 업데이트
			    if(list.size() > 0){
					for(int j=0; j<list.size(); j++){
						Map<String,String> mp = (Map<String,String>)list.get(j);
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
						        	Map<String,String> _dataParam = null;
									_dataParam = new HashMap<String,String>() ;
									_dataParam.put("G_BUYER", st_buyer);
									_dataParam.put("G_QUOTATION_NO", st_quotatgion_no);
									_dataParam.put("G_QUOTATION_SEQ", st_quotation_seq);
									_dataParam.put("G_REVISION", st_revision);
									_dataParam.put("G_CONTRACT_NO",str[0]);
									_dataParam.put("G_CONTRACT_SEQ",str[1]);
									_dataParam.put("G_USR_ID",formData.get("USR_ID"));
									_dataParam.putAll((Map<String, String>)gridData.get(i));
									//기등록건 계약 업데이트
									sqlSessionTemplate.update("master.mprq.updateAgrmntRqdtICOMCQDT", _dataParam);
									//기등록건 이력 인서트
									sqlSessionTemplate.update("master.mprq.insertAgrmntRqdtICOMCQEP", _dataParam);				        	
						        }
							 }
						 }				
					}
			    }
			    //견적 멀티 선택 기등록건 업데이트 End
			    
				int byit_result = sqlSessionTemplate.update("master.mprq.updateAgrmntICOMBYIT", formData);
				if(byit_result < 0) {
					throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
				}
				
				if (formData.get("PRODUCT_CLOSE_FLAG").equals("G")) {
					int rqdt2_result = sqlSessionTemplate.update("master.mprq.updateAgrmntKEPRQDT", formData);
					if(rqdt2_result!=1) {
						throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
					}
				} else {
					int rqdt_result = sqlSessionTemplate.update("master.mprq.updateAgrmntKEPRQDT2", formData);
					if(rqdt_result!=1 || formData.get("USR_ID").equals("")) {
						throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
					}
				}
				int buyer_item_no_update_result = sqlSessionTemplate.update("master.mprq.updateAgrmntKEPRQDT3", formData);
				if(buyer_item_no_update_result<=0 || formData.get("USR_ID").equals("")) {
					throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
				}
				//선입고 장바구니 특수로직 체크
				String BUYER = formData.get("BUYER");
				boolean sCartYn = CommonUtil.getSpecialCheckReturn( BUYER,"P04-4031-01");
				//선입고 특수로직있고 견적건에 선입고 체크 되어 있으면 선입고 장바구니 입력
				LOGGER.debug("선입고 견적여부==>" + formData.get("PRE_GR_FLAG")+"/"+sCartYn);
				if (sCartYn == true && formData.get("PRE_GR_FLAG").equals("Y")){
					LOGGER.debug("선입고 장바구니 등록");
					int cart_result = sqlSessionTemplate.update("master.mprq.insertMpRqUnitPricePreCart", formData);
					if(cart_result < 0) {
						throw new RuntimeException("선입고 장바구니 등록정보가 없습니다.\n\n관리자에게 문의 바랍니다.");
					}					
				}
				//물질정보 여부 체크.(표준카테고리 기준)
				String _cmcChk  = sqlSessionTemplate.selectOne("master.mprq.getItemCMCChk", formData); 
				if (!"0".equals(_cmcChk)){//물질정보 등록 대상일 경우 품목코드 업데이트
					//물질정보 요청 품목코드 변경
					sqlSessionTemplate.update("master.mprq.updatetMpRqKepCmcReq", formData);
					//물질정보 품목코드 변경
					sqlSessionTemplate.update("master.mprq.updatetMpRqKepCmcByit", formData);
					//물질정보 품목코드 변경 2
					sqlSessionTemplate.update("master.mprq.updatetMpRqKepCmcByitMake", formData);
				}
				
				 // I/F 품목 단가합의시 단가합의 로직과 같게 실행  후 ICOMBYIT 테이블내 해당 품목코드 PRODUCT_CLOSE_FLAG를 T(I/F품목)으로 변경
			    if (formData.get("st_if_change").equals("Y")) {
			    	int byit_if_result = sqlSessionTemplate.update("master.mprq.updateAgrmntICOMBYIT_IF", formData);
			    	if(byit_if_result < 0) {
			    		throw new RuntimeException("I/F 단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
			    	}
			    }
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
		return _rtnMsg;
	}

}
