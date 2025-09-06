package com.shashi.servlets;


import com.shashi.DAO.UserDAO;
import com.shashi.DTO.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        email = email.trim();
        password = password.trim();
        
        try {
            UserDAO userDao = new UserDAO();
            User user = userDao.authenticateUser(email, password);
            
            if (user != null) {
                String sessionId = userDao.createSession(user.getUserId(), request.getRemoteAddr());
                Cookie sessionCookie = new Cookie("sessionId", sessionId);
                sessionCookie.setMaxAge(60 * 60);
                response.addCookie(sessionCookie);
                response.sendRedirect("userdashboard.jsp");
                return;
            } else {
                request.setAttribute("error", "Invalid email or password");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error occurred");
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}