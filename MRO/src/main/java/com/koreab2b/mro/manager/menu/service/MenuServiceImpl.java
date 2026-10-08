package com.koreab2b.mro.manager.menu.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.SerializationUtils;

import com.koreab2b.mro.manager.menu.dao.MenuDao;
import com.koreab2b.mro.manager.menu.domain.Menu;
import com.koreab2b.mro.manager.menu.domain.Root;
import com.koreab2b.mro.util.CommonUtil;

import biz.source_code.base64Coder.Base64Coder;

@Service("menuService")
public class MenuServiceImpl implements MenuService {
	
	@Autowired
	private MenuDao menuDao;

	
	public List<Menu> getMenus() {
		return menuDao.selectMenus();
	}
	
	public List<Menu> getMenus(String authId) {
		return menuDao.selectMenus2(authId);
	}

	public Menu getMenu(String pMenuId) {
		return menuDao.selectMenuByMenuId(pMenuId);
	}

	
	public String getMenusByAuths(List<String> pAuths, String pPart,String ptUpperId,String pUpperId, List<String> pRoles, String pScript,String authId,String empNo,String userId,String userName, String AdimFlag) {

		/**
		 * header  협력사메인,협력사세부
		 * masterMainHeader 운영사메인
		 * masterHeader 운영사세부
		 * 고객사는 header 이미지로 고정
		 */
		if("header".equals(pPart) || "header_v2".equals(pPart) || "buyerHeader_v2".equals("pPart")){
			return buildSellerHeaderMenu(getHeaderMenusByAuths(pAuths,pPart, pUpperId,authId));
		}  else if("eheader".equals(pPart)){//수출시스템 메뉴 생성.
				return buildExportHeaderMenu(getHeaderMenusByAuths(pAuths,pPart, pUpperId,authId));
		}  else if ( "masterMainHeader".equals(pPart)){
			return buildKepHeaderMenu(getHeaderMenusByAuths(pAuths,pPart, ptUpperId,authId), empNo, userId, userName, AdimFlag);
		}  else if ( "masterHeader".equals(pPart)){
			if("Y".equals(pScript)){
				return buildHeaderScriptMenu(getHeaderMenusByAuths(pAuths,pPart, ptUpperId,authId));
			}else{
				return buildHeaderMenu(getHeaderMenusByAuths(pAuths,pPart, ptUpperId,authId),AdimFlag);
			}
		}  else if ( "navi".equals(pPart)){
			return getNaviMenusByAuths(pAuths, pRoles,authId, AdimFlag);
		}
		return getMenusByAuths(pAuths, pRoles,authId, AdimFlag).buildMenu(pPart);
	}


