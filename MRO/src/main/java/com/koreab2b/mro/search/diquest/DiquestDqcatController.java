package com.koreab2b.mro.search.diquest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import m2.context.msg.protocol.query.Query;
import m2.context.msg.protocol.query.QuerySet;
import m2.context.msg.protocol.result.Result;
import m2.context.msg.protocol.result.ResultSet;
import m2.earth.command.CommandSearchRequest;
import m2.earth.util.EarthException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.util.CommonUtil;

@Controller("diquestDqcatController")
public class DiquestDqcatController {

	private static final Logger LOGGER = LoggerFactory.getLogger(DiquestDqcatController.class);

	@Value("#{diquestProps['diquest.dqcat.ip']}")
	private String adminIp;

	@Value("#{diquestProps['diquest.dqcat.port']}")
	private String adminPort;
	
	@Value("#{diquestProps['diquest.collection.dqcat.dev.name']}")
	private String collentionDevName;
	
	@Value("#{diquestProps['diquest.collection.dqcat.real.name']}")
	private String collentionRealName;
	
	public String getCollentionName(HttpServletRequest pRequest) {
		String flag = CommonUtil.getDevRealLocalFlag(pRequest); // 0 로컬 1 개발 2 운영
		
//		LOGGER.debug(" getCollentionName 0 로컬 1 개발 2 운영 : {}", flag);
		
		// 개발, 운영 구분 없음 모두 KEPS_REAL
		if ("2".equals(flag)){
			return collentionRealName;
		}else{
			return collentionRealName;
		}
	}

	/**
	 * 카테고리 자동세팅
	 *  
	 * 
	 */
	@RequestMapping(value = "/mprq/searchCategAutoSetting.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> searchCategAutoSetting(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
//		LOGGER.debug("요청 파라미터 : {}", pMap);
//		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String recommendSize = pMap.get("categ_target_count"); //return할 카테고리 갯수, maximum : 20
		String categ_row_no = pMap.get("categ_row_no"); //그리드 ROW 번호(화면 return 시 그리드 세팅에 필요)
		String matchProb = pMap.get("categ_target_rate"); //정확도
		
		String searchTermDes= pMap.get("categ_desc"); //카테고리를 추천받을 검색어
        String searchTermSpec= pMap.get("categ_spec"); //카테고리를 추천받을 검색어
        String searchTermMnm= pMap.get("categ_maker"); //카테고리를 추천받을 검색어
        String searchTermMpn= pMap.get("categ_model"); //카테고리를 추천받을 검색어
        
        String desc_flag = pMap.get("categ_desc_flag"); //조회조건으로 사용여부
        String spec_flag = pMap.get("categ_spec_flag"); //조회조건으로 사용여부
        String maker_flag = pMap.get("categ_maker_flag"); //조회조건으로 사용여부
        String model_flag = pMap.get("categ_model_flag"); //조회조건으로 사용여부
		
        String sParam01 = "sParam01Val";
        String sParam02 = "sParam02Val";
        String sParam03 = "sParam03Val";
        String sParam04 = "sParam04Val";
        String sParam05 = "sParam05Val";
        
		String collectionName = getCollentionName(req);
		
		HashMap<String, String> catParam = new HashMap<String, String>();
		catParam.put("recommendSize", recommendSize);
		catParam.put("matchProb", matchProb);
		catParam.put("collectionName", collectionName);
		
		catParam.put("searchTermDes", searchTermDes);
        catParam.put("searchTermSpec", searchTermSpec);
        catParam.put("searchTermMnm", searchTermMnm);
        catParam.put("searchTermMpn", searchTermMpn);
        
        catParam.put("sParam01", sParam01);
        catParam.put("sParam02", sParam02);
        catParam.put("sParam03", sParam03);
        catParam.put("sParam04", sParam04);
        catParam.put("sParam05", sParam05);
        
        catParam.put("desc_flag", desc_flag);
        catParam.put("spec_flag", spec_flag);
        catParam.put("maker_flag", maker_flag);
        catParam.put("model_flag", model_flag);
        
		List<HashMap<String, String>> list = getAutoCategorizer(catParam);
		HashMap<String, String> map = null;
		for (int i=0 ; i < list.size() ; i++){
			map = list.get(i);
			// 리턴 시 순위별 정보 입력 위해(ex 리턴수 5 = 순위별로 categPath1~categPath5에 세팅)
			int j=i+1;
//			Iterator<String> itr = map.keySet().iterator();

//			LOGGER.debug("map : {}", map);

			_response.put("categPath"+j, CommonUtil.nvl2(map.get("cateGpath"), ""));
			_response.put("cmsCategId"+j, CommonUtil.nvl2(map.get("cmsCategid"), ""));
			_response.put("categName"+j, CommonUtil.nvl2(map.get("cateGname"), ""));
			_response.put("sgId"+j, CommonUtil.nvl2(map.get("sgId"), ""));
			_response.put("sgName"+j, CommonUtil.nvl2(map.get("sgName"), ""));
			_response.put("categ_row_no"+j, categ_row_no);
			_response.put("pr"+j, CommonUtil.nvl2(map.get("pr"), ""));
			_response.put("choice_type"+j, CommonUtil.nvl2(map.get("choice_type"), ""));
			
			/* 테스트 출력용
			while(itr.hasNext()) {
				String key = itr.next();
				String value = map.get(key);
				System.out.println(key+", "+ value);
			}
			*/
//			LOGGER.debug("_response : {}", _response);
			
		}
//		_response.put("key", key);
		return  _response;
	}
	
