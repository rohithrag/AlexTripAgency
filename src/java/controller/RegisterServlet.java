package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import util.ValidationUtil;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        
        List<String> errors = validateRegistration(username, email, password, confirmPassword, fullName);
        
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        try {
            // Check if username already exists
            if (userDAO.usernameExists(username)) {
                errors.add("Username already exists");
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Check if email already exists
            if (userDAO.emailExists(email)) {
                errors.add("Email already exists");
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Create new user
            User user = new User(username, password, email, "USER");
            user.setFullName(fullName);
            user.setPhone(phone);
            
            boolean success = userDAO.createUser(user);
            
            if (success) {
                request.setAttribute("success", "Registration successful! Please login to continue.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Database error occurred");
        }
    }
    
    private List<String> validateRegistration(String username, String email, String password, 
                                            String confirmPassword, String fullName) {
        List<String> errors = new ArrayList<>();
        
        if (username == null || username.trim().isEmpty()) {
            errors.add("Username is required");
        } else if (username.length() < 3) {
            errors.add("Username must be at least 3 characters long");
        }
        
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.add("Full name is required");
        }
        
        if (email == null || email.trim().isEmpty()) {
            errors.add("Email is required");
        } else if (!ValidationUtil.isValidEmail(email)) {
            errors.add("Please enter a valid email address");
        }
        
        if (password == null || password.trim().isEmpty()) {
            errors.add("Password is required");
        } else if (password.length() < 6) {
            errors.add("Password must be at least 6 characters long");
        }
        
        if (confirmPassword == null || !confirmPassword.equals(password)) {
            errors.add("Passwords do not match");
        }
        
        return errors;
    }
}