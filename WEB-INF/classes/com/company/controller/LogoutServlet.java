package com.company.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션 가져오기
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 세션 무효화
            session.invalidate();
        }
        
        // 로그인 페이지로 리다이렉트
        response.sendRedirect("login.jsp");
    }
}