	/**
	 * @param pRequest 
	 * 카테고라이징
	 * 
	 * @param request
	 * @param response
	 * @param pModel
	 * @return
	 * @throws
	 */
	public List<HashMap<String, String>> getAutoCategorizer(HashMap<String, String> catParam) {
		String sParam01= catParam.get("sParam01") !=null ?  catParam.get("sParam01") : "";  // 품목/견적 구분
		String sParam02= catParam.get("sParam02") !=null ?  catParam.get("sParam02") : ""; // 고객사코드
		String sParam03= catParam.get("sParam03") !=null ?  catParam.get("sParam03") : ""; // 견적의뢰번호 / 품목번호
		String sParam04= catParam.get("sParam04") !=null ?  catParam.get("sParam04") : ""; //견적의뢰항번
		String sParam05= catParam.get("sParam05") !=null ?  catParam.get("sParam05") : ""; //견적차수

		String desc_flag = catParam.get("desc_flag"); // !=null ?  catParam.get("desc_flag") : ""; // 상품명
		String spec_flag = catParam.get("spec_flag"); // !=null ?  catParam.get("spec_flag") : ""; // 규격
		String maker_flag = catParam.get("maker_flag"); // !=null ?  catParam.get("maker_flag") : ""; // 제조사명
		String model_flag = catParam.get("model_flag"); // !=null ?  catParam.get("model_flag") : ""; // 모델명
		
		String searchTermDes = catParam.get("searchTermDes") !=null ? catParam.get("searchTermDes") : ""; // 검색어
		String searchTermSpec = catParam.get("searchTermSpec") !=null ? catParam.get("searchTermSpec") : ""; // 검색어
		String searchTermMnm = catParam.get("searchTermMnm") !=null ? catParam.get("searchTermMnm") : ""; // 검색어
		String searchTermMpn = catParam.get("searchTermMpn") !=null ? catParam.get("searchTermMpn") : ""; // 검색어
		String matchProbStr = catParam.get("matchProb") !=null ?  catParam.get("matchProb") : "0"; // 정확도 제한
		
		double matchProb = Double.parseDouble(matchProbStr);
		String CATEG_PATH = "";
		String searchTerm = "";
		
//		LOGGER.debug("1.desc_flag / 2.spec_flag / 3.maker_flag / 4.model_flag : 1." + desc_flag + " / 2." + spec_flag + " / 3." +  maker_flag + " / 4." + model_flag);
		
		if(desc_flag.equals("true") && spec_flag.equals("true") && maker_flag.equals("true") && model_flag.equals("true")) {
			CATEG_PATH = "TOTAL";
			searchTerm = searchTermDes+"\t"+searchTermSpec+"\t"+searchTermMnm+"\t"+searchTermMpn;
		} else if (desc_flag.equals("true") && spec_flag.equals("false") && maker_flag.equals("false") && model_flag.equals("false")) {
			CATEG_PATH = "DESC";
			searchTerm = searchTermDes;
		} else if (desc_flag.equals("false") && spec_flag.equals("true") && maker_flag.equals("false") && model_flag.equals("false")) {
			CATEG_PATH = "SPEC";
			searchTerm = searchTermSpec;
		} else if (desc_flag.equals("false") && spec_flag.equals("false") && maker_flag.equals("true") && model_flag.equals("false")) {
			CATEG_PATH = "MN";
			searchTerm = searchTermMnm;
		} else if (desc_flag.equals("false") && spec_flag.equals("false") && maker_flag.equals("false") && model_flag.equals("true")) {
			CATEG_PATH = "MPN";
			searchTerm = searchTermMpn;
		} else if (desc_flag.equals("true") && spec_flag.equals("true") && maker_flag.equals("false") && model_flag.equals("false")) {
			CATEG_PATH = "DESC_SPEC";
			searchTerm = searchTermDes+"\t"+searchTermSpec;
		} else if (desc_flag.equals("true") && spec_flag.equals("false") && maker_flag.equals("true") && model_flag.equals("false")) {
			CATEG_PATH = "DESC_MN";
			searchTerm = searchTermDes+"\t"+searchTermMnm;
		} else if (desc_flag.equals("true") && spec_flag.equals("false") && maker_flag.equals("false") && model_flag.equals("true")) {
			CATEG_PATH = "DESC_MPN";
			searchTerm = searchTermDes+"\t"+searchTermMpn;
		} else if (desc_flag.equals("false") && spec_flag.equals("true") && maker_flag.equals("true") && model_flag.equals("false")) {
			CATEG_PATH = "SPEC_MN";
			searchTerm = searchTermSpec+"\t"+searchTermMnm;
		} else if (desc_flag.equals("false") && spec_flag.equals("true") && maker_flag.equals("false") && model_flag.equals("true")) {
			CATEG_PATH = "SPEC_MPN";
			searchTerm = searchTermSpec+"\t"+searchTermMpn;
		} else if (desc_flag.equals("false") && spec_flag.equals("false") && maker_flag.equals("true") && model_flag.equals("true")) {
			CATEG_PATH = "MPN_MN";
			searchTerm = searchTermMpn+"\t"+searchTermMnm;
		} else if (desc_flag.equals("true") && spec_flag.equals("true") && maker_flag.equals("true") && model_flag.equals("false")) {
			CATEG_PATH = "DESC_SPEC_MN";
			searchTerm = searchTermDes+"\t"+searchTermSpec+"\t"+searchTermMnm;
		} else if (desc_flag.equals("true") && spec_flag.equals("true") && maker_flag.equals("false") && model_flag.equals("true")) {
			CATEG_PATH = "DESC_SPEC_MPN";
			searchTerm = searchTermDes+"\t"+searchTermSpec+"\t"+searchTermMpn;
		} else if (desc_flag.equals("true") && spec_flag.equals("false") && maker_flag.equals("true") && model_flag.equals("true")) {
			CATEG_PATH = "DESC_MN_MPN";
			searchTerm = searchTermDes+"\t"+searchTermMnm+"\t"+searchTermMpn;
		} else if (desc_flag.equals("false") && spec_flag.equals("true") && maker_flag.equals("true") && model_flag.equals("true")) {
			CATEG_PATH = "SPEC_MN_MPN";
			searchTerm = searchTermSpec+"\t"+searchTermMnm+"\t"+searchTermMpn;
		}
		
		QuerySet querySet = new QuerySet(1);
		Query query = new Query();
		query.setFrom(catParam.get("collectionName"));
		query.setValue("search", "false"); 
		query.setValue("debug", "true");
		query.setResultModifier("category");
		query.setValue("category", CATEG_PATH+" 0 " +(Integer.parseInt(catParam.get("recommendSize"))-1));
		query.setValue("catKeyword", searchTerm); //카테고리를 추천받을 검색어 설정
		query.setValue("catOption", "2"); //카테고리 추천 로직 설정
		query.setValue("printQuery", "true"); //DQCAT 로그 노출 여부 설정 true/false 
		querySet.addQuery(query);

		LOGGER.debug("접속 시작 : " + "품명 : " + searchTermDes + "규격 : " + searchTermSpec + "제조사 : " + searchTermMnm);
		CommandSearchRequest csr = new CommandSearchRequest(adminIp, Integer.parseInt(adminPort));
		LOGGER.debug("접속 종료 : " + "품명 : " + searchTermDes + "규격 : " + searchTermSpec + "제조사 : " + searchTermMnm);
		
		int rval = 0;
		
		try {
			rval = csr.request(querySet);
		} catch (EarthException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		HashMap<String, String> map = new HashMap<String,String>();
		List<HashMap<String, String>> list = new ArrayList<HashMap<String,String>>();
		if( rval < 0) {
			System.out.println("request failed");
			map.put("errCode", String.valueOf(rval));
			map.put("searchTerm", catParam.get("searchTerm"));
			list.add(map);
			return list;
		} else {
			ResultSet rs = csr.getResultSet();
			Result result = rs.getResult(0);
			String categoryResult = result.getValue("catResult");
			String catPr = result.getValue("catPR");
			String [] splitResult = categoryResult.split("\n");
			String [] splitResultPR = catPr.split("\n");

			if(!splitResult[0].equals("")) {
				for(int i=0 ; i< splitResult.length ; i++) {
					map = new LinkedHashMap<String, String>();

					if(Double.parseDouble(splitResultPR[i]) >= matchProb ) {
						map.put("category", splitResult[i]);
						String cateGpath=splitResult[i].split("@#")[0];
						String cateGname=splitResult[i].split("@#")[1];
						String cmsCategid=splitResult[i].split("@#")[2];
						String sgId=splitResult[i].split("@#")[3];
						String sgName=splitResult[i].split("@#")[4];
						map.put("pr", splitResultPR[i]);
						map.put("cateGpath", cateGpath);
						map.put("cateGname", cateGname);
						map.put("cmsCategid", cmsCategid);
						map.put("sgId", sgId);
						map.put("sgName", sgName);
						map.put("choice_type", "DQCAT01");
					}
					
					if(i==splitResult.length-1) {
						map.put("searchTerm", searchTerm);
						map.put("sParam01", sParam01);
						map.put("sParam02", sParam02);
						map.put("sParam03", sParam03);
						map.put("sParam04", sParam04);
						map.put("sParam05", sParam05);
					}
					list.add(i,map);
				}
			} else {
					map.put("searchTerm", searchTerm);
					map.put("sParam01", sParam01);
					map.put("sParam02", sParam02);
					map.put("sParam03", sParam03);
					map.put("sParam04", sParam04);
					map.put("sParam05", sParam05);
			}
			
			return list;
		}
	}
}
