package com.koreab2b.mro.manager.menu.domain;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Root {

	private final String UL_START = "<ul>";
	private final String UL_END = "</ul>";
	private final String LI_START = "<li>";
	private final String LI_END = "</li>";
	private final String CLASS_DEPTH2 = "class='lnb_li_2depth'";
	private final String CLASS_DEPTH3 = "class='lnb_ul_3depth'";

	private Menu root;

	public Root() {
		root = new Menu("root", "", "ROOT", 0, "folder", "ROLE_ANONYMOUS", "#", 0, "최상위");
	}

	public void setRoot(Menu pMenu){
		root = pMenu;
	}
	
	public void add(Menu pMenu) {
		root.add(pMenu);
	}

	public void addAll(List<Menu> pList) {
		Iterator<Menu> _iter = pList.iterator();
		while (_iter.hasNext()) {
			add(_iter.next());
		}
	}

	public String buildMenu() {
		StringBuilder _sb = new StringBuilder();
		_sb.append(UL_START);
		_sb.append(buildMenu(root));
		_sb.append(UL_END);
		return _sb.toString();
	}
	
	public Menu getByMenuId(Menu pMenu, String pMenuId) {
		if (pMenu.getMenuId().equals(pMenuId)) {
			return pMenu;
		}

		Iterator<Menu> _iter = pMenu.getMenus().iterator();
		while (_iter.hasNext()) {
			pMenu = getByMenuId(_iter.next(), pMenuId); 
			if (pMenu.getMenuId().equals(pMenuId)) {
				return pMenu;
			}
		}

		return pMenu;
	}
	
	public String buildMenu(String pMenu) {
		
		if(pMenu.equals("root")){
			return buildMenu();
		}
		Menu _menu = getByMenuId(root,pMenu);
		
		if (_menu != null) {
			return buildMenu(_menu);
		}

		return "";
	}

	public String buildMenu(Menu pMenu) {
		StringBuilder _sb = new StringBuilder();
		Iterator<Menu> _iter = pMenu.getMenus().iterator();
		
		int depth = pMenu.getDepth();
			
		if (pMenu.getType().equals("menu")||pMenu.getType().equals("tab")) {
			if(depth ==1){
				_sb.append(""); 
			}else if(depth == 2){
				_sb.append(LI_START.replace("li", "li "+ CLASS_DEPTH2));
			}else if(depth == 3 && "#".equals(pMenu.getUrl())){
				_sb.append(LI_START);
			}else if(depth == 4 && "#".equals(pMenu.getUrl())){
				_sb.append(LI_START);
			}else {
				_sb.append(LI_START);
			}
			
			
			
			if(depth ==1){
				_sb.append(""); 
			}else{
				
				_sb.append(pMenu.build(depth));				
				if (pMenu.getMenus().size() > 0){
						if(depth == 2 && "#".equals(pMenu.getUrl())){
							_sb.append(UL_START.replace("ul", "ul "+ CLASS_DEPTH3));
						}else{
							_sb.append(UL_START);
						}						
					}
				}
			}
	
			while (_iter.hasNext()) {
				_sb.append(buildMenu(_iter.next()));
			}
			
			if(depth ==1){
				_sb.append(""); 
			}else{
				if (pMenu.getType().equals("menu")||pMenu.getType().equals("tab")) {
					if (pMenu.getMenus().size() > 0)
						_sb.append(UL_END);
					_sb.append(LI_END);
				}
			}
		
		return _sb.toString();
	}

	public static void main(String[] args) {
		List<Menu> _list = new ArrayList<Menu>();
		_list.add(new Menu("4", "1", "공지사항", 0, "menu", "ROLE_ANONYMOUS", "#", 1, ""));
		_list.add(new Menu("13", "1", "문의사항", 1, "menu", "ROLE_ANONYMOUS", "#", 1, ""));
		_list.add(new Menu("8", "3", "제품등록", 0, "menu", "ROLE_ANONYMOUS", "#", 1, ""));
		_list.add(new Menu("7", "3", "제품삭제", 1, "menu", "ROLE_ANONYMOUS", "#", 1, ""));
		_list.add(new Menu("9", "5", "고객등록", 0, "menu", "ROLE_ANONYMOUS", "#", 1, ""));
		_list.add(new Menu("11", "5", "고객통계", 1, "menu", "ROLE_ANONYMOUS", "#", 1, ""));
		_list.add(new Menu("14", "8", "제품등록주의", 0, "menu", "ROLE_ANONYMOUS", "#", 1, ""));
		_list.add(new Menu("12", "11", "출력", 0, "menu", "ROLE_ANONYMOUS", "#", 1, ""));
		_list.add(new Menu("13", "11", "분석", 1, "action", "ROLE_ANONYMOUS", "#", 1, ""));

		Root _menu = new Root();
		_menu.setRoot(new Menu("8", "3", "제품등록", 0, "menu", "ROLE_ANONYMOUS", "#", 1, ""));
		_menu.addAll(_list);

	}
	//메인메뉴 left 메뉴 생성
	public String buildMainMenu(String pMenu) {

		Menu _menu = getByMenuId(root,pMenu);
		
		if (_menu != null) {
			return buildMainMenu(_menu);
		}

		return "";
	}
	//메인메뉴 left 메뉴 생성
	public String buildMainMenu(Menu pMenu) {
		StringBuilder _sb = new StringBuilder();
		Iterator<Menu> _iter = pMenu.getMenus().iterator();
		int depth = pMenu.getDepth();
		if(depth ==0||depth ==1){
			_sb.append(""); 
		}else{
			_sb.append(pMenu.mainMenuBuild(depth));				
			if (pMenu.getMenus().size() > 0){
				_sb.append(UL_START);						
				}
			}
		while (_iter.hasNext()) {
				_sb.append(buildMainMenu(_iter.next()));
		}
		if(depth ==0||depth ==1){
			_sb.append(""); 
		}else{
			if (pMenu.getType().equals("menu")||pMenu.getType().equals("tab")) {
				if (pMenu.getMenus().size() > 0)
					_sb.append(UL_END);
				_sb.append(LI_END);
			}
		}
		return _sb.toString();
	}
}
