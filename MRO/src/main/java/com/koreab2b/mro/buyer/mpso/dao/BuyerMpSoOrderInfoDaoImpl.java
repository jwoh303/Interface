package com.koreab2b.mro.buyer.mpso.dao;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringReader;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.cert.X509Certificate;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.activation.FileDataSource;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.axis.utils.ByteArrayOutputStream;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.koreab2b.mro.rfc.coway.controller.SapManager;
import com.koreab2b.mro.rfc.coway.controller.SapManager.SapRfcFunction;
import com.koreab2b.mro.rfc.coway.dao.BuyerCowayRfcDao;
import com.koreab2b.mro.util.AES256Cipher;
import com.koreab2b.mro.util.CommonAwsS3;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.MailSmsUtil;
import com.koreab2b.mro.webservice.coway.Service1Soap;
import com.koreab2b.mro.webservice.coway.WebservicePropsBean;
import com.koreab2b.mro.webservice.dongwha.COMMON.COMMON11.COMMON11_MRO_REQ;
import com.koreab2b.mro.webservice.dongwha.COMMON.COMMON11.COMMON11_MRO_REQ_SOProxy;
import com.koreab2b.mro.webservice.dongwha.COMMON.COMMON11.COMMON11_MRO_RESP;
import com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016.M2KEP0001M2016Proxy;
import com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016.T_APPR_LINE_OUT_STEP;
import com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016.T_APPR_OUT_STEP;
import com.koreab2b.mro.webservice.hanwha.approval.ws.service.M2KEP0001M2016.WsApAttachFile;
import com.koreab2b.mro.webservice.hwdefense.WSKP001WebServiceProxy;
import com.org.json.JSONArray;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import com.sap.conn.jco.ext.DestinationDataProvider;


