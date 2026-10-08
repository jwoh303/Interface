package com.koreab2b.mro.master.mdcm.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import m2.context.msg.protocol.query.Query;
import m2.context.msg.protocol.query.QuerySet;
import m2.context.msg.protocol.result.Result;
import m2.context.msg.protocol.result.ResultSet;
import m2.earth.command.CommandSearchRequest;
import m2.earth.util.EarthException;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCmCatlgRcmdDao")
@Transactional
public class MasterMdCmCatlgRcmdDaoImpl implements MasterMdCmCatlgRcmdDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCatlgRcmdDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 업로드 후 조회
	public List<Map<String,String>> selectUploadList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectUploadMasterMdCmCatlgRcmdList", param);
	}
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCatlgRcmdList", param);
	}

	// BNTTRXL 저장
	@SuppressWarnings("unchecked")
	public String updateUploadData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 저장되었습니다.";
		
		try{
			// STEP1 - INSERT 전 본인 기존 등록건 삭제
			sqlSessionTemplate.update("master.mdcm.initBntTrxlMasterMdCmCatlgRcmdUplolad", formData);
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP2 - BNTTRXL INSERT
				sqlSessionTemplate.update("master.mdcm.setBntTrxlMasterMdCmCatlgRcmdUplolad", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 추천
	@SuppressWarnings("unchecked")
	public String updateData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "정상적으로 저장되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				String recommendSize = formData.get("catlg_target_count"); //return할 카탈로그 갯수, maximum : 20
				String matchProb = formData.get("catlg_target_rate"); //정확도
				
				String searchTermDes= formData.get("DESCRIPTION"); //카탈로그를 추천받을 검색어
		        String searchTermSpec= formData.get("SPECIFICATION"); //카탈로그를 추천받을 검색어
		        String searchTermMnm= formData.get("MAKER_NAME"); //카탈로그를 추천받을 검색어
		        String searchTermMpn= formData.get("MODEL_PART_NO"); //카탈로그를 추천받을 검색어
		        
		        String desc_flag = formData.get("catlg_desc_flag"); //조회조건으로 사용여부
		        String spec_flag = formData.get("catlg_spec_flag"); //조회조건으로 사용여부
		        String maker_flag = formData.get("catlg_maker_flag"); //조회조건으로 사용여부
		        String model_flag = formData.get("CATLG_MODEL_FLAG"); //조회조건으로 사용여부
				
		        String sParam01 = "sParam01Val";
		        String sParam02 = "sParam02Val";
		        String sParam03 = "sParam03Val";
		        String sParam04 = "sParam04Val";
		        String sParam05 = "sParam05Val";
		        
				String adminIp = formData.get("adminIp");
				String adminPort = formData.get("adminPort");
				String collectionName = formData.get("collentionRealName");
				
				HashMap<String, String> catParam = new HashMap<String, String>();
				catParam.put("recommendSize", recommendSize);
				catParam.put("matchProb", matchProb);
				
				catParam.put("adminIp", adminIp);
				catParam.put("adminPort", adminPort);
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
		        
				List<HashMap<String, String>> list = getCatlgAutoCategorizer(catParam);
				HashMap<String, String> map = null;
				
				for (int k=0 ; k < list.size() ; k++){
					map = list.get(k);
					// 리턴 시 순위별 정보 입력 위해(ex 리턴수 5 = 순위별로 cmsCatlgId1~cmsCatlgId5에 세팅)
					int j=k+1;

					formData.put("cmsCatlgId"+j, CommonUtil.nvl2(map.get("cmsCatlgId"), ""));
					formData.put("desc"+j, CommonUtil.nvl2(map.get("desc"), ""));
					formData.put("spec"+j, CommonUtil.nvl2(map.get("spec"), ""));
					formData.put("makerCode"+j, CommonUtil.nvl2(map.get("makerCode"), ""));
					formData.put("makerName"+j, CommonUtil.nvl2(map.get("makerName"), ""));
					formData.put("originCode"+j, CommonUtil.nvl2(map.get("originCode"), ""));
					formData.put("originName"+j, CommonUtil.nvl2(map.get("originName"), ""));
					formData.put("unitMeasure"+j, CommonUtil.nvl2(map.get("unitMeasure"), ""));
					formData.put("itemGubun"+j, CommonUtil.nvl2(map.get("itemGubun"), ""));
					formData.put("sgId"+j, CommonUtil.nvl2(map.get("sgId"), ""));
					formData.put("sgName"+j, CommonUtil.nvl2(map.get("sgName"), ""));
					formData.put("imgfileDir"+j, CommonUtil.nvl2(map.get("imgfileDir"), ""));
					formData.put("imgfileName"+j, CommonUtil.nvl2(map.get("imgfileName"), ""));
					formData.put("pr"+j, CommonUtil.nvl2(map.get("pr"), ""));
					formData.put("choice_type"+j, CommonUtil.nvl2(map.get("choice_type"), ""));
					
					sqlSessionTemplate.update("master.mdcm.updateBntTrxlMasterMdCmCatlgRcmd", formData);
				}
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	public List<HashMap<String, String>> getCatlgAutoCategorizer(HashMap<String, String> catParam) {
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
		String CATLG_PATH = "";
		String searchTerm = "";
		
		String adminIp = catParam.get("adminIp");
		String adminPort = catParam.get("adminPort");
		
		if(desc_flag.equals("true") && spec_flag.equals("true") && maker_flag.equals("true") && model_flag.equals("true")) {
			CATLG_PATH = "TOTAL";
			searchTerm = searchTermDes+"\t"+searchTermSpec+"\t"+searchTermMnm+"\t"+searchTermMpn;
		} else if (desc_flag.equals("true") && spec_flag.equals("false") && maker_flag.equals("false") && model_flag.equals("false")) {
			CATLG_PATH = "DESC";
			searchTerm = searchTermDes;
		} else if (desc_flag.equals("false") && spec_flag.equals("true") && maker_flag.equals("false") && model_flag.equals("false")) {
			CATLG_PATH = "SPEC";
			searchTerm = searchTermSpec;
		} else if (desc_flag.equals("false") && spec_flag.equals("false") && maker_flag.equals("true") && model_flag.equals("false")) {
			CATLG_PATH = "MN";
			searchTerm = searchTermMnm;
		} else if (desc_flag.equals("false") && spec_flag.equals("false") && maker_flag.equals("false") && model_flag.equals("true")) {
			CATLG_PATH = "MPN";
			searchTerm = searchTermMpn;
		} else if (desc_flag.equals("true") && spec_flag.equals("true") && maker_flag.equals("false") && model_flag.equals("false")) {
			CATLG_PATH = "DESC_SPEC";
			searchTerm = searchTermDes+"\t"+searchTermSpec;
		} else if (desc_flag.equals("true") && spec_flag.equals("false") && maker_flag.equals("true") && model_flag.equals("false")) {
			CATLG_PATH = "DESC_MN";
			searchTerm = searchTermDes+"\t"+searchTermMnm;
		} else if (desc_flag.equals("true") && spec_flag.equals("false") && maker_flag.equals("false") && model_flag.equals("true")) {
			CATLG_PATH = "DESC_MPN";
			searchTerm = searchTermDes+"\t"+searchTermMpn;
		} else if (desc_flag.equals("false") && spec_flag.equals("true") && maker_flag.equals("true") && model_flag.equals("false")) {
			CATLG_PATH = "SPEC_MN";
			searchTerm = searchTermSpec+"\t"+searchTermMnm;
		} else if (desc_flag.equals("false") && spec_flag.equals("true") && maker_flag.equals("false") && model_flag.equals("true")) {
			CATLG_PATH = "SPEC_MPN";
			searchTerm = searchTermSpec+"\t"+searchTermMpn;
		} else if (desc_flag.equals("false") && spec_flag.equals("false") && maker_flag.equals("true") && model_flag.equals("true")) {
			CATLG_PATH = "MPN_MN";
			searchTerm = searchTermMpn+"\t"+searchTermMnm;
		} else if (desc_flag.equals("true") && spec_flag.equals("true") && maker_flag.equals("true") && model_flag.equals("false")) {
			CATLG_PATH = "DESC_SPEC_MN";
			searchTerm = searchTermDes+"\t"+searchTermSpec+"\t"+searchTermMnm;
		} else if (desc_flag.equals("true") && spec_flag.equals("true") && maker_flag.equals("false") && model_flag.equals("true")) {
			CATLG_PATH = "DESC_SPEC_MPN";
			searchTerm = searchTermDes+"\t"+searchTermSpec+"\t"+searchTermMpn;
		} else if (desc_flag.equals("true") && spec_flag.equals("false") && maker_flag.equals("true") && model_flag.equals("true")) {
			CATLG_PATH = "DESC_MN_MPN";
			searchTerm = searchTermDes+"\t"+searchTermMnm+"\t"+searchTermMpn;
		} else if (desc_flag.equals("false") && spec_flag.equals("true") && maker_flag.equals("true") && model_flag.equals("true")) {
			CATLG_PATH = "SPEC_MN_MPN";
			searchTerm = searchTermSpec+"\t"+searchTermMnm+"\t"+searchTermMpn;
		}
		
		QuerySet querySet = new QuerySet(1);
		Query query = new Query();
		query.setFrom(catParam.get("collectionName"));
		query.setValue("search", "false"); 
		query.setValue("debug", "true");
		query.setResultModifier("category");
		query.setValue("category", CATLG_PATH+" 0 " +(Integer.parseInt(catParam.get("recommendSize"))-1));
		
		query.setValue("catKeyword", searchTerm); //카탈로그를 추천받을 검색어 설정
		query.setValue("catOption", "2"); //카탈로그 추천 로직 설정
		query.setValue("printQuery", "true"); //DQCAT 로그 노출 여부 설정 true/false 
		querySet.addQuery(query);

		logger.debug("접속 시작 (" + CATLG_PATH + ") : 품명 : " + searchTermDes + ", 규격 : " + searchTermSpec + ", 제조사 : " + searchTermMnm + ", 모델명 : " + searchTermMpn);
		CommandSearchRequest csr = new CommandSearchRequest(adminIp, Integer.parseInt(adminPort));
		logger.debug("접속 종료 : " + "품명 : " + searchTermDes + ", 규격 : " + searchTermSpec + ", 제조사 : " + searchTermMnm + ", 모델명 : " + searchTermMpn);
		
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
						String cmsCatlgId=splitResult[i].split("@#", -1)[0];
						String desc=splitResult[i].split("@#", -1)[1];
						String spec=splitResult[i].split("@#", -1)[2];
						String makerCode=splitResult[i].split("@#", -1)[3];
						String makerName=splitResult[i].split("@#", -1)[4];
						String originCode=splitResult[i].split("@#", -1)[5];
						String originName=splitResult[i].split("@#", -1)[6];
						String unitMeasure=splitResult[i].split("@#", -1)[7];
						String itemGubun=splitResult[i].split("@#", -1)[8];
						String sgId=splitResult[i].split("@#", -1)[9];
						String sgName=splitResult[i].split("@#", -1)[10];
						String imgfileDir=splitResult[i].split("@#", -1)[11];
						String imgfileName=splitResult[i].split("@#", -1)[12];
						map.put("pr", splitResultPR[i]);
						map.put("cmsCatlgId", cmsCatlgId);
						map.put("desc", desc);
						map.put("spec", spec);
						map.put("makerCode", makerCode);
						map.put("makerName", makerName);
						map.put("originCode", originCode);
						map.put("originName", originName);
						map.put("unitMeasure", unitMeasure);
						map.put("itemGubun", itemGubun);
						map.put("sgId", sgId);
						map.put("sgName", sgName);
						map.put("imgfileDir", imgfileDir);
						map.put("imgfileName", imgfileName);
						map.put("choice_type", "DQCAT02");
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
			
			logger.debug("요청 파라미터 : map {}", map);
			
			return list;
		}
	}
}

