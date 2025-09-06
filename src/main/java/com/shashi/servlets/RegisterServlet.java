package com.shashi.servlets;


import com.shashi.DAO.UserDAO;
import com.shashi.DTO.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fullName = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        fullName = fullName.trim();
        email = email.trim();
        password = password.trim();
        confirmPassword = confirmPassword.trim();
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (password.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        try {
            UserDAO userDao = new UserDAO();
            
            if (userDao.authenticateUser(email, password) != null) {
                request.setAttribute("error", "Email already registered");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            User newUser = new User(fullName, email, null, null);
            if (userDao.registerUser(newUser, password)) {
                String sessionId = userDao.createSession(newUser.getUserId(), request.getRemoteAddr());
                Cookie sessionCookie = new Cookie("sessionId", sessionId);
                sessionCookie.setMaxAge(60 * 60);
                response.addCookie(sessionCookie);
                response.sendRedirect("userdashboard.jsp");
                return;
            } else {
                request.setAttribute("error", "Registration failed");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Successful!!!");
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}