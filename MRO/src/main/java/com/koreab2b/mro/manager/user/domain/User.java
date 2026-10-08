package com.koreab2b.mro.manager.user.domain;

import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("serial")
public class User extends Page {
	private String userId;
	private String userNm;
	private String password;
	private String userActive;
	private String createDt;
	private String authors;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String pUserId) {
		userId = pUserId;
	}

	public String getUserNm() {
		return userNm;
	}

	public void setUserNm(String pUserNm) {
		userNm = pUserNm;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String pPassword) {
		password = pPassword;
	}

	public String getUserActive() {
		return userActive;
	}

	public void setUserActive(String pUserActive) {
		userActive = pUserActive;
	}

	public String getCreateDt() {
		return createDt;
	}

	public void setCreateDt(String pCreateDt) {
		createDt = pCreateDt;
	}

	public String getAuthors() {
		return authors;
	}

	public void setAuthors(String pAuthors) {
		authors = pAuthors;
	}

	public List<UserAuth> getUserAuthors() {
		List<UserAuth> _userAuthors = new ArrayList<UserAuth>();
		String[] _authors = authors.split(",");

		for (String _tmp : _authors) {
			UserAuth _userAuthor = new UserAuth(userId, _tmp);
			_userAuthors.add(_userAuthor);
		}

		return _userAuthors;
	}

	public void setUserAuthors(List<UserAuth> pUserAuthors) {
		StringBuilder _sb = new StringBuilder();
		
		for (UserAuth _tmp : pUserAuthors) {
			_sb.append(_tmp.getAuthId()).append(",");
		}
		
		authors = _sb.toString();
	}

}
