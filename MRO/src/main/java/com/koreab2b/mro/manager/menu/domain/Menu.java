package com.koreab2b.mro.manager.menu.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@SuppressWarnings("serial")
public class Menu implements Serializable {

	private String menuId;
	private String upperId;
	private String name;
	private int depth;
	private String type;
	private String authId;
	private String url;
	private int menuOrder;
	private String menuDc;
	private String createDt;
	private String topMenuId;
	private String roleId;
	
	private List<Menu> menus = new ArrayList<Menu>();

	public Menu() {
	}

	public Menu(String pMenuId, String pUpperId, String pName, int pDepth, String pType, String pAuthId, String pUrl, int pMenuOrder, String pMenuDc) {
		menuId = pMenuId;
		upperId = pUpperId;
		name = pName;
		depth = pDepth;
		type = pType;
		authId = pAuthId;
		url = pUrl;
		menuOrder = pMenuOrder;
		menuDc = pMenuDc;
	}

	public int size() {
		return menus.size();
	}

	public void add(Menu pMenu) { 
		if (menuId.equals(pMenu.upperId)) {
			menus.add(pMenu);
			return;
		}

		Iterator<Menu> _iter = menus.iterator();
		while (_iter.hasNext()) {
			_iter.next().add(pMenu);
		}
	}
	
	
	public void headerAdd(Menu pMenu) {  

		Iterator<Menu> _iter = menus.iterator();
		while (_iter.hasNext()) {
			_iter.next().add(pMenu);
		}
	}
 
	
	public String build(int depth) {
		StringBuilder _sb = new StringBuilder();
		String _tmpUrl = ""; 
		_tmpUrl =(type.equals("tab"))?"": "?upperId="+topMenuId; 
		if (depth == 1 || depth == 2) {
			if ("tab".equals(type)){
				_sb.append("<p class='bigM' style='cursor:pointer;' onclick='" + url + _tmpUrl+"'><a href='" + url + _tmpUrl+"'>");
			}else{
				_sb.append("<p class='bigM' style='cursor:pointer;' onclick='javascript:kep_view_link(\"" + url + _tmpUrl+"\");'><a href='javascript:kep_view_link(\"" + url + _tmpUrl+"\");'>");	
			}
			_sb.append(name);
		}else if (depth == 3) {
			if ("tab".equals(type)){
				_sb.append("<p class='SubM' style='cursor:pointer;' onclick='" + url + _tmpUrl+"'><a href='" + url + _tmpUrl+"'>");
			}else{
				_sb.append("<p class='SubM' style='cursor:pointer;' onclick='javascript:kep_view_link(\"" + url + _tmpUrl+"\");'><a href='javascript:kep_view_link(\"" + url + _tmpUrl+"\");'>");
			}
			_sb.append(name);
		}else{
			if ("tab".equals(type)){
				_sb.append("<p style='cursor:pointer;' onclick='" + url + _tmpUrl+"'>└ <a href='" + url + _tmpUrl+"'>");
			}else{
				_sb.append("<p style='cursor:pointer;' onclick='javascript:kep_view_link(\"" + url + _tmpUrl+"\");'>└ <a href='javascript:kep_view_link(\"" + url + _tmpUrl+"\");'>");
			}
			_sb.append(name);
		}
		_sb.append("</a></p>");
		return _sb.toString();
	}
	
 

	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String pMenuId) {
		menuId = pMenuId;
	}

	public String getUpperId() {
		return upperId;
	}

	public void setUpperId(String pUpperId) {
		upperId = pUpperId;
	}

	public String getName() {
		return name;
	}

	public void setName(String pName) {
		name = pName;
	}

	public int getDepth() {
		return depth;
	}

	public void setDepth(int pDepth) {
		depth = pDepth;
	}

	public String getType() {
		return type;
	}

	public void setType(String pType) {
		type = pType;
	}

	public String getAuthId() {
		return authId;
	}

	public void setAuthId(String pAuthId) {
		authId = pAuthId;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String pUrl) {
		url = pUrl;
	}

	public int getMenuOrder() {
		return menuOrder;
	}

	public void setMenuOrder(int pMenuOrder) {
		menuOrder = pMenuOrder;
	}

	public String getMenuDc() {
		return menuDc;
	}

	public void setMenuDc(String pMenuDc) {
		menuDc = pMenuDc;
	}

	public String getCreateDt() {
		return createDt;
	}

	public void setCreateDt(String pCreateDt) {
		createDt = pCreateDt;
	}

	public List<Menu> getMenus() {
		return menus;
	}

	public void setMenus(List<Menu> pMenus) {
		menus = pMenus;
	}

	public String getTopMenuId() {
		return topMenuId;
	}

	public void setTopMenuId(String pTopMenuId) {
		topMenuId = pTopMenuId;
	}

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String pRoleId) {
		roleId = pRoleId;
	}
	public String mainMenuBuild(int depth) {
		StringBuilder _sb = new StringBuilder();
		String _tmpUrl = ""; 
		_tmpUrl =(type.equals("tab"))?"": "?upperId="+topMenuId; 
		if (depth == 2) {
			_sb.append("<h2><a href='javascript:kep_view_link(\"" + url + _tmpUrl+"\");'>");
			_sb.append(name);
			_sb.append("</a></h2>");
		}else if (depth == 3) {
			_sb.append("<li><a href='javascript:kep_view_link(\"" + url + _tmpUrl+"\");'>");
			_sb.append(name);
			_sb.append("</a></li>");
		}else{
			_sb.append("<li><p>- <a href='javascript:kep_view_link(\"" + url + _tmpUrl+"\");'>");
			_sb.append(name);
			_sb.append("</a></p></li>");
		}
		return _sb.toString();
	}
	
}
