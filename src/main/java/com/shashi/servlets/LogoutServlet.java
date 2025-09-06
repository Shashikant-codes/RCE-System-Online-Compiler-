package com.shashi.servlets;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Invalidate session
        Cookie sessionCookie = new Cookie("sessionId", "");
        sessionCookie.setMaxAge(0);
        response.addCookie(sessionCookie);
        
        response.sendRedirect("login.jsp");
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}