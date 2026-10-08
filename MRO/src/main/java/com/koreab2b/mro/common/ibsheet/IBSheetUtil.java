package com.koreab2b.mro.common.ibsheet;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import MarkAny.MaSaferJava.Madn;

import com.ibleaders.ibsheet7.ibsheet.excel.DirectDown2Excel;
import com.ibleaders.ibsheet7.util.Common;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

public class IBSheetUtil {

	private static final Logger logger = LoggerFactory.getLogger(IBSheetUtil.class);

	private String TREECOL = "";

	@SuppressWarnings("unchecked")
	public String getJson(HttpServletRequest req) throws Exception {

		JSONObject ibsheetjson = new JSONObject();
		Enumeration<String> en = req.getAttributeNames();
		while (en.hasMoreElements()) {
			String objname = en.nextElement();
			// 시트에 보여질 데이터
			if (req.getAttribute(objname) instanceof List) {
				JSONArray sheetdata = new JSONArray();
				sheetdata.add((List<String>) req.getAttribute(objname));
				ibsheetjson.put(objname, sheetdata);
			} else if (req.getAttribute(objname) instanceof Map) {
				ibsheetjson.put(objname, new JSONObject((Map<String, String>) req.getAttribute(objname)));
			} else {
				ibsheetjson.put(objname, req.getAttribute(objname) + "");
			}
		}
		return ibsheetjson.toString();
	}

	@SuppressWarnings("unchecked")
	public void getXml(HttpServletRequest req, HttpServletResponse res) {
		
		
		StringBuffer sb = new StringBuffer();
		String message = "";
		StringBuffer etcData = new StringBuffer();
		PrintWriter out = null;
		
		if (req.getParameter("s_SAVENAME") == null) {
			try {
				String encoding = res.getCharacterEncoding();
				String contentType = res.getContentType();
				if(contentType == null) {
					contentType = "text/html";
				}
				res.reset();
				res.setCharacterEncoding(encoding);
				res.setContentType(contentType);
				out = res.getWriter();
				message = (String) req.getAttribute("SHEET_MSG");
				out.println("<?xml version='1.0'?>");
				out.println("<SHEET>");
				out.println(setMessage(message));
				out.println("<RESULT Code='1'>");
				out.println("</RESULT>");
				out.println("</SHEET>");
			} catch (IOException ex) {
				logger.error("save _ XML 변환 중 에러 발생!", ex);
				throw new RuntimeException(ex);
			}
		} else {

			try {

				String encoding = res.getCharacterEncoding();
				String contentType = res.getContentType();
				if(contentType == null) {
					contentType = "text/html";
				}
				res.reset();
				res.setCharacterEncoding(encoding);
				res.setContentType(contentType);
				
				
				out = res.getWriter();
				List<String> paramList = new ArrayList<String>();

				// logger.debug("S_SAVENAME="+reqCtx.get("S_SAVENAME"));

				String[] savename = req.getParameter("s_SAVENAME").split("@@");

				TREECOL = req.getParameter("s_TREECOL");
				int cnt = 0;

				Enumeration<String> en = req.getAttributeNames();
				List<String> orderKeyVector = new ArrayList<String>();
				while (en.hasMoreElements()) {
					String objname = en.nextElement();
					if (objname.indexOf("SHEETDATA") > -1) {
						orderKeyVector.add(objname);
					} else {
						paramList.add(objname);
					}
				}
				// 여러개의 Sheet가 존재할경우 순서가 없으므로
				// HashMap 의 key를 기준으로 알파벳 순으로 asc sorting을 한다.

				// 순서재정렬
				Collections.sort(orderKeyVector);
				Iterator<String> it = orderKeyVector.iterator();

				etcData.append("<ETC-DATA>\n");
				for (int p = 0; p < paramList.size(); p++) {
					if ("SHEET_MSG".equals(paramList.get(p))) {
						message = (String) req.getAttribute(paramList.get(p));
					} else {
						etcData.append("<ETC key='" + paramList.get(p) + "'><![CDATA[" + req.getAttribute(paramList.get(p)) + "]]></ETC>\n");
					}
				}
				etcData.append("</ETC-DATA>\n");

				int i = 0;
				if (orderKeyVector.size() > 0) {
					while (it.hasNext()) {

						i++;
						if (i > 0) {
							sb.append("|!|");
						}
						out.println("<?xml version='1.0'?><SHEET>");
						if (i == 0) {
							out.println(etcData.toString());
							out.println(setMessage(message));
						}

						// 시트의 개수만큼 루프를 돌자.
						// while(it.hasNext()){

						String key = it.next();
						List<?> ls = (List<?>) req.getAttribute(key);
						// RDS형이 넘어온 경우 XML테그로 바꿔 ArrayList에 담아두자.
						getSheetXml(req, ls, savename[cnt++], out);

						out.println("</SHEET>");

					}
				} else {
					out.println("<?xml version='1.0'?>");
					out.println("<SHEET>");
					out.println(etcData.toString());
					out.println(setMessage(message));
					out.println("<RESULT Code='1'>");
					out.println("</RESULT>");
					out.println("</SHEET>");
				}

			} catch (Exception ex) {
				logger.error("search _ XML 변환 중 에러 발생!", ex);
				
				try {
					if (out == null) {
						out = res.getWriter();
					}
					out.println("<?xml version='1.0'?>");
					out.println("<SHEET>");
					out.println(etcData.toString());
					out.println("" + setMessage(message) + "");
					out.println("<RESULT Code='-1'>");
					out.println("</RESULT>");
					out.println("</SHEET>");
				} catch (Exception E) {
					logger.error("save2 _ XML 변환 중 에러 발생!", E);
					throw new RuntimeException(E);
				}

			}
		}

	}

	protected String setMessage(String msg) {
		return "<MESSAGE><![CDATA[" + msg + "]]></MESSAGE>";
	}

	/*
	 * name : getSheetXml param1 : HttpServletRequest 화면으로부터 받은 request 객체
	 * param2 : List 디비로 조회된 결과 param3 : 각시트에 따른 savename desc : List에서 시트에 필요한
	 * 조회 Xml을 생성한다.
	 */
	@SuppressWarnings("unchecked")
	protected String getSheetXml(HttpServletRequest req, List<?> ls, String S_SAVENAME, PrintWriter out) {
		StringBuffer sb = new StringBuffer();
		try {

			String[] saveNames = S_SAVENAME.split("\\|");

			String totRows = (String) req.getAttribute("TOTROWS");
			// sheet tag!!!!!

			// 스크롤을 이용한 조회를 위하여 "TOTROWS"attribute가 존재하면 TOTAL테그를 삽입한다.
			if (totRows == null) {
				out.println("\n<DATA COLSEPARATOR='‡' COLORDER='"+S_SAVENAME+"'>");
			} else {
				out.println("\n<DATA TOTAL='" + totRows + "' COLSEPARATOR='‡' COLORDER='"+S_SAVENAME+"'>");
			}

			if (ls.size() != 0) {
				if (ls.get(0) instanceof java.util.HashMap) {
					makeDataXmlFromHashMap((List<HashMap<String, String>>) ls, saveNames, out);
				} else if (ls.get(0) instanceof java.util.Map) {
					sb.append(makeDataXmlFromMap((List<Map<String,String>>)ls, saveNames));
				} else {
					sb.append(makeDataXmlFromGetSetObject((List<Object>)ls, saveNames));
				}
			}
			out.println("</DATA>");
		} catch (Exception e) {
			logger.error("XML 변환 중 에러 발생!", e);
			throw new RuntimeException(e);
		}
		return sb.toString();
	}

