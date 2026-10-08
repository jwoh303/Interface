package com.koreab2b.mro.master.mpso.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpSoBuyerOrderCreationDao")
@Transactional
public class MasterMpSoBuyerOrderCreationDaoImpl implements MasterMpSoBuyerOrderCreationDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoBuyerOrderCreationDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.masterMpSoBuyerOrderCreation_buyerOrderQuery", param);
	}

	
	// 엑셀 업로딩검증 결과 조회
	public List<Map<String,String>> searchMasterMpSoBuyerOrderCreationListExcelResult(Map<String,Object>  param)  {
		return sqlSessionTemplate.selectList("master.mpso.masterMpSoBuyerOrderCreation_getUplodingCheck", param);
	}

	// 엑셀 업로딩검증 결과를 저장
	@SuppressWarnings("unchecked")
	public String updateMasterMpSoBuyerOrderCreationListExcelCheckResult(Map<String,String>  formData, List<Object> gridData)  {
		
		_rtnMsg = "엑셀 저장이 완료되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("updateMasterMpSoBuyerOrderCreationListExcelCheckResult  formData {} " , formData);
				
				//KEP_AGENCY_PO
				if (!"REG".equals(formData.get("TOT_FLAG"))){ // 비고내용에서 정상이 아닌 불일치 건은 업로드 항목에서 삭제됩니다.
					//sqlSessionTemplate.update("master.mpso.masterMpSoBuyerOrderCreation_deleteRow", formData);
					//자동삭제하지 않고 화면에서 삭제한다.
				}
				
				//KEP_AGENCY_PO
				sqlSessionTemplate.update("master.mpso.masterMpSoBuyerOrderCreation_comfirmUpdateRow", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("엑셀 저장에 실패하였습니다.");
		}
		return _rtnMsg;
		
	}

	
	
	// 엑셀 업로딩검증
	@SuppressWarnings("unchecked")
	public String updateSelectedDataExcelCheck(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "엑셀 검증이 완료되었습니다.";
		String st_kep_user_id = "";
		String KEP_USER_ID = "";
		String BUYER_ITEM_NO = "";
		String BUYER = "";
		String ITEM_QTY = "";
		String UNIT_PRICE = "";
		String LIST_PRICE = "";
		int userEquals = 0;
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				
				LOGGER.debug("updateSelectedDataExcelCheck  formData {} " , formData);
				st_kep_user_id = CommonUtil.nvl(formData.get("st_kep_user_id"),"");
				KEP_USER_ID = CommonUtil.nvl(formData.get("KEP_USER_ID"),"");
				BUYER_ITEM_NO = CommonUtil.nvl(formData.get("BUYER_ITEM_NO"),"");
				BUYER = CommonUtil.nvl(formData.get("BUYER"),"");
				ITEM_QTY = CommonUtil.nvl(formData.get("ITEM_QTY"),"");
				UNIT_PRICE = CommonUtil.nvl(formData.get("UNIT_PRICE"),"");
				LIST_PRICE = CommonUtil.nvl(formData.get("LIST_PRICE"),"");
				LOGGER.debug("updateSelectedDataExcelCheck  st_kep_user_id {} " , st_kep_user_id);
				LOGGER.debug("updateSelectedDataExcelCheck  KEP_USER_ID {} " , KEP_USER_ID);
				if ("".equals(KEP_USER_ID)
						|| "".equals(BUYER_ITEM_NO)
						|| "".equals(BUYER)
						|| "".equals(ITEM_QTY)
						|| "".equals(UNIT_PRICE)
						|| "".equals(LIST_PRICE)
					){
					userEquals = 1;
					throw new RuntimeException();
				}
				else if (!st_kep_user_id.equals(KEP_USER_ID)){
					userEquals = 2;
					throw new RuntimeException();
				}
				
				
				// 삭제하고 입력한다.. .PK 충돌을 막는다.
				sqlSessionTemplate.update("master.mpso.masterMpSoBuyerOrderCreation_saveGridtoDB_deleteRow", formData);			
				//KEP_AGENCY_PO
				sqlSessionTemplate.update("master.mpso.masterMpSoBuyerOrderCreation_saveGridtoDB", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if (userEquals == 1){
				throw new RuntimeException("정확한 정보를 엑셀 업로드하세요.");
			}else if (userEquals == 2){
				throw new RuntimeException("로그인한 사용자와 다른 엑셀정보를 업로드하셨습니다.");
			}else{
				throw new RuntimeException("엑셀 검증에 실패하였습니다.");
			}
		}
		return _rtnMsg;
		
	}
	// 주문생성 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "주문생성 완료되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				  
				if(formData.get("st_aply_range").equals("PO")){
					formData.put("st_dsdate_date", "");
					formData.put("st_invoice_date", "");
					formData.put("st_delivery_date", "");
					formData.put("st_gr_date", "");
				}else if(formData.get("st_aply_range").equals("DO")){
					formData.put("st_invoice_date", "");
					formData.put("st_delivery_date", "");
					formData.put("st_gr_date", "");
				}else if(formData.get("st_aply_range").equals("IV")){
					formData.put("st_delivery_date", "");
					formData.put("st_gr_date", "");
				}else if(formData.get("st_aply_range").equals("DI")){
					formData.put("st_gr_date", "");
				}
				sqlSessionTemplate.update("master.mpso.masterMpSoBuyerOrderCreation_OrderCreatelist", formData);
				
				// PM 번호생성 --> 상신전처리에서 합니다.
				String pm_no = ""; //buyerMpSoOrderInfoDao.getOrderNo("KRKORE0001","PM");  
				//formData.put("PO_NO", pm_no);
				_rtnMsg = pm_no;
				
				LOGGER.debug("updateSelectedData  formData {} " , formData);
				
				 /** 파일업로드 테이블 Y 로 변경*/
		        //첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경)  
		        Map<String,String> _fildData = new HashMap<String,String>() ; 
		        _fildData.put("DOC_NO", formData.get("st_reason_attkey"));
		        sqlSessionTemplate.update("common.fileUploadFlagUpdate", _fildData);
				
				// 고객사 주문생성 결재상신 전처리에서 해야할듯 한대...
				//sqlSessionTemplate.update("master.mpso.setSysopKepmgpOfReg", formData);				
				//sqlSessionTemplate.update("master.mpso.PKG_AUTO_PROCESS_AGENCY_PO_SELECT", formData);
				
				// 주문요청자, 발주자 마지막 로그인정보 UPDATE
				formData.put("LAST_LOGIN_ID", CommonUtil.nvl(formData.get("st_req_user_id"), ""));
				formData.put("LAST_LOGIN_ID1", CommonUtil.nvl(formData.get("st_purchaser_id"), ""));
				
		        // 주문요청자 마지막 로그인 정보 UPDATE
		        sqlSessionTemplate.insert("login.saveLogintime", formData);
		        
		        // 발주자 마지막 로그인 정보 UPDATE
		        sqlSessionTemplate.insert("login.saveLogintime1", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("주문생성에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked") 
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				LOGGER.debug("deleteSelectedData  formData {} " , formData);
				
				//KEP_AGENCY_PO
				sqlSessionTemplate.update("master.mpso.masterMpSoBuyerOrderCreation_deleteRow", formData);

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
	// PM번호 생성 - 결재 상신 전처리 
	public String getPmNoMasterMpSoBuyerOrderCreationList(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "상신 전처리 완료";
		
		try{
 
			// PM 번호생성
			String pm_no = buyerMpSoOrderInfoDao.getOrderNo("KRKORE0001","PM");  
				
				LOGGER.debug("getPmNoMasterMpSoBuyerOrderCreationList  formData {} " , formData);
				
				String param1 = formData.get("PARAM1");
				
				LOGGER.debug("getPmNoMasterMpSoBuyerOrderCreationList   param1 {} " ,  param1);
				 
				if (param1 != null){					
					String check_str[]  = CommonUtil.StrToArray(param1 , "^||^");  
					for(int i=0 ; i < check_str.length; i++){
						String str[] = check_str[i].split("@@",-1);
						LOGGER.debug("getPmNoMasterMpSoBuyerOrderCreationList   str {} " ,  str);
						formData.put("PO_NO",pm_no);
						formData.put("BUYER", str[0]);
						formData.put("BUYER1", str[0]);
						formData.put("BUYER_ITEM_NO", str[1]);
						formData.put("KEP_USER_ID", str[2]);

						sqlSessionTemplate.update("master.mpso.setSysopKepmgpOfReg", formData);
						break;
					}
				}
					   
				
				formData.put("BUYER", "KRKORE0001"); // ????????????
				formData.put("PO_NO", pm_no);
				//formData.put("BUYER_ITEM_NO", "BUYER_ITEM_NO");
				//formData.put("KEP_USER_ID",formData.get("USER_ID"));

				sqlSessionTemplate.update("master.mpso.PKG_AUTO_PROCESS_AGENCY_PO_SELECT", formData);
				_rtnMsg = pm_no + "@@"+formData.get("BUYER1");

 
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("상신 전처리에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	


	// 결재 후처리  
	public String savePmNoAfterMasterMpSoBuyerOrderCreationList(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "결재 후처리 완료";
		
		try{
 
			
				formData.put("BUYER", formData.get("KEY_2"));
				formData.put("LEGACY_NO", formData.get("KEY_1"));
				//formData.put("KEP_USER_ID",formData.get("KEY_1")); 
			
				LOGGER.debug("savePmNoAfterMasterMpSoBuyerOrderCreationList  formData {} " , formData);
				
				sqlSessionTemplate.update("master.mpso.setSyopProxbuyCatalogChangeKepmgpOf", formData);
				
				// 메일보내기
  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("결재 후처리에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
}
