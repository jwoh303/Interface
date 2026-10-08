package com.koreab2b.mro.manager.menu.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.googlecode.ehcache.annotations.Cacheable;
import com.googlecode.ehcache.annotations.TriggersRemove;
import com.koreab2b.mro.manager.menu.domain.Menu;

@Repository("menuDao")
@Transactional
public class MenuDaoImpl implements MenuDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Cacheable(cacheName = "managerCache")
	public List<Menu> selectMenus() {
		return sqlSessionTemplate.selectList("menu.selectMenus");
	}
	
	@Cacheable(cacheName = "managerCache")
	public List<Menu> selectMenus2(String authId) {
		return sqlSessionTemplate.selectList("menu.selectMenus2", authId);
	}
	@Cacheable(cacheName = "managerCache")
	public List<Menu> selectMenus3(String authId) {
		return sqlSessionTemplate.selectList("menu.selectMenus3", authId);
	}	
	
	
	@Cacheable(cacheName = "managerCache") 
	public List<Menu> selectMenus2_v2(String authId) {
		return sqlSessionTemplate.selectList("menu.selectMenus2_v2", authId);
	}
	@Cacheable(cacheName = "managerCache")
	public List<Menu> selectMenus3_v2(String authId) {
		return sqlSessionTemplate.selectList("menu.selectMenus3_v2", authId);
	}	
	@Cacheable(cacheName = "managerCache")
	public List<Menu> selecLefttMenus(String pAuthId) {
		return sqlSessionTemplate.selectList("menu.selecLefttMenus",pAuthId);
	}

	@Cacheable(cacheName = "managerCache")
	public List<Menu> selectMenusForSecurity() {
		return sqlSessionTemplate.selectList("menu.selectMenusForSecurity");
	}

	@Cacheable(cacheName = "managerCache")
	public List<Menu> selectMenusByAuths(List<String> pAuths) {
		return sqlSessionTemplate.selectList("menu.selectMenusByAuths", pAuths);
	}

	public Menu selectMenuByMenuId(String pMenuId) {
		return sqlSessionTemplate.selectOne("menu.selectMenuByMenuId", pMenuId);
	}

	@TriggersRemove(cacheName = "managerCache", removeAll=true)
	public void insertMenu(Menu pMenu) {
		sqlSessionTemplate.insert("menu.insertMenu", pMenu);
	}

	@TriggersRemove(cacheName = "managerCache", removeAll=true)
	public void updateMenu(Menu pMenu) {
		sqlSessionTemplate.update("menu.updateMenu", pMenu);
	}
	
	@TriggersRemove(cacheName = "managerCache", removeAll=true)
	public void deleteMenu(String pMenuId) {
		sqlSessionTemplate.delete("menu.deleteMenuByMenuId", pMenuId);
	}

	public List<Menu> selectMenuByUpper(String pUpper) {
		return sqlSessionTemplate.selectList("menu.selectUpperMenuByUpperMenuId", pUpper);
	}

	public List<String> selectUpperMenuIds() {
		return sqlSessionTemplate.selectList("menu.selectUpperMenuIds");
	}
	
	public List<Map<String, String>>  getMainCateList_v2(Map<String,String>  pMap){
		pMap.put("type", "URCT");
		String _cnt = (String)sqlSessionTemplate.selectOne("buyer.mdcm.getSpecialCategUserBoolean", pMap);
		if(Integer.parseInt(_cnt) > 0){
			return sqlSessionTemplate.selectList("menu.getMainCateList_v2",pMap);
		}
		pMap.put("type", "URCT2");
		String _cnt2 = (String)sqlSessionTemplate.selectOne("buyer.mdcm.getSpecialCategUserBoolean", pMap);
		if(Integer.parseInt(_cnt2) > 0){
			return sqlSessionTemplate.selectList("menu.getMainCateList_v2",pMap);
		}
		
		pMap.put("type", "");
		return sqlSessionTemplate.selectList("menu.getMainCateList_v2",pMap);
	}

}