@Repository("buyerMpSoOrderInfoDao")
@Transactional
public class BuyerMpSoOrderInfoDaoImpl implements BuyerMpSoOrderInfoDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoOrderInfoDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Autowired
	Service1Soap cowayService1SoapProxyid;

	@Autowired
	BuyerCowayRfcDao buyerCowayRfcDao;
	
	@Autowired 
	WebservicePropsBean webservicePropsBean;

	/**
	 * 결재유형 - 기안자
	 */
	public final static String MAN_SEND = "0";
	/**
	 * 결재유형 - 결재자
	 */
	public final static String MAN_PASS = "1"; 
	/**
	 * 결재유형 - 참조자
	 */
	public final static String MAN_REFER = "2"; 
	/**
	 * 결재유형 - 합의자
	 */
	public final static String MAN_AGREE = "3"; 
	/**
	 * 결재상태 - 임시 저장
	 */
	public final static String STATUS_TEMP = "9";
	/**
	 * 결재상태 - 결재중
	 */
	public final static String STATUS_PING = "0";
	/**
	 * 결재상태 - 반려
	 */
	public final static String STATUS_RET = "1";
	/**
	 * 결재상태 - 참조진행
	 */
	public final static String STATUS_RING = "2";
	/**
	 * 결재상태 - 결재완료
	 */
	public final static String STATUS_COMP = "3";
	/**
	 * 결재종류 - 기안
	 */
	public final static String KIND_SEND = "0";
	/**
	 * 결재종류 - 결재
	 */
	public final static String KIND_PASS = "1";
	/**
	 * 결재종류 - 참조
	 */
	public final static String KIND_REFER = "2";
	/**
	 * 결재종류 - 반려
	 */
	public final static String KIND_RET = "3";
	/**
	 * 전자결재문서
	 */
	public final static String DOC_TYPE = "GW";
	/**
	 * 임시보관함 번호
	 */
	public final static int TEMP_FOLDER_CD = 0;
	/**
	 * 임시보관함 이름
	 */
	public final static String TEMP_FOLDER_NM = "임시보관함";
	/**
	 * 없음
	 */
	public final static String NOTHING = "없음";
	/**
	 * 키 분리자
	 */
	public final static String KEY_DELIMITER = "|";

	public static final String localUploadPath = "C:/kepFileUplad"; // 로컬 파일업로드 대상
	public static final String realUploadPath = "attfiles"; // 개발,리얼 파일업로드 대상 

	/**
	 * 조회
	 */
	public List<Map<String, String>> selectList(Map<String, String> formData) {
		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);
		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
		if (_list.size() > 0) {
			data.put("st_query_cart_array", _list);
		}

		/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	
		
		String st_query_cart_tmp = formData.get("st_query_cart");
		String st_query_cart_tmp_list[] = st_query_cart_tmp.split("@@");		
		String st_query_cart_seq = "";
		data.put("st_seqYn", "N");
		
		if (st_query_cart_tmp_list != null) {
			
			// ICOMCART.SEQ 구분자 : &&
			for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
				String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
				
				for( int k=0; k < str.length; k++){
					LOGGER.debug("str["+k+"] ==>" + str[k]);
                } 
		        
				LOGGER.debug("str.length ==>" + str.length);
				
				// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
		        if (str != null && str.length == 2){
		        	data.put("st_cart_seq", str[1]);
					data.put("st_seqYn", "Y");
					st_query_cart_seq += str[0] + str[1] + "@@";
		        }else{ // 없으면 원문 그대로
		        	st_query_cart_seq = st_query_cart_tmp;
		        }
			}
			
			_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
			
			LOGGER.debug("_list ==>" + _list );
			
			data.put("st_query_cart_array", _list);
		}

		/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */	
		
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerShoppingCartOrderListConfirmList2", data);
	}
	public List<Map<String, String>> selectList_v2(Map<String, String> formData) {
		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);
		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
		if (_list.size() > 0) {
			data.put("st_query_cart_array", _list);
		}

		/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	
		
		String st_query_cart_tmp = formData.get("st_query_cart");
		String st_query_cart_tmp_list[] = st_query_cart_tmp.split("@@");		
		String st_query_cart_seq = "";
		data.put("st_seqYn", "N");
		
		if (st_query_cart_tmp_list != null) {
			
			// ICOMCART.SEQ 구분자 : &&
			for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
				String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
				
				for( int k=0; k < str.length; k++){
					LOGGER.debug("str["+k+"] ==>" + str[k]);
                } 
		        
				LOGGER.debug("str.length ==>" + str.length);
				
				// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
		        if (str != null && str.length == 2){
		        	data.put("st_cart_seq", str[1]);
					data.put("st_seqYn", "Y");
					st_query_cart_seq += str[0] + str[1] + "@@";
		        }else{ // 없으면 원문 그대로
		        	st_query_cart_seq = st_query_cart_tmp;
		        }
			}
			
			_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
			
			LOGGER.debug("_list ==>" + _list );
			
			data.put("st_query_cart_array", _list);
		}

		/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */	
		
		return sqlSessionTemplate.selectList("buyer.mpso.getBuyerShoppingCartOrderListConfirmList2_v2", data);
	}
	public List<Map<String, String>> getOrderInfo_v2(Map<String, String> formData) {
		
		return sqlSessionTemplate.selectList("buyer.mpso.getOrderInfo_v2", formData);
	}
	
	public List<Map<String, String>> getPasslnInfo_v2(Map<String, String> formData) {
		
		String docu_no = sqlSessionTemplate.selectOne("buyer.mpso.getDocuNo_v2", formData);
		formData.put("docu_no", docu_no);
		return sqlSessionTemplate.selectList("buyer.mpso.getPasslnInfo_v2", formData);
	}
	
	

	/**
	 * 선입고발주 제외대상 업체 조회
	 */
	public String getNotPreGoodsCompany(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("buyer.mpso.getNotPreGoodsCompany", formData);
	}

	public String createBuyerNewCreateBenit(Map<String, String> formData) {
		try {
			Map<String, Object> data = new HashMap<String, Object>();
			List<String> _list = new ArrayList<String>();

			data.putAll(formData);
			_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
			if (_list.size() > 0) {
				data.put("st_query_cart_array", _list);
			}

			/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	

			String st_query_cart_temp = formData.get("st_query_cart");
			String st_query_cart_tmp_list[] = st_query_cart_temp.split("@@");		
			String st_query_cart_seq = "";
			data.put("st_seqYn", "N");

			if (st_query_cart_tmp_list != null) {
				
				// ICOMCART.SEQ 구분자 : &&
				for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
					String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
					
					for( int k=0; k < str.length; k++){
						LOGGER.debug("str["+k+"] ==>" + str[k]);
			} 
				
					LOGGER.debug("str.length ==>" + str.length);
					
					// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
				if (str != null && str.length == 2){
					data.put("st_cart_seq", str[1]);
						data.put("st_seqYn", "Y");
						st_query_cart_seq += str[0] + str[1] + "@@";
				}else{ // 없으면 원문 그대로
					st_query_cart_seq = st_query_cart_temp;
				}
				}
				
				_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
				
				LOGGER.debug("_list ==>" + _list );
				
				data.put("st_query_cart_array", _list);
			}

			/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */
			
			String cnt = sqlSessionTemplate.selectOne("buyer.mpso.selectICOMCARTCheck", data);
			if ("0".equals(cnt)) {
				return "DUP"; // 이미진행된 상태로 리턴후 화면에 메시지 출력한다.....
			}

			LOGGER.debug("createBuyerNewCreateBenit - formData : {}  ", formData.get("st_query_cart"));
			LOGGER.debug("createBuyerNewCreateBenit - formData : {}  ", formData.get("st_query_cart_date"));

			String st_query_cart_date_tmp[] = null;
			String st_query_cart_date = formData.get("st_query_cart_date");
			String st_query_cart_tmp[] = st_query_cart_date.split("@@");

			if (st_query_cart_date == null || "".equals(st_query_cart_date)) {
				LOGGER.debug("createBuyerNewCreateOrder - st_query_cart_date XXXXXXXXXXX  ");
				sqlSessionTemplate.insert("buyer.mpso.insertSetNewCreateBenitOrder", data);
				
			} else {
				if (st_query_cart_tmp != null) {
					for (int i = 0; i < st_query_cart_tmp.length; i++) {
						st_query_cart_date_tmp = st_query_cart_tmp[i].split("\\|");
						data.put("st_recv_date2", st_query_cart_date_tmp[1]);
						data.put("st_query_cart_array", "");
						data.put("st_query_cart_array2", st_query_cart_date_tmp[0]);
						sqlSessionTemplate.insert("buyer.mpso.insertSetNewCreateBenitOrder", data);
					}
				}
			}
			data.put("st_query_cart_array", _list);
			data.put("st_query_cart_array2", "");
			sqlSessionTemplate.delete("buyer.mpso.deleteSetNewCreateBenitOrder", data);

		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException();
		}

		return "OK";
	}

	/**
	 * setNewCreatePrPoOrder
	 */
	public String createBuyerNewCreateOrder(Map<String, String> formData) {
		String result = "";
		Map<String, String> ht = new HashMap<String, String>();
		Map<String, String> gwht = new HashMap<String, String>();
		String com_code = formData.get("comCode").toString();
		String person_author = formData.get("st_person_author").toString();
		String GW_NO = formData.get("GW_NO").toString();
		String buyer = formData.get("buyer").toString();
		String budget_flag = formData.get("budget_flag").toString();
		String st_recv_date2 = formData.get("st_recv_date2").toString();
		// 상조용품 관계
		String ref_pr_no = CommonUtil.nvl((String) formData.get("st_ref_pr_no"), "");
		// 상조용품 인수자정보
		String st_mg_note = CommonUtil.nvl((String) formData.get("st_mg_note"), "");

		String card_cd = CommonUtil.nvl((String) formData.get("card_cd"), "");
		String card_name = CommonUtil.nvl((String) formData.get("card_name"), "");
		String tno = CommonUtil.nvl((String) formData.get("tno"), "");
		String amount = CommonUtil.nvl((String) formData.get("amount"), "");

		if ("".equals(card_cd)) {
			formData.put("cardPayYn", "N");
		} else {
			formData.put("cardPayYn", "Y");
		}

		String cardPayYn = CommonUtil.nvl((String) formData.get("cardPayYn"), "");
		String sPR_No = null;
		String sRecvFlag = "";
		StringBuilder po_str = new StringBuilder();
		Map<String, Object> data = new HashMap<String, Object>();

		LOGGER.debug("createBuyerNewCreateOrder - card_cd : {} ", card_cd);
		LOGGER.debug("createBuyerNewCreateOrder - card_name : {} ", card_name);
		LOGGER.debug("createBuyerNewCreateOrder - tno : {} ", tno);
		LOGGER.debug("createBuyerNewCreateOrder - amount : {} ", amount);
		LOGGER.debug("createBuyerNewCreateOrder - cardPayYn : {} ", cardPayYn);

		try {
			List<String> _list = new ArrayList<String>();
			_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
			if (_list != null) {
				if (_list.size() > 0) {
					data.put("st_query_cart_array", _list);
				}
			}

			data.put("buyer", formData.get("buyer"));
			data.put("userid", formData.get("userid"));

			/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	

			String st_query_cart_tmp = formData.get("st_query_cart");
			String st_query_cart_tmp_list[] = st_query_cart_tmp.split("@@");		
			String st_query_cart_seq = "";
			String st_seqYn = "N";
			
			data.put("st_seqYn", st_seqYn);

			if (st_query_cart_tmp_list != null) {
				
				// ICOMCART.SEQ 구분자 : &&
				for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
					String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
					
					for( int k=0; k < str.length; k++){
						LOGGER.debug("str["+k+"] ==>" + str[k]);
					} 
				
					LOGGER.debug("str.length ==>" + str.length);
					
					// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
					if (str != null && str.length == 2){
						data.put("st_cart_seq", str[1]);
						st_seqYn = "Y";
						data.put("st_seqYn", st_seqYn);
						st_query_cart_seq += str[0] + str[1] + "@@";
					}else{ // 없으면 원문 그대로
						st_query_cart_seq = st_query_cart_tmp;
					}
				}
				
				_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
				
				LOGGER.debug("_list ==>" + _list );
				
				data.put("st_query_cart_array", _list);
			}

			/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */
			String cnt = sqlSessionTemplate.selectOne("buyer.mpso.selectICOMCARTCheck", data);
			if ("0".equals(cnt)) {
				return "DUP"; // 이미진행된 상태로 리턴후 화면에 메시지 출력한다.....
			}
			/* 재고관리 고객사 재고초과 되었을 경우 주문 불가능 처리 */
			String cntStcok = sqlSessionTemplate.selectOne("buyer.mpso.selectICOMCARTStockCheck", data);
			if (!"0".equals(cntStcok)) {
				return "OVER_STOCK"; // 재고초과건 주문 불가능
			}
			if (formData.get("st_query_cart") == null) {
				formData.put("st_query_cart", "");
			} else {
				LOGGER.debug(formData.get("st_query_cart"));
			}

			String st_query_cart = st_query_cart_seq;
			String[] item_array = st_query_cart.split("@@", -1);
			int iRecordCnt = 0;

			if (item_array != null) {
				iRecordCnt = item_array.length;
			}

			sPR_No = getOrderNo(com_code, "PR");

			LOGGER.debug("createBuyerNewCreateOrder - sPR_No : {} ", sPR_No);
			LOGGER.debug("createBuyerNewCreateOrder - formData : {}  ", formData);
			LOGGER.debug(" - ref_pr_no : {}  ", ref_pr_no);
			LOGGER.debug("createBuyerNewCreateOrder - st_mg_note : {}  ", st_mg_note);
			LOGGER.debug("createBuyerNewCreateOrder - st_recv_date2 : {}  ", st_recv_date2);
			LOGGER.debug("createBuyerNewCreateOrder - budget_flag : {}  ", budget_flag);

			// 경동보일러는 모두 직발주
			if (!com_code.equals("KRBOIL0002") && !com_code.equals("KRKDBO0001") && !com_code.equals("KRKDBO0002")
					&& !com_code.equals("KRKDPR0001")) {
				// if(!com_code.equals("GROUPWARE")){

				if (!"PO".equals(person_author)) {
					if (!"N".equals(GW_NO)) { // 결재처리한 경우 GW_NO ==> GW01000003 결재문서 번호가 넘어옴 , 미처리시 GW_NO = 'N'

						ht.put("KEY_1", sPR_No);
						gwht = setPassBase(GW_NO, com_code, ht, "PR", formData);
						sRecvFlag = "GS"; // 결재중
					} else
						sRecvFlag = "GA"; // 발주대기
				}

			}
			LOGGER.debug("createBuyerNewCreateOrder - sRecvFlag : {}  ", sRecvFlag);
			LOGGER.debug("createBuyerNewCreateOrder - gwht : {}  ", gwht);

			formData.put("st_seqYn", st_seqYn);
			formData.put("sRecvFlag", sRecvFlag);
			formData.put("sPR_No", sPR_No);

			LOGGER.debug("createBuyerNewCreateOrder - iRecordCnt : {}  ", iRecordCnt);

			String st_recv_date2_tmp = "";

			for (int i = 0; i < iRecordCnt; i++) {

				if (!"".equals(item_array[i])) {
					formData.put("ITEM_ARRAY", item_array[i]);
					formData.put("PR_SEQ", String.valueOf(i + 1));
					LOGGER.debug("createBuyerNewCreateOrder - formData : {}  ", formData.get("st_query_cart_date"));

					if (formData.get("st_query_cart_date") == null || "".equals(formData.get("st_query_cart_date"))) {
						LOGGER.debug("createBuyerNewCreateOrder - st_query_cart_date XXXXXXXXXXX  ");
					} else {
						LOGGER.debug("createBuyerNewCreateOrder - formData : {}  ", formData.get("st_query_cart_date"));
						LOGGER.debug("createBuyerNewCreateOrder - ITEM_ARRAY : {}  ", item_array[i]);
						st_recv_date2_tmp = getDateArray(formData.get("st_query_cart_date"), item_array[i]);
						st_recv_date2 = st_recv_date2_tmp;
						formData.put("st_recv_date2", st_recv_date2);
					}

					LOGGER.debug("createBuyerNewCreateOrder - st_recv_date2 : {}  ", st_recv_date2);
					LOGGER.debug("createBuyerNewCreateOrder - formData : {}  ", formData);
					// 구매요청
					sqlSessionTemplate.insert("buyer.mpso.insertIcomprdt", formData);
					//재고관리 고객사 재고 차감 로직 추가
					sqlSessionTemplate.insert("buyer.mpso.updateWmStStock", formData);
					po_str.append(sPR_No + "~~~" + CommonUtil.lpad(String.valueOf(i + 1), 6, '0') + "~~~" + "0" + "~~~"
							+ " " + "~~~" + " " + "~~~" + st_recv_date2 + "~~~" + " " + "~~~" + "@@");
					// COWAY_BUDGET_ACTUAL 코웨이 SAP데이터 인서트
					// SLOGIC-BEGIN(P06-0000036)
					// 코웨이일경우
					String p060000036 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000036", "COL03_DATA"); // 권한특수로직
					if ("COWAY".equals(p060000036)) {
						if (budget_flag.equals("Y")) {
							sqlSessionTemplate.insert("buyer.mpso.insertCowayBudgetActual", formData);
						}
						if("/mpso/getBuyerMpSoCartCowayClcsList.do?upperId=b00000000000&leftMenu=N".equals(CommonUtil.getSpecialCheckReturn(buyer, "P06-0000036", "COL05_DATA")))
							sqlSessionTemplate.insert("buyer.mpso.updatePrdtReqUserId", formData);
					}// SLOGIC-END
				}
			}

			String st_user_id = formData.get("userid").toString();
			String st_user_dept = formData.get("st_user_dept").toString();
			String tel_no = formData.get("st_tel_no").toString();
			String user_name = formData.get("st_user_name").toString();
			String po_create_date = formData.get("st_po_create_date").toString();
			String gr_flag = formData.get("st_gr_flag").toString();
			String account_type = formData.get("st_account_type").toString();

			po_str.append("|");
			po_str.append(com_code); // 구매사
			po_str.append("|");
			po_str.append(st_user_id); // 요청자
			po_str.append("|");
			po_str.append(st_user_dept); // 요청자 부서
			po_str.append("|");
			po_str.append("1"); // 1로 넘김 ==> 발주
			po_str.append("|");
			po_str.append(tel_no); // 요청자 전화번호
			po_str.append("|");
			po_str.append(user_name); // 요청자 이름
			po_str.append("|");
			po_str.append(GW_NO); // 결재 여부 Y(결재) , N(미결재)
			po_str.append("|");
			po_str.append(po_create_date); // 발주일자
			po_str.append("|");
			po_str.append(gr_flag); // 선입고 여부 Y(선입고) , N(발주)
			po_str.append("|");
			po_str.append("0"); // 0 으로 넘김
			po_str.append("|");
			po_str.append("PXPO"); // PXPO 으로 넘김
			po_str.append("|");
			po_str.append(account_type); // ACCOUNT_TYPE
			po_str.append("|");
			po_str.append(st_user_dept); // 요청자 부서
			po_str.append("|");

			LOGGER.debug("createBuyerNewCreateOrder - po_str : {}  ", po_str);

			data.putAll(formData);
			if (_list != null) {
				if (_list.size() > 0) {
					data.put("st_query_cart_array", _list);
				}
			}
			
			// 선입고, 긴급발주 선택 시 특이사항 앞에 문구 추가(금호석유화학 그룹)
			Map<String, String> bca00001_map	= CommonUtil.getSpecialCheckReturnMap(com_code,"BCA00001");
			if(bca00001_map != null) {
				if(gr_flag.equals("S")) { // 선입고
					data.put("st_remark", bca00001_map.get("COL01_DATA") + data.get("st_remark"));
				} else if(gr_flag.equals("F")) { // 긴급발주
					data.put("st_remark", bca00001_map.get("COL02_DATA") + data.get("st_remark"));
				}
			}
			
			// 구매요청
			sqlSessionTemplate.insert("buyer.mpso.insertIcomprhd", data);
			// 장바구니 삭제
			sqlSessionTemplate.insert("buyer.mpso.deleteIcomcart", data);

			/* 트리거 ICOMPRHD_TRG , PRHDSMS_TRG start 
			SAVE_FLAG PR
			String V_CNT = "";
			List<Map<String,String>> _list_email = null;
			List<Map<String,String>> _list_email2 = null;
			if ("GA".equals(sRecvFlag) && !"KRCONV0001".equals(com_code)){
				_list_email = sqlSessionTemplate.selectList("buyer.mpso.ICOMPRHD_TRG3",data);
				V_CNT = CommonUtil.getListKeyValue(_list_email, "V_CNT", "");
				if ("0".equals(V_CNT)){
					Map<String, String> _email_data = new HashMap<String, String>();
					_email_data.put("MAILFORM_ID", "DO_PR_MB");
					_list_email2 = sqlSessionTemplate.selectList("buyer.mpso.get_mail_MAIL_PODT_TRG_MAILSETM",_email_data);
					if (_list_email != null){
						if (_list_email.size()>0){
							Map<String, String> _map_email2 = _list_email.get(0);
						}
					}
				}
			}
			List<Map<String,String>> _list_sms = null;
			List<Map<String,String>> _list_sms2 = null;
			List<Map<String,String>> _list_sms3 = null;
			if ("GA".equals(sRecvFlag) && "KRCONV0001".equals(com_code)){
				Map<String, String> _sms_data = new HashMap<String, String>();
				_sms_data.put("DOC_NAME", "SMSSEND");
				_sms_data.put("TARGET", com_code);
				_sms_data.put("KEY_1", "PR");
				_sms_data.put("KEY_2", sPR_No);
				_sms_data.put("KEY_3", " ");
				_sms_data.put("KEY_4", " ");
				_sms_data.put("KEY_5", " ");
				_sms_data.put("KEY_6", " ");
				_sms_data.put("KEY_7", " ");
				_sms_data.put("KEY_8", " ");
				_sms_data.put("KEY_9", " ");
				_sms_data.put("KEY_10", " ");
				_list_sms = sqlSessionTemplate.selectList("buyer.mpso.get_sms_ICOMTRXL",_sms_data);
				V_CNT = CommonUtil.getListKeyValue(_list_sms, "V_CNT", "");
			}
			_list_sms2 = sqlSessionTemplate.selectList("buyer.mpso.PRHDSMS_TRG2",data);
			V_CNT = CommonUtil.getListKeyValue(_list_sms2, "V_CNT", "");
			if ("PS".equals(sRecvFlag) && "1".equals(V_CNT)){
				Map<String, String> _sms_data = new HashMap<String, String>();
				_sms_data.put("DOC_NAME", "APPROVAL");
				_sms_data.put("TARGET", com_code);
				_sms_data.put("KEY_1", sPR_No);
				_sms_data.put("KEY_2", " ");
				_sms_data.put("KEY_3", " ");
				_sms_data.put("KEY_4", " ");
				_sms_data.put("KEY_5", " ");
				_sms_data.put("KEY_6", " ");
				_sms_data.put("KEY_7", " ");
				_sms_data.put("KEY_8", " ");
				_sms_data.put("KEY_9", " ");
				_sms_data.put("KEY_10", " ");
				_list_sms = sqlSessionTemplate.selectList("buyer.mpso.get_sms_ICOMTRXL",_sms_data);
				V_CNT = CommonUtil.getListKeyValue(_list_sms, "V_CNT", "");
			}
			 트리거 ICOMPRHD_TRG , PRHDSMS_TRG end */

			// 부서별 예산관리
			// SLOGIC-BEGIN(P06-0000036)
			// 코웨이일경우
			String p060000036 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000036", "COL03_DATA"); // 권한특수로직
			if ("COWAY".equals(p060000036)) {
				sqlSessionTemplate.insert("buyer.mpso.getTempBdgtUpdate1", formData);
			} else {
				sqlSessionTemplate.insert("buyer.mpso.getTempBdgtUpdate2", formData);
			}
			// SLOGIC-END
			
			formData.put("st_query", po_str.toString());

			/* ODS 코웨이 변경 */
			if ("KRCOWA0003".equals(com_code) || "KRCOWA0008".equals(com_code)) {
				getCowayPointChk(com_code, sPR_No, st_user_id);
			}
			LOGGER.debug("createBuyerNewCreateOrder - person_author : {}  ", person_author);
			// 직발주
			if ("PO".equals(person_author)) {
				result = insertMergePxPo(formData);
			}
			// 구매요청
			if (!"PO".equals(person_author)) {
				result = sPR_No;
			}
			
			// 특수로직 추가
			// 결재 상신 후 결재정보 인터페이스 테이블에 등록처리. P11-0000004
			// 고객사 요청으로 결재정보를 넘겨줄 경우 이 방법을 사용함.
			boolean p110000004 = CommonUtil.getSpecialCheckReturn(buyer,"P11-0000004"); // 권한특수로직
			
			// 결재 후처리 타입 
			String st_type	= null;
			try {
				st_type = CommonUtil.getSpecialCheckReturn(buyer, "P11-0000004", "COL01_DATA");
			} catch (Exception e) {
				st_type	= "X";
			}
			
			if (p110000004) {
				if ("TYPE01".equals(st_type)) {
					// 한화테크윈
					insertIFAppInfo(formData);
				} else if ("TYPE05".equals(st_type)) {
					// 한화디펜스
					insertIFAppInfoTYPE05(formData);
				} else if ("TYPE02".equals(st_type)) {
					// 우진기전
					insertIFAppHeaderInfo(formData);
				} else if ("TYPE03".equals(st_type)) {
					// 영풍if 추가.
					Map<String, String> ypRtn = ypRfcPrCreateCall(formData);
					result += ":" + ypRtn.get("ERR_MSG") + ":" + ypRtn.get("CALL_URL").replaceAll("http://", "");
				} else if ("TYPE06".equals(st_type)) {
					// 환인제약
					result += ":" + insertIFAppInfoTYPE06(formData).replaceAll("http://", "");	
					System.out.println("result : "+result);
				} else if ("TYPE08".equals(st_type)) {
					
					//PX 번호 채번 
					insertIFAppInfoTYPE07(formData);
					
					
					Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(buyer, "P11-0000004");
					String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
					
					URL url = new URL(st_url);
					HttpsURLConnection con = (HttpsURLConnection)url.openConnection();
					
					
					con.setRequestMethod("POST");
					con.setRequestProperty("Content-Type", "application/json; utf-8");
					con.setRequestProperty("Accept", "application/json;");
					con.setDoOutput(true);
					con.connect();
					
					List<Map<String,String>> Applist =  SelectHanLimAppList(formData);
					
					LOGGER.info("Applist.toString() : " + Applist.toString());
					
					JSONObject jsonlist = new JSONObject();
					JSONArray jsonarray = new JSONArray();
					
					for( Map<String,String> iMap : Applist) {
						
						JSONObject json = new JSONObject();
						
						if(iMap.get("GD_CD") == null || iMap.get("GD_CD_MRO") == null) {

							TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
							LOGGER.info("품목정보가 없습니다.");
							throw new Exception("품목정보가 없습니다.");
							
						}
						
						json.put("po_req_no", iMap.get("PO_REQ_NO"));
						json.put("gd_cd_mro", iMap.get("GD_CD_MRO"));
						json.put("po_req_seq", Integer.parseInt(String.valueOf(iMap.get("PO_REQ_SEQ"))));
						json.put("gd_cd", iMap.get("GD_CD"));
						json.put("gd_nm", iMap.get("GD_NM"));
						json.put("jejosa", iMap.get("JEJOSA"));
						json.put("pn", iMap.get("PN"));
						json.put("spec", iMap.get("SPEC"));
						json.put("danga", Integer.parseInt(String.valueOf(iMap.get("DANGA"))));
						json.put("req_qty", Integer.parseInt(String.valueOf(iMap.get("REQ_QTY"))));
						json.put("req_date", iMap.get("REQ_DATE"));
						
						jsonarray.put(json);
					}

					jsonlist.put("data", jsonarray);
					
					String str = jsonlist.toString();
					
					str	= str.replaceAll("\"\\[\\{", "\\[\\{");
					str	= str.replaceAll("\\}\\]\"", "\\}\\]");
					str	= str.replaceAll("\"\\[null\\]\"", "\\[null\\]");
					str	= str.replaceAll("\\\\", "");
					
					try {
						OutputStream os = con.getOutputStream();
						byte[] input = str.getBytes("utf-8");
						os.write(input,0,input.length);
						
					}catch (Exception e) {
						LOGGER.info("input error");
						LOGGER.error("SQL ERROR : "+ e.getMessage());
						throw new Exception("input error~!");
					}
					
					try {
						BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
						StringBuilder response = new StringBuilder();
						String responseLine = null;
						while ((responseLine = br.readLine()) != null ) {
							response.append(responseLine.trim());
						}
						
						System.out.println("response : " + response);
						
						// 결재창 call
						
						JSONParser parser = new JSONParser(); 
						Object obj = parser.parse( response.toString()); 
						JSONObject jsonObj = (JSONObject) obj;

						if("success".equals((String)jsonObj.get("status")) && "".equals((String)jsonObj.get("description"))) {
							result += ":" + CallHanLimAppList(formData).replaceAll("https://", "");
						
						}else {
							LOGGER.info("hanlim status error : " + (String)jsonObj.get("status"));
							LOGGER.info("hanlim description error : " + (String)jsonObj.get("description"));
							
							throw new Exception("Fail!!");
						}
						
					}catch (Exception e) {
						LOGGER.info("output error");
						LOGGER.error("SQL ERROR : "+ e.getMessage());
						throw new Exception("output error!!!");
					}
					
				}
				else if ("TYPE09".equals(st_type)) {
					
					Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(buyer, "P11-0000004");
					String _endpoint = slgMap.get("COL03_DATA");
					// 동화 산업 결재 인터페이스 
					  
					  
					  List<Map<String,String>> Applist =  SelectDongWhaAppList(formData);
					  LOGGER.debug("Applist.toString() : " + Applist.toString());
					  
					  
					  String arr[] = new String[Applist.size()];
					  int prcnt = 0;
//					  String tol_amount = formData.get("nu_tot_price");
					  String tol_amount_tmp = formData.get("nu_tot_price");					  					  					   
				      BigDecimal bigDecimal = new BigDecimal(tol_amount_tmp);
				      long value = bigDecimal.longValue(); // 소수점 제거 (버림)
				      String tol_amount = new java.text.DecimalFormat("#,###").format(value); // 천단위 콤마 적용
					  
					  for(Map<String, String> iMap : Applist) {
						  arr[prcnt++] = iMap.get("PR_SEQ");
						  
						  if ("4".equals(iMap.get("MATNR").substring(0,1))) {
							  if (" ".equals(iMap.get("KOST")) || " ".equals(iMap.get("TXT20"))) {
								  LOGGER.info("errMsg : "+ " 품목코드  " + iMap.get("MATNR")+"은(는) 코스트 센터를 입력해야합니다.");
								  errMsg("TYPE"," 품목코드  " + iMap.get("MATNR")+"은(는) 코스트 센터를 입력해야합니다.");
							  } 
						  }
					  }
					  
					  String xmldata = getXml(Applist,tol_amount);
					  
					  LOGGER.info("xmldata : " + xmldata);

					  String IFKey = SelectDongWhaIFkey(formData);
					  String DONGWHA_pr_no = formData.get("sPR_No");
					  String DONGWHA_legacy_user_id	= formData.get("st_legacy_user_id").split("_")[0];
					  String TEAMCD					= formData.get("st_legacy_user_id").split("_")[1];
					  //KRDONG1107, KRDONG1108
					  String STYPE = "MM026";
					  String SUBCD = "0003";
					  String SBUKRS = "K100";
					  
					  if("KRDONG1109".equals(formData.get("buyer"))) {
						  STYPE = "MM019";
						  SUBCD = "0002";
						  SBUKRS = "KT00";
					  }else if("KRDAES0230".equals(formData.get("buyer"))) {                          
						  SBUKRS = "K400";
					  }else if("KRSUNR0004".equals(formData.get("buyer"))) {                          
						  SBUKRS = "KS00";
					  }
                      LOGGER.info("buyer : "+formData.get("buyer"));
					  LOGGER.info("IFKey : "+IFKey);
					  LOGGER.info("formData : " + formData);
					  LOGGER.info("DONGWHA_pr_no : " + DONGWHA_pr_no);
					  LOGGER.info("tol_amount : " + tol_amount);
					  LOGGER.info("TEAMCD : " + TEAMCD);
					  LOGGER.info("STYPE : " + STYPE);
					  LOGGER.info("SUBCD : " + SUBCD);
					  LOGGER.info("SBUKRS : " + SBUKRS);
					  
					  formData.put("DongWha_IFKEY",IFKey);
					  updatePRDT_DWHA(formData);
					  
					  COMMON11_MRO_REQ arrReq = new COMMON11_MRO_REQ(
							  IFKey ,
							  DONGWHA_pr_no,
							  arr,
							  TEAMCD,
							  DONGWHA_legacy_user_id,
							  xmldata,
							  STYPE,
							  SUBCD,
							  "KR",
							  "KO",
							  SBUKRS,
							  "KRW",
							  tol_amount,
							  " "
							  );
					  
					  LOGGER.info(" * DONGWHA Endpoint : " + _endpoint);
//					  LOGGER.info(" *** DEV *** " );
					  COMMON11_MRO_REQ_SOProxy proxy = new COMMON11_MRO_REQ_SOProxy( _endpoint );					  
					  COMMON11_MRO_RESP  arrres = proxy.COMMON11_MRO_REQ_SO(arrReq);					  
//					  LOGGER.info("arrres.getIFSTATUS() :  " + arrres.getIFSTATUS());
					  
					  String IFstatus = arrres.getIFSTATUS();
					  
					  if("S".equals(IFstatus)) {
						  
						  result += ":" + CallDongWhaAppList(formData,IFKey).replaceAll("http://", "");
						  LOGGER.info("result : " + result);
						  
					  }else {
						  
						  throw new Exception("TYPE09 - " + "동화산업 결재 오류 입니다.");
						  
					  }
				} else if ("TYPE10".equals(st_type) || "TYPE11".equals(st_type) || "TYPE14".equals(st_type)) {
					//큐라티스(TYPE10) & 홍익대학교(TYPE11)
					updateAppStatusPRDT(formData); // 주문 결재 중 -> 주문 중

					String Extern_buyer	= formData.get("st_buyer");
					String Extern_pr_no	= formData.get("sPR_No");
					
					result += ":" + Extern_buyer + ":" + Extern_pr_no;
						
				} else if ("TYPE12".equals(st_type)){
					//LNF && 제이에이치화학공업
					//PX 번호 채번 
					updateAppStatusPRDT(formData);
					
					result += ":" + CallLNFAppList(formData).replaceAll("http://", "");
					System.out.println("lnf_result = " + result );
				}
				  else if ("TYPE04".equals(st_type)) {
					// 롯데알미늄 2
//					System.out.println("** st_type : " + st_type);
					Map<String, String> pMap = new HashMap<String, String>();
					pMap.put("BUYER", buyer);
					pMap.put("PR_NO", result);
//					System.out.println("** BUYER / PR_NO : " + buyer + " / " + result);
					String xmlStr	= makeBuyerXmlData(pMap);
					String st_legacy_user_id	= formData.get("st_legacy_user_id");
					Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(buyer, "P11-0000004");
					String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
					String st_host	= CommonUtil.nvl(slgMap.get("COL03_DATA"));
					String st_mode	= CommonUtil.nvl(slgMap.get("COL04_DATA"));
					/* 재개발 2020-12-10 롯데알미늄과 테스트 필수. */
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

			        	for(int i = 0 ; i < ja.length() ; i++) {
			        		System.out.println("Item["+i+"] : " + ja.getString(i));
			        		if (!"OK".equals(ja.getString(0))) {
			        			System.out.println("LTAL PO APP ERR : " + ja.getString(1));
			        			throw new RuntimeException(ja.getString(1));
			        		} else {
				        		result += ":" + ja.getString(i).replaceAll("http://", "");	
			        		}
			        	}
			        }
			         /* */
				} else if ("TYPE07".equals(st_type)) {
					// 주문 생성 후 PX번호까지 채번하는 경우.
					insertIFAppInfoTYPE07(formData);
				} else if ("TYPE13".equals(st_type)) {
					String company_id = sqlSessionTemplate.selectOne("buyer.mpso.selectHanwhaCompany", formData);
					if ("410".equals(company_id) || "KRHANW0107".equals(buyer)) {	// 기계 - SAP연동 X
						formData.put("TYPE", "HANWHA_APP");
						try {
							sqlSessionTemplate.update("buyer.mpso.insertIfEvent", formData);
						} catch (Exception e) {
							LOGGER.error("HANWHA_APP["+company_id+"]: " + formData);
							e.printStackTrace();
						}
					} else if (!"X".equals(company_id))  {	// 방산/글로벌 - SAP 연동 O
						formData.put("TYPE", "HNWH_PO");
						try {
							LOGGER.debug("CheckData:" + formData);
							sqlSessionTemplate.update("buyer.mpso.insertHanwhaSapIfEvent", formData);
						} catch (Exception e) {
							LOGGER.error("HNWH_PO Error["+company_id+"]: " + e.getMessage());
							e.printStackTrace();
						}
						LOGGER.debug("insertHanwhaSapIfEvent Success.");
					} else {
						throw new RuntimeException("한화 회사정보 오류");
					}

					try {	// 한화 기본 결재선 구성 기능 확인.
						int apptCnt = sqlSessionTemplate.selectOne("buyer.mpso.selectHanwhaApptCnt", formData);
						LOGGER.info("selectHanwhaApptCnt Cnt["+apptCnt+"]");
						if (apptCnt == 0) {
							formData.put("SUBJECT", "기본결재선");
							sqlSessionTemplate.update("buyer.mpso.insertHanwhaAppt", formData);
							LOGGER.debug("insertHanwhaAppt Success.");
						}
						sqlSessionTemplate.update("buyer.mpso.deleteHanwhaApse", formData);
						LOGGER.debug("deleteHanwhaApse Success.");
						sqlSessionTemplate.update("buyer.mpso.insertHanwhaApse", formData);
						LOGGER.debug("insertHanwhaApse Success.");
					} catch (Exception e) {
						// TODO: handle exception
					}
				} else if ("TYPE15".equals(st_type)) {					
					//애경캐미칼
					insertIFAppInfoTYPE15(formData);
				} else if ("TYPE16".equals(st_type)){					
					// 한컴라이프케어
					// INSERT KEP_PO_HANCOM
					insertHanComPo(formData);
					result += ":" + CallHLCAppList(formData).replaceAll("https://", "");
					LOGGER.info("result = " + result);
				} else if ("TYPE17".equals(st_type)){					
					// KCTech
					// INSERT KEP_PO_KCTECH
					insertKCTechPo(formData);
					result += ":" + CallKCTAppList(formData).replaceAll("https://", "");
					LOGGER.info("result = " + result);
				}  else if ("TYPE18".equals(st_type)){
					try {
						insertIFAppInfoTYPE18(formData);
					} catch (Exception e) {
						LOGGER.error("HNWH TYPE18 " +  e.getMessage());
						e.printStackTrace();
						throw new RuntimeException("오류");
					}
				} else if ("TYPE19".equals(st_type)){					
					formData.put("TYPE", "HAERO_APP");
					try {
						sqlSessionTemplate.update("buyer.mpso.insertIfEvent", formData);
					} catch (Exception e) {
						LOGGER.error("HAERO_APP" + formData);
						e.printStackTrace();
						throw new RuntimeException("오류");
					}
				}else if ("TYPE20".equals(st_type)) {
					
					insertIFAppInfoTYPE20(formData);
					
				}else if ("TYPE22".equals(st_type)) {
					
					insertIFAppInfoTYPE22(formData);
					
				}else if ("TYPE23".equals(st_type)) {
					insertIFAppInfoTYPE23(formData);
				}
			}
		} catch (Exception e) {
			String errMsg = "주문 실패하였습니다.";
			e.printStackTrace();
			if(e.getMessage().contains("ypRfcPrCreateCall")){
				errMsg = errMsg + e.getMessage().replace("ypRfcPrCreateCall", "");
			} else if (e.getMessage().contains("TYPE")){
				errMsg = errMsg + e.getMessage().replace("TYPE", " ");
			} else if (e.getMessage().contains("NEXEAPICALL")){
				errMsg = errMsg + e.getMessage().replace("NEXEAPICALL", " ");
			} else if (e.getMessage().contains("HANSAPICALL")){
				errMsg = errMsg + e.getMessage().replace("HANSAPICALL", " ");
			}
			LOGGER.error("errMsg : [ "+errMsg+" ] ");
			LOGGER.error("SQL ERROR : "+ e.getMessage());
			
			throw new RuntimeException(errMsg);
		}
		
		return result;
	}
	
	

	public String createBuyerNewCreateOrder_v2(Map<String, String> formData) {
		String result = "";
		Map<String, String> ht = new HashMap<String, String>();
		Map<String, String> gwht = new HashMap<String, String>();
		String com_code = formData.get("comCode").toString();
		String person_author = formData.get("st_person_author").toString();
		String GW_NO = formData.get("GW_NO").toString();
		String buyer = formData.get("buyer").toString();
		String budget_flag = formData.get("budget_flag").toString();
		String st_recv_date2 = formData.get("st_recv_date2").toString();
		// 상조용품 관계
		String ref_pr_no = CommonUtil.nvl((String) formData.get("st_ref_pr_no"), "");
		// 상조용품 인수자정보
		String st_mg_note = CommonUtil.nvl((String) formData.get("st_mg_note"), "");

		String card_cd = CommonUtil.nvl((String) formData.get("card_cd"), "");
		String card_name = CommonUtil.nvl((String) formData.get("card_name"), "");
		String tno = CommonUtil.nvl((String) formData.get("tno"), "");
		String amount = CommonUtil.nvl((String) formData.get("amount"), "");

		if ("".equals(card_cd)) {
			formData.put("cardPayYn", "N");
		} else {
			formData.put("cardPayYn", "Y");
		}

		String cardPayYn = CommonUtil.nvl((String) formData.get("cardPayYn"), "");
		String sPR_No = null;
		String sRecvFlag = "";
		StringBuilder po_str = new StringBuilder();
		Map<String, Object> data = new HashMap<String, Object>();

		LOGGER.debug("createBuyerNewCreateOrder - card_cd : {} ", card_cd);
		LOGGER.debug("createBuyerNewCreateOrder - card_name : {} ", card_name);
		LOGGER.debug("createBuyerNewCreateOrder - tno : {} ", tno);
		LOGGER.debug("createBuyerNewCreateOrder - amount : {} ", amount);
		LOGGER.debug("createBuyerNewCreateOrder - cardPayYn : {} ", cardPayYn);

		try {
			List<String> _list = new ArrayList<String>();
			_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
			if (_list != null) {
				if (_list.size() > 0) {
					data.put("st_query_cart_array", _list);
				}
			}

			data.put("buyer", formData.get("buyer"));
			data.put("userid", formData.get("userid"));

			/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	

			String st_query_cart_tmp = formData.get("st_query_cart");
			String st_query_cart_tmp_list[] = st_query_cart_tmp.split("@@");		
			String st_query_cart_seq = "";
			String st_seqYn = "N";
			
			data.put("st_seqYn", st_seqYn);

			if (st_query_cart_tmp_list != null) {
				
				// ICOMCART.SEQ 구분자 : &&
				for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
					String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
					
					for( int k=0; k < str.length; k++){
						LOGGER.debug("str["+k+"] ==>" + str[k]);
					} 
				
					LOGGER.debug("str.length ==>" + str.length);
					
					// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
					if (str != null && str.length == 2){
						data.put("st_cart_seq", str[1]);
						st_seqYn = "Y";
						data.put("st_seqYn", st_seqYn);
						st_query_cart_seq += str[0] + str[1] + "@@";
					}else{ // 없으면 원문 그대로
						st_query_cart_seq = st_query_cart_tmp;
					}
				}
				
				_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
				
				LOGGER.debug("_list ==>" + _list );
				
				data.put("st_query_cart_array", _list);
			}

			/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */
			String cnt = sqlSessionTemplate.selectOne("buyer.mpso.selectICOMCARTCheck", data);
			if ("0".equals(cnt)) {
				return "DUP"; // 이미진행된 상태로 리턴후 화면에 메시지 출력한다.....
			}
			/* 재고관리 고객사 재고초과 되었을 경우 주문 불가능 처리 */
			String cntStcok = sqlSessionTemplate.selectOne("buyer.mpso.selectICOMCARTStockCheck", data);
			if (!"0".equals(cntStcok)) {
				return "OVER_STOCK"; // 재고초과건 주문 불가능
			}
			if (formData.get("st_query_cart") == null) {
				formData.put("st_query_cart", "");
			} else {
				LOGGER.debug(formData.get("st_query_cart"));
			}

			String st_query_cart = st_query_cart_seq;
			String[] item_array = st_query_cart.split("@@", -1);
			int iRecordCnt = 0;

			if (item_array != null) {
				iRecordCnt = item_array.length;
			}

			sPR_No = getOrderNo(com_code, "PR");

			LOGGER.debug("createBuyerNewCreateOrder - sPR_No : {} ", sPR_No);
			LOGGER.debug("createBuyerNewCreateOrder - formData : {}  ", formData);
			LOGGER.debug(" - ref_pr_no : {}  ", ref_pr_no);
			LOGGER.debug("createBuyerNewCreateOrder - st_mg_note : {}  ", st_mg_note);
			LOGGER.debug("createBuyerNewCreateOrder - st_recv_date2 : {}  ", st_recv_date2);
			LOGGER.debug("createBuyerNewCreateOrder - budget_flag : {}  ", budget_flag);

			if (!"PO".equals(person_author)) {
				if (!"N".equals(GW_NO)) { // 결재처리한 경우 GW_NO ==> GW01000003 결재문서 번호가 넘어옴 , 미처리시 GW_NO = 'N'

					ht.put("KEY_1", sPR_No);
					gwht = setPassBase(GW_NO, com_code, ht, "PR", formData);
					sRecvFlag = "GS"; // 결재중
				} else
					sRecvFlag = "GA"; // 발주대기
			}

			LOGGER.debug("createBuyerNewCreateOrder - sRecvFlag : {}  ", sRecvFlag);
			LOGGER.debug("createBuyerNewCreateOrder - gwht : {}  ", gwht);

			formData.put("st_seqYn", st_seqYn);
			formData.put("sRecvFlag", sRecvFlag);
			formData.put("sPR_No", sPR_No);

			LOGGER.debug("createBuyerNewCreateOrder - iRecordCnt : {}  ", iRecordCnt);

			String st_recv_date2_tmp = "";

			for (int i = 0; i < iRecordCnt; i++) {

				if (!"".equals(item_array[i])) {
					formData.put("ITEM_ARRAY", item_array[i]);
					formData.put("PR_SEQ", String.valueOf(i + 1));
					LOGGER.debug("createBuyerNewCreateOrder - formData : {}  ", formData.get("st_query_cart_date"));

					if (formData.get("st_query_cart_date") == null || "".equals(formData.get("st_query_cart_date"))) {
						LOGGER.debug("createBuyerNewCreateOrder - st_query_cart_date XXXXXXXXXXX  ");
					} else {
						LOGGER.debug("createBuyerNewCreateOrder - formData : {}  ", formData.get("st_query_cart_date"));
						LOGGER.debug("createBuyerNewCreateOrder - ITEM_ARRAY : {}  ", item_array[i]);
						st_recv_date2_tmp = getDateArray(formData.get("st_query_cart_date"), item_array[i]);
						st_recv_date2 = st_recv_date2_tmp;
						formData.put("st_recv_date2", st_recv_date2);
					}

					LOGGER.debug("createBuyerNewCreateOrder - st_recv_date2 : {}  ", st_recv_date2);
					LOGGER.debug("createBuyerNewCreateOrder - formData : {}  ", formData);
					// 구매요청
					sqlSessionTemplate.insert("buyer.mpso.insertIcomprdt_v2", formData);
					//재고관리 고객사 재고 차감 로직 추가
					sqlSessionTemplate.insert("buyer.mpso.updateWmStStock", formData);
					po_str.append(sPR_No + "~~~" + CommonUtil.lpad(String.valueOf(i + 1), 6, '0') + "~~~" + "0" + "~~~"
							+ " " + "~~~" + " " + "~~~" + st_recv_date2 + "~~~" + " " + "~~~" + "@@");
				}
			}
			String st_user_id = formData.get("userid").toString();
			String st_user_dept = formData.get("st_user_dept").toString();
			String tel_no = formData.get("st_tel_no").toString();
			String user_name = formData.get("st_user_name").toString();
			String po_create_date = formData.get("st_po_create_date").toString();
			String gr_flag = formData.get("st_gr_flag").toString();
			String account_type = formData.get("st_account_type").toString();
			po_str.append("|");
			po_str.append(com_code); // 구매사
			po_str.append("|");
			po_str.append(st_user_id); // 요청자
			po_str.append("|");
			po_str.append(st_user_dept); // 요청자 부서
			po_str.append("|");
			po_str.append("1"); // 1로 넘김 ==> 발주
			po_str.append("|");
			po_str.append(tel_no); // 요청자 전화번호
			po_str.append("|");
			po_str.append(user_name); // 요청자 이름
			po_str.append("|");
			po_str.append(GW_NO); // 결재 여부 Y(결재) , N(미결재)
			po_str.append("|");
			po_str.append(po_create_date); // 발주일자
			po_str.append("|");
			po_str.append(gr_flag); // 선입고 여부 Y(선입고) , N(발주)
			po_str.append("|");
			po_str.append("0"); // 0 으로 넘김
			po_str.append("|");
			po_str.append("PXPO"); // PXPO 으로 넘김
			po_str.append("|");
			po_str.append(account_type); // ACCOUNT_TYPE
			po_str.append("|");
			po_str.append(st_user_dept); // 요청자 부서
			po_str.append("|");

			LOGGER.debug("createBuyerNewCreateOrder - po_str : {}  ", po_str);

			data.putAll(formData);
			if (_list != null) {
				if (_list.size() > 0) {
					data.put("st_query_cart_array", _list);
				}
			}
			
			// 선입고, 긴급발주 선택 시 특이사항 앞에 문구 추가(금호석유화학 그룹)
			//따로 PRHD.DOC_TYPE_REMARK 로 관리함
//			Map<String, String> bca00001_map	= CommonUtil.getSpecialCheckReturnMap(com_code,"BCA00001");
//			if(bca00001_map != null) {
//				if(gr_flag.equals("S")) { // 선입고
//					data.put("st_remark", bca00001_map.get("COL01_DATA") + data.get("st_remark"));
//				} else if(gr_flag.equals("F")) { // 긴급발주
//					data.put("st_remark", bca00001_map.get("COL02_DATA") + data.get("st_remark"));
//				}
//			}
			
			// 구매요청
			sqlSessionTemplate.insert("buyer.mpso.insertIcomprhd_v2", data);
			// 장바구니 삭제
			sqlSessionTemplate.insert("buyer.mpso.deleteIcomcart", data);

			// 부서별 예산관리
			sqlSessionTemplate.insert("buyer.mpso.getTempBdgtUpdate2", formData);
			
			formData.put("st_query", po_str.toString());

			LOGGER.debug("createBuyerNewCreateOrder - person_author : {}  ", person_author);
			// 직발주
			if ("PO".equals(person_author)) {
				result = insertMergePxPo(formData);
			}
			// 구매요청
			if (!"PO".equals(person_author)) {
				result = sPR_No;
			}
			
			// 특수로직 추가
			// 결재 상신 후 결재정보 인터페이스 테이블에 등록처리. P11-0000004
			// 고객사 요청으로 결재정보를 넘겨줄 경우 이 방법을 사용함.
			boolean p110000004 = CommonUtil.getSpecialCheckReturn(buyer,"P11-0000004"); // 권한특수로직
			
			// 결재 후처리 타입 
			String st_type	= null;
			try {
				st_type = CommonUtil.getSpecialCheckReturn(buyer, "P11-0000004", "COL01_DATA");
			} catch (Exception e) {
				st_type	= "X";
			}
			
			if (p110000004) {
				if ("TYPE01".equals(st_type)) {
					// 한화테크윈
					insertIFAppInfo(formData);
				} else if ("TYPE05".equals(st_type)) {
					// 한화디펜스
					insertIFAppInfoTYPE05(formData);
				} else if ("TYPE02".equals(st_type)) {
					// 우진기전
					insertIFAppHeaderInfo(formData);
				} else if ("TYPE03".equals(st_type)) {
					// 영풍if 추가.
					Map<String, String> ypRtn = ypRfcPrCreateCall(formData);
					result += ":" + ypRtn.get("ERR_MSG") + ":" + ypRtn.get("CALL_URL").replaceAll("http://", "");
				} else if ("TYPE06".equals(st_type)) {
					// 환인제약
					result += ":" + insertIFAppInfoTYPE06(formData).replaceAll("http://", "");	
					System.out.println("result : "+result);
				} else if ("TYPE08".equals(st_type)) {
					
					//PX 번호 채번 
					insertIFAppInfoTYPE07(formData);
					
					
					Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(buyer, "P11-0000004");
					String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
					
					URL url = new URL(st_url);
					HttpsURLConnection con = (HttpsURLConnection)url.openConnection();
					
					
					con.setRequestMethod("POST");
					con.setRequestProperty("Content-Type", "application/json; utf-8");
					con.setRequestProperty("Accept", "application/json;");
					con.setDoOutput(true);
					con.connect();
					
					List<Map<String,String>> Applist =  SelectHanLimAppList(formData);
					
					LOGGER.info("Applist.toString() : " + Applist.toString());
					
					JSONObject jsonlist = new JSONObject();
					JSONArray jsonarray = new JSONArray();
					
					for( Map<String,String> iMap : Applist) {
						
						JSONObject json = new JSONObject();
						
						if(iMap.get("GD_CD") == null || iMap.get("GD_CD_MRO") == null) {

							TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
							LOGGER.info("품목정보가 없습니다.");
							throw new Exception("품목정보가 없습니다.");
							
						}
						
						json.put("po_req_no", iMap.get("PO_REQ_NO"));
						json.put("gd_cd_mro", iMap.get("GD_CD_MRO"));
						json.put("po_req_seq", Integer.parseInt(String.valueOf(iMap.get("PO_REQ_SEQ"))));
						json.put("gd_cd", iMap.get("GD_CD"));
						json.put("gd_nm", iMap.get("GD_NM"));
						json.put("jejosa", iMap.get("JEJOSA"));
						json.put("pn", iMap.get("PN"));
						json.put("spec", iMap.get("SPEC"));
						json.put("danga", Integer.parseInt(String.valueOf(iMap.get("DANGA"))));
						json.put("req_qty", Integer.parseInt(String.valueOf(iMap.get("REQ_QTY"))));
						json.put("req_date", iMap.get("REQ_DATE"));
						
						jsonarray.put(json);
					}

					jsonlist.put("data", jsonarray);
					
					String str = jsonlist.toString();
					
					str	= str.replaceAll("\"\\[\\{", "\\[\\{");
					str	= str.replaceAll("\\}\\]\"", "\\}\\]");
					str	= str.replaceAll("\"\\[null\\]\"", "\\[null\\]");
					str	= str.replaceAll("\\\\", "");
					
					try {
						OutputStream os = con.getOutputStream();
						byte[] input = str.getBytes("utf-8");
						os.write(input,0,input.length);
						
					}catch (Exception e) {
						LOGGER.info("input error");
						LOGGER.error("SQL ERROR : "+ e.getMessage());
						throw new Exception("input error~!");
					}
					
					try {
						BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
						StringBuilder response = new StringBuilder();
						String responseLine = null;
						while ((responseLine = br.readLine()) != null ) {
							response.append(responseLine.trim());
						}
						
						System.out.println("response : " + response);
						
						// 결재창 call
						
						JSONParser parser = new JSONParser(); 
						Object obj = parser.parse( response.toString()); 
						JSONObject jsonObj = (JSONObject) obj;

						if("success".equals((String)jsonObj.get("status")) && "".equals((String)jsonObj.get("description"))) {
							result += ":" + CallHanLimAppList(formData).replaceAll("https://", "");
						
						}else {
							LOGGER.info("hanlim status error : " + (String)jsonObj.get("status"));
							LOGGER.info("hanlim description error : " + (String)jsonObj.get("description"));
							
							throw new Exception("Fail!!");
						}
						
					}catch (Exception e) {
						LOGGER.info("output error");
						LOGGER.error("SQL ERROR : "+ e.getMessage());
						throw new Exception("output error!!!");
					}
					
				}
				else if ("TYPE09".equals(st_type)) {
					
					Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(buyer, "P11-0000004");
					String _endpoint = slgMap.get("COL03_DATA");
					// 동화 산업 결재 인터페이스 
					  
					  
					  List<Map<String,String>> Applist =  SelectDongWhaAppList(formData);
					  LOGGER.debug("Applist.toString() : " + Applist.toString());
					  
					  
					  String arr[] = new String[Applist.size()];
					  int prcnt = 0;
//					  String tol_amount = formData.get("nu_tot_price");
					  String tol_amount_tmp = formData.get("nu_tot_price");
					  BigDecimal bigDecimal = new BigDecimal(tol_amount_tmp);
					  long value = bigDecimal.longValue(); // 소수점 제거 (버림)
				      String tol_amount = new java.text.DecimalFormat("#,###").format(value); // 천단위 콤마 적용
					  
					  for(Map<String, String> iMap : Applist) {
						  arr[prcnt++] = iMap.get("PR_SEQ");
						  
						  if ("4".equals(iMap.get("MATNR").substring(0,1))) {
							  if (" ".equals(iMap.get("KOST")) || " ".equals(iMap.get("TXT20"))) {
								  LOGGER.info("errMsg : "+ " 품목코드  " + iMap.get("MATNR")+"은(는) 코스트 센터를 입력해야합니다.");
								  errMsg("TYPE"," 품목코드  " + iMap.get("MATNR")+"은(는) 코스트 센터를 입력해야합니다.");
							  } 
						  }
					  }
					  
					  String xmldata = getXml(Applist,tol_amount);
					  
					  LOGGER.info("xmldata : " + xmldata);

					  String IFKey = SelectDongWhaIFkey(formData);
					  String DONGWHA_pr_no = formData.get("sPR_No");
					  String DONGWHA_legacy_user_id	= formData.get("st_legacy_user_id").split("_")[0];
					  String TEAMCD					= formData.get("st_legacy_user_id").split("_")[1];
					  //KRDONG1107, KRDONG1108
					  String STYPE = "MM026";
					  String SUBCD = "0003";
					  String SBUKRS = "K100";
					  
					  if("KRDONG1109".equals(formData.get("buyer"))) {
						  STYPE = "MM019";
						  SUBCD = "0002";
						  SBUKRS = "KT00";
					  }else if("KRDAES0230".equals(formData.get("buyer"))) {                          
						  SBUKRS = "K400";
					  }else if("KRSUNR0004".equals(formData.get("buyer"))) {                          
						  SBUKRS = "KS00";
					  }
                      LOGGER.info("buyer : "+formData.get("buyer"));
					  LOGGER.info("IFKey : "+IFKey);
					  LOGGER.info("formData : " + formData);
					  LOGGER.info("DONGWHA_pr_no : " + DONGWHA_pr_no);
					  LOGGER.info("tol_amount : " + tol_amount);
					  LOGGER.info("TEAMCD : " + TEAMCD);
					  LOGGER.info("STYPE : " + STYPE);
					  LOGGER.info("SUBCD : " + SUBCD);
					  LOGGER.info("SBUKRS : " + SBUKRS);
					  
					  formData.put("DongWha_IFKEY",IFKey);
					  updatePRDT_DWHA(formData);
					  
					  COMMON11_MRO_REQ arrReq = new COMMON11_MRO_REQ(
							  IFKey ,
							  DONGWHA_pr_no,
							  arr,
							  TEAMCD,
							  DONGWHA_legacy_user_id,
							  xmldata,
							  STYPE,
							  SUBCD,
							  "KR",
							  "KO",
							  SBUKRS,
							  "KRW",
							  tol_amount,
							  " "
							  );
					  
					  LOGGER.info(" * DONGWHA Endpoint : " + _endpoint);
//					  LOGGER.info(" *** DEV *** " );
					  COMMON11_MRO_REQ_SOProxy proxy = new COMMON11_MRO_REQ_SOProxy( _endpoint );					  
					  COMMON11_MRO_RESP  arrres = proxy.COMMON11_MRO_REQ_SO(arrReq);					  
//					  LOGGER.info("arrres.getIFSTATUS() :  " + arrres.getIFSTATUS());
					  
					  String IFstatus = arrres.getIFSTATUS();
					  
					  if("S".equals(IFstatus)) {
						  
						  result += ":" + CallDongWhaAppList(formData,IFKey).replaceAll("http://", "");
						  LOGGER.info("result : " + result);
						  
					  }else {
						  
						  throw new Exception("TYPE09 - " + "동화산업 결재 오류 입니다.");
						  
					  }
				} else if ("TYPE10".equals(st_type) || "TYPE11".equals(st_type) || "TYPE14".equals(st_type)) {
					//큐라티스(TYPE10) & 홍익대학교(TYPE11)
					updateAppStatusPRDT(formData); // 주문 결재 중 -> 주문 중

					String Extern_buyer	= formData.get("st_buyer");
					String Extern_pr_no	= formData.get("sPR_No");
					
					result += ":" + Extern_buyer + ":" + Extern_pr_no;
						
				} else if ("TYPE12".equals(st_type)){
					//LNF && 제이에이치화학공업
					//PX 번호 채번 
					updateAppStatusPRDT(formData);
					
					result += ":" + CallLNFAppList(formData).replaceAll("http://", "");
					System.out.println("lnf_result = " + result );
				}
				  else if ("TYPE04".equals(st_type)) {
					// 롯데알미늄 2
//					System.out.println("** st_type : " + st_type);
					Map<String, String> pMap = new HashMap<String, String>();
					pMap.put("BUYER", buyer);
					pMap.put("PR_NO", result);
//					System.out.println("** BUYER / PR_NO : " + buyer + " / " + result);
					String xmlStr	= makeBuyerXmlData(pMap);
					String st_legacy_user_id	= formData.get("st_legacy_user_id");
					Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(buyer, "P11-0000004");
					String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
					String st_host	= CommonUtil.nvl(slgMap.get("COL03_DATA"));
					String st_mode	= CommonUtil.nvl(slgMap.get("COL04_DATA"));
					/* 재개발 2020-12-10 롯데알미늄과 테스트 필수. */
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

			        	for(int i = 0 ; i < ja.length() ; i++) {
			        		System.out.println("Item["+i+"] : " + ja.getString(i));
			        		if (!"OK".equals(ja.getString(0))) {
			        			System.out.println("LTAL PO APP ERR : " + ja.getString(1));
			        			throw new RuntimeException(ja.getString(1));
			        		} else {
				        		result += ":" + ja.getString(i).replaceAll("http://", "");	
			        		}
			        	}
			        }
			         /* */
				} else if ("TYPE07".equals(st_type)) {
					// 주문 생성 후 PX번호까지 채번하는 경우.
					insertIFAppInfoTYPE07(formData);
				} else if ("TYPE13".equals(st_type)) {
					String company_id = sqlSessionTemplate.selectOne("buyer.mpso.selectHanwhaCompany", formData);
					if ("410".equals(company_id) || "KRHANW0107".equals(buyer)) {	// 기계 - SAP연동 X
						formData.put("TYPE", "HANWHA_APP");
						try {
							sqlSessionTemplate.update("buyer.mpso.insertIfEvent", formData);
						} catch (Exception e) {
							LOGGER.error("HANWHA_APP["+company_id+"]: " + formData);
							e.printStackTrace();
						}
					} else if (!"X".equals(company_id))  {	// 방산/글로벌 - SAP 연동 O
						formData.put("TYPE", "HNWH_PO");
						try {
							LOGGER.debug("CheckData:" + formData);
							sqlSessionTemplate.update("buyer.mpso.insertHanwhaSapIfEvent", formData);
						} catch (Exception e) {
							LOGGER.error("HNWH_PO Error["+company_id+"]: " + e.getMessage());
							e.printStackTrace();
						}
						LOGGER.debug("insertHanwhaSapIfEvent Success.");
					} else {
						throw new RuntimeException("한화 회사정보 오류");
					}

					try {	// 한화 기본 결재선 구성 기능 확인.
						int apptCnt = sqlSessionTemplate.selectOne("buyer.mpso.selectHanwhaApptCnt", formData);
						LOGGER.info("selectHanwhaApptCnt Cnt["+apptCnt+"]");
						if (apptCnt == 0) {
							formData.put("SUBJECT", "기본결재선");
							sqlSessionTemplate.update("buyer.mpso.insertHanwhaAppt", formData);
							LOGGER.debug("insertHanwhaAppt Success.");
						}
						sqlSessionTemplate.update("buyer.mpso.deleteHanwhaApse", formData);
						LOGGER.debug("deleteHanwhaApse Success.");
						sqlSessionTemplate.update("buyer.mpso.insertHanwhaApse", formData);
						LOGGER.debug("insertHanwhaApse Success.");
					} catch (Exception e) {
						// TODO: handle exception
					}
				} else if ("TYPE15".equals(st_type)) {					
					//애경캐미칼
					insertIFAppInfoTYPE15(formData);
				} else if ("TYPE16".equals(st_type)){					
					// 한컴라이프케어
					// INSERT KEP_PO_HANCOM
					insertHanComPo(formData);
					result += ":" + CallHLCAppList(formData).replaceAll("https://", "");
					LOGGER.info("result = " + result);
				} else if ("TYPE17".equals(st_type)){					
					// KCTech
					// INSERT KEP_PO_KCTECH
					insertKCTechPo(formData);
					result += ":" + CallKCTAppList(formData).replaceAll("https://", "");
					LOGGER.info("result = " + result);
				}  else if ("TYPE18".equals(st_type)){
					try {
						insertIFAppInfoTYPE18(formData);
					} catch (Exception e) {
						LOGGER.error("HNWH TYPE18 " +  e.getMessage());
						e.printStackTrace();
						throw new RuntimeException("오류");
					}
				} else if ("TYPE19".equals(st_type)){					
					formData.put("TYPE", "HAERO_APP");
					try {
						sqlSessionTemplate.update("buyer.mpso.insertIfEvent", formData);
					} catch (Exception e) {
						LOGGER.error("HAERO_APP" + formData);
						e.printStackTrace();
						throw new RuntimeException("오류");
					}
				}else if ("TYPE20".equals(st_type)) {
					
					insertIFAppInfoTYPE20(formData);
					
				}else if ("TYPE22".equals(st_type)) {
					
					insertIFAppInfoTYPE22(formData);
					
				}else if ("TYPE23".equals(st_type)) {
					insertIFAppInfoTYPE23(formData);
				}
			}
		} catch (Exception e) {
			String errMsg = "주문 실패하였습니다.";
			e.printStackTrace();
			if(e.getMessage().contains("ypRfcPrCreateCall")){
				errMsg = errMsg + e.getMessage().replace("ypRfcPrCreateCall", "");
			} else if (e.getMessage().contains("TYPE")){
				errMsg = errMsg + e.getMessage().replace("TYPE", " ");
			} else if (e.getMessage().contains("NEXEAPICALL")){
				errMsg = errMsg + e.getMessage().replace("NEXEAPICALL", " ");
			} else if (e.getMessage().contains("HANSAPICALL")){
				errMsg = errMsg + e.getMessage().replace("HANSAPICALL", " ");
			}
			LOGGER.error("errMsg : [ "+errMsg+" ] ");
			LOGGER.error("SQL ERROR : "+ e.getMessage());
			
			throw new RuntimeException(errMsg);
		}
		
		return result;
	}
	

	public void insertIFAppInfoTYPE23(Map<String, String> formData) throws Exception{
		//한솔 홈 데코 품목 체크로직 
		List<Map<String, String>> HansPrList = sqlSessionTemplate.selectList("buyer.mpso.selectHansPrList", formData);
		
		int prSize = HansPrList.size();
		if(prSize > 0) {
			
			Map<String, String> resultMap = new HashMap<String, String>();
			org.json.simple.JSONArray ZKEP_PO = new org.json.simple.JSONArray();
			JSONObject jsonObj2 = new JSONObject();
			
			for (Map<String, String> prMap : HansPrList) {
				JSONObject jsonObj = new JSONObject();

				jsonObj.put("ZDOC_NUM",prMap.get("REF_NO"));
				jsonObj.put("ZDOC_SEQ",prMap.get("REF_SEQ"));
				jsonObj.put("MATNR",prMap.get("BUYER_ITEM_NO"));
				jsonObj.put("TXZ01",prMap.get("DESCRIPTION"));
				jsonObj.put("MENGE",prMap.get("TARGET_QTY"));
				jsonObj.put("MEINS",prMap.get("UNIT_MEASURE"));
				jsonObj.put("MATKL",prMap.get("SAP_CATEG_ID"));
				jsonObj.put("LGORT","7000"); //고정값
				
				//추가 계정지정범주, gl계정, 코스트센터, 저장품/포장비
				String key = String.valueOf(prMap.get("REF_PR_NO"));
				String[] hansArr =  key.split("\\^");
				
				if("K".equals(hansArr[2])) {
					jsonObj.put("SAKTO",hansArr[0]); //GL계정
					jsonObj.put("KOSTL",hansArr[1]); //코스트센터
					jsonObj.put("KNTTP","K"); //고정값
					jsonObj.put("IDNLF",""); //고정값
				}else if("X".equals(hansArr[2])) {
					jsonObj.put("SAKTO",hansArr[0]); //GL계정
					jsonObj.put("KOSTL",hansArr[1]); //코스트센터
					jsonObj.put("KNTTP","K"); //고정값
					jsonObj.put("IDNLF","포장비"); //고정값
				}else if("Z".equals(hansArr[2])) {
					jsonObj.put("SAKTO",""); //GL계정
					jsonObj.put("KOSTL",""); //코스트센터
					jsonObj.put("IDNLF","저장품"); //고정값
					jsonObj.put("KNTTP",""); //고정값
				}
				
				ZKEP_PO.add(jsonObj);
			}
			jsonObj2.put("IT_ITEM", ZKEP_PO);
			
			Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer"), "P11-0000004");
			String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
			
			URL url = new URL(st_url);
			HttpURLConnection httpUrlConn = (HttpURLConnection)url.openConnection();
			
			httpUrlConn.setRequestMethod("POST");
			httpUrlConn.setRequestProperty("Content-Type","application/json; charset=UTF-8");
			httpUrlConn.setDoOutput(true);
			httpUrlConn.setDoInput(true);
			httpUrlConn.setUseCaches(false);
			httpUrlConn.setConnectTimeout(10000); 
			httpUrlConn.setReadTimeout(10000);
			
			OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream(), "utf-8");
			wr.write(jsonObj2.toString());
			wr.flush();
			wr.close();
			
			int responseCode = httpUrlConn.getResponseCode();
			StringBuilder sb = new StringBuilder();
			
			if (responseCode == HttpURLConnection.HTTP_OK) {

				BufferedReader br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(),"utf-8"));
				String line;
				while ((line = br.readLine()) != null) {sb.append(line).append("\n");}
				br.close();
				
				httpUrlConn.disconnect();
				
				String flag = "";
				String errMsg = "";

				JSONParser parser = new JSONParser();
				
				LOGGER.info("Hansol Response : " + sb.toString());
				
				org.json.simple.JSONObject root =(org.json.simple.JSONObject) parser.parse(sb.toString());
				org.json.simple.JSONArray etReturn =(org.json.simple.JSONArray) root.get("ET_RETURN");
				
				
				for (Object obj : etReturn) {
				    org.json.simple.JSONObject item = (org.json.simple.JSONObject) obj;
				    String type = String.valueOf(item.get("TYPE"));
				    if ("E".equals(type)) {
				    	   if ("".equals(errMsg)) {
				               errMsg = "HANSAPICALL \n고객사SAP 오류 발생 하였습니다.\n";
				           }
				           errMsg += "[자재코드 - "
				                   + item.get("MATNR")
				                   + "] "
				                   + item.get("MESSAGE")
				                   + "\n";
				        };
				    }
				
				if (!"".equals(errMsg)) {
					LOGGER.info("hansol errMsg" + errMsg);
					throw new Exception(errMsg);
				}
				
				if("GROUPWARE".equals(formData.get("GW_NO"))) {
					formData.put("GW_FLAG", "N");
				}else {
					formData.put("GW_FLAG", "T");
				}
				sqlSessionTemplate.insert("buyer.mpso.insertHansPr", formData);
				
		} else {
				BufferedReader br =new BufferedReader(new InputStreamReader(httpUrlConn.getErrorStream(),"utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				httpUrlConn.disconnect();
				throw new Exception("HANSAPICALL \n한솔홈데코 SAP 오류 발생 하였습니다.");
			}
		}

	}

	public void insertIFAppInfoTYPE18(Map<String, String> formData) throws Exception {
		Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer").toString(), "P11-0000004");
		String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
		String formid	= CommonUtil.nvl(slgMap.get("COL03_DATA")); //501 사업장 구분 값
		String xmlns = CommonUtil.nvl(slgMap.get("COL04_DATA")); 
		
 		List<Map<String, String>> prList	= sqlSessionTemplate.selectList("buyer.mpso.selectAeroIFAppPrList", formData);
		Map<String, String> appData	= sqlSessionTemplate.selectOne("buyer.mpso.selectIFHanwAppInfo", formData);
		String st_server_mode	= formData.get("st_server_mode").toString();
		
		// 파일 첨부 처리용 변수 선언.
		InputStream is = null;
		BufferedInputStream bis = null;
		ByteArrayOutputStream arrayBuff = null;
		int MAX_BUF_BYTE	= 1024000;	// 1MB
		String osName = System.getProperty("os.name");	// 환경에 따른 설정을 변경하기 위함.
		
		//결재문서 생성
		StringBuffer contents	= new StringBuffer();
		
		contents.append("<pre align='center' style='font-size:30px'>");
		contents.append("MRO 구매결의");
		contents.append("</pre>");
		contents.append("<br><hr><br>\n");
		contents.append("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>\n");
		contents.append("<html>\n");
		contents.append("<head>\n");
		contents.append("<meta http-equiv='Content-Type' content='text/html; charset=euc-kr'>\n");
		contents.append("</head>\n");
		contents.append("<body leftmargin='10' topmargin='10' marginwidth='0' marginheight='0'>\n");
		
		contents.append("<table class='MsoTableGrid' border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none'>");
		contents.append("<tbody>");
		contents.append("<tr height = '50'>");
		contents.append("<td width='85' bgcolor='#D3D3D3' style='border:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>사업장</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='200' style='border:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>"  + prList.get(0).get("COM_NAME_LOC") +  "<span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='140' style='border:none;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='84' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문번호</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><strong>(KeP Mall)</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='190' style=';border:1px solid;border-left:none;'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'>" + prList.get(0).get("BUYER") + prList.get(0).get("PR_NO") + "<o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		
		contents.append("<tr height = '50'>");
		contents.append("<td width='85' bgcolor='#D3D3D3' style=';border:1px solid;border-top:none;'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문자</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='200' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + prList.get(0).get("USER_NAME_LOC") + "<span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='140' style='border:none;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='110' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>발주번호</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><strong>(PO)</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='201' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + prList.get(0).get("LEGACY_PO_NO") + "<span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		
		contents.append("<tr height = '50' style='border:none'>");
		contents.append("<td width='85' style='border:none;border-left:none;border-bottom:none;border-right:none'>");
		contents.append("</td>");
		contents.append("<td width='170' style='border:none;border-left:none;border-bottom:none;border-right:none'>");
		contents.append("</td>");
		contents.append("<td width='170' style='border:none;border-left:none;border-bottom:none;border-top:none'>");
		contents.append("</td>");
		contents.append("<td width='110' bgcolor='#D3D3D3' style='border-top:none;border-left:1px solid;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>대금지급 조건</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='201' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + "전자채권 90일" + "<span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		
		contents.append("</tbody>");
		contents.append("</table>");

		contents.append("<p class='MsoNormal'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");

		contents.append("<table class='MsoTableGrid' border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none'>");
		contents.append("<tbody>");
		contents.append("<tr height = '50'>");
		contents.append("<td width='37' bgcolor='#D3D3D3' style='border:1px solid;border-left:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'><strong>No</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='132' colspan='2' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>품목코드</strong><span lang='EN-US'><strong>(KeP mall)</strong><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>자재코드</strong><span lang='EN-US'><strong>(ERP)</strong><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='210' colspan='3' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>내 역</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>규 격</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='45' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>수량</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>단위</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='98' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>단 가</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>금 액</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='145' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>코스트 센터</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>G/L 계정</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='110' bgcolor='#D3D3D3' style='border:1px solid;border-left:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>희망납기</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		
		for (int i = 0 ; i < prList.size() ; i++) {
		
			Map<String, String> tMap	= prList.get(i);
				
			contents.append("<tr height = '30'>");
			contents.append("<td width='37' rowspan='2' style='border:1px solid;border-left:1px solid;border-top:none'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center'><span lang='EN-US'>" + (i+1) + "<o:p></o:p></span></p>");
			contents.append("</td>");
			contents.append("<td width='132' colspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center'>" + tMap.get("BUYER_ITEM_NO") + "</p>");
			contents.append("</td>");
			contents.append("<td width='191' colspan='3' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center;padding-right:5px;padding-left:5px'>" + tMap.get("DESCRIPTION") + "</p>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center;padding-right:5px;padding-left:5px'>" + tMap.get("SPECIFICATION")+ "</p>");
			contents.append("</td>");
			contents.append("<td width='45' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + tMap.get("TARGET_QTY") + "</p>");
			contents.append("</td>");
			contents.append("<td width='98' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;padding-right:8px'>");
			contents.append("<p class='MsoNormal' align='right' style='text-align:right'>" +tMap.get("PRICE") + "</p>");
			contents.append("</td>");
			contents.append("<td width='145' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center'>" +tMap.get("BUDGET_DEPT") + "</p>");
			contents.append("</td>");
			contents.append("<td width='110' align='center' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal'>" + tMap.get("RD_DATE") + "</p>");
			contents.append("</td>");
			contents.append("</tr>");
			contents.append("<tr height = '30'>");
			contents.append("<td width='132' colspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center'>" + tMap.get("ERP_ITEM_NO")  + "</p>");        // 수정요망
			contents.append("</td>");
			contents.append("<td width='45' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + tMap.get("UNIT_MEASURE") + "</p>");
			contents.append("</td>");
			contents.append("<td width='98' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;padding-right:8px'>");
			contents.append("<p class='MsoNormal' align='right' style='text-align:right'>" + tMap.get("AMT") + "</p>");
			contents.append("</td>");
			contents.append("<td width='145' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid'>");
			contents.append("<p class='MsoNormal' align='center'>" + tMap.get("ACCOUNT_TYPE") + "</p>");
			contents.append("</td>");
			contents.append("</tr>");
		}

		contents.append("<tr height = '30'>");
		contents.append("<td width='83' colspan='2' rowspan='2' bgcolor='#D3D3D3' style='border:1px solid;border-left:1px solid;border-bottom:1px solid;border-right:1px solid;border-top:none'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문 일자</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='86' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" +prList.get(0).get("ADD_DATE")+ "</p>");
		contents.append("</td>");
		contents.append("<td width='85' rowspan='2' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>주문 건수</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='66' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'>" + prList.size() + "</p>");
		contents.append("</td>");
		contents.append("<td width='85' colspan='2' rowspan='2' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>금액 합계</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("<td width='98' rowspan='2' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid;padding-right:8px'>");
		contents.append("<p class='MsoNormal' align='right' style='text-align:right'><strong>" + prList.get(0).get("AMT_TOTAL") + "</strong></p>");
		contents.append("</td>");
		contents.append("<td width='110' colspan='2' bgcolor='#D3D3D3' style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center' style='text-align:center'><strong>공급사명</strong><span lang='EN-US'><o:p></o:p></span></p>");
		contents.append("</td>");
		contents.append("</tr>");
		contents.append("<tr height = '30'>");
		contents.append("<td width='132' colspan='2'  style='border-top:none;border-left:none;border-bottom:1px solid;border-right:1px solid;border-bottom:1px solid'>");
		contents.append("<p class='MsoNormal' align='center'> " + prList.get(0).get("AGENT_NAME") + " </p>");
		contents.append("</td>");
		contents.append("</tr>");
		contents.append("<tr height='0'>");
		contents.append("<td width='37' style='border:none'></td>");
		contents.append("<td width='46' style='border:none'></td>");
		contents.append("<td width='86' style='border:none'></td>");
		contents.append("<td width='85' style='border:none'></td>");
		contents.append("<td width='66' style='border:none'></td>");
		contents.append("<td width='40' style='border:none'></td>");
		contents.append("<td width='45' style='border:none'></td>");
		contents.append("<td width='98' style='border:none'></td>");
		contents.append("<td width='110' style='border:none'></td>");
		contents.append("</tr>");
		contents.append("</tbody>");
		contents.append("</table>");
		
		contents.append("<p class='MsoNormal'><span lang='EN-US'><o:p>&nbsp;</o:p></span></p>");
		
		contents.append("<table>");
		contents.append("<tr height = '80'>");
		contents.append("<td width='780' style='border:1px solid;border-left:1px solid;padding-left:8px'>");
		contents.append("<p>" + appData.get("DOCU_CONT") + "</p>");
		contents.append("</td>");
		contents.append("</tr>");
		contents.append("</table>");
		
		contents.append("</body>\n");
		contents.append("</html>\n");
		
		appData.put("CONTENTS",contents.toString());
		appData.put("DOCU_TITLE","(" + prList.get(0).get("PR_NO") + ") "+ appData.get("DOCU_TITLE"));
		
		if("501".equals(formid)) {
			appData.put("AEROSYSTEMID","MROHW8914");
		}else {
			appData.put("AEROSYSTEMID","506EQ0001");
		}
		
		sqlSessionTemplate.update("buyer.mpso.insertAeroIfAplSend", appData);
		sqlSessionTemplate.update("buyer.mpso.insertAeroIfApmSend", appData);
		
		// 결재정보 조회 
		Map<String, String> apmData	= sqlSessionTemplate.selectOne("buyer.mpso.selectHanhwaAeroDocu", appData);
		// 결재선 조회.(결재)
		List<Map<String, String>> aplList	= sqlSessionTemplate.selectList("buyer.mpso.selectHanWhaAeroPassln", apmData);
		List<Map<String, String>> aplList_r	= sqlSessionTemplate.selectList("buyer.mpso.selectHanWhaAeroPassln_refer", apmData);
		//첨부파일
		List<Map<String, String>> appFileList	= null;
		if (apmData.get("IMAGE_KEY") != null && !"".equals(apmData.get("IMAGE_KEY"))) {
			appFileList	= sqlSessionTemplate.selectList("buyer.mpso.selectHanhwaAttFileList", apmData);
		}
		
		//결재선 info
		com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.SignerInfo[] cleverseSignerInfoList = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.SignerInfo[aplList.size()];
		
		for(int i = 0 ; i < aplList.size() ; i++) {
			com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.SignerInfo cleverseSignerInfo = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.SignerInfo();
			Map<String, String> tMap	= aplList.get(i);
			
			cleverseSignerInfo.setAssignType(Integer.parseInt(tMap.get("APPRACTIONCD"))); //참여자 형대
			cleverseSignerInfo.setSequence(Integer.parseInt(tMap.get("APPRSEQ"))); // 결재순번
			cleverseSignerInfo.setUserId(tMap.get("USER_ID")); //Circle의 userID
			cleverseSignerInfoList[i] = cleverseSignerInfo;
		}
		
		com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocument cleverseApprovalDocument = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocument();

		cleverseApprovalDocument.setBodyContent(contents.toString()); // 결재본문
		cleverseApprovalDocument.setBodyContentType(1); // 결재타입
		cleverseApprovalDocument.setTitle(prList.get(0).get("LEGACY_PO_NO") + " "+ (String)apmData.get("SUBJECT"));  // 결재제목							
		cleverseApprovalDocument.setMisDocId((String)apmData.get("APPRID"));  // 결재ID
		cleverseApprovalDocument.setSystemId((String)apmData.get("SYSTEMID"));  // systemID
		cleverseApprovalDocument.setFlowCase("customized");  
		cleverseApprovalDocument.setCompanyId((String)apmData.get("COMPANYID"));  // 회사ID
		cleverseApprovalDocument.setFormCode((String)apmData.get("FORMCODE"));  // systemID
		cleverseApprovalDocument.setSignerInfos(cleverseSignerInfoList);  // 결재 경로 객체 배열
		
		if ( appFileList != null && appFileList.size() > 0) {
			com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.WsApAttachFile[] cleverseWsAtchList = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.WsApAttachFile[appFileList.size()];
			for(int i = 0 ; i < appFileList.size() ; i++) {
				Map<String, String> fMap	= appFileList.get(i);
				com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.WsApAttachFile cleverseAtchFile = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.WsApAttachFile();
				
				String _filename	= (String)fMap.get("DES_FILE_NAME");
				String _orgFilename	= (String)fMap.get("SRC_FILE_NAME");
				String _type = (String)fMap.get("TYPE").toString();
				String _path = "";
				String _del_file_dir = (String)fMap.get("DES_FILE_DIR").toString();
				
				if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
					_path = CommonUtil.getUploadTypePath(_type, "N")+ "/";
				}else{
					_path = CommonUtil.getUploadTypePath(_type, "N") + "/" +_del_file_dir+ "/";
				}

				try {
					System.out.println(" _path + _filename : " + _path + _filename);
					if (CommonAwsS3.doesFileExists(_path + _filename)) {
						byte[] buffer = new byte[MAX_BUF_BYTE];
						is = new FileInputStream(CommonAwsS3.download(_path + _filename, _orgFilename));
						bis = new BufferedInputStream(is);
						arrayBuff = new ByteArrayOutputStream();
					    int len = 0;
					    while ((len = bis.read(buffer)) >= 0) {
					        arrayBuff.write(buffer, 0, len);
					    }
					    
					    File srcFile = CommonAwsS3.download(_path + _filename, _filename);
						
						FileDataSource fds = new FileDataSource(srcFile);
						javax.activation.DataHandler dh = new javax.activation.DataHandler(fds);
						
					    cleverseAtchFile.setFileName(_orgFilename);
					    cleverseAtchFile.setSeqID(Integer.valueOf(fMap.get("DOC_SEQ")));
					    cleverseAtchFile.setFileSize(Integer.toString(arrayBuff.toByteArray().length));
					    cleverseAtchFile.setFileInfo(dh);
					}
				} catch (Exception e) {
					LOGGER.error(CommonUtil.printStackTraceToString(e));
				} finally {
					try {is.close();} catch (Exception e2) {}
					try {bis.close();} catch (Exception e2) {}
					try {arrayBuff.close();} catch (Exception e2) {}
				}				
				
				cleverseWsAtchList[i]	= cleverseAtchFile;
			}
			
			cleverseApprovalDocument.setAttachfiles(cleverseWsAtchList);
		}
		
		
		if(aplList_r.size() > 0) {
			com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo[] cleverseReceiverInfoList = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo[aplList_r.size()];
			// 참조 정보 입력
			for(int i = 0 ; i < aplList_r.size() ; i++) {
				com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo cleverseReceiverInfo = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.ReceiverInfo();
				Map<String, String> tMap	= aplList_r.get(i);
				
				cleverseReceiverInfo.setRoleType("referer");
				cleverseReceiverInfo.setReceiverId(tMap.get("USER_ID"));
				
				cleverseReceiverInfoList[i] = cleverseReceiverInfo;
			}
			cleverseApprovalDocument.setReceiverInfos(cleverseReceiverInfoList); // 결재 참조 경로 객체 배열
		}
		
		com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.axisws.ApprovalServiceProxy cleverseProxy = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.axisws.ApprovalServiceProxy(st_server_mode);
		String rtn = cleverseProxy.submitApprovalUseUserId(cleverseApprovalDocument);
		
		apmData.put("RTN_MSG", rtn);
		apmData.put("STATUS2", "01");
		
		if (rtn.equals("SUCCESS")) {
			apmData.put("RTN_FLAG", "Y");
		} else {
			apmData.put("RTN_FLAG", "E");
		}
		
		sqlSessionTemplate.update("buyer.mpso.updateAeroApmSendResult",apmData);
		
		
		com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly [] cleverseApprovalDocumentStatusOnly = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocumentStatusOnly[1];
		com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey [] cleverseMiskeylist = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey[1];
		
		
		cleverseMiskeylist[0] = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey();
		
		cleverseMiskeylist[0].setMisDocId((String)apmData.get("APPRID"));
		cleverseMiskeylist[0].setSystemId((String)apmData.get("SYSTEMID"));
		
		cleverseApprovalDocumentStatusOnly = cleverseProxy.getProcessIdByBulkMisId(cleverseMiskeylist);
		
		String instanceId = cleverseApprovalDocumentStatusOnly[0].getInstanceId();
		
		apmData.put("INSTANCEID",instanceId);
		
		sqlSessionTemplate.update("buyer.mpso.updateHanWhaAeroIfApmSend",apmData);
		
	}

	public void insertIFAppInfoTYPE15(Map<String, String> formData) throws Exception {		
		Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer").toString(), "P11-0000004");
		String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
		String formid	= CommonUtil.nvl(slgMap.get("COL03_DATA"));
		String xmlns = CommonUtil.nvl(slgMap.get("COL04_DATA"));
		
		List<Map<String, String>> prList	= sqlSessionTemplate.selectList("buyer.mpso.selectIFAppPrList", formData); // pr list
		Map<String, String> appData	= sqlSessionTemplate.selectOne("buyer.mpso.selectIFAppInfo", formData);  // icogdouc info		
		sqlSessionTemplate.update("buyer.mpso.updateAppUserInfo", appData);
		sqlSessionTemplate.update("buyer.mpso.insertIfAplSend", appData);
		sqlSessionTemplate.update("buyer.mpso.insertIfApmSend", appData);		
		// 결재정보 조회 
		 Map<String, String> apmData	= sqlSessionTemplate.selectOne("buyer.mpso.selectIFAeKyAppInfo", appData);
		// 결재선 조회. 
		List<Map<String, String>> aplList	= sqlSessionTemplate.selectList("buyer.mpso.selectAeKyPassln", appData);
		
		StringBuffer contents	= new StringBuffer();
		// contents.append 
		contents.append("<!doctype html>");
		contents.append("<html>");
		contents.append("<head><title>MRO구매품의서</title><style type='text/css'>.FIELD {border: 1px solid rgb(182, 188, 195);border-image: none;padding-left: 5px;font-family: 굴림체;font-size: 9pt;}.CONTENTS {border: 1px solid rgb(182, 188, 195);border-image: none;font-family: 굴림체;font-size: 9pt;}.SUBJECT {border: 1px solid rgb(182, 188, 195);border-image: none;font-family: 굴림체;font-size: 9pt;background-color: #e5e5e5;}.tableHead {border-width: 1px;border-color: rgb(182, 188, 195);width: 100%;font-family: 굴림체;font-size: 9pt;border-collapse: collapse;table-layout: fixed;}.header {border-width: 1px;border-color: rgb(182, 188, 195);font-family: 굴림체;font-size: 0pt;}.footer {border-width: 1px;border-color: rgb(182, 188, 195);font-family: 굴림체;font-size: 9pt;}.cost {border: 1px solid rgb(182, 188, 195);border-image: none;font-family: 굴림체;font-size: 9pt;background-color: #dedede}</style></head>");

		// html body 부분 품의서 양식
		contents.append("<body>");
	    contents.append("<table width=640 border=0 align=center cellpadding=0 cellspacing=0 style='border-width: 1px; border-color: rgb(182, 188, 195); width: 640px; font-family: 굴림체; font-size: 9pt; border-collapse: collapse; table-layout: fixed;' valign=middle>");
	    contents.append("<colgroup>");
	    contents.append("<col width=90>");
	    contents.append("<col width=230>");
	    contents.append("<col width=90>");
	    contents.append("<col width=230>");
	    contents.append("</colgroup>");
	    contents.append("<tr height=30>");
	    contents.append("<td align=center valign=middle style='border-width: 1px; border-color: rgb(182, 188, 195); font-family: 굴림체; font-size: 15pt; font-weight: bold;' colspan=4>");
	    contents.append("◆ 구 매 품 의 서 ◆"); 
	    contents.append("</td>");
	    contents.append("</tr>");
	    contents.append("<tbody>");
	    contents.append("<tr height=5>");
	    contents.append("<td align=center valign=middle class='header' colspan=4>");
	    contents.append("<p style='margin: 0px; padding: 0px;'>&nbsp;");
	    contents.append("</p>");
	    contents.append("</td>");
	    contents.append("</tr>");
	    contents.append("<tr height=30>");
	    contents.append("<td align=center valign=middle class='SUBJECT'>작업허가서번호");
	    contents.append("</td>");
	    contents.append("<td align=left class='FIELD' valign=middle colspan='3'>");
	    contents.append("<input type='checkbox' name='chk_info' value='HTML' checked='checked'>있음 (허가서: 1018023)  ");
	    contents.append("<input type='checkbox' name='chk_info' value='CSS'>없음");
	    contents.append("</td>");
	    contents.append("</tr>");
	    contents.append("<tr height=30>");
	    contents.append("<td align=center valign=middle class='SUBJECT'>제 목");
        contents.append("</td>");
	    contents.append("<td align=left class='FIELD' valign=middle colspan='3'>");
	    contents.append(appData.get("DOCU_TITLE")); // 제목
	    contents.append("</td>");
	    contents.append("</tr>");
	    contents.append("<tr height=30>");
	    contents.append("<td align=center valign=middle class='SUBJECT'><p>신청자</p>");
	    contents.append("</td>");
	    contents.append("<td align=left class='FIELD' valign=middle>");
	    contents.append(apmData.get("APP_USER_NAME")+" " + apmData.get("POSITION") + ", 사원번호[" + apmData.get("LEGACY_USER_ID") + "]");
	    contents.append("</td>");		
	    contents.append("</td>");
	    contents.append("<td align=center valign=middle class='SUBJECT'>주문번호");
	    contents.append("</td>");
	    contents.append("<td align=left class='FIELD' valign=middle>");
	    contents.append(prList.get(0).get("PR_NO"));
	    contents.append("</td>");
	    contents.append("</tr>");
	    contents.append("<tr height=30>");
	    contents.append("<td align=center valign=middle class='SUBJECT'>신청부서");
	    contents.append("</td>");
	    contents.append("<td align=left class='FIELD' valign=middle>");
	    contents.append(prList.get(0).get("BUDGET_DEPT")); // 신청부서
	    contents.append("</td>");
	    contents.append("<td align=center valign=middle class='SUBJECT'>신청일자");
	    contents.append("</td>");
	    contents.append("<td align=left class='FIELD' valign=middle>");
	    contents.append(apmData.get("APP_DATE"));
	    contents.append("</td>");
	    contents.append("</tr>");
	    contents.append("<tr height=30>");
	    contents.append("<td align=center valign=middle class='SUBJECT'>코스트센터");
        contents.append("</td>");
	    contents.append("<td align=left class='FIELD' valign=middle>");
	    contents.append(prList.get(0).get("BUDGET_DEPT"));  // 코스트센터
	    contents.append("</td>");
	    contents.append("<td align=center valign=middle class='SUBJECT'><p>비목</p>");
	    contents.append("</td>");
	    contents.append("<td align=left class='FIELD' valign=middle>");
	    contents.append("</td>");
	    contents.append("</tr>");
	    contents.append("<tr>");
	    contents.append("<td align=center valign=middle class='SUBJECT'>신청내역");
        contents.append("</td>");
	    contents.append("<td colspan=3 align=left valign=middle class='FIELD' style='padding: 10px;'>");
	    contents.append("<table width='100%' border=0 cellspacing=0 cellpadding=0>");
	    contents.append("<tr>");
	    contents.append("<td>");
	    contents.append("<table width='100%' border=0 align=center cellpadding=0 cellspacing=0 style='border-width: 1px; border-color: rgb(182, 188, 195); width: 100%; font-family: 굴림체; font-size: 9pt; border-collapse: collapse; table-layout: fixed;' valign=middle>");
	    contents.append("<colgroup>");
	    contents.append("<col width=40>");
	    contents.append("<col width=70>");
	    contents.append("<col width='*'>");
	    contents.append("<col width=90>");
	    contents.append("<col width=90>");
	    contents.append("<col width=90>");
	    contents.append("</colgroup>");
	    contents.append("<tbody>");
	    contents.append("<tr height=30>");
	    contents.append("<td align=center valign=middle class='SUBJECT'>+No");contents.append("</td>");
        contents.append("<td align=center valign=middle class='SUBJECT'>상품ID");contents.append("</td>");
        contents.append("<td align=center valign=middle class='SUBJECT'>품명");contents.append("</td>");
        contents.append("<td align=center valign=middle class='SUBJECT'>수량");contents.append("</td>");
        contents.append("<td align=center valign=middle class='SUBJECT'>단가");contents.append("</td>");
        contents.append("<td align=center valign=middle class='SUBJECT'>공급가액");contents.append("</td>");
	    contents.append("</tr>");
	    int i = 1;
	    for (Map <String,String> prlist : prList) {
		    contents.append("<tr height=30>");
	        contents.append("<td align=center valign=middle class='CONTENTS'>");
	        contents.append(i);
	        contents.append("</td>");
	        contents.append("<td align=center valign=middle class='CONTENTS'>");
	        contents.append(prlist.get("BUYER_ITEM_NO"));
	        contents.append("</td>");
	        contents.append("<td align=center valign=middle class='CONTENTS'>");
	        contents.append(prlist.get("DESCRIPTION"));
	        contents.append("</td>");
	        contents.append("<td align=center valign=middle class='CONTENTS'>");
	        contents.append(prlist.get("TARGET_QTY"));
	        contents.append("</td>");
	        contents.append("<td align=center valign=middle class='CONTENTS'>");
	        contents.append(prlist.get("PRICE"));
	        contents.append("</td>");
	        contents.append("<td align=center valign=middle class='CONTENTS'>");
	        contents.append(prlist.get("AMT"));
	        contents.append("</td>");
		    contents.append("</tr>");
		    i++;
	    }
	    contents.append("<tr height=30>");
        contents.append("<td colspan=2 align=center valign=middle class='CONTENTS'>합계(VAT별도)");
        contents.append("</td>");
        contents.append("<td align=center valign=middle class='CONTENTS'>");
        contents.append("</td>");
        contents.append("<td align=right valign=middle class='CONTENTS'>");
        contents.append(prList.get(0).get("TOT_CNT"));
        contents.append("</td>");
        contents.append("<td align=right valign=middle class='CONTENTS'>");
        contents.append("</td>");
        contents.append("<td align=right valign=middle class='CONTENTS'>");
        contents.append(prList.get(0).get("TOT_AMT"));
        contents.append("</td>");
        contents.append("</tr>");
        contents.append("</tbody>");
        contents.append("</table>");
        contents.append("</td>");
        contents.append("</tr>");
	    contents.append("</table>");
        contents.append("</td>");
        contents.append("</tr>");contents.append("<br>");contents.append("<br>");
        contents.append("<tr>");
        contents.append("<td colspan=4>");
        contents.append("<table width='100%' border=0 align=center cellpadding=0 cellspacing=0 style='border-width: 1px; border-color: rgb(182, 188, 195); width: 100%; font-family: 굴림체; font-size: 9pt; border-collapse: collapse; table-layout: fixed;' valign=middle>");
        contents.append("<colgroup>");
        contents.append("<col width=90>");
        contents.append("<col width='*'>");
        contents.append("</colgroup>");
        contents.append("<tbody>");
        contents.append("<tr height=30>");
        contents.append("<td width=70 align=center valign=middle style='border: 1px solid rgb(182, 188, 195); border-image: none; font-family: 굴림체; font-size: 9pt; background-color: #dedede'>예산현황");
        contents.append("</td>");
        contents.append("<td width='100%' colspan=3 align=left valign=middle class='FIELD' style='border: 1px solid rgb(182, 188, 195); border-image: none; padding-left: 5px; font-family: 굴림체; font-size: 9pt;'>");
        contents.append("<p style='margin: 0px; padding: 0px;'>"); // 추가
        contents.append(prList.get(0).get("ACCOUNT_TYPE") + " (" + prList.get(0).get("ACCOUNT_CODE") + ")");    			   // 추가
        contents.append("</p>");								   // 추가
        
        contents.append("</td>");
        contents.append("</tr>");
        contents.append("<tr height=30>");
        contents.append("<td align=center valign=middle style='border: 1px solid rgb(182, 188, 195); border-image: none; font-family: 굴림체; font-size: 9pt; background-color: #dedede'>비고사항");
        contents.append("</td>");
        contents.append("<td colspan=3 align=left valign=middle class='FIELD' style='border: 1px solid rgb(182, 188, 195); border-image: none; padding-left: 5px; font-family: 굴림체; font-size: 9pt;'>");
        contents.append("<p style='margin: 0px; padding: 0px;'>"); // 추가
        contents.append(appData.get("DOCU_CONT"));    			   // 추가
        contents.append("</p>");								   // 추가
        contents.append("</td>");
        contents.append("</tr>");
        contents.append("</tbody>");
        contents.append("</table>");
        contents.append("</td>");
        contents.append("</tr>");
        contents.append("<tr height=5>");
        contents.append("<td align=center valign=middle class='header' colspan=4>");
        contents.append("<p style='margin: 0px; padding: 0px;'>&nbsp;");
        contents.append("</p>");
        contents.append("</td>");
        contents.append("</tr>");
        contents.append("<tr height=30>");
        contents.append("<td align=left valign=middle class='footer' colspan=4>");
        contents.append("<p style='margin: 0px; padding: 0px;'>");
//        contents.append(appData.get("DOCU_CONT"));
        contents.append("</p>");
        contents.append("</td>");
        contents.append("</tr>");
        contents.append("<tr height=30>");
        contents.append("<td align=right valign=middle class='footer' colspan=4>");
        contents.append("<p style='margin: 0px; padding: 0px;'>");
        contents.append(appData.get("USER_NM"));
        contents.append("</p>");
        contents.append("</td>");
        contents.append("</tr>");
	    contents.append("</table>");
	    contents.append("</body>");

	    contents.append("</html>");
		// sJSON 구성
		JSONObject jsonlist = new JSONObject();
		JSONArray jsonaprlist = new JSONArray(); // 결재자 리스트 1
		JSONArray jsonchamlist = new JSONArray(); // 참조자 리스트 9
		
		jsonlist.put("docID", "");
		jsonlist.put("docTitle", appData.get("DOCU_TITLE")); // 제목
		jsonlist.put("docBody", contents.toString()); // 본문
		
		jsonlist.put("formID",formid);
		
		jsonlist.put("company", "CA"); // 회사코드  CA: 애경캐미칼
		jsonlist.put("actionType", "A03001"); // 결재타임_A03008 : 개인순차협의
		jsonlist.put("actionState", "A04002"); // 결재상태 A04002 : 기안
		
		jsonlist.put("actionComment", ""); // 결재자 의견
		
		
		for (Map<String, String> iMap : aplList) {
			String pass_tp = iMap.get("APPRACTIONCD"); // 0:기안 , 1:결재, 9:참조
			JSONObject json = new JSONObject();
			
			 if (pass_tp.equals("0") || pass_tp.equals("1")) { // 결재자 정보
				
				if (pass_tp.equals("0")) {
					jsonlist.put("writeUser", iMap.get("LEGACY_USER_ID")); 
					jsonlist.put("actionUser", iMap.get("LEGACY_USER_ID")); 
				}
				json.put("aprMemberID", iMap.get("LEGACY_USER_ID"));  // 결재자 사번
				json.put("aprMemberName1", iMap.get("USER_NAME_LOC"));  // 결재자 명(한굴)
				json.put("aprMemberName2", "");  // 결재자 명(영문)
				json.put("aprMemberTitle1", "");  // 결재자 직위(한글)
				json.put("aprMemberTitle2", "");  // 결재자 직위(한글)
				json.put("aprMemberDeptCode", "");  // 결재자 부서코드
				json.put("aprMemberDeptName1", "");  // 결재자 부서명(한글)
				json.put("aprMemberDeptName2", "");  // 결재자 부서명(한글)
				json.put("aprMemberLoginID", iMap.get("LEGACY_USER_ID"));  // 결재자 아이디
				json.put("aprMemberSingImg","");
				json.put("aprMemberAppType", "A03001");  // 결재자 결재타입
				json.put("aprMemberCompanyName", "");  

				jsonaprlist.put(json);
				
			} else if (pass_tp.equals("9")) { // 참조자 정보
				json.put("chamjoMemberID", iMap.get("LEGACY_USER_ID"));  // 참조자 사번
				json.put("chamjoMemberName1", iMap.get("USER_NAME_LOC"));  // 참조자 명(한굴)
				json.put("chamjoMemberName2", "");  // 참조자 명(영문)
				json.put("chamjoMemberDeptCode", "");  // 참조자 부서코드
				json.put("chamjoMemberDeptName1", "");  // 참조자 부서명(한글)
				json.put("chamjoMemberDeptName2", "");  // 참조자 부서명(한글)
				
				jsonchamlist.put(json);
			}
		}
		
		jsonlist.put("aprLineInfo", jsonaprlist);
		jsonlist.put("chamjoInfo", jsonchamlist);
		jsonlist.put("packageId", "CAMRO");
		jsonlist.put("workflowProcessId", prList.get(0).get("BUYER")+ prList.get(0).get("PR_NO"));
		
		String str = jsonlist.toString();		
		StringBuffer xml	= new StringBuffer();

		xml.append("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
		xml.append("<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>");
		xml.append("<soap:Body>");
		xml.append("<ExecuteDoc_Json_NewDoc xmlns='http://ezGateWay.ezApprovalM.Kaoni.com/'>");
		xml.append("<sJson>");
		xml.append(str.replaceAll("&", "＆").replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
		xml.append("</sJson>");
		xml.append("</ExecuteDoc_Json_NewDoc>");
		xml.append("</soap:Body>");
		xml.append("</soap:Envelope>");
		
		String new_xml = xml.toString().replaceAll("\\\\/", "/");
		
//		LOGGER.info("#### new_xml : "+ new_xml);
		
		URL url = new URL(st_url);
		// Https SSL인증서 무시하기
    	try {	        		
    		ignorSsl();	        		
    	} catch(Exception e) {
    		e.printStackTrace();
    	}  
		HttpURLConnection con = (HttpURLConnection)url.openConnection();

		con.setRequestMethod("POST");		
		con.setRequestProperty("Content-Type", "text/xml; charset=utf-8");
		con.setConnectTimeout(10000);
		con.setDoOutput(true);
		
		con.connect();
		
		try {
			OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream(), "utf-8");
			BufferedWriter bw = new BufferedWriter(wr);
			bw.write(new_xml);
			bw.flush();
			bw.close();
		}catch (Exception e) {
			LOGGER.info("input error");
			LOGGER.error("SQL ERROR : "+ e.getMessage());
			throw new Exception("input error~!");
		}
		
		try {
			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
			StringBuilder response = new StringBuilder();
			String responseLine = null;
			while ((responseLine = br.readLine()) != null ) {
				response.append(responseLine).append("\n");
			}			
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true);
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document document = builder.parse(new InputSource(new StringReader(response.toString())));
		    
			NodeList nodelist = document.getElementsByTagName("ExecuteDoc_Json_NewDocResult");
			Node node = nodelist.item(0);
			Node text = node.getFirstChild();
			
			String rtntext = text.getNodeValue();
			
			System.out.println("rtntext = "+ rtntext);
			
			String [] rtntextlist = rtntext.split("\\^");
		
		    if (rtntextlist[0].equals("TRUE")) {
				formData.put("AeKyDocNo", rtntextlist[1]);
				
				sqlSessionTemplate.update("buyer.mpso.updateAeKyDocNo", formData);
		    }else {
		    	throw new Exception("App error~!");
		    }
		}catch (Exception e) {
			LOGGER.info("output error");
			e.printStackTrace();
			LOGGER.error("SQL ERROR : "+ e.getMessage());
			throw new Exception("output error!!!");
		} 
	}
	public String aekyApprPriceSend(Map<String, String> formData) {
		String result = "";
		try {	
			Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer").toString(), "P11-0000004");
			String st_url	= CommonUtil.nvl(slgMap.get("COL05_DATA"));  //http://m.gwaekyung.kr/ExternalLink/ExternalNewDoc.asmx?op=ExecuteDoc_Json_NewDoc
			String formid	= CommonUtil.nvl(slgMap.get("COL03_DATA"));  //2022000080   개발 : 2022000063
			String xmlns = CommonUtil.nvl(slgMap.get("COL04_DATA"));	 //null
			String docu_no = formData.get("ak_docu_no").toString();
			String user_dept = formData.get("st_user_dept_name").toString();
			List<Map<String, String>> reList	= sqlSessionTemplate.selectList("buyer.mpso.selectAekyReList", formData); // RE LIST   -> ★ rqdt,qtdt,cmpy 조인해서 re list 가져오기
			Map<String, String> appData	= sqlSessionTemplate.selectOne("buyer.mpso.selectAekyReAppInfo", formData);  // icogdouc info  결재문서 정보 
		
			sqlSessionTemplate.update("buyer.mpso.updateAppUserInfo", appData);
			sqlSessionTemplate.update("buyer.mpso.insertIfAplSend", appData);	
			sqlSessionTemplate.update("buyer.mpso.insertIfApmSend", appData);	
			
			// 결재정보 조회 
			 Map<String, String> apmData	= sqlSessionTemplate.selectOne("buyer.mpso.selectIFAeKyAppInfo", appData);
			// 결재선 조회. 
			List<Map<String, String>> aplList	= sqlSessionTemplate.selectList("buyer.mpso.selectAeKyPassln", appData);
			
			StringBuffer contents	= new StringBuffer();
			// contents.append 
			contents.append("<!doctype html>");
			contents.append("<html>");
			contents.append("<head><title>MRO견적품의서</title><style type='text/css'>.FIELD {border: 1px solid rgb(182, 188, 195);border-image: none;padding-left: 5px;font-family: 굴림체;font-size: 9pt;}.CONTENTS {border: 1px solid rgb(182, 188, 195);border-image: none;font-family: 굴림체;font-size: 9pt;}.SUBJECT {border: 1px solid rgb(182, 188, 195);border-image: none;font-family: 굴림체;font-size: 9pt;background-color: #e5e5e5;}.tableHead {border-width: 1px;border-color: rgb(182, 188, 195);width: 100%;font-family: 굴림체;font-size: 9pt;border-collapse: collapse;table-layout: fixed;}.header {border-width: 1px;border-color: rgb(182, 188, 195);font-family: 굴림체;font-size: 0pt;}.footer {border-width: 1px;border-color: rgb(182, 188, 195);font-family: 굴림체;font-size: 9pt;}.cost {border: 1px solid rgb(182, 188, 195);border-image: none;font-family: 굴림체;font-size: 9pt;background-color: #dedede}</style></head>");
	
			// html body 부분 품의서 양식
			contents.append("<body>");
		    contents.append("<table width=640 border=0 align=center cellpadding=0 cellspacing=0 style='border-width: 1px; border-color: rgb(182, 188, 195); width: 640px; font-family: 굴림체; font-size: 9pt; border-collapse: collapse; table-layout: fixed;' valign=middle>");
		    contents.append("<colgroup>");
		    contents.append("<col width=90>");
		    contents.append("<col width=230>");
		    contents.append("<col width=90>");
		    contents.append("<col width=230>");
		    contents.append("</colgroup>");
		    contents.append("<tr height=30>");
		    contents.append("<td align=center valign=middle style='border-width: 1px; border-color: rgb(182, 188, 195); font-family: 굴림체; font-size: 15pt; font-weight: bold;' colspan=4>");
		    contents.append("◆ 상품 등록 품 의 서 ◆"); 
		    contents.append("</td>");
		    contents.append("</tr>");
		    contents.append("<tbody>");
		    contents.append("<tr height=5>");
		    contents.append("<td align=center valign=middle class='header' colspan=4>");
		    contents.append("<p style='margin: 0px; padding: 0px;'>&nbsp;");
		    contents.append("</p>");
		    contents.append("</td>");
		    contents.append("</tr>");
		    contents.append("<tr height=30>");
		    contents.append("<td align=center valign=middle class='SUBJECT'>제 목");
	        contents.append("</td>");
		    contents.append("<td align=left class='FIELD' valign=middle colspan='3'>");
		    contents.append(appData.get("DOCU_TITLE"));
		    contents.append("</td>");
		    contents.append("</tr>");
		    contents.append("<tr height=30>");
		    contents.append("<td align=center valign=middle class='SUBJECT'><p>신청자</p>");
		    contents.append("</td>");
		    contents.append("<td align=left class='FIELD' valign=middle>");
		    contents.append(apmData.get("APP_USER_NAME")+" " + apmData.get("POSITION") + ", 사원번호[" + apmData.get("LEGACY_USER_ID") + "]"); //그대로가면 될 듯
		    contents.append("</td>");		
		    contents.append("</td>");
		    contents.append("<td align=center valign=middle class='SUBJECT'>결재번호");
		    contents.append("</td>");
		    contents.append("<td align=left class='FIELD' valign=middle>");
		    contents.append(docu_no);   // -> ★ docu_no로 변경
		    contents.append("</td>");
		    contents.append("</tr>");
		    contents.append("<tr height=30>");
		    contents.append("<td align=center valign=middle class='SUBJECT'>신청부서");
		    contents.append("</td>");
		    contents.append("<td align=left class='FIELD' valign=middle>");
		    contents.append(user_dept); // 신청부서
		    contents.append("</td>");
		    contents.append("<td align=center valign=middle class='SUBJECT'>신청일자");
		    contents.append("</td>");
		    contents.append("<td align=left class='FIELD' valign=middle>"); 
		    contents.append(apmData.get("APP_DATE"));
		    contents.append("</td>");
		    contents.append("</tr>");
		    contents.append("<tr>");
		    contents.append("<td align=center valign=middle class='SUBJECT'>신청내역");
	        contents.append("</td>");
		    contents.append("<td colspan=3 align=left valign=middle class='FIELD' style='padding: 10px;'>");
		    contents.append("<table width='100%' border=0 cellspacing=0 cellpadding=0>");
		    contents.append("<tr>");
		    contents.append("<td>");
		    contents.append("<table width='100%' border=0 align=center cellpadding=0 cellspacing=0 style='border-width: 1px; border-color: rgb(182, 188, 195); width: 100%; font-family: 굴림체; font-size: 9pt; border-collapse: collapse; table-layout: fixed;' valign=middle>");
		    contents.append("<colgroup>");
		    contents.append("<col width=30>");
		    contents.append("<col width=70>");
		    contents.append("<col width=50>");
		    contents.append("<col width=60>");
		    contents.append("<col width='*'>");
		    contents.append("<col width=50>");
		    contents.append("<col width=70>");
		    contents.append("<col width=70>");
		    contents.append("</colgroup>");
		    contents.append("<tbody>");
		    contents.append("<tr height=30>");  
		    contents.append("<td align=center valign=middle class='SUBJECT'>+No");contents.append("</td>");
		    contents.append("<td align=center valign=middle class='SUBJECT'>견적번호");contents.append("</td>");
	        contents.append("<td align=center valign=middle class='SUBJECT'>견적항번");contents.append("</td>");
	        contents.append("<td align=center valign=middle class='SUBJECT'>상품ID");contents.append("</td>");        
	        contents.append("<td align=center valign=middle class='SUBJECT'>품명");contents.append("</td>");
	        contents.append("<td align=center valign=middle class='SUBJECT'>수량");contents.append("</td>");
	        contents.append("<td align=center valign=middle class='SUBJECT'>단가");contents.append("</td>");
	        contents.append("<td align=center valign=middle class='SUBJECT'>공급가액");contents.append("</td>");
		    contents.append("</tr>");
		    int i = 1;
		    for (Map <String,String> relist : reList) {	 // -> ★ 견적번호, 항번 추가 
			    contents.append("<tr height=30>");
		        contents.append("<td align=center valign=middle class='CONTENTS'>");
		        contents.append(i);
		        contents.append("</td>");
		        contents.append("<td align=center valign=middle class='CONTENTS'>");
		        contents.append(relist.get("QUOTATION_NO"));
		        contents.append("</td>");
		        contents.append("<td align=center valign=middle class='CONTENTS'>");
		        contents.append(relist.get("QUOTATION_SEQ"));
		        contents.append("</td>");
		        contents.append("<td align=center valign=middle class='CONTENTS'>");
		        contents.append(relist.get("BUYER_ITEM_NO"));
		        contents.append("</td>");
		        contents.append("<td align=center valign=middle class='CONTENTS'>");
		        contents.append(relist.get("DESCRIPTION"));
		        contents.append("</td>");
		        contents.append("<td align=center valign=middle class='CONTENTS'>");
		        contents.append(relist.get("ITEM_QTY"));
		        contents.append("</td>");
		        contents.append("<td align=center valign=middle class='CONTENTS'>");
		        contents.append(relist.get("PRICE"));
		        contents.append("</td>");
		        contents.append("<td align=center valign=middle class='CONTENTS'>");
		        contents.append(relist.get("AMT")); 
		        contents.append("</td>");
			    contents.append("</tr>");
			    i++;
		    }
		    contents.append("<tr height=30>");
	        contents.append("<td colspan=2 align=center valign=middle class='CONTENTS'>합계(VAT별도)");
	        contents.append("</td>");
	        contents.append("<td align=center valign=middle class='CONTENTS'>");
	        contents.append("</td>");
	        contents.append("<td align=center valign=middle class='CONTENTS'>");
	        contents.append("</td>");
	        contents.append("<td align=center valign=middle class='CONTENTS'>");
	        contents.append("</td>");
	        contents.append("<td align=right valign=middle class='CONTENTS'>");
	        contents.append(reList.get(0).get("TOT_CNT"));
	        contents.append("</td>");
	        contents.append("<td align=right valign=middle class='CONTENTS'>");
	        contents.append("</td>");
	        contents.append("<td align=right valign=middle class='CONTENTS'>");
	        contents.append(reList.get(0).get("TOT_AMT")); 
	        contents.append("</td>");
	        contents.append("</tr>");
	        contents.append("</tbody>");
	        contents.append("</table>");
	        contents.append("</td>");
	        contents.append("</tr>");
		    contents.append("</table>");
	        contents.append("</td>");
	        contents.append("</tr>");contents.append("<br>");contents.append("<br>");
	        contents.append("<tr>");
	        contents.append("<td colspan=4>");
	        contents.append("<table width='100%' border=0 align=center cellpadding=0 cellspacing=0 style='border-width: 1px; border-color: rgb(182, 188, 195); width: 100%; font-family: 굴림체; font-size: 9pt; border-collapse: collapse; table-layout: fixed;' valign=middle>");
	        contents.append("<colgroup>");
	        contents.append("<col width=90>");
	        contents.append("<col width='*'>");
	        contents.append("</colgroup>");
	        contents.append("<tbody>");
	        contents.append("<tr height=30>");
	        contents.append("<td align=center valign=middle style='border: 1px solid rgb(182, 188, 195); border-image: none; font-family: 굴림체; font-size: 9pt; background-color: #dedede'>비고사항");
	        contents.append("</td>");
	        contents.append("<td colspan=3 align=left valign=middle class='FIELD' style='border: 1px solid rgb(182, 188, 195); border-image: none; padding-left: 5px; font-family: 굴림체; font-size: 9pt;'>");
	        contents.append("<p style='margin: 0px; padding: 0px;'>"); // 추가
	        contents.append(appData.get("DOCU_CONT"));    			   // 추가
	        contents.append("</p>");								   // 추가
	        contents.append("</td>");
	        contents.append("</tr>");
	        contents.append("</tbody>");
	        contents.append("</table>");
	        contents.append("</td>");
	        contents.append("</tr>");
	        contents.append("<tr height=5>");
	        contents.append("<td align=center valign=middle class='header' colspan=4>");
	        contents.append("<p style='margin: 0px; padding: 0px;'>&nbsp;");
	        contents.append("</p>");
	        contents.append("</td>");
	        contents.append("</tr>");
	        contents.append("<tr height=30>");
	        contents.append("<td align=left valign=middle class='footer' colspan=4>");
	        contents.append("<p style='margin: 0px; padding: 0px;'>");
	//        contents.append(appData.get("DOCU_CONT"));
	        contents.append("</p>");
	        contents.append("</td>");
	        contents.append("</tr>");
	        contents.append("<tr height=30>");
	        contents.append("<td align=right valign=middle class='footer' colspan=4>");
	        contents.append("<p style='margin: 0px; padding: 0px;'>");
	        contents.append(appData.get("USER_NM"));
	        contents.append("</p>");
	        contents.append("</td>");
	        contents.append("</tr>");
		    contents.append("</table>");
		    contents.append("</body>");
	
		    contents.append("</html>");
		    
			// sJSON 구성
			JSONObject jsonlist = new JSONObject();
			JSONArray jsonaprlist = new JSONArray(); // 결재자 리스트경
			JSONArray jsonchamlist = new JSONArray(); // 참조자 리스트 9
			
			jsonlist.put("docID", "");
			jsonlist.put("docTitle", appData.get("DOCU_TITLE")); // 제목
			jsonlist.put("docBody", contents.toString()); // 본문
			
			jsonlist.put("formID",formid);
			
			jsonlist.put("company", "CA"); // 회사코드  CA: 애경캐미칼
			jsonlist.put("actionType", "A03001"); // 결재타임_A03008 : 개인순차협의 
			jsonlist.put("actionState", "A04002"); // 결재상태 A04002 : 기안
			
			jsonlist.put("actionComment", ""); // 결재자 의견
			
			
			for (Map<String, String> iMap : aplList) {
				String pass_tp = iMap.get("APPRACTIONCD"); // 0:기안 , 1:결재, 9:참조
				JSONObject json = new JSONObject();
				
				 if (pass_tp.equals("0") || pass_tp.equals("1")) { // 결재자 정보
					
					if (pass_tp.equals("0")) {
						jsonlist.put("writeUser", iMap.get("LEGACY_USER_ID")); 
						jsonlist.put("actionUser", iMap.get("LEGACY_USER_ID")); 
					}
					json.put("aprMemberID", iMap.get("LEGACY_USER_ID"));  // 결재자 사번
					json.put("aprMemberName1", iMap.get("USER_NAME_LOC"));  // 결재자 명(한굴)
					json.put("aprMemberName2", "");  // 결재자 명(영문)
					json.put("aprMemberTitle1", "");  // 결재자 직위(한글)
					json.put("aprMemberTitle2", "");  // 결재자 직위(한글)
					json.put("aprMemberDeptCode", "");  // 결재자 부서코드
					json.put("aprMemberDeptName1", "");  // 결재자 부서명(한글)
					json.put("aprMemberDeptName2", "");  // 결재자 부서명(한글)
					json.put("aprMemberLoginID", iMap.get("LEGACY_USER_ID"));  // 결재자 아이디
					json.put("aprMemberSingImg","");
					json.put("aprMemberAppType", "A03001");  // 결재자 결재타입
					json.put("aprMemberCompanyName", "");  
	
					jsonaprlist.put(json);
					
				} else if (pass_tp.equals("9")) { // 참조자 정보
					json.put("chamjoMemberID", iMap.get("LEGACY_USER_ID"));  // 참조자 사번
					json.put("chamjoMemberName1", iMap.get("USER_NAME_LOC"));  // 참조자 명(한굴)
					json.put("chamjoMemberName2", "");  // 참조자 명(영문)
					json.put("chamjoMemberDeptCode", "");  // 참조자 부서코드
					json.put("chamjoMemberDeptName1", "");  // 참조자 부서명(한글)
					json.put("chamjoMemberDeptName2", "");  // 참조자 부서명(한글)
					
					jsonchamlist.put(json);
				}
			}
			
			jsonlist.put("aprLineInfo", jsonaprlist);
			jsonlist.put("chamjoInfo", jsonchamlist);
			jsonlist.put("packageId", "CAMRO");	
			jsonlist.put("workflowProcessId", reList.get(0).get("BUYER")+ docu_no);	// GWXXXXXX
			
			String str = jsonlist.toString();
			
			StringBuffer xml	= new StringBuffer();
	
			xml.append("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
			xml.append("<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>");
			xml.append("<soap:Body>");
			xml.append("<ExecuteDoc_Json_NewDoc xmlns='http://ezGateWay.ezApprovalM.Kaoni.com/'>");
			xml.append("<sJson>");
			xml.append(str.replaceAll("&", "＆").replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
			xml.append("</sJson>");
			xml.append("</ExecuteDoc_Json_NewDoc>");
			xml.append("</soap:Body>");
			xml.append("</soap:Envelope>");
			
			String new_xml = xml.toString().replaceAll("\\\\/", "/");
			
			URL url = new URL(st_url);
			// Https SSL인증서 무시하기
        	try {	        		
        		ignorSsl();	        		
        	} catch(Exception e) {
        		e.printStackTrace();
        	}  
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
	
			con.setRequestMethod("POST");
			con.setRequestProperty("Content-Type", "text/xml; charset=utf-8");
			con.setConnectTimeout(10000);
			con.setDoOutput(true);
			
			con.connect();
			
			try {
				OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream(), "utf-8");
				BufferedWriter bw = new BufferedWriter(wr);
				bw.write(new_xml);
				bw.flush();
				bw.close();				
			}catch (Exception e) {
				LOGGER.info("### Aeky appr price input error");
				LOGGER.error("### Aeky appr price SQL ERROR : "+ e.getMessage());
				throw new Exception("### Aeky appr price input error~!");
			}
			
			try {
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				StringBuilder response = new StringBuilder();
				String responseLine = null;
				while ((responseLine = br.readLine()) != null ) {					
					response.append(responseLine).append("\n");
				}	
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
				factory.setNamespaceAware(true);
				DocumentBuilder builder = factory.newDocumentBuilder();
				Document document = builder.parse(new InputSource(new StringReader(response.toString())));
			    
				NodeList nodelist = document.getElementsByTagName("ExecuteDoc_Json_NewDocResult");
				Node node = nodelist.item(0);
				Node text = node.getFirstChild();
				
				String rtntext = text.getNodeValue();
				
				System.out.println("rtntext = "+ rtntext);
				
				String [] rtntextlist = rtntext.split("\\^");
			
			    if (rtntextlist[0].equals("TRUE")) {
					formData.put("AeKyDocNo", rtntextlist[1]);
					
					sqlSessionTemplate.update("buyer.mpso.updateAeKyRqdtDocNo", formData);	// -> ★ 애경 회신 코드를 rqdt/ ref_no에 업데이트
			    }else {
			    	throw new Exception("### Aeky appr price Return Error");
			    }
			    
			}catch (Exception e) {
				LOGGER.info("### Aeky appr price output error");
				e.printStackTrace();
				LOGGER.error("### Aeky appr price output SQL ERROR : "+ e.getMessage());
				throw new Exception("### Aeky appr price output error!!!");
			} 
		
		} catch (Exception e) {
			String errMsg = "애경 단가합의 품의 상신 실패.";
			e.printStackTrace();
			
			LOGGER.error("errMsg : [ "+errMsg+" ] ");
			LOGGER.error("SQL ERROR : "+ e.getMessage());
			
			throw new RuntimeException(errMsg);
		}
		
		return result;
	}
	
	// Https SSL 인증서 무시 함수
	public static void ignorSsl() throws Exception{
		TrustManager[] trustAllCerts = new TrustManager[] { 
			new X509TrustManager() {
				public X509Certificate[] getAcceptedIssuers() {return null;}
				public void checkClientTrusted(X509Certificate[] certs, String authType) {}
				public void checkServerTrusted(X509Certificate[] certs, String authType) {}
		  } 
		};
		
		// Install the all-trusting trust manager
        try {
        	SSLContext sc = SSLContext.getInstance("SSL");
        	sc.init(null, trustAllCerts, new java.security.SecureRandom());
    		HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
    		// Create all-trusting host name verifier
    		HostnameVerifier allHostsValid = new HostnameVerifier() {
    			public boolean verify(String hostname, SSLSession session){
    				return true;
    			}
    		};

    		// Install the all-trusting host verifier
    		HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
        }catch(Exception e) {
        	e.printStackTrace();
        }
	}
	public void insertIFAppInfoTYPE05(Map<String, String> formData) throws Exception {
		/**
		 * 결재정보 저장 저장
		 * 1. SELECT PR LIST
		 * 2. MAKE CONTENTS....
		 * 3. INSERT INTO EAI.IF_APL_SEND
		 * 4. INSERT INTO EAI.IF_APM_SEND
		 * 5. UPDATE EAI.IF_APM_SEND.CONTENTS
		 */
		
 		List<Map<String, String>> prList	= sqlSessionTemplate.selectList("buyer.mpso.selectIFAppPrList", formData);
		Map<String, String> appData	= sqlSessionTemplate.selectOne("buyer.mpso.selectIFAppInfo", formData);
		String st_server_mode	= formData.get("st_server_mode").toString();
		
		StringBuffer contents	= new StringBuffer();

		// 파일 첨부 처리용 변수 선언.
		InputStream is = null;
		BufferedInputStream bis = null;
		ByteArrayOutputStream arrayBuff = null;
		int MAX_BUF_BYTE	= 1024000;	// 1MB
		String osName = System.getProperty("os.name");	// 환경에 따른 설정을 변경하기 위함.
		
		contents.append("<pre>");
		contents.append(appData.get("DOCU_CONT"));
		contents.append("</pre>");
		contents.append("<br><hr><br>\n");
		contents.append("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>\n");
		contents.append("<html>\n");
		contents.append("<head>\n");
		contents.append("<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>\n");
		contents.append("</head>\n");
		contents.append("<body leftmargin='10' topmargin='10' marginwidth='0' marginheight='0'>\n");
		contents.append("<table width='720' border='0' cellspacing='0' cellpadding='0'>\n");
		contents.append("<tr>\n");
		contents.append("<td>\n");
		contents.append("<table width='100%' border='0' cellpadding='2' cellspacing='1' bgcolor='#d6e0f2' style='font-family:Dotum;font-size:9pt;color:#555555;word-break:break-all'>\n");

		contents.append("<tr bgcolor='#F0F6FB' align='center'>\n");
		contents.append("<td width='80' height='24'>품목코드</td>\n");
		contents.append("<td width='200'>품목명</td>\n");
		contents.append("<td width='50'>단위</td>\n");
		contents.append("<td width='125'>예산부서</td>\n");
		contents.append("<td width='125'>계정</td>\n");
		contents.append("<td width='70'>주문일자</td>\n");
		contents.append("<td width='70'>희망납기</td>\n");
		contents.append("</tr>\n");
		contents.append("<tr bgcolor='#F0F6FB' align='center'>\n");
		contents.append("<td width='80' height='24'>주문번호</td>\n");
		contents.append("<td width='200'>규격</td>\n");
		contents.append("<td width='50'>통화</td>\n");
		contents.append("<td width='125'>공급사명</td>\n");
		contents.append("<td width='125'>수량</td>\n");
		contents.append("<td width='70'>단가</td>\n");
		contents.append("<td width='70'>금액</td>\n");
		contents.append("</tr>\n");
		  
		// #ffffff #F5F5F5
		String bgColor	= "";
		for(int i = 0 ; i < prList.size() ; i++ ) {
			
			Map<String, String> tMap	= prList.get(i);
			
			if (i%2 == 0) bgColor	= "#ffffff";
			else bgColor	= "#F5F5F5";
			
			contents.append("<tr bgcolor="+bgColor+">\n");
			contents.append("<td height='24' align='left'>"+tMap.get("BUYER_ITEM_NO")+"</td>\n");
			contents.append("<td><font title='"+tMap.get("DESCRIPTION")+"'>"+tMap.get("DESCRIPTION")+"</font></td>\n");
			contents.append("<td align='center'>"+tMap.get("UNIT_MEASURE")+"</td>\n");
			contents.append("<td><font title='"+tMap.get("BUDGET_DEPT")+"'>"+tMap.get("BUDGET_DEPT")+"</font></td>\n");
			contents.append("<td><font title='"+tMap.get("ACCOUNT_TYPE")+"'>"+tMap.get("ACCOUNT_TYPE")+"</font></td>\n");
			contents.append("<td align='center'>"+tMap.get("ADD_DATE")+"</td>\n");
			contents.append("<td align='center'>"+tMap.get("RD_DATE")+"</td>\n");
			contents.append("</tr>\n");
			contents.append("<tr height=30 bgcolor="+bgColor+">\n");
			contents.append("<td height='24' align='left'>"+tMap.get("PR_NO")+"<br></td>\n");
			contents.append("<td><font title='"+tMap.get("SPECIFICATION")+"'>"+tMap.get("SPECIFICATION")+"</font></td>\n");
			contents.append("<td align='center'>"+tMap.get("CUR")+"</td>\n");
			contents.append("<td><font title='"+tMap.get("AGENT_NAME")+"'>"+tMap.get("AGENT_NAME")+"</font></td>\n");
			contents.append("<td align='right'>"+tMap.get("TARGET_QTY")+"</td>\n");
			contents.append("<td align='right'>"+tMap.get("PRICE")+"&nbsp;</td>\n");
			contents.append("<td align='right'>"+tMap.get("AMT")+"&nbsp;</td>\n");
			contents.append("</tr>\n");
		}
		
		contents.append("<tr>\n");
		contents.append("<td colspan= '7' align='center'><b>&nbsp;총금액&nbsp;<font color='ff0000'>"+prList.get(0).get("TOT_AMT")+"</font>&nbsp;KRW&nbsp;(&nbsp;총&nbsp;"+prList.get(0).get("TOT_CNT")+"&nbsp;품목&nbsp;) </b></td>\n");
		contents.append("</tr>\n");
		
		contents.append("</table>\n");
		contents.append("</td>\n");
		contents.append("</tr>\n");
		contents.append("</table>\n");
		contents.append("</body>\n");
		contents.append("</html>\n");
		
		appData.put("CONTENTS",contents.toString());

		sqlSessionTemplate.update("buyer.mpso.updateAppUserInfo", appData);
		sqlSessionTemplate.update("buyer.mpso.insertIfAplSend", appData);
		sqlSessionTemplate.update("buyer.mpso.insertIfApmSend", appData);
		
		// 결재정보 조회 1. SELECT T_APPR_OUT_STEP DATA
		Map<String, String> apmData	= sqlSessionTemplate.selectOne("buyer.mpso.selectHanhwaDocu", appData);
		// 결재선 조회. 2. SELECT T_APPR_LINE_OUT_STEP DATA
		List<Map<String, String>> aplList	= sqlSessionTemplate.selectList("buyer.mpso.selectHanhwaPassln", appData);
		List<Map<String, String>> appFileList	= null;
		// 첨부파일 리스트 조회 3. SELECT ICOMATCH DATA
		if (apmData.get("IMAGE_KEY") != null && !"".equals(apmData.get("IMAGE_KEY"))) {
			appFileList	= sqlSessionTemplate.selectList("buyer.mpso.selectHanhwaAttFileList", apmData);
		}
		
		
		com.koreab2b.mro.webservice.hwdefense.T_APPR_OUT_STEP[]	apprOut	= new com.koreab2b.mro.webservice.hwdefense.T_APPR_OUT_STEP[1];
		// 결재선 정보 객체 생성.
		com.koreab2b.mro.webservice.hwdefense.T_APPR_LINE_OUT_STEP[]	apprLineOut	= new com.koreab2b.mro.webservice.hwdefense.T_APPR_LINE_OUT_STEP[aplList.size()];

		// 결재선 정보 입력
		for(int i = 0 ; i < aplList.size() ; i++) {
			com.koreab2b.mro.webservice.hwdefense.T_APPR_LINE_OUT_STEP tApprLine	= new com.koreab2b.mro.webservice.hwdefense.T_APPR_LINE_OUT_STEP();
			Map<String, String> tMap	= aplList.get(i);
			
			tApprLine.setAPPRID(tMap.get("APPRID"));
			tApprLine.setAPPRSEQ(tMap.get("APPRSEQ"));
			tApprLine.setAPPRACTIONCD(tMap.get("APPRACTIONCD"));
			tApprLine.setAPPRSTATUSCD("0");	// 0
			tApprLine.setAPPRUID(tMap.get("LEGACY_USER_ID"));
			tApprLine.setAPPRNM(tMap.get("USER_NAME_LOC"));
			tApprLine.setAPPRDEPTNM(tMap.get("APPRDEPTNM"));
//			APPRCONFIRMDT	-- 불필요 필드로 예상
//			APPRGRDNM	-- 불필요 필드로 예상
//			APPROPINION	-- 불필요 필드로 예상
			tApprLine.setINSERTUID(apmData.get("LEGACY_USER_ID"));
			tApprLine.setUPDATEUID(apmData.get("LEGACY_USER_ID"));

			apprLineOut[i]	= tApprLine;
		}
		
		// 결재정보 입력
		com.koreab2b.mro.webservice.hwdefense.T_APPR_OUT_STEP tApprOut	= new com.koreab2b.mro.webservice.hwdefense.T_APPR_OUT_STEP();
		tApprOut.setSYSID("506EQ0001");	// 설비관리 : 506EQ0001
		tApprOut.setAPPRID(apmData.get("APPRID"));
		tApprOut.setAPPRTYPEID("3");	// 일반문서 : 3
		tApprOut.setAPPRTITLE(apmData.get("SUBJECT"));
		tApprOut.setAPPRCONTENTSCLOB(appData.get("CONTENTS"));
		tApprOut.setAPPRCONTENTSCD("1");	// ( 1 : html, 2 : mht )
		tApprOut.setCOMPANYID("506");		// 한화디펜스 : 506
//		DEPTOPENYN
//		FLOWCASE
//		FORMCODE
//		INITDEPTOPENYN
//		PRESERVATIONTERMCODE
		tApprOut.setINSERTUID(apmData.get("LEGACY_USER_ID"));
		tApprOut.setUPDATEUID(apmData.get("LEGACY_USER_ID"));
		tApprOut.setAPPRSUBMITDT(apmData.get("ADD_DATE"));	// MM/DD/YYYY HH24:MI:SS
		tApprOut.setAPPRSTATUSCD("0");	// 0:상신중
		tApprOut.setT_APPR_LINE_OUT_STEP(apprLineOut);

		// 첨부파일 로딩 객체 생성.
		if ( appFileList != null && appFileList.size() > 0) {

			com.koreab2b.mro.webservice.hwdefense.WsApAttachFile[] attFiles	= new com.koreab2b.mro.webservice.hwdefense.WsApAttachFile[appFileList.size()];
			for(int i = 0 ; i < appFileList.size() ; i++) {
				Map<String, String> fMap	= appFileList.get(i);
				com.koreab2b.mro.webservice.hwdefense.WsApAttachFile tFile	= new com.koreab2b.mro.webservice.hwdefense.WsApAttachFile();

				String _filename	= (String)fMap.get("DES_FILE_NAME");
				String _orgFilename	= (String)fMap.get("SRC_FILE_NAME");
				String _type = (String)fMap.get("TYPE").toString();
				String _path = "";
				String _del_file_dir = (String)fMap.get("DES_FILE_DIR").toString();
				
				if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
					_path = CommonUtil.getUploadTypePath(_type, "N")+ "/";
				}else{
					_path = CommonUtil.getUploadTypePath(_type, "N") + "/" +_del_file_dir+ "/";
				}

				try {
					System.out.println(" _path + _filename : " + _path + _filename);
					if (CommonAwsS3.doesFileExists(_path + _filename)) {
						byte[] buffer = new byte[MAX_BUF_BYTE];
						is = new FileInputStream(CommonAwsS3.download(_path + _filename, _orgFilename));
						bis = new BufferedInputStream(is);
						arrayBuff = new ByteArrayOutputStream();
					    int len = 0;
					    while ((len = bis.read(buffer)) >= 0) {
					        arrayBuff.write(buffer, 0, len);
					    }
						tFile.setFileId("KEY_001_0000" + (String)fMap.get("DOC_NO"));
						tFile.setSeqID(Integer.valueOf(fMap.get("DOC_SEQ")));
						tFile.setFileName(_orgFilename);
						tFile.setFileSize(arrayBuff.toByteArray().length);
						tFile.setFileInfo(arrayBuff.toByteArray());
					}
				} catch (Exception e) {
					LOGGER.error(CommonUtil.printStackTraceToString(e));
				} finally {
					try {is.close();} catch (Exception e2) {}
					try {bis.close();} catch (Exception e2) {}
					try {arrayBuff.close();} catch (Exception e2) {}
				}				
				
				attFiles[i]	= tFile;
				tApprOut.setATTACHFILES(attFiles);
			}
		}
		
		apprOut[0]	= tApprOut;
		
		// Call Web Service
		WSKP001WebServiceProxy proxy1	= new WSKP001WebServiceProxy(st_server_mode);

		String st_endpoint_url	= apmData.get("END_POINT");
		
		if ( !"".equals(st_endpoint_url) && st_endpoint_url != null) {
			proxy1.setEndpoint(st_endpoint_url);
		}
		
		LOGGER.error("HDFN EndPoint : " + proxy1.getEndpoint());
		
		com.koreab2b.mro.webservice.hwdefense.T_APPR_RETURN[] rtnArr = proxy1.process(apprOut);
		
		System.out.println("hwdefense.T_APPR_RETURN : " + rtnArr.length);
		LOGGER.error("hwdefense.T_APPR_RETURN : " + rtnArr.length);
		
		for(int i = 0 ; i < rtnArr.length ; i++ ) {
			rtnArr[i].getERRORDESC4();
			rtnArr[i].getAPPRID();
			rtnArr[i].getAPPRSTATUSCD();
			System.out.println("hwdefense.T_APPR_RETURN["+i+"] : " + rtnArr[i].getAPPRID() + " / " + rtnArr[i].getAPPRSTATUSCD() + " / " + rtnArr[i].getERRORDESC4() + " / " + appData.get("COMPANY") + " / " + appData.get("DOCU_NO"));
			LOGGER.error("hwdefense.T_APPR_RETURN["+i+"] : " + rtnArr[i].getAPPRID() + " / " + rtnArr[i].getAPPRSTATUSCD() + " / " + rtnArr[i].getERRORDESC4() + " / " + appData.get("COMPANY") + " / " + appData.get("DOCU_NO"));
			
			Map<String, String> rMap = new HashMap<String, String>();
			rMap.put("KEY_NO", apmData.get("APPRID"));
			rMap.put("RESULT_FLAG", rtnArr[i].getAPPRSTATUSCD());
			rMap.put("RESULT_MSG", rtnArr[i].getERRORDESC4());
			rMap.put("BUYER", appData.get("COMPANY"));
			rMap.put("DOC_NO", appData.get("DOCU_NO"));
			
			sqlSessionTemplate.update("buyer.mpso.updateApmSendResult",rMap);
			
			if ( rtnArr[i].getT_APPR_LINE_RETURN() != null ) {
				com.koreab2b.mro.webservice.hwdefense.T_APPR_LINE_RETURN[] rtnArrLine = rtnArr[i].getT_APPR_LINE_RETURN();
				for(int j = 0 ; j < rtnArrLine.length ; j++) {
					LOGGER.error("hwdefense.T_APPR_LINE_RETURN["+i+"]["+j+"] : " + rtnArrLine[j].getERRORDESC4());
				}	
			}
		}
	}
	
	public void insertIFAppInfo(Map<String, String> formData) throws Exception {
		/**
		 * 결재정보 저장 저장
		 * 1. SELECT PR LIST
		 * 2. MAKE CONTENTS....
		 * 3. INSERT INTO EAI.IF_APL_SEND
		 * 4. INSERT INTO EAI.IF_APM_SEND
		 * 5. UPDATE EAI.IF_APM_SEND.CONTENTS
		 */
		
 		List<Map<String, String>> prList	= sqlSessionTemplate.selectList("buyer.mpso.selectIFAppPrList", formData);
		Map<String, String> appData	= sqlSessionTemplate.selectOne("buyer.mpso.selectIFAppInfo", formData);
		String st_server_mode	= formData.get("st_server_mode").toString();
		
		StringBuffer contents	= new StringBuffer();

		// 파일 첨부 처리용 변수 선언.
		InputStream is = null;
		BufferedInputStream bis = null;
		ByteArrayOutputStream arrayBuff = null;
		int MAX_BUF_BYTE	= 1024000;	// 1MB
		String osName = System.getProperty("os.name");	// 환경에 따른 설정을 변경하기 위함.
		
		contents.append("<pre>");
		contents.append(appData.get("DOCU_CONT"));
		contents.append("</pre>");
		contents.append("<br><hr><br>\n");
		contents.append("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>\n");
		contents.append("<html>\n");
		contents.append("<head>\n");
		contents.append("<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>\n");
		contents.append("</head>\n");
		contents.append("<body leftmargin='10' topmargin='10' marginwidth='0' marginheight='0'>\n");
		contents.append("<table width='720' border='0' cellspacing='0' cellpadding='0'>\n");
		contents.append("<tr>\n");
		contents.append("<td>\n");
		contents.append("<table width='100%' border='0' cellpadding='2' cellspacing='1' bgcolor='#d6e0f2' style='font-family:Dotum;font-size:9pt;color:#555555;word-break:break-all'>\n");

		contents.append("<tr bgcolor='#F0F6FB' align='center'>\n");
		contents.append("<td width='80' height='24'>품목코드</td>\n");
		contents.append("<td width='200'>품목명</td>\n");
		contents.append("<td width='50'>단위</td>\n");
		contents.append("<td width='125'>예산부서</td>\n");
		contents.append("<td width='125'>계정</td>\n");
		contents.append("<td width='70'>주문일자</td>\n");
		contents.append("<td width='70'>희망납기</td>\n");
		contents.append("</tr>\n");
		contents.append("<tr bgcolor='#F0F6FB' align='center'>\n");
		contents.append("<td width='80' height='24'>주문번호</td>\n");
		contents.append("<td width='200'>규격</td>\n");
		contents.append("<td width='50'>통화</td>\n");
		contents.append("<td width='125'>공급사명</td>\n");
		contents.append("<td width='125'>수량</td>\n");
		contents.append("<td width='70'>단가</td>\n");
		contents.append("<td width='70'>금액</td>\n");
		contents.append("</tr>\n");
		
		// #ffffff #F5F5F5
		String bgColor	= "";
		for(int i = 0 ; i < prList.size() ; i++ ) {
			
			Map<String, String> tMap	= prList.get(i);
			
			if (i%2 == 0) bgColor	= "#ffffff";
			else bgColor	= "#F5F5F5";
			
			contents.append("<tr bgcolor="+bgColor+">\n");
			contents.append("<td height='24' align='left'>"+tMap.get("BUYER_ITEM_NO")+"</td>\n");
			contents.append("<td><font title='"+tMap.get("DESCRIPTION")+"'>"+tMap.get("DESCRIPTION")+"</font></td>\n");
			contents.append("<td align='center'>"+tMap.get("UNIT_MEASURE")+"</td>\n");
			contents.append("<td><font title='"+tMap.get("BUDGET_DEPT")+"'>"+tMap.get("BUDGET_DEPT")+"</font></td>\n");
			contents.append("<td><font title='"+tMap.get("ACCOUNT_TYPE")+"'>"+tMap.get("ACCOUNT_TYPE")+"</font></td>\n");
			contents.append("<td align='center'>"+tMap.get("ADD_DATE")+"</td>\n");
			contents.append("<td align='center'>"+tMap.get("RD_DATE")+"</td>\n");
			contents.append("</tr>\n");
			contents.append("<tr height=30 bgcolor="+bgColor+">\n");
			contents.append("<td height='24' align='left'>"+tMap.get("PR_NO")+"<br></td>\n");
			contents.append("<td><font title='"+tMap.get("SPECIFICATION")+"'>"+tMap.get("SPECIFICATION")+"</font></td>\n");
			contents.append("<td align='center'>"+tMap.get("CUR")+"</td>\n");
			contents.append("<td><font title='"+tMap.get("AGENT_NAME")+"'>"+tMap.get("AGENT_NAME")+"</font></td>\n");
			contents.append("<td align='right'>"+tMap.get("TARGET_QTY")+"</td>\n");
			contents.append("<td align='right'>"+tMap.get("PRICE")+"&nbsp;</td>\n");
			contents.append("<td align='right'>"+tMap.get("AMT")+"&nbsp;</td>\n");
			contents.append("</tr>\n");
		}
		
		contents.append("<tr>\n");
		contents.append("<td colspan= '7' align='center'><b>&nbsp;총금액&nbsp;<font color='ff0000'>"+prList.get(0).get("TOT_AMT")+"</font>&nbsp;KRW&nbsp;(&nbsp;총&nbsp;"+prList.get(0).get("TOT_CNT")+"&nbsp;품목&nbsp;) </b></td>\n");
		contents.append("</tr>\n");
		
		contents.append("</table>\n");
		contents.append("</td>\n");
		contents.append("</tr>\n");
		contents.append("</table>\n");
		contents.append("</body>\n");
		contents.append("</html>\n");
		
		appData.put("CONTENTS",contents.toString());

		sqlSessionTemplate.update("buyer.mpso.updateAppUserInfo", appData);
		sqlSessionTemplate.update("buyer.mpso.insertIfAplSend", appData);
		sqlSessionTemplate.update("buyer.mpso.insertIfApmSend", appData);
		
		// 결재정보 조회 1. SELECT T_APPR_OUT_STEP DATA
		Map<String, String> apmData	= sqlSessionTemplate.selectOne("buyer.mpso.selectHanhwaDocu", appData);
		// 결재선 조회. 2. SELECT T_APPR_LINE_OUT_STEP DATA
		List<Map<String, String>> aplList	= sqlSessionTemplate.selectList("buyer.mpso.selectHanhwaPassln", appData);
		List<Map<String, String>> appFileList	= null;
		// 첨부파일 리스트 조회 3. SELECT ICOMATCH DATA
		if (apmData.get("IMAGE_KEY") != null && !"".equals(apmData.get("IMAGE_KEY"))) {
			appFileList	= sqlSessionTemplate.selectList("buyer.mpso.selectHanhwaAttFileList", apmData);
		}
		
		// 결재정보 객체 생성.
		T_APPR_OUT_STEP[]	apprOut	= new T_APPR_OUT_STEP[1];
		// 결재선 정보 객체 생성.
		T_APPR_LINE_OUT_STEP[]	apprLineOut	= new T_APPR_LINE_OUT_STEP[aplList.size()];

		// 결재선 정보 입력
		for(int i = 0 ; i < aplList.size() ; i++) {
			T_APPR_LINE_OUT_STEP tApprLine	= new T_APPR_LINE_OUT_STEP();
			Map<String, String> tMap	= aplList.get(i);
			
			tApprLine.setAPPRID(tMap.get("APPRID"));
			tApprLine.setAPPRSEQ(tMap.get("APPRSEQ"));
			tApprLine.setAPPRACTIONSEQ(tMap.get("APPRSEQ"));
			tApprLine.setAPPRACTIONCD(tMap.get("APPRACTIONCD"));
			tApprLine.setAPPRSTATUSCD("0");	// 0
			tApprLine.setAPPRUID(tMap.get("LEGACY_USER_ID"));
			tApprLine.setAPPRNM(tMap.get("USER_NAME_LOC"));
			tApprLine.setAPPRDEPTNM(tMap.get("APPRDEPTNM"));
			tApprLine.setINSERTUID(apmData.get("LEGACY_USER_ID"));
			tApprLine.setUPDATEUID(apmData.get("LEGACY_USER_ID"));
			tApprLine.setAPPRSGID(tMap.get("LEGACY_USER_ID"));
			
			apprLineOut[i]	= tApprLine;
		}
		
		// 결재정보 입력
		T_APPR_OUT_STEP tApprOut	= new T_APPR_OUT_STEP();
		tApprOut.setAPPRID(apmData.get("APPRID"));
		tApprOut.setSYSID("HTW_KEP1");	// HTW_KEP1
		tApprOut.setSGSVRLOCANM("KR");	// KR
		tApprOut.setAPPRCONTENTSCD("H");	// H
		tApprOut.setAPPRCONTENTSCLOB(appData.get("CONTENTS"));
		tApprOut.setAPPRTRANSSTATUSCD("1");	// 1:상신
		tApprOut.setAPPRTITLE(apmData.get("SUBJECT"));
		tApprOut.setAPPRSTATUSCD("0");	// 0:상신중
		tApprOut.setAPPRTYPEID("KEP_001");	// KEP_001
		tApprOut.setINSERTUID(apmData.get("LEGACY_USER_ID"));
		tApprOut.setUPDATEUID(apmData.get("LEGACY_USER_ID"));
		tApprOut.setAPPRSUBMITDT(apmData.get("ADD_DATE"));	// MM/DD/YYYY HH24:MI:SS
		tApprOut.setAPPRREVNO("1");
		tApprOut.setCOMPCD(apmData.get("COMP_CD"));
		tApprOut.setSHIFTDATA(apmData.get("SHIFT_DATA"));
		tApprOut.setT_APPR_LINE_OUT_STEP(apprLineOut);

		// 첨부파일 로딩 객체 생성.
		if ( appFileList != null && appFileList.size() > 0) {

			WsApAttachFile[] attFiles	= new WsApAttachFile[appFileList.size()];
			for(int i = 0 ; i < appFileList.size() ; i++) {
				Map<String, String> fMap	= appFileList.get(i);
				WsApAttachFile tFile	= new WsApAttachFile();
				
				String _filename	= (String)fMap.get("DES_FILE_NAME");
				String _orgFilename	= (String)fMap.get("SRC_FILE_NAME");
				String _type = (String)fMap.get("TYPE").toString();
				String _path = "";
				String _del_file_dir = (String)fMap.get("DES_FILE_DIR").toString();
				
				if ("./".equals(_del_file_dir) || "".equals(_del_file_dir)){
					_path = CommonUtil.getUploadTypePath(_type, "N")+ "/";
				}else{
					_path = CommonUtil.getUploadTypePath(_type, "N") + "/" +_del_file_dir+ "/";
				}

				try {
					System.out.println(" _path + _filename : " + _path + _filename);
					if (CommonAwsS3.doesFileExists(_path + _filename)) {
						byte[] buffer = new byte[MAX_BUF_BYTE];
						is = new FileInputStream(CommonAwsS3.download(_path + _filename, _orgFilename));
						bis = new BufferedInputStream(is);
						arrayBuff = new ByteArrayOutputStream();
					    int len = 0;
					    while ((len = bis.read(buffer)) >= 0) {
					        arrayBuff.write(buffer, 0, len);
					    }
						tFile.setFileId("KEY_001_0000" + (String)fMap.get("DOC_NO"));
						tFile.setSeqID(Integer.valueOf(fMap.get("DOC_SEQ")));
						tFile.setFileName(_orgFilename);
						tFile.setFileSize(Integer.toString(arrayBuff.toByteArray().length));
						tFile.setFileInfo(arrayBuff.toByteArray());
					}
				} catch (Exception e) {
					LOGGER.error(CommonUtil.printStackTraceToString(e));
				} finally {
					try {is.close();} catch (Exception e2) {}
					try {bis.close();} catch (Exception e2) {}
					try {arrayBuff.close();} catch (Exception e2) {}
				}
				
				attFiles[i]	= tFile;
				tApprOut.setATTACHFILES(attFiles);
			}
		}
		
		apprOut[0]	= tApprOut;
		
		// Call Web Service
		M2KEP0001M2016Proxy proxy1	= new M2KEP0001M2016Proxy(st_server_mode);
		String st_endpoint_url	= apmData.get("END_POINT");
		
		if ( !"".equals(st_endpoint_url) && st_endpoint_url != null) {
			proxy1.setEndpoint(st_endpoint_url);	
		}
		
		LOGGER.error("HWin EndPoint : " + proxy1.getEndpoint());
		
		proxy1.process(apprOut);
	}
	
	public void insertIFAppHeaderInfo(Map<String, String> formData) throws Exception {
				
		String buyer	= formData.get("st_buyer");
		String pr_no	= formData.get("sPR_No");
		
		Map<String, String> appData	= new HashMap<String, String>();
		
		appData.put("COMPANY",buyer);
		appData.put("DOCU_NO",pr_no);
		appData.put("DOCU_TITLE",".");
		appData.put("CONTENTS",".");
		appData.put("USER_ID",formData.get("st_user_id"));
		appData.put("USER_NM",formData.get("st_user_name"));
		appData.put("APP_DATE",formData.get("st_po_create_date"));
		appData.put("APPR_ID",formData.get("st_user_id"));

		sqlSessionTemplate.insert("buyer.mpso.insertIfApmSend", appData);
		
		List<Map<String, Object>> prdtList	= sqlSessionTemplate.selectList("buyer.mpso.selectWooJinPRList", appData);

		Map<String, Object> appHeader	= sqlSessionTemplate.selectOne("buyer.mpso.selectWoojinHeaderInfo", appData);
		
		sqlSessionTemplate.update("buyer.mpso.updatePrRecvFlag", appData);
		
		String conn_url	= null;
		String id	= null;
		String pass	= null;
		String class_name	= null;

		try {
			Map<String, String> sMap = CommonUtil.getSpecialCheckReturnMap(buyer, "P11-0000004");
			conn_url	= sMap.get("COL02_DATA");
			id			= sMap.get("COL03_DATA");
			pass		= sMap.get("COL04_DATA");
			class_name	= sMap.get("COL05_DATA");
		} catch(Exception e) {
			LOGGER.error(CommonUtil.printStackTraceToString(e));
		}

		Connection conn	= null;
		PreparedStatement stmt1	= null;
		PreparedStatement stmt2	= null;
		PreparedStatement stmt3	= null;

		StringBuffer sql1	= new StringBuffer();
		StringBuffer sql2	= new StringBuffer();
		StringBuffer sql3	= new StringBuffer();
		
		ResultSet	rs1	= null;
		
		int idx	= 0;
		int cnt	= 0;
		
		/**
		 * ZKEP_APP 중복체크
		 * ZKEP_PRDT 중복체크
		 */
		
		try {
			Class.forName(class_name);
			conn	= DriverManager.getConnection(conn_url, id, pass);
			
			sql1.append("SELECT COUNT(*) AS CNT FROM ZKEP_APP WHERE APPRO_KEY = ?");
			stmt1	= conn.prepareStatement(sql1.toString());
			
			idx = 1;
			stmt1.setString(idx++, pr_no);
			
			rs1	= stmt1.executeQuery();
			
			while(rs1.next()) {
				cnt	= rs1.getInt("CNT");
			}
			
			if ( 0 == cnt ) {

				sql2.append("INSERT INTO ZKEP_APP (	\n");
				sql2.append("	APPRO_KEY, FCODE, LOCATION_NAME, REQ_USER_NAME, REQ_USER_DEPT_NAME, REMARK	\n");
				sql2.append(") VALUES (				\n");
				sql2.append("	?, ?, ?, ?, ?, ?	\n");
				sql2.append(")						\n");
				stmt2	= conn.prepareStatement(sql2.toString());
				
				idx	= 1;
				stmt2.clearParameters();
				stmt2.setString(idx++, pr_no);
				stmt2.setString(idx++, "소모품");
				stmt2.setString(idx++, (String)appHeader.get("LOCATION_NAME"));
				stmt2.setString(idx++, formData.get("st_user_name"));
				stmt2.setString(idx++, (String)appHeader.get("REQ_USER_DEPT_NAME"));
				stmt2.setString(idx++, formData.get("st_remark"));

				stmt2.executeUpdate();

				sql3.append("INSERT INTO ZKEP_PRDT (	\n");
				sql3.append("	APPRO_KEY, PLANT, PR_NO, PR_SEQ, BUYER_ITEM_NO,	\n");
				sql3.append("	DESCRIPTION, SPECIFICATION, UNIT_MEASURE, ITEM_QTY, UNIT_PRICE, 	\n");
				sql3.append("	ITEM_AMT, ACCOUNT_NAME, REMARK	\n");
				sql3.append(") VALUES (			\n");
				sql3.append("	?, ?, ?, ?, ?, 	\n");
				sql3.append("	?, ?, ?, ?, ?, 	\n");
				sql3.append("	?, ?, ?			\n");
				sql3.append(")					\n");
				stmt3	= conn.prepareStatement(sql3.toString());

				for(Map<String, Object> tmp : prdtList) {
					idx	= 1;
					stmt3.clearParameters();
					
					stmt3.setString(idx++, pr_no);
					stmt3.setString(idx++, (String)tmp.get("PLANT"));
					stmt3.setString(idx++, (String)tmp.get("PR_NO"));
					stmt3.setString(idx++, (String)tmp.get("PR_SEQ"));
					stmt3.setString(idx++, (String)tmp.get("BUYER_ITEM_NO"));
					stmt3.setString(idx++, (String)tmp.get("DESCRIPTION"));
					stmt3.setString(idx++, (String)tmp.get("SPECIFICATION"));
					stmt3.setString(idx++, (String)tmp.get("UNIT_MEASURE"));
					stmt3.setBigDecimal(idx++, (BigDecimal)tmp.get("ITEM_QTY"));
					stmt3.setBigDecimal(idx++, (BigDecimal)tmp.get("UNIT_PRICE"));
					stmt3.setBigDecimal(idx++, (BigDecimal)tmp.get("ITEM_AMT"));
					stmt3.setString(idx++, (String)tmp.get("ACCOUNT_NAME"));
					stmt3.setString(idx++, (String)tmp.get("REMARK"));
					
					stmt3.executeUpdate();
				}
			}
		} catch (Exception e) {
			cnt	= -99;
			LOGGER.error(CommonUtil.printStackTraceToString(e));
		} finally {
			try{if (rs1 != null) rs1.close();}catch(Exception e2){}
			
			try{if (stmt1 != null) stmt1.close();}catch(Exception e2){}
			try{if (stmt2 != null) stmt2.close();}catch(Exception e2){}
			try{if (stmt3 != null) stmt3.close();}catch(Exception e2){}
			
			try{if (conn != null) conn.close();}catch(Exception e2){}
		}
		
		if ( -1 == cnt ) {
			throw new Exception("Approval Data Duplicate....Check Data ("+buyer+"/"+pr_no+")!!!");
		} else if ( -99 == cnt ) {
			throw new Exception("Customer DB Error!!");
		}
	}

	public String insertMergePxPo(Map<String, String> formData) {
		return insertMergePxPo(formData, "");
	}
	//고객사별
	public String insertMergePxPoDetail(Map<String, String> formData) {
		return insertMergePxPoDetail(formData, "");
	}
	// 직발주하는 경우 바로 이 메소드를 호출함
	// /ejb/ejb/koreab2b_src/new/sl_BuyerPo/sl_BuyerPoBean.java
	public String insertMergePxPoDetail(Map<String, String> formData, String DUPNOCHECK) {

		String Query_str = formData.get("st_query").toString();
		String strpono = "";
		String rtn = "null";

		int Po_seq = 1;
		int Po_create_max = 4;
		String Po_no = null;
		String Subject = null;
		String temp = "";

		LOGGER.debug("Query_str {} ", Query_str);
		try {

			// String Query_str = WisehubString.Iso8859ToEucKr(null2sp(request.getParameter("st_query")));
			String para_str[] = Query_str.split("\\|"); // WisehubString.StrToArray(WisehubString.Iso8859ToEucKr(Query_str)
														// , "^||^");
			String temp_para_str = para_str[0];
			String checkedRecord[] = temp_para_str.split("@@"); // WisehubString.StrToArray(temp_para_str , "@@");

			Map<String, String> ht = new HashMap<String, String>();

			String sRecvFlag = "";
			String buyer = "";
			String userID = para_str[2];
			String userDept = para_str[3];
			int iFlag = Integer.parseInt(para_str[4]); // 구매발주(recvFlag=1) , 발주보류(recvFlag=3)
			String userTel = para_str[5];
			String usrname = para_str[6];
			String GW_NO = para_str[7];
			String po_create_date = para_str[8];
			String gr_flag = para_str[9];
			String end_price = para_str[10];
			String px_flag = para_str[11]; // (PXPR)직발주 인지 , (PRPO)요청접수발주인지 구분
			String account_type = para_str[12]; // 계정분류
			String req_dept = para_str[13]; // 요청부서 ==> PXPR)직발주 일 경우는 userDept와 같은 값을 받음

			LOGGER.debug("sRecvFlag {} ", sRecvFlag);
			LOGGER.debug("buyer {} ", buyer);
			LOGGER.debug("userID {} ", userID);
			LOGGER.debug("userDept {} ", userDept);
			LOGGER.debug("req_dept {} ", req_dept);
			LOGGER.debug("iFlag {} ", iFlag);
			LOGGER.debug("userTel {} ", userTel);
			LOGGER.debug("usrname {} ", usrname);
			LOGGER.debug("GW_NO {} ", GW_NO);
			LOGGER.debug("po_create_date {} ", po_create_date);
			LOGGER.debug("gr_flag {} ", gr_flag);
			LOGGER.debug("end_price {} ", end_price);
			LOGGER.debug("px_flag {} ", px_flag);
			LOGGER.debug("account_type {} ", account_type);

			// conn = WisehubDBConnect.WisehubDBConnect("oracleDataSource");
			// conn.setAutoCommit(false);

			if (iFlag == 1) {
				// Recv_Flag = "PC";
				if (!"N".equals(GW_NO)) {
					sRecvFlag = "PS"; // 결재상신
				} else {
					sRecvFlag = "PC"; // 구매발주 OR 발주결재완료
				}
			} else {
				sRecvFlag = "PT";
				// Recv_Flag = "PT"; // 구매발주임시저장(발주보류)
			}

			Map<String, String> _data = null;
			Map<String, String> _podtcountData = null;

			/**
			 * 진행상태 미리 체크후 진행된게 존재하면 모두 미처리한다.
			 */
			if (checkedRecord != null) {
				for (int i = 0; i < checkedRecord.length; i++) {
					// strpono = sPR_No; // PX

					if (checkedRecord[i].length() > 0 && checkedRecord[i] != "" && checkedRecord[i] != null) {

						String temp_PXNO[] = new String[10];
						String PXNO_str[] = checkedRecord[i].split("~~~"); // WisehubString.StrToArray(checkedRecord[i]
																			// , "~~~");

						for (int k = 0; k < PXNO_str.length; k++) {
							LOGGER.debug("PXNO_str[" + k + "]==>" + PXNO_str[k]);
						}
						buyer = PXNO_str[7];
						temp_PXNO[0] = PXNO_str[7]; // BUYER
						temp_PXNO[1] = PXNO_str[0]; // PR_NO
						temp_PXNO[2] = PXNO_str[1]; // PR_SEQ/

						_data = new HashMap<String, String>();
						_data.put("BUYER", temp_PXNO[0]);
						_data.put("PR_NO", temp_PXNO[1]);
						_data.put("PR_SEQ", temp_PXNO[2]);

						if ("".equals(DUPNOCHECK)) {
							String cnt = sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRDTCheck", _data);
							if ("0".equals(cnt)) {
								return "DUP"; // 이미진행된 상태로 리턴후 화면에 메시지 출력한다.....
							}
							cnt = sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRDTCheck2", _data);
							if ("1".equals(cnt)) {
								return "DUP2"; // 이미 반려 진행된 상태로 리턴후 화면에 메시지 출력한다.....
							}
						}
					}
				} // end FOR
			}

			String sPR_No = null;

			sPR_No = getOrderNo(buyer, "PX"); // getOrderPX(buyer ,"PX");

			LOGGER.debug("insertMergePxPo sRecvFlag {} ", sRecvFlag);
			LOGGER.debug("insertMergePxPo sPR_No {} ", sPR_No);

			if (checkedRecord != null) {
				for (int i = 0; i < checkedRecord.length; i++) {
					strpono = sPR_No; // PX

					if (checkedRecord[i].length() > 0 && checkedRecord[i] != "" && checkedRecord[i] != null) {

						String temp_PXNO[] = new String[10];
						String PXNO_str[] = checkedRecord[i].split("~~~"); // WisehubString.StrToArray(checkedRecord[i]
																			// , "~~~");

						for (int k = 0; k < PXNO_str.length; k++) {
							LOGGER.debug("PXNO_str[" + k + "]==>" + PXNO_str[k]);
						}

						temp_PXNO[0] = PXNO_str[7];// BUYER
						temp_PXNO[1] = PXNO_str[0]; // PR_NO
						temp_PXNO[2] = PXNO_str[1]; // PR_SEQ
						temp_PXNO[3] = PXNO_str[2]; // RECV_QTY
						temp_PXNO[4] = sPR_No; // PX_NO
						temp_PXNO[5] = String.valueOf(i + 1); // PX_SEQ
						temp_PXNO[6] = PXNO_str[4].trim(); // RETURN_REASON1 ( 요청수량 변경사유)
						temp_PXNO[7] = PXNO_str[3].trim(); // REF_PR_NO
						temp_PXNO[8] = PXNO_str[5].trim(); // RD_DATE
						temp_PXNO[9] = PXNO_str[6].trim(); // PO_REMARK

						_data = new HashMap<String, String>();
						_data.put("BUYER", temp_PXNO[0]);
						_data.put("PR_NO", temp_PXNO[1]);
						_data.put("PR_SEQ", temp_PXNO[2]);
						_data.put("RECV_QTY", temp_PXNO[3]);
						_data.put("PX_NO", temp_PXNO[4]);
						_data.put("PX_SEQ", temp_PXNO[5]);
						_data.put("RETURN_REASON", temp_PXNO[6]);
						_data.put("REF_PR_NO", temp_PXNO[7]);
						_data.put("RD_DATE", temp_PXNO[8]);
						_data.put("PO_REMARK", temp_PXNO[9]);
						_data.put("USERID", formData.get("userid"));
						_data.put("RECV_FLAG", sRecvFlag);
						_data.put("PX_FLAG", px_flag);
						// setPxPrPoUpdate( v_PXNO, px_flag , userID, userDept, usrname, userTel, sRecvFlag);

						LOGGER.debug("insertMergePxPo _data {} ", _data);

						// String cnt = sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRHDCheck", _data);
						// if ("1".equals(cnt)){
						// //sqlSessionTemplate.rollback();
						// return "DUP"; // 이미진행된 상태로 리턴후 화면에 메시지 출력한다.....
						// }
						//
						sqlSessionTemplate.insert("buyer.mppo.setPxPrPoUpdate1", _data); // ICOMPRDT 구매요청
						// ICOMPRHD 업데이트
						if (i == 0) {
							sqlSessionTemplate.insert("buyer.mppo.setPxPrPoUpdate2", _data); // ICOMPRDT 구매요청
						}

					}
				} // end FOR
			}

			LOGGER.debug("insertMergePxPo sRecvFlag {} ", sRecvFlag);

			boolean p060000009 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000009"); // KRKFNT0001
			LOGGER.debug("insertMergePxPo p060000009 {} ", p060000009);

			if ("PC".equals(sRecvFlag)) {
				// - 구현 setNewProxyPoCreate(sPR_No, buyer, userID, po_create_date); //buyer, user_id, ,po_create_date,
				// gr_flag
				List<Map<String, String>> pcList = null;
				List<Map<String, String>> podtcount = new ArrayList<Map<String, String>>();
				formData.put("PC_SPR_NO", sPR_No); // PX
				formData.put("PC_BUYER", buyer);
				formData.put("PC_USERID", userID);
				formData.put("PC_PO_CREATE_DATE", po_create_date);
				LOGGER.debug("insertMergePxPo formData {} ", formData);
				//품목별 도착지 입력 고객사 체크
				boolean p060000100 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000100");
				String st_dely_item_yn = "N";
				if(p060000100 == true) {
					st_dely_item_yn = "Y";
				}
				Map<String, String> _pcData = null;
				pcList = sqlSessionTemplate.selectList("buyer.mppo.setNewProxyPoCreate1", formData); // ICOMCQDT 계약상품,
																										// ICOMPRHD
																										// 구매요청,
																										// ICOMPRDT 구매요청
				pcList = CommonUtil.getListNvl(pcList);
				if (pcList != null) {
					for (int i = 0; i < pcList.size(); i++) {
						_pcData = pcList.get(i);

						LOGGER.debug("insertMergePxPo _pcData {} ", _pcData);
						// SLOGIC-BEGIN(P06-0000009)
						if (p060000009 == true) {
							if (temp.compareTo(_pcData.get("CONDITION").toString()) != 0 || (Po_seq > Po_create_max)) {

								Map<String, String> _tmp = new HashMap<String, String>();
								temp = _pcData.get("CONDITION").toString(); // 42 PO 분리 생성 조건
								Po_no = getOrderNo(buyer, "PO"); // PO
								Subject = _pcData.get("PR_SUBJECT").toString(); // 50

								Po_seq = 1;
								_tmp.put("BUYER", buyer);
								_tmp.put("PO_NO", Po_no); // PO
								_tmp.put("SELLER", _pcData.get("SELLER").toString()); // SELLER
								_tmp.put("DELY_TO_LOCATION", _pcData.get("DELY_TO_LOCATION_TEXT").toString()); // POHD.DELY_TO_LOCATION
								_tmp.put("CHANGE_USER_ID", _pcData.get("CHANGE_USER_ID").toString()); // REF_ADD_USER_ID
								_tmp.put("AGENT", _pcData.get("AGENT").toString()); // AGENT
								_tmp.put("REMARK", _pcData.get("REMARK").toString()); // PX_REMARK
								_tmp.put("DOC_TYPE", _pcData.get("DOC_TYPE").toString()); // GR_FLAG
								_tmp.put("CHANGE_USER_NAME", _pcData.get("CHANGE_USER_NAME").toString()); // CHANGE_USER_NAME
								_tmp.put("CHANGE_USER_TEL", _pcData.get("CHANGE_USER_TEL").toString()); // CHANGE_USER_TEL
								_tmp.put("REQ_USER_INFO", _pcData.get("REQ_USER_INFO").toString()); //요청자 정보
								podtcount.add(_tmp); // podt가 몇개가 만들어 지는지 그 값을 넣어준다.

							} else {
								Po_seq++;
							}
						} // SLOGIC-END
						else {
							if (temp.compareTo(_pcData.get("CONDITION").toString()) != 0) {

								Map<String, String> _tmp = new HashMap<String, String>();
								temp = _pcData.get("CONDITION").toString(); // PO 분리 생성 조건
								Po_no = getOrderNo(buyer, "PO"); // PO
								Subject = _pcData.get("PR_SUBJECT").toString(); // 50

								Po_seq = 1;
								_tmp.put("BUYER", buyer);
								_tmp.put("PO_NO", Po_no); // PO
								_tmp.put("SELLER", _pcData.get("SELLER").toString()); // SELLER
								_tmp.put("DELY_TO_LOCATION", _pcData.get("DELY_TO_LOCATION_TEXT").toString()); // POHD.DELY_TO_LOCATION
								_tmp.put("CHANGE_USER_ID", _pcData.get("CHANGE_USER_ID").toString()); // REF_ADD_USER_ID
								_tmp.put("AGENT", _pcData.get("AGENT").toString()); // AGENT
								_tmp.put("REMARK", _pcData.get("REMARK").toString()); // PX_REMARK
								_tmp.put("DOC_TYPE", _pcData.get("DOC_TYPE").toString()); // GR_FLAG
								_tmp.put("CHANGE_USER_NAME", _pcData.get("CHANGE_USER_NAME").toString()); // CHANGE_USER_NAME
								_tmp.put("CHANGE_USER_TEL", _pcData.get("CHANGE_USER_TEL").toString()); // CHANGE_USER_TEL
								_tmp.put("REQ_USER_INFO", _pcData.get("REQ_USER_INFO").toString()); //요청자 정보
								podtcount.add(_tmp); // podt가 몇개가 만들어 지는지 그 값을 넣어준다.

							} else {
								Po_seq++;
							}
						}

						LOGGER.debug("insertMergePxPo buyer {} ", buyer);
						LOGGER.debug("insertMergePxPo Po_no {} ", Po_no);
						LOGGER.debug("insertMergePxPo Po_seq {} ", Po_seq);

						_pcData.put("BUYER", buyer);
						_pcData.put("PO_NO", Po_no); // PO
						_pcData.put("PO_SEQ", String.valueOf(Po_seq));
						LOGGER.debug("_pcData[" + i + "]==>" + _pcData);
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate2", _pcData); // ICOMPODT 구매발주
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate3", _pcData); // ICOMCQDT 계약상품
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate4", _pcData); // ICOMPRDT 수주접수

						// sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate5", _pcData); <-- 사용안함 ICOMBYIT 카탈로그
						// (고객사)
					}

				}

				if (podtcount != null) {
					for (int j = 0; j < podtcount.size(); j++) {
						_podtcountData = podtcount.get(j);
						_podtcountData.put("USERID", userID);
						_podtcountData.put("PO_CREATE_DATE", po_create_date); // DOC_TYPE (Gr_Flag) = S
						_podtcountData.put("SUBJECT", Subject);
						_podtcountData.put("DELY_ITEM_YN", st_dely_item_yn); // 품목별 도착지 입력
						LOGGER.debug("insertMergePxPo _podtcountData {} ", _podtcountData);
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate6", _podtcountData); // ICOMPOHD 구매발주
																										// PO

						Map<String, String> _pMap = new HashMap<String, String>();
						_pMap.put("BUYER", _podtcountData.get("BUYER"));
						_pMap.put("PO_NO", _podtcountData.get("PO_NO"));
						_pMap.put("CODE", "PO_NEW");
						_pMap.put("USER_ID", _podtcountData.get("USERID"));
						call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO(_pMap); // 메일 발송 패키지

						// 메일전송 파라메터
						/*
						 * String company_loc = getCompanyText(bb[0]); String [] str_mail = new String[5];
						 * 
						 * str_mail[0] = User_Id; str_mail[1] = bb[2]; // Seller str_mail[2] = bb[1]; // Po_no
						 * str_mail[3] = company_loc; str_mail[4] = bb[5]; // Agent
						 * 
						 * vobj[j] = (Object)str_mail;
						 */
					}
				}

			} else if ("PS".equals(sRecvFlag)) { // 발주결재상신

				ht.put("KEY_1", strpono); // 스트링 배열이다.. PO나갈 PX.
				ht.put("KEY_2", buyer); // BUYER
				ht.put("KEY_3", userID); // BUYER_ID
				ht.put("KEY_4", userDept); // BUYER_DEPT
				ht.put("KEY_5", usrname); // BUYER_NAME
				ht.put("KEY_6", userTel); // BUYER_TEL
				ht.put("KEY_7", sPR_No); // PX번호는 하나이다네..

				if (!buyer.equals("KRBOIL0002") && !buyer.equals("KRKDBO0001") && !buyer.equals("KRKDBO0002")
						&& !buyer.equals("KRKDPR0001")) {
					// if(!buyer.equals("GROUPWARE")){
					// setPassBase( GW_NO, buyer, ht, "PX");

					// map.put("buyer", formData.get("buyer"));
					// map.put("comCode", formData.get("comCode"));

					LOGGER.debug("insertMergePxPo setPassBase GW_NO {} ", GW_NO);
					LOGGER.debug("insertMergePxPo setPassBase ht {} ", ht);
					setPassBase(GW_NO, buyer, ht, "PX", formData);
				}

			}

			formData.put("REF_NO", sPR_No);
			formData.put("BUYER", buyer);
			LOGGER.debug("insertMergePxPo formDataformDataformData {} ", formData);
			// 예산 업데이트
			// 임시저장 , 발주결재상신
			if ("PT".equals(sRecvFlag) || "PS".equals(sRecvFlag)) {
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo1", formData); // ICOMBDGT
				// 발주
			} else if ("PC".equals(sRecvFlag)) {
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo2", formData); // ICOMBDGT
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo3", formData); // ICOMBDGT
			}

			LOGGER.debug("insertMergePxPo sPR_NosPR_NosPR_NosPR_NosPR_NosPR_NosPR_NosPR_NosPR_No  {} ", sPR_No);
			rtn = sPR_No;
		} catch (Exception e) {
			LOGGER.debug("구매발주 Exception : ", e);
			throw new RuntimeException("구매발주 생성 실패하였습니다.");
		}

		return rtn;
	}
	// 직발주하는 경우 바로 이 메소드를 호출함
	// /ejb/ejb/koreab2b_src/new/sl_BuyerPo/sl_BuyerPoBean.java
	public String insertMergePxPo(Map<String, String> formData, String DUPNOCHECK) {

		String Query_str = formData.get("st_query").toString();
		String strpono = "";
		String rtn = "null";

		int Po_seq = 1;
		int Po_create_max = 4;
		String Po_no = null;
		String Subject = null;
		String temp = "";

		LOGGER.debug("Query_str {} ", Query_str);
		try {

			// String Query_str = WisehubString.Iso8859ToEucKr(null2sp(request.getParameter("st_query")));
			String para_str[] = Query_str.split("\\|"); // WisehubString.StrToArray(WisehubString.Iso8859ToEucKr(Query_str)
														// , "^||^");
			String temp_para_str = para_str[0];
			String checkedRecord[] = temp_para_str.split("@@"); // WisehubString.StrToArray(temp_para_str , "@@");

			Map<String, String> ht = new HashMap<String, String>();

			String sRecvFlag = "";
			String buyer = para_str[1];
			String userID = para_str[2];
			String userDept = para_str[3];
			int iFlag = Integer.parseInt(para_str[4]); // 구매발주(recvFlag=1) , 발주보류(recvFlag=3)
			String userTel = para_str[5];
			String usrname = para_str[6];
			String GW_NO = para_str[7];
			String po_create_date = para_str[8];
			String gr_flag = para_str[9];
			String end_price = para_str[10];
			String px_flag = para_str[11]; // (PXPR)직발주 인지 , (PRPO)요청접수발주인지 구분
			String account_type = para_str[12]; // 계정분류
			String req_dept = para_str[13]; // 요청부서 ==> PXPR)직발주 일 경우는 userDept와 같은 값을 받음

			LOGGER.debug("sRecvFlag {} ", sRecvFlag);
			LOGGER.debug("buyer {} ", buyer);
			LOGGER.debug("userID {} ", userID);
			LOGGER.debug("userDept {} ", userDept);
			LOGGER.debug("req_dept {} ", req_dept);
			LOGGER.debug("iFlag {} ", iFlag);
			LOGGER.debug("userTel {} ", userTel);
			LOGGER.debug("usrname {} ", usrname);
			LOGGER.debug("GW_NO {} ", GW_NO);
			LOGGER.debug("po_create_date {} ", po_create_date);
			LOGGER.debug("gr_flag {} ", gr_flag);
			LOGGER.debug("end_price {} ", end_price);
			LOGGER.debug("px_flag {} ", px_flag);
			LOGGER.debug("account_type {} ", account_type);

			// conn = WisehubDBConnect.WisehubDBConnect("oracleDataSource");
			// conn.setAutoCommit(false);

			if (iFlag == 1) {
				// Recv_Flag = "PC";
				if (!"N".equals(GW_NO)) {
					sRecvFlag = "PS"; // 결재상신
				} else {
					sRecvFlag = "PC"; // 구매발주 OR 발주결재완료
				}
			} else {
				sRecvFlag = "PT";
				// Recv_Flag = "PT"; // 구매발주임시저장(발주보류)
			}

			Map<String, String> _data = null;
			Map<String, String> _podtcountData = null;

			/**
			 * 진행상태 미리 체크후 진행된게 존재하면 모두 미처리한다.
			 */
			if (checkedRecord != null) {
				for (int i = 0; i < checkedRecord.length; i++) {
					// strpono = sPR_No; // PX

					if (checkedRecord[i].length() > 0 && checkedRecord[i] != "" && checkedRecord[i] != null) {

						String temp_PXNO[] = new String[10];
						String PXNO_str[] = checkedRecord[i].split("~~~"); // WisehubString.StrToArray(checkedRecord[i]
																			// , "~~~");

						for (int k = 0; k < PXNO_str.length; k++) {
							LOGGER.debug("PXNO_str[" + k + "]==>" + PXNO_str[k]);
						}

						temp_PXNO[0] = buyer; // BUYER
						temp_PXNO[1] = PXNO_str[0]; // PR_NO
						temp_PXNO[2] = PXNO_str[1]; // PR_SEQ/

						_data = new HashMap<String, String>();
						_data.put("BUYER", temp_PXNO[0]);
						_data.put("PR_NO", temp_PXNO[1]);
						_data.put("PR_SEQ", temp_PXNO[2]);

						if ("".equals(DUPNOCHECK)) {
							String cnt = sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRDTCheck", _data);
							if ("0".equals(cnt)) {
								return "DUP"; // 이미진행된 상태로 리턴후 화면에 메시지 출력한다.....
							}
							cnt = sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRDTCheck2", _data);
							if ("1".equals(cnt)) {
								return "DUP2"; // 이미 반려 진행된 상태로 리턴후 화면에 메시지 출력한다.....
							}
						}
					}
				} // end FOR
			}

			String sPR_No = null;

			sPR_No = getOrderNo(buyer, "PX"); // getOrderPX(buyer ,"PX");

			LOGGER.debug("insertMergePxPo sRecvFlag {} ", sRecvFlag);
			LOGGER.debug("insertMergePxPo sPR_No {} ", sPR_No);

			if (checkedRecord != null) {
				for (int i = 0; i < checkedRecord.length; i++) {
					strpono = sPR_No; // PX

					if (checkedRecord[i].length() > 0 && checkedRecord[i] != "" && checkedRecord[i] != null) {

						String temp_PXNO[] = new String[10];
						String PXNO_str[] = checkedRecord[i].split("~~~"); // WisehubString.StrToArray(checkedRecord[i]
																			// , "~~~");

						for (int k = 0; k < PXNO_str.length; k++) {
							LOGGER.debug("PXNO_str[" + k + "]==>" + PXNO_str[k]);
						}

						temp_PXNO[0] = buyer; // BUYER
						temp_PXNO[1] = PXNO_str[0]; // PR_NO
						temp_PXNO[2] = PXNO_str[1]; // PR_SEQ
						temp_PXNO[3] = PXNO_str[2]; // RECV_QTY
						temp_PXNO[4] = sPR_No; // PX_NO
						temp_PXNO[5] = String.valueOf(i + 1); // PX_SEQ
						temp_PXNO[6] = PXNO_str[4].trim(); // RETURN_REASON1 ( 요청수량 변경사유)
						temp_PXNO[7] = PXNO_str[3].trim(); // REF_PR_NO
						temp_PXNO[8] = PXNO_str[5].trim(); // RD_DATE
						temp_PXNO[9] = PXNO_str[6].trim(); // PO_REMARK

						_data = new HashMap<String, String>();
						_data.put("BUYER", temp_PXNO[0]);
						_data.put("PR_NO", temp_PXNO[1]);
						_data.put("PR_SEQ", temp_PXNO[2]);
						_data.put("RECV_QTY", temp_PXNO[3]);
						_data.put("PX_NO", temp_PXNO[4]);
						_data.put("PX_SEQ", temp_PXNO[5]);
						_data.put("RETURN_REASON", temp_PXNO[6]);
						_data.put("REF_PR_NO", temp_PXNO[7]);
						_data.put("RD_DATE", temp_PXNO[8]);
						_data.put("PO_REMARK", temp_PXNO[9]);
						_data.put("USERID", formData.get("userid"));
						_data.put("RECV_FLAG", sRecvFlag);
						_data.put("PX_FLAG", px_flag);
						// setPxPrPoUpdate( v_PXNO, px_flag , userID, userDept, usrname, userTel, sRecvFlag);

						LOGGER.debug("insertMergePxPo _data {} ", _data);

						// String cnt = sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRHDCheck", _data);
						// if ("1".equals(cnt)){
						// //sqlSessionTemplate.rollback();
						// return "DUP"; // 이미진행된 상태로 리턴후 화면에 메시지 출력한다.....
						// }
						//
						sqlSessionTemplate.insert("buyer.mppo.setPxPrPoUpdate1", _data); // ICOMPRDT 구매요청
						// ICOMPRHD 업데이트
						if (i == 0) {
							sqlSessionTemplate.insert("buyer.mppo.setPxPrPoUpdate2", _data); // ICOMPRDT 구매요청
						}

					}
				} // end FOR
			}

			LOGGER.debug("insertMergePxPo sRecvFlag {} ", sRecvFlag);

			boolean p060000009 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000009"); // KRKFNT0001
			LOGGER.debug("insertMergePxPo p060000009 {} ", p060000009);

			if ("PC".equals(sRecvFlag)) {
				// - 구현 setNewProxyPoCreate(sPR_No, buyer, userID, po_create_date); //buyer, user_id, ,po_create_date,
				// gr_flag
				List<Map<String, String>> pcList = null;
				List<Map<String, String>> podtcount = new ArrayList<Map<String, String>>();
				formData.put("PC_SPR_NO", sPR_No); // PX
				formData.put("PC_BUYER", buyer);
				formData.put("PC_USERID", userID);
				formData.put("PC_PO_CREATE_DATE", po_create_date);
				LOGGER.debug("insertMergePxPo formData {} ", formData);
				Map<String, String> _pcData = null;
				//품목별 도착지 입력 고객사 체크
				boolean p060000100 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000100");
				String st_dely_item_yn = "N";
				if(p060000100 == true) {
					st_dely_item_yn = "Y";
				}
				pcList = sqlSessionTemplate.selectList("buyer.mppo.setNewProxyPoCreate1", formData); // ICOMCQDT 계약상품,
																										// ICOMPRHD
																										// 구매요청,
																										// ICOMPRDT 구매요청
				pcList = CommonUtil.getListNvl(pcList);
				if (pcList != null) {
					for (int i = 0; i < pcList.size(); i++) {
						_pcData = pcList.get(i);

						LOGGER.debug("insertMergePxPo _pcData {} ", _pcData);
						// SLOGIC-BEGIN(P06-0000009)
						if (p060000009 == true) {
							if (temp.compareTo(_pcData.get("CONDITION").toString()) != 0 || (Po_seq > Po_create_max)) {

								Map<String, String> _tmp = new HashMap<String, String>();
								temp = _pcData.get("CONDITION").toString(); // 42 PO 분리 생성 조건
								Po_no = getOrderNo(buyer, "PO"); // PO
								Subject = _pcData.get("PR_SUBJECT").toString(); // 50

								Po_seq = 1;
								_tmp.put("BUYER", buyer);
								_tmp.put("PO_NO", Po_no); // PO
								_tmp.put("SELLER", _pcData.get("SELLER").toString()); // SELLER
								_tmp.put("DELY_TO_LOCATION", _pcData.get("DELY_TO_LOCATION_TEXT").toString()); // POHD.DELY_TO_LOCATION
								_tmp.put("CHANGE_USER_ID", _pcData.get("CHANGE_USER_ID").toString()); // REF_ADD_USER_ID
								_tmp.put("AGENT", _pcData.get("AGENT").toString()); // AGENT
								_tmp.put("REMARK", _pcData.get("REMARK").toString()); // PX_REMARK
								_tmp.put("DOC_TYPE", _pcData.get("DOC_TYPE").toString()); // GR_FLAG
								_tmp.put("CHANGE_USER_NAME", _pcData.get("CHANGE_USER_NAME").toString()); // CHANGE_USER_NAME
								_tmp.put("CHANGE_USER_TEL", _pcData.get("CHANGE_USER_TEL").toString()); // CHANGE_USER_TEL
								_tmp.put("REQ_USER_INFO", _pcData.get("REQ_USER_INFO").toString()); //요청자 정보
								podtcount.add(_tmp); // podt가 몇개가 만들어 지는지 그 값을 넣어준다.

							} else {
								Po_seq++;
							}
						} // SLOGIC-END
						else {
							if (temp.compareTo(_pcData.get("CONDITION").toString()) != 0) {

								Map<String, String> _tmp = new HashMap<String, String>();
								temp = _pcData.get("CONDITION").toString(); // PO 분리 생성 조건
								Po_no = getOrderNo(buyer, "PO"); // PO
								Subject = _pcData.get("PR_SUBJECT").toString(); // 50

								Po_seq = 1;
								_tmp.put("BUYER", buyer);
								_tmp.put("PO_NO", Po_no); // PO
								_tmp.put("SELLER", _pcData.get("SELLER").toString()); // SELLER
								_tmp.put("DELY_TO_LOCATION", _pcData.get("DELY_TO_LOCATION_TEXT").toString()); // POHD.DELY_TO_LOCATION
								_tmp.put("CHANGE_USER_ID", _pcData.get("CHANGE_USER_ID").toString()); // REF_ADD_USER_ID
								_tmp.put("AGENT", _pcData.get("AGENT").toString()); // AGENT
								_tmp.put("REMARK", _pcData.get("REMARK").toString()); // PX_REMARK
								_tmp.put("DOC_TYPE", _pcData.get("DOC_TYPE").toString()); // GR_FLAG
								_tmp.put("CHANGE_USER_NAME", _pcData.get("CHANGE_USER_NAME").toString()); // CHANGE_USER_NAME
								_tmp.put("CHANGE_USER_TEL", _pcData.get("CHANGE_USER_TEL").toString()); // CHANGE_USER_TEL
								_tmp.put("REQ_USER_INFO", _pcData.get("REQ_USER_INFO").toString()); //요청자 정보
								podtcount.add(_tmp); // podt가 몇개가 만들어 지는지 그 값을 넣어준다.

							} else {
								Po_seq++;
							}
						}

						LOGGER.debug("insertMergePxPo buyer {} ", buyer);
						LOGGER.debug("insertMergePxPo Po_no {} ", Po_no);
						LOGGER.debug("insertMergePxPo Po_seq {} ", Po_seq);

						_pcData.put("BUYER", buyer);
						_pcData.put("PO_NO", Po_no); // PO
						_pcData.put("PO_SEQ", String.valueOf(Po_seq));
						LOGGER.debug("_pcData[" + i + "]==>" + _pcData);
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate2", _pcData); // ICOMPODT 구매발주
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate3", _pcData); // ICOMCQDT 계약상품
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate4", _pcData); // ICOMPRDT 수주접수

						// sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate5", _pcData); <-- 사용안함 ICOMBYIT 카탈로그
						// (고객사)
					}

				}

				if (podtcount != null) {
					for (int j = 0; j < podtcount.size(); j++) {
						_podtcountData = podtcount.get(j);

						_podtcountData.put("USERID", userID);
						_podtcountData.put("PO_CREATE_DATE", po_create_date); // DOC_TYPE (Gr_Flag) = S
						_podtcountData.put("SUBJECT", Subject);
						_podtcountData.put("DELY_ITEM_YN", st_dely_item_yn); // 품목별 도착지 입력
						LOGGER.debug("insertMergePxPo _podtcountData {} ", _podtcountData);
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate6", _podtcountData); // ICOMPOHD 구매발주
																										// PO

						Map<String, String> _pMap = new HashMap<String, String>();
						_pMap.put("BUYER", _podtcountData.get("BUYER"));
						_pMap.put("PO_NO", _podtcountData.get("PO_NO"));
						_pMap.put("CODE", "PO_NEW");
						_pMap.put("USER_ID", _podtcountData.get("USERID"));
						call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO(_pMap); // 메일 발송 패키지

						// 메일전송 파라메터
						/*
						 * String company_loc = getCompanyText(bb[0]); String [] str_mail = new String[5];
						 * 
						 * str_mail[0] = User_Id; str_mail[1] = bb[2]; // Seller str_mail[2] = bb[1]; // Po_no
						 * str_mail[3] = company_loc; str_mail[4] = bb[5]; // Agent
						 * 
						 * vobj[j] = (Object)str_mail;
						 */
					}
				}

			} else if ("PS".equals(sRecvFlag)) { // 발주결재상신

				ht.put("KEY_1", strpono); // 스트링 배열이다.. PO나갈 PX.
				ht.put("KEY_2", buyer); // BUYER
				ht.put("KEY_3", userID); // BUYER_ID
				ht.put("KEY_4", userDept); // BUYER_DEPT
				ht.put("KEY_5", usrname); // BUYER_NAME
				ht.put("KEY_6", userTel); // BUYER_TEL
				ht.put("KEY_7", sPR_No); // PX번호는 하나이다네..

				if (!buyer.equals("KRBOIL0002") && !buyer.equals("KRKDBO0001") && !buyer.equals("KRKDBO0002")
						&& !buyer.equals("KRKDPR0001")) {
					// if(!buyer.equals("GROUPWARE")){
					// setPassBase( GW_NO, buyer, ht, "PX");

					// map.put("buyer", formData.get("buyer"));
					// map.put("comCode", formData.get("comCode"));

					LOGGER.debug("insertMergePxPo setPassBase GW_NO {} ", GW_NO);
					LOGGER.debug("insertMergePxPo setPassBase ht {} ", ht);
					setPassBase(GW_NO, buyer, ht, "PX", formData);
				}

			}

			formData.put("REF_NO", sPR_No);
			formData.put("BUYER", buyer);
			LOGGER.debug("insertMergePxPo formDataformDataformData {} ", formData);
			// 예산 업데이트
			// 임시저장 , 발주결재상신
			if ("PT".equals(sRecvFlag) || "PS".equals(sRecvFlag)) {
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo1", formData); // ICOMBDGT
				// 발주
			} else if ("PC".equals(sRecvFlag)) {
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo2", formData); // ICOMBDGT
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo3", formData); // ICOMBDGT
			}

			LOGGER.debug("insertMergePxPo sPR_NosPR_NosPR_NosPR_NosPR_NosPR_NosPR_NosPR_NosPR_No  {} ", sPR_No);
			rtn = sPR_No;
		} catch (Exception e) {
			LOGGER.error("구매발주 Exception : ", e);
			throw new RuntimeException("구매발주 생성 실패하였습니다.");
		}

		return rtn;
	}

	public String changeMergePxPo(Map<String, String> formData) {

		// System.out.println( "Query_str ==>" + Query_str ) ;
		String Query_str = formData.get("st_query").toString();
		String strpono = "";
		String rtn = "null";

		int Po_seq = 1;
		int Po_create_max = 4;
		String Po_no = null;
		String Subject = null;
		String temp = "";

		try {

			// String Query_str = WisehubString.Iso8859ToEucKr(null2sp(request.getParameter("st_query")));

			String para_str[] = Query_str.split("\\|"); // WisehubString.StrToArray(WisehubString.Iso8859ToEucKr(Query_str)
														// , "^||^");
			String temp_para_str = para_str[0];
			String checkedRecord[] = temp_para_str.split("@@"); // WisehubString.StrToArray(temp_para_str , "@@");

			Map<String, String> ht = new HashMap<String, String>();

			String sRecvFlag = "";
			String buyer = para_str[1];
			String userID = para_str[2];
			String userDept = para_str[3];
			int iFlag = Integer.parseInt(para_str[4]);
			String userTel = para_str[5];
			String usrname = para_str[6];
			String GW_NO = para_str[7];
			String po_create_date = para_str[8];
			String gr_flag = para_str[9];
			String end_price = para_str[10];
			String px_flag = para_str[11]; // (PXPR)직발주 인지 , (PRPO)요청접수발주인지 구분
			String account_type = para_str[12]; // 계정분류
			String req_dept = para_str[13]; // 요청부서 ==> PXPR)직발주 일 경우는 userDept와 같은 값을 받음

			LOGGER.debug("sRecvFlag {} ", sRecvFlag);
			LOGGER.debug("buyer {} ", buyer);
			LOGGER.debug("userID {} ", userID);
			LOGGER.debug("userDept {} ", userDept);
			LOGGER.debug("req_dept {} ", req_dept);
			LOGGER.debug("iFlag {} ", iFlag);
			LOGGER.debug("userTel {} ", userTel);
			LOGGER.debug("usrname {} ", usrname);
			LOGGER.debug("GW_NO {} ", GW_NO);
			LOGGER.debug("po_create_date {} ", po_create_date);
			LOGGER.debug("gr_flag {} ", gr_flag);
			LOGGER.debug("end_price {} ", end_price);
			LOGGER.debug("px_flag {} ", px_flag);
			LOGGER.debug("account_type {} ", account_type);

			if (iFlag == 1) {
				if (!GW_NO.equals("N")) {
					sRecvFlag = "PS"; // 결재상신
				} else {
					sRecvFlag = "PC"; // 구매발주 OR 발주결재완료
				}
			}

			Map<String, String> _data = null;
			Map<String, String> _podtcountData = null;

			/**
			 * 진행상태 미리 체크후 진행된게 존재하면 모두 미처리한다.
			 */
			if (checkedRecord != null) {
				for (int i = 0; i < checkedRecord.length; i++) {
					// strpono = sPR_No; // PX

					if (checkedRecord[i].length() > 0 && checkedRecord[i] != "" && checkedRecord[i] != null) {

						String temp_PXNO[] = new String[10];
						String PXNO_str[] = checkedRecord[i].split("~~~"); // WisehubString.StrToArray(checkedRecord[i]
																			// , "~~~");

						for (int k = 0; k < PXNO_str.length; k++) {
							LOGGER.debug("PXNO_str[" + k + "]==>" + PXNO_str[k]);
						}

						temp_PXNO[0] = buyer; // BUYER
						temp_PXNO[1] = PXNO_str[0]; // PR_NO
						temp_PXNO[2] = PXNO_str[1]; // PR_SEQ/

						_data = new HashMap<String, String>();
						_data.put("BUYER", temp_PXNO[0]);
						_data.put("PR_NO", temp_PXNO[1]);
						_data.put("PR_SEQ", temp_PXNO[2]);

						String cnt = sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRDTCheck2", _data);
						if ("1".equals(cnt)) {
							return "DUP2"; // 이미 반려 진행된 상태로 리턴후 화면에 메시지 출력한다.....
						}
					}
				} // end FOR
			}

			String sPR_No = null;

			sPR_No = getOrderNo(buyer, "PX");

			LOGGER.debug("changeMergePxPo sRecvFlag {} ", sRecvFlag);
			LOGGER.debug("changeMergePxPo sPR_No {} ", sPR_No);

			if (checkedRecord != null) {
				for (int i = 0; i < checkedRecord.length; i++) {
					strpono = sPR_No;

					if (checkedRecord[i].length() > 0 && checkedRecord[i] != "" && checkedRecord[i] != null) {

						String temp_PXNO[] = new String[10];
						String PXNO_str[] = checkedRecord[i].split("~~~"); // WisehubString.StrToArray(checkedRecord[i]
																			// , "~~~");

						for (int k = 0; k < PXNO_str.length; k++) {
							// System.out.println( "PXNO_str["+k+"]==>" + PXNO_str[k] );
						}

						temp_PXNO[0] = buyer; // BUYER
						temp_PXNO[1] = PXNO_str[0]; // PR_NO
						temp_PXNO[2] = PXNO_str[1]; // PR_SEQ
						temp_PXNO[3] = PXNO_str[2]; // RECV_QTY
						temp_PXNO[4] = sPR_No; // PX_NO
						temp_PXNO[5] = String.valueOf(i + 1); // PX_SEQ
						temp_PXNO[6] = PXNO_str[4].trim(); // RETURN_REASON1 ( 요청수량 변경사유)
						temp_PXNO[7] = PXNO_str[3].trim(); // REF_PR_NO
						temp_PXNO[8] = PXNO_str[5].trim(); // RD_DATE
						temp_PXNO[9] = PXNO_str[6].trim(); // PO_REMARK

						_data = new HashMap<String, String>();
						_data.put("BUYER", temp_PXNO[0]);
						_data.put("PR_NO", temp_PXNO[1]);
						_data.put("PR_SEQ", temp_PXNO[2]);
						_data.put("RECV_QTY", temp_PXNO[3]);
						_data.put("PX_NO", temp_PXNO[4]);
						_data.put("PX_SEQ", temp_PXNO[5]);
						_data.put("RETURN_REASON", temp_PXNO[6]);
						_data.put("REF_PR_NO", temp_PXNO[7]);
						_data.put("RD_DATE", temp_PXNO[8]);
						_data.put("PO_REMARK", temp_PXNO[9]);
						_data.put("USERID", formData.get("userid"));
						_data.put("RECV_FLAG", sRecvFlag);
						_data.put("PX_FLAG", px_flag);

						LOGGER.debug("changeMergePxPo _data {} ", _data);

						// String cnt = sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRHDCheck", _data);
						// if ("1".equals(cnt)){
						// //sqlSessionTemplate.rollback();
						// return "DUP"; // 이미진행된 상태로 리턴후 화면에 메시지 출력한다.....
						// }

						sqlSessionTemplate.insert("buyer.mppo.setPxPrPoUpdate1", _data); // ICOMPRDT 구매요청
						// ICOMPRHD 업데이트
						if (i == 0) {
							sqlSessionTemplate.insert("buyer.mppo.setPxPrPoUpdate2", _data); // ICOMPRDT 구매요청
						}
					}
				} // end FOR
			}

			LOGGER.debug("changeMergePxPo sRecvFlag {} ", sRecvFlag);
			boolean p060000009 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000009"); // KRKFNT0001
			LOGGER.debug("changeMergePxPo p060000009 {} ", p060000009);

			if ("PC".equals(sRecvFlag)) {
				// - 구현 setNewProxyPoCreate(sPR_No, buyer, userID, po_create_date); //buyer, user_id, ,po_create_date,
				// gr_flag
				List<Map<String, String>> pcList = null;
				List<Map<String, String>> podtcount = new ArrayList<Map<String, String>>();
				formData.put("PC_SPR_NO", sPR_No); // PX
				formData.put("PC_BUYER", buyer);
				formData.put("PC_USERID", userID);
				formData.put("PC_PO_CREATE_DATE", po_create_date);
				//품목별 도착지 입력 고객사 체크
				boolean p060000100 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000100");
				String st_dely_item_yn = "N";
				if(p060000100 == true) {
					st_dely_item_yn = "Y";
				}
				LOGGER.debug("changeMergePxPo formData {} ", formData);
				Map<String, String> _pcData = null;
				pcList = sqlSessionTemplate.selectList("buyer.mppo.setNewProxyPoCreate1", formData); // ICOMCQDT 계약상품,
																										// ICOMPRHD
																										// 구매요청,
																										// ICOMPRDT 구매요청
				pcList = CommonUtil.getListNvl(pcList);
				if (pcList != null) {
					for (int i = 0; i < pcList.size(); i++) {
						_pcData = pcList.get(i);

						LOGGER.debug("changeMergePxPo _pcData {} ", _pcData);
						// SLOGIC-BEGIN(P06-0000009)
						if (p060000009 == true) {
							if (temp.compareTo(_pcData.get("CONDITION").toString()) != 0 || (Po_seq > Po_create_max)) {

								Map<String, String> _tmp = new HashMap<String, String>();
								temp = _pcData.get("CONDITION").toString(); // 42 PO 분리 생성 조건
								Po_no = getOrderNo(buyer, "PO");
								Subject = _pcData.get("PR_SUBJECT").toString(); // 50

								Po_seq = 1;
								_tmp.put("BUYER", buyer);
								_tmp.put("PO_NO", Po_no);
								_tmp.put("SELLER", _pcData.get("SELLER").toString()); // SELLER
								_tmp.put("DELY_TO_LOCATION", _pcData.get("DELY_TO_LOCATION_TEXT").toString()); // POHD.DELY_TO_LOCATION
								_tmp.put("CHANGE_USER_ID", _pcData.get("CHANGE_USER_ID").toString()); // REF_ADD_USER_ID
								_tmp.put("AGENT", _pcData.get("AGENT").toString()); // AGENT
								_tmp.put("REMARK", _pcData.get("REMARK").toString()); // PX_REMARK
								_tmp.put("DOC_TYPE", _pcData.get("DOC_TYPE").toString()); // GR_FLAG
								_tmp.put("CHANGE_USER_NAME", _pcData.get("CHANGE_USER_NAME").toString()); // CHANGE_USER_NAME
								_tmp.put("CHANGE_USER_TEL", _pcData.get("CHANGE_USER_TEL").toString()); // CHANGE_USER_TEL
								_tmp.put("REQ_USER_INFO", _pcData.get("REQ_USER_INFO").toString()); //요청자 정보
								podtcount.add(_tmp); // podt가 몇개가 만들어 지는지 그 값을 넣어준다.

							} else {
								Po_seq++;
							}
						} // SLOGIC-END
						else {
							if (temp.compareTo(_pcData.get("CONDITION").toString()) != 0) {

								Map<String, String> _tmp = new HashMap<String, String>();
								temp = _pcData.get("CONDITION").toString(); // PO 분리 생성 조건
								Po_no = getOrderNo(buyer, "PO");
								Subject = _pcData.get("PR_SUBJECT").toString(); // 50

								Po_seq = 1;
								_tmp.put("BUYER", buyer);
								_tmp.put("PO_NO", Po_no);
								_tmp.put("SELLER", _pcData.get("SELLER").toString()); // SELLER
								_tmp.put("DELY_TO_LOCATION", _pcData.get("DELY_TO_LOCATION_TEXT").toString()); // POHD.DELY_TO_LOCATION
								_tmp.put("CHANGE_USER_ID", _pcData.get("CHANGE_USER_ID").toString()); // REF_ADD_USER_ID
								_tmp.put("AGENT", _pcData.get("AGENT").toString()); // AGENT
								_tmp.put("REMARK", _pcData.get("REMARK").toString()); // PX_REMARK
								_tmp.put("DOC_TYPE", _pcData.get("DOC_TYPE").toString()); // GR_FLAG
								_tmp.put("CHANGE_USER_NAME", _pcData.get("CHANGE_USER_NAME").toString()); // CHANGE_USER_NAME
								_tmp.put("CHANGE_USER_TEL", _pcData.get("CHANGE_USER_TEL").toString()); // CHANGE_USER_TEL
								_tmp.put("REQ_USER_INFO", _pcData.get("REQ_USER_INFO").toString()); //요청자 정보
								podtcount.add(_tmp); // podt가 몇개가 만들어 지는지 그 값을 넣어준다.

							} else {
								Po_seq++;
							}
						}

						LOGGER.debug("changeMergePxPo buyer {} ", buyer);
						LOGGER.debug("changeMergePxPo Po_no {} ", Po_no);
						LOGGER.debug("changeMergePxPo Po_seq {} ", Po_seq);

						_pcData.put("BUYER", buyer);
						_pcData.put("PO_NO", Po_no);
						_pcData.put("PO_SEQ", String.valueOf(Po_seq));
						LOGGER.debug("_pcData[" + i + "]==>" + _pcData);
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate2", _pcData); // ICOMPODT 구매발주
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate3", _pcData); // ICOMCQDT 계약상품
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate4", _pcData); // ICOMPRDT 수주접수

						// sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate5", _pcData); <-- 사용안함 ICOMBYIT 카탈로그
						// (고객사)
					}

				}

				if (podtcount != null) {
					for (int j = 0; j < podtcount.size(); j++) {
						_podtcountData = podtcount.get(j);

						_podtcountData.put("USERID", userID);
						_podtcountData.put("PO_CREATE_DATE", po_create_date);// DOC_TYPE (Gr_Flag) = S
						_podtcountData.put("SUBJECT", Subject);
						_podtcountData.put("DELY_ITEM_YN", st_dely_item_yn); // 품목별 도착지 입력
						LOGGER.debug("changeMergePxPo _podtcountData {} ", _podtcountData);
						sqlSessionTemplate.update("buyer.mppo.setNewProxyPoCreate6", _podtcountData); // ICOMPOHD 구매발주

						// if (j == 0){
						Map<String, String> _pMap = new HashMap<String, String>();
						_pMap.put("BUYER", _podtcountData.get("BUYER"));
						_pMap.put("PO_NO", _podtcountData.get("PO_NO"));
						_pMap.put("CODE", "PO_NEW");
						_pMap.put("USER_ID", _podtcountData.get("USERID"));
						call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO(_pMap); // 메일 발송 패키지
						// }
					}
				}

			} else if ("PS".equals(sRecvFlag)) {

				ht.put("KEY_1", strpono); // 스트링 배열이다.. PO나갈 PX.
				ht.put("KEY_2", buyer); // BUYER
				ht.put("KEY_3", userID); // BUYER_ID
				ht.put("KEY_4", userDept); // BUYER_DEPT
				ht.put("KEY_5", usrname); // BUYER_NAME
				ht.put("KEY_6", userTel); // BUYER_TEL
				ht.put("KEY_7", sPR_No); // PX번호는 하나이다네..

				if (!buyer.equals("KRBOIL0002") && !buyer.equals("KRKDBO0001") && !buyer.equals("KRKDBO0002")
						&& !buyer.equals("KRKDPR0001")) {
					// if(!buyer.equals("GROUPWARE")) ){
					LOGGER.debug("changeMergePxPo setPassBase GW_NO {} ", GW_NO);
					LOGGER.debug("changeMergePxPo setPassBase ht {} ", ht);
					setPassBase(GW_NO, buyer, ht, "PX", formData);
				}

			}

			// 예산 업데이트
			formData.put("REF_NO", sPR_No); // PX
			formData.put("BUYER", buyer);
			LOGGER.debug("changeMergePxPo formDataformDataformData {} ", formData);
			// 예산 업데이트
			// 임시저장 , 발주결재상신
			if ("PT".equals(sRecvFlag) || "PS".equals(sRecvFlag)) {
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo1", formData); // ICOMBDGT
				// 발주
			} else if ("PC".equals(sRecvFlag)) {
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo2", formData); // ICOMBDGT
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo3", formData); // ICOMBDGT
			}

			LOGGER.debug("changeMergePxPo sPR_NosPR_NosPR_NosPR_NosPR_NosPR_NosPR_NosPR_NosPR_No  {} ", sPR_No); // PX

			rtn = sPR_No;
		} catch (Exception e) {
			LOGGER.debug("구매발주 Exception : ", e);
			throw new RuntimeException("구매발주 생성 실패하였습니다.");
		}

		return rtn;
	}

	// 채번
	public String getOrderNo(String cmpyId, String docType) throws Exception {
		String returnValue = null;
		Map<String, String> pMap = new HashMap<String, String>();

		pMap.put("COM_CODE", cmpyId);
		pMap.put("DOC_TYPE", docType);
		try {
			returnValue = sqlSessionTemplate.selectOne("common.getDocuNo", pMap);
			LOGGER.debug("채번 - returnValue : {}  ", returnValue);

			if (returnValue == null || "".equals(returnValue) || returnValue.isEmpty()) {
				sqlSessionTemplate.insert("common.insertDocuNo", pMap);

				String year = "" + Calendar.getInstance().get(Calendar.YEAR);
				returnValue = docType + year.substring(2, 4) + "000001";
			} else {
				sqlSessionTemplate.update("common.updateDocuNo", pMap);
				// returnValue = sqlSessionTemplate.selectOne("common.getDocuNo", pMap);
			}
			LOGGER.debug("채번 - returnValue :  {}  ", returnValue);

		} catch (Exception e) {
			LOGGER.debug("채번 Exception : ", e);
			throw new RuntimeException("채번 취득에 실패하였습니다.");
		} finally {
			LOGGER.debug("채번 - returnValue :  {}  ", returnValue);
		}
		return returnValue;
	}

	public Map<String, String> setPassBase(String TempId, String company, Map<String, String> htar, String mode,
			Map<String, String> formData) throws Exception {

		boolean dataFlag = true;
		List<Map<String, String>> list = null;
		Map<String, String> map = new HashMap<String, String>();
		Map<String, String> ht = new HashMap<String, String>();

		String DOCU_NO = "";
		String USER_ID = "";
		String DOCU_KN = "";
		String DOCU_TITLE = "";
		String DOCU_CONT = "";
		String USER_NM = "";
		String DOCU_CC = "";
		String DOCU_TO = "";
		String IMAGE_KEY = "";

		String MM = "";
		String[] str = new String[10];
		for (int cnt = 0; cnt < 10; ++cnt) {
			MM = (String) htar.get("KEY_" + (cnt + 1));
			str[cnt] = (MM == null ? " " : MM);

			map.put("KEY_" + (cnt + 1), str[cnt]);
		}

		map.put("buyer", formData.get("buyer"));
		map.put("comCode", formData.get("comCode"));
		map.put("TempId", TempId); // GW_NO
		map.put("company", company);

		LOGGER.debug("setPassBase - map : {}  ", map);

		list = sqlSessionTemplate.selectList("buyer.mpso.selectIcotdocu", map);
		list = CommonUtil.getListNvl(list);

		LOGGER.debug("setPassBase - list : {}  ", list);

		if (list != null) {
			if (list.size() > 0) {
				Map<String, String> data = list.get(0);

				DOCU_TITLE = data.get("DOCU_TITLE");
				USER_ID = data.get("USER_ID");
				DOCU_CONT = data.get("DOCU_CONT");
				USER_NM = data.get("USER_NM");
				DOCU_KN = data.get("DOCU_KN");
				DOCU_CC = data.get("DOCU_CC");
				DOCU_TO = data.get("DOCU_TO");
				IMAGE_KEY = data.get("IMAGE_KEY");

			} else {
				dataFlag = false;
			}
		} else {
			dataFlag = false;
		}

		LOGGER.debug("setPassBase - dataFlag : {}  ", dataFlag);

		if (dataFlag == false) {
			ht.put("SUCCESS", "false");
			ht.put("GW_NO", "");
			ht.put("MESSAGE", "");
			return ht;
		}

		map.put("DOCU_TITLE", DOCU_TITLE);
		map.put("USER_ID", USER_ID);
		map.put("DOCU_CONT", DOCU_CONT);
		map.put("USER_NM", USER_NM);
		map.put("DOCU_KN", DOCU_KN);
		map.put("DOCU_CC", DOCU_CC);
		map.put("DOCU_TO", DOCU_TO);
		map.put("IMAGE_KEY", CommonUtil.nvl(IMAGE_KEY));

		map.put("PASS_STATUS", STATUS_PING); // 결재상태 - 결재중
		map.put("EXTIF_TP", mode);

		DOCU_NO = getOrderNo(company, "GW"); // getDocuNo(company,"GW");
		map.put("DOCU_NO", DOCU_NO);
		/*
		 * pstmt = mydbcon.prepareStatement(sb.toString()); pstmt1 = mydbcon.prepareStatement(sb02.toString());
		 * 
		 * pstmt.setString(1, company); pstmt.setString(2, DOCU_NO); pstmt.setString(3, USER_ID); pstmt.setString(4,
		 * DOCU_KN); pstmt.setString(5, DOCU_TITLE); pstmt.setString(6, DOCU_CONT); pstmt.setString(7, USER_NM);
		 * pstmt.setString(8, STATUS_PING); // 결재중 pstmt.setString(9, mode); pstmt.setString(10, IMAGE_KEY); //
		 * IMAGE_KEY 추가
		 * 
		 * pstmt1.setString(1, company); pstmt1.setString(2, mode); pstmt1.setString(3, DOCU_NO); for (int
		 * cnt=0;cnt<str.length;++cnt) { pstmt1.setString(4+cnt, str[cnt]); }
		 */

		LOGGER.debug("setPassBase - map : {}  ", map);
		updatePassLn(map, "NEW");
		map.put("USER_ID", USER_ID);
		sqlSessionTemplate.update("buyer.mpso.createIcogdocu", map);
		sqlSessionTemplate.update("buyer.mpso.createIcommtrgw", map);

		/** 파일업로드 테이블 Y 로 변경 */
		// 첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경)
		Map<String, String> _fildData = new HashMap<String, String>();
		_fildData.put("DOC_NO", map.get("IMAGE_KEY"));
		sqlSessionTemplate.update("common.fileUploadFlagUpdate", _fildData);



		ht.put("SUCCESS", "true");
		ht.put("GW_NO", DOCU_NO);
		ht.put("MESSAGE", "");

		return ht;
	}

	public void updatePassLn(Map<String, String> ht, String mode) throws Exception {

		int order = 1;
		int len;
		// Map<String,String> ht = new HashMap<String,String>();

		String to = "";
		String cc = "";

		if (ht.get("DOCU_TO") == null) {
			to = "";
		} else {
			to = ht.get("DOCU_TO").toString();
		}

		if (ht.get("DOCU_CC") == null) {
			cc = "";
		} else {
			cc = ht.get("DOCU_CC").toString();
		}
		String tbuf = null;

		// 임시 - 메일에서 주소록 가져오기때문에
		if (to == null)
			to = "";

		if (cc == null)
			cc = "";
		to = removeMailAddr(to);
		cc = removeMailAddr(cc);

		int cur_order_no = 2;

		// ht.put("company", pMap.get("company").toString());
		// ht.put("DOCU_NO", pMap.get("DOCU_NO").toString());
		ht.put("pass_tp", MAN_PASS); // 결재자

		LOGGER.debug("updatePassLn 시작  - ht : {}  ", ht);

		try {

			if ("NEW".equals(mode)) {
				// 기안자 등록하기
				// ht.put("user_id", pMap.get("userId").toString());
				if (order == 1) {
					ht.put("pass_kn", KIND_SEND); // 기안자 => 결재
					ht.put("pass_tp", MAN_SEND);
				}
				ht.put("order", String.valueOf(order));
				insertPassLn(ht);
				ht.remove("pass_kn");
			} else if ("MOD".equals(mode)) { // 결재선 수정인 경우
				// 1. cur_order_no 찾기
				// sql_01.append("SELECT CUR_ORDER_NO FROM ICOGDOCU WHERE COMPANY = ? AND DOCU_NO = ?");

				cur_order_no = ((Integer) sqlSessionTemplate.selectOne("buyer.mpso.selectIcogdocu_curOrderNo", ht))
						.intValue();

				// sql_01.append("DELETE FROM ICOGPASSLN WHERE COMPANY = ? AND DOCU_NO = ? AND ORDER_NO >= ?");

				ht.put("CUR_ORDER_NO", String.valueOf(cur_order_no));

				LOGGER.debug("updatePassLn 기안자  - ht : {}  ", ht);

				sqlSessionTemplate.update("buyer.mpso.deleteIcogpassln", ht);
			}
			order++;

			// 결재자 등록하기
			len = 0;
			tbuf = to;
			while (tbuf.length() > 0) {
				len = tbuf.indexOf(",");
				if (len <= 0)
					break;
				if (order < cur_order_no) { // 이미 결재한 사람이면 SKIP
					tbuf = tbuf.substring(len + 1);
					order++;
					continue;
				}
				ht.remove("USER_ID");
				ht.remove("order");
				ht.put("USER_ID", tbuf.substring(0, len));
				ht.put("order", String.valueOf(order));
				
				if(("^").equals(ht.get("USER_ID").substring(0, 1))){
					ht.put("USER_ID", ht.get("USER_ID").replace("^", ""));
					ht.put("pass_tp", MAN_AGREE);
				}else{
					ht.put("pass_tp", MAN_PASS);
				}
				
				ht.put("pass_kn", KIND_PASS); // 기안자 => 결재
				insertPassLn(ht);
				tbuf = tbuf.substring(len + 1);
				order++;
			}
			// 미결재인 사람을 모두 결재선에서 삭제해버린 경우
			if ("MOD".equals(mode)) {
				if (cur_order_no == order) { // 결재완료로 설정하기
					// sql_01.append("UPDATE ICOGDOCU SET CUR_ORDER_NO = ?, PASS_STATUS = ?  WHERE COMPANY = ? AND DOCU_NO = ?");

					/*
					 * pstmt.setInt(args_no++, cur_order_no-1); pstmt.setString(args_no++, STATUS_COMP);
					 * pstmt.setString(args_no++, company); pstmt.setString(args_no++, docu_no);
					 */

					ht.put("PASS_STATUS", STATUS_COMP);
					LOGGER.debug("updatePassLn  결재자 - ht : {}  ", ht);

					sqlSessionTemplate.update("buyer.mpso.updateIcogdocu", ht);

				}
			}
			// 참조자 등록하기
			ht.remove("pass_tp");
			ht.put("pass_tp", MAN_REFER); // 참조자
			// ht.remove("order");
			// ht.put("order", new Integer(order));
			tbuf = cc;
			while (true) {
				len = tbuf.indexOf(",");
				if (len <= 0)
					break;
				ht.remove("USER_ID");
				ht.put("USER_ID", tbuf.substring(0, len));
				ht.remove("order");
				ht.put("order", String.valueOf(order));
				insertPassLn(ht);
				tbuf = tbuf.substring(len + 1);
				order++;
			}

		} finally {
			LOGGER.debug("updatePassLn end");
		}

	} // end of updatePassLn()

	public String removeMailAddr(String addr) throws Exception {
		String target = "";
		String source = null;
		String tbuf = null;
		int len = 0;

		source = addr;
		while (source.length() > 0) {
			len = source.indexOf(",");
			if (len <= 0)
				break;
			tbuf = source.substring(0, len);
			source = source.substring(len + 1);
			len = tbuf.indexOf("@");
			if (len <= 0)
				target = target + tbuf + ",";
			else
				target = target + tbuf.substring(0, len) + ",";
		}
		return target;
	}

	public void insertPassLn(Map<String, String> ht) throws Exception {

		LOGGER.debug("insertPassLn  - ht : {}  ", ht);

		int order = 0;
		if (ht.get("order") != null) {
			order = Integer.parseInt(ht.get("order").toString());
		}

		if (order == 1) // 기안자인 경우 바로 결재 설정
		{
			sqlSessionTemplate.update("buyer.mpso.insertIcogpassln1", ht);
		} else {
			sqlSessionTemplate.update("buyer.mpso.insertIcogpassln2", ht);
		}

	}

	public List<Map<String, String>> selectNewBuyerCommonPassbiz(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.selectNewBuyerCommonPassbiz", formData);
	}

	public String createAdminBuyerMasterPrCreateMailReg(Map<String, String> formData) {

		try {

			String mail_recv = formData.get("mail_recv").toString();
			String[] recv_mail = null;
			recv_mail = mail_recv.split("##", -1);
			int rtn = recv_mail.length;

			formData.put("MAILFORM_ID", "DO_PR_MB");
			formData.put("SEND_COM_TYPE", "M");
			formData.put("RECV_COM_TYPE", "B");
			formData.put("SEND_COM_CODE", "KRKORE0001");
			formData.put("SEND_USER_ID", "KOREAB2B");
			formData.put("KEY1", formData.get("buyer"));
			formData.put("KEY2", formData.get("st_pr_no"));
			formData.put("KEY4", " ");
			formData.put("KEY6", " ");
			formData.put("KEY5SEQ", "Y");

			for (int i = 0; i < rtn; i++) {
				if (recv_mail[i] != null) {
					if (!"".equals(recv_mail[i])) {
						formData.put("KEY3", recv_mail[i]);
						MailSmsUtil.mailSend(formData);
						// sqlSessionTemplate.update("buyer.mpso.insertAdminBuyerMasterPrCreateMailReg", formData);
					}
				}

			}// for end

		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException();
		}

		return "true";

	}

	public List<Map<String, String>> selectCowayBuyerAdminBdgtTempCheck(Map<String, String> formData) {

		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);

		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
		if (_list.size() > 0) {
			data.put("st_query_cart_array", _list);
		}

		/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	

		String st_query_cart_tmp = formData.get("st_query_cart");
		String st_query_cart_tmp_list[] = st_query_cart_tmp.split("@@");		
		String st_query_cart_seq = "";
		data.put("st_seqYn", "N");

		if (st_query_cart_tmp_list != null) {
			
			// ICOMCART.SEQ 구분자 : &&
			for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
				String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
				
				for( int k=0; k < str.length; k++){
					LOGGER.debug("str["+k+"] ==>" + str[k]);
				} 
			
				LOGGER.debug("str.length ==>" + str.length);
				
				// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
				if (str != null && str.length == 2){
					data.put("st_cart_seq", str[1]);
					data.put("st_seqYn", "Y");
					st_query_cart_seq += str[0] + str[1] + "@@";
				}else{ // 없으면 원문 그대로
					st_query_cart_seq = st_query_cart_tmp;
				}
			}
			
			_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
			
			LOGGER.debug("_list ==>" + _list );
			
			data.put("st_query_cart_array", _list);
		}

		/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */
		
		return sqlSessionTemplate.selectList("buyer.mpso.selectCowayBuyerAdminBdgtTempCheck", data);
	}

	public List<Map<String, String>> selectBuyerAdminBdgtTempCheck(Map<String, String> formData) {

		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);

		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
		if (_list.size() > 0) {
			data.put("st_query_cart_array", _list);
		}

		/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	

		String st_query_cart_tmp = formData.get("st_query_cart");
		String st_query_cart_tmp_list[] = st_query_cart_tmp.split("@@");		
		String st_query_cart_seq = "";
		data.put("st_seqYn", "N");

		if (st_query_cart_tmp_list != null) {
			
			// ICOMCART.SEQ 구분자 : &&
			for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
				String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
				
				for( int k=0; k < str.length; k++){
					LOGGER.debug("str["+k+"] ==>" + str[k]);
				} 
			
				LOGGER.debug("str.length ==>" + str.length);
				
				// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
				if (str != null && str.length == 2){
					data.put("st_cart_seq", str[1]);
					data.put("st_seqYn", "Y");
					st_query_cart_seq += str[0] + str[1] + "@@";
				}else{ // 없으면 원문 그대로
					st_query_cart_seq = st_query_cart_tmp;
				}
			}
			
			_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
			
			LOGGER.debug("_list ==>" + _list );
			
			data.put("st_query_cart_array", _list);
		}

		/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */
		
		return sqlSessionTemplate.selectList("buyer.mpso.selectBuyerAdminBdgtTempCheck", data);
	}

	public String selectPassCheck(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("buyer.mpso.selectPassCheck", formData);
	}

	public List<Map<String, String>> selectCompanyPassflag(Map<String, String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.selectCompanyPassflag", formData);
	}

	/**
	 * 결재,취소 후처리 PR
	 */
	public String setPassPr(Map<String, String> formData) {

		String buyer = formData.get("COMPANY").toString();
		String rtnMsg = "주문 실패하였습니다.";
		sqlSessionTemplate.update("buyer.mpso.setPassPr1", formData);
		sqlSessionTemplate.update("buyer.mpso.setPassPr2", formData);
		// SLOGIC-BEGIN(P06-0000036)
		// 코웨이일경우
		String p060000036 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000036", "COL03_DATA"); // 권한특수로직
		if ("COWAY".equals(p060000036)) {
			sqlSessionTemplate.update("buyer.mpso.setPassPr3", formData);
		}
		//SLOGIC-END
		try {
			 //결재처리 일경우 처리 로직 자동 구매 결재선 생성 됨.
			 if(formData.get("RECV_FLAG").equals("GA")) {
				 boolean p150000107 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000107");
				 LOGGER.debug("p150000107 : {}  ",p150000107);
				 //특정 고객사만 후처리 됨
				 if(p150000107 == true) {
					 //참조정보 
					List<Map<String,String>> list = null;
					Map<String,String> mp = null;
					list = sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoPrApprList", formData);
					LOGGER.debug("list.size=========() : {}  ",list.size());
				    if(list.size() > 0){
				    	mp = new HashMap<String,String>();
						for(int z=0; z< list.size(); z++){
							mp = (Map<String,String>)list.get(z);
						}
						String PX_NO = getOrderNo(buyer, "PX");
						mp.put("PX_NO", PX_NO);
						mp.put("REF_NO", PX_NO);
					    //PR DT 업데이트
					    sqlSessionTemplate.update("buyer.mpso.updateBuyerMpSoPrApprDtList", mp); //ICOMPRDT
					    //PR HD 업데이트
					    sqlSessionTemplate.update("buyer.mpso.updateBuyerMpSoPrApprHdList", mp); //ICOMPRHD
					    String DOCU_NO = getOrderNo(buyer,"GW");
					    mp.put("DOCU_NO", DOCU_NO);//결재번호 GW
						//결재선 등록
					    sqlSessionTemplate.update("buyer.mpso.insertBuyerMpSoIcogapassln1", mp); //ICOGPASSLN 상신자
					    sqlSessionTemplate.update("buyer.mpso.insertBuyerMpSoIcogapassln2", mp); //ICOGPASSLN 결재자
					    sqlSessionTemplate.update("buyer.mpso.insertBuyerMpSoIcogapassln3", mp); //ICOGPASSLN 결재자
					    //결재정보 등록
					    sqlSessionTemplate.update("buyer.mpso.insertBuyerMpSoIcogdocu", mp); //ICOGDOCU
					    sqlSessionTemplate.update("buyer.mpso.insertBuyerMpSoIcomtrgw", mp); //ICOMTRGW
					    
					    sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo1", mp); // ICOMBDGT
				    }else {
				    	rtnMsg = "이미 결재된건이거나 결재선 정보가 없어 처리 불가능 합니다.";
				    	//결재선 정보 없을 경우 에러 발생
						throw new RuntimeException(rtnMsg);			    	
				    }
				 }
			 }
		}catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException(rtnMsg);
	  	}
		return "OK";
	}
	
	/**
	 * 결재,취소 후처리 PX
	 */
	public String setPxPoOrder(Map<String, String> formData) {

		String flag = formData.get("RECV_FLAG").toString();

		formData.put("DOC_NAME", formData.get("DOC_TYPE").toString());
		// formData.put("DOCU_NO", formData.get("KEY_1").toString());
		Map<String, String> _passht = sqlSessionTemplate.selectOne("commonApproval.getPassWisehubNo", formData);
		String PONO = (String) _passht.get("KEY_1");
		String buyer = (String) _passht.get("KEY_2");
		String buyer_id = (String) _passht.get("KEY_3");
		String px_no = (String) _passht.get("KEY_7");
		String Po_Create_Date = (String) _passht.get("PO_CREATE_DATE");
		String Gr_Flag = (String) _passht.get("GR_FLAG");
		formData.put("PONO", PONO);
		formData.put("REF_NO", PONO);
		formData.put("KEY_1", PONO);
		formData.put("BUYER", buyer);
		formData.put("BUYER_ID", buyer_id);
		formData.put("PX_NO", px_no);
		formData.put("PO_CREATE_DATE", Po_Create_Date);
		formData.put("GR_FLAG", Gr_Flag);

		if ("PR".equals(flag)) {

			sqlSessionTemplate.update("buyer.mpso.setPxPoOrder1", formData);

			/*
			 * if(buyer.equals("KRCOWA0001") || buyer.equals("KRCOWA0002") || buyer.equals("KRCOWA0003") ||
			 * buyer.equals("KRCOWA0004") || buyer.equals("KRCOWA0005") || buyer.equals("KRCOWA0006")){
			 * sqlSessionTemplate.update("buyer.mpso.setPassPr3", formData); }
			 */
			// SLOGIC-BEGIN(P06-0000036)
			// 코웨이일경우
			String p060000036 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000036", "COL03_DATA"); // 권한특수로직
			if ("COWAY".equals(p060000036)) {
				sqlSessionTemplate.update("buyer.mpso.setPassPr3", formData);
			}
			// SLOGIC-END

		} else if ("PC".equals(flag)) {
			sqlSessionTemplate.update("buyer.mpso.setPxPoOrder2", formData);

			// 임시저장 , 발주결재상신
			if ("PT".equals(flag) || "PS".equals(flag)) {
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo1", formData); // ICOMBDGT
				// 발주
			} else if ("PC".equals(flag)) {
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo2", formData); // ICOMBDGT
				sqlSessionTemplate.update("buyer.mppo.getTempBdgtUpdateInsertMergePxPo3", formData); // ICOMBDGT
			}

		}

		return "OK";
	}

	/**
	 * 결재,취소 후처리
	 */
	public String getTempBdgtUpdateApprovalReturn(Map<String, String> formData) {

		String DOC_TYPE = formData.get("DOC_TYPE").toString(); // 타입
		if ("PR".equals(DOC_TYPE)) { // 구매요청
			sqlSessionTemplate.update("buyer.mpso.getTempBdgtUpdateApprovalReturn1", formData);
		} else if ("PX".equals(DOC_TYPE)) { // 구매대행
			sqlSessionTemplate.update("buyer.mpso.getTempBdgtUpdateApprovalReturn2", formData);
		}
		
		return "OK";
	}

	/**
	 * 
	 * 결재 상신 요청을 취소한다.
	 */
	@Transactional
	public String bizCancel(Map<String, String> _pMap) {

		String DOC_TYPE = _pMap.get("DOC_TYPE").toString(); // 타입
		if ("PX".equals(DOC_TYPE)) {
			sqlSessionTemplate.update("buyer.mpso.updatePrnoRecvFlag1", _pMap);// icomprdt_query="UPDATE ICOMPRDT SET RECV_FLAG='PD' WHERE BUYER='"+company+"' AND REF_NO='"+ref_no+"'";
		} else if ("NS".equals(DOC_TYPE)) {
			sqlSessionTemplate.update("buyer.mpso.updatePrnoRecvFlag2", _pMap);// icomprdt_query="UPDATE KEPRQDT SET RECV_FLAG='GA' WHERE BUYER='"+company+"' AND GW_NO='"+ref_no+"'";
		} else {
			sqlSessionTemplate.update("buyer.mpso.updatePrnoRecvFlag3", _pMap);// icomprdt_query="UPDATE ICOMPRDT SET RECV_FLAG='GD' WHERE BUYER='"+company+"' AND PR_NO='"+ref_no+"'";
		}
		
		// 예산 재계산 실행 HSJ 20230418
		_pMap.put("BUYER", _pMap.get("COMPANY"));
		sqlSessionTemplate.update("common.mpso.setSysopOrderChangeBeforeDelete5BudgetUpdate", _pMap);
		
		return "OK";
	}

	/**
	 * 
	 * aaaa|20140707@@bbbb|20140707@@cccc|20140707@@
	 * 
	 * 해당 key 의 값의 날짜를 리턴한다.
	 * 
	 * @param args
	 *            비교할 문자열
	 * @param key
	 *            리턴할 키
	 * @return
	 */
	private String getDateArray(String args, String key) {

		String ret = "";
		String param[] = null;
		String argsArray[] = args.split("@@");
		if (argsArray != null) {
			for (int i = 0; i < argsArray.length; i++) {
				param = argsArray[i].split("\\|");
				LOGGER.debug("getDateArray - key : {}  ",key);
				LOGGER.debug("getDateArray - param[0].toString() : {}  ", param[0].toString());
				if (param != null) {
					if (key.equals(param[0].toString())) {
						ret = param[1];
					}
				}
			}
		}

		return ret;
	}

	public List<Map<String, String>> buyerAdminBdgtTempOrderCheck(Map<String, String> formData) {

		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);

		String st_query_cart_array[] = null;
		String pr_seq_in_cart = formData.get("pr_seq_in_cart");
		String st_query_cart = formData.get("st_query_cart");

		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary(pr_seq_in_cart, "@@");
		if (_list.size() > 0) {
			data.put("pr_seq_in", _list);
		}

		st_query_cart_array = st_query_cart.split("@@");
		for (int i = 0; i < st_query_cart_array.length; i++) {

			Map<String, String> _map = new HashMap<String, String>();

			_map.put("RECV_QTY", st_query_cart_array[1]);
			_map.put("ACCOUNT_TYPE", st_query_cart_array[2]);
			_map.put("BUDGET_DEPT", st_query_cart_array[3]);
			_map.put("BUYER", formData.get("BUYER"));
			_map.put("PR_NO", st_query_cart_array[4]);
			_map.put("PR_SEQ", st_query_cart_array[0]);

			sqlSessionTemplate.update("buyer.mpso.modify_buyer_admin_bdgt_temp_order_check", _map);
		}

		return sqlSessionTemplate.selectList("buyer.mpso.select_buyer_admin_bdgt_temp_order_check", data);

	}

	public String buyerNewReCreateOrder(Map<String, String> formData) {

		String com_code = formData.get("comCode").toString();
		String person_author = formData.get("st_person_author").toString();
		String GW_NO = formData.get("st_gw_no").toString();

		String result = "";
		Map<String, String> ht = new HashMap<String, String>();

		String sPR_No = "";
		String sRecvFlag = "";
		String origin_pr_no = "";

		StringBuilder po_str = new StringBuilder();

		Map<String, Object> data = new HashMap<String, Object>();

		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) formData.get("st_query_save"), "@@");
		if (_list != null) {
			if (_list.size() > 0) {
				data.put("st_query_cart_array", _list);
			}
		}

		String st_query_cart = formData.get("st_query_save").toString();
		String[] item_array = st_query_cart.split("@@", -1);
		int iRecordCnt = 0;

		if (item_array != null) {
			iRecordCnt = item_array.length;
		}
		try {

			sPR_No = getOrderNo(com_code, "PR");
			LOGGER.debug("buyer_new_recreate_order_ICOMPRDT - person_author : {}  ", person_author);
			if ("PR".equals(person_author)) {
				if (!"N".equals(GW_NO)) { // 결재처리한 경우 GW_NO ==> GW01000003 결재문서 번호가 넘어옴 , 미처리시 GW_NO = 'N'

					ht.put("KEY_1", sPR_No);
					setPassBase(GW_NO, com_code, ht, "PR", formData);
//					gwht = setPassBase(GW_NO, com_code, ht, "PR", formData);
					sRecvFlag = "GS"; // 결재중
				} else
					sRecvFlag = "GA"; // 발주대기
			}

			LOGGER.debug("buyer_new_recreate_order_ICOMPRDT - iRecordCnt : {}  ", iRecordCnt);
			for (int i = 0; i < iRecordCnt; i++) {

				Map<String, String> _map = new HashMap<String, String>();
				String[] item_data_array = item_array[i].split("~~~", -1);
				if (item_data_array != null) {
					if (item_data_array.length > 3) {
						LOGGER.debug("buyer_new_recreate_order_ICOMPRDT - item_data_array : {}  ", item_data_array);

						_map.put("NEW_PR_NO", sPR_No);
						_map.put("RD_DATE", item_data_array[3]);
						_map.put("TARGET_QTY", item_data_array[2]);
						_map.put("RECV_FLAG", sRecvFlag);
						_map.put("BUYER", com_code);
						_map.put("PR_NO", item_data_array[0]);
						_map.put("PR_SEQ", item_data_array[1]);

						origin_pr_no = item_data_array[0];
						LOGGER.debug("buyer_new_recreate_order_ICOMPRDT - _map2 : {}  ", _map);
						sqlSessionTemplate.update("buyer.mpso.buyer_new_recreate_order_ICOMPRDT", _map);

						po_str.append(sPR_No + "~~~" + item_data_array[1] + "~~~" + "0" + "~~~" + " " + "~~~" + " "
								+ "~~~" + item_data_array[3] + "~~~" + " " + "~~~" + "@@");
					}
				}

			}

			String st_user_id = formData.get("userid").toString(); // 세션
			String st_user_dept = formData.get("st_user_dept").toString();// 세션
			String tel_no = formData.get("st_tel_no").toString(); // 세션
			String user_name = formData.get("st_user_name").toString(); // 세션
			String po_create_date = formData.get("st_po_create_date").toString();
			String gr_flag = formData.get("st_gr_flag").toString();
			String account_type = formData.get("st_account_type_code").toString();
			String st_location_name = formData.get("st_location_name").toString();
			String st_remark = formData.get("st_remark").toString();
			String tot_price = formData.get("nu_end_price").toString();

			po_str.append("|");
			po_str.append(com_code); // 구매사
			po_str.append("|");
			po_str.append(st_user_id); // 요청자
			po_str.append("|");
			po_str.append(st_user_dept); // 요청자 부서
			po_str.append("|");
			po_str.append("1"); // 1로 넘김 ==> 발주
			po_str.append("|");
			po_str.append(tel_no); // 요청자 전화번호
			po_str.append("|");
			po_str.append(user_name); // 요청자 이름
			po_str.append("|");
			po_str.append(GW_NO); // 결재 여부 Y(결재) , N(미결재)
			po_str.append("|");
			po_str.append(po_create_date); // 발주일자
			po_str.append("|");
			po_str.append(gr_flag); // 선입고 여부 Y(선입고) , N(발주)
			po_str.append("|");
			po_str.append("0"); // 0 으로 넘김
			po_str.append("|");
			po_str.append("PXPO"); // PXPO 으로 넘김
			po_str.append("|");
			po_str.append(account_type); // ACCOUNT_TYPE
			po_str.append("|");
			po_str.append(st_user_dept); // 요청자 부서
			po_str.append("|");

			Map<String, String> _map2 = new HashMap<String, String>();

			_map2.put("NEW_PR_NO", sPR_No);
			_map2.put("RECV_FLAG", sRecvFlag);
			_map2.put("DELY_TO_LOCATION", st_location_name);
			_map2.put("REMARK", st_remark);
			_map2.put("DOC_TYPE", gr_flag);
			_map2.put("BUYER", com_code);
			_map2.put("PR_NO", origin_pr_no);

			LOGGER.debug("buyer_new_recreate_order_ICOMPRHD - _map2 : {}  ", _map2);
			sqlSessionTemplate.update("buyer.mpso.buyer_new_recreate_order_ICOMPRHD", _map2);

			_map2.put("END_PRICE", tot_price);
			_map2.put("DEPT", st_user_dept);
			_map2.put("ACCOUNT_TYPE", account_type);

			LOGGER.debug("buyer_new_recreate_order_getTempBdgtUpdate - _map2 : {}  ", _map2);
			sqlSessionTemplate.update("buyer.mpso.buyer_new_recreate_order_getTempBdgtUpdate", _map2);

			LOGGER.debug("buyerNewReCreateOrder - po_str : {}  ", po_str);

			formData.put("st_query", po_str.toString());

			// 직발주
			if ("PO".equals(person_author)) {
				result = insertMergePxPo(formData, "DUPNOCHECK");
			} else {
				result = sPR_No;
			}

			LOGGER.debug("buyerNewReCreateOrder - result : {}  ", result);

		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("주문 실패하였습니다.");
		}

		return result;
	}

	public void call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO(Map<String, String> formData) {
		sqlSessionTemplate.update("buyer.mpso.call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO", formData);
	}

	/**
	 * 포인트관련 적용
	 * @param comCode
	 * @param prNo
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> getCowayPointChk(String comCode, String prNo, String userId) {
		Map<String, Object> data = new HashMap<String, Object>();
		data.put("BUYER", comCode);
		data.put("PR_NO", prNo);
		List<Map<String, String>> mgCodeList =sqlSessionTemplate.selectList("buyer.mpso.getCowayMgcodeList", data);
		return mgCodeList;
	}

	@Override
	public void insertCowayPointHistory(Map<String, Object> data) {
		String buyer = data.get("COMPANY").toString();
		String prNo = data.get("KEY_1").toString();
		data.put("BUYER", buyer);
		data.put("PR_NO", prNo);
		sqlSessionTemplate.insert("buyer.mpso.insertCowayPointHistory", data);
		
	}

	@Override
	public Map<String, String> createNewCreateGroupware(Map<String, String> formData) {
		Map<String, String> rtn	= new HashMap<String, String>();
		Map<String, Object> data = new HashMap<String, Object>();
		List<String> _list = new ArrayList<String>();
		
		try {

			data.putAll(formData);
			_list = CommonUtil.getStringArrary((String) formData.get("st_query_cart"), "@@");
			if (_list.size() > 0) {
				data.put("st_query_cart_array", _list);
			}

			/* SEQ를 필요로 하는 st_query_cart 부분 추가 시작 */	

			String st_query_cart_temp = formData.get("st_query_cart");
			String st_query_cart_tmp_list[] = st_query_cart_temp.split("@@");		
			String st_query_cart_seq = "";
			data.put("st_seqYn", "N");

			if (st_query_cart_tmp_list != null) {
				
				// ICOMCART.SEQ 구분자 : &&
				for (int i = 0; i < st_query_cart_tmp_list.length; i++) {
					String str[] =  st_query_cart_tmp_list[i].split("&&",-1);  
					
					for( int k=0; k < str.length; k++){
						LOGGER.debug("str["+k+"] ==>" + str[k]);
					} 
				
					LOGGER.debug("str.length ==>" + str.length);
					
					// SEQ 존재하면 st_seqYn(xml의 조건에서 사용)
					if (str != null && str.length == 2){
						data.put("st_cart_seq", str[1]);
							data.put("st_seqYn", "Y");
							st_query_cart_seq += str[0] + str[1] + "@@";
					}else{ // 없으면 원문 그대로
						st_query_cart_seq = st_query_cart_temp;
					}
				}
				
				_list = CommonUtil.getStringArrary(st_query_cart_seq,"@@");
				
				LOGGER.debug("_list ==>" + _list );
				
				data.put("st_query_cart_array", _list);
			}

			/* SEQ를 필요로 하는 st_query_cart 부분 추가 종료 */
			
			String cnt = sqlSessionTemplate.selectOne("buyer.mpso.selectICOMCARTCheck", data);
			
			if ("0".equals(cnt)) {
				rtn.put("MSG","DUP");
				return rtn; // 이미진행된 상태로 리턴후 화면에 메시지 출력한다.....
			}

			LOGGER.debug("createBuyerNewCreateBenit - formData : {}  ", formData.get("st_query_cart"));
			LOGGER.debug("createBuyerNewCreateBenit - formData : {}  ", formData.get("st_query_cart_date"));

			String st_query_cart_date_tmp[] = null;
			String st_query_cart_date = formData.get("st_query_cart_date");
			String st_query_cart_tmp[] = st_query_cart_date.split("@@");
			
			String doc_no	= sqlSessionTemplate.selectOne("selectNewCreateGroupwareOrderNo");

			if (st_query_cart_date == null || "".equals(st_query_cart_date)) {
				LOGGER.debug("createBuyerNewCreateOrder - st_query_cart_date XXXXXXXXXXX  ");
				data.put("st_doc_no", doc_no);
				data.put("st_seq", "1");
				int rtnCnt = sqlSessionTemplate.insert("buyer.mpso.insertSetNewCreateGroupwareOrder", data);
				
				if (rtnCnt == 0) {
					throw new Exception("데이터 생성에 실패했습니다.");
				}
				
			} else {
				if (st_query_cart_tmp != null) {
					for (int i = 0; i < st_query_cart_tmp.length; i++) {
						st_query_cart_date_tmp = st_query_cart_tmp[i].split("\\|");
						data.put("st_recv_date2", st_query_cart_date_tmp[1]);
						data.put("st_query_cart_array", "");
						data.put("st_query_cart_array2", st_query_cart_date_tmp[0]);
						data.put("st_doc_no", doc_no);
						data.put("st_seq", Integer.toString(i+1));
						int rtnCnt = sqlSessionTemplate.insert("buyer.mpso.insertSetNewCreateGroupwareOrder", data);
						
						if (rtnCnt == 0) {
							throw new Exception("데이터 생성에 실패했습니다.");
						}
					}
				}
			}
			data.put("st_query_cart_array", _list);
			data.put("st_query_cart_array2", "");
			sqlSessionTemplate.delete("buyer.mpso.deleteSetNewCreateBenitOrder", data);
			
			rtn.put("DOC_NO", doc_no);
			rtn.put("MSG","PR");

		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException();
		}

		return rtn;
	}
	
	private Map<String, String> ypRfcPrCreateCall(Map<String, String> formData) throws Exception {

		Map<String, String> rtn	= new HashMap<String, String>();
		SapManager ypSap = null;
        
        String E_KEP_NUM	= "";
        String E_BANFN	= "";
        String E_AEDAT	= "";
        String E_ERNAM	= "";
        String E_GWURL	= "";
        String E_ZFLAG	= "";
        String E_ZMSS	= "";
		
		try {
			LOGGER.error("ypRfcPrCreateCall Check 1 : " + formData.get("st_server_mode") + " / " + formData.get("st_buyer") + " / " + formData.get("sPR_No"));
			List<Map<String, String>> jco_prop = sqlSessionTemplate.selectList("common.mpif.selectRfcYPProperties", formData);
			LOGGER.error("ypRfcPrCreateCall Check 2 : " + jco_prop.get(0).get("JCO_CLIENT"));

			// 연결 생성
			ypSap = new SapManager("YP").newSapManagerBinder()
					.set(DestinationDataProvider.JCO_CLIENT, jco_prop.get(0).get("JCO_CLIENT"))
					.set(DestinationDataProvider.JCO_USER, jco_prop.get(0).get("JCO_USER"))
					.set(DestinationDataProvider.JCO_PASSWD, jco_prop.get(0).get("JCO_PASSWD"))
					.set(DestinationDataProvider.JCO_LANG, jco_prop.get(0).get("JCO_LANG"))
					.set(DestinationDataProvider.JCO_ASHOST, jco_prop.get(0).get("JCO_ASHOST"))
					.set(DestinationDataProvider.JCO_SYSNR, "00")
					.bind(true);
	        
			String functionName	= "ZMRO_PR_CREATE";
			
			SapRfcFunction rfc = ypSap.getRfcFunction(functionName);
	        List<Map<String, String>> prList = sqlSessionTemplate.selectList("buyer.mpso.selectYoungPoongPRList", formData);
	        rfc.imports();
			rfc.imports().setValue("I_KEP_NUM", prList.get(0).get("KEP_NUM"));
			rfc.imports().setValue("I_ZGWID", prList.get(0).get("LEGACY_USER_ID"));
			rfc.imports().setValue("I_ZNAME", prList.get(0).get("ADD_USER_NAME"));
			
			JCoTable input_tables = rfc.importTable("I_TBODY");
			input_tables.clear();

	        
	        for(Map<String, String> iMap : prList) {
	        	input_tables.appendRow();
	        	
	        	input_tables.setValue("KEP_ITEM",	iMap.get("PR_SEQ"));	// pr_seq
	        	input_tables.setValue("KNTTP",		iMap.get("WBS_FLAG"));		// 계정지정범주(" ", "Y")
	        	input_tables.setValue("MATNR",		iMap.get("BUYER_ITEM_NO"));		// buyer_item_no	
	        	input_tables.setValue("MENGE",		iMap.get("TARGET_QTY"));		// 수량
	        	input_tables.setValue("NETPR",		iMap.get("TARGET_PRICE"));		// 단가
	        	input_tables.setValue("KOSTL",		iMap.get("COST_CENTER"));		// 코스트 센터
	        	input_tables.setValue("PS_POSID",	iMap.get("WBS"));	// WBS요소
	        	input_tables.setValue("BNFPO",		iMap.get("PR_SEQ"));		// SAP PR Item 번호
	        	input_tables.setValue("LFDAT",		iMap.get("RD_DATE"));		// 납기요청일
	        }
	        
	        rfc.execute();
	        
	        JCoParameterList export = rfc.exports();
	        
	        E_KEP_NUM	= (String) export.getValue("E_KEP_NUM");
	        E_BANFN	= (String) export.getValue("E_BANFN");
	        E_GWURL	= (String) export.getValue("E_GWURL");
	        E_ZFLAG	= (String) export.getValue("E_ZFLAG");
	        E_ZMSS	= (String) export.getValue("E_ZMSS");
			
	        formData.put("st_legacy_pr_no", E_BANFN);
	        formData.put("st_gw_url", E_GWURL);
	        formData.put("st_ori_pr_no", E_KEP_NUM);
	        
	        rtn.put("FLAG", E_ZFLAG);
	        rtn.put("ERR_MSG", E_ZMSS);
	        rtn.put("CALL_URL", E_GWURL);

	        // 결과 후 처리.
	        if ( !"S".equals(E_ZFLAG) ) {
	        	LOGGER.error("ypRfcPrCreateCall 영풍 SAP 생성 오류 : " + E_ZMSS);
	        	throw new Exception("ypRfcPrCreateCall " + E_ZMSS);
	        } else {
	        	sqlSessionTemplate.update("common.mpif.updateYPPrInfo", formData);
	        }
		} catch (Exception e) {
			LOGGER.error("ypRfcPrCreateCall ERROR : " + e.getMessage());
			throw new Exception(e.getMessage());
		}
		
		return rtn;
	}

	private String makeBuyerXmlData(Map<String, String> pMap) throws Exception {
		String xmlStr	= null;
		
		List<Map<String, Object>> prAppInfo = sqlSessionTemplate.selectList("buyer.mpso.selectLtalAppInfo", pMap);
		String subject = (String)prAppInfo.get(0).get("SUBJECT");
		
		StringBuffer tmpXml	= new StringBuffer();
		tmpXml.append("<DBAPPROVAL>\n");
		tmpXml.append("<HEADER>\n");
		tmpXml.append("<SYSTEMID><![CDATA[MRO]]></SYSTEMID>\n");
		tmpXml.append("<MODULEID><![CDATA[MM]]></MODULEID>\n");
		tmpXml.append("<KEYVALUE><![CDATA[MROMM000000_"+pMap.get("BUYER") + "_" + pMap.get("PR_NO")+"]]></KEYVALUE>\n");
		tmpXml.append("<FORMALIAS><![CDATA[MRO_002]]></FORMALIAS>\n");
		tmpXml.append("<TITLE><![CDATA[구매 오더서]]></TITLE>\n");
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
		tmpXml.append("<HEAD>\n");
		tmpXml.append("<PR_NO><![CDATA["+pMap.get("PR_NO")+"]]></PR_NO>\n");
		tmpXml.append("<PURCHASE_DEPT><![CDATA["+prAppInfo.get(0).get("PURCHASE_DEPT")+"]]></PURCHASE_DEPT>\n");
		tmpXml.append("<PLANT><![CDATA["+prAppInfo.get(0).get("PLANT")+"]]></PLANT>\n");
		tmpXml.append("<PO_CREATE_DATE><![CDATA["+prAppInfo.get(0).get("PO_CREATE_DATE")+"]]></PO_CREATE_DATE>\n");
		tmpXml.append("<ITEM_TYPE><![CDATA["+prAppInfo.get(0).get("ITEM_TYPE")+"]]></ITEM_TYPE>\n");
		tmpXml.append("<LOCATION><![CDATA["+prAppInfo.get(0).get("LOCATION")+"]]></LOCATION>\n");
		tmpXml.append("<HD_REMARK><![CDATA["+prAppInfo.get(0).get("HD_REMARK")+"]]></HD_REMARK>\n");
		tmpXml.append("<PO_CNT><![CDATA["+prAppInfo.get(0).get("PO_CNT")+"]]></PO_CNT>\n");
		tmpXml.append("<ITEM_QTY_SUM><![CDATA["+prAppInfo.get(0).get("ITEM_QTY_SUM")+"]]></ITEM_QTY_SUM>\n");
		tmpXml.append("<ITEM_AMT_SUM><![CDATA["+prAppInfo.get(0).get("ITEM_AMT_SUM")+"]]></ITEM_AMT_SUM>\n");
		tmpXml.append("</HEAD>\n");
		tmpXml.append("<LIST>\n");
		for(Map<String, Object> iMap : prAppInfo) {
			tmpXml.append("<ITEM>\n");
			tmpXml.append("<PR_SEQ><![CDATA["+iMap.get("PR_SEQ")+"]]></PR_SEQ>\n");
			tmpXml.append("<BUYER_ITEM_NO><![CDATA["+iMap.get("BUYER_ITEM_NO")+"]]></BUYER_ITEM_NO>\n");
			tmpXml.append("<DESCRIPTION><![CDATA["+iMap.get("DESCRIPTION")+"]]></DESCRIPTION>\n");
			tmpXml.append("<SPECIFICATION><![CDATA["+iMap.get("SPECIFICATION")+"]]></SPECIFICATION>\n");
			tmpXml.append("<UNIT_MEASURE><![CDATA["+iMap.get("UNIT_MEASURE")+"]]></UNIT_MEASURE>\n");
			tmpXml.append("<ITEM_QTY><![CDATA["+iMap.get("ITEM_QTY")+"]]></ITEM_QTY>\n");
			tmpXml.append("<UNIT_PRICE><![CDATA["+iMap.get("UNIT_PRICE")+"]]></UNIT_PRICE>\n");
			tmpXml.append("<ITEM_AMT><![CDATA["+iMap.get("ITEM_AMT")+"]]></ITEM_AMT>\n");
			tmpXml.append("<MAKER_NAME><![CDATA["+iMap.get("MAKER_NAME")+"]]></MAKER_NAME>\n");
			tmpXml.append("<ORIGIN_NAME><![CDATA["+iMap.get("ORIGIN_NAME")+"]]></ORIGIN_NAME>\n");
			tmpXml.append("<PO_REMARK><![CDATA["+iMap.get("PO_REMARK")+"]]></PO_REMARK>\n");
			tmpXml.append("</ITEM>\n");
		}
		tmpXml.append("</LIST>\n");
		tmpXml.append("</CONTENT>\n");
		tmpXml.append("</BODY>\n");
		tmpXml.append("</DBAPPROVAL>\n");

        xmlStr	= tmpXml.toString();
		
		return xmlStr;
	}
	
	public String insertIFAppInfoTYPE06(Map<String, String> formData) throws Exception {
		/**
		 * 
		 * 1. INSERT INTO EAI.IF_UCUBE_PR_SEND
		 * 2. SELECT URL AND MAKE URL 
		 * 3. RETURN.
		 */
		/**
		 * 
		 * 
		 *  /mpso/getWhaninPop.do?pr_no=pr19000001&buyer=KRWHAN0001&legacy_user_id=218023
		 * 
		 */
		
		// 1. INSERT INTO EAI.IF_UCUBE_PR_SEND
		sqlSessionTemplate.insert("buyer.mpso.insertWhaninPr", formData);
		
		// 2. MAKING
		Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer"), "P11-0000004");
		Map<String, String> pMap = sqlSessionTemplate.selectOne("selectLegacyUserIdById",formData);
		
		String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
		String form_key	= CommonUtil.nvl(slgMap.get("COL03_DATA"));
		String legacy_user_id = pMap.get("LEGACY_USER_ID").toString();
		
		String extra = "{&quot;"+"BUYER"+"&quot;^&quot;"+formData.get("buyer")+"&quot;,"+"&quot;"+"PR_NO"+"&quot;^&quot;"+formData.get("sPR_No")+"&quot;,&quot;GUBUN&quot;^&quot;ZWPO_PURCHASE_APPROVAL&quot;}";
		
		String result = st_url + "?EMP_NO=" + legacy_user_id + "&FORM_KEY=" + form_key + "&EXTRA=" + extra;
		
		
		return result;
	}
	
	public void insertIFAppInfoTYPE07(Map<String, String> formData) throws Exception {
		/**
		 * TYPE07 : PR 생성 후 인터페이스 테이블에 적재.
		 * PR의 상태값을 결재 진행중으로 변경.
		 * PX번호 채번하여 등록
		 */
		
		String pxNo = getOrderNo(formData.get("buyer"), "PX");
		formData.put("REF_NO", pxNo);
		
		sqlSessionTemplate.update("buyer.mpso.updatePRDT_TYPE07", formData);
	}
	
	public void insertIFAppInfoTYPE20(Map<String, String> formData) throws Exception {
		// 1. INSERT INTO EAI.IF_UCUBE_PR_SEND
		sqlSessionTemplate.insert("buyer.mpso.insertNexePr", formData);
				
		// 2. SELECT FROM EAI.IF_UCUBE_PR_SEND
		List<Map<String, String>> NexePrList =sqlSessionTemplate.selectList("buyer.mpso.selectNexePrList", formData);
		
		org.json.simple.JSONArray ZKEP_PO = new org.json.simple.JSONArray();
		JSONObject jsonObj2 = new JSONObject();
		JSONObject jsonObj3 = new JSONObject();
		
		int prSize = NexePrList.size();
		if(prSize > 0) {
			Map<String, String> resultMap = new HashMap<String, String>();
			for (Map<String, String> prMap : NexePrList) {
				resultMap = prMap;

				JSONObject jsonObj1 = new JSONObject();
				jsonObj1.put("BUKRS", "KR10"); //회사코드
				jsonObj1.put("PR_NO", prMap.get("BUYER")+prMap.get("DOC_NO")); //kep발주번호
				jsonObj1.put("PR_SEQ", prMap.get("DOC_SEQ")); //kep발주항번
				jsonObj1.put("ADD_DATE", prMap.get("ADD_DATE")); //주문생성일
				jsonObj1.put("CURRENCY", "KRW"); //통화키
				jsonObj1.put("BUYER_ITEM_NO",  prMap.get("BUYER_ITEM_NO")); //품목코드
				jsonObj1.put("PR_REMARK",  prMap.get("DESCRIPTION")); //주문 비고
				jsonObj1.put("PLANT", prMap.get("PLANT")); //플랜트
				jsonObj1.put("ITEM_QTY", prMap.get("ITEM_QTY")); //주문수량
				jsonObj1.put("UNIT_MEASURE", prMap.get("UNIT_MEASURE")); //단위
				jsonObj1.put("PER", "1"); //per
				jsonObj1.put("UNIT_PRICE", prMap.get("UNIT_PRICE")); //단가
				jsonObj1.put("ITEM_AMT", prMap.get("ITEM_AMT")); //금액
				jsonObj1.put("RD_DATE", prMap.get("RD_DATE")); //납품요청일
				jsonObj1.put("KNTTP", prMap.get("KEY_1")); //계정지정범주 (K : 코스트센터, A: 고정자산)
				if("K".equals(prMap.get("KEY_1"))) {
					jsonObj1.put("KOSTL", prMap.get("BUDGET_DEPT")); //코스트 센터 (K일때 입력)
					jsonObj1.put("SAKTO", prMap.get("ACCOUNT_TYPE")); //G/L 계정 번호 (K일때 입력)
					jsonObj1.put("ANLN1", ""); //고정 자산 번호 (A일때 입력) 
					jsonObj1.put("AUFNR", ""); //오더 번호 (A일때 입력) 빈 값으로 전송 sap 에서 맵핑해주기로 함 
				}else {
					jsonObj1.put("KOSTL", ""); //코스트 센터 (K일때 입력)
					jsonObj1.put("SAKTO", ""); //G/L 계정 번호 (K일때 입력)
					jsonObj1.put("ANLN1", prMap.get("REF_PR_NO")); //고정 자산 번호 (A일때 입력) 
					jsonObj1.put("AUFNR", ""); //오더 번호 (A일때 입력) 빈 값으로 전송 sap 에서 맵핑해주기로 함 
				}
				jsonObj1.put("AFNAM",  prMap.get("LEGACY_USER_ID")); //요청자
				jsonObj1.put("IF_FLAG", ""); //flag
				jsonObj1.put("IF_MSG", ""); //msg
				
				ZKEP_PO.add(jsonObj1);
			}	
			
			jsonObj2.put("ZKEP_PO", ZKEP_PO);
			jsonObj3.put("Request", jsonObj2);
			
			Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer"), "P11-0000004");
			String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
			String st_login	= CommonUtil.nvl(slgMap.get("COL03_DATA"));
			
			String basicKey = Base64.getEncoder().encodeToString((st_login).getBytes()); 
			
			URL url = new URL(st_url);
			HttpURLConnection httpUrlConn = (HttpURLConnection)url.openConnection();
			
			httpUrlConn.setRequestMethod("POST");
			httpUrlConn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			httpUrlConn.setRequestProperty("Authorization", "Basic " + basicKey);
			httpUrlConn.setDoOutput(true); 
			httpUrlConn.setDoInput(true);
			httpUrlConn.setRequestProperty("Accept", "application/json");
			httpUrlConn.setConnectTimeout(10000); 
			
			OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream(), "utf-8");
			wr.write(jsonObj3.toString());
			wr.flush();
			wr.close();
			StringBuilder sb = new StringBuilder();
			if (httpUrlConn.getResponseCode() == HttpURLConnection.HTTP_OK) {
				BufferedReader br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonResponse = (JSONObject) jsonParser.parse(sb.toString());
	
				JSONObject ResponseObj1 = (JSONObject) jsonResponse;
				JSONObject ResponseObj2 = (JSONObject) ResponseObj1.get("Response");
				org.json.simple.JSONArray resultArray = (org.json.simple.JSONArray) ResponseObj2.get("ZKEP_PO");			
				
				httpUrlConn.disconnect();

				String flag = "";
				String errMsg = "";
				for (int i = 0; i < resultArray.size(); i++) {
					JSONObject resultObj = (JSONObject)resultArray.get(i);
					flag += resultObj.get("IF_FLAG");
					if(resultObj.get("IF_MSG") != null && !errMsg.contains((String)resultObj.get("IF_MSG"))) {
						errMsg += resultObj.get("IF_MSG");
					}
				}
				//한 품목이라도 if_flag = E 면 전부 오류  
				if(flag.contains("E")) {
					throw new Exception("NEXEAPICALL \n넥센타이어 SAP 오류 발생 하였습니다.\n" + errMsg);
				}else {
					resultMap.put("FLAG", "S");
					sqlSessionTemplate.insert("buyer.mpso.updateNexePrResult", resultMap);
				}
			} else {
				BufferedReader br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonResponse = (JSONObject) jsonParser.parse(sb.toString());
				httpUrlConn.disconnect();
				throw new Exception("NEXEAPICALL \n넥센타이어 SAP 오류 발생 하였습니다.");
			}
		}
	}
	
	public void insertIFAppInfoTYPE22(Map<String, String> formData) throws Exception {
		// 1. INSERT INTO EAI.IF_UCUBE_PR_SEND
		sqlSessionTemplate.insert("buyer.mpso.insertNexePr", formData);
				
		// 2. SELECT FROM EAI.IF_UCUBE_PR_SEND
		List<Map<String, String>> NexePrList =sqlSessionTemplate.selectList("buyer.mpso.selectNexePrList", formData);
		
		org.json.simple.JSONArray ZKEP_PO = new org.json.simple.JSONArray();
		JSONObject jsonObj2 = new JSONObject();
		JSONObject jsonObj3 = new JSONObject();
		
		int prSize = NexePrList.size();
		if(prSize > 0) {
			Map<String, String> resultMap = new HashMap<String, String>();
			for (Map<String, String> prMap : NexePrList) {
				resultMap = prMap;

				JSONObject jsonObj1 = new JSONObject();
				jsonObj1.put("BUKRS", "KR10"); //회사코드
				jsonObj1.put("STATUS", "C"); //상태값
				jsonObj1.put("BANFN", ""); 					 //SAP구매요청번호
				jsonObj1.put("BNFPO", ""); 					 //SAP구매요청항번
				jsonObj1.put("PR_NO", prMap.get("BUYER")+prMap.get("DOC_NO")); //kep발주번호
				jsonObj1.put("PR_SEQ", prMap.get("DOC_SEQ")); //kep발주항번
				jsonObj1.put("ADD_DATE", prMap.get("ADD_DATE")); //주문생성일
				jsonObj1.put("CURRENCY", "KRW"); //통화키
				jsonObj1.put("BUYER_ITEM_NO",  prMap.get("BUYER_ITEM_NO")); //품목코드
				jsonObj1.put("PR_REMARK",  prMap.get("DESCRIPTION")); //주문 비고
				jsonObj1.put("PLANT", prMap.get("PLANT")); //플랜트
				jsonObj1.put("ITEM_QTY", prMap.get("ITEM_QTY")); //주문수량
				jsonObj1.put("UNIT_MEASURE", prMap.get("UNIT_MEASURE")); //단위
				jsonObj1.put("PER", "1"); //per
				jsonObj1.put("UNIT_PRICE", prMap.get("UNIT_PRICE")); //단가
				jsonObj1.put("ITEM_AMT", prMap.get("ITEM_AMT")); //금액
				jsonObj1.put("RD_DATE", prMap.get("RD_DATE")); //납품요청일
				jsonObj1.put("KNTTP", prMap.get("KEY_1")); //계정지정범주 (K : 코스트센터, A: 고정자산)
				if("K".equals(prMap.get("KEY_1"))) {
					jsonObj1.put("KOSTL", prMap.get("BUDGET_DEPT")); //코스트 센터 (K일때 입력)
					jsonObj1.put("SAKTO", prMap.get("ACCOUNT_TYPE")); //G/L 계정 번호 (K일때 입력)
					jsonObj1.put("ANLN1", ""); //고정 자산 번호 (A일때 입력) 
					jsonObj1.put("AUFNR", ""); //오더 번호 (A일때 입력) 빈 값으로 전송 sap 에서 맵핑해주기로 함 
				}else {
					jsonObj1.put("KOSTL", ""); //코스트 센터 (K일때 입력)
					jsonObj1.put("SAKTO", ""); //G/L 계정 번호 (K일때 입력)
					jsonObj1.put("ANLN1", prMap.get("REF_PR_NO")); //고정 자산 번호 (A일때 입력) 
					jsonObj1.put("AUFNR", ""); //오더 번호 (A일때 입력) 빈 값으로 전송 sap 에서 맵핑해주기로 함 
				}
				jsonObj1.put("AFNAM",  prMap.get("LEGACY_USER_ID")); //요청자
				jsonObj1.put("IF_FLAG", ""); //flag
				jsonObj1.put("IF_MSG", ""); //msg
				
				ZKEP_PO.add(jsonObj1);
			}	
			
			jsonObj2.put("ZKEP_PO", ZKEP_PO);
			jsonObj3.put("Request", jsonObj2);
			
			Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer"), "P11-0000004");
			String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
			String st_login	= CommonUtil.nvl(slgMap.get("COL03_DATA"));
			
			String basicKey = Base64.getEncoder().encodeToString((st_login).getBytes()); 
			
			URL url = new URL(st_url);
			HttpURLConnection httpUrlConn = (HttpURLConnection)url.openConnection();
			
			httpUrlConn.setRequestMethod("POST");
			httpUrlConn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			httpUrlConn.setRequestProperty("Authorization", "Basic " + basicKey);
			httpUrlConn.setDoOutput(true); 
			httpUrlConn.setDoInput(true);
			httpUrlConn.setRequestProperty("Accept", "application/json");
			httpUrlConn.setConnectTimeout(10000); 
			
			OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream(), "utf-8");
			wr.write(jsonObj3.toString());
			wr.flush();
			wr.close();
			StringBuilder sb = new StringBuilder();
			if (httpUrlConn.getResponseCode() == HttpURLConnection.HTTP_OK) {
				BufferedReader br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonResponse = (JSONObject) jsonParser.parse(sb.toString());
	
				JSONObject ResponseObj1 = (JSONObject) jsonResponse;
				JSONObject ResponseObj2 = (JSONObject) ResponseObj1.get("Response");
				org.json.simple.JSONArray resultArray = (org.json.simple.JSONArray) ResponseObj2.get("ZKEP_PO");			
				
				httpUrlConn.disconnect();

				String flag = "";
				String errMsg = "";
				for (int i = 0; i < resultArray.size(); i++) {
					JSONObject resultObj = (JSONObject)resultArray.get(i);
					flag += resultObj.get("IF_FLAG");
					if(resultObj.get("IF_MSG") != null && !errMsg.contains((String)resultObj.get("IF_MSG"))) {
						errMsg += resultObj.get("IF_MSG");
					}
				}
				//한 품목이라도 if_flag = E 면 전부 오류  
				if(flag.contains("E")) {
					throw new Exception("NEXEAPICALL \n넥센타이어 SAP 오류 발생 하였습니다.\n" + errMsg);
				}else {
					resultMap.put("FLAG", "S");
					sqlSessionTemplate.insert("buyer.mpso.updateNexePrResult", resultMap);
				}
			} else {
				BufferedReader br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonResponse = (JSONObject) jsonParser.parse(sb.toString());
				httpUrlConn.disconnect();
				throw new Exception("NEXEAPICALL \n넥센타이어 SAP 오류 발생 하였습니다.");
			}
		}
	}
	
	public String CallHanLimAppList(Map<String, String> formData) throws Exception {
		/**
		 * 한림제약 결재 팝업창 호출
		 * 
		 * gwdev.hanlim.com/ekp/view/openapi/IF_EAP_001_goWrite?USER_ID=[사용자사번]&USER_ID_TYPE=N&WORK_ID=[결재업무고유번호]&INTRLCK_CD_NAME=[연동명]&INTRLCK_CD_VAL=[연동코드]&PO_REQ_NO=[구입요청번호]
		   gwdev.hanlim.com/ekp/view/openapi/IF_EAP_001_goWrite?USER_ID=2008044&USER_ID_TYPE=N&WORK_ID=AW133727604399259494803&INTRLCK_CD_NAME=egj_po_req&INTRLCK_CD_VAL=DXP8JJ1YERTL&PO_REQ_NO=PR20000223
		 */
		Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer"), "P11-0000004");
		Map<String, String> pMap = sqlSessionTemplate.selectOne("selectLegacyUserIdById",formData);
		
		
		String st_url	= CommonUtil.nvl(slgMap.get("COL05_DATA"));
		String work_id	= CommonUtil.nvl(slgMap.get("COL06_DATA"));
		String intrlck_cd_name = CommonUtil.nvl(slgMap.get("COL03_DATA"));
		String intrlck_cd_val	= CommonUtil.nvl(slgMap.get("COL04_DATA"));
		
		
		String legacy_user_id = pMap.get("LEGACY_USER_ID").toString();
		
		
		String result =  st_url + "?USER_ID=" + legacy_user_id + "&USER_ID_TYPE=N&WORK_ID=" + work_id + "&INTRLCK_CD_NAME=" + intrlck_cd_name + "&INTRLCK_CD_VAL=" +   intrlck_cd_val     + "&PO_REQ_NO=" + formData.get("sPR_No") ;
		
		return result;
	}
	
	public String CallDongWhaAppList(Map<String, String> formData,String IFKey) throws Exception {
		/**
		 * 동화산업 결재 팝업창 호출
		 * 
		     http://ep.dongwhadev.com:8180/gw/apprDocGet.do?
		 */
		Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer"), "P11-0000004");
		Map<String, String> pMap = sqlSessionTemplate.selectOne("selectLegacyUserIdById",formData);
		
		
		String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
		
//		String result =  st_url + "receiveId="+IFKey ;
		String result =  IFKey ;
		
		
		
		return result;
	}
	
	public List<Map<String,String>> SelectHanLimAppList(Map<String, String> formData) throws Exception {
		/**
		 * 한림제약 APPLIST
		 */
		
		List<Map<String,String>> iMap = sqlSessionTemplate.selectList("buyer.mpso.SelectHanLimAppList", formData);
		
		return iMap;
	}
	
	public List<Map<String,String>> SelectDongWhaAppList(Map<String, String> formData) throws Exception {
		/**
		 * 동화산업 APPLIST
		 */
		
		List<Map<String,String>> iMap = sqlSessionTemplate.selectList("buyer.mpso.SelectDongWhaAppList", formData);
		
		return iMap;
	}
	
	public void updatePRDT_DWHA(Map<String, String> formData) throws Exception {
		/**
		 * TYPE07 : PR 생성 후 인터페이스 테이블에 적재.
		 * PR의 상태값을 결재 진행중으로 변경.
		 * PX번호 채번하여 등록
		 */
		
		String pxNo = getOrderNo(formData.get("buyer"), "PX");
		formData.put("REF_NO", pxNo);
		
		sqlSessionTemplate.update("buyer.mpso.updatePRDT_DWHA", formData);
		sqlSessionTemplate.update("buyer.mpso.updatePRHD_DWHA", formData);
		
	}
	
	public String getXml(List<Map<String,String>> objs, String tol_amount) throws Exception {

		StringBuffer xml	= new StringBuffer();
		String BANFN = "";
		
        xml.append("<ROOT>");
		
		xml.append("  <HEADER>");
		xml.append("  <LANGUAGE>ENG</LANGUAGE>");
		xml.append("    <AMOUNT>" + tol_amount + "</AMOUNT>");
		xml.append("  </HEADER>");
		
		xml.append("    <TABLE>");
        for(Map<String,String> iMap : objs) {
        	
        	xml.append("    <RECORD>");
        	
            xml.append("<BANFN>"+ iMap.get("PR_NO") +"</BANFN>");
            xml.append("<BNFPO>" + iMap.get("PR_SEQ") +"</BNFPO>");
			xml.append("<ERNAM>"+iMap.get("ERNAM")+"</ERNAM>");
			xml.append("<NAME_TEXTC><![CDATA["+iMap.get("NAME_TEXTC")+"]]></NAME_TEXTC>");  // ?
			xml.append("<PSTYP></PSTYP>");
			xml.append("<EKGRP></EKGRP>");
			xml.append("<EKNAM></EKNAM>");
			xml.append("<MATNR>"+iMap.get("MATNR")+"</MATNR>");
			xml.append("<TXZ01><![CDATA["+iMap.get("TXZ01")+"]]></TXZ01>");
			xml.append("<MENGE>"+String.valueOf(iMap.get("MENGE"))+"</MENGE>");
			xml.append("<MEINS>"+iMap.get("MEINS")+"</MEINS>");
			xml.append("<ZREQA>"+String.valueOf(iMap.get("ZREQA"))+"</ZREQA>");
			xml.append("<WAERS>"+iMap.get("WAERS")+"</WAERS>");
			xml.append("<WERKS>"+iMap.get("WERKS")+"</WERKS>");
			xml.append("<NAME1>"+iMap.get("NAME1")+"</NAME1>");
			xml.append("<LFDAT>"+iMap.get("LFDAT")+"</LFDAT>");			
			xml.append("<MATKL></MATKL>");
			xml.append("<WGBEZ><![CDATA[]]></WGBEZ>");
			xml.append("<AUFNR>　</AUFNR>");
			xml.append("<ZKTEXT><![CDATA[　]]></ZKTEXT>");
			xml.append("<FRGKZ></FRGKZ>");
			xml.append("<KTEXT><![CDATA["+iMap.get("KTEXT")+"]]></KTEXT>");
			xml.append("<TXT20><![CDATA["+iMap.get("TXT20")+"]]></TXT20>");
			xml.append("<GSTRP></GSTRP>");
			xml.append("<LGORT>"+iMap.get("LGORT")+"</LGORT>");
			xml.append("<LGOBE></LGOBE>");
			xml.append("<PREIS>"+String.valueOf(iMap.get("PREIS"))+"</PREIS>");
			xml.append("<ZIURL1><![CDATA[]]></ZIURL1>");
			xml.append("<ZIURL2><![CDATA[]]></ZIURL2>");
			xml.append("<ZIURL3><![CDATA[]]></ZIURL3>");
			xml.append("<WAERS1> </WAERS1>");
			xml.append("<ANLN1>"+iMap.get("ANLN1")+"</ANLN1>");
			xml.append("<BUDAT> </BUDAT> ");
			xml.append("<BPMNG> </BPMNG>");
			xml.append("<BPRME> </BPRME>");
			xml.append("<LBKUM> </LBKUM>");
			xml.append("<SLBKM> </SLBKM>");
			xml.append("<AVSTK> </AVSTK>");
			xml.append("<ZIURL><![CDATA[]]></ZIURL>");

			xml.append("    </RECORD>");
        }
        
		
		xml.append("  </TABLE>");
		xml.append("</ROOT>");
        
        
		return xml.toString();
	}
	public String SelectDongWhaIFkey(Map<String, String> formData) {
		
		String ifkey = sqlSessionTemplate.selectOne("buyer.mpso.SelectDongWhaIFkey", formData);

		return ifkey;
		
	}
	public String SelectDongWhaTEAMCD(Map<String, String> formData) {
		
		String TEAMCD = sqlSessionTemplate.selectOne("buyer.mpso.SelectDongWhaTEAMCD", formData);
		
		return TEAMCD;
	}
	
	public void updateAppStatusPRDT(Map<String, String> formData) throws Exception {
		
		String pxNo = getOrderNo(formData.get("buyer"), "PX");
		formData.put("REF_NO", pxNo);
		
		sqlSessionTemplate.update("buyer.mpso.updatePRDT_QURA", formData);  
		sqlSessionTemplate.update("buyer.mpso.updatePRHD_QURA", formData);
		
	}
	
	public List<Map<String, String>> getQuratisContentsList(Map<String,String>  formData) {
		
		List<Map<String,String>> objs = sqlSessionTemplate.selectList("buyer.mpso.getQuratisContentsList", formData);
		
		return objs;
	}
	
	public List<Map<String, String>> getHongikContentsList(Map<String,String>  formData) {
		
		List<Map<String,String>> objs = sqlSessionTemplate.selectList("buyer.mpso.getHongikContentsList", formData);
		
		return objs;
	}

	public void errMsg (String type, String err) throws Exception {
		
		throw new Exception(type+err);
		
	}
	
	public String CallLNFAppList(Map<String, String> formData) throws Exception {
		/**
		 * LNF formCode=MRO_APPR
		 * && 
		 * 제이에이치화학공업 formCode=MRO_JHC_APPR
		 * 팝업창 호출
		 * lfon.landf.co.kr/app/approval/integration/mro?buyer=  BUYER&docNo=  DOC_NO&formCode=MRO_APPR
		 *  
		 */
		Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer"), "P11-0000004");		
		String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
		String st_option	= CommonUtil.nvl(slgMap.get("COL03_DATA"));
		
		String formCodeOption = null;
		if ("KRJH-C0002".equals(formData.get("buyer"))) {
			formCodeOption = "MRO_JHC_APPR";
		}else if("KRLAND0003".equals(formData.get("buyer")) && "SWC4327".equals(formData.get("st_user_id"))) {
			formCodeOption = "MRO_APPR_TEST";
		}else if("KRL-F-0001".equals(formData.get("buyer"))) {
			formCodeOption = "MRO_LFP_APPR";
		}else {
			formCodeOption = "MRO_APPR";
		}
		
		
		String result =  st_url + "?buyer=" + formData.get("buyer") + "&docNo=" +formData.get("sPR_No") + "&formCode=" + formCodeOption+"&option=" + st_option;
		
		LOGGER.debug("LNF RESULT URL {} ", result);
		
		return result;
	}
	

	public String updateApItemType(Map<String, String> pMap) {
		
		sqlSessionTemplate.insert("buyer.mpso.updateApItemType", pMap);  
		
		return "OK";
	}
	
	public String CallHLCAppList(Map<String, String> formData) throws Exception {
		/**
		 * HLC 결재 팝업창 호출
		 * DEV(개발)
		   https://gw.hancomgroup.com/ekp/user.do?cmd=goEappWrite&CD_FORM=EL005
		   PROC(운영)
		   https://gw.hancom.com/ekp/user.do?cmd=goEappWrite&CD_FORM=EL005
		 *  
		 */
		
		Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer"), "P11-0000004");
		Map<String, String> pMap = sqlSessionTemplate.selectOne("selectLegacyUserIdById",formData);
		String legacy_user_id = null;
		try {
			legacy_user_id = pMap.get("LEGACY_USER_ID").toString();
		} catch (Exception e) {
			throw new Exception("사번이 존재하지 않습니다.");
		}
		String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
		String result =  st_url + "&NO_EMP=" + legacy_user_id + "&APP_BUYER=" +formData.get("buyer") + 
							"&APP_TYPE=PR&APP_NO="+formData.get("sPR_No");
		
		return result;
	}
	
	public String CallKCTAppList(Map<String, String> formData) throws Exception {
		/**
		 * KCTech 결재 팝업창 호출
		 * DEV(개발)
		   https://kctech.kcmaterials.kr/ekp/service/openapi/IF_MRO_001_goPrWrite?CD_FORM=EL001&NO_EMP=12277&APP_TYPE=PR&APP_BUYER=KRKCTE0003&APP_NO=PR24000001
		   PROC(운영)
		   https://kcg.kctech.co.kr/ekp/service/openapi/IF_MRO_001_goPrWrite?CD_FORM=EL001&NO_EMP=12277&APP_TYPE=PR&APP_BUYER=KRKCTE0003&APP_NO=PR24000001
		 *  
		 */
		
		Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer"), "P11-0000004");
		Map<String, String> pMap = sqlSessionTemplate.selectOne("selectLegacyUserIdById",formData);
		String legacy_user_id = null;
		String user_id = null;
		try {
			legacy_user_id = pMap.get("LEGACY_USER_ID").toString();
			user_id = AES256Cipher.Base64Encode(legacy_user_id);			
		} catch (Exception e) {
			throw new Exception("사번이 존재하지 않습니다.");
		}
		String st_url	= CommonUtil.nvl(slgMap.get("COL02_DATA"));
		String result =  st_url + "&NO_EMP=" + user_id + "&APP_BUYER=" +formData.get("buyer") + 
							"&APP_TYPE=PR&APP_NO="+formData.get("sPR_No");
		
		return result;
	}
	
	private void insertHanComPo(Map<String, String> formData) {
		
		List<Map<String,Object>> hanComPoList = sqlSessionTemplate.selectList("buyer.mpso.SelectHanComPoList", formData);
		List<Map<String,Object>> hanComAppList = sqlSessionTemplate.selectList("buyer.mpso.SelectHanComAppList", formData);
		Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer"), "P11-0000004");
//		Map<String, String> ifData = new HashMap<String, String>();
		String url = CommonUtil.nvl(slgMap.get("COL03_DATA"));
		String id = CommonUtil.nvl(slgMap.get("COL04_DATA"));
		String pw = CommonUtil.nvl(slgMap.get("COL05_DATA"));
		
		Connection conn = null;
		PreparedStatement prestmt1 = null;
		PreparedStatement prestmt2 = null;
		
		for(Map<String,Object> hanComPo : hanComPoList) {
			String buyer = (String) hanComPo.get("BUYER");
			String prNo = (String) hanComPo.get("PR_NO");
			String prSeq = (String) hanComPo.get("PR_SEQ");
			String buyerItemNo = (String) hanComPo.get("BUYER_ITEM_NO");
			String description = (String) hanComPo.get("DESCRIPTION");
			String unitMeasure = (String) hanComPo.get("UNIT_MEASURE");
			BigDecimal itemQty = (BigDecimal) hanComPo.get("ITEM_QTY");
			BigDecimal itemPrice = (BigDecimal) hanComPo.get("ITEM_PRICE");
			BigDecimal itemAmt = (BigDecimal) hanComPo.get("ITEM_AMT");
			String account = (String) hanComPo.get("ACCOUNT");
			String line = (String) hanComPo.get("LINE");
			String cost = (String) hanComPo.get("COST");
			String rdDate = (String) hanComPo.get("RD_DATE");
			String accountClass = (String) hanComPo.get("ACCOUNT_CLASS");
			
//			ifData.put("BUYER", buyer);
//			ifData.put("ACCOUNT", account);
//			ifData.put("LINE", line);
//			ifData.put("COST", cost);
			
//			String ifAccount = sqlSessionTemplate.selectOne("buyer.mpso.SelectHanComPoAccount", ifData);
//			String ifLine = sqlSessionTemplate.selectOne("buyer.mpso.SelectHanComPoLine", ifData);
//			String ifCost = sqlSessionTemplate.selectOne("buyer.mpso.SelectHanComPoCost", ifData);
		
			
			
			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				conn = DriverManager.getConnection(url, id, pw);
				
				StringBuffer sql1	= new StringBuffer(); // INSERT
				sql1.append(" INSERT INTO KEP_PO_HANCOM ");
				sql1.append(" (BUYER, PR_NO, PR_SEQ, BUYER_ITEM_NO, DESCRIPTION  , UNIT_MEASURE , ");
				sql1.append(" ITEM_QTY  , ITEM_PRICE   , ITEM_AMT,  ACCOUNT , LINE   , COST, RD_DATE, ACCOUNT_CLASS)"); 
				sql1.append(" VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");		
				prestmt1 = conn.prepareStatement(sql1.toString());
				int idx	= 1;
				prestmt1.clearParameters();
				prestmt1.setString(idx++, buyer);
				prestmt1.setString(idx++, prNo);
				prestmt1.setString(idx++, prSeq);
				prestmt1.setString(idx++, buyerItemNo);
				prestmt1.setString(idx++, description);
				prestmt1.setString(idx++, unitMeasure);
				prestmt1.setBigDecimal(idx++, itemQty);
				prestmt1.setBigDecimal(idx++, itemPrice);
				prestmt1.setBigDecimal(idx++, itemAmt);
				prestmt1.setString(idx++, account);
				prestmt1.setString(idx++, line);
				prestmt1.setString(idx++, cost);
				prestmt1.setString(idx++, rdDate);
				prestmt1.setString(idx++, accountClass);
				prestmt1.executeUpdate();
				
			} catch (ClassNotFoundException e) {
				LOGGER.error("insertHanComPo ClassNotFoundException ERROR : " + e.getMessage());
			} catch (SQLException e) {
				LOGGER.error("insertHanComPo SQLException ERROR : " + e.getMessage());
			} finally {
				try {
					conn.close();
					prestmt1.close();					
				} catch (SQLException e) {
					LOGGER.error("insertHanComPo SQLException ERROR : " + e.getMessage());
				}
			}
			
		}
		
		for(Map<String,Object> hanComApp : hanComAppList) {
			String appType = (String) hanComApp.get("APP_TYPE");
			String appBuyer = (String) hanComApp.get("APP_BUYER");
			String appNo = (String) hanComApp.get("APP_NO");
			String appDate = (String) hanComApp.get("APP_DATE");
			String userName = (String) hanComApp.get("USER_NM");
			String userDept = (String) hanComApp.get("USER_DEPT");
			String passNote = (String) hanComApp.get("PASS_NOTE");
			String passStatus = (String) hanComApp.get("PASS_STATUS");
			String ifFlag = (String) hanComApp.get("IF_FLAG");
//			java.sql.Date ifDate = (java.sql.Date) hanComApp.get("IF_DATE");
			
			
			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				conn = DriverManager.getConnection(url, id, pw);
				
				StringBuffer sql2	= new StringBuffer(); // INSERT
				sql2.append(" INSERT INTO KEP_APP_HANCOM ");
				sql2.append(" (APP_TYPE , APP_BUYER  , APP_NO , APP_DATE , USER_NM , ");
				sql2.append(" USER_DEPT, PASS_NOTE, PASS_STATUS, IF_FLAG , IF_DATE)");
				sql2.append(" VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE)");		
				prestmt2 = conn.prepareStatement(sql2.toString());
				int idx	= 1;
				prestmt2.clearParameters();
				prestmt2.setString(idx++, appType);
				prestmt2.setString(idx++, appBuyer);
				prestmt2.setString(idx++, appNo);
				prestmt2.setString(idx++, appDate);
				prestmt2.setString(idx++, userName);
				prestmt2.setString(idx++, userDept);
				prestmt2.setString(idx++, passNote);
				prestmt2.setString(idx++, passStatus);
				prestmt2.setString(idx++, ifFlag);
//				prestmt2.setDate(idx++, ifDate);							
				prestmt2.executeUpdate();
				
			} catch (ClassNotFoundException e) {
				LOGGER.error("insertHanComPo ClassNotFoundException ERROR : " + e.getMessage());
			} catch (SQLException e) {
				LOGGER.error("insertHanComPo SQLException ERROR : " + e.getMessage());
			} finally {
				try {
					conn.close();
					prestmt2.close();					
				} catch (SQLException e) {
					LOGGER.error("insertHanComPo SQLException ERROR : " + e.getMessage());
				}
			}
		}
		
		
	}
	
