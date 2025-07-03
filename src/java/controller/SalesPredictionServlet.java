package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import weka.WekaPredictor;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/admin/sales-prediction")
public class SalesPredictionServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authentication
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            // First try to create a simple prediction if Weka fails
            Map<String, Object> predictionResults = null;
            String errorMessage = null;
            
            try {
                // Try Weka prediction
                WekaPredictor predictor = new WekaPredictor();
                
                // Load data and train model
                predictor.loadData();
                predictor.trainModel();
                
                // Get predictions for display
                predictionResults = predictor.getPredictionResults();
                
                System.out.println("✓ Weka prediction completed successfully!");
                
            } catch (Exception wekaError) {
                System.err.println("Weka prediction failed: " + wekaError.getMessage());
                wekaError.printStackTrace();
                
                // Fallback to simple prediction
                predictionResults = generateSimplePrediction();
                errorMessage = "Using simplified prediction model (Weka library issue: " + wekaError.getMessage() + ")";
            }
            
            // Set attributes for JSP
            request.setAttribute("predictionResults", predictionResults);
            request.setAttribute("pageTitle", "Sales Prediction Analysis");
            if (errorMessage != null) {
                request.setAttribute("warning", errorMessage);
            }
            
            // Forward to JSP
            request.getRequestDispatcher("/admin/sales-prediction.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error generating sales predictions: " + e.getMessage());
            request.getRequestDispatcher("/admin/sales-prediction.jsp").forward(request, response);
        }
    }
    
    /**
     * Generate simple prediction without Weka as fallback
     */
    private Map<String, Object> generateSimplePrediction() {
        Map<String, Object> results = new HashMap<>();
        List<Map<String, Object>> monthlyPredictions = new ArrayList<>();
        
        // Simple linear relationship: Revenue ≈ 3.8 * Advertising Cost + 1500
        double slope = 3.8;
        double intercept = 1500.0;
        
        // 2024 projected advertising costs
        double[] advertisingCosts2024 = {
            1900, 2000, 2100, 1950, 1850, 1950,
            2050, 2150, 2200, 2300, 2400, 2500
        };
        
        String[] months = {
            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        };
        
        double totalPredictedRevenue = 0;
        double totalIncreasedRevenue = 0;
        double totalAdvertisingCost = 0;
        
        for (int i = 0; i < 12; i++) {
            Map<String, Object> monthData = new HashMap<>();
            
            // Simple prediction: Revenue = slope * advertising + intercept
            double predictedRevenue = slope * advertisingCosts2024[i] + intercept;
            totalPredictedRevenue += predictedRevenue;
            
            // 10% increased advertising cost
            double increasedCost = advertisingCosts2024[i] * 1.10;
            double increasedRevenue = slope * increasedCost + intercept;
            totalIncreasedRevenue += increasedRevenue;
            
            totalAdvertisingCost += advertisingCosts2024[i];
            
            monthData.put("month", months[i]);
            monthData.put("advertisingCost", advertisingCosts2024[i]);
            monthData.put("predictedRevenue", predictedRevenue);
            monthData.put("increasedCost", increasedCost);
            monthData.put("increasedRevenue", increasedRevenue);
            
            monthlyPredictions.add(monthData);
        }
        
        // Calculate summary metrics
        double revenueIncrease = totalIncreasedRevenue - totalPredictedRevenue;
        double additionalAdvertising = totalAdvertisingCost * 0.10;
        double roi = (revenueIncrease / additionalAdvertising) * 100;
        
        results.put("monthlyPredictions", monthlyPredictions);
        results.put("totalPredictedRevenue", totalPredictedRevenue);
        results.put("totalIncreasedRevenue", totalIncreasedRevenue);
        results.put("totalAdvertisingCost", totalAdvertisingCost);
        results.put("revenueIncrease", revenueIncrease);
        results.put("roi", roi);
        results.put("recommendation", roi > 100 ? "Increase advertising budget - positive ROI!" : 
                                               "Consider cost-effectiveness of increased advertising.");
        
        System.out.println("✓ Simple prediction model generated successfully!");
        
        return results;
    }
}