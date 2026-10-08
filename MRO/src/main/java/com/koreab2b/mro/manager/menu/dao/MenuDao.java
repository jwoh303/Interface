package com.koreab2b.mro.manager.menu.dao;

import java.util.List;
import java.util.Map;

import com.koreab2b.mro.manager.menu.domain.Menu;

public interface MenuDao {
	List<Menu> selectMenus();
	List<Menu> selectMenus2(String authId);
	List<Menu> selectMenus3(String authId);
	List<Menu> selectMenus2_v2(String authId);
	List<Menu> selectMenus3_v2(String authId);
	List<Menu> selecLefttMenus(String pAuthId);
	
	List<Menu> selectMenusForSecurity();
	
	List<Menu> selectMenusByAuths(List<String> pAuths);

	Menu selectMenuByMenuId(String pMenuId);

	void insertMenu(Menu pMenu);

	void updateMenu(Menu pMenu);

	void deleteMenu(String pMenuId);
	
	List<Menu>  selectMenuByUpper(String pUpper);
	
	List<String> selectUpperMenuIds();
	
	public List<Map<String, String>>  getMainCateList_v2(Map<String,String>  pMap);
}
