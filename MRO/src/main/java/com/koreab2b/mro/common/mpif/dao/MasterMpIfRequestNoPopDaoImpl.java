package com.koreab2b.mro.common.mpif.dao;

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

import com.koreab2b.mro.master.mpso.dao.MasterMpSoStockMovemntRequestRegDaoImpl;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpIfRequestNoPopDao")
@Transactional
public class MasterMpIfRequestNoPopDaoImpl implements MasterMpIfRequestNoPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoStockMovemntRequestRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpif.selectMasterMpIfRequestNoPopList", formData);
	}
	
	// 조회(상세)
	public List<Map<String,String>> selectDetailList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpif.selectMasterMpIfRequestNoDetailPopList", formData);
	}
	
	// 임시저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {

		_rtnMsg = "임시저장이 완료 되었습니다.";
		try {
			
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("st_recv_flag", "AT");
				sqlSessionTemplate.update("common.mpif.updateMasterMpIfRequestNoPop", formData);
			}
			
		} catch (Exception e) {
				logger.error("SQL ERROR : ", e);
				throw new RuntimeException("임시저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}	
	
	// 단가임시저장
	@SuppressWarnings("unchecked")
	public Map<String,String> InsertSelectedPriceData(Map<String,String>  formData, List<Object> gridData) {

		_rtnMsg = "단가변경은 내부품의가 필요합니다.";
		int index = 0;
		String _pm_no = null;
		int _pm_seq = 1;
		Map<String, String> pMap = new HashMap<String, String>();
		
		
		try {
			
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));
				++index;
				if (index == 1){
					pMap.put("COM_CODE", "KRKORE0001");
					pMap.put("DOC_TYPE", "PM");

					_pm_no =  masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PM"); 
					formData.put("PM_NO", _pm_no);					

					sqlSessionTemplate.update("common.mpif.InsertPriceDataKEPMGPHD", formData);
				}
				formData.put("PM_NO", _pm_no);
				formData.put("PM_SEQ", String.valueOf(_pm_seq));
				sqlSessionTemplate.update("common.mpif.InsertPriceDataKEPMGPDT", formData);
				_pm_seq++;				
			}
			
		} catch (Exception e) {
				logger.error("SQL ERROR : ", e);
				throw new RuntimeException("임시저장에 실패하였습니다.");
		}
		pMap.put("MSG", _rtnMsg);
		pMap.put("PM_NO", _pm_no);
		return pMap;	
	}
	
	// 구매발주
	@SuppressWarnings("unchecked")
	public String updateSelectedDataPo(Map<String,String>  formData, List<Object> gridData) {

		Map<String, String> lastLoginList = null;
		
		_rtnMsg = "구매발주가 완료 되었습니다.";
		try {
			
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("st_recv_flag", "IF");
				sqlSessionTemplate.update("common.mpif.updateMasterMpIfRequestNoPop", formData);
				
				lastLoginList = sqlSessionTemplate.selectOne("master.mpso.selectLastLoginIdWithPrInfo", formData);
	            
	        	// 주문요청자, 발주자 마지막 로그인정보 UPDATE
				formData.put("LAST_LOGIN_ID", CommonUtil.nvl(lastLoginList.get("REQ_USER_ID"), ""));
				formData.put("LAST_LOGIN_ID1",CommonUtil.nvl(lastLoginList.get("PURCHASER_ID"), ""));
				
				// 주문요청자 마지막 로그인 정보 UPDATE
		        sqlSessionTemplate.insert("login.saveLogintime", formData);
		        // 발주자 마지막 로그인 정보 UPDATE
		        sqlSessionTemplate.insert("login.saveLogintime1", formData);
			}
			
			String buyer = formData.get("BUYER");
		    String poNo="";
		    String poSeq="";
		    String TmpBuyer="";
		    String TmpLocation="";
		    String TmpUser="";
		    String TmpAgent="";
		    String TmpLegacyPoNo="";
		    String TmpRemark="";
		    String TmpDocType="";
		    String TmpReqUserInfo="";
		    String TmpProcessType ="";
		    String TmpRefPrNo ="";
		    String TmpHdRemark ="";
		    int cnt=0;
		    int totNo=0;
		    
			if( buyer.equals("KRKOLO0001") || buyer.equals("KRKOLO0002") ||buyer.equals("KRKOLO0003")){
				//운영자 > I/F 임시저장목록 > 발주 > 코오롱(발주 생성조건에 REF_PR_NO(관리번호) 추가 )
				List<Map<String,String>> list = sqlSessionTemplate.selectList("common.mpif.selectNewBuyerCreatePOKolon", formData);
			    
				for(int i=0; i<list.size(); i++){
					Map<String,String> mp = (Map<String,String>)list.get(i);
//					logger.error("중복체크1 : ", TmpBuyer+TmpLocation+TmpUser+TmpAgent+TmpDocType+TmpLegacyPoNo+TmpProcessType+TmpRefPrNo+TmpReqUserInfo);

					if( !(TmpBuyer.equals(mp.get("BUYER")))           ||           // PO 생성 조건
			                !(TmpLocation.equals(mp.get("DELY_TO_LOCATION")))       ||
			                !(TmpUser.equals(mp.get("REF_ADD_USER_ID")))           ||
			                !(TmpAgent.equals(mp.get("AGENT")))          ||
			                !(TmpDocType.equals(mp.get("DOC_TYPE")))        ||
			                !(TmpLegacyPoNo.equals(mp.get("LEGACY_PO_NO")))     ||
			                !(TmpProcessType.equals(mp.get("PROCESS_TYPE")))    ||
//			                !(TmpRefPrNo.equals(mp.get("REF_PR_NO")))    ||
			                !(TmpReqUserInfo.equals(mp.get("REQ_USER_INFO")))
			            ){
						
						if(cnt>0) { // PO가 여러 건으로 생성될때 마직막 POHD 앞까지 아래코드 사용
							mp.put("TmpAgent", TmpAgent);
							mp.put("TmpReqUserInfo", TmpReqUserInfo);
							mp.put("TmpDocType", TmpDocType);
							mp.put("TmpBuyer", TmpBuyer);
							mp.put("PoNo", poNo);							
							sqlSessionTemplate.update("common.mpif.insertNewBuyerCreatePO_POHD", mp);							
							//메일전송
							Map<String, String> _pMap = new HashMap<String, String>();
							_pMap.put("BUYER", TmpBuyer);
							_pMap.put("PO_NO", poNo);
							_pMap.put("CODE", "PO_NEW");
							_pMap.put("USER_ID", mp.get("USER_ID"));
							sqlSessionTemplate.update("buyer.mpso.call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO", _pMap);
						}

						List<Map<String,String>> sublist = sqlSessionTemplate.selectList("common.mpif.selectNewBuyerCreatePOKolonSub", mp);

						for(int j=0; j<sublist.size();j++){
							Map<String,String> submp =(Map<String,String>) sublist.get(j);
							
							poNo = submp.get("PO_NO");
							totNo = Integer.valueOf(submp.get("TOTNO"));
						}
						
						  if(totNo == 0){
							  String docType = "PO";
							  int ordernoCnt=0;	  
							  mp.put("st_company", formData.get("BUYER"));
							  mp.put("st_doc_type", docType);
							  List<Map<String,String>> sublist2 = sqlSessionTemplate.selectList("common.mpif.getOrderPO", mp);
							  
							  for(int k=0; k<sublist2.size(); k++){
								  Map<String,String> submp2 =(Map<String,String>) sublist2.get(k);
								  poNo = submp2.get("ORDERNO");
								  ordernoCnt++;
							  }
							  
							  if (ordernoCnt !=1) {
								  sqlSessionTemplate.update("common.mpif.insertICOMSQMTALL", mp);
								  poNo = "" + Calendar.getInstance().get(Calendar.YEAR);
								  poNo = docType + poNo.substring(2,4) +   "000001";
						      } else {
								  sqlSessionTemplate.update("common.mpif.insertICOMSQMTOne", mp);
						      }
	
							  _rtnMsg += "["+poNo+"]";
			                }else{
			                	_rtnMsg = "관리자에게 문의바랍니다(POHD DUP)" ;
			                }
							  
			                TmpBuyer        = mp.get("BUYER");
			                TmpLocation     = mp.get("DELY_TO_LOCATION");
			                TmpUser         = mp.get("REF_ADD_USER_ID");
			                TmpAgent        = mp.get("AGENT");
			                TmpRemark       = mp.get("REMARK");
			                TmpDocType      = mp.get("DOC_TYPE");
			                TmpLegacyPoNo   = mp.get("LEGACY_PO_NO");
			                TmpProcessType  = mp.get("PROCESS_TYPE");
			                TmpRefPrNo      = mp.get("TEMP_REF_PR_NO");
			                TmpReqUserInfo  = mp.get("REQ_USER_INFO");			                
			                cnt = 0;
						}
					
					cnt++;
		            mp.put("st_cnt", String.valueOf(cnt));
					mp.put("st_buyer_code", formData.get("st_buyer_code"));
					mp.put("st_pr_no", formData.get("st_pr_no"));
		            mp.put("st_po_no", poNo);
		            mp.put("st_pr_seq", mp.get("PR_SEQ"));
		         // PODT Insert
		            sqlSessionTemplate.update("common.mpif.insertNewBuyerCreatePOKolon_PODT", mp);
		            
		            // PRDT에 IF => GA 변경
		            sqlSessionTemplate.update("common.mpif.updateNewBuyerCreatePO_PRDT", mp);
		         // PRHD에 AT => PC 변경
		            sqlSessionTemplate.update("common.mpif.updateNewBuyerCreatePO_PRHD", mp);

				}
				
            }else{
				List<Map<String,String>> list = sqlSessionTemplate.selectList("common.mpif.selectNewBuyerCreatePO", formData);
				for(int i=0; i<list.size(); i++){
					Map<String,String> mp = (Map<String,String>)list.get(i);
//					logger.error("중복체크2 : ", TmpBuyer+TmpLocation+TmpUser+TmpAgent+TmpDocType+TmpLegacyPoNo+TmpProcessType+TmpRefPrNo+TmpReqUserInfo);

					// PO 생성 조건
					if( !(TmpBuyer.equals(mp.get("BUYER")))           ||           // PO 생성 조건
			                !(TmpLocation.equals(mp.get("DELY_TO_LOCATION")))       ||
			                !(TmpUser.equals(mp.get("REF_ADD_USER_ID")))           ||
			                !(TmpAgent.equals(mp.get("AGENT")))          ||
			                !(TmpDocType.equals(mp.get("DOC_TYPE")))        ||
			                !(TmpLegacyPoNo.equals(mp.get("LEGACY_PO_NO")))     ||
			                !(TmpProcessType.equals(mp.get("PROCESS_TYPE")))    ||
			                !(TmpReqUserInfo.equals(mp.get("REQ_USER_INFO")))
			            ){
							if(cnt>0) { // PO가 여러 건으로 생성될때 마직막 POHD 앞까지 아래코드 사용
								mp.put("TmpAgent", TmpAgent);
								mp.put("TmpReqUserInfo", TmpReqUserInfo);
								mp.put("TmpDocType", TmpDocType);
								mp.put("TmpBuyer", TmpBuyer);
								mp.put("PoNo", poNo);
								mp.put("TmpHdRemark", TmpHdRemark);
								sqlSessionTemplate.update("common.mpif.insertNewBuyerCreatePO_POHD", mp);
								//메일전송
								Map<String, String> _pMap = new HashMap<String, String>();
								_pMap.put("BUYER", TmpBuyer);
								_pMap.put("PO_NO", poNo);
								_pMap.put("CODE", "PO_NEW");
								_pMap.put("USER_ID", mp.get("USER_ID"));
								sqlSessionTemplate.update("buyer.mpso.call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO", _pMap);
							}
							
							List<Map<String,String>> sublist = sqlSessionTemplate.selectList("common.mpif.selectNewBuyerCreatePOSub", mp);

							for(int j=0; j<sublist.size();j++){
								Map<String,String> submp =(Map<String,String>) sublist.get(j);
								
								poNo = submp.get("PO_NO");
								totNo = Integer.parseInt(submp.get("TOTNO"));
							}
							
							  if(totNo == 0){
								  String docType = "PO";
								  int ordernoCnt=0;	  
								  mp.put("st_company", formData.get("BUYER"));
								  mp.put("st_doc_type", docType);
								  List<Map<String,String>> sublist2 = sqlSessionTemplate.selectList("common.mpif.getOrderPO", mp);
								  
								  for(int k=0; k<sublist2.size(); k++){
									  Map<String,String> submp2 =(Map<String,String>) sublist2.get(k);
									  poNo = submp2.get("ORDERNO");
									  ordernoCnt++;
								  }
								  
								  if (ordernoCnt !=1) {
									  sqlSessionTemplate.update("common.mpif.insertICOMSQMTALL", mp);
									  poNo = "" + Calendar.getInstance().get(Calendar.YEAR);
									  poNo = docType + poNo.substring(2,4) +   "000001";
							      } else {
									  sqlSessionTemplate.update("common.mpif.insertICOMSQMTOne", mp);
							      }
		
								  _rtnMsg += poNo;
				                }else{
				                	_rtnMsg = "관리자에게 문의바랍니다(POHD DUP)" ;
				                }
								  
				                TmpBuyer        = mp.get("BUYER");
				                TmpLocation     = mp.get("DELY_TO_LOCATION");
				                TmpUser         = mp.get("REF_ADD_USER_ID");
				                TmpAgent        = mp.get("AGENT");
				                TmpRemark       = mp.get("REMARK");
				                TmpDocType      = mp.get("DOC_TYPE");
				                TmpLegacyPoNo   = mp.get("LEGACY_PO_NO");
				                TmpProcessType  = mp.get("PROCESS_TYPE");
				                TmpReqUserInfo  = mp.get("REQ_USER_INFO");
				                TmpHdRemark		= mp.get("HD_REMARK");
				                cnt = 0;
							
						}
					
					cnt++;
		            mp.put("st_cnt", String.valueOf(cnt));
					mp.put("st_buyer_code", formData.get("st_buyer_code"));
					mp.put("st_pr_no", formData.get("st_pr_no"));
		            mp.put("st_po_no", poNo);
		            mp.put("st_pr_seq", mp.get("PR_SEQ"));
		         // PODT Insert
		            sqlSessionTemplate.update("common.mpif.insertNewBuyerCreatePO_PODT", mp);

		            // PRDT에 IF => GA 변경
		            sqlSessionTemplate.update("common.mpif.updateNewBuyerCreatePO_PRDT", mp);
		         // PRHD에 AT => PC 변경
		            sqlSessionTemplate.update("common.mpif.updateNewBuyerCreatePO_PRHD", mp);
		            
				}
            }

            
	        // 마지막 ICOMPOHD 생성시 아래 코드 사용
	        if(cnt > 0) {
	        	formData.put("TmpAgent",TmpAgent);
	        	formData.put("TmpReqUserInfo",TmpReqUserInfo);
	        	formData.put("TmpDocType",TmpDocType);
	        	formData.put("TmpBuyer",TmpBuyer);
	        	formData.put("PoNo",poNo);
	        	formData.put("TmpHdRemark",TmpHdRemark);
	            sqlSessionTemplate.update("common.mpif.insertNewBuyerCreatePO_POHD", formData);
				//메일전송
				Map<String, String> _pMap = new HashMap<String, String>();
				_pMap.put("BUYER", TmpBuyer);
				_pMap.put("PO_NO", poNo);
				_pMap.put("CODE", "PO_NEW");
				_pMap.put("USER_ID","");
				sqlSessionTemplate.update("buyer.mpso.call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO", _pMap);
	        }else{
	        	_rtnMsg = "ERROR System Error!!!!";
	        }
			
		} catch (Exception e) {
				logger.error("SQL ERROR : ", e);
				throw new RuntimeException("구매발주에 실패하였습니다.");
		}
		return _rtnMsg;
	}	
}
