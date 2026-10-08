package com.koreab2b.mro.common.mprq.dao;

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

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqCmpySelQuotationSendDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpRqBuyerQuotationSendPopDao")
@Transactional
public class MasterMpRqBuyerQuotationSendPopDaoImpl implements MasterMpRqBuyerQuotationSendPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqCmpySelQuotationSendDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	private String _rtnMsg = "";

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) formData.get("st_quotation_list"),"@");
		if(_list.size() > 0){
			formData.put("st_quotationArr", _list);
		}
		
		return sqlSessionTemplate.selectList("common.mprq.selectMasterMpRqBuyerQuotationSendPopList", formData);
	}
	
	// 견적제출
	@SuppressWarnings("unchecked")
	public Map<String,String> saveBuyerQuotationSend(Map<String,String>  formData, List<Object> gridData){
		
		_rtnMsg = "정상적으로 처리되었습니다.";
		int _passflag = 0;
		String _pm_no = "N";
		int _pm_seq = 1;
		Map<String, String>  pMap = new HashMap<String, String>();
		List<Map<String,String>> _belowFlag = null;
		Map<String,String> _belowComorgFlag = null;
		Map<String,String> _prefix = null;
		String _nextSeq = null;
		Map<String,String> _contractInfo = null;
		Map<String,Integer> _buyerMap = new HashMap<String, Integer>();
	//	String gplChk ="Y";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//GPL 품목 여부 확인									
				//gplChk = (String) sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqGplChk", formData);	
				//if(gplChk.equals("Y")) {
					_prefix = sqlSessionTemplate.selectOne("common.mprq.selectCDNO", formData);
					
					if(_prefix != null) {
						if(_prefix.get("G_PREFIX").equals("!")) {
							throw new RuntimeException("NO_PREFIX");
						}
					
					// 현재 채번 규칙 조회할 고객사 코드
					String st_buyer =  formData.get("BUYER");
					// 고객사 코드 몇 번째 검색하는지 idx
					int _idx = _buyerMap.getOrDefault(st_buyer, 0)+1;
					_buyerMap.put(st_buyer, _idx);
					
					_prefix.put("IDX", Integer.toString(_idx));
					_nextSeq = sqlSessionTemplate.selectOne("common.mprq.selectCDNONextSeq", _prefix);
					
					LOGGER.debug(i+"th _nextSeq:::::::::::::::::::::::  "+ _nextSeq);
					if(_nextSeq.length() > _prefix.get("G_LENGTH").length()) {
							throw new RuntimeException("NO_NEXTSEQ");
						}
					}
					
					// 견적 진행중인 품목코드
					String st_buyer_item_no = formData.get("BUYER_ITEM_NO");
					
					// 기등록이라 계약번호 선택 시
					if(!formData.get("CONTRACT_NO").equals("") && !formData.get("CONTRACT_SEQ").equals("")) {
						_contractInfo = sqlSessionTemplate.selectOne("common.mprq.selectBuyerItemNoByContract", formData);
						
						// 계약 vs 견적 품목코드 비교
						if(!_contractInfo.get("BUYER_ITEM_NO").equals(st_buyer_item_no) || _contractInfo.get("BUYER_ITEM_NO").equals("NULL_ITEM_NO")) {
							throw new RuntimeException("NO_CONTRACT");
						}
						
						// 다중 계약선택으로 연결정보 있는 경우 나눠서 건별로 위와 같이 체크
						if(!formData.get("CONTRACT_INFO").equals("")) {
							String _contract_info[] = formData.get("CONTRACT_INFO").split("&&");
							if (_contract_info.length >0){
								for( int k=0 ; k < _contract_info.length; k++){
							        String str[] =  _contract_info[k].split("@@",-1);
							        LOGGER.debug(" str.length:::::::::::::::::::::::  "+ str.length);
							        if (str != null && str.length == 2){
							        	Map<String,String> _dataParam = null;
										_dataParam = new HashMap<String,String>() ;
										_dataParam.put("BUYER", formData.get("BUYER"));
										_dataParam.put("CONTRACT_NO",str[0]);
										_dataParam.put("CONTRACT_SEQ",str[1]);
										
										_contractInfo = sqlSessionTemplate.selectOne("common.mprq.selectBuyerItemNoByContract", _dataParam);
										
										if(!_contractInfo.get("BUYER_ITEM_NO").equals(st_buyer_item_no) || _contractInfo.get("BUYER_ITEM_NO").equals("NULL_ITEM_NO")) {
											throw new RuntimeException("NO_CONTRACT");
										}
									}
								}
							}
						}
					}
					
					if (formData.get("PM_FLAG").equals("Y")){
						_rtnMsg = "정상적으로 견적 제출되었으며 일부품목은 품의상신 하여야 합니다.";
						if (_passflag < 1){
	
							// KEPMGPHD, KEPMGPDT - 임시 상신 데이터 삭제
							sqlSessionTemplate.update("common.mprq.deleteKEPMGPHD", formData);
							//sqlSessionTemplate.update("common.mprq.deleteKEPMGPDT", formData);
							
							_pm_no = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PM");
							
							_passflag++;
							formData.put("PM_NO", _pm_no);
							sqlSessionTemplate.update("master.mprq.insertNegoKEPMGPHD", formData);
						}
						//위치변경 현명환.
						sqlSessionTemplate.update("common.mprq.deleteKEPMGPDT", formData);
						formData.put("PM_NO", _pm_no);
						formData.put("PM_SEQ", String.valueOf(_pm_seq));
						sqlSessionTemplate.update("common.mprq.insertNegoKEPMGPDT2", formData);
						_pm_seq++;
						
					}else{
						if(!formData.get("BTOA_NEGO_PRICE").equals("0")){
							
							sqlSessionTemplate.update("common.mprq.insertNegoHistoryRqdt", formData);
						}					
					}
					// 사용자 요구사항 중 중복체크 기능 빼달라는 요구조건 - 미확정 사항으로 주석 처리
	//				if (formData.get("BUYER_ITEM_NO_STATUS").equals("신규")){
	//					Map<String,String> _result = sqlSessionTemplate.selectOne("common.mprq.selectBuyerItemDoubleCheck", formData);
	//					if (String.valueOf(_result.get("DBL_CHK")).equals("T")){
	//						_rtnMsg = "고객사 견적제출을 하던중 중복코드를 발견하였습니다.\n\n중복코드는 "+formData.get("BUYER_ITEM_NO")+" 입니다.";
	//						throw new RuntimeException(_rtnMsg);
	//					}
	//				}
					// STEP1
					sqlSessionTemplate.update("common.mprq.saveAtosDateQtdt", formData);
					// STEP2
					sqlSessionTemplate.update("common.mprq.saveQuotaionRqdt", formData);
					
					// ICOMBYIT_ADD - 임시 생성 데이터 삭제 (결재 시 생성된 데이터 있을 수 있음) - S, K (신규, 기등록만)
					sqlSessionTemplate.update("common.mprq.deleteICOMBYIT_ADD", formData);
					
					if (formData.get("INIT_BELOW_COMORG_CODE").equals("ALL")){
					
						_belowFlag =  sqlSessionTemplate.selectList("common.mprq.selectComorgcode", formData);
						if(_belowFlag.size() == 0) {
							throw new RuntimeException("그룹카탈로그 정합성 오류(BYCAORGL)");
						}
						
						for(int inx= 0; inx < _belowFlag.size() ; inx++){
							_belowComorgFlag = _belowFlag.get(inx);
							formData.put("P_BUYER", _belowComorgFlag.get("COMORG_CODE"));
							
							// STEP3
							sqlSessionTemplate.update("common.mprq.saveIcombyitAdd", formData);
						}
					} else {
						formData.put("P_BUYER", formData.get("BUYER"));
						// STEP3
						sqlSessionTemplate.update("common.mprq.saveIcombyitAdd", formData);
					}
	//				 if(pFlag=="DOUBLE") {
	//
	//				        alert("고객사 견적제출을 하던중 중복코드를 발견하였습니다.\n\n중복코드는 "+msg_content+" 입니다.");
				
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if(e.getMessage().equals("NO_PREFIX")) {
				throw new RuntimeException("채번 룰을 확인하시기 바랍니다.(등록불가)");
			}
			else if(e.getMessage().equals("NO_NEXTSEQ")) {
				throw new RuntimeException("자동채번 항번이 초과하였습니다.\n사업팀에게 확인하시기 바랍니다.(등록불가)");
			}
			else if(e.getMessage().equals("NO_CONTRACT")) {
				throw new RuntimeException("선택한 계약서와 견적의 품목코드가 불일치합니다.\n품목코드를 눌러 계약정보를 다시 선택바랍니다.(제출불가)");
			}			
			else {
				throw new RuntimeException("등록이 실패하였습니다. 다시 확인하여 주십시요.");
			}
		}
		pMap.put("MSG", _rtnMsg);
		pMap.put("PM_NO", _pm_no);
		
		return pMap;
		
	}

	// 환율정보변경
	@SuppressWarnings("unchecked")
	public Map<String,String> saveExpBuyerQuotationSend(Map<String,String>  formData, List<Object> gridData){
		
		_rtnMsg = "외화단가 매핑 처리되었습니다.";
		Map<String, String>  pMap = new HashMap<String, String>();
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("common.mprq.saveExpQuotaionRqdt", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("외화단가 매핑 실패하였습니다. 다시 확인하여 주십시요.");
		}
		pMap.put("MSG", _rtnMsg);
		return pMap;
		
	}
}
