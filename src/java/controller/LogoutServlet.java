package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


// Handle both /logout and /admin/logout URLs
@WebServlet(urlPatterns = {"/logout", "/admin/logout"})
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Determine redirect based on the request URL
        String requestURI = request.getRequestURI();
        if (requestURI.contains("/admin/")) {
            // Admin logout - redirect to admin login
            response.sendRedirect(request.getContextPath() + "/admin/login?message=Logged out successfully");
        } else {
            // Regular logout - redirect to main login
            response.sendRedirect(request.getContextPath() + "/login?message=Logged out successfully");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}