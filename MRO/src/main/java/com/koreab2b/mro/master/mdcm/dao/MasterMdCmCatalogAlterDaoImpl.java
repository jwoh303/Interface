package com.koreab2b.mro.master.mdcm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMdCmCatalogAlterDao")
@Transactional
public class MasterMdCmCatalogAlterDaoImpl implements MasterMdCmCatalogAlterDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogAlterDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCatalogAlterList", param);
	}
	// Msds리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectMsdsList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mdcm.selectMasterMdCmBuyerMsDsPop", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
	// Msds상세리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectMsdsDetailList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mdcm.selectMasterMdCmBuyerMsDsDetailPop", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
	// Msds상세헤드리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectMsdsHeadDetailList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mdcm.selectMasterMdCmBuyerMsDsHeadDetailPop", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
	public List<Map<String,String>> selectMsdsHeadDetailList_v2(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmBuyerMsDsHeadDetailPop_v2", param);
	}
	public List<Map<String,String>> getMasterMsdsDetailList_v2(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmBuyerMsDsHeadCasDetailPop_v2", param);
	}
	
	
	// Msds상세등록리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectMsdsRegList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mdcm.selectMasterMdCmBuyerMsDsRegPop", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}	
	// Msds상세삭제
	public String delMasterMsdsDetailList(Map<String,String>  formData){
		  
		String _st_update = formData.get("st_query").toString();
		String _user_id = formData.get("userid").toString();
		String _buyer = formData.get("buyer").toString(); 
		Map<String,String> _data = null;
		
		try{
			 
			 String  _ICOMCART[] = _st_update.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				  
				 LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				 if (_ICOMCART.length >0){
					 for( int i=0 ; i < _ICOMCART.length; i++){ 
				        String str[] =  _ICOMCART[i].split("@@",-1);  
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
				        if (str != null){
				        	_data = new HashMap<String,String>() ;
					        _data.put("user_id", _user_id); 
					        _data.put("msds_no", str[0]);
					        _data.put("file_no", str[1]);   
					        _data.put("revision", str[2]);
					        _data.put("status", "D");
					        sqlSessionTemplate.delete("master.mdcm.deleteMasterMdCmMsdsDetail", _data);  
					        
						 }				         
					 }					  
				 }				  
			 } 
			  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return null;
		 
	}
	// Msds 매핑
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public int saveMasterMsdsMapping(Map<String, String> formData, List<Object> gridData) {
		
		try{
			for (int i = 0; i < gridData.size(); i++) {
					formData.putAll((Map<String, String>) gridData.get(i));
					
					// KEPRQDT 수정
					sqlSessionTemplate.insert("master.mdcm.saveMasterMsdsMapping", formData);
					
					// 등록되어 있는 견적완료건 ICOMBYIT 수정(KEPRQDT.RECV_FLAG : CC, CM, PC 상태만)
					sqlSessionTemplate.insert("master.mdcm.saveMasterMsdsByitMappingByQuot", formData);
			}	
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		
		return 0;
	}
	// Msds BYIT 매핑
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public int saveMasterMsdsByitMapping(Map<String, String> formData, List<Object> gridData) {
		
		try{
			for (int i = 0; i < gridData.size(); i++) {
					formData.putAll((Map<String, String>) gridData.get(i));
					sqlSessionTemplate.insert("master.mdcm.saveMasterMsdsByitMapping", formData);

			}	
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		
		return 0;
	}
	// Msds상세수정
	public String updateMasterMsdsDetailList(Map<String,String> formData){
		String _st_update = formData.get("st_query").toString();
		String _user_id = formData.get("userid").toString();
		Map<String,String> _data = null;
		
		try{
			String _ICOMCART[] = _st_update.split("\\|");
			
			if (_ICOMCART == null){
				LOGGER.debug("_ICOMCART 미존재 ");
			}else{
				LOGGER.debug(" _ICOMCART.length " + _ICOMCART.length );
				
				if (_ICOMCART.length >0){
					for( int i=0 ; i < _ICOMCART.length; i++){
						String str[] =  _ICOMCART[i].split("@@",-1);
						
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
						}
						
						if (str != null){
							_data = new HashMap<String,String>() ;
					        _data.put("user_id", _user_id);
					        _data.put("msds_no", str[0]);
					        _data.put("file_no", str[1]);
					        _data.put("revision", str[2]);
					        _data.put("image_key", str[3]);
					        _data.put("note", str[4]);
					        _data.put("description", str[5]);
					        _data.put("specification", str[6]);
					        _data.put("maker_name", str[7]);
					        _data.put("cas_no", str[8]);
					        _data.put("cas_no_min", str[9]);
					        _data.put("cas_no_max", str[10]);
					        _data.put("cas_no_acut", str[11]);
					        _data.put("cas_no_chro", str[12]);
					        _data.put("cas_no_ecol", str[13]);
					        _data.put("cas_no_harmful", str[14]);
					        _data.put("cas_no_prepare", str[15]);
					        _data.put("cas_no_limit", str[16]);
					        _data.put("last_revision_date", str[17]);
					        _data.put("use_cd", str[18]);
					        _data.put("info_cd", str[19]);
					        _data.put("use_note", str[20]);
					        _data.put("info_level", str[21]);
					        _data.put("cmc_harmful_yn", str[22]);
					        _data.put("submission_number", str[23]);
					        
					        _data.put("status", "O");
					        
					        String msds_file_change_yn = sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmMsdsDetailChange", _data);
					        
					        if(msds_file_change_yn.equals("Y")) { // DT 변경 있음. 이력 추가
					        	sqlSessionTemplate.delete("master.mdcm.deleteMasterMdCmMsdsDetail", _data);
						        sqlSessionTemplate.update("master.mdcm.updateMasterMdCmMsdsDetail", _data);
						        sqlSessionTemplate.update("master.mdcm.updateMasterMdCmMsdsLastRevisionDate", _data);
					        }else{ // 변경없음
					        	_data.put("status", "C");
					        	
					        	sqlSessionTemplate.delete("master.mdcm.deleteMasterMdCmMsdsDetail", _data);
						        sqlSessionTemplate.update("master.mdcm.updateMasterMdCmMsdsLastRevisionDate", _data);
					        }
					        
					        // MSDS 매핑된 카탈로그(BYIT) 유해화학물질 모두 수정
					        sqlSessionTemplate.update("master.mdcm.updateMasterMdCmMsdsHarmfulByit", _data);
					        
					        _data.put("DOC_NO", str[3]);
							sqlSessionTemplate.update("common.fileUploadFlagUpdate", _data);
						}
					}
				}
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		
		return null;
	}

	//Msds상세등록
	public String insertMasterMsdsDetailList(Map<String,String>  formData){
		String _st_update = formData.get("st_query").toString();
		String _user_id = formData.get("userid").toString();
		String _msNo = "";
		Map<String,String> _data = null;
		
		try{
			String  _ICOMCART[] = _st_update.split("\\|");
			if (_ICOMCART == null){
				LOGGER.debug("_ICOMCART 미존재 ");
			}else{
				LOGGER.debug(" _ICOMCART.length  " + _ICOMCART.length );
				_msNo = masterMpRqBuyerReqDao.nextVal("KRKORE0001", "MS");

				if (_ICOMCART.length >0){
					for( int i=0 ; i < _ICOMCART.length; i++){
						String str[] =  _ICOMCART[i].split("@@",-1);
						
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    }
						
				        if (str != null){
				        	_data = new HashMap<String,String>() ;				        	
					        _data.put("user_id", _user_id); 
					        _data.put("msds_no", _msNo);
					        _data.put("file_no", str[1]);   
					        _data.put("revision", str[2]);
					        _data.put("image_key", str[3]);
					        _data.put("note", str[4]);
					        _data.put("description", str[5]);
					        _data.put("specification", str[6]);
					        _data.put("maker_name", str[7]);
					        _data.put("cas_no", str[8]);
					        _data.put("cas_no_min", str[9]);
					        _data.put("cas_no_max", str[10]);					        
					        _data.put("cas_no_acut", str[11]);
					        _data.put("cas_no_chro", str[12]);
					        _data.put("cas_no_ecol", str[13]);					        
					        _data.put("cas_no_harmful", str[14]);
					        _data.put("cas_no_prepare", str[15]);
					        _data.put("cas_no_limit", str[16]);
					        _data.put("last_revision_date", str[17]);
					        _data.put("use_cd", str[18]);
					        _data.put("info_cd", str[19]);
					        _data.put("use_note", str[20]);
					        _data.put("info_level", str[21]);
					        _data.put("cmc_harmful_yn", str[22]);
					        _data.put("submission_number", str[23]);
					        
					        if(i == 0){
					        	sqlSessionTemplate.update("master.mdcm.insertMasterMdCmMsdsHd", _data);
					        }
					        sqlSessionTemplate.update("master.mdcm.updateMasterMdCmMsdsDetail", _data);
					        _data.put("DOC_NO", str[3]);
							sqlSessionTemplate.update("common.fileUploadFlagUpdate", _data);
						 }
					 }
				 }
			 }
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return null;
		 
	}
	
	public String getBycaComorgSelect(Map<String,Object> param) {
		return sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmBycaComorgSelect", param);
	}
	
	//엑셀 리스트 조회
	public List<Map<String,String>> selecExceltList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCatalogAlterExcelList", param);
	}
	
	
	
	/**
	 * 카탈로그 일괄수정 시작
	 */	
	public List<Map<String,String>> getMasterMdCmCatalogMultiAlter(Map<String,Object>  param) {
		return sqlSessionTemplate.selectList("master.mdcm.getSysopIcomtrxlCaList", param);
	}
	
	public List<Map<String,String>> getWarehouseCodeList(Map<String,Object>  param){
		return sqlSessionTemplate.selectList("master.mdcm.getWarehouseCodeList",param);
	}
	
	public List<Map<String,String>> getMasterMdCmCatalogSearchPop(Map<String,String>  param) {
		return sqlSessionTemplate.selectList("master.mdcm.getSysopBuyerCatalogOldList", param);
	}
	
	
	@SuppressWarnings("unchecked")
	public String batchMasterMdCmCatalogMultiAlter(Map<String, String> param,List<Object> gridData) {
		
		String _rtnMsg = "저장완료 되었습니다.";
		int checkFlag = 0;
		String st_buyer_code = "";
		String BUYER_ITEM_NO = "";
		String CONTRACT_NO = "";
		String CONTRACT_SEQ = "";
		String BUYER = "";
		String AFTER_LIST_PRICE = "";
		String AFTER_UNIT_PRICE = "";
		String AFTER_AGENT = "";
		String UNIT_PRICE_CHANGE_REASON = "";
		String LIST_PRICE_CHANGE_REASON = "";
		try{
			for(int i=0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("batchMasterMdCmCatalogMultiAlter param : {} ", param);
				
				st_buyer_code = CommonUtil.nvl(param.get("st_buyer_code"),"");
				BUYER_ITEM_NO = CommonUtil.nvl(param.get("BUYER_ITEM_NO"),"");
				CONTRACT_NO = CommonUtil.nvl(param.get("CONTRACT_NO"),"");
				CONTRACT_SEQ = CommonUtil.nvl(param.get("CONTRACT_SEQ"),"");
				AFTER_LIST_PRICE = CommonUtil.nvl(param.get("AFTER_LIST_PRICE"),"");
				AFTER_UNIT_PRICE = CommonUtil.nvl(param.get("AFTER_UNIT_PRICE"),""); 
				BUYER = CommonUtil.nvl(param.get("BUYER"),"");  
				AFTER_AGENT = CommonUtil.nvl(param.get("AFTER_AGENT"),"");
				UNIT_PRICE_CHANGE_REASON = CommonUtil.nvl(param.get("UNIT_PRICE_CHANGE_REASON"),"");
				LIST_PRICE_CHANGE_REASON = CommonUtil.nvl(param.get("LIST_PRICE_CHANGE_REASON"),"");
				
				if ("".equals(BUYER_ITEM_NO) 
					|| "".equals(CONTRACT_NO) 
					|| "".equals(CONTRACT_SEQ)  
					|| "".equals(BUYER)  
					){	
					checkFlag = 1;
					throw new RuntimeException();
				}
				//변경후 매출, 매입단가 없을 경우 공백 셋팅.
				 if ("".equals(AFTER_LIST_PRICE)) {
					 param.put("AFTER_LIST_PRICE", " ");
				}
				 if ("".equals(AFTER_UNIT_PRICE)) {
					 param.put("AFTER_UNIT_PRICE", " ");
				}
				LOGGER.debug("batchMasterMdCmCatalogMultiAlter checkFlag : {} ", checkFlag);
				LOGGER.debug("batchMasterMdCmCatalogMultiAlter AFTER_AGENT : {} ", AFTER_AGENT);
				
				param.put("DOC_NAME","KEPMGPDT");
				param.put("ST_USER_ID", param.get("st_user_id"));
				param.put("TRXL_GUBUN", param.get("trxl_gubun"));
				param.put("SEQ", String.valueOf(i)); 
				param.put("CH_PROCESS_TYPE",CommonUtil.nvl(param.get("CH_PROCESS_TYPE")," "));
				param.put("CH_WAREHOUSE_CODE",CommonUtil.nvl(param.get("CH_WAREHOUSE_CODE")," "));
				param.put("LIST_PRICE", "0");  
				param.put("UNIT_PRICE", "0");  
				param.put("STATUS_TEXT", "N");
				param.put("DELIVERY_LT", " ");
				param.put("UNIT_PRICE_CHANGE_REASON", UNIT_PRICE_CHANGE_REASON);
				param.put("LIST_PRICE_CHANGE_REASON", LIST_PRICE_CHANGE_REASON);
				
				
				// STEP1
				sqlSessionTemplate.update("master.mdcm.setSysopIcomTrxlUploadReg0Delete", param);
				sqlSessionTemplate.update("master.mdcm.setSysopIcomTrxlUploadReg1", param);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			String msg = "저장에 실패하였습니다.";
			if (checkFlag==1){
				msg = "빈 값 없이 정확한 정보로 엑셀 업로드하세요.";
			}else 	if (checkFlag==2){
				msg = "단가 입력 후 엑셀 업로드하세요.";
			}else 	if (checkFlag==3){
				msg = "조회한 고객사로 엑셀 업로드하세요.";
			}
				throw new RuntimeException(msg);
		}
		return _rtnMsg; 
	}
	
	public String popBatchMasterMdCmCatalogMultiAlter(Map<String, String> param) {
		String _rtnMsg = "저장완료 되었습니다.";
		
		String query		    = param.get("st_query");
		if (query != null) {
			String check_str[]		=    CommonUtil.StrToArray(query , "^||^");
			if (check_str != null){
					LOGGER.debug("popBatchMasterMdCmCatalogMultiAlter check_str : {} ", check_str.length);
					Map<String,String>  dataMap = null;
					try{
						for(int i=0 ; i < check_str.length; i++){	
							String str[]		=     check_str[i].split("@@" , -1);   
							if (str != null){
								dataMap = new HashMap<String,String>();
								dataMap.put("DOC_NAME","KEPMGPDT");
								dataMap.put("ST_USER_ID", param.get("st_user_id"));
								dataMap.put("TRXL_GUBUN", param.get("trxl_gubun"));
								dataMap.put("BUYER",str[0]);
								dataMap.put("BUYER_ITEM_NO",str[1]);
								dataMap.put("AGENT",str[2]);
								dataMap.put("CONTRACT_NO",str[3]);
								dataMap.put("CONTRACT_SEQ",str[4]);
//								dataMap.put("BYCA_COMORG_CODE",str[5]);
								dataMap.put("STATUS_TEXT",str[6]); 
								dataMap.put("SEQ", String.valueOf(i)); 
								dataMap.put("LIST_PRICE", "0");  
								dataMap.put("UNIT_PRICE", "0");  
								dataMap.put("AFTER_AGENT", str[2]);  
								dataMap.put("AFTER_UNIT_PRICE", "0");  
								dataMap.put("AFTER_LIST_PRICE", "0");  
								dataMap.put("AFTER_ITEM_MAKE_TYPE", " ");
								dataMap.put("DELIVERY_LT", " ");
								dataMap.put("AFTER_DELIVERY_LT", " ");
								dataMap.put("CH_TO_DATE", "");
								dataMap.put("CH_MIN_ORDER_QTY", str[7]);
								dataMap.put("CH_PUR_UNIT_QTY", str[8]);
								dataMap.put("CH_SELLER_AREA", str[9]);
								dataMap.put("CH_PROCESS_TYPE", str[10]);
								dataMap.put("CH_WAREHOUSE_CODE", str[11]);
								dataMap.put("CH_SELL_CLOSE_DATE", str[12]);
								dataMap.put("CH_BUY_CLOSE_DATE", str[13]);
								dataMap.put("UNIT_PRICE_CHANGE_REASON", "");
								dataMap.put("LIST_PRICE_CHANGE_REASON", "");
								// STEP1
								sqlSessionTemplate.update("master.mdcm.setSysopIcomTrxlUploadReg0Delete", dataMap);
								sqlSessionTemplate.update("master.mdcm.setSysopIcomTrxlUploadReg1", dataMap);
							}
						}
						
					} catch (Exception e){
						LOGGER.error("SQL ERROR : ", e);
							throw new RuntimeException("저장에 실패하였습니다.");
					}
			}
		}
		return _rtnMsg; 
	}
	
	@SuppressWarnings("unchecked")
	public String delMasterMdCmCatalogMultiAlter(Map<String, String> param,List<Object> gridData) {
		String _rtnMsg = "삭제완료 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.mdcm.setSysopIcomTrxlUploadReg1Delete", param);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("삭제완료에 실패하였습니다.");
		}
		return _rtnMsg; 
	}
	

	
	@SuppressWarnings("unchecked")
	public String  requestMasterMdCmCatalogSearchPop(Map<String, String> param,List<Object> gridData) {
		String _rtnMsg = "상신완료 되었습니다.";
		String pm_no = "";
		String dssChk = "Y";
		try{
			
			String com_code = "KRKORE0001";
			pm_no = buyerMpSoOrderInfoDao.getOrderNo(com_code,"PM");
			param.put("PM_NO", pm_no);
			param.put("DOC_NAME","KEPMGPDT");
			param.put("REG_USER_ID", param.get("st_user_id"));
			param.put("REG_USER_DEPT", param.get("st_user_dept"));
			param.put("TRXL_GUBUN", param.get("trxl_gubun"));
			
			
			for(int i=0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				
				param.put("PO_NO",param.get("BUYER")); //PO_NO에 고객사정보 넣음
				
				param.put("PO_SEQ", "");  
				param.put("PM_SEQ", String.valueOf(i+1));
				
				//제제업체 발생 시 오류 발생
				param.put("AGENT", CommonUtil.nvl(param.get("AFTER_AGENT"), ""));
				param.put("BUYER", CommonUtil.nvl(param.get("BELOW_COMORG_CODE"), ""));
				dssChk = (String) sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCatalogRegBNot", param);
				param.put("BUYER","KRKORE0001");//buyer에는 KRKORE0001 고정
				if(dssChk.equals("Y")) { // 제제대상 없으면
					// STEP1
					sqlSessionTemplate.update("master.mdcm.setSysopKepmgpCaReg1", param);
					sqlSessionTemplate.update("master.mdcm.setSysopKepmgpCaReg3", param);
					
					if (i == 0){
						sqlSessionTemplate.update("master.mdcm.setSysopKepmgpCaReg2", param); 
					
						// 고객사 메일 전송
						/*
						param.put("MAILFORM_ID", "PRE_GR_END_MB");
						param.put("SEND_COM_TYPE", "M");
						param.put("RECV_COM_TYPE", "B");
						param.put("SEND_COM_CODE", "KRKORE0001");
						param.put("SEND_USER_ID",  param.get("st_user_id"));
						param.put("KEY1", param.get("REG_USER_ID"));
						param.put("KEY2", param.get("REG_USER_DEPT"));
						
						MailSmsUtil.mailSend(param);
						*/
					}
				} else {					
					throw new RuntimeException((i+1) + "번째 행 제제업체(협력사) 입니다.\n"+CommonUtil.nvl(param.get("BELOW_COMORG_CODE"), "") + "<->" + CommonUtil.nvl(param.get("AFTER_AGENT"), ""));
				}
				
			}
			

			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if(dssChk.equals("Y")) {
				throw new RuntimeException("상신완료에 실패하였습니다.");
			} else {
				throw new RuntimeException(e.getMessage());
			}
				
		}
		return pm_no; 
	}
	
	public String  approvalMasterMdCmCatalogSearchPop(Map<String, String> param) {
		String _rtnMsg = "결재완료 되었습니다.";
		
		param.put("DOC_NAME", param.get("DOC_TYPE").toString());
        Map<String, String> _pMap = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo",param);
		if (_pMap != null){
			// 결재 요청자 정보 불러오기
			String KEPMGPHD_REG_ID = _pMap.get("REG_USER_ID");
		
			//적용구분이 존재하는 dataList를 SELECT
			List<Map<String,String>> dtList = sqlSessionTemplate.selectList("common.mdcm.selectCamApprovalDtList", _pMap);
			if (dtList != null){
				dtList = CommonUtil.getListNvl(dtList);
			
				try{
					
					for (int i=0; i<dtList.size(); i++){
				        Map<String, String> _pdMap = dtList.get(i);
				        
				        _pdMap.put("STATUS", "A");
				        _pdMap.put("USER_ID", param.get("USER_ID"));
				        _pdMap.put("USER_DEPT", param.get("USER_DEPT"));
				        _pdMap.put("USER_NAME", param.get("USER_NAME"));
				        _pdMap.put("USER_TEL", param.get("USER_TEL"));
				        
				        // 결재 요청자 정보 세팅
				        _pdMap.put("KEPMGPHD_REG_ID", KEPMGPHD_REG_ID);
				        
				        LOGGER.debug("approvalMasterMdCmCatalogSearchPop _pdMap {} " ,_pdMap);
				        String st_buyer = _pdMap.get("BELOW_COMORG_CODE"); //PO_NO에 고객사코드 들어있음
				        LOGGER.debug("BUYER {} " ,st_buyer);
						
				        //해당 고객사 매출단가 변경이 안됨. 삼성전자 로직
				        //ICOMCQDT UPDATE
						if(st_buyer.equals("KRSAMS0123")||st_buyer.equals("KRSAMS0192")){
							sqlSessionTemplate.update("master.mdcm.setSyopProxbuyCatalogChangeKepmgpCa1IF", _pdMap);
						}else{
							sqlSessionTemplate.update("master.mdcm.setSyopProxbuyCatalogChangeKepmgpCa1", _pdMap);							
						}
						//ICOMCQEP UPDATE
						sqlSessionTemplate.update("master.mdcm.setSyopProxbuyCatalogChangeKepmgpCa2", _pdMap);
						
						//해당 고객사 매출단가 변경이 안됨. 삼성전자 로직
						if(st_buyer.equals("KRSAMS0123")||st_buyer.equals("KRSAMS0192")){
							sqlSessionTemplate.update("master.mdcm.setSyopProxbuyCatalogChangeKepmgpCa3IF", _pdMap);							
						}else{
							sqlSessionTemplate.update("master.mdcm.setSyopProxbuyCatalogChangeKepmgpCa3", _pdMap);
						}
						sqlSessionTemplate.update("master.mdcm.setSyopProxbuyCatalogChangeKepmgpCa4", _pdMap);
						sqlSessionTemplate.update("master.mdcm.setSyopProxbuyCatalogChangeKepmgpCa5", _pdMap);
						sqlSessionTemplate.update("master.mdcm.setSyopProxbuyCatalogChangeKepmgpCa6", _pdMap);
						//해당 고객사 매출단가 변경이 안됨. 삼성전자 로직
						if(st_buyer.equals("KRSAMS0123")||st_buyer.equals("KRSAMS0192")){
							sqlSessionTemplate.update("master.mdcm.insertCaApprovalKepMgpDtEaiItemInfo", _pdMap);	
						}else{//삼성전자(KRSAMS0123)는 판매단가는 고객사 confirm 이후 변경 되기 때문에 외화단가 변경 필요 없음.
							//외화단가정보 업데이트
							sqlSessionTemplate.update("master.mdcm.setSyopProxbuyCatalogChangeKEPCURRENCYDT", _pdMap); // #{BELOW_COMORG_CODE} 고객사코드
							//외화단가 이력 insert
							sqlSessionTemplate.update("master.mdcm.setSyopProxbuyCatalogChangeKEPCURRENCYDT_HIST", _pdMap);// #{BELOW_COMORG_CODE} 고객사코드							
						}
					}
				} catch (Exception e){
					LOGGER.error("SQL ERROR : ", e);
						throw new RuntimeException("결재완료에 실패하였습니다.");
				}
			}
		}
		return _rtnMsg; 
	}
	/**
	 * 카탈로그 일괄수정 종료
	 */
	
	// 결재정보 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectApprInfoList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mdcm.selectMasterMdCmCatalogAlterApprInfoList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
	
	//카탈로그상태 변경
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public Map<String,String> saveSelectedStatusData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "정상적으로 저장 되었습니다.";

		String strStatus = "";
		int index = 0;
		String _pm_no = null;
		int _pm_seq = 1;
		Map<String, String> pMap = new HashMap<String, String>();
		
		try{

			
			for(int i=0; i < gridData.size(); i++){
				Map<String, String> gridMap= (Map<String, String>) gridData.get(i);
				formData.putAll(gridMap);
				++index;
				if (index == 1){
					pMap.put("COM_CODE", "KRKORE0001");
					pMap.put("DOC_TYPE", "PM");
					
					_pm_no =  masterMpRqBuyerReqDao.nextVal("KRKORE0001", "PM"); 
					formData.put("PM_NO", _pm_no);
					formData.put("NEW_YN", strStatus);
					
					sqlSessionTemplate.update("master.mdcm.insertCASTKEPMGPHD", formData);
				}
				
				formData.put("PM_NO", _pm_no);
				formData.put("PM_SEQ", String.valueOf(_pm_seq));
				sqlSessionTemplate.update("master.mdcm.insertCASTKEPMGPDT", formData);
				_pm_seq++;
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장이 실패하였습니다. 다시 확인하여 주십시요. ");
		}
		
		pMap.put("MSG", _rtnMsg);
		pMap.put("PM_NO", _pm_no);
		return pMap;	
	}
	
	public List<Map<String, String>> selecCmsExcelList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsCatalogAlterExcelList", param);
	};
	
	// MSDS 매핑 해제
	@SuppressWarnings("unchecked")
	public String saveSelectedMsdsClean(Map<String, String> param,List<Object> gridData) {
		String _rtnMsg = "매핑 해제 완료 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCatalogMsdsClean", param);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("매핑 해제에 실패하였습니다.");
		}
		return _rtnMsg; 
	}
}
