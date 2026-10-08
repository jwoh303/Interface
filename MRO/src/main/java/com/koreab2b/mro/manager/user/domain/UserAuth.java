package com.koreab2b.mro.manager.user.domain;

import java.io.Serializable;

@SuppressWarnings("serial")
public class UserAuth implements Serializable {

	private String userId;
	private String authId;

	public UserAuth() {
	}

	public UserAuth(String pUserID, String pAuthId) {
		userId = pUserID;
		authId = pAuthId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String pUserId) {
		userId = pUserId;
	}

	public String getAuthId() {
		return authId;
	}

	public void setAuthId(String pAuthId) {
		authId = pAuthId;
	}

}