private void insertKCTechPo(Map<String, String> formData) {
		
		List<Map<String,Object>> kctPoList = sqlSessionTemplate.selectList("buyer.mpso.SelectKCTechPoList", formData);
		List<Map<String,Object>> kctAppList = sqlSessionTemplate.selectList("buyer.mpso.SelectKCTechAppList", formData);
		Map<String, String> slgMap	= CommonUtil.getSpecialCheckReturnMap(formData.get("buyer"), "P11-0000004");
		String url = CommonUtil.nvl(slgMap.get("COL03_DATA"));
		String id = CommonUtil.nvl(slgMap.get("COL04_DATA"));
		String pw = CommonUtil.nvl(slgMap.get("COL05_DATA"));
		
		Connection conn = null;
		PreparedStatement prestmt1 = null;
		PreparedStatement prestmt2 = null;
		
		for(Map<String,Object> kctPo : kctPoList) {
			String buyer = (String) kctPo.get("BUYER");
			String prNo = (String) kctPo.get("PR_NO");
			String prSe = (String) kctPo.get("PR_SEQ");
			String itemNo = (String) kctPo.get("ITEM_NO");
			String itemNm = (String) kctPo.get("ITEM_NM");
			String unitMeasure = (String) kctPo.get("UNIT_MEASURE");
			BigDecimal itemQty = (BigDecimal) kctPo.get("ITEM_QTY");
			BigDecimal unitPrice = (BigDecimal) kctPo.get("UNIT_PRICE");
			BigDecimal itemAmt = (BigDecimal) kctPo.get("ITEM_AMT");
			String accountNm = (String) kctPo.get("ACCOUNT_NM");			
			String rdDate = (String) kctPo.get("RD_DATE");						
			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				conn = DriverManager.getConnection(url, id, pw);
				
				StringBuffer sql1	= new StringBuffer(); // INSERT
				sql1.append(" INSERT INTO KEP_PO_KCTECH ");
				sql1.append(" (BUYER, PR_NO, PR_SEQ, ITEM_NO, ITEM_NM, UNIT_MEASURE, ");
				sql1.append(" ITEM_QTY, UNIT_PRICE, ITEM_AMT, ACCOUNT_CD, ACCOUNT_NM, RD_DATE)"); 
				sql1.append(" VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ' ', ?, ?)");		
				prestmt1 = conn.prepareStatement(sql1.toString());
				int idx	= 1;
				prestmt1.clearParameters();
				prestmt1.setString(idx++, buyer);
				prestmt1.setString(idx++, prNo);
				prestmt1.setString(idx++, prSe);
				prestmt1.setString(idx++, itemNo);
				prestmt1.setString(idx++, itemNm);
				prestmt1.setString(idx++, unitMeasure);
				prestmt1.setBigDecimal(idx++, itemQty);
				prestmt1.setBigDecimal(idx++, unitPrice);
				prestmt1.setBigDecimal(idx++, itemAmt);
				prestmt1.setString(idx++, accountNm);				
				prestmt1.setString(idx++, rdDate);				
				prestmt1.executeUpdate();
				
				
			} catch (ClassNotFoundException e) {
				LOGGER.error("insertKCTechPo ClassNotFoundException ERROR : " + e.getMessage());
			} catch (SQLException e) {
				LOGGER.error("insertKCTechPo SQLException ERROR : " + e.getMessage());
			} finally {
				try {
					conn.close();
					prestmt1.close();					
				} catch (SQLException e) {
					LOGGER.error("insertKCTechPo SQLException ERROR : " + e.getMessage());
				}
			}
			
		}
		
		for(Map<String,Object> kctApp : kctAppList) {
			String appBuyer = (String) kctApp.get("APP_BUYER");
			String appNo = (String) kctApp.get("APP_NO");
			String appDate = (String) kctApp.get("APP_DATE");
			String userName = (String) kctApp.get("USER_NM");
			String userDept = (String) kctApp.get("USER_DEPT");
			String passNote = (String) kctApp.get("PASS_NOTE");
			BigDecimal prCnt = (BigDecimal) kctApp.get("PR_CNT");
			BigDecimal prAmt = (BigDecimal) kctApp.get("PR_AMT");
			String stgNm = (String) kctApp.get("STG_NM");
			
			
			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				conn = DriverManager.getConnection(url, id, pw);
				
				StringBuffer sql2	= new StringBuffer(); // INSERT
				sql2.append(" INSERT INTO KEP_APP_KCTECH ");
				sql2.append(" (APP_TYPE, APP_BUYER, APP_NO, APP_DATE, USER_NM, ");
				sql2.append(" USER_DEPT, PASS_NOTE, PASS_STATUS, IF_FLAG, IF_DATE,");
				sql2.append(" PR_CNT, PR_AMT, STG_NM)");
				sql2.append(" VALUES('PR', ?, ?, ?, ?, ?, ?, '0', 'N', SYSDATE, ?, ?, ?)");		
				prestmt2 = conn.prepareStatement(sql2.toString());
				int idx	= 1;
				prestmt2.clearParameters();
				prestmt2.setString(idx++, appBuyer);
				prestmt2.setString(idx++, appNo);
				prestmt2.setString(idx++, appDate);
				prestmt2.setString(idx++, userName);
				prestmt2.setString(idx++, userDept);
				prestmt2.setString(idx++, passNote);
				prestmt2.setBigDecimal(idx++, prCnt);
				prestmt2.setBigDecimal(idx++, prAmt);
				prestmt2.setString(idx++, stgNm);
				prestmt2.executeUpdate();
				
				
			} catch (ClassNotFoundException e) {
				LOGGER.error("insertKCTechApp ClassNotFoundException ERROR : " + e.getMessage());
			} catch (SQLException e) {
				LOGGER.error("insertKCTechApp SQLException ERROR : " + e.getMessage());
			} finally {
				try {
					conn.close();
					prestmt2.close();					
				} catch (SQLException e) {
					LOGGER.error("insertKCTechApp SQLException ERROR : " + e.getMessage());
				}
			}
		}
		
		
	}

}