	private String buildHeaderMenu(List<Menu> _pList, String AdimFlag){
		return buildKepHeaderMenu(_pList, "","","",AdimFlag);
	}
	private String buildKepHeaderMenu(List<Menu> _pList, String _empNo, String _userId, String userName, String AdimFlag){
		StringBuilder _sb = new StringBuilder();
		String _tmpUrl = "";
		_sb.append("<ul class='header_mainGnb'>");
	    for (int i=0; i<_pList.size(); i++){
	    	Menu _menu =_pList.get(i);
	    	_sb.append("<li>"); 
			_tmpUrl = "?upperId="+_menu.getTopMenuId();
			
			// 나의 주요업무는 스크립트호출하므로 예외처리
			if("m00201100000".equals(_menu.getTopMenuId())){
				_sb.append("<a href='" + _menu.getUrl() + "'>");
			}else if("m00400000000".equals(_menu.getTopMenuId())){
				_tmpUrl = "?st_link_gubun=KMS&st_emp_no="+_empNo+"&st_datetime="+CommonUtil.getCurrentDay_Time("YYYYMMDDHH");
				_sb.append("<a href='javascript:openSearchPopup(\"" + _menu.getUrl() +"\",\""+ _tmpUrl+"\",\"1000,750,no\");'>");
			}else if("m00600000000".equals(_menu.getTopMenuId())){
				if((_userId != null && _userId != "") && (userName != null && userName != "")){
					byte[] userIdBytes =  _userId.getBytes();
					byte[] userNameBytes =  userName.getBytes();
					String userIdEncrypted = new String(Base64Coder.encode(userIdBytes));
					String userNameEncrypted = new String(Base64Coder.encode(userNameBytes));
					_tmpUrl = "?encryptGrade=1&encryptId="+userIdEncrypted+"&encryptName="+userNameEncrypted;
					_sb.append("<a href='javascript:openSearchPopup(\"" + _menu.getUrl() +"\",\""+ _tmpUrl+"\",\"1000,700,no\");'>");
				}
			} else {
				_sb.append("<a href='javascript:kep_view_link(\"" + _menu.getUrl() + _tmpUrl+"\");'>");	
			}
			
			_sb.append(_menu.getName());
			_sb.append("</a>");
			
	    	_sb.append("</li>");
	    }
	    _sb.append("</ul>");
		return _sb.toString();
	}
	private String buildHeaderScriptMenu(List<Menu> _pList){
		StringBuilder _sb = new StringBuilder();
		
		_sb.append("<ul class='header_mainGnb'>");
	    for (int i=0; i<_pList.size(); i++){
	    	Menu _menu =_pList.get(i);
	    	_sb.append("<li>"); 
			
			// 나의 주요업무는 스크립트호출하므로 예외처리
			if("m00201100000".equals(_menu.getTopMenuId())){
				_sb.append("<a href='" + _menu.getUrl() +"'>");
			} else {
				_sb.append("<a href='javascript:selectSubMenu(\""+_menu.getTopMenuId()+"\");'>");	
			}
			
			_sb.append(_menu.getName());
			_sb.append("</a>");
			
	    	_sb.append("</li>");
	    }
	    _sb.append("</ul>");
		return _sb.toString();
	}
	private String buildExportHeaderMenu(List<Menu> _pList){
		StringBuilder _sb = new StringBuilder();
		
		String _tmpUrl = "";
		_sb.append("<ul>");
	    for (int i=0; i<_pList.size(); i++){
	    	Menu _menu =_pList.get(i);
	    	_sb.append("<li>"); 
			_tmpUrl = "?upperId="+_menu.getTopMenuId()+"&menuShow=N";
			
			_sb.append("<a href='javascript:kep_view_link(\"" + _menu.getUrl() + _tmpUrl+"\");'>");
			
			_sb.append(_menu.getName());
			_sb.append("</a>");
			
	    	_sb.append("</li>");
	    }
	    _sb.append("</ul>");
		return _sb.toString();
	}
	private String buildSellerHeaderMenu(List<Menu> _pList){ //이부분 확인(기존꺼로 돌릴껀지)
StringBuilder _sb = new StringBuilder();
		
		String _tmpUrl = "";
		_sb.append("<ul>");
	    for (int i=0; i<_pList.size(); i++){
	    	Menu _menu =_pList.get(i);
	    	_sb.append("<li>"); 
			_tmpUrl = "?upperId="+_menu.getTopMenuId()+"&menuShow=Y";
			
			_sb.append("<a href='javascript:kep_view_link(\"" + _menu.getUrl() + _tmpUrl+"\");'>");
			
			_sb.append(_menu.getName());
			_sb.append("</a>");
			
	    	_sb.append("</li>");
	    }
	    _sb.append("</ul>");
		return _sb.toString();
	}
	
	public String getLeftMenusByAuths(List<String> pAuths, String pPart,String userId){ 
			return getLeftHeaderMenusByAuths(pAuths,pPart,userId);
	}
	public String getLeftMenusByNotExistsAuths(List<String> pAuths, String pPart,String userId){ 
		return getLeftHeaderMenusByNotExistsAuths(pAuths,pPart,userId);
}
	
