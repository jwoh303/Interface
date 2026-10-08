package com.koreab2b.mro.master.cmcl.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.net.URL;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.AesCryptoAlgorithmUtil;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.webservice.erp.bond.BondInWebService;
import com.koreab2b.mro.webservice.erp.reverse.ReverseInWebService;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

@Repository("masterCmClSmartBillUploadingCreationDao")
@Transactional
public class MasterCmClSmartBillUploadingCreationDaoImpl implements MasterCmClSmartBillUploadingCreationDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSmartBillUploadingCreationDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private BondInWebService bondInWebService;
	
	@Autowired
	private ReverseInWebService reverseInWebService;
	
	
	//스마트빌 전송상태 업데이트
	public String saveXXSBDtiStatusInfo(Map<String,String>  formData){
		try{
				sqlSessionTemplate.update("master.cmcl.saveXXSBDtiStatusInfo", formData);  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("스마트빌 전송상태 업데이트 실패하였습니다.");
		}
		return null;
	}
	//스마트빌 전송상태 업데이트
	public String sendSuccessSmartbill(Map<String,String>  formData){
		try{
				sqlSessionTemplate.update("master.cmcl.sendSuccessSmartbill", formData);  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("스마트빌 전송상태 업데이트 실패하였습니다.");
		}
		return null;
	}
	//스마트빌 전송실패 업데이트
	public String errorSendSmartBill(Map<String,String>  formData){
		try{
			sqlSessionTemplate.update("master.cmcl.errorSendSmartBill", formData);  
	}catch(Exception e){
		LOGGER.error("SQL ERROR : ", e);
		throw new RuntimeException("스마트빌 취소 실패하였습니다.");
	}
	return null;
} 
	//스마트빌 전송송공 업데이트
	public String cancleSuccessSmartBill(Map<String,String>  formData){
		try{
			String _param1 = formData.get("param1").toString();
			String _param2 = formData.get("param2").toString();
			String st_user_id = formData.get("st_user_id").toString();
			Map<String,String> _dataParam = null;
			 _dataParam = new HashMap<String,String>() ;
			_dataParam.put("CREATED_BY", st_user_id);
			_dataParam.put("DTI_STATUS", "O");
			_dataParam.put("SBDESCRIPTION", _param2);
			_dataParam.put("CONVERSATION_ID", _param1);
			sqlSessionTemplate.insert("master.cmcl.updateMasterCmClSBStatus", _dataParam);
			//MAIN상태 업데이트
			sqlSessionTemplate.insert("master.cmcl.updateMasterCmClDelSBSMain", _dataParam);
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("스마트빌 전송상태 업데이트 실패하였습니다.");
		}
		return null;
	}

	//스마트빌 전송양식.
	public List<Map<String,String>> SendARMasterCmClSalesTaxsheetIssueFormatInfo(Map<String,String> formData) {

		List<Map<String, String>> data = new ArrayList<Map<String, String>>();
		/*
		 * _st_gbn2 세금계산서 정상/수정세금계산서/취소(S/M/R)
		 * _st_gbn3 정발행역발행구분(A/B)
		 * _st_gbn 엡데이트상태
		 */
		String _st_update = formData.get("param1").toString();
		String _st_user_id = formData.get("param2").toString();
		String _st_gbn = formData.get("param3").toString();
		String _st_gbn2 = formData.get("param4").toString();
		String param5Data = formData.get("param5").toString();
		String[] param5Array = param5Data.split("@@");
		String _st_gbn3 = param5Array[0];
		String _st_issueYn = param5Array[1];
		String _st_smartBillUrl = formData.get("smartBillUrl").toString();
		StringBuffer send_buf = new StringBuffer();
		String send = "";
		String certPassword = "";
		String _rtnMsg = "";
		//스마트빌ID, 참조ID
		String conId = "";
		String issueId = "";
		String yymmdd = "";
		Map<String, String> map =  new HashMap<String, String>();
		Map<String,String> _dataParam = null;
		Map<String,String> _dataDetailParam = null;
		Map<String,String> _dataPwParam = null;
		String _st_dtiStatus = "";
		String bizIrsNo = "";//공급자 사업자번호
		
		try {
				String  _SENDFORMAT[] = _st_update.split("\\|");
				if(_st_issueYn.equals("Y")){//국세청전송
					 if (_SENDFORMAT == null){
						 LOGGER.debug("_SENDFORMAT 미존재 ");
					 }else{
						 LOGGER.debug(" _SENDFORMAT.length  " + _SENDFORMAT.length );
						 if (_SENDFORMAT.length >0){
							 for( int i=0 ; i < _SENDFORMAT.length; i++){ 
						        String str[] =  _SENDFORMAT[i].split("@@",-1);  
						        bizIrsNo = str[0];
							 }
							yymmdd = sqlSessionTemplate.selectOne("master.cmcl.getYyyymmdd", ""); //작성일자
							_dataPwParam = new HashMap<String,String>() ;
							_dataPwParam.put("CONVERSATION_ID", conId);
							if(bizIrsNo.equals("1358551796")){//경기MRO
								certPassword = AesCryptoAlgorithmUtil.Encrypt("koreab2b!!", "sBcertNonStd");
							}else{
								certPassword = AesCryptoAlgorithmUtil.Encrypt("koreab2b", "sBcertNonStd");
							}
							LOGGER.debug("bizIrsNo/certPassword : {}", bizIrsNo+"/"+certPassword);
							map.put("SEND_FORMAT","");
							map.put("SERT_PASSWORD",certPassword);
							map.put("CON_ID","");
							map.put("REQUEST_TIME",yymmdd);					
							map.put("SMARTBILL_URL",_st_smartBillUrl);
							data.add(0, map);
						 }
					 }
				}else{
					 if (_SENDFORMAT == null){
						 LOGGER.debug("_SENDFORMAT 미존재 ");
					 }else{
						 LOGGER.debug(" _SENDFORMAT.length  " + _SENDFORMAT.length );
						 if (_SENDFORMAT.length >0){
							 for( int i=0 ; i < _SENDFORMAT.length; i++){ 
						        String str[] =  _SENDFORMAT[i].split("@@",-1);  
								for( int k=0; k < str.length; k++){
									LOGGER.debug("str["+k+"]==>" + str[k] + "/ size="+str[k].length() );
			                    } 
						        //참조번호 채번
								//세금계산서 1건와 1:1로 매핑되는 스마트빌 시스템 고유의 식별자(공급자사업자번호(10자리)+공급받는자사업자번호(10자리)+현재날짜(8자리)+시퀀스(4자리)+시스템구분코드(3자리고정값 006) -> 시스템구분코드 006은 고정값
								
								LOGGER.debug("정발행역발행구분(정발행:A/역발행:B)==>" + _st_gbn3);
								LOGGER.debug("세금계산서상태==>" + _st_gbn2);
								_st_dtiStatus = str[27];
								if(_st_gbn2.equals("R")){//취소처리
							        conId =  str[31]; //참조번호
							        issueId = str[32];//국세청번호								
								}else{
									if(_st_dtiStatus.equals("E")){//계산서상태가 에러일경우 채번안함.
								        conId =  str[31]; //참조번호
								        issueId = str[32];//국세청번호										
									}else{
								        conId =  nextVal(str[0], str[9],"CON",""); //참조번호
								        issueId = nextVal(str[0], str[9],"ISSUE_ID",str[28]); //국세청번호										
									}
								
								}
								bizIrsNo = str[0];
						        yymmdd = sqlSessionTemplate.selectOne("master.cmcl.getYyyymmdd", ""); //작성일자
								 _dataParam = new HashMap<String,String>() ;
								_dataParam.put("CONVERSATION_ID", conId);
								_dataParam.put("SUPBUY_TYPE", str[20]);
								_dataParam.put("DIRECTION", str[21]);
								_dataParam.put("DTI_TYPE", str[22]);
								_dataParam.put("TAX_DEMAND", str[23]);
								_dataParam.put("ISSUE_ID", issueId);
								_dataParam.put("SEQ_ID", str[24]);
								_dataParam.put("SUP_COM_REGNO", str[0]); //공급자사업자번호
								_dataParam.put("SUP_REP_NAME", str[4]); //공급자 대표자
								_dataParam.put("SUP_COM_NAME", str[2]); //공급자 상호
								_dataParam.put("SUP_COM_TYPE", str[1]); //공급자 업태
								_dataParam.put("SUP_COM_CLASSIFY", str[3]); //공급자 업종
								_dataParam.put("SUP_COM_ADDR", str[8]); //공급자 주소
								_dataParam.put("SUP_EMP_NAME", str[5]); //공급자 담당자
								_dataParam.put("SUP_EMAIL", str[7]); //공급자 이메일
								_dataParam.put("BYR_COM_REGNO", str[9]); //공급받는자 사업자번호
								_dataParam.put("BYR_REP_NAME", str[13]); //공급받는자 대표자명
								_dataParam.put("BYR_COM_NAME", str[11]); //공급받는자 상호
								_dataParam.put("BYR_COM_TYPE", str[10]); //공급받는자업태
								_dataParam.put("BYR_COM_CLASSIFY", str[12]); //공급받는자 업종
								_dataParam.put("BYR_COM_ADDR", str[17]); //공급받는자 주소
								_dataParam.put("BYR_EMP_NAME", str[14]); //공급받는자 담당자명
								_dataParam.put("BYR_EMAIL", str[16]); //공급받는자 이메일
								_dataParam.put("TOTAL_QUANTITY", "1"); //총수량
								_dataParam.put("REMARK", ""); //비고
								_dataParam.put("CREATED_BY",_st_user_id); 		 //작성자
								_dataParam.put("DTI_MSG", send); 			 // DTI 원본
								_dataParam.put("DTI_STATUS", _st_gbn); 			 // DTI 원본
								_dataParam.put("DTI_WDATE", str[28]); 			 // 작성일자
								_dataParam.put("ARDT_REMARK", str[29]); 		// 비고							
								if(_st_gbn2.equals("M")){ //수정일경우
									if(str[33].equals("01")){
										str[18] = Integer.parseInt(str[18])*-1+"";
										str[19] = Integer.parseInt(str[19])*-1+"";
										str[25] = Integer.parseInt(str[25])*-1+"";
									}else if(str[33].equals("02")){	
										str[33] = "01";
									}
									_dataParam.put("ORI_ISSUE_ID", str[34]); 			 // 당초승인번호
									_dataParam.put("DEL_ISSUE_ID", str[32]); 			 // 당초승인번호
									_dataParam.put("AMEND_CODE", str[33]); 			 // 수정사유
								}else{
									_dataParam.put("ORI_ISSUE_ID", ""); 			 // 당초승인번호
									_dataParam.put("DEL_ISSUE_ID", ""); 			 // 당초승인번호
									_dataParam.put("AMEND_CODE", ""); 			 // 수정사유
								}
								if(_st_gbn2.equals("R")){ //취소일경우
									_dataParam.put("SBDESCRIPTION", str[33]);
								}else{
									_dataParam.put("SBDESCRIPTION", ""); 
								}
								LOGGER.debug("SUP_AMOUNT==>" + str[18]);
								LOGGER.debug("TAX_AMOUNT==>" + str[19]);
								LOGGER.debug("TOTAL_AMOUNT==>" + str[25]);
								_dataParam.put("SUP_AMOUNT", str[18]); //공급가액합계
								_dataParam.put("TAX_AMOUNT", str[19]); //세액합계
								_dataParam.put("TOTAL_AMOUNT", str[25]); //계산서총금액
								if(_st_gbn2.equals("R")){ //취소일경우
									_dataParam.put("SBDESCRIPTION", str[33]);
								}else{
									_dataParam.put("SBDESCRIPTION", ""); 
								}
						        //적요데이터 조회 마이너스처
						        List<Map<String,String>> list = null;
						        //중복체크.
						        List<Map<String,String>> list2 = null;
						        if(_st_dtiStatus.equals("E")){//에러일경우 삭제후 재insert
						        	sqlSessionTemplate.insert("master.cmcl.deleteMasterCmClDelSBSMain", _dataParam);
						        	sqlSessionTemplate.insert("master.cmcl.deleteMasterCmClDelSBItem", _dataParam);
						        	sqlSessionTemplate.insert("master.cmcl.deleteMasterCmClDelSBStatus", _dataParam);
						        }
						        if(_st_gbn2.equals("M")||_st_gbn2.equals("R")){ 
						        }else{
						        	list2 = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClCheckXxSbDtiMain", _dataParam);
									 if(list2.size() > 0){
										 LOGGER.debug("list2.size()==>" + list2.size());
										String bizTitle = "스마트빌 전송 내역이 존재 합니다.";
										throw new RuntimeException(bizTitle);
									 }
						        }
						        if(_st_gbn2.equals("M")||_st_gbn2.equals("R")){ //취소나 수정 일경우
						        	//취소
						        	list = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClKepItemMinusList", _dataParam);
						        }else{
						        	list = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClKepItemList", _dataParam);
						        }

								send_buf.append("<?xml version = \"1.0\" encoding=\"UTF-8\"?>");
								send_buf.append("<TaxInvoice xmlns=\"urn:kr:or:kec:standard:Tax:ReusableAggregateBusinessInformationEntitySchemaModule:1:0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"urn:kr:or:kec:standard:Tax:ReusableAggregateBusinessInformationEntitySchemaModule:1:0 http://www.kec.or.kr/standard/Tax/TaxInvoiceSchemaModule_1.0.xsd\">");
								send_buf.append("<ExchangedDocument>");
								send_buf.append("<IssueDateTime>");
								send_buf.append(yymmdd); //전자세금계산서 작성일자
								send_buf.append("</IssueDateTime>");
								send_buf.append("</ExchangedDocument>");
								send_buf.append("<TaxInvoiceDocument>");
								send_buf.append("<IssueID>"); 
								send_buf.append(issueId);  //세금계산서 승인번호 발행일자(8자리)+발행시스템고유번호(41000008 (고정값))+시퀀스(5자리)+업체코드(fhv (고정값)) ->스마트빌요청
								send_buf.append("</IssueID>	");
								send_buf.append("<TypeCode>");
								send_buf.append(str[26]); //전자세금계산서 종류 구분자 세금계산서 분류(2자리) : 01(세금계산서), 02(수정세금계산서), 03(계산서), 04(수정계산서)/세금계산서 종류(2자리) : 01(일반), 02(영세율), 03(일반 위수탁), 04(수입), 05(영세율 위수탁)
								send_buf.append("</TypeCode>");
								send_buf.append("<DescriptionText>"); 
								send_buf.append(str[29]);//비고
								send_buf.append("</DescriptionText>");
								send_buf.append("<IssueDateTime>"); 
								send_buf.append(str[28]); //전자세금계산서 작성일자
								send_buf.append("</IssueDateTime>");
								if(_st_gbn2.equals("M")){ //수정일경우
									send_buf.append("<AmendmentStatusCode>");
									send_buf.append(str[33]); //수정사유
									send_buf.append("</AmendmentStatusCode>");
									send_buf.append("<PurposeCode>");
									send_buf.append(str[23]); //세금계산서의 영수/청구 구분 지시자 01 : 영수, 02 : 청구
									send_buf.append("</PurposeCode>");
									send_buf.append("<OriginalIssueID>");
									send_buf.append(str[34]); //당초국세청전송번호.
									send_buf.append("</OriginalIssueID>");
								}else{
									send_buf.append("<PurposeCode>");
									send_buf.append(str[23]); //세금계산서의 영수/청구 구분 지시자 01 : 영수, 02 : 청구
									send_buf.append("</PurposeCode>");
								}
								send_buf.append("</TaxInvoiceDocument>");
								send_buf.append("<TaxInvoiceTradeSettlement>");//공급받는자 정보 셋팅
								send_buf.append("<InvoicerParty>"); //공급자 정보
								send_buf.append("<ID>"); 
								send_buf.append(str[0]);//공급자 사업자등록번호
								send_buf.append("</ID>");
								send_buf.append("<TypeCode>");
								send_buf.append(str[1]); //공급업체의 업태 텍스트
								send_buf.append("</TypeCode>");
								send_buf.append("<NameText>");
								send_buf.append(str[2].replace("&", "&amp;").replace("＆", "&amp;")); //공급업체 사업체명
								send_buf.append("</NameText>");
								send_buf.append("<ClassificationCode>");
								send_buf.append(str[3]); //공급업체의 업종
								send_buf.append("</ClassificationCode>");
								send_buf.append("<SpecifiedPerson>");
								send_buf.append("<NameText>");
								send_buf.append(str[4]); //공급업체 대표자명
								send_buf.append("</NameText>	");
								send_buf.append("</SpecifiedPerson>");
								send_buf.append("<DefinedContact>");
								send_buf.append("<DepartmentNameText />"); //공급업체 담당부서
								send_buf.append("<PersonNameText>"); 
								send_buf.append(str[5]); //공급업체 담당자명
								send_buf.append("</PersonNameText>");
								send_buf.append("<TelephoneCommunication>");
								send_buf.append(str[6]); //공급업체 담당자 전화번호
								send_buf.append("</TelephoneCommunication>");
								send_buf.append("<URICommunication>");
								send_buf.append(str[7]);//공급업체 담당자 이메일
								send_buf.append("</URICommunication>");
								send_buf.append("</DefinedContact>");
								send_buf.append("<SpecifiedAddress>");
								send_buf.append("<LineOneText>");
								send_buf.append(str[8]);//공급업체의 주소
								send_buf.append("</LineOneText>");
								send_buf.append("</SpecifiedAddress>");
								send_buf.append("</InvoicerParty>"); //공급자 정보
								send_buf.append("<InvoiceeParty>"); //공급받는자
								send_buf.append("<ID>"); 
								send_buf.append(str[9]);///공급받는자 사업자등록번호
								send_buf.append("</ID>");
								send_buf.append("<TypeCode>");
								send_buf.append(str[10]); ////공급받는자의 업태 텍스트
								send_buf.append("</TypeCode>");
								send_buf.append("<NameText>");
								send_buf.append(str[11].replace("&", "&amp;").replace("＆", "&amp;")); //공급받는자 사업체명
								send_buf.append("</NameText>	");
								send_buf.append("<ClassificationCode>");
								send_buf.append(str[12]); //공급받는자의 업종
								send_buf.append("</ClassificationCode>");							
								send_buf.append("<SpecifiedOrganization>");
								if(str[30].length() > 0 && _st_gbn3.equals("A")){
									send_buf.append("<TaxRegistrationID>");
									send_buf.append(str[30]);//종사업자번호
									send_buf.append("</TaxRegistrationID>");
								}
								if(str[30].length() > 0 && _st_gbn3.equals("B")){
									send_buf.append("<TaxRegistrationID>");
									send_buf.append(str[30]);//종사업자번호
									send_buf.append("</TaxRegistrationID>");
								}
								send_buf.append("<BusinessTypeCode>");
								send_buf.append("01");//01 : 사업자등록번호, 02 : 주민등록번호, 03 : 외국인
								send_buf.append("</BusinessTypeCode>");
								send_buf.append("</SpecifiedOrganization>");
								send_buf.append("<SpecifiedPerson>");
								send_buf.append("<NameText>");
								send_buf.append(str[13]); //공급받는대표자명
								send_buf.append("</NameText>	");
								send_buf.append("</SpecifiedPerson>");
								send_buf.append("<PrimaryDefinedContact>");
								send_buf.append("<DepartmentNameText/>");
								send_buf.append("<PersonNameText>");
								send_buf.append(str[14]); //공급받는 담당자명
								send_buf.append("</PersonNameText>");
								send_buf.append("<TelephoneCommunication>");
								send_buf.append(str[15]); //공급받는자 담당자 전화번호
								send_buf.append("</TelephoneCommunication>");
								send_buf.append("<URICommunication>");
								send_buf.append(str[16]); //공급받는자 담당자 이메일
								send_buf.append("</URICommunication>");
								send_buf.append("</PrimaryDefinedContact>");
								send_buf.append("<SpecifiedAddress>");
								send_buf.append("<LineOneText>");
								send_buf.append(str[17]); //공급받는자 주소
								send_buf.append("</LineOneText>");
								send_buf.append("</SpecifiedAddress>");
								send_buf.append("</InvoiceeParty>"); //공급받는자
								send_buf.append("<SpecifiedMonetarySummation>");
								send_buf.append("<ChargeTotalAmount>");
								send_buf.append(str[18]);//총 공급가액 합계
								send_buf.append("</ChargeTotalAmount>");
								send_buf.append("<TaxTotalAmount>");
								send_buf.append(str[19]);//총 세액 합계
								send_buf.append("</TaxTotalAmount>");
								send_buf.append("<GrandTotalAmount>");
								send_buf.append(str[25]);//총액(공급가액+세액)
								send_buf.append("</GrandTotalAmount>");
								send_buf.append("</SpecifiedMonetarySummation>");
								send_buf.append("</TaxInvoiceTradeSettlement>");
								LOGGER.debug("list.size() : {}", list.size());
							    if(list.size() > 0){
									for(int z=0; z<list.size(); z++){
										Map<String,String> mp = (Map<String,String>)list.get(z);
										//DTI 입력
										send_buf.append("<TaxInvoiceTradeLineItem>");
										send_buf.append("<SequenceNumeric>");
										send_buf.append(z+1);
										send_buf.append("</SequenceNumeric>");
										if(mp.get("REMARK") != null){
											send_buf.append("<DescriptionText>");
											send_buf.append(mp.get("REMARK"));
											send_buf.append("</DescriptionText>");
										}
										send_buf.append("<InvoiceAmount>");
										send_buf.append(mp.get("SUPP_PRICE"));//물품 공급 가액
										send_buf.append("</InvoiceAmount>");
										if(mp.get("REMARK_QTY") != null){
											send_buf.append("<ChargeableUnitQuantity>");
											send_buf.append(mp.get("REMARK_QTY"));
											send_buf.append("</ChargeableUnitQuantity>");
										}
										if(mp.get("REMARK_SPECIFICATION") != null){
											send_buf.append("<InformationText>");
											send_buf.append(mp.get("REMARK_SPECIFICATION").replace("&", "&amp;"));
											send_buf.append("</InformationText>");
										}
										if(mp.get("REMARK_DESCRIPTION") != null){
											send_buf.append("<NameText>");
											send_buf.append(mp.get("REMARK_DESCRIPTION").replace("&", "&amp;"));
											send_buf.append("</NameText>");
										}
										send_buf.append("<PurchaseExpiryDateTime>");
										send_buf.append(str[28]);								
										send_buf.append("</PurchaseExpiryDateTime>");
										send_buf.append("<TotalTax>");
										send_buf.append("<CalculatedAmount>");
										send_buf.append(mp.get("TAX_PRICE"));//물품 공급 가액
										send_buf.append("</CalculatedAmount>");
										send_buf.append("</TotalTax>");
										if(mp.get("REMARK_QTY") != null){
											send_buf.append("<UnitPrice>");
											send_buf.append("<UnitAmount>");
											send_buf.append(mp.get("REMARK_PRICE"));//물품 공급 가액
											send_buf.append("</UnitAmount>");
											send_buf.append("</UnitPrice>");
										}
										send_buf.append("</TaxInvoiceTradeLineItem>");
									}
							    }else{
									
									send_buf.append("<TaxInvoiceTradeLineItem>");
									send_buf.append("<SequenceNumeric>");
									send_buf.append("1");
									send_buf.append("</SequenceNumeric>");
									send_buf.append("<InvoiceAmount>");
									send_buf.append(str[18]);//물품 공급 가액
									send_buf.append("</InvoiceAmount>");
									send_buf.append("<NameText>");
									send_buf.append("MRO품목");
									send_buf.append("</NameText>");
									send_buf.append("<PurchaseExpiryDateTime>");
									send_buf.append(str[28]);								
									send_buf.append("</PurchaseExpiryDateTime>");
									send_buf.append("<TotalTax>");
									send_buf.append("<CalculatedAmount>");
									send_buf.append(str[19]);//물품 공급 가액
									send_buf.append("</CalculatedAmount>");
									send_buf.append("</TotalTax>");
									send_buf.append("<UnitPrice>");
									send_buf.append("<UnitAmount>");
									send_buf.append(str[18]);//물품 공급 가액
									send_buf.append("</UnitAmount>");
									send_buf.append("</UnitPrice>");
									send_buf.append("</TaxInvoiceTradeLineItem>");

							    }
								
								send_buf.append("</TaxInvoice>							\n");
								//send = AesCryptoAlgorithmUtil.URLUTF8Encoder_encode(send);
								 send = send_buf.toString();
								 //xxdbmain insert
								 //취소가아닐경우
								if(!_st_gbn.equals("O")){
								    if(list.size() > 0){
										for(int k=0; k<list.size(); k++){
											Map<String,String> mp = (Map<String,String>)list.get(k);
											//DTI 입력
											_dataDetailParam = new HashMap<String,String>() ;
											_dataDetailParam.put("CONVERSATION_ID", conId); 	
											_dataDetailParam.put("SUPBUY_TYPE", str[20]);
											_dataDetailParam.put("DIRECTION", str[21]);
											_dataDetailParam.put("ITEM_NAME", CommonUtil.nvl(mp.get("REMARK_DESCRIPTION").replace("&", "&amp;"),""));
											_dataDetailParam.put("ITEM_QTY", CommonUtil.nvl(mp.get("REMARK_QTY"),""));
											_dataDetailParam.put("SUP_AMOUNT", CommonUtil.nvl(mp.get("SUPP_PRICE"),""));
											_dataDetailParam.put("TAX_AMOUNT", CommonUtil.nvl(mp.get("TAX_PRICE"),""));
											_dataDetailParam.put("CREATED_BY", _st_user_id);
											
											sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBDtiItem", _dataDetailParam);
										}
								    }else{
										//DTI 입력
										_dataDetailParam = new HashMap<String,String>() ;
										_dataDetailParam.put("CONVERSATION_ID", conId); 	
										_dataDetailParam.put("SUPBUY_TYPE", str[20]);
										_dataDetailParam.put("DIRECTION", str[21]);
										_dataDetailParam.put("ITEM_NAME", "MRO품목");
										_dataDetailParam.put("ITEM_QTY", "1");
										_dataDetailParam.put("SUP_AMOUNT", str[18]);
										_dataDetailParam.put("TAX_AMOUNT", str[19]);
										_dataDetailParam.put("CREATED_BY", _st_user_id);
										
										sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBDtiItem", _dataDetailParam);
								    }
		
								 }
							 }
						 }
						certPassword = AesCryptoAlgorithmUtil.Encrypt("koreab2b", "sBcertNonStd");
						if(bizIrsNo.equals("1358551796")){//경기MRO
							certPassword = AesCryptoAlgorithmUtil.Encrypt("koreab2b!!", "sBcertNonStd");
						}else{
							certPassword = AesCryptoAlgorithmUtil.Encrypt("koreab2b", "sBcertNonStd");
						}
						LOGGER.debug("send : {}", send);
						map.put("SEND_FORMAT",send);
						LOGGER.debug("bizIrsNo/certPassword : {}", bizIrsNo+"/"+certPassword);
						map.put("SERT_PASSWORD",certPassword);
						map.put("REQUEST_TIME",yymmdd);					
						map.put("CON_ID",conId);					
						_rtnMsg  ="OK";
						map.put("RTN_MSG",_rtnMsg);
						map.put("SMARTBILL_URL",_st_smartBillUrl);
						data.add(0, map);
						if(_st_gbn2.equals("R")){
							//취소일경우
							//STATUS 입력
							//sqlSessionTemplate.insert("master.cmcl.updateMasterCmClSBStatus", _dataParam);
							//MAIN상태 업데이트
							//sqlSessionTemplate.insert("master.cmcl.updateMasterCmClDelSBSMain", _dataParam);
						}else if(_st_gbn2.equals("M")){//수정계산서
							//MAIN 당초계산서 삭제
							//sqlSessionTemplate.insert("master.cmcl.updateMasterCmClDelSBSMainOld", _dataParam); //삭제처리안함.
							//MAIN 입력
							sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBDtimain", _dataParam);
							//STATUS 입력
							sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBStatus", _dataParam);
							//ARDT비고저장
							sqlSessionTemplate.insert("master.cmcl.updateMasterCmClArdtRemark", _dataParam);						
					 	}else{
							//MAIN 입력
							sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBDtimain", _dataParam);
							//STATUS 입력
							sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBStatus", _dataParam);

						}

					 }
				}
			} catch(Exception e) {
				_rtnMsg = "ERR";
				throw new RuntimeException("세금계산서 전송에 실패하였습니다."+e);
			}
		

		return data;
	}
	//스마트빌 전송양식.
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> SendARMasterCmClSalesTaxsheetIssueRegList(Map<String,String> formData, HttpServletRequest req, HttpServletResponse pResponse) {

		List<Map<String, String>> data = new ArrayList<Map<String, String>>();
		/*
		 * _st_gbn2 세금계산서 정상/수정세금계산서/취소(S/M/R)
		 * _st_gbn3 정발행역발행구분(A/B)
		 * _st_gbn 엡데이트상태
		 */
		String _st_update = formData.get("param1").toString();
		String _st_user_id = formData.get("param2").toString();
		String _st_gbn = formData.get("param3").toString();
		String _st_gbn2 = formData.get("param4").toString();
		String _st_gbn3 = formData.get("param5").toString();
		String _authtoken = formData.get("_authtoken").toString();
		StringBuffer send_buf = new StringBuffer();
		String send = "";
		String certPassword = "";
		//스마트빌ID, 참조ID
		String conId = "";
		String issueId = "";
		String yymmdd = "";
		Map<String, String> map =  new HashMap<String, String>();
		Map<String,String> _dataParam = null;
		Map<String,String> _dataDetailParam = null;
		
		try {
				String  _SENDFORMAT[] = _st_update.split("\\|"); 
				 if (_SENDFORMAT == null){
					 LOGGER.debug("_SENDFORMAT 미존재 ");
				 }else{
					 LOGGER.debug(" _SENDFORMAT.length  " + _SENDFORMAT.length );
					 if (_SENDFORMAT.length >0){
						 for( int i=0 ; i < _SENDFORMAT.length; i++){ 
					        String str[] =  _SENDFORMAT[i].split("@@",-1);  
							for( int k=0; k < str.length; k++){
								LOGGER.debug("str["+k+"]==>" + str[k] );
		                    } 
					        //참조번호 채번
							//세금계산서 1건와 1:1로 매핑되는 스마트빌 시스템 고유의 식별자(공급자사업자번호(10자리)+공급받는자사업자번호(10자리)+현재날짜(8자리)+시퀀스(4자리)+시스템구분코드(3자리고정값 006) -> 시스템구분코드 006은 고정값
							LOGGER.debug("세금계산서상태==>" + _st_gbn2);
							if(_st_gbn2.equals("R")){//취소처리
						        conId =  str[31]; //참조번호
						        issueId = str[32];//국세청번호								
							}else{
						        conId =  nextVal(str[0], str[9],"CON",""); //참조번호
						        issueId = nextVal(str[0], str[9],"ISSUE_ID",str[28]); //국세청번호								
							}

					        yymmdd = sqlSessionTemplate.selectOne("master.cmcl.getYyyymmdd", ""); //작성일자
							 _dataParam = new HashMap<String,String>() ;
							_dataParam.put("CONVERSATION_ID", conId);
							_dataParam.put("SUPBUY_TYPE", str[20]);
							_dataParam.put("DIRECTION", str[21]);
							_dataParam.put("DTI_TYPE", str[22]);
							_dataParam.put("TAX_DEMAND", str[23]);
							_dataParam.put("ISSUE_ID", issueId);
							_dataParam.put("SEQ_ID", str[24]);
							_dataParam.put("SUP_COM_REGNO", str[0]); //공급자사업자번호
							_dataParam.put("SUP_REP_NAME", str[4]); //공급자 대표자
							_dataParam.put("SUP_COM_NAME", str[2]); //공급자 상호
							_dataParam.put("SUP_COM_TYPE", str[1]); //공급자 업태
							_dataParam.put("SUP_COM_CLASSIFY", str[3]); //공급자 업종
							_dataParam.put("SUP_COM_ADDR", str[8]); //공급자 주소
							_dataParam.put("SUP_EMP_NAME", str[5]); //공급자 담당자
							_dataParam.put("SUP_EMAIL", str[7]); //공급자 이메일
							_dataParam.put("BYR_COM_REGNO", str[9]); //공급받는자 사업자번호
							_dataParam.put("BYR_REP_NAME", str[13]); //공급받는자 대표자명
							_dataParam.put("BYR_COM_NAME", str[11]); //공급받는자 상호
							_dataParam.put("BYR_COM_TYPE", str[10]); //공급받는자업태
							_dataParam.put("BYR_COM_CLASSIFY", str[12]); //공급받는자 업종
							_dataParam.put("BYR_COM_ADDR", str[17]); //공급받는자 주소
							_dataParam.put("BYR_EMP_NAME", str[14]); //공급받는자 담당자명
							_dataParam.put("BYR_EMAIL", str[16]); //공급받는자 이메일
							_dataParam.put("TOTAL_QUANTITY", "1"); //총수량
							_dataParam.put("REMARK", ""); //비고
							_dataParam.put("CREATED_BY",_st_user_id); 		 //작성자
							_dataParam.put("DTI_MSG", send); 			 // DTI 원본
							_dataParam.put("DTI_STATUS", _st_gbn); 			 // DTI 원본
							if(_st_gbn2.equals("M")){ //수정일경우
								
								if(str[33].equals("01")){
									str[18] = Integer.parseInt(str[18])*-1+"";
									str[19] = Integer.parseInt(str[19])*-1+"";
									str[25] = Integer.parseInt(str[25])*-1+"";
								}else if(str[33].equals("02")){	
									str[33] = "01";
								}
								_dataParam.put("ORI_ISSUE_ID", str[34]); 			 // 당초승인번호
								_dataParam.put("DEL_ISSUE_ID", str[32]); 			 // 당초승인번호
								_dataParam.put("AMEND_CODE", str[33]); 			 // 수정사유
							}else{
								_dataParam.put("ORI_ISSUE_ID", ""); 			 // 당초승인번호
								_dataParam.put("DEL_ISSUE_ID", ""); 			 // 당초승인번호
								_dataParam.put("AMEND_CODE", ""); 			 // 수정사유
							}
							if(_st_gbn2.equals("R")){ //취소일경우
								_dataParam.put("SBDESCRIPTION", str[33]);
							}else{
								_dataParam.put("SBDESCRIPTION", ""); 
							}
							LOGGER.debug("SUP_AMOUNT==>" + str[18]);
							LOGGER.debug("TAX_AMOUNT==>" + str[19]);
							LOGGER.debug("TOTAL_AMOUNT==>" + str[25]);
							
							_dataParam.put("SUP_AMOUNT", str[18]); //공급가액합계
							_dataParam.put("TAX_AMOUNT", str[19]); //세액합계
							_dataParam.put("TOTAL_AMOUNT", str[25]); //계산서총금액
					        //적요데이터 조회 마이너스처
					        List<Map<String,String>> list = null;
					        if(_st_gbn2.equals("M")||_st_gbn2.equals("R")){ //취소나 수정 일경우
					        	//취소
					        	list = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClKepItemMinusList", _dataParam);
					        }else{
					        	list = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClKepItemList", _dataParam);
					        }
							send_buf.append("<?xml version = \"1.0\" encoding=\"UTF-8\"?>");
							send_buf.append("<TaxInvoice xmlns=\"urn:kr:or:kec:standard:Tax:ReusableAggregateBusinessInformationEntitySchemaModule:1:0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"urn:kr:or:kec:standard:Tax:ReusableAggregateBusinessInformationEntitySchemaModule:1:0 http://www.kec.or.kr/standard/Tax/TaxInvoiceSchemaModule_1.0.xsd\">");
							send_buf.append("<ExchangedDocument>");
							send_buf.append("<IssueDateTime>");
							send_buf.append(yymmdd); //전자세금계산서 작성일자
							send_buf.append("</IssueDateTime>");
							send_buf.append("</ExchangedDocument>");
							send_buf.append("<TaxInvoiceDocument>");
							send_buf.append("<IssueID>"); 
							send_buf.append(issueId);  //세금계산서 승인번호 발행일자(8자리)+발행시스템고유번호(41000008 (고정값))+시퀀스(5자리)+업체코드(fhv (고정값)) ->스마트빌요청
							send_buf.append("</IssueID>	");
							send_buf.append("<TypeCode>");
							send_buf.append(str[26]); //전자세금계산서 종류 구분자 세금계산서 분류(2자리) : 01(세금계산서), 02(수정세금계산서), 03(계산서), 04(수정계산서)/세금계산서 종류(2자리) : 01(일반), 02(영세율), 03(일반 위수탁), 04(수입), 05(영세율 위수탁)
							send_buf.append("</TypeCode>");
							send_buf.append("<DescriptionText>"); 
							send_buf.append(str[29]);//비고
							send_buf.append("</DescriptionText>");
							send_buf.append("<IssueDateTime>"); 
							send_buf.append(str[28]); //전자세금계산서 작성일자
							send_buf.append("</IssueDateTime>");
							if(_st_gbn2.equals("M")){ //수정일경우
								send_buf.append("<AmendmentStatusCode>");
								send_buf.append(str[33]); //수정사유
								send_buf.append("</AmendmentStatusCode>");
								send_buf.append("<PurposeCode>");
								send_buf.append(str[23]); //세금계산서의 영수/청구 구분 지시자 01 : 영수, 02 : 청구
								send_buf.append("</PurposeCode>");
								send_buf.append("<OriginalIssueID>");
								send_buf.append(str[34]); //당초국세청전송번호.
								send_buf.append("</OriginalIssueID>");
							}else{
								send_buf.append("<PurposeCode>");
								send_buf.append(str[23]); //세금계산서의 영수/청구 구분 지시자 01 : 영수, 02 : 청구
								send_buf.append("</PurposeCode>");
							}
							send_buf.append("</TaxInvoiceDocument>");
							send_buf.append("<TaxInvoiceTradeSettlement>");//공급받는자 정보 셋팅
							send_buf.append("<InvoicerParty>"); //공급자 정보
							send_buf.append("<ID>"); 
							send_buf.append(str[0]);//공급자 사업자등록번호
							send_buf.append("</ID>");
							send_buf.append("<TypeCode>");
							send_buf.append(str[1]); //공급업체의 업태 텍스트
							send_buf.append("</TypeCode>");
							send_buf.append("<NameText>");
							send_buf.append(str[2]); //공급업체 사업체명
							send_buf.append("</NameText>");
							send_buf.append("<ClassificationCode>");
							send_buf.append(str[3]); //공급업체의 업종
							send_buf.append("</ClassificationCode>");
							send_buf.append("<SpecifiedPerson>");
							send_buf.append("<NameText>");
							send_buf.append(str[4]); //공급업체 대표자명
							send_buf.append("</NameText>	");
							send_buf.append("</SpecifiedPerson>");
							if(str[30].length() > 0 && _st_gbn3.equals("B")){
								send_buf.append("<SpecifiedOrganization>");
								send_buf.append("<TaxRegistrationID>");
								send_buf.append(str[30]);//종사업자번호
								send_buf.append("</TaxRegistrationID>");
								send_buf.append("</SpecifiedOrganization>");
							}
							send_buf.append("<DefinedContact>");
							send_buf.append("<DepartmentNameText />"); //공급업체 담당부서
							send_buf.append("<PersonNameText>"); 
							send_buf.append(str[5]); //공급업체 담당자명
							send_buf.append("</PersonNameText>");
							send_buf.append("<TelephoneCommunication>");
							send_buf.append(str[6]); //공급업체 담당자 전화번호
							send_buf.append("</TelephoneCommunication>");
							send_buf.append("<URICommunication>");
							send_buf.append(str[7]);//공급업체 담당자 이메일
							send_buf.append("</URICommunication>");
							send_buf.append("</DefinedContact>");
							send_buf.append("<SpecifiedAddress>");
							send_buf.append("<LineOneText>");
							send_buf.append(str[8]);//공급업체의 주소
							send_buf.append("</LineOneText>");
							send_buf.append("</SpecifiedAddress>");
							send_buf.append("</InvoicerParty>"); //공급자 정보
							send_buf.append("<InvoiceeParty>"); //공급받는자
							send_buf.append("<ID>"); 
							send_buf.append(str[9]);///공급받는자 사업자등록번호
							send_buf.append("</ID>");
							send_buf.append("<TypeCode>");
							send_buf.append(str[10]); ////공급받는자의 업태 텍스트
							send_buf.append("</TypeCode>");
							send_buf.append("<NameText>");
							send_buf.append(str[11]); //공급받는자 사업체명
							send_buf.append("</NameText>	");
							send_buf.append("<ClassificationCode>");
							send_buf.append(str[12]); //공급받는자의 업종
							send_buf.append("</ClassificationCode>");							
							send_buf.append("<SpecifiedOrganization>");
							if(str[30].length() > 0&& _st_gbn3.equals("A")){
								send_buf.append("<TaxRegistrationID>");
								send_buf.append(str[30]);//종사업자번호
								send_buf.append("</TaxRegistrationID>");
							}
							send_buf.append("<BusinessTypeCode>");
							send_buf.append("01");//01 : 사업자등록번호, 02 : 주민등록번호, 03 : 외국인
							send_buf.append("</BusinessTypeCode>");
							send_buf.append("</SpecifiedOrganization>");
							send_buf.append("<SpecifiedPerson>");
							send_buf.append("<NameText>");
							send_buf.append(str[13]); //공급받는대표자명
							send_buf.append("</NameText>	");
							send_buf.append("</SpecifiedPerson>");
							send_buf.append("<PrimaryDefinedContact>");
							send_buf.append("<DepartmentNameText/>");
							send_buf.append("<PersonNameText>");
							send_buf.append(str[14]); //공급받는 담당자명
							send_buf.append("</PersonNameText>");
							send_buf.append("<TelephoneCommunication>");
							send_buf.append(str[15]); //공급받는자 담당자 전화번호
							send_buf.append("</TelephoneCommunication>");
							send_buf.append("<URICommunication>");
							send_buf.append(str[16]); //공급받는자 담당자 이메일
							send_buf.append("</URICommunication>");
							send_buf.append("</PrimaryDefinedContact>");
							send_buf.append("<SpecifiedAddress>");
							send_buf.append("<LineOneText>");
							send_buf.append(str[17]); //공급받는자 주소
							send_buf.append("</LineOneText>");
							send_buf.append("</SpecifiedAddress>");
							send_buf.append("</InvoiceeParty>"); //공급받는자
							send_buf.append("<SpecifiedMonetarySummation>");
							send_buf.append("<ChargeTotalAmount>");
							send_buf.append(str[18]);//총 공급가액 합계
							send_buf.append("</ChargeTotalAmount>");
							send_buf.append("<TaxTotalAmount>");
							send_buf.append(str[19]);//총 세액 합계
							send_buf.append("</TaxTotalAmount>");
							send_buf.append("<GrandTotalAmount>");
							send_buf.append(str[25]);//총액(공급가액+세액)
							send_buf.append("</GrandTotalAmount>");
							send_buf.append("</SpecifiedMonetarySummation>");
							send_buf.append("</TaxInvoiceTradeSettlement>");
							LOGGER.debug("list.size() : {}", list.size());
						    if(list.size() > 0){
								for(int z=0; z<list.size(); z++){
									Map<String,String> mp = (Map<String,String>)list.get(z);
									//DTI 입력
									send_buf.append("<TaxInvoiceTradeLineItem>");
									send_buf.append("<SequenceNumeric>");
									send_buf.append(z+1);
									send_buf.append("</SequenceNumeric>");
									send_buf.append("<DescriptionText>");
									send_buf.append( mp.get("REMARK_DESCRIPTION"));
									send_buf.append("</DescriptionText>");
									send_buf.append("<InvoiceAmount>");
									send_buf.append(mp.get("SUPP_PRICE"));//물품 공급 가액
									send_buf.append("</InvoiceAmount>");
									send_buf.append("<ChargeableUnitQuantity>");
									send_buf.append(mp.get("REMARK_QTY"));
									send_buf.append("</ChargeableUnitQuantity>");
									send_buf.append("<InformationText>");
									send_buf.append(mp.get("REMARK_DESCRIPTION"));
									send_buf.append("</InformationText>");
									send_buf.append("<NameText>");
									send_buf.append(mp.get("REMARK_DESCRIPTION"));
									send_buf.append("</NameText>");
									send_buf.append("<PurchaseExpiryDateTime>");
									send_buf.append(yymmdd.substring(0, 8));								
									send_buf.append("</PurchaseExpiryDateTime>");
									send_buf.append("<TotalTax>");
									send_buf.append("<CalculatedAmount>");
									send_buf.append(mp.get("TAX_PRICE"));//물품 공급 가액
									send_buf.append("</CalculatedAmount>");
									send_buf.append("</TotalTax>");
									send_buf.append("<UnitPrice>");
									send_buf.append("<UnitAmount>");
									send_buf.append(mp.get("SUPP_PRICE"));//물품 공급 가액
									send_buf.append("</UnitAmount>");
									send_buf.append("</UnitPrice>");
									send_buf.append("</TaxInvoiceTradeLineItem>");
								}
						    }else{
								
								send_buf.append("<TaxInvoiceTradeLineItem>");
								send_buf.append("<SequenceNumeric>");
								send_buf.append("1");
								send_buf.append("</SequenceNumeric>");
								send_buf.append("<DescriptionText>");
								send_buf.append("MRO품목");
								send_buf.append("</DescriptionText>");
								send_buf.append("<InvoiceAmount>");
								send_buf.append(str[18]);//물품 공급 가액
								send_buf.append("</InvoiceAmount>");
								send_buf.append("<ChargeableUnitQuantity>");
								send_buf.append("1");
								send_buf.append("</ChargeableUnitQuantity>");
								send_buf.append("<InformationText>");
								send_buf.append("MRO품목");
								send_buf.append("</InformationText>");
								send_buf.append("<NameText>");
								send_buf.append("MRO품목");
								send_buf.append("</NameText>");
								send_buf.append("<PurchaseExpiryDateTime>");
								send_buf.append(yymmdd.substring(0, 8));								
								send_buf.append("</PurchaseExpiryDateTime>");
								send_buf.append("<TotalTax>");
								send_buf.append("<CalculatedAmount>");
								send_buf.append(str[19]);//물품 공급 가액
								send_buf.append("</CalculatedAmount>");
								send_buf.append("</TotalTax>");
								send_buf.append("<UnitPrice>");
								send_buf.append("<UnitAmount>");
								send_buf.append(str[18]);//물품 공급 가액
								send_buf.append("</UnitAmount>");
								send_buf.append("</UnitPrice>");
								send_buf.append("</TaxInvoiceTradeLineItem>");

						    }
							
							send_buf.append("</TaxInvoice>							\n");
							 send = send_buf.toString();
							 send = AesCryptoAlgorithmUtil.URLUTF8Encoder_encode(send);
							 //xxdbmain insert
							 //취소가아닐경우
							if(!_st_gbn.equals("O")){
							    if(list.size() > 0){
									for(int k=0; k<list.size(); k++){
										Map<String,String> mp = (Map<String,String>)list.get(k);
										//DTI 입력
										_dataDetailParam = new HashMap<String,String>() ;
										_dataDetailParam.put("CONVERSATION_ID", conId); 	
										_dataDetailParam.put("SUPBUY_TYPE", str[20]);
										_dataDetailParam.put("DIRECTION", str[21]);
										_dataDetailParam.put("ITEM_NAME", CommonUtil.nvl(mp.get("REMARK_DESCRIPTION"),""));
										_dataDetailParam.put("ITEM_QTY", CommonUtil.nvl(mp.get("REMARK_QTY"),""));
										_dataDetailParam.put("SUP_AMOUNT", CommonUtil.nvl(mp.get("SUPP_PRICE"),""));
										_dataDetailParam.put("TAX_AMOUNT", CommonUtil.nvl(mp.get("TAX_PRICE"),""));
										_dataDetailParam.put("CREATED_BY", _st_user_id);
										
										sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBDtiItem", _dataDetailParam);
									}
							    }else{
									//DTI 입력
									_dataDetailParam = new HashMap<String,String>() ;
									_dataDetailParam.put("CONVERSATION_ID", conId); 	
									_dataDetailParam.put("SUPBUY_TYPE", str[20]);
									_dataDetailParam.put("DIRECTION", str[21]);
									_dataDetailParam.put("ITEM_NAME", "MRO품목");
									_dataDetailParam.put("ITEM_QTY", "1");
									_dataDetailParam.put("SUP_AMOUNT", str[18]);
									_dataDetailParam.put("TAX_AMOUNT", str[19]);
									_dataDetailParam.put("CREATED_BY", _st_user_id);
									
									sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBDtiItem", _dataDetailParam);
							    }
	
							 }
						 }
					 }

					certPassword = AesCryptoAlgorithmUtil.Encrypt("koreab2b", "sBcertNonStd");
					if(_st_gbn2.equals("R")){
						//취소일경우
						//STATUS 입력
						//sqlSessionTemplate.insert("master.cmcl.updateMasterCmClSBStatus", _dataParam);
						//MAIN상태 업데이트
						//sqlSessionTemplate.insert("master.cmcl.updateMasterCmClDelSBSMain", _dataParam);
					}else if(_st_gbn2.equals("M")){//수정계산서
						//MAIN 당초계산서 삭제
						sqlSessionTemplate.insert("master.cmcl.updateMasterCmClDelSBSMainOld", _dataParam);
						//MAIN 입력
						sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBDtimain", _dataParam);
						//STATUS 입력
						sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBStatus", _dataParam);						
				 	}else{
						//MAIN 입력
						sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBDtimain", _dataParam);
						//STATUS 입력
						sqlSessionTemplate.insert("master.cmcl.insertMasterCmClSBStatus", _dataParam);

					}
					String st_signal = "";
					String st_status_signal = "";
					if(_st_gbn .equals("O")){//취소
						//A정발행 B역발행
						if(_st_gbn3.equals("A")){
							st_signal = "CHGSTATUS";
							st_status_signal = "CANCELALL";
						}else{//역발행
							st_signal = "CHGSTATUS";
							st_status_signal = "CANCELRREQUEST";		
						}
					}else if(_st_gbn .equals("V")){ //역발행
						st_signal = "RDETAILREQUEST";
					}else{ //정발행
						st_signal = "ARISSUE";
					}
					//(공급자사업자번호(10자리)+공급받는자사업자번호(10자리)+현재날짜(8자리)+시퀀스(4자리)+시스템구분코드(3자리고정값 006) -> 시스템구분코드 006은 고정값
					JSONObject jsonObj		= new JSONObject();
					/*jsonObj.put("MessageId", AesCryptoAlgorithmUtil.URLUTF8Encoder_encode( _dataParam.get("SEQ_ID"))); // 트랜잭션 식별자 ,AR,AP번호
					jsonObj.put("Signal", AesCryptoAlgorithmUtil.URLUTF8Encoder_encode(st_signal)); // 트랜잭션 식별자 고정
					jsonObj.put("RequestTime",  AesCryptoAlgorithmUtil.URLUTF8Encoder_encode(yymmdd)); //yyyymmddhh24miss
					jsonObj.put("SendComRegno", AesCryptoAlgorithmUtil.URLUTF8Encoder_encode( _dataParam.get("SUP_COM_REGNO"))); //공급자 사업번호
					jsonObj.put("ReceiveComRegno", AesCryptoAlgorithmUtil.URLUTF8Encoder_encode( _dataParam.get("BYR_COM_REGNO"))); //공급받는자 사업번호
					jsonObj.put("AuthToken",AesCryptoAlgorithmUtil.URLUTF8Encoder_encode(_authtoken)); //인증토큰
					jsonObj.put("ServiceCode",AesCryptoAlgorithmUtil.URLUTF8Encoder_encode("DTI")); //서비스코드 고정
					jsonObj.put("SystemType", AesCryptoAlgorithmUtil.URLUTF8Encoder_encode("OAPI")); //시스템타입
					jsonObj.put("ConversationId", AesCryptoAlgorithmUtil.URLUTF8Encoder_encodeA(conId)); //스마트빌 식별자(35자리) //(공급자사업자번호(10자리)+공급받는자사업자번호(10자리)+현재날짜(8자리)+시퀀스(4자리)+시스템구분코드(3자리고정값 006) -> 시스템구분코드 006은 고정값
					jsonObj.put("SMTPEmail", ""); //유통용 이메일 주소(옵션)
					jsonObj.put("RValue", ""); //신원확인값 공백?
					jsonObj.put("CertPassword", AesCryptoAlgorithmUtil.URLUTF8Encoder_encode(certPassword)); //공인인증서 패스워드
					if(_st_gbn .equals("O")){//취소
						jsonObj.put("StatusSignal",AesCryptoAlgorithmUtil.URLUTF8Encoder_encode(st_status_signal)); //서명정보가 있는 세금계산서
						jsonObj.put("StatusReason",""); //서명정보가 있는 세금계산서
						jsonObj.put("SignedXML",AesCryptoAlgorithmUtil.URLUTF8Encoder_encode(send)); //서명정보가 있는 세금계산서
						jsonObj.put("UnSignedXML",AesCryptoAlgorithmUtil.URLUTF8Encoder_encode(send)); //서명정보가 있는 세금계산서
					}else{
						jsonObj.put("SignedXML",AesCryptoAlgorithmUtil.URLUTF8Encoder_encode(send)); //서명정보가 있는 세금계산서						
					}*/
			  		String[] aConId = new String[1];
			  		aConId[0] =conId;
					jsonObj.put("MessageId",  _dataParam.get("SEQ_ID")); // 트랜잭션 식별자 ,AR,AP번호
					jsonObj.put("Signal", st_signal); // 트랜잭션 식별자 고정
					jsonObj.put("RequestTime",  yymmdd); //yyyymmddhh24miss
					jsonObj.put("SendComRegno",  _dataParam.get("SUP_COM_REGNO")); //공급자 사업번호
					jsonObj.put("ReceiveComRegno", _dataParam.get("BYR_COM_REGNO")); //공급받는자 사업번호
					jsonObj.put("AuthToken",_authtoken); //인증토큰
					jsonObj.put("ServiceCode", "DTI"); //서비스코드 고정
					jsonObj.put("SystemType", "OAPI"); //시스템타입
					jsonObj.put("ConversationId", aConId); //스마트빌 식별자(35자리) //(공급자사업자번호(10자리)+공급받는자사업자번호(10자리)+현재날짜(8자리)+시퀀스(4자리)+시스템구분코드(3자리고정값 006) -> 시스템구분코드 006은 고정값
					jsonObj.put("SMTPEmail", ""); //유통용 이메일 주소(옵션)
					jsonObj.put("RValue", ""); //신원확인값 공백?
					jsonObj.put("CertPassword", certPassword); //공인인증서 패스워드
					if(_st_gbn .equals("O")){//취소
						jsonObj.put("StatusSignal", st_status_signal); //서명정보가 있는 세금계산서
						jsonObj.put("StatusReason",""); //서명정보가 있는 세금계산서
						jsonObj.put("SignedXML", send); //서명정보가 있는 세금계산서
						jsonObj.put("UnSignedXML", send); //서명정보가 있는 세금계산서
					}else{
						jsonObj.put("SignedXML", send); //서명정보가 있는 세금계산서						
					}
					LOGGER.debug("send : {}", send);
					LOGGER.debug("certPassword : {}", certPassword);
					LOGGER.debug("MessageId : {}", _dataParam.get("SEQ_ID"));
					LOGGER.debug("Signal : {}", st_signal);
					LOGGER.debug("RequestTime : {}", yymmdd);
					LOGGER.debug("SendComRegno : {}", _dataParam.get("SUP_COM_REGNO"));
					LOGGER.debug("ReceiveComRegno : {}", _dataParam.get("BYR_COM_REGNO"));
					LOGGER.debug("AuthToken : {}", _authtoken);
					LOGGER.debug("ConversationId : {}", conId);
					LOGGER.debug("StatusSignal : {}", st_status_signal);
					
					URL url = new URL("http://demoapi.smartbill.co.kr/sb-api/request/");
					HttpURLConnection conn = (HttpURLConnection) url.openConnection();
					conn.setRequestMethod("POST");
					conn.setUseCaches(false);
					conn.setDoInput(true);
					conn.setDoOutput(true);
					conn.setConnectTimeout(10000);
					conn.setRequestProperty("Content-Type", "application/json");
					conn.setRequestProperty("Accept", "application/json");
					DataOutputStream os = new DataOutputStream(conn.getOutputStream());
					os.write(jsonObj.toString().getBytes());
					os.flush();
					os.close();
					
					BufferedReader br;

					String response = "";
					if(null != conn){
						br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
						String line = null;
						while((line = br.readLine()) != null){
							LOGGER.debug("line : {}", "==============================="+line);
							response += line + "\n";
						}
					}
					
		            JSONParser jsonParser = new JSONParser();
		             
		            JSONObject jsonResponse = (JSONObject) jsonParser.parse(response);

					if("30000".equalsIgnoreCase((String)jsonResponse.get("ResultCode"))){
						LOGGER.debug("30000 : {}", "===============================");
					}else{
						_dataParam.put("st_error_code",(String)jsonResponse.get("ResultCode"));
						_dataParam.put("st_error_msg", (String)jsonResponse.get("ResultMessage"));
						_dataParam.put("st_ca_id", conId);
						_dataParam.put("st_s_user_id", _st_user_id);
						sqlSessionTemplate.update("master.cmcl.saveXXSBDtiStatusInfo", _dataParam);
					}

				 }
			} catch(Exception e) {
				//throw new RuntimeException("세금계산서 전송에 실패하였습니다.");
				throw new RuntimeException(e);
			}
		

		return data;
	}
	public String nextVal(String cmpyId, String buyerId, String docType, String IssueDate)
	{
		String returnValue = null;
		String yyyymmdd = null;
		String yyyymmdd1 = null;
		String ConId = null;
		Map<String, String>  pMap = new HashMap<String, String>();
		
		try {
				if(docType.equals("CON")){
				 	yyyymmdd1 = sqlSessionTemplate.selectOne("master.cmcl.getYyyymmdd", "");
				 	yyyymmdd = yyyymmdd1.substring(0, 8);
				 	LOGGER.debug("채번 - yyyymmdd : ", yyyymmdd);
				 	//조건
				 	ConId = cmpyId+buyerId+yyyymmdd;
					pMap.put("CON_ID", ConId);
					returnValue = sqlSessionTemplate.selectOne("master.cmcl.getConversationId", pMap);
				
					if (returnValue == null || "".equals(returnValue) ||  returnValue.isEmpty()){ 
						returnValue = cmpyId+buyerId+yyyymmdd + "0001"+"006";
					} else {
						returnValue = cmpyId+buyerId+yyyymmdd + returnValue+"006";
					}
				}else if(docType.equals("ISSUE_ID")){
					//세금계산서 승인번호 발행일자(8자리)+발행시스템고유번호(41000008 (고정값))+시퀀스(5자리)+업체코드(fhv (고정값)) ->스마트빌요청
				 	yyyymmdd1 = sqlSessionTemplate.selectOne("master.cmcl.getYyyymmdd", "");
				 	//yyyymmdd = yyyymmdd1.substring(0, 8);
				 	yyyymmdd = IssueDate;
				 	//조건
				 	ConId = yyyymmdd+"41000008";
					pMap.put("CON_ID", ConId);
					returnValue = sqlSessionTemplate.selectOne("master.cmcl.getIssueId", pMap);
					if (returnValue == null || "".equals(returnValue) ||  returnValue.isEmpty()){
						returnValue = ConId + "00001fhv";
					}else{
						returnValue = ConId + returnValue+"fhv";
					}
				}
				LOGGER.debug("채번 - returnValue : ", returnValue);
			
		} catch (Exception e){
			LOGGER.debug("채번 Exception : ", e);
			throw new RuntimeException( "채번 취득에 실패하였습니다.");
		} finally {
			
		}
		return returnValue;
	}
	
	public List<Map<String,String>> selectMasterCmClsendApRMailPop(Map<String,String> formData) {

		List<Map<String, String>> data = new ArrayList<Map<String, String>>();

		String _st_ap_no = formData.get("param1").toString();
		String _st_recv_mail = formData.get("param2").toString();
		String _st_recv_user_name = formData.get("param3").toString();
		String _st_smartBillUrl = formData.get("smartBillUrl").toString();
		String _rtnMsg = "";

		Map<String, String> map =  new HashMap<String, String>();
		
		List<Map<String,String>> list = null;
		
		Map<String,String> _dataParam = null;
		
		try {
			_dataParam = new HashMap<String,String>() ;
			_dataParam.put("AP_NO", _st_ap_no);
			
			list = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClApRMailSend", _dataParam);
			
			if(list.size() > 0){
				Map<String,String> mp = (Map<String,String>)list.get(0);
				map.put("CON_ID", CommonUtil.nvl(mp.get("CONVERSATION_ID"),""));
				map.put("REQUEST_TIME", CommonUtil.nvl(mp.get("TODAY_DATE"),""));
				map.put("ISSUE_ID", CommonUtil.nvl(mp.get("ISSUE_ID"),""));
				map.put("SEQ_ID", CommonUtil.nvl(mp.get("SEQ_ID"),""));
				map.put("BYR_IRS_NO", CommonUtil.nvl(mp.get("BYR_IRS_NO"),""));
				map.put("SMARTBILL_URL",_st_smartBillUrl);
			}
			
			_dataParam.put("TAX_BILL_NO", _st_ap_no);
			_dataParam.put("RECV_EMAIL", _st_recv_mail);
			_dataParam.put("RECV_USER_NAME", _st_recv_user_name);
			sqlSessionTemplate.update("master.cmcl.rsendApMailMasterCmClPurchaseTaxsheetIssueReg", _dataParam);
			
			_rtnMsg  ="OK";
			map.put("RTN_MSG",_rtnMsg);
			data.add(0, map);

		} catch(Exception e) {
			_rtnMsg = "ERR";
			throw new RuntimeException("역발행 메일 전송에 실패하였습니다."+e);
		}

		return data;
	}
}