	public String makeDataXmlFromGetSetObject(List<Object> ls, String[] saveNames) {
		StringBuffer sb = new StringBuffer();
		int colLen = saveNames.length;
		String tsn = "";
		boolean isTree = TREECOL != null ? true : false;
		// /body
		for (int i = 0; i < ls.size(); i++) {
			String[] parameters = new String[0];
			Object instance = ls.get(i);
			sb.append("<TR " + (isTree ? ("LEVEL='" + "get" + TREECOL.substring(0, 1).toUpperCase() + TREECOL.substring(1) + "'") : "")
					+ "><![CDATA[");
			for (int n = 0; n < colLen; n++) {
				try {
					tsn = "get" + saveNames[n].substring(0, 1).toUpperCase() + saveNames[n].substring(1);
					Object data = ClassBroker.invoke(instance, tsn, parameters);
					sb.append(nvl(data)).append("‡");
				} catch (Throwable ex) {
					sb.append("‡");
				}
			}
			sb.append("]]></TR>");
		}

		return sb.toString();
	}

	public String makeDataXmlFromHashMap(List<HashMap<String, String>> ls, String[] saveNames, PrintWriter out) {

		int colLen = saveNames.length;
		boolean isTree = TREECOL != null ? true : false;
		// /body
		for (int i = 0; i < ls.size(); i++) {
			// String[] parameters = new String[0];
			HashMap<String, String> hm = ls.get(i);
			// System.out.println(hm);
			out.print("<TR " + (isTree ? ("LEVEL='" + hm.get(TREECOL) + "'") : "") + "><![CDATA[");
			for (int n = 0; n < colLen; n++) {
				try {
					out.print(nvl(hm.get(saveNames[n])) + "‡");
				} catch (Throwable ex) {
					out.print("‡");
				}
			}
			out.print("]]></TR>");
			if (i % 500 == 0) {
				out.flush();
			}
		}
		return "";
	}

	public String makeDataXmlFromMap(List<Map<String,String>> ls, String[] saveNames) {

		StringBuffer sb = new StringBuffer();
		int colLen = saveNames.length;
		boolean isTree = TREECOL != null ? true : false;
		// /body
		for (int i = 0; i < ls.size(); i++) {
			Map<String,String> hm = ls.get(i);
			sb.append("<TR " + (isTree ? ("LEVEL='" + hm.get(TREECOL) + "'") : "") + "><![CDATA[");
			for (int n = 0; n < colLen; n++) {
				try {
					sb.append(nvl(hm.get(saveNames[n]))).append("‡");
				} catch (Throwable ex) {
					sb.append("‡");
				}
			}
			sb.append("]]></TR>");

		}
		return sb.toString();
	}

	public static Object getParam(Map<String,Object> commandMap, Object obj) {
		return getParamArr(commandMap, obj, 0);
	}