	@SuppressWarnings("unchecked")
	public Root getMenusByAuths(List<String> pAuths, List<String> pRoles,String authId, String AdimFlag) {
		Root _menu = new Root();
		List<Menu> _menus= null;
		if(AdimFlag.equals("N")){
			_menus =menuDao.selectMenus3(authId);	
		}else{
		    _menus =menuDao.selectMenus2(authId);	
		}
		byte[] _byteMenus = SerializationUtils.serialize(_menus);
		List<Menu> _copyMenus = (List<Menu>) SerializationUtils.deserialize(_byteMenus);
		
		for (Menu _tmpMenu : _copyMenus) {
			for (String _tmpAuthId : pAuths) {
				if (_tmpMenu.getAuthId().equals(_tmpAuthId) && _tmpMenu.getRoleId().equals("N")) {
					_menu.add(_tmpMenu);
				}else if(!_tmpMenu.getRoleId().equals("N")){
					for (String _tmpRoleId : pRoles) {
						if (_tmpMenu.getAuthId().equals(_tmpAuthId) && _tmpMenu.getRoleId().indexOf(_tmpRoleId) > -1) {
							_menu.add(_tmpMenu);
						}
					}
				}
			}
		}
		return _menu;
	}
	@SuppressWarnings("unchecked")
	public String getNaviMenusByAuths(List<String> pAuths, List<String> pRoles,String authId, String AdimFlag) {
		Root _menu = new Root();
		List<Menu> _menus= null;
		String mainTitle = "";
		String mainLink = "";
		String mainMenuId = "";
		String subTitle = "";
		String subLink = "";
		String subMenuId = "";
		String returnString = "";
		if(AdimFlag.equals("N")){
			_menus =menuDao.selectMenus3_v2(authId);	
		}else{
		    _menus =menuDao.selectMenus2_v2(authId);	
		}
		byte[] _byteMenus = SerializationUtils.serialize(_menus);
		List<Menu> _copyMenus = (List<Menu>) SerializationUtils.deserialize(_byteMenus);
		
		//navi 만들기
		String checkUpperId = "";
		ArrayList<String> titleArray = new ArrayList<String>();	
		ArrayList<String> linkArray = new ArrayList<String>();
		ArrayList<String> menuIdArray = new ArrayList<String>();
		
		int checkIndex = 0;
		for (Menu _tmpMenu : _copyMenus) {
			for (String _tmpAuthId : pAuths) {
				if (_tmpMenu.getAuthId().equals(_tmpAuthId) && _tmpMenu.getRoleId().equals("N")) {
					if(_tmpMenu.getDepth() == 1){ //depth 1,2 만 가져옴
						checkUpperId = _tmpMenu.getUpperId();
						mainTitle = mainTitle +"\""+ _tmpMenu.getName()+"\",";
						mainLink = mainLink + "\"" + _tmpMenu.getUrl()+"\",";
//						mainMenuId = mainMenuId + "\"" + _tmpMenu.getMenuId()+"\",";
					}else if (_tmpMenu.getDepth() == 2){
						if(!checkUpperId.equals(_tmpMenu.getUpperId())){
							checkUpperId = _tmpMenu.getUpperId();
							if(checkIndex != 0){
								subTitle = subTitle + titleArray.toString() + ",";
								subLink = subLink + linkArray.toString() + ",";
								subMenuId = subMenuId + menuIdArray.toString() + ",";
								titleArray.clear();
								linkArray.clear();
								menuIdArray.clear();
							}
							checkIndex ++;

							titleArray.add("\""+_tmpMenu.getName()+"\"");
							linkArray.add("\""+_tmpMenu.getUrl()+"\"");
							menuIdArray.add("\""+_tmpMenu.getMenuId()+"\"");
							mainMenuId = mainMenuId + "\"" + _tmpMenu.getMenuId()+"\",";
						}else{
							titleArray.add("\""+_tmpMenu.getName()+"\"");
							linkArray.add("\""+_tmpMenu.getUrl()+"\"");
							menuIdArray.add("\""+_tmpMenu.getMenuId()+"\"");
						}
					}
				}else if(!_tmpMenu.getRoleId().equals("N")){
					for (String _tmpRoleId : pRoles) {
						if (_tmpMenu.getAuthId().equals(_tmpAuthId) && _tmpMenu.getRoleId().indexOf(_tmpRoleId) > -1) {
							if(_tmpMenu.getDepth() == 1){//depth 1,2 만 가져옴
								checkUpperId = _tmpMenu.getUpperId();
								mainTitle = mainTitle +"\""+ _tmpMenu.getName()+"\",";
								mainLink = mainLink + "\"" + _tmpMenu.getUrl()+"\",";
//								mainMenuId = mainMenuId + "\"" + _tmpMenu.getMenuId()+"\",";
							}else if (_tmpMenu.getDepth() == 2){
								if(!checkUpperId.equals(_tmpMenu.getUpperId())){
									checkUpperId = _tmpMenu.getUpperId();
									if(checkIndex != 0){
										subTitle = subTitle + titleArray.toString() + ",";
										subLink = subLink + linkArray.toString() + ",";
										subMenuId = subMenuId + menuIdArray.toString() + ",";
										titleArray.clear();
										linkArray.clear();
										menuIdArray.clear();
									}
									checkIndex ++;

									titleArray.add("\""+_tmpMenu.getName()+"\"");
									linkArray.add("\""+_tmpMenu.getUrl()+"\"");
									menuIdArray.add("\""+_tmpMenu.getMenuId()+"\"");
									mainMenuId = mainMenuId + "\"" + _tmpMenu.getMenuId()+"\",";
									
								}else{
									titleArray.add("\""+_tmpMenu.getName()+"\"");
									linkArray.add("\""+_tmpMenu.getUrl()+"\"");
									menuIdArray.add("\""+_tmpMenu.getMenuId()+"\"");
								}
							}
						}
					}
				}
			}
		}
		
		subTitle += titleArray.toString();
		subLink += linkArray.toString();
		subMenuId += menuIdArray.toString();
		mainTitle = mainTitle.substring(0, mainTitle.length()-1);
		mainLink = mainLink.substring(0, mainLink.length()-1);
		mainMenuId = mainMenuId.substring(0, mainMenuId.length()-1);
//		returnString = mainTitle+"@"+mainLink+"@"+subTitle+"@"+subLink+"@";
		returnString = mainTitle+"@"+mainLink+"@"+mainMenuId+"@"+subTitle+"@"+subLink+"@"+subMenuId+"@";
		
		return returnString;
	}
	
	
	private String getLeftHeaderMenusByAuths(List<String> pAuths,String pPart,String authId) {
		String _menu = "";
		List<Menu> _menus = menuDao.selectMenus2(authId); 
		for (Menu _tmpMenu : _menus) { 
			for (String _tmpAuthId : pAuths) {
				if (_tmpMenu.getAuthId().equals(_tmpAuthId) && _tmpMenu.getMenuId().equals(pPart)) {
					_menu = _tmpMenu.getName();
					break;
				}
			}
		}
		return _menu;
	}
	private String getLeftHeaderMenusByNotExistsAuths(List<String> pAuths,String pPart,String authId) {
		String _menu = "";
		List<Menu> _menus = menuDao.selectMenus3(authId); 
		for (Menu _tmpMenu : _menus) { 
			for (String _tmpAuthId : pAuths) {
				if (_tmpMenu.getAuthId().equals(_tmpAuthId) && _tmpMenu.getMenuId().equals(pPart)) {
					_menu = _tmpMenu.getName();
					break;
				}
			}
		}
		return _menu;
	}
	private List<Menu> getHeaderMenusByAuths(List<String> pAuths,String pPart,String pUpperId,String authId) {
		List<Menu> _menus = new ArrayList<Menu>();
		if(pPart.equals("header_v2")){ //리뉴얼
			_menus = menuDao.selectMenus2_v2(authId);
		}else{
			_menus = menuDao.selectMenus2(authId);
		}
		List<Menu> _menusResult = new ArrayList<Menu>();
		int depth = 0;
	
		/**
		 * header  협력사메인,협력사세부 -> 메뉴 depth 1
		 * masterMainHeader 운영사메인 -> 메뉴 depth 0
		 * masterHeader 운영사세부 -> 메뉴 depth 1
		 * 고객사는 header 이미지로 고정 -> 메뉴 depth 1
		 */
		if ("masterMainHeader".equals(pPart)){
			depth = 0; // 운영사 main  header  0
		}else{
			depth = 1; // 일반 header 는 1
		}
		 
		if ("masterHeader".equals(pPart)){ // 운영사 header 는 메인 header 가 따로 있어서 upperid 를 이용하여 뿌린다. - 운영사1
			for (Menu _tmpMenu : _menus) {
				for (String _tmpAuthId : pAuths) { 
					if (_tmpMenu.getAuthId().equals(_tmpAuthId) && _tmpMenu.getDepth()==depth && _tmpMenu.getUpperId().startsWith(pUpperId)) {  
						_menusResult.add(_tmpMenu);
					}
				}
			} 
		}else{ // 그외 운영사0,고객사1,협력사1은 동일
			for (Menu _tmpMenu : _menus) {
				for (String _tmpAuthId : pAuths) { 
					if (_tmpMenu.getAuthId().equals(_tmpAuthId) && _tmpMenu.getDepth()==depth) {  
						_menusResult.add(_tmpMenu);
					}
				}
			} 
		}
		return _menusResult;
	}

