// File: web/js/main.js

// Global JavaScript functionality for Trip Agency Management System

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeTooltips();
    initializeFormValidation();
    initializeImagePreview();
    handleSearchForm();
});

// Initialize Bootstrap tooltips
function initializeTooltips() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

// Form validation enhancements
function initializeFormValidation() {
    const forms = document.querySelectorAll('.needs-validation');
    
    Array.prototype.slice.call(forms).forEach(function(form) {
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
    
    // Email validation
    const emailInputs = document.querySelectorAll('input[type="email"]');
    emailInputs.forEach(function(input) {
        input.addEventListener('blur', function() {
            validateEmail(this);
        });
    });
    
    // Phone validation
    const phoneInputs = document.querySelectorAll('input[type="tel"]');
    phoneInputs.forEach(function(input) {
        input.addEventListener('blur', function() {
            validatePhone(this);
        });
    });
}

// Email validation function
function validateEmail(input) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const isValid = emailRegex.test(input.value);
    
    if (input.value && !isValid) {
        input.setCustomValidity('Please enter a valid email address');
        input.classList.add('is-invalid');
    } else {
        input.setCustomValidity('');
        input.classList.remove('is-invalid');
        if (input.value) {
            input.classList.add('is-valid');
        }
    }
}

// Phone validation function
function validatePhone(input) {
    const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/;
    const cleanPhone = input.value.replace(/[\s\-\(\)]/g, '');
    const isValid = phoneRegex.test(cleanPhone) && cleanPhone.length >= 10;
    
    if (input.value && !isValid) {
        input.setCustomValidity('Please enter a valid phone number');
        input.classList.add('is-invalid');
    } else {
        input.setCustomValidity('');
        input.classList.remove('is-invalid');
        if (input.value) {
            input.classList.add('is-valid');
        }
    }
}

// Image preview functionality
function initializeImagePreview() {
    const imageUrlInputs = document.querySelectorAll('input[name="imageUrl"]');
    
    imageUrlInputs.forEach(function(input) {
        input.addEventListener('input', function() {
            previewImage(this);
        });
    });
}

function previewImage(input) {
    const url = input.value;
    const previewContainer = document.getElementById('imagePreview');
    
    if (previewContainer && url) {
        const img = new Image();
        img.onload = function() {
            previewContainer.innerHTML = `<img src="${url}" class="img-fluid rounded" style="max-height: 200px;">`;
        };
        img.onerror = function() {
            previewContainer.innerHTML = `<div class="alert alert-warning">Invalid image URL</div>`;
        };
        img.src = url;
    }
}

// Search form enhancements
function handleSearchForm() {
    const searchForm = document.querySelector('form[action*="trips"]');
    if (searchForm) {
        // Auto-submit on filter change
        const filterInputs = searchForm.querySelectorAll('select, input[type="number"]');
        filterInputs.forEach(function(input) {
            input.addEventListener('change', function() {
                if (this.dataset.autoSubmit !== 'false') {
                    searchForm.submit();
                }
            });
        });
        
        // Clear filters functionality
        const clearButton = document.getElementById('clearFilters');
        if (clearButton) {
            clearButton.addEventListener('click', function() {
                filterInputs.forEach(function(input) {
                    input.value = '';
                });
                searchForm.submit();
            });
        }
    }
}

// Price formatting
function formatPrice(amount) {
    return new Intl.NumberFormat('en-GB', {
        style: 'currency',
        currency: 'GBP'
    }).format(amount);
}

// Date formatting
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-GB', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
}

// Loading states
function showLoading(element) {
    element.classList.add('loading');
    element.disabled = true;
}

function hideLoading(element) {
    element.classList.remove('loading');
    element.disabled = false;
}

// Alert helpers
function showAlert(message, type = 'info', container = null) {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    if (container) {
        container.insertBefore(alertDiv, container.firstChild);
    } else {
        document.body.insertBefore(alertDiv, document.body.firstChild);
    }
    
    // Auto-dismiss after 5 seconds
    setTimeout(function() {
        alertDiv.remove();
    }, 5000);
}

// Booking form enhancements
if (document.getElementById('bookingForm')) {
    initializeBookingForm();
}

function initializeBookingForm() {
    const participantsSelect = document.getElementById('participants');
    const bookingDateInput = document.getElementById('bookingDate');
    
    // Set minimum booking date to today
    if (bookingDateInput) {
        const today = new Date().toISOString().split('T')[0];
        bookingDateInput.min = today;
    }
    
    // Validate booking date against trip dates
    if (bookingDateInput) {
        bookingDateInput.addEventListener('change', function() {
            validateBookingDate(this);
        });
    }
}

function validateBookingDate(input) {
    const selectedDate = new Date(input.value);
    const today = new Date();
    
    if (selectedDate < today) {
        input.setCustomValidity('Booking date cannot be in the past');
        input.classList.add('is-invalid');
    } else {
        input.setCustomValidity('');
        input.classList.remove('is-invalid');
        input.classList.add('is-valid');
    }
}

// Admin dashboard functionality
if (document.querySelector('.sidebar')) {
    initializeAdminDashboard();
}

function initializeAdminDashboard() {
    // Highlight current page in sidebar
    const currentPath = window.location.pathname;
    const sidebarLinks = document.querySelectorAll('.sidebar .nav-link');
    
    sidebarLinks.forEach(function(link) {
        if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
            link.classList.add('active');
        }
    });
    
    // Auto-refresh dashboard stats every 5 minutes
    if (document.getElementById('totalTrips')) {
        setInterval(refreshDashboardStats, 300000); // 5 minutes
    }
}

function refreshDashboardStats() {
    // In a real application, this would make AJAX calls to get updated stats
    console.log('Refreshing dashboard stats...');
}

// Utility functions
const Utils = {
    // Debounce function
    debounce: function(func, wait, immediate) {
        let timeout;
        return function executedFunction() {
            const context = this;
            const args = arguments;
            const later = function() {
                timeout = null;
                if (!immediate) func.apply(context, args);
            };
            const callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
            if (callNow) func.apply(context, args);
        };
    },
    
    // Storage helpers
    setStorage: function(key, value) {
        try {
            localStorage.setItem(key, JSON.stringify(value));
        } catch (e) {
            console.warn('localStorage not available');
        }
    },
    
    getStorage: function(key) {
        try {
            const item = localStorage.getItem(key);
            return item ? JSON.parse(item) : null;
        } catch (e) {
            console.warn('localStorage not available');
            return null;
        }
    },
    
    // AJAX helper
    ajax: function(url, options = {}) {
        const defaults = {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        };
        
        const config = Object.assign(defaults, options);
        
        return fetch(url, config)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .catch(error => {
                console.error('AJAX error:', error);
                throw error;
            });
    }
};

// Export for module use
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        Utils,
        formatPrice,
        formatDate,
        showAlert
    };
}