	@SuppressWarnings("unchecked")
	public static Object getParam(HttpServletRequest req, Object obj) {
		Map<String,Object> mp = new HashMap<String,Object>();

		String key = "";
		Enumeration<String> en = req.getParameterNames();
		while (en.hasMoreElements()) {
			key = en.nextElement();
			try {
				if (req.getParameterValues(key).length > 1) {
					mp.put(key, req.getParameterValues(key));
				} else {
					mp.put(key, req.getParameter(key));
				}

			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return getParamArr(mp, obj, 0);
	}

	@SuppressWarnings("unchecked")
	public static Object getParam4Multipart(MultipartHttpServletRequest req, Object obj) {
		Map<String,Object> mp = new HashMap<String,Object>();

		String key = "";
		Enumeration<String> en = req.getParameterNames();
		while (en.hasMoreElements()) {
			key = en.nextElement();
			try {
				if (req.getParameterValues(key).length > 1) {
					mp.put(key, req.getParameterValues(key));
				} else {
					mp.put(key, URLDecoder.decode(req.getParameter(key), "utf-8"));
				}

			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		return getParamArr(mp, obj, 0);
	}

	@SuppressWarnings("unchecked")
	public static Object getParam(HttpServletRequest req, Object obj, int k) {
		Map<String,Object> mp = new HashMap<String,Object>();

		String key = "";
		Enumeration<String> en = req.getParameterNames();
		while (en.hasMoreElements()) {
			key = en.nextElement();
			try {
				if (req.getParameterValues(key).length > 1) {
					mp.put(key, req.getParameterValues(key));
				} else {
					mp.put(key, req.getParameter(key));
				}

			} catch (Exception ex) {
				logger.error("파라미터 수집 중 에러 발생!", ex);
				throw new RuntimeException(ex);
			}
		}
		return getParamArr(mp, obj, k);
	}

	/*
	 * getParam desc: commandMap으로 부터 넘어온 데이터 중 SAVENAME에 있는 내용을 뽑아 vo형태의 객체에
	 * 내용을 채워 보내줌.
	 * 
	 * paramlist 1. 화면으로부터 받은 commandMap 객체 2. 돌려받고자 하는 class유형 3. 여러건의 데이터가
	 * 저장되는 경우 몇번째 데이터를 vo형태로 만들것인지 index 4. 여러개의 시트가 동시에 저장되는 경우, 몇번째 시트 객체에 대한
	 * 내용을 받을 것인지 index
	 */
	public Object nvl(Object obj) {
		if (obj == null) {
			return "";
		} else {
			return obj;
		}
	}

	public static List<Object> getParamArr(Map<String,Object> commandMap, Object rtnObj, int sheetIdx) {
		// IBSheet로 부터 넘어온 savename
		List<Object> rtnArr = new ArrayList<Object>();
		String savename = (String) commandMap.get("s_SAVENAME");
		String[] savenameArr = savename.split("@@");
		savenameArr = (savenameArr[sheetIdx]).split("\\|");
		String method = "";
		Object indexObj = commandMap.get(savenameArr[0]);

		int cnt = 0;
		try {
			if (indexObj instanceof String) {
				// 단건 (시트로 부터 넘어온 데이터가 한건인 경우)
				cnt = 1;
				if (rtnObj instanceof java.util.HashMap) {
					for (int r = 0; r < cnt; r++) {

						String item1 = (String) (commandMap.get(savenameArr[0]));
						if (item1.indexOf("‡") > -1) {

							int sheetdatacnt = item1.length() - item1.replaceAll("\\‡", "").length() + 1;
							String data[][] = new String[savenameArr.length][sheetdatacnt];

							for (int sn = 0; sn < savenameArr.length; sn++) {
								String item = (String) (commandMap.get(savenameArr[sn]));
								//System.out.println(savenameArr[sn]);
								String[] itemArr = item.split("‡", sheetdatacnt);
								for (int row = 0; row < sheetdatacnt; row++) {
									data[sn][row] = itemArr[row];
								}
							}

							for (int row = 0; row < data[0].length; row++) {
								Map<String,String> instance = new HashMap<String,String>();
								for (int sn = 0; sn < data.length; sn++) {
									instance.put(savenameArr[sn], data[sn][row]);
								}
								rtnArr.add(instance);
							}

						} else {
							Map<String,String> instance = new HashMap<String,String>();
							for (int c = 0; c < savenameArr.length; c++) {

								try {
									instance.put(savenameArr[c], ((String) (commandMap.get(savenameArr[c]))));
								} catch (Throwable ex) {

								}
							}
							rtnArr.add(instance);
						}

					}
				} else {
					for (int r = 0; r < cnt; r++) {

						Object instance = ClassBroker.getInstance(rtnObj.getClass().getName());
						Object[] parameter = null;
						// 컬럼의 개수
						for (int c = 0; c < savenameArr.length; c++) {

							try {
								method = "set" + savenameArr[c].substring(0, 1).toUpperCase() + savenameArr[c].substring(1);
								parameter = new Object[1];
								parameter[0] = ((String) (commandMap.get(savenameArr[c])));
								// setter 메서드 호출
								ClassBroker.invoke(instance, method, parameter);
							} catch (Exception ex) {
//								logger.error("파라미터 배열 수집 중 에러 발생!", ex);
//								throw new RuntimeException(ex);
							}
						}
						rtnArr.add(instance);
					}
				}
			} else {
				// 다건 (시트로부터 넘어온 데이터가 여러건인 경우)
				cnt = ((String[]) indexObj).length;
				if (rtnObj instanceof java.util.HashMap) {
					for (int r = 0; r < cnt; r++) {
						Map<String,String> instance = new HashMap<String,String>();
						for (int c = 0; c < savenameArr.length; c++) {
							try {
								instance.put(savenameArr[c], ((String[]) (commandMap.get(savenameArr[c])))[r]);
							} catch (Exception ex) {
								logger.error("파라미터 배열 수집 중 에러 발생!", ex);
								throw new RuntimeException(ex);
							}
						}
						rtnArr.add(instance);
					}
				} else {
					for (int r = 0; r < cnt; r++) {

						Object instance = ClassBroker.getInstance(rtnObj.getClass().getName());
						Object[] parameter = null;
						// 컬럼의 개수
						for (int c = 0; c < savenameArr.length; c++) {
							try {
								method = "set" + savenameArr[c].substring(0, 1).toUpperCase() + savenameArr[c].substring(1);
								parameter = new Object[1];
								parameter[0] = ((String[]) (commandMap.get(savenameArr[c])))[r];
								// setter 메서드 호출
								ClassBroker.invoke(instance, method, parameter);
							} catch (Exception ex) {
								logger.error("파라미터 배열 수집 중 에러 발생!", ex);
								throw new RuntimeException(ex);
							}
						}
						rtnArr.add(instance);

					}
				}
			}

			// }catch(Exception ex){
		} catch (Exception ex) {
			logger.error("파라미터 배열 수집 중 에러 발생!", ex);
			throw new RuntimeException(ex);
		}
		return rtnArr;
	}

	public static void mapPrint(Map<String,String> mp) {

		String key = "";
		Iterator<String> it = mp.keySet().iterator();
		while (it.hasNext()) {
			key = it.next();
			logger.debug("Map Print>>>>>   key: {}  value:", mp.get(key));
		}
	}

	public static void enumPrint(Enumeration<String> en) {
		String key = "";
		while (en.hasMoreElements()) {
			key = en.nextElement();
			logger.debug("Enum Print>>>>>   {}", key);
		}
	}

	// Controller > Service 데이터 전달시 세션 데이터를 셋팅하는 메소드 - 2012-10-19 by SSM
	public static Map<String,String> getCommonSesFrmData(HttpServletRequest req, Map<String, String> formdata) {
		try {
			 SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			 
			 if(_sessionInfo != null){
				 formdata.put("USER_ID", _sessionInfo.getUserId());
				 formdata.put("USER_NAME_LOC",  _sessionInfo.getUserNameLoc());
				 formdata.put("EMAIL",  _sessionInfo.getEmail());
				 formdata.put("COM_TYPE",      _sessionInfo.getComType());
				 formdata.put("USER_TYPE",     _sessionInfo.getUserType());
				 formdata.put("COM_CODE",      _sessionInfo.getComCode());
				 formdata.put("BUSINESS_COND", _sessionInfo.getBusinessCond()); 
				 formdata.put("MPHONE", _sessionInfo.getmPhone());
				 formdata.put("TEL",    _sessionInfo.getTel());
				 formdata.put("FAX",    _sessionInfo.getFax());
			 }else{
				 formdata.put("USER_ID", "NEW_AGENT");
				 formdata.put("USER_NAME_LOC",  "");
				 formdata.put("EMAIL",  "");
				 formdata.put("COM_TYPE",     "");
				 formdata.put("USER_TYPE",     "");
				 formdata.put("COM_CODE",      "");
				 formdata.put("BUSINESS_COND", ""); 
				 formdata.put("MPHONE", "");
				 formdata.put("TEL",    "");
				 formdata.put("FAX",    "");
			 }


		} catch (Exception e) {
			logger.error("세션 데이터 수집 중 에러 발생!", e);
			throw new RuntimeException(e);
		}

		return formdata;
	}

	// Controller > Service 데이터 전달시 폼데이터를 셋팅하는 메소드
	@SuppressWarnings("unchecked")
	public static Map<String,String> getCommonFormData(HttpServletRequest req) {
		Map<String, String> mp = new HashMap<String,String>();
		try {

			String[] savename = null;
			if (req.getParameter("s_SAVENAME") != null) {
				savename = req.getParameter("s_SAVENAME").split("\\|");
			}

			Enumeration<String> e = req.getParameterNames();
			while (e.hasMoreElements()) {
				String name = e.nextElement();
				String value = "";
				if (savename == null) {
					value = req.getParameter(name);
					mp.put(name, value);
					//System.out.println(name + " = " + value);
				} else {
					int count = 0;
					for (int i = 0; i < savename.length; i++) {
						if (name.equals(savename[i])) {
							count = 1;
						}
					}
					if (count == 0) {
						value = req.getParameter(name);
						mp.put(name, value);
						//System.out.println(name + " = " + value);
					}
				}
			}
		} catch (Exception e) {
			logger.error("폼 데이터 수집 중 에러 발생!", e);
			throw new RuntimeException(e);
		}
		return mp;
	}

	// Controller > Service 데이터 전달시 폼데이터를 셋팅하는 메소드
	public static Map<String,String> addParamForPaging(HttpServletRequest req, Map<String, String> params) {
		String pageflag = params.get("pageflag");
//		if (!"Y".equals(pageflag))
		if (!"1".equals(pageflag))
			return params;

		String rowidx = req.getParameter("page"); // 현재가 몇번째 페이지
		String onepagerow = req.getParameter("onepagerow"); // 한번에 몇건씩 가져올 것인지
		String iborderby = req.getParameter("iborderby"); // sort 2013.01.30
		// ORDR_SEQ|STATE^ASC|DESC

		if (iborderby == null || "".equals(iborderby)) {
			params.put("KEPORDERBY", "");
		} else {
			String orderbyStr = "";
			String[] colArr = null;
			String[] sortArr = null;
			// System.out.println(iborderby);
			String[] ColandSort = iborderby.split("\\^");
			if (ColandSort[0].indexOf("|") > -1) {
				colArr = ColandSort[0].split("\\|");
				sortArr = ColandSort[1].split("\\|");
				for (int i = 0; i < colArr.length; i++) {
					orderbyStr += "," + colArr[i] + " " + sortArr[i];
				}
			} else {
				orderbyStr = " " + ColandSort[0] + " " + ColandSort[1];
			}
			params.put("KEPORDERBY", orderbyStr.substring(1));
		}

		String onepage = "0";
		// 처음 조회 하는 경우
		if (rowidx == null) {
			rowidx = "1";
			onepage = "0";
		} else {
			onepage = onepagerow;
		}
		int startrow, endrow;
		startrow = (Integer.parseInt(rowidx) - 1) * Integer.parseInt(onepage) + 1;
		endrow = startrow + (Integer.parseInt(onepagerow) - 1);

		params.put("STARTROW", startrow + "");
		params.put("ENDROW", endrow + "");
		
		logger.debug("{} , {}",startrow,endrow );
		return params;
	}

	// Controller > Service 데이터 전달시 폼데이터를 셋팅하는 메소드
	public static Map<String, String> addParamForPaging2(Map<String, String> params) {
		String pageflag = params.get("pageflag");
//		if (!"Y".equals(pageflag))
		if (!"1".equals(pageflag))
			return params;

		String rowidx = params.get("page"); // 현재가 몇번째 페이지
		String onepagerow = params.get("onepagerow"); // 한번에 몇건씩 가져올 것인지
		String iborderby = params.get("iborderby"); // sort 2013.01.30
		// ORDR_SEQ|STATE^ASC|DESC

		if (iborderby == null || "".equals(iborderby)) {
			params.put("KEPORDERBY", "");
		} else {
			String orderbyStr = "";
			String[] colArr = null;
			String[] sortArr = null;
			// System.out.println(iborderby);
			String[] ColandSort = iborderby.split("\\^");
			if (ColandSort[0].indexOf("|") > -1) {
				colArr = ColandSort[0].split("\\|");
				sortArr = ColandSort[1].split("\\|");
				for (int i = 0; i < colArr.length; i++) {
					orderbyStr += "," + colArr[i] + " " + sortArr[i];
				}
			} else {
				orderbyStr = " " + ColandSort[0] + " " + ColandSort[1];
			}
			params.put("KEPORDERBY", orderbyStr.substring(1));
		}

		String onepage = "0";
		// 처음 조회 하는 경우
		if (rowidx == null) {
			rowidx = "1";
			onepage = "0";
		} else {
			onepage = onepagerow;
		}
		int startrow, endrow;
		startrow = (Integer.parseInt(rowidx) - 1) * Integer.parseInt(onepage) + 1;
		endrow = startrow + (Integer.parseInt(onepagerow) - 1);

		params.put("STARTROW", startrow + "");
		params.put("ENDROW", endrow + "");

		logger.debug("{} , {}",startrow,endrow );

		return params;
	}

	
	// Controller > Service 데이터 전달시 폼데이터를 셋팅하는 메소드
	public static Map<String, Object> addParamForPaging3(Map<String, Object> params) {
		// 조회일 슬래시 제거
		params = removeSlash(params);

		String pageflag = (String)params.get("pageflag");
//		if (!"Y".equals(pageflag))
		if (!"1".equals(pageflag))
			return params;
		
		String rowidx = (String)params.get("page"); // 현재가 몇번째 페이지
		String onepagerow = (String)params.get("onepagerow"); // 한번에 몇건씩 가져올 것인지
		String iborderby = (String)params.get("iborderby"); // sort 2013.01.30
		// ORDR_SEQ|STATE^ASC|DESC

		if (iborderby == null || "".equals(iborderby)) {
			params.put("KEPORDERBY", "");
		} else {
			String orderbyStr = "";
			String[] colArr = null;
			String[] sortArr = null;
			// System.out.println(iborderby);
			String[] ColandSort = iborderby.split("\\^");
			if (ColandSort[0].indexOf("|") > -1) {
				colArr = ColandSort[0].split("\\|");
				sortArr = ColandSort[1].split("\\|");
				for (int i = 0; i < colArr.length; i++) {
					orderbyStr += "," + colArr[i] + " " + sortArr[i];
				}
			} else {
				orderbyStr = " " + ColandSort[0] + " " + ColandSort[1];
			}
			params.put("KEPORDERBY", orderbyStr.substring(1));
		}

		String onepage = "0";
		// 처음 조회 하는 경우
		if (rowidx == null) {
			rowidx = "1";
			onepage = "0";
		} else {
			onepage = onepagerow;
		}
		int startrow, endrow;
		startrow = (Integer.parseInt(rowidx) - 1) * Integer.parseInt(onepage) + 1;
		endrow = startrow + (Integer.parseInt(onepagerow) - 1);

		params.put("STARTROW", startrow + "");
		params.put("ENDROW", endrow + "");

		logger.debug("{} , {}",startrow,endrow );

		return params;
	}
	
	public static List<Map<String,String>> getMassData(String dataStr) {
		return getMassData(dataStr, "†", "‡");
	}

	public static List<Map<String,String>> getMassData(String dataStr, String colSepa, String rowSepa) {
		List<Map<String,String>> li = new ArrayList<Map<String,String>>();
		String[] row = dataStr.split("\\" + rowSepa);
		int colcnt = 0;
		String[] header = row[0].split("\\" + colSepa);
		colcnt = header.length;
		Map<String,String> mp = new HashMap<String,String>();
		for (int i = 1; i < row.length; i++) {
			String[] item = row[i].split("\\" + colSepa, colcnt);
			for (int c = 0; c < colcnt; c++) {
				mp.put(header[c], item[c]);
			}
			li.add(mp);
		}
		return li;
	}

	@SuppressWarnings("unchecked")
	public static Map<String,Object> getMultipartData(String str, boolean isUTF8) throws Exception {
		Map<String,Object> hm = new HashMap<String,Object>();
		String[] item = str.split("&");
		for (int i = 0; i < item.length; i++) {

			String[] keyvalue = item[i].split("=", 2);
			if (keyvalue.length == 1) {
				String[] t = new String[2];
				t[0] = keyvalue[0];
				t[1] = "";
				keyvalue = t;
			}

			if (hm.containsKey(keyvalue[0])) {
				List<String> al = (ArrayList<String>) hm.get(keyvalue[0]);
				al.add(keyvalue[1]);
				hm.put(keyvalue[0], al);
			} else {
				List<String> al = new ArrayList<String>();
				al.add(keyvalue[1]);
				hm.put(keyvalue[0], al);
			}
		}
		return hm;
	}

	@SuppressWarnings("unchecked")
	public static Map<String,Object> getMultipartData(HttpServletRequest request, boolean isUTF8) throws Exception {
		// ====================================================================================================
		// 수신자료를 수집합니다.
		// ====================================================================================================
		BufferedReader br = null;
		Map<String,Object> hm = new HashMap<String,Object>();
		try {

			ServletInputStream ips = request.getInputStream();
			if (isUTF8) {
				br = new BufferedReader(new InputStreamReader(ips, "utf-8"));
			} else {
				br = new BufferedReader(new InputStreamReader(ips));
			}
			String str;

			// 가져온 데이터를 &와 =을 기준으로 잘라내어 데이터 셋을 구성한다.
			while ((str = br.readLine()) != null) {
				if (str.indexOf("!!") > -1) {
					str = str.substring(2);
				}

				String[] item = str.split("&");
				for (int i = 0; i < item.length; i++) {

					String[] keyvalue = item[i].split("=", 2);
					if (keyvalue.length == 1) {
						String[] t = new String[2];
						t[0] = keyvalue[0];
						t[1] = "";
						keyvalue = t;
					}

					if (hm.containsKey(keyvalue[0])) {
						List<String> al = (ArrayList<String>) hm.get(keyvalue[0]);
						al.add(keyvalue[1]);
						hm.put(keyvalue[0], al);
					} else {
						List<String> al = new ArrayList<String>();
						al.add(keyvalue[1]);
						hm.put(keyvalue[0], al);
					}
				}
			}
			ips.close();
			br.close();
		} catch (IOException iex) {
			logger.error("멀티 파트 데이터 수집 중 에러 발생!", iex);
			throw new RuntimeException(iex);
		} finally {
			br.close();
		}

		// ====================================================================================================
		// 수신자료 수집 끝!!!
		// ====================================================================================================
		return hm;
	}
	
	/**
	 * 화면 그리드 데이터 및 페이징 등의 설정데이터를 Controller 에서 셋팅. 
	 * @param req
	 * @param li
	 * @param params
	 * @return
	 * @throws ServletException
	 * @throws IOException
	 */
	
    public static Map<String, Object> addResut(HttpServletRequest req, List<Map<String,String>> li ,MultiValueMap<String, String> params) {
    	return addResut(req, li , null , null);
    }	
	public static Map<String, Object> addResut(HttpServletRequest req, List<Map<String,String>> li ,Map<String,Object> params) {
    	return addResut(req, li , params , null);
    }	
    //Controller > Service 데이터 전달시 폼데이터를 셋팅하는 메소드
    public static Map<String, Object> addResut(HttpServletRequest req, List<Map<String,String>> li ,Map<String,Object> params, HttpServletResponse res) {
    	Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("data", li);

		if(params != null){
			String pageflag = (String)params.get("pageflag");
	    	if( "1".equals(pageflag)) {
				if(li.size()>0){
					_response.put("total", li.get(0).get("TOTNUM"));
				}
	    	}
			
			if("DirectDown2Excel".equals(params.get("SheetWork"))){
				
				//System.out.println("!!!!!!!!!!!!!!!!!"+req.getParameter("Data"));
				_response.put("SHEETHEADER", li);
	//			req.setAttribute("SHEETHEADER",req.getParameter("Data"));
				String forwardPath = "/js/ibsheet7/jsp/DirectDown2Excel.jsp"; 
				if(!"".equals(forwardPath)){
					RequestDispatcher rd = req.getRequestDispatcher(forwardPath);
					try {
						rd.forward(req,res);
					} catch (ServletException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					req.setAttribute("ResponseClose", "CLOSE");
				}
			}
		}
		return _response;
    }

    /**
	 * KEPPROJECT 
	 * 
	 * @author 한승준
	 * @remark 엑셀다운로드 버튼 클릭 시 DRM 적용
	 * @date 2015-10-02
	 */
	private static boolean setFileEncryption(String sPath, String sFile, String dPath, String dFile, String originFileName, String userID, String userName,
			String userLocalIp, String fileID) {
		boolean bRtn = false;
		File fIn = null;
		File fOut = null;
		long OutFileLength = 0;

		InputStream is = null;
		OutputStream os = null;
		BufferedInputStream in = null;
		BufferedOutputStream out = null;

		try {
			System.out.println("Drm Encryption Start......");
			fIn = new File(sPath, sFile);
			fOut = new File(dPath, dFile);
			
			is = new FileInputStream(fIn);
			os = new FileOutputStream(fOut);
			
			os.flush();

			in = new BufferedInputStream(is);
			out = new BufferedOutputStream(os);

			long beforetime = System.currentTimeMillis();

			System.out.println("Drm Encryption Step 0 : read MarkAnyDrmInfo.dat before");
			Madn clMadn = new Madn();
			
			String osName1 = System.getProperty("os.name");
			if (osName1.indexOf("Win") > -1){
				clMadn = new Madn("D:/project/MRO_PJT/workspace/MRO/src/main/webapp/resources/drm/MarkAnyDrmInfo.dat");
			} else {
				clMadn = new Madn("/webContents/mro/resources/drm/MarkAnyDrmInfo.dat");
			}
			System.out.println("Drm Encryption Step 0 : read MarkAnyDrmInfo.dat after");
			
			int tempInt = -99;

	        int piAclFlag                   = 0;                            // 0 고정
	        String pstrDocLevel             = new String("0");              // 0 고정
	        String pstrUserId               = userID;                       // 다운로드사용자계정
	        String pstrFileName             = originFileName;               // 파일명(확장자포함)
	        long plFileSize                 = fIn.length();
	        String pstrOwnerId              = new String("");
	        String pstrCompanyId            = new String("KEP-2A0D-EB84-21BF"); // 고정
	        String pstrGroupId              = ("");
	        String pstrPositionId           = ("");
	        String pstrGrade                = ("");
	        String pstrFileId               = fileID;                   // 파일아이디
	        int piCanSave                   = 1;                        // 저장가능		0
	        int piCanEdit                   = 1;                        // 편집가능		0
	        int piBlockCopy                 = 1;                        // 블럭복사방지	
	        int piOpenCount                 = -99;                        // 열람횟수제한없음	3
	        int piPrintCount                = -99;                        // 인쇄횟수제한없음	3
	        int piValidPeriod               = 7;                        // 기간제한없음		7
	        int piSaveLog                   = 1;                        // 저장로그사용
	        int piPrintLog                  = 1;                        // 인쇄로그사용
	        int piOpenLog                   = 1;                        // 열람로그사용
	        int piVisualPrint               = 1;                        // 워터마크사용
	        int piImageSafer                = 1;                        // 캡쳐방지사용
	        int piRealTimeAcl               = 0;                        // 0
	        String pstrDocumentTitle        = new String("");
	        String pstrCompanyName          = new String("KEP");        // KEP
	        String pstrGroupName            = new String("");
	        String pstrPositionName         = new String("");
	        String pstrUserName             = userName;                 // 사용자명
	        String pstrUserIp               = userLocalIp;              // 사용자PC IP
	        String pstrServerOrigin         = new String("KOREAB2B");   // 시스템명
	        int piExchangePolicy            = 1;                        // 1 고정
	        int piDrmFlag                   = 0;                        // 0 고정
	        int iBlockSize                  = 0;
	        String  strMachineKey           = new String("");
	        String  strFileVersion          = new String("");
	        String  strMultiUserID          = new String("");
	        String  strMultiUserName        = new String("");
	        String  strEnterpriseID         = new String("KEPG-8E5C-495C-FF9D");    // 고정
	        String  strEnterpriseName       = new String("");
	        String  strDeptID               = new String("");
	        String  strDeptName             = new String("");
	        String  strPositionLevel        = new String("-99");
	        String  strSecurityLevel        = new String("-99");
	        String  strSecurityLevelName    = new String("");
	        String  strPgCode               = new String("");
	        String  strCipherBlockSize      = new String("16"); // 고정
	        String  strCreatorID            = new String("");
	        String  strCreatorName          = new String("");
	        String  strOnlineContorl        = new String("0");  // 고정
	        String  strOfflinePolicy        = new String("");
	        String  strValidPeriodType      = new String("");
	        String  strUsableAlways         = new String("0");  // 고정
	        String  strPriPubKey            = new String("");
	        String  pstrCreatorCompanyId    = new String("KEP-2A0D-EB84-21BF");     //(고정)
	        String  pstrCreatorDeptId       = new String("");                       // 싸이트 접속 하신 id의 부서 이름
	        String  pstrCreatorGroupId      = new String("KEP");                    // 싸이트 접속 하신 id의  groupid  == 해당 싸이트 :KEP
	        String  pstrCreatorPositionId   = new String("");                       // 싸이트 접속 하신 직책
	        String  pstrFileSize            = Long.toString(plFileSize);            // 파일 사이즈 암호화 안된 파일사이즈
	        String  pstrHeaderUpdateTime    = Long.toString(beforetime);            // 파일 다운로드 하시는 시간 (sysdate)
	        String  pstrReserved01          = new String("0");                      // 아무정보 넣어두됨  0
	        String  pstrReserved02          = new String("0");                      // 아무정보 넣어두됨  0
	        String  pstrReserved03          = new String("0");                      // 아무정보 넣어두됨  0
	        String  pstrReserved04          = new String("0");                      // 아무정보 넣어두됨  0
	        String  pstrReserved05          = new String("0");                      // 아무정보 넣어두됨  0
	        

			System.out.println("Drm Encryption Step 0 : clMadn.lGetEncryptFileSize before");
			OutFileLength = clMadn.lGetEncryptFileSize(piAclFlag, pstrDocLevel, pstrUserId, pstrFileName, plFileSize,

			pstrOwnerId, pstrCompanyId, pstrGroupId, pstrPositionId, pstrGrade, // 10

					pstrFileId, piCanSave, piCanEdit, piBlockCopy, piOpenCount,

					piPrintCount, piValidPeriod, piSaveLog, piPrintLog, piOpenLog, // 20

					piVisualPrint, piImageSafer, piRealTimeAcl, pstrDocumentTitle, pstrCompanyName,

					pstrGroupName, pstrPositionName, pstrUserName, pstrUserIp, pstrServerOrigin, // 30

					piExchangePolicy, piDrmFlag, iBlockSize, strMachineKey, strFileVersion,

					strMultiUserID, strMultiUserName, strEnterpriseID, strEnterpriseName, strDeptID, // 40

					strDeptName, strPositionLevel, strSecurityLevel, strSecurityLevelName, strPgCode,

					strCipherBlockSize, strCreatorID, strCreatorName, strOnlineContorl, strOfflinePolicy, // 50

					strValidPeriodType, strUsableAlways, strPriPubKey, pstrCreatorCompanyId, pstrCreatorDeptId,

					pstrCreatorGroupId, pstrCreatorPositionId, pstrFileSize, pstrHeaderUpdateTime, pstrReserved01, // 60

					pstrReserved02, pstrReserved03, pstrReserved04, pstrReserved05, in);
			System.out.println("Drm Encryption Step 0 : clMadn.lGetEncryptFileSize after");

			if (OutFileLength > 0) {
				String strRetCode = clMadn.strMadn(out);
				System.out.println("strRetCode    : " + strRetCode);
				System.out.println("OutFileLength : " + OutFileLength);
				bRtn = true;

			} else {
				String strErrorCode = clMadn.strGetErrorCode();
				System.out.println("[ErrorCode] " + strErrorCode + " [ErrorDescription] " + clMadn.strGetErrorMessage(strErrorCode));

				bRtn = false;
			}
			System.out.println("Drm Encryption End......");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		} finally {

			if (is != null)
				try {
					is.close();
				} catch (Exception e) {
				}
			;
			if (os != null)
				try {
					os.close();
				} catch (Exception e) {
				}
			;

			// is.flush();
			// os.flush();
		}

		return bRtn;
	}
    
    //Controller > Service 데이터 전달시 폼데이터를 셋팅하는 메소드
    public static void excelOut(HttpServletRequest req, HttpServletResponse res, List<Map<String,String>> _data) {

    	SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
    	String user_id = CommonUtil.nvl((String)_sessionInfo.getUserId());
    	
    	// DRM 예외 사용자 리스트(ex 물류센터 직원)
    	String com_code = CommonUtil.nvl((String)_sessionInfo.getComCode());
    	String p01103202 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1032-02","COL01_DATA");
    	String pass_ok = "N";
    	
    	String _path = "";
		java.io.File file = null;
		ServletOutputStream outStream = null;
		FileInputStream inputStream = null;
		
		//if(_data.size()>0){
			req.setAttribute("SHEETDATA",_data);

			DirectDown2Excel ibExcel = new DirectDown2Excel();
			ibExcel.setService(req, res);
			
			Common ibcomm = new Common();
			
			ibExcel.setPageEncoding("utf-8");
//			ibExcel.setWebRoot(CommonUtil.getURL(req));
			String osName = System.getProperty("os.name");
			_path = (osName.indexOf("Win") > -1)?"c:/temp" : "/webContents/tmp/";
			ibExcel.setWebRoot(_path);
			
			ibExcel.setTreeChar("\u2026");
			ibExcel.setDefaultFontName("맑은고딕");
			ibExcel.setDefaultFontSize((short)10);
			try {
				res.reset();
				// 파라메터 정보를 얻음
				// ※ 'Data' 는 브라우저(클라이언트)가 통째로 만들어 보낸 문자열이다. 신뢰할 수 없다.
				String data = req.getParameter("Data");

				// [보안 패치] IBSheet BaseDir 임의 파일 읽기(Path Traversal) 차단.
				//  - 클라이언트가 Data 안에 넣은 <BaseDir> 값을 비워서, 아래 setData()/makeDirectExcel()
				//    (ibsheet7 jar)로 공격용 서버 경로가 전달되지 않게 한다. 상세 설명은 removeClientBaseDir() 주석 참고.
				data = removeClientBaseDir(data);

				ibExcel.setData(data);
				
				// 엑셀 워크북을 생성
				Workbook workbook = ibExcel.makeDirectExcel();
				
				// 물류센터 직원들은 엑셀 다운 시 DRM 미설치로 암호화 제외
				if (!"".equals(p01103202)){
					String grant[] = p01103202.split("\\^");
					if (grant != null){
						if (grant.length>0){
							for (int i=0; i<grant.length; i++){
								if (user_id.equals(grant[i])){
									pass_ok = "Y";
								}
							}
						}
					}
				}
				
				// 고객사, 협력사 그리드 이용 시 엑셀다운로드 DRM 제외
				String com_business_cond = CommonUtil.nvl((String)_sessionInfo.getBusinessCond());
				if("S".equals(com_business_cond) || "B".equals(com_business_cond)){
					pass_ok = "Y";
				}
				
				// DRM 예외 사용자이면
				if("Y".equals(pass_ok)){
					
					// 다운로드 1. 생성된 엑셀 문서를 바로 다운로드 받음
					ServletOutputStream out2 = res.getOutputStream();
					workbook.write(out2);
					out2.flush();
				}
				
				// 물류센터 직원 제외 엑셀다운 시 DRM 적용
				else{
					// 다운로드 2. 생성된 엑셀 문서를 서버에 저장
					// 다운로드 받을 파일 이름을 얻음
					
					// 시스템 시간을 파일명에 붙일 때 사용
					long sysTime = System.currentTimeMillis();
					
					String fileName = user_id+"_"+sysTime+".xlsx";
					
					// 확장자 추출(파일명 만들기 위하여)
					String inFileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
					
					FileOutputStream out2 = new FileOutputStream (_path + "/" + fileName);
					workbook.write(out2);
					out2.close();
					
					String orgFile = _path + "/" + fileName;
					String encDir	= _path;
					
					// 최종 out파일명
					String encFileName = (fileName.substring(0, fileName.lastIndexOf(".")) + "_enc." + inFileExt);
					String _orgFilename	= ibExcel.getDownloadFileName();
					boolean bRtn    = setFileEncryption(_path, fileName, encDir, encFileName, _orgFilename,
							user_id, user_id, req.getRemoteAddr(), encFileName);
			        
			        if (bRtn == false) {
			        	throw new Exception("File Encryption Failed.");
			        }
			     // 생성된 엑셀 문서를 다운로드 받음 (예, 엑셀문서를 DRM 처리함)
		     		file = new File( encDir + "/" + encFileName );

				res.setContentLength((int)file.length());

				try {
					if (file.isFile()) {
						byte[] outputByte = new byte[(int) file.length()];

						outStream = null;
						inputStream = null;
						
						inputStream = new FileInputStream(file);
						outStream = res.getOutputStream();
						
						int leng = 0;
			        	while((leng = inputStream.read(outputByte)) > 0){
			        		outStream.write(outputByte, 0, leng);
			        	}
						inputStream.close();
						outStream.flush();
						outStream.close();
						res.flushBuffer();
					} 
				} catch( Exception e) {
					e.printStackTrace();
				} finally {
					file.delete();
				}
				// DRM 암호화되지 않은 임시 생성파일은 삭제
				ibcomm.mDeleteFile(orgFile);
				}
				
				
						
			}catch(Exception ex){
				logger.error("엑셀 생성 중 에러 발생!", ex);
				throw new RuntimeException(ex);
			}
		//}else{
		//	logger.error("엑셀출력 대상 데이터가 존재하지 않습니다.");
		//}
    }

    /**
     * 서버가 직접 만든 워크북(POI)을 DRM 을 씌워 내려보낸다.
     *
     * excelOut() 은 IBSheet 가 그린 그리드를 내보내는 경로라 병합 다단 헤더·드롭다운이 있는 양식에는 못 쓴다.
     * 그런 양식은 호출부가 POI 로 직접 만들고 이 메서드로 내보낸다 — DRM 정책(setFileEncryption)을 한 곳에서 쓰기 위함이다.
     * DRM 예외(고객사 B / 협력사 S)는 excelOut 과 같은 기준으로 그대로 흘려보낸다.
     *
     * @param downloadFileName 사용자가 받는 파일명(확장자 포함)
     */
    public static void drmExcelOut(HttpServletRequest req, HttpServletResponse res, Workbook workbook, String downloadFileName) {
    	drmExcelOut(req, res, workbook, downloadFileName, null);
    }

    /**
     * 위와 같되, 다운로드가 끝난 것을 화면에 알려 준다(로딩바를 내리기 위함).
     *
     * 파일 응답은 숨은 iframe 으로 받는데, attachment 응답은 iframe 을 이동시키지 않아
     * onload 이벤트가 오지 않는다 → 화면은 언제 끝났는지 알 수 없다.
     * 그래서 응답에 쿠키를 하나 실어 보내고, 화면은 그 쿠키가 생기는 것을 보고 로딩바를 내린다.
     *
     * @param downToken 화면이 만들어 보낸 1회용 토큰. 비어 있으면 아무것도 하지 않는다(기존 동작).
     */
    public static void drmExcelOut(HttpServletRequest req, HttpServletResponse res, Workbook workbook,
    		String downloadFileName, String downToken) {

    	SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
    	String user_id = CommonUtil.nvl((String)_sessionInfo.getUserId());
    	String com_business_cond = CommonUtil.nvl((String)_sessionInfo.getBusinessCond());

    	String osName = System.getProperty("os.name");
    	String _path  = (osName.indexOf("Win") > -1) ? "c:/temp" : "/webContents/tmp/";

    	Common ibcomm = new Common();
    	File file = null;
    	FileInputStream inputStream = null;
    	ServletOutputStream outStream = null;

    	try {
    		res.reset();
    		setDownTokenCookie(res, downToken);		// ⚠ reset() 이 헤더를 지우므로 반드시 그 뒤에서 심는다
    		res.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
    		// ⚠ URLEncoder 는 공백을 '+' 로 바꾼다 → 사용자가 받는 파일명이 "상품정보+일괄수정" 이 된다.
    		//   URL 경로가 아니라 헤더 값이므로 %20 으로 되돌려야 공백이 공백으로 보인다.
    		String encName = java.net.URLEncoder.encode(downloadFileName, "UTF-8").replace("+", "%20");
    		res.setHeader("Content-Disposition", "attachment;filename=\"" + encName + "\"");

    		// DRM 예외 사용자(고객사·협력사)는 암호화 없이 바로 내려보낸다
    		if ("S".equals(com_business_cond) || "B".equals(com_business_cond)) {
    			ServletOutputStream out2 = res.getOutputStream();
    			workbook.write(out2);
    			out2.flush();
    			return;
    		}

    		long sysTime = System.currentTimeMillis();
    		String fileName = user_id + "_" + sysTime + ".xlsx";
    		String orgFile  = _path + "/" + fileName;

    		FileOutputStream out2 = new FileOutputStream(orgFile);
    		workbook.write(out2);
    		out2.close();

    		String encFileName = fileName.substring(0, fileName.lastIndexOf(".")) + "_enc.xlsx";
    		boolean bRtn = setFileEncryption(_path, fileName, _path, encFileName, downloadFileName,
    				user_id, user_id, req.getRemoteAddr(), encFileName);

    		if (bRtn == false) {
    			throw new Exception("File Encryption Failed.");
    		}

    		file = new File(_path + "/" + encFileName);
    		res.setContentLength((int) file.length());

    		byte[] buf = new byte[8192];
    		inputStream = new FileInputStream(file);
    		outStream   = res.getOutputStream();
    		int leng = 0;
    		while ((leng = inputStream.read(buf)) > 0) {
    			outStream.write(buf, 0, leng);
    		}
    		outStream.flush();
    		res.flushBuffer();

    		// DRM 암호화되지 않은 임시 생성파일은 삭제
    		ibcomm.mDeleteFile(orgFile);

    	} catch (Exception ex) {
    		logger.error("양식 엑셀 생성 중 에러 발생!", ex);
    		throw new RuntimeException(ex);
    	} finally {
    		try { if (inputStream != null) { inputStream.close(); } } catch (Exception e) {}
    		try { if (outStream   != null) { outStream.close();   } } catch (Exception e) {}
    		if (file != null) { file.delete(); }
    	}
    }

    /**
     * 다운로드 완료 신호 쿠키. 화면이 이 쿠키를 보고 로딩바를 내린 뒤 스스로 지운다.
     * 값 전달이 전부라 경로는 "/", 만료는 두지 않는다(브라우저 세션 한정).
     */
    public static void setDownTokenCookie(HttpServletResponse res, String downToken) {
    	if (downToken == null || downToken.length() == 0) { return; }
    	String safe = downToken.replaceAll("[^0-9A-Za-z_-]", "");	// 쿠키 값에 못 쓰는 문자를 걸러낸다
    	if (safe.length() == 0) { return; }
    	Cookie c = new Cookie("mroDownToken", safe);
    	c.setPath("/");
    	res.addCookie(c);
    }

    /**
     * [보안] IBSheet 엑셀다운로드 페이로드(Data)에서 "클라이언트가 보낸 BaseDir 값"을 제거(무력화)한다.
     *
     * ── 왜 필요한가 (취약점 설명) ─────────────────────────────────────────────
     * 엑셀다운로드 요청의 'Data' 파라미터는 브라우저(클라이언트)가 통째로 만들어 서버로 보낸다.
     * 이 문자열 안에는 아래처럼 "헤더 프로퍼티"가 들어 있는데, 그 중 하나가 BaseDir 이다.
     *      ... <BaseDir>어떤경로</BaseDir> ...     (프로퍼티 포맷: <태그>값</태그>)
     *
     * IBSheet 라이브러리(ibsheet7 jar)는 컬럼 타입이 Image/ImageText 일 때 이 BaseDir 값을
     * 파일 경로 앞에 그대로 붙여서
     *      new File( BaseDir + 셀값 )
     * 로 "서버에 있는 실제 파일"을 읽어 엑셀 안에 그림처럼 끼워 넣는다.
     * (동일 로직의 원본 소스: src/main/webapp/chart/Sheet/jsp/DirectDown2Excel.jsp 의
     *  L176 BaseDir 읽기, L191 경로 결합, L718 new File(...) 참고. jar 안에도 같은 코드가 들어 있다.)
     *
     * 즉, 공격자가 프록시 툴로 요청을 가로채 BaseDir 에 서버의 절대경로
     * (예: 톰캣 conf/context.xml 의 URL 인코딩 경로)를 넣으면, 그 파일 내용이 엑셀에 담겨
     * 그대로 다운로드된다. → "임의 파일 읽기(Arbitrary File Read / Path Traversal)" 취약점.
     *
     * ── 무엇을 하나 (대응) ───────────────────────────────────────────────────
     * 정상적인 엑셀다운로드 화면들은 클라이언트가 BaseDir 을 지정할 필요가 전혀 없다.
     * (정상 이미지는 '/' 로 시작하는 웹루트 상대경로를 쓰며, 이 경우는 BaseDir 분기를 타지 않는다.)
     * 그래서 여기서 <BaseDir>...</BaseDir> 사이의 값을 "무조건 빈 값"으로 바꿔서,
     * 공격자가 넣은 경로가 라이브러리로 전달되는 것을 원천 차단한다.
     * → 정상 기능은 영향 없음(깨지는 화면 없음), 공격 경로만 제거됨.
     *
     * @param data 클라이언트가 보낸 원본 Data 파라미터 (null 일 수 있음)
     * @return <BaseDir> 값이 비워진 안전한 Data 문자열 (원본이 null 이면 null 그대로 반환)
     */
    private static String removeClientBaseDir(String data) {
        // 방어적 처리: 파라미터가 없으면(null) 그대로 돌려준다. (뒤 로직에서 별도 처리)
        if (data == null) {
            return data;
        }

        // 정규식 설명:
        //   (?is)                 → i: 대소문자 무시,  s: 개행문자도 .(dot) 에 매칭시킴
        //   <BaseDir>  ...  </BaseDir>
        //   .*?                   → 최소(non-greedy) 매칭. 여러 시트를 한 번에 보내
        //                           <BaseDir> 태그가 여러 개 있어도 각각을 개별적으로 비운다.
        // → <BaseDir>...</BaseDir> 안의 내용을 통째로 지우고 빈 태그 <BaseDir></BaseDir> 로 치환.
        //   (태그 자체를 남겨두어도 라이브러리는 "값이 비었다"고 보고 파일을 읽지 않는다.)
        return data.replaceAll("(?is)<BaseDir>.*?</BaseDir>", "<BaseDir></BaseDir>");
    }


    /**
     * 조회일 Convert( 슬래시'/' 제거)
     */
	public static Map<String, Object> removeSlash(Map<String, Object> params) {

		if (params != null){
			Set<String> key =null;
			Iterator<String> iterkey =null;
			key = params.keySet();
			iterkey = key.iterator();
			
			while(iterkey.hasNext()){
				String mapkey = iterkey.next();
				
				if(mapkey.indexOf("_date") > -1){
					String dateVal = (String)params.get(mapkey);
					if (dateVal.indexOf("/") > -1) {
						params.put(mapkey, dateVal.replace("/",""));
					}
				}
			}
		}
		
		return params;		
	}    
}
