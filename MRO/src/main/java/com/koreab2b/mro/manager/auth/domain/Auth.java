package com.koreab2b.mro.manager.auth.domain;

import java.io.Serializable;

@SuppressWarnings("serial")
public class Auth implements Serializable {

	private String authId;
	private String name;
	private String authDc;
	private String createDt;

	public String getAuthId() {
		return authId;
	}

	public void setAuthId(String pAuthId) {
		authId = pAuthId;
	}

	public String getName() {
		return name;
	}

	public void setName(String pName) {
		name = pName;
	}

	public String getAuthDc() {
		return authDc;
	}

	public void setAuthDc(String pAuthDc) {
		authDc = pAuthDc;
	}

	public String getCreateDt() {
		return createDt;
	}

	public void setCreateDt(String pCreateDt) {
		createDt = pCreateDt;
	}

}
