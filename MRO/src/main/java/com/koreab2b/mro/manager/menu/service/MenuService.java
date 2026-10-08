package com.koreab2b.mro.manager.menu.service;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.manager.menu.domain.Menu;

public interface MenuService {
	
	List<Menu> getMenus();
	List<Menu> getMenus(String userId);

	String getMenusByAuths(List<String> pAuths, String pPart,String ptUpperId,String pUpperId, List<String> pRole,String pScript,String authId,String empNo,String userId, String userName, String AdimFlag);
	
	String getLeftMenusByAuths(List<String> pAuths, String pPart,String userId);
	
	String getLeftMenusByNotExistsAuths(List<String> pAuths, String pPart,String userId);

	Menu getMenu(String pMenuId);

	void saveMenu(Menu pMenu);

	void deleteMenu(String[] pMenuId);

	List<Menu> getMenuByUpper(String pUpper);

	List<String> getUpperMenuIds();

	Map<String, List<Menu>> getMenusDividedByMenuId();
	
	String getBuyerMainMenu(List<String> pAuths, String pPart,String ptUpperId,String pUpperId, List<String> pRoles, String authId);
	
	public String  getMainCateList_v2(Map<String,String>  pMap);
}
