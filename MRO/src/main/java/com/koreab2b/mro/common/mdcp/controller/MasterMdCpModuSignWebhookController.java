package com.koreab2b.mro.common.mdcp.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.common.mdcp.service.MasterMdCpModuSignWebhookService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCpModuSignWebhookController")
public class MasterMdCpModuSignWebhookController {

	@Value("#{eContractProps['modusign.apiurl']}")
	private String apiUrl;
	
	@Value("#{eContractProps['modusign.authorization']}")
	private String authorization;
	
	@Value("#{eContractProps['modusign.bwtemplateId']}")
	private String bwTemplateId;
	
	@Value("#{eContractProps['modusign.btemplateId']}")
	private String bTemplateId;
	
	@Value("#{eContractProps['modusign.wtemplateId']}")
	private String wTemplateId;
	
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpModuSignWebhookController.class);

	@Autowired
	private MasterMdCpModuSignWebhookService masterMdCpModuSignWebhookService;

	// WEBHOOK 설정
	@NoLoginCheck
	@RequestMapping(value = "/mdcp/saveMasterMdCpModuSignWebhookPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public void saveMasterMdCpModuSignWebhookPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) throws IOException {
		
		//System.out.println("WEBHOOK Start ================ \n");
		
		StringBuffer json = new StringBuffer();
		String line = null;

		String jsonString = "";
		
		//System.out.println("JSONParser Start ================ \n");
		
		JSONParser parser = new JSONParser();
		
		//System.out.println("JSONObject Start ================ \n");
		
		JSONObject coderollsJSONObject = new JSONObject();
		
		//System.out.println("String to JSON Start  ================ \n");

		try {
			BufferedReader reader = req.getReader();
			while((line = reader.readLine()) != null) {
				json.append(line);
				jsonString = json.toString();
			}
			coderollsJSONObject = (JSONObject) parser.parse(jsonString);
		} catch(ParseException e) {
			e.printStackTrace();
		}
		
		JSONObject event = (JSONObject) coderollsJSONObject.get("event");
		//System.out.println("event catch ================ \n");
		
		JSONObject document = (JSONObject) coderollsJSONObject.get("document");
		//System.out.println("document catch ================ \n");
		
		String type = (String) event.get("type");
		String id = (String) document.get("id");
		
		//System.out.println("type ================ " + type + "\n");
		//System.out.println("id =============== " + id + "\n");

		pMap.put("doc_id", id);
		
		if("document_started".equals(type)) {
			pMap.put("doc_status", "A");
		}else if("document_signed".equals(type)) {
			pMap.put("doc_status", "B");
		}else if("document_rejected".equals(type)) {
			pMap.put("doc_status", "C");
		}else if("document_signing_canceled".equals(type)) {
			pMap.put("doc_status", "D");
		}else if("document_request_canceled".equals(type)) {
			pMap.put("doc_status", "E");
		}else if("document_all_signed".equals(type)) {
			pMap.put("doc_status", "F");
		}else {
			pMap.put("doc_status", "");
		}
		
		//System.out.println("update start =============== " + pMap.get("doc_status") + "\n");
		masterMdCpModuSignWebhookService.updateModuSignStatus(pMap);
		//System.out.println("update end =============== " + pMap.get("doc_status") + "\n");
		System.out.println("WEBHOOK ===== " + id + " ===== " + type + " ===== " + pMap.get("doc_status") + " ===== " + "\n");
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mdcp/saveMasterMdCpEcontSend.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCpEcontSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) throws IOException {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String wms_yn = CommonUtil.nvl(formData.get("E_CONTRACT_WMS_YN"), "");
		String agent_name = CommonUtil.nvl(formData.get("COM_NAME_LOC"), "");
		String agent_irs_no = CommonUtil.nvl(formData.get("IRS_NO"), "");
		String agent_irs_no_nodash = agent_irs_no.replace("-", "");
		String agent_address = CommonUtil.nvl(formData.get("ADDRESS_LOC"), "");
		String agent_ceo_name = CommonUtil.nvl(formData.get("CEO_NAME_LOC_TEMP"), "");
		String contract_user_name = CommonUtil.nvl(formData.get("EC_USER_NAME"), "");
		String contract_user_email = CommonUtil.nvl3(formData.get("EC_USER_EMAIL"), "");
		String contract_date = CommonUtil.nvl(formData.get("EC_DATE"), "");
		String contract_to_date = CommonUtil.nvl(formData.get("EC_TO_DATE"), "");
		String kep_address = CommonUtil.nvl(formData.get("KEP_ADDRESS"), "");
		String kep_ceo_name = CommonUtil.nvl(formData.get("KEP_CEO"), "");
		String title = contract_date.replace("/", "") + "_" + agent_irs_no_nodash + "_";
		String subTitle1 = "기본계약서";
		String subTitle2 = "기본+물류계약서";
		
		try {
			JSONObject signingMethod_in = new JSONObject();
			signingMethod_in.put("type", "EMAIL");
			signingMethod_in.put("value", contract_user_email);
			String signingMethod_str = signingMethod_in.toString();
			//logger.info("요청 파라미터 : signingMethod_str ===== {}", signingMethod_str);
			
			JSONParser signingMethod_parser = new JSONParser();
			JSONObject signingMethod = (JSONObject) signingMethod_parser.parse(signingMethod_str);
			//logger.info("요청 파라미터 : signingMethod ===== {}", signingMethod.toString());
			
			JSONObject dCert_in = new JSONObject();
			dCert_in.put("name", agent_name);
			dCert_in.put("bizNumber", agent_irs_no_nodash);
			String dCert_str = dCert_in.toString();
			//logger.info("요청 파라미터 : dCert_str ===== {}", dCert_str);
			
			JSONParser dCert_parser = new JSONParser();
			JSONObject dCert = (JSONObject) dCert_parser.parse(dCert_str);
			//logger.info("요청 파라미터 : dCert ===== {}", dCert.toString());
			
			JSONObject verification = new JSONObject();
			verification.put("dCert", dCert);
			//logger.info("요청 파라미터 : verification ===== {}", verification.toString());
			
			JSONObject participantMappings_in = new JSONObject();
			participantMappings_in.put("excluded", false);
			participantMappings_in.put("signingMethod", signingMethod);
			participantMappings_in.put("signingDuration", 20160);
			participantMappings_in.put("verification", verification);
			participantMappings_in.put("locale", "ko");
			participantMappings_in.put("role", "협력사");
			participantMappings_in.put("name", contract_user_name);
			
			String participantMappings_str = participantMappings_in.toString();
			//logger.info("요청 파라미터 : participantMappings_str ===== {}", participantMappings_str);
			JSONParser participantMappings_parser = new JSONParser();
			JSONObject participantMappings = (JSONObject) participantMappings_parser.parse(participantMappings_str);
			//logger.info("요청 파라미터 : participantMappings ===== {}", participantMappings.toString());
			
			JSONArray participantMappings_arr = new JSONArray();
			participantMappings_arr.add(participantMappings);
			//logger.info("요청 파라미터 : participantMappings_arr ===== {}", participantMappings_arr.toString());
			
			JSONObject requesterInputMappings_label1 = new JSONObject();
			requesterInputMappings_label1.put("dataLabel", "COM_NAME_AGENT1");
			requesterInputMappings_label1.put("value", agent_name);
			
			JSONObject requesterInputMappings_label2 = new JSONObject();
			requesterInputMappings_label2.put("dataLabel", "CON_FROMDATE1");
			requesterInputMappings_label2.put("value", contract_date);
			
			JSONObject requesterInputMappings_label3 = new JSONObject();
			requesterInputMappings_label3.put("dataLabel", "CON_TODATE1");
			requesterInputMappings_label3.put("value", contract_to_date);
			
			JSONObject requesterInputMappings_label4 = new JSONObject();
			requesterInputMappings_label4.put("dataLabel", "CONTRACT_DATE1");
			requesterInputMappings_label4.put("value", contract_date);
			
			JSONObject requesterInputMappings_label5 = new JSONObject();
			requesterInputMappings_label5.put("dataLabel", "ADDRESS_KEP1");
			requesterInputMappings_label5.put("value", kep_address);
			
			JSONObject requesterInputMappings_label6 = new JSONObject();
			requesterInputMappings_label6.put("dataLabel", "CEO_NAME_KEP1");
			requesterInputMappings_label6.put("value", kep_ceo_name);
			
			JSONObject requesterInputMappings_label7 = new JSONObject();
			requesterInputMappings_label7.put("dataLabel", "COM_NAME_AGENT2");
			requesterInputMappings_label7.put("value", agent_name);
			
			JSONObject requesterInputMappings_label8 = new JSONObject();
			requesterInputMappings_label8.put("dataLabel", "IRS_NO_AGENT1");
			requesterInputMappings_label8.put("value", agent_irs_no);
			
			JSONObject requesterInputMappings_label9 = new JSONObject();
			requesterInputMappings_label9.put("dataLabel", "ADDRESS_AGENT1");
			requesterInputMappings_label9.put("value", agent_address);
			
			JSONObject requesterInputMappings_label10 = new JSONObject();
			requesterInputMappings_label10.put("dataLabel", "CEO_NAME_AGENT1");
			requesterInputMappings_label10.put("value", agent_ceo_name);
			
			JSONObject requesterInputMappings_label11 = new JSONObject();
			requesterInputMappings_label11.put("dataLabel", "CONTRACT_DATE2");
			requesterInputMappings_label11.put("value", contract_date);
			
			JSONObject requesterInputMappings_label12 = new JSONObject();
			requesterInputMappings_label12.put("dataLabel", "COM_NAME_AGENT3");
			requesterInputMappings_label12.put("value", agent_name);
			
			JSONObject requesterInputMappings_label13 = new JSONObject();
			requesterInputMappings_label13.put("dataLabel", "IRS_NO_AGENT2");
			requesterInputMappings_label13.put("value", agent_irs_no);
			
			JSONObject requesterInputMappings_label14 = new JSONObject();
			requesterInputMappings_label14.put("dataLabel", "CEO_NAME_AGENT2");
			requesterInputMappings_label14.put("value", agent_ceo_name);
			
			JSONArray requesterInputMappings_arr = new JSONArray();
			requesterInputMappings_arr.add(requesterInputMappings_label1);
			requesterInputMappings_arr.add(requesterInputMappings_label2);
			requesterInputMappings_arr.add(requesterInputMappings_label3);
			requesterInputMappings_arr.add(requesterInputMappings_label4);
			requesterInputMappings_arr.add(requesterInputMappings_label5);
			requesterInputMappings_arr.add(requesterInputMappings_label6);
			requesterInputMappings_arr.add(requesterInputMappings_label7);
			requesterInputMappings_arr.add(requesterInputMappings_label8);
			requesterInputMappings_arr.add(requesterInputMappings_label9);
			requesterInputMappings_arr.add(requesterInputMappings_label10);
			requesterInputMappings_arr.add(requesterInputMappings_label11);
			requesterInputMappings_arr.add(requesterInputMappings_label12);
			requesterInputMappings_arr.add(requesterInputMappings_label13);
			requesterInputMappings_arr.add(requesterInputMappings_label14);
			
			if("Y".equals(wms_yn)){
				JSONObject requesterInputMappings_label15 = new JSONObject();
				requesterInputMappings_label15.put("dataLabel", "COM_NAME_AGENT4");
				requesterInputMappings_label15.put("value", agent_name);
				
				JSONObject requesterInputMappings_label16 = new JSONObject();
				requesterInputMappings_label16.put("dataLabel", "CON_FROMDATE2");
				requesterInputMappings_label16.put("value", contract_date);
				
				JSONObject requesterInputMappings_label17 = new JSONObject();
				requesterInputMappings_label17.put("dataLabel", "CON_TODATE2");
				requesterInputMappings_label17.put("value", contract_to_date);
				
				JSONObject requesterInputMappings_label18 = new JSONObject();
				requesterInputMappings_label18.put("dataLabel", "CONTRACT_DATE3");
				requesterInputMappings_label18.put("value", contract_date);
				
				JSONObject requesterInputMappings_label19 = new JSONObject();
				requesterInputMappings_label19.put("dataLabel", "COM_NAME_AGENT5");
				requesterInputMappings_label19.put("value", agent_name);
	
				JSONObject requesterInputMappings_label20 = new JSONObject();
				requesterInputMappings_label20.put("dataLabel", "IRS_NO_AGENT3");
				requesterInputMappings_label20.put("value", agent_irs_no);
				
				JSONObject requesterInputMappings_label21 = new JSONObject();
				requesterInputMappings_label21.put("dataLabel", "ADDRESS_AGENT2");
				requesterInputMappings_label21.put("value", agent_address);
				
				JSONObject requesterInputMappings_label22 = new JSONObject();
				requesterInputMappings_label22.put("dataLabel", "CEO_NAME_AGENT3");
				requesterInputMappings_label22.put("value", agent_ceo_name);
				
				JSONObject requesterInputMappings_label23 = new JSONObject();
				requesterInputMappings_label23.put("dataLabel", "ADDRESS_KEP2");
				requesterInputMappings_label23.put("value", kep_address);
				
				JSONObject requesterInputMappings_label24 = new JSONObject();
				requesterInputMappings_label24.put("dataLabel", "CEO_NAME_KEP2");
				requesterInputMappings_label24.put("value", kep_ceo_name);
				
				requesterInputMappings_arr.add(requesterInputMappings_label15);
				requesterInputMappings_arr.add(requesterInputMappings_label16);
				requesterInputMappings_arr.add(requesterInputMappings_label17);
				requesterInputMappings_arr.add(requesterInputMappings_label18);
				requesterInputMappings_arr.add(requesterInputMappings_label19);
				requesterInputMappings_arr.add(requesterInputMappings_label20);
				requesterInputMappings_arr.add(requesterInputMappings_label21);
				requesterInputMappings_arr.add(requesterInputMappings_label22);
				requesterInputMappings_arr.add(requesterInputMappings_label23);
				requesterInputMappings_arr.add(requesterInputMappings_label24);
			}
			
			//logger.info("요청 파라미터 : requesterInputMappings_arr ===== {}", requesterInputMappings_arr.toString());
			
			JSONObject document_in = new JSONObject();
			document_in.put("participantMappings", participantMappings_arr);
			document_in.put("requesterInputMappings", requesterInputMappings_arr);
			
			if("Y".equals(wms_yn)){
				document_in.put("title", title + subTitle2);	
			}else{
				document_in.put("title", title + subTitle1);
			}
			
			//logger.info("요청 파라미터 : document_in ===== {}", document_in.toString());
			
			String document_str = document_in.toString();
			JSONParser document_parser = new JSONParser();
			JSONObject document = (JSONObject) document_parser.parse(document_str);
			//logger.info("요청 파라미터 : document ===== {}", document.toString());
			
			JSONObject json = new JSONObject();
			json.put("document", document);
			if("Y".equals(wms_yn)){
				json.put("templateId", bwTemplateId);
			}else{
				json.put("templateId", bTemplateId);
			}
			
			//logger.info("요청 파라미터 : json ===== {}", json.toString());
			
			String str = json.toString();
			//logger.info("요청 파라미터 : str ===== {}", str);
			
			String response = null;
			//System.out.println("--------------------------------- JSON TO STRING END -----------------------------\n");
			
			try {
				String urlPath = apiUrl + "request-with-template";
				
				//System.out.println("--------------------------------- HttpsURLConnection START -----------------------------\n");
				URL url = new URL(urlPath);
				HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
				
				//System.out.println("--------------------------------- setRequestProperty START -----------------------------\n");
				con.setRequestMethod("POST");
				//System.out.println("--------------------------------- setRequestMethod POST END -----------------------------\n");
				con.setRequestProperty("Accept", "application/json");
				//System.out.println("--------------------------------- setRequestProperty Accept END -----------------------------\n");
				con.setRequestProperty("Content-Type", "application/json");
				//System.out.println("--------------------------------- setRequestProperty Content-Type END -----------------------------\n");
				con.setRequestProperty("Authorization", authorization);
				//System.out.println("--------------------------------- setRequestProperty Authorization END -----------------------------\n");
				con.setDoOutput(true);
				//System.out.println("--------------------------------- setRequestProperty END -----------------------------\n");
				
				OutputStream os = con.getOutputStream();
				//System.out.println("--------------------------------- OutputStream END -----------------------------\n");
				os.write(json.toString().getBytes("utf-8"));
				//System.out.println("--------------------------------- write END -----------------------------\n");
				os.flush();
				//System.out.println("--------------------------------- flush END -----------------------------\n");
				os.close();
				//System.out.println("--------------------------------- close END -----------------------------\n");
				
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				//System.out.println("--------------------------------- BufferedReader END -----------------------------\n");
				
				StringBuffer sb = new StringBuffer();
				String inputline;
				
				//System.out.println("--------------------------------- While START -----------------------------\n");
				while((inputline = br.readLine()) != null) {
					sb.append(inputline);
				}
				//System.out.println("--------------------------------- While END -----------------------------\n");
				br.close();
				//System.out.println("--------------------------------- BufferedReader close END -----------------------------\n");
				
				//System.out.println("--------------------------------- response START -----------------------------\n");
				response = sb.toString();
				System.out.println(response);
				//System.out.println("--------------------------------- response END -----------------------------\n");

				JSONParser jsonParser = new JSONParser();
				//System.out.println("--------------------------------- JSONParser START -----------------------------\n");
				JSONObject jsonResponse = (JSONObject)jsonParser.parse(response.toString());
				//System.out.println("--------------------------------- JSONParser END -----------------------------\n");
				
				//결과값 수신
	    		int rc = con.getResponseCode();
	    		
	    		if(rc==201){
					//logger.info("ResultCode 201=============================== {}", (String)jsonResponse.get("ResultCode"));
					//logger.info("id=============================== {}", (String)jsonResponse.get("id"));
					//logger.info("status=============================== {}", (String)jsonResponse.get("status"));
				}else {
					//logger.info("rc else=============================== {}", rc);
					//logger.info("ResultCode else=============================== {}", (String)jsonResponse.get("ResultCode"));
					//logger.info("jsonResponse else=============================== {}", jsonResponse);
				}
	    		
	    		formData.put("doc_id", (String)jsonResponse.get("id"));
	    		masterMdCpModuSignWebhookService.updateModuSignDocId(formData);
	    		
	    		String rtnMsg = "전송완료";
	    		
	    		Map<String, Object> mp = new HashMap<String, Object>();
				mp.put("Code",1);
				_response.put("Result",mp);
				_response.put("Message", rtnMsg);
	    		
			}catch (IOException e) {
				e.printStackTrace();
			}
		} catch(Exception e) {
			throw new RuntimeException("전송에 실패하였습니다.");
			//throw new RuntimeException(e);
		}
		return _response;
	}
	
	@RequestMapping(value = "/mdcp/getMasterMdCpEcontStatus.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getMasterMdCpEcontStatus(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) throws IOException {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		//logger.info("요청 파라미터 : gridData ===== {}", gridData);
		//logger.info("요청 파라미터 : formData ===== {}", formData);
		
		try {
			String doc_id = formData.get("EC_DOC_ID"); // SUPLINFO2.EC_DOC_ID
			String response = null;
			
			try {
				String urlPath = apiUrl + doc_id;
				
				URL url = new URL(urlPath);
				HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
				
				con.setRequestMethod("GET");
				con.setRequestProperty("Accept", "application/json");
				con.setRequestProperty("Authorization", authorization);
				
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				StringBuffer sb = new StringBuffer();
				String inputline;
				
				while((inputline = br.readLine()) != null) {
					sb.append(inputline);
				}
				br.close();
				
				response = sb.toString();
				
				//System.out.println(response);
				
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonResponse = (JSONObject)jsonParser.parse(response);
				JSONObject abort = (JSONObject) jsonResponse.get("abort");
				JSONObject file = (JSONObject) jsonResponse.get("file");
				//결과값 수신
	    		int rc = con.getResponseCode();
	    		
	    		//logger.info("id=============================== {}", (String)jsonResponse.get("id"));
				//logger.info("status=============================== {}", (String)jsonResponse.get("status"));
	    		if(abort != null) { // 거절 아닌 경우 abort 값 null 로 넘어옴
	    			//logger.info("abort type=============================== {}", (String)abort.get("type"));
					//logger.info("abort message=============================== {}", (String)abort.get("message"));
	    		}
				//logger.info("downloadUrl=============================== {}", (String)file.get("downloadUrl"));
				
	    		if(rc==200){
					//logger.info("id=============================== {}", (String)jsonResponse.get("id"));
					//logger.info("status=============================== {}", (String)jsonResponse.get("status"));
				}else {
					//logger.info("rc else=============================== {}", rc);
					//logger.info("ResultCode else=============================== {}", (String)jsonResponse.get("ResultCode"));
					//logger.info("jsonResponse else=============================== {}", jsonResponse);
				}
	    		
	    		String rtnMsg = "조회완료";
	    		
	    		formData.put("doc_id", doc_id);
	    		
	    		if("ON_GOING".equals((String)jsonResponse.get("status"))) {
	    			formData.put("doc_status", "A");
	    		}else if("ABORTED".equals((String)jsonResponse.get("status"))) {
	    			if("REJECTION".equals((String)abort.get("type"))) {
	    				formData.put("doc_status", "C");	
	    			}else if("REQUEST_CANCELLATION".equals((String)abort.get("type"))) {
	    				formData.put("doc_status", "E");	
	    			}
	    		}else if("COMPLETED".equals((String)jsonResponse.get("status"))) {
	    			formData.put("doc_status", "F");
	    		}else {
	    			formData.put("doc_status", "");
	    		}
	    		masterMdCpModuSignWebhookService.updateModuSignStatus(formData);
	    		
	    		Map<String, Object> mp = new HashMap<String, Object>();
				mp.put("Code",1);
				_response.put("Result",mp);
				_response.put("Message", rtnMsg);
	    		
			}catch (IOException e) {
				e.printStackTrace();
			}
			
		} catch(Exception e) {
			throw new RuntimeException("조회에 실패하였습니다.");
			//throw new RuntimeException(e);
		}
		return _response;
	}
	
	// 저장
	@RequestMapping(value = "/mdcp/getMasterMdCpEcontStatusWithId.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getMasterMdCpEcontStatusWithId(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) throws IOException {
		//logger.info("요청 파라미터 : _list ===== {}", pMap);
		
		String doc_id = pMap.get("st_doc_id"); // SUPLINFO2.EC_DOC_ID
		String response = null;
		String reason = "";
		
		try {
			
			String urlPath = apiUrl + doc_id;
			//System.out.println("--------------------------------- HttpsURLConnection START -----------------------------\n");
			
			URL url = new URL(urlPath);
			HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
			//System.out.println("--------------------------------- HttpsURLConnection END -----------------------------\n");
			
			con.setRequestMethod("GET");
			//System.out.println("--------------------------------- setRequestMethod GET -----------------------------\n");
			con.setRequestProperty("Accept", "application/json");
			//System.out.println("--------------------------------- setRequestProperty Accept -----------------------------\n");
			con.setRequestProperty("Authorization", authorization);
			//System.out.println("--------------------------------- setRequestProperty Authorization -----------------------------\n");
			
			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
			//System.out.println("--------------------------------- BufferedReader START -----------------------------\n");
			StringBuffer sb = new StringBuffer();
			String inputline;
			
			//System.out.println("--------------------------------- while START -----------------------------\n");
			while((inputline = br.readLine()) != null) {
				sb.append(inputline);
			}
			//System.out.println("--------------------------------- while END -----------------------------\n");
			br.close();
			//System.out.println("--------------------------------- close END -----------------------------\n");
			
			response = sb.toString();
			
			//System.out.println(response);
			//System.out.println("--------------------------------- jsonParser START -----------------------------\n");
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonResponse = (JSONObject)jsonParser.parse(response);
			JSONObject abort = (JSONObject) jsonResponse.get("abort");
			//System.out.println("--------------------------------- jsonParser END -----------------------------\n");
			//결과값 수신
    		int rc = con.getResponseCode();
    		
    		//logger.info("id=============================== {}", (String)jsonResponse.get("id"));
			//logger.info("status=============================== {}", (String)jsonResponse.get("status"));
    		if(abort != null) { // 거절 아닌 경우 abort 값 null 로 넘어옴
    			//logger.info("abort type=============================== {}", (String)abort.get("type"));
    			//logger.info("abort message=============================== {}", (String)abort.get("message"));
				reason = (String)abort.get("message"); 
    		}
			
    		if(rc==200){
				//logger.info("id=============================== {}", (String)jsonResponse.get("id"));
				//logger.info("status=============================== {}", (String)jsonResponse.get("status"));
			}else {
				//logger.info("rc else=============================== {}", rc);
				//logger.info("ResultCode else=============================== {}", (String)jsonResponse.get("ResultCode"));
				//logger.info("jsonResponse else=============================== {}", jsonResponse);
			}
		
		} catch(Exception e) {
			throw new RuntimeException("전송에 실패하였습니다.");
			//throw new RuntimeException(e);
		}
		
		Map<String, Object> _response = new HashMap<String, Object>();
		//String flag = MasterMdCpModuSignWebhookService.updateModuSignStatus(_pMap, _list);
		
		_response.put("reason", reason);
		return  _response;
	}
	
	// 임베드 URL
	@RequestMapping(value = "/mdcp/getMasterMdCpEcontEmbeddedUrl.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getMasterMdCpEcontEmbeddedUrl(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) throws IOException {
		//logger.info("요청 파라미터 : _list ===== {}", pMap);
		
		String doc_id = pMap.get("st_doc_id"); // SUPLINFO2.EC_DOC_ID
		String response = null;
		String downloadUrl = "";
		
		try {
			
			String urlPath = apiUrl + doc_id + "/embedded-view";
			//System.out.println("--------------------------------- HttpsURLConnection START -----------------------------\n");
			
			URL url = new URL(urlPath);
			HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
			//System.out.println("--------------------------------- HttpsURLConnection END -----------------------------\n");
			
			con.setRequestMethod("GET");
			//System.out.println("--------------------------------- setRequestMethod GET -----------------------------\n");
			con.setRequestProperty("Accept", "application/json");
			//System.out.println("--------------------------------- setRequestProperty Accept -----------------------------\n");
			con.setRequestProperty("Authorization", authorization);
			//System.out.println("--------------------------------- setRequestProperty Authorization -----------------------------\n");
			
			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
			//System.out.println("--------------------------------- BufferedReader START -----------------------------\n");
			StringBuffer sb = new StringBuffer();
			String inputline;
			
			//System.out.println("--------------------------------- while START -----------------------------\n");
			while((inputline = br.readLine()) != null) {
				sb.append(inputline);
			}
			//System.out.println("--------------------------------- while END -----------------------------\n");
			br.close();
			//System.out.println("--------------------------------- close END -----------------------------\n");
			
			response = sb.toString();
			
			//System.out.println(response);
			//System.out.println("--------------------------------- jsonParser START -----------------------------\n");
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonResponse = (JSONObject)jsonParser.parse(response);
			//System.out.println("--------------------------------- jsonParser END -----------------------------\n");

			downloadUrl = (String)jsonResponse.get("embeddedUrl");
    		
			//logger.info("downloadUrl=============================== {}", (String)jsonResponse.get("embeddedUrl"));
		} catch(Exception e) {
			throw new RuntimeException("전송에 실패하였습니다.");
			//throw new RuntimeException(e);
		}
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		_response.put("url", downloadUrl);
		return  _response;
	}
}