	public void saveMenu(Menu pMenu) {
		Menu _menu = menuDao.selectMenuByMenuId(pMenu.getMenuId());
		if (_menu != null) {
			menuDao.updateMenu(pMenu);
		} else {
			menuDao.insertMenu(pMenu);
		}
	}

	public void deleteMenu(String[] pMenuId) {
		for (String _tmpMenuId : pMenuId) {
			menuDao.deleteMenu(_tmpMenuId);
		}
	}

	public List<Menu> getMenuByUpper(String pUpper) {
		return menuDao.selectMenuByUpper(pUpper);
	}

	public List<String> getUpperMenuIds() {
		return menuDao.selectUpperMenuIds();
	}

	public Map<String, List<Menu>> getMenusDividedByMenuId() {
		List<String> _upperMendIds = menuDao.selectUpperMenuIds();

		Map<String, List<Menu>> _dividedMenus = new HashMap<String, List<Menu>>();

		for (String _tmp : _upperMendIds) {
			_dividedMenus.put(_tmp, menuDao.selectMenuByUpper(_tmp));
		}

		return _dividedMenus;
	}
	/**
	 * 고객사 메인메뉴 생성
	 */
	public String getBuyerMainMenu(List<String> pAuths, String pPart,String ptUpperId,String pUpperId, List<String> pRoles, String authId) {

		return getMenusByAuths(pAuths, pRoles,authId, "N").buildMainMenu(pPart);
	}
	
