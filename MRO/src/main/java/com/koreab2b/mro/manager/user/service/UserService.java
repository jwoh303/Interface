package com.koreab2b.mro.manager.user.service;

import java.util.List;

import com.koreab2b.mro.manager.user.domain.User;

public interface UserService {
	List<User> getUsers(User pUser);

	User getUser(String pUserId);

	void saveUser(User pUser);

	void deleteUser(String[] pUserIds);
}
