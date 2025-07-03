package weka;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;
import weka.core.Instance;
import weka.core.DenseInstance;
import weka.core.Attribute;
import weka.classifiers.functions.SimpleLinearRegression;
import weka.classifiers.evaluation.Evaluation;
import java.util.ArrayList;
import java.util.Arrays;
import java.text.DecimalFormat;
import weka.core.converters.CSVLoader;

/**
 * Sales Prediction System using Weka (Fixed - No Matrix Dependencies)
 * Uses SimpleLinearRegression instead of LinearRegression to avoid matrix dependencies
 */
public class WekaPredictor {
    
    private SimpleLinearRegression model;
    private Instances trainingData;
    private DecimalFormat df = new DecimalFormat("#,##0.00");
    
    // 2024 projected advertising costs (based on 2023 trend)
    private double[] advertisingCosts2024 = {
        1900, 2000, 2100, 1950, 1850, 1950,
        2050, 2150, 2200, 2300, 2400, 2500
    };
    
    // Month names for display
    private String[] months = {
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    };
    
    /**
     * Load and prepare the training data
     */
    public void loadData() {
        // Define attributes
        ArrayList<Attribute> attributes = new ArrayList<>();
        attributes.add(new Attribute("month"));             // index 0
        attributes.add(new Attribute("tourists"));          // index 1
        attributes.add(new Attribute("advertising_cost"));  // index 2
        attributes.add(new Attribute("revenue"));           // index 3

        trainingData = new Instances("trip_data", attributes, 0);
        trainingData.setClassIndex(3);  // revenue is the target (class) attribute

        // Manually add data (month as 1–12 for simplicity)
        double[][] data = {
            {1,  120, 1800, 8500},
            {2,  135, 1850, 9100},
            {3,  150, 1900, 9800},
            {4,  160, 1950, 10500},
            {5,  170, 2000, 11000},
            {6,  180, 2100, 11800},
            {7,  200, 2200, 12500},
            {8,  210, 2300, 13000},
            {9,  190, 2150, 12000},
            {10, 185, 2100, 11500},
            {11, 175, 2000, 10800},
            {12, 165, 1950, 10000}
        };

        for (double[] row : data) {
            Instance instance = new DenseInstance(4);
            for (int i = 0; i < 4; i++) {
                instance.setValue(i, row[i]);
            }
            instance.setDataset(trainingData);
            trainingData.add(instance);
        }

        System.out.println("✅ Data loaded from array: " + trainingData.numInstances() + " instances.");
    }


    
    /**
     * Train the regression model using SimpleLinearRegression
     */
    public void trainModel() {
        try {
            // Create a dataset with only advertising cost and revenue for simple linear regression
            Instances simpleData = createSimpleDataset();
            
            model = new SimpleLinearRegression();
            model.buildClassifier(simpleData);
            
            System.out.println("\n✓ Model trained successfully!");
            System.out.println("Model details:");
            System.out.println("Revenue = " + df.format(model.getSlope()) + " * advertising_cost + " + df.format(model.getIntercept()));
            
            // Evaluate the model
            evaluateModel(simpleData);
            
        } catch (Exception e) {
            System.err.println("Error training model: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Create a simple dataset with only advertising cost and revenue
     */
    private Instances createSimpleDataset() throws Exception {
        // Create attributes
        ArrayList<Attribute> attributes = new ArrayList<>();
        attributes.add(new Attribute("advertising_cost"));
        attributes.add(new Attribute("revenue"));
        
        // Create dataset
        Instances simpleData = new Instances("simple_regression", attributes, 0);
        simpleData.setClassIndex(1); // revenue is the class
        
        // Add instances
        for (int i = 0; i < trainingData.numInstances(); i++) {
            Instance originalInstance = trainingData.instance(i);
            double advertisingCost = originalInstance.value(2); // advertising_cost is index 2
            double revenue = originalInstance.value(3); // revenue is index 3
            
            Instance newInstance = new DenseInstance(2);
            newInstance.setValue(0, advertisingCost);
            newInstance.setValue(1, revenue);
            newInstance.setDataset(simpleData);
            
            simpleData.add(newInstance);
        }
        
        return simpleData;
    }
    
    /**
     * Evaluate the model performance
     */
    private void evaluateModel(Instances data) {
        try {
            Evaluation eval = new Evaluation(data);
            eval.evaluateModel(model, data);
            
            System.out.println("\n📊 Model Evaluation:");
            System.out.println("  - Correlation coefficient: " + df.format(eval.correlationCoefficient()));
            System.out.println("  - Mean absolute error: £" + df.format(eval.meanAbsoluteError()));
            System.out.println("  - Root mean squared error: £" + df.format(eval.rootMeanSquaredError()));
            
        } catch (Exception e) {
            System.err.println("Error evaluating model: " + e.getMessage());
        }
    }
    
    /**
     * Predict revenue for 2024 based on advertising costs
     */
    public void predictRevenue2024() {
        try {
            System.out.println("\n🔮 SALES PREDICTIONS FOR 2024");
            System.out.println("=" + "=".repeat(80));
            
            double totalPredictedRevenue = 0;
            double totalIncreasedRevenue = 0;
            
            System.out.printf("%-5s %-10s %-15s %-15s %-15s%n", 
                "Month", "Adv Cost", "Predicted Rev", "10% Inc Cost", "Inc Revenue");
            System.out.println("-".repeat(80));
            
            for (int i = 0; i < 12; i++) {
                // Predict with normal advertising cost
                double predictedRevenue = predictRevenue(advertisingCosts2024[i]);
                totalPredictedRevenue += predictedRevenue;
                
                // Predict with 10% increased advertising cost
                double increasedCost = advertisingCosts2024[i] * 1.10;
                double increasedRevenue = predictRevenue(increasedCost);
                totalIncreasedRevenue += increasedRevenue;
                
                System.out.printf("%-5s £%-9.0f £%-14.0f £%-14.0f £%-14.0f%n",
                    months[i], advertisingCosts2024[i], predictedRevenue, 
                    increasedCost, increasedRevenue);
            }
            
            // Summary
            System.out.println("-".repeat(80));
            System.out.printf("%-16s £%-14.0f £%-14.0f%n", 
                "TOTAL ANNUAL:", totalPredictedRevenue, totalIncreasedRevenue);
            
            double revenueIncrease = totalIncreasedRevenue - totalPredictedRevenue;
            double additionalAdvertising = getTotalAdvertisingCost() * 0.10;
            double roi = (revenueIncrease / additionalAdvertising) * 100;
            
            System.out.println("\n📈 BUSINESS INSIGHTS:");
            System.out.println("  • Total advertising budget 2024: £" + df.format(getTotalAdvertisingCost()));
            System.out.println("  • Predicted annual revenue: £" + df.format(totalPredictedRevenue));
            System.out.println("  • Revenue with 10% increased advertising: £" + df.format(totalIncreasedRevenue));
            System.out.println("  • Additional revenue from 10% increase: £" + df.format(revenueIncrease));
            System.out.println("  • ROI of additional advertising: " + df.format(roi) + "%");
            
            // Business recommendation
            if (roi > 100) {
                System.out.println("  ✅ RECOMMENDATION: Increase advertising budget - positive ROI!");
            } else {
                System.out.println("  ⚠️ RECOMMENDATION: Consider cost-effectiveness of increased advertising.");
            }
            
        } catch (Exception e) {
            System.err.println("Error making predictions: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Predict revenue for a given advertising cost
     */
    private double predictRevenue(double advertisingCost) throws Exception {
        // Create instance for prediction
        Instances predictionDataset = createSimpleDataset();
        Instance instance = new DenseInstance(2);
        instance.setValue(0, advertisingCost);
        instance.setDataset(predictionDataset);
        
        return model.classifyInstance(instance);
    }
    
    /**
     * Calculate total advertising cost for 2024
     */
    private double getTotalAdvertisingCost() {
        return Arrays.stream(advertisingCosts2024).sum();
    }
    
    /**
     * Display historical data analysis
     */
    public void analyzeHistoricalData() {
        System.out.println("\n📊 HISTORICAL DATA ANALYSIS (2023)");
        System.out.println("=" + "=".repeat(50));
        
        double totalAdvertising = 0;
        double totalRevenue = 0;
        
        for (int i = 0; i < trainingData.numInstances(); i++) {
            Instance instance = trainingData.instance(i);
            double advertising = instance.value(2);
            double revenue = instance.value(3);
            totalAdvertising += advertising;
            totalRevenue += revenue;
        }
        
        double avgROI = (totalRevenue / totalAdvertising) * 100;
        
        System.out.println("  • Total advertising spend 2023: £" + df.format(totalAdvertising));
        System.out.println("  • Total revenue generated 2023: £" + df.format(totalRevenue));
        System.out.println("  • Average ROI: " + df.format(avgROI) + "%");
        System.out.println("  • Revenue per £1 advertising: £" + df.format(totalRevenue / totalAdvertising));
    }
    
    /**
     * Get prediction results for web display
     */
    public java.util.Map<String, Object> getPredictionResults() {
        java.util.Map<String, Object> results = new java.util.HashMap<>();
        java.util.List<java.util.Map<String, Object>> monthlyPredictions = new java.util.ArrayList<>();
        
        try {
            double totalPredictedRevenue = 0;
            double totalIncreasedRevenue = 0;
            double totalAdvertisingCost = 0;
            
            for (int i = 0; i < 12; i++) {
                java.util.Map<String, Object> monthData = new java.util.HashMap<>();
                
                // Predict with normal advertising cost
                double predictedRevenue = predictRevenue(advertisingCosts2024[i]);
                totalPredictedRevenue += predictedRevenue;
                
                // Predict with 10% increased advertising cost
                double increasedCost = advertisingCosts2024[i] * 1.10;
                double increasedRevenue = predictRevenue(increasedCost);
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
            
        } catch (Exception e) {
            System.err.println("Error generating prediction results: " + e.getMessage());
        }
        
        return results;
    }
    
    /**
     * Main method to run the prediction system
     */
    public static void main(String[] args) {
        System.out.println("🚀 ALEX'S TRIP AGENCY - SALES PREDICTION SYSTEM");
        System.out.println("=" + "=".repeat(60));
        
        WekaPredictor predictor = new WekaPredictor();
        
        // Step 1: Load data
        predictor.loadData();
        
        // Step 2: Train model
        predictor.trainModel();
        
        // Step 3: Analyze historical data
        predictor.analyzeHistoricalData();
        
        // Step 4: Make predictions for 2024
        predictor.predictRevenue2024();
        
        System.out.println("\n✨ Analysis completed successfully!");
    }
}