	//고객사 카테고리
	public String  getMainCateList_v2(Map<String,String>  pMap){
		
		String categStr = "";
		String mainCateStr = ""; //대분류
		List<Map<String,String>> categList = menuDao.getMainCateList_v2(pMap);
		
		List<String> mainCateArray = new ArrayList<String>();
		Map<String,String> twoDepthNameTmp = new HashMap<String,String>();
		Map<String,String> threeDepthNameTmp = new HashMap<String,String>();
		Map<String,String> fourDepthNameTmp = new HashMap<String,String>();
		Map<String,String> twoDepthIdTmp = new HashMap<String,String>();
		Map<String,String> threeDepthIdTmp = new HashMap<String,String>();
		Map<String,String> fourDepthIdTmp = new HashMap<String,String>();
		
		if(categList.size()>0 && categList != null){
			for(int i = 0; i<categList.size(); i++){
				String categId = categList.get(i).get("STD_CATEG_ID");
				String categPid = categList.get(i).get("PID");
				String categName = "";
				String realCategName = categList.get(i).get("CATEG_NAME_REAL");
				String mainCategName = "";
				if(categList.get(i).get("CATEG_TYPE").equals("ITM")){
					categName = "\""+categList.get(i).get("CATEG_TYPE")+"#"+categId+"#"+realCategName+"#"+categList.get(i).get("CATEG_NAME").trim()+categList.get(i).get("CNT")+"\"";
					mainCategName = categList.get(i).get("CATEG_NAME").trim()+categList.get(i).get("CNT");
				}else{
					categName = "\""+categList.get(i).get("CATEG_TYPE")+"#"+categId+"#"+realCategName+"#"+categList.get(i).get("CATEG_NAME").trim()+"\"";
					mainCategName = categList.get(i).get("CATEG_NAME").trim();
				}
				
				
				//대분류 만들어주기
				if(String.valueOf(categList.get(i).get("DEPTH")).equals("1")){
					if(categList.get(i).get("CATEG_TYPE").equals("ITM")){
						mainCateStr = mainCateStr + "<div class=\"category-item\" data-mid=\"Cate"+categId+"\"><a href='javascript:kep_sel_h_getItmeList_v2(\""+categId+"\",\""+realCategName+"\")'>"+mainCategName+"</a><span class=\"arrow\"></span></div>";
					}else{
						mainCateStr = mainCateStr + "<div class=\"category-item\" data-mid=\"Cate"+categId+"\">"+mainCategName+"<span class=\"arrow\"></span></div>";
					}
					mainCateArray.add(categId);
				}
				if(String.valueOf(categList.get(i).get("DEPTH")).equals("2")){
					if(twoDepthNameTmp.get(categPid) == null){
						twoDepthNameTmp.put(categPid,categName);
						twoDepthIdTmp.put(categPid,categId);
					}else{
						twoDepthNameTmp.put(categPid,twoDepthNameTmp.get(categPid)+"@@"+categName);
						twoDepthIdTmp.put(categPid,twoDepthIdTmp.get(categPid)+"@@"+categId);
					}
					
				}
				if(String.valueOf(categList.get(i).get("DEPTH")).equals("3")){
					if(threeDepthNameTmp.get(categPid)== null){
						threeDepthNameTmp.put(categPid,categName);
						threeDepthIdTmp.put(categPid,categId);
					}else{
						threeDepthNameTmp.put(categPid,threeDepthNameTmp.get(categPid)+"@@"+categName);
						threeDepthIdTmp.put(categPid,threeDepthIdTmp.get(categPid)+"@@"+categId);
					}
				}
				if(String.valueOf(categList.get(i).get("DEPTH")).equals("4")){
					if(fourDepthNameTmp.get(categPid)== null){
						fourDepthNameTmp.put(categPid,categName);
						fourDepthIdTmp.put(categPid,categId);
					}else{
						fourDepthNameTmp.put(categPid,fourDepthNameTmp.get(categPid)+"@@"+categName);
						fourDepthIdTmp.put(categPid,fourDepthIdTmp.get(categPid)+"@@"+categId);
					}
				}
			}
			
			String subNameStr = "";
			for(int i = 0; i <mainCateArray.size(); i++){
				String cateId = mainCateArray.get(i);
				String tmpNameStr = "";
				String twoDepthCategName = twoDepthNameTmp.get(cateId);
				String twoDepthCategId = twoDepthIdTmp.get(cateId);
				if(twoDepthCategName != null){
					tmpNameStr = "Cate"+cateId+":{";
					String twoDepthNameArr[] = twoDepthCategName.split("@@");
					String twoDepthIdArr[] = twoDepthCategId.split("@@");
					for(int j = 0; j<twoDepthNameArr.length; j++){
						tmpNameStr =tmpNameStr+twoDepthNameArr[j]+": {";
						String threeDepthCategName = threeDepthNameTmp.get(twoDepthIdArr[j]);
						String threeDepthCategId = threeDepthIdTmp.get(twoDepthIdArr[j]);
						if(threeDepthCategName == null){
							tmpNameStr =tmpNameStr + "},";
						}else{
							String threeDepthNameArr[] = threeDepthCategName.split("@@");
							String threeDepthIdArr[] = threeDepthCategId.split("@@");
							for(int k = 0; k<threeDepthNameArr.length; k++){
								tmpNameStr = tmpNameStr+threeDepthNameArr[k]+": [";
								String fourDepthCategName = fourDepthNameTmp.get(threeDepthIdArr[k]);
								if(fourDepthCategName == null){
									
									tmpNameStr = tmpNameStr+"],";
								}else{
									tmpNameStr = tmpNameStr + fourDepthCategName+"],";
								}
								if(k == threeDepthNameArr.length-1){
									tmpNameStr = tmpNameStr.substring(0,tmpNameStr.length()-1);
									tmpNameStr = tmpNameStr+"},";
								}
							}
						}
						if(j == twoDepthNameArr.length-1){ // 마지막엔 ,빼주는 작업
							tmpNameStr = tmpNameStr.substring(0,tmpNameStr.length()-1);
							tmpNameStr = tmpNameStr+ "},";
						}
					}
				}else{
					tmpNameStr = "Cate"+cateId+":{},";
				}
				subNameStr = subNameStr + tmpNameStr;
			}
			subNameStr = subNameStr.substring(0,subNameStr.length()-1);
			subNameStr = subNameStr.replaceAll("@@", ",");
			categStr = mainCateStr+"@"+subNameStr;
			return categStr;
		}else{
			return "";
		}

		
	}
}
