package com.koreab2b.mro.manager.user.dao;

import java.util.List;

import com.koreab2b.mro.manager.user.domain.User;

public interface UserDao {
	List<User> selectUsers(User pUser);

	User selectUserByUserId(String pUserId);

	void insertUser(User pUser);

	void updateUser(User pUser);

	void deleteUser(String pUserId